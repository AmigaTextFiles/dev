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

/* anim_ex.c 19oct89 original code by Dave Lucas.
** rework by CATS
**
** lattice c 5.04
** lc -b1 -cfist -v -y anim_ex.c
** blink FROM LIB:c.o anim_ex.o /animtools/animtools.o LIB LIB:lc.lib TO anim_ex
*/
#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/gels.h>
#include <exec/memory.h>
#include <libraries/dos.h>

#include "/animtools/animtools.h"
#include "/animtools/animtools_proto.h"

#include <stdlib.h>
#include <stdio.h>
#include <proto/all.h>
int CXBRK(void) { return(0); } /* disable lattice CTRL-C handling */

/*--------------------------------------------------------------*/
/* prototypes for the functions in this file.                   */
/*--------------------------------------------------------------*/
struct AnimOb *setupBoing(SHORT dbufing);

WORD bounceORoutine(struct AnimOb *anOb);
WORD goInFrontOfHead(struct AnimComp *aComp);
WORD goBehindHead(struct AnimComp *aComp);

VOID runAnimation(struct Window *win, SHORT dbufing,
				  struct AnimOb **animKey, struct BitMap **myBitMaps);

LONG setupPlanes(struct BitMap *bitMap, LONG depth, LONG width, LONG height);
struct BitMap **setupBitMaps(LONG depth, LONG width, LONG height);
VOID freePlanes(struct BitMap *bitMap, LONG depth, LONG width, LONG height);
VOID freeBitMaps(struct BitMap **myBitMaps,
					LONG depth, LONG width, LONG height);
struct GelsInfo *setupDisplay(struct Window **win, SHORT dbufing,
							  struct BitMap **myBitMaps);

VOID DrawGels(struct Window *win, struct AnimOb **animKey,
			  SHORT dbufing, WORD *toggleFrame, struct BitMap **myBitMaps);

/*--------------------------------------------------------------*/
/* animation and screen constants.                              */
/*--------------------------------------------------------------*/
#define ANFS	ANFRACSIZE
#define BNFS	(ANFRACSIZE-2)
#define CNFS	(ANFRACSIZE-2)

/* These are used for MeMask (1 << ID_xxx) */
#define ID_BORDER 0
#define ID_BNG    4

#define SBMWIDTH  320  /* My screen size constants. */
#define SBMHEIGHT 200
#define SBMDEPTH    4
#define SCRNMODE NULL  /* (HIRES | LACE) for NewScreen, ends up in view.*/

#define RBMWIDTH  320  /* My raster size constants. (These CAN differ) */
#define RBMHEIGHT 200
#define RBMDEPTH    4

/*--------------------------------------------------------------*/
/* global data for libraries and display.                       */
/*--------------------------------------------------------------*/
struct NewScreen ns =
	{
	0, 0, SBMWIDTH, SBMHEIGHT, SBMDEPTH, 0, 0, SCRNMODE,
	CUSTOMSCREEN | SCREENQUIET, NULL, NULL, NULL, NULL
	};

/* this is a little window that will let us get a CLOSEWINDOW message */
struct NewWindow nw =
	{
	0, 0, 25, 12, 0, 0, CLOSEWINDOW,
	WINDOWCLOSE | BORDERLESS | RMBTRAP, NULL, NULL, NULL, NULL,
	NULL, 0, 0, SBMWIDTH, SBMHEIGHT-1, CUSTOMSCREEN
	};

struct IntuitionBase *IntuitionBase	= NULL;
struct GfxBase		 *GfxBase		= NULL;

int return_code;

/*--------------------------------------------------------------*/
/* constants for the boing ball and sattellites.                */
/*--------------------------------------------------------------*/
#define BNG3RINGY		0
#define BNG3RINGX		0
#define BNG3COUNT		6
#define BNG3HEIGHT		25
#define BNG3WIDTH		32
#define BNG3DEPTH		1
#define BNG3WWIDTH		((BNG3WIDTH + 15) / 16)

#define SATCOUNT		16
#define SATHEIGHT		5
#define SATWIDTH		5
#define SATDEPTH		2
#define SATWWIDTH		((SATWIDTH + 15) / 16)

#include "image_boing.h"

