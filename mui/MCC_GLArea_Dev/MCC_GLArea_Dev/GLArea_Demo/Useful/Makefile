# Makefile for Common usful functions

CC = gcc
LOPT = -noixemul
COPT = -O3
CPU = -m68040
LIB = -lm -lstubs

# Cancel automatic compliation
%.o: %.c
        
#Cancel automatic linking
%: %.o
        
# All
all: Misc.o Conversion.o StormMesaSupport.o GL_stubs.o install

# Misc
Misc.o: Misc.c Misc.h
	$(CC) $(CPU) $(COPT) -c Misc.c

# Conversion
Conversion.o: Conversion.c Conversion.h
	$(CC) $(CPU) $(COPT) -c Conversion.c

# StormMesaSupport
StormMesaSupport.o: StormMesaSupport.c StormMesaSupport.h
	$(CC) $(CPU) $(COPT) -c StormMesaSupport.c

# GL_stubs
GL_stubs.o: GL_stubs.c GL_stubs.h
	$(CC) $(CPU) $(COPT) -c GL_stubs.c

# install
install:
	ar -r libusefull.a *.o
	copy libusefull.a to gg:os-lib

# Other
clean:
	rm *.o
	rm *.rpo
