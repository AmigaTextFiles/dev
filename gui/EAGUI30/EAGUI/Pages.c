/*
 * $RCSfile: Pages.c $
 *
 * $Author: marcel $
 *
 * $Revision: 3.1 $
 *
 * $Date: 1994/12/01 07:03:51 $
 *
 * $Locker: marcel $
 *
 * $State: Exp $
 *
 * Description: This is an advanced example of how to use EAGUI. It can be compiled under
 *     SAS/C 6.51. This example demonstrates how you can create pages. Pages are groups of
 *     gadgets. Only one of these groups (one page) is shown. A cycle gadget is used to
 *     browse through the pages.
 *
 *     Although page groups aren't supported directly in EAGUI, you can create them quite
 *     easily because EAGUI is a very open system.
 *
 * Use a tab size of 5 to read this source! Comments were formatted for a right margin of 95,
 * which matches my overscan and font settings. I hope it is readable for others.
 */

/* standard headers */
#include <stdlib.h>
#include <exec/types.h>
#include <graphics/text.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>
#include <clib/macros.h>
#include <proto/diskfont.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/dos.h>

/* EAGUI headers */
#include "EAGUI.h"
#include "EAGUI_pragmas.h"

/* custom object(s) */
#include "TextField.c"

/* globals */
struct ea_Object *			winobj_ptr		= NULL;
struct ea_Object *			pgroupobj_ptr		= NULL;
struct ea_Object *			page1_ptr			= NULL;
struct ea_Object *			page2_ptr			= NULL;
struct ea_Object *			page3_ptr			= NULL;
struct Window *			win_ptr			= NULL;
struct Screen *			scr_ptr			= NULL;
struct Gadget *			gadlist_ptr		= NULL;
struct Gadget *			cycle_ptr			= NULL;
APTR 					visualinfo_ptr		= NULL;
struct DrawInfo *			drawinfo_ptr		= NULL;
struct TextFont *			tf_ptr			= NULL;
struct Library *			EAGUIBase			= NULL;
struct TextAttr 			textattr 			= {"helvetica.font", 15, FS_NORMAL, FPB_DISKFONT};
struct ci_TextField			textfield1;
struct Hook				tfminsizehook;
struct Hook				tfrenderhook;
struct Hook				pgminsizehook;
struct IntuiMessage			imsg;
STRPTR					labels[]			= {
											"Page One",
											"Page Two",
											"Page Three",
											NULL};
#define page 				(cytaglist1[1].ti_Data)
struct TagItem				cytaglist1[]		= {
											{GTCY_Labels,			(LONG)labels},
											{GTCY_Active,			0},
											{TAG_DONE}};
STATIC UBYTE				rcs_id_string[]	= "$Id: Pages.c 3.1 1994/12/01 07:03:51 marcel Exp marcel $";

/* constants */
#define LAYOUTSPACING		4
#define CYCLEGADGET_ID		666

/* prototypes */
ULONG __saveds __asm		HookEntry(register __a0 struct Hook *, register __a2 VOID *, register __a1 VOID *);
VOID						InitHook(struct Hook *, ULONG (*)(), VOID *);
ULONG					meth_minsize_pgroup(struct Hook *, struct ea_Object *, APTR);
LONG						init(VOID);
VOID						cleanup(STRPTR);
VOID						resizewindow(VOID);
VOID						repagewindow(VOID);
ULONG					handlemsgs(VOID);

/* functions for hook handling */
ULONG __saveds __asm HookEntry
(
	register __a0 struct Hook *	hook_ptr,
	register __a2 VOID *		object_ptr,
	register __a1 VOID *		message_ptr
)
{
	return((*hook_ptr->h_SubEntry)(hook_ptr, object_ptr, message_ptr));
}

VOID InitHook(struct Hook *h_ptr, ULONG (*func_ptr)(), VOID *data_ptr)
{
	if (h_ptr)
	{
		h_ptr->h_Entry = (ULONG (*)())HookEntry;
		h_ptr->h_SubEntry = func_ptr;
		h_ptr->h_Data = data_ptr;
	}
}

