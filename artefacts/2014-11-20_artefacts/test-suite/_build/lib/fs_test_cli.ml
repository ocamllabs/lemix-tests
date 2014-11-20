open Cmdliner

let man_trailer = [
  `S "BUGS";
  `P "Report bugs on the web at <https://bitbucket.org/tomridge/fs>.";
]

let map f x = Term.(pure f $ x)

let fs all_fs = map List.flatten Arg.(
  let all_s = String.concat ", " all_fs in
  value & opt_all (list string) [all_fs] & info ["fs"]
    ~docv:"FS"
    ~doc:("The file systems which should be tested (default "
          ^all_s^")")
)

let suite_path default =
  map (fun paths -> List.flatten (paths@[default])) Arg.(
    value & opt_all (list ~sep:':' string) [] & info ["suites"]
      ~docv:"SUITE_PATH"
      ~doc:("The paths to search for test suites (default "
            ^(String.concat ":" default)^")")
  )

let suite all_suites = map List.flatten Arg.(
  let all_s = String.concat ", " all_suites in
  value & opt_all (list string) [all_suites] & info ["suite"]
    ~docv:"SUITE"
    ~doc:("The test suites to run (default "
          ^all_s^")")
)

let trace = map List.flatten Arg.(
  value & opt_all (list string) [] & info ["trace"]
    ~docv:"TRACE"
    ~doc:("The trace files to run (default all for selected suites)")
)
