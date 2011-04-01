kerl
====

Easy building and installing of Erlang/OTP instances

Kerl aims to be shell agnostic and its only dependency, excluding what's required to actually build Erlang/OTP, is curl.

Downloading
===========

You can download the script directly from github:

    $ curl -O https://github.com/evax/kerl/raw/master/kerl
    $ chmod a+x kerl

How it works
============

Kerl keeps tracks of the releases it downloaded, built and installed,
allowing easy installations to new destinations (without complete rebuilding) and easy switches between Erlang/OTP installations.

Usage
=====

List the available releases (kerl ignores releases < 10):

    $ ./kerl list releases
    Getting the available releases from erlang.org...
    R10B-0 R10B-2 R10B-3 R10B-4 R10B-5 R10B-6 R10B-7 R10B-8 R10B-9 R11B-0 R11B-1
    R11B-2 R11B-3 R11B-4 R11B-5 R12B-0 R12B-1 R12B-2 R12B-3 R12B-4 R12B-5 R13A
    R13B R13B01 R13B02 R13B03 R13B04 R14A R14B R14B01 R14B02
    Run "./kerl update" to update this list from erlang.org

Pick your choice and build it:

    $ ./kerl build R14B02
    Downloading otp_src_R14B02.tar.gz to /home/evax/.kerl/archives
    (curl progresses...)
    Verifying archive checksum...
    (curl progresses...)
    Checksum verified (229fb8f193b09ac04a57a9d7794349b7)
    Extracting source code
    Building Erlang/OTP R14B02, please wait...
    Erlang/OTP R14B02 has been successfully built

You can verify it's been registered:

    $ ./kerl list builds
    R14B02

Now install it to some location:
   
    $ ./kerl install R14B02 /path/to/install/dir/
    Installing Erlang/OTP R14B02 in /path/to/install/dir/
    You can activate this installation running the following command:
    . /path/to/install/dir/activate

Here again you can check the installation's been registered:

    $ ./kerl list installations
    R14B02 /path/to/install/dir

And at last activate it:

    $ . /path/to/install/dir/activate

You're now ready to work with R14B02

    $ erl -version
    Erlang (SMP,ASYNC_THREADS,HIPE) (BEAM) emulator version 5.8.3


Tuning
======

You can tune kerl using the .kerlrc file in your $HOME directory.

You can set the following variables:

- KERL_DOWNLOAD_DIR (where to put downloaded files)
- KERL_BUILD_DIR (where to hold the builds)
- KERL_CONFIGURE_OPTIONS (options to pass to Erlang's ./configure script)
- KERL_MAKE_OPTIONS (options to pass to make, e.g. -j2)

