#!/bin/sh -ex

. /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
git clone git@github.com:ocamllabs/lemix-tests.git
cd lemix-tests
./run_tests.ml
