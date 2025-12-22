CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul

SRCS = mxml-attr.c mxml-entity.c mxml-file.c mxml-get.c \
			mxml-index.c mxml-node.c mxml-search.c mxml-set.c \
			mxml-private.c mxml-string.c \
			mxmldoc.c testmxml.c







OBJS = $(SRCS:.c=.o)

LIB = libmxml.a

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
