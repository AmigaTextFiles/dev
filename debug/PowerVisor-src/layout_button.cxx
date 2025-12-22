//===============================================//
// Layout manager classes                        //
// Button   																		 //
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

#ifndef LAYOUT_BUTTON_H
#include "layout_button.h"
#endif

//-----------------------------------------------------------------//
// BUTTON                                                          //
//-----------------------------------------------------------------//

button::button (Shell* shell, char *name, composite *parent) : gadget (shell, name, parent)
{
	D db("button::button", name);
	NormalImage = (struct Image*)NewObject ((struct IClass*)NULL, (unsigned char*)FRAMEICLASS,
		IA_FrameType, FRAME_BUTTON,
		IA_Recessed, FALSE,
		IA_Width, width (),
		IA_Height, height (),
		TAG_DONE);
	SelectImage = (struct Image*)NewObject ((struct IClass*)NULL, (unsigned char*)FRAMEICLASS,
		IA_FrameType, FRAME_BUTTON,
		IA_Recessed, TRUE,
		IA_Width, width (),
		IA_Height, height (),
		TAG_DONE);
	g = (struct Gadget*)NewObject ((struct IClass*)NULL, (unsigned char*)BUTTONGCLASS,
		GA_Left, left (),
		GA_Top, top (),
		GA_Width, width (),
		GA_Height, height (),
		GA_Text, get_name (),
		GA_Image, NormalImage,
		GA_SelectRender, SelectImage,
		GA_RelVerify, TRUE,
		TAG_DONE);
	activateCB = NULL;
}

button::~button()
{
	D db("button::~button", get_name ());
	DisposeObject (NormalImage);
	DisposeObject (SelectImage);
}

void button::resize ()
{
	D db("button::resize", get_name ());
	gadget::resize ();
	q.QuSetImageAttr (NormalImage, IA_Width, width ());
	q.QuSetImageAttr (NormalImage, IA_Height, height ());
	q.QuSetImageAttr (SelectImage, IA_Width, width ());
	q.QuSetImageAttr (SelectImage, IA_Height, height ());
//	SetAttrs (NormalImage,
//		IA_Width, width (),
//		IA_Height, height (),
//		TAG_DONE);
//	SetAttrs (SelectImage,
//		IA_Width, width (),
//		IA_Height, height (),
//		TAG_DONE);
}

int button::HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr)
{
	D db("button::HandleEvent", get_name ());
	if (g == (struct Gadget*)iaddr)
	{
		if (clas == IDCMP_GADGETUP && activateCB)
		{
			activateCB (this, NULL, activateCBuser);
		}
	}
	return 0;
}


void button::ClearQueue ()
{
	D db("button::ClearQueue", get_name ());
}


boolean button::YtAddCallback (YtCallback cbt, YtCallbackFun cbf, void* user)
{
	D db("button::YtAddCallback", get_name (), (int)cbt);
	switch (cbt)
	{
		case YtNactivateCallback: activateCB = cbf; activateCBuser = user; break;
		default: gadget::YtAddCallback (cbt, cbf, user);
	}
}
