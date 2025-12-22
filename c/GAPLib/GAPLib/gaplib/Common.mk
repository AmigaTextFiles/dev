OBJ = Evolve.o Testbit.o Flip.o IRange.o \
	CreatePopulation.o EnterGAP.o Crossover.o \
	Random.o DeletePopulation.o Magic.o PopMember.o \
	DefaultFunctions.o HammingDist.o Misc.o Filters.o

lib: $(OBJ)
	$(AR) $(AROPTS) $(LIBRARY) $(OBJ)

all: veryclean lib

clean:
	rm -f $(OBJ) mkver.o mkver increv.o increv VString

veryclean:
	rm -f Evolve.o Testbit.o Flip.o CreatePopulation.o IRange.o \
	EnterGAP.o Crossover.o Random.o DeletePopulation.o Magic.o \
	PopMember.o ../lib/libgap.a

bump: increv
	./increv

increv: increv.c
	$(CC) -o increv increv.c

mkver: mkver.c
	$(CC) -o mkver mkver.c

VString: mkver GAP_Version GAP_Revision
	-chmod 755 mkver
	./mkver c >VString

Evolve.o: Evolve.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c Evolve.c

Magic.o: Magic.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c Magic.c

Testbit.o: Testbit.c
	$(CC) $(CFLAGS) $(INCL) -c Testbit.c

Flip.o: Flip.c
	$(CC) $(CFLAGS) $(INCL) -c Flip.c

IRange.o: IRange.c
	$(CC) $(CFLAGS) $(INCL) -c IRange.c

CreatePopulation.o: CreatePopulation.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c CreatePopulation.c

PopMember.o: PopMember.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c PopMember.c

EnterGAP.o: EnterGAP.c VString
	$(CC) $(CFLAGS) $(INCL) -c EnterGAP.c

Crossover.o: Crossover.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c Crossover.c

Random.o: Random.c
	$(CC) $(CFLAGS) $(INCL) -c Random.c

DeletePopulation.o: DeletePopulation.c
	$(CC) $(CFLAGS) $(INCL) -c DeletePopulation.c

DefaultFunctions.o: DefaultFunctions.c
	$(CC) $(CFLAGS) $(INCL) -c DefaultFunctions.c

HammingDist.o: HammingDist.c
	$(CC) $(CFLAGS) $(INCL) -c HammingDist.c

Misc.o: Misc.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c Misc.c

Filters.o: Filters.c GAPLocal.h
	$(CC) $(CFLAGS) $(INCL) -c Filters.c



