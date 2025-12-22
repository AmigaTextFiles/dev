#ifdef oiehroishreoifh

/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  dragndrop_prim.c - Drag & Drop primitives
 *
 */


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define INTUI_V36_NAMES_ONLY
#define TR_NOSUPPORT
#define TR_THIS_IS_TRITON

#include <exec/types.h>
#include <exec/lists.h>
#include <exec/ports.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <graphics/gfx.h>
#include <graphics/gels.h>
#include <graphics/clip.h>
#include <graphics/rastport.h>
#include <graphics/view.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>

#include "include/libraries/triton.h"
#include "include/clib/triton_protos.h"
#include "dragndrop.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////// Extended bob object //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct TR_Bob
{
  struct TR_Project * project;       // Triton Project
  struct GelsInfo     gelinfo;       // GelInfo for entire structure
  WORD                nextline [8];  // Nextline data
  WORD              * lastcolor [8]; // Last colour data
  struct RastPort   * mainrast;      // Rastport bob is displayed in
  struct collTable    colltable;     // Collision table
  struct VSprite      vshead;        // Head sprite anchor
  struct VSprite      vstail;        // Tail sprite anchor
  struct VSprite      bobvsprite;    // Vsprite used for bob
  struct Bob          bob;           // Data for a single bob
  struct RastPort     rastport;      // Rastport for our BOB
  struct BitMap       bitmap;        // Bitmap for our BOB
  ULONG               planesize;     // Size of one plane in bob
  UBYTE             * planedata;     // Pointer to first plane
  UBYTE             * chipdata;      // Pointer to all CHIP RAM data
  ULONG               chipsize;      // Total size of allocated CHIP
} TR_Bob;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Private functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_Bob * TR_CreateBob(struct TR_Project *project, int width, int height, int transp);
void     TR_FreeBob(TR_Bob *aBob);
void     TR_UpdateBob(TR_Bob *aBob, ULONG x, ULONG y);
int      TR_PickUpBob(TR_Bob *aBob, ULONG hit, ULONG x, ULONG y);
void     TR_DropBob(TR_Bob *aBob);


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Drag & drop primitives //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *		TR_CreateBob(project, width, height, transp)
 *
 *		This function does all the initialisation necessary to allow us
 *		to use a single BOB in the given rastport. A new bitmap is allocated
 *		of dimensions width x height into which data can be rendered.
 *
 *		If successful, this function returns a pointer to a TR_Bob structure
 *		which contains, among other things, the rastport and bob structure
 *		you will use when calling system routines to manipulate the bob.
 *
 *		Note that the bob must be removed from the Gel list before rendering
 *		into it.
 *
 *		If transp is true, then the BOB will be transparent on colour zero.
 *		In this case, you must call InitMasks(aBob->vsprite) whenever
 *		you make a change to the image, to recalculate the mask.
 */