NEWBOB newBoingBob =
	{
	NULL, BNG3WWIDTH, BNG3HEIGHT, BNG3DEPTH, 0x2, 0xC,
	SAVEBACK | OVERLAY, 0, RBMDEPTH, 0,0, (1L<<ID_BORDER), (1L<<ID_BNG),
	};
NEWANIMSEQ newBoingSeq =
	{
	NULL, (WORD *)boing3Image, boing3XTranses, boing3YTranses,
	boing3Times, boing3CRoutines, 0, BNG3COUNT, 0,
	};

NEWBOB newSatABob =
	{
	NULL, SATWWIDTH, SATHEIGHT, SATDEPTH, 0xC, 0x0,
	SAVEBACK | OVERLAY, 0, RBMDEPTH, 0,0, (1L<<ID_BORDER), (1L<<ID_BNG),
	};
NEWANIMSEQ newSatASeq =
	{
	NULL, (WORD *)satImage, satAXTranses, satAYTranses,
	satTimes, satACRoutines, 0, SATCOUNT, 1,
	};
NEWBOB newSatBBob =
	{
	NULL, SATWWIDTH, SATHEIGHT, SATDEPTH, 0xC, 0x3,
	SAVEBACK | OVERLAY, 0, RBMDEPTH, 0,0, (1L<<ID_BORDER), (1L<<ID_BNG),
	};
NEWANIMSEQ newSatBSeq =
	{
	NULL, (WORD *)satImage, satBXTranses, satBYTranses,
	satTimes, satBCRoutines, 0, SATCOUNT, 1,
	};
NEWBOB newSatCBob =
	{
	NULL, SATWWIDTH, SATHEIGHT, SATDEPTH, 0x3, 0x0,
	SAVEBACK | OVERLAY, 0, RBMDEPTH, 0,0, (1L<<ID_BORDER), (1L<<ID_BNG),
	};
NEWANIMSEQ newSatCSeq =
	{
	NULL, (WORD *)satImage, satCXTranses, satCYTranses,
	satTimes, satCCRoutines, 0, SATCOUNT, 1,
	};

/*--------------------------------------------------------------*/
/*--------------------------------------------------------------*/
/*                      PROCEDURES                              */
/*--------------------------------------------------------------*/
/*--------------------------------------------------------------*/

