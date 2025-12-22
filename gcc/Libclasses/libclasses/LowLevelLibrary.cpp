
#ifndef _LOWLEVELLIBRARY_CPP
#define _LOWLEVELLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/LowLevelLibrary.h>

LowLevelLibrary::LowLevelLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("lowlevel.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open lowlevel.library") );
	}
}

LowLevelLibrary::~LowLevelLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

ULONG LowLevelLibrary::ReadJoyPort(ULONG port)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = port;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (ULONG) _res;
}

UBYTE LowLevelLibrary::GetLanguageSelection()
{
	register UBYTE _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (UBYTE) _res;
}

ULONG LowLevelLibrary::GetKey()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

VOID LowLevelLibrary::QueryKeys(struct KeyQuery * queryArray, ULONG arraySize)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = queryArray;
	register unsigned int d1 __asm("d1") = arraySize;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0), "r" (d1)
	: "a0", "d1");
}

APTR LowLevelLibrary::AddKBInt(CONST APTR intRoutine, CONST APTR intData)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = intRoutine;
	register const void * a1 __asm("a1") = intData;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

VOID LowLevelLibrary::RemKBInt(APTR intHandle)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = intHandle;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

ULONG LowLevelLibrary::SystemControlA(CONST struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (ULONG) _res;
}

APTR LowLevelLibrary::AddTimerInt(CONST APTR intRoutine, CONST APTR intData)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = intRoutine;
	register const void * a1 __asm("a1") = intData;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

VOID LowLevelLibrary::RemTimerInt(APTR intHandle)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = intHandle;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID LowLevelLibrary::StopTimerInt(APTR intHandle)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = intHandle;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID LowLevelLibrary::StartTimerInt(APTR intHandle, ULONG timeInterval, LONG continuous)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = intHandle;
	register unsigned int d0 __asm("d0") = timeInterval;
	register int d1 __asm("d1") = continuous;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1)
	: "a1", "d0", "d1");
}

ULONG LowLevelLibrary::ElapsedTime(struct EClockVal * context)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = context;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

APTR LowLevelLibrary::AddVBlankInt(CONST APTR intRoutine, CONST APTR intData)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = intRoutine;
	register const void * a1 __asm("a1") = intData;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

VOID LowLevelLibrary::RemVBlankInt(APTR intHandle)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = intHandle;

	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

BOOL LowLevelLibrary::SetJoyPortAttrsA(ULONG portNumber, CONST struct TagItem * tagList)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = portNumber;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "a1");
	return (BOOL) _res;
}


#endif

