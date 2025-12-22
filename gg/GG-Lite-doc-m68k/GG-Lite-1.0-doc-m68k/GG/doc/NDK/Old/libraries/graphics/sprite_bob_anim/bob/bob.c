/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

/* bob.c 19oct89
**
** lattice c 5.04
** lc -b1 -cfist -v -y bob.c
** blink FROM LIB:c.o bob.o /animtools/animtools.o LIB LIB:lc.lib TO bob
*/
#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/gels.h>
#include <exec/memory.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdlib.h>

#include "/animtools/animtools.h"
#include "/animtools/animtools_proto.h"

VOID bobDrawGList(struct RastPort *rport, struct ViewPort *vport);
VOID process_window(struct Window *win, struct Bob *myBob);
VOID do_Bob(struct Window *win);

struct GfxBase		 *GfxBase;       /* pointer to Graphics library */
struct IntuitionBase *IntuitionBase; /* pointer to Intuition library */

int return_code;

/* number of lines in the bob */
#define GEL_SIZE	4

/* bob data - there are two sets that are alternated between.
** note that this data is at the resolution of the screen.
*/
WORD chip bob_data1[2 * 2 * GEL_SIZE] =
	{ /* data is 2 planes by 2 words by GEL_SIZE lines */
	/* plane 1 */
	0xffff, 0x0003, 0xfff0, 0x0003, 0xfff0, 0x0003, 0xffff, 0x0003,
	/* plane 2 */
	0x3fff, 0xfffc, 0x3ff0, 0x0ffc, 0x3ff0, 0x0ffc, 0x3fff, 0xfffc,
	};

WORD chip bob_data2[2 * 2 * GEL_SIZE] =
	{ /* data is 2 planes by 2 words by GEL_SIZE lines */
	/* plane 1 */
	0xc000, 0xffff, 0xc000, 0x0fff, 0xc000, 0x0fff, 0xc000, 0xffff,
	/* plane 2 */
	0x3fff, 0xfffc, 0x3ff0, 0x0ffc, 0x3ff0, 0x0ffc, 0x3fff, 0xfffc,
	};

/* information for the new bob
** structure defined in animtools.h
*/
NEWBOB myNewBob =
	{
	bob_data2,			/* initial image			*/
	2,					/* WORD width				*/
	GEL_SIZE,			/* line height				*/
	2,					/* image depth				*/
	3, 0,				/* plane pick, plane on off	*/
	SAVEBACK | OVERLAY,	/* vsprite flags			*/
	0,					/* dbuf (0 == false)		*/
	2,					/* raster depth				*/
	160, 100,			/* x,y position				*/
	0,0,				/* hit mask, me mask		*/
	};

/* information for the new window */
struct NewWindow myNewWindow =
	{
	80, 20, 400, 150, -1, -1, CLOSEWINDOW | INTUITICKS,
	ACTIVATE | WINDOWCLOSE | WINDOWDEPTH | RMBTRAP,
	NULL, NULL, "Bob", NULL, NULL, 0, 0, 0, 0, WBENCHSCREEN
	};

/*-------------------------------------------------------------
** draw the bobs into the rast port.
*/
VOID bobDrawGList(struct RastPort *rport, struct ViewPort *vport)
{
/* only need to MrgCop() LoadView() if using TRUE VSprites */
SortGList(rport);
DrawGList(rport, vport);
WaitTOF() ;
}

/*-------------------------------------------------------------
** process window and dynamically change bob:
** - get messages.
** - go away on CLOSEWINDOW.
** - update and redisplay bob on INTUITICKS.
** - wait for more messages.
*/
VOID process_window(struct Window *win, struct Bob *myBob)
{
struct IntuiMessage *msg;

FOREVER
	{
	Wait(1L << win->UserPort->mp_SigBit);

	while (NULL != (msg = (struct IntuiMessage *)GetMsg(win->UserPort)))
		{
		/* only CLOSEWINDOW and INTUITICKS are active */
		if (msg->Class == CLOSEWINDOW)
			{
			ReplyMsg((struct Message *)msg);
			return;
			}

		/* must be INTUITICKS:  change x and y values on the fly
		** note:  do not have to add window offset, bob is relative
		** to the window (sprite relative to screen).
		*/
		myBob->BobVSprite->X = msg->MouseX + 20;
		myBob->BobVSprite->Y = msg->MouseY + 1;
		ReplyMsg((struct Message *)msg);
		}

	/* after getting a message, change image data on the fly */
	myBob->BobVSprite->ImageData =
		(myBob->BobVSprite->ImageData == bob_data1) ? bob_data2 : bob_data1;

	InitMasks(myBob->BobVSprite); /* set up masks for new image */
	bobDrawGList(win->RPort, ViewPortAddress(win));
	}
}

/*-------------------------------------------------------------
** working with the bob:
** - setup the gel system, and get a new bob (makeBob()).
** - add the bob to the system and display.
** - use the bob.
** - when done, remove the bob and update the display without the bob.
** - cleanup everything.
*/
VOID do_Bob(struct Window *win)
{
struct Bob	   *myBob;
struct GelsInfo	   *my_ginfo;

if (NULL == (my_ginfo = setupGelSys(win->RPort, 0xfc)))
	return_code = RETURN_WARN;
else
	{
	if (NULL == (myBob = makeBob(&myNewBob)))
		return_code = RETURN_WARN;
	else
		{
		AddBob(myBob, win->RPort);
		bobDrawGList(win->RPort, ViewPortAddress(win));

		process_window(win, myBob);

		RemBob(myBob);
		bobDrawGList(win->RPort, ViewPortAddress(win));

		freeBob(myBob, myNewBob.nb_RasDepth);
		}
	cleanupGelSys(my_ginfo,win->RPort);
	}
}

/*-------------------------------------------------------------
** example bob program:
** - first open up the libraries and a window.
*/
VOID main(int argc, char **argv)
{
struct Window	   *win;

return_code = RETURN_OK;

if (NULL == (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",33L)))
	return_code = RETURN_FAIL;
else
	{
	if (NULL == (IntuitionBase =
			(struct IntuitionBase *)OpenLibrary("intuition.library",33L)))
		return_code = RETURN_FAIL;
	else
		{
		if (NULL == (win = OpenWindow(&myNewWindow)))
			return_code = RETURN_FAIL;
		else
			{
			do_Bob(win);

			CloseWindow(win);
			}
		CloseLibrary(IntuitionBase);
		}
	CloseLibrary(GfxBase);
	}
exit(return_code);
}