/* page group minsize method */
ULONG meth_minsize_pgroup(struct Hook *hook_ptr, struct ea_Object *obj_ptr, APTR msg_ptr)
{
	struct ea_Object *	current_ptr;
	LONG				minwidth;
	LONG				minheight;
	LONG				w, h;
	LONG				mw, mh, bl, br, bt, bb;
	struct TagItem		msg_taglist[] = {
		{EA_MinWidth,		0L},
		{EA_MinHeight,		0L},
		{EA_BorderLeft,	0L},
		{EA_BorderRight,	0L},
		{EA_BorderTop,		0L},
		{EA_BorderBottom,	0L},
		{EA_NextObject,	0L},
		{TAG_DONE,		0L}
		};

	/* starting values */
	minwidth				= 0;
	minheight				= 0;
	current_ptr			= (struct ea_Object *)ea_GetAttr(obj_ptr, EA_FirstChild);
	msg_taglist[0].ti_Data	= (ULONG)&mw;
	msg_taglist[1].ti_Data	= (ULONG)&mh;
	msg_taglist[2].ti_Data	= (ULONG)&bl;
	msg_taglist[3].ti_Data	= (ULONG)&br;
	msg_taglist[4].ti_Data	= (ULONG)&bt;
	msg_taglist[5].ti_Data	= (ULONG)&bb;
	msg_taglist[6].ti_Data	= (ULONG)&current_ptr;

	/* do all children */
	while (current_ptr)
	{
		/* get the required attributes */
		ea_GetAttrsA(current_ptr, msg_taglist);

		/* determine the minimum dimensions of this child */
		w = mw + bl + br;
		h = mh + bt + bb;

		/* check and use these dimensions if they were larger than the largest upto now */
		if (h > minheight)
		{
			minheight = h;
		}
		if (w > minwidth)
		{
			minwidth = w;
		}
	}

	/* set the minimum dimensions of the object */
	ea_SetAttr(obj_ptr, EA_MinWidth,	minwidth);
	ea_SetAttr(obj_ptr, EA_MinHeight,	minheight);

	/* return zero for success */
	return(0);
}

