
#ifndef _CHOOSERLIBRARY_CPP
#define _CHOOSERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ChooserLibrary.h>

ChooserLibrary::ChooserLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("chooser.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open chooser.library") );
	}
}

ChooserLibrary::~ChooserLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * ChooserLibrary::CHOOSER_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

struct Node * ChooserLibrary::AllocChooserNodeA(struct TagItem * tags)
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

VOID ChooserLibrary::FreeChooserNode(struct Node * node)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ChooserLibrary::SetChooserNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ChooserLibrary::GetChooserNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG ChooserLibrary::ShowChooser(Object *obj, struct Window *win, ULONG xpos, ULONG ypos)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = obj;
	register void * a1 __asm("a1") = win;
	register unsigned int d0 __asm("d0") = xpos;
	register unsigned int d1 __asm("d1") = ypos;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (ULONG) _res;
}

VOID ChooserLibrary::HideChooser(Object *obj, struct Window *win)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = obj;
	register void * a1 __asm("a1") = win;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}


#endif

