/*
**	$VER: PIPWin 2.6 (13.10.97) by Bernardo Innocenti & Alfonso Caschili
**
**	Use 4 chars wide TABs to read this file.
**
**
**	Introduction
**	============
**
**	This program opens a window on any public screen which shows the
**	contents of a user selected public screen. The window can be
**	resized and scrolled by dragging it with mouse or using the cursor
**	keys.
**
**	The source code shows how to create a resizable window with sliders
**	and how to write a custom `boopsi' class on top of the gadgetclass.
**
**
**	Usage
**	=====
**
**	PipWin SCREEN, PUB/K, DELAY/K, LEFT/K, TOP/K, WIDTH/K, HEIGHT/K
**
**	SCREEN    - the name of the public screen to monitorize
**	PUBSCREEN - name of the public screen where the window should open
**	DELAY     - delay between window refreshes, in tenth of seconds
**	            (default: 2 seconds)
**	X,Y,W,H   - window geometry (in pixel units)
**
**
**	Compiling
**	=========
**
**	This project can be compiled with SAS/C 6.58 or better,
**	GCC 2.7.2.1 or better and StormC 2.00.14 or better.
**	You get the smallest executable with SAS/C. GCC will give
**	you quite a lot of warnings with the tag calls. Don't worry about them.
**
**
**	History
**	=======
**
**	1.0 (3.12.95) -- First version by Alfonso Caschili
**
**	1.1 (27.3.96) -- Major revamp by Bernardo Innocenti
**
**		- Source cleaned up, re-indented and commented the way I like it :)
**
**		- Fixed a bug with CTRL-C handling
**
**		- Does not keep a lock on the screen where the window opens for all the time
**
**		- Argument parsing improved a bit
**
**		- Does not need C startup code anymore (saves some KB)
**
**		- Window positioning and sizing is a bit smarter
**
**		- Does not refresh the window twice on startup
**
**
**	2.0 (14.4.96) -- Rewritten using a `boopsi' class by Bernardo Innocenti
**
**		- Created the PIP 'boopsi' class
**
**		- Added sliders and buttons in window borders
**
**		- Added no-op backfilling hook (makes resizing and depth arragnging
**		  much faster and less flickering
**
**
**	2.1 (8.5.96)
**
**		- Fixed window positioning bug.  Window was being positioned just below
**		  the screen title bar, but it was looking on the titlebar height of
**		  the screen being captured instead of the screen when the window was
**		  to be opened
**
**		- Changed PATTA_#? attributes to PIPA_#? attributes in the boopsi
**		  interconnection diagram.  PATTA_ is the attribute prefix for the
**		  pattedit.gadget, another boopsi class written by me
**
**		- Changed to always keep a lock on the screen where the window opens.
**		  This is needed because we are trying to free the associated DrawInfo
**		  strucure *after* closing the window.  Without a proper lock, our host
**		  screen could close just after we closed our window, which would make
**		  the parameter we pass to FreeScreenDrawInfo() an invalid pointer
**
**		- Fixed a bug that caused a call to still BltBitMapRastPort() with a
**		  NULL BitMap pointer when the PIPA_BitMap attribute was set to NULL
**
**		- Added error report for bad arguments
**
**
**	2.2 (28.4.97)
**
**		- Added GCC compiler support (untested)
**
**		- Now uses a custom DoMethod() stub (faster than calling amiga.lib one)
**
**		- Fixed the arrow buttons positioning when their width/height is
**		  not the same of the size gadget
**
**	2.3 (10.5.97)
**
**		- Fixed LEFT, TOP, WIDTH & HEIGHT command line arguments. The
**		  OpenPIPWin() function was passing the *pointers* to the LONG
**		  values to OpenWindowTags(). (Riccardo Torrini)
**
**		- Dragging the view to the extreme left or top does no longer send
**		  negative numbers when notifying the sliders.
**
**		- Removed test to check if GetScreenDrawInfo() fails because this
**		  function is always successful
**
**
**	2.4 (15.8.97)
**
**		- Added StormC compiler support
**
**		- GCC support tested: works fine with latest GeekGadgets snapshot
**
**
**	2.5 (15.9.97)
**
**		- Compiled with SAS/C 6.58
**
**		- Improved SMakefile, now PIPWin is not need to be linked with
**		  any static libraries
**
**		- Size reduced even more!
**
**	2.6 (13.10.97)
**
**		- Fixed scroll bars positioning with non standard window
**		  border sizes
**
**		- GCC version can now be built without linking it with libnix
**
**		- Replaced call to RefreshGList() with the new PIPM_Refresh
**		  class method, which in turn calls GM_RENDER with mode GREDRAW_UPDATE.
**
**
**	Known Bugs
**	==========
**
**		- This code has never been tested on V37
**
**
**	To Do
**	=====
**
**		- Add a requester to select a public screen to snoop
**
**		- Allow opening more than one window
**
**		- Workbench startup and ToolTypes parsing
**
**		- Allow zooming into the bitmap
**
**		- Make the pipclass update its imagery automatically at given
**		  time intervals.  This would require creating a Process for each
**		  istance the class, or perhaps one single Process for all objects.
**		  Unfortunately, most gadgetclass methods can not be called by
**		  soft interrupts, so it seems we really need a process :-(
**
**		- This one is very ambitious: it should be possible to forward mouse
**		  and keyboard input to the screen being displayed.  This would allow
**		  the user to actually USE programs without bringing their screens
**		  to front
**
**		- Optimize display scrolling in some special cases.  When the bitmap
**		  of the screen being displayed is not the same format of the bitmap
**		  where the PIP gadget renders (i.e.: they arn't `friend bitmaps'),
**		  some kind of conversion (e.g.: planar to chunky) will be done
**		  transparently by CopyBitMapRastPort().  This operation might be
**		  very slow, making more convenient to ScrollRaster() the existing
**		  image and copy just the part that gets revealed by the scrolling
**
**		- Change the mouse pointer to a grabbing hand while user is dragging
**		  the display
**
**
**	Copyright Notice
**	================
**
**	Copyright © 1995 by Alfonso Caschili <valdus@mbox.vol.it>.
**	Freely Distributable.
**
**	Copyright © 1996,97 by Bernardo Innocenti <bernie@shock.cosmos.it>.
**	Freely Distributable, as long as source code, documentation and
**	executable are kept together.  Permission is granted to release
**	modified versions of this program as long as all existing copyright
**	notices are left intact.
**
*/

