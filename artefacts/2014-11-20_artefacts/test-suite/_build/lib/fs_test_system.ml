open Printf

exception Command_failure of string * string * string

type t =
| Linux
| Darwin
| FreeBSD

type process = {
  pid    : int;
  stdout : Unix.file_descr;
  stdin  : Unix.file_descr;
  stderr : Unix.file_descr;
}

let quote = sprintf "\"%s\""
let all dir = Filename.concat dir "*"
let megs x = Int64.(mul (mul 1024_L 1024_L) (of_int x))

let string_of_exec_args exec args =
  exec ^ (
    if Array.length args > 0 then
      " " ^ (String.concat " " Array.(to_list (map quote args)))
    else ""
  )

let string_of_signal = Sys.(function
  | x when x = sigabrt   -> "SIGABRT"
  | x when x = sigalrm   -> "SIGALRM"
  | x when x = sigfpe    -> "SIGFPE"
  | x when x = sighup    -> "SIGHUP"
  | x when x = sigill    -> "SIGILL"
  | x when x = sigint    -> "SIGINT"
  | x when x = sigkill   -> "SIGKILL"
  | x when x = sigpipe   -> "SIGPIPE"
  | x when x = sigquit   -> "SIGQUIT"
  | x when x = sigsegv   -> "SIGSEGV"
  | x when x = sigterm   -> "SIGTERM"
  | x when x = sigusr1   -> "SIGUSR1"
  | x when x = sigusr2   -> "SIGUSR2"
  | x when x = sigchld   -> "SIGCHLD"
  | x when x = sigcont   -> "SIGCONT"
  | x when x = sigstop   -> "SIGSTOP"
  | x when x = sigtstp   -> "SIGTSTP"
  | x when x = sigttin   -> "SIGTTIN"
  | x when x = sigttou   -> "SIGTTOU"
  | x when x = sigvtalrm -> "SIGVTALRM"
  | x when x = sigprof   -> "SIGPROF"
  | x                    -> "SIG"^(string_of_int x)
)

let string_of_status = function
  | Unix.WEXITED k   -> sprintf "exit %d" k
  | Unix.WSIGNALED k -> sprintf "signal %s" (string_of_signal k)
  | Unix.WSTOPPED k  -> sprintf "stop %d" k

let check_status ?(exit_code=0) command = function
  | Unix.WEXITED k when k = exit_code -> ()
  | status ->
    raise (Command_failure (Unix.getcwd (), command, string_of_status status))

let ignore_failure cmd_fun = fun () ->
  try cmd_fun ()
  with Command_failure (_,_,_) | Unix.Unix_error (_,_,_) -> ()

let rec split acc str char =
  try
    let spc = String.index str char in
    let next = String.sub str 0 spc in
    let str = String.sub str (spc+1) ((String.length str) - spc - 1) in
    split (next::acc) str char
  with Not_found -> List.rev (str::acc)

let system_stderr exec args =
  let args = Array.append [|exec|] args in
  let env = Unix.environment () in
  let in_fd, stdin = Unix.pipe () in
  let stderr = Unix.stderr in
  Unix.set_close_on_exec stdin;
  let pid = Unix.create_process_env exec args env in_fd stderr stderr in
  let status = snd Unix.(waitpid [WUNTRACED] pid) in
  Unix.close in_fd;
  status

let continue exec args =
  let command = string_of_exec_args exec args in
  eprintf "+ %s\n%!" command;
  check_status command (system_stderr exec args)

let exit_command exec args default exit_handler =
  let command = string_of_exec_args exec args in
  eprintf "? %s\n%!" command;
  let status = system_stderr exec args in
  match status with
  | Unix.WEXITED k -> begin match exit_handler k with
    | Some v -> v
    | None -> check_status command status; default
  end
  | status -> check_status command status; default

let rec input_all_ lst ic =
  let line = try Some (input_line ic) with End_of_file -> None in
  match line with Some l -> input_all_ (l::lst) ic | None -> List.rev lst
let input_all = input_all_ []

let read_command_full ?exit_code ?(env=[||]) command input_fun =
  let env = Array.append (Unix.environment ()) env in
  let o, i, e = Unix.open_process_full command env in
  let lines = input_fun o i e in
  check_status ?exit_code command (Unix.close_process_full (o, i, e));
  lines

let read_command ?exit_code ?env command =
  eprintf "< %s\n%!" command;
  read_command_full ?exit_code ?env command (fun ic _ _ -> input_all ic)

let read_command_err ?exit_code ?env command =
  eprintf "2< %s\n%!" command;
  read_command_full ?exit_code ?env command (fun _ _ ic -> input_all ic)

let child_set = Hashtbl.create 32

