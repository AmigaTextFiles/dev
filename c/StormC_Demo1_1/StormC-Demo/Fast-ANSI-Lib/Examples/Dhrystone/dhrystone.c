#include <pragma/exec_lib.h>


#define LOOPS	60000

char	Ver[] = "$VER: Dhrystone 2.1 68020+ (19.4.96)";

#define	structassign(d, s)	d = s

typedef enum	{Ident1, Ident2, Ident3, Ident4, Ident5} Enumeration;

typedef int	OneToThirty;
typedef int	OneToFifty;
typedef char	CapitalLetter;
typedef char	String30[31];
typedef int	Array1Dim[51];
typedef int	Array2Dim[51][51];

struct	Record
{
	struct Record		*PtrComp;
	Enumeration		Discr;
	Enumeration		EnumComp;
	OneToFifty		intComp;
	String30		StringComp;
};

typedef struct Record 	RecordType;
typedef RecordType *	RecordPtr;
typedef int		boolean;

#define	TRUE		1
#define	FALSE		0

#define	REG

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


GetSYSTime();
void Proc0();
void Proc1(REG RecordPtr PtrParIn);
void Proc2(OneToFifty *intParIO);
void Proc3();
void Proc4();
void Proc5();
void Proc6(REG Enumeration EnumParIn, REG Enumeration *EnumParOut);
void Proc7(OneToFifty intParI1, OneToFifty intParI2, OneToFifty *intParOut);
void Proc8(Array1Dim Array1Par, Array2Dim Array2Par, OneToFifty intParI1, OneToFifty intParI2);
Enumeration Func1(CapitalLetter CharPar1, CapitalLetter CharPar2);
boolean Func2(String30 StrParI1, String30 StrParI2);
boolean Func3(REG Enumeration EnumParIn);

/*
 * Package 1
 */
int		intGlob;
boolean		BoolGlob;
char		Char1Glob;
char		Char2Glob;
Array1Dim	Array1Glob;
Array2Dim	Array2Glob;
RecordPtr	PtrGlb;
RecordPtr	PtrGlbNext;


