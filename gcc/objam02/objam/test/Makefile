# Makefile for ObjectiveAmiga test programs


CC		= gcc
CFLAGS		= $(PAR_GCC_FLAGS)

RM		= rm -f
ALL		= objcTest objamTest objbasTest runtimeTest rexxTest objtritonTest

OBJCINIT	= $(OBJCLIBDIR)/objc_init.o

.SUFFIXES: .m


.m.o:
	$(CC) $(CFLAGS) -o $@ -c $<


default: objamTest objtritonTest

all: $(ALL)

objcTest: objcTest.o fooObject.o fooObject.h # ../objc/libobjc.a
	gcc $(CFLAGS) -o objcTest $(OBJCINIT) objcTest.o fooObject.o -lobjc

objbasTest: objbasTest.o ../objc/libobjc.a # ../objbas/libobjbas.a
	gcc $(CFLAGS) -o objbasTest $(OBJCINIT) objbasTest.o -lobjbas -lobjc

objamTest: objamTest.o fooObject.o fooObject.h # ../objc/libobjc.a ../objam/libobjam.a
	gcc $(CFLAGS) -o objamTest $(OBJCINIT) objamTest.o fooObject.o -lobjam -lobjc

objtritonTest: objtritonTest.o # ../objc/libobjc.a ../objam/libobjam.a ../objtriton/libobjtriton.a
	gcc $(CFLAGS) -o objtritonTest $(OBJCINIT) objtritonTest.o -lobjtriton -ltriton -lobjam -lobjc

runtimeTest: runtimeTest.o # ../objc/libobjc.a
	gcc $(CFLAGS) -o runtimeTest $(OBJCINIT) runtimeTest.o -lobjc

rexxTest: rexxTest.o # ../objc/libobjc.a ../objam/libobjam.a
	gcc $(CFLAGS) -o rexxTest $(OBJCINIT) rexxTest.o -lobjam -lobjc

clean:
	$(RM) *.o $(ALL)
