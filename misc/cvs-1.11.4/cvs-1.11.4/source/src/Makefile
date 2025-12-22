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
#

TARGET	= libsrc.a

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
CFLAGS   = -noixemul -I./ -I../ -I../lib -I../diff -I../zlib -I../amiga -I../amiga/netinclude -DHAVE_CONFIG_H $(CPU) $(CPUFLAGS) $(WARN) $(OPTFLAGS) $(DEBUG) -c
LDFLAGS  = -noixemul

# CPU and DEBUG can be defined outside, defaults to above
# using e.g. "make DEBUG= CPU=-mcpu=603e" produces optimized non-debug PPC-603e version
#
# OPTFLAGS are disabled by DEBUG normally!
#
# ignored warnings are:
# none - because we want to compile with -Wall all the time
#

OBJS     =  add.o admin.o annotate.o buffer.o checkin.o checkout.o classify.o \
            client.o commit.o create_adm.o cvsrc.o diff.o edit.o entries.o expand_path.o \
            fileattr.o find_names.o hardlink.o hash.o history.o ignore.o import.o \
            lock.o log.o login.o logmsg.o main.o mkmodules.o modules.o myndbm.o no_diff.o \
            parseinfo.o patch.o rcs.o rcscmds.o recurse.o release.o remove.o repos.o \
            root.o scramble.o server.o status.o tag.o update.o watch.o wrapper.o vers_ts.o \
            subr.o filesubr.o run.o version.o error.o zlib.o

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

