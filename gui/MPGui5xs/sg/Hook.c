// MPGui - requester library
// Copyright (C) © 1995 Mark John Paddock

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

// mark@topic.demon.co.uk
// mpaddock@cix.compulink.co.uk

#include <proto/exec.h>
#include <clib/graphics_protos.h>
#include <graphics/gfxmacros.h>
#define GfxBase MyGfxBase
#include <pragmas/graphics_pragmas.h>
#include <dos/dos.h>
#include <clib/gadtools_protos.h>
#define GadToolsBase MyGadToolsBase
#include <pragmas/gadtools_pragmas.h>
#include <libraries/gadtools.h>
#include <string.h>
#include <proto/locale.h>
extern struct Library *LocaleBase = NULL;
#include "MPGui.h"
#define CATCOMP_NUMBERS
#include "messages.h"

ULONG __asm HookEntryList(register __a0 struct Hook *Hook,
								 register __a2 struct MyValue *MyValue,
								 register __a1 struct LVDrawMsg *msg);

ULONG __asm MyRefresh(register __a0 struct Hook *hook,
								  register __a2 struct FileRequester *fr,
								  register __a1 struct IntuiMessage *msg);

static far int OpenCount = 0;
far struct Hook HookList = {0};
far struct GfxBase *MyGfxBase = NULL;
far struct Library *MyGadToolsBase = NULL;

char OKCHAR;
char CANCELCHAR;
char SAVECHAR;
char USECHAR;

int __stdargs
_STI_Open(void) {
	Forbid();
	if (!OpenCount) {
		++OpenCount;
		Permit();
		HookList.h_Entry = (ULONG (*)())HookEntryList;
		HookList.h_Data	 = NULL;
		GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",0);
		if (!GfxBase) {
//			Permit();
			return 1;
		}
		GadToolsBase = OpenLibrary("gadtools.library",0);
		if (!GadToolsBase) {
			CloseLibrary((struct Library *)GfxBase);
			GfxBase = NULL;
//			Permit();
			return 1;
		}
	}
	else {
		++OpenCount;
		Permit();
	}
	if (!(LocaleBase = OpenLibrary("locale.library",38))) {
		return 1;
	}
	Catalog = OpenCatalog(NULL,
								"mp/mpgui.catalog",
								TAG_END);
	OKCHAR = *GetMessage(MSG_OKCHAR);
	USECHAR = *GetMessage(MSG_USECHAR);
	SAVECHAR = *GetMessage(MSG_SAVECHAR);
	CANCELCHAR = *GetMessage(MSG_CANCELCHAR);
	return 0;
}

void __stdargs
_STD_Close(void) {
	--OpenCount;
	if (!OpenCount) {
		if (GfxBase) {
			CloseLibrary((struct Library *)GfxBase);
			GfxBase = NULL;
		}
		if (GadToolsBase) {
			CloseLibrary(GadToolsBase);
			GadToolsBase = NULL;
		}
		if (LocaleBase) {
			CloseCatalog(Catalog);
			Catalog = NULL;
			CloseLibrary(LocaleBase);
			LocaleBase = NULL;
		}
	}
	return;
}

ULONG __asm MyRefresh(register __a0 struct Hook *hook,
								  register __a2 struct FileRequester *fr,
								  register __a1 struct IntuiMessage *msg) {
	if (msg->Class == IDCMP_REFRESHWINDOW) {
		GT_BeginRefresh(((struct MPGuiHandle *)hook->h_Data)->Window);
		GT_EndRefresh(((struct MPGuiHandle *)hook->h_Data)->Window,TRUE);
	}
	return 0;
}

