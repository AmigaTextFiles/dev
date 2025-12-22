static const char rcsid[] =
   "$Id: statusclass.c 1.10 1995/12/09 23:47:41 JöG Exp JöG $";

/*
 * Statusclass - a BOOPSI gadget class to display
 * text in a framed button, with the option to
 * put it in the window border or relative to something.
 *
 * SAS/C 6.55 code - beware when porting:
 * autoinitalization of library bases
 * __oslibversion
 * uses SAS/C stccpy()
 *
 *
 * Jörgen Grahn
 * Wetterlinsgatan 13E
 * S-521 34 Falköping
 * Sverige
 *
 */

/*
 * $Log: statusclass.c $
 * Revision 1.10  1995/12/09  23:47:41  JöG
 * rendering in case of OM_SET optimized
 * now only renders if significant attributes have changed
 * compares new STATUS_Text and STATUS_RText
 *     with existing before setting and redrawing
 *
 * Revision 1.9  1995/12/09  17:58:34  JöG
 * ...but it didn't compile
 *
 * Revision 1.8  1995/12/09  17:55:11  JöG
 * used to have problems with NULL for the two
 * text attributes
 *
 * Revision 1.7  1995/12/06  21:20:31  JöG
 * small comment change
 *
 * Revision 1.6  1995/12/06  19:25:33  JöG
 * MAJOR reworking
 * this version stands up to its original specification,
 * as far as I know
 *
 * Revision 1.5  1995/12/05  20:22:01  JöG
 * fixed dangerous Hook bug which would show itself if PARAMETERS=BOTH
 * was used
 *
 * Revision 1.4  1995/12/05  19:40:03  JöG
 * changed HORRIBLE bug with accessing instance data
 * minor type castings and changes
 *
 * Revision 1.3  1995/12/05  16:55:27  JöG
 * minor fix
 *
 * Revision 1.2  1995/12/05  16:52:14  JöG
 * fixed to compile
 * changed extern HookEntry() to take its arguments
 * on the stack
 *
 * Revision 1.1  1995/12/05  15:53:17  JöG
 * Initial revision
 *
 */

/* 
 * STATUSCLASS - a view-only text display gadget.
 * 
 *
 * FEATURES:
 * 
 * Displays _two_ texts in the same font as the window title.
 * Frames itself with a nice-looking frameiclass.
 * Has an attribute to turn the "blue" background on or off.
 * Can exist in the border, be relative to the right or bottom
 * 		border, and/or have relative width and/or height.
 * At least under V39 and above, adjusts its size to leave only
 * 		a free height inside the window of BSpace + k·WinMult,
 * 		where k is the largest integer leaving enough space for
 * 		the gadget. Works best if sitting at the top or bottom
 * 		of the window. In these cases, your supplied Height
 * 		doesn't matter.
 * 
 * NOTES:
 * 
 * You _must_, at least under V37, set the Height to at least what
 * 		you expect the window title height to be.
 * Automatic resizing under v39 works best with RELBOTTOM or simply
 * 		a gadget below the title bar. It does nothing with
 * 		BOTTOMBORDER gadgets or when WinMult is 1.
 * You can size and move the gadget using SetAttr, but it won't
 * 		be visually attractive.
 * Don't put this gadget in requesters.
 * You probably need the V39 includes to compile this.
 * Compile with things like stack checking OFF. Register arguments
 * 		are supported.
 *
 * BUGS:
 *
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/cghooks.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <utility/hooks.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>

#include <stdlib.h>
#include <string.h>

#include "statusclass.h"



#define IM(o) ((struct Image *) o)
#define GAD(o) ((struct Gadget *) o)



static char * internalgettagstr(Tag, char *, struct TagItem *);



#define GETTAGSTR(tag,str,array) \
	internalgettagstr((tag),(str),(array))



typedef struct
{
	char	text[128];	/* text in the gadget */
	char	rtext[64];	/* right-adjusted text in the gadget */
	WORD	bspace;		/* space for inner window top+bottom border */
	WORD	winmult;	/* height of each window-contents item */
	BOOL	borcol;		/* TRUE if gadget currently is 'blue' */
} IData;



