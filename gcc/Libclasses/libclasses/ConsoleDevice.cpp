
#ifndef _CONSOLEDEVICE_CPP
#define _CONSOLEDEVICE_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ConsoleDevice.h>

ConsoleDevice::ConsoleDevice()
{
	Base = ExecLibrary::Default.OpenLibrary("consoledevice.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open consoledevice.library") );
	}
}

ConsoleDevice::~ConsoleDevice()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct InputEvent * ConsoleDevice::CDInputHandler(CONST struct InputEvent * events, struct Library * consoleDevice)
{
	register struct InputEvent * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = events;
	register void * a1 __asm("a1") = consoleDevice;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct InputEvent *) _res;
}

LONG ConsoleDevice::RawKeyConvert(CONST struct InputEvent * events, STRPTR buffer, LONG length, CONST struct KeyMap * keyMap)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = events;
	register char * a1 __asm("a1") = buffer;
	register int d1 __asm("d1") = length;
	register const void * a2 __asm("a2") = keyMap;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d1), "r" (a2)
	: "a0", "a1", "d1", "a2");
	return (LONG) _res;
}


#endif

