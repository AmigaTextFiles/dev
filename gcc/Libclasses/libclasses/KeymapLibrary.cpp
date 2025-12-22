
#ifndef _KEYMAPLIBRARY_CPP
#define _KEYMAPLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/KeymapLibrary.h>

KeymapLibrary::KeymapLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("keymap.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open keymap.library") );
	}
}

KeymapLibrary::~KeymapLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID KeymapLibrary::SetKeyMapDefault(CONST struct KeyMap * keyMap)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = keyMap;

	__asm volatile ("jsr a6@(-30)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct KeyMap * KeymapLibrary::AskKeyMapDefault()
{
	register struct KeyMap * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct KeyMap *) _res;
}

WORD KeymapLibrary::MapRawKey(CONST struct InputEvent * event, STRPTR buffer, LONG length, CONST struct KeyMap * keyMap)
{
	register WORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = event;
	register char * a1 __asm("a1") = buffer;
	register int d1 __asm("d1") = length;
	register const void * a2 __asm("a2") = keyMap;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d1), "r" (a2)
	: "a0", "a1", "d1", "a2");
	return (WORD) _res;
}

LONG KeymapLibrary::MapANSI(CONST_STRPTR string, LONG count, STRPTR buffer, LONG length, CONST struct KeyMap * keyMap)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = string;
	register int d0 __asm("d0") = count;
	register char * a1 __asm("a1") = buffer;
	register int d1 __asm("d1") = length;
	register const void * a2 __asm("a2") = keyMap;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1), "r" (d1), "r" (a2)
	: "a0", "d0", "a1", "d1", "a2");
	return (LONG) _res;
}


#endif

