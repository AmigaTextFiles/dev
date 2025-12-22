
#ifndef _MATHIEEESINGTRANSLIBRARY_CPP
#define _MATHIEEESINGTRANSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/MathIeeeSingTransLibrary.h>

MathIeeeSingTransLibrary::MathIeeeSingTransLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("mathieeesingtrans.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open mathieeesingtrans.library") );
	}
}

MathIeeeSingTransLibrary::~MathIeeeSingTransLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

FLOAT MathIeeeSingTransLibrary::IEEESPAtan(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPSin(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPCos(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPTan(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPSincos(FLOAT * cosptr, FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cosptr;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPSinh(FLOAT parm)
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

FLOAT MathIeeeSingTransLibrary::IEEESPCosh(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPTanh(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPExp(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPLog(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPPow(FLOAT exp, FLOAT arg)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = exp;
	register float d0 __asm("d0") = arg;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPSqrt(FLOAT parm)
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

FLOAT MathIeeeSingTransLibrary::IEEESPTieee(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPFieee(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPAsin(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPAcos(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}

FLOAT MathIeeeSingTransLibrary::IEEESPLog10(FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (FLOAT) _res;
}


#endif

