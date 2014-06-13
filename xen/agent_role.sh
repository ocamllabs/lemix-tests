#!/bin/sh

prefix=$1

#
#  Source our common functions
#
if [ -e /usr/share/xen-tools/common.sh ]; then
    . /usr/share/xen-tools/common.sh
else
    . ./hooks/common.sh
fi


#
# Log our start
#
logMessage Script $0 starting


#
#  Now let's authorize ourselves
#
mkdir -p ${prefix}/root/.ssh
cat ~/.ssh/id_rsa.pub >> ${prefix}/root/.ssh/authorized_keys

#
#  Log our finish
#
logMessage Script $0 finished
