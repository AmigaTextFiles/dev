# makefile for SAS 6.50


INCLUDES = usr:include/gl.h usr:include/device.h
OBJECTS = gltest.o
CC = sc
LIBRARIES = LIBRARY usr:lib/gl.lib+lib:scm881.lib+lib:sc.lib+lib:amiga.lib


all: $(BIN)/gltest


### gltest Executable	###
$(BIN)/gltest: $(OBJECTS)
	$(CC) $(OBJECTS) $(LIBRARIES)
	copy gltest $(BIN)/gltest 
	delete gltest


# $(OBJECTS): $(INCLUDES)


### Generic Rule	###
.c.o: $(INCLUDES)
	$(CC) nolink $*.c
	copy $*.c COMPILEbackup
