
#ifndef _CLICKTABLIBRARY_CPP
#define _CLICKTABLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ClickTabLibrary.h>

ClickTabLibrary::ClickTabLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("clicktab.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open clicktab.library") );
	}
}

ClickTabLibrary::~ClickTabLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * ClickTabLibrary::CLICKTAB_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

struct Node * ClickTabLibrary::AllocClickTabNodeA(struct TagItem * tags)
{
	register struct Node * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tags;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Node *) _res;
}

VOID ClickTabLibrary::FreeClickTabNode(struct Node * node)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ClickTabLibrary::SetClickTabNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ClickTabLibrary::GetClickTabNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}


#endif

