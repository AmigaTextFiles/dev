
#ifndef _CHECKBOXLIBRARY_CPP
#define _CHECKBOXLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/CheckBoxLibrary.h>

CheckBoxLibrary::CheckBoxLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("checkbox.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open checkbox.library") );
	}
}

CheckBoxLibrary::~CheckBoxLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * CheckBoxLibrary::CHECKBOX_GetClass()
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

