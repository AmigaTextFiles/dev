CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -mcpu=750 -mmultiple -fomit-frame-pointer -mfused-madd -ffast-math -noixemul -IWork:Development/Tutorials/lib3ds-1.3.0/lib3ds \
-IWork:Development/Tutorials/lib3ds-1.3.0


SRCS = \
  io.c \
  vector.c \
  matrix.c \
  quat.c \
  tcb.c \
  ease.c \
  chunktable.h \
  chunk.c \
  file.c \
  background.c \
  atmosphere.c \
  shadow.c \
  viewport.c \
  material.c \
  mesh.c \
  camera.c \
  light.c \
  tracks.c \
  node.c

OBJS = $(SRCS:.c=.o)

LIB = lib3ds.a

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
