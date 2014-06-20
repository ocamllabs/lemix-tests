#!/bin/sh -ex

HOST=$1
FILE=$2

mkdir -p results/$HOST
scp $HOST:$FILE results/$HOST/$FILE