#define _ANSI_SOURCE
#define INTUI_V36_NAMES_ONLY
#define __USE_SYSBASE
#define  CLIB_ALIB_PROTOS_H	/* Avoid including this header file because of
							 * conflicting definitions in BoopsiStubs.h
							 */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <dos/rdargs.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <devices/timer.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/utility.h>

#include "CompilerSpecific.h"
#include "Debug.h"
#include "BoopsiStubs.h"

#include "PIPClass.h"


/* OS version */

#ifdef OS30_ONLY
 #define WANTEDLIBVER	39L
#else
 #define WANTEDLIBVER	37L
#endif


/* Local function prototypes */
LONG SAVEDS				 _main			(void);
static struct PIPHandle	*OpenPIPWin		(UBYTE *spyscreen, UBYTE *pubscreen,
										ULONG *left, ULONG *top, ULONG *width, ULONG *height);
static void				 ClosePIPWin	(struct PIPHandle *piphandle);
static struct Gadget	*CreateGadgets	(struct PIPHandle *piphandle);
static void				 DisposeGadgets (struct PIPHandle *piphandle);
static void				 CreateImages	(struct DrawInfo *dri);
static void				 FreeImages		(void);
static Class *			 MakeScrollButtonClass	(void);
static BOOL				 FreeScrollButtonClass	(Class *cl);
static ULONG HOOKCALL	 ScrollButtonDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, struct gpInput *gpi));



/* Definitions for argument parsing */

#define ARGS_TEMPLATE	"SCREEN,PUBSCREEN/K,DELAY/K/N,"				\
						"LEFT/K/N,TOP/K/N,WIDTH/K/N,HEIGHT/K/N"

enum
{
	ARG_SCREEN, ARG_PUBSCREEN, ARG_DELAY,
	ARG_LEFT, ARG_TOP, ARG_WIDTH, ARG_HEIGHT, ARG_COUNT
};


/* Gadgets IDs */

enum
{
	GAD_PIP, GAD_VSLIDER, GAD_HSLIDER,
	GAD_UPBUTTON, GAD_DOWNBUTTON, GAD_LEFTBUTTON, GAD_RIGHTBUTTON,
	GAD_COUNT
};


/* Images IDs */

enum
{
	IMG_UP, IMG_DOWN, IMG_LEFT, IMG_RIGHT, IMG_COUNT
};



/* This structure describes an open PIP window */

struct PIPHandle
{
	struct Window	*Win;
	struct Screen	*Scr;
	struct DrawInfo	*DrawInfo;
	struct Screen	*SpyScr;
	struct Gadget	*Gad[GAD_COUNT];
	APTR			 Model;
};



/* Version tag */

