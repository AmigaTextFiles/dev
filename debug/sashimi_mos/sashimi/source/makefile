# If you use another compiler change the following line:
CC 	  = ppc-morphos-gcc
CDEFS   = -DUSE_INLINE_STDARG -D__NOLIBBASE__
CWARN   = -Wall
CFLAGS  = $(CDEFS) $(CWARN) -noixemul -O3 -fomit-frame-pointer -mcpu=750 -finline-functions -mstring -mmultiple
LDFLAGS = -noixemul

OBJS = sashimi.o

sashimi: $(OBJS)
		  $(CC) $(LDFLAGS) -o $@ $(OBJS)
		  ppc-morphos-strip --remove-section=.comment $@

sashimi.o: sashimi.c

clean:
	@delete #?.o
