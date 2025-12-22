test: T:lpre.pre test.o win.o scr.o init.o gad.o cgad.o sgad.o wall.o pntr.o gfx.o menu.o gadext.o ext.o help.o GER:multidesktop.catalog T:amiga.lib
 ln -o T:test    test.o win.o scr.o init.o gad.o cgad.o sgad.o wall.o pntr.o gfx.o menu.o gadext.o ext.o help.o desk/multidesk.o system/sys.o +q -lT:amiga -lT:m8l32 -lT:cl32
 copy T:test ""

test.o: test.c multiwindows.h
 cc test.c +P +F8 -S +Icc:pre/lpre.pre -O T:test.o
 copy T:test.o ""

win.o: win.c multiwindows.h
 cc win.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:win.o
 copy T:win.o ""

scr.o: scr.c multiwindows.h
 cc scr.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:scr.o
 copy T:scr.o ""

wall.o: wall.c multiwindows.h
 cc wall.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:wall.o
 copy T:wall.o ""

gfx.o: gfx.c multiwindows.h
 cc gfx.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:gfx.o
 copy T:gfx.o ""

pntr.o: pntr.c multiwindows.h
 cc pntr.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:pntr.o
 copy T:pntr.o ""

gad.o: gad.c multiwindows.h
 cc gad.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:gad.o
 copy T:gad.o ""

cgad.o: cgad.c multiwindows.h
 cc cgad.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:cgad.o
 copy T:cgad.o ""

gadext.o: gadext.c multiwindows.h
 cc gadext.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:gadext.o
 copy T:gadext.o ""

ext.o: ext.c multiwindows.h
 cc ext.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:ext.o
 copy T:ext.o ""

help.o: help.c multiwindows.h
 cc help.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:help.o
 copy T:help.o ""

GER:multidesktop.catalog: multi.txt
 makecat multi.txt multidesktop.catalog

T:amiga.lib: cc:lib/amiga.lib
 copy cc:lib/amiga.lib T:
 copy ccs:lib/cl32.lib T:
 copy ccs:lib/m8l32.lib T:

T:lpre.pre: cc:pre/lpre.pre
 copy cc:pre/lpre.pre T:

init.o: init.c multiwindows.h
 cc init.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:init.o
 copy T:init.o ""

sgad.o: sgad.c multiwindows.h
 cc sgad.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:sgad.o
 copy T:sgad.o ""

menu.o: menu.c multiwindows.h
 cc menu.c +B +P +F8 -S +Icc:pre/lpre.pre -O T:menu.o
 copy T:menu.o ""

menutest: menutest.o
 ln menutest.o +q -lc32

menutest.o: menutest.c
 cc menutest.c +L -S +Icc:pre/pre.pre

ptr: ptr.o
 ln ptr.o +q -lc32

ptr.o: ptr.c
 cc ptr.c +L -S +Icc:pre/pre.pre

hook: hook.o hk.o T:amiga.lib
 ln hook.o hk.o desk/multidesk.o +q -lT:amiga -lT:cl32

hook.o: hook.c
 cc hook.c +P -S +Icc:pre/lpre.pre

hk.o: hk.c
 cc hk.c +B +P -S +Icc:pre/lpre.pre

fmt: fmt.o T:amiga.lib
 ln fmt.o desk/multidesk.o +q -lT:amiga -lT:cl32

fmt.o: fmt.c
 cc fmt.c +P -S +Icc:pre/lpre.pre

