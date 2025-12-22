CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -noixemul -IWork:Development/Tutorials/lib3ds-1.3.0 -IWork:Development/GG/usr/local/include \
-IWork:Development/GG/usr/local/include/SDL


SRCS = 3dsplay.c


OBJS = $(SRCS:.c=.o)

LIB = 3dsplay


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -LWork:Development/Tutorials/lib3ds-1.3.0/lib3ds -l3ds -lglut -s -Wall -Wextra -O2 -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