/* initialize everything */
LONG init(VOID)
{
	LONG w, h, bl, br, bt, bb;

	/* open the EAGUI library */
	if (!(EAGUIBase = OpenLibrary(EAGUILIBRARYNAME, EAGUILIBRARYVERSION)))
	{
		cleanup("Couldn't open EAGUI.library.\n");
	}

	/* open the font */
	if (!(tf_ptr = OpenDiskFont(&textattr)))
	{
		cleanup("Couldn't open font.\n");
	}

	/* initialize the pagegroup minsize hook */
	InitHook(&pgminsizehook, meth_minsize_pgroup, NULL);

	/* initialize textfield hooks */
	InitHook(&tfminsizehook, meth_MinSize_TextField, NULL);
	InitHook(&tfrenderhook, meth_Render_TextField, NULL);

	/* set up some defaults for all objects */
	ea_SetAttr(NULL, EA_DefGTTextAttr, (ULONG)&textattr);

	/* now we can build the object tree */
	if (!(winobj_ptr = HGroup
		EA_BorderLeft,		LAYOUTSPACING,
		EA_BorderRight,	LAYOUTSPACING,
		EA_BorderTop,		LAYOUTSPACING,
		EA_BorderBottom,	LAYOUTSPACING,
		EA_Child,			VGroup
			EA_Weight,		1,
			EA_BorderRight,	LAYOUTSPACING,
			EA_Child,			EmptyBox(1)
				End,
			EA_Child,			GTButton("Help...")
				End,
			EA_Child,			EmptyBox(1)
				End,
			EA_Child,			GTButton("Ok")
				End,
			EA_Child,			GTButton("Cancel")
				End,
			End,
		EA_Child,			VGroup
			EA_Weight,		2,
			EA_Child,			GTCycle
				EA_GTTagList,		cytaglist1,
				EA_InstanceAddress,	&cycle_ptr,
				EA_ID,			CYCLEGADGET_ID,
				End,
			EA_Child,			pgroupobj_ptr = ea_NewObject(EA_TYPE_HGROUP,
				EA_StandardMethod,	EASM_BORDER,
				EA_Weight,		1,
				EA_MinSizeMethod,	&pgminsizehook,
				EA_Child,			page1_ptr = GTListView(NULL)
					EA_Weight,		1,
					End,
				EA_Child,			page2_ptr = VGroup
					EA_Weight,		1,
					EA_Child,			EmptyBox(2)
						End,
					EA_Child,			GTString("Username:")
						End,
					EA_Child,			EmptyBox(1)
						End,
					EA_Child,			GTString("Password:")
						End,
					EA_Child,			EmptyBox(2)
						End,
					End,
				EA_Child,			page3_ptr = ea_NewObject(EA_TYPE_CUSTOMIMAGE,
					EA_Weight,		1,
					EA_BorderBottom,	4,
					EA_MinSizeMethod,	&tfminsizehook,
					EA_RenderMethod,	&tfrenderhook,
					EA_UserData,		&textfield1,
					TAG_DONE),
				TAG_DONE),
			End,
		End))
	{
		cleanup("Couldn't init the objects.\n");
	}

	/* lock the screen */
	if (!(scr_ptr = LockPubScreen(NULL)))
	{
		cleanup("Couldn't lock default public screen.\n");
	}

	/* get VisualInfo and DrawInfo */
	if (!(visualinfo_ptr = GetVisualInfo(scr_ptr, TAG_DONE)))
	{
		cleanup("Couldn't get the visual info.\n");
	}
	if (!(drawinfo_ptr = GetScreenDrawInfo(scr_ptr)))
	{
		cleanup("Couldn't get the draw info.\n");
	}

	/* fill in the textfield structure */
	textfield1.tf_string_ptr		= "Connection Established";	/* title */
	textfield1.tf_textattr_ptr	= &textattr;				/* font */
	textfield1.tf_flags			= 0;						/* alignment flags */
	textfield1.tf_frontpen		= 2;						/* frontpen color index */

     /* obtain the minimum dimensions of every object in the tree */
     ea_GetMinSizes(winobj_ptr);

	/* enable and disable the right pages */
	ea_SetAttr(page1_ptr, EA_Disabled, (page == 0) ? FALSE : TRUE);
	ea_SetAttr(page2_ptr, EA_Disabled, (page == 1) ? FALSE : TRUE);
	ea_SetAttr(page3_ptr, EA_Disabled, (page == 2) ? FALSE : TRUE);

	/* get some attributes */
	ea_GetAttrs(winobj_ptr,
		EA_MinWidth,		&w,
		EA_MinHeight,		&h,
		EA_BorderLeft,		&bl,
		EA_BorderRight,	&br,
		EA_BorderTop,		&bt,
		EA_BorderBottom,	&bb,
		TAG_DONE);

     /* open the window */
     if (!(win_ptr = OpenWindowTags(NULL,
     	WA_Title,			"EAGUI Pages Example",
		WA_Flags,			(WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SIZEGADGET | WFLG_SIZEBBOTTOM | WFLG_ACTIVATE),
		WA_IDCMP,			(IDCMP_CLOSEWINDOW | BUTTONIDCMP | STRINGIDCMP | IDCMP_REFRESHWINDOW | IDCMP_NEWSIZE),
		WA_InnerHeight,	(h + bt + bb) * 2,
		WA_InnerWidth,		(w + bl + br) * 2,
		TAG_DONE)))
	{
		cleanup("Couldn't open the window.\n");
	}

	/* set the window limits */
	WindowLimits(
		win_ptr,
		w + win_ptr->BorderLeft + win_ptr->BorderRight + bl + br,
		h + win_ptr->BorderTop + win_ptr->BorderBottom + bt + bb,
		~0,
		~0);

	/* create the gadgets and add them to the window */
	resizewindow();

	return(0);
}

