#
# Ixprefs v.1.2--ixemul.library configuration program
# Copyright © 1995 Kriton Kyrimis
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

CC = gcc
CPU = #-m68040
CFLAGS = -O2 $(CPU)
LDFLAGS = -s $(CPU)

OBJS = ixprefs.o functions.o main.o cli.o getopt.o getopt1.o

ixprefs: $(OBJS)
	$(CC) $(LDFLAGS) -o ixprefs $(OBJS) -lauto

ixprefs.c: ixprefs.gui
	patch ixprefs.c ixprefs.c.diff

clean:
	rm -f *.o ixprefs
