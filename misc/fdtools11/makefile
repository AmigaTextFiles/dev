#
# makefile for fdtools
#

FILES= fdtools11.readme fdtools.doc makefile SCOPTIONS fd2i fd2pragma \
       fd2stub fdparse.h \
       fd2i.c fd2pragma.c fd2stub.c fdparse.c addext.c

fdtools11.lha: $(FILES)
	lha u $@ $(FILES)

fd2i: fd2i.o fdparse.o addext.o
	slink from lib:cres.o fd2i.o fdparse.o addext.o to fd2i \
        lib lib:sc.lib lib:amiga.lib sc sd

fd2pragma: fd2pragma.o fdparse.o addext.o
	slink from lib:cres.o fd2pragma.o fdparse.o addext.o to fd2pragma \
        lib lib:sc.lib lib:amiga.lib sc sd

fd2stub: fd2stub.o fdparse.o addext.o
	slink from lib:cres.o fd2stub.o fdparse.o addext.o to fd2stub \
        lib lib:sc.lib lib:amiga.lib sc sd

fd2i.o: fd2i.c fdparse.h

fd2pragma.o: fd2pragma.c fdparse.h

fd2stub.o: fd2stub.c fdparse.h

fdparse.o: fdparse.c fdparse.h

addext.o: addext.c

