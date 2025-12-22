//===============================================//
// Layout manager classes                        //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

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

#ifndef LAYOUT_PUSHBUTTON_H
#include "layout_pushbutton.h"
#endif

#ifndef LAYOUT_LEFTRIGHT_H
#include "layout_leftright.h"
#endif

#ifndef LAYOUT_TEXT_H
#include "layout_text.h"
#endif

#ifndef LAYOUT_FORM_H
#include "layout_form.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

#ifndef LAYOUT_SCROLLBAR_H
#include "layout_scrollbar.h"
#endif

#ifndef LAYOUT_TEXTFIELD_H
#include "layout_textfield.h"
#endif

#ifndef LAYOUT_BUTTON_H
#include "layout_button.h"
#endif

#ifndef LAYOUT_FRAME_H
#include "layout_frame.h"
#endif

#ifndef LAYOUT_CONTEXT_H
#include "layout_context.h"
#endif

int D::debug = FALSE;
int D::ind = 0;
char D::prefix[255];
int D::prefix_len = 0;

void D::show ()
{
	if (prefix[0]) if (strncmp (buf+7, prefix, prefix_len)) return;
	char spaces[255];
	spaces[0] = ' ';
	strncpy (spaces+1, spaces, 250);
	spaces[ind*2 < 250 ? ind*2 : 250] = 0;
	printf ("%s%s\n", spaces, buf);
}

void D::set_debug (char* p)
{
	set_debug (TRUE);
	if (strcmp (p, "all"))
	{
		strcpy (prefix, p);
		prefix_len = (int)strlen (prefix);
	}
}


D::D () { if (debug) { sprintf (buf, "Entry"); ++ind; show (); } }
D::D (char *a) { if (debug) { sprintf (buf, "Entry: %s", a); ++ind; show (); } }
D::D (char *a, char *b) { if (debug) { sprintf (buf, "Entry: %s \"%s\"", a, b); ++ind; show (); } }
D::D (char *a, char *b, char *c) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %s", a, b, c); ++ind; show (); } }
D::D (char *a, char *b, char *c, char *d) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %s %s", a, b, c, d); ++ind; show (); } }
D::D (char *a, int b) { if (debug) { sprintf (buf, "Entry: %s %d", a, b); ++ind; show (); } }
D::D (char *a, int b, int c) { if (debug) { sprintf (buf, "Entry: %s %d %d", a, b, c); ++ind; show (); } }
D::D (char *a, int b, int c, int d) { if (debug) { sprintf (buf, "Entry: %s %d %d %d", a, b, c, d); ++ind; show (); } }
D::D (char *a, int b, char *c) { if (debug) { sprintf (buf, "Entry: %s %d %s", a, b, c); ++ind; show (); } }
D::D (char *a, int b, char *c, int d) { if (debug) { sprintf (buf, "Entry: %s %d %s %d", a, b, c, d); ++ind; show (); } }
D::D (char *a, char *b, char *c, int d) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %s %d", a, b, c, d); ++ind; show (); } }
D::D (char *a, char *b, int c) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %d", a, b, c); ++ind; show (); } }
D::D (char *a, char *b, int c, int d) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %d %d", a, b, c, d); ++ind; show (); } }
D::D (char *a, char *b, int c, int d, int e) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %d %d %d", a, b, c, d, e); ++ind; show (); } }
D::D (char *a, char *b, int c, int d, int e, int f) { if (debug) { sprintf (buf, "Entry: %s \"%s\" %d %d %d %d", a, b, c, d, e, f); ++ind; show (); } }
D::~D () { if (debug) { strncpy (buf, "Exit ", 5); show (); --ind; } }


//-----------------------------------------------------------------//
// BOX                                                             //
//-----------------------------------------------------------------//

int box::counter = 0;

box& box::show (Shell* shell)
{
	DB(("box::show"));
	shell->draw_box (x, y, w, h); return *this;
}

box& box::show ()
{
	DB(("box::show"));
	printf ("x:%d, y:%d, w:%d, h:%d\n", x, y, w, h);
	return *this;
}

boolean box::operator< (box &b)
{
	return left () > b.left () && right () < b.right ()
			&& top () > b.top () && bottom () < b.bottom ();
}

boolean box::operator== (box& b)
{
	return left () == b.left () && top () == b.top ()
				&& width () == b.width () && height () == b.height ();
}

