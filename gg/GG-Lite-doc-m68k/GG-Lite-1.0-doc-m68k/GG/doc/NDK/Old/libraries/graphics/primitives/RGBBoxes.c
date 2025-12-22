/*  RGBBoxes
    A self-contained example of a single playfield display.
    For Lattice, compile and link with:  LC -b1 -cfist -L -v -y RGBBoxes.c

   Copyright (c) 1990 Commodore-Amiga, Inc.
  
   This example is provided in electronic form by Commodore-Amiga, Inc. for
   use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
   The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
   information on the correct usage of the techniques and operating system
   functions presented in this example.  The source and executable code of
   this example may only be distributed in free electronic form, via bulletin
   board or as part of a fully non-commercial and freely redistributable
   diskette.  Both the source and executable code (including comments) must
   be included, without modification, in any copy.  This example may not be
   published in printed form or distributed with any commercial product.
   However, the programming techniques and support routines set forth in
   this example may be used in the development of original executable
   software products for Commodore Amiga computers.
   All other rights reserved.
   This example is provided "as-is" and is subject to change; no warranties
   are made.  All use is at your own risk.  No liability or responsibility
   is assumed.
*/

#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/copper.h>
#include <graphics/view.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdlib.h>

#define DEPTH 2    /*  The number of bitplanes.  */
#define WIDTH 320
#define HEIGHT 200

struct GfxBase *GfxBase = NULL;

/*  Construct a simple display.  */
struct View view;
struct ViewPort viewPort;
struct BitMap bitMap;

/*  Pointer for writing to BitMap memory.  */
UBYTE *displaymem = NULL;

/*  Pointer to old View so it can be restored.  */
struct View *oldview = NULL;

/*  RGB values for the four colors used.  */
#define BLACK 0x000
#define RED   0xf00
#define GREEN 0x0f0
#define BLUE  0x00f


/*
   Draw a WIDTH/2 by HEIGHT/2 box of color "fillcolor" into the given plane.
*/
VOID drawFilledBox(WORD fillcolor, WORD plane)
{
UBYTE value;
WORD boxHeight, boxWidth, width;

/*
   Divide (WIDTH/2) by eight because each UBYTE that
   is written stuffs eight bits into the BitMap.
*/
boxWidth = (WIDTH/2)/8;
boxHeight = HEIGHT/2;

value = ((fillcolor & (1 << plane)) != 0) ?  0xff : 0x00;

for( ; boxHeight; boxHeight--)
    {
    for(width=0 ; width < boxWidth; width++)
        *displaymem++ = value;

    displaymem += (bitMap.BytesPerRow - boxWidth);
    }
}


/*
   Return user- and system-allocated memory to system memory manager.
*/
VOID freeMemory(VOID)
{
WORD depth;

/*  Free the drawing area.  */
for(depth=0; depth<DEPTH; depth++)
    {
    if (bitMap.Planes[depth])
        FreeRaster(bitMap.Planes[depth], WIDTH, HEIGHT);
    }

/*  Free the color map created by GetColorMap().  */
if (viewPort.ColorMap)
    FreeColorMap(viewPort.ColorMap);

/*  Free all intermediate Copper lists from ViewPort.  */
FreeVPortCopLists(&viewPort);

/*  Deallocate the hardware Copper list.  */
if (view.LOFCprList)
    FreeCprList(view.LOFCprList);
}


/*
   Clean up and exit.
*/
VOID cleanExit(int exitStatus)
{
if (oldview)
    {
    LoadView(oldview);    /*  Put back the old View.  */
    /*  Wait until the the view is being rendered to free our memory.  */
    WaitTOF();
    }

freeMemory();    /*  Give back what was borrowed.  */

if (GfxBase)
    CloseLibrary((struct Library *)GfxBase);

exit(exitStatus);
}


VOID main(VOID)
{
WORD depth, box;
/*  Offsets in BitMap where boxes will be drawn.  */
static SHORT boxoffsets[] = { 802, 2010, 3218 };
static UWORD colortable[] = { BLACK, RED, GREEN, BLUE };
struct RasInfo rasInfo;

GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 33L);
if (GfxBase == NULL)
    cleanExit(RETURN_FAIL);

/*  Example steals screen from Intuition if Intuition is around.  */
oldview = GfxBase->ActiView;    /* Save current View to restore later. */

InitView(&view);                /*  Initialize the View.  */
InitVPort(&viewPort);           /*  Initialize the ViewPort.  */
view.ViewPort = &viewPort;      /*  Link the ViewPort into the View.  */

/*  Init BitMap for RasInfo.  */
InitBitMap(&bitMap, DEPTH, WIDTH, HEIGHT);

/*
   Set the plane pointers to NULL so the cleanup
   routine will know if they were used.
*/
for(depth=0; depth<DEPTH; depth++)
    bitMap.Planes[depth] = NULL;


/*  Init RasInfo.  */
rasInfo.BitMap = &bitMap;
rasInfo.RxOffset = 0;
rasInfo.RyOffset = 0;
rasInfo.Next = NULL;

viewPort.RasInfo = &rasInfo;
viewPort.DWidth = WIDTH;
viewPort.DHeight = HEIGHT;

/*  Init ColorMap.  */
/*  2 planes deep, so 4 entries (2 raised to the #_planes power).  */
viewPort.ColorMap = GetColorMap(4L);
if (viewPort.ColorMap == NULL)
    cleanExit(RETURN_WARN);

/*  Change colors to those in colortable.  */
LoadRGB4(&viewPort, colortable, 4);

/*  Allocate space for BitMap.  */
for (depth=0; depth<DEPTH; depth++)
    {
    bitMap.Planes[depth] = (PLANEPTR)AllocRaster(WIDTH, HEIGHT);
    if (bitMap.Planes[depth] == NULL)
        cleanExit(RETURN_WARN);
    }

/*  Construct preliminary Copper instruction list.  */
MakeVPort( &view, &viewPort );

/*  Merge preliminary lists into a real Copper list in the view structure.  */
MrgCop( &view );

for(depth=0; depth<DEPTH; depth++)
    {
    displaymem = (UBYTE *)bitMap.Planes[depth];
    BltClear(displaymem, RASSIZE(WIDTH, HEIGHT), 0);
    }

LoadView(&view);

/*
   Now fill some boxes so that user can see something.
   Always draw into both planes to assure true colors.
*/
for (box=1; box<=3; box++)    /*  Three boxes; red, green, and blue.  */
    {
    for (depth=0; depth<DEPTH; depth++)    /*  Two planes.  */
        {
        displaymem = bitMap.Planes[depth] + boxoffsets[box-1];
        drawFilledBox(box, depth);
        }
    }

Delay(10L * TICKS_PER_SECOND);    /*  Pause for 10 seconds,  */

cleanExit(RETURN_OK);    /*  then exit.  */

}    /*  End of main().  */

