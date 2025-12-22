//===============================================//
// Layout manager classes                        //
// Shell																				 //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include <exec/types.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <graphics/gfx.h>
#include <graphics/gfxmacros.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/classusr.h>

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

//-----------------------------------------------------------------//
// SHELL                                                           //
//-----------------------------------------------------------------//

Shell::Shell (char *name, composite* parent) : composite (this, name, parent)
{
	D db("Shell::Shell", name);
	events = NULL;
	win = NULL;
	RegisterEvent (this);
}

Shell::~Shell ()
{
	D db("Shell::~Shell", get_name ());
	while (events)
		UnregisterEvent (events->obj);
	if (win) CloseWindow (win);
}


void Shell::clear ()
{
	D db("Shell::clear", get_name ());
	SetRast (rp, 0);
	RefreshWindowFrame (win);
}

void Shell::clear_box (int x, int y, int w, int h)
{
	D db("Shell::clear_box", get_name ());
	EraseRect (rp, x, y, x+w-1, y+h-1);
}

void Shell::draw_box (int x, int y, int w, int h)
{
	D db("Shell::draw_box", get_name ());
	Move (rp, x, y);
	Draw (rp, x+w-1, y);
	Draw (rp, x+w-1, y+h-1);
	Draw (rp, x, y+h-1);
	Draw (rp, x, y);
}


int Shell::HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	D db("Shell::HandleEvent", get_name ());
	switch (clas)
	{
		case IDCMP_CLOSEWINDOW:
			return 1;
		case IDCMP_INTUITICKS:
			PlayQueue ();
			break;
		case IDCMP_NEWSIZE:
			YtSetValues (YtNx, win->BorderLeft, YtNy, win->BorderTop,
				YtNwidth, win->Width-win->BorderLeft-win->BorderRight,
				YtNheight, win->Height-win->BorderTop-win->BorderBottom, YtNend);
			expose ();
			break;
	}
	return 0;
}


void Shell::expose ()
{
	D db("Shell::expose", get_name ());
	if (!win)
	{
		GeometryRequest answer;
		if (children)
		{
			children->query_geometry (answer);
			answer.setbox (10, 600, answer.width (), answer.height ());
		}
		else answer.setbox (10, 600, 300, 300);
		win = OpenWindowTags (NULL,
			WA_Left, answer.left (), WA_Top, answer.top (),
			WA_InnerWidth, answer.width (), WA_InnerHeight, answer.height (),
			WA_MinWidth, 50, WA_MinHeight, 50,
			WA_MaxWidth, ~0, WA_MaxHeight, ~0,
			WA_IDCMP, IDCMP_NEWSIZE|IDCMP_MOUSEBUTTONS|IDCMP_MOUSEMOVE|IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|
								IDCMP_GADGETDOWN|IDCMP_IDCMPUPDATE|IDCMP_INTUITICKS,
			WA_AutoAdjust, TRUE,
			WA_Flags, WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_SIZEGADGET|
								WFLG_SIMPLE_REFRESH|WFLG_ACTIVATE|WFLG_NEWLOOKMENUS,
			WA_ScreenTitle, "Layout Manager © Jorrit Tyberghein", TAG_END);
		if (win)
		{
			rp = win->RPort;
			setbox (win->BorderLeft, win->BorderTop, win->Width-win->BorderLeft-win->BorderRight,
				win->Height-win->BorderTop-win->BorderBottom);
			SetAPen (rp, 1);
			resize ();
		}
	}
	clear ();
	// Shell only supports one child
	if (children) children->expose ();
}

void Shell::resize ()
{
	D db("Shell::resize", get_name ());
	if (children)
	{
		children->setbox (left (), top (), width (), height ());
		children->resize ();
	}
}

GeometryResult Shell::query_geometry (GeometryRequest& answer)
{
	D db("Shell::query_geometry", get_name ());
	answer = *this;
	if (children)
	{
		children->query_geometry (answer);
		answer.setwidth (answer.width ());
		answer.setheight (answer.height ());
		answer.settop (answer.top ());
		answer.setleft (answer.left ());
	}
	// else choose current size as prefered size
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}

GeometryResult Shell::geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer)
{
	D db("Shell::geometry_answer", get_name ());
	box newsize (request->left (), request->top (),
							 request->width (), request->height ());
	composite *p = get_parent ();
	if (p)
	{
		GeometryRequest my_request = newsize;
		GeometryRequest my_answer;
		switch (p->geometry_manager (this, &my_request, &my_answer))
		{
			case GeometryNo:
				return GeometryNo;
			case GeometryYes:
				if (*this == newsize) return GeometryYes;
				setbox (newsize);
				return GeometryYes;
			case GeometryAlmost:
				setbox (my_answer);
				answer->setbox (request->left (), request->top (),
							 request->width (), request->height ());
				return GeometryAlmost;
		}
	}
	else
	{
		if (*this == newsize) return GeometryYes;
		setbox (newsize);
		return GeometryYes;
	}

	return GeometryAlmost;
}

void Shell::change_managed ()
{
	D db("Shell::change_managed", get_name ());
}

void Shell::RegisterEvent (primitive* obj)
{
	D db("Shell::RegisterEvent", get_name (), obj->get_name ());
	if (FindEvent (obj)) return;
	Event* ev = new Event;
	ev->obj = obj;
	ev->next = events;
	ev->prev = NULL;
	if (events) events->prev = ev;
	events = ev;
}


Shell::Event* Shell::FindEvent (primitive* obj)
{
	D db("Shell::FindEvent", get_name (), obj->get_name ());
	for (Event* ev = events ; ev ; ev = ev->next)
		if (ev->obj == obj) return ev;
	return NULL;
}


void Shell::UnregisterEvent (primitive* obj)
{
	D db("Shell::UnregisterEvent", get_name (), obj->get_name ());
	Event* ev = FindEvent (obj);
	if (ev)
	{
		if (ev->prev) ev->prev->next = ev->next;
		else events = ev->next;
		if (ev->next) ev->next->prev = ev->prev;
	}
}

int Shell::DispatchEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	D db("Shell::DispatchEvent", get_name (), (int)clas, (int)code, (int)qual);
	for (Event* ev = events ; ev ; ev = ev->next)
		if (ev->obj->HandleEvent (clas, code, qual, iaddr)) return 1;
	return 0;
}
