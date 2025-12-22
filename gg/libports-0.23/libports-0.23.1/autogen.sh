#! /bin/sh

aclocal
automake Makefile src/Makefile tests/Makefile
autoconf
