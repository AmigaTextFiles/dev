O = Gadget.o Message.o Simple.o TextGadget.o StringGadget.o PropGadget.o
O = $O Scrollbar.o TextButton.o CycleGadget.o Listview.o MX.o Palette.o
O = $O Element.o
O = $O chip.o utility.o

CFLAGS = -bs -mcd -wup -hi struct.pre
LDFLAGS=-lamigal -lcl

.c.pro:
	protos $*

ALL: test
LIB: library


test: $O test.o gadget_stub.o
	ln test $O gadget_stub.o $(LDFLAGS)

debug: $O test.o gadget_stub.o
	ln -w -g test $O gadget_stub.o $(LDFLAGS)

library:
	@Echo "#This file is generated automatically. Don't Edit!" >:tmp/0
   @echo ".c.libo:" >:tmp/1
	@echo "	cc \$(CFLAGS) -o \$**.libo \$**.c" >:tmp/2
	@copy	Makefile :tmp/m
	@sed "s/\.o/.libo/g" :tmp/m >:tmp/3
	@join :tmp/0 :tmp/1 :tmp/2 :tmp/3 AS Makefile.lib
	@make -f Makefile.lib gadget.lib gadget.library testl "CFLAGS=-mcd -so -hi struct.pre -DLIBRARY"

gadget.library:	$O
	ln -o gadget.library $O -lGadget $(LDFLAGS)
	copy gadget.library libs:gadget.library
	copy gadget.h prog:aztec/Include/Libraries/
	copy gadget_lib.h prog:aztec/Include/pragma/
   avail flush

testl: test.libo
	ln -w -g -o testl test.libo -lgadget $(LDFLAGS)
test.libo: test.c
	cc -bs -DLIBRARY -hi struct.pre -o test.libo test.c

protos:
	@echo "# This file is generated automatically. Don't Edit!" >:tmp/0
   @echo "PRO= " >:tmp/1 NOLINE
	@echo "$O" >:tmp/o
	@sed "s/\.o/.pro/g" :tmp/o >:tmp/2
   @echo "protos.really: \$(PRO)" >:tmp/3
	@join :tmp/0 :tmp/1 :tmp/2 Makefile :tmp/3 AS Makefile.pro
	@make -f Makefile.pro protos.really


lha:
	lha -r u Gadget *.c *.asm *.h Makefile *.doc

clean:
	delete >NIL: #?.o #?.libo #?.lib #?.pro #?.pre #?.dbg #?.tmp test testl gadget.library

gadget.lib: Gadget_stub.libo
	lb gadget.lib Gadget_Stub.libo
	copy gadget.lib prog:aztec/lib/
gadget_stub.libo: gadget_stub.c struct.pre
	cc -o gadget_stub.libo -mcd -so -hi struct.pre -DLIBRARY gadget_stub.c

struct.pre: struct.h gadget.h gadgetprivate.h
   cc -a -o NIL: -ho struct.pre struct.h

CycleGadget.o:	CycleGadget.c struct.pre
Gadget.o: 	Gadget.c libstart.asm struct.pre
Listview.o:	Listview.c struct.pre
Message.o:	Message.c struct.pre
MX.o:	MX.c struct.pre
Palette.o:	Palette.c struct.pre
PropGadget.o: PropGadget.c struct.pre
Simple.o:	Simple.c struct.pre
Scrollbar.o: Scrollbar.c struct.pre
StringGadget.o: StringGadget.c struct.pre
chip.o:		chip.c struct.pre
Element.o:		Element.c struct.pre
utility.o: utility.c struct.pre

gadget.pro:	gadget.c gadget_stub.c
	protos gadget
	protos gadget_stub
	-@delete >NIL: gadget.tmp
	rename gadget.pro gadget.tmp
	join gadget.tmp gadget_stub.pro AS gadget.pro

libstart.o: libstart.asm
