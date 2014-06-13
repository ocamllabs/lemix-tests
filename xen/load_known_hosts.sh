#!/bin/sh -ex

ssh $1 "bash -c cat >> .ssh/known_hosts" < .ssh/known_hosts
