/*  UserCopperExample
    User Copper List Example
    For Lattice, compile and link with:  LC -b1 -cfist -L -v -y uCopperExample.c

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
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/copper.h>
#include <intuition/intuition.h>
#include <hardware/custom.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdlib.h>

/*  Use this structure to gain access to the custom registers.  */
extern struct Custom far custom;

VOID openAll(VOID), cleanExit(int);
BOOL loadCopper(VOID);

struct IntuitionBase  *IntuitionBase = NULL;
struct GfxBase        *GfxBase = NULL;
struct Window         *window = NULL;
struct IntuiMessage   *intuiMessage;
struct ViewPort       *viewPort = NULL;
struct UCopList       *uCopList = NULL;

struct  NewWindow  newWindow =
{
    40,0,          /* Upper Left Corner */
    175,10,        /* Width and Height */
    -1,-1,         /* Use screen default pens */
    CLOSEWINDOW,   /* IDCMP flags */
    WINDOWDRAG|WINDOWDEPTH|WINDOWCLOSE|NOCAREREFRESH, /* Flags */
    NULL,          /* no gadgets */
    NULL,          /* use default checkmark image */
    "Copper!",     /* Title */
    NULL,          /* using WorkBench screen */
    NULL,          /* no super-bitmap */
    0,0,0,0,       /* no sizing */
    WBENCHSCREEN   /* it goes on the WorkBench screen */
};

#define NUMCOLORS      32
#define NUMLINES_EACH   8

UWORD  colors[] =
{
      0x0604, 0x0605, 0x0606, 0x0607, 0x0617, 0x0618, 0x0619,
      0x0629, 0x072a, 0x073b, 0x074b, 0x074c, 0x075d, 0x076e,
      0x077e, 0x088f, 0x07af, 0x06cf, 0x05ff, 0x04fb, 0x04f7,
      0x03f3, 0x07f2, 0x0bf1, 0x0ff0, 0x0fc0, 0x0ea0, 0x0e80,
      0x0e60, 0x0d40, 0x0d20, 0x0d00
};


VOID main(VOID)
{
openAll();    /* Open the libraries and a window. */
if (loadCopper())    /* Do the Copper specific stuff. */
    {
    /* Wait until the user clicks in the close gadget */
    (VOID) Wait(1<<window->UserPort->mp_SigBit);
    while (intuiMessage = (struct IntuiMessage *)GetMsg(window->UserPort)) 
        ReplyMsg((struct Message *)intuiMessage);

    }
cleanExit(RETURN_OK);
}


VOID openAll(VOID)
{
IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", 33L);
if (IntuitionBase == NULL)
    cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);
GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 33L);
if (GfxBase == NULL)
    cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);
if (! (window = OpenWindow(&newWindow)))    /* Open a Window. */
    cleanExit(ERROR_NO_FREE_STORE);
viewPort = ViewPortAddress(window);    /* Get a pointer to the ViewPort. */
}


VOID cleanExit(int retval)
{
if (uCopList)    /* Free the memory allocated for the Copper. */
    {
    FreeVPortCopLists(viewPort);
    RemakeDisplay();
    }
if (window)
    CloseWindow(window);
if (IntuitionBase)
    CloseLibrary((struct Library *)IntuitionBase);
if (GfxBase)
    CloseLibrary((struct Library *)GfxBase);
exit(retval);
}


BOOL loadCopper(VOID)
{
register USHORT i;

/* Allocate memory for the Copper list */
/* Make certain that the initial memory is cleared.  */
uCopList = (struct UCopList *)
  AllocMem(sizeof(struct UCopList), MEMF_PUBLIC|MEMF_CLEAR);
if (uCopList == NULL)
    return(FALSE);
CINIT(uCopList, NUMCOLORS);   /* Initialize the Copper list buffer. */
for (i=0; i<NUMCOLORS; i++)    /* Load in each color. */
    { 
    CWAIT(uCopList, (i*NUMLINES_EACH), 0);
    CMOVE(uCopList, custom.color[0], colors[i]);
    }
CEND(uCopList);    /* End the Copper list */
/*  Forbid task switching while changing the Copper list. */
Forbid();
viewPort->UCopIns=uCopList;
Permit();    /* Permit task switching again. */
RethinkDisplay();    /* Display the new Copper list. */
return(TRUE);
}

