CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -O2 -s -noixemul -IWork:Development/Tutorials/libUEMF-0.1.6 -IWork:Development/GG/usr/local/include


SRCS = testbed_wmf.c


OBJS = $(SRCS:.c=.o)

LIB = testbed_wmf


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -LWork:Development/Tutorials/libUEMF-0.1.6 -luemf -LWork:Development/GG/usr/local/lib -liconv -s -Wall -Wextra -O2 -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
