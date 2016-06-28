kerl
====

Easy building and installing of [Erlang/OTP](http://www.erlang.org) instances

Kerl aims to be shell agnostic and its only dependencies, excluding what's required to actually build Erlang/OTP, are `curl` and `git`.

All is done so that, once a specific release has been built, creating a new installation is as fast as possible.

Downloading
-----------

You can download the script directly from github:

    $ curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl

Then ensure it is executable

    $ chmod a+x kerl

and drop it in your $PATH

Optionally download and install kerl's bash_completion file from https://github.com/kerl/kerl/raw/master/bash_completion/kerl

Optionally download and install kerl's zsh-completion file from https://github.com/kerl/kerl/raw/master/zsh_completion/_kerl


How it works
------------

Kerl keeps tracks of the releases it downloads, builds and installs, allowing
easy installations to new destinations (without complete rebuilding) and easy
switches between Erlang/OTP installations.

By default, kerl downloads source tarballs from the [official Erlang website](http://www.erlang.org), but
you can tell kerl to download tarballs of Erlang source code from the tags
pushed to the [official source code](https://github.com/erlang/otp) by setting `KERL_BUILD_BACKEND=git`

Usage
-----

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

(Note that kerl uses the otp_build script internally, and `./otp_build configure` disables HiPE on linux)

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

Activation will backup your $PATH, prepend it with the installation's bin/
directory. Thus it's only valid for the current shell session, and until you
activate another installation or call `kerl_deactivate`.

You're now ready to work with your r14b02 installation:

    $ erl -version
    Erlang (SMP,ASYNC_THREADS,HIPE) (BEAM) emulator version 5.8.3

When you're done just call the shell function:

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

You can easily deploy an installation to another host having `ssh` and `rsync` access with the following command:

    $ kerl deploy anotherhost /path/to/install/dir
    Cloning Erlang/OTP r14b02 (/path/to/install/dir) to anotherhost (/path/to/install/dir) ...
    On anotherhost, you can activate this installation running the following command:
    . /path/to/install/dir/activate
    Later on, you can leave the installation typing:
    kerl_deactivate

Building from a git source
--------------------------

You can build Erlang directly from a git repository with a command of the form
`kerl build git <git_url> <git_version> <build_name>` where `<git_version>` can
be either a branch, a tag or a commit id that will be passed to `git checkout`:

    $ kerl build git https://github.com/erlang/otp.git dev r14b02_dev
    Checking Erlang/OTP git repositoy from https://github.com/erlang/otp.git...
    Building Erlang/OTP r14b02_dev from git, please wait...
    Erlang/OTP r14b02_dev from git has been successfully built

Tuning
------

You can tune kerl using the .kerlrc file in your $HOME directory.

You can set the following variables:

- `KERL_BUILD_BACKEND` which source code download provider to use - (`tarball` - default) erlang.org or github (`git`)
- `KERL_DOWNLOAD_DIR` where to put downloaded files, defaults to $HOME/.kerl/archives
- `KERL_BUILD_DIR` where to hold the builds, defaults to $HOME/.kerl/builds
- `KERL_DEFAULT_INSTALL_DIR` if set in ~/.kerlrc, install builds to this dir if no path is provided on installs, (recommend `$KERL_BASE_DIR/installs`)
- `KERL_CONFIGURE_OPTIONS` options to pass to Erlang's `./configure` script, e.g. `--without-termcap`
- `KERL_CONFIGURE_APPLICATIONS` if non-empty, subset of applications used in the builds (and subsequent installations) process, e.g. `kernel stdlib sasl`
- `KERL_CONFIGURE_DISABLE_APPLICATIONS` if non-empty, subset of applications disabled in the builds (and subsequent installations) process, e.g. `odbc`
- `KERL_SASL_STARTUP` use SASL system startup instead of minimal
- `KERL_DEPLOY_SSH_OPTIONS` if additional options are required, e.g. `-qx -o PasswordAuthentication=no`
- `KERL_DEPLOY_RSYNC_OPTIONS` if additional options are required, e.g. `--delete`
- `KERL_ENABLE_PROMPT` if set, the prompt will be prefixed with the name of the active build 
- `KERL_BUILD_DOCS` if set, will build documentation from source code repository
- `KERL_USE_AUTOCONF` use autoconf in the builds process (**note**: implied by the `git` build backend)

### Options for tarball builds only ###

These options only work when `KERL_BUILD_BACKEND=tarball` (the default) **and**
if `KERL_BUILD_DOCS` is not set. That is, they are *strictly* for backward
compatibility. They will probably be removed in a future release.

- `KERL_INSTALL_MANPAGES` if non-empty will install manpages into `/install/path/man`
- `KERL_INSTALL_HTMLDOCS` if non-empty will install HTML docs into `/install/path/html`

If you want documentation for git based builds, set `KERL_BUILD_DOCS=yes` - and if
you don't want to download 120MB of docs from erlang.org, also set `KERL_BUILD_DOCS=yes`

Note on .kerlrc
---------------

Since .kerlrc is a dot file for `/bin/sh`, running shell commands inside the
.kerlrc will affect the shell and environment variables for the commands being
executed later. For example, the shell `export` commands in .kerlrc will affect
*your login shell environment* when activating `curl`.  Use with care.

Glossary
--------

Here are the abstractions kerl is handling:

- **releases**: Erlang/OTP releases from [erlang.org](http://erlang.org)

- **builds**: the result of configuring and compiling releases or git repositories

- **installations**: the result of deploying builds to filesystem locations (also referred to as "sandboxes")

Commands reference
------------------

### build

    kerl build <release_code> <build_name>
    kerl build git <git_url> <git_version> <build_name>

Creates a named build either from an official Erlang/OTP release or from a git repository.

    $ kerl build R14B02 r14b02
    $ kerl build git https://github.com/erlang/otp dev r14b02_dev

#### Tuning

##### Configure options

You can specify the configure options to use when building Erlang/OTP with the
`KERL_CONFIGURE_OPTIONS` variable, either in your $HOME/.kerlrc file or
prepending it to the command line.

    $ KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build R14B02 r14b02_hipe

##### Configure applications

If non-empty, you can specify the subset of applications to use when building
(and subsequent installing) Erlang/OTP with the `KERL_CONFIGURE_APPLICATIONS`
variable, either in your $HOME/.kerlrc file or prepending it to the command
line.

    $ KERL_CONFIGURE_APPLICATIONS="kernel stdlib sasl" kerl build R15B01 r15b01_minimal

##### Configure disable applications

If non-empty, you can specify the subset of applications to disable when
building (and subsequent installing) Erlang/OTP with the
`KERL_CONFIGURE_DISABLE_APPLICATIONS` variable, either in your $HOME/.kerlrc
file or prepending it to the command line.

    $ KERL_CONFIGURE_DISABLE_APPLICATIONS="odbc" kerl build R16B02 r16b02_no_odbc

##### Enable autoconf

You can enable the use of `autoconf` in the build process setting
`KERL_USE_AUTOCONF=yes` in your $HOME/.kerlrc file

**Note**: `autoconf` is always enabled for git builds

##### Using shell export command in .kerlrc

Configure variables which includes spaces such as those in `CFLAGS` cannot be
passed on with `KERL_CONFIGURE_OPTIONS`. In such a case you can use shell
`export` command to define the environment variables for `./configure`. Note
well: this method has a side effect to change your shell execution environment
after activating a kerl installation of Erlang/OTP. Here is an example of
.kerlrc for building Erlang/OTP for FreeBSD with clang compiler:

    # for clang
    export CC=clang CXX=clang CFLAGS="-g -O3 -fstack-protector" LDFLAGS="-fstack-protector"
    # compilation options
    KERL_CONFIGURE_OPTIONS="--disable-native-libs --enable-vm-probes --with-dynamic-trace=dtrace --with-ssl=/usr/local --with-javac --enable-hipe --enable-kernel-poll --with-wx-config=/usr/local/bin/wxgtk2u-2.8-config --without-odbc --enable-threads --enable-sctp --enable-smp-support"

#### Building documentation

Prior to kerl 1.0, kerl always downloaded prepared documentation from erlang.org. Now 
if `KERL_BUILD_DOCS=yes` is set, kerl will build the man pages and HTML
documentation from the source repository in which is working.

**Note**: This variable takes precedent over the other documentation parameters. 

### install

    kerl install <build_name> [path]

Installs a named build to the specified filesystem location.

    $ kerl install r14b02 /srv/otp/r14b02

If path is omitted the current working directory will be used. However, if
`KERL_DEFAULT_INSTALL_DIR` is defined in ~/.kerlrc,
`KERL_DEFAULT_INSTALL_DIR/<build-name>` will be used instead.

#### Install location restrictions

**WARNING**: kerl assumes the given installation directory is for its sole use.
If you later delete it with the `kerl delete` command, the whole directory will
be deleted, along with anything you may have added to it!

So please only install kerl in an empty (or non-existant) directory.  

If you attempt to install kerl in `$HOME` or `.erlang` or `$KERL_BASE_DIR`,
then kerl will give you an error and refuse to proceed. If you try to install
kerl in a directory that exists and is not empty, kerl will give you an error.

#### Tuning

##### SASL startup

You can have SASL started automatically setting `KERL_SASL_STARTUP=yes` in your
$HOME/.kerlrc file or prepending it to the command line.

##### Manpages installation

You can have manpages installed automatically setting
`KERL_INSTALL_MANPAGES=yes` in your $HOME/.kerlrc file or prepending it to the
command line.

**Note**: for git-based builds, you want to set `KERL_BUILD_DOCS=yes`

##### HTML docs installation

You can have HTML docs installed automatically setting
`KERL_INSTALL_HTMLDOCS=yes` in your $HOME/.kerlrc file or prepending it to the
command line.

*Note*: for git-based builds, you want to set `KERL_BUILD_DOCS=yes`

#### Documentation installation

Man pages will be installed to `[path]/man` and HTML docs will be installed in
`[path]/html`.  The kerl `activate` script manipulates the MANPATH of the current
shell such that `man 3 gen_server` or `erl -man gen_server` should work perfectly.

(Do not fret - `kerl_deactivate` restores your shell's MANPATH to whatever its 
original value was.)

### deploy

    kerl deploy <[user@]host> [directory] [remote_directory]

Deploys the specified installation to the given host and location.

    $ kerl deploy anotherhost /path/to/install/dir

If remote_directory is omitted the specified directory will be used.

If directory and remote_directory is omitted the current working directory will be used.

*NOTE*: kerl assumes the specified host is accessible via `ssh` and `rsync`.

#### Tuning

##### Additional SSH options

You can have additional options given to `ssh` by setting them in the
`KERL_DEPLOY_SSH_OPTIONS` variable in your $HOME/.kerlrc file or on the command
line, e.g. `KERL_DEPLOY_SSH_OPTIONS='-qx -o PasswordAuthentication=no'`.

##### Additional RSYNC options

You can have additional options given to `rsync` by setting them in the
`KERL_DEPLOY_RSYNC_OPTIONS` variable in your $HOME/.kerlrc file or on the
command line, e.g. `KERL_DEPLOY_RSYNC_OPTIONS='--delete'`.

### update

    kerl update releases

If `KERL_BUILD_BACKEND=tarball` this command fetches the up-to-date list of OTP
releases from erlang.org.

If it is set to `KERL_BUILD_BACKEND=git` this command fetches an up-to-date
list of OTP tags from the official OTP github repository.

### list

    kerl list <releases|builds|installations>

Lists the releases, builds or installations available.

### delete

    kerl delete build <build_name>
    kerl delete installation <path>

Deletes the specified build or installation.

```
$ kerl delete build r14b02
The r14b02 build has been deleted
```

```
$ kerl delete installation /srv/otp/r14b02
The installation in /srv/otp/r14b02 has been deleted
```

### active

    kerl active

Prints the path of the currently active installation, if any.

    $ kerl active
    The current active installation is:
    /srv/otp/r14b02

### status

    kerl status

Prints the available builds and installations as well as the currently active installation.

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

Changelog
---------

28 June 2016 - 1.2.0

  - Make curl output more robust if using a .curlrc (#137)
  - Apply patches to build older Erlangs (#138) 
  - Add a command to output a version string (#140)
  - Do not assume success for metadata file writes (#142)
  - Fix a grammar problem (#145)

20 May 2016 - 1.1.1

  - Remove valid directory check when doing a remote deployment.
  - Various get_otp_version() regex cleanup/fixes

14 May 2016 - 1.1.0

  - Remove support for Mac OS X Lion. Stop setting CFLAGS for better compiler
    optimizations. (#132)

14 May 2016 - 1.0.1

  - Be much more careful about installing into and removing directories. (#127)
  - Make `OTP_GITHUB_URL` and `KERL_BUILD_BACKEND` controllable from .kerlrc (#130)

2 May 2016 - 1.0

  - Support builds from git tags (#122)
  - Support documentation builds/installs from source code (#126)
