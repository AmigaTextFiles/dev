CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -noixemul -IWork:Development/Tutorials/libtga-1.0.1/src 


SRCS = encode.c


OBJS = $(SRCS:.c=.o)

LIB = encode


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -LWork:Development/Tutorials/libtga-1.0.1/src -ltga -s -ltga -Wall -Wextra -O2 -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
