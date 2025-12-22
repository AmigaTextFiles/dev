#
# $Id$
#
# :ts=4
#
# AmigaOS wrapper routines for GNU CVS, using the AmiTCP V3 API
# and the SAS/C V6.58 compiler.
#
# Written and adapted by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
#                        Jens Langner <Jens.Langner@htw-dresden.de>
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

TARGET	= cvs020

#

CC        = gcc
STRIP     = strip
OBJDUMP   = objdump
RANLIB    = ranlib
AR        = ar
RM        = rm -f
CHMOD     = chmod

CPU      = -m68020
CPUFLAGS =
WARN     = -Wall
OPTFLAGS = -O2 -fomit-frame-pointer -fstrength-reduce -resident
DEBUG    = #-g3 -O0
CFLAGS   = -noixemul -I./ -I../ -I../lib -I../src -I../amiga -I../amiga/netinclude -DHAVE_CONFIG_H $(CPU) $(CPUFLAGS) $(WARN) $(OPTFLAGS) $(DEBUG) -c
LDFLAGS  = -noixemul -resident $(CPU)
LDLIBS   = -ldebug

# CPU and DEBUG can be defined outside, defaults to above
# using e.g. "make DEBUG= CPU=-mcpu=603e" produces optimized non-debug PPC-603e version
#
# OPTFLAGS are disabled by DEBUG normally!
#
# ignored warnings are:
# none - because we want to compile with -Wall all the time
#

OBJS     =  src/libsrc.a lib/libcvs.a amiga/libamcvs.a amiga/ssh/libssh.a diff/libdiff.a zlib/libzlib.a

#

all: libsrc.a libcvs.a libamcvs.a libssh.a libdiff.a libzlib.a $(TARGET)

#

libsrc.a:
	@make -C src CPU="$(CPU)" DEBUG="$(DEBUG)" OPTFLAGS="$(OPTFLAGS)"

libcvs.a:
	@make -C lib CPU="$(CPU)" DEBUG="$(DEBUG)" OPTFLAGS="$(OPTFLAGS)"

libamcvs.a:
	@make -C amiga CPU="$(CPU)" DEBUG="$(DEBUG)" OPTFLAGS="$(OPTFLAGS)"

libssh.a:
	@make -C amiga/ssh CPU="$(CPU)" DEBUG="$(DEBUG)" OPTFLAGS="$(OPTFLAGS)"

libdiff.a:
	@make -C diff CPU="$(CPU)" DEBUG="$(DEBUG)" OPTFLAGS="$(OPTFLAGS)"

libzlib.a:
	@make -C zlib CPU="$(CPU)" DEBUG="$(DEBUG)" OPTFLAGS="$(OPTFLAGS)"

#

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@.debug $(OBJS) $(LDLIBS)
	$(STRIP) -o $@ $@.debug
	$(CHMOD) a+x $@

dump:
	-$(OBJDUMP) --section-headers --all-headers --reloc --disassemble-all $(TARGET).debug >$(TARGET).dump

clean:
	-$(RM) $(TARGET) $(OBJS)

cleanall: clean
	make -C src clean
	make -C lib clean
	make -C amiga clean
	make -C amiga/ssh clean
	make -C diff clean
	make -C zlib clean

#######################################


#######################################

