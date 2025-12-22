#*********************************************************************
#
# Title:	btree.fe.M
#
# Function:	btree front-end makefile
#
#*********************************************************************
#
# @(#)btree.fe.M	1.1 7/16/86

CC =		cc

btree.fe :	btree.fe.o btree.o btree.prt.h
		$(CC) -O -o btree.fe btree.fe.o

btree.fe.o :	btree.fe.c btree.fe.h
		$(CC) -c -O btree.fe.c

btree.o :	btree.c btree.h
		$(CC) -c -O btree.c
