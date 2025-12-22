
/* IDCMPDemo.c -- Tests the IDCMP by printing IDCMP classes */
/*                to the console.                           */
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
#include <stdio.h>
int CXBRK(void) {return(0);}
#endif
/* Include other required vendor- or Commodore-Amiga-supplied header */
/*  files here.                                                      */

/* Include user-written header files here. */
#include "quartzWindow.h"

/* Use lowest non-obselete version that supplies the functions you need. */
#define INTUITION_REV 33

extern VOID cleanExit( struct Window *, int );
extern UBYTE handleIDCMP( struct Window * );

struct IntuitionBase *IntuitionBase = NULL;
        
VOID main(int argc, char *argv[])
{
    /* Declare variables here */
    ULONG signalmask, signals, moreFlags;
    UBYTE done = 0;
    struct Window *window1 = NULL;


    /* Open the Intuition Library */
    IntuitionBase = (struct IntuitionBase *)
                    OpenLibrary( "intuition.library",INTUITION_REV );

    if (IntuitionBase == NULL)
        cleanExit(window1, RETURN_WARN);


    /* Open any other required libraries */


    /* Make the assignments that were postponed above */
    /* We need a couple more flags in the window      */

    quartzWindow.Flags |= REPORTMOUSE | RMBTRAP;
    quartzWindow.Type = WBENCHSCREEN;


    /* Open the window */
    window1 = OpenWindow(&quartzWindow);
    if (window1 == NULL)
        cleanExit(window1, RETURN_WARN);


    /* QuartzWindow has only the CLOSEWINDOW IDCMP flag set. */
    /* We'll set all of the following flags in quartzWindow  */
    /* by using the ModifyIDCMP() function.                  */
    moreFlags = CLOSEWINDOW | NEWSIZE | DISKINSERTED |
                DISKREMOVED | MOUSEBUTTONS;

    ModifyIDCMP( window1, moreFlags );


    /* Set up the signals that you want to hear about ... */
    signalmask = 1L << window1->UserPort->mp_SigBit;


    /* Call the functions that do the main processing */
    /* None to call in this example */


    /* And wait to hear from your signals */      
    while( !done ) {

        signals = Wait(signalmask);    
        if (signals & signalmask)
            done = handleIDCMP(window1);
    };


    /* Exit the program */
    cleanExit(window1, RETURN_OK);


}

UBYTE handleIDCMP( struct Window *win )
{
    UBYTE flag = 0;
    struct IntuiMessage *message = NULL;
    USHORT code;
    SHORT mousex, mousey;
    ULONG class;

    /* Examine pending messages */
    while( message = (struct IntuiMessage *)GetMsg(win->UserPort) ) {

        class = message->Class;
        code = message->Code;
        mousex = message->MouseX;
        mousey = message->MouseY;
        
        /* When we're through with a message, reply */
        ReplyMsg( (struct Message *)message);

        /* See what events occurred */
        switch( class ) {
        
            case CLOSEWINDOW:            
                flag = 1;
                break;
            case NEWSIZE:
                printf( "NEWSIZE\n" );
                break;
            case DISKINSERTED:
                printf( "DISKINSERTED\n" );
                break;
            case DISKREMOVED:
                printf( "DISKREMOVED\n" );
                break;
            case MOUSEBUTTONS:
                switch( code )
                {
                    case SELECTUP:
                        printf( "SELECTUP at %d,%d\n",mousex,mousey );
                        break;
                    case SELECTDOWN:
                        printf( "SELECTDOWN at %d,%d\n",mousex,mousey );
                        break;
                    case MENUUP:
                        printf( "MENUUP\n" );
                        break;
                    case MENUDOWN:
                        printf( "MENUDOWN\n" );
                        break;
                    default:
                        printf( "UNKNOWN CODE\n" );
                        break;
                }; /* end of switch on code */
		break;
            default:
                printf( "Unknown IDCMP message\n" );
                break;
                
        } /* End switch */        
    }   /* End while */

    /* Flush any remaining pending messages */

    while( message = (struct IntuiMessage *)GetMsg(win->UserPort))
                  ReplyMsg( (struct Message *)message );


    return(flag);
}

VOID cleanExit( wind, returnValue )
struct Window *wind;
int returnValue;
{
    /* Close things in the reverse order of opening */

    /* Close the windows */

    if (wind) CloseWindow( wind );


    /* Close the library, and then exit */

    if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );


    exit(returnValue);

}