box box::operator+ (box& b)
{
	return box (min (left (), b.left ()), min (top (), b.top ()),
							max (right (), b.right ()), max (bottom (), b.bottom ()));
}


box& box::operator+= (box& b)
{
	setbox (min (left (), b.left ()), min (top (), b.top ()),
					max (right (), b.right ()), max (bottom (), b.bottom ()));
	return *this;
}


box box::operator- (box& b)
{
	if (right () < b.left () || bottom () < b.top ()) return box ();
	if (left () > b.right () || top () > b.bottom ()) return box ();
	return box (max (left (), b.left ()), max (top (), b.top ()),
							min (right (), b.right ()), min (bottom (), b.bottom ()));
}


box& box::operator-= (box& b)
{
	if (right () < b.left () || bottom () < b.top () ||
			left () > b.right () || top () > b.bottom ()) setbox (0, 0, 0, 0);
	else setbox (max (left (), b.left ()), max (top (), b.top ()),
							min (right (), b.right ()), min (bottom (), b.bottom ()));
	return *this;
}

void box::setpos (DirType dir, int p)
{
	switch (dir)
	{
		case DirectionLeft:		setleft (p); break;
		case DirectionTop:		settop (p); break;
		case DirectionRight:	setright (p); break;
		case DirectionBottom:	setbottom (p); break;
	}
}

void box::setspan (DirType dir, int p)
{
	switch (dir)
	{
		case DirectionLeft:
		case DirectionRight:	setwidth (p); break;
		case DirectionTop:
		case DirectionBottom:	setheight (p); break;
	}
}

int box::pos (DirType dir)
{
	switch (dir)
	{
		case DirectionLeft:		return left ();
		case DirectionTop:		return top ();
		case DirectionRight:	return right ();
		case DirectionBottom:	return bottom ();
	}
	return -1;
}

int box::span (DirType dir)
{
	switch (dir)
	{
		case DirectionLeft:
		case DirectionRight:	return width ();
		case DirectionTop:
		case DirectionBottom:	return height ();
	}
	return -1;
}

DirType opposite (DirType dir)
{
	switch (dir)
	{
		case DirectionLeft:		return DirectionRight;
		case DirectionTop:		return DirectionBottom;
		case DirectionRight:	return DirectionLeft;
		case DirectionBottom:	return DirectionTop;
	}
	return dir;
}


//-----------------------------------------------------------------//
// PRIMITIVE                                                       //
//-----------------------------------------------------------------//

primitive::primitive (Shell* shell, char *newname, composite *parent) : box ()
{
	DB(("primitive::primitive", newname, "Parent:", parent ? parent->get_name () : "NULL"));
	primitive::shell = shell;
	next = prev = NULL;
	name = new char[strlen (newname)+1];
	strcpy (name, newname);
	primitive::parent = NULL;
	next = prev = NULL;
	parent_me (parent);
}

primitive::~primitive ()
{
	DB(("primitive::~primitive", get_name ()));
	delete name;
}

void primitive::parent_me (composite *parent)
{
	DB(("primitive::parent_me", get_name (), "Parent:", parent ? parent->get_name () : "NULL"));
	// This method does NOT unlink the child from its previous parent if any
	primitive::parent = parent;
	if (parent)
	{
		next = parent->children;
		prev = NULL;
		parent->children = this;
		parent->numChildren++;
	}
	else
	{
		next = prev = NULL;
	}
}

ResourceType primitive::GetResourceType (YtResource r)
{
	DB(("primitive::GetResourceType", get_name ()));
	if (r == YtNbox) return ResourceBox;
	else return ResourceInt;
}

void primitive::SetResource (YtResource r, ResourceVal& v)
{
	DB(("primitive::SetResource", get_name ()));
	switch (r)
	{
		case YtNx:
			setleft (v.i);
			break;
		case YtNy:
			settop (v.i);
			break;
		case YtNwidth:
			setwidth (v.i);
			break;
		case YtNheight:
			setheight (v.i);
			break;
		case YtNbox:
			setbox (*v.b);
			break;
	}
}

void primitive::EndResources ()
{
	DB(("primitive::EndResources", get_name ()));
}


