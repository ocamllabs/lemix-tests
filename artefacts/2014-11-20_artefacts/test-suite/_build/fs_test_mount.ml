open Printf
open Fs_test_system

type fs =
| Tmpfs
| Ext2_loop
| Ext3_loop
| Ext4_loop
| Btrfs_loop
| Fusexmp of fs
| Sshfs of fs
| Ntfs3g_loop
| Hfsplus_loop
| Ufs2_loop
| Zfs_loop

type fs_version =
| Function of fs_version * fs_version
| Fuse of string * string
| Version of string
| System

type params = {
  mnt_path : string;
  size     : int64;
  system   : t; (* System.t *)
}

type t = {
  fs            : fs;
  params        : params;
  mnt           : string;
  subdir        : string option;
  mutable users : int;
}

let exec_path = Unix.getcwd ()
let cmd_path = Filename.dirname Sys.argv.(0)
let cmd_path = Filename.(
  if is_relative cmd_path then concat exec_path cmd_path else cmd_path
)

let sector_size = 512_L
let sector_count sz = Int64.(div sz sector_size)
let blk_size = 4096_L
let blk_count sz = Int64.(div sz blk_size)
let blk_overhead = 512_L
let subfs_blk_count sz = Int64.(sub (blk_count sz) blk_overhead)

let memo_query fn =
  let q = Lazy.from_fun fn in
  fun () -> Lazy.force q

let tmpfs_if_available = function
  | Darwin ->
    printf "tmpfs not available on Darwin/OS X; skipping tmpfs\n%!";
    []
  | Linux | FreeBSD -> [Tmpfs, System]

let ext_version = memo_query (fun () ->
  Version (List.hd (read_command_err "mke2fs -V"))
)

let extfs_if_available () =
  try
    let ext_version = ext_version () in
    [
      Ext2_loop, ext_version;
      Ext3_loop, ext_version;
      Ext4_loop, ext_version;
    ]
  with Command_failure (_,_,_) ->
    printf "mke2fs not found; skipping ext2, ext3, ext4\n%!";
    []

let btrfs_version = memo_query (fun () ->
  Version (List.hd (read_command_err "mkfs.btrfs --version"))
)

let btrfs_if_available () =
  try
    let btrfs_version = btrfs_version () in
    [ Btrfs_loop, btrfs_version ]
  with Command_failure (_,_,_) ->
    printf "mkfs.btrfs not found; skipping btrfs\n%!";
    []

let fuse_version system = memo_query (fun () ->
  match system with
  | Linux  -> List.hd (read_command "fusermount --version")
  | Darwin ->
    List.hd (read_command_err ~exit_code:64
               "/Library/Filesystems/osxfusefs.fs/Support/mount_osxfusefs")
  | FreeBSD -> List.hd (read_command ~exit_code:64 "mount_fusefs --version")
)

let fusexmp_version system = memo_query (fun () ->
  match system with
  | Linux | Darwin -> fuse_version system ()
  | FreeBSD -> String.concat "\n"
    (read_command_err ~exit_code:1 "fusexmp_fh --version")
)

let sshfs_version = memo_query (fun () ->
  String.concat "\n" (read_command "sshfs --version")
)

let ntfs3g_version = memo_query (fun () ->
  List.hd (read_command_err "ntfs-3g --version")
)

let hfsplus_version system = memo_query (fun () ->
  match system with Darwin -> System
  | Linux ->
    let command = "dpkg -s hfsprogs | grep Version" in
    let version_line = List.hd (read_command command) in
    let line_length = String.length version_line in
    let version_lbl = "Version: " in
    let lbl_length = String.length version_lbl in
    if String.sub version_line 0 lbl_length = version_lbl
    then Version (String.sub version_line lbl_length (line_length - lbl_length))
    else (printf "Can't read \"%s\": got \"%s\". Aborting.\n"
            command version_line;
          raise Not_found)
  | FreeBSD -> raise Not_found 
)

let hfsplus_if_available system =
  try
    let hfsplus_version = hfsplus_version system () in
    [ Hfsplus_loop, hfsplus_version ]
  with Not_found | Command_failure (_,_,_) ->
    printf "HFS+ support not found; skipping hfsplus\n%!";
    []

