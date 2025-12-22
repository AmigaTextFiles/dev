#!/bin/sh

chdir $1
make -f Makefile.ucc $2
chdir ..