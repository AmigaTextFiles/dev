
#ifndef _LAYOUTLIBRARY_CPP
#define _LAYOUTLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/LayoutLibrary.h>

LayoutLibrary::LayoutLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("layout.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open layout.library") );
	}
}

LayoutLibrary::~LayoutLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * LayoutLibrary::LAYOUT_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

BOOL LayoutLibrary::ActivateLayoutGadget(struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG object)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;
	register unsigned int d0 __asm("d0") = object;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
	: "a0", "a1", "a2", "d0");
	return (BOOL) _res;
}

VOID LayoutLibrary::FlushLayoutDomainCache(struct Gadget * gadget)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL LayoutLibrary::RethinkLayout(struct Gadget * gadget, struct Window * window, struct Requester * requester, LONG refresh)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;
	register int d0 __asm("d0") = refresh;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
	: "a0", "a1", "a2", "d0");
	return (BOOL) _res;
}

VOID LayoutLibrary::LayoutLimits(struct Gadget * gadget, struct LayoutLimits * limits, struct TextFont * font, struct Screen * screen)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = limits;
	register void * a2 __asm("a2") = font;
	register void * a3 __asm("a3") = screen;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
}

Class * LayoutLibrary::PAGE_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

ULONG LayoutLibrary::SetPageGadgetAttrsA(struct Gadget * gadget, Object * object, struct Window * window, struct Requester * requester, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = object;
	register void * a2 __asm("a2") = window;
	register void * a3 __asm("a3") = requester;
	register void * a4 __asm("a4") = tags;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
	: "a0", "a1", "a2", "a3", "a4");
	return (ULONG) _res;
}

VOID LayoutLibrary::RefreshPageGadget(struct Gadget * gadget, Object * object, struct Window * window, struct Requester * requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = object;
	register void * a2 __asm("a2") = window;
	register void * a3 __asm("a3") = requester;

	__asm volatile ("jsr a6@(-72)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
}


#endif

