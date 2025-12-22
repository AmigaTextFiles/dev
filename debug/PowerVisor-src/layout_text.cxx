//===============================================//
// Layout manager classes                        //
// Text manager                                  //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include <exec/types.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <graphics/gfx.h>
#include <graphics/gfxmacros.h>

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

#ifndef LAYOUT_COMPOSITE_H
#include "layout_composite.h"
#endif

#ifndef LAYOUT_TEXT_H
#include "layout_text.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

//-----------------------------------------------------------------//
// BYTELINE                                                        //
//-----------------------------------------------------------------//

ByteLine& ByteLine::operator= (char* s)
{
	D db("ByteLine::operator=", s);
	if (line) delete line;
	len = (StringPos)strlen (s);
	line = new char[len+1];
	strcpy (line, s);
	return *this;
}

char& ByteLine::operator[] (StringPos p)
{
	D db("ByteLine::operator[]", line, p);
	if (p >= len || !line)
	{
		char* newline = new char[p+2];		// One char for null termination, one char because p points BEFORE the end
		if (line)
		{
			strcpy (newline, line);
			delete line;
		}
		else newline[0] = 0;
		line = newline;
		for (StringPos i = len ; i <= p ; i++) line[i] = ' ';
		line[p+1] = 0;
		len = p+1;												// We need one char more
	}
	return line[p];
}

void ByteLine::Put (StringPos p, char* s, StringPos l)
{
	D db("ByteLine::Put", line, s, l);
	if (l == 0) return;
	char* e = &((*this)[p+l-1]);	// Use our own defined [] operator to make the needed space
	strncpy (line+p, s, l);
//	if (p+l > len)
//	{
//		*(e+1) = 0;									// NULL terminate if needed
//		len = p+l;
//	}
}

//-----------------------------------------------------------------//
// LINES                                                           //
//-----------------------------------------------------------------//

Lines::Lines ()
{
	D db("Lines::Lines");
	lines = NULL;
	nrlines = 0;
	TopRow = BottomRow = CurrentRow = 0;
	CurrentCol = 0;
	MaxCol = 80;
}

void Lines::SetNrLines (int nr)
{
	D db("Lines::SetNrLines", nr);
	if (lines) delete [] lines;
	lines = new ByteLine[nr];
	nrlines = nr;
}

ByteLine& Lines::operator[] (int p)
{
	D db("Lines::operator[]", p);
	return lines[(p+TopRow) % nrlines];
}

void Lines::NewLine ()
{
	D db("Lines::NewLine", CurrentRow);
	if (CurrentRow == BottomRow)
	{
		BottomRow = (BottomRow+1) % nrlines;
		lines[BottomRow].Clear ();
		if (BottomRow == TopRow) TopRow = (TopRow+1) % nrlines;
	}
	CurrentRow = (CurrentRow+1) % nrlines;
	CurrentCol = 0;
}

void Lines::Print (char* s)
{
	D db("Lines::Print", s, CurrentRow);
// At this moment, Print ignores the maximum number of columns
	char* t;
	StringPos len;
	do
	{
		t = strchr (s, '\n');
		if (!t) t = strchr (s, 0);
		len = (StringPos)(t-s);
		lines[CurrentRow].Put (CurrentCol, s, len);
		CurrentCol += len;
		if (*t == '\n') NewLine ();
		s = t+1;
	}
	while (*t);
}


//-----------------------------------------------------------------//
// TEXTAREA                                                        //
//-----------------------------------------------------------------//

TextArea::TextArea (Shell* shell, char *name, composite *parent) : primitive (shell, name, parent)
{
	D db("TextArea::TextArea", name);
	FirstCol = FirstRow = 0;
	VisibleCols = VisibleRows = 0;
	CharWidth = CharHeight = 8;
	Baseline = 0;
}

void TextArea::expose ()
{
	D db("TextArea::expose", get_name ());
	get_shell ()->clear_box (*this);
	struct RastPort* rp = get_shell ()->get_rp ();
	SetABPenDrMd (rp, 1, 0, JAM2);
	for (int y = 0 ; y < VisibleRows ; y++)
	{
		ByteLine& l = lines[FirstRow+y];
		D db("TextArea:: expose one line:", l.Get ((StringPos)FirstCol), l.Length ((StringPos)FirstCol), y);
		Move (rp, left (), top () + y * CharHeight + Baseline);
		Text (rp, l.Get ((StringPos)FirstCol), min (l.Length ((StringPos)FirstCol), VisibleCols));
	}
}

void TextArea::resize ()
{
	D db("TextArea::resize", get_name ());
	struct TextFont* tf = get_shell ()->get_rp ()->Font;
	CharWidth = tf->tf_XSize;
	CharHeight = tf->tf_YSize;
	Baseline = tf->tf_Baseline;
	VisibleCols = width () / CharWidth;
	VisibleRows = height () / CharHeight;
}

GeometryResult TextArea::query_geometry (GeometryRequest& answer)
{
	D db("TextArea::query_geometry", get_name ());
	answer = *this;
	answer.setwidth (20 * CharWidth);
	answer.setheight (lines.GetNrLines () * CharHeight);
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}

