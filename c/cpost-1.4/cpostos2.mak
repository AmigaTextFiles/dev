COPTS = /ti+ /Gh+ /Q+ /C+ /W3 /Kb+ /DOPSYS_OS2V2
LOPTS = /DEBUG /NOLOGO /PM:VIO /ST:20000

OBJS = \
 cpost.obj\
 cpostp1.obj\
 cpostp2.obj\
 cpostutl.obj\
 cpostpar.obj\
 ctok.obj\
 parsearg.obj\
 list.obj\
 hash.obj\
 tokfile.obj

LIBS = os2386

cpost.exe  : $(OBJS)
	link386 $(LOPTS) $(OBJS),$@,nul,$(LIBS);

.c.obj:
	icc $(COPTS) /Fo$@ $<

cpost.obj    : cpost.h  ctok.h tokfile.h parsearg.h cposthdr.h
cpostp1.obj  : cpost.h  ctok.h
cpostp2.obj  : cpost.h  ctok.h
cpostutl.obj : cpost.h  ctok.h tokfile.h
cpostpar.obj : cpost.h  ctok.h
ctok.obj     : ctok.h
list.obj     : list.h
hash.obj     : hash.h
tokfile.obj  : tokfile.h
parsearg.obj : parsearg.h

clean       :
    del *.obj
    del *.exe