boolean primitive::YtSetValues (YtResource r ...)
{
	DB(("primitive::YtSetValues", get_name ()));
	ResourceVal val;
	box bak = *this;
	va_list ap;
	va_start (ap, r);
	while (r != YtNend)
	{
		switch (GetResourceType (r))
		{
			case ResourceUnknown: { setbox (bak); return FALSE; }
			case ResourceLong: val.l = va_arg (ap, long); break;
			case ResourceInt: val.i = va_arg (ap, int); break;
			case ResourceChar: val.c = va_arg (ap, char); break;
			case ResourceVoidPtr: val.p = va_arg (ap, void*); break;
			case ResourceBox: val.b = va_arg (ap, box*); break;
		}
		SetResource (r, val);
		r = va_arg (ap, YtResource);
	}
	va_end (ap);
	if (set_values (bak)) get_shell ()->resize ();
	EndResources ();
	return TRUE;
}

boolean primitive::set_values (box& old)
{
	DB(("primitive::set_values", get_name ()));
	composite *p = get_parent ();
	if (p)
	{
		GeometryRequest request = *this;
		GeometryRequest answer;
		switch (p->geometry_manager (this, &request, &answer))
		{
			case GeometryNo:
				setbox (old);
				return FALSE;
			case GeometryYes:
				if (*this == old) return FALSE;
				return TRUE;
			case GeometryAlmost:
				setbox (answer);
				return TRUE;
		}
	}
	else
	{
		if (*this == old) return FALSE;
		return TRUE;
	}
	return FALSE;
}

void primitive::ClearQueue ()
{
	DB(("primitive::ClearQueue", get_name ()));
}


void primitive::PlayQueue ()
{
	DB(("primitive::PlayQueue", get_name ()));
}


int primitive::HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	DB(("primitive::HandleEvent", get_name ()));
	return 0;
}

boolean primitive::YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user)
{
	DB(("primitive::YtAddCallback", get_name (), (int)cbt));
	printf ("WARNING! Callback type %d not supported for object \"%s\"!\n", (int)cbt,
		get_name ());
	return FALSE;
}

//-----------------------------------------------------------------//
// COMPOSITE                                                       //
//-----------------------------------------------------------------//

composite::composite (Shell* shell, char *name, composite *parent) : primitive (shell, name, parent)
{
	DB(("composite::composite", get_name (), "Parent:", get_parent () ? get_parent ()->get_name () : "NULL"));
	children = NULL;
	numChildren = 0;
}

composite::~composite ()
{
	DB(("composite::~composite", get_name ()));
}

void composite::insert_child (primitive *child)
{
	DB(("composite::insert_child", get_name (), "Child:", child->get_name ()));
	child->parent_me (this);
}

void composite::delete_child (primitive *child)
{
	DB(("composite::delete_child", get_name (), "Child:", child->get_name ()));
	child->parent_me (NULL);
}

void composite::ClearQueue ()
{
	DB(("composite::ClearQueue", get_name ()));
	primitive* child = children;
	while (child)
	{
		child->ClearQueue ();
		child = child->get_next ();
	}
}


void composite::PlayQueue ()
{
	DB(("composite::PlayQueue", get_name ()));
	primitive* child = children;
	while (child)
	{
		child->PlayQueue ();
		child = child->get_next ();
	}
}


// Four phases in geometry negotiation:
//
//	1. initial geometry negotiation:
//				- call change_managed of each composite starting with the lowest (post-order traversal)
//						- each change_managed determines an initial size for each child and moves/resizes the child
//						- when the top composite is reached (with no parent) it receives the size of its child unless
//							the user specified another size (see (*))
//						- change_managed may use query_geometry of each child or use the geometry box directly
//						- change_managed determines size of children and not of this composite
//			(*)- the top composite resizes it's child and calls resize for this child.
//						- the resize method consideres the layout for all children and calls resize for all children
//						- resize may also call query_geometry
//				- now all the realize methods can be called
//
//	2. user resizes top composite
//				- see step (*)
//
//	3. object requires a size change (mostly in the set_values method)
//				- child makes a geometry request
//				- calls the geometry_manager method of the parent
//						- the geometry_manager may use query_geometry for the children
//				- when the complete (recursive) process is finished, resize is called for all objects
//					that have been resized
//
//	4. application resizes an object
//				- see 3

//-----------------------------------------------------------------//
// PUSHBUTTON                                                      //
//-----------------------------------------------------------------//

pushbutton::pushbutton (Shell* shell, char *name, composite *parent) : primitive (shell, name, parent)
{
	DB(("pushbutton::pushbutton", name));
}

