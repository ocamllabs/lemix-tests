#!/bin/sh

HOST=$1

shift

echo "\n*** executing on $HOST"
ssh -o ForwardAgent=yes $HOST "bash -l -c \"$*\""
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** $* on $HOST failed with $EXIT\n"; fi
exit $EXIT