static ULONG __stdargs __saveds dispatcher(Class *, Object *, APTR);

static ULONG methodnew(Class *, Object *, struct opSet *);
static ULONG methodset(Class *, Object *, struct opSet *);
static ULONG methodlayout(Class *, Object *, struct gpLayout *);
static ULONG methodrender(Class *, Object *, struct gpRender *);
static ULONG methodgoactive(Class *, Object *, struct gpInput *);
static ULONG methodhandleinput(Class *, Object *, struct gpInput *);
static ULONG methoddispose(Class *, Object *, Msg);



/*
 *
 *
 *
 */
Class * statusclasscreate(void)
{
	Class	* class;

	extern ULONG __stdargs HookEntry();


	class = MakeClass(NULL, "gadgetclass", NULL, sizeof(IData), 0);
	if(!class)
	{	return(NULL);
	}

	class->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry;
	class->cl_Dispatcher.h_SubEntry = (HOOKFUNC)dispatcher;
#if 0
	class->cl_Dispatcher.h_Data = NULL;
#endif

	return(class);
}



/*
 *
 *
 *
 */
void statusclassdestroy(Class * class)
{
	FreeClass(class);
}



/*
 *
 * WARNING!  Unspeakable slimy creatures wait along the path ready to rip your
 * heart from your quivering body if you a) use amiga.lib/HookEntry() to call
 * your dispatcher and b) use PARAMETERS=BOTH and c) fail to mark the true
 * dispatcher as __stdargs.  In that case the compiler will pick the _regargs_
 * version of the function and put it in the hook...
 *
 * This goes for all hooks, BTW.
 *
 *
 */
static ULONG __stdargs __saveds dispatcher(Class * class, Object * obj, APTR msg)
{
	switch(((Msg)msg)->MethodID)
	{
		case OM_NEW:
			return(methodnew(class, obj, msg));
		case OM_SET:
			return(methodset(class, obj, msg));
		case GM_LAYOUT:
			return(methodlayout(class, obj, msg));
		case GM_RENDER:
			return(methodrender(class, obj, msg));
		case GM_GOACTIVE:
			return(methodgoactive(class, obj, msg));
		case GM_HANDLEINPUT:
			return(methodhandleinput(class, obj, msg));
		case OM_DISPOSE:
			methoddispose(class, obj, msg);
			/* fall-through */
		case OM_GET:
		case OM_ADDTAIL:
		case OM_REMOVE:
		case OM_NOTIFY:
		case OM_UPDATE:
		case OM_ADDMEMBER:
		case OM_REMMEMBER:
		case GM_HITTEST:
		case GM_GOINACTIVE:
		case GM_HELPTEST:
		default:
			return(DoSuperMethodA(class, obj, msg));
	}
}



static ULONG methodnew(Class * class, Object * obj, struct opSet * msg)
{
	Object	* new;
	Object	* frame;
	IData	* data;


	new = (Object *)DoSuperMethodA(class, obj, (Msg)msg);
	if(new)
	{
		/* set default attributes */

		data = INST_DATA(class, new);
		stccpy(data->text,
			GETTAGSTR(STATUS_Text, "Status gadget", msg->ops_AttrList),
			128);
		stccpy(data->rtext,
			GETTAGSTR(STATUS_RText, "", msg->ops_AttrList),
			64);
		data->bspace =
			GetTagData(STATUS_BSpace, 0, msg->ops_AttrList);
		data->winmult =
			GetTagData(STATUS_WinMult, 1, msg->ops_AttrList);
		if(data->winmult<1)
		{	data->winmult = 1;
		}
		data->borcol =
			GetTagData(STATUS_BorCol, 0, msg->ops_AttrList);

		frame = NewObject(NULL, "frameiclass",
			/* this should really be aspect ratio-sensitive */
#if 1
			IA_FrameType, FRAME_DEFAULT,
#else
			IA_FrameType, FRAME_BUTTON,
#endif
			TAG_DONE);

		if(!frame)
		{	CoerceMethod(class, new, OM_DISPOSE);
			return(0);
		}
		else
		{	GAD(new)->GadgetRender = frame;
			return(ULONG)(new);
		}
	}
	else
	{	return(0);
	}
}



