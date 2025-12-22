CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul

SRCS = convert.c librtf.c parser.c rtfproc.c
OBJS = $(SRCS:.c=.o)

LIB = librtf.a

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
