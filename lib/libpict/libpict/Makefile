CC = gcc -mcrt=newlib
AR = ar
RM = delete
CFLAGS = -O2 -g -D__USE_INLINE__ #-DDEBUG

LIBNAME = libpict.a
LIB_OBJS = pict.o io.o read.o #write.o

all: $(LIBNAME) pictview

$(LIBNAME): $(LIB_OBJS)
	$(AR) -crv $@ $^

pictview: pictview.o $(LIBNAME)
	$(CC) -o $@ $^ -lauto -lraauto
	
clean:
	$(RM) pictview.o $(LIB_OBJS)
