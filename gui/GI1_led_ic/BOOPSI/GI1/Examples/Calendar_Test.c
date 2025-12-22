/*****************************************************************************
 *
 * COPYRIGHT: Unless otherwise noted, all files are Copyright (c) 1992-1994
 * Commodore-Amiga, Inc. All rights reserved.
 *
 * DISCLAIMER: This software is provided "as is".  No representations or
 * warranties are made with respect to the accuracy, reliability,
 * performance, currentness, or operation of this software, and all use is at
 * your own risk. Neither Commodore nor the authors assume any responsibility
 * or liability whatsoever with respect to your use of this software.
 *
 *****************************************************************************
 * calendar_test.c
 * test program for the calendar.gadget
 * Written by David N. Junod
 *
 */

#include <dos/dos.h>
#include <dos/rdargs.h>
#include <exec/types.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/icclass.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/intuitionbase.h>
#include <gadgets/calendar.h>
#include <stdlib.h>
#include <stdio.h>

#include <clib/macros.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>

#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/utility_pragmas.h>

/*****************************************************************************/

#define	IDCMP_FLAGS	IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | IDCMP_GADGETUP \
			| IDCMP_MOUSEMOVE | IDCMP_INTUITICKS | IDCMP_MOUSEBUTTONS \
			| IDCMP_IDCMPUPDATE

/*****************************************************************************/

extern struct Library *SysBase, *DOSBase, *UtilityBase;
struct Library *IntuitionBase;

/*****************************************************************************/

#define	TEMPLATE	"READONLY/S,MULTISELECT/S,LABELS/S,NOLABEL/S"
#define	OPT_READONLY	0
#define	OPT_MULTI	1
#define	OPT_LABELS	2
#define	OPT_LABEL	3
#define	OPT_MAX		4

struct RDArgs *ra;
LONG opts[OPT_MAX];

/*****************************************************************************/

struct ClassLibrary *openclass (STRPTR name, ULONG version);
LONG DoClassLibraryMethod (struct ClassLibrary *cl, Msg msg);

/*****************************************************************************/

