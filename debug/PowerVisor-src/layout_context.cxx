//===============================================//
// Layout manager classes                        //
// Context																			 //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include <exec/types.h>
#include <proto/exec.h>
#include <proto/intuition.h>

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

#ifndef LAYOUT_CONTEXT_H
#include "layout_context.h"
#endif

//-----------------------------------------------------------------//
// SCREENCTXT                                                      //
//-----------------------------------------------------------------//

screenctxt::screenctxt (char* name) : composite (NULL, name, NULL)
{
	D db("screenctxt::screenctxt", name);
}

screenctxt::~screenctxt ()
{
	D db("screenctxt::~screenctxt", get_name ());
}

void screenctxt::expose ()
{
	D db("screenctxt::expose", get_name ());
	primitive* child = children;
	while (child)
	{
		child->expose ();
		child = child->get_next ();
	}
}

void screenctxt::resize ()
{
	D db("screenctxt::resize", get_name ());
}

GeometryResult screenctxt::query_geometry (GeometryRequest& answer)
{
	D db("screenctxt::query_geometry", get_name ());
	answer = *this;
	return GeometryNoChange;
}

GeometryResult screenctxt::geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer)
{
	D db("screenctxt::geometry_answer", get_name ());
	*answer = *request;
	return GeometryYes;
}

void screenctxt::change_managed ()
{
	D db("screenctxt::change_managed", get_name ());
}


void screenctxt::Wait ()
{
	D db("screenctxt::Wait", get_name ());
	IntuiMessage *imsg;
	ULONG mask;
	ULONG cl;
	UWORD code;
	UWORD qual;
	APTR iaddr;

	mask = 0L;
	primitive* child = children;
	while (child)
	{
		mask |= 1L << ((Shell*)child)->get_win ()->UserPort->mp_SigBit;
		child = child->get_next ();
	}

	for (;;)
	{
		child = children;
		while (child)
		{
			while (imsg = (IntuiMessage*)GetMsg (((Shell*)child)->get_win ()->UserPort))
			{
				cl = imsg->Class;
				code = imsg->Code;
				qual = imsg->Qualifier;
				iaddr = imsg->IAddress;
				ReplyMsg ((Message*)imsg);
				if (((Shell*)child)->DispatchEvent (cl, code, qual, iaddr)) return;
			}
			child = child->get_next ();
		}
		::Wait (mask);
	}
}