static const UBYTE versiontag[] = "$VER: PIPWin 2.4 (15.9.97) by Bernardo Innocenti & Alfonso Caschili";
static const UBYTE PrgName[] = "PIPWin";



/* Workaround a bug in StormC header file <proto/utility.h> */

#ifdef __STORM__
	#define UTILITYBASETYPE struct Library
#else
	#define UTILITYBASETYPE struct UtilityBase
#endif


/* Library bases */

struct ExecBase			*SysBase;
struct DosLibrary		*DOSBase;
struct IntuitionBase	*IntuitionBase;
struct GfxBase			*GfxBase;
UTILITYBASETYPE			*UtilityBase;



/* Our private `boopsi' classes */

static Class			*PIPClass;
static Class			*ScrollButtonClass;



/* 'boopsi' images for all our windows
 *
 * These variables must be NULL at startup time. We are not
 * going to explicitly initialize them because otherwise
 * Storm C 2.0 would generate a constructor to do it :-)
 * LoasSeg() will clear the BSS data section for us, so
 * these variables are guaranteed to be NULL anyway.
 */
static struct Image		*Img[IMG_COUNT];
static ULONG			 ImgWidth[IMG_COUNT];
static ULONG			 ImgHeight[IMG_COUNT];



/* Attribute translations for object interconnections */

static const ULONG MapPIPToHSlider[] =
{
	PIPA_OffX,			PGA_Top,
	PIPA_Width,			PGA_Total,
	PIPA_DisplayWidth,	PGA_Visible,
	TAG_DONE
};

static const ULONG MapHSliderToPIP[] =
{
	PGA_Top,	PIPA_OffX,
	TAG_DONE
};

static const ULONG MapPIPToVSlider[] =
{
	PIPA_OffY,			PGA_Top,
	PIPA_Height,		PGA_Total,
	PIPA_DisplayHeight,	PGA_Visible,
	TAG_DONE
};


static const ULONG MapVSliderToPIP[] =
{
	PGA_Top,	PIPA_OffY,
	TAG_DONE
};

static const ULONG MapUpButtonToPIP[] =
{
	GA_ID,		PIPA_MoveUp,
	TAG_DONE
};

static const ULONG MapDownButtonToPIP[] =
{
	GA_ID,		PIPA_MoveDown,
	TAG_DONE
};

static const ULONG MapLeftButtonToPIP[] =
{
	GA_ID,		PIPA_MoveLeft,
	TAG_DONE
};

static const ULONG MapRightButtonToPIP[] =
{
	GA_ID,		PIPA_MoveRight,
	TAG_DONE
};



LONG SAVEDS _main (void)

