CFLAGS = -DOPSYS_LINUX
CC     = gcc

OBJS = \
 cpost.o\
 cpostp1.o\
 cpostp2.o\
 cpostutl.o\
 cpostpar.o\
 ctok.o\
 parsearg.o\
 list.o\
 hash.o\
 tokfile.o

cpost: $(OBJS)
	gcc -o cpost $(OBJS)

cpost.o    : cpost.h  ctok.h tokfile.h parsearg.h cposthdr.h
cpostp1.o  : cpost.h  ctok.h
cpostp2.o  : cpost.h  ctok.h
cpostutl.o : cpost.h  ctok.h tokfile.h
cpostpar.o : cpost.h  ctok.h
ctok.o     : ctok.h
parsearg.o : parsearg.h
list.o     : list.h
hash.o     : hash.h
tokfile.o  : tokfile.h


clean:
	rm $(OBJS)
	rm cpost
