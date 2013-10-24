kerl
====

Easy building and installing of [Erlang/OTP](http://www.erlang.org) instances

Kerl aims to be shell agnostic and its only dependencies, excluding what's required to actually build Erlang/OTP, are curl and git.

All is done so that, once a specific release has been built, creating a new installation is as fast as possible.

Downloading
===========

You can download the script directly from github:

    $ curl -O https://raw.github.com/spawngrid/kerl/master/kerl

Then ensure it is executable

    $ chmod a+x kerl

and drop it in your $PATH

Optionally download and install kerl's bash_completion file from https://github.com/spawngrid/kerl/raw/master/bash_completion/kerl

How it works
============

Kerl keeps tracks of the releases it downloaded, built and installed,
allowing easy installations to new destinations (without complete rebuilding) and easy switches between Erlang/OTP installations.

Usage
=====

List the available releases (kerl ignores releases < 10):

    $ kerl list releases
    Getting the available releases from erlang.org...
    R10B-0 R10B-2 R10B-3 R10B-4 R10B-5 R10B-6 R10B-7 R10B-8 R10B-9 R11B-0 R11B-1
    R11B-2 R11B-3 R11B-4 R11B-5 R12B-0 R12B-1 R12B-2 R12B-3 R12B-4 R12B-5 R13A
    R13B R13B01 R13B02 R13B03 R13B04 R14A R14B R14B01 R14B02
    Run "./kerl update releases" to update this list from erlang.org

Pick your choice and build it:

    $ kerl build R14B02 r14b02
    Downloading otp_src_R14B02.tar.gz to /home/evax/.kerl/archives
    (curl progresses...)
    Verifying archive checksum...
    (curl progresses...)
    Checksum verified (229fb8f193b09ac04a57a9d7794349b7)
    Extracting source code
    Building Erlang/OTP R14B02 (r14b02), please wait...
    Erlang/OTP R14B02 has been successfully built

Note that named builds allow you to have different builds for the same Erlang/OTP release with different configure options:

    $ KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build R14B02 r14b02_hipe
    Verifying archive checksum...
    Checksum verified (229fb8f193b09ac04a57a9d7794349b7)
    Extracting source code
    Building Erlang/OTP R14B02 (r14b02_hipe), please wait...
    Erlang/OTP R14B02 (r14b02_hipe) has been successfully built

(Note that kerl uses the otp_build script internally, and './otp_build configure' disables HiPE on linux)

You can verify your build has been registered:

    $ kerl list builds
    R14B02,r14b02
    R14B02,r14b02_hipe

Now install a build to some location:

    $ kerl install r14b02 /path/to/install/dir/
    Installing Erlang/OTP R14B02 (r14b02) in /path/to/install/dir...
    You can activate this installation running the following command:
    . /path/to/install/dir/activate
    Later on, you can leave the installation typing:
    kerl_deactivate

Here again you can check the installation's been registered:

    $ kerl list installations
    r14b02 /path/to/install/dir

And at last activate it:

    $ . /path/to/install/dir/activate

Activation will backup your $PATH, prepend it with the installation's bin/ directory. Thus it's only valid for the current shell session, and until you activate another installation or call kerl_deactivate.

You're now ready to work with your r14b02 installation:

    $ erl -version
    Erlang (SMP,ASYNC_THREADS,HIPE) (BEAM) emulator version 5.8.3

When you're done just type:
    $ kerl_deactivate

Anytime you can check which installation, if any, is currently active with:

    $ kerl active
    No Erlang/OTP kerl installation is currently active

You can get an overview of the current kerl state with:

    $ kerl status
    Available builds:
    R14B02,r14b02
    R14B02,r14b02_hipe
    ----------
    Available installations:
    r14b02 /path/to/install/dir
    ----------
    Currently active installation:
    The current active installation is:
    /path/to/install/dir

You can delete builds and installations with the following commands:

    $ kerl delete build r14b02
    The r14b02 build has been deleted

    $ kerl delete installation /path/to/install/dir
    The installation in /path/to/install/dir has been deleted

You can easily deploy an installation to another host having ssh and rsync access with the following command:

    $ kerl deploy anotherhost /path/to/install/dir

    Cloning Erlang/OTP r14b02 (/path/to/install/dir) to anotherhost (/path/to/install/dir) ...
    On anotherhost, you can activate this installation running the following command:
    . /path/to/install/dir/activate
    Later on, you can leave the installation typing:
    kerl_deactivate

As an experimental feature, you can build Erlang directly from a git repository with a command of the form "kerl build git <git_url> <git_version> <build_name>" where <git_version> can be either a branch, a tag or a commit id as it will be passed to "git checkout":

    $ kerl build git https://github.com/erlang/otp.git dev r14b02_dev
    Checking Erlang/OTP git repositoy from https://github.com/erlang/otp.git...
    Building Erlang/OTP r14b02_dev from git, please wait...
    Erlang/OTP r14b02_dev from git has been successfully built

Tuning
======

You can tune kerl using the .kerlrc file in your $HOME directory.

You can set the following variables:

- KERL_DOWNLOAD_DIR where to put downloaded files, defaults to $HOME/.kerl/archives
- KERL_BUILD_DIR where to hold the builds, defaults to $HOME/.kerl/builds
- KERL_DEFAULT_INSTALL_DIR if set in ~/.kerlrc, install builds to this dir if no path is provided on installs, (recommend "$KERL_BASE_DIR/installs")
- KERL_CONFIGURE_OPTIONS options to pass to Erlang's ./configure script, e.g. --without-termcap
- KERL_CONFIGURE_APPLICATIONS if non-empty, subset of applications used in the builds (and subsequent installations) process, e.g. "kernel stdlib sasl"
- KERL_CONFIGURE_DISABLE_APPLICATIONS if non-empty, subset of applications disabled in the builds (and subsequent installations) process, e.g. "odbc"
- KERL_SASL_STARTUP use SASL system startup instead of minimal
- KERL_USE_AUTOCONF use autoconf in the builds process
- KERL_INSTALL_MANPAGES if non-empty will install manpages
- KERL_INSTALL_HTMLDOCS if non-empty will install HTML docs
- KERL_DEPLOY_SSH_OPTIONS if additional options are required, e.g. "-qx -o PasswordAuthentication=no"
- KERL_DEPLOY_RSYNC_OPTIONS if additional options are required, e.g. "--delete"
- KERL_ENABLE_PROMPT if set, the prompt will be prefixed with the name of the active build 

Glossary
========

Here are the abstractions kerl is handling:

- **releases**: Erlang/OTP releases from [erlang.org](http://erlang.org)

- **builds**: the result of configuring and compiling releases or git repositories

- **installations**: the result of deploying builds to filesystem locations (also referred to as "sandboxes")

Commands reference
==================

build
-----

Create a named build either from an official Erlang/OTP release or from a git repository

### Syntax

    kerl build <release_code> <build_name>
    kerl build git <git_url> <git_version> <build_name>

### Examples

    $ kerl build R14B02 r14b02
    $ kerl build git https://github.com/erlang/otp dev r14b02_dev

### Tuning

#### Configure options

You can specify the configure options to use when building Erlang/OTP with the KERL_CONFIGURE_OPTIONS variable, either in your $HOME/.kerlrc file or prepending it to the command line.

    $ KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build R14B02 r14b02_hipe

#### Configure applications

If non-empty, you can specify the subset of applications to use when building (and subsequent installing) Erlang/OTOP with the KERL_CONFIGURE_APPLICATIONS variable, either in your $HOME/.kerlrc file or prepending it to the command line.

    $ KERL_CONFIGURE_APPLICATIONS="kernel stdlib sasl" kerl build R15B01 r15b01_minimal

#### Configure disable applications

If non-empty, you can specify the subset of applications to disable when building (and subsequent installing) Erlang/OTOP with the KERL_CONFIGURE_DISABLE_APPLICATIONS variable, either in your $HOME/.kerlrc file or prepending it to the command line.

    $ KERL_CONFIGURE_DISABLE_APPLICATIONS="odbc" kerl build R16B02 r16b02_no_odbc

#### Enable autoconf

You can enable the use of autoconf in the build process setting KERL_USE_AUTOCONF=yes in your $HOME/.kerlrc file

*Note*: autoconf is always enabled for git builds


install
-------

Install a named build to the specified filesystem location

### Syntax

    kerl install <build_name> [path]

If path is omitted the current working directory will be used. However, if KERL_DEFAULT_INSTALL_DIR is defined in ~/.kerlrc, KERL_DEFAULT_INSTALL_DIR/<build-name> will be used instead.

*Note*: kerl assumes the specified directory is for its sole use. If you later delete it with the kerl delete command, the whole directory will be deleted, along with anything you may have added to it!

### Example

    $ kerl install r14b02 /srv/otp/r14b02

### Tuning

#### SASL startup

You can have SASL started automatically setting KERL_SASL_STARTUP=yes in your $HOME/.kerlrc file or prepending it to the command line

#### Manpages installation

You can have manpages installed automatically setting KERL_INSTALL_MANPAGES=yes in your $HOME/.kerlrc file or prepending it to the command line

*Note*: for git-based builds, kerl downloads and installs the newest official manpages which may or may not correspond to the contents of your local build.

#### HTML docs installation

You can have HTML docs installed automatically setting KERL_INSTALL_HTMLDOCS=yes in your $HOME/.kerlrc file or prepending it to the command line

*Note*: for git-based builds, kerl downloads and installs the newest official HTML docs which may or may not correspond to the contents of your local build.

deploy
------

Deploy the specified installation to the given host and location

### Syntax

    kerl deploy <[user@]host> [directory] [remote_directory]

If remote_directory is omitted the specified directory will be used.

If directory and remote_directory is omitted the current working directory will be used.

*NOTE*: kerl assumes the specified host is accessible via ssh and rsync.

### Example

    $ kerl deploy anotherhost /path/to/install/dir

### Tuning

#### Additional SSH options

You can have additional options given to SSH by setting them in the KERL_DEPLOY_SSH_OPTIONS variable in your $HOME/.kerlrc file or on the command line, e.g. KERL_DEPLOY_SSH_OPTIONS="-qx -o PasswordAuthentication=no"

#### Additional RSYNC options

You can have additional options given to RSYNC by setting them in the KERL_DEPLOY_RSYNC_OPTIONS variable in your $HOME/.kerlrc file or on the command line, e.g. KERL_DEPLOY_RSYNC_OPTIONS="--delete"

update
------

Update the list of releases

### Syntax

    kerl update releases

list
----

List the releases, builds or installations available

### Syntax

    kerl list <releases|builds|installations>

delete
------

Delete the specified build or installation

### Syntax

    kerl delete build <build_name>
    kerl delete installation <path>

### Examples

    $ kerl delete build r14b02
    The r14b02 build has been deleted
    $ kerl delete installation /srv/otp/r14b02
    The installation in /srv/otp/r14b02 has been deleted

active
------

Print the path of the currently active installation, if any

### Example

    $ kerl active
    The current active installation is:
    /srv/otp/r14b02

status
------

Print the available builds and installations as well as the currently active installation

### Example

    $ kerl status
    Available builds:
    R14B02,r14b02
    git,r14b02_dev
    ----------
    Available installations:
    r14b02 /srv/otp/r14b02
    r14b02 /srv/otp/r14b02_dev
    ----------
    No Erlang/OTP kerl installation is currently active

