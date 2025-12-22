# 	Makefile for libmat.a v0.1



CC=gcc
FLAGS=-O3 #-DDEBUG -DCHECK

OBJS=	version.o meig.o mdet.o mlr.o mconstdiv.o mdiv.o mvdiv.o \
		minv.o e.o msolve.o mgauss.o mprint.o mread.o mmult.o \
		mconstmult2.o mconstmult1.o mplus.o mass.o mdest.o mneq.o meq.o I.o dealloc.o \
		alloc.o Mtrans.o mconst1.o mconst2.o mconst3.o mconst4.o mconst5.o \
		mminus.o mconst6.o mget.o


libmat.a: 	$(OBJS)
			ar qc libmat.a $(OBJS)
			ranlib libmat.a
			cp libmat.a /gnu/lib/

all:	libmat.a 

install: all

version.o: 
	$(CC) version.cc -c $(FLAGS)	
meig.o:
	$(CC) meig.cc -c $(FLAGS)
mdet.o:
	$(CC) mdet.cc -c $(FLAGS)
mlr.o:
	$(CC) mlr.cc -c $(FLAGS)
mconstdiv.o:
	$(CC) mconstdiv.cc -c $(FLAGS)
mdiv.o:
	$(CC) mdiv.cc -c $(FLAGS)
mvdiv.o:
	$(CC) mvdiv.cc -c $(FLAGS)
minv.o:
	$(CC) minv.cc -c $(FLAGS)
e.o:
	$(CC) e.cc -c $(FLAGS)
msolve.o:
	$(CC) msolve.cc -c $(FLAGS)
mgauss.o:
	$(CC) mgauss.cc -c $(FLAGS)
mprint.o:
	$(CC) mprint.cc -c $(FLAGS)
mread.o:
	$(CC) mread.cc -c $(FLAGS)
mmult.o:	
	$(CC) mmult.cc -c $(FLAGS)
mconstmult2.o:
	$(CC) mconstmult2.cc -c $(FLAGS)
mconstmult1.o:
	$(CC) mconstmult1.cc -c $(FLAGS)
mplus.o:
	$(CC) mplus.cc -c $(FLAGS)
mass.o:
	$(CC) mass.cc -c $(FLAGS)
mdest.o:
	$(CC) mdest.cc -c $(FLAGS)
mconst5.o:	
	$(CC) mconst5.cc -c $(FLAGS)
mconst4.o:
	$(CC) mconst4.cc -c $(FLAGS)
mconst3.o:
	$(CC) mconst3.cc -c $(FLAGS)
mconst2.o:
	$(CC) mconst2.cc -c $(FLAGS)
mconst1.o:
	$(CC) mconst1.cc -c $(FLAGS)
mneq.o:
	$(CC) mneq.cc -c $(FLAGS)
meq.o:
	$(CC) meq.cc -c $(FLAGS)
I.o:
	$(CC) I.cc -c $(FLAGS)
dealloc.o:
	$(CC) dealloc.cc -c $(FLAGS)
alloc.o:
	$(CC) alloc.cc -c $(FLAGS)
Mtrans.o:
	$(CC) mtrans.cc -c $(FLAGS)
mminus.o:
	$(CC) mminus.cc -c $(FLAGS)
mconst6.o:
	$(CC) mconst6.cc -c $(FLAGS)
mget.o:
	$(CC) mget.cc -c $(FLAGS)
