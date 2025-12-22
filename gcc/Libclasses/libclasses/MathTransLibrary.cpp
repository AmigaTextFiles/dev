
#ifndef _MATHTRANSLIBRARY_CPP
#define _MATHTRANSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/MathTransLibrary.h>

MathTransLibrary::MathTransLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("mathtrans.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open mathtrans.library") );
	}
}

MathTransLibrary::~MathTransLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

FLOAT MathTransLibrary::SPAtan(FLOAT parm)
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

FLOAT MathTransLibrary::SPSin(FLOAT parm)
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

FLOAT MathTransLibrary::SPCos(FLOAT parm)
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

FLOAT MathTransLibrary::SPTan(FLOAT parm)
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

FLOAT MathTransLibrary::SPSincos(FLOAT * cosResult, FLOAT parm)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * d1 __asm("d1") = cosResult;
	register float d0 __asm("d0") = parm;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathTransLibrary::SPSinh(FLOAT parm)
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

FLOAT MathTransLibrary::SPCosh(FLOAT parm)
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

FLOAT MathTransLibrary::SPTanh(FLOAT parm)
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

FLOAT MathTransLibrary::SPExp(FLOAT parm)
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

FLOAT MathTransLibrary::SPLog(FLOAT parm)
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

FLOAT MathTransLibrary::SPPow(FLOAT power, FLOAT arg)
{
	register FLOAT _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register float d1 __asm("d1") = power;
	register float d0 __asm("d0") = arg;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (d1), "r" (d0)
	: "d1", "d0");
	return (FLOAT) _res;
}

FLOAT MathTransLibrary::SPSqrt(FLOAT parm)
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

FLOAT MathTransLibrary::SPTieee(FLOAT parm)
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

FLOAT MathTransLibrary::SPFieee(FLOAT parm)
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

FLOAT MathTransLibrary::SPAsin(FLOAT parm)
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

FLOAT MathTransLibrary::SPAcos(FLOAT parm)
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

FLOAT MathTransLibrary::SPLog10(FLOAT parm)
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

