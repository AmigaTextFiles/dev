OBJECTS=expansion/startup.o expansion/configdev.o expansion/expansion_functable.o \
expansion/endcode.o \
exec/startup.o exec/semaphores.o exec/lists.o exec/tasks.o exec/signals.o \
exec/messages.o exec/memory.o exec/devices.o exec/init.o exec/libraries.o \
exec/interrupts.o exec/misc.o exec/machine.o exec/resources.o exec/resident.o \
exec/kernel.o exec/rawdofmt.o exec/exec_functable.o\
exectest/exectest.o exectest/__test_init.o

LIBS=expansion/libexpansion.a expansion/lib_expansion.a \
exec/libexec.a exec/lib_exec.a

boot: $(OBJECTS) $(LIBS)
	gcc -nostdlib $^ -o $@
