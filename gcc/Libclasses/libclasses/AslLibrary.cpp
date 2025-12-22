
#ifndef _ASLLIBRARY_CPP
#define _ASLLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/AslLibrary.h>

AslLibrary::AslLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("asl.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open asl.library") );
	}
}

AslLibrary::~AslLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct FileRequester * AslLibrary::AllocFileRequest()
{
	register struct FileRequester * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct FileRequester *) _res;
}

VOID AslLibrary::FreeFileRequest(struct FileRequester * fileReq)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = fileReq;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL AslLibrary::RequestFile(struct FileRequester * fileReq)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = fileReq;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

APTR AslLibrary::AllocAslRequest(ULONG reqType, struct TagItem * tagList)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = reqType;
	register void * a0 __asm("a0") = tagList;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (APTR) _res;
}

VOID AslLibrary::FreeAslRequest(APTR requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL AslLibrary::AslRequest(APTR requester, struct TagItem * tagList)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;
	register void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID AslLibrary::AbortAslRequest(APTR requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID AslLibrary::ActivateAslRequest(APTR requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}


#endif

