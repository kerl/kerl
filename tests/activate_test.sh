#!/bin/sh

expected_env() {
    DIR="$1"
    OLD="$2"
    grep "$OLD" -wv -e PATH -e MANPATH -e PS1
    cat - <<EOT
_KERL_ACTIVE_DIR=$DIR
_KERL_ERL_AFLAGS_SET=
_KERL_MANPATH_REMOVABLE=$DIR/lib/erlang/man:$DIR/man
_KERL_PATH_REMOVABLE=$DIR/bin
_KERL_REBAR_CACHE_DIR_SET=
_KERL_REBAR_PLT_DIR_SET=
_KERL_SAVED_REBAR_CACHE_DIR=
_KERL_SAVED_REBAR_PLT_DIR=
ERL_AFLAGS=-kernel shell_history enabled
MANPATH=$DIR/lib/erlang/man:$DIR/man:$MANPATH
PS1=$PS1
REBAR_CACHE_DIR=$DIR/.cache/rebar3
REBAR_PLT_DIR=$DIR
EOT
    if grep -qw MANPATH "$OLD"; then
        echo "_KERL_MANPATH_SET=x"
    else
        echo "_KERL_MANPATH_SET="
    fi
    ERLCALLDIR=$(\find "$DIR" -type d -path "*erl_interface*/bin" 2>/dev/null)
    if [ -n "$ERLCALLDIR" ]; then
        echo "_KERL_ERL_CALL_REMOVABLE=$ERLCALLDIR"
        echo "PATH=$ERLCALLDIR:$DIR/bin:$PATH"
    else
        echo "_KERL_ERL_CALL_REMOVABLE="
        echo "PATH=$DIR/bin:$PATH"
    fi
}

test_it() {
    release=$1
    build_name=$2
    directory=$3
    ./kerl emit-activate "$release" "$build_name" "$directory" >/tmp/activate.sh
    export PS1="test> "
    env | sort >/tmp/env_old
    # shellcheck source=/dev/null
    . /tmp/activate.sh
    env | sort >/tmp/env_act
    kerl_deactivate
    env | sort >/tmp/env_new

    expected_env "$directory" /tmp/env_old | sort >/tmp/env_exp
    diff /tmp/env_exp /tmp/env_act || { echo "env setup failed"; exit 1; }
    diff /tmp/env_old /tmp/env_new || { echo "env cleanup failed"; exit 1; }
}

release=$1
build_name=$2
directory=$3

[ -d "$directory" ] || exit 1

test_it "$release" "$build_name" "$directory"
test_it foo boo foo_dir
