
#ifndef _POWERPCLIBRARY_CPP
#define _POWERPCLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/PowerPCLibrary.h>

PowerPCLibrary::PowerPCLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("powerpc.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open powerpc.library") );
	}
}

PowerPCLibrary::~PowerPCLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

ULONG PowerPCLibrary::RunPPC(struct PPCArgs * PPStruct)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = PPStruct;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG PowerPCLibrary::WaitForPPC(struct PPCArgs * PPStruct)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = PPStruct;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG PowerPCLibrary::GetCPU()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

VOID PowerPCLibrary::PowerDebugMode(ULONG debuglevel)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = debuglevel;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

APTR PowerPCLibrary::AllocVec32(ULONG memsize, ULONG attributes)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = memsize;
	register unsigned int d1 __asm("d1") = attributes;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1)
	: "d0", "d1");
	return (APTR) _res;
}

VOID PowerPCLibrary::FreeVec32(APTR memblock)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = memblock;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID PowerPCLibrary::SPrintF68K(STRPTR Formatstring, APTR values)
{
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = Formatstring;
	register void * a1 __asm("a1") = values;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct Message * PowerPCLibrary::AllocXMsg(ULONG bodysize, struct MsgPort * replyport)
{
	register struct Message * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = bodysize;
	register void * a0 __asm("a0") = replyport;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (struct Message *) _res;
}

VOID PowerPCLibrary::FreeXMsg(struct Message * message)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = message;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID PowerPCLibrary::PutXMsg(struct MsgPortPPC, struct Message * message)
{
	register void * a6 __asm("a6") = Base;
	register struct a0 __asm("a0") = MsgPortPPC;
	register void * a1 __asm("a1") = message;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG PowerPCLibrary::GetPPCState()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

void PowerPCLibrary::SetCache68K(ULONG flags, void * addr, ULONG length)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = flags;
	register void * a0 __asm("a0") = addr;
	register unsigned int d1 __asm("d1") = length;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (d0), "r" (a0), "r" (d1)
	: "d0", "a0", "d1");
}

struct TaskPPC * PowerPCLibrary::CreatePPCTask(struct TagItem * taglist)
{
	register struct TaskPPC * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = taglist;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct TaskPPC *) _res;
}

void PowerPCLibrary::CausePPCInterrupt()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-108)"
	: 
	: "r" (a6)
	: "d0");
}


#endif

