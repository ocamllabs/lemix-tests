#!/bin/sh -ex

HOST=$1
IMAGE=$2

xl destroy $HOST || true
./restore_fs.sh $HOST $IMAGE
./start_vm.sh $HOST

