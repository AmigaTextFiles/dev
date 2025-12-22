//===============================================//
// Layout manager classes                        //
// Textfield																		 //
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

#ifndef LAYOUT_TEXTFIELD_H
#include "layout_textfield.h"
#endif

#ifndef LAYOUT_SHELL_H
#include "layout_shell.h"
#endif

//-----------------------------------------------------------------//
// TEXTFIELD                                                       //
//-----------------------------------------------------------------//

textfield::textfield (Shell* shell, char *name, composite *parent) : gadget (shell, name, parent)
{
	D db("textfield::textfield", name);
	NormalImage = (struct Image*)NewObject ((struct IClass*)NULL, (unsigned char*)FRAMEICLASS,
		IA_FrameType, FRAME_RIDGE,
		IA_Recessed, FALSE,
		IA_Left, -3,
		IA_Top, -2,
		IA_Width, width (),
		IA_Height, height (),
		TAG_DONE);
	g = (struct Gadget*)NewObject ((struct IClass*)NULL, (unsigned char*)STRGCLASS,
		GA_Left, left () + 3,
		GA_Top, top () + 2,
		GA_Width, width () - 6,
		GA_Height, height () - 4,
		GA_Image, NormalImage,
		GA_RelVerify, TRUE,
		STRINGA_MaxChars, 255,
		STRINGA_Buffer, buffer,
		TAG_DONE);
}

textfield::~textfield()
{
	D db("textfield::~textfield", get_name ());
	DisposeObject (NormalImage);
}

void textfield::resize ()
{
	D db("textfield::resize", get_name ());
//	SetGadgetAttrs (g, get_shell ()->get_win (), NULL,
//		GA_Left, left () + 3,
//		GA_Top, top () + 2,
//		GA_Width, width () - 6,
//		GA_Height, height () - 4,
//		TAG_DONE);
//	SetAttrs (NormalImage,
//		IA_Width, width (),
//		IA_Height, height (),
//		TAG_DONE);
	q.QuSetGadgetAttr (GA_Left, left ()+3);
	q.QuSetGadgetAttr (GA_Top, top ()+2);
	q.QuSetGadgetAttr (GA_Width, width ()-6);
	q.QuSetGadgetAttr (GA_Height, height ()-4);
	q.QuSetImageAttr (NormalImage, IA_Width, width ());
	q.QuSetImageAttr (NormalImage, IA_Height, height ());
}


ResourceType textfield::GetResourceType (YtResource r)
{
	D db("textfield::GetResourceType", get_name ());
	switch (r)
	{
		case YtNtfMaxChars: return ResourceInt;
		case YtNfont: return ResourceVoidPtr;
	}
	return gadget::GetResourceType (r);
}

void textfield::SetResource (YtResource r, ResourceVal& v)
{
	D db("textfield::SetResource", get_name ());
	switch (r)
	{
		case YtNtfMaxChars: q.QuSetGadgetAttr (STRINGA_MaxChars, v.i); break;
		case YtNfont: q.QuSetGadgetAttr (STRINGA_Font, (int)v.p); break;	// @@@ Bad cast!
//		case YtNtfMaxChars: SetGadgetAttrs (g, get_shell ()->get_win (), NULL, STRINGA_MaxChars, v.i, TAG_DONE); break;
//		case YtNfont: SetGadgetAttrs (g, get_shell ()->get_win (), NULL, STRINGA_Font, v.p, TAG_DONE); break;
		default:
			gadget::SetResource (r, v);
			return;
	}
}

int textfield::HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	D db("textfield::HandleEvent", get_name (), (int)clas, (int)code, (int)qual);
	YtTextfieldCBdata data;
	if (g == (struct Gadget*)iaddr)
	{
		if (clas == IDCMP_GADGETUP)
		{
			if (activateCB)
			{
				//GetAttr (STRINGA_Buffer, (APTR)g, (unsigned long*)&data.buffer);
				data.buffer = buffer;
				activateCB (this, (void*)&data, activateCBuser);
			}
		}
	}
	return 0;
}

boolean textfield::YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user)
{
	D db("textfield::YtAddCallback", get_name (), (int)cbt);
	switch (cbt)
	{
		case YtNactivateCallback: activateCB = cbf; activateCBuser = user; break;
		default: gadget::YtAddCallback (cbt, cbf, user);
	}
}
