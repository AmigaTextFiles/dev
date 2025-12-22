CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul -IWork:Development/GG/usr/local/include\
-IWork:Development/Tutorials/libpng-1.6.2/scripts

SRCS = png.c pngerror.c\
	pngget.c pngmem.c pngpread.c pngread.c pngrio.c pngrtran.c pngrutil.c\
	pngset.c pngtrans.c pngwio.c pngwrite.c pngwtran.c pngwutil.c\
	png.h pngconf.h pngdebug.h pnginfo.h pngpriv.h pngstruct.h pngusr.dfa

OBJS = $(SRCS:.c=.o)

LIB = libpng.a

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
