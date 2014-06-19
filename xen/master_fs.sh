#!/bin/sh -ex

HOST=$1
IMAGE=$2

mkdir -p fs_images/masters/$IMAGE
cp -R fs_images/domains/$HOST fs_images/masters/$IMAGE

