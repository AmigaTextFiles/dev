OBJS  = engine.o data.o readlevel.o render.o text.o png.o texture.o
LIB   = ../lib/libvecmat.a ../lib/libutil.a
EXE   = ../Engine

.c.o:
	$(CC) -c $< $(CFLAGS)

all: $(EXE)


$(EXE): $(OBJS) $(LIB)
	$(CC) $(CFLAGS) -o $(EXE) $(OBJS) -L../lib -lvecmat -lutil -lpng -lz -lm
