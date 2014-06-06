#!/bin/bash

# call this script with the argument directory of traces to test test 
# e.g. ./this_script.sh current_tests/open_read_write

if [[ $1 == "-dummy" ]]
then
    shift;
    real=0;
else
    real=1;
fi

test_dir=$1
if [[ ! (-d $test_dir) ]]
then
  echo "Error: argument is not a directory containing trace files";
  exit 1;
fi

date=`date +'%F'`
test_dir_name=`basename $test_dir`

if [[ $real -eq 1 ]] 
then
    OUTDIR=`mktemp -d --tmpdir=. ${date}_${test_dir_name}_XXX`
else
    OUTDIR=`mktemp -d --tmpdir=. dummy_${test_dir_name}_XXX`
fi

echo "creating test-directory $OUTDIR ..."
cp $test_dir/* $OUTDIR
rm $OUTDIR/*~
mkdir $OUTDIR/results

cd $OUTDIR

for file in *.trace; do
   ../run_trace.sh -q $file
# be more verbose
#   ../run_trace.sh $file
   echo "-----------------------------------"
done

echo -e "\ndone!"

# tr: I prefer not to stage these in git automatically!
#
# if [[ $real -eq 1 ]]
# then
#     cd ..
#     echo "staging $OUTDIR ..."
#     git stage $OUTDIR
# fi

exit 0

