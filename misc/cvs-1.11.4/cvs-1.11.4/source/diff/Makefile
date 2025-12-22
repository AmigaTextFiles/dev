#
# $Id$
#
# :ts=4
#
# AmigaOS wrapper routines for GNU CVS, using the RoadShow TCP/IP API
#
# Written and adapted by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
#                        Jens Langner <Jens.Langner@light-speed.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

TARGET	= libdiff.a

#

CC        = gcc
STRIP     = strip
OBJDUMP   = objdump
RANLIB    = ranlib
AR        = ar
RM        = rm -f

CPU      = -m68020
CPUFLAGS =
WARN     = -Wall
OPTFLAGS = -O2 -fomit-frame-pointer -fstrength-reduce -resident
DEBUG    = -g3 -O0
CFLAGS   = -noixemul -I../amiga -I../amiga/netinclude -I./ -I../ -I../lib -DHAVE_CONFIG_H $(CPU) $(CPUFLAGS) $(WARN) $(OPTFLAGS) $(DEBUG) -c

# CPU and DEBUG can be defined outside, defaults to above
# using e.g. "make DEBUG= CPU=-mcpu=603e" produces optimized non-debug PPC-603e version
#
# OPTFLAGS are disabled by DEBUG normally!
#
# ignored warnings are:
# none - because we want to compile with -Wall all the time
#

OBJS     =  diff.o diff3.o analyze.o cmpbuf.o dir.o io.o util.o \
            context.o ed.o ifdef.o normal.o side.o version.o

#

all: $(TARGET)

#

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

#

$(TARGET): $(OBJS)
	$(AR) rs $@ $(OBJS)

clean:
	-$(RM) $(TARGET) $(OBJS)

#######################################


#######################################

