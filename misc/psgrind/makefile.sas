DESTDIR=c:
LIBDIR=s:
DEFSFILE=vgrindef
INITFILE=vinit.ps
EXEFILE=psgrind
ARCHIVEFILE=t:psgrind.lha ## don't put this in the current directory
CFLAGS=optimize define AMIGA
SOURCES=pfontedp.c vgrindef.c regexp.c
OBJS=pfontedp.o vgrindef.o regexp.o

psgrind: pfontedp.o vgrindef.o regexp.o
	sc link to $(EXEFILE) from $(OBJS) lib lib:sc.lib lib:amiga.lib

pfontedp.o: pfontedp.c
	sc $(CFLAGS) nolink pfontedp.c \
		define DEFSFILE="$(LIBDIR)$(DEFSFILE)" \
		define INITFILE="$(LIBDIR)$(INITFILE)"

install: psgrind $(DEFSFILE) $(INITFILE)
	copy $(EXEFILE) $(DESTDIR)
	copy $(DEFSFILE) $(LIBDIR)
	copy $(INITFILE) $(LIBDIR)

clean:
	"delete *.o *.lnk"

archive:  
	lha a $(ARCHIVEFILE) $(EXEFILE) readme.amiga vgrindef vinit.ps makefile.sas makefile.unix regexp.c pfontedp.c vgrindef.c