/* Main program entry point.  When linking without startup code, this
 * must be the first function in the first object module listed on the
 * linker command line.  We also need to initialize SysBase and open
 * all needed libraries manually.
 */
{
	struct PIPHandle	*piphandle;
	struct RDArgs		*rdargs;
	struct MsgPort		*TimerMsgPort;
	struct timerequest	*TimerIO;
	LONG				 args[ARG_COUNT] = { 0 };
	LONG				 sigwait, sigrcvd;
	LONG				 secs, micros;
	LONG				 retval	= RETURN_FAIL;
	BOOL				 quit	= FALSE;


	/* Initialize SysBase */
	SysBase = *((struct ExecBase **)4UL);

	if (DOSBase = (struct DosLibrary *) OpenLibrary ("dos.library", 37L))
	{
		if (UtilityBase = (UTILITYBASETYPE *) OpenLibrary ("utility.library", 37L))
		{
			/* Shell arguments parsing */

			if (rdargs = ReadArgs (ARGS_TEMPLATE, args, NULL))
			{
				if (args[ARG_DELAY])
				{
					/* We use utility.library math because it works on 68000 too */
					secs	= UDivMod32 (*((LONG *)args[ARG_DELAY]), 10);
					micros	= UMult32 ((*((LONG *)args[ARG_DELAY]) - UMult32 (secs, 10)), 100000);
				}
				else
				{
					secs	= 2;
					micros	= 0;
				}

				if (IntuitionBase = (struct IntuitionBase *)
					OpenLibrary ("intuition.library", WANTEDLIBVER))
				{
					if (GfxBase = (struct GfxBase *)
						OpenLibrary ("graphics.library", WANTEDLIBVER))
					{
						if (TimerMsgPort = CreateMsgPort())
						{
							if (TimerIO = (struct timerequest *) CreateIORequest (TimerMsgPort, sizeof (struct timerequest)))
							{
								if (!OpenDevice (TIMERNAME, UNIT_VBLANK, (struct IORequest *)TimerIO, 0))
								{
									if (PIPClass = MakePIPClass ())
									{
										if (ScrollButtonClass = MakeScrollButtonClass ())
										{
											if (piphandle = OpenPIPWin ((UBYTE *)args[ARG_SCREEN], (UBYTE *)args[ARG_PUBSCREEN],
												(ULONG *)args[ARG_LEFT], (ULONG *)args[ARG_TOP],
												(ULONG *)args[ARG_WIDTH], (ULONG *)args[ARG_HEIGHT]))
											{
												/* Pre-calculate the signal mask for Wait() */
												sigwait = (1 << TimerMsgPort->mp_SigBit) |
													(1 << piphandle->Win->UserPort->mp_SigBit) |
													SIGBREAKF_CTRL_C;

												/* Send our first IORequest to timer.device */
												TimerIO->tr_node.io_Command	= TR_ADDREQUEST;
												TimerIO->tr_time.tv_secs	= secs;
												TimerIO->tr_time.tv_micro	= micros;
												SendIO ((struct IORequest *)TimerIO);

												/* Now for the main loop.  As you can see, it is really
												 * very compact.  That's the magic of boopsi! :-)
												 */
												while (!quit)
												{
													/* Sleep until something interesting occurs */
													sigrcvd = Wait (sigwait);

													/* Now handle received signals */

													/* Break signal? */
													if (sigrcvd & SIGBREAKF_CTRL_C)
														quit = TRUE;

													/* timer.device? */
													if (sigrcvd & (1 << TimerMsgPort->mp_SigBit))
													{
														/* Update the PIP gadget and send another
														 * request to the timer.device
														 */
														DoGadgetMethod (piphandle->Gad[GAD_PIP], piphandle->Win, NULL,
															PIPM_REFRESH, NULL);

														TimerIO->tr_node.io_Command	= TR_ADDREQUEST;
														TimerIO->tr_time.tv_secs	= secs;
														TimerIO->tr_time.tv_micro	= micros;
														SendIO ((struct IORequest *)TimerIO);
													}

													/* IDCMP message? */
													if (sigrcvd & (1 << piphandle->Win->UserPort->mp_SigBit))
													{
														struct IntuiMessage	*msg;

														while (msg = (struct IntuiMessage *) GetMsg (piphandle->Win->UserPort))
														{
															switch (msg->Class)
															{
																case IDCMP_CLOSEWINDOW:
																	quit = TRUE;
																	break;

																default:
																	break;
															}
															ReplyMsg ((struct Message *) msg);
														}
													}
												} /* End while (!quit) */

												retval = RETURN_OK;

												/* Abort the IORequest sent to the timer.device */
												AbortIO ((struct IORequest *)TimerIO);
												WaitIO ((struct IORequest *)TimerIO);

												ClosePIPWin (piphandle);
											}

											FreeImages ();
											/* This one cannot fail */
											FreeScrollButtonClass (ScrollButtonClass);
										}
										/* This one cannot fail */
										FreePIPClass (PIPClass);
									}
									CloseDevice ((struct IORequest *)TimerIO);
								}
								DeleteIORequest ((struct IORequest *)TimerIO);
							}
							DeleteMsgPort (TimerMsgPort);
						}
						CloseLibrary ((struct Library *)GfxBase);
					}
					CloseLibrary ((struct Library *)IntuitionBase);
				}
				FreeArgs (rdargs);
			}
			else PrintFault (IoErr(), (STRPTR)PrgName);

			CloseLibrary ((struct Library *)UtilityBase);
		}
		CloseLibrary ((struct Library *)DOSBase);
	}

	return retval;
}



#ifndef OS30_ONLY

static ULONG BFHookFunc (void)

/* No-op backfilling hook.  Since we are going to redraw the whole window
 * anyway, we can disable backfilling.  This avoids ugly flashing while
 * resizing or revealing the window.
 *
 * This function does not need the SAVEDS attribute because it makes no
 * references to external data.
 */
{
	return 1;	/* Do nothing */
}

static struct Hook BFHook =
{
	NULL, NULL,	/* h_MinNode	*/
	(ULONG (*)())	BFHookFunc,	/* h_Entry		*/
	NULL,		/* h_SubEntry	*/
	0			/* h_Data		*/
};
#endif /* !OS30_ONLY */



