
#ifndef _REQUESTERLIBRARY_CPP
#define _REQUESTERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/RequesterLibrary.h>

RequesterLibrary::RequesterLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("requester.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open requester.library") );
	}
}

RequesterLibrary::~RequesterLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * RequesterLibrary::REQUESTER_GetClass()
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

