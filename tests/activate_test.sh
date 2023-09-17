#!/bin/sh

expected_env() {
    DIR="$1"
    OLD="$2"
    BLD="$3"
    grep "$OLD" -wv -e PATH -e MANPATH -e PS1 -e REBAR_CACHE_DIR -e REBAR_PLT_DIR
    cat - <<EOT
_KERL_ACTIVE_DIR=$DIR
ERL_AFLAGS=-kernel shell_history enabled
REBAR_CACHE_DIR=$DIR/.cache/rebar3
REBAR_PLT_DIR=$DIR
EOT
    if [ -n "$KERL_ENABLE_PROMPT" ]; then
        echo "PS1=($BLD)$PS1"
    fi
    if [ -n "$MANPATH" ]; then
        echo "MANPATH=$DIR/lib/erlang/man:$DIR/man:$MANPATH"
    else
        echo "MANPATH=$DIR/lib/erlang/man:$DIR/man"
    fi
    ERLCALLDIR=$(\find "$DIR" -type d -path "*erl_interface*/bin" 2>/dev/null)
    if [ -n "$ERLCALLDIR" ]; then
        echo "PATH=$ERLCALLDIR:$DIR/bin:$PATH"
    else
        echo "PATH=$DIR/bin:$PATH"
    fi
}

test_it() (
    release=$1
    build_name=$2
    directory=$3
    variant=$4

    ./kerl emit-activate "$release" "$build_name" "$directory" >/tmp/activate.sh

    if [ "$variant" = rebar_plt ]; then
        REBAR_PLT_DIR="plt dir"
        export REBAR_PLT_DIR
    fi

    if [ "$variant" = rebar_cache ]; then
        REBAR_CACHE_DIR="cache dir"
        export REBAR_CACHE_DIR
    fi

    env | sort >/tmp/env_old

    if [ "$variant" = enable_prompt ]; then
        KERL_ENABLE_PROMPT=yes
        export KERL_ENABLE_PROMPT
    fi

    expected_env "$directory" /tmp/env_old "$build_name" | sort >/tmp/env_exp

    if [ "$variant" = alter_manpath ]; then
        if [ -n "${MANPATH+x}" ]; then
            manpath_set=yes
        else
            manpath_set=no
        fi
    fi

    # shellcheck source=/dev/null
    . /tmp/activate.sh
    env | sort >/tmp/env_act

    if [ "$variant" = alter_manpath ]; then
        MANPATH="extra path element:$MANPATH"
        export MANPATH
    fi

    kerl_deactivate

    if [ "$variant" = alter_manpath ]; then
        if [ "$manpath_set" = yes ]; then
            env | sed -r 's#extra path element:?##' | sort >/tmp/env_new
        else
            env | grep -wv MANPATH | sort >/tmp/env_new
        fi
    else
        env | sort >/tmp/env_new
    fi

    diff /tmp/env_exp /tmp/env_act || { echo "env setup failed"; exit 1; }
    diff /tmp/env_old /tmp/env_new || { echo "env cleanup failed"; exit 1; }
)

release=$1
build_name=$2
directory=$3

[ -d "$directory" ] || exit 1

run_test() {
    test_it "$release" "$build_name" "$directory"
    test_it foo boo foo_dir
    test_it foo boo "foo dir"
    test_it foo boo "foo dir" alter_manpath
    test_it foo boo "foo dir" rebar_plt
    test_it foo boo "foo dir" rebar_cache
    test_it foo boo "foo dir" enable_prompt
    test_it foo "boo build" "foo dir" enable_prompt
}

run_test

# MANPATH manipulations
if [ -n "${MANPATH+x}" ]; then
    MANPATH_SAVE=$MANPATH
    if [ -n "$MANPATH" ]; then
        # shellcheck disable=SC1007
        MANPATH= run_test
        MANPATH=
        export MANPATH
        run_test
    else
        MANPATH=/man/path run_test
        MANPATH=/man/path
        export MANPATH
        run_test
    fi
    unset MANPATH
    run_test
    MANPATH=$MANPATH_SAVE
    export MANPATH
else
    # shellcheck disable=SC1007
    MANPATH= run_test
    MANPATH=
    export MANPATH
    run_test
    MANPATH=/man/path run_test
    MANPATH=/man/path
    export MANPATH
    run_test
    unset MANPATH
fi
