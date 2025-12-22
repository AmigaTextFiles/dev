
#ifndef _TEXTFIELDLIBRARY_CPP
#define _TEXTFIELDLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/TextFieldLibrary.h>

TextFieldLibrary::TextFieldLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("textfield.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open textfield.library") );
	}
}

TextFieldLibrary::~TextFieldLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * TextFieldLibrary::TEXTFIELD_GetClass()
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