static ULONG methodset(Class * class, Object * obj, struct opSet * msg)
{
	struct RastPort		* rport;
	struct TagItem		* ti1,
						* ti2;
	IData				* data;
	BOOL				  change;


	data = INST_DATA(class, obj);

	/* let things like dimensions set first */
	change = DoSuperMethodA(class, obj, (Msg)msg);

	/* get attributes, layout if necessary, and render */

	ti1 = FindTagItem(STATUS_Text, msg->ops_AttrList);
	if(ti1 && ti1->ti_Data)
	{	if(strcmp(data->text, (char *)ti1->ti_Data) != 0)
		{	stccpy(data->text, (char *)ti1->ti_Data, 128);
			change = TRUE;
		}
	}

	ti1 = FindTagItem(STATUS_RText, msg->ops_AttrList);
	if(ti1 && ti1->ti_Data)
	{	if(strcmp(data->rtext, (char *)ti1->ti_Data) != 0)
		{	stccpy(data->rtext, (char *)ti1->ti_Data, 64);
			change = TRUE;
		}
	}

	ti1 = FindTagItem(STATUS_BorCol, msg->ops_AttrList);
	if(ti1)
	{	data->borcol = ti1->ti_Data;
		change = TRUE;
	}

	ti1 = FindTagItem(STATUS_BSpace, msg->ops_AttrList);
	if(ti1)
	{	data->bspace = ti1->ti_Data;
		change = TRUE;
	}

	ti2 = FindTagItem(STATUS_WinMult, msg->ops_AttrList);
	if(ti2)
	{	data->winmult = ti2->ti_Data;
		change = TRUE;
	}

	/* this is a NOP in V37 (actually, NOT) */
	if(ti1 || ti2)
	{	DoMethod(obj, GM_LAYOUT, msg->ops_GInfo, 0);
	}

	if(change)
	{	rport = ObtainGIRPort(msg->ops_GInfo);
		if(rport)
		{	DoMethod(obj, GM_RENDER, msg->ops_GInfo, rport, GREDRAW_REDRAW);

			ReleaseGIRPort(rport);
		}
	}

	return(1);
}



static ULONG methodlayout(Class * class, Object * obj, struct gpLayout * msg)
{
	struct Window	* window;
	struct RastPort	* rport;
	IData			* data;
	WORD			  spaceused,	/* minimum space used for artwork */
					  spaceleft,	/* remaining height */
					  newheight;	/* new gadget size */

	/*
	 * Here goes. We want the gadget to be the same size
	 * as as the title bar, plus enough space to make
	 * the free space of the window a certain height.
	 * We have to resize and possibly reposition the
	 * gadget.
	 *
	 */

	data = INST_DATA(class, obj);

	/* if winmult==1, nothing can be done */
	/* don't handle BORDER gadgets */

	if((data->winmult==1) ||
		(GAD(obj)->Activation & GACT_BOTTOMBORDER))
	{
		return(DoSuperMethodA(class, obj, (Msg)msg));
	}

	/* don't handle BORDER gadgets */
	if(GAD(obj)->Activation & GACT_BOTTOMBORDER)
	{	return(1);
	}

	window = msg->gpl_GInfo->gi_Window;
	rport = ObtainGIRPort(msg->gpl_GInfo);

	if(rport)
	{
		spaceused = window->BorderTop + window->BorderBottom
			+ data->bspace;
		spaceused += rport->TxHeight + 4;

		spaceleft = window->Height - spaceused;

		newheight = rport->TxHeight + 4 + (spaceleft % data->winmult);

		if(GAD(obj)->Flags & GFLG_RELBOTTOM)
		{
			/* extend upwards */
			GAD(obj)->TopEdge += GAD(obj)->Height - newheight;
			GAD(obj)->Height = newheight;
		}
		else
		{	/* assume no relativity, no border */

			/* extend downwards */
			GAD(obj)->Height = newheight;
		}

		ReleaseGIRPort(rport);
	}

	return(1);	/* don't know if we should call the superclass ### */
}



