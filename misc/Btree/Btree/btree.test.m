#*********************************************************************
#
# Title:	btree.test.M
#
# Function:	btree test makefile
#
#*********************************************************************
#
# @(#)btree.test.M	1.1 7/16/86

CC =		cc

btree.test :	btree.test.o btree.o btree.prt.h
		$(CC) -O -o btree.test btree.test.o

btree.test.o :	btree.test.c btree.test.h
		$(CC) -c -O btree.test.c

btree.o :	btree.c btree.h
		$(CC) -c -O btree.c