/*--------------------------------------------------------------
** setupBoing() - allocate and initialize an object that will
** display as a boing ball with orbiting sattellites.
**
** this is an animation object with four animation sequences.
** (boing and three sattellites.)
** (note that the sattellites all share the same single image data.)
**
** return NULL on failure.
*/
struct AnimOb *setupBoing(SHORT dbufing)
{
struct AnimOb	*bngOb;
struct AnimComp *bngComp;
struct AnimComp *satAComp;
struct AnimComp *satBComp;
struct AnimComp *satCComp;

if (NULL != (bngOb = AllocMem((LONG)sizeof(struct AnimOb), MEMF_CLEAR)))
	{
	bngOb->NextOb		= NULL;
	bngOb->PrevOb		= NULL;
	bngOb->Clock		= 0;
	bngOb->AnY			= 50;
	bngOb->AnX			= 50;
	bngOb->AnOldY		= bngOb->AnY;
	bngOb->AnOldX		= bngOb->AnX;
	bngOb->YVel			= 3 << ANFRACSIZE;
	bngOb->XVel			= 3 << ANFRACSIZE;
	bngOb->YAccel		= 0;
	bngOb->XAccel		= 0;
	bngOb->RingYTrans	= BNG3RINGY << ANFRACSIZE;
	bngOb->RingXTrans	= BNG3RINGX << ANFRACSIZE;
	bngOb->AnimORoutine	= bounceORoutine;
	bngOb->AUserExt		= 0;

	newBoingBob.nb_DBuf    = dbufing;
	newBoingSeq.nas_HeadOb = bngOb;

	/* these routines are called when a specific comp in a sequence is
	** drawn.  sattellite A will go in front when the 5th (counting from
	** zero) comp is drawn.
	*/
	satACRoutines[4]	  = goInFrontOfHead;
	satACRoutines[12]	  = goBehindHead;
	satBCRoutines[8]      = goInFrontOfHead;
	satBCRoutines[0]      = goBehindHead;
	satCCRoutines[4]      = goInFrontOfHead;
	satCCRoutines[12]     = goBehindHead;

	/* set up the double buf flag and pointer to the Head Object.
	** these are not known until run time.
	*/
	newSatABob.nb_DBuf	  = dbufing;
	newSatBBob.nb_DBuf	  = dbufing;
	newSatCBob.nb_DBuf	  = dbufing;
	newSatASeq.nas_HeadOb = bngOb;
	newSatBSeq.nas_HeadOb = bngOb;
	newSatCSeq.nas_HeadOb = bngOb;

	if (NULL != (bngComp = makeSeq(&newBoingBob, &newBoingSeq)))
		{
		/* set RINGTRIGGER for the first comp in the sequence.
		** this will cause RingYTrans and RingXTrans to be added to
		** the object position when this comp is drawn.
		** (Here they are zero, so this could be taken out.)
		*/
		bngComp->Flags |= RINGTRIGGER;
		bngOb->HeadComp = bngComp;

		if (NULL != (satAComp = makeSeq(&newSatABob, &newSatASeq)))
			{
			/* set up the drawing precedence for the bobs */
			bngComp->AnimBob->Before = satAComp->AnimBob;
			satAComp->AnimBob->After = bngComp->AnimBob;

			if (NULL != (satBComp = makeSeq(&newSatBBob, &newSatBSeq)))
				{
				satAComp->AnimBob->Before = satBComp->AnimBob;
				satBComp->AnimBob->After = satAComp->AnimBob;

				if (NULL != (satCComp = makeSeq(&newSatCBob, &newSatCSeq)))
					{
					satBComp->AnimBob->Before = satCComp->AnimBob;
					satCComp->AnimBob->After = satBComp->AnimBob;

					/* connect all of the head comps (one for each sequence)
					** together to form a single animation object.
					*/
					bngComp->NextComp  = satAComp;
					bngComp->PrevComp  = NULL;

					satAComp->NextComp = satBComp;
					satAComp->PrevComp = bngComp;

					satBComp->NextComp = satCComp;
					satBComp->PrevComp = satAComp;

					satCComp->NextComp = NULL;
					satCComp->PrevComp = satBComp;

					return(bngOb);
					}
				/* if something failed, close everything */
				freeSeq(satBComp,RBMDEPTH);
				}
			freeSeq(satAComp,RBMDEPTH);
			}
		freeSeq(bngComp,RBMDEPTH);
		}
	FreeMem(bngOb, (LONG)sizeof(struct AnimOb));
	}
return_code = RETURN_WARN;
return(NULL);
}

/*--------------------------------------------------------------
** This ORoutine makes the Object Bounce off Borders.
*/
WORD bounceORoutine(struct AnimOb *anOb)
{
SHORT Y;
SHORT X;

Y = anOb->AnY >> ANFRACSIZE;
X = anOb->AnX >> ANFRACSIZE;

if ((Y<0 && anOb->YVel < 0) ||
	((Y+anOb->HeadComp->AnimBob->BobVSprite->Height > RBMHEIGHT) &&
	 (anOb->YVel > 0)))
	{
	anOb->YVel = -(anOb->YVel);
	}

if (((X < 0) && (anOb->XVel < 0)) ||
	((X + (anOb->HeadComp->AnimBob->BobVSprite->Width << 4) > RBMWIDTH) &&
	 (anOb->XVel > 0)))
	{
	anOb->XVel = -(anOb->XVel);
	}
return(0) ;
}

/*--------------------------------------------------------------
** This CRoutine rearranges Bob Before and After pointers in a
** way that makes the Component passed look like it is in front
** of its' head component.
** 
** Used for Boing satelittes.
** 
** So that they go in front of AND behind the boing ball.
*/
WORD goInFrontOfHead(struct AnimComp *aComp)
{
/* remove bob and close up hole */
if (aComp->AnimBob->Before != NULL)
	aComp->AnimBob->Before->After = aComp->AnimBob->After;
if (aComp->AnimBob->After != NULL)
	aComp->AnimBob->After->Before = aComp->AnimBob->Before;

/* reinsert bob in front of HeadOb (it will be drawn after Head) */
aComp->AnimBob->Before = aComp->HeadOb->HeadComp->AnimBob->Before;
aComp->AnimBob->After = aComp->HeadOb->HeadComp->AnimBob;
if (aComp->AnimBob->Before != NULL)
	aComp->AnimBob->Before->After = aComp->AnimBob;
aComp->HeadOb->HeadComp->AnimBob->Before = aComp->AnimBob;

return(0) ;
}

