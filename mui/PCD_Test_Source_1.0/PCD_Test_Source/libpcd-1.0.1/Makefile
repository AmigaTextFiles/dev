CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm




CFLAGS = -O2 -D__BIG_ENDIAN__ -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul







SRCS = file.c yuv2rgb.c huff.c inter.c



OBJS = $(SRCS:.c=.o)

LIB = libpcd.a

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
