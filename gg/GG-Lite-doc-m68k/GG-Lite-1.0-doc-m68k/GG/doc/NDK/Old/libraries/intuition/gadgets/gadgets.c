/* Gadgets.c */
/* How to use EACH kind of 1.2/1.3 Gadget Types                      */
/* Try typing small integers into the string gadget, and hit return  */
/* Compiled with Lattice C v5.02                                     */
/* Compiler invoked with: lc -b1 -cfist -L -v -ms                    */

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
#include <graphics/gfxbase.h>
#include <libraries/dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef LATTICE
#include <proto/all.h>
#endif

#define RP window->RPort
#define TOT_DISPLAY     10
#define LINE_HEIGHT     9
#define MAX_VALUE       9999

#include "gadgets.h"

/* function declarations */
VOID    OpenAll(VOID);
VOID    cleanExit(int);
USHORT  HandleUGad(struct IntuiMessage *);
USHORT  HandleDGad(struct IntuiMessage *);
VOID    InitSlider(struct Gadget *g);
VOID    GetSlider(struct Gadget *, SHORT);
VOID    DisplayEntries(VOID);
VOID    PrintText(struct RastPort *rp, UBYTE *msg,
          USHORT x, USHORT y, USHORT f, USHORT b);

/* global declarations */
struct  GfxBase *GfxBase = NULL;
struct  IntuitionBase *IntuitionBase = NULL;
struct  Window  *window = NULL;

/* for showing the list information */
LONG    numentries;
LONG    topentry;

VOID  main( int argc, char *argv[] )
{
struct  IntuiMessage *msg = NULL;
ULONG   class;
USHORT  flagi;

    OpenAll();
    flagi=TRUE;
    while(flagi) {
       Wait(1L << window->UserPort->mp_SigBit);
       while(msg=(struct IntuiMessage *)GetMsg(window->UserPort)) {
          class=msg->Class;
          switch(class) {
            case INTUITICKS:
              if(ArrowGads[0].Flags&SELECTED) GetSlider(&VertSlider,-1);
              if(VertSlider.Flags&SELECTED)   GetSlider(&VertSlider, 0);
              if(ArrowGads[1].Flags&SELECTED) GetSlider(&VertSlider, 1);
              break;
            case GADGETDOWN:
              flagi=HandleDGad(msg); break;
            case GADGETUP:
              flagi=HandleUGad(msg); break;
            case CLOSEWINDOW:
              flagi=FALSE; break;
            default: break;
          }
          ReplyMsg((struct Message *)msg);
	}
    }
    cleanExit(0);
}


/* For this example, this is just used to clear the
 * message areas.  You could use it to start a function
 * on the down-press of a gadget 
 */

USHORT  HandleDGad(struct IntuiMessage *m)
{
struct  Gadget  *g;
USHORT  id;
UBYTE   msg[12];
USHORT  retval;

    retval=TRUE;
    strcpy(msg,"           \000");
    g = (struct Gadget *)m->IAddress;
    id = g->GadgetID;

/* clear the entry number area */
    PrintText(RP, msg, 10, 139, 1, 0);

/* clear the button number area */
    sprintf(msg, "ID %-4dd", id);
    PrintText(RP, msg, 104, 139, 1, 0);

/* return */
    return(retval);
}


USHORT  HandleUGad(struct IntuiMessage *m)
{
struct  Gadget  *g;
USHORT  id;
UBYTE   msg[12];
USHORT  retval;
USHORT  entry;

    retval=TRUE;
    g = (struct Gadget *)m->IAddress;
    id = g->GadgetID;
    switch(id) {
       case 1:  /* The ENTRY area */
          entry = topentry + ((m->MouseY - g->TopEdge + 1) / LINE_HEIGHT) + 1;
          if(entry > numentries)   entry = 0;
          sprintf(msg, "Entry %-4d", entry);
          PrintText(RP, msg, 10, 139, 1, 0);
          break;
       case 2:  /* Clicked in the body of the Vertical PROP */
          GetSlider(&VertSlider, 0);
          break;
       case 5:  /* The STRING gadget */
          /* Get the number of entries.  Filter it out, put it back
           * into the String gadget and display it.
           */
          numentries = NameGadSInfo.LongInt;
          if(numentries>MAX_VALUE)     numentries=MAX_VALUE;
          sprintf(NameGadSIBuff, "%d\000", numentries);
          RefreshGList(&NameGad, window, NULL, 1);
          InitSlider(&VertSlider);
          break;
       case 6:  /* OKAY button */
       case 7:  /* CANCEL button */
          retval = FALSE;
          break;
       default:
          break;
    }
/* show the button number that we pushed */
    sprintf(msg, "ID %-4du", id);
    PrintText(RP, msg, 104, 139, 1, 0);

/* return */
    return(retval);
}


/* Initialize the proportional gadget
 */