/*--------------------------------------------------------------
** This CRoutine rearranges Bob Before and After pointers in a
** way that makes the Component passed look like it is behind
** its' head component.
*/
WORD goBehindHead(struct AnimComp *aComp)
{
/* remove bob and close up hole */
if (aComp->AnimBob->Before != NULL)
	aComp->AnimBob->Before->After = aComp->AnimBob->After;
if (aComp->AnimBob->After != NULL)
	aComp->AnimBob->After->Before = aComp->AnimBob->Before;

/* reinsert bob in behind of HeadOb (it will be drawn before Head) */
aComp->AnimBob->After = aComp->HeadOb->HeadComp->AnimBob->After;
aComp->AnimBob->Before = aComp->HeadOb->HeadComp->AnimBob;
if (aComp->AnimBob->After != NULL)
	aComp->AnimBob->After->Before = aComp->AnimBob;
aComp->HeadOb->HeadComp->AnimBob->After = aComp->AnimBob;

return(0) ;
}

/*--------------------------------------------------------------
**
*/
VOID runAnimation(struct Window *win,
				  SHORT dbufing,
				  struct AnimOb **animKey,
				  struct BitMap **myBitMaps)
{
struct IntuiMessage  *intuiMsg;
WORD toggleFrame;

toggleFrame = 0;

/* everything opened, and allocated, and initialized.
** hang out, move the gels, tell the system to redraw them,
** and let the collision and anim routines bounce them about.
**
** check after each draw for CLOSEWINDOW events.
** go away when we get one.
*/
for (;;)
	{
	/* All the work done here */
	DrawGels(win, animKey, dbufing, &toggleFrame, myBitMaps);

	while (intuiMsg = (struct IntuiMessage *)GetMsg(win->UserPort))
		{
		if (intuiMsg->Class == CLOSEWINDOW)
			{
			ReplyMsg((struct Message *)intuiMsg);
			return;
			}
		ReplyMsg((struct Message *)intuiMsg);
		}
	}
}

/*---------------------------------------------------------
** allocate the bit planes for a screen bit map.
*/
LONG setupPlanes(struct BitMap *bitMap,
				 LONG depth, LONG width, LONG height)
{
SHORT plane_num ;

for (plane_num = 0; plane_num < depth; plane_num++)
	{
	if (NULL != (bitMap->Planes[plane_num] =
					(PLANEPTR)AllocRaster(width, height)))
		BltClear(bitMap->Planes[plane_num], (width / 8) * height, 1);
	else
		{
		freePlanes(bitMap, depth, width, height);
		return_code = RETURN_WARN;
		return(NULL);
		}
	}
return(TRUE);
}

/*---------------------------------------------------------
** allocate the bit maps for a double buffered screen.
*/
struct BitMap **setupBitMaps(LONG depth, LONG width, LONG height)
{
/* this must be static -- it cannot go away when the routine exits. */
static struct BitMap *myBitMaps[2];

if (NULL != (myBitMaps[0] =
		(struct BitMap *)AllocMem((LONG)sizeof(struct BitMap), MEMF_CLEAR)))
	{
	if (NULL != (myBitMaps[1] =
		(struct BitMap *)AllocMem((LONG)sizeof(struct BitMap), MEMF_CLEAR)))
		{
		InitBitMap(myBitMaps[0], depth, width, height);
		InitBitMap(myBitMaps[1], depth, width, height);

		if (NULL != setupPlanes(myBitMaps[0], depth, width, height))
			{
			if (NULL != setupPlanes(myBitMaps[1], depth, width, height))
				return(myBitMaps);

			freePlanes(myBitMaps[0], depth, width, height);
			}
		FreeMem(myBitMaps[1], (LONG)sizeof(struct BitMap));
		}
	FreeMem(myBitMaps[0], (LONG)sizeof(struct BitMap));
	}
return_code = RETURN_WARN;
return(NULL);
}

