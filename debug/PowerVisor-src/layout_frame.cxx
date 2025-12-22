//===============================================//
// Layout manager classes                        //
// Frame																				 //
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

#ifndef LAYOUT_FRAME_H
#include "layout_frame.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

//-----------------------------------------------------------------//
// FRAME                                                           //
//-----------------------------------------------------------------//

Frame::Frame (Shell* shell, char *name, composite *parent) : composite (shell, name, parent)
{
	D db("Frame::Frame", name);
	image = (struct Image*)NewObject ((struct IClass*)NULL, (unsigned char*)FRAMEICLASS,
		IA_FrameType, FRAME_DEFAULT,
		IA_Recessed, FALSE,
		IA_Width, width (),
		IA_Height, height (),
		TAG_DONE);
}

Frame::~Frame ()
{
	D db("Frame::~Frame", get_name ());
	DisposeObject (image);
}

void Frame::expose ()
{
	D db("Frame::expose", get_name ());
	get_shell ()->clear_box (*this);
	DrawImage (get_shell ()->get_rp (), image, left (), top ());
	// Frame only supports one child
	if (children) children->expose ();
}

void Frame::resize ()
{
	D db("Frame::resize", get_name ());
	SetAttrs (image,
		IA_Width, width (),
		IA_Height, height (),
		TAG_DONE);

	if (children)
	{
		children->setbox (left ()+2, top ()+2, width ()-4, height ()-4);
		children->resize ();
	}
}

GeometryResult Frame::query_geometry (GeometryRequest& answer)
{
	D db("Frame::query_geometry", get_name ());
	answer = *this;
	if (children)
	{
		children->query_geometry (answer);
		answer.setwidth (answer.width ()+4);
		answer.setheight (answer.height ()+4);
		answer.settop (answer.top ()-2);
		answer.setleft (answer.left ()-2);
	}
	else
	{
		answer.setwidth (200);
		answer.setheight (100);
	}
	if (*this == answer) return GeometryNoChange;
	else return GeometryYes;
}

GeometryResult Frame::geometry_manager (primitive *child, GeometryRequest *request,
					GeometryRequest *answer)
{
	D db("Frame::geometry_answer", get_name ());
	box newsize (request->left ()-2, request->top ()-2,
							 request->width ()+4, request->height ()+4);
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
				answer->setbox (request->left ()+2, request->top ()+2,
							 request->width ()-4, request->height ()-4);
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

void Frame::change_managed ()
{
	D db("Frame::change_managed", get_name ());
}
