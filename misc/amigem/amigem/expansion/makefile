PREINCLUDE=libraries/configvars dos/dos

TARGET=expansion
LIBBASE=ExpansionBase
LIBTYPE=struct ExpansionBase
OBJECTS=startup.o configdev.o $(TARGET)_functable.o
LIBS=../exec/libexec.a lib$(TARGET).a lib_$(TARGET).a
ENDOBJ=endcode.o
DEPEND=$(OBJECTS) $(LIBS) $(ENDOBJ)

CC=gcc
CFLAGS=-Wall -freg-struct-return -O3

include ../macro/makefile

%.o: %.c
	$(CC) $(CFLAGS) -I .. -c $^ 2>&1|tee $*.err
	-if test ! -s $*.err; then rm $*.err; fi

$(TARGET).library: $(DEPEND)
	$(CC) -nostdlib -s $^ -o $@
