
#ifndef _GADTOOLSLIBRARY_CPP
#define _GADTOOLSLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/GadToolsLibrary.h>

GadToolsLibrary::GadToolsLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("gadtools.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open gadtools.library") );
	}
}

GadToolsLibrary::~GadToolsLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct Gadget * GadToolsLibrary::CreateGadgetA(ULONG kind, struct Gadget * gad, CONST struct NewGadget * ng, CONST struct TagItem * taglist)
{
	register struct Gadget * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = kind;
	register void * a0 __asm("a0") = gad;
	register const void * a1 __asm("a1") = ng;
	register const void * a2 __asm("a2") = taglist;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1), "r" (a2)
	: "d0", "a0", "a1", "a2");
	return (struct Gadget *) _res;
}

VOID GadToolsLibrary::FreeGadgets(struct Gadget * gad)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gad;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GadToolsLibrary::GT_SetGadgetAttrsA(struct Gadget * gad, struct Window * win, struct Requester * req, CONST struct TagItem * taglist)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gad;
	register void * a1 __asm("a1") = win;
	register void * a2 __asm("a2") = req;
	register const void * a3 __asm("a3") = taglist;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
}

struct Menu * GadToolsLibrary::CreateMenusA(CONST struct NewMenu * newmenu, CONST struct TagItem * taglist)
{
	register struct Menu * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = newmenu;
	register const void * a1 __asm("a1") = taglist;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Menu *) _res;
}

VOID GadToolsLibrary::FreeMenus(struct Menu * menu)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = menu;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL GadToolsLibrary::LayoutMenuItemsA(struct MenuItem * firstitem, APTR vi, CONST struct TagItem * taglist)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = firstitem;
	register void * a1 __asm("a1") = vi;
	register const void * a2 __asm("a2") = taglist;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

BOOL GadToolsLibrary::LayoutMenusA(struct Menu * firstmenu, APTR vi, CONST struct TagItem * taglist)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = firstmenu;
	register void * a1 __asm("a1") = vi;
	register const void * a2 __asm("a2") = taglist;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

struct IntuiMessage * GadToolsLibrary::GT_GetIMsg(struct MsgPort * iport)
{
	register struct IntuiMessage * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iport;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct IntuiMessage *) _res;
}

VOID GadToolsLibrary::GT_ReplyIMsg(struct IntuiMessage * imsg)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = imsg;

	__asm volatile ("jsr a6@(-78)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

VOID GadToolsLibrary::GT_RefreshWindow(struct Window * win, struct Requester * req)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;
	register void * a1 __asm("a1") = req;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID GadToolsLibrary::GT_BeginRefresh(struct Window * win)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID GadToolsLibrary::GT_EndRefresh(struct Window * win, LONG complete)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;
	register int d0 __asm("d0") = complete;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

struct IntuiMessage * GadToolsLibrary::GT_FilterIMsg(CONST struct IntuiMessage * imsg)
{
	register struct IntuiMessage * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a1 __asm("a1") = imsg;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct IntuiMessage *) _res;
}

struct IntuiMessage * GadToolsLibrary::GT_PostFilterIMsg(struct IntuiMessage * imsg)
{
	register struct IntuiMessage * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = imsg;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a1)
	: "a1");
	return (struct IntuiMessage *) _res;
}

struct Gadget * GadToolsLibrary::CreateContext(struct Gadget ** glistptr)
{
	register struct Gadget * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = glistptr;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Gadget *) _res;
}

VOID GadToolsLibrary::DrawBevelBoxA(struct RastPort * rport, LONG left, LONG top, LONG width, LONG height, CONST struct TagItem * taglist)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rport;
	register int d0 __asm("d0") = left;
	register int d1 __asm("d1") = top;
	register int d2 __asm("d2") = width;
	register int d3 __asm("d3") = height;
	register const void * a1 __asm("a1") = taglist;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a1)
	: "a0", "d0", "d1", "d2", "d3", "a1");
}

APTR GadToolsLibrary::GetVisualInfoA(struct Screen * screen, CONST struct TagItem * taglist)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register const void * a1 __asm("a1") = taglist;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

VOID GadToolsLibrary::FreeVisualInfo(APTR vi)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = vi;

	__asm volatile ("jsr a6@(-132)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG GadToolsLibrary::GT_GetGadgetAttrsA(struct Gadget * gad, struct Window * win, struct Requester * req, CONST struct TagItem * taglist)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gad;
	register void * a1 __asm("a1") = win;
	register void * a2 __asm("a2") = req;
	register const void * a3 __asm("a3") = taglist;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (LONG) _res;
}


#endif

