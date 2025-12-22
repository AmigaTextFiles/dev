all:  edlist chgpwd logout deled hl2ilbm ilbm2hl hl2text text2hl hliff login

#############################################################################

LE=LC:blink
CC=LC:lc
CFLAGS=-b1 -cciktsw -d0 -fl -j100i -m0t -O -qram: -r1 -v

#############################################################################
edlist: edlist.o
        $(LE) FROM lib:c.o edlist.o LIB lib:lc.lib TO edlist
       
edlist.o: edlist.c
        $(CC) $(CFLAGS) edlist.c

#############################################################################
chgpwd: chgpwd.o 
        $(LE) FROM lib:c.o chgpwd.o LIB lib:lc.lib TO chgpwd

chgpwd.o: chgpwd.c
        $(CC) $(CFLAGS) chgpwd.c

#############################################################################
logout: logout.o
        $(LE) FROM lib:c.o logout.o LIB lib:lc.lib TO logout

logout.o: logout.c
        $(CC) $(CFLAGS) logout.c

#############################################################################
deled: deled.o
        $(LE) FROM lib:c.o deled.o LIB lib:lc.lib TO deled

deled.o: deled.c
        $(CC) $(CFLAGS) deled.c

#############################################################################
hl2ilbm: hl2ilbm.o
        $(LE) FROM lib:c.o hl2ilbm.o LIB lib:lc.lib TO hl2ilbm

hl2ilbm.o: hl2ilbm.c
        $(CC) $(CFLAGS) hl2ilbm.c

#############################################################################
ilbm2hl: ilbm2hl.o
        $(LE) FROM lib:c.o ilbm2hl.o LIB lib:lc.lib TO ilbm2hl

ilbm2hl.o: ilbm2hl.c
        $(CC) $(CFLAGS) ilbm2hl.c

#############################################################################
hl2text: hl2text.o
        $(LE) FROM lib:c.o hl2text.o LIB lib:lc.lib TO hl2text

hl2text.o: hl2text.c
        $(CC) $(CFLAGS) hl2text.c

#############################################################################
text2hl: text2hl.o
        $(LE) FROM lib:c.o text2hl.o LIB lib:lc.lib TO text2hl

text2hl.o: text2hl.c
        $(CC) $(CFLAGS) text2hl.c

#############################################################################
hliff: hliff.o
        $(LE) FROM lib:c.o hliff.o LIB lib:lc.lib TO hliff ND

hliff.o: hliff.c
        $(CC) $(CFLAGS) hliff.c

#############################################################################
login: login.o
        $(LE) FROM lib:c.o login.o LIB lib:lc.lib TO login

login.o: login.c
        $(CC) $(CFLAGS) login.c
