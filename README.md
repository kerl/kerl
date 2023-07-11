# `kerl` [![GitHub Actions CI][ci-img]][ci] [![GitHub Actions Lint][lint-img]][lint]

[ci-img]: https://github.com/kerl/kerl/actions/workflows/ci.yml/badge.svg
[ci]: https://github.com/kerl/kerl/actions/workflows/ci.yml
[lint-img]: https://github.com/kerl/kerl/actions/workflows/lint.yml/badge.svg
[lint]: https://github.com/kerl/kerl/actions/workflows/lint.yml

Easy building and installing of [Erlang/OTP](https://www.erlang.org) instances.

`kerl` aims to be shell agnostic and its only dependencies, excluding what's
required to actually build Erlang/OTP, are `curl` and `git`.

All is done so that, once a specific release has been built, creating a new
installation is as fast as possible.

## Table of Contents

- [Installing `kerl`](#installing-kerl)
- [How `kerl` works](#how-kerl-works)
- [Using `kerl`](#using-kerl)
- [`kerl` options](#kerl-options)
- [Command reference](#command-reference)
- [Important notes](#important-notes)
- [Shell support](#shell-support)
- [The `kerl` glossary](#the-kerl-glossary)
- [The `kerl` project](#the-kerl-project)

## Installing `kerl`

If you are on macOS, and using [homebrew](https://github.com/Homebrew/brew),
you can install `kerl`, along with shell completion, by running:

```console
$ brew install kerl
```

Alternatively, you can download the script directly from GitHub:

```console
$ curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
```

Then ensure it is executable

```console
$ chmod a+x kerl
```

and drop it in your `$PATH`.

Optionally, download and install `kerl`'s `bash_completion` file from
<https://github.com/kerl/kerl/raw/master/bash_completion/kerl>

Optionally, download and install `kerl`'s `zsh-completion` file from
<https://github.com/kerl/kerl/raw/master/zsh_completion/_kerl>

### Updating `kerl` locally

Run:

```console
$ kerl upgrade
local kerl found (/usr/local/bin/kerl) at version 2.6.0.
remote kerl found at version 3.0.0.
Versions are different. Upgrading to 3.0.0.
kerl 2.6.0 is now available at /usr/local/bin/kerl.
Updating list of available releases...
Done!
```

## How `kerl` works

`kerl` keeps tracks of the releases it downloads, builds and installs, allowing
easy installations to new destinations (without complete rebuilding) and easy
switches between Erlang/OTP installations.

By default, `kerl` downloads source tarballs from the [official Erlang/OTP repository](https://github.com/erlang/otp/tags)
but you can tell `kerl` to download from the [official Erlang/OTP website](https://www.erlang.org/downloads)
by setting `KERL_BUILD_BACKEND=tarball`.
However, this website does not use HTTPS and is down more often than GitHub.

You can also install directly from a raw Git repository by using the
`kerl build git <git_url> <git_version> <build_name>` syntax.

## Using `kerl`

List the available releases:

<!-- markdownlint-disable MD007 # line-length -->
```console
$ kerl list releases
24.0-rc1
...
24.3.4.13
25.0-rc1
...
25.3.2.3
26.0-rc1
...
26.0.2
Run '/usr/local/bin/kerl update releases' to update this list from erlang.org
```
<!-- markdownlint-enable MD007 # line-length -->

Pick your choice and build it:

```console
$ kerl build 25.3 25.3
Downloading 25.3 to /home/user/.kerl/archives...
...
Extracting source code
Building Erlang/OTP 25.3 (25.3), please wait...
...
Erlang/OTP 25.3 (25.3) has been successfully built
```

Note that named builds allow you to have different builds for the same Erlang/OTP release with
different configure options:

```console
$ KERL_BUILD_DOCS=yes kerl build 25.3 25.3-builtdocs
Extracting source code
Building Erlang/OTP 25.3 (25.3-builtdocs), please wait...
...
Building docs...
Erlang/OTP 25.3 (25.3-builtdocs) has been successfully built
```

You can verify your build has been registered:

```console
$ kerl list builds
25.3,25.3
25.3,25.3-builtdocs
```

Now install a build to some location:

```console
$ kerl install 25.3 /usr/local/lib/erlang/25.3
Installing Erlang/OTP 25.3 (25.3) in /usr/local/lib/erlang/25.3...
Building Dialyzer PLT...
Done building /usr/local/lib/erlang/25.3/dialyzer/plt
You can activate this installation running the following command:
. /usr/local/lib/erlang/25.3/activate
Later on, you can leave the installation typing:
kerl_deactivate
```

Here again you can check the installation's been registered:

```console
$ kerl list installations
25.3 /usr/local/lib/erlang/25.3
```

And at last activate it:

```console
$ . /usr/local/lib/erlang/25.3/activate
```

Activation will backup your `$PATH`, and prepend it with the installation's `bin/`
directory. Thus it's only valid for the current shell session, and until you either
activate another installation or call `kerl_deactivate`.

**Note**: alternatively you can use `kerl build-install` as a shortcut for
the two previous actions to be played in sequence.

```console
$ kerl build-install
usage: ./kerl build-install <release> [build_name] [directory]
```

```console
$ kerl build-install git
usage: ./kerl build-install git <git_url> <git_version> <build_name> [directory]
```

You're now ready to work with your 25.3 installation:

```console
$ erl -version
Erlang (SMP,ASYNC_THREADS) (BEAM) emulator version 13.2
```

When you're done just call the shell function:

```console
$ kerl_deactivate
```

Anytime you can check which installation, if any, is currently active with:

```console
$ kerl active
The current active installation is:
/usr/local/lib/erlang/25.3
```

You can get an overview of the current `kerl` state with:

```console
$ kerl status
Available builds:
25.3,25.3
25.3,25.3-builtdocs
----------
Available installations:
25.3 /usr/local/lib/erlang/25.3
----------
The current active installation is:
/usr/local/lib/erlang/25.3
Dialyzer PLT for the active installation is:
/usr/local/lib/erlang/25.3/dialyzer/plt
The build options for the active installation are:
...
```

You can delete builds and installations with the following commands:

```console
$ kerl delete build 25.3-builtdocs
The 25.3-builtdocs build has been deleted
```

```console
$ kerl delete installation 25.3
The installation "25.3" has been deleted
```

You can easily deploy an installation to another host having `ssh` and `rsync` access with the
following command:

```console
$ kerl deploy anotherhost /usr/local/lib/erlang/25.3
Cloning Erlang/OTP 25.3 (/usr/local/lib/erlang/25.3) to anotherhost (/usr/local/lib/erlang/25.3) ...
```

On anotherhost, you can activate this installation running the following command:

```console
$ . /usr/local/lib/erlang/25.3/activate
```

Later on, you can leave the installation typing:

```console
$ kerl_deactivate
```

### Building Erlang/OTP from a GitHub fork

It is possible to build Erlang/OTP from a GitHub fork, by using the `KERL_BUILD_BACKEND=git` and
setting `OTP_GITHUB_URL` to the URL of the fork. For example, to build `<orgname>'s` Erlang/OTP fork:

<!-- markdownlint-disable MD007 # line-length -->
```console
$ export KERL_BUILD_BACKEND=git
$ export OTP_GITHUB_URL='https://github.com/<orgname>/otp'
$ kerl update releases
The available releases are:
24.0-rc1
24.0-rc1.1-orgname
...
24.3.4.13
24.3.4.13.1-orgname
25.0-rc1
...
25.3.2.3
26.0-rc1
26.0-rc1.1-orgname
...
26.0.2
```
<!-- markdownlint-enable MD007 # line-length -->

From here (provided the `KERL_BUILD_BACKEND` and `OTP_GITHUB_URL` variables remain in place), it is
possible to use `kerl` as before:

```console
$ kerl build 26.0-rc1.1-orgname 26.0-rc1.1-orgname
```

### Building Erlang/OTP from a Git source

You can build Erlang/OTP directly from a Git repository with a command of the form
`kerl build git <git_url> <git_version> <build_name>` where `<git_version>` can
be either a branch, a tag or a commit id that will be passed to `git checkout`:

```console
$ kerl build git https://github.com/erlang/otp.git OTP-24.3.4.13 24.3.4.13
Checking out Erlang/OTP git repository from https://github.com/erlang/otp.git...
Building Erlang/OTP OTP-24.3.4.13 from git, please wait...
Erlang/OTP 25.3 from git has been successfully built
```

### Debugging `kerl` usage

If `KERL_DEBUG` is set to a value, then `kerl` will emit copious debug logging, including
a best effort attempt at line numbers. The line numbers may or may not be accurate if
`kerl` is run under the `dash` shell, as is commonly found in Alpine Linux/Docker images.

### Configuring `kerl`

You can tune `kerl` using the `.kerlrc` file in your `$HOME` directory.

## `kerl` options

`kerl` options can be passed either via `.kerlrc` or environment variables, as shown below.

### Color configuration

#### `KERL_COLORIZE`

Default: 1 (Enabled)
Enable VT100 colorizing if `tput` available (provided by `ncurses`). Set to 0 to disable.
Colorization will be disabled anyway if necessary requirements are missing.

Color for log levels can be overriden, by setting ANSI numerical color code to variables
`KERL_COLOR_*` :

- `KERL_COLOR_E` : (1=red) Error level color
- `KERL_COLOR_W` : (3=yellow) Warning level color
- `KERL_COLOR_N` : (4=blue) Notice level color
- `KERL_COLOR_T` : (6=cyan) Tip level color
- `KERL_COLOR_S` : (2=green) Success level color
- `KERL_COLOR_D` : (9) Default Terminal color

### Locations on disk

#### `KERL_BASE_DIR`

Default: `$HOME/.kerl`
Directory in which `kerl` will cache artifacts for building and installing.

#### `KERL_CONFIG`

Default: `$HOME/.kerlrc`
File from which to source `kerl` configuration

#### `KERL_DOWNLOAD_DIR`

Default: `${KERL_BASE_DIR}/archives`
Directory in which to place downloaded artifacts

#### `KERL_BUILD_DIR`

Default: `${KERL_BASE_DIR}/builds`
Directory in which `kerl` will perform builds

#### `KERL_GIT_DIR`

Default: `${KERL_BASE_DIR}/gits`
Directory in which `kerl` will clone Git repositories for building.

### Build configuration

#### `KERL_AUTOCLEAN`

Default: 1 (Enabled)
Clean all build artifacts but the log file on failure. This allows safe build retries
after failure while still keeping a log file with all attempted builds until
success.

Set to 0 to keep build artifacts on failure.

#### `KERL_CONFIGURE_OPTIONS`

Space-separated options to pass to `configure` when building Erlang/OTP.

#### `KERL_CONFIGURE_APPLICATIONS`

Space-separated list of Erlang/OTP applications which should exclusively be built.

#### `KERL_CONFIGURE_DISABLE_APPLICATIONS`

Space-separated list of Erlang/OTP applications to disable during building.

#### `KERL_BUILD_PLT`

Create a PLT file alongside the built release.

#### `KERL_USE_AUTOCONF`

Use `autoconf` during build process.

**Note**: automatically enabled when using `KERL_BUILD_BACKEND=git`

#### `KERL_BUILD_BACKEND`

Default value: `git`
Acceptable values: `tarball`, `git`

- `tarball`: fetch Erlang/OTP releases from <erlang.org>
- `git`: fetch Erlang/OTP releases from [`$OTP_GITHUB_URL`](#otp_github_url)

**Note**: docs are only fetched when this is set to `tarball`. To enable creation of docs when set to
`git`, one must also set [`$KERL_BUILD_DOCS`](#kerl_build_docs).

**Note**: this option has no effect when using `kerl build git...`, which invokes `kerl` to directly
clone a Git repository and build from there.

#### `KERL_RELEASE_TARGET`

Allows building, alongside the regular VM, a list of various runtime types for debugging
(such as `cerl -debug` or `cerl -asan`)

**Note**: enable this build using `KERL_RELEASE_TARGET="debug asan"`

**Note**: available types: `opt`, `gcov`, `gprof`, `debug`, `valgrind`, `asan` or `lcnt`

For more information: see  "How to Build a Debug Enabled Erlang RunTime System" in
<https://www.erlang.org/doc/installation_guide/install>.

#### `OTP_GITHUB_URL`

Default value: `https://github.com/erlang/otp`
Acceptable value: any GitHub fork of Erlang/OTP

#### `KERL_BUILD_DOCS`

If `$KERL_BUILD_DOCS` is set, `kerl` will create docs from the built Erlang/OTP version regardless of
origin (`tarball` backend from <erlang.org> or via `kerl build git`, or via `git` backend).

If `$KERL_BUILD_DOCS` is unset, `kerl` will only install docs when **not** installing a build
created via `kerl build git...`, and according to `KERL_INSTALL_HTMLDOCS` and `KERL_INSTALL_MANPAGES`.

#### `KERL_DOC_TARGETS`

Default: `chunks`
Available targets:

- `man`: install manpage docs.
- `html`: install HTML docs.
- `pdf`: install PDF docs.
- `chunks`: install the "chunks" format to get documentation from the `erl` REPL.

You can set multiple type of targets separated by space, example `$KERL_DOC_TARGETS="man html pdf chunks"`

#### `KERL_INSTALL_MANPAGES`

Install man pages when not building from Git source.

It's noteworthy that when not using `KERL_BUILD_DOCS=yes`, the docset that may be downloaded can be
up to 120 MB.

#### `KERL_INSTALL_HTMLDOCS`

Install HTML documentation when not building from Git source.

It's noteworthy that when not using `KERL_BUILD_DOCS=yes`, the docset that may be downloaded can be
up to 120 MB.

#### `KERL_SASL_STARTUP`

Build Erlang/OTP to use SASL startup instead of minimal (default, when var is unset).

### Activation configuration

The following applies when activating an installation (i.e. `. ${KERL_DEFAULT_INSTALL_DIR}/19.2/activate`).

#### `KERL_ENABLE_PROMPT`

When set, automatically prefix the shell prompt with a section containing the
Erlang/OTP version (see [`$KERL_PROMPT_FORMAT`](#kerl_prompt_format) ).

#### `KERL_PROMPT_FORMAT`

Default: `(%BUILDNAME%)`
Available variables:

- `%BUILDNAME%`: name of the `kerl` build (e.g. `my_test_build_18.0`)
- `%RELEASE%`: name of the Erlang/OTP release (e.g. `19.2` or `R16B02`)

The format of the prompt section to add.

### Installation configuration

#### `KERL_DEFAULT_INSTALL_DIR`

Effective when calling `kerl install <build>` with no installation location argument.

If unset, `$PWD` is used.

If set, install the build under `$KERL_DEFAULT_INSTALL_DIR/${buildname}`.

#### `KERL_APP_INSTALL_DIR`

Effective when calling `kerl upgrade`. This is the folder where the `kerl` application
resides.

If unset, `$PWD` is used.

If set, `kerl` is installed at `$KERL_APP_INSTALL_DIR/kerl`.

#### `KERL_DEPLOY_SSH_OPTIONS` + `KERL_DEPLOY_RSYNC_OPTIONS`

Options passed to `ssh` and `rsync` during `kerl deploy` tasks.

## Command reference

You can also get information on the following by executing `kerl` (no parameters) on your shell.

### `build`

```console
$ kerl build <release> <build_name>
$ # or
$ kerl build git <git_url> <git_version> <build_name>
```

Creates a named build either from an official Erlang/OTP release or from a git repository.

```console
$ kerl build 25.3 25.3
$ #or
$ kerl build git https://github.com/erlang/otp.git OTP-24.3.4.13 24.3.4.13
```

#### Tuning

##### Configure options

You can specify the configure options to use when building Erlang/OTP with the
`KERL_CONFIGURE_OPTIONS` variable, either in your `$HOME/.kerlrc` file or
prepending it to the command line. A full list of all options can be found the in
[Erlang/OTP documentation](https://erlang.org/doc/installation_guide/INSTALL.html#Advanced-configuration-and-build-of-ErlangOTP_Configuring).

##### Configure applications

If non-empty, you can specify the subset of applications to use when building
(and subsequent installing) Erlang/OTP with the `KERL_CONFIGURE_APPLICATIONS`
variable, either in your `$HOME/.kerlrc` file or prepending it to the command
line.

```console
$ KERL_CONFIGURE_APPLICATIONS="kernel stdlib sasl" kerl build 25.0.3 25.0.3-minimal
```

##### Configure disable applications

If non-empty, you can specify the subset of applications to disable when
building (and subsequent installing) Erlang/OTP with the
`KERL_CONFIGURE_DISABLE_APPLICATIONS` variable, either in your `$HOME/.kerlrc`
file or prepending it to the command line.

```console
$ KERL_CONFIGURE_DISABLE_APPLICATIONS="odbc" kerl build 24.3.4.13 24.3.4.13-no-odbc
```

##### Enable autoconf

You can enable the use of `autoconf` in the build process setting
`KERL_USE_AUTOCONF=yes` in your `$HOME/.kerlrc` file.

**Note**: `autoconf` is always enabled for Git builds.

##### Using shell export command in .kerlrc

Configure variables which includes spaces such as those in `CFLAGS` cannot be
passed on with `KERL_CONFIGURE_OPTIONS`. In such a case you can use shell
`export` command to define the environment variables for `./configure`. Note
well: this method has a side effect to change your shell execution environment
after activating a `kerl` installation of Erlang/OTP. Here is an example of
`.kerlrc` for building Erlang/OTP for FreeBSD with clang compiler:

<!-- markdownlint-disable MD007 # line-length -->
```console
$ # for clang
$ export CC=clang CXX=clang CFLAGS="-g -O3 -fstack-protector" LDFLAGS="-fstack-protector"
$ # compilation options
$ KERL_CONFIGURE_OPTIONS="--disable-native-libs --enable-vm-probes --with-dynamic-trace=dtrace --with-ssl=/usr/local --with-javac --enable-hipe --enable-kernel-poll --with-wx-config=/usr/local/bin/wxgtk2u-2.8-config --without-odbc --enable-threads --enable-sctp --enable-smp-support"
```
<!-- markdownlint-enable MD007 # line-length -->

In case you cannot access the default directory for temporary files (`/tmp`) or
simply want them somewhere else, you can also provide your own directory with
the variable `TMP_DIR`.

```console
$ export TMP_DIR=/your/custom/temporary/dir
```

#### Building documentation

Prior to `kerl` 1.0, `kerl` always downloaded prepared documentation from
erlang.org. Now if `KERL_BUILD_DOCS=yes` is set, `kerl` will build the man pages
and HTML documentation from the source repository in which it is working.

**Note**: this variable takes precedent over the other documentation parameters.

### `install`

#### Installing a build

```console
$ kerl install <build_name> [directory]
```

Installs a named build to the specified filesystem location.

```console
$ kerl install 25.3 /usr/local/lib/erlang/25.3
```

If path is omitted the current working directory will be used. However, if
`KERL_DEFAULT_INSTALL_DIR` is defined in `$HOME/.kerlrc`,
`KERL_DEFAULT_INSTALL_DIR/<build-name>` will be used instead.

##### Install location restrictions

**Warning**: `kerl` assumes the given installation directory is for its sole use.
If you later delete it with the `kerl delete` command, the whole directory will
be deleted, along with anything you may have added to it!

So only install `kerl` in an empty (or non-existant) directory.

If you attempt to install `kerl` in `$HOME` or `.erlang` or `$KERL_BASE_DIR`,
then `kerl` will give you an error and refuse to proceed. If you try to install
`kerl` in a directory that exists and is not empty, `kerl` will give you an error.

##### Tuning

###### SASL startup

You can have SASL started automatically setting `KERL_SASL_STARTUP=yes` in your
`$HOME/.kerlrc` file or prepending it to the command line.

###### Manpages installation

You can have manpages installed automatically setting
`KERL_INSTALL_MANPAGES=yes` in your `$HOME/.kerlrc` file or prepending it to the
command line.

**Note**: for Git-based builds, you want to set `KERL_BUILD_DOCS=yes`

###### HTML docs installation

You can have HTML docs installed automatically setting
`KERL_INSTALL_HTMLDOCS=yes` in your `$HOME/.kerlrc` file or prepending it to the
command line.

*Note*: for Git-based builds, you want to set `KERL_BUILD_DOCS=yes`

#### Documentation installation

Man pages will be installed to `[path]/man` and HTML docs will be installed in
`[path]/html`.  The `kerl` `activate` script manipulates the MANPATH of the current
shell such that `man 3 gen_server` or `erl -man gen_server` should work perfectly.

Do not fret - `kerl_deactivate` restores your shell's `MANPATH` to whatever its
original value was.

### `deploy`

```console
$ kerl deploy <[user@]host> [directory] [remote_directory]
```

Deploys the specified installation to the given host and location.

```console
$ kerl deploy anotherhost /path/to/install/dir
```

If `[remote_directory]` is omitted the specified `[directory]` will be used.

If both `[directory]` and `[remote_directory]` are omitted the current working directory will be used.

*NOTE*: `kerl` assumes the specified host is accessible via `ssh` and `rsync`.

#### Tuning

##### Additional SSH options

You can have additional options given to `ssh` by setting them in the
`KERL_DEPLOY_SSH_OPTIONS` variable in your `$HOME/.kerlrc` file or on the command
line, e.g. `KERL_DEPLOY_SSH_OPTIONS='-qx -o PasswordAuthentication=no'`.

##### Additional RSYNC options

You can have additional options given to `rsync` by setting them in the
`KERL_DEPLOY_RSYNC_OPTIONS` variable in your `$HOME/.kerlrc` file or on the
command line, e.g. `KERL_DEPLOY_RSYNC_OPTIONS='--delete'`.

### `update`

```console
$ kerl update releases
```

If `KERL_BUILD_BACKEND=tarball` this command fetches the up-to-date list of Erlang/OTP
releases from erlang.org.

If it is set to `KERL_BUILD_BACKEND=git` this command fetches an up-to-date
list of Erlang/OTP tags from the official Erlang/OTP GitHub repository.

### `list`

```console
$ kerl list <releases|builds|installations>
```

Lists the releases, builds or installations available.

### `delete`

```console
$ kerl delete build <build_name>
$ # or
$ kerl delete installation <directory>
```

Deletes the specified build or installation.

```console
$ kerl delete build 25.3
The 25.3 build has been deleted
```

```console
$ kerl delete installation /usr/local/lib/erlang/25.3
The installation in /usr/local/lib/erlang/25.3 has been deleted
```

### `active`

```console
$ kerl active
```

Prints the path of the currently active installation, if any.

```console
$ kerl active
The current active installation is:
/usr/local/lib/erlang/25.3
```

### `status`

```console
$ kerl status
```

Prints the available builds and installations as well as the currently active installation.

```console
$ kerl status
Available builds:
25.3,25.3
25.3,25.3-builtdocs
----------
Available installations:
25.3 /usr/local/lib/erlang/25.3
----------
The current active installation is:
/usr/local/lib/erlang/25.3
Dialyzer PLT for the active installation is:
/usr/local/lib/erlang/25.3/dialyzer/plt
The build options for the active installation are:
...
```

### `path`

```console
$ kerl path [installation]
```

Prints the path of the currently active installation if one is active. When given an
installation name, it will return the path to that installation location on disk.
This makes it useful for automation without having to run `kerl`'s output through
other tools to extract to path information.

```console
$ kerl path
No active kerl-managed erlang installation
```

```console
$ kerl path 24.3.3
/usr/local/lib/erlang/24.3.3
```

### `build-install`

```console
$ kerl build-install <release> [build_name] [directory]
kerl build-install git <git_url> <git_version> <build_name> [directory]
```

Combines `kerl build` and `kerl install` into a single command.

### `plt`

Prints Dialyzer PLT path for the active installation.

### `prompt`

Prints a string suitable for insertion in prompt.

### `cleanup`

```console
$ kerl cleanup <build_name|all>
```

Remove compilation artifacts (use after installation), for a given build or for "all".

### `version`

Prints current version.

## Important notes

### Compiling crypto on older macOS

Apple stopped shipping OpenSSL in OS X 10.11 (El Capitan) in favor of Apple's
own SSL library. That makes using homebrew the most convenient way to install
openssl on macOS 10.11 or later. Additionally, homebrew [stopped creating](https://github.com/Homebrew/brew/pull/612)
symlinks from the homebrew installation directory to `/usr/local`, so in
response to this, *if* you're running El Capitan, Sierra, or High Sierra
*and* you have homebrew installed, *and* you used it to install openssl,
`kerl` will ask homebrew for the openssl installation prefix and configure Erlang/OTP
to build with that location automatically.

**Important**: if you already have `--with-ssl` in your `.kerlrc`, `kerl`
will honor that instead, and will not do any automatic configuration.

### Note on .kerlrc

Since `.kerlrc` is a dot file for `/bin/sh`, running shell commands inside the
`.kerlrc` will affect the shell and environment variables for the commands being
executed later. For example, the shell `export` commands in `.kerlrc` will affect
*your login shell environment* when activating `curl`.  Use with care.

## Shell support

### fish

`kerl` has basic support for the fish shell.

To activate an installation:

```console
$ source /path/to/install/dir/activate.fish
```

Deactivation is the same as in other shells:

```console
$ kerl_deactivate
```

### C

`kerl` has basic support for the C shells (`csh`, `tcsh`, etc.).

To activate an installation:

```console
$ source /path/to/install/dir/activate.csh
```

The activation script sources file `.kerlrc.csh` instead of `.kerlrc`.

Deactivation is the same as in other shells:

```console
$ kerl_deactivate
```

### Bash

Bash completion is available from
<https://github.com/kerl/kerl/raw/master/bash_completion/kerl>.

### Zsh

Zsh completion is available from
<https://github.com/kerl/kerl/raw/master/zsh_completion/_kerl>.

## The `kerl` glossary

Here are the abstractions `kerl` is handling:

- **releases**: Erlang/OTP releases from [erlang.org](https://erlang.org)

- **builds**: the result of configuring and compiling releases or Git repositories

- **installations**: the result of deploying builds to filesystem locations (also referred to as "sandboxes")

## The `kerl` project

### Erlang/OTP support policy

As of 2021 September 17, we are supporting the current Erlang/OTP release version
and 2 prior release versions (same as upstream Erlang/OTP). Older Erlang/OTP releases
may or may not work. We will advance release support as new releases of Erlang/OTP
become available.

### Code of conduct

You can read more about our code of conduct at [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

### Contributing to `kerl`

Contributions are welcome! Be sure to read and follow the general guidelines made explicit in
[CONTRIBUTING.md](CONTRIBUTING.md).

### License

`kerl` is MIT-licensed, as per [LICENSE.md](LICENSE.md). You'll also find the same license notice
inside the distributable shell script.

### Changelog

Check [CHANGELOG.md](CHANGELOG.md) and also [GitHub releases](https://github.com/kerl/kerl/releases).
