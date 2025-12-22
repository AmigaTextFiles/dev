
#ifndef _AMIGAGUIDELIBRARY_CPP
#define _AMIGAGUIDELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/AmigaGuideLibrary.h>

AmigaGuideLibrary::AmigaGuideLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("amigaguide.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open amigaguide.library") );
	}
}

AmigaGuideLibrary::~AmigaGuideLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

LONG AmigaGuideLibrary::LockAmigaGuideBase(APTR handle)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = handle;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

VOID AmigaGuideLibrary::UnlockAmigaGuideBase(LONG key)
{
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = key;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

APTR AmigaGuideLibrary::OpenAmigaGuideA(struct NewAmigaGuide * nag, struct TagItem * tag1)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = nag;
	register void * a1 __asm("a1") = tag1;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

APTR AmigaGuideLibrary::OpenAmigaGuideAsyncA(struct NewAmigaGuide * nag, struct TagItem * attrs)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = nag;
	register void * d0 __asm("d0") = attrs;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (APTR) _res;
}

VOID AmigaGuideLibrary::CloseAmigaGuide(APTR cl)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG AmigaGuideLibrary::AmigaGuideSignal(APTR cl)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

struct AmigaGuideMsg * AmigaGuideLibrary::GetAmigaGuideMsg(APTR cl)
{
	register struct AmigaGuideMsg * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct AmigaGuideMsg *) _res;
}

VOID AmigaGuideLibrary::ReplyAmigaGuideMsg(struct AmigaGuideMsg * amsg)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = amsg;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG AmigaGuideLibrary::SetAmigaGuideContextA(APTR cl, ULONG id, struct TagItem * attrs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;
	register unsigned int d0 __asm("d0") = id;
	register void * d1 __asm("d1") = attrs;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

LONG AmigaGuideLibrary::SendAmigaGuideContextA(APTR cl, struct TagItem * attrs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;
	register void * d0 __asm("d0") = attrs;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

LONG AmigaGuideLibrary::SendAmigaGuideCmdA(APTR cl, STRPTR cmd, struct TagItem * attrs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;
	register char * d0 __asm("d0") = cmd;
	register void * d1 __asm("d1") = attrs;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

LONG AmigaGuideLibrary::SetAmigaGuideAttrsA(APTR cl, struct TagItem * attrs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = cl;
	register void * a1 __asm("a1") = attrs;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

LONG AmigaGuideLibrary::GetAmigaGuideAttr(Tag tag, APTR cl, ULONG * storage)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register Tag d0 __asm("d0") = tag;
	register void * a0 __asm("a0") = cl;
	register void * a1 __asm("a1") = storage;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (LONG) _res;
}

LONG AmigaGuideLibrary::LoadXRef(BPTR lock, STRPTR name)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int a0 __asm("a0") = lock;
	register char * a1 __asm("a1") = name;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

VOID AmigaGuideLibrary::ExpungeXRef()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-132)"
	: 
	: "r" (a6)
	: "d0");
}

APTR AmigaGuideLibrary::AddAmigaGuideHostA(struct Hook * h, STRPTR name, struct TagItem * attrs)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = h;
	register char * d0 __asm("d0") = name;
	register void * a1 __asm("a1") = attrs;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
	return (APTR) _res;
}

LONG AmigaGuideLibrary::RemoveAmigaGuideHostA(APTR hh, struct TagItem * attrs)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = hh;
	register void * a1 __asm("a1") = attrs;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

STRPTR AmigaGuideLibrary::GetAmigaGuideString(LONG id)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = id;

	__asm volatile ("jsr a6@(-210)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (STRPTR) _res;
}


#endif

