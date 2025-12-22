# ObjectiveAmiga: Global Makefile
# See GNU:lib/libobjam/ReadMe for details


RM		= rm -f
CP		= cp
AUTODOC		= /sys/shell-tools/autodoc

GCC258INCLUDE	= /gnu/lib/gcc-lib/mc68000-cbm-amigados/2.5.8/include
OBJCLIBDIR	= /gnu/lib/libobjam
OBJCINCDIR	= /gnu/lib/libobjam/include

PAR_GCC_FLAGS	= -Wno-import -Wno-protocol -V2.5.8 -O2 -s \
		  -noixemul -I$(OBJCINCDIR) -L$(OBJCLIBDIR) # -v

FLAGS_TO_PASS	= "OBJCLIBDIR=$(OBJCLIBDIR)" \
		  "OBJCINCDIR=$(OBJCINCDIR)" \
		  "PAR_GCC_FLAGS=$(PAR_GCC_FLAGS)"

ADOC_SRC	= runtime/zone.c

default:	objc.library \
		libobjc.a \
		libobjbas.a \
		libobjam.a \
		libobjtriton.a \
		objc_init.o

all:		default demos ReadMe doc/objam.adoc

libobjc.a:
	cd objc; make $(FLAGS_TO_PASS)

libobjbas.a:
	cd objbas; make $(FLAGS_TO_PASS)

libobjam.a:
	cd objam; make $(FLAGS_TO_PASS)

libobjtriton.a:
	cd objtriton; make $(FLAGS_TO_PASS)

objc_init.o:
	cd init; make $(FLAGS_TO_PASS)

objc.library:
	cd runtime; make $(FLAGS_TO_PASS)

demos:
	cd test; make $(FLAGS_TO_PASS)

ReadMe: doc/objam.texi
	tex:texinfo/makeinfo --amiga --no-split --no-headers -o ReadMe doc/objam.texi
	$(CP) ReadMe $(OBJCLIBDIR)/

doc/objam.adoc: $(ADOC_SRC)
	$(AUTODOC) -C -Ft:tmpfile -I $(ADOC_SRC) >doc/objam.adoc

clean:
	cd objc; make clean
	cd objbas; make clean
	cd objam; make clean
	cd objtriton; make clean
	cd init; make clean
	cd runtime; make clean
	cd test; make clean
	-$(RM) doc/objam.adoc

install: prepare all

prepare:
	-mkdir $(OBJCLIBDIR)
	-mkdir $(OBJCINCDIR)
	-mkdir $(OBJCINCDIR)/clib
	-mkdir $(OBJCINCDIR)/inline
	-mkdir $(OBJCINCDIR)/libraries
	-mkdir $(OBJCINCDIR)/objam
	-mkdir $(OBJCINCDIR)/objbas
	-mkdir $(OBJCINCDIR)/objc
	-mkdir $(OBJCINCDIR)/objtriton
	-mkdir $(OBJCINCDIR)/proto
	-mv /gnu/lib/libobjc.a /gnu/lib/libobjc.a_noObjAm
	-mv $(GCC258INCLUDE)/objc $(GCC258INCLUDE)/objc_noObjAm

remove:
	-$(RM) -r $(OBJCLIBDIR)
	-$(RM) /libs/objc-*.library
	-mv /gnu/lib/libobjc.a_noObjAm /gnu/lib/libobjc.a
	-mv $(GCC258INCLUDE)/objc_noObjAm $(GCC258INCLUDE)/objc