let ufs2_if_available = function
  | FreeBSD -> [ Ufs2_loop, System ]
  | (Linux | Darwin) as s ->
    printf "ufs2 not available on %s; skipping ufs2\n%!" (to_string s);
    []

let zfs_version = memo_query (fun () ->
  let zfs = String.concat "\n" (read_command "zfs upgrade -v") in
  let zpool = String.concat "\n" (read_command "zpool upgrade -v") in
  Version (sprintf "zfs:\n%s\n\nzpool:\n%s\n" zfs zpool)
)

let zfs_if_available () = match get_system () with
  | FreeBSD | Linux | Darwin -> [ Zfs_loop, zfs_version () ]

let rec version_of_fs system = function
  | Tmpfs -> System
  | Ext2_loop | Ext3_loop | Ext4_loop -> ext_version ()
  | Btrfs_loop -> btrfs_version ()
  | Fusexmp subfs ->
    Function (version_of_fs system subfs,
              Fuse (fuse_version system (), fusexmp_version system ()))
  | Sshfs subfs ->
    Function (version_of_fs system subfs,
              Fuse (fuse_version system (), sshfs_version ()))
  | Ntfs3g_loop -> Fuse (fuse_version system (), ntfs3g_version ())
  | Hfsplus_loop -> hfsplus_version system ()
  | Ufs2_loop -> System
  | Zfs_loop -> zfs_version ()

let rec string_of_version = function
  | System -> "system"
  | Function (dom, cod) ->
    (string_of_version cod)^" over "^(string_of_version dom)
  | Fuse (fusev, fsv) -> fsv^" fuse "^fusev
  | Version v -> v

let rec name_of_fs = function
  | Tmpfs        -> "tmpfs"
  | Ext2_loop    -> "ext2_loop"
  | Ext3_loop    -> "ext3_loop"
  | Ext4_loop    -> "ext4_loop"
  | Btrfs_loop   -> "btrfs_loop"
  | Fusexmp fs   -> "fusexmp_"^(name_of_fs fs)
  | Sshfs fs     -> "sshfs_"^(name_of_fs fs)
  | Ntfs3g_loop  -> "ntfs3g_loop"
  | Hfsplus_loop -> "hfsplus_loop"
  | Ufs2_loop    -> "ufs2_loop"
  | Zfs_loop     -> "zfs_loop"

let basic_fs = function
  | Darwin -> Hfsplus_loop
  | Linux | FreeBSD -> Tmpfs

let local_target system fs = fs, version_of_fs system fs

(* END OF SIMPLE FUNCTIONS AND QUERIES *)

(* BEGIN STATEFUL FUNCTIONS *)

let destroy_funs = Hashtbl.create 16
let dtor_stack = ref []

let destroy ?(force=false) env () =
  env.users <- env.users - 1;
  if not force && env.users > 0 then ()
  else begin
    let users = env.users in
    env.users <- 0;
    List.iter (fun destroy ->
      Hashtbl.remove destroy_funs env;
      destroy ()
    ) (Hashtbl.find_all destroy_funs env);
    env.users <- users
  end

let add_destructor env dtor =
  let users = env.users in
  env.users <- 0;
  Hashtbl.add destroy_funs env dtor;
  dtor_stack := env::(!dtor_stack);
  env.users <- users

let destroy_world () =
  kill_children ();
  let errors = List.fold_left (fun errors env ->
    try (destroy ~force:true env (); errors)
    with Command_failure (_,_,_) | Unix.Unix_error (_,_,_) -> errors + 1
  ) 0 !dtor_stack
  in
  eprintf "%d errors encountered unloading filesystems.\n%!" errors

