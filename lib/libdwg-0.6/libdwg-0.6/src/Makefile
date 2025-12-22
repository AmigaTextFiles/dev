CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

TOPDIR = ../


CFLAGS = -O2 -Wextra -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul -I/usr/local/include -L/usr/local/lib  -lz -lm 
 






SRCS = \
	dwg.c \
	bits.c \
	decode.c \
        decode_r2000.c \
        decode_r2004.c \
        variables.c \
        object.c \
	logging.c \
		auto_variables.c \
		auto_variables_free.c \
		auto_object.c \
		auto_object_free.c \
		auto_entity_handle.c\
		auto_variables.c \
		auto_variables_free.c \
		auto_object.c \
		auto_object_free.c \
		auto_entity_handle.c






OBJS = $(SRCS:.c=.o)

LIB = libdwg.a

all: $(LIB)

%.o: %.c *.h 
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c $(CFLAGS) -o $*.o 

$(LIB): $(OBJS)
	@echo Making $@...
	@$(AR) rc $@ $^
	@$(RANLIB) $@

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
