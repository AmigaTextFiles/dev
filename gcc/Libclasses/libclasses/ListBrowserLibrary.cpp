
#ifndef _LISTBROWSERLIBRARY_CPP
#define _LISTBROWSERLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/ListBrowserLibrary.h>

ListBrowserLibrary::ListBrowserLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("listbrowser.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open listbrowser.library") );
	}
}

ListBrowserLibrary::~ListBrowserLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

Class * ListBrowserLibrary::LISTBROWSER_GetClass()
{
	register Class * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (Class *) _res;
}

struct Node * ListBrowserLibrary::AllocListBrowserNodeA(UWORD columns, struct TagItem * tags)
{
	register struct Node * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned short d0 __asm("d0") = columns;
	register void * a0 __asm("a0") = tags;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (struct Node *) _res;
}

VOID ListBrowserLibrary::FreeListBrowserNode(struct Node * node)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ListBrowserLibrary::SetListBrowserNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ListBrowserLibrary::GetListBrowserNodeAttrsA(struct Node * node, struct TagItem * tags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID ListBrowserLibrary::ListBrowserSelectAll(struct List * list)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = list;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ListBrowserLibrary::ShowListBrowserNodeChildren(struct Node * node, WORD depth)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;
	register short d0 __asm("d0") = depth;

	__asm volatile ("jsr a6@(-66)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

VOID ListBrowserLibrary::HideListBrowserNodeChildren(struct Node * node)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = node;

	__asm volatile ("jsr a6@(-72)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ListBrowserLibrary::ShowAllListBrowserChildren(struct List * list)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = list;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ListBrowserLibrary::HideAllListBrowserChildren(struct List * list)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = list;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID ListBrowserLibrary::FreeListBrowserList(struct List * list)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = list;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}


#endif

