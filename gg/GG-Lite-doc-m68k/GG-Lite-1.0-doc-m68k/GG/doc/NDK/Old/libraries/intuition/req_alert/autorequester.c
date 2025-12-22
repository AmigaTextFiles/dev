
/* autorequester.c */ 
/* This program implements an autorequester.                 */
/* Inserting a disk will make the requester go away but you  */
/* must still click on the close gadget to end the program.  */
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

/* Include user-written header files here. */
#include "hires.h"
#include "graniteWindow.h"

struct IntuiText reqtext[] = {
    { 1,2,JAM2,20,5,NULL,"An Autorequester",NULL },
    { 0,1,JAM2,5,4,NULL,"YES",NULL },
    { 0,1,JAM2,6,4,NULL,"NOT YET", NULL }
};


/* Use lowest non-obsolete version that supplies the functions you need. */
#define INTUITION_REV 33

extern VOID cleanExit( struct Screen *, struct Window *, int );
extern UBYTE handleIDCMP( struct Window *);

struct IntuitionBase *IntuitionBase = NULL;
        
VOID main(int argc, char *argv[])
{
    /* Declare variables here */
    ULONG signalmask, signals;
    UBYTE done = 0;
    struct Screen *screen1 = NULL;
    struct Window *window1 = NULL;

    /* Open the Intuition Library */
    IntuitionBase = (struct IntuitionBase *)
                    OpenLibrary( "intuition.library",INTUITION_REV );

    if (IntuitionBase == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Open the screen */
    screen1 = OpenScreen(&fullHires);
    if (screen1 == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Make the assignments that were postponed above */


    /* Attach the window to the open screen ... */
    graniteWindow.Screen = screen1;


    /* ... and open the window */
    window1 = OpenWindow(&graniteWindow);
    if (window1 == NULL)
        cleanExit(screen1, window1, RETURN_WARN);


    /* Set up the signals that you want to hear about ... */
    signalmask = 1L << window1->UserPort->mp_SigBit;


    /* Call the functions that do the main processing */
    /* Call the autorequester */
    AutoRequest( window1,&reqtext[0],&reqtext[1],&reqtext[2],
                   DISKINSERTED,0,200,50 );


    /* And wait to hear from your signals */      
    while( !done ) {

        signals = Wait(signalmask);    
        if (signals & signalmask)
            done = handleIDCMP(window1);
    };


    /* Exit the program */
    cleanExit(screen1, window1, RETURN_OK);


}

UBYTE handleIDCMP( struct Window *win )
{
    UBYTE flag = 0;
    struct IntuiMessage *message = NULL;
    ULONG class;

    /* Examine pending messages */
    while( message = (struct IntuiMessage *)GetMsg(win->UserPort) ) {

        class = message->Class;
 
        /* When we're through with a message, reply */
        ReplyMsg( (struct Message *)message);


        /* See what events occurred */
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

VOID cleanExit( scrn, wind, returnValue )
struct Screen *scrn;
struct Window *wind;
int returnValue;
{
    /* Close things in the reverse order of opening */


    /* Close the window and the screen */
    if (wind) CloseWindow( wind );
    if (scrn) CloseScreen( scrn );


    /* Close the library, and then exit */
    if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );


    exit(returnValue);

}

