#
# Makefile for sepp
#

CC	= gcc
CFLAGS	=

sepp	: older.o sepp.o
	$(CC) $(CFLAGS) older.o sepp.o -o sepp

sepp.o	: sepp.c
	$(CC) $(CFLAGS) -c sepp.c

older.o	: older.c
	$(CC) $(CFLAGS) -c older.c

# EOF
