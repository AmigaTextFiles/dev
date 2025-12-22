
/* borderless.c - Opens a borderless backdrop window, writes a message. */
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

/* Include user-written header files here.  */
#include "hires.h"
#include "agateWindow.h"
#include "hellotext.h"

/* Use lowest non-obselete version that supplies the functions you need. */
#define INTUITION_REV 33
#define GRAPHICS_REV  33

/* TICKS_PER_SECOND is defined in libraries/dos.h
   NEVER call Delay() with an argument of 0 !
*/
#define PAUSE(seconds)	(Delay((seconds) * TICKS_PER_SECOND))

extern VOID cleanExit( struct Screen *, struct Window *, int );

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;

/* The next two declarations are for redirecting system requesters. */
struct Process *myProcess = NULL;
APTR oldwindowptr = NULL;

        
VOID main(int argc, char *argv[])
{
    /* Declare variables here */
    SHORT i;
    SHORT txWidth;
    struct Screen *screen1 = NULL;
    struct Window *window1 = NULL;


    /* Save the old window pointer now, so that cleanExit() has it
     * if it needs it.
     */
    oldwindowptr = myProcess->pr_WindowPtr;

    /* Open the Intuition Library */
    IntuitionBase = (struct IntuitionBase *)
                    OpenLibrary( "intuition.library",INTUITION_REV );

    if (IntuitionBase == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Open any other required libraries */
    GfxBase = (struct GfxBase *)
                     OpenLibrary("graphics.library",GRAPHICS_REV);

    if (GfxBase == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Open the screen */
    screen1 = OpenScreen(&fullHires);
    if (screen1 == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Attach the window to the open screen ... */
    agateWindow.Screen = screen1;


    /* Conceal the screen title */
    ShowTitle( screen1, (BOOL)FALSE );


    /* ... and open the window */
    window1 = OpenWindow(&agateWindow);
    if (window1 == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Now is the time to redirect system requesters. */
    myProcess = (struct Process *)FindTask(NULL);   /* Finds our process */
    myProcess->pr_WindowPtr = (APTR)window1;


    /* Write at the top edge of the window                */
    /* Get the text width to space the greeting properly. */
    txWidth = IntuiTextLength(&hello);


    /* Print text five times, one pixel down from the top. */
    for ( i = 0; i < 5; i++ )
        PrintIText( window1->RPort, &hello, i*txWidth, 1 );

    PAUSE( 6 );

    /* Set up the signals that you want to hear about ... */
    /* No signals in this program                         */


    /* Exit the program */
    cleanExit(screen1, window1, RETURN_OK);


}

VOID cleanExit( scrn, wind, returnValue )
struct Screen *scrn;
struct Window *wind;
int returnValue;
{
    /* Close things in the reverse order of opening */


    /* Restore the old window pointer to our process. */
    /* Don't test 'oldwindowptr', since NULL is a valid
     * value for pr_WindowPtr.
     */
    myProcess->pr_WindowPtr = oldwindowptr;

    /* Close the window and screen. */
    if (wind) CloseWindow( wind );
    if (scrn) CloseScreen( scrn );


    /* Close the library, and then exit */
    if (GfxBase) CloseLibrary( (struct Library *)GfxBase );
    if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );


    exit(returnValue);

}

