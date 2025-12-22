///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : gfxwindow.cc          ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>


#include "gfxwindow.h"


GfxWindow :: GfxWindow() : CWindow(),CRastPortHdl() {}


GfxWindow :: GfxWindow(struct NewWindow *neww) : CWindow(neww),CRastPortHdl() {}


GfxWindow :: GfxWindow(struct ExtNewWindow *neww) : CWindow(neww),CRastPortHdl() {}


GfxWindow :: GfxWindow(struct NewWindow *neww, struct TagItem *tags) : CWindow(neww, tags),CRastPortHdl() {}


GfxWindow :: ~GfxWindow() {}


BOOL GfxWindow :: open()
{
	BOOL ok = CWindow :: open();
	if (ok) ok = CRastPortHdl :: hdlon(wind->RPort);
	return ok;
}


void GfxWindow :: close()
{
	CWindow :: close();
	CRastPortHdl :: hdloff();
}


void GfxWindow :: clear()
{
	CRastPortHdl :: clear();
	RefreshWindowFrame(wind);
}

