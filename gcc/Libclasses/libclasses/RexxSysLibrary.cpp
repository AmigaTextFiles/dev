
#ifndef _REXXSYSLIBRARY_CPP
#define _REXXSYSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/RexxSysLibrary.h>

RexxSysLibrary::RexxSysLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("rexxsys.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open rexxsys.library") );
	}
}

RexxSysLibrary::~RexxSysLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

UBYTE * RexxSysLibrary::CreateArgstring(CONST STRPTR string, ULONG length)
{
	register UBYTE * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = string;
	register unsigned int d0 __asm("d0") = length;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (UBYTE *) _res;
}

VOID RexxSysLibrary::DeleteArgstring(UBYTE * argstring)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = argstring;

	__asm volatile ("jsr a6@(-132)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG RexxSysLibrary::LengthArgstring(CONST UBYTE * argstring)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = argstring;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

struct RexxMsg * RexxSysLibrary::CreateRexxMsg(CONST struct MsgPort * port, CONST_STRPTR extension, CONST_STRPTR host)
{
	register struct RexxMsg * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = port;
	register const char * a1 __asm("a1") = extension;
	register const char * d0 __asm("d0") = host;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (struct RexxMsg *) _res;
}

VOID RexxSysLibrary::DeleteRexxMsg(struct RexxMsg * packet)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = packet;

	__asm volatile ("jsr a6@(-150)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID RexxSysLibrary::ClearRexxMsg(struct RexxMsg * msgptr, ULONG count)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = msgptr;
	register unsigned int d0 __asm("d0") = count;

	__asm volatile ("jsr a6@(-156)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

BOOL RexxSysLibrary::FillRexxMsg(struct RexxMsg * msgptr, ULONG count, ULONG mask)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = msgptr;
	register unsigned int d0 __asm("d0") = count;
	register unsigned int d1 __asm("d1") = mask;

	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (BOOL) _res;
}

BOOL RexxSysLibrary::IsRexxMsg(CONST struct RexxMsg * msgptr)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = msgptr;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

VOID RexxSysLibrary::LockRexxBase(ULONG resource)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = resource;

	__asm volatile ("jsr a6@(-450)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}

VOID RexxSysLibrary::UnlockRexxBase(ULONG resource)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = resource;

	__asm volatile ("jsr a6@(-456)"
	: 
	: "r" (a6), "r" (d0)
	: "d0");
}


#endif

