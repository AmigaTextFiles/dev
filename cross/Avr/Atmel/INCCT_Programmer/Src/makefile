INCCT: incct.o timer.o gadget.o filereq.o progress.o
	vc incct.o timer.o gadget.o filereq.o progress.o -o INCCT -lmieee

incct.o: incct.c globdefs.h
	vc -c incct.c -o incct.o 

timer.o: timer.c
	vc -c timer.c -o timer.o

gadget.o: gadget.c globdefs.h
	vc -c gadget.c -o gadget.o

filereq.o: filereq.c
	vc -c filereq.c -o filereq.o

progress.o: progress.c
	vc -c progress.c -o progress.o
