#!/bin/csh -f

echo "test_it $argv[*]"

set rel = "$argv[1]"
set bld = "$argv[2]"
set dir = "$argv[3]"

if ( $#argv > 3 ) then
    set var = "$argv[4]"
else
    set var = ''
endif

./kerl emit-activate "$rel" "$bld" "$dir" csh >/tmp/activate.csh

if ( "$var" == rebar_plt ) then
    set REBAR_PLT_DIR = "plt dir"
endif

if ( "$var" == rebar_cache ) then
    set REBAR_CACHE_DIR = "cache dir"
endif

./tests/dump_env.csh "$bld" "$dir" "$var"

diff /tmp/exp_prompt /tmp/act_prompt
if ( $status > 0 ) then
    echo "prompt setup failed"
    exit 1
endif

diff /tmp/old_prompt /tmp/new_prompt
if ( $status > 0 ) then
    echo "prompt cleanup failed"
    exit 1
endif

diff /tmp/env_exp /tmp/env_act
if ( $status > 0 ) then
    echo "env setup failed"
    exit 1
endif

diff /tmp/env_old /tmp/env_new
if ( $status > 0 ) then
    echo "env cleanup failed"
    exit 1
endif
