
#ifndef _MATHLIBRARY_CPP
#define _MATHLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/MathLibrary.h>

MathLibrary::MathLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("math.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open math.library") );
	}
}

MathLibrary::~MathLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

LONG MathLibrary::SPFix(FLOAT parm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

FLOAT MathLibrary::SPFlt(LONG integer)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = integer;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

LONG MathLibrary::SPCmp(FLOAT leftParm, FLOAT rightParm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = leftParm;
	register float d0 __asm("d0") = rightParm;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (LONG) _res;
}

LONG MathLibrary::SPTst(FLOAT parm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = parm;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (LONG) _res;
}

FLOAT MathLibrary::SPAbs(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPNeg(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPAdd(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = leftParm;
	register float d0 __asm("d0") = rightParm;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPSub(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = leftParm;
	register float d0 __asm("d0") = rightParm;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPMul(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = leftParm;
	register float d0 __asm("d0") = rightParm;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPDiv(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = leftParm;
	register float d0 __asm("d0") = rightParm;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPFloor(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathLibrary::SPCeil(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}


#endif

