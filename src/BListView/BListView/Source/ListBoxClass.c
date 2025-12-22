/*
**	ListBoxClass.c
**
**	Copyright (C) 1997 Bernardo Innocenti
**
**	Use 4 chars wide TABs to read this file
**
**	GadTools-like `boopsi' ListView group class
*/

#define USE_BUILTIN_MATH
#define INTUI_V36_NAMES_ONLY
#define __USE_SYSBASE
#define  CLIB_ALIB_PROTOS_H		/* Avoid dupe defs of boopsi funcs */

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>

#include <proto/intuition.h>
#include <proto/utility.h>

#ifdef __STORM__
	#pragma header
#endif

#include "CompilerSpecific.h"
#include "Debug.h"
#include "BoopsiStubs.h"

#define LV_GADTOOLS_STUFF
#include "ListViewClass.h"
#include "ListBoxClass.h"



extern Class *ListViewClass;



struct LBData
{
	/* Group children */
	Object *ListView;
	Object *HSlider;
	Object *VSlider;
	Object *UpButton;
	Object *DownButton;
	Object *LefyButton;
	Object *RightButton;
};



/* Local function prototypes */
static void		LB_GMLayout	(Class *cl, struct Gadget *g, struct gpLayout *msg);
static ULONG	LB_OMSet	(Class *cl, struct Gadget *g, struct opUpdate *msg);
static ULONG	LB_OMGet	(Class *cl, struct Gadget *g, struct opGet *msg);
static ULONG	LB_OMNew	(Class *cl, struct Gadget *g, struct opSet *msg);



static ULONG HOOKCALL LBDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, Msg msg))
{
	ASSERT_VALIDNO0(cl)
	ASSERT_VALIDNO0(g)
	ASSERT_VALIDNO0(msg)

	switch (msg->MethodID)
	{
		case GM_LAYOUT:
			/* This method is only supported on V39 and above */
			LB_GMLayout (cl, g, (struct gpLayout *)msg);
			return TRUE;

		case OM_SET:
		case OM_UPDATE:
			return LB_OMSet (cl, g, (struct opUpdate *)msg);

		case OM_GET:
			return LB_OMGet (cl, g, (struct opGet *)msg);

		case OM_NEW:
			return LB_OMNew (cl, g, (struct opSet *)msg);

		default:
			/* Unsupported method: let our superclass's
			 * dispatcher take a look at it. This includes
			 * all gadget methods sent by Intuition:
			 * GM_RENDER, GM_HANDLEINPUT, GM_GOACTIVE,
			 * GM_GOINACTIVE. These methods are
			 * automatically forwarded to our child
			 * gadgets by the groupgclass.
			 */
			return DoSuperMethodA (cl, (Object *)g, msg);
	}
}



static void LB_GMLayout (Class *cl, struct Gadget *g, struct gpLayout *msg)
{
	struct LBData	*lb = (struct LBData *) INST_DATA (cl, (Object *)g);

	DB (kprintf ("ListBoxClass: GM_LAYOUT\n");)
	ASSERT_VALIDNO0(lb)

	/* Forward this method to our listview */
	DoMethodA (lb->ListView, (Msg)msg);
}



static ULONG LB_OMSet (Class *cl, struct Gadget *g, struct opUpdate *msg)
{
	struct LBData	*lb = (struct LBData *) INST_DATA (cl, (Object *)g);

	DB (kprintf ("ListBoxClass: OM_SET\n");)
	ASSERT_VALIDNO0(lb)

	/* Forward this method to our listview */
	return DoMethodA (lb->ListView, (Msg)msg);
}



static ULONG LB_OMGet (Class *cl, struct Gadget *g, struct opGet *msg)
{
	struct LBData	*lb = (struct LBData *) INST_DATA (cl, (Object *)g);

	DB (kprintf ("ListBoxClass: OM_GET\n");)
	ASSERT_VALIDNO0(lb)

	/* Forward this method to our listview */
	return DoMethodA (lb->ListView, (Msg)msg);
}



static ULONG LB_OMNew (Class *cl, struct Gadget *g, struct opSet *msg)
{
	struct LBData	*lb;
//	struct TagItem	*tag;

	DB (kprintf ("ListBoxClass: OM_NEW\n");)

	if (g = (struct Gadget *)DoSuperMethodA (cl, (Object *)g, (Msg)msg))
	{
		lb = (struct LBData *) INST_DATA (cl, (Object *)g);
		ASSERT_VALIDNO0(lb)

		/* Clear the object instance */
		memset (lb, 0, sizeof (struct LBData));

		/* Create the ListView and pass all creation time attributes to it.
		 * Note that any GA_#? attributes are also passed to the listview,
		 * so it will have our same size.
		 */
		if (lb->ListView = NewObjectA (ListViewClass, NULL, msg->ops_AttrList))
		{
			/* From now on, the groupgclass will dispose this object for us */
			DoMethod ((Object *)g, OM_ADDMEMBER, lb->ListView);

			if (lb->VSlider = NewObject (NULL, PROPGCLASS,
				GA_Left,		100,
				GA_Top,			0,
				GA_Width,		20,
				GA_Height,		200,
//				GA_DrawInfo,	dri,
				PGA_Freedom,	FREEVERT,
				PGA_NewLook,	TRUE,
//				ICA_TARGET,		lvhandle->Model,
//				ICA_MAP,		MapVSliderToLV,
				TAG_DONE))
			{
				/* From now on, the groupgclass will dispose this object for us */
				DoMethod ((Object *)g, OM_ADDMEMBER, lb->VSlider);
			}

			/* TODO: Handle creation-time attributes */
		}

		/* Dispose object without disturbing our subclasses */
		CoerceMethod (cl, (Object *)g, OM_DISPOSE);
	}

	return (ULONG)g;
}



Class *MakeListBoxClass (void)
{
	Class *LBClass;

	if (LBClass = MakeClass (NULL, GROUPGCLASS, NULL, sizeof (struct LBData), 0))
		LBClass->cl_Dispatcher.h_Entry = (ULONG (*)()) LBDispatcher;

	return LBClass;
}



void FreeListBoxClass (Class *LBClass)
{
	ASSERT_VALID(LBClass)
	FreeClass (LBClass);
}
