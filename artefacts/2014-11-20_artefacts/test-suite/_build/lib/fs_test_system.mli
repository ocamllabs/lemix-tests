exception Command_failure of string * string * string

type t =
| Linux
| Darwin
| FreeBSD

type process = {
  pid : int;
  stdout : Unix.file_descr;
  stdin : Unix.file_descr;
  stderr : Unix.file_descr;
}

val all : string -> string
val megs : int -> int64

val string_of_exec_args : string -> string array -> string

val string_of_signal : int -> string
val string_of_status : Unix.process_status -> string
val ignore_failure : (unit -> unit) -> unit -> unit

val continue : string -> string array -> unit
val exit_command : string -> string array -> 'a -> (int -> 'a option) -> 'a

val read_command :
  ?exit_code:int -> ?env:string array -> string -> string list
val read_command_err :
  ?exit_code:int -> ?env:string array -> string -> string list

val create_process : string -> string array -> string array -> process

val read_into_buf : ?block:bool -> Unix.file_descr -> Buffer.t -> int

val drain_into_buf : Unix.file_descr -> Buffer.t -> int

val waitpid : Unix.wait_flag list -> int -> int * Unix.process_status

val tee : ?quiet:bool -> process -> string -> 'a

val kill_children : unit -> unit

val get_system : unit -> t

val to_string : t -> string

val create_new_user : unit -> int * string

val delete_user : ?force:bool -> string -> unit

val create_new_group : unit -> int * string

val delete_group : ?force:bool -> string -> unit

val put_user_in_group : string -> string -> unit
