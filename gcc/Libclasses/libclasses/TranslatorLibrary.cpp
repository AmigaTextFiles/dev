
#ifndef _TRANSLATORLIBRARY_CPP
#define _TRANSLATORLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/TranslatorLibrary.h>

TranslatorLibrary::TranslatorLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("translator.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open translator.library") );
	}
}

TranslatorLibrary::~TranslatorLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

LONG TranslatorLibrary::Translate(CONST_STRPTR inputString, LONG inputLength, STRPTR outputBuffer, LONG bufferSize)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = inputString;
	register int d0 __asm("d0") = inputLength;
	register char * a1 __asm("a1") = outputBuffer;
	register int d1 __asm("d1") = bufferSize;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1), "r" (d1)
	: "a0", "d0", "a1", "d1");
	return (LONG) _res;
}


#endif

