OBJS  = vecmat.o 3d.o
LIB   = ../lib/libvecmat.a

.c.o:
	$(CC) -c $< $(CFLAGS)

$(LIB): $(OBJS)
	ar -rc $(LIB) $(OBJS)

