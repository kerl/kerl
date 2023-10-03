#!/bin/csh -ef

set release = $argv[1]
set build_name = $argv[2]
set directory = $argv[3]

test -d "$directory" || exit 1

alias run_test ./tests/run_test.csh "$release" "$build_name" "$directory"

run_test

# MANPATH manipulations
if ( $?MANPATH ) then
    set MANPATH_SAVE = $MANPATH
    if ( "$MANPATH" == "" ) then
        echo "MANPATH is empty"
        echo "testing non-empty MANPATH..."
        setenv MANPATH "/man/path"
        run_test
    else
        echo "MANPATH is not empty"
        echo "testing empty MANPATH..."
        setenv MANPATH ""
        run_test
    endif
    echo "testing undefined MANPATH..."
    unsetenv MANPATH
    run_test
    setenv MANPATH "$MANPATH_SAVE"
else
    echo "MANPATH is not set"
    echo "testing empty MANPATH..."
    setenv MANPATH ""
    run_test
    echo "testing non-empty MANPATH..."
    setenv MANPATH "/man/path"
    run_test
    unsetenv MANPATH
endif
