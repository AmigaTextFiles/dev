/*======================================*/
/*																			*/
/* Data INterface demo.									*/
/* © J.Tyberghein												*/
/*																			*/
/* Sat Nov 10 13:39:46 1990							*/
/*																			*/
/* Start all slave programs with :			*/
/*		'run dindemo'											*/
/* Start master program with :					*/
/*		'run dindemo master'							*/
/*																			*/
/* Compile with :												*/
/*		lc -L -v -cms DinDemo							*/
/*																			*/
/*======================================*/


#include <exec/types.h>
#include <exec/memory.h>
#include <graphics/gfx.h>
#include <intuition/intuitionbase.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <string.h>
/* #include <proto/din.h> */
#include <clib/din_protos.h>
#include <libraries/din.h>


/*==================================================================================*/


/* Error codes */
#define ERR_OLDLIB		-1
#define ERR_WINDOW		-2
#define ERR_LIB				-3
#define ERR_OBJECT		-4
#define ERR_LINK			-5


struct Window *win = NULL;
struct RastPort *rp;
struct Screen *lockscr = NULL;

extern APTR DOSBase;
struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;
struct DinBase *DinBase = NULL;


/*==================================================================================*/


/***----------------------------------------***/
/*** Stub function to use OpenWindowTagList ***/
/***----------------------------------------***/

struct Window *OpenWindowTags (struct NewWindow *newWindow, ULONG tag1Type, ...)
{
	return ((struct Window *)OpenWindowTagList (newWindow,(struct TagItem *)&tag1Type));
}


/***------------------***/
/*** Clean everything ***/
/***------------------***/

void CloseStuff (int rc)
{
  if (win) CloseWindow (win);
	if (lockscr) UnlockPubScreen (NULL,lockscr);
	if (IntuitionBase) CloseLibrary ((struct Library *)IntuitionBase);
	if (GfxBase) CloseLibrary ((struct Library *)GfxBase);
	if (DinBase) CloseLibrary ((struct Library *)DinBase);
	exit (rc);
}


/***-----------------***/
/*** Init everything ***/
/***-----------------***/

void OpenStuff ()
{
	int sw,sh;

	GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library",36L);
	if (!GfxBase)
		{
			Write (Output (),"You need AmigaDOS 2.0 to run this program !\n",43);
			exit (ERR_OLDLIB);
		}
	IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library",0L);
	if (!(DinBase = (struct DinBase *)OpenLibrary (DINNAME,DINVERSION)))
		{
			PutStr ("You need din.library installed in you libs: directory !\n");
			CloseStuff (ERR_LIB);
		}

	lockscr = LockPubScreen (NULL);
	sw = lockscr->Width;
	sh = lockscr->Height;

	if (!(win = OpenWindowTags (NULL,
			WA_Left,(sw-200)/2,WA_Top,(sh-100)/2,				/* Center window on screen	*/
			WA_Width,200,WA_Height,100,									/* Dimensions								*/
			WA_Flags,WINDOWCLOSE | WINDOWDEPTH |				/* Flags for window					*/
				WINDOWDRAG | REPORTMOUSE | RMBTRAP,
			WA_IDCMP,CLOSEWINDOW | MOUSEMOVE |					/* IDCMP for master window	*/
				MOUSEBUTTONS,
			WA_PubScreen,lockscr,												/* Default public screen		*/
			WA_Title,"DIN Demo",												/* Window title							*/
			TAG_END,0)))
		{
			PutStr ("Could not open window !\n");
			CloseStuff (ERR_WINDOW);
		}
	rp = win->RPort;
}


/***--------------***/
/*** Main program ***/
/***--------------***/

