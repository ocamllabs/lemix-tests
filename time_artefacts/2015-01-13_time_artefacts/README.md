This is the README to track the state of the various artefacts.

Items that need doing are identified by a box: [ ]

The branch used for testing was: [time_clean_c](https://bitbucket.org/tomridge/fs/commits/branch/time_clean_c)

The git commit used for testing was: [b4fddbe](https://bitbucket.org/tomridge/fs/commits/b4fddbe8c0e7df5e957ef4253406882892efd6cb?at=master)

Artefact            |Subdirectory
--------------------|-------------------------
Test suite          | [test-suite/](test-suite/)
Linux interp summary| [2015-01-13_oCB/summary.md](2015-01-13_oCB/summary.md)
Linux ext2 traces   | [2015-01-13_oCB/ext2_loop/](2015-01-13_oCB/ext2_loop/)
Linux ext3 traces   | [2015-01-13_oCB/ext3_loop/](2015-01-13_oCB/ext3_loop/)
Linux ext4 traces   | [2015-01-13_oCB/ext4_loop/](2015-01-13_oCB/ext4_loop/)
Linux check summary | [2015-01-13_oCB/check_summary.md](2015-01-13_oCB/check_summary.md)
Linux coverage data | [ ]
Mac interp summary  | [ ]
Mac hfsplus traces  | [ ]
Mac check summary   | [ ]
Mac coverage data   | [ ]


Notes:

this testsuite was run with the filesystem stressing tool dbench.
Dbench was run with the following options:
dbench -F -S -t 1000 100

(this means that dbench created 100 processes, run for 1000 seconds and forced the file system to call fsync and synchronize metadata)
