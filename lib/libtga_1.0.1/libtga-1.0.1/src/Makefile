CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul -IWork:Development/Tutorials/libtga-1.0.1/src


SRCS = tga.c 	\
		    tgaread.c 	\
		    tgawrite.c	

OBJS = $(SRCS:.c=.o)

LIB = libtga.a

all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(AR) rc $@ $^
	@$(RANLIB) $@

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
