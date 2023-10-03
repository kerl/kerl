#!/bin/csh -ef

set DIR = "$argv[1]"
set OLD = "$argv[2]"

grep "$OLD" -wv -e PATH -e MANPATH -e REBAR_CACHE_DIR -e REBAR_PLT_DIR
echo "REBAR_CACHE_DIR=$DIR/.cache/rebar3"
echo "REBAR_PLT_DIR=$DIR"

if ( $?MANPATH ) then
    if ( $MANPATH != "" ) then
        echo "MANPATH=$DIR/lib/erlang/man:$DIR/man:$MANPATH"
    else
        echo "MANPATH=$DIR/lib/erlang/man:$DIR/man"
    endif
else
    echo "MANPATH=$DIR/lib/erlang/man:$DIR/man"
endif

set ERLCALLDIR = `sh -c "find '$DIR' -type d -path '*erl_interface*/bin' 2>/dev/null || true"`
if ( "$ERLCALLDIR" != "" ) then
    echo "PATH=${ERLCALLDIR}:$DIR/bin:$PATH"
else
    echo "PATH=$DIR/bin:$PATH"
endif