void pushbutton::expose ()
{
	DB(("pushbutton::expose", get_name ()));
	get_shell ()->clear_box (*this);
	show (get_shell ());
}

void pushbutton::resize ()
{
	DB(("pushbutton::resize", get_name ()));
}

GeometryResult pushbutton::query_geometry (GeometryRequest& answer)
{
	DB(("pushbutton::query_geometry", get_name ()));
	answer = *this;
	answer.setwidth (50);
	answer.setheight (20);
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}

//-----------------------------------------------------------------//
// LEFTRIGHT                                                       //
//-----------------------------------------------------------------//

leftright::leftright (Shell* shell, char *name, composite *parent) : composite (shell, name, parent)
{
	DB(("leftright::leftright", name));
}

void leftright::expose ()
{
	DB(("leftright::expose", get_name ()));
	get_shell ()->clear_box (*this);
	show (get_shell ());
	primitive *child = children;
	while (child)
	{
		child->expose ();
		child = child->get_next ();
	}
}

void leftright::resize ()
{
	DB(("leftright::resize", get_name ()));
	primitive *child = children;
	int l = left ();
	int childwidth = width () / numChildren;
	while (child)
	{
		child->setbox (l, top (), childwidth, height ());
		l += childwidth;
		child->resize ();
		child = child->get_next ();
	}
}

GeometryResult leftright::query_geometry (GeometryRequest& answer)
{
	DB(("leftright::query_geometry", get_name ()));
	answer = *this;
	answer.setwidth (200);
	answer.setheight (100);
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}

GeometryResult leftright::geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer)
{
	DB(("leftright::geometry_answer", get_name ()));
	int newwidth = numChildren * request->width ();
	int newheight = request->height ();
	box newsize (left (), top (), newwidth, newheight);
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
					my_answer.width () / numChildren, my_answer.height ());
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

void leftright::change_managed ()
{
	DB(("leftright::change_managed", get_name ()));
}

//-----------------------------------------------------------------//
// FORM                                                            //
//-----------------------------------------------------------------//

form::form (Shell* shell, char* name, composite* parent) : composite (shell, name, parent)
{
	DB(("form::form", name));
	FirstLink = NULL;
}

form::~form ()
{
	DB(("form::~form", get_name ()));
	while (FirstLink)
	{
		del_link (FirstLink);
	}
}

void form::add_link (primitive* child, DirType dir, FormLinkType link, primitive* linked_child, int distance)
{
	DB(("form::add_link", get_name (), "Child:", child->get_name ()));
	FormLink* l;
	if (!(l = find_link (FirstLink, child)))
	{
		l = new FormLink;
		l->child = child;
		for (int i = 0 ; i < 4 ; i++)
		{
			l->links[i].link = LinkAttachNone;
			l->links[i].linked_child = NULL;
			l->links[i].distance = 0;
		}
		l->next = FirstLink;
		l->prev = NULL;
		if (FirstLink) FirstLink->prev = l;
		FirstLink = l;
	}
	l->links[dir].link = link;
	l->links[dir].linked_child = linked_child;
	l->links[dir].distance = distance;
}

void form::del_link (FormLink* l)
{
	DB(("form::del_link", get_name ()));
	if (l->next) l->next->prev = l->prev;
	if (l->prev) l->prev->next = l->next;
	else FirstLink = l->next;
	delete l;
}

FormLink* form::find_link (FormLink* start, primitive* child)
{
	DB(("form:find_link", get_name (), "Child:", child->get_name ()));
	while (start)
	{
		if (start->child == child) break;
		start = start->next;
	}
	return start;
}

void form::expose ()
{
	DB(("form::expose", get_name ()));
	get_shell ()->clear_box (*this);
	show (get_shell ());
	primitive *child = children;
	while (child)
	{
		child->expose ();
		child = child->get_next ();
	}
}

