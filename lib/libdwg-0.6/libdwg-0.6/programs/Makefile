CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -s -noixemul -IWork:Development/Tutorials/libdwg-0.6/programs -I/usr/local/include -IWork:Development/Tutorials/libdwg-0.6/src









SRCS = dwg-dxf.c dump_variables.c dump_objects.c dump_entity_handle.c



OBJS = $(SRCS:.c=.o)

LIB = dwg-dxf


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -noixemul -s -Wall -Wextra -LWork:Development/Tutorials/libdwg-0.6/src -ldwg -lm -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