let destroy_mount dir () =
  let mnt_path = Filename.dirname dir in
  Unix.chdir mnt_path; (* don't want to be in dir when unmounting *)
  continue "umount" [|dir|];
  Unix.rmdir dir

let init_fuse = function Linux | Darwin -> ()
  | FreeBSD -> continue "kldload" [|"-n"; "fuse"|]

let load_fs ?subdir ?(destroy=true) params fs mount_fun =
  let mnt = Filename.concat params.mnt_path (name_of_fs fs) in
  continue "mkdir" [|"-p"; mnt|];
  let env = { fs; params; users = 1; mnt; subdir } in
  (try mount_fun env
   with e -> Unix.rmdir mnt; raise e);
  if destroy then add_destructor env (destroy_mount mnt);
  env

let mount_tmpfs size env =
  continue "mount"
    [|"-t"; "tmpfs"; "-o"; "size="^(Int64.to_string size); "tmpfs"; env.mnt|]

let load_tmpfs params fs = load_fs params fs (mount_tmpfs params.size)

let loop file =
  continue "losetup" [|"-f"; file|];
  let status = List.hd (read_command ("losetup -j "^file)) in
  String.sub status 0 (String.index status ':')
let rec unloop dev = exit_command "losetup" [|"-d"; dev|] () (function
  | 0 -> Some ()
  | 1 as x ->
    (* TODO: investigate the root cause and report it *)
    eprintf "Loop race error: losetup -d %s failed with %d; retrying.\n%!"
      dev x;
    Some (unloop dev)
  | _ -> None
)

let make_tmploopdisk env format_fun =
  let name = name_of_fs env.fs in
  let mnt = Filename.concat env.params.mnt_path (name^"_tmp") in
  continue "mkdir" [|"-p"; mnt|]; (* TODO: clean? *)
  let img = Filename.concat mnt (name^".img") in
  mount_tmpfs env.params.size { env with mnt };
  add_destructor env (destroy_mount mnt);
  continue "dd"
    [|"if=/dev/zero"; "of="^img; "bs=4k";
      "count="^(Int64.to_string (subfs_blk_count env.params.size))|];
  let loopdev = loop img in
  (try format_fun loopdev
   with e -> unloop loopdev; raise e);
  unloop loopdev;
  img

let make_md env =
  let sectors = sector_count env.params.size in
  let devno = List.hd (
    read_command ("mdconfig -n -s "^(Int64.to_string sectors))
  ) in
  add_destructor env (fun () -> continue "mdconfig" [|"-d"; "-u"; devno|]);
  let dev = "/dev/md"^devno in
  dev

let make_ramdisk env =
  let sectors = sector_count env.params.size in
  let dev = List.hd (
    read_command ("hdiutil attach -nomount ram://"^(Int64.to_string sectors))
  ) in
  let dev = String.(sub dev 0 (index dev ' ')) in
  add_destructor env (fun () -> continue "hdiutil" [|"detach"; dev|]);
  dev

let load_ext_loop params typ fs = load_fs params fs (fun env ->
  let img = make_tmploopdisk env (fun dev ->
    continue "mke2fs"
      [|"-t"; typ; "-T"; "small";
        "-b"; Int64.to_string blk_size;
        dev; Int64.to_string (subfs_blk_count params.size);
      |]
  ) in
  continue "mount" [|"-t"; typ; "-o"; "loop"; img; env.mnt|]
)

let load_btrfs_loop params fs = load_fs params fs (fun env ->
  let img = make_tmploopdisk env (fun dev ->
    continue "mkfs.btrfs" [|dev|]
  ) in
  continue "mount" [|"-t"; "btrfs"; "-o"; "loop"; img; env.mnt|]
)

let load_ntfs3g_loop params fs = load_fs params fs (fun env ->
  init_fuse params.system;
  match params.system with
  | Linux ->
    let img = make_tmploopdisk env (fun dev ->
      continue "mkntfs" [|"-Q"; dev|]
    ) in
    continue "ntfs-3g" [|img; env.mnt|]
  | FreeBSD ->
    let dev = make_md env in
    (* FreeBSD doesn't have block devices so force onto a char device *)
    continue "mkntfs" [|"-FQ"; dev|];
    continue "ntfs-3g" [|dev; env.mnt|]
  | Darwin ->
    let dev = make_ramdisk env in
    continue "/usr/local/sbin/mkntfs" [|"-Q"; dev|];
    continue "ntfs-3g" [|dev; env.mnt|]
)

let load_hfsplus_loop params fs = load_fs params fs (fun env ->
  match params.system with
  | Linux | FreeBSD ->
    let img = make_tmploopdisk env (fun dev ->
      continue "mkfs.hfsplus" [|dev|]
    ) in
    continue "modprobe" [|"hfsplus"|];
    add_destructor env (fun () -> continue "modprobe" [|"-r"; "hfsplus"|]);
    continue "mount" [|"-t"; "hfsplus"; "-o"; "loop"; img; env.mnt|]
  | Darwin ->
    let name = name_of_fs fs in
    let dev = make_ramdisk env in
    continue "diskutil" [|"erasevolume"; "hfsx"; name; dev|];
    (* diskutil automatically mounted our new fs *)
    continue "diskutil" [|"unmountdisk"; dev|];
    continue "hdiutil" [|"attach"; "-mountpoint"; env.mnt; dev|]
)

let load_ufs2_loop params fs = load_fs params fs (fun env ->
  let dev = make_md env in
  continue "newfs" [|"-O"; "2"; dev|];
  continue "mount" [|"-t"; "ufs"; dev; env.mnt|]
)

let load_zfs_loop params fs = load_fs ~destroy:false params fs (fun env ->
  let dev = make_md env in
  let pool = name_of_fs Zfs_loop in
  continue "zpool" [|"create"; "-m"; env.mnt; pool; dev|];
  add_destructor env (fun () ->
    continue "zpool" [|"destroy"; pool|];
    Unix.chdir params.mnt_path;
    Unix.rmdir env.mnt
  )
)

let envs = Hashtbl.create 16

let rec load params fs =
  try let env = Hashtbl.find envs fs in
      env.users <- env.users + 1;
      env
  with Not_found ->
    let env = match fs with
      | Tmpfs      -> load_tmpfs params fs
      | Ext2_loop  -> load_ext_loop params "ext2" fs
      | Ext3_loop  -> load_ext_loop params "ext3" fs
      | Ext4_loop  -> load_ext_loop params "ext4" fs
      | Btrfs_loop -> load_btrfs_loop params fs
      | Fusexmp subfs -> load_fusexmp params subfs fs
      | Sshfs subfs   -> load_sshfs params subfs fs
      | Ntfs3g_loop   -> load_ntfs3g_loop params fs
      | Hfsplus_loop  -> load_hfsplus_loop params fs
      | Ufs2_loop     -> load_ufs2_loop params fs
      | Zfs_loop      -> load_zfs_loop params fs
    in
    Hashtbl.replace envs fs env;
    add_destructor env (fun () -> Hashtbl.remove envs fs);
    env
and load_fusexmp params subfs fs =
  let subname = name_of_fs subfs in
  let subdir = Filename.concat params.mnt_path subname in
  load_fs ~subdir params fs (fun env ->
    let subenv = load params subfs in
    add_destructor env (destroy subenv);
    init_fuse params.system;
    match params.system with
    | Linux ->
      continue (Filename.concat cmd_path "fusexmp") [|env.mnt|]
    | FreeBSD ->
      continue "fusexmp_fh" [|env.mnt; "-oallow_other"|]
    | Darwin ->
      continue "./loopback"
        [|env.mnt; "-omodules=threadid"; "-oallow_other,native_xattr"|]
  )
and load_sshfs params subfs fs = load_fs params fs (fun env ->
  let subenv = load params subfs in
  add_destructor env (destroy subenv);
  init_fuse params.system;
  continue "sshfs" [|"root@localhost:"^subenv.mnt; env.mnt|]
)

(* END STATEFUL FUNCTIONS *)

let set_signals_destroy_world signals =
  let sigh = Sys.Signal_handle (fun signal ->
    ignore Unix.(sigprocmask SIG_BLOCK signals);
    eprintf "%d caught %s; unloading filesystems.\n%!"
      (Unix.getpid ()) (string_of_signal signal);
    destroy_world ();
    exit 1
  ) in
  List.iter (fun signal -> Sys.set_signal signal sigh) signals