void main (int argc, char *argv[])
{
	struct IntuiMessage *imsg;	/* Intuition variables */
	ULONG Class;
	USHORT Code;
	SHORT MouseX,MouseY;
	int Drawing;								/* Indicate we are busy drawing (for master only)	*/
	int Slave;									/* We are a slave, (we didn't create the object		*/
	ULONG sig;									/* Returned signal from Wait											*/
	struct DinObject *ob;				/* Pointer to our object (for master and slave)		*/
	struct DinLink *dl;					/* Pointer to our link (for slave only)						*/
	struct ObjectImage oi,			/* Our physical object (for master only)					*/
		*obi;											/* Pointer to physical object (for slave only)		*/

	OpenStuff ();

	if (argc>1)									/* There are arguments on the command line */
		{
			/*------------------*/
			/* Setup for master */
			/*------------------*/

			/* oi is only used in the master program															*/
			/* The slave programs obtain a pointer to this physical object using	*/
			/* their DinLink to the DinObject																			*/

			/* Init the rastport in the physical object */
			oi.rp = rp;

			/* Exclude the windowborders from our image */
			oi.Rect.MinX = win->BorderLeft;
			oi.Rect.MinY = win->BorderTop;
			oi.Rect.MaxX = win->Width - win->BorderRight;
			oi.Rect.MaxY = win->Height - win->BorderBottom;

			/* Make the object																								*/
			/* It is possible that there are already DinLinks to this object	*/
			/* You need not worry about these																	*/
			/* Note that there can be only one master program running because	*/
			/* all DinObjects must have unique names													*/
			if (!(ob = MakeDinObject ("DinDemo Object",OBJECTIMAGE,0,&oi,
					sizeof (struct ObjectImage))))
				{
					PutStr ("Error creating object !\n");
					CloseStuff (ERR_OBJECT);
				}

			/* The object is disabled by default */
			EnableDinObject (ob);

			/* Remember we are no slave program */
			Slave = FALSE;
		}
	else
		{
			/*-----------------*/
			/* Setup for slave */
			/*-----------------*/

			/* We make our link to the DinObject																*/
			/* It is possible that the DinObject does not exist at this moment	*/
			/* Therefore we use MakeDinLink with the object name and not with		*/
			/* a pointer to the DinObject																				*/
			if (!(dl = MakeDinLink (NULL,"DinDemo Object")))
				{
					PutStr ("Error creating link !\n");
					CloseStuff (ERR_LINK);
				}

			/* We only need the CLOSEWINDOW IDCMP when we are in slave mode */
			ModifyIDCMP (win,CLOSEWINDOW);

			if (dl->Flags & LNK_WAITING4OB)
				/* The object does not exist (there is no master yet)	*/
				/* This makes no difference for our program						*/
				PutStr ("Object does not yet exist.\n");
			else
				{
					/* obi points to oi (the master object) */
					obi = (struct ObjectImage *)(dl->Ob->PhysObject);

					/* Copy the master object rastport to our rastport				*/
					/* This means we READ the object													*/
					/* Note that in this simple program it is not absolutely	*/
					/* necessary to lock the object. The lock is simply done	*/
					/* for educational purposes.															*/
					ReadLockDinObject (dl->Ob);
					ClipBlit (
						obi->rp,					/* Use RastPort in physical object as source	*/
						obi->Rect.MinX,		/* Top-left corner in source									*/
						obi->Rect.MinY,
						rp,								/* Destination (our window rastport)					*/
						win->BorderLeft,	/* Top-left corner in destination							*/
						win->BorderTop,
															/* Width and height to blit										*/
						obi->Rect.MaxX-obi->Rect.MinX,
						obi->Rect.MaxY-obi->Rect.MinY,
						0xc0);						/* Minterm																		*/
					/* Do NOT forget to unlock !!! */
					ReadUnlockDinObject (dl->Ob);
				}

			/* We are a slave program */
			Slave = TRUE;
		}

	/*-------------------------------*/
	/* Main loop: wait for intuition */
	/* messages and DIN signals			 */
	/*-------------------------------*/

	Drawing = FALSE;						/* Only relevant for master */
	for (;;)
		{
			if (Slave)
				/* Wait for intuition and a signal from our DinLink */
				sig = Wait ((1<<win->UserPort->mp_SigBit) | (1<<dl->SigBit));
			else
				/* Only wait for intuition (master) */
				sig = Wait (1<<win->UserPort->mp_SigBit);

			if (sig & (1<<win->UserPort->mp_SigBit))
				/*--------------------------------*/
				/* We got a signal from intuition */
				/*--------------------------------*/
				while (imsg = (struct IntuiMessage *)GetMsg (win->UserPort))
					{
						Class = imsg->Class;
						Code = imsg->Code;
						MouseX = imsg->MouseX;
						MouseY = imsg->MouseY;
						ReplyMsg ((struct Message *)imsg);
						switch (Class)
							{
								case CLOSEWINDOW :
									if (Slave)
										/* Remove our DinLink */
										RemoveDinLink (dl);
									else
										/* RemoveDinObject gives a signal to all					*/
										/* slave programs so that they can remove their		*/
										/* DinLinks																				*/
										/* This function will only return when they have	*/
										/* done this																			*/
										RemoveDinObject (ob);

									CloseStuff (0);

								case MOUSEBUTTONS :
									/* We only get MOUSEBUTTONS for the master window	*/
									/* so we now we are in the master program					*/
									if (Code == SELECTDOWN)
										{
											/* Start drawing if color 1 */
											Drawing = TRUE;
											SetAPen (rp,1);

											/* Lock our object for writing and draw a pixel			*/
											/* Note that in this simple example, locking is not	*/
											/* absolutely necessary															*/
											WriteLockDinObject (ob);
											WritePixel (rp,MouseX,MouseY);
											WriteUnlockDinObject (ob);

											/* Say to all slave programs that you have changed	*/
											/* the object. Note that you need not do this				*/
											/* immediatelly. For performance reasons you may		*/
											/* decide to do this only after you have completed	*/
											/* an action																				*/
											/* You could even decide to delay the								*/
											/* WriteUnlockDinObject until later									*/
											NotifyDinLinks (ob,LNK_CHANGE);
										}
									else if (Code == MENUDOWN)
										{
											/* Start drawing if color 2 */
											Drawing = TRUE;
											SetAPen (rp,2);

											WriteLockDinObject (ob);
											WritePixel (rp,MouseX,MouseY);
											WriteUnlockDinObject (ob);

											NotifyDinLinks (ob,LNK_CHANGE);
										}
									else Drawing = FALSE;
									break;

								case MOUSEMOVE :
									if (Drawing)
										{
											WriteLockDinObject (ob);
											WritePixel (rp,MouseX,MouseY);
											WriteUnlockDinObject (ob);

											NotifyDinLinks (ob,LNK_CHANGE);
										}
									break;
							}
					}

			if (Slave && (sig & (1<<dl->SigBit)))
				/*------------------------------------------*/
				/* We got a signal from our DinLink (slave) */
				/*------------------------------------------*/
				{
					if (dl->Flags & LNK_KILLED)
						{
							/* The DinObject has been removed	*/
							/* we must remove our DinLink			*/
							RemoveDinLink (dl);
							CloseStuff (0);
						}

					if (dl->Flags & LNK_NEW)
						{
							/* The DinObject did not exist when we started	*/
							/* The signal we get now indicates that the			*/
							/* DinObject has just been created							*/
							/* Get the pointer to the physical object				*/
							obi = (struct ObjectImage *)(dl->Ob->PhysObject);

							/* Go and get the image from the object rastport */
							ReadLockDinObject (dl->Ob);
							ClipBlit (obi->rp,obi->Rect.MinX,obi->Rect.MinY,rp,
								win->BorderLeft,win->BorderTop,
								obi->Rect.MaxX-obi->Rect.MinX,obi->Rect.MaxY-obi->Rect.MinY,
								0xc0);
							ReadUnlockDinObject (dl->Ob);
						}

					if (dl->Flags & LNK_CHANGE)
						{
							/* The master program has changed something to his			*/
							/* image, we must copy the changed data to our rastport	*/
							ReadLockDinObject (dl->Ob);
							ClipBlit (obi->rp,obi->Rect.MinX,obi->Rect.MinY,rp,
								win->BorderLeft,win->BorderTop,
								obi->Rect.MaxX-obi->Rect.MinX,obi->Rect.MaxY-obi->Rect.MinY,
								0xc0);
							ReadUnlockDinObject (dl->Ob);
						}

					/* Make sure that we correctly catch the next signal */
					ResetDinLinkFlags (dl);
				}
		}
}
