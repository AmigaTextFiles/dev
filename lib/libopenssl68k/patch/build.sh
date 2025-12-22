#!/bin/sh
#
# OpenSSL build Amiga command line tool
#

# Unpack
tar xvf openssl-1.0.1j.tar.gz
mv *.patch cd openssl-1.0.1j
cd openssl-1.0.1j

# Configure
./Configure shared no-hw no-engine no-threads zlib no-asm no-krb5 enable-md2 enable-rc5 --cross-compile-prefix=m68k-amigaos- sunos-gcc -noixemul -liberty -lsocket

# Apply DIFF patchs
patch -p1 < e_os.h.patch
patch -p1 < apps.c.patch
patch -p1 < speed.c.patch
patch -p1 < bss_fd.c.patch
patch -p1 < opensslconf.h.patch
patch -p1 < ui_openssl.c.patch
patch -p1 < uid.c.patch
patch -p1 < Makefile.patch

# Make dependencies
make depend

# Build
make