static struct PIPHandle *OpenPIPWin (UBYTE *screen, UBYTE *pubscreen,
	ULONG *left, ULONG *top, ULONG *width, ULONG *height)
{
	struct PIPHandle	*piphandle;
	struct Gadget		*glist;


	if (piphandle = AllocMem (sizeof (struct PIPHandle), MEMF_ANY | MEMF_CLEAR))
	{
		if (piphandle->SpyScr = LockPubScreen (screen))
		{
			if (piphandle->Scr = LockPubScreen (pubscreen))
			{
				if (glist = CreateGadgets (piphandle))
				{
					SetAttrs (glist,
						PIPA_Screen,	piphandle->SpyScr,
						TAG_DONE);

/* I'm using this method because GCC does not support
 * preprocessor directives inside macro arguments.
 */
#ifndef OS30_ONLY
 #define BACKFILL_TAG_VALUE	(IntuitionBase->LibNode.lib_Version < 39) ? &BFHook : LAYERS_NOBACKFILL
#else
 #define BACKFILL_TAG_VALUE	LAYERS_NOBACKFILL
#endif /* !OS30_ONLY */

					if (piphandle->Win = OpenWindowTags (NULL,
						WA_Left,			left ? *left : 0,
						WA_Top,				top ? *top : piphandle->Scr->BarHeight + 1,
						WA_InnerWidth,		width ? *width : piphandle->SpyScr->Width,
						WA_InnerHeight,		height ? *height : piphandle->SpyScr->Height,
						WA_MinWidth,		64,
						WA_MinHeight,		64,
						WA_MaxWidth,		piphandle->SpyScr->Width,
						WA_MaxHeight,		piphandle->SpyScr->Height,
						WA_PubScreen,		piphandle->Scr,
						WA_PubScreenFallBack, TRUE,
						WA_AutoAdjust,		TRUE,
						WA_IDCMP,			IDCMP_CLOSEWINDOW,
						WA_Flags,			WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
											WFLG_SIZEGADGET | WFLG_SIZEBRIGHT | WFLG_SIZEBBOTTOM |
											WFLG_SIMPLE_REFRESH | WFLG_NOCAREREFRESH,
						WA_Gadgets,			glist,
						WA_BackFill,		BACKFILL_TAG_VALUE,
						WA_Title,			piphandle->SpyScr->DefaultTitle,
						WA_ScreenTitle,		versiontag + 6,
						TAG_DONE))

						/* We need to keep our screen locked all the time
						 * because we want to free the associated DrawInfo
						 * *after* the window has been closed and
						 * FreeScreenDrawInfo() wants a pointer to a *valid*
						 * Screen.
						 */
						return piphandle;
#undef BACKFILL_TAG_VALUE
					DisposeGadgets (piphandle);
				}
				UnlockPubScreen (NULL, piphandle->Scr);
			}
			UnlockPubScreen (NULL, piphandle->SpyScr);
		}
		FreeMem (piphandle, sizeof (struct PIPHandle));
	}
	return NULL;
}



static void ClosePIPWin (struct PIPHandle *piphandle)
{
	/* Close our window. No need to reply queued messages,
	 * Intuition is clever enough to care about this for us.
	 */
	CloseWindow (piphandle->Win);
	DisposeGadgets (piphandle);
	UnlockPubScreen (NULL, piphandle->Scr);
	UnlockPubScreen (NULL, piphandle->SpyScr);
	FreeMem (piphandle, sizeof (struct PIPHandle));
}



/*
 *	Diagram of object interconnections
 *	==================================
 *
 *
 *	               ScrollButtonClass objects
 *	+----------+ +------------+ +------------+ +-------------+
 *	| UpButton | | DownButton | | LeftButton | | RightButton |
 *	+----------+ +------------+ +------------+ +-------------+
 *	 | GA_ID =     | GA_ID =       | GA_ID =       | GA_ID =
 *	 | PIPA_MoveUp | PIPA_MoveDown | PIPA_MoveLeft | PIPA_MoveRight
 *	 |             |               |               |
 *	 |  +----------+               |               |
 *	 |  |  +-----------------------+               |
 *	 |  |  |  +------------------------------------+
 *	 |  |  |  |        propgclass object     icclass object
 *	 |  |  |  |          +-----------+      +--------------+
 *	 |  |  |  |          |  HSlider  |<-----| PIPToHSlider |
 *	 |  |  |  |          +-----------+      +--------------+
 *	 |  |  |  |      PGA_Top = |                 ^ PIPA_OffX  = PGA_Top
 *	 |  |  |  |      PIPA_OffX |                 | PIPA_Width = PGA_Visible
 *	 |  |  |  |                |                 | PIPA_DisplayWidth =
 *	 V  V  V  V                V                 |              PGA_Total
 *	+-----------+         ***********            |
 *	|           |-------->*         *------------+
 *	|    PIP    |         *  Model  *
 *	|           |<--------*         *------------+
 *	+-----------+         ***********            |
 *	                           ^                 |
 *	                 PGA_Top = |                 |
 *	                 PIPA_OffY |                 V  icclass object
 *	                     +-----------+      +--------------+
 *	                     |  VSlider  |<-----| PIPToVSlider |
 *	                     +-----------+      +--------------+
 *	                   propgclass object     PIPA_OffY   = PGA_Top
 *	                                         PIPA_Height = PGA_Visible
 *	                                         PIPA_DisplayHeight = PGA_Total
 */

