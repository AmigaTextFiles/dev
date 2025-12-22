/*
**	PIPClass.c
**
**	Copyright (C) 1996,97 Bernardo Innocenti
**
**	Picture In Picture gadget class
*/

#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>

#include "CompilerSpecific.h"
#include "Debug.h"
#include "BoopsiStubs.h"

#include "PIPClass.h"



/* PIP gadget private instance data */

struct PIPData
{
	struct Screen	*Scr;			/* Snoop this screen...				*/
	struct BitMap	*BitMap;		/* ...or this BitMap				*/
	WORD			Width,	Height;	/* Size of snooped object			*/
	WORD			OffX,	OffY;	/* Current XY offset of the view	*/
	WORD			StartX,	StartY;	/* Start coords for mouse dragging	*/
	WORD			Dragging;		/* TRUE if dragging with mouse		*/
	WORD			Dummy;			/* Keep data longword aligned		*/
	struct IBox		GBox;			/* Real gadget size					*/
};



/* Local function prototypes */

static void		PIP_GMRender		(Class *cl, struct Gadget *g, struct gpRender *msg);
static ULONG	PIP_GMHandleInput	(Class *cl, struct Gadget *g, struct gpInput *msg);
static void		PIP_GMGoInactive	(Class *cl, struct Gadget *g, struct gpGoInactive *msg);
static void		PIP_GMLayout		(Class *cl, struct Gadget *g, struct gpLayout *msg);
static ULONG	PIP_OMNew			(Class *cl, struct Gadget *g, struct opSet *msg);
static ULONG	PIP_OMSet			(Class *cl, struct Gadget *g, struct opUpdate *msg);
static ULONG	PIP_OMGet			(Class *cl, struct Gadget *g, struct opGet *msg);
static ULONG	PIP_PIPMRefresh		(Class *cl, struct Gadget *g, struct pippRefresh *msg);
static void		RestrictXY			(struct PIPData *pip);
static void		GetGadgetBox		(struct GadgetInfo *ginfo, struct Gadget *g, struct IBox *rect);



static ULONG HOOKCALL PIPDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, Msg msg))
{
	switch (msg->MethodID)
	{
		case GM_RENDER:
			PIP_GMRender (cl, g, (struct gpRender *)msg);
			return TRUE;

		case GM_GOACTIVE:
		case GM_HANDLEINPUT:
			return PIP_GMHandleInput (cl, g, (struct gpInput *)msg);

		case GM_GOINACTIVE:
			PIP_GMGoInactive (cl, g, (struct gpGoInactive *)msg);
			return TRUE;

		case GM_LAYOUT:
			/* This method is only supported on V39 and above */
			PIP_GMLayout (cl, g, (struct gpLayout *)msg);
			return TRUE;

		case OM_NEW:
			return PIP_OMNew (cl, g, (struct opSet *)msg);

		/* We don't need to override OM_DISPOSE */

		case OM_SET:
		case OM_UPDATE:
			return PIP_OMSet (cl, g, (struct opUpdate *)msg);

		case OM_GET:
			return PIP_OMGet (cl, g, (struct opGet *)msg);

		case PIPM_REFRESH:
			return PIP_PIPMRefresh (cl, g, (struct pippRefresh *)msg);

		default:
			/* Unsupported method: let our superclass's
			 * dispatcher take a look at it.
			 */
			return DoSuperMethodA (cl, (Object *)g, msg);
	}
}



