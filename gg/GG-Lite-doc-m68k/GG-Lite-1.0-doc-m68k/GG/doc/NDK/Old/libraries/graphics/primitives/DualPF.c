/* DualPF
   Dual-PlayFields Example
   For Lattice, compile and link with:  LC -b1 -cfist -L -v -y DualPF.c

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
#include <graphics/rastport.h>
#include <graphics/view.h>
#include <hardware/dmabits.h>
#include <hardware/custom.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdlib.h>

#define DEPTH 2  
#define WIDTH 320 
#define HEIGHT 200 

struct GfxBase *GfxBase = NULL;
 
/* Add a second BitMap for dual playfield. */
struct BitMap bitMap, bitMap2;
struct View view, *oldview;

#define BLACK  0x000
#define BLUE   0x00f
#define GREEN  0x0f0
#define RED    0xf00
#define VIOLET 0xf0f
#define ORANGE 0xf80
#define WHITE  0xfff

#define COLOR0 0
#define COLOR1 1
#define COLOR2 2
#define COLOR3 3

VOID cleanExit(int exitStatus);

VOID main(VOID)
{
SHORT i, stripe;
LONG color;

/* In dual playfield mode, colors 0-7 are dedicated to playfield one
 * and colors 8-15 to playfield two.  Since (in this example)
 * there are only 2 planes in each playfield, colors 4-7 and 12-15
 * won't even get used.  Colors 4-7 are included below to keep the
 * values of colors 8-11 in their proper locations for LoadRGB4().
 */
static UWORD colortable[] =
{
    BLACK, WHITE, ORANGE, RED,
    0, 0, 0, 0,    /* The values for colors 4-7 are placeholders. */
    /* The second playfield's BLACK will be transparent. */
    BLACK, GREEN, VIOLET, BLUE
};

/* Add a second RasInfo for dual playfield. */
struct RasInfo rasInfo, rasInfo2;
struct RastPort rastPort, rastPort2;    /* RastPorts for both BitMaps. */
struct ViewPort viewPort;

GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 33L);
if (GfxBase == NULL)
    cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);

/* Initialize the BitMaps. */
InitBitMap(&bitMap, DEPTH, WIDTH, HEIGHT);
InitBitMap(&bitMap2, DEPTH, WIDTH, HEIGHT);

/* Clear the plane pointers. */
for (i=0; i<DEPTH; i++)
    bitMap.Planes[i] = bitMap2.Planes[i] = NULL;

/* Allocate space for their Planes. */
for (i=0; i<DEPTH; i++)
    {
    bitMap.Planes[i] = (PLANEPTR)AllocRaster(WIDTH, HEIGHT);
    if (bitMap.Planes[i] == NULL)
        cleanExit(ERROR_NO_FREE_STORE);

    bitMap2.Planes[i] = (PLANEPTR)AllocRaster(WIDTH, HEIGHT);
    if (bitMap2.Planes[i] == NULL)
        cleanExit(ERROR_NO_FREE_STORE);
    }

/* Initialize the RastPorts and link the BitMaps to them. */
InitRastPort(&rastPort);
InitRastPort(&rastPort2);
rastPort.BitMap = &bitMap;
rastPort2.BitMap = &bitMap2;

/* Simple form of setting drawing area to color COLOR0. */
SetRast(&rastPort, COLOR0);
SetRast(&rastPort2, COLOR0);

/* Initialize the RasInfos. */
rasInfo.BitMap = &bitMap;    /* Attach the corresponding BitMap. */
rasInfo.RxOffset = 0;    /* Align upper left corners of display */
rasInfo.RyOffset = 0;    /*   with upper left corner of drawing area. */
rasInfo.Next = &rasInfo2;    /* Link second RasInfo structure to the first. */

/* Initialize second RasInfo for Dual Playfield. */
rasInfo2.BitMap = &bitMap2;
rasInfo2.RxOffset = 0;
rasInfo2.RyOffset = 0;
rasInfo2.Next = NULL;

InitVPort(&viewPort);    /* Initialize the ViewPort. */

/* Specify ViewPort characteristics. */
viewPort.DWidth = WIDTH;
viewPort.DHeight = HEIGHT;
viewPort.RasInfo = &rasInfo;
viewPort.Modes = DUALPF;    /* dual-playfield mode */

/* Initialize the ViewPort's ColorMap. */
viewPort.ColorMap = GetColorMap(12L);
if (viewPort.ColorMap == NULL)
    cleanExit(ERROR_NO_FREE_STORE);
LoadRGB4(&viewPort, colortable, 12);

InitView(&view);    /* Initialize the View. */
view.ViewPort = &viewPort;    /* Attach the ViewPort to the View. */

/* Construct (preliminary) Copper instruction list. */
MakeVPort( &view, &viewPort );

/* Merge preliminary lists together into a real
 * Copper list in the View structure.
 */
MrgCop( &view );

/* Save current view to restore later.  Example steals
 * the screen from the active view, but restores it when done.
 */
oldview = GfxBase->ActiView;

/* Load the newly created View. */
LoadView( &view );

/* Stripes of color will be drawn in the playfields.
 * Wherever color 0 is used in playfield number 1,
 * the colors of playfield number 2 will show through.
 */

/* Playfield number 1.  Vertical stripes. */
stripe = WIDTH/32;
for (color=0L, i=WIDTH-stripe; i>=0; i-=stripe)
    {
    SetAPen(&rastPort, color++ % 4L);    /* Cycle through the four colors. */

    /* Create a rectangle.  The coordinates are inset by one on all
     * four edges to allow for the outline created by RectFill.
     */
    RectFill(&rastPort, i+1, 1, i+stripe-2, HEIGHT-1);

    /* Delay for 1/4 second between stripes.
     * The +1L prevents the possibility of a Delay(0) which
     * would cause problems due to a bug in the timer.device.
     */
    Delay(TICKS_PER_SECOND / 4L + 1L);
    }

Delay(1L * TICKS_PER_SECOND);      /* Pause for one second. */

/* Playfield number 2.  Horizontal stripes. */
stripe = HEIGHT/20;
for (color=0L, i=HEIGHT-stripe; i>=0; i-=stripe)
    {
    SetAPen(&rastPort2, color++ % 4L);
    RectFill(&rastPort2, 1, i+1, WIDTH-1, i+stripe-2);
    Delay(TICKS_PER_SECOND / 4L + 1L);
    }

Delay(10L * TICKS_PER_SECOND);
cleanExit(RETURN_OK);

}    /* end of main() */


VOID cleanExit(int exitStatus)
{
SHORT i;

if (oldview)
    {
    LoadView(oldview);    /* Put the original View back again. */
    WaitTOF();    /* Wait for that View to return. */
    }

/* Free the drawing area. */
for(i=0; i<DEPTH; i++)
    {
    if (bitMap.Planes[i])
        FreeRaster(bitMap.Planes[i], WIDTH, HEIGHT);

    if (bitMap2.Planes[i])
        FreeRaster(bitMap2.Planes[i], WIDTH, HEIGHT);
    }

/* Free the color map created by GetColorMap(). */
if (view.ViewPort->ColorMap)
    FreeColorMap(view.ViewPort->ColorMap);

/* Free dynamically created structures. */
if (view.ViewPort)
    FreeVPortCopLists(view.ViewPort);            
if (view.LOFCprList)
    FreeCprList(view.LOFCprList);

if (GfxBase)
    CloseLibrary((struct Library *)GfxBase);

exit(exitStatus);
}

