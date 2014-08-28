#!/bin/sh -ex

. /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
git clone https://bitbucket.org/dsheets/lem.git
cd lem
git fetch origin fs:fs
git checkout fs
make
make ocaml-libs
cd -
git clone git@bitbucket.org:tomridge/fs.git
cd fs
git fetch origin clean_c:clean_c
git checkout clean_c
ln -s ../../lem src_ext/lem
ln -s ../../ocaml-4.01.0 src_ext/ocaml
opam install -y ocamlfind
./install_opam_deps.sh --install -y
make src_ext build_spec fs_test
