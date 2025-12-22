
#ifndef _POPCYCLELIBRARY_CPP
#define _POPCYCLELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/PopCycleLibrary.h>

PopCycleLibrary::PopCycleLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("popcycle.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open popcycle.library") );
	}
}

PopCycleLibrary::~PopCycleLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * PopCycleLibrary::POPCYCLE_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

struct Node * PopCycleLibrary::AllocPopCycleNodeA(struct TagItem * tags)
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

VOID PopCycleLibrary::FreePopCycleNode(struct Node * node)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID PopCycleLibrary::SetPopCycleNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID PopCycleLibrary::GetPopCycleNodeAttrsA(struct Node * node, struct TagItem * tags)
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