void TextArea::NewLine ()
{
	D db("TextArea::NewLine");
	lines.NewLine ();
//	expose ();
}

void TextArea::Print (char* s)
{
	D db("TextArea::Print", s);
	lines.Print (s);
//	expose ();
}

ResourceType TextArea::GetResourceType (YtResource r)
{
	D db("TextArea::GetResourceType", get_name ());
	switch (r)
	{
		case YtNmaxLines: return ResourceInt;
		case YtNfont: return ResourceVoidPtr;
	}
	return primitive::GetResourceType (r);
}

void TextArea::SetResource (YtResource r, ResourceVal& v)
{
	D db("TextArea::SetResource", get_name ());
	switch (r)
	{
		case YtNmaxLines: lines.SetNrLines (v.i); break;
		case YtNfont: break;
		default:
			primitive::SetResource (r, v);
			return;
	}
}

//-----------------------------------------------------------------//
// SCROLLTEXTAREA                                                  //
//-----------------------------------------------------------------//

ScrollTextArea::ScrollTextArea (Shell* shell, char *name, composite *parent)
		: form (shell, name, parent), ta (shell, "textarea", this), sbarV (shell, "sbarV", this),
			sbarH (shell, "sbarH", this)
{
	D db("ScrollTextArea::ScrollTextArea", name);
	add_link (&ta, DirectionTop, LinkAttachForm, NULL, 0);
	add_link (&ta, DirectionBottom, LinkAttachChild, &sbarH, 2);
	add_link (&ta, DirectionLeft, LinkAttachForm, NULL, 0);
	add_link (&ta, DirectionRight, LinkAttachChild, &sbarV, 2);

	add_link (&sbarV, DirectionTop, LinkAttachForm, NULL, 0);
	add_link (&sbarV, DirectionBottom, LinkAttachChild, &sbarH, 0);
	add_link (&sbarV, DirectionLeft, LinkAttachNone, NULL, 0);
	add_link (&sbarV, DirectionRight, LinkAttachForm, NULL, 0);

	add_link (&sbarH, DirectionTop, LinkAttachNone, NULL, 0);
	add_link (&sbarH, DirectionBottom, LinkAttachForm, NULL, 0);
	add_link (&sbarH, DirectionLeft, LinkAttachForm, NULL, 0);
	add_link (&sbarH, DirectionRight, LinkAttachChild, &sbarV, 0);

	shell->RegisterEvent (this);
	sbarV.YtAddCallback (YtNnewValueCallback, &ScrollTextArea::newValueCB, (void*)0);
	sbarV.YtAddCallback (YtNslidingCallback, &ScrollTextArea::slidingCB, (void*)0);
	sbarH.YtAddCallback (YtNnewValueCallback, &ScrollTextArea::newValueCB, (void*)1);
	sbarH.YtAddCallback (YtNslidingCallback, &ScrollTextArea::slidingCB, (void*)1);
	AdjustProps ();
}

ScrollTextArea::~ScrollTextArea ()
{
	D db("ScrollTextArea::~ScrollTextArea", get_name ());
	get_shell ()->UnregisterEvent (this);
}


void ScrollTextArea::AdjustProps ()
{
	D db("ScrollTextArea::AdjustProps", get_name ());
	sbarV.YtSetValues (YtNpropTotal, ta.GetLines (), YtNpropTop, ta.GetFirstRow (),
		YtNpropVisible, ta.GetVisibleRows (), YtNend);
	sbarH.YtSetValues (YtNpropOrientation, FREEHORIZ, YtNpropTotal, 80,
		YtNpropTop, ta.GetFirstCol (), YtNpropVisible, ta.GetVisibleCols (), YtNend);
}

void ScrollTextArea::NewLine ()
{
	D db("ScrollTextArea::NewLine");
	ta.NewLine ();
	AdjustProps ();
}

void ScrollTextArea::Print (char* s)
{
	D db("ScrollTextArea::Print", s);
	ta.Print (s);
	AdjustProps ();
}

void ScrollTextArea::resize ()
{
	D db("ScrollTextArea::resize", get_name ());
	form::resize ();
	AdjustProps ();
}

int ScrollTextArea::HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	D db("ScrollTextArea::HandleEvent", get_name ());
	return 0;
}

int ScrollTextArea::newValueCB (primitive* obj, void* data, void* user)
{
	D db("ScrollTextArea::newValueCB", obj->get_name ());
	slidingCB (obj, data, user);
}

int ScrollTextArea::slidingCB (primitive* obj, void* data, void* user)
{
	D db("ScrollTextArea::slidingCB", obj->get_name ());
	int horiz = (int)user;
	ScrollTextArea* sta = (ScrollTextArea*)(obj->get_parent ());
	YtScrollbarCBdata* cbd = (YtScrollbarCBdata*)data;

	int newcol, newrow;

	if (horiz) { newcol = cbd->pos; newrow =  sta->ta.GetFirstRow (); }
	else { newcol = sta->ta.GetFirstCol (); newrow = cbd->pos; }

	if (newcol != sta->ta.GetFirstCol () || newrow != sta->ta.GetFirstRow ())
	{
		sta->ta.Scroll (newcol, newrow);
		sta->ta.expose ();
	}
}
