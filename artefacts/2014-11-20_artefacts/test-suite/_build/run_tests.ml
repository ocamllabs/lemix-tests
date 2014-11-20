open Printf
module System = Fs_test_system
module Mount = Fs_test_mount
module Cli = Fs_test_cli

(*
check already mounted

kernel:
openbsd ?
sunos ?

libc:
eglibc ?
glibc ?
musl ?
dietlibc ?
bionic ?

filesystem:
ZFS (on Linux and OS X)
NFS3 ?
aufs ?
overlayfs ?
unionfs ?
*)

type suite = {
  path : string;
  nick : string;
}

type run = {
  env     : Mount.t;
  suite   : suite;
  trace   : string;
  process : System.process;
  run_dir : string;
  out_buf : Buffer.t;
  err_buf : Buffer.t;
}

type error =
| Invalid_suite of suite
| Missing_suite of string
| Missing_trace of suite list * string
| Unknown_fs of string
exception Invocation_error of error

let signals = Sys.([sigterm; sigint])
let () = Mount.set_signals_destroy_world signals

let fs_size = System.megs 512

let system = System.get_system ()

let exec_path = Unix.getcwd ()
let cmd_path = Filename.dirname Sys.argv.(0)
let cmd_path = Filename.(
  if is_relative cmd_path then concat exec_path cmd_path else cmd_path
)
let mnt_path = Filename.concat exec_path "mnt"
let bin_path = Filename.(concat (concat cmd_path "..") "fs_test")
let out_base_path = exec_path

let params = { Mount.size = fs_size; system; mnt_path }

let pid_idx = Hashtbl.create 16
let fd_idx  = Hashtbl.create 32

let string_of_run ({ env; suite; trace }) =
  sprintf "%s:%s:%s" Mount.(name_of_fs env.fs) suite.nick trace

let output_file trace typ = sprintf "run_%s.%s" (Filename.basename trace) typ

let wait_read wait_flags pid =
  match System.waitpid wait_flags pid with
  | 0, _ -> ()
  | pid, status ->
    let run = Hashtbl.find pid_idx pid in
    Mount.destroy run.env ();
    begin match status with
    | Unix.WEXITED 0 ->
      printf "%s SUCCESS\n%!" (string_of_run run);
      Buffer.clear run.out_buf;
      Buffer.clear run.err_buf;
      Hashtbl.remove fd_idx run.process.System.stdout;
      Hashtbl.remove fd_idx run.process.System.stderr
    | status ->
      let run_str = string_of_run run in
      let results = Filename.concat run.run_dir "results" in
      printf "%s FAILURE: %s\n" run_str (System.string_of_status status);
      let out_drain = System.(drain_into_buf run.process.stdout run.out_buf) in
      Hashtbl.remove fd_idx run.process.System.stdout;
      let out_sz = Buffer.length run.out_buf in
      let out_file = output_file run.trace "stdout" in
      let out_file = Filename.concat results out_file in
      let oc = open_out out_file in
      Buffer.output_buffer oc run.out_buf;
      close_out oc;
      printf "%s STDOUT: %d bytes (%d drained) in %s\n"
        run_str out_sz out_drain out_file;
      Buffer.clear run.out_buf;
      let err_drain = System.(drain_into_buf run.process.stderr run.err_buf) in
      Hashtbl.remove fd_idx run.process.System.stderr;
      let err_sz = Buffer.length run.err_buf in
      let err_file = output_file run.trace "stderr" in
      let err_file = Filename.concat results err_file in
      let oc = open_out err_file in
      Buffer.output_buffer oc run.err_buf;
      close_out oc;
      printf "%s STDERR: %d bytes (%d drained) in %s\n%!"
        run_str err_sz err_drain err_file;
      Buffer.clear run.err_buf
    end;
    Hashtbl.remove pid_idx pid

let drain_children () =
  eprintf "%d live children receiving SIGTERM\n%!" (Hashtbl.length pid_idx);
  let pids = Hashtbl.fold (fun pid _ pids -> pid::pids) pid_idx [] in
  List.iter (fun pid -> Unix.kill pid Sys.sigterm) pids;
  List.iter (fun pid ->
    wait_read Unix.([WUNTRACED]) pid;
    eprintf "Child pid %d drained\n%!" pid;
  ) pids

