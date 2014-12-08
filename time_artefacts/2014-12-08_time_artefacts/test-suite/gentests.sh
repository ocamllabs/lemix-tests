#!/bin/sh -ex

TESTGEN=../fs_test/testgen.byte

rm -r link
$TESTGEN -l link

rm -r mkdir
$TESTGEN -l mkdir

rm -r open
$TESTGEN -l open
cp -R open.tmpl/* open/

rm -r rmdir
$TESTGEN -l rmdir

rm -r unlink
$TESTGEN -l unlink

rm -r rename
$TESTGEN -l rename

rm -r stat
$TESTGEN -l stat

rm -r lstat
$TESTGEN -l lstat

rm -r truncate
$TESTGEN -l truncate


