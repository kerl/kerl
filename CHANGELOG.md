<!-- markdownlint-disable MD007 # ul-indent -->
# Changelog

18 Jun 2025 - 4.4.0

  - Support OTP 28 (#559)
  - Fix "No debug build is produced" (#560)

23 Apr 2025 - 4.3.1

  - Fast-track for `kerl version` (#553)
  - Use `gtar` to extract archives, if available (#555)

21 Sep 2024 - 4.3.0

  - Fix `kerl upgrade` example on `README.md` (#541)
  - Make Bash and Zsh completions support custom `KERL_BASE_DIR` (#544)
  - Add fish shell completion support (#543)
  - Stop depending on (or proposing, in probes) `automake` (#547)

3 Jul 2024 - 4.2.0

  - Allow specifying Git clone depth on `kerl build git ...` (#527)
  - On macOS, use OpenSSL 1.1 if Erlang/OTP is pre-25.1, and OpenSSL 3.0 otherwise (#528)
  - Fix warning on Fedora's missing package `gcc-c++` by (#532)
  - Have shared code reusable (on the package warning list) (#534)
  - Fix broken documentation links (#533)
  - `kerl upgrade` always "upgrading" (#539)

21 May 2024 - 4.1.1

  - KERL_DOC_TARGETS needs to be quoted (#520)
  - Probe fails for `libncurses5-dev` (#521)
  - Standardize on `libncurses-dev` for `dpkg` package probing (#523)
  - Prepare for OTP 27 (#507)

3 March 2024 - 4.1.0

  - Ease log and output code maintenance (#476)
  - Fix as per Lint workflow (#477)
  - Update README.md (#478)
  - Add lock/unlock for build git, build, and install (#479)
  - Fix `is_older_than_x_days`: use `find` instead of `stat` (#481)
  - Simplify code maintenance (#480)
  - Fix/improve output on errors (#482)
  - Fix typos in security policy (#486)
  - Fix awk script (#484)
  - Warn on stale build due to kernel changed (#485)
  - Fix verification for `$#` in `kerl delete build` (#489)
  - Minor fixes around `delete installation` (#488)
  - Fix/complement `cleanup` (#492)
  - Be more specific in the packages we suggest for installation (#491)
  - Fix broken Zsh completion scripts (#497)
  - `brew` in CI: don't install updates "just because" (#499)
  - Attempt auto-cleanup of `otp_builds` and `otp_installations`, at every run (#490)
  - Make Pop!_OS a `kerl`-known Linux distro, for package probing (#505)
  - Prevent GitHub CI warnings on "Node.js 16 actions are deprecated" (#506)
  - Fix shell completion scripts (#501)
  - Extend `KERL_AUTOCLEAN` to Git-based builds (#511)
  - Have CI run on pull request, workflow dispatch and push to main (#516)
  - Ignore ownership and permissions of files in OTP source archives (#515)
  
12 October 2023 - 4.0.0

  - Fix fish shell deactivate (#460)
  - Fix sh shell deactivate (#461)
  - Shellcheck and shfmt completion scripts (#463)
  - Shellcheck and shfmt generated files (#464)
  - Trim kerl releases output **Breaking change** (#465)
  - Bury dead code **Breaking change** (#466)
    patches and code for very old OTP releases have been removed - if you need this,
    please use 3.1.0 or earlier.
  - Fix kerl remote command (#469)
  - Fix csh (de)activate (#470)
  - Fix no whitespace before ps output (#474)
  - Completely overhaul build pre-requisite package tests **Breaking change** (#471)
    If your Linux isn't supported, please submit a PR

9 September 2023 - 3.1.0

  - Respect markdownlint (#446)
  - Huge maintenance update/cleanup (#449)
  - Add a new `emit-activate` command to emit activation/deactivation artifacts (#452)
  - Warn on activation script staleness (#454)
  - Use -o exportall to write less code (#456)
  - Handle REBAR_CACHE_DIR (#457)

11 May 2023 - 3.0.0

  - Fix shellcheck issues (#442)
  - For CI, force install OpenSSL 1.1 on Ubuntu 22 for older OTPs (#443, #444)
  - NEW FEATURE: a single build install step! (#419)
  - REMOVED: docsh functionality has been removed, as it no longer needed
             for newer OTPs (#445)

18 April 2023 - 2.6.0

  - Make logging less verbose (#417)
  - Use Github Actions instead of CircleCI (#423)
  - Fix broken CI images on README (#424)
  - Fix broken version output (#425)
  - Add macOS to CI matrix (#427)
  - Fix error when running in a container (#402)
  - Use Ubuntu 22.04, drop Ubuntu 20.04 for CI (#429)
  - Add Ventura to version bypass for macOS (#433)
  - If a patch has already been applied, do not apply it again (#437)
  - Fix shellcheck for unreachable code (#438)
  - On build failures, autoclean build art{e|i}facts (#410)

18 June 2022 - 2.5.1

  - Many shellcheck, ci and bugfixes (#414)

31 May 2022 - 2.5.0

  - Add a way to specify a debug/release target build (#411)

27 April 2022 - 2.4.0

  - Handle a failed github retrieval better (#408)
  - Colorize kerl output (if available) (#409)

13 April 2022 - 2.3.0

  - Fix build of older OTPs on macOS Monterey (#397)
  - Separate info and error messages onto stdout/stderr (#401 - rebased as #403)
  - Add a new `upgrade` command to check, download and install kerl upgrades (#400)

7 January 2022 - 2.2.4

  - Fix fish activation error (#392)
  - Fix build issue on macOS Monterey (#395)

27 November 2021 - 2.2.3

  - Use `-path` in find to be more POSIX friendly (#388)
  - Do not let default values override config values (#389)

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
