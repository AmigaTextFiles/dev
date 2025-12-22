
#ifndef _NVLIBRARY_CPP
#define _NVLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/NVLibrary.h>

NVLibrary::NVLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("nv.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open nv.library") );
	}
}

NVLibrary::~NVLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

APTR NVLibrary::GetCopyNV(CONST_STRPTR appName, CONST_STRPTR itemName, LONG killRequesters)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = appName;
	register const char * a1 __asm("a1") = itemName;
	register int d1 __asm("d1") = killRequesters;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d1)
	: "a0", "a1", "d1");
	return (APTR) _res;
}

VOID NVLibrary::FreeNVData(APTR data)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = data;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

UWORD NVLibrary::StoreNV(CONST_STRPTR appName, CONST_STRPTR itemName, CONST APTR data, ULONG length, LONG killRequesters)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = appName;
	register const char * a1 __asm("a1") = itemName;
	register const void * a2 __asm("a2") = data;
	register unsigned int d0 __asm("d0") = length;
	register int d1 __asm("d1") = killRequesters;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
	: "a0", "a1", "a2", "d0", "d1");
	return (UWORD) _res;
}

BOOL NVLibrary::DeleteNV(CONST_STRPTR appName, CONST_STRPTR itemName, LONG killRequesters)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = appName;
	register const char * a1 __asm("a1") = itemName;
	register int d1 __asm("d1") = killRequesters;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d1)
	: "a0", "a1", "d1");
	return (BOOL) _res;
}

struct NVInfo * NVLibrary::GetNVInfo(LONG killRequesters)
{
	register struct NVInfo * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d1 __asm("d1") = killRequesters;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (d1)
	: "d1");
	return (struct NVInfo *) _res;
}

struct MinList * NVLibrary::GetNVList(CONST_STRPTR appName, LONG killRequesters)
{
	register struct MinList * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = appName;
	register int d1 __asm("d1") = killRequesters;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d1)
	: "a0", "d1");
	return (struct MinList *) _res;
}

BOOL NVLibrary::SetNVProtection(CONST_STRPTR appName, CONST_STRPTR itemName, LONG mask, LONG killRequesters)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = appName;
	register const char * a1 __asm("a1") = itemName;
	register int d2 __asm("d2") = mask;
	register int d1 __asm("d1") = killRequesters;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d2), "r" (d1)
	: "a0", "a1", "d2", "d1");
	return (BOOL) _res;
}


#endif

