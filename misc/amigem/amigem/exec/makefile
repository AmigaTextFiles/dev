PREINCLUDE=exec/devices exec/semaphores exec/io exec/memory dos/dos

TARGET=exec
LIBBASE=SysBase
LIBTYPE=struct ExecBase
OBJECTS=startup.o semaphores.o lists.o tasks.o signals.o messages.o memory.o devices.o \
init.o libraries.o interrupts.o misc.o machine.o resources.o resident.o kernel.o \
rawdofmt.o
LIBS=../expansion/libexpansion.a

CC=gcc
CFLAGS=-Wall -freg-struct-return -O3

include ../macro/makefile

%.o: %.c
	$(CC) $(CFLAGS) -I .. -c $^ 2>&1|tee $*.err
	-if test ! -s $*.err; then rm $*.err; fi

$(TARGET).library: $(OBJECTS) $(TARGET)_functable.o lib$(TARGET).a lib_$(TARGET).a $(LIBS)
	$(CC) -nostdlib -s $^ -o $@