/*--------------------------------------------------------------
** free up the memory allocated by setupPlanes().
*/
VOID	freePlanes(struct BitMap *bitMap,
				   LONG depth, LONG width, LONG height)
{
SHORT plane_num ;

for (plane_num = 0; plane_num < depth; plane_num++)
	{
	if (NULL != bitMap->Planes[plane_num])
		FreeRaster(bitMap->Planes[plane_num], width, height);
	}
}

/*--------------------------------------------------------------
** free up the memory allocated by setupBitMaps().
*/
VOID	freeBitMaps(struct BitMap **myBitMaps,
					LONG depth, LONG width, LONG height)
{
freePlanes(myBitMaps[0], depth, width, height);
freePlanes(myBitMaps[1], depth, width, height);

FreeMem(myBitMaps[0], (LONG)sizeof(struct BitMap));
FreeMem(myBitMaps[1], (LONG)sizeof(struct BitMap));
}

/*--------------------------------------------------------------
** setup the screen and window for the animation.
*/
struct GelsInfo *setupDisplay(struct Window **win,
							  SHORT dbufing,
							  struct BitMap **myBitMaps)
{
struct GelsInfo	   *gInfo;
struct Screen	   *screen;
struct ViewPort	   *vport;
struct RastPort    *rport;

if (dbufing)
	{
	/* Screen type. We alloc two BitMaps. See DBLBUF comments. */
	ns.Type |= CUSTOMBITMAP;
	ns.CustomBitMap = myBitMaps[0];
	}

if ((screen = (struct Screen *)OpenScreen(&ns)) != NULL)
	{
	vport = &screen->ViewPort;
	rport = &screen->RastPort;

	SetRGB4(vport, 0x0, 0x0, 0x0, 0x0); /* Black			*/
	SetRGB4(vport, 0x1, 0x0, 0x6, 0x0); /* dk green			*/
	SetRGB4(vport, 0x2, 0x0, 0x9, 0x0); /* med green		*/
	SetRGB4(vport, 0x3, 0x0, 0xC, 0x0); /* lt green			*/
	SetRGB4(vport, 0x4, 0x1, 0x1, 0x7); /* dk blue			*/
	SetRGB4(vport, 0x5, 0x7, 0x0, 0x8); /* dk violet		*/
	SetRGB4(vport, 0x6, 0x6, 0x6, 0x6); /* dk grey			*/
	SetRGB4(vport, 0x7, 0x7, 0x1, 0x0); /* dk red			*/
	SetRGB4(vport, 0x8, 0x3, 0x3, 0xB); /* med blue			*/
	SetRGB4(vport, 0x9, 0xB, 0x0, 0xC); /* med violet		*/
	SetRGB4(vport, 0xA, 0x9, 0x9, 0x9); /* med grey			*/
	SetRGB4(vport, 0xB, 0xB, 0x0, 0x0); /* med red			*/
	SetRGB4(vport, 0xC, 0x5, 0x5, 0xF); /* lt blue			*/
	SetRGB4(vport, 0xD, 0xE, 0x0, 0xF); /* lt violet		*/
	SetRGB4(vport, 0xE, 0xF, 0xF, 0xF); /* lt grey (white)	*/
	SetRGB4(vport, 0xF, 0xF, 0x0, 0x0); /* lt red			*/

	/* put some stuff in the background, so we can
	** see that it does not get destroyed.
	*/
	SetAPen(rport, 0xA);
	SetDrMd(rport, JAM1);
	Move(rport, 70, 105);
	Text(rport, "Animation Example...", 20);

	nw.Screen = screen;
	if ((*win = (struct Window *)OpenWindow(&nw)) != NULL)
		{
		if (dbufing)
			{
			(*win)->WScreen->RastPort.Flags = DBUFFER;

			/* copy the rast port data into the alternate rast port */
			(*win)->WScreen->RastPort.BitMap = myBitMaps[1];
			BltBitMapRastPort(myBitMaps[0], 0,0, &(*win)->WScreen->RastPort,
						0,0, RBMWIDTH, RBMHEIGHT, 0xC0);
			(*win)->WScreen->RastPort.BitMap = myBitMaps[0];
			}

		/* set up the gels system.
		** 0xFC says: when you allocate sprites for me, don't ever use
		** sprites zero or one. This guarantees that sprite zero, the
		** intuition pointer, stays intact. Remember sprite one shares
		** colors with sprite zero.
		*/
		if (NULL != (gInfo = setupGelSys(&(*win)->WScreen->RastPort, 0xFC)))
			return(gInfo);

		CloseWindow(*win);
		}
	CloseScreen(screen);
	}
return_code = RETURN_WARN;
return(NULL);
}