/* clean up everything that was created */
VOID cleanup(STRPTR str_ptr)
{
	int rc = 0;

	/* if a string is passed, we assume there was some kind of error */
	if (str_ptr)
	{
		Printf("Error: %s", str_ptr);
		rc = 20;
	}

	if (gadlist_ptr)
	{
		RemoveGList(win_ptr, gadlist_ptr, -1);
		ea_FreeGadgetList(winobj_ptr, gadlist_ptr);
		gadlist_ptr = NULL;
	}

	if (win_ptr)
	{
		CloseWindow(win_ptr);
		win_ptr = NULL;
	}

	if (drawinfo_ptr)
	{
		FreeScreenDrawInfo(scr_ptr, drawinfo_ptr);
		drawinfo_ptr = NULL;
	}

	if (visualinfo_ptr)
	{
		FreeVisualInfo(visualinfo_ptr);
		visualinfo_ptr = NULL;
	}

	if (scr_ptr)
	{
		UnlockPubScreen(NULL, scr_ptr);
		scr_ptr = NULL;
	}

	if (winobj_ptr)
	{
		ea_DisposeObject(winobj_ptr);
		winobj_ptr = NULL;
	}

	if (tf_ptr)
	{
		CloseFont(tf_ptr);
		tf_ptr = NULL;
	}

	if (EAGUIBase)
	{
		CloseLibrary(EAGUIBase);
		EAGUIBase = NULL;
	}

	exit(rc);
}

/* (re)create the gadget list after a size change */
VOID resizewindow(VOID)
{
	LONG bl, br, bt, bb;

	/* if necessary, remove the gadget list from the window, and clean it up */
	if (gadlist_ptr)
	{
		RemoveGList(win_ptr, gadlist_ptr, -1);
		ea_FreeGadgetList(winobj_ptr, gadlist_ptr);
		gadlist_ptr = NULL;
	}

	ea_GetAttrs(winobj_ptr,
		EA_BorderLeft,		&bl,
		EA_BorderRight,	&br,
		EA_BorderTop,		&bt,
		EA_BorderBottom,	&bb,
		TAG_DONE);

	 ea_SetAttrs(winobj_ptr,
		EA_Width,		win_ptr->Width -
					win_ptr->BorderLeft -
					win_ptr->BorderRight -
					bl -
					br,
		EA_Height,	win_ptr->Height -
					win_ptr->BorderTop -
					win_ptr->BorderBottom -
					bt -
					bb,
		EA_Left,		win_ptr->BorderLeft,
		EA_Top,		win_ptr->BorderTop,
		TAG_DONE);

	ea_LayoutObjects(winobj_ptr);

	if (ea_CreateGadgetList(winobj_ptr, &gadlist_ptr, visualinfo_ptr, drawinfo_ptr) != EA_ERROR_OK)
	{     
		cleanup("Couldn't create the gadget list.\n");
	}     

	EraseRect(win_ptr->RPort,     
		win_ptr->BorderLeft,
		win_ptr->BorderTop,
		win_ptr->Width - win_ptr->BorderRight - 1,
		win_ptr->Height - win_ptr->BorderBottom - 1);

	RefreshWindowFrame(win_ptr);

	AddGList(win_ptr, gadlist_ptr, -1, -1, NULL);
	RefreshGList(gadlist_ptr, win_ptr, NULL, -1);
	GT_RefreshWindow(win_ptr, NULL);

	/* finally, we render the imagery, if there is any */
	ea_RenderObjects(winobj_ptr, win_ptr->RPort);
}