static ULONG methodrender(Class * class, Object * obj, struct gpRender * msg)
{
	Object			* frame;
	struct RastPort	* rport;
	IData			* data;

	struct TextExtent	dummy;

	WORD			  left,
					  top,
					  width,
					  height;
	ULONG			  nrchars;


	data = INST_DATA(class, obj);

	rport = msg->gpr_RPort;

	/* transform gadget bounding box to real values */

	left = (GAD(obj)->Flags & GFLG_RELRIGHT) ?
		msg->gpr_GInfo->gi_Domain.Width + GAD(obj)->LeftEdge - 1:
		GAD(obj)->LeftEdge;

	top = (GAD(obj)->Flags & GFLG_RELBOTTOM) ?
		msg->gpr_GInfo->gi_Domain.Height + GAD(obj)->TopEdge - 1:
		GAD(obj)->TopEdge;

	width = (GAD(obj)->Flags & GFLG_RELWIDTH) ?
		msg->gpr_GInfo->gi_Domain.Width + GAD(obj)->Width:
		GAD(obj)->Width;

	height = (GAD(obj)->Flags & GFLG_RELHEIGHT) ?
		msg->gpr_GInfo->gi_Domain.Height + GAD(obj)->Height:
		GAD(obj)->Height;

	/* time to inform the frame */

	frame = GAD(obj)->GadgetRender;
	SetAttrs(frame,
		IA_Width, width,
		IA_Height, height,
		IA_Recessed, data->borcol,
		TAG_DONE);

	DrawImageState(rport, IM(frame),
		left, top,
		data->borcol? IDS_SELECTED: IDS_NORMAL,
		msg->gpr_GInfo? msg->gpr_GInfo->gi_DrInfo: NULL);	/* why check? */

	/* rendering left text... */

	nrchars = TextFit(rport, data->text, strlen(data->text),
		&dummy, NULL, 1, width-20, rport->TxHeight);

	Move(rport,
		left+12,
		top + (height-rport->TxHeight)/2 + rport->TxBaseline);

	Text(rport, data->text, nrchars);

	/* rendering right text... left has prescedence */

	nrchars = TextFit(rport, data->rtext, strlen(data->rtext),
		&dummy, NULL, 1, left+width-10-rport->cp_x, rport->TxHeight);

	Move(rport,
		left+width-10 - TextLength(rport, data->rtext, nrchars),
		rport->cp_y);

	Text(rport, data->rtext, nrchars);

	return(1);
}



static ULONG methodgoactive(Class * class, Object * obj, struct gpInput * msg)
{
	/* GMR_REUSE not allowed here */

	return(GMR_NOREUSE);
}



static ULONG methodhandleinput(Class * class, Object * obj, struct gpInput * msg)
{
	/* the mouse press goes right through the gadget... */

	return(GMR_REUSE);
}



static ULONG methoddispose(Class * class, Object * obj, Msg msg)
{
	/* dispose of the frame */

	DisposeObject(GAD(obj)->GadgetRender);

	return(1);
}



static char * internalgettagstr(Tag tag, char * defstr, struct TagItem * array)
{
	char	* tmp;


	if(tmp = (char *)GetTagData(tag, (ULONG)defstr, array))
	{	return(tmp);
	}
	else
	{	return("");
	}
}
