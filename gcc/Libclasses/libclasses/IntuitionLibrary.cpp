
#ifndef _INTUITIONLIBRARY_CPP
#define _INTUITIONLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/IntuitionLibrary.h>

IntuitionLibrary::IntuitionLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("intuition.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open intuition.library") );
	}
}

IntuitionLibrary::~IntuitionLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID IntuitionLibrary::OpenIntuition()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-30)"
	: 
	: "r" (a6)
	: "d0");
}

VOID IntuitionLibrary::Intuition(struct InputEvent * iEvent)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = iEvent;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

UWORD IntuitionLibrary::AddGadget(struct Window * window, struct Gadget * gadget, ULONG position)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = gadget;
	register unsigned int d0 __asm("d0") = position;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (UWORD) _res;
}

BOOL IntuitionLibrary::ClearDMRequest(struct Window * window)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

VOID IntuitionLibrary::ClearMenuStrip(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-54)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IntuitionLibrary::ClearPointer(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IntuitionLibrary::CloseScreen(struct Screen * screen)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

VOID IntuitionLibrary::CloseWindow(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-72)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG IntuitionLibrary::CloseWorkBench()
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (LONG) _res;
}

VOID IntuitionLibrary::CurrentTime(ULONG * seconds, ULONG * micros)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = seconds;
	register void * a1 __asm("a1") = micros;

	__asm volatile ("jsr a6@(-84)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

BOOL IntuitionLibrary::DisplayAlert(ULONG alertNumber, CONST_STRPTR string, ULONG height)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = alertNumber;
	register const char * a0 __asm("a0") = string;
	register unsigned int d1 __asm("d1") = height;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (d1)
	: "d0", "a0", "d1");
	return (BOOL) _res;
}

VOID IntuitionLibrary::DisplayBeep(struct Screen * screen)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;

	__asm volatile ("jsr a6@(-96)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IntuitionLibrary::DoubleClick(ULONG sSeconds, ULONG sMicros, ULONG cSeconds, ULONG cMicros)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = sSeconds;
	register unsigned int d1 __asm("d1") = sMicros;
	register unsigned int d2 __asm("d2") = cSeconds;
	register unsigned int d3 __asm("d3") = cMicros;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "d0", "d1", "d2", "d3");
	return (BOOL) _res;
}

VOID IntuitionLibrary::DrawBorder(struct RastPort * rp, CONST struct Border * border, LONG leftOffset, LONG topOffset)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register const void * a1 __asm("a1") = border;
	register int d0 __asm("d0") = leftOffset;
	register int d1 __asm("d1") = topOffset;

	__asm volatile ("jsr a6@(-108)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
}

VOID IntuitionLibrary::DrawImage(struct RastPort * rp, struct Image * image, LONG leftOffset, LONG topOffset)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register void * a1 __asm("a1") = image;
	register int d0 __asm("d0") = leftOffset;
	register int d1 __asm("d1") = topOffset;

	__asm volatile ("jsr a6@(-114)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
}

