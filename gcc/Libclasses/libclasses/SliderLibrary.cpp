
#ifndef _SLIDERLIBRARY_CPP
#define _SLIDERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/SliderLibrary.h>

SliderLibrary::SliderLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("slider.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open slider.library") );
	}
}

SliderLibrary::~SliderLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * SliderLibrary::SLIDER_GetClass()
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

