CC = ppc-morphos-gcc
AR = ppc-morphos-ar
RANLIB = ppc-morphos-ranlib
RM = rm

CFLAGS = -s -noixemul -O2 -IRam:Epub_mcc.0.4 -I/usr/local/include 




SRCS = mui.c main.c


OBJS = $(SRCS:.c=.o)

LIB = EPUB-Reader


all: $(LIB)

%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS)  -noixemul -O2 -s -Wall -Wextra -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)
