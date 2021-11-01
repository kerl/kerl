kerl [![CircleCI](https://circleci.com/gh/kerl/kerl.svg?style=svg)](https://circleci.com/gh/kerl/kerl)
====

Easy building and installing of [Erlang/OTP](https://www.erlang.org) instances.

Kerl aims to be shell agnostic and its only dependencies, excluding what's
required to actually build Erlang/OTP, are `curl` and `git`.

All is done so that, once a specific release has been built, creating a new
installation is as fast as possible.

OTP Support Policy
------------------
As of 2021 September 17, we are supporting the current OTP release version
and 2 prior release versions (same as upstream OTP.) Older OTP releases
may or may not work. We will advance release support as new releases of OTP
become available.

Triage cadence
--------------
We triage kerl pull requests and issues at least once a month, typically on
the fourth Tuesday of the month at 1 pm US/Pacific or 8 pm UTC.

IRC channel
-----------
We have a channel on [Libera](https://web.libera.chat/gamja/) called `#kerl` -
feel free to join and ask support or implementation questions any time. If
no one is around, feel free to open an issue with your question or problem
instead.

Downloading
-----------

If you are on MacOS, and using [homebrew](https://github.com/Homebrew/brew),
you can install kerl, along with shell completion, by running:

    $ brew install kerl

Alternatively, you can download the script directly from github:

    $ curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl

Then ensure it is executable

    $ chmod a+x kerl

and drop it in your $PATH

Optionally download and install kerl's bash_completion file from
https://github.com/kerl/kerl/raw/master/bash_completion/kerl

Optionally download and install kerl's zsh-completion file from
https://github.com/kerl/kerl/raw/master/zsh_completion/_kerl


How it works
------------

Kerl keeps tracks of the releases it downloads, builds and installs, allowing
easy installations to new destinations (without complete rebuilding) and easy
switches between Erlang/OTP installations.

By default, kerl downloads source tarballs from the [official repository tags](https://github.com/erlang/otp/tags)
but you can tell kerl to download from the [official Erlang website](https://www.erlang.org/downloads) by setting `KERL_BUILD_BACKEND=tarball`.
However this website does not use HTTPS and is down more often than Github.

You can also install directly from a raw git repository by using the `kerl build git <git_url> <git_version> <build_name>` syntax.


Usage
-----

List the available releases (kerl ignores releases < 10):

    $ kerl list releases
    R10B-0 R10B-10 R10B-1a R10B-2 R10B-3 R10B-4 R10B-5 R10B-6 R10B-7 R10B-8 R10B-9 R11B-0 R11B-1 R11B-2 R11B-3 R11B-4 R11B-5 R12B-0 R12B-1 R12B-2 R12B-3 R12B-4 R12B-5 R13A R13B01 R13B02-1 R13B02 R13B03 R13B04 R13B R14A R14B01 R14B02 R14B03 R14B04 R14B R14B_erts-5.8.1.1 R15B01 R15B02 R15B02_with_MSVCR100_installer_fix R15B03-1 R15B03 R15B R16A_RELEASE_CANDIDATE R16B01 R16B02 R16B03-1 R16B03 R16B 17.0-rc1 17.0-rc2 17.0 17.1 17.3 17.4 17.5 18.0 18.1 18.2 18.2.1 18.3 19.0 19.1 19.2
    Run '/usr/local/bin/kerl update releases' to update this list from erlang.org

Pick your choice and build it:

    $ kerl build 19.2 19.2
    Verifying archive checksum...
    Checksum verified (7cdd18a826dd7bda0ca46d1c3b2efca6)
    Extracting source code
    Building Erlang/OTP 19.2 (19.2), please wait...
    Erlang/OTP 19.2 (19.2) has been successfully built

Note that named builds allow you to have different builds for the same Erlang/OTP release with different configure options:

    $ KERL_BUILD_DOCS=yes kerl build 19.2 19.2-builtdocs
    Verifying archive checksum...
    Checksum verified (7cdd18a826dd7bda0ca46d1c3b2efca6)
    Extracting source code
    Building Erlang/OTP 19.2 (19.2-builtdocs), please wait...
    Building docs...
    Erlang/OTP 19.2 (19.2-builtdocs) has been successfully built

(Note that kerl uses the otp_build script internally, and `./otp_build configure` disables HiPE on linux)

You can verify your build has been registered:

    $ kerl list builds
    19.2,19.2
    19.2,19.2-builtdocs

Now install a build to some location:

    $ kerl install 19.2 ~/kerl/19.2
    Installing Erlang/OTP 19.2 (19.2) in /Users/sanmiguel/kerl/19.2...
    You can activate this installation running the following command:
    . /Users/sanmiguel/kerl/19.2/activate
    Later on, you can leave the installation typing:
    kerl_deactivate

Here again you can check the installation's been registered:

    $ kerl list installations
    19.2 /Users/sanmiguel/kerl/19.2

And at last activate it:

    $ . /path/to/install/dir/activate

Activation will backup your $PATH, prepend it with the installation's bin/
directory. Thus it's only valid for the current shell session, and until you
activate another installation or call `kerl_deactivate`.

You're now ready to work with your 19.2 installation:

    $ erl -version
    Erlang (SMP,ASYNC_THREADS,HIPE) (BEAM) emulator version 8.2

When you're done just call the shell function:

    $ kerl_deactivate

Anytime you can check which installation, if any, is currently active with:

    $ kerl active
    The current active installation is:
    /Users/sanmiguel/kerl/19.2

You can get an overview of the current kerl state with:

    $ kerl status
    Available builds:
    19.2,19.2
    ----------
    Available installations:
    19.2 /Users/sanmiguel/kerl/19.2
    ----------
    The current active installation is:
    /Users/sanmiguel/kerl/19.2
    There's no Dialyzer PLT for the active installation

You can delete builds and installations with the following commands:

    $ kerl delete build 19.2
    The 19.2 build has been deleted
    $ kerl delete installation /path/to/install/dir
    The installation in /path/to/install/dir has been deleted

You can easily deploy an installation to another host having `ssh` and `rsync` access with the following command:

    $ kerl deploy anotherhost /path/to/install/dir
    Cloning Erlang/OTP 19.2 (/path/to/install/dir) to anotherhost (/path/to/install/dir) ...
    On anotherhost, you can activate this installation running the following command:
    . /path/to/install/dir/activate
    Later on, you can leave the installation typing:
    kerl_deactivate


Building from a github fork
---------------------------

It is possible to build Erlang from a github fork, by using the `KERL_BUILD_BACKEND=git` and setting `OTP_GITHUB_URL` to the URL of the fork. For example, to build Basho's OTP fork:

    $ export KERL_BUILD_BACKEND=git
    $ export OTP_GITHUB_URL='https://github.com/basho/otp'
    $ kerl update releases
    The available releases are:
    R13B03 R13B04 R14A R14B R14B01 R14B02 R14B03 R14B04 R15A R15B R15B01 R15B01_basho1 R15B01p R15B02 R15B03 R15B03-1 R16A_RELEASE_CANDIDATE R16B R16B01 R16B01_RC1 R16B02 R16B02_basho R16B02_basho10 R16B02_basho10rc1 R16B02_basho10rc2 R16B02_basho10rc3 R16B02_basho2 R16B02_basho3 R16B02_basho4 R16B02_basho5 R16B02_basho6 R16B02_basho7 R16B02_basho8 R16B02_basho9 R16B02_basho9rc1 R16B03 R16B03-1 R16B03_yielding_binary_to_term 17.0 17.0-rc1 17.0-rc2 17.0.1 17.0.2 17.1 17.1.1 17.1.2 17.2 17.2.1 17.2.2 17.3 17.3.1 17.3.2 17.3.3 17.3.4 17.4 17.4.1 17.5 17.5.1 17.5.2 17.5.3 17.5.4 17.5.5 17.5.6 17.5.6.1 17.5.6.2 17.5.6.3 17.5.6.4 17.5.6.5 17.5.6.6 17.5.6.7 17.5.6.8 17.5.6.9 18.0 18.0-rc1 18.0-rc2 18.0.1 18.0.2 18.0.3 18.1 18.1.1 18.1.2 18.1.3 18.1.4 18.1.5 18.2 18.2.1 18.2.2 18.2.3 18.2.4 18.2.4.1 18.3 18.3.1 18.3.2 18.3.3 18.3.4 18.3.4.1 19.0 19.0-rc1 19.0-rc2 19.0.2


From here (provided the `KERL_BUILD_BACKEND` and `OTP_GITHUB_URL` variables remain in place), it is possible to use kerl as normal:

    $ kerl build R16B02_basho10 16b02-basho10


Building from a git source
--------------------------

You can build Erlang directly from a git repository with a command of the form
`kerl build git <git_url> <git_version> <build_name>` where `<git_version>` can
be either a branch, a tag or a commit id that will be passed to `git checkout`:

    $ kerl build git https://github.com/erlang/otp.git dev 19.2_dev
    Checking Erlang/OTP git repository from https://github.com/erlang/otp.git...
    Building Erlang/OTP 19.2_dev from git, please wait...
    Erlang/OTP 19.2_dev from git has been successfully built


Tuning
------

You can tune kerl using the .kerlrc file in your $HOME directory.

## Locations on disk

### KERL_BASE_DIR

Default: `"$HOME"/.kerl`
Directory in which kerl will cache artefacts for building and installing.


### KERL_CONFIG

Default: `"$HOME"/.kerlrc`
File from which to source kerl configuration


### KERL_DOWNLOAD_DIR

Default: `${KERL_BASE_DIR}/archives`
Directory in which to place downloaded artefacts


### KERL_BUILD_DIR

Default: `${KERL_BASE_DIR}/builds`
Directory in which kerl will perform builds


### KERL_GIT_DIR

Default: `${KERL_BASE_DIR}/gits`
Directory in which kerl will clone git repositories for building.


## Build configuration

### KERL_CONFIGURE_OPTIONS

Space-separated options to pass to `configure` when building OTP.


### KERL_CONFIGURE_APPLICATIONS

Space-separated list of OTP applications which should exclusively be built.


### KERL_CONFIGURE_DISABLE_APPLICATIONS

Space-separated list of OTP applications to disable during building.


### KERL_BUILD_PLT

Create a PLT file alongside the built release.


### KERL_USE_AUTOCONF

Use `autoconf` during build process.
NB: Automatically enabled when using `KERL_BUILD_BACKEND=git`


### KERL_BUILD_BACKEND

Default value: `git`
Acceptable values: `tarball`, `git`

- `tarball`: Fetch erlang releases from erlang.org
- `git`: Fetch erlang releases from [`$OTP_GITHUB_URL`](#otp_github_url)

NB: Docs are only fetched when this is set to `tarball`. To enable creation of docs when set to `git`, one must also set [`$KERL_BUILD_DOCS`](#kerl_build_docs).

NB: This setting has no effect when using `kerl build git...`, which invokes kerl to directly clone a git repository and build from there.


### KERL_BUILD_DEBUG_VM

Allows building, alongside the regular VM, a debug VM (available via `cerl -debug`).
NB: Enable this build using `KERL_BUILD_DEBUG_VM=true`


### OTP_GITHUB_URL

Default value: `https://github.com/erlang/otp`
Acceptable value: any github fork of OTP, e.g. `https://github.com/basho/otp`


### KERL_BUILD_DOCS

If `$KERL_BUILD_DOCS` is set, kerl will create docs from the built erlang version regardless of origin (`tarball` backend from erlang.org or via `kerl build git`, or via `git` backend).

If `$KERL_BUILD_DOCS` is unset, kerl will only install docs when NOT installing a build created via `kerl build git...`, and according to `KERL_INSTALL_HTMLDOCS` and `KERL_INSTALL_MANPAGES`.

### KERL_DOC_TARGETS

Default: `chunks`
Available targets:
 - `man`: install manpage docs.
 - `html`: install HTML docs.
 - `pdf`: install PDF docs.
 - `chunks`: install chunnks format for get documentation from `erl`.

You can set multiple type of targets separated by space, example `$KERL_DOC_TARGETS="man html pdf chunks"`

### KERL_INSTALL_MANPAGES

Install man pages when not building from git source.

It's noteworthy that when not using `KERL_BUILD_DOCS=yes`, the docset that may be downloaded can be up to 120MB.


### KERL_INSTALL_HTMLDOCS

Install HTML documentation when not building from git source.

It's noteworthy that when not using `KERL_BUILD_DOCS=yes`, the docset that may be downloaded can be up to 120MB.


### KERL_SASL_STARTUP

Build OTP to use SASL startup instead of minimal (default, when var is unset).


## Installation configuration


## Activation configuration

The following apply when activating an installation (i.e. `. ${KERL_DEFAULT_INSTALL_DIR}/19.2/activate`).

### KERL_ENABLE_PROMPT

When set, automatically prefix the shell prompt with a section containing the erlang version (see [`$KERL_PROMPT_FORMAT`](#kerl_prompt_format) ).


### KERL_PROMPT_FORMAT

Default: `(%BUILDNAME%)`
Available variables:
 - `%BUILDNAME%`: Name of the kerl build (e.g. `my_test_build_18.0`)
 - `%RELEASE%`: Name of the erlang release (e.g. `19.2` or `R16B02`)

The format of the prompt section to add.


### KERL_DEFAULT_INSTALL_DIR

Effective when calling `kerl install <build>` with no installation location argument.

If unset, `$PWD` is used.

If set, install the build under `$KERL_DEFAULT_INSTALL_DIR/${buildname}`.


### KERL_DEPLOY_SSH_OPTIONS
### KERL_DEPLOY_RSYNC_OPTIONS

Options passed to `ssh` and `rsync` during `kerl deploy` tasks.

Note on .kerlrc
---------------

Since .kerlrc is a dot file for `/bin/sh`, running shell commands inside the
.kerlrc will affect the shell and environment variables for the commands being
executed later. For example, the shell `export` commands in .kerlrc will affect
*your login shell environment* when activating `curl`.  Use with care.

Fish shell support
------------------

kerl has basic support for the fish shell.

To activate an installation:

    source /path/to/install/dir/activate.fish

Deactivation is the same as in other shells:

    kerl_deactivate

Please note: if you've installed a build with an older version of kerl
(1.2.0 older) it won't have the `activate.fish` script.

C shell support
---------------

kerl has basic support for the C shells (csh/tcsh/etc.).

To activate an installation:

    source /path/to/install/dir/activate.csh

The activation script sources file .kerlrc.csh instead of .kerlrc.

Deactivation is the same as in other shells:

    kerl_deactivate

Please note: if you've installed a build with an older version of kerl
it won't have the `activate.csh` script.

Glossary
--------

Here are the abstractions kerl is handling:

- **releases**: Erlang/OTP releases from [erlang.org](https://erlang.org)

- **builds**: the result of configuring and compiling releases or git repositories

- **installations**: the result of deploying builds to filesystem locations (also referred to as "sandboxes")

Commands reference
------------------

### build

    kerl build <release_code> <build_name>
    kerl build git <git_url> <git_version> <build_name>

Creates a named build either from an official Erlang/OTP release or from a git repository.

    $ kerl build 19.2 19.2
    $ kerl build git https://github.com/erlang/otp dev 19.2_dev

#### Tuning

##### Configure options

You can specify the configure options to use when building Erlang/OTP with the
`KERL_CONFIGURE_OPTIONS` variable, either in your $HOME/.kerlrc file or
prepending it to the command line.  Full list of all options can be in
[Erlang documentation](https://erlang.org/doc/installation_guide/INSTALL.html#Advanced-configuration-and-build-of-ErlangOTP_Configuring).

    $ KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build 19.2 19.2-hipe

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


In case you cannot access the default directory for temporary files (`/tmp`) or simply want them somewhere else, you can also provide your own directory with the variable `TMP_DIR`

    export TMP_DIR=/your/custom/temporary/dir

#### Building documentation

Prior to kerl 1.0, kerl always downloaded prepared documentation from erlang.org. Now if `KERL_BUILD_DOCS=yes` is set, kerl will build the man pages and HTML
documentation from the source repository in which is working.

**Note**: This variable takes precedent over the other documentation parameters. 

### install

    kerl install <build_name> [path]

Installs a named build to the specified filesystem location.

    $ kerl install 19.2 /srv/otp/19.2

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
$ kerl delete build 19.2
The 19.2 build has been deleted
```

```
$ kerl delete installation /srv/otp/19.2
The installation in /srv/otp/19.2 has been deleted
```

### active

    kerl active

Prints the path of the currently active installation, if any.

    $ kerl active
    The current active installation is:
    /srv/otp/19.2

### status

    kerl status

Prints the available builds and installations as well as the currently active installation.

    $ kerl status
    Available builds:
    19.2,19.2
    git,19.2_dev
    ----------
    Available installations:
    19.2 /srv/otp/19.2
    19.2 /srv/otp/19.2_dev
    ----------
    No Erlang/OTP kerl installation is currently active

### path

    kerl path [installation]

Prints the path of the currently active installation if one is active. When given an
installation name, it will return the path to that installation location on disk.
This makes it useful for automation without having to run kerl's output through
other tools to extract to path information.

    $ kerl path
    No active kerl-managed erlang installation

    $ kerl path 19.2.3
    /aux/erlangs/19.2.3

### install-docsh

    kerl install-docsh

**Important note**: docsh only supports OTP versions 18 and later.

Install `erl` shell documentation access
extension - [docsh](https://github.com/erszcz/docsh).
This extends the shell with new helpers, which enable access to full
function help (via `h/{1,2,3}`), function specs (`s/{1,2,3}`) and type
information (`t/{1,2,3}`).

If you already have an OTP installation, you will need to remove it and
re-install it **before** you execute `install-docsh`,
since docsh needs some environment variables of its own to be set up
and managed by the activate script.

Activating a docsh-enabled Erlang installation will try to create
a `$HOME/.erlang` symlink.
If this file exists (i.e. you have created it manually),
please consider removing it - otherwise, docsh won't work.
Deactivating the kerl Erlang installation will remove the symlink.

Alternatively, if the file exists and you have to keep it you can extend
it with the content of [a docsh-specific `.erlang`][docsh-dot-erlang] - this
task is left as an exercise for the reader - and export
`KERL_DOCSH_DOT_ERLANG=exists` to silence unwanted warnings.
The [manual setup guide][docsh-manual-setup] will probably come in handy
if you decide to take this route.

[docsh-dot-erlang]: https://github.com/erszcz/docsh/blob/2d9843bce794e726f591bbca49c88aedbb435f8c/templates/dot.erlang
[docsh-manual-setup]: https://github.com/erszcz/docsh/blob/ecf35821610977e36b04c0c256990a5b0dab4870/doc/manual-setup.md

Compiling crypto on Macs
------------------------
Apple stopped shipping OpenSSL in OS X 10.11 (El Capitan) in favor of Apple's
own SSL library. That makes using homebrew the most convenient way to install
openssl on macOS 10.11 or later. Additionally, homebrew [stopped creating](https://github.com/Homebrew/brew/pull/612)
symlinks from the homebrew installation directory to `/usr/local`, so in
response to this, *if* you're running El Capitan, Sierra, or High Sierra
*and* you have homebrew installed, *and* you used it to install openssl,
kerl will ask homebrew for the openssl installation prefix and configure Erlang
to build with that location automatically.

**Important**: If you already have `--with-ssl` in your .kerlrc, kerl
will honor that instead, and will not do any automatic configuration.

Compiling crypto on Red Hat systems
-----------------------------------
Red Hat believes there's a [patent
issue](https://bugzilla.redhat.com/show_bug.cgi?id=319901#c2) and has disabled
elliptic curve crypto algorithms in its distributions for over 10 years.

This causes Erlang builds to die when its compiling its own crypto libraries.

As a workaround, you can set `CFLAGS="-DOPENSSL_NO_EC=1"` to tell the
Erlang crypto libraries to not build the elliptic curve cipher suite.

This issue applies to Fedora, Red Hat Enterprise Linux, CentOS and all
derivatives of those distributions.

There is a [tracking issue](https://github.com/kerl/kerl/issues/212) to
automatically set this compiler flag, if you wish to follow how kerl
will eventually deal with this issue.

Changelog
---------
1 November 2021 - 2.2.2

  - Enable autoconf when patches are applied on macOS; fixes #384 (#385)

8 October 2021 - 2.2.1

  - Fix downloads for certain OTP releases (#383)
  - Pin openssl to version 1.1 (#380)

17 September 2021 - 2.2.0

  - Download prebuilt binaries (if available) from github to speed builds (#376)

3 June 2021 - 2.1.2

  - Do not munge `LD_` flags on macOS any more (#372)

22 March 2021 - 2.1.1

  - grep `with-ssl` (#367)
  - Add a `\` to commands to bypass any shell alias (#363)
  - Enable multiple doc targets (#362)

26 January 2021 - 2.1.0

  - Fix Big Sur build issues again (#358)
  - Automate building a debug Erlang (#360)

10 December 2020 - 2.0.2

  - Fix Big Sur build issue (#356) (see also [OTP #2871](https://github.com/erlang/otp/pull/2871))

20 October 2020 - 2.0.1

  - Use `-path` in `find` (#345)
  - Redownload a tarball if it's corrupted (#348)
  - Update to build on Catalina and Big Sur (#355)

4 May 2020 - 2.0.0

  - **Important**: possible breaking change - releases are now fetched
                   through github tags by default (#277)
  - Fix documentation building, especially for inline REPL help (#336)
  - Fix builds on Catalina (#337, #339) - if you are on Catalina and
    need to build older Erlangs, you should downgrade your XCode to an
    earlier version.

3 March 2020 - 1.8.7

  - Implement version sorting (#319)
  - Fix CI breakage (#327)
  - Include `erl_call` in the path (#330)

16 September 2019 - 1.8.6

  - Remove almost all special cases for older macOS releases

25 September 2018 - 1.8.5

  - Support Mojave builds (#301)
  - Disable SC2207 for Bash completion (#296)

3 August 2018 - 1.8.4

  - Support docsh 0.6.1 (#290)
  - Update docs about KERL_INSTALL_MANPAGES & HTML_DOCS (#292)
  - Fix bash completion for Bash 3 (#295)

3 July 2018 - 1.8.3

  - Update testing to include OTP 21 (#286)
  - Fix an issue affecting CD\_PATH during builds (#284)

5 March 2018 - 1.8.2

  - Apply zlib patch when building OTP 17-19. (#258)
  - Add CircleCI (#246)
  - Fix empty package name warning (#245)

13 November 2017 - 1.8.1

  - Fix removing an installation by its name. (#244)

8 November 2017 - 1.8.0

  - Include support for installing and managing docsh (#213)
  - Fix a function name typo (#241)

23 October 2017 - 1.7.0

  - Suggest the proper activation script based on the shell you're using (#225)
  - Automatically turn on built-in shell history when using an OTP release >=
    20 (#214)
  - Warn when a Linux does not appear to have a pre-requisite library/package
    to compile Erlang from source code. (#222)

2 October 2017 - 1.6.0

  - Support clang 9 and High Sierra command-line tools (CLT) on older Erlang
    builds. (#234)
  - Fix a pointer error in wx on macOS/clang 9 (#235)

25 May 2017 - 1.5.1

  - Bug Fix: Remove spurious spaces (#209)

24 May 2017 - 1.5.0

  - Published an OTP support policy, triage schedule, IRC channel
  - Apply build patches for Perls >= 5.22 on older OTP releases (#198)
  - Fix bad `read` usage (#200)
  - Add a force flag for mv (#201)
  - Use a more portable way to get perl minor release version (#204)
  - Force 64 bit flag on macOS (#205)
  - Fix documentation symlinks (#206)

22 February 2017 - 1.4.2

  - Fixed a syntax error when comparing hash outputs on reconfigurations (#191)
  - Added the path subcommand; enabled Travis-CI (#190)
  - Fixed mistakenly omitted version string from past 2 releases.

12 February 2017 - 1.4.1

  - Fix reading a checksum file for compile options (#180)
  - Get a little smarter about figuring out what apps to use
    when building a PLT file for dialyzer (#181)

5 February 2017 - 1.4.0

  - Fix environment variable handling and a typo (#179)
  - Overhaul the README; document all environment variables (#178)
  - Store build configuration in a file. Enables detecting if configuration has
    changed from build to build and also allows outputing build time options
    in `kerl status` (#177)
  - Assert perl exists before attempting build (#176); fixes issue #170

13 October 2016 - 1.3.4

  - Use a more portable way to restore PATH (#165)
  - Exit if curl fails. Download files if they are 0 length. (#166)

07 October 2016 - 1.3.3

  - Add support for (T)CSH (#155)
  - If homebrew is installed, make kerl check for a homebrew OpenSSL library path (#161)
  - If `--enable-native-libs` is active, make, clean and make again. (#163)

20 July 2016 - 1.3.2

  - Optionally enhance the activation prompt (#149)
  - Do not permit installation into a location that's already installed (#150)
  - Fix duplicate response from `kerl prompt` (fix #88) (#150)
  - Do not run if $HOME is not set. (fix #22) (#151)

16 July 2016 - 1.3.1

  - Fix argument order in archive unpacking (#146)
  - When building, show output of unmet dependencies or other build prerequisites (#148)

1 July 2016 - 1.3.0

  - basic fish shell support (#91)

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
