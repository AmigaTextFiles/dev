#
# gensymtab
# by megacz
#
-include ../Makefile.i
-include ../Makefile.stubs
-include ../../lib/Makefile.i

PROGGY = gensymtab


CFLAGS = $(OPTLEV) $(STDCPU) $(STDCFLAGS) -I../$(INCPATH) -Wall
LDFLAGS = 
LIBS =


platform: $(PROGGY)

$(PROGGY): $(PROGGY).c
	$(CC) $(CFLAGS) $(LDFLAGS) $(PROGGY).c -o $@ $(LIBS)

clean:

cleanall:
	-rm -f $(PROGGY)