void form::resize ()
{
	DB(("form::resize", get_name (), left (), top (), width (), height ()));
	int p, dist, d;
	FormLink* fl;
	int changes, counter;
	primitive* child, *lc;
	GeometryRequest answer;
	box newsize;
	int geometry_available;
	DirType i;

	// Now for each child, calculate the position using all links
	counter = 1000;
	do
	{
		changes = FALSE;
		child = children;
		while (child)
		{
			DB(("form:: examine child", get_name (), "Child:", child->get_name ()));
			// Find the link for this child
			fl = find_link (FirstLink, child);
			if (fl)
			{
				newsize = *child;
				geometry_available = FALSE;

				for (i = DirType (0) ; i < DirType (4) ; i = DirType (i+1))
				{
					DB(("form:: examine direction for child:", child->get_name (), "Dir:", (int)i));
					lc = fl->links[i].linked_child;
					dist = fl->links[i].distance;
					if (i == DirectionRight || i == DirectionBottom) d = -1;
					else d = 1;
					switch (fl->links[i].link)
					{
						case LinkAttachForm:	{p = pos (i) + d*dist; DB(("form:: link to form", p, d, dist)); break;}
						case LinkAttachChild:	{p = lc->pos (opposite (i)) + d*dist; DB(("form:: link to child:", lc->get_name (), p, d, dist)); break;}
						case LinkAttachProp:	{p = (d == 1 ? pos (i) : pos (opposite (i))) + span (i)*dist / 100; DB(("form:: link to prop", p, d, dist)); break;}
						case LinkAttachNone:	{
							if (!geometry_available) { child->query_geometry (answer); geometry_available = TRUE; }
							p = newsize.pos (opposite (i)) - d*answer.span (i) + d;
							DB(("form:: link to none", p, d));
							break;}
					}
					if ((d == 1 && p >= pos (i)) || (d == -1 && p <= pos (i))) newsize.setpos (i, p);
					else newsize.setpos (i, pos (i));
				}

				if (*child != newsize)
				{
					{ DB(("form:: old size for child:", child->get_name (), child->left (), child->top (),
						child->width (), child->height ())); }
					{ DB(("form:: new size for child:", child->get_name (), newsize.left (), newsize.top (),
						newsize.width (), newsize.height ())); }
					child->setbox (newsize);
					changes = TRUE;
				}
			}
			child = child->get_next ();
		}
	}
	while (changes && --counter > 0);
	if (changes) printf ("Warning! Bailed out!\n");

	// Really resize the children
	child = children;
	while (child)
	{
		child->resize ();
		child = child->get_next ();
	}
}

int form::scan_links (FormLink* link, DirType dir, int spanI)
{
	DB(("form::scan_links", get_name ()));
	int span, maxspan = 0;
	primitive* child = link->child;
	GeometryRequest child_req;
	child->query_geometry (child_req);

	// Check the child that is referenced by this child (if any)
	SimpleLink* sl = &link->links[opposite (dir)];
	if (sl->link == LinkAttachForm)
	{
		maxspan = spanI + sl->distance + child_req.span (dir);
	}
	else if (sl->link == LinkAttachProp)
	{
		maxspan = (spanI + child_req.span (dir))*100 / sl->distance;
	}
	else if (sl->link == LinkAttachNone)
	{
		// Check all children that have a link to this child
		FormLink* fl = FirstLink;
		while (fl)
		{
			if (fl->links[dir].link == LinkAttachChild && fl->links[dir].linked_child == child)
			{
				span = scan_links (fl, dir, spanI + fl->links[dir].distance + child_req.span (dir));
				if (span > maxspan) maxspan = span;
			}
			fl = fl->next;
		}
	}

	return maxspan;
}

GeometryResult form::query_geometry (GeometryRequest& answer)
{
	DB(("form::query_geometry", get_name ()));
	int diff, span, width, height, maxspan[4];
	FormLink* fl;
	for (DirType dir = DirType (0) ; dir < DirType (4) ; dir = DirType (dir+1))
	{
		maxspan[dir] = 0;
		fl = FirstLink;
		while (fl)
		{
			if (fl->links[dir].link == LinkAttachForm)
			{
				span = scan_links (fl, dir, fl->links[dir].distance);
			}
			else if (fl->links[dir].link == LinkAttachProp && fl->links[opposite (dir)].link == LinkAttachProp)
			{
				diff = abs (fl->links[dir].distance - fl->links[opposite (dir)].distance);
				if (diff)	// If two percentages are the same we do nothing
				{
					GeometryRequest child_req;
					fl->child->query_geometry (child_req);
					span = child_req.span (dir)*100 / diff;
				}
			}
			else span = 0;
			if (span > maxspan[dir]) maxspan[dir] = span;

			fl = fl->next;
		}
	}

	width = max (maxspan[DirectionLeft], maxspan[DirectionRight]);
	height = max (maxspan[DirectionTop], maxspan[DirectionBottom]);

	answer = *this;
	answer.setwidth (width);
	answer.setheight (height);
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}

