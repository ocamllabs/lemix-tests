#!/bin/sh

CMD=$1

shift

parallel -j0 $CMD {} $* < ubuntus
