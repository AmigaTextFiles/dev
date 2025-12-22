
#ifndef _GETSCREENMODELIBRARY_CPP
#define _GETSCREENMODELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/GetScreenModeLibrary.h>

GetScreenModeLibrary::GetScreenModeLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("getscreenmode.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open getscreenmode.library") );
	}
}

GetScreenModeLibrary::~GetScreenModeLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * GetScreenModeLibrary::GETSCREENMODE_GetClass()
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

