///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : wgscreen.cc           ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>


#include "wgscreen.h"


WGScreen :: WGScreen() : CScreen(),Waiter(),CRastPortHdl() {}


WGScreen :: WGScreen(struct NewScreen *neww) : CScreen(neww),Waiter(),CRastPortHdl() {}


WGScreen :: WGScreen(struct ExtNewScreen *neww) : CScreen(neww),Waiter(),CRastPortHdl() {}


WGScreen :: WGScreen(struct NewScreen *neww, struct TagItem *tags) : CScreen(neww, tags),Waiter(),CRastPortHdl() {}


WGScreen :: ~WGScreen() {}



BOOL WGScreen :: open()
{
	return GScreen :: open();
}


void WGScreen :: close()
{
	GScreen :: close();
}


BOOL WGScreen :: linkwindow(MsgWindow& window)
{
	return WScreen :: linkwindow(window);
}


MsgWindow * WGScreen :: rmwindow(MsgWindow& window)
{
	return WScreen :: rmwindow(window);
}


void WGScreen :: rmwindows()
{
	WScreen :: rmwindows();
}


