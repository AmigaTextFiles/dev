
#ifndef _SCROLLERLIBRARY_CPP
#define _SCROLLERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ScrollerLibrary.h>

ScrollerLibrary::ScrollerLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("scroller.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open scroller.library") );
	}
}

ScrollerLibrary::~ScrollerLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * ScrollerLibrary::SCROLLER_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}


#endif

