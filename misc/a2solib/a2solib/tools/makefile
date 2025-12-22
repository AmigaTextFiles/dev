include ../rules.make

ifeq ($(shell uname), AmigaOS)
LIBS=-lunix
endif

all: genso

genso: gen.c 
	$(CCNAT) -O2 -Wall -g -DNDEBUG -I$(TOPDIR)include -o genso gen.c $(LIBS)

clean:
	-$(RM) genso$(EXE)
	
install: genso
	$(CP) genso $(BINSTDIR)

