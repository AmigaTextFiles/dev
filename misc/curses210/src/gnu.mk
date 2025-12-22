# -*-make-*-
##################################################################
#
# Desc   : Makefile for amiga curses using GNUC
#
# Author : Simon J Raybould.	(sie@fulcrum.co.uk)
#
# Date   : Thursday 27th August 1992.
#
#
# Revision History
# ================
#
# $Log: gnu.mk,v $
# Revision 1.3  1994/02/21  22:17:16  sie
# Added tgetent.c tgetstr.c tputs.c tgoto.c tgetnum.c tgetflag.c setupterm.c
#
# Revision 1.2  1993/05/17  23:33:10  sie
# Underscores added to names.
# Changes for version 2.10
#
# Revision 1.1  1992/12/25  22:20:02  sie
# Initial revision
#
#
##################################################################


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

CC= gcc
RM= delete
AR= ar
RANLIB= ranlib
COPY= copy

DEBUG=
CFLAGS= $(DEBUG) -DNO_SCAN_PROTOS
LIB= libcurses.a

OBJS= $(SRCS:.c=.o)


all: $(LIB)

$(LIB): $(OBJS)
	-$(RM) $(LIB)
	$(AR) clq $(LIB) $(OBJS)
	$(RANLIB) $(LIB)
	$(COPY) curses.h gcc:include CLONE
	$(COPY) $(LIB) gcc:lib CLONE

$(OBJS): acurses.h curses.h

clean:
	-delete $(OBJS) TAGS

clobber: clean
	-delete $(LIB)
