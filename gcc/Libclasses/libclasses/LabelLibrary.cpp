
#ifndef _LABELLIBRARY_CPP
#define _LABELLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/LabelLibrary.h>

LabelLibrary::LabelLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("label.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open label.library") );
	}
}

LabelLibrary::~LabelLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * LabelLibrary::LABEL_GetClass()
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

