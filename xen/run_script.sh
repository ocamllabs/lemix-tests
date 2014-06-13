#!/bin/sh

echo "\n*** executing on fs-lucid-ext4"
scp $1 fs-lucid-ext4:$1
ssh fs-lucid-ext4 chmod +x $1
ssh -o ForwardAgent=yes fs-lucid-ext4 "bash -l -c ./$1 2>&1 | tee -a $1.log"
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** fs-lucid-ext4 failed with $EXIT"; fi

echo "\n*** executing on fs-precise-ext4"
scp $1 fs-precise-ext4:$1
ssh fs-precise-ext4 chmod +x $1
ssh -o ForwardAgent=yes fs-precise-ext4 "bash -l -c ./$1 2>&1 | tee -a $1.log"
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** fs-precise-ext4 failed with $EXIT"; fi

echo "\n*** executing on fs-trusty-ext4"
scp $1 fs-trusty-ext4:$1
ssh fs-trusty-ext4 chmod +x $1
ssh -o ForwardAgent=yes fs-trusty-ext4 "bash -l -c ./$1 2>&1 | tee -a $1.log"
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** fs-trusty-ext4 failed with $EXIT"; fi

echo ""