ULONG __asm HookEntryList(register __a0 struct Hook *Hook,
								 register __a2 struct MyValue *MyValue,
								 register __a1 struct LVDrawMsg *msg) {
	char buffer[2];
	ULONG len;
	WORD length;
	struct TextExtent textExtent;
	if (msg->lvdm_MethodID != LV_DRAW) {
		return LVCB_UNKNOWN;
	}
	switch(msg->lvdm_State) {
	case LVR_NORMAL:
	case LVR_NORMALDISABLED:
	case LVR_SELECTED:
	case LVR_SELECTEDDISABLED:
		Move(msg->lvdm_RastPort,msg->lvdm_Bounds.MinX,msg->lvdm_Bounds.MinY+msg->lvdm_RastPort->TxBaseline);
		length = TextLength(msg->lvdm_RastPort,"+",1);
		switch(msg->lvdm_State) {
		case LVR_NORMAL:
		case LVR_NORMALDISABLED:
			buffer[0] = ' ';
			break;
		case LVR_SELECTED:
		case LVR_SELECTEDDISABLED:
			buffer[0] = '+';
			break;
		}
		buffer[1]=0;
		len = TextFit(msg->lvdm_RastPort,MyValue->VNode.ln_Name,strlen(MyValue->VNode.ln_Name),&textExtent,NULL,1,msg->lvdm_Bounds.MaxX-msg->lvdm_Bounds.MinX+1-length,32767);
		if (!MyValue->Selected) {
			SetABPenDrMd(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[TEXTPEN],msg->lvdm_DrawInfo->dri_Pens[BACKGROUNDPEN],JAM2);
		}
		else {
			SetABPenDrMd(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[FILLTEXTPEN],msg->lvdm_DrawInfo->dri_Pens[FILLPEN],JAM2);
		}
		Text(msg->lvdm_RastPort,buffer,1);
		if (msg->lvdm_RastPort->cp_x < msg->lvdm_Bounds.MinX+length) {
			if (!MyValue->Selected) {
				SetAPen(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[BACKGROUNDPEN]);
			}
			else {
				SetAPen(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[FILLPEN]);
			}
			RectFill(msg->lvdm_RastPort,msg->lvdm_RastPort->cp_x,msg->lvdm_Bounds.MinY,msg->lvdm_Bounds.MinX-1+length,msg->lvdm_Bounds.MaxY);
		}
		Move(msg->lvdm_RastPort,msg->lvdm_Bounds.MinX+length,msg->lvdm_Bounds.MinY+msg->lvdm_RastPort->TxBaseline);
		if (!MyValue->Selected) {
			SetABPenDrMd(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[TEXTPEN],msg->lvdm_DrawInfo->dri_Pens[BACKGROUNDPEN],JAM2);
		}
		else {
			SetABPenDrMd(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[FILLTEXTPEN],msg->lvdm_DrawInfo->dri_Pens[FILLPEN],JAM2);
		}
		Text(msg->lvdm_RastPort,MyValue->VNode.ln_Name,len);
		if (!MyValue->Selected) {
			SetAPen(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[BACKGROUNDPEN]);
		}
		else {
			SetAPen(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[FILLPEN]);
		}
		RectFill(msg->lvdm_RastPort,msg->lvdm_RastPort->cp_x,msg->lvdm_Bounds.MinY,msg->lvdm_Bounds.MaxX,msg->lvdm_Bounds.MaxY);
		break;
	default:
		break;
	}
	switch(msg->lvdm_State) {
	case LVR_NORMALDISABLED:
	case LVR_SELECTEDDISABLED:
		{
			USHORT ditherdata[] = {
				0x4444,
				0x1111
			};
			SetAfPt(msg->lvdm_RastPort,ditherdata,1);
			SetABPenDrMd(msg->lvdm_RastPort,msg->lvdm_DrawInfo->dri_Pens[TEXTPEN],msg->lvdm_DrawInfo->dri_Pens[TEXTPEN],JAM1);
			RectFill(msg->lvdm_RastPort,msg->lvdm_Bounds.MinX,msg->lvdm_Bounds.MinY,msg->lvdm_Bounds.MaxX,msg->lvdm_Bounds.MaxY);
		}
		break;
	default:
		break;
	}
	return LVCB_OK;
}
