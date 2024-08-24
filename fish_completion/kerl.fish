# Completion for kerl (https://github.com/kerl/kerl)

if ! set -q KERL_BASE_DIR
    set KERL_BASE_DIR $HOME/.kerl
end

set -l kerl_args build install build-install deploy update list delete path active plt status prompt cleanup emit-activate upgrade version
set -l kerl_list_args releases builds installations
set -l kerl_delete_args installation build

function kerl_otp_releases
    set -l file $KERL_BASE_DIR/otp_releases
    test -f $file && cat $file
end

function kerl_otp_builds
    set -l file $KERL_BASE_DIR/otp_builds
    test -f $file && cat $file | cut -f 2 -d ","
end

function kerl_otp_installations_names
    set -l file $KERL_BASE_DIR/otp_installations
    test -f $file && cat $file | cut -f 2 -d " "
end

function kerl_otp_installations_directories
    set -l file $KERL_BASE_DIR/otp_installations
    test -f $file && cat $file | cut -f 2 -d " " | xargs basename
end

function kerl_build_complete
    set -l cmd (commandline -poc)

    if test (count $cmd) -ge 3
        return 1
    end

    if test $cmd[2] = "build" && ! contains "delete" $cmd
        echo "git" && kerl_otp_releases
    end
end

function kerl_deploy_complete
    set -l cmd (commandline -poc)
    set -l arg_index (count $cmd)

    switch $arg_index
        case 2
            __fish_print_hostnames | uniq
        case 3
            kerl_otp_installations_names
        case '*'
            return 1
    end
end

function kerl_delete_complete
    set -l cmd (commandline -poc)
    set -l arg_index (count $cmd)

    switch $arg_index
        case 2
            printf "%s\t%s\n" build "Delete a specific build"
            printf "%s\t%s\n" installation "Delete a specific installation"
        case 3
            if test $cmd[$arg_index] = "build"
                kerl_otp_builds
            else if test $cmd[$arg_index] = "installation"
                kerl_otp_installations_names
            end
        case '*'
            return 1
    end
end

function kerl_emit_activate_complete
    set -l cmd (commandline -poc)
    set -l arg_index (count $cmd)

    switch $arg_index
        case 2
            kerl_otp_releases
        case 3
            kerl_otp_builds
        case 4
            kerl_otp_installations_names
        case 5
            printf "%s\n%s\n%s\n%s" sh bash fish csh
    end
end

complete -c kerl -f
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a build -d "Build specified release or git repository"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a install -d "Install the specified release at the given location"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a build-install -d "Builds and installs the specified release or git repository at the given location"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a deploy -d "Deploy the specified installation to the given host and location"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a update -d "Update the list of available releases from your source provider"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a list -d "List releases, builds and installations"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a delete -d "Delete builds and installations"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a path -d "Print the path of a given installation"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a active -d "Print the path of the active installation"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a plt -d "Print Dialyzer PLT path for the active installation"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a status -d "Print available builds and installations"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a prompt -d "Print a string suitable for insertion in prompt"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a cleanup -d "Remove compilation artifacts (use after installation)"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a emit-activate -d "Print the activate script"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a upgrade -d "Fetch and install the most recent kerl release"
complete -c kerl -n "not __fish_seen_subcommand_from $kerl_args" -a version -d "Print current version"


## build subcommand
complete -c kerl -n "__fish_seen_subcommand_from build" -a "(kerl_build_complete)"

## install command
complete -c kerl -n "__fish_seen_subcommand_from install && not __fish_seen_argument (kerl_otp_builds)" -a "(kerl_otp_builds)"
complete -c kerl -n "__fish_seen_subcommand_from install && __fish_seen_argument (kerl_otp_builds)" -a "(__fish_complete_directories)"

## build-install subcommand
complete -c kerl -n "__fish_seen_subcommand_from build-install && not __fish_seen_argument git (kerl_otp_releases)" -a "git (kerl_otp_releases)"
complete -c kerl -n "__fish_seen_subcommand_from build-install && __fish_seen_argument git (kerl_otp_releases)" -a "(__fish_complete_directories)"

## deploy subcommand
complete -c kerl -n "__fish_seen_subcommand_from deploy" -a "(kerl_deploy_complete)"

## update subcommand
complete -c kerl -n "__fish_seen_subcommand_from update && not __fish_seen_argument releases" -a "releases" -d "All available OTP releases"

## list subcommand
complete -c kerl -n "__fish_seen_subcommand_from list && not __fish_seen_argument $kerl_list_args" -a releases -d "Available OTP releases"
complete -c kerl -n "__fish_seen_subcommand_from list && not __fish_seen_argument $kerl_list_args" -a builds -d "All locally built OTP releases"
complete -c kerl -n "__fish_seen_subcommand_from list && not __fish_seen_argument $kerl_list_args" -a installations -d "All locally installed OTP builds"

## delete subcommand
complete -c kerl -n "__fish_seen_subcommand_from delete" -a "(kerl_delete_complete)"

## path subcommand
complete -c kerl -n "__fish_seen_subcommand_from path && not __fish_seen_argument (kerl_otp_installations_directories)" -a "(kerl_otp_installations_directories)"

## cleanup subcommand
complete -c kerl -n "__fish_seen_subcommand_from cleanup && not __fish_seen_argument all (kerl_otp_builds)"  -a "all (kerl_otp_builds)"

## emit-activate
complete -c kerl -n '__fish_seen_subcommand_from emit-activate' -a "(kerl_emit_activate_complete)"