GeometryResult form::geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer)
{
	DB(("form::geometry_manager", get_name ()));
	return GeometryYes;
}

void form::change_managed ()
{
	DB(("form::change_managed", get_name ()));
}

//-----------------------------------------------------------------//
// MAIN                                                            //
//-----------------------------------------------------------------//

int newValueCB (primitive* obj, void* data, void* user)
{
	DB(("GLOBAL::newValueCB", obj->get_name ()));
	printf ("New value for \"%s\" : %d\n", obj->get_name (), ((YtScrollbarCBdata*)data)->pos);
	return 0;
}

int slidingCB (primitive* obj, void* data, void* user)
{
	DB(("GLOBAL::slidingCB", obj->get_name ()));
	printf ("Sliding \"%s\" : %d\n", obj->get_name (), ((YtScrollbarCBdata*)data)->pos);
	return 0;
}

int activateCB (primitive* obj, void* data, void* user)
{
	DB(("GLOBAL::activateCB", obj->get_name ()));
	printf ("Activate \"%s\"\n", obj->get_name ());
	return 0;
}

int addToTextCB (primitive* obj, void* data, void* user)
{
	DB(("GLOBAL::addToTextCB", obj->get_name ()));
	TextArea* ta = (TextArea*)user;
	YtTextfieldCBdata* tfd = (YtTextfieldCBdata*)data;
	ta->Print (tfd->buffer);
	ta->NewLine ();
	ta->expose ();
	return 0;
}

