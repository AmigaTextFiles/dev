
#ifndef _GETFILELIBRARY_CPP
#define _GETFILELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/GetFileLibrary.h>

GetFileLibrary::GetFileLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("getfile.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open getfile.library") );
	}
}

GetFileLibrary::~GetFileLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * GetFileLibrary::GETFILE_GetClass()
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

