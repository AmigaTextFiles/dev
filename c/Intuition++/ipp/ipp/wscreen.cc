///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : wscreen.cc            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>


#include "wscreen.h"


WScreen :: WScreen() : CScreen(),Waiter() {}


WScreen :: WScreen(struct NewScreen *neww) : CScreen(neww),Waiter() {}


WScreen :: WScreen(struct ExtNewScreen *neww) : CScreen(neww),Waiter() {}


WScreen :: WScreen(struct NewScreen *neww, struct TagItem *tags) : CScreen(neww, tags),Waiter() {}


WScreen :: ~WScreen() {}


BOOL WScreen :: open()
{
	return CScreen :: open();
}


void WScreen :: close()
{
	CScreen :: close();
}


BOOL WScreen :: linkwindow(MsgWindow& window)
{
	BOOL ok = CScreen :: linkwindow(window);
	if (!ok) return FALSE;
	ok = Waiter :: linkwindow(window);
	if (!ok)
	{
		CScreen :: rmwindow(window);
		return FALSE;
	}
	return TRUE;
}


MsgWindow * WScreen :: rmwindow(MsgWindow& window)
{
	CScreen :: rmwindow(window);
	return Waiter :: rmwindow(window);
}


void WScreen :: rmwindows()
{
	CScreen :: rmwindows();
	Waiter :: rmwindows();
}


