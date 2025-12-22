/* BoxFill
   Three methods of rendering a filled rectangle.
   Insert this routine into the "wrapper" code at the end of the TEXT chapter.

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

#include <graphics/gfxmacros.h>

#define AREA_SIZE 200

#define COLOR0 0
#define COLOR1 1
#define COLOR3 3

BOOL example(struct Window *window)
{
register USHORT i;
SHORT xLow, xHigh, yLow, yHigh;
WORD areabuffer[AREA_SIZE];
UWORD height, width;
PLANEPTR planePtr = NULL;
struct RastPort *rastPort = window->RPort;
struct TmpRas tmpRas;
struct AreaInfo areaInfo;

xLow = window->BorderLeft;
xHigh = window->GZZWidth - window->BorderRight;
yLow = window->BorderTop;
yHigh = window->GZZHeight - window->BorderBottom;

height = GfxBase->NormalDisplayRows;
width  = GfxBase->NormalDisplayColumns;

/*  The AreaInfo structure is needed only by the Area...() calls.  */
planePtr = AllocRaster(width, height);
if (planePtr)
    {
    for (i=0; i<AREA_SIZE; i++)
        areabuffer[i] = 0;

    InitArea(&areaInfo, areabuffer, (AREA_SIZE*2)/5);
    rastPort->AreaInfo = &areaInfo;

    InitTmpRas(&tmpRas, planePtr, RASSIZE(width, height));
    rastPort->TmpRas = &tmpRas;

    SetRast(rastPort, COLOR0);

    /* Area-fill a rectangular area. */
    TITLE(window, "AreaMove(), AreaDraw(), AreaEnd()");
    Delay(2L * TICKS_PER_SECOND);
    SetAPen(rastPort, COLOR1);
    SetOPen(rastPort, COLOR3);
    AreaMove(rastPort, xLow, yLow);
    AreaDraw(rastPort, xLow, yHigh);
    AreaDraw(rastPort, xHigh, yHigh);
    AreaDraw(rastPort, xHigh, yLow);
    /*  AreaEnd() will complete the rectangle automatically.  */
    AreaEnd(rastPort);


    Delay(5L * TICKS_PER_SECOND);
    SetRast(rastPort, COLOR0);


    /* Flood-fill a rectangular area. */
    TITLE(window, "Move(), Draw(), Flood()");
    Delay(2L * TICKS_PER_SECOND);
    SetAPen(rastPort, COLOR3);
    BNDRYOFF(rastPort);
    Move(rastPort, xLow, yLow);
    Draw(rastPort, xLow, yHigh);
    Draw(rastPort, xHigh, yHigh);
    Draw(rastPort, xHigh, yLow);
    /*  Must complete the rectangle or flood will leak.  */
    Draw(rastPort, xLow, yLow);
    SetAPen(rastPort, COLOR1);
    /*  Start Flood() in the middle of the rectangle,
        and replace all pixels of the same color as x,y).
    */
    Flood(rastPort, 1L, (xHigh-xLow)/2, (yHigh-yLow)/2);


    Delay(5L * TICKS_PER_SECOND);
    SetRast(rastPort, COLOR0);


    /* Rectangle-fill a rectangular area. */
    TITLE(window, "RectFill()");
    Delay(2L * TICKS_PER_SECOND);
    SetAPen(rastPort, COLOR1);
    SetOPen(rastPort, COLOR3);
    RectFill(rastPort, xLow, yLow, xHigh, yHigh);

    FreeRaster(planePtr, width, height);
    }

    return(WAIT_FOR_CLOSE);
}

