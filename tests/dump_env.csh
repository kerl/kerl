#!/bin/csh -ef

set bld = "$argv[1]"
set dir = "$argv[2]"
set var = "$argv[3]"

printenv | sort >/tmp/env_old

if ( $?prompt ) then
    echo -n "$prompt" >/tmp/old_prompt
else
    echo -n >/tmp/old_prompt
endif

tests/expected_env.csh "$dir" "/tmp/env_old" | sort >/tmp/env_exp

if ( "$var" == enable_prompt ) then
    set KERL_ENABLE_PROMPT = yes
    echo -n "($bld)" | cat - /tmp/old_prompt >/tmp/exp_prompt
else
    cp /tmp/old_prompt /tmp/exp_prompt
endif

if ( "$var" == alter_manpath ) then
    if ( $?MANPATH ) then
        set manpath_set = yes
    else
        set manpath_set = no
    endif
endif

source /tmp/activate.csh

printenv | sort >/tmp/env_act

if ( $?prompt ) then
    echo -n "$prompt" >/tmp/act_prompt
else
    echo -n >/tmp/act_prompt
endif

if ( "$var" == alter_manpath ) then
    setenv MANPATH "extra path element:$MANPATH"
endif

kerl_deactivate

if ( $?prompt ) then
    echo -n "$prompt" >/tmp/new_prompt
else
    echo -n >/tmp/new_prompt
endif

if ( "$var" == alter_manpath ) then
    if ( "$manpath_set" == yes ) then
        printenv | sed -r 's#extra path element:?##' | sort >/tmp/env_new
    else
        printenv | grep -wv MANPATH | sort >/tmp/env_new
    endif
else
    printenv | sort >/tmp/env_new
endif