static void PIP_GMRender (Class *cl, struct Gadget *g, struct gpRender *msg)
{
	struct PIPData	*pip = INST_DATA (cl, g);
	struct BitMap	*bitmap;


	if (pip->Scr)
		bitmap = pip->Scr->RastPort.BitMap;	/* Get screen bitmap */
	else if (pip->BitMap)
		bitmap = pip->BitMap;				/* Use provided bitmap */
	else
		bitmap = NULL;						/* Do nothing otherwise */


	switch (msg->gpr_Redraw)
	{
		case GREDRAW_REDRAW:

#ifndef OS30_ONLY
			/* Pre-V39 Intuition won't call our GM_LAYOUT method */
			if (IntuitionBase->LibNode.lib_Version < 39)
				PIP_GMLayout (cl, g, (struct gpLayout *)msg);
#endif /* !OS30_ONLY */

			if (!bitmap || (bitmap->Depth < msg->gpr_RPort->BitMap->Depth))
			{
				/* Clearing all our visible area is needed because
				 * BltBitMapRastPort() will not clear the bitplanes beyond
				 * the last bitplane in the source bitmap.
				 *
				 * NOTE: The pen number really needs to be 0, not BACKGROUNDPEN!
				 */
				SetAPen (msg->gpr_RPort, 0);
				RectFill (msg->gpr_RPort,
					pip->GBox.Left, pip->GBox.Top,
					pip->GBox.Left + pip->GBox.Width, pip->GBox.Top + pip->GBox.Height);
			}

			/* NOTE: I'm falling through here! */

		case GREDRAW_UPDATE:

			if (bitmap)
			{
				/* Scaling, remapping and other similar features could be added here */

				/* Update gadget display */
				BltBitMapRastPort (bitmap, pip->OffX, pip->OffY,
					msg->gpr_RPort, pip->GBox.Left, pip->GBox.Top,
					min (pip->GBox.Width, pip->Width), min (pip->GBox.Height, pip->Height),
					0x0C0);
			}
			/* NOTE: I'm falling through here! */

		default:
			break;
	}
}



