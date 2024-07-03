#!/bin/sh
version=$(./kerl version)
if [ -z "${version}" ]; then exit 1; fi
