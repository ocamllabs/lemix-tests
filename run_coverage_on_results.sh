#!/bin/bash -e

# this script is intended to check posix trace results and produce
# coverage testing of the specification
#
# Usage:
#     myself directory_with_posix_results
#
# or for quiet mode
#     myself -q directory_with_posix_results

if [[ ! $@ || $1 == "-h" || $1 == "--help" ]]
then
    echo "Usage: run_coverage_on_results.sh [OPTION] ... [DIR]
      
      run_coverage_on_results.sh generates a coverage testing report,
      after checking that running a file system trace
      against an implementation has the same results expected
      by the POSIX specification.
      
      OPTIONS:
      -m            uses make to build the posix and the checker instrumented (they produce a coverage report) executables
      -a <ARCH>     architecture of the spec: it can be [posix,linux,mac_os_x]
      -h,--help     show a message help
      "
    exit 0;
fi;

# adapt to fit the dirs in your installation
check_command=`readlink -f ./src_ext/fs/fs_test/check.native`

echo "Using check command \"$check_command\""

# safety check: fs must have the Makefile_bisect
if  [[ -f ../src_ext/fs/Makefile_bisect ]]
then echo "Error: the specification cannot be instrumented,
           no Makefile_bisect in src_ext/fs/
           (change fs branch in add_bisect or add_bisect_clean_c)"
     exit 1;
fi;

if [[ $1 == "-m" ]]
then
    shift
    dir=`pwd .`
    cd ./src_ext/fs/
    make clean
    make
    make -f Makefile_bisect
    cd $dir
fi;

architecture=posix
if [[ $1 = "-a" ]]
then
    shift
    #sanity check on the architecture
    if ! [[ $1 = "posix" || $1 = "linux" || $1 = "mac_os_x" ]]
    then
        echo "Wrong architecture: the only allowed are posix, linux or mac_os_x"
    exit 1;
    fi;
    architecture=$1
    shift
fi;

echo "Checker uses the $architecture architecture"

# sanity check on passed directory
if ! [[ -d $1 ]]
then
    echo "Missing directory containing results
          (Hint: it should be something like
          artefacts/2014-08-27_artefacts/2014-08-27_WGf/ext4_loop/)"
    exit 1;
fi;

results_dir=`readlink -f $1`
coverage_dir=$results_dir/coverage
#remove results of a previous run
if [[-d $coverage_dir]]
then
    rm -rf $coverage_dir
fi;
mkdir $coverage_dir

for d in $results_dir/*;
do
    if [[ $d == $coverage_dir ]]
    then
        continue;
    fi;

    echo "Operating on $(basename $d)..."
    merge_trace=$coverage_dir/$(basename $d)-check.trace
    touch $merge_trace
    echo "  merging $(basename $d) traces in $merge_trace..."
    for f in `find $d -name posix*.trace`;
    do
        # echo "  merging $f in $merge_trace"
        cat $f >> $merge_trace
        echo "" >> $merge_trace
    done;
    echo ""
    echo "  checker is running on $merge_trace"
    $check_command -arch $architecture $merge_trace
    mv bisect0001.out $coverage_dir/$(basename $d)-report.out
done;

cd ./src_ext/fs/
echo "Running bisect-report on partial reports..."
bisect-report -html $coverage_dir/total_coverage_html `find $coverage_dir -name *-report.out`

echo "All the outputs of this script are in:

      $coverage_dir

      The html report is consultable running (substitute to
      firefox your preferred web browser):

      firefox $coverage_dir/total_coverage_html/index.html"