TR_Bob *TR_CreateBob(struct TR_Project *project, int width, int height, int transp)
{
  struct GelsInfo * gInfo;
  struct Bob      * bob;
  struct VSprite  * vsprite;
  struct RastPort * rport=project->trp_Window->RPort;
  TR_Bob          * aBob;
  UBYTE           * chipdata;
  ULONG             linesize, planesize, imagesize, chipsize, wordwidth, depth, i;

  wordwidth	= (width + 15) >> 4;
  depth		= rport->BitMap->Depth;

  if(!( aBob = (TR_Bob *)AllocMem(sizeof(TR_Bob), MEMF_CLEAR) )) return NULL;
		
  aBob->mainrast		= rport;
  aBob->project                 = project;

  gInfo				= &aBob->gelinfo;
  gInfo->nextLine		= aBob->nextline;
  gInfo->lastColor	= aBob->lastcolor;
  gInfo->collHandler	= &aBob->colltable;
  gInfo->sprRsrvd		= 0x03;

  /*
   *		Set left-most and top-most to 1 to better keep items
   *		inside the display boundaries.
   */
  gInfo->leftmost   = 1;
  gInfo->topmost	  = 1;
  gInfo->rightmost  = (rport->BitMap->BytesPerRow << 3) - 1;
  gInfo->bottommost = rport->BitMap->Rows - 1;
  rport->GelsInfo	  = gInfo;
  InitGels(&aBob->vshead, &aBob->vstail, gInfo);

  /*
   *		Now allocate a new BOB to be linked into this structure.
   *		We also allocate a bitmap associated with the bob, and
   *		give it its own RastPort so that we can render into it.
   */
  linesize	= sizeof(WORD)  * wordwidth;
  planesize	= linesize      * height;
  imagesize	= planesize		* depth;
  chipsize	= imagesize*2 + linesize + planesize;
  bob			= &aBob->bob;
  vsprite		= &aBob->bobvsprite;

  if (!(chipdata = AllocMem(chipsize, MEMF_CHIP | MEMF_CLEAR))) {
    rport->GelsInfo = NULL;
    FreeMem(aBob, sizeof(TR_Bob));
    return (NULL);
  }
  aBob->chipdata		= (void *)(chipdata);
  aBob->chipsize		= chipsize;

  aBob->planedata	= (void *)(chipdata);
  bob->SaveBuffer		= (void *)(chipdata + imagesize);
  vsprite->BorderLine = (void *)(chipdata + imagesize*2);
  vsprite->CollMask	= (void *)(chipdata + imagesize*2 + linesize);

  vsprite->Y			= -9999;
  vsprite->X			= -9999;
  vsprite->Flags      = SAVEBACK | (transp ? OVERLAY : 0);
  vsprite->Width      = wordwidth;
  vsprite->Depth      = depth;
  vsprite->Height     = height;
  vsprite->MeMask     = 0;
  vsprite->HitMask    = 0;
  vsprite->ImageData  = (void *)aBob->planedata;
  vsprite->SprColors  = NULL;
  vsprite->PlanePick  = -1;
  vsprite->PlaneOnOff = 0x00;
  InitMasks(vsprite);

  vsprite->VSBob      = bob;
  bob->BobVSprite     = vsprite;
  bob->ImageShadow    = vsprite->CollMask;
  bob->Flags          = 0;
  bob->Before         = NULL;
  bob->After          = NULL;
  bob->BobComp        = NULL;
  bob->DBuffer		= NULL;

  /*
   *		Now setup the Rastport and Bitmap so we can render into the BOB
   */
  InitRastPort(&aBob->rastport);
  InitBitMap(&aBob->bitmap, depth, width, height);
  aBob->rastport.BitMap = &aBob->bitmap;

  for (i = 0; i < depth; i++)
    aBob->bitmap.Planes[i] = aBob->planedata + i * planesize;

  return (aBob);
}

/*
 *		TR_FreeBob(aBob)
 *
 *		Frees the bob allocated earlier, along with all other associated info 
 *		Also removes all GELs from the system rastport.
 */
void TR_FreeBob(TR_Bob *aBob)
{
	aBob->mainrast->GelsInfo = NULL;
	FreeMem(aBob->chipdata, aBob->chipsize);
	FreeMem(aBob, sizeof(TR_Bob));
}

/*
 *		TR_PickUpBob(aBob, hit, x, y)
 *
 *		Picks up the line and copies it into our bob's bitmap, then adds
 *		the bob to the screen at the current mouse location so the
 *		user can drag it around.
 *
 *		If the hit is correct, we can ignore Y since the field being
 *		dragged is in the right box and we already know which line.
 *		Otherwise, Y is a pixel co-ordinate that we use to calculate
 *		the line of the box that's being chosen.
 *
 *		If hit is FBOX_SELECTLEFT, then we need to calculate which line
 *		we are dealing with.
 *
 *		We also record the start line we use.
 *
 *		Returns true for success, false if we didn't have a hit after all.
 */
