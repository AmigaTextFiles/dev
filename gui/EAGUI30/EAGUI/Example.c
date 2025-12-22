/*
 * $RCSfile: Example.c,v $
 *
 * $Author: marcel $
 *
 * $Revision: 3.2 $
 *
 * $Date: 1994/12/01 07:04:30 $
 *
 * $Locker: marcel $
 *
 * $State: Exp $
 *
 * Description: This is an example of how to use EAGUI. In fact it is the complete version of
 *     the example used in the tutorial[2]. It can be compiled under SAS/C 6.51. It should be
 *     fairly trivial to modify this example to create any window you want[1]. Please note that
 *     the contents of the gadgets aren't saved, so after a resize, everything is lost. Under
 *     V39 it is very easy to get and set these attributes (with GT_GetGadgetAttrs() and
 *     GT_SetGadgetAttrs()), and although it's a bit more difficult under V37, it can be done
 *     there too (it's something you'll have to do anyway).
 *
 * [1] If you want to create a new window, it is enough to specify a new tree of objects. The
 *     only other thing you might want to change is the fact that the window in this example
 *     can only be resized in horizontal direction. If you change the last argument of the
 *     WindowLimits() call to "~0" that's fixed too.
 *
 * [2] In fact, it is a slightly enhanced example, which shows a little bit more.
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

/* Custom object(s) */
#include "TextField.c"

/* globals */
struct ea_Object *			winobj_ptr		= NULL;
struct ea_Object *			okobj_ptr			= NULL;
struct ea_Object *			cancelobj_ptr		= NULL;
struct ea_Object *			hgroupobj_ptr		= NULL;
struct Window *			win_ptr			= NULL;
struct Screen *			scr_ptr			= NULL;
struct Gadget *			gadlist_ptr		= NULL;
struct Gadget *			stringgadget_ptr	= NULL;
APTR 					visualinfo_ptr		= NULL;
struct DrawInfo *			drawinfo_ptr		= NULL;
struct TextFont *			tf_ptr			= NULL;
struct Library *			EAGUIBase			= NULL;
struct TextAttr 			textattr 			= {"helvetica.font", 15, FS_NORMAL, FPB_DISKFONT};
struct Hook				relhook;
struct Hook				tfminsizehook;
struct Hook				tfrenderhook;
struct IntuiMessage			imsg;
struct ci_TextField			textfield1;
STATIC UBYTE				rcs_id_string[]	= "$Id: Example.c,v 3.2 1994/12/01 07:04:30 marcel Exp marcel $";

/* prototypes */
ULONG __saveds __asm		HookEntry(register __a0 struct Hook *, register __a2 VOID *, register __a1 VOID *);
VOID						InitHook(struct Hook *, ULONG (*)(), VOID *);
ULONG					rel_samesize(struct Hook *, struct List *, APTR);
LONG						init(VOID);
VOID						cleanup(STRPTR);
VOID						resizewindow(VOID);
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

