
#ifndef _DATEBROWSERLIBRARY_CPP
#define _DATEBROWSERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DateBrowserLibrary.h>

DateBrowserLibrary::DateBrowserLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("datebrowser.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open datebrowser.library") );
	}
}

DateBrowserLibrary::~DateBrowserLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * DateBrowserLibrary::DATEBROWSER_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

UWORD DateBrowserLibrary::JulianWeekDay(UWORD day, UWORD month, LONG year)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned short d0 __asm("d0") = day;
	register unsigned short d1 __asm("d1") = month;
	register int d2 __asm("d2") = year;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2)
	: "d0", "d1", "d2");
	return (UWORD) _res;
}

void DateBrowserLibrary::JulianMonthDays(int month, int year)
{
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = month;
	register int d1 __asm("d1") = year;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
}

BOOL DateBrowserLibrary::JulianLeapYear(LONG year)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = year;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (BOOL) _res;
}


#endif