void main (int argc, char **argv)
{
    struct IntuiMessage *imsg;
    struct ClassLibrary *cl;
    struct gpDomain gpd;
    struct Screen *scr;
    struct Window *win;
    struct Gadget *gad;
    struct Gadget *g;
    BOOL going = FALSE;
    ULONG mw, w;
    ULONG mh, h;
    ULONG sigr;
    ULONG day;

    DayLabel dlArray[31];
    DayLabelP dl;
    LONG i, j;
    struct TagItem ti[2];

    /* Make sure that we have at least V2.04 */
    if (IntuitionBase = OpenLibrary ("intuition.library", 37))
    {
	/* Get our arguments from the command line */
	if (ra = ReadArgs (TEMPLATE, opts, NULL))
	{
	    /* See if they tried to get away */
	    if (!((SIGBREAKF_CTRL_C & CheckSignal (SIGBREAKF_CTRL_C))))
		going = TRUE;
	}
	else
	    PrintFault (IoErr (), NULL);

	if (going == FALSE)
	{
	    /* Can't really go on with it all */
	}
	else if (cl = openclass ("gadgets/calendar.gadget", 37))
	{
	    /* Clear the array */
	    for (i = 0; i < 31; i++)
		for (j = 0; j < MAX_DL_PENS; j++)
		    dlArray[i].dl_Pens[j] = -1;

	    /* Set a few of our favorite dates */
	    dl = &dlArray[0];
	    dl->dl_Flags = DLF_SELECTED;
	    dl = &dlArray[6];
	    dl->dl_Flags = DLF_DISABLED;
	    dl = &dlArray[12];
	    dl->dl_Pens[DL_TEXTPEN] = 1;
	    dl->dl_Pens[DL_BACKGROUNDPEN] = 3;
	    dl = &dlArray[19];
	    dl->dl_Pens[DL_TEXTPEN] = 2;
	    dl->dl_Pens[DL_BACKGROUNDPEN] = 4;

	    /* Illegal but easy way to TEST on any screen.
	     * DO NOT DO THIS IN PRODUCTION CODE. */
	    scr = ((struct IntuitionBase *)IntuitionBase)->FirstScreen;

	    /* Get the domain of the object */
	    gpd.MethodID  = GM_DOMAIN;
	    gpd.gpd_GInfo = NULL;
	    gpd.gpd_RPort = &scr->RastPort;
	    gpd.gpd_Which = GDOMAIN_MINIMUM;
	    ti[0].ti_Tag  = CALENDAR_Label;
	    ti[0].ti_Data = (opts[OPT_LABEL] ? FALSE : TRUE);
	    ti[1].ti_Tag  = TAG_DONE;
	    gpd.gpd_Attrs = ti;
	    if (DoClassLibraryMethod (cl, (Msg)&gpd) == 1)
	    {
		mw = gpd.gpd_Domain.Width;
		mh = gpd.gpd_Domain.Height;
		Printf ("class said we have a minimum size of w=%ld and h=%ld\n", (ULONG)mw, (ULONG)mh);
	    }
	    else
	    {
		Printf ("class had no clue as to the size to be, so we'll do it ourself!\n");

		/* Compute the size that we want to be */
		mw = ((scr->RastPort.TxWidth * 3) * 7) + (6 * 2);
		mh = (scr->RastPort.TxHeight * 7) + (6 * 1);
	    }
	    w = MAX (320, mw);
	    h = MAX (100, mh);

	    /* Create the destination window */
	    if (win = OpenWindowTags (NULL,
				      WA_Title,		"calendar.gadget Test",
				      WA_InnerWidth,	w + 4,
				      WA_InnerHeight,	h + 2,
				      WA_IDCMP,		IDCMP_FLAGS,
				      WA_Activate,	TRUE,
				      WA_DragBar,	TRUE,
				      WA_DepthGadget,	TRUE,
				      WA_CloseGadget,	TRUE,
				      WA_SimpleRefresh,	TRUE,
				      WA_NoCareRefresh,	TRUE,
				      WA_SizeGadget,	TRUE,
				      WA_SizeBBottom,	TRUE,
				      WA_AutoAdjust,	TRUE,
				      WA_CustomScreen,	scr,
				      WA_MinWidth,	8 + 4 + mw,
				      WA_MinHeight,	scr->BarHeight + 10 + 2 + mh,
				      WA_MaxWidth,	1024,
				      WA_MaxHeight,	1024,
				      TAG_DONE))
	    {
		/* Create the gadget */
		if (gad = NewObject (NULL, "calendar.gadget",
					GA_Left,		win->BorderLeft + 2,
					GA_Top,			win->BorderTop + 1,
					GA_RelWidth,		-(win->BorderLeft + win->BorderRight + 4),
					GA_RelHeight,		-(win->BorderTop + win->BorderBottom + 2),
					GA_TextAttr,		scr->Font,
					GA_RelVerify,		TRUE,
					GA_Immediate,		TRUE,
					GA_ReadOnly,		opts[OPT_READONLY],
					CALENDAR_Multiselect,	opts[OPT_MULTI],
					CALENDAR_Label,		(opts[OPT_LABEL] ? FALSE : TRUE),
					CALENDAR_Labels,	(opts[OPT_LABELS] ? dlArray : NULL),
					ICA_TARGET,		ICTARGET_IDCMP,
					TAG_DONE))
		{
		    /* Add the gadget */
		    AddGList (win, gad, -1, 1, NULL);
		    RefreshGList (gad, win, NULL, -1);

		    while (going)
		    {
			sigr = Wait ((1L << win->UserPort->mp_SigBit | SIGBREAKF_CTRL_C));

			if (sigr & SIGBREAKF_CTRL_C)
			    going = FALSE;

			while (imsg = (struct IntuiMessage *) GetMsg (win->UserPort))
			{
			    switch (imsg->Class)
			    {
				case IDCMP_CLOSEWINDOW:
				    going = FALSE;
				    break;

				case IDCMP_IDCMPUPDATE:
				    day = GetTagData (CALENDAR_Day, 99, (struct TagItem *) imsg->IAddress);
				    Printf ("%s %ld\n", ((day & 0x100) ? "clear" : "set"), (day & 0xFF));
				    break;

				case IDCMP_VANILLAKEY:
				    switch (imsg->Code)
				    {
					case 'd':
					case 'D':
					    SetGadgetAttrs (gad, win, NULL,
							    GA_Disabled, ((gad->Flags & GFLG_DISABLED) ? 0 : 1),
							    TAG_DONE);
					    break;

					case  27:
					case 'q':
					case 'Q':
					    going = FALSE;
					    break;
				    }
				    break;

				case IDCMP_GADGETUP:
				    g = (struct Gadget *) imsg->IAddress;
				    Printf ("id=%ld code=%ld\n", (ULONG)g->GadgetID, (ULONG)imsg->Code);
				    break;
			    }

			    ReplyMsg ((struct Message *) imsg);
			}
		    }

		    /* Delete the gadget */
		    RemoveGList (win, gad, 1);
		    DisposeObject (gad);
		}

		CloseWindow (win);
	    }
	    else
		Printf ("couldn't open the window\n");

	    CloseLibrary ((struct Library *) cl);
	}
	else
	    Printf ("couldn't open classes:gadgets/calendar.gadget\n");

	FreeArgs (ra);

	CloseLibrary (IntuitionBase);
    }
}

/*****************************************************************************/

/* Try opening the class library from a number of common places */
struct ClassLibrary *openclass (STRPTR name, ULONG version)
{
    struct ExecBase *SysBase = (*((struct ExecBase **) 4));
    struct Library *retval;
    UBYTE buffer[256];

    if ((retval = OpenLibrary (name, version)) == NULL)
    {
	sprintf (buffer, ":classes/%s", name);
	if ((retval = OpenLibrary (buffer, version)) == NULL)
	{
	    sprintf (buffer, "classes/%s", name);
	    retval = OpenLibrary (buffer, version);
	}
    }
    return (struct ClassLibrary *) retval;
}

/*****************************************************************************/

LONG DoClassLibraryMethod (struct ClassLibrary *cl, Msg msg)
{
    LONG (__asm *disp)(register __a0 Class *, register __a2 Object *, register __a1 Msg msg);
    disp = cl->cl_Class->cl_Dispatcher.h_Entry;
    return (*disp)(cl->cl_Class, (Object *) cl->cl_Class, msg);
}