/* same size relation */
ULONG rel_samesize(struct Hook *hook_ptr, struct List *list_ptr, APTR msg_ptr)
{
     struct ea_RelationObject *ro_ptr;
     ULONG minx, miny;
     ULONG x, y;
     minx = 0;
     miny = 0;

     /* examine the list of objects that are affected by the relation */
     ro_ptr = (struct ea_RelationObject *)list_ptr->lh_Head;
     while (ro_ptr->node.ln_Succ)
     {
          ea_GetAttrs(ro_ptr->object_ptr,
               EA_MinWidth,        &x,
               EA_MinHeight,       &y,
               TAG_DONE);

          /* find the maximum values of the minimum sizes */
          minx = MAX(x, minx);
          miny = MAX(y, miny);

          ro_ptr = (struct ea_RelationObject *)ro_ptr->node.ln_Succ;
     }

     /* set all objects to the newly found minimum sizes */
     ro_ptr = (struct ea_RelationObject *)list_ptr->lh_Head;
     while (ro_ptr->node.ln_Succ)
     {
          ea_SetAttrs(ro_ptr->object_ptr,
               EA_MinWidth,        minx,
               EA_MinHeight,       miny,
               TAG_DONE);

          ro_ptr = (struct ea_RelationObject *)ro_ptr->node.ln_Succ;
     }
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

	/* initialize the relation */
	InitHook(&relhook, rel_samesize, NULL);

	/* initialize textfield hooks */
	InitHook(&tfminsizehook, meth_MinSize_TextField, NULL);
	InitHook(&tfrenderhook, meth_Render_TextField, NULL);

	/* set up some defaults for all objects */
	ea_SetAttr(NULL, EA_DefGTTextAttr, (ULONG)&textattr);

	/* now we can build the object tree */
	if (!( winobj_ptr = VGroup
		EA_BorderLeft,		4,
		EA_BorderRight,	4,
		EA_BorderTop,		4,
		EA_BorderBottom,	4,
		EA_Child,			ea_NewObject(EA_TYPE_CUSTOMIMAGE,
			EA_BorderBottom,	4,
			EA_MinSizeMethod,	&tfminsizehook,
			EA_RenderMethod,	&tfrenderhook,
			EA_UserData,		&textfield1,
			TAG_DONE),
		EA_Child,			GTString(NULL)
			EA_InstanceAddress,	&stringgadget_ptr,
			EA_MinWidth,		20,	/* Fixes a bug in the GadTools library, which
								 * renders the full contents of the gadget, if
								 * it is very small, and you're using a fixed-
								 * width font. Originally reported by Roy van
								 * der Woning.
								 */
			End,
		EA_Child,			hgroupobj_ptr = HGroup
			EA_BorderTop,		4,
			EA_Child,			okobj_ptr = GTButton("Ok")
				End,
			EA_Child,			EmptyBox(1)
				End,
			EA_Child,			cancelobj_ptr = GTButton("Cancel")
				End,
			End,
		End ) )
	{
		cleanup("Couldn't init the objects.\n");
	}

     ea_NewRelation(hgroupobj_ptr, &relhook,
          EA_Object,          okobj_ptr,
          EA_Object,          cancelobj_ptr,
          TAG_DONE);

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
	textfield1.tf_string_ptr = "Enter a string here:";	/* title */
	textfield1.tf_textattr_ptr = &textattr;				/* font */
	textfield1.tf_flags = CITF_ALIGNTOP;				/* alignment flags */
	textfield1.tf_frontpen = 2;						/* frontpen color index */

     /* obtain the minimum dimensions of every object in the tree */
     ea_GetMinSizes(winobj_ptr);

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
     	WA_Title,			"EAGUI Example",
		WA_Flags,			(WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_SIZEGADGET | WFLG_SIZEBBOTTOM | WFLG_ACTIVATE),
		WA_IDCMP,			(IDCMP_CLOSEWINDOW | BUTTONIDCMP | STRINGIDCMP | IDCMP_REFRESHWINDOW | IDCMP_NEWSIZE),
		WA_InnerHeight,	h + bt + bb,
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
		h + win_ptr->BorderTop + win_ptr->BorderBottom + bt + bb);

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

/* (re)create the gadget list */
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
				GT_BeginRefresh(win_ptr);
				GT_EndRefresh(win_ptr, TRUE);
				break;

			case	IDCMP_CLOSEWINDOW:
				rc = 10;
				break;

			case	IDCMP_NEWSIZE:
				resizewindow();
				/* Just for fun, we put a string in the string gadget after each
				 * resize. This demonstrates how to use the EA_InstanceAddress
				 * tag to obtain pointers to gadgets, which you can use to modify
				 * the gadgets directly.
				 */
				GT_SetGadgetAttrs(stringgadget_ptr, win_ptr, NULL,
					GTST_String,	"Ah, a size change! How nice.",
					TAG_DONE);
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
