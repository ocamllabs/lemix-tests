#!/bin/sh -ex

xl destroy $2 || true
./restore_fs.sh $1 $2
./start_vm.sh $2

