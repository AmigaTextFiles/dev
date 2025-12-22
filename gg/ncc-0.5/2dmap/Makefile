
CC = gcc
LCFLAGS = -Wall
CFLAGS = $(LCFLAGS) -c -g -O2

#PROT=-lefence -DEFENCE
PROT=

2dmap: 2dmap.C ../objdir/dbstree.o dLIST.o
	$(CC) 2dmap.C -I.. -lncurses -o 2dmap ../objdir/dbstree.o dLIST.o $(LCFLAGS)

dLIST.o: dLIST.[Ch]
	$(CC) $(CFLAGS) dLIST.C

wc:
	wc *.[Ch] | sort -n

clean:
	rm -f dLIST.o 2dmap
