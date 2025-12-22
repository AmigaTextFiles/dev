#
# default.dilp - Default plugin for DIL
# Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
# All rights reserved.
#
# Please see "License.readme" for the terms of this file
#------------------------------------------------------------------------------

CC	= gcc
CFLAGS	= -O2 -Wall -mcpu=powerpc -fomit-frame-pointer -noixemul -fno-builtin -fstrength-reduce
LFLAGS	= -lm -labox -ldebug -noixemul
CDEFS	=\
	-D__AMIGADATE__=\"$(shell date "+%d.%m.%y")\"\
	-D__YEAR__=\"$(shell date "+%Y")\"
EXT	= dilp

#------------------------------------------------------------------------------

NAME	= default

TEST	= test

REL	= 0--MU:morphos

#------------------------------------------------------------------------------

OFILES	= init.o main.o end.o

SFILES	= $(shell ls -I*.$(EXT) -I$(TEST) -I$(TEST).* -I*.o)

PLUGIN	= $(NAME).$(EXT)

#------------------------------------------------------------------------------

$(PLUGIN): $(OFILES)
	$(CC) $(CFLAGS) -s -o $@ $(OFILES) $(LFLAGS) -nostdlib -nostartfiles

$(TEST): $(TEST).o
	$(CC) $(CFLAGS) -s -o $@ $(TEST).o $(LFLAGS) -nostartfiles

.c.o:
	$(CC) $(CDEFS) $(CFLAGS) -c -o $@ $<

#------------------------------------------------------------------------------

clean:
	rm -f *.o *.$(EXT)

#------------------------------------------------------------------------------

install:
	cp $(PLUGIN) LIBS:DIL

uninstall:
	rm -f LIBS:DIL/$(PLUGIN)

#------------------------------------------------------------------------------

install_rel:
	cp $(PLUGIN) $(REL)/DIL/User/Libs/DIL

install_src:
	mkdir -p $(REL)/DIL/Developer/Examples/Plugins/$(NAME)
	cp $(SFILES) $(REL)/DIL/Developer/Examples/Plugins/$(NAME)

#------------------------------------------------------------------------------

