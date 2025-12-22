
#ifndef _TEXTEDITORLIBRARY_CPP
#define _TEXTEDITORLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/TextEditorLibrary.h>

TextEditorLibrary::TextEditorLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("texteditor.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open texteditor.library") );
	}
}

TextEditorLibrary::~TextEditorLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * TextEditorLibrary::TEXTEDITOR_GetClass()
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

