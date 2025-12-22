//===============================================//
// Layout manager classes                        //
// Scrollbar																		 //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include <exec/types.h>
#include <proto/intuition.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/classusr.h>

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

#ifndef LAYOUT_SCROLLBAR_H
#include "layout_scrollbar.h"
#endif

//-----------------------------------------------------------------//
// SCROLLBAR                                                       //
//-----------------------------------------------------------------//

scrollbar::scrollbar (Shell* shell, char *name, composite *parent) : gadget (shell, name, parent)
{
	D db("scrollbar::scrollbar", name);
	g = (struct Gadget*)NewObject ((struct IClass*)NULL, (unsigned char*)PROPGCLASS,
		GA_Left, left (),
		GA_Top, top (),
		GA_Width, width (),
		GA_Height, height (),
		GA_Immediate, TRUE,
		GA_RelVerify, TRUE,
		GA_FollowMouse, TRUE,
		PGA_Total, 9,
		PGA_Visible, 3,
		PGA_NewLook, TRUE,
		TAG_DONE);
	newValueCB = NULL;
	slidingCB = NULL;
	sliding = FALSE;
	horiz = 0;
}

scrollbar::~scrollbar ()
{
	D db("scrollbar::~scrollbar", get_name ());
}

int scrollbar::HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	D db("scrollbar::HandleEvent", get_name (), (int)clas, (int)code, (int)qual);
	YtScrollbarCBdata data;
	ULONG answer;
	if (g == (struct Gadget*)iaddr)
	{
		if (clas == IDCMP_GADGETUP)
		{
			sliding = FALSE;
			if (newValueCB)
			{
				GetAttr (PGA_Top, (APTR)g, &answer);
				data.pos = (unsigned short)answer;
				newValueCB (this, (void*)&data, newValueCBuser);
			}
		}
		else if (clas == IDCMP_GADGETDOWN)
		{
			sliding = TRUE;
		}
	}
	else if (sliding && clas == IDCMP_MOUSEMOVE && slidingCB)
	{
		GetAttr (PGA_Top, (APTR)g, &answer);
		data.pos = (unsigned short)answer;
		slidingCB (this, (void*)&data, slidingCBuser);
	}
	return 0;
}

boolean scrollbar::YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user)
{
	D db("scrollbar::YtAddCallback", get_name (), (int)cbt);
	switch (cbt)
	{
		case YtNnewValueCallback: newValueCB = cbf; newValueCBuser = user; break;
		case YtNslidingCallback: slidingCB = cbf; slidingCBuser = user; break;
		default: gadget::YtAddCallback (cbt, cbf, user);
	}
}

ResourceType scrollbar::GetResourceType (YtResource r)
{
	D db("scrollbar::GetResourceType", get_name ());
	switch (r)
	{
		case YtNpropOrientation:
		case YtNpropVisible:
		case YtNpropTotal:
		case YtNpropTop:
			return ResourceInt;
	}
	return gadget::GetResourceType (r);
}

void scrollbar::SetResource (YtResource r, ResourceVal& v)
{
	D db("scrollbar::SetResource", get_name ());
	int attr;
	switch (r)
	{
		case YtNpropVisible: attr = PGA_Visible; break;
		case YtNpropTotal: attr = PGA_Total; break;
		case YtNpropTop: attr = PGA_Top; break;
		case YtNpropOrientation: attr = PGA_Freedom; horiz = v.i == FREEHORIZ; break;
		default:
			gadget::SetResource (r, v);
			return;
	}
//	SetGadgetAttrs (g, get_shell ()->get_win (), NULL, attr, v.i, TAG_DONE);
	q.QuSetGadgetAttr (attr, v.i);
}