void Proc0()
{
     unsigned long time1,time2,time3;
	OneToFifty		intLoc1;
	REG OneToFifty		intLoc2;
	OneToFifty		intLoc3;
	REG char		CharIndex;
	Enumeration	 	EnumLoc;
	String30		String1Loc;
	String30		String2Loc;
	REG int			i;

	PtrGlbNext = (RecordPtr) malloc(sizeof(RecordType));
	PtrGlb = (RecordPtr) malloc(sizeof(RecordType));
	PtrGlb->PtrComp = PtrGlbNext;
	PtrGlb->Discr = Ident1;
	PtrGlb->EnumComp = Ident3;
	PtrGlb->intComp = 40;
	strcpy(PtrGlb->StringComp, "DHRYSTONE PROGRAM, SOME STRING");
	strcpy(String1Loc, "DHRYSTONE PROGRAM, 1'ST STRING");	/*GOOF*/

	Array2Glob[8][7] = 10;	/* Was missing in published program */

/*****************
-- Start Timer --
*****************/

Forbid();
time1=GetSYSTime();

	for (i = 0; i < LOOPS; ++i)
	{

		Proc5();
		Proc4();
		
		intLoc1 = 2;
		intLoc2 = 3;
		strcpy(String2Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
		EnumLoc = Ident2;
		BoolGlob = ! Func2(String1Loc, String2Loc);
		while (intLoc1 < intLoc2)
		{
			intLoc3 = 5 * intLoc1 - intLoc2;
			Proc7(intLoc1, intLoc2, &intLoc3);
			intLoc1 += 1;
		}
		Proc8(Array1Glob, Array2Glob, intLoc1, intLoc3);
		Proc1(PtrGlb);
		for (CharIndex = 'A'; CharIndex <= Char2Glob; ++CharIndex)
		{
			if (EnumLoc == Func1(CharIndex, 'C'))
			{
				Proc6(Ident1, &EnumLoc);
				strcpy(String1Loc, "DHRYSTONE PROGRAM, 3'ST STRING");
				intLoc2 = i;
				intGlob = i;
			}
		}
		intLoc2 = intLoc2 * intLoc1;
		intLoc1 = intLoc2 / intLoc3;
		intLoc2 = 7 * (intLoc2 - intLoc3) - intLoc1;
		Proc2(&intLoc1);
	}

/***************** 
-- Stop Timer --
*****************/

time2 = GetSYSTime();
time3 = time2-time1;
Permit();

printf("Dhrystone (2.1) time for %ld passes = %d.%03d seconds.\n",
	(long) LOOPS,time3/1000,time3%1000);
printf("This machine benchmarks at %ld dhrystones/second.\n",
	(LOOPS*1000) / time3 );
printf("\nBenchmark ported by Torsten Hiddessen (math@sun.rz.tu-clausthal.de)\n");
}

GetSYSTime()
{
 unsigned int t1[2]={0,0};
 time(t1);

  //printf("t1=%ld t2=%ld\n",t1[0],t1[1]);

 return ((unsigned long) (1000*t1[0])+(t1[1]/1000) );

}


main()
{
	Proc0();
	exit(0);
}

void Proc1(REG RecordPtr PtrParIn)
{
#define	NextRecord	(*(PtrParIn->PtrComp))

	structassign(NextRecord, *PtrGlb);
	PtrParIn->intComp = 5;
	NextRecord.intComp = PtrParIn->intComp;
	NextRecord.PtrComp = PtrParIn->PtrComp;
	Proc3(NextRecord.PtrComp);
	if (NextRecord.Discr == Ident1)
	{
		NextRecord.intComp = 6;
		Proc6(PtrParIn->EnumComp, &NextRecord.EnumComp);
		NextRecord.PtrComp = PtrGlb->PtrComp;
		Proc7(NextRecord.intComp, 10, &NextRecord.intComp);
	}
	else
		structassign(*PtrParIn, NextRecord);

#undef	NextRecord
}

void Proc2(OneToFifty *intParIO)
{
	REG OneToFifty		intLoc;
	REG Enumeration		EnumLoc;

	intLoc = *intParIO + 10;
	for(;;)
	{
		if (Char1Glob == 'A')
		{
			--intLoc;
			*intParIO = intLoc - intGlob;
			EnumLoc = Ident1;
		}
		if (EnumLoc == Ident1)
			break;
	}
}

void Proc3(RecordPtr *PtrParOut)
{
	if (PtrGlb != NULL)
		*PtrParOut = PtrGlb->PtrComp;
	else
		intGlob = 100;
	Proc7(10, intGlob, &PtrGlb->intComp);
}

void Proc4()
{
	REG boolean	BoolLoc;

	BoolLoc = Char1Glob == 'A';
	BoolLoc |= BoolGlob;
	Char2Glob = 'B';
}

void Proc5()
{
	Char1Glob = 'A';
	BoolGlob = FALSE;
}

extern boolean Func3();

void Proc6(REG Enumeration EnumParIn, REG Enumeration *EnumParOut)
{
	*EnumParOut = EnumParIn;
	if (! Func3(EnumParIn) )
		*EnumParOut = Ident4;
	switch (EnumParIn)
	{
	case Ident1:	*EnumParOut = Ident1; break;
	case Ident2:	if (intGlob > 100) *EnumParOut = Ident1;
			else *EnumParOut = Ident4;
			break;
	case Ident3:	*EnumParOut = Ident2; break;
	case Ident4:	break;
	case Ident5:	*EnumParOut = Ident3;
	}
}

void Proc7(OneToFifty intParI1, OneToFifty intParI2, OneToFifty *intParOut)
{
	REG OneToFifty	intLoc;

	intLoc = intParI1 + 2;
	*intParOut = intParI2 + intLoc;
}

void Proc8(Array1Dim Array1Par, Array2Dim Array2Par, OneToFifty intParI1, OneToFifty intParI2)
{
	REG OneToFifty	intLoc;
	REG OneToFifty	intIndex;

	intLoc = intParI1 + 5;
	Array1Par[intLoc] = intParI2;
	Array1Par[intLoc+1] = Array1Par[intLoc];
	Array1Par[intLoc+30] = intLoc;
	for (intIndex = intLoc; intIndex <= (intLoc+1); ++intIndex)
		Array2Par[intLoc][intIndex] = intLoc;
	++Array2Par[intLoc][intLoc-1];
	Array2Par[intLoc+20][intLoc] = Array1Par[intLoc];
	intGlob = 5;
}

Enumeration Func1(CapitalLetter CharPar1,CapitalLetter CharPar2)
{
	REG CapitalLetter	CharLoc1;
	REG CapitalLetter	CharLoc2;

	CharLoc1 = CharPar1;
	CharLoc2 = CharLoc1;
	if (CharLoc2 != CharPar2)
		return (Ident1);
	else
		return (Ident2);
}

boolean Func2(String30 StrParI1, String30 StrParI2)
{
	REG OneToThirty		intLoc;
	REG CapitalLetter	CharLoc;

	intLoc = 1;
	while (intLoc <= 1)
		if (Func1(StrParI1[intLoc], StrParI2[intLoc+1]) == Ident1)
		{
			CharLoc = 'A';
			++intLoc;
		}
	if (CharLoc >= 'W' && CharLoc <= 'Z')
		intLoc = 7;
	if (CharLoc == 'X')
		return(TRUE);
	else
	{
		if (strcmp(StrParI1, StrParI2) > 0)
		{
			intLoc += 7;
			return (TRUE);
		}
		else
			return (FALSE);
	}
}

boolean Func3(REG Enumeration EnumParIn)

{
	REG Enumeration	EnumLoc;

	EnumLoc = EnumParIn;
	if (EnumLoc == Ident3) return (TRUE);
	return (FALSE);
}
