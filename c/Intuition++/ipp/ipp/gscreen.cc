///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : gscreen.cc            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>


#include "gscreen.h"


GScreen :: GScreen() : CScreen(),CRastPortHdl() {}


GScreen :: GScreen(struct NewScreen *neww) : CScreen(neww),CRastPortHdl() {}


GScreen :: GScreen(struct ExtNewScreen *neww) : CScreen(neww),CRastPortHdl() {}


GScreen :: GScreen(struct NewScreen *neww, struct TagItem *tags) : CScreen(neww, tags),CRastPortHdl() {}


GScreen :: ~GScreen() {}


BOOL GScreen :: open()
{
	if (isopen()) return TRUE;
	scr=(struct Screen *)OpenScreenTagList((struct NewScreen *)newscr, newscr->Extension);
	if (isopen())
	{
		CRastPortHdl :: hdlon(&scr->RastPort);
		reopenwindows();
		return TRUE;
	}
	else return FALSE;
}


void GScreen :: close()
{
	CScreen :: close();
	CRastPortHdl :: hdloff();
}