static struct Gadget *CreateGadgets (struct PIPHandle *piphandle)
{
	struct DrawInfo	*dri;
	struct Screen	*scr = piphandle->Scr;
	struct Image	*SizeImage;
	ULONG SizeWidth = 18, SizeHeight = 11;	/* Default values */

	/* GetScreenDrawInfo() never fails */
	dri = piphandle->DrawInfo = GetScreenDrawInfo (scr);

	/* Create a new size image to get its size */
	if (SizeImage = NewObject (NULL, SYSICLASS,
		SYSIA_Which,	SIZEIMAGE,
		SYSIA_DrawInfo,	dri,
		TAG_DONE))
	{
		/* Get size gadget geometry */
		GetAttr (IA_Width, SizeImage, &SizeWidth);
		GetAttr (IA_Height, SizeImage, &SizeHeight);

		/* And then get rid of it... */
		DisposeObject (SizeImage);
	}

	/* No need to check this: in case of failure we would just
	 * get no images in the scroll buttons, but we can still try
	 * to open our window.
	 */
	CreateImages (dri);

	if (piphandle->Model = NewObjectA (NULL, MODELCLASS, NULL))
		if (piphandle->Gad[GAD_PIP] = NewObject (PIPClass, NULL,
			GA_ID,			GAD_PIP,
			GA_Left,		scr->WBorLeft,
			GA_Top,			scr->WBorTop + scr->Font->ta_YSize + 1,
			GA_RelWidth,	- SizeWidth - scr->WBorLeft,
			GA_RelHeight,	- (scr->WBorTop + scr->Font->ta_YSize + SizeHeight + 1),
			GA_DrawInfo,	dri,
			ICA_TARGET,		piphandle->Model,
			TAG_DONE))
			if (piphandle->Gad[GAD_VSLIDER] = NewObject (NULL, PROPGCLASS,
				GA_ID,			GAD_VSLIDER,
				GA_Previous,	piphandle->Gad[GAD_PIP],
				GA_RelRight,	- SizeWidth + 5,
				GA_Top,			scr->WBorTop + scr->Font->ta_YSize + 2,
				GA_Width,		SizeWidth - 8,
				GA_RelHeight,	- (scr->WBorTop + scr->Font->ta_YSize +
								SizeHeight + ImgHeight[IMG_DOWN] + ImgHeight[IMG_UP] + 4),
				GA_RightBorder,	TRUE,
				GA_DrawInfo,	dri,
				PGA_Freedom,	FREEVERT,
				PGA_Borderless,	((dri->dri_Flags & DRIF_NEWLOOK) && (dri->dri_Depth != 1)),
				PGA_NewLook,	TRUE,
				ICA_TARGET,		piphandle->Model,
				ICA_MAP,		MapVSliderToPIP,
				TAG_DONE))
				if (piphandle->Gad[GAD_HSLIDER] = NewObject (NULL, PROPGCLASS,
					GA_ID,			GAD_HSLIDER,
					GA_Previous,	piphandle->Gad[GAD_VSLIDER],
					GA_RelBottom,	- SizeHeight + ((SizeHeight > 15) ? 4 : 3),
					GA_Left,		scr->WBorLeft,
					GA_Height,		SizeHeight - ((SizeHeight > 15)  ? 6 : 4),
					GA_RelWidth,	- (SizeWidth + ImgWidth[IMG_RIGHT] + ImgWidth[IMG_LEFT] + scr->WBorLeft + 2),
					GA_BottomBorder,TRUE,
					GA_DrawInfo,	dri,
					PGA_Freedom,	FREEHORIZ,
					PGA_Borderless,	((dri->dri_Flags & DRIF_NEWLOOK) && (dri->dri_Depth != 1)),
					PGA_NewLook,	TRUE,
					ICA_TARGET,		piphandle->Model,
					ICA_MAP,		MapHSliderToPIP,
					TAG_DONE))
					if (piphandle->Gad[GAD_UPBUTTON] = NewObject (ScrollButtonClass, NULL,
						GA_ID,			GAD_UPBUTTON,
						GA_Previous,	piphandle->Gad[GAD_HSLIDER],
						GA_RelBottom,	- SizeHeight - ImgHeight[IMG_DOWN] - ImgHeight[IMG_UP] + 1,
						GA_RelRight,	- ImgWidth[IMG_DOWN] + 1,
						GA_RightBorder,	TRUE,
						GA_DrawInfo,	dri,
						GA_Image,		Img[IMG_UP],
						ICA_TARGET,		piphandle->Gad[GAD_PIP],
						ICA_MAP,		MapUpButtonToPIP,
						TAG_DONE))
						if (piphandle->Gad[GAD_DOWNBUTTON] = NewObject (ScrollButtonClass, NULL,
							GA_ID,			GAD_DOWNBUTTON,
							GA_Previous,	piphandle->Gad[GAD_UPBUTTON],
							GA_RelBottom,	- SizeHeight - ImgHeight[IMG_DOWN] + 1,
							GA_RelRight,	- ImgWidth[IMG_DOWN] + 1,
							GA_RightBorder,	TRUE,
							GA_DrawInfo,	dri,
							GA_Image,		Img[IMG_DOWN],
							ICA_TARGET,		piphandle->Gad[GAD_PIP],
							ICA_MAP,		MapDownButtonToPIP,
							TAG_DONE))
							if (piphandle->Gad[GAD_LEFTBUTTON] = NewObject (ScrollButtonClass, NULL,
								GA_ID,			GAD_LEFTBUTTON,
								GA_Previous,	piphandle->Gad[GAD_DOWNBUTTON],
								GA_RelBottom,	- ImgHeight[IMG_LEFT] + 1,
								GA_RelRight,	- SizeWidth - ImgWidth[IMG_RIGHT] - ImgWidth[IMG_LEFT] + 1,
								GA_BottomBorder,TRUE,
								GA_DrawInfo,	dri,
								GA_Image,		Img[IMG_LEFT],
								ICA_TARGET,		piphandle->Gad[GAD_PIP],
								ICA_MAP,		MapLeftButtonToPIP,
								TAG_DONE))
								if (piphandle->Gad[GAD_RIGHTBUTTON] = NewObject (ScrollButtonClass, NULL,
									GA_ID,			GAD_RIGHTBUTTON,
									GA_Previous,	piphandle->Gad[GAD_LEFTBUTTON],
									GA_RelBottom,	- ImgHeight[IMG_RIGHT] + 1,
									GA_RelRight,	- SizeWidth - ImgWidth[IMG_RIGHT] + 1,
									GA_BottomBorder,TRUE,
									GA_DrawInfo,	dri,
									GA_Image,		Img[IMG_RIGHT],
									ICA_TARGET,		piphandle->Gad[GAD_PIP],
									ICA_MAP,		MapRightButtonToPIP,
									TAG_DONE))
									{
										APTR icobject;

										/* Connect VSlider to Model */

										if (icobject = NewObject (NULL, ICCLASS,
											ICA_TARGET,	piphandle->Gad[GAD_VSLIDER],
											ICA_MAP,	MapPIPToVSlider,
											TAG_DONE))
											if (!DoMethod (piphandle->Model, OM_ADDMEMBER, icobject))
												DisposeObject (icobject);

										/* Connect HSlider to Model */

										if (icobject = NewObject (NULL, ICCLASS,
											ICA_TARGET,	piphandle->Gad[GAD_HSLIDER],
											ICA_MAP,	MapPIPToHSlider,
											TAG_DONE))
											if (!DoMethod (piphandle->Model, OM_ADDMEMBER, icobject))
												DisposeObject (icobject);

										/* Connect Model to PIP */

										SetAttrs (piphandle->Model,
											ICA_TARGET, piphandle->Gad[GAD_PIP],
											TAG_DONE);

										return piphandle->Gad[GAD_PIP];
									}
	DisposeGadgets (piphandle);