let create_process exec args env =
  printf "@ %s\n%!" (string_of_exec_args exec args);
  let args = Array.append [|exec|] args in
  let in_fd, stdin = Unix.pipe () in
  let stdout, out_fd = Unix.pipe () in
  let stderr, err_fd = Unix.pipe () in
  Unix.set_close_on_exec stdin;
  Unix.set_close_on_exec stdout;
  Unix.set_close_on_exec stderr;
  let pid = Unix.create_process_env exec args env in_fd out_fd err_fd in
  Unix.close in_fd;
  Unix.close out_fd;
  Unix.close err_fd;
  Hashtbl.replace child_set pid ();
  { pid; stdout; stdin; stderr; }

let read_into_buf =
  let tmp = String.create 4096 in
  fun ?(block=false) fd buf ->
    let rec read rlen =
      let len = Unix.read fd tmp 0 4096 in
      if len = 0 then rlen
      else begin
        Buffer.add_substring buf tmp 0 len;
        let rlen = len + rlen in
        if block then read rlen
        else if len = 4096
        then
          let read_fds, _, _ = Unix.select [fd] [] [] 0. in
          if List.length read_fds > 0 then read rlen else rlen
        else rlen
      end
    in read 0

let drain_into_buf fd buf =
  try
    let len = read_into_buf ~block:true fd buf in
    Unix.close fd;
    len
  with Unix.Unix_error (Unix.EBADF,_,_) -> 0

let waitpid flags pid =
  let (pid, _) as r = Unix.waitpid flags pid in
  (if pid <> 0 then Hashtbl.remove child_set pid);
  r

let tee ?(quiet=false) process file =
  let output = open_out file in
  let fds = [process.stdout; process.stderr] in
  let read_fd read_fn fd =
    let buf = Buffer.create 4096 in
    ignore (read_fn fd buf);
    if fd = process.stdout
    then begin
      Buffer.output_buffer output buf;
      if not quiet then Buffer.output_buffer stdout buf
    end
    else Buffer.output_buffer stderr buf
  in
  let rec read () =
    let read_fds, _, _ = Unix.select fds [] [] (-0.1) in
    List.iter (read_fd read_into_buf) read_fds;
    match waitpid Unix.([WNOHANG; WUNTRACED]) process.pid with
    | 0, _ -> read ()
    | _, Unix.WEXITED k ->
      List.iter (read_fd drain_into_buf) fds;
      close_out output;
      exit k
    | _, status ->
      List.iter (read_fd drain_into_buf) fds;
      close_out output;
      eprintf "child terminated with %s\n%!" (string_of_status status);
      exit 1
  in
  let signals = Sys.([sigterm; sigint]) in
  let sigh = Sys.Signal_handle (fun signal ->
    ignore Unix.(sigprocmask SIG_BLOCK signals);
    eprintf "%d caught %s; terminating children.\n%!"
      (Unix.getpid ()) (string_of_signal signal);
    Unix.kill process.pid Sys.sigterm;
    read ()
  ) in
  List.iter (fun signal -> Sys.set_signal signal sigh) signals;
  read ()

let kill_children () =
  let child_count = Hashtbl.length child_set in
  eprintf "%d live children receiving SIGTERM\n%!" child_count;
  Hashtbl.iter (fun pid () -> Unix.kill pid Sys.sigterm) child_set;

  Hashtbl.iter (fun pid () ->
    ignore (waitpid [Unix.WUNTRACED] pid);
    eprintf "Child pid %d terminated\n%!" pid;
  ) child_set

let of_string = function
  | "Darwin"  -> Some Darwin
  | "FreeBSD" -> Some FreeBSD
  | "Linux"   -> Some Linux
  | _         -> None

let to_string = function
  | Darwin  -> "Darwin"
  | FreeBSD -> "FreeBSD"
  | Linux   -> "Linux"

let memo fn =
  let cell = ref None in
  fun arg -> match !cell with
  | None -> let v = fn arg in cell := Some v; v
  | Some v -> v