static ULONG PIP_GMHandleInput (Class *cl, struct Gadget *g, struct gpInput *msg)
{
	struct PIPData		*pip = INST_DATA (cl, g);
	struct InputEvent	*ie = msg->gpi_IEvent;


	/* Handle GM_GOACTIVE */
	if (msg->MethodID == GM_GOACTIVE)
	{
		if (!pip->Scr && !pip->BitMap)
			return GMR_NOREUSE;

		g->Flags |= GFLG_SELECTED;

		/* Do not process InputEvent when the gadget has been
		 * activated by ActivateGadget().
		 */
		if (!ie)
			return GMR_MEACTIVE;

		/* Note: The input event that triggered the gadget
		 * activation (usually a mouse click) should be passed
		 * to the GM_HANDLEINPUT method, so we fall down to it.
		 */
	}

	/* Handle GM_HANDLEINPUT */
	switch (ie->ie_Class)
	{
		case IECLASS_RAWMOUSE:
		{
			switch (ie->ie_Code)
			{
				case MENUDOWN:
					/* Deactivate gadget on menu button press */
					return GMR_REUSE;

				case SELECTDOWN:

					/* Check click outside gadget box */

					if ((msg->gpi_Mouse.X < 0) ||
						(msg->gpi_Mouse.X >= pip->GBox.Width) ||
						(msg->gpi_Mouse.Y < 0) ||
						(msg->gpi_Mouse.Y >= pip->GBox.Height))
						return GMR_REUSE;

					/* Store current mouse coordinates for mouse dragging */
					pip->StartX = pip->OffX + msg->gpi_Mouse.X;
					pip->StartY = pip->OffY + msg->gpi_Mouse.Y;
					pip->Dragging = TRUE;

					break;

				case SELECTUP:

					/* Stop mouse dragging mode */
					pip->Dragging = FALSE;

					/* Send one final notification to our targets */
					UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
						PIPA_OffX,			pip->StartX - msg->gpi_Mouse.X,
						PIPA_OffY,			pip->StartY - msg->gpi_Mouse.Y,
						TAG_DONE);

					break;


				default: /* Mouse just moved */

					/* Call our OM_UPDATE method to change the object attributes.
					 * This will also send notification to targets and
					 * update the contents of the gadget.
					 */
					if (pip->Dragging)
						UpdateAttrs ((Object *)g, msg->gpi_GInfo, OPUF_INTERIM,
							PIPA_OffX,			pip->StartX - msg->gpi_Mouse.X,
							PIPA_OffY,			pip->StartY - msg->gpi_Mouse.Y,
							GA_ID,				g->GadgetID,
							TAG_DONE);
			}
			return GMR_MEACTIVE;
		}

		case IECLASS_RAWKEY:
		{
			LONG tags[3];
			WORD pos;

			switch (ie->ie_Code)
			{
				case CURSORUP:
					if (ie->ie_Qualifier & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
						pos = 0;
					else if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
						pos = pip->OffY - pip->GBox.Height + 1;
					else if (ie->ie_Qualifier & IEQUALIFIER_CONTROL)
						pos = pip->OffY - 8;
					else
						pos = pip->OffY - 1;


					tags[0] = PIPA_OffY;
					tags[1] = pos;
					tags[2] = TAG_DONE;
					break;

				case CURSORDOWN:
					if (ie->ie_Qualifier & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
						pos = pip->Height - pip->GBox.Height;
					else if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
						pos = pip->OffY + pip->GBox.Height - 1;
					else if (ie->ie_Qualifier & IEQUALIFIER_CONTROL)
						pos = pip->OffY + 8;
					else
						pos = pip->OffY + 1;

					tags[0] = PIPA_OffY;
					tags[1] = pos;
					tags[2] = TAG_DONE;
					break;

				case CURSORLEFT:
					if (ie->ie_Qualifier & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
						pos = 0;
					else if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
						pos = pip->OffX - pip->GBox.Width + 1;
					else if (ie->ie_Qualifier & IEQUALIFIER_CONTROL)
						pos = pip->OffX - 8;
					else
						pos = pip->OffX - 1;

					tags[0] = PIPA_OffX;
					tags[1] = pos;
					tags[2] = TAG_DONE;
					break;

				case CURSORRIGHT:
					if (ie->ie_Qualifier & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
						pos = pip->Width - pip->GBox.Width;
					else if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
						pos = pip->OffX + pip->GBox.Height - 1;
					else if (ie->ie_Qualifier & IEQUALIFIER_CONTROL)
						pos = pip->OffX + 8;
					else
						pos = pip->OffX + 1;

					tags[0] = PIPA_OffX;
					tags[1] = pos;
					tags[2] = TAG_DONE;
					break;

				default:
					tags[0] = TAG_DONE;
			}

			if (tags[0] != TAG_DONE)
				DoMethod ((Object *)g, OM_UPDATE, tags, msg->gpi_GInfo, OPUF_INTERIM);

			return GMR_MEACTIVE;
		}

		default:
			return GMR_MEACTIVE;
	}
}



static void PIP_GMGoInactive (Class *cl, struct Gadget *g, struct gpGoInactive *msg)
{
	struct PIPData *pip = INST_DATA (cl, g);

	pip->Dragging = FALSE;
	g->Flags &= ~GFLG_SELECTED;
}



static void PIP_GMLayout (Class *cl, struct Gadget *g, struct gpLayout *msg)
{
	struct PIPData *pip = INST_DATA (cl, g);

	GetGadgetBox (msg->gpl_GInfo, g, &pip->GBox);
	RestrictXY (pip);

	/* Notify our targets about it */
	NotifyAttrs ((Object *)g, msg->gpl_GInfo, 0,
		PIPA_OffX,			pip->OffX,
		PIPA_OffY,			pip->OffY,
		PIPA_Width,			pip->Width,
		PIPA_Height,		pip->Height,
		PIPA_DisplayWidth,	pip->GBox.Width,
		PIPA_DisplayHeight,	pip->GBox.Height,
		GA_ID,				g->GadgetID,
		TAG_DONE);
}



static ULONG PIP_OMNew (Class *cl, struct Gadget *g, struct opSet *msg)
{
	ULONG result;

	if (result = DoSuperMethodA (cl, (Object *)g, (Msg)msg))
	{
		struct PIPData *pip = (struct PIPData *) INST_DATA (cl, (Object *)result);

		/* Read creation time attributes */
		pip->Scr	= (struct Screen *) GetTagData (PIPA_Screen,	NULL,	msg->ops_AttrList);
		pip->BitMap	= (struct BitMap *) GetTagData (PIPA_BitMap,	NULL,	msg->ops_AttrList);
		pip->OffX	= (WORD)			GetTagData (PIPA_OffX,		0,		msg->ops_AttrList);
		pip->OffY	= (WORD)			GetTagData (PIPA_OffY,		0,		msg->ops_AttrList);
		pip->Dragging = FALSE;
	}
	return result;
}



static ULONG PIP_OMSet (Class *cl, struct Gadget *g, struct opUpdate *msg)
{
	struct PIPData	*pip = (struct PIPData *) INST_DATA (cl, g);
	struct TagItem	*ti,
					*tstate	= msg->opu_AttrList;
	ULONG	result = FALSE;
	BOOL	do_super_method	= FALSE,
			render			= FALSE,
			notify			= FALSE;

	while (ti = NextTagItem (&tstate))
		switch (ti->ti_Tag)
		{
			case PIPA_Screen:
				pip->BitMap	= NULL;

				if (pip->Scr = (struct Screen *)ti->ti_Data)
				{
					pip->Width	= pip->Scr->Width;
					pip->Height	= pip->Scr->Height;
				}
				else
					pip->Width = pip->Height = 0;

				RestrictXY (pip);

				break;

			case PIPA_BitMap:
				pip->Scr = NULL;
				if (pip->BitMap = (struct BitMap *)ti->ti_Data)
				{
					pip->Width	= pip->BitMap->BytesPerRow << 3;
					pip->Height	= pip->BitMap->Rows;
				}
				else
					pip->Width = pip->Height = 0;

				RestrictXY (pip);

				render		= TRUE;
				notify		= TRUE;

				break;

			case PIPA_OffX:
				if (pip->OffX != ti->ti_Data)
				{
					WORD newx = (WORD)ti->ti_Data;

					/* Restrict offset to valid limits */
					if (newx + pip->GBox.Width > pip->Width)
						newx = pip->Width - pip->GBox.Width;
					if (newx < 0)
						newx = 0;

					if (newx != pip->OffX)
					{
						pip->OffX	= newx;
						render		= TRUE;
						notify		= TRUE;
					}
				}
				break;

			case PIPA_OffY:
				if (pip->OffY != ti->ti_Data)
				{
					WORD newy = (WORD)ti->ti_Data;

					/* Restrict offset to valid limits */
					if (newy + pip->GBox.Height > pip->Height)
						newy = pip->Height - pip->GBox.Height;
					if (newy < 0)
						newy = 0;

					if (newy != pip->OffY)
					{
						pip->OffY	= newy;
						render		= TRUE;
						notify		= TRUE;
					}
				}
				break;

			case PIPA_MoveUp:
				if (pip->OffY)
				{
					if (pip->OffY > 8)
						pip->OffY -= 8;
					else
						pip->OffY = 0;

					render		= TRUE;
					notify		= TRUE;
				}
				break;

			case PIPA_MoveDown:
				if (pip->OffY < pip->Height - pip->GBox.Height)
				{
					if (pip->OffY + pip->GBox.Height < pip->Height - 8)
						pip->OffY += 8;
					else
						pip->OffY = pip->Height - pip->GBox.Height;

					render		= TRUE;
					notify		= TRUE;
				}
				break;

			case PIPA_MoveLeft:
				if (pip->OffX)
				{
					if (pip->OffX > 8)
						pip->OffX -= 8;
					else
						pip->OffX = 0;

					render		= TRUE;
					notify		= TRUE;
				}
				break;

			case PIPA_MoveRight:
				if (pip->OffX < pip->Width - pip->GBox.Width)
				{
					if (pip->OffX + pip->GBox.Width < pip->Width - 8)
						pip->OffX += 8;
					else
						pip->OffX = pip->Width - pip->GBox.Width;

					render		= TRUE;
					notify		= TRUE;
				}
				break;

			default:
				/* This little optimization avoids forwarding the
				 * OM_SET method to our superclass when there are
				 * no unknown tags.
				 */
				do_super_method = TRUE;
				break;
		}


	/* Forward method to our superclass dispatcher, only when needed */

	if (do_super_method)
		result = (DoSuperMethodA (cl, (Object *)g, (Msg) msg));


	/* Update gadget imagery, only when needed */

	if (render && msg->opu_GInfo)
	{
		struct RastPort *rp;

		if (rp = ObtainGIRPort (msg->opu_GInfo))
		{
			DoMethod ((Object *)g,
				GM_RENDER, msg->opu_GInfo, rp, GREDRAW_UPDATE);
			ReleaseGIRPort (rp);
			result = TRUE;
		}
	}


	/* Notify our targets about all changed attributes, only when needed */

	if (notify)
		NotifyAttrs ((Object *)g, msg->opu_GInfo,
			(msg->MethodID == OM_UPDATE) ? msg->opu_Flags : 0,
			PIPA_OffX,			pip->OffX,
			PIPA_OffY,			pip->OffY,
			GA_ID,				g->GadgetID,
			TAG_DONE);

	return result;
}



static ULONG PIP_OMGet (Class *cl, struct Gadget *g, struct opGet *msg)
{
	struct PIPData *pip = INST_DATA (cl, g);

	switch (msg->opg_AttrID)
	{
		case PIPA_Screen:
			*(msg->opg_Storage) = (ULONG) pip->Scr;
			return TRUE;

		case PIPA_BitMap:
			*(msg->opg_Storage) = (ULONG) pip->BitMap;
			return TRUE;

		case PIPA_OffX:
			*(msg->opg_Storage) = (ULONG) pip->OffX;
			return TRUE;

		case PIPA_OffY:
			*(msg->opg_Storage) = (ULONG) pip->OffY;
			return TRUE;

		case PIPA_Width:
			*(msg->opg_Storage) = (ULONG) pip->Width;
			return TRUE;

		case PIPA_Height:
			*(msg->opg_Storage) = (ULONG) pip->Height;
			return TRUE;

		default:
			return DoSuperMethodA (cl, (Object *)g, (Msg) msg);
	}
}



static ULONG PIP_PIPMRefresh (Class *cl, struct Gadget *g, struct pippRefresh *msg)
{
	struct RastPort *rp;

	if (msg->pipp_GInfo && (rp = ObtainGIRPort (msg->pipp_GInfo)))
	{
		/* Call our GM_RENDER method */

		DoMethod ((Object *)g, GM_RENDER, msg->pipp_GInfo, rp, GREDRAW_UPDATE);
		ReleaseGIRPort (rp);
		return TRUE;
	}

	return FALSE;
}



static void RestrictXY (struct PIPData *pip)

/* Restrict XOff and YOff inside bitmap limits */
{
	if (pip->OffY + pip->GBox.Height > pip->Height)
		pip->OffY = pip->Height - pip->GBox.Height;
	if (pip->OffY < 0) pip->OffY = 0;

	if (pip->OffX + pip->GBox.Width > pip->Width)
		pip->OffX = pip->Width - pip->GBox.Width;
	if (pip->OffX < 0) pip->OffX = 0;
}



static void GetGadgetBox (struct GadgetInfo *ginfo, struct Gadget *g, struct IBox *rect)

/* This function gets the actual IBox where a gadget exists
 * in a window.  The special cases it handles are all the REL#?
 * (relative positioning flags).
 */
{
	rect->Left = g->LeftEdge;
	if (g->Flags & GFLG_RELRIGHT) rect->Left += ginfo->gi_Domain.Width - 1;

	rect->Top = g->TopEdge;
	if (g->Flags & GFLG_RELBOTTOM) rect->Top += ginfo->gi_Domain.Height - 1;

	rect->Width = g->Width;
	if (g->Flags & GFLG_RELWIDTH) rect->Width += ginfo->gi_Domain.Width;

	rect->Height = g->Height;
	if (g->Flags & GFLG_RELHEIGHT) rect->Height += ginfo->gi_Domain.Height;
}



Class *MakePIPClass (void)
{
	Class *PIPClass;

	if (PIPClass = MakeClass (NULL, GADGETCLASS, NULL, sizeof (struct PIPData), 0))
		PIPClass->cl_Dispatcher.h_Entry = (ULONG (*)()) PIPDispatcher;

	return PIPClass;
}



void FreePIPClass (Class *PIPClass)
{
	FreeClass (PIPClass);
}