VOID IntuitionLibrary::EndRequest(struct Requester * requester, struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;
	register void * a1 __asm("a1") = window;

	__asm volatile ("jsr a6@(-120)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct Preferences * IntuitionLibrary::GetDefPrefs(struct Preferences * preferences, LONG size)
{
	register struct Preferences * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = preferences;
	register int d0 __asm("d0") = size;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (struct Preferences *) _res;
}

struct Preferences * IntuitionLibrary::GetPrefs(struct Preferences * preferences, LONG size)
{
	register struct Preferences * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = preferences;
	register int d0 __asm("d0") = size;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (struct Preferences *) _res;
}

VOID IntuitionLibrary::InitRequester(struct Requester * requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;

	__asm volatile ("jsr a6@(-138)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct MenuItem * IntuitionLibrary::ItemAddress(CONST struct Menu * menuStrip, ULONG menuNumber)
{
	register struct MenuItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = menuStrip;
	register unsigned int d0 __asm("d0") = menuNumber;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (struct MenuItem *) _res;
}

BOOL IntuitionLibrary::ModifyIDCMP(struct Window * window, ULONG flags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

VOID IntuitionLibrary::ModifyProp(struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG flags, ULONG horizPot, ULONG vertPot, ULONG horizBody, ULONG vertBody)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;
	register unsigned int d0 __asm("d0") = flags;
	register unsigned int d1 __asm("d1") = horizPot;
	register unsigned int d2 __asm("d2") = vertPot;
	register unsigned int d3 __asm("d3") = horizBody;
	register unsigned int d4 __asm("d4") = vertBody;

	__asm volatile ("jsr a6@(-156)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "a0", "a1", "a2", "d0", "d1", "d2", "d3", "d4");
}

VOID IntuitionLibrary::MoveScreen(struct Screen * screen, LONG dx, LONG dy)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-162)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

VOID IntuitionLibrary::MoveWindow(struct Window * window, LONG dx, LONG dy)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-168)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

VOID IntuitionLibrary::OffGadget(struct Gadget * gadget, struct Window * window, struct Requester * requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;

	__asm volatile ("jsr a6@(-174)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID IntuitionLibrary::OffMenu(struct Window * window, ULONG menuNumber)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register unsigned int d0 __asm("d0") = menuNumber;

	__asm volatile ("jsr a6@(-180)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

VOID IntuitionLibrary::OnGadget(struct Gadget * gadget, struct Window * window, struct Requester * requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;

	__asm volatile ("jsr a6@(-186)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID IntuitionLibrary::OnMenu(struct Window * window, ULONG menuNumber)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register unsigned int d0 __asm("d0") = menuNumber;

	__asm volatile ("jsr a6@(-192)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

struct Screen * IntuitionLibrary::OpenScreen(CONST struct NewScreen * newScreen)
{
	register struct Screen * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = newScreen;

	__asm volatile ("jsr a6@(-198)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Screen *) _res;
}

struct Window * IntuitionLibrary::OpenWindow(CONST struct NewWindow * newWindow)
{
	register struct Window * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = newWindow;

	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Window *) _res;
}

ULONG IntuitionLibrary::OpenWorkBench()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-210)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

VOID IntuitionLibrary::PrintIText(struct RastPort * rp, CONST struct IntuiText * iText, LONG left, LONG top)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register const void * a1 __asm("a1") = iText;
	register int d0 __asm("d0") = left;
	register int d1 __asm("d1") = top;

	__asm volatile ("jsr a6@(-216)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
}

VOID IntuitionLibrary::RefreshGadgets(struct Gadget * gadgets, struct Window * window, struct Requester * requester)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadgets;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;

	__asm volatile ("jsr a6@(-222)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

UWORD IntuitionLibrary::RemoveGadget(struct Window * window, struct Gadget * gadget)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = gadget;

	__asm volatile ("jsr a6@(-228)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (UWORD) _res;
}

VOID IntuitionLibrary::ReportMouse(LONG flag, struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = flag;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-234)"
	: 
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
}

BOOL IntuitionLibrary::Request(struct Requester * requester, struct Window * window)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = requester;
	register void * a1 __asm("a1") = window;

	__asm volatile ("jsr a6@(-240)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID IntuitionLibrary::ScreenToBack(struct Screen * screen)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;

	__asm volatile ("jsr a6@(-246)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IntuitionLibrary::ScreenToFront(struct Screen * screen)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;

	__asm volatile ("jsr a6@(-252)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IntuitionLibrary::SetDMRequest(struct Window * window, struct Requester * requester)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = requester;

	__asm volatile ("jsr a6@(-258)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL IntuitionLibrary::SetMenuStrip(struct Window * window, struct Menu * menu)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = menu;

	__asm volatile ("jsr a6@(-264)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID IntuitionLibrary::SetPointer(struct Window * window, UWORD * pointer, LONG height, LONG width, LONG xOffset, LONG yOffset)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = pointer;
	register int d0 __asm("d0") = height;
	register int d1 __asm("d1") = width;
	register int d2 __asm("d2") = xOffset;
	register int d3 __asm("d3") = yOffset;

	__asm volatile ("jsr a6@(-270)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "a1", "d0", "d1", "d2", "d3");
}

VOID IntuitionLibrary::SetWindowTitles(struct Window * window, CONST_STRPTR windowTitle, CONST_STRPTR screenTitle)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register const char * a1 __asm("a1") = windowTitle;
	register const char * a2 __asm("a2") = screenTitle;

	__asm volatile ("jsr a6@(-276)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID IntuitionLibrary::ShowTitle(struct Screen * screen, LONG showIt)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register int d0 __asm("d0") = showIt;

	__asm volatile ("jsr a6@(-282)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

VOID IntuitionLibrary::SizeWindow(struct Window * window, LONG dx, LONG dy)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;

	__asm volatile ("jsr a6@(-288)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
}

struct View * IntuitionLibrary::ViewAddress()
{
	register struct View * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-294)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct View *) _res;
}

struct ViewPort * IntuitionLibrary::ViewPortAddress(CONST struct Window * window)
{
	register struct ViewPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-300)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct ViewPort *) _res;
}

VOID IntuitionLibrary::WindowToBack(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-306)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IntuitionLibrary::WindowToFront(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-312)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IntuitionLibrary::WindowLimits(struct Window * window, LONG widthMin, LONG heightMin, ULONG widthMax, ULONG heightMax)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register int d0 __asm("d0") = widthMin;
	register int d1 __asm("d1") = heightMin;
	register unsigned int d2 __asm("d2") = widthMax;
	register unsigned int d3 __asm("d3") = heightMax;

	__asm volatile ("jsr a6@(-318)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
	return (BOOL) _res;
}

struct Preferences * IntuitionLibrary::SetPrefs(CONST struct Preferences * preferences, LONG size, LONG inform)
{
	register struct Preferences * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = preferences;
	register int d0 __asm("d0") = size;
	register int d1 __asm("d1") = inform;

	__asm volatile ("jsr a6@(-324)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (struct Preferences *) _res;
}

LONG IntuitionLibrary::IntuiTextLength(CONST struct IntuiText * iText)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = iText;

	__asm volatile ("jsr a6@(-330)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

BOOL IntuitionLibrary::WBenchToBack()
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-336)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (BOOL) _res;
}

BOOL IntuitionLibrary::WBenchToFront()
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-342)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (BOOL) _res;
}

BOOL IntuitionLibrary::AutoRequest(struct Window * window, CONST struct IntuiText * body, CONST struct IntuiText * posText, CONST struct IntuiText * negText, ULONG pFlag, ULONG nFlag, ULONG width, ULONG height)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register const void * a1 __asm("a1") = body;
	register const void * a2 __asm("a2") = posText;
	register const void * a3 __asm("a3") = negText;
	register unsigned int d0 __asm("d0") = pFlag;
	register unsigned int d1 __asm("d1") = nFlag;
	register unsigned int d2 __asm("d2") = width;
	register unsigned int d3 __asm("d3") = height;

	__asm volatile ("jsr a6@(-348)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "a1", "a2", "a3", "d0", "d1", "d2", "d3");
	return (BOOL) _res;
}

VOID IntuitionLibrary::BeginRefresh(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-354)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct Window * IntuitionLibrary::BuildSysRequest(struct Window * window, CONST struct IntuiText * body, CONST struct IntuiText * posText, CONST struct IntuiText * negText, ULONG flags, ULONG width, ULONG height)
{
	register struct Window * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register const void * a1 __asm("a1") = body;
	register const void * a2 __asm("a2") = posText;
	register const void * a3 __asm("a3") = negText;
	register unsigned int d0 __asm("d0") = flags;
	register unsigned int d1 __asm("d1") = width;
	register unsigned int d2 __asm("d2") = height;

	__asm volatile ("jsr a6@(-360)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (d0), "r" (d1), "r" (d2)
	: "a0", "a1", "a2", "a3", "d0", "d1", "d2");
	return (struct Window *) _res;
}

VOID IntuitionLibrary::EndRefresh(struct Window * window, LONG complete)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register int d0 __asm("d0") = complete;

	__asm volatile ("jsr a6@(-366)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

VOID IntuitionLibrary::FreeSysRequest(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-372)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG IntuitionLibrary::MakeScreen(struct Screen * screen)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;

	__asm volatile ("jsr a6@(-378)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

LONG IntuitionLibrary::RemakeDisplay()
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-384)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (LONG) _res;
}

LONG IntuitionLibrary::RethinkDisplay()
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-390)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (LONG) _res;
}

APTR IntuitionLibrary::AllocRemember(struct Remember ** rememberKey, ULONG size, ULONG flags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rememberKey;
	register unsigned int d0 __asm("d0") = size;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-396)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (APTR) _res;
}

VOID IntuitionLibrary::FreeRemember(struct Remember ** rememberKey, LONG reallyForget)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rememberKey;
	register int d0 __asm("d0") = reallyForget;

	__asm volatile ("jsr a6@(-408)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

ULONG IntuitionLibrary::LockIBase(ULONG dontknow)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = dontknow;

	__asm volatile ("jsr a6@(-414)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (ULONG) _res;
}

VOID IntuitionLibrary::UnlockIBase(ULONG ibLock)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int a0 __asm("a0") = ibLock;

	__asm volatile ("jsr a6@(-420)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG IntuitionLibrary::GetScreenData(APTR buffer, ULONG size, ULONG type, CONST struct Screen * screen)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = buffer;
	register unsigned int d0 __asm("d0") = size;
	register unsigned int d1 __asm("d1") = type;
	register const void * a1 __asm("a1") = screen;

	__asm volatile ("jsr a6@(-426)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1)
	: "a0", "d0", "d1", "a1");
	return (LONG) _res;
}

VOID IntuitionLibrary::RefreshGList(struct Gadget * gadgets, struct Window * window, struct Requester * requester, LONG numGad)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadgets;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;
	register int d0 __asm("d0") = numGad;

	__asm volatile ("jsr a6@(-432)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
	: "a0", "a1", "a2", "d0");
}

UWORD IntuitionLibrary::AddGList(struct Window * window, struct Gadget * gadget, ULONG position, LONG numGad, struct Requester * requester)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = gadget;
	register unsigned int d0 __asm("d0") = position;
	register int d1 __asm("d1") = numGad;
	register void * a2 __asm("a2") = requester;

	__asm volatile ("jsr a6@(-438)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (a2)
	: "a0", "a1", "d0", "d1", "a2");
	return (UWORD) _res;
}

UWORD IntuitionLibrary::RemoveGList(struct Window * remPtr, struct Gadget * gadget, LONG numGad)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = remPtr;
	register void * a1 __asm("a1") = gadget;
	register int d0 __asm("d0") = numGad;

	__asm volatile ("jsr a6@(-444)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (UWORD) _res;
}

VOID IntuitionLibrary::ActivateWindow(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-450)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IntuitionLibrary::RefreshWindowFrame(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-456)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IntuitionLibrary::ActivateGadget(struct Gadget * gadgets, struct Window * window, struct Requester * requester)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadgets;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;

	__asm volatile ("jsr a6@(-462)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

VOID IntuitionLibrary::NewModifyProp(struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG flags, ULONG horizPot, ULONG vertPot, ULONG horizBody, ULONG vertBody, LONG numGad)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;
	register unsigned int d0 __asm("d0") = flags;
	register unsigned int d1 __asm("d1") = horizPot;
	register unsigned int d2 __asm("d2") = vertPot;
	register unsigned int d3 __asm("d3") = horizBody;
	register unsigned int d4 __asm("d4") = vertBody;
	register int d5 __asm("d5") = numGad;

	__asm volatile ("jsr a6@(-468)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "a0", "a1", "a2", "d0", "d1", "d2", "d3", "d4", "d5");
}

LONG IntuitionLibrary::QueryOverscan(ULONG displayID, struct Rectangle * rect, LONG oScanType)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int a0 __asm("a0") = displayID;
	register void * a1 __asm("a1") = rect;
	register int d0 __asm("d0") = oScanType;

	__asm volatile ("jsr a6@(-474)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

VOID IntuitionLibrary::MoveWindowInFrontOf(struct Window * window, struct Window * behindWindow)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = behindWindow;

	__asm volatile ("jsr a6@(-480)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

VOID IntuitionLibrary::ChangeWindowBox(struct Window * window, LONG left, LONG top, LONG width, LONG height)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register int d0 __asm("d0") = left;
	register int d1 __asm("d1") = top;
	register int d2 __asm("d2") = width;
	register int d3 __asm("d3") = height;

	__asm volatile ("jsr a6@(-486)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
	: "a0", "d0", "d1", "d2", "d3");
}

struct Hook * IntuitionLibrary::SetEditHook(struct Hook * hook)
{
	register struct Hook * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = hook;

	__asm volatile ("jsr a6@(-492)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Hook *) _res;
}

LONG IntuitionLibrary::SetMouseQueue(struct Window * window, ULONG queueLength)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register unsigned int d0 __asm("d0") = queueLength;

	__asm volatile ("jsr a6@(-498)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

VOID IntuitionLibrary::ZipWindow(struct Window * window)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;

	__asm volatile ("jsr a6@(-504)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct Screen * IntuitionLibrary::LockPubScreen(CONST_STRPTR name)
{
	register struct Screen * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-510)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Screen *) _res;
}

VOID IntuitionLibrary::UnlockPubScreen(CONST_STRPTR name, struct Screen * screen)
{
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;
	register void * a1 __asm("a1") = screen;

	__asm volatile ("jsr a6@(-516)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

struct List * IntuitionLibrary::LockPubScreenList()
{
	register struct List * _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-522)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (struct List *) _res;
}

VOID IntuitionLibrary::UnlockPubScreenList()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-528)"
	: 
	: "r" (a6)
	: "d0");
}

STRPTR IntuitionLibrary::NextPubScreen(CONST struct Screen * screen, STRPTR namebuf)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = screen;
	register char * a1 __asm("a1") = namebuf;

	__asm volatile ("jsr a6@(-534)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (STRPTR) _res;
}

VOID IntuitionLibrary::SetDefaultPubScreen(CONST_STRPTR name)
{
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-540)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

UWORD IntuitionLibrary::SetPubScreenModes(ULONG modes)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = modes;

	__asm volatile ("jsr a6@(-546)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (UWORD) _res;
}

UWORD IntuitionLibrary::PubScreenStatus(struct Screen * screen, ULONG statusFlags)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register unsigned int d0 __asm("d0") = statusFlags;

	__asm volatile ("jsr a6@(-552)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (UWORD) _res;
}

struct RastPort * IntuitionLibrary::ObtainGIRPort(struct GadgetInfo * gInfo)
{
	register struct RastPort * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gInfo;

	__asm volatile ("jsr a6@(-558)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct RastPort *) _res;
}

VOID IntuitionLibrary::ReleaseGIRPort(struct RastPort * rp)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;

	__asm volatile ("jsr a6@(-564)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID IntuitionLibrary::GadgetMouse(struct Gadget * gadget, struct GadgetInfo * gInfo, WORD * mousePoint)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = gInfo;
	register void * a2 __asm("a2") = mousePoint;

	__asm volatile ("jsr a6@(-570)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

VOID IntuitionLibrary::GetDefaultPubScreen(STRPTR nameBuffer)
{
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = nameBuffer;

	__asm volatile ("jsr a6@(-582)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

LONG IntuitionLibrary::EasyRequestArgs(struct Window * window, CONST struct EasyStruct * easyStruct, ULONG * idcmpPtr, CONST APTR args)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register const void * a1 __asm("a1") = easyStruct;
	register void * a2 __asm("a2") = idcmpPtr;
	register const void * a3 __asm("a3") = args;

	__asm volatile ("jsr a6@(-588)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (LONG) _res;
}

struct Window * IntuitionLibrary::BuildEasyRequestArgs(struct Window * window, CONST struct EasyStruct * easyStruct, ULONG idcmp, CONST APTR args)
{
	register struct Window * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register const void * a1 __asm("a1") = easyStruct;
	register unsigned int d0 __asm("d0") = idcmp;
	register const void * a3 __asm("a3") = args;

	__asm volatile ("jsr a6@(-594)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (a3)
	: "a0", "a1", "d0", "a3");
	return (struct Window *) _res;
}

LONG IntuitionLibrary::SysReqHandler(struct Window * window, ULONG * idcmpPtr, LONG waitInput)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = idcmpPtr;
	register int d0 __asm("d0") = waitInput;

	__asm volatile ("jsr a6@(-600)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (LONG) _res;
}

struct Window * IntuitionLibrary::OpenWindowTagList(CONST struct NewWindow * newWindow, CONST struct TagItem * tagList)
{
	register struct Window * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = newWindow;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-606)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Window *) _res;
}

struct Screen * IntuitionLibrary::OpenScreenTagList(CONST struct NewScreen * newScreen, CONST struct TagItem * tagList)
{
	register struct Screen * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = newScreen;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-612)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct Screen *) _res;
}

VOID IntuitionLibrary::DrawImageState(struct RastPort * rp, struct Image * image, LONG leftOffset, LONG topOffset, ULONG state, CONST struct DrawInfo * drawInfo)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register void * a1 __asm("a1") = image;
	register int d0 __asm("d0") = leftOffset;
	register int d1 __asm("d1") = topOffset;
	register unsigned int d2 __asm("d2") = state;
	register const void * a2 __asm("a2") = drawInfo;

	__asm volatile ("jsr a6@(-618)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (a2)
	: "a0", "a1", "d0", "d1", "d2", "a2");
}

BOOL IntuitionLibrary::PointInImage(ULONG point, struct Image * image)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = point;
	register void * a0 __asm("a0") = image;

	__asm volatile ("jsr a6@(-624)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (BOOL) _res;
}

VOID IntuitionLibrary::EraseImage(struct RastPort * rp, struct Image * image, LONG leftOffset, LONG topOffset)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rp;
	register void * a1 __asm("a1") = image;
	register int d0 __asm("d0") = leftOffset;
	register int d1 __asm("d1") = topOffset;

	__asm volatile ("jsr a6@(-630)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
}

APTR IntuitionLibrary::NewObjectA(struct IClass * classPtr, CONST_STRPTR classID, CONST struct TagItem * tagList)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = classPtr;
	register const char * a1 __asm("a1") = classID;
	register const void * a2 __asm("a2") = tagList;

	__asm volatile ("jsr a6@(-636)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (APTR) _res;
}

VOID IntuitionLibrary::DisposeObject(APTR object)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;

	__asm volatile ("jsr a6@(-642)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG IntuitionLibrary::SetAttrsA(APTR object, CONST struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = object;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-648)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG IntuitionLibrary::GetAttr(ULONG attrID, APTR object, ULONG * storagePtr)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = attrID;
	register void * a0 __asm("a0") = object;
	register void * a1 __asm("a1") = storagePtr;

	__asm volatile ("jsr a6@(-654)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (ULONG) _res;
}

ULONG IntuitionLibrary::SetGadgetAttrsA(struct Gadget * gadget, struct Window * window, struct Requester * requester, CONST struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gadget;
	register void * a1 __asm("a1") = window;
	register void * a2 __asm("a2") = requester;
	register const void * a3 __asm("a3") = tagList;

	__asm volatile ("jsr a6@(-660)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (ULONG) _res;
}

APTR IntuitionLibrary::NextObject(APTR objectPtrPtr)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = objectPtrPtr;

	__asm volatile ("jsr a6@(-666)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

struct IClass * IntuitionLibrary::MakeClass(CONST_STRPTR classID, CONST_STRPTR superClassID, CONST struct IClass * superClassPtr, ULONG instanceSize, ULONG flags)
{
	register struct IClass * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = classID;
	register const char * a1 __asm("a1") = superClassID;
	register const void * a2 __asm("a2") = superClassPtr;
	register unsigned int d0 __asm("d0") = instanceSize;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-678)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
	: "a0", "a1", "a2", "d0", "d1");
	return (struct IClass *) _res;
}

VOID IntuitionLibrary::AddClass(struct IClass * classPtr)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = classPtr;

	__asm volatile ("jsr a6@(-684)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct DrawInfo * IntuitionLibrary::GetScreenDrawInfo(struct Screen * screen)
{
	register struct DrawInfo * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;

	__asm volatile ("jsr a6@(-690)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct DrawInfo *) _res;
}

VOID IntuitionLibrary::FreeScreenDrawInfo(struct Screen * screen, struct DrawInfo * drawInfo)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register void * a1 __asm("a1") = drawInfo;

	__asm volatile ("jsr a6@(-696)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

BOOL IntuitionLibrary::ResetMenuStrip(struct Window * window, struct Menu * menu)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = menu;

	__asm volatile ("jsr a6@(-702)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

VOID IntuitionLibrary::RemoveClass(struct IClass * classPtr)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = classPtr;

	__asm volatile ("jsr a6@(-708)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL IntuitionLibrary::FreeClass(struct IClass * classPtr)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = classPtr;

	__asm volatile ("jsr a6@(-714)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

struct ScreenBuffer * IntuitionLibrary::AllocScreenBuffer(struct Screen * sc, struct BitMap * bm, ULONG flags)
{
	register struct ScreenBuffer * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = sc;
	register void * a1 __asm("a1") = bm;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-768)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (struct ScreenBuffer *) _res;
}

VOID IntuitionLibrary::FreeScreenBuffer(struct Screen * sc, struct ScreenBuffer * sb)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = sc;
	register void * a1 __asm("a1") = sb;

	__asm volatile ("jsr a6@(-774)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG IntuitionLibrary::ChangeScreenBuffer(struct Screen * sc, struct ScreenBuffer * sb)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = sc;
	register void * a1 __asm("a1") = sb;

	__asm volatile ("jsr a6@(-780)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

VOID IntuitionLibrary::ScreenDepth(struct Screen * screen, ULONG flags, APTR reserved)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register unsigned int d0 __asm("d0") = flags;
	register void * a1 __asm("a1") = reserved;

	__asm volatile ("jsr a6@(-786)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
}

VOID IntuitionLibrary::ScreenPosition(struct Screen * screen, ULONG flags, LONG x1, LONG y1, LONG x2, LONG y2)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = screen;
	register unsigned int d0 __asm("d0") = flags;
	register int d1 __asm("d1") = x1;
	register int d2 __asm("d2") = y1;
	register int d3 __asm("d3") = x2;
	register int d4 __asm("d4") = y2;

	__asm volatile ("jsr a6@(-792)"
	: 
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
	: "a0", "d0", "d1", "d2", "d3", "d4");
}

VOID IntuitionLibrary::ScrollWindowRaster(struct Window * win, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = win;
	register int d0 __asm("d0") = dx;
	register int d1 __asm("d1") = dy;
	register int d2 __asm("d2") = xMin;
	register int d3 __asm("d3") = yMin;
	register int d4 __asm("d4") = xMax;
	register int d5 __asm("d5") = yMax;

	__asm volatile ("jsr a6@(-798)"
	: 
	: "r" (a6), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)
	: "a1", "d0", "d1", "d2", "d3", "d4", "d5");
}

VOID IntuitionLibrary::LendMenus(struct Window * fromwindow, struct Window * towindow)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = fromwindow;
	register void * a1 __asm("a1") = towindow;

	__asm volatile ("jsr a6@(-804)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

ULONG IntuitionLibrary::DoGadgetMethodA(struct Gadget * gad, struct Window * win, struct Requester * req, Msg message)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = gad;
	register void * a1 __asm("a1") = win;
	register void * a2 __asm("a2") = req;
	register Msg a3 __asm("a3") = message;

	__asm volatile ("jsr a6@(-810)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (ULONG) _res;
}

VOID IntuitionLibrary::SetWindowPointerA(struct Window * win, CONST struct TagItem * taglist)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;
	register const void * a1 __asm("a1") = taglist;

	__asm volatile ("jsr a6@(-816)"
	: 
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
}

BOOL IntuitionLibrary::TimedDisplayAlert(ULONG alertNumber, CONST_STRPTR string, ULONG height, ULONG time)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = alertNumber;
	register const char * a0 __asm("a0") = string;
	register unsigned int d1 __asm("d1") = height;
	register unsigned int a1 __asm("a1") = time;

	__asm volatile ("jsr a6@(-822)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (d1), "r" (a1)
	: "d0", "a0", "d1", "a1");
	return (BOOL) _res;
}

VOID IntuitionLibrary::HelpControl(struct Window * win, ULONG flags)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = win;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-828)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}


#endif