let () =
  let sigh = Hashtbl.create 4 in
  List.iter (fun signal_ ->
    Hashtbl.replace sigh signal_ Sys.(
      signal signal_ (Signal_handle (fun signal ->
        ignore Unix.(sigprocmask SIG_BLOCK signals);
        eprintf "%d caught %s; draining children.\n%!"
          (Unix.getpid ()) (System.string_of_signal signal);
        drain_children ();
        try (match Hashtbl.find sigh signal_ with
        | Signal_default -> exit 1
        | Signal_ignore -> ()
        | Signal_handle f -> f signal_
        ) with Not_found -> exit 1
      ))
    )
  ) signals

let run_trace env run_dir file =
  Unix.chdir run_dir;
  let dir = Mount.(match env.subdir with
    | None -> env.mnt
    | Some sub -> Filename.concat env.mnt sub
  ) in
  let exec = Filename.concat cmd_path "run_trace" in
  let args = [|"-q"; file; "-tmp"; dir|] in
  System.create_process exec args (Unix.environment ())

let os_version = List.hd (System.read_command "uname -a")
let libc_version bin = System.(match system with
  | Darwin -> List.hd (
    read_command
      ("otool -L "^bin
       ^" | grep libSystem"
      )
  )
  | FreeBSD -> "system"
  | Linux -> List.hd (
    read_command
      ("`ldd "^bin
       ^" | grep libc.so"
       ^" | sed -e \"s/.*=> \\\\([^ ]*\\\\).*/\\\\1/\""
       ^"`"
       ^"| head -1"
      )
  )
)

let traces_of_suite suite =
  let { path } = suite in
  let dh = Unix.opendir path in
  let rec list_traces lst =
    let trace = try Some (Unix.readdir dh) with End_of_file -> None in
    match trace with
    | Some t when Filename.check_suffix t ".trace" -> list_traces (t::lst)
    | Some _ -> list_traces lst
    | None -> lst
  in
  let traces = list_traces [] in
  Unix.closedir dh;
  eprintf "Found %d traces for %s\n%!" (List.length traces) suite.nick;
  traces

let run_of_trace fs suite run_dir trace =
  let env = Mount.load params fs in
  let process = run_trace env run_dir trace in
  let run = {
    env; suite; trace; process; run_dir;
    out_buf = Buffer.create 4096;
    err_buf = Buffer.create 4096;
  } in
  Hashtbl.replace pid_idx process.System.pid    run;
  Hashtbl.replace fd_idx  process.System.stdout (false, run);
  Hashtbl.replace fd_idx  process.System.stderr (true,  run);
  run

let suite_of_trace trace =
  let path = Filename.dirname trace in
  let nick = Filename.basename path in
  { nick; path }

let scatter_traces out_path fs traces =
  let fs_name = Mount.name_of_fs fs in
  let run_dir = Filename.concat out_path fs_name in
  System.continue "mkdir" [|"-p"; Filename.concat run_dir "results"|];
  (* TODO: what if multiple traces have the same name? *)
  List.map (fun trace ->
    let name = Filename.basename trace in
    System.continue "cp" [|trace; run_dir|];
    eprintf "Starting trace %s against %s\n%!" name fs_name;
    run_of_trace fs (suite_of_trace trace) run_dir trace
  ) traces

let scatter_suite out_path fs suite =
  let fs_name = Mount.name_of_fs fs in
  let run_dir = Filename.(concat (concat out_path fs_name) suite.nick) in
  System.continue "mkdir" [|"-p"; Filename.concat run_dir "results"|];
  System.(continue "sh" [|"-c"; "cp " ^ (all suite.path) ^ " " ^ run_dir|]);
  System.continue "sh" [|"-c"; "rm -f " ^ (Filename.concat run_dir "*~")|];
  let traces = traces_of_suite suite in
  eprintf "Starting suite %s against %s\n%!" suite.nick fs_name;
  List.map (run_of_trace fs suite run_dir) traces