	return NULL;
}



static void DisposeGadgets (struct PIPHandle *piphandle)
{
	ULONG i;

	for (i = 0; i < GAD_COUNT; i++)
	{
		DisposeObject (piphandle->Gad[i]);
		/* piphandle->Gad[i] = NULL; */
	}

	/* Freeing the Model will also free its two targets */
	DisposeObject (piphandle->Model);
	/* piphandle->Model = NULL */

	FreeScreenDrawInfo (piphandle->Scr, piphandle->DrawInfo);
	/* piphandle->DrawInfo = NULL */
}



static void CreateImages (struct DrawInfo *dri)

/* Create 4 arrow images for the window scrolling buttons.
 *
 * Why bother checking for failure? The arrow images are not
 * life critical in our program...
 */
{
	static ULONG imagetypes[IMG_COUNT] = { UPIMAGE, DOWNIMAGE, LEFTIMAGE, RIGHTIMAGE };
	ULONG i;

	for (i = 0; i < IMG_COUNT; i++)
		if (!Img[i])
			if (Img[i] = (struct Image *)NewObject (NULL, SYSICLASS,
				SYSIA_Which,	imagetypes[i],
				SYSIA_DrawInfo,	dri,
				TAG_DONE))
			{
				/* Ask image width and height */
				GetAttr (IA_Width, Img[i], &ImgWidth[i]);
				GetAttr (IA_Height, Img[i], &ImgHeight[i]);
			}
}



