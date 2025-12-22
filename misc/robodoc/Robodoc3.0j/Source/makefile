#
# Makefile, for SAS C compiler v6.x and Dice
#
# guide:   make autodocs for robodoc in guide format
# html:    make autodocs for robodoc in html format
# robodoc: make robodoc
#
#

# use DICE C under AmigaOS
#--------------------------------------
#CC = dcc
#CFLAGS =

# use gcc (optimising for AmigaOS)
#--------------------------------------
#CC = gcc
#CFLAGS = -O2 -fstrength-reduce -s -m68020-40 -noixemul

# use gcc (generic)
#--------------------------------------
CC = gcc
CFLAGS = -Wall


#
# GUIDE
#

guide: robodoc.h.guide robodoc.c.guide
	amigaguide robodoc.c.guide

robodoc.c.guide: robodoc.c.guide.xref robodoc.h.guide.xref robodoc robodoc.defaults
	robodoc robodoc.c robodoc.c.guide GUIDE -s -i -x robodoc.guide.xrefs -ts 2 -v

robodoc.h.guide: robodoc.c.guide.xref robodoc.h.guide.xref robodoc robodoc.defaults
	robodoc robodoc.h robodoc.h.guide GUIDE -s -i -x robodoc.guide.xrefs -ts 2 -v

robodoc.c.guide.xref: robodoc.c robodoc
	robodoc robodoc.c robodoc.c.guide -g robodoc.c.guide.xref -v

robodoc.h.guide.xref: robodoc.h robodoc
	robodoc robodoc.h robodoc.h.guide -g robodoc.h.guide.xref -v

#
# HTML
#

html: robodoc.h.html robodoc.c.html
	lynx robodoc.c.html

robodoc.c.html: robodoc.c.html.xref robodoc.h.html.xref robodoc
	robodoc robodoc.c robodoc.c.html HTML -s -i -x robodoc.html.xrefs -ts 2 -v

robodoc.h.html: robodoc.c.html.xref robodoc.h.html.xref robodoc
	robodoc robodoc.h robodoc.h.html HTML -s -i -x robodoc.html.xrefs -ts 2 -v

robodoc.c.html.xref: robodoc.c robodoc
	robodoc robodoc.c robodoc.c.html -g robodoc.c.html.xref -v

robodoc.h.html.xref: robodoc.h robodoc
	robodoc robodoc.h robodoc.h.html -g robodoc.h.html.xref -v


#
# ROBODOC
#


robodoc: robodoc.c robodoc.h
	$(CC) $(CFLAGS) -o robodoc robodoc.c

#
# Clean
#

clean:
	rm -f *.guide
	rm -f *.html
	rm -f robodoc
	rm -f *.xref
	rm -f *~

