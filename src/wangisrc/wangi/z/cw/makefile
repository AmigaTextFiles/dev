#
# CC and GCC
#CC = CC
CC = g++
#CC = gcc
LINK = 
NOLINK = -c
PNS = -o
OPT =
#OPT = -g

#
# SAS/C++
#
#CC = SC
#LINK = LINK
#NOLINK = NOLINK
#PNS = PNAME
#OPT =


#
# Global
#
PROGNAME = cw
OBJS = cw.o ui.o journey.o seat.o

$(PROGNAME): $(OBJS)
	$(CC) $(OPT) $(LINK) $(PNS) $@ $(OBJS)

seat.o: seat.cxx seat.h
	$(CC) $(OPT) $(NOLINK) seat.cxx

journey.o: journey.cxx journey.h seat.h
	$(CC) $(OPT) $(NOLINK) journey.cxx

ui.o: ui.cxx ui.h journey.h
	$(CC) $(OPT) $(NOLINK) ui.cxx

cw.o: cw.cxx ui.h
	$(CC) $(OPT) $(NOLINK) cw.cxx

clean:
	-rm *%
	-rm *.o
	-rm *.jny

dist:
	rm cw.lha
	lha a cw.lha *.cxx *.h makefile