(* Assumes Linux when we don't know *)
let get_system = memo (fun () ->
  match read_command "uname -s" with
  | s::_ -> begin match of_string s with
    | Some system -> system
    | None -> Linux
  end
  | [] -> Linux
)

let create_lock lock_set lock_name =
  let lock_dir = Filename.(concat temp_dir_name lock_set) in
  continue "mkdir" [|"-p"; lock_dir|];
  let lock_file = Filename.concat lock_dir lock_name in
  let fd = Unix.(openfile lock_file [O_WRONLY;O_CREAT] 0o600) in
  Unix.close fd;
  lock_file
let darwin_dscl_lock = create_lock "fs_test" "dscl.lock"

let dscl_command action ?kv node = match kv with
  | Some (key, value) ->
    continue "dscl" [|"localhost"; "-" ^ action; node; key; value|]
  | None ->
    continue "dscl" [|"localhost"; "-" ^ action; node|]

let acquire_lock lock =
  let pid = Unix.getpid () in
  let pid_str = (string_of_int pid) ^ "\n" in
  let pid_str_len = String.length pid_str in
  let fd = Unix.(openfile lock [O_WRONLY] 0o600) in
  Unix.(lockf fd F_LOCK 0);
  eprintf "$ Acquired lock %s\n%!" lock;
  Unix.ftruncate fd 0;
  let written = Unix.write fd pid_str 0 pid_str_len in
  assert (written = pid_str_len);
  fd

let release_lock lock fd =
  Unix.ftruncate fd 0;
  Unix.(lockf fd F_ULOCK 0);
  eprintf "$ Released lock %s\n%!" lock;
  Unix.close fd

let critical_section lock fn =
  let fd = acquire_lock lock in
  let v = try fn () with e -> release_lock lock fd; raise e in
  release_lock lock fd;
  v

let uid_of_username username = Unix.((getpwnam username).pw_uid)

let create_new_user = let min = ref 0 in fun () ->
  let system = get_system () in
  let rec try_username n =
    let username = sprintf "fs_user_%d" n in
    if (match system with
    | Linux ->
      exit_command "useradd" [|"-s"; "/bin/false"; username|] true (function
      | 9 -> Some false
      | _ -> None
      )
    | FreeBSD ->
      exit_command "pw" [|"useradd"; username; "-w"; "no"|] true (function
      | 65 -> Some false
      | 1  -> Some false (* TODO: Only busy group file? *)
      | _  -> None
      )
    | Darwin ->
      let user = "/Local/Default/Users/" ^ username in
      exit_command "dscl" [|"localhost"; "-list"; user|] false (function
      | 185 ->
        dscl_command "create" user;
        let max_uid = int_of_string (List.hd (
          read_command (
            "dscl localhost -list /Local/Default/Users UniqueID "
            ^ "| awk '{print $2}' "
            ^ "| sort -ug "
            ^ "| tail -1"
          ))) in
        dscl_command "create" ~kv:("UniqueID",string_of_int (max_uid+1)) user;
        dscl_command "create" ~kv:("UserShell","/usr/bin/false") user;
        dscl_command "create" ~kv:("RealName",username) user;
        dscl_command "create" ~kv:("PrimaryGroupID","20") user;
        Some true
      | _ -> None
      )
    )
    then (min := n + 1; (uid_of_username username, username))
    else try_username (n + 1)
  in
  if system = Darwin
  then critical_section darwin_dscl_lock (fun () -> try_username !min)
  else try_username !min

let delete_user ?(force=false) username = match get_system () with
  | Linux   -> continue "userdel" [|username|]
  | FreeBSD -> continue "pw" [|"userdel"; username|]
  | Darwin  ->
    exit_command "dscl"
      [|"localhost"; "-delete"; "/Local/Default/Users/" ^ username|] ()
      (function 185 when force -> Some () | _ -> None)

let gid_of_groupname groupname = Unix.((getgrnam groupname).gr_gid)

let create_new_group = let min = ref 0 in fun () ->
  let system = get_system () in
  let rec try_groupname n =
    let groupname = sprintf "fs_group_%d" n in
    if (match system with
    | Linux ->
      exit_command "groupadd" [|groupname|] true (function
      | 9 -> Some false
      | _ -> None
      )
    | FreeBSD ->
      exit_command "pw" [|"groupadd"; groupname|] true (function
      | 65 -> Some false
      | 1  -> Some false (* TODO: Only busy group file? *)
      | _  -> None 
      )
    | Darwin ->
      let group = "/Local/Default/Groups/" ^ groupname in
      exit_command "dscl" [|"localhost"; "-list"; group|] false (function
      | 185 ->
        dscl_command "create" group;
        let max_gid = int_of_string (List.hd (
          read_command (
            "dscl localhost -list /Local/Default/Groups PrimaryGroupID "
            ^ "| awk '{print $2}' "
            ^ "| sort -ug "
            ^ "| tail -1"
          ))) in
        dscl_command "create"
          ~kv:("PrimaryGroupID",string_of_int (max_gid+1)) group;
        Some true
      | _ -> None
      )
    )
    then (min := n + 1; (gid_of_groupname groupname, groupname))
    else try_groupname (n + 1)
  in
  if system = Darwin
  then critical_section darwin_dscl_lock (fun () -> try_groupname !min)
  else try_groupname !min

let delete_group ?(force=false) groupname = match get_system () with
  | Linux   -> continue "groupdel" [|groupname|]
  | FreeBSD -> continue "pw" [|"groupdel"; groupname|]
  | Darwin  ->
    exit_command "dscl"
      [|"localhost"; "-delete"; "/Local/Default/Groups/" ^ groupname|] ()
      (function 185 when force -> Some () | _ -> None)

let rec put_user_in_group username groupname = match get_system () with
  | Linux -> continue "adduser" [|username; groupname|]
  | FreeBSD ->
    let update = exit_command "pw" [|"groupmod"; groupname; "-m"; username|] in
    if update false (function
    | 1 -> Some true (* TODO: Only busy group file? *)
    | _ -> None
    )
    then put_user_in_group username groupname
  | Darwin ->
    continue "dseditgroup"
      [|"-o"; "edit"; "-a"; username; "-t"; "user"; groupname|]