int main (int argc, char *argv[])
{
	if (argc > 1) D::set_debug (argv[1]);

	screenctxt c ("The context");

	Shell theWindow ("Main shell", &c);
	form mainform (&theWindow, "Main form", &theWindow);

	form subform (&theWindow, "Sub form", &mainform);
	form subform2 (&theWindow, "Sub form2", &mainform);
	scrollbar sbar2 (&theWindow, "SBAR 2", &mainform);
	sbar2.YtAddCallback (YtNnewValueCallback, &newValueCB);
	sbar2.YtAddCallback (YtNslidingCallback, &slidingCB);

	leftright mymanager (&theWindow, "My Manager", &subform);
	TextArea textarea1 (&theWindow, "Text area 1", &subform);
	pushbutton button6 (&theWindow, "XXX button6", &subform);

	pushbutton button1 (&theWindow, "A button1", &mymanager);
	Frame frame2 (&theWindow, "Frame 2", &mymanager);
	leftright childmanager (&theWindow, "Child manager", &mymanager);

	button button2 (&theWindow, "BUTTON 2", &frame2);
	button2.YtAddCallback (YtNactivateCallback, &activateCB);

	button button3 (&theWindow, "XXX button3", &childmanager);
	button3.YtAddCallback (YtNactivateCallback, &activateCB);
	button3.YtSetValues (YtNgadgDisabled, TRUE, YtNend);
	scrollbar sbar1 (&theWindow, "SBAR 1", &childmanager);
	sbar1.YtAddCallback (YtNnewValueCallback, &newValueCB);
	sbar1.YtAddCallback (YtNslidingCallback, &slidingCB);

	button b1a (&theWindow, "b1a", &subform2);
	b1a.YtAddCallback (YtNactivateCallback, &activateCB);
	pushbutton b1b (&theWindow, "b1b", &subform2);
	ScrollTextArea b2a (&theWindow, "b2a", &subform2);
	TextArea& ta = b2a.GetTextArea ();
	textfield b2b (&theWindow, "b2b", &subform2);
	b2b.YtAddCallback (YtNactivateCallback, &addToTextCB, (void*)&ta);

	mainform.add_link (&subform, DirectionRight, LinkAttachForm, NULL, 10);
	mainform.add_link (&subform, DirectionTop, LinkAttachForm, NULL, 10);
	mainform.add_link (&sbar2, DirectionTop, LinkAttachForm, NULL, 5);
	mainform.add_link (&sbar2, DirectionLeft, LinkAttachForm, NULL, 5);
	mainform.add_link (&sbar2, DirectionBottom, LinkAttachForm, NULL, 5);
	mainform.add_link (&sbar2, DirectionRight, LinkAttachChild, &subform, 5);
	mainform.add_link (&subform2, DirectionLeft, LinkAttachChild, &sbar2, 10);
	mainform.add_link (&subform2, DirectionTop, LinkAttachChild, &subform, 10);
	mainform.add_link (&subform2, DirectionBottom, LinkAttachForm, NULL, 10);
	mainform.add_link (&subform2, DirectionRight, LinkAttachForm, NULL, 10);

	subform.add_link (&mymanager, DirectionLeft, LinkAttachForm, NULL, 10);
	subform.add_link (&mymanager, DirectionTop, LinkAttachForm, NULL, 10);
	subform.add_link (&mymanager, DirectionBottom, LinkAttachForm, NULL, 10);
	subform.add_link (&mymanager, DirectionRight, LinkAttachForm, NULL, 100);
	subform.add_link (&textarea1, DirectionLeft, LinkAttachChild, &mymanager, 10);
	subform.add_link (&textarea1, DirectionTop, LinkAttachForm, NULL, 10);
	subform.add_link (&textarea1, DirectionRight, LinkAttachForm, NULL, 10);
	subform.add_link (&textarea1, DirectionBottom, LinkAttachForm, NULL, 50);
	subform.add_link (&button6, DirectionLeft, LinkAttachChild, &mymanager, 10);
	subform.add_link (&button6, DirectionTop, LinkAttachChild, &textarea1, 10);
	subform.add_link (&button6, DirectionRight, LinkAttachForm, NULL, 10);
	subform.add_link (&button6, DirectionBottom, LinkAttachForm, NULL, 10);

	subform2.add_link (&b1a, DirectionTop, LinkAttachForm, NULL, 2);
	subform2.add_link (&b1a, DirectionLeft, LinkAttachForm, NULL, 5);
	subform2.add_link (&b1b, DirectionTop, LinkAttachForm, NULL, 2);
	subform2.add_link (&b1b, DirectionRight, LinkAttachForm, NULL, 5);
	subform2.add_link (&b2a, DirectionTop, LinkAttachChild, &b1a, 2);
	subform2.add_link (&b2a, DirectionLeft, LinkAttachForm, NULL, 5);
	subform2.add_link (&b2b, DirectionTop, LinkAttachChild, &b1b, 2);
	subform2.add_link (&b2b, DirectionRight, LinkAttachForm, NULL, 5);

	subform2.add_link (&b2a, DirectionBottom, LinkAttachForm, NULL, 2);
	subform2.add_link (&b2b, DirectionBottom, LinkAttachForm, NULL, 2);

	subform2.add_link (&b1a, DirectionRight, LinkAttachChild, &b1b, 5);
	subform2.add_link (&b1b, DirectionLeft, LinkAttachNone, NULL, 0);
	subform2.add_link (&b2a, DirectionRight, LinkAttachNone, NULL, 0);
	subform2.add_link (&b2b, DirectionLeft, LinkAttachChild, &b2a, 5);

	textarea1.YtSetValues (YtNmaxLines, 10, YtNend);
	textarea1.Print ("Dit is een test om te zien of dit allemaal wel goed werkt\n");
	textarea1.Print ("De tweede regel...");
	textarea1.Print ("Nog op de tweede regel");
	textarea1.NewLine ();
	textarea1.Print ("D\ne\n \nl\na\na\nt\ns\nt\ne\n \nregel");

	ta.YtSetValues (YtNmaxLines, 40, YtNend);
	ta.Print ("Dit zijn een test\nom te zien\nof dit allemaal\nwel goed werkt\n");
	ta.Print ("!De tweede regel....");
	ta.Print ("Nog op de tweede regel");
	ta.NewLine ();
	ta.Print ("d\ne\n \nl\na\na\nt\ns\nt\ne\n \nregels");
	ta.Print ("Regeltje 1\n");
	ta.Print ("Regeltje 2\n");
	ta.Print ("Regeltje 3\n");
	ta.Print ("Regeltje 4\n");
	ta.Print ("Regeltje 5\n");
	ta.Print ("Regeltje 6\n");
	ta.Print ("Regeltje 7\n");
	ta.Print ("Regeltje 8\n");
	ta.Print ("Regeltje 9\n");
	ta.Print ("Regeltje 10\n");

	c.expose ();

	c.Wait ();
	return 0;
}
