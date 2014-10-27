open Printf
module System = Fs_test_system

let int_suff = "-int.trace"
let chk_suff = "-check.trace"

let exec_dir = Filename.dirname Sys.argv.(0)
let check_command = Filename.concat exec_dir "../fs_test/check.native"
let posix_command = Filename.concat exec_dir "../fs_test/posix.native"

let argc = Array.length Sys.argv
let argr = ref 1

let quiet =
  if argc > !argr && Sys.argv.(!argr) = "-q"
  then (incr argr; true)
  else false

let file_raw =
  if argc > !argr
  then let i = !argr in incr argr; Sys.argv.(i)
  else ""

let rest_args =
  if argc > !argr
  then Array.sub Sys.argv !argr (Array.length Sys.argv - !argr)
  else [||]

let result_dir = "results"

let check_suffix = Filename.check_suffix

let env = Array.append (Unix.environment ()) [|"OCAMLRUNPARAM=b"|]

let tee = System.tee

;;

if check_suffix file_raw int_suff
then begin
  let file = Filename.chop_suffix file_raw int_suff in
  let ident = Filename.basename file in
  if check_suffix file "check"
  then begin
    printf "Interpreting %s with check ...\n%!" ident;
    let process = System.create_process check_command
      [|"-arch"; "linux"; file_raw|]
      env
    in
    tee ~quiet process (Filename.concat result_dir ("check_results-"^ident))
  end
  else if check_suffix file "posix"
  then begin
    printf "Interpreting %s with posix ...\n%!" ident;
    let process = System.create_process posix_command
      (Array.append
         [|file_raw;
           "-o"; Filename.concat result_dir ("posix_results-"^ident^chk_suff);
         |]
         rest_args
      ) env
    in
    tee ~quiet process (Filename.concat result_dir ("posix_results-"^ident))
  end
  else
    let process = System.create_process posix_command
      (Array.append
         [|"-c"; file_raw;
           "-cpo"; Filename.concat result_dir ("posix_results-"^ident^chk_suff);
           "-cpl"; Filename.concat result_dir ("posix_results-"^ident);
           "-cl" ; Filename.concat result_dir ("diff_results-"^ident);
         |]
         rest_args
      ) env
    in tee ~quiet:true process "/dev/stdout"
end
else if check_suffix file_raw chk_suff
  then begin
    let file = Filename.chop_suffix file_raw chk_suff in
    let ident = Filename.basename file in
    if check_suffix file "posix"
    then begin
      printf "Processing %s with posix ...\n%!" ident;
      let process = System.create_process posix_command
        (Array.append [|file_raw; "-v"|] rest_args) env
      in
      tee ~quiet process (Filename.concat result_dir ("posix_results-"^ident))
    end
    else begin
      printf "Processing %s with check ...\n%!" ident;
      let process = System.create_process check_command
        [|"-arch"; "linux"; "-v"; file_raw|] env
      in
      tee ~quiet process (Filename.concat result_dir ("check_results-"^ident))
    end
  end
else (print_endline "Error: argument is not a trace file"; exit 1)
