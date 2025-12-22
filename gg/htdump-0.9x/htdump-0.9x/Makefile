#
# Makefile      Makefile for htdump
#
#               Remember, in makefiles TABS != spaces
#
#

# CFLAGS	= -O4 -m486 -Wall #-funsigned-char -Wshadow -Wmissing-prototypes -Wmissing-declarations -Winline
CFLAGS	= -O4 -DAMIGAOS -Wall 
PROGS	= htdump
LFLAGS	= -s -Xlinker -s
CC	= gcc

# Nothing should have to change beneath this line

HDRS		= global.h

OBJS		= usage.o init.o read_headers.o main.o enc_password.o mem2hex.o \
                  delnchar.o file.o arguments.o sgets.o getopt.o

all:		$(PROGS)


htdump:		$(OBJS) socket.o
		rm -f htdump
		$(CC) $(LFLAGS) -o htdump $(OBJS) socket.o

ssl:		$(OBJS) socket-ssl.o
		rm -f htdump
		$(CC) $(LFLAGS) -o htdump $(OBJS) socket-ssl.o -lssl -lcrypto -L/usr/local/ssl/lib

$(OBJS):	%.o: %.c $(HDRS)

socket.o:	socket.c $(HDRS)
		$(CC) $(CFLAGS)   -c socket.c

socket-ssl.o:	socket.c socket-ssl.c $(HDRS)
		$(CC) $(CFLAGS)   -c socket-ssl.c -I /usr/local/ssl/include

install:	$(PROGS)
		cp htdump /usr/local/bin

clobber:
		@rm -f *.o *~ core DEADJOE $(PROGS)

clean:		
		@rm -f *.o *~ core DEADJOE
		@echo "Type \"make clobber\" to really clean up."

clear:
		@clear
