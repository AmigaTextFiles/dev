
#ifndef _EXPANSIONLIBRARY_CPP
#define _EXPANSIONLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ExpansionLibrary.h>

ExpansionLibrary::ExpansionLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("expansion.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open expansion.library") );
	}
}

ExpansionLibrary::~ExpansionLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID ExpansionLibrary::AddConfigDev(struct ConfigDev * configDev)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = configDev;

	__asm volatile ("jsr a6@(-30)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL ExpansionLibrary::AddBootNode(LONG bootPri, ULONG flags, struct DeviceNode * deviceNode, struct ConfigDev * configDev)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = bootPri;
	register unsigned int d1 __asm("d1") = flags;
	register void * a0 __asm("a0") = deviceNode;
	register void * a1 __asm("a1") = configDev;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1)
	: "d0", "d1", "a0", "a1");
	return (BOOL) _res;
}

VOID ExpansionLibrary::AllocBoardMem(ULONG slotSpec)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = slotSpec;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

struct ConfigDev * ExpansionLibrary::AllocConfigDev()
{
	register struct ConfigDev * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct ConfigDev *) _res;
}

APTR ExpansionLibrary::AllocExpansionMem(ULONG numSlots, ULONG slotAlign)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = numSlots;
	register unsigned int d1 __asm("d1") = slotAlign;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (APTR) _res;
}

VOID ExpansionLibrary::ConfigBoard(APTR board, struct ConfigDev * configDev)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = board;
	register void * a1 __asm("a1") = configDev;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ExpansionLibrary::ConfigChain(APTR baseAddr)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = baseAddr;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct ConfigDev * ExpansionLibrary::FindConfigDev(CONST struct ConfigDev * oldConfigDev, LONG manufacturer, LONG product)
{
	register struct ConfigDev * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = oldConfigDev;
	register int d0 __asm("d0") = manufacturer;
	register int d1 __asm("d1") = product;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (struct ConfigDev *) _res;
}

VOID ExpansionLibrary::FreeBoardMem(ULONG startSlot, ULONG slotSpec)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = startSlot;
	register unsigned int d1 __asm("d1") = slotSpec;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
}

VOID ExpansionLibrary::FreeConfigDev(struct ConfigDev * configDev)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = configDev;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExpansionLibrary::FreeExpansionMem(ULONG startSlot, ULONG numSlots)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = startSlot;
	register unsigned int d1 __asm("d1") = numSlots;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
}

UBYTE ExpansionLibrary::ReadExpansionByte(CONST APTR board, ULONG offset)
{
	register UBYTE _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = board;
	register unsigned int d0 __asm("d0") = offset;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (UBYTE) _res;
}

VOID ExpansionLibrary::ReadExpansionRom(CONST APTR board, struct ConfigDev * configDev)
{
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = board;
	register void * a1 __asm("a1") = configDev;

	__asm volatile ("jsr a6@(-102)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ExpansionLibrary::RemConfigDev(struct ConfigDev * configDev)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = configDev;

	__asm volatile ("jsr a6@(-108)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ExpansionLibrary::WriteExpansionByte(APTR board, ULONG offset, ULONG byte)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = board;
	register unsigned int d0 __asm("d0") = offset;
	register unsigned int d1 __asm("d1") = byte;

	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

VOID ExpansionLibrary::ObtainConfigBinding()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExpansionLibrary::ReleaseConfigBinding()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-126)"
	: 
	: "r" (a6)
	: "d0");
}

VOID ExpansionLibrary::SetCurrentBinding(struct CurrentBinding * currentBinding, ULONG bindingSize)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = currentBinding;
	register unsigned int d0 __asm("d0") = bindingSize;

	__asm volatile ("jsr a6@(-132)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

ULONG ExpansionLibrary::GetCurrentBinding(CONST struct CurrentBinding * currentBinding, ULONG bindingSize)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = currentBinding;
	register unsigned int d0 __asm("d0") = bindingSize;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

struct DeviceNode * ExpansionLibrary::MakeDosNode(CONST APTR parmPacket)
{
	register struct DeviceNode * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = parmPacket;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct DeviceNode *) _res;
}

BOOL ExpansionLibrary::AddDosNode(LONG bootPri, ULONG flags, struct DeviceNode * deviceNode)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = bootPri;
	register unsigned int d1 __asm("d1") = flags;
	register void * a0 __asm("a0") = deviceNode;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0)
	: "d0", "d1", "a0");
	return (BOOL) _res;
}


#endif

