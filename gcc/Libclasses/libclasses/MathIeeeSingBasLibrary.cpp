
#ifndef _MATHIEEESINGBASLIBRARY_CPP
#define _MATHIEEESINGBASLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/MathIeeeSingBasLibrary.h>

MathIeeeSingBasLibrary::MathIeeeSingBasLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("mathieeesingbas.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open mathieeesingbas.library") );
	}
}

MathIeeeSingBasLibrary::~MathIeeeSingBasLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

LONG MathIeeeSingBasLibrary::IEEESPFix(FLOAT parm)
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

FLOAT MathIeeeSingBasLibrary::IEEESPFlt(LONG integer)
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

LONG MathIeeeSingBasLibrary::IEEESPCmp(FLOAT leftParm, FLOAT rightParm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = leftParm;
	register float d1 __asm("d1") = rightParm;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (LONG) _res;
}

LONG MathIeeeSingBasLibrary::IEEESPTst(FLOAT parm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (LONG) _res;
}

FLOAT MathIeeeSingBasLibrary::IEEESPAbs(FLOAT parm)
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

FLOAT MathIeeeSingBasLibrary::IEEESPNeg(FLOAT parm)
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

FLOAT MathIeeeSingBasLibrary::IEEESPAdd(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = leftParm;
	register float d1 __asm("d1") = rightParm;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingBasLibrary::IEEESPSub(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = leftParm;
	register float d1 __asm("d1") = rightParm;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingBasLibrary::IEEESPMul(FLOAT leftParm, FLOAT rightParm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = leftParm;
	register float d1 __asm("d1") = rightParm;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingBasLibrary::IEEESPDiv(FLOAT dividend, FLOAT divisor)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = dividend;
	register float d1 __asm("d1") = divisor;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingBasLibrary::IEEESPFloor(FLOAT parm)
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

FLOAT MathIeeeSingBasLibrary::IEEESPCeil(FLOAT parm)
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

