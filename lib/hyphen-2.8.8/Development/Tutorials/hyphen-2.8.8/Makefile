CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -noixemul -I- -IWork:Development/Tutorials/hyphen-2.8.8








SRCS = example.c


OBJS = $(SRCS:.c=.o)

LIB = Hyphenation


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -noixemul -s -L/usr/local/lib -LWork:Development/Tutorials/hyphen-2.8.8 -lhyphen  -Wall -Wextra -O2 -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
