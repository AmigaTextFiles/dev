
#ifndef _BUTTONLIBRARY_CPP
#define _BUTTONLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ButtonLibrary.h>

ButtonLibrary::ButtonLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("button.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open button.library") );
	}
}

ButtonLibrary::~ButtonLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * ButtonLibrary::BUTTON_GetClass()
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

