
#ifndef _CARDRESOURCE_CPP
#define _CARDRESOURCE_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/CardResource.h>

CardResource::CardResource()
{
	Base = ExecLibrary::Default.OpenLibrary("cardresource.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open cardresource.library") );
	}
}

CardResource::~CardResource()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct CardHandle * CardResource::OwnCard(struct CardHandle * handle)
{
	register struct CardHandle * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;

	__asm volatile ("jsr a6@(-6)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct CardHandle *) _res;
}

VOID CardResource::ReleaseCard(struct CardHandle * handle, ULONG flags)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-12)"
	: 
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
}

struct CardMemoryMap * CardResource::GetCardMap()
{
	register struct CardMemoryMap * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-18)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct CardMemoryMap *) _res;
}

BOOL CardResource::BeginCardAccess(struct CardHandle * handle)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;

	__asm volatile ("jsr a6@(-24)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (BOOL) _res;
}

BOOL CardResource::EndCardAccess(struct CardHandle * handle)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (BOOL) _res;
}

UBYTE CardResource::ReadCardStatus()
{
	register UBYTE _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (UBYTE) _res;
}

BOOL CardResource::CardResetRemove(struct CardHandle * handle, ULONG flag)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;
	register unsigned int d0 __asm("d0") = flag;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
	return (BOOL) _res;
}

UBYTE CardResource::CardMiscControl(struct CardHandle * handle, ULONG control_bits)
{
	register UBYTE _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;
	register unsigned int d1 __asm("d1") = control_bits;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d1)
	: "a1", "d1");
	return (UBYTE) _res;
}

ULONG CardResource::CardAccessSpeed(struct CardHandle * handle, ULONG nanoseconds)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;
	register unsigned int d0 __asm("d0") = nanoseconds;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
	return (ULONG) _res;
}

LONG CardResource::CardProgramVoltage(struct CardHandle * handle, ULONG voltage)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;
	register unsigned int d0 __asm("d0") = voltage;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (d0)
	: "a1", "d0");
	return (LONG) _res;
}

BOOL CardResource::CardResetCard(struct CardHandle * handle)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = handle;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (BOOL) _res;
}

BOOL CardResource::CopyTuple(CONST struct CardHandle * handle, UBYTE * buffer, ULONG tuplecode, ULONG size)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a1 __asm("a1") = handle;
	register void * a0 __asm("a0") = buffer;
	register unsigned int d1 __asm("d1") = tuplecode;
	register unsigned int d0 __asm("d0") = size;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a1), "r" (a0), "r" (d1), "r" (d0)
	: "a1", "a0", "d1", "d0");
	return (BOOL) _res;
}

ULONG CardResource::DeviceTuple(CONST UBYTE * tuple_data, struct DeviceTData * storage)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = tuple_data;
	register void * a1 __asm("a1") = storage;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

struct Resident * CardResource::IfAmigaXIP(CONST struct CardHandle * handle)
{
	register struct Resident * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a2 __asm("a2") = handle;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a2)
	: "a2");
	return (struct Resident *) _res;
}

BOOL CardResource::CardForceChange()
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (BOOL) _res;
}

ULONG CardResource::CardChangeCount()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

ULONG CardResource::CardInterface()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}


#endif

