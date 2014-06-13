#!/bin/sh -ex

mkdir -p fs_images/masters/$1
cp -R fs_images/domains/$2 fs_images/masters/$1

