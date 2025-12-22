
#ifndef _WORKBENCHLIBRARY_CPP
#define _WORKBENCHLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/WorkbenchLibrary.h>

WorkbenchLibrary::WorkbenchLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("workbench.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open workbench.library") );
	}
}

WorkbenchLibrary::~WorkbenchLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct AppWindow * WorkbenchLibrary::AddAppWindowA(ULONG id, ULONG userdata, struct Window * window, struct MsgPort * msgport, struct TagItem * taglist)
{
	register struct AppWindow * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = id;
	register unsigned int d1 __asm("d1") = userdata;
	register void * a0 __asm("a0") = window;
	register void * a1 __asm("a1") = msgport;
	register void * a2 __asm("a2") = taglist;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
	: "d0", "d1", "a0", "a1", "a2");
	return (struct AppWindow *) _res;
}

BOOL WorkbenchLibrary::RemoveAppWindow(struct AppWindow * appWindow)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = appWindow;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

struct AppIcon * WorkbenchLibrary::AddAppIconA(ULONG id, ULONG userdata, UBYTE * text, struct MsgPort * msgport, struct FileLock * lock, struct DiskObject * diskobj, struct TagItem * taglist)
{
	register struct AppIcon * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = id;
	register unsigned int d1 __asm("d1") = userdata;
	register void * a0 __asm("a0") = text;
	register void * a1 __asm("a1") = msgport;
	register void * a2 __asm("a2") = lock;
	register void * a3 __asm("a3") = diskobj;
	register void * a4 __asm("a4") = taglist;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
	: "d0", "d1", "a0", "a1", "a2", "a3", "a4");
	return (struct AppIcon *) _res;
}

BOOL WorkbenchLibrary::RemoveAppIcon(struct AppIcon * appIcon)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = appIcon;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

struct AppMenuItem * WorkbenchLibrary::AddAppMenuItemA(ULONG id, ULONG userdata, UBYTE * text, struct MsgPort * msgport, struct TagItem * taglist)
{
	register struct AppMenuItem * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = id;
	register unsigned int d1 __asm("d1") = userdata;
	register void * a0 __asm("a0") = text;
	register void * a1 __asm("a1") = msgport;
	register void * a2 __asm("a2") = taglist;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1), "r" (a2)
	: "d0", "d1", "a0", "a1", "a2");
	return (struct AppMenuItem *) _res;
}

BOOL WorkbenchLibrary::RemoveAppMenuItem(struct AppMenuItem * appMenuItem)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = appMenuItem;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

VOID WorkbenchLibrary::WBInfo(BPTR lock, STRPTR name, struct Screen * screen)
{
	register void * a6 __asm("a6") = Base;
	register unsigned int a0 __asm("a0") = lock;
	register char * a1 __asm("a1") = name;
	register void * a2 __asm("a2") = screen;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
}

BOOL WorkbenchLibrary::OpenWorkbenchObjectA(STRPTR name, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = name;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL WorkbenchLibrary::CloseWorkbenchObjectA(STRPTR name, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = name;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL WorkbenchLibrary::WorkbenchControlA(STRPTR name, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = name;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

struct AppWindowDropZone * WorkbenchLibrary::AddAppWindowDropZoneA(struct AppWindow * aw, ULONG id, ULONG userdata, struct TagItem * tags)
{
	register struct AppWindowDropZone * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = aw;
	register unsigned int d0 __asm("d0") = id;
	register unsigned int d1 __asm("d1") = userdata;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (a1)
	: "a0", "d0", "d1", "a1");
	return (struct AppWindowDropZone *) _res;
}

BOOL WorkbenchLibrary::RemoveAppWindowDropZone(struct AppWindow * aw, struct AppWindowDropZone * dropZone)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = aw;
	register void * a1 __asm("a1") = dropZone;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL WorkbenchLibrary::ChangeWorkbenchSelectionA(STRPTR name, struct Hook * hook, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = name;
	register void * a1 __asm("a1") = hook;
	register void * a2 __asm("a2") = tags;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

BOOL WorkbenchLibrary::MakeWorkbenchObjectVisibleA(STRPTR name, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = name;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}


#endif

