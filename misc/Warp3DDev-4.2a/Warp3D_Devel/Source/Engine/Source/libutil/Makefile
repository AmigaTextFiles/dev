OBJS  = lex.o timer.o
LIB   = ../lib/libutil.a

.c.o:
	$(CC) -c $< $(CFLAGS)

$(LIB): $(OBJS)
	ar -rc $(LIB) $(OBJS)

