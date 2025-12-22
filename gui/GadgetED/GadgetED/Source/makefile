#
# GadgetEd version 2.3  Manx MakeFile
#
# Usage: make pre ged
#

FLAG= -so -hi defs.pre

SRC= GadgetEd.c GenSrc.c SetMenus.c Mem.c bin.c rim.c func.c func1.c\
     km_handler.c gfunc.c EditGad.c text.c tsel.c con.c pref.c\
     set_flags.c IDReq.c SPal.c

OBJ= GadgetEd.o GenSrc.o SetMenus.o Mem.o bin.o rim.o func.o func1.o\
     km_handler.o gfunc.o EditGad.o text.o tsel.o con.o pref.o\
     set_flags.o IDReq.o Spal.o

pre:
    cc -ho defs.pre defs.h
.c.o:
    cc $(FLAG) -O $@ $*.c

ged: $(OBJ)
    ln $(OBJ) -ltool -lc -O GadgetEd

