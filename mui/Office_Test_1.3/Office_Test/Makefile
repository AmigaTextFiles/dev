CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -s -noixemul -O2 -IWork:Development/Workspace/Office_Test -I/usr/local/include 




SRCS = mui.c main.c


OBJS = $(SRCS:.c=.o)

LIB =  Office_Test


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -noixemul -O2 -s -Wall -L/usr/local/lib -Wextra -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
