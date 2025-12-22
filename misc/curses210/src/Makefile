# -*-Text-*-
#
# Filename     : SRC:lib/curses/src/Makefile
#
# Author       : Simon J Raybould.  (sie@fulcrum.co.uk)
#
# Date         : Friday 23rd August 1991.
#
# Desc         : Makefile for Amiga curses library.
#
#
# THIS CODE IS NOT PUBLIC DOMAIN
# ==============================
# 
# This code is copyright Simon J Raybould 1992, all rights are reserved.
# All code, ideas, data structures and algorithms remain the property of the
# author. Neither the whole nor sections of this code may be used as part
# of other code without the authors consent. If you wish to use some of this
# code then please email me at (sie@fulcrum.bt.co.uk).
#
# This source is not public domain, so you do not have any right to alter it
# or sell it for personal gain. The source is provided purely for reference
# purposes. You may re-compile the source with any compiler you choose.
# You must not distribute altered copies without the authors consent. My
# intention is that the source will help people isolate any bugs much more
# effectively.
#
# Disclaimer
# ==========
#
# No implication is made as to this code being fit for any purpose at all.
# I (the author) shall not be held responsible for any loss of data or damage 
# to property that may result from its use or misuse.
#
#
# Revision History
# ================
#
# $Log: Makefile,v $
# Revision 1.11  1994/02/21  22:18:08  sie
# Added setupterm.c
#
# Revision 1.10  1993/05/17  23:42:07  sie
# tidying up.
#
# Revision 1.9  1993/05/17  23:33:10  sie
# Underscores added to names.
# Changes for version 2.10
#
# Revision 1.8  1992/12/25  22:22:09  sie
# Changes for the GNU C port.
#
# Revision 1.7  92/06/10  23:44:42  sie
# Added serial support.
# 
# Revision 1.6  92/01/28  00:11:43  sie
# removed -q1e1w as these are now defaults.
# 
# Revision 1.5  92/01/28  00:10:40  sie
# compacts the header file.
# 
# Revision 1.4  92/01/25  23:53:48  sie
# clean now removed emacs temporary files as well.
# 
# Revision 1.3  91/12/28  22:49:15  sie
# made "clean" remove the library.
# 
# Revision 1.2  91/09/28  17:53:40  sie
# Put clone on both copy instructions.
# 
# Revision 1.1  91/09/07  11:55:48  sie
# Initial revision
# 
#

VER= V2.00
SRCS=	wclrtobot.c flushinp.c wgetstr.c subwin.c mvprintw.c wscanw.c \
	scanw.c mvwscanw.c mvscanw.c printw.c newwin.c _creatwin.c \
	touchwin.c delwin.c mvwin.c scroll.c wsetscrreg.c _scroll.c \
	scrollok.c wnoutrefresh.c doupdate.c echo.c noecho.c beep.c \
	wrefresh.c initscr.c wgetch.c wstandout.c keypad.c flash.c \
	initcolour.c _data.c startcolour.c hascolours.c waddstr.c \
	waddch.c winsch.c wdelch.c wclear.c werase.c clearok.c wclrtoeol.c \
	wstandend.c wattrset.c wattron.c wattroff.c cbreak.c nocbreak.c \
	idlok.c winsertln.c wdeleteln.c nodelay.c resetty.c savetty.c \
	resetterm.c fixterm.c saveterm.c baudrate.c nl.c nonl.c box.c \
	mvwprintw.c _togcur.c wmove.c _zapcur.c _drawcur.c _exit.c endwin.c \
	mvcur.c wprintw.c leaveok.c winch.c _doecho.c _cleanup.c \
	_ansi.c gettmode.c longname.c overlay.c overwrite.c \
	_mergewin.c setterm.c unctrl.c tgetent.c tgetstr.c tputs.c \
	tgoto.c tgetnum.c tgetflag.c setupterm.c


CC= sc
CP= copy
RM= delete
TAGS= etags
OBJS= $(SRCS:.c=.o)
#DEBUG  = DEFINE DEBUG debug=ff
#TSTOPTS = COVERAGE
CFLAGS = DEFINE NO_SCAN_PROTOS $(DEBUG) $(TSTOPTS)
LIB    = curses.lib
LIBDIR = LLIB:

.c.o:
	$(CC) $(CFLAGS) $<

all: $(LIB)


$(LIB): $(OBJS)
	-$(RM) $(LIB)
	join #?.o AS $(LIB)

install: $(LIB)
	-$(CP) $(LIB) $(LIBDIR) CLONE
	$(CP) curses.h INCLUDE: CLONE

$(OBJS): acurses.h curses.h

TAGS: $(SRCS)
	$(TAGS)	$(SRCS)

protos: $(SRCS)
	$(CC) GPROTO $(SRCS)
	join #?_protos.h as protos.h
	-$(RM) #?_protos.h #?_protos.h.info

clean:
	-$(RM) #?~
	-$(RM) #?.info
	-$(RM) $(OBJS)
	-$(RM) TAGS
	-$(RM) $(LIB)
