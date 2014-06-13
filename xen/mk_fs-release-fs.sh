#!/bin/sh

xen-create-image --hostname=fs-$1-$2 --memory=512mb --vcpus=2 --pygrub --dist=$1 --dhcp --dir=fs_images --fs=$2 --image="sparse" --genpass=0 --role=`pwd`/agent_role.sh --password=password