static void FreeImages (void)
{
	ULONG i;

	for (i = 0; i < IMG_COUNT; i++)
		DisposeObject ((APTR)Img[i]);	/* DisposeObject(NULL) is safe */
}



/*
**	ScrollButtonClass
**
**	This code has been taken from ScrollerWindow 0.3
**	Copyright © 1994 Christoph Feck, TowerSystems.
**
**	Subclass of buttongclass.  The ROM class has two problems, which make
**	it not quite usable for scrollarrows.  The first problem is the missing
**	delay.  Once the next INTUITICK gets send by input.device, the ROM
**	class already sends a notification.  The other problem is that it also
**	notifies us, when the button finally gets released (which is necessary
**	for command buttons).
**
**	We define a new class with the GM_GOACTIVE and GM_HANDLEINPUT method
**	overloaded to work around these problems.
*/



/* Function prototypes */

static ULONG HOOKCALL ScrollButtonDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, struct gpInput *gpi));


/* Per object instance data */
struct ScrollButtonData
{
	/* The number of ticks we still have to wait
	 * before sending any notification.
	 */
	ULONG TickCounter;
};



static ULONG HOOKCALL ScrollButtonDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, struct gpInput *gpi))

/* ScrollButton Class Dispatcher entrypoint.
 * Handle BOOPSI messages.
 */
{
	struct ScrollButtonData *bd = (struct ScrollButtonData *) INST_DATA(cl, g);

	switch (gpi->MethodID)
	{
		case GM_GOACTIVE:
			/* May define an attribute to make delay configurable */
			bd->TickCounter = 3;

			/* Notify our target that we have initially hit. */
			NotifyAttrs ((Object *)g, gpi->gpi_GInfo, 0,
				GA_ID,	g->GadgetID,
				TAG_DONE);

			/* Send more input */
			return GMR_MEACTIVE;

		case GM_HANDLEINPUT:
		{
			ULONG retval = GMR_MEACTIVE;
			UWORD selected = 0;

			/* This also works with classic (non-boopsi) images. */
			if (PointInImage ((gpi->gpi_Mouse.X << 16) + (gpi->gpi_Mouse.Y), g->GadgetRender))
			{
				/* We are hit */
				selected = GFLG_SELECTED;
			}

			if (gpi->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE && gpi->gpi_IEvent->ie_Code == SELECTUP)
			{
				/* Gadgetup, time to go */
				retval = GMR_NOREUSE;
				/* Unselect the gadget on our way out... */
				selected = 0;
			}
			else if (gpi->gpi_IEvent->ie_Class == IECLASS_TIMER)
			{
				/* We got a tick.  Decrement counter, and if 0, send notify. */

				if (bd->TickCounter) bd->TickCounter--;
				else if (selected)
					/* Notify our target that we are still being hit */
					NotifyAttrs ((Object *)g, gpi->gpi_GInfo, 0,
						GA_ID,	g->GadgetID,
						TAG_DONE);
			}

			if ((g->Flags & GFLG_SELECTED) != selected)
			{
				struct RastPort *rp;

				/* Update changes in gadget render */
				g->Flags ^= GFLG_SELECTED;
				if (rp = ObtainGIRPort (gpi->gpi_GInfo))
				{
					DoMethod ((Object *) g, GM_RENDER, gpi->gpi_GInfo, rp, GREDRAW_UPDATE);
					ReleaseGIRPort (rp);
				}
			}
			return retval;
		}

		default:
			/* Super class handles everything else */
			return (DoSuperMethodA (cl, (Object *)g, (Msg) gpi));
	}
}



static Class *MakeScrollButtonClass (void)
{
	Class *class;

	if (class = MakeClass (NULL, BUTTONGCLASS, NULL, sizeof (struct ScrollButtonData), 0))
		class->cl_Dispatcher.h_Entry = (ULONG (*)()) ScrollButtonDispatcher;

	return class;
}



static BOOL FreeScrollButtonClass (Class *cl)
{
	return (FreeClass (cl));
}
