#!/bin/sh -ex

HOST=$1

ssh $HOST "bash -c cat >> .ssh/known_hosts" < ~/.ssh/known_hosts
