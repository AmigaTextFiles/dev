
#ifndef _BEVELLIBRARY_CPP
#define _BEVELLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/BevelLibrary.h>

BevelLibrary::BevelLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("bevel.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open bevel.library") );
	}
}

BevelLibrary::~BevelLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * BevelLibrary::BEVEL_GetClass()
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