VOID    InitSlider(struct Gadget *g)
{
    topentry=0L;
    if(numentries>TOT_DISPLAY)
    {
       NewModifyProp(g,window,NULL,AUTOKNOB|FREEVERT,
         NULL,((MAXBODY*topentry)/(numentries)),
         MAXBODY,((MAXBODY*TOT_DISPLAY)/numentries),1L);
    }
    else
    {
       NewModifyProp(g,window,NULL,AUTOKNOB|FREEVERT,
         NULL,NULL,MAXBODY,MAXBODY,1L);
    }
/* clear the entry area */
    RefreshGList(&BackDrop,window,NULL,1);
/* display the current entries */
    DisplayEntries();
}


/* Get the current entry, based on either the movement of the
 * proportional gadget, or the pressing of the arrow keys.
 */

VOID    GetSlider(struct Gadget *g, SHORT dir)
{
USHORT  potv;
struct  PropInfo *p;
static  USHORT  update=0;

    p=(struct PropInfo *)g->SpecialInfo;
    if(dir!=0)
    {
       topentry += (LONG)dir;
       if(topentry>0L && topentry<(numentries-TOT_DISPLAY))
       {
          potv=((MAXBODY*topentry)/(numentries-TOT_DISPLAY));
          update=0;
       }
       else
       {
          /* It is necessary that the check for topentry>=numentries
           * is before topentry<=0 to catch the instance when
           * numentries < TOT_DISPLAY
           */
          if(topentry>=(numentries-TOT_DISPLAY))
          {
             potv=MAXBODY;
             topentry=(numentries-TOT_DISPLAY);
             update++;
          }
          if(topentry<=0L)
          {
             potv=0;
             topentry=0L;
             update++;
          }
       }
       if(numentries>TOT_DISPLAY && update<3)
       {
          NewModifyProp(g,window,NULL,AUTOKNOB|FREEVERT,
            NULL,(LONG)potv,MAXBODY,
            ((MAXBODY*TOT_DISPLAY)/numentries-TOT_DISPLAY),1L);
       }
    }
    else
    {
       if(numentries>TOT_DISPLAY)
          topentry=(p->VertPot*(numentries-TOT_DISPLAY))/MAXBODY;
       else
          topentry=0L;
    }
    DisplayEntries();
}


/* Update the display to show the current view of entries. */

VOID    DisplayEntries(VOID)
{
UBYTE   msg[5];
register LONG i;

/* update the display */
    for(i=0; (i<TOT_DISPLAY && i<numentries); i++)
    {
       sprintf(msg,"%4ld", i + topentry + 1L);
       PrintText(RP, msg,
          7, (USHORT)(EntryBox.TopEdge + (i * LINE_HEIGHT)), 1, 2);
    }

/* put the pen back the way it was */
    SetBPen(RP, 0);
}

VOID    PrintText(struct RastPort *rp, UBYTE *msg,
          USHORT x, USHORT y, USHORT f, USHORT b)
{
    strcpy(Buffer, msg);
    Messages.FrontPen = f;
    Messages.BackPen = b;
    PrintIText(rp, &Messages, (LONG)x, (LONG)y);
}

VOID    cleanExit(int retval)
{
    if(window)          CloseWindow(window);
    if(GfxBase)         CloseLibrary((struct Library *)GfxBase);
    if(IntuitionBase)   CloseLibrary((struct Library *)IntuitionBase);
    exit(retval);
}

VOID    OpenAll(VOID)
{
struct Gadget *g;

    if(!(IntuitionBase=(struct IntuitionBase *)
     OpenLibrary("intuition.library",33)))
       cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);
    if(!(GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",33)))
       cleanExit(ERROR_INVALID_RESIDENT_LIBRARY);

/* center the window */
    NewWindow.TopEdge = (GfxBase->NormalDisplayRows - NewWindow.Height) / 2;
    NewWindow.LeftEdge= (GfxBase->NormalDisplayColumns-NewWindow.Width) / 2;

/* open the window */
    if(!(window=OpenWindow(&NewWindow)))
       cleanExit(ERROR_NO_FREE_STORE);

/* Adjust the top of the gadgets relative to the upper border.
 * Usually is 11 if using Topaz80, 12 if using Topaz60
 */
    g=&VertSlider;
    while(g)
    {
       g->TopEdge += window->BorderTop;
       g = g->NextGadget;
    }

/* pre-initialize the list variables */
    numentries=100;

/* just to show how many entries we're working with */
    sprintf(NameGadSIBuff,"%d\000", numentries);

/* hook the gadgets to the window */
    AddGList(window, &VertSlider, 0, -1, NULL);

/* update the display to show the new gadgets */
    RefreshGList(&VertSlider, window, NULL, -1);

/* update the vertical proportional gadget information */
    InitSlider(&VertSlider);
}
