#!/bin/sh -ex

HOST=$1
IMAGE=$2

cp -R fs_images/masters/$IMAGE/$HOST fs_images/domains