/*--------------------------------------------------------------
** draw all of those animation objects.
*/
VOID DrawGels(struct Window *win,
			  struct AnimOb **animKey,
			  SHORT dbufing,
			  WORD *toggleFrame,
			  struct BitMap **myBitMaps)
{
Animate(animKey, &win->WScreen->RastPort);

SortGList(&win->WScreen->RastPort);   /* Put the list in order. */
DoCollision(&win->WScreen->RastPort); /* Collision routines may called now */
SortGList(&win->WScreen->RastPort);	  /* Put the list in order. */

if (dbufing)
	win->WScreen->ViewPort.RasInfo->BitMap = myBitMaps[*toggleFrame];

/* Draw 'em. */
DrawGList(&win->WScreen->RastPort, &win->WScreen->ViewPort);

/* if single buffered and using TRUE VSprites, you have to do a
** MrgCop() & LoadView().  Under Intuition use RethinkDisplay().
** if this is not done, then the vsprites will not be updated.
*/

if (dbufing)
	{
	MakeScreen(win->WScreen);	/* Tell intuition to do it's stuff. */
	RethinkDisplay();			/* Intuition compatible MrgCop & LoadView */
								/*     also does a WaitTOF()              */

	*toggleFrame ^= 1;
	/* Flip to the next BitMap. */
	win->WScreen->RastPort.BitMap = myBitMaps[*toggleFrame];
	}
else
	WaitTOF();
}

/*--------------------------------------------------------------
** main routine.  setup and run the animation.
** clean up all resources when done or on any error.
*/
VOID main(int argc, char **argv)
{
struct BitMap	**myBitMaps;
struct AnimOb	 *boingOb;
struct Window	 *win;
struct Screen	 *screen;
struct GelsInfo	 *gInfo;
struct AnimOb	 *animKey;
SHORT dbufing;

return_code = RETURN_OK; /* a global variable, yech! */

printf("Program will run double buffered if there are\n");
printf("any command line arguements.\n");

if (argc > 1)
	dbufing = 1;  /* run double buffered when arguements */
else
	dbufing = 0;  /* not double buff */

if (NULL == (IntuitionBase = (struct IntuitionBase *)
		OpenLibrary("intuition.library", 33L)))
	return_code = RETURN_FAIL;
else
	{
	if (NULL == (GfxBase = (struct GfxBase *)
			OpenLibrary("graphics.library", 33L)))
		return_code = RETURN_FAIL;
	else
		{
		if ((!dbufing) ||
			(NULL != (myBitMaps=setupBitMaps(RBMDEPTH,RBMWIDTH,RBMHEIGHT))))
			{
			if (NULL != (gInfo = setupDisplay(&win,dbufing,myBitMaps)))
				{
				InitAnimate(&animKey);
				/* Simple sequenced animation. (Boing ball)
				** smaller components animated using XTrans and YTrans.
				** (tiny orbiting satellites)
				*/
				if (NULL != (boingOb = setupBoing(dbufing)))
					{
					AddAnimOb(boingOb, &animKey, &win->WScreen->RastPort);
					runAnimation(win, dbufing, &animKey, myBitMaps);
					freeOb(boingOb, RBMDEPTH);
					}

				cleanupGelSys(gInfo, &win->WScreen->RastPort);
				screen = win->WScreen;
				CloseWindow(win);
				CloseScreen(screen);
				}

			if (dbufing)
				freeBitMaps(myBitMaps, RBMDEPTH, RBMWIDTH, RBMHEIGHT);
			}
		CloseLibrary((struct Library *)GfxBase);
		}
	CloseLibrary((struct Library *)IntuitionBase);
	}
exit(return_code);
}
