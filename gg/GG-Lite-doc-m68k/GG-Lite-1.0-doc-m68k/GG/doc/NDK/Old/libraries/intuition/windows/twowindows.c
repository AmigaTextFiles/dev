
/* twowindows.c                                               */
/* Shows the function of the ACTIVATE flag, and how to wait   */
/* for messages from two windows                              */
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

/* Include user-written header files here. For illustration, we show */
/*  two header files which we will use frequently.                   */
#include "hires.h"
#include "graniteWindow.h"
#include "hellogoodbye.h"

/* Use lowest non-obselete version that supplies the functions you need. */
#define INTUITION_REV 33
#define GRAPHICS_REV  33
/* TICKS_PER_SECOND (defined in libraries/dos.h)
   NEVER call Delay() with an argument of 0 !
*/
#define PAUSE(seconds)	(Delay((seconds) * TICKS_PER_SECOND))


extern VOID cleanExit( struct Screen *, struct Window *, struct Window *,
                       int returnValue);
extern UBYTE handleIDCMP( struct Window * );


struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;
/* The following two lines are for system requester redirection. */
APTR oldwindowptr = NULL;
struct Process *myProcess = NULL;

        
VOID main(int argc, char *argv[])
{
    /* Declare variables here */

    ULONG aSignalmask, bSignalmask, signals;
    USHORT aDone = FALSE, bDone = FALSE, i, fontHeight;
    struct Screen *screen1 = NULL;
    struct Window *aWindow = NULL, *bWindow = NULL;

    /* Save the value of the old window pointer now,
     * in case cleanExit() needs it.
     */

    oldwindowptr = myProcess->pr_WindowPtr;

    /* Open the Intuition Library */
    
    IntuitionBase = (struct IntuitionBase *)
                    OpenLibrary( "intuition.library",INTUITION_REV );

    if (IntuitionBase == NULL)
        cleanExit( screen1, aWindow, bWindow, RETURN_WARN);

    /* Open any other required libraries */

    GfxBase = (struct GfxBase *)
              OpenLibrary("graphics.library", GRAPHICS_REV);

    if ( GfxBase == NULL)
        cleanExit( screen1, aWindow, bWindow, RETURN_WARN);

    /* Make the assignments that were postponed above */

    graniteWindow.Width = 300;
    graniteWindow.Height = 100;
    graniteWindow.Title = "aWindow";

    /* Open the screen */

    screen1 = OpenScreen(&fullHires);
    if (screen1 == NULL)
        cleanExit( screen1, aWindow, bWindow, RETURN_WARN);


    /* Attach the window to the open screen ... */

    graniteWindow.Screen = screen1;

    /* ... and open the window */

    aWindow = OpenWindow(&graniteWindow);
    if (aWindow == NULL)
        cleanExit( screen1, aWindow, bWindow, RETURN_WARN);


    /* Now is the time to redirect system requesters. */

    myProcess = (struct Process *)FindTask(NULL);   /* Finds our process */
    myProcess->pr_WindowPtr = (APTR)aWindow;


    /* Now find out how big the font is, and write the greeting */

    fontHeight = (SHORT)aWindow->RPort->Font->tf_YSize;
    hello.TopEdge = fontHeight;

    PrintIText( aWindow->RPort, &hello, 5, (LONG)fontHeight );

    PAUSE(3L);

    /* The NewWindow structure is now free to be modified for */
    /*  the other window.                                     */

    graniteWindow.LeftEdge = 330;
    graniteWindow.Title = "bWindow";

    bWindow = OpenWindow(&graniteWindow);
    if (bWindow == NULL)
        cleanExit( screen1, aWindow, bWindow, RETURN_WARN);

    PrintIText( bWindow->RPort, &hello, 5, (LONG)fontHeight );

    /* Now's a good time to finish initializing the IntuiText. */

    other[0].NextText = &other[1];
    other[1].NextText = &other[2];

    /* Fill in the IntuiText vertical offset for the message */

    for ( i = 0; i < 3; i ++ )
        other[i].TopEdge = ( i + 1 ) * fontHeight;

    /* Set up the signals that you want to hear about ... */

    aSignalmask = 1L << aWindow->UserPort->mp_SigBit;
    bSignalmask = 1L << bWindow->UserPort->mp_SigBit;

    /* Call the functions that do the main processing */

    /* And wait to hear from your signals */
      
    while( !aDone || !bDone ) {

        signals = Wait(aSignalmask | bSignalmask);    
        if (signals & aSignalmask)
            aDone = handleIDCMP(aWindow);
        if (signals & bSignalmask)
            bDone = handleIDCMP(bWindow);
        if (aWindow && aDone) {           /* Close bWindow! */

            PrintIText(bWindow->RPort, &other[0], 5L, 20L);
            PAUSE( 3L );
            CloseWindow(bWindow);
            bWindow = NULL;
            bSignalmask = 0L;
        }   
        if (bWindow && bDone) {           /* Close aWindow! */

            PrintIText(aWindow->RPort, &other[0], 5L, 50L);
            PAUSE( 3L );

            /* We're about to close the window that our Process
             * is pointing to, so we must switch our Process
             * to the other window, first.
            */
            myProcess->pr_WindowPtr = (APTR)bWindow;
            
            CloseWindow(aWindow);
            aWindow = NULL;
            aSignalmask = 0L;
        }

        /* If either window has been closed, then the user cannot */
        /* close the remaining window, so we must close it and    */
        /* go away.                                               */

        if ( !aWindow || !bWindow )
           break;           
    }

    /* Exit the program */

    PAUSE( 3L );
    cleanExit( screen1, aWindow, bWindow, RETURN_WARN);


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

VOID cleanExit( scrn, aWind, bWind, returnValue )
struct Screen *scrn;
struct Window *aWind, *bWind;
int returnValue;
{
    /* Close things in the reverse order of opening */

    /* Restore the old window pointer in our process.
     * Don't test 'oldwindowptr', since NULL is a valid
     * value for pr_WindowPtr.
     */
    myProcess->pr_WindowPtr = oldwindowptr;    

    /* Close the window and the screen. */
    if (bWind) CloseWindow( bWind );
    if (aWind) CloseWindow( aWind );

    if (scrn) CloseScreen( scrn );


    /* Close the library, and then exit */
    if (GfxBase) CloseLibrary( (struct Library *)GfxBase );
    if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );


    exit(returnValue);

}

