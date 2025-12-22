# makefile for SAS 6.50

INCLUDES = agl.h usr:include/gl.h usr:include/device.h
OUTPUT = usr:lib/gl.lib
CC = sc


all: $(OUTPUT)


### Amiga GL		###
$(OUTPUT): $(OFILES)
	echo >$(OUTPUT)
	delete $(OUTPUT)
	oml $(OUTPUT) r $(OFILES)


#$(OFILES): $(INCLUDES)


### Generic Rule	###
.c.o: $(INCLUDES)
	$(CC) $*
	copy $*.c COMPILEbackup
