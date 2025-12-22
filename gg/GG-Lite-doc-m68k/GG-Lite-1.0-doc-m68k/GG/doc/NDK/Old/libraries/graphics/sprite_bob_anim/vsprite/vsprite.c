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

/* vsprite.c 19oct89 CATS
**
** lattice c 5.04
** lc -b1 -cfist -v -y vsprite.c
** blink FROM LIB:c.o vsprite.o /animtools/animtools.o LIB LIB:lc.lib TO vsprite
*/
#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/gels.h>
#include <graphics/collide.h>
#include <exec/memory.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdlib.h>

#include "/animtools/animtools.h"
#include "/animtools/animtools_proto.h"

VOID borderCheck(struct VSprite *hitVSprite, LONG borderflags);
VOID process_window(struct Window *win, struct VSprite *MyVSprite);
VOID do_VSprite(struct Window *win);
VOID vspriteDrawGList(struct Window *win);

struct GfxBase		 *GfxBase;       /* pointer to Graphics library */
struct IntuitionBase *IntuitionBase; /* pointer to Intuition library */

int return_code;

/* number of lines in the vsprite */
#define GEL_SIZE	4

/* vsprite data - there are two sets that are alternated between.
** note that this data is always displayed as low resolution.
*/
WORD chip vsprite_data1[2 * GEL_SIZE] =
	{ 0x7ffe, 0x80ff, 0x7c3e, 0x803f, 0x7c3e, 0x803f, 0x7ffe, 0x80ff, };

WORD chip vsprite_data2[2 * GEL_SIZE] =
	{ 0x7ffe, 0xff01, 0x7c3e, 0xfc01, 0x7c3e, 0xfc01, 0x7ffe, 0xff01, };

WORD mySpriteAltColors[] =
	{ 0x000f, 0x0f00, 0x0ff0 };

WORD mySpriteColors[] =
	{ 0x0000, 0x00f0, 0x0f00 };

/* information for the new vsprite */
NEWVSPRITE myNewVSprite =
	{
	vsprite_data2,	/* image data								*/
	mySpriteColors,	/* sprite color array						*/
	1,				/* word width (must be 1 for true vsprite)	*/
	GEL_SIZE,		/* line height								*/
	2,				/* image depth (must be 2 for true vsprite)	*/
	160, 100,		/* x, y position							*/
	VSPRITE,		/* flags (VSPRITE == true vsprite)			*/
	1 << BORDERHIT,	/* hit mask									*/
	0,				/* me mask									*/
	};

/* information for the new window */
struct NewWindow myNewWindow =
	{
	80, 20, 400, 150, -1, -1, CLOSEWINDOW | INTUITICKS,
	ACTIVATE | WINDOWCLOSE | WINDOWDEPTH | RMBTRAP,
	NULL, NULL, "VSprite", NULL, NULL, 0, 0, 0, 0, WBENCHSCREEN
	};

/*-------------------------------------------------------------
**
*/
VOID vspriteDrawGList(struct Window *win)
{
SortGList(win->RPort);
DrawGList(win->RPort, ViewPortAddress(win));
/* These calls are not intuition compatible...
**    MrgCop(view);
**    LoadView(view);
** use RethinkDisplay() in intuition environment.
*/
RethinkDisplay();
/* WaitTOF(); done by RethinkDisplay */
}

/*-------------------------------------------------------------
** collision routine for vsprite hitting border.
** note that when the collision is vsprite to vsprite (or bob
** to bob, bob to animOb, etc), then the parameters are both
** pointers to a vsprite:
**
**  VOID collCheck(struct VSprite *vsp1,struct VSprite *vsp2)
*/
VOID	borderCheck(struct VSprite *hitVSprite, LONG borderflags)
{
if (borderflags & RIGHTHIT)
	{
	hitVSprite->SprColors = mySpriteAltColors;
	hitVSprite->VUserExt  = -40;
	}
if (borderflags & LEFTHIT)
	{
	hitVSprite->SprColors = mySpriteColors;
	hitVSprite->VUserExt  = 20;
	}
}

/*-------------------------------------------------------------
** process window and dynamically change vsprite:
** - get messages.
** - go away on CLOSEWINDOW.
** - update and redisplay vsprite on INTUITICKS.
** - wait for more messages.
*/
VOID process_window(struct Window *win, struct VSprite *myVSprite)
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

		/* must be an INTUITICKS:  change x and y values on the fly.
		** note offset by window left and top edge--sprite relative
		** to the screen, not window.
		*/
		myVSprite->X = win->LeftEdge + msg->MouseX + myVSprite->VUserExt;
		myVSprite->Y = win->TopEdge  + msg->MouseY + 1;
		ReplyMsg((struct Message *)msg);
		}

	/* got a message, change image data on the fly */
	myVSprite->ImageData = (myVSprite->ImageData == vsprite_data1) ?
		vsprite_data2 : vsprite_data1;

	SortGList(win->RPort);
	DoCollision(win->RPort);
	vspriteDrawGList(win);
	}
}

/*-------------------------------------------------------------
** working with the vsprite:
** - setup the gel system, and get a new vsprite (makeVSprite()).
** - add the vsprite to the system and display.
** - use the vsprite.
** - when done, remove vsprite and update the display without the vsprite.
** - cleanup everything.
*/
VOID do_VSprite(struct Window *win)
{
struct VSprite	   *myVSprite;
struct GelsInfo	   *my_ginfo;

if (NULL == (my_ginfo = setupGelSys(win->RPort, 0xfc)))
	return_code = RETURN_WARN;
else
	{
	if (NULL == (myVSprite = makeVSprite(&myNewVSprite)))
		return_code = RETURN_WARN;
	else
		{
		AddVSprite(myVSprite, win->RPort);
		vspriteDrawGList(win);

		myVSprite->VUserExt = 20;
		SetCollision(BORDERHIT, borderCheck, win->RPort->GelsInfo);

		process_window(win, myVSprite);

		RemVSprite(myVSprite);
		freeVSprite(myVSprite);
		}
	vspriteDrawGList(win);
	cleanupGelSys(my_ginfo,win->RPort);
	}
}

/*-------------------------------------------------------------
** example vsprite program:
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
			return_code = RETURN_WARN;
		else
			{
			do_VSprite(win);

			CloseWindow(win);
			}
		CloseLibrary(IntuitionBase);
		}
	CloseLibrary(GfxBase);
	}
exit(return_code);
}
