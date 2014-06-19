#!/bin/sh -xe

HOST=$1

xl create /etc/xen/$HOST.cfg &
