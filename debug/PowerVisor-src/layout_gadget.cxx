//===============================================//
// Layout manager classes                        //
// Gadget  																			 //
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

#ifndef LAYOUT_GADGET_H
#include "layout_gadget.h"
#endif

//-----------------------------------------------------------------//
// QUEUE                                                           //
//-----------------------------------------------------------------//

void GadgetQueue::Optimize ()
{
	DB(("gadget::GadgetQueue::Optimize for", get_parent ()->get_name ()));

	Queue::Optimize ();

// First optimize the queue (operations in the queue are not removed
// but disabled)
//		1. If there are QORefreshGadget operations in the queue they may be
//			 discarded and replaced by one at the end of the list
//		2. Duplicate attribute settings are removed and only the last one
//			 is retained
	int NeedsRefresh = FALSE;
	QueueCmd* qo = first;
	while (qo)
	{
		if (qo->op == QORefreshGadget)
		{
			NeedsRefresh = TRUE;
			qo->op = QONOP;
		}
		else
		{
			QueueCmd* qo2 = qo->next;
			while (qo2)
			{
				if (qo2->op == qo->op && qo2->a2.l == qo->a2.l && qo2->a1.p == qo->a1.p)
				{
					qo->op = QONOP;
					break;
				}
				qo2 = qo2->next;
			}
		}
		qo = qo->next;
	}
	if (NeedsRefresh) QuRefreshGadget ();
}

void GadgetQueue::Play (gadget* gad)
{
	DB(("gadget::GadgetQueue::Play for", get_parent ()->get_name ()));
	QueueCmd* qo = first;

// Draw everything
	struct Window* win = gad->get_shell ()->get_win ();
	while (qo)
	{
		switch (qo->op)
		{
			case QOSetGadgetAttr:
				SetGadgetAttrs (gad->g, win, NULL, qo->a2.l, qo->a3.i, TAG_DONE);
				break;
			case QOSetImageAttr:
				SetAttrs ((struct Image*)qo->a1.p, qo->a2.l, qo->a3.i, TAG_DONE);
				break;
			case QORefreshGadget:
				RefreshGList (gad->g, win, NULL, 1);
		}
		qo = qo->next;
		delete first;
		first = qo;
	}
	last = NULL;
}

//-----------------------------------------------------------------//
// GADGET                                                          //
//-----------------------------------------------------------------//

gadget::gadget (Shell* shell, char* name, composite* parent) :
		primitive (shell, name, parent),
		q (this)
{
	DB(("gadget::gadget", name));
	GadgetInList = FALSE;
	shell->RegisterEvent (this);
}

gadget::~gadget ()
{
	DB(("gadget::~gadget", get_name ()));
	RemoveGadget (get_shell ()->get_win (), g);
	DisposeObject (g);
	get_shell ()->UnregisterEvent (this);
}

void gadget::expose ()
{
	DB(("gadget::expose", get_name ()));
	// DrawImage (get_shell ()->get_rp (), image, left (), top ());
	if (!GadgetInList) { AddGadget (get_shell ()->get_win (), g, ~0); GadgetInList = TRUE; }
	// RefreshGList (g, get_shell ()->get_win (), NULL, 1);
	q.QuRefreshGadget ();
}

void gadget::resize ()
{
	DB(("gadget::resize", get_name ()));
//	SetGadgetAttrs (g, get_shell ()->get_win (), NULL,
//		GA_Left, left (),
//		GA_Top, top (),
//		GA_Width, width (),
//		GA_Height, height (),
//		TAG_DONE);
	q.QuSetGadgetAttr (GA_Left, left ());
	q.QuSetGadgetAttr (GA_Top, top ());
	q.QuSetGadgetAttr (GA_Width, width ());
	q.QuSetGadgetAttr (GA_Height, height ());
}

GeometryResult gadget::query_geometry (GeometryRequest& answer)
{
	DB(("gadget::query_geometry", get_name ()));
	answer = *this;
	answer.setwidth (prefered_width ());
	answer.setheight (prefered_height ());
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}


ResourceType gadget::GetResourceType (YtResource r)
{
	DB(("gadget::GetResourceType", get_name ()));
	switch (r)
	{
		case YtNgadgDisabled:
		case YtNgadgID:
		case YtNgadgImmediate:
		case YtNgadgRelVerify:
		case YtNgadgTabCycle:
			return ResourceLong;
	}
	return primitive::GetResourceType (r);
}

void gadget::SetResource (YtResource r, ResourceVal& v)
{
	DB(("gadget::SetResource", get_name ()));
	long attr;
	switch (r)
	{
		case YtNgadgDisabled: attr = GA_Disabled; break;
		case YtNgadgID: attr = GA_ID; break;
		case YtNgadgImmediate: attr = GA_Immediate; break;
		case YtNgadgRelVerify: attr = GA_RelVerify; break;
		case YtNgadgTabCycle: attr = GA_TabCycle; break;
		default:
			primitive::SetResource (r, v);
			return;
	}
//	SetGadgetAttrs (g, get_shell ()->get_win (), NULL, attr, v.l, TAG_DONE);
	q.QuSetGadgetAttr (attr, v.l);
}
