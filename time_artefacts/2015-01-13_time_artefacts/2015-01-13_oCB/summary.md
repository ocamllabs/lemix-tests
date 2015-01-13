< uname -s
< uname -a
2< mke2fs -V
< `ldd /home/andrea/workspace/fs/test-suite/../fs_test/posix.native | grep libc.so | sed -e "s/.*=> \\([^ ]*\\).*/\\1/"`| head -1
OS version: Linux freedom 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC 2014 x86_64 GNU/Linux
libc version: GNU C Library (GNU libc) stable release version 2.20, by Roland McGrath et al.
Spec version: 275063c6b158e451cca9384db2f1b25a96741f7a (dirty)
ext2_loop version: mke2fs 1.42.12 (29-Aug-2014)
ext3_loop version: mke2fs 1.42.12 (29-Aug-2014)
ext4_loop version: mke2fs 1.42.12 (29-Aug-2014)
