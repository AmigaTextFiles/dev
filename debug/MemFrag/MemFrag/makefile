######################################################################
#
# Makefile to build MemFrag
#
#
#  02 Jul 89 - GMD
#
######################################################################

O=O/
OBJS	=   $(O)MemFrag.o 

MemFrag	: $(OBJS)
	cc -o $(O)date.o date.c
	ln  -g -T  -o MemFrag $(OBJS) $(O)date.o  -lc -ls -lm -lma

$(O)MemFrag.o   : MemFrag.c 
	cc  -n  -o $(O)MemFrag.o MemFrag.c 