int TR_PickUpBob(TR_Bob *aBob, ULONG hit, ULONG x, ULONG y)
{
	struct RastPort *rport    = aBob->project->trp_Window->RPort;
	struct RastPort *bobrport = &aBob->rastport;
	char viewbuf[50];
	int line;
	int box;
	int xpos;
	int ypos;
	int len;

//	if (hit == FBOX_NOSELECT) {
//		return (FALSE);
//	} else if (hit == FBOX_SELECTLEFT) {
//		box  = FORMAT_LEFTBOX;
//		line = (y - FBoxA_Top - 2);
//		if (line < FBoxSpacing)
//			line = 0;
//		else
//			line /= FBoxSpacing;
//		if (line >= FBoxA_CurLines)
//			return (FALSE);
//	} else {
//		/* Right box */
//		box  = FORMAT_RIGHTBOX;
//		line = hit;
//		if (line >= FBoxB_CurLines)
//			return (FALSE);
	}

	/*
	 *		Okay, got a definite hit so go ahead and start the drag
	 */
	FormatDragBox	= box;
	FormatDragLine	= line;
	
	SetRast(bobrport, 0);				/* Erase rast bitmap 	*/
	SetAPen(bobrport, 2);				/* White foreground		*/
	SetBPen(bobrport, 1);				/* Black background		*/
	SetDrMd(bobrport, JAM2);			/* Solid text			*/
	SetFont(bobrport, FormBufFont);

	if (box == FORMAT_LEFTBOX) {
		FieldInit *fi = &FieldTypes[AvailableFields[line].type];

		mysprintf(viewbuf, FBoxA_FormString, MSG(fi->titlemsgid), fi->idchar);
		len  = FBoxA_NumChars;
		xpos = FBoxA_Left + 2;
		ypos = FBoxA_Top  + 2 + line * FBoxSpacing;
	} else {
		FieldInit *fi = &FieldTypes[CurrentFields[line].type];

		mysprintf(viewbuf, FBoxB_FormString, MSG(fi->titlemsgid),
						   CurrentFields[line].width, fi->idchar);
		len  = FBoxB_NumChars;
		xpos = FBoxB_Left + 2;
		ypos = FBoxB_Top  + 2 + line * FBoxSpacing;
	}
	ABob->bob.BobVSprite->X = xpos;
	ABob->bob.BobVSprite->Y = ypos;
	FBoxDeltaX = xpos - x;
	FBoxDeltaY = ypos - y;

	Move(bobrport, 0, FormBufFont->tf_Baseline+1);
	Text(bobrport, viewbuf, len);

	/*
	 *		Now draw highlight above and below the text
	 */
	SetAPen(bobrport, 1);
	Move(bobrport, 0, 0);
	Draw(bobrport, len * FormBufFont->tf_XSize - 1, 0);
	Move(bobrport, 0, FormBufFont->tf_YSize + 1);
	Draw(bobrport, len * FormBufFont->tf_XSize - 1, FormBufFont->tf_YSize + 1);

	InitMasks(ABob->bob.BobVSprite);
	SortGList(rport);
	DrawGList(rport, ViewPortAddress(aBob->project->trp_Window));
	return (1);
}


/****i* triton.library/TR_DropBob ******
*
*   NAME	
*	TR_DropBob -- Drop a Triton bob
*
*   SYNOPSIS
*	TR_DropBob(aBob)
*
*	void TR_DropBob(TR_Bob *);
*
*   FUNCTION
*	Drops the specified bob, triggering any necessary action.
*
*   SEE ALSO
*	TR_CreateBob(), TR_FreeBob(), TR_PickUpBob(), TR_UpdateBob()
*
******/

void TR_DropBob(TR_Bob *aBob)
{
  TR_UpdateBob(aBob, 0, -9999); // Kill any highlighted region
}


/****i* triton.library/TR_UpdateBob ******
*
*   NAME	
*	TR_UpdateBob -- Updates the position of a Triton bob
*
*   SYNOPSIS
*	TR_UpdateBob(aBob, x, y)
*
*	void TR_UpdateBob(TR_Bob *, ULONG, ULONG);
*
*   FUNCTION
*	Moves a currently displayed Triton bob to a new position and
*	draws any highlights etc. that are deemed necessary.
*
*   SEE ALSO
*	TR_CreateBob(), TR_FreeBob(), TR_PickUpBob(), TR_DropBob()
*
******/

void TR_UpdateBob(TR_Bob *aBob, ULONG x, ULONG y)
{
  // Move bob off-screen
  //ABob->bob.BobVSprite->X = 0;
  //ABob->bob.BobVSprite->Y = -9999;

  // Do some rendering in the window

  // Move bob back on screen
  ABob->bob.BobVSprite->X = x;
  ABob->bob.BobVSprite->Y = y;
}

#endif
