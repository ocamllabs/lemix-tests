#!/bin/sh

HOST=$1
SCRIPT=$2

echo "\n*** executing on $HOST"
scp $SCRIPT $HOST:$SCRIPT
ssh $HOST chmod +x $SCRIPT
ssh -o ForwardAgent=yes $HOST "bash -l -c ./$SCRIPT 2>&1 | tee -a $SCRIPT.log"
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** $SCRIPT on $HOST failed with $EXIT\n"; fi
exit $EXIT
