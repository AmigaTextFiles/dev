/* Wrapper
   Support routines needed by Text chapter examples.
   Insert routine(s) where indicated below, then compile, link, and run.
   For Lattice, compile and link with:  LC -b1 -cfist -L -v -y Wrapper.c

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
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/nodes.h>
#include <graphics/text.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>
#include <intuition/intuitionbase.h>
#include <libraries/dos.h>
#include <libraries/diskfont.h>
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Library pointers.
   Pointers are initialized to NULL so that the Close...()
   and Free...() routines can tell whether the pointers were used.
*/

struct GfxBase *GfxBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library *DiskfontBase = NULL;

/*  The Workbench pen color registers.  */
#define COLOR0 0
#define COLOR1 1
#define COLOR2 2
#define COLOR3 3

/*  do/don't wait for the user to click the close gadget before exiting.  */
#define WAIT_FOR_CLOSE  FALSE
#define DONT_WAIT       TRUE

/*
   Set the titlebar of the specified Window (w) to the specified string (s).
*/
#define TITLE(w, s) (SetWindowTitles((w), (UBYTE *)(s), (UBYTE *)~0))


/*
    ======================================================================
                      INSERT EXAMPLE CODE AFTER HERE
    ======================================================================
*/


/*
    ======================================================================
                      INSERT EXAMPLE CODE BEFORE HERE
    ======================================================================
*/


/*
   Open the graphics, intuition, and diskfont libraries.
   Return TRUE if completely successful, FALSE otherwise.
*/
BOOL openLibs(VOID)
{
GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 33L);
if (GfxBase)
    {
    IntuitionBase =
        (struct IntuitionBase *)OpenLibrary("intuition.library", 33L);
    if (IntuitionBase)
        {
        DiskfontBase = OpenLibrary("diskfont.library", 33L);
        if (DiskfontBase)
            return(TRUE);
        }
    }
return(FALSE);
}


/*
   Open a half-height, full-width window on the Workbench screen.
   Return a Window pointer if successful, NULL otherwise.
*/
struct Window *doWindow(VOID)
{
static struct NewWindow nw =
    {
    0, 0, 0, 0, -1, -1, CLOSEWINDOW,
    WINDOWCLOSE|WINDOWDEPTH|WINDOWDRAG|SMART_REFRESH|ACTIVATE|GIMMEZEROZERO,
    NULL, NULL, NULL, NULL, NULL, ~0, ~0, ~0, ~0, WBENCHSCREEN
    };
struct Window *window;

nw.Height = GfxBase->NormalDisplayRows / 2;
nw.Width  = GfxBase->NormalDisplayColumns;
window = OpenWindow(&nw);
return(window);
}


/*
   If requested, wait for the user to click on the Window's close gadget.
   Reply to any messages which may have accumulated, and close the Window.
*/
VOID undoWindow(struct Window *window, BOOL immediate)
{
struct IntuiMessage *intuiMessage;
if (window)
    {
    if (! immediate)
        (VOID) Wait(1<<window->UserPort->mp_SigBit);
    while (intuiMessage = (struct IntuiMessage *)GetMsg(window->UserPort))
        ReplyMsg((struct Message *)intuiMessage);
    CloseWindow(window);
    }
}


/*
   Close any libraries opened in openLibs().
*/
VOID closeLibs(VOID)
{
if (DiskfontBase)
    CloseLibrary(DiskfontBase);
if (IntuitionBase)
    CloseLibrary((struct Library *)IntuitionBase);
if (GfxBase)
    CloseLibrary((struct Library *)GfxBase);
}


/*
   Open the libraries, open a window, and call the example routine.
   Returns one of several values to the calling environment:
   RETURN_OK if successful, RETURN_ERROR if unable to open a window,
   and RETURN_FAIL if unable to open the needed libraries.
*/
VOID main(int argc, char *argv[])
{
int exitVal = RETURN_OK;
BOOL immediate = TRUE;
struct Window *window = NULL;

if (openLibs())
    {
    if (window = doWindow())
        immediate = example(window);
    else
        exitVal = RETURN_ERROR;
    undoWindow(window, immediate);
    }
else
    exitVal = RETURN_FAIL;
closeLibs();
exit(exitVal);
}

