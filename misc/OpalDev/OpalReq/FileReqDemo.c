/* 
 * FileReqDemo.c 
 *
 * 17/12/91 By Martin Boyd.
 *
 * Simple File requester example.
 * Uses the OpalRequester to input
 * filenames and displays the selected
 * files. Selecting cancel exits.
 */


#include "graphics/gfxbase.h"
#include <opal/opallib.h>
#include <opal/OpalReqlib.h>
#include <exec/memory.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifndef	AZTEC_C
#include <proto/all.h>
#endif

#define BLACK		0L
#define GREY		1L
#define BLUE		2L
#define WHITE		3L


struct NewScreen NewScreen =
	{ 0,0,640,512,2,
	  BLUE,GREY,LACE|HIRES,
	  CUSTOMSCREEN|SCREENQUIET,
	  NULL,NULL,NULL,NULL
	};


struct NewWindow NewWind =
	{ 0,0,640,512,BLUE,GREY,
	  NULL,BORDERLESS|ACTIVATE,
	  NULL,NULL,NULL,NULL,NULL,
	  0,0,1,0,CUSTOMSCREEN
	};


USHORT Palette[] =
	{ 0x0001,			/* Colour 0 */
	  0x0666,			/* Colour 1 */
	  0x0346,			/* Colour 2 */
	  0x0999,			/* Colour 3 */
	  0x0000,0x0000,0x0000,0x0000,	/* Colours 4..7   */
	  0x0000,0x0000,0x0000,0x0000,	/* Colours 8..11  */
	  0x0000,0x0000,0x0000,0x0000,	/* Colours 12..15 */
	  0x0000,0x0666,0x0000,0x0ABC	/* Colours 16..19 */
	};


USHORT MousePointer[] =
	{ 0x0000,0x0000,
	  0x0000,0xFC00, 0x7C00,0xFE00, 0x7C00,0x8600, 0x7800,0x8C00,
	  0x7C00,0x8600, 0x6E00,0x9300, 0x0700,0x6980, 0x0380,0x04C0,
	  0x01C0,0x0260, 0x0080,0x0140, 0x0000,0x0080, 0x0000,0x0000,
	};


struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct OpalBase *OpalBase;
struct OpalReqBase *OpalReqBase;
struct OpalReq OReq;
struct Screen *Scrn;
struct Window *Wind;
struct OpalScreen *OScrn;
BYTE Dir[200],FullName[231];
BYTE FileName[31];
char *ChipSave;

#define AND &&
#define OR ||

void CleanUp (char *String);

void main(void)
{
   register int i;
   long Err;


	GfxBase = (struct GfxBase *)
		OpenLibrary ("graphics.library",0L);
	IntuitionBase = (struct IntuitionBase *)
		OpenLibrary ("intuition.library",0L);
	OpalReqBase = (struct OpalReqBase *)
		OpenLibrary ("opalreq.library",0L);
	OpalBase = (struct OpalBase *)
		OpenLibrary ("opal.library",0L);

	if ((OpalBase==NULL) OR (OpalReqBase==NULL) OR
		 (IntuitionBase==NULL) OR (GfxBase==NULL))
			CleanUp ("Error openning libraries\n");

	NewScreen.Height = GfxBase->NormalDisplayRows*2;
	NewWind.Height = NewScreen.Height;

	if ((Scrn = OpenScreen (&NewScreen))==NULL)
		CleanUp ("Can't open intuition screen.\n");
	LoadRGB4 (&Scrn->ViewPort,Palette,20L);
	NewWind.Screen = Scrn;
	if ((Wind = OpenWindow (&NewWind))==NULL)
		CleanUp ("Can't open window.\n");

	OScrn = OpenScreen24 (0);
	OReq.Hail = "Pick an Image";
	OReq.OScrn = OScrn;
	OReq.File = FileName;
	OReq.Dir = Dir;
	OReq.Window = Wind;
	OReq.Pointer = MousePointer;
	OReq.PrimaryPen = WHITE;
	OReq.SecondaryPen = BLUE;
	OReq.BackPen = GREY;
	WaitTOF();
	SetPointer (Wind,MousePointer,11L,16L,-1L,-1L);
	SetSprite24 (MousePointer,0L);

	do
		{ AmigaPriority ();
		  DualDisplay24 ();
		  OpalRequester (&OReq);
		  strcpy (FullName,Dir);
		  i = strlen (FullName);
		  if ((i!=0) AND (FullName[i-1]!=':'))
			strcat (FullName,"/");
		  strcat (FullName,FileName);
		  if (OReq.OKHit)
			{ CloseScreen24 ();
			  OScrn = NULL;
			  ChipSave = AllocMem (80*1024L,MEMF_CHIP);
			  if (ChipSave==NULL)
				CleanUp ("Out of memory !!\n");
			  Err = LoadIFF24 (OScrn,FullName,0);
			  if (Err<OL_ERR_MAXERR)
				{ FreeMem (ChipSave,80*1024L);
				  CleanUp ("Error loading file\n");
				}
			  OScrn = (struct OpalScreen *)Err;
			  FreeMem (ChipSave,80*1024L);
			  SetSprite24 (NULL,0L);
			  Refresh24 ();
			  SetSprite24 (MousePointer,0L);
			}
		}
	while (OReq.OKHit);

	CleanUp (NULL);
}


void CleanUp (char *String)
{
	if (Wind!=NULL) CloseWindow (Wind);
	if (Scrn!=NULL) CloseScreen (Scrn);
	if (OScrn!=NULL) CloseScreen24 ();
	if (IntuitionBase!=NULL) CloseLibrary ((struct Library *)IntuitionBase);
	if (GfxBase!=NULL) CloseLibrary ((struct Library *)GfxBase);
	if (OpalReqBase!=NULL) CloseLibrary ((struct Library *)OpalReqBase);
	if (OpalBase!=NULL) CloseLibrary ((struct Library *)OpalBase);
	if (String!=NULL)
		puts (String);
	exit (0);
}

