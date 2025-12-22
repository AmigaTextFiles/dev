/* MouseKeys.c */
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
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <graphics/gfxbase.h>
#include <devices/inputevent.h>
#include <libraries/dos.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int CXBRK(void) { return(0); } /* Disable Lattice CTRL/C handling */
#endif

VOID   cleanExit(int);
VOID   OpenAll(VOID);
VOID   DoKeys(struct IntuiMessage *);
LONG   DeadKeyConvert(struct IntuiMessage *, UBYTE *, LONG, struct KeyMap *);
VOID   DoMouseMove(struct RastPort *, struct IntuiMessage *);
VOID   DoButtons(struct IntuiMessage *);

#define	BUFSIZE 15
#define RP window->RPort
#define WIDTH 320
#define HEIGHT 50
#define SHIFTED (IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT)

struct	IntuitionBase	*IntuitionBase=NULL;
struct  GfxBase         *GfxBase=NULL;
struct	Window		*window=NULL;
struct	ConsoleDevice	*ConsoleDevice=NULL;
struct	IOStdReq	ioreq;

struct	NewWindow	NewWindow = {
    0,0,WIDTH,HEIGHT,
    -1,-1,
    CLOSEWINDOW|RAWKEY|MOUSEMOVE|MOUSEBUTTONS,
    WINDOWDRAG|WINDOWCLOSE|ACTIVATE|REPORTMOUSE|RMBTRAP,
    NULL,NULL,
    "Mouse & KeyBoard",
    NULL,NULL,
    0,0,0,0,
    WBENCHSCREEN
};


/*
 The Main Loop
 */

VOID	main(int argc, char *argv[])
{
USHORT	keep=TRUE;           /* loop control */
struct  IntuiMessage  *msg;  /* for the Intuition message */
ULONG	class;               /* event class */

    OpenAll();
    printf("Monitors the Mouse AND Keyboard\n");
    printf("Try DoubleClicking and Special Keys\n");
    while(keep)
    {
        Wait((1L<<window->UserPort->mp_SigBit));
        while(msg=(struct IntuiMessage *)GetMsg(window->UserPort))
        {
            class=msg->Class;  /* Get the event class */
            switch(class)      /* handle our events */
            {
                case CLOSEWINDOW:  keep=FALSE; break;
                case RAWKEY:       DoKeys(msg); break;
                case MOUSEMOVE:    DoMouseMove(RP,msg); break;
                case MOUSEBUTTONS: DoButtons(msg); break;
            }
            ReplyMsg((struct Message *)msg);
        }
    }
    cleanExit(RETURN_OK);
}


/*
 Show what mouse buttons where pushed
 */

VOID   DoButtons(struct IntuiMessage *msg)
{
static ULONG  lsecs = 0L, lmics = 0L;   /* For detecting DoubleClick */
USHORT code;
USHORT qual;
ULONG  secs, mics;

    code = msg->Code;
    qual = msg->Qualifier;
    secs = msg->Seconds;          /* get the current time for */
    mics = msg->Micros;           /* DoubleClick() */

    /* Yes, qualifiers can apply to the mouse also.  That is how
     * we get the shift select on the WorkBench.  This shows how
     * to see if a specific bit is set within the qualifier
     */

    if(qual&SHIFTED)  printf("Shift ");
    switch(code)
    {
       case SELECTDOWN:
          printf("Left Button Down");
          if(DoubleClick(lsecs, lmics, secs, mics)) {
             printf(" DoubleClick!");
          } else {
             lsecs = secs;
             lmics = mics;
          }
          break;
       case SELECTUP:
          printf("Left Button up");
          break;
       case MENUDOWN:
          printf("Right Button down");
          break;
       case MENUUP:
          printf("Right Button up");
          break;
    }
    printf("\n");
}



/* Show the current position of the mouse relative to the
 * upper left-hand corner of our window
 */

VOID   DoMouseMove(
   struct RastPort *rp,         /* RastPort to write coordinates into */
   struct IntuiMessage *msg)    /* IntuiMessage containing mouse coords */
{
UBYTE  coords[12];

    sprintf(coords,"X%4d Y%4d", msg->MouseX, msg->MouseY);
    Move(rp,((WIDTH-88)/2),((HEIGHT-8)/2)+10);  /* ASSUMES 8 Pixel-High Font */
    Text(rp,&coords[0],11);
}


/*
 Show what keys where pressed...
 */

VOID   DoKeys(struct IntuiMessage *msg)
{
register USHORT i;
USHORT  numchars;
UBYTE   buffer[BUFSIZE];

    strcpy(buffer,"               ");
    numchars=(int)DeadKeyConvert(msg, &buffer[0], BUFSIZE, 0L);

    /* numchars now contains the number of characters placed 
     * within the buffer.  If this was a message notifying us of a
     * key release, then it shows zero.  Special keys (like HELP,
     * the cursor keys, FKeys, etc) return multiple characters that
     * have to then be parsed.
     */

    if(numchars>0)
    {
        printf("key %d maps to %d character(s)\n", msg->Code, numchars);
        for(i=0; i<numchars; i++)
        {
           printf("  %3d = %c\n", buffer[i], buffer[i]);
        }
    }
}


/*
 Open up all the resources that we need
 */

VOID	OpenAll(VOID)
{
    if(!(IntuitionBase=(struct IntuitionBase *)
      OpenLibrary("intuition.library",33)))
        cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);
    if(!(GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",33)))
        cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);

    /* must have the console.device opened to use RawKeyConvert()
     */

    if(OpenDevice("console.device",-1L,(struct IORequest *)&ioreq,0L))
        cleanExit(ERROR_DEVICE_NOT_MOUNTED);
    ConsoleDevice=(struct ConsoleDevice *)ioreq.io_Device;

    /* center the window that we are going to use to display
     * the current mouse position in.
     */

    NewWindow.LeftEdge = (GfxBase->NormalDisplayColumns - WIDTH) / 2;
    NewWindow.TopEdge = (GfxBase->NormalDisplayRows - HEIGHT) / 2;

    if(!(window=(struct Window *)OpenWindow(&NewWindow)))
        cleanExit(ERROR_NO_FREE_STORE);

    /* initialize the drawing variables used for rendering the
     * current mouse position 
     */

    SetAPen(RP,1);
    SetBPen(RP,0);
    SetDrMd(RP,JAM2);
}


/*
 Free up all the resources that we used
 */

VOID	cleanExit(int retval)
{
    if(window)         CloseWindow(window);
    if(ConsoleDevice)  CloseDevice((struct IORequest *)&ioreq);
    if(GfxBase)        CloseLibrary((struct Library *)GfxBase);
    if(IntuitionBase)  CloseLibrary((struct Library *)IntuitionBase);
    exit(retval);
}


/*
 Convert RAWKEYS into VANILLAKEYS, also shows
 special keys like HELP, Cursor Keys, FKeys, etc.

 Returns:
   -2 if not a RAWKEY event
   -1 if not enough room in the buffer
   the number of characters placed in the buffer
 */

LONG   DeadKeyConvert(
struct IntuiMessage *msg,
UBYTE               *kbuffer,
LONG                kbsize,
struct KeyMap	    *kmap
)
{
    static struct InputEvent ievent = {NULL, IECLASS_RAWKEY,0,0,0};

    if(msg->Class != RAWKEY) return(-2);
    ievent.ie_Code = msg->Code;
    ievent.ie_Qualifier = msg->Qualifier;
    ievent.ie_position.ie_addr = *((APTR*)msg->IAddress);
    return(RawKeyConvert(&ievent,kbuffer,kbsize,kmap));
}
