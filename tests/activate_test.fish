#!/usr/bin/env fish

function expected_env
    set -f DIR $argv[1]
    set -f OLD $argv[2]
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

function expected_prompt
    set -f BLD $argv[1]
    set -f OLD $argv[2]
    echo -n "($BLD)" | cat - "$OLD"
end

function test_it
    set -f release $argv[1]
    set -f build_name $argv[2]
    set -f directory $argv[3]
    set -f variant $argv[4]

    ./kerl emit-activate "$release" "$build_name" "$directory" fish >/tmp/activate.fish

    if test "$variant" = rebar_plt
        set -x REBAR_PLT_DIR "plt dir"
    end

    if test "$variant" = rebar_cache
        set -x REBAR_CACHE_DIR "cache dir"
    end

    if test "$variant" = enable_prompt
        set -x KERL_ENABLE_PROMPT yes
    end

    env | sort >/tmp/env_old
    expected_env $directory /tmp/env_old | sort >/tmp/env_exp

    if test "$variant" = alter_manpath
        if set -q MANPATH
            set manpath_set yes
        end
    end

    . /tmp/activate.fish

    env | sort >/tmp/env_act

    if test "$variant" = alter_manpath
        set -xp MANPATH "extra path element"
    end

    kerl_deactivate

    if test "$variant" = alter_manpath
        if set -q manpath_set
            env | sed -r 's#extra path element:?##' | sort >/tmp/env_new
        else
            env | grep -wv MANPATH | sort >/tmp/env_new
        end
    else
        env | sort >/tmp/env_new
    end

    fish -c '
        fish_prompt >/tmp/old_prompt
        source /tmp/activate.fish
        fish_prompt >/tmp/act_prompt
        kerl_deactivate
        fish_prompt >/tmp/new_prompt
    '

    if test "$variant" = enable_prompt
        expected_prompt $build_name /tmp/old_prompt >/tmp/exp_prompt
    else
        cp /tmp/old_prompt /tmp/exp_prompt
    end

    diff /tmp/exp_prompt /tmp/act_prompt || begin echo "prompt setup failed"; exit 1; end
    diff /tmp/old_prompt /tmp/new_prompt || begin echo "prompt cleanup failed"; exit 1; end

    diff /tmp/env_exp /tmp/env_act || begin echo "env setup failed"; exit 1; end
    diff /tmp/env_old /tmp/env_new || begin echo "env cleanup failed"; exit 1; end
end

set release $argv[1]
set build_name $argv[2]
set directory $argv[3]

[ -d "$directory" ] || exit 1

function run_test
    test_it "$release" "$build_name" "$directory"
    test_it foo boo foo_dir
    test_it foo boo "foo dir"
    test_it foo boo "foo dir" alter_manpath
    test_it foo boo "foo dir" rebar_plt
    test_it foo boo "foo dir" rebar_cache
    test_it foo boo "foo dir" enable_prompt
    test_it foo "boo build" "foo dir" enable_prompt
end

# MANPATH manipulations
run_test
if set -q MANPATH
    set -l MANPATH_SAVE $MANPATH
    if test -n "$MANPATH"
        MANPATH= run_test
        set -gx MANPATH
        run_test
    else
        MANPATH=/man/path run_test
        set -gx MANPATH /man/path
        run_test
    end
    set -e MANPATH
    run_test
    set -x MANPATH $MANPATH_SAVE
else
    MANPATH= run_test
    set -gx MANPATH
    run_test
    MANPATH=/man/path run_test
    set -gx MANPATH /man/path
    run_test
    set -e MANPATH
end
