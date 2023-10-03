#!/bin/csh -ef

echo "run_test $argv[*]"

set release = $argv[1]
set build_name = $argv[2]
set directory = $argv[3]

./tests/test_it.csh "$release" "$build_name" "$directory"
./tests/test_it.csh foo boo foo_dir
./tests/test_it.csh foo boo "foo dir"

./tests/test_it.csh foo boo "foo dir" alter_manpath
./tests/test_it.csh foo boo "foo dir" rebar_plt
./tests/test_it.csh foo boo "foo dir" rebar_cache

./tests/test_it.csh foo boo foo_dir enable_prompt
./tests/test_it.csh foo boo "foo dir" enable_prompt
./tests/test_it.csh foo "boo build" "foo dir" enable_prompt

if ( $?prompt ) then
    unsetenv prompt
else
    setenv prompt "a b c >"
endif
./tests/test_it.csh foo boo foo_dir enable_prompt
./tests/test_it.csh foo boo "foo dir" enable_prompt
./tests/test_it.csh foo "boo build" "foo dir" enable_prompt

echo ok
