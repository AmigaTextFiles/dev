
/* dualpf.c - Shows a dual-playfield.           */
/* Compiled with Lattice C v5.02                                     */
/* Compiler invoked with: lc -b1 -cfist -L -v -w                     */

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


#include <exec/types.h>
#include <intuition/intuition.h>
#include <libraries/dos.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
int CXBRK(void) {return(0);}
#endif
/* Include other required vendor- or Commodore-Amiga-supplied header */
/*  files here.                                                      */
#include <exec/memory.h>

/* Include user-written header files here. For illustration, we show */
/*  two header files which we will use frequently.                   */
#include "graniteWindow.h"

/* Use lowest non-obselete version that supplies the functions you need. */
#define INTUITION_REV 33
#define GRAPHICS_REV  33

extern VOID cleanExit( struct Screen *, struct Window *, struct RasInfo *,
                       struct BitMap *, struct RastPort *, int, int );
extern VOID drawSomething( struct RastPort * );
extern UBYTE handleIDCMP( struct Window *);

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase  *GfxBase  = NULL;
        
VOID main(int argc, char *argv[])
{
    /* Declare variables here */

    ULONG signalmask, signals;
    UBYTE done = 0;
    struct Screen *wbscreen = NULL;
    struct Window *window1 = NULL;
    struct RasInfo  *rinfo2   = NULL;   /* Second playfield rasinfo  */
    struct BitMap   *bmap2    = NULL;   /* Second playfield bitmap   */
    struct RastPort *rport2   = NULL;   /* Used to render into bmap2 */
    int    it_is_done         = 0;      /* Success flag              */

    /* Open the Intuition Library */

    IntuitionBase = (struct IntuitionBase *)
                    OpenLibrary( "intuition.library",INTUITION_REV );

    if (IntuitionBase == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    /* Open any other required libraries */

    GfxBase = (struct GfxBase *)
              OpenLibrary("graphics.library", GRAPHICS_REV);

    if ( GfxBase == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    /* Make the assignments that were postponed above */

    graniteWindow.DetailPen = -1;
    graniteWindow.BlockPen  = -1;
    graniteWindow.Title     = " Dual Playfield Mode ";
    graniteWindow.Type      = WBENCHSCREEN;

    /* Open the screen */

    /* Workbench is already open */

    /* Open the window */

    window1 = OpenWindow(&graniteWindow);
    if (window1 == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    /* Set up the signals that you want to hear about ... */

    signalmask = 1L << window1->UserPort->mp_SigBit;

    /* Call the functions that do the main processing */

    wbscreen = window1->WScreen;   /* Find the Workbench screen */

    /* Allocate the second playfield's rasinfo, bitmap, and bitplane */
    
    rinfo2 = (struct RasInfo *) AllocMem( (ULONG)sizeof(struct RasInfo),
                                          (ULONG) MEMF_PUBLIC|MEMF_CLEAR);

    if (rinfo2 == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    bmap2 = (struct BitMap *) AllocMem( (ULONG)sizeof(struct BitMap),
                                        (ULONG) MEMF_PUBLIC|MEMF_CLEAR);

    if (bmap2 == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    InitBitMap(bmap2, (BYTE)1, (LONG)wbscreen->Width, (LONG)wbscreen->Height);

    /* We'll use one bitplane */

    bmap2->Planes[0] = (PLANEPTR) AllocRaster( (LONG)wbscreen->Width,
                                               (LONG)wbscreen->Height);
   
    if (bmap2->Planes[0] == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    /* Get a rastport, and set it up for rendering into bmap2 */

    rport2 = (struct RastPort *) AllocMem( (ULONG)sizeof(struct RastPort),
                                           (ULONG) MEMF_PUBLIC);

    if (rport2 == NULL)
        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

    InitRastPort(rport2);
    rport2->BitMap = bmap2;
    SetRast(rport2, (UBYTE)0);

    /* Manhandle the viewport: install second playfield and change modes */

    Forbid();
    rinfo2->BitMap = bmap2;      /* Install new bitmap into new rasinfo */

    /* Install rinfo for viewport's second playfield */

    wbscreen->ViewPort.RasInfo->Next = rinfo2;

    wbscreen->ViewPort.Modes |= DUALPF;   /* Convert viewport */
    it_is_done = 1;
    Permit();

    /* Set foreground color; color 9 is color 1 for second  */
    /*  playfield of hi-res viewport                        */

    SetRGB4(&wbscreen->ViewPort, (SHORT)9, (UBYTE)0, (UBYTE)0xF, (UBYTE)0);
    
    /* Put viewport change into effect */
    
    MakeScreen(wbscreen);
    RethinkDisplay();
    
    /* Now ... */

    drawSomething(rport2);

    /* And wait to hear from your signals */
      
    while( !done ) {

        signals = Wait(signalmask);    
        if (signals & signalmask)
            done = handleIDCMP(window1);
    };

    /* Exit the program */

        cleanExit( wbscreen, window1, rinfo2, bmap2, rport2,
                                    it_is_done, RETURN_WARN);

}

VOID drawSomething(struct RastPort *rp)
{
    int width, height;
    int r, c;

    width = rp->BitMap->BytesPerRow * 8;
    height = rp->BitMap->Rows;

    SetAPen(rp, 1L);

    for (r = 0; r < height; r += 40)
	for (c = 0; c < width; c += 40)
	{
	    Move(rp, 0L, (LONG) r);
	    Draw(rp, (LONG) c, 0L);
	}
}

UBYTE handleIDCMP( struct Window *win )
{
    UBYTE flag = 0;
    struct IntuiMessage *message = NULL;
    ULONG class;

    while( message = (struct IntuiMessage *)GetMsg(win->UserPort) ) {

        class = message->Class;
        ReplyMsg( (struct Message *)message);

        switch( class ) {
        
            case CLOSEWINDOW:
            
                flag = 1;
                break;
                
            default:
            
                break;
                
        }        
    }

    return(flag);
}

VOID cleanExit( scrn, wind, rasi, bitm, rasp, flag, returnValue )
struct Screen *scrn;
struct Window *wind;
struct RasInfo *rasi;
struct BitMap *bitm;
struct RastPort *rasp;
int flag, returnValue;
{
    /* clean up dual-playfield trick	*/
    if (flag)
    {
	Forbid();
	scrn->ViewPort.RasInfo->Next = NULL;
	scrn->ViewPort.Modes &= ~DUALPF;
	Permit();
	MakeScreen(scrn);
	RethinkDisplay();
    }

    /* Close things in the reverse order of opening */

    if (rasp) FreeMem(rasp, (ULONG)sizeof(struct RastPort));

    if (bitm)
    {
        if (bitm->Planes[0])
            FreeRaster(bitm->Planes[0], (LONG)scrn->Width,
                                        (LONG)scrn->Height);

        FreeMem(bitm, (ULONG)sizeof(struct BitMap));
    }

    if (rasi) FreeMem(rasi, (ULONG)sizeof(struct RasInfo));

    /* Close the window and NOT the screen */

    if (wind) CloseWindow( wind );

    /* Close the libraries, and then exit */

    if (GfxBase) CloseLibrary( (struct Library *)GfxBase ); 
    if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );

    exit(returnValue);

}