let gather runs =
  while Hashtbl.length pid_idx > 0 do
    let fds = Hashtbl.fold (fun k _ l -> k::l) fd_idx [] in

    begin match fds with
    | [] -> ()
    | fds ->
      let read_fds, _, _ = Unix.select fds [] [] (-0.1) in
      List.iter (fun fd ->
        let is_err, { out_buf; err_buf } = Hashtbl.find fd_idx fd in
        let buf = if is_err then err_buf else out_buf in
        let len = System.read_into_buf fd buf in
        if len = 0 then (Hashtbl.remove fd_idx fd; Unix.close fd)
      ) read_fds
    end;

    wait_read Unix.([WNOHANG; WUNTRACED]) 0
  done

let basic_fs = Mount.basic_fs system
let local_target = Mount.local_target system

(* TODO: work out errors/unavailability *)
let parse_fs = function
  | "fusexmp" -> [local_target (Mount.Fusexmp basic_fs)]
  | "sshfs"   -> [local_target (Mount.Sshfs basic_fs)]
  | "ntfs"    -> [local_target Mount.Ntfs3g_loop]
  | "tmpfs"   -> Mount.tmpfs_if_available system
  | "ext"     -> Mount.extfs_if_available ()
  | "btrfs"   -> Mount.btrfs_if_available ()
  | "hfsplus" -> Mount.hfsplus_if_available system
  | "ufs2"    -> Mount.ufs2_if_available system
  | "zfs"     -> Mount.zfs_if_available ()
  | fs        -> raise (Invocation_error (Unknown_fs fs))

let all_fs = [
  "tmpfs";
  "ext";
  "btrfs";
  "hfsplus";
  "ufs2";
  "zfs";
  "fusexmp";
  "sshfs";
  "ntfs";
]

let version = (List.hd (System.read_command "git rev-parse HEAD"))^(
  System.exit_command "git" [|"diff-index"; "--quiet"; "HEAD"|] "" (function
  | 0 -> Some ""
  | 1 -> Some " (dirty)"
  | _ -> None
  )
)

let posix_command = Filename.concat bin_path "posix.native"
let check_command = Filename.concat bin_path "check.native"

let check_commands () =
  let open Unix in
  let check command =
    try access command [X_OK]
    with Unix_error ((EACCES | ENOENT),_,_) ->
      eprintf "%s not found.\n" command;
      eprintf "Please build %s.\n%!" command;
      exit 1
  in
  check posix_command;
  check check_command

let print_versions fs_list =
  printf "OS version: %s\n" os_version;
  printf "libc version: %s\n" (libc_version posix_command);
  printf "Spec version: %s\n" version;
  List.iter (fun (fs, fs_version) ->
    printf "%s version: %s\n"
      (Mount.name_of_fs fs) (Mount.string_of_version fs_version)
  ) fs_list;
  flush stdout

let prepare_mnt () =
  at_exit (System.ignore_failure (fun () -> Unix.rmdir mnt_path));
  System.continue "mkdir" [|"-p"; mnt_path|]

let all_suites = [
  "file_descriptors";
  "link";
  "chdir";
  "mkdir";
  "readdir";
  "rmdir";
  "rename";
  "stat";
  "truncate";
  "permissions";
  "permissions_root";
  "open";
  "unlink";
  "symlink";
]

let is_serial_suite = function { nick="open" } -> true | _ -> false

let make_temp_dir () =
  let date = List.hd (System.read_command "date +'%F'") in
  Filename.concat out_base_path
    (List.hd (System.read_command ~env:[|"TMPDIR="^out_base_path|] (
      sprintf "mktemp -d %s_XXX" date
     )))

let cleanup e =
  eprintf "\nFatal error encountered; cleaning up.\n%!";
  drain_children ();
  Mount.destroy_world ();
  begin match e with
  | Unix.Unix_error (e, syscall, "") ->
    eprintf "%s error: %s\n%!" syscall (Unix.error_message e);
    exit 1
  | Unix.Unix_error (e, syscall, path) ->
    eprintf "%s error on %s: %s\n%!" syscall path (Unix.error_message e);
    exit 1
  | _ -> ()
  end;
  raise e

let run_all fs_list suites =
  let serial_suites, suites = List.partition is_serial_suite suites in
  let out_path = make_temp_dir () in
  try
    List.(iter (fun (fs, fs_version) ->
      let runs = flatten (rev_map (fun suite ->
        scatter_suite out_path fs suite
      ) suites)
      in
      gather runs;
      List.iter (fun suite ->
        gather (scatter_suite out_path fs suite)
      ) serial_suites;
    ) fs_list)
  with e -> cleanup e

