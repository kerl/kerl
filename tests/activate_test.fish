#!/usr/bin/env fish

function expected_env
    set DIR $argv[1]
    set OLD $argv[2]
    cat "$OLD" |grep -wv -e PATH -e MANPATH -e REBAR_CACHE_DIR -e REBAR_PLT_DIR
    echo "\
_KERL_ACTIVE_DIR=$DIR
_KERL_MANPATH_REMOVABLE=$DIR/lib/erlang/man $DIR/man
REBAR_CACHE_DIR=$DIR/.cache/rebar3
REBAR_PLT_DIR=$DIR\
"
    if test -n "$MANPATH"
        echo "MANPATH=$DIR/lib/erlang/man:$DIR/man:$MANPATH"
    else
        echo "MANPATH=$DIR/lib/erlang/man:$DIR/man"
    end
    set ERLCALLDIR (find "$DIR" -type d -path "*erl_interface*/bin" 2>/dev/null)
    if test -n "$ERLCALLDIR"
        echo "_KERL_PATH_REMOVABLE=$DIR/bin $ERLCALLDIR"
        echo "PATH=$DIR/bin:$ERLCALLDIR:$PATH"
    else
        echo "_KERL_PATH_REMOVABLE=$DIR/bin"
        echo "PATH=$DIR/bin:$PATH"
    end
end

function test_it
    set release $argv[1]
    set build_name $argv[2]
    set directory $argv[3]
    ./kerl emit-activate "$release" "$build_name" "$directory" fish >/tmp/activate.fish
    set -x REBAR_CACHE_DIR cache
    set -x REBAR_PLT_DIR plt
    set -x KERL_ENABLE_PROMPT yes
    env | sort >/tmp/env_old
    expected_env $directory /tmp/env_old | sort >/tmp/env_exp
    . /tmp/activate.fish
    env | sort >/tmp/env_act
    kerl_deactivate
    env | sort >/tmp/env_new
    fish -c '
        fish_prompt >/tmp/old_prompt
        source /tmp/activate.fish
        fish_prompt >/tmp/act_prompt
        kerl_deactivate
        fish_prompt >/tmp/new_prompt
    '
    diff /tmp/old_prompt /tmp/new_prompt
    # diff /tmp/old_prompt /tmp/act_prompt

    diff /tmp/env_exp /tmp/env_act || begin echo "env setup failed"; exit 1; end
    diff /tmp/env_old /tmp/env_new || begin echo "env cleanup failed"; exit 1; end
end

set release $argv[1]
set build_name $argv[2]
set directory $argv[3]

[ -d "$directory" ] || exit 1

test_it "$release" "$build_name" "$directory"
if set -q MANPATH
    if test -n "$MANPATH"
        MANPATH= test_it "$release" "$build_name" "$directory"
        set -gx MANPATH
        test_it "$release" "$build_name" "$directory"
    else
        MANPATH=/man/path test_it "$release" "$build_name" "$directory"
        set -gx MANPATH /man/path
        test_it "$release" "$build_name" "$directory"
    end
    set -e MANPATH
    test_it "$release" "$build_name" "$directory"
else
    MANPATH= test_it "$release" "$build_name" "$directory"
    set -gx MANPATH
    test_it "$release" "$build_name" "$directory"
    MANPATH=/man/path test_it "$release" "$build_name" "$directory"
    set -gx MANPATH /man/path
    test_it "$release" "$build_name" "$directory"
end

test_it foo boo foo_dir
test_it foo boo "foo dir"
