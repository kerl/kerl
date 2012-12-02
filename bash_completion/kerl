# bash_completion for kerl

_kerl()
{
    local cur prev
    _get_comp_words_by_ref cur prev

    case $prev in
        kerl)
            COMPREPLY=( $( compgen -W "build install update list delete active status" -- "$cur" ) )
            ;;
        list)
            COMPREPLY=( $( compgen -W "releases builds installations" -- "$cur" ) )
            ;;
        build)
            if [ "$COMP_CWORD" -eq 2 ]; then
                if [ -f "$HOME/.kerl/otp_releases" ]; then
                    RELEASES=`cat "$HOME/.kerl/otp_releases"`
                fi
                COMPREPLY=( $( compgen -W "git $RELEASES" -- "$cur") )
            else
                if [ -f "$HOME/.kerl/otp_builds" ]; then
                    BUILDS=`cat "$HOME/.kerl/otp_builds" | cut -d "," -f 2`
                fi
                COMPREPLY=( $( compgen -W "$BUILDS" -- "$cur") )
            fi
            ;;
        installation)
            if [ -f "$HOME/.kerl/otp_installations" ]; then
                PATHS=`cat "$HOME/.kerl/otp_installations" | cut -d " " -f 2`
            fi
            COMPREPLY=( $( compgen -W "$PATHS" -- "$cur") )
            ;;
        install)
            if [ -f "$HOME/.kerl/otp_builds" ]; then
                BUILDS=`cat "$HOME/.kerl/otp_builds" | cut -d "," -f 2`
            fi
            COMPREPLY=( $( compgen -W "$BUILDS" -- "$cur") )
            ;;
         deploy)
            if [ "$COMP_CWORD" -eq 3 ]; then
                if [ -f "$HOME/.kerl/otp_installations" ]; then
                    PATHS=`cat "$HOME/.kerl/otp_installations" | cut -d " " -f 2`
                fi
            fi
            COMPREPLY=( $( compgen -W "$PATHS" -- "$cur") )
            ;;
        delete)
            COMPREPLY=( $( compgen -W "build installation $words" -- "$cur") )
            ;;
        update)
            COMPREPLY=( $( compgen -W "releases" -- "$cur") )
            ;;
        *)
            if [ "$COMP_CWORD" -eq 3 ]; then
                if [ -f "$HOME/.kerl/otp_builds" ]; then
                    BUILDS=`cat "$HOME/.kerl/otp_builds" | cut -d "," -f 2`
                fi
                if [ -n "$BUILDS" ]; then
                    for b in $BUILDS; do
                        if [ "$prev" = "$b" ]; then
                            _filedir
                            return 0
                        fi
                    done
                fi
            fi
            ;;
    esac
}
complete -F _kerl kerl