let run_traces fs_list traces =
  let serial_traces, traces = List.partition (fun trace ->
    is_serial_suite (suite_of_trace trace)
  ) traces in
  let out_path = make_temp_dir () in
  try
    List.(iter (fun (fs, fs_version) ->
      let runs = scatter_traces out_path fs traces in
      gather runs;
      List.iter (fun trace ->
        gather (scatter_traces out_path fs [trace])
      ) serial_traces;
    ) fs_list)
  with e -> cleanup e

let rec resolve_suite search_path nick = match search_path with
  | dir::rest ->
    let path = Filename.(concat (concat dir nick) "") in
    let suite = { nick; path; } in
    let open Unix in
    (try access path []; suite
     with
     | Unix_error (ENOENT, _, _) -> resolve_suite rest nick
     | Unix_error (ENOTDIR, _, _) ->
       raise (Invocation_error (Invalid_suite suite))
    )
  | [] -> raise (Invocation_error (Missing_suite nick))

let resolve_suite_list search_path = List.map (fun suite ->
  if Filename.is_relative suite
  then resolve_suite search_path suite
  else { nick = Filename.basename suite; path = suite; }
)

let rec resolve_trace suites trace = match suites with
  | { path }::rest ->
    let path = Filename.concat path trace in
    let open Unix in
    (try access path []; path
     with Unix_error (ENOENT, _, _) -> resolve_trace rest trace
    )
  | [] -> raise Not_found

let resolve_trace_list suites = List.map (fun trace ->
  if Filename.is_relative trace
  then try resolve_trace suites trace
    with Not_found -> raise (Invocation_error (Missing_trace (suites, trace)))
  else trace
)

let run fs_list search_path suite_list trace_list =
  let search_path = List.map (fun path ->
    if Filename.is_relative path then Filename.concat exec_path path else path
  ) search_path in
  try
    let fs_list = List.(flatten (map parse_fs fs_list)) in
    let suites = resolve_suite_list search_path suite_list in
    check_commands ();
    print_versions fs_list;
    prepare_mnt ();
    (match trace_list with
    | [] -> run_all fs_list suites
    | traces -> run_traces fs_list (resolve_trace_list suites traces)
    );

    let args = Array.of_list (List.tl (Array.to_list Sys.argv)) in
    let command_line = System.string_of_exec_args Sys.argv.(0) args in
    printf "\nFINISHED: %s\n%!" command_line
  with
  | Invocation_error error -> begin match error with
    | Missing_trace (suites, trace) ->
      eprintf "Trace '%s' not found in %s\n%!"
        trace (String.concat ":" (List.map (fun suite -> suite.path) suites))
    | Missing_suite nick ->
      eprintf "Suite '%s' not found in %s\n%!"
        nick (String.concat ":" search_path)
    | Invalid_suite suite ->
      eprintf "Suite '%s' found at %s but it is not a directory.\n%!"
        suite.nick suite.path
    | Unknown_fs fs ->
      eprintf "Filesystem name '%s' is not known to this program.\n%!" fs
  end; exit 1

open Cmdliner

let run_cmd =
  let doc =
    "run a set of traces against the model and this machine and compare"
  in
  let man = [
    `S "DESCRIPTION";
    `P ("$(b,fs-test) $(b,run) interprets a set of traces through the "
        ^"specification and on the local machine and compares the results.");
  ]@Cli.man_trailer in
  Term.(pure run
          $ Cli.fs all_fs
          $ Cli.suite_path ["."]
          $ Cli.suite all_suites
          $ Cli.trace
  ), Term.info "run" ~version ~doc ~man

let default_cmd =
  let doc = "execute the fs-test model" in
  let man = [
    `S "DESCRIPTION";
    `P "$(b,fs-test) offers POSIX file system specification tools";
  ]@Cli.man_trailer in
  Term.(ret (pure (`Help (`Plain, None)))),
  Term.info "fs-test" ~version ~doc ~man

;;

match Term.eval_choice default_cmd [
  run_cmd;
] with
| `Error _ -> exit 1
| `Help | `Ok _ | `Version -> exit 0
