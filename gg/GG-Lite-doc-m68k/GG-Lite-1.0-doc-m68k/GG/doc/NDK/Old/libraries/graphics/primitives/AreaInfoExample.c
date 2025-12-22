/* AreaInfoExample
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

#define AREA_SIZE 200

BOOL example(struct Window *window)
{
register USHORT i;
WORD areabuffer[AREA_SIZE];
UWORD height, width;
PLANEPTR planePtr = NULL;
struct RastPort *rastPort = window->RPort;
struct TmpRas tmpRas;
struct AreaInfo areaInfo;

height = GfxBase->NormalDisplayRows;
width  = GfxBase->NormalDisplayColumns;

planePtr = AllocRaster(width, height);
if (planePtr)
    {
    for (i=0; i<AREA_SIZE; i++)
        areabuffer[i] = 0;

    InitArea(&areaInfo, areabuffer, (AREA_SIZE*2)/5);
    rastPort->AreaInfo = &areaInfo;

    InitTmpRas(&tmpRas, planePtr, RASSIZE(width, height));
    rastPort->TmpRas = &tmpRas;

    /* Area routines need a temporary raster buffer at least as large as the
     * largest object to be drawn.  If a single task uses multiple RastPorts,
     * it is sometimes possible to share the same TmpRas structure among
     * multiple RastPorts.  Multiple tasks, however, cannot share a TmpRas,
     * as each task won't know when another task has a drawing partially
     * completed.
    */

    AreaMove(rastPort, 0, 0); 
    AreaDraw(rastPort, 0, 100); 
    AreaDraw(rastPort, 100, 100);

    AreaMove(rastPort, 50, 10);
    AreaDraw(rastPort, 50, 50);
    AreaDraw(rastPort, 100, 50);

    AreaEnd (rastPort);

    FreeRaster(planePtr, width, height);
    }
    return(WAIT_FOR_CLOSE);
}

