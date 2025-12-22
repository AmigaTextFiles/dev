///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : mgwindow.cc           ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>

#include "mgwindow.h"

MGWindow :: MGWindow() {}
MGWindow :: MGWindow(struct NewWindow *neww) : CWindow(neww),GfxWindow(),MsgWindow() {}
MGWindow :: MGWindow(struct ExtNewWindow *neww) : CWindow(neww),GfxWindow(),MsgWindow() {}
MGWindow :: MGWindow(struct NewWindow *neww, struct TagItem *tags) : CWindow(neww, tags),GfxWindow(),MsgWindow() {}
MGWindow :: ~MGWindow() {}

BOOL MGWindow :: open()
{
	BOOL ok = CWindow::open();
	if (menu && ok) SetMenuStrip(wind,menu);
	if (ok) ok = hdlon(wind->RPort);
	return ok;
}

void MGWindow :: close()
{
	if (wind) ClearMenuStrip(wind);
	GfxWindow :: close();
}
