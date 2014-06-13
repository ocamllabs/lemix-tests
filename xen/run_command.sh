#!/bin/sh

echo "\n*** executing on fs-lucid-ext4"
ssh -o ForwardAgent=yes fs-lucid-ext4 "bash -l -c \"$*\""
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** fs-lucid-ext4 failed with $EXIT"; fi

echo "\n*** executing on fs-precise-ext4"
ssh -o ForwardAgent=yes fs-precise-ext4 "bash -l -c \"$*\""
EXIT=$?
if [ $EXIT != 0 ]; then echo "\n*** fs-precise-ext4 failed with $EXIT"; fi

echo "\n*** executing on fs-trusty-ext4"
ssh -o ForwardAgent=yes fs-trusty-ext4 "bash -l -c \"$*\""
if [ $EXIT != 0 ]; then echo "\n*** fs-trusty-ext4 failed with $EXIT"; fi

echo ""