/* (re)create the gadget list after a page change */
VOID repagewindow(VOID)
{
	LONG bl, br, bt, bb;
	LONG gw, gh, gt, gl;

	/* if necessary, remove the gadget list from the window, and clean it up */
	if (gadlist_ptr)
	{
		RemoveGList(win_ptr, gadlist_ptr, -1);
		ea_FreeGadgetList(winobj_ptr, gadlist_ptr);
		gadlist_ptr = NULL;
	}

	ea_GetAttrs(winobj_ptr,
		EA_BorderLeft,		&bl,
		EA_BorderRight,	&br,
		EA_BorderTop,		&bt,
		EA_BorderBottom,	&bb,
		TAG_DONE);

	 ea_SetAttrs(winobj_ptr,
		EA_Width,		win_ptr->Width -
					win_ptr->BorderLeft -
					win_ptr->BorderRight -
					bl -
					br,
		EA_Height,	win_ptr->Height -
					win_ptr->BorderTop -
					win_ptr->BorderBottom -
					bt -
					bb,
		EA_Left,		win_ptr->BorderLeft,
		EA_Top,		win_ptr->BorderTop,
		TAG_DONE);

	ea_LayoutObjects(winobj_ptr);

	if (ea_CreateGadgetList(winobj_ptr, &gadlist_ptr, visualinfo_ptr, drawinfo_ptr) != EA_ERROR_OK)
	{     
		cleanup("Couldn't create the gadget list.\n");
	}     

	/* now determine the exact position of the page in the window */
	gl = ea_GetObjectLeft(winobj_ptr, pgroupobj_ptr);
	gt = ea_GetObjectTop(winobj_ptr, pgroupobj_ptr);
	gw = ea_GetAttr(pgroupobj_ptr, EA_Width);
	gh = ea_GetAttr(pgroupobj_ptr, EA_Height);

	/* clear only the page instead of the complete window */
	EraseRect(win_ptr->RPort,
		gl,
		gt,
		gl + gw - 1,
		gt + gh - 1);

	AddGList(win_ptr, gadlist_ptr, -1, -1, NULL);
	RefreshGList(gadlist_ptr, win_ptr, NULL, -1);
	GT_RefreshWindow(win_ptr, NULL);

	/* finally, we render the imagery, if there is any */
	ea_RenderObjects(winobj_ptr, win_ptr->RPort);
}

/* a normal message handling loop */
ULONG handlemsgs(VOID)
{
	struct IntuiMessage	*	imsg_ptr;
	ULONG				rc = 0;

	while (imsg_ptr = GT_GetIMsg(win_ptr->UserPort))
	{
		CopyMem((char *)imsg_ptr, (char *)&imsg, (long)sizeof(struct IntuiMessage));

		GT_ReplyIMsg(imsg_ptr);

		switch (imsg.Class)
		{
			case	IDCMP_REFRESHWINDOW:
				/* just do the normal refreshing here */
				GT_BeginRefresh(win_ptr);
				GT_EndRefresh(win_ptr, TRUE);
				break;

			case	IDCMP_CLOSEWINDOW:
				/* set the return code */
				rc = 10;
				break;

			case	IDCMP_NEWSIZE:
				/* resize the window */
				resizewindow();
				break;

			case IDCMP_GADGETUP:
				/* check if the user clicked on the cycle gadget */
				if ((((struct Gadget *)imsg.IAddress)->GadgetID) == CYCLEGADGET_ID)
				{
					/* the user clicked on the cycle gadget and selected a different page */
					page = imsg.Code;

					/* enable and disable the right pages */
					ea_SetAttr(page1_ptr, EA_Disabled, (page == 0) ? FALSE : TRUE);
					ea_SetAttr(page2_ptr, EA_Disabled, (page == 1) ? FALSE : TRUE);
					ea_SetAttr(page3_ptr, EA_Disabled, (page == 2) ? FALSE : TRUE);

					/* refresh the window and the gadgets */
					repagewindow();
				}
				break;
		}
	}
	return(rc);
}

/* main */
int main(int argc, char *argv[])
{
	ULONG idcmpmask, signals;
	BOOL done = FALSE;

	/* process any startup options the user has supplied */
	if (argc > 1)
	{
		/* first argument is the font name */
		textattr.ta_Name = argv[1];
		if (argc > 2)
		{
			/* second argument is the font y-size */
			textattr.ta_YSize = atoi(argv[2]);
		}
	}

	/* initialize everything */
	init();

	/* event handling loop */
	idcmpmask = 1L << win_ptr->UserPort->mp_SigBit;
	while (done == FALSE)
	{
		signals = Wait(idcmpmask);
		if (signals & idcmpmask)
		{
			if (handlemsgs() != 0)
			{
				done = TRUE;
			}
		}
	}

	/* cleanup everything */
	cleanup(NULL);
}
