
#ifndef _TIMERLIBRARY_CPP
#define _TIMERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/TimerLibrary.h>

TimerLibrary::TimerLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("timer.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open timer.library") );
	}
}

TimerLibrary::~TimerLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID TimerLibrary::AddTime(struct timeval * dest, CONST struct timeval * src)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dest;
	register const void * a1 __asm("a1") = src;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID TimerLibrary::SubTime(struct timeval * dest, CONST struct timeval * src)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dest;
	register const void * a1 __asm("a1") = src;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

LONG TimerLibrary::CmpTime(CONST struct timeval * dest, CONST struct timeval * src)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = dest;
	register const void * a1 __asm("a1") = src;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

ULONG TimerLibrary::ReadEClock(struct EClockVal * dest)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dest;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

VOID TimerLibrary::GetSysTime(struct timeval * dest)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dest;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}


#endif

