/*
 * CTagSel.c:  Build an Amiga ListView gadget from stdin and return selected.
 * Particularly usefull with the output from "ctags -x".
 * (C) Copyright 1993, David A. Faught,  All rights reserved.
 * This information is provided "as is"; no warranties are made.
 * All use is at your own risk. No liability or responsibility is assumed.
 */

#include <workbench/startup.h>
#include <intuition/screens.h>
#include <graphics/displayinfo.h>
#include <exec/libraries.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <dos/dostags.h>
#include <dos/var.h>

#ifndef pdc
#ifndef __GNUC__
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/asl_protos.h>
#include <clib/alib_stdio_protos.h>
#endif
#endif

#ifdef __GNUC__
#include <tagdefs.h>
#endif

#include <stdio.h>

int main ();
void leave ();
BOOL HandleGadgetEvent (struct Window *, struct Gadget *, UWORD);
struct Gadget *CreateSelGadget (struct Gadget **, void *, UWORD);
void CreateSelList (struct MinList **);

#define GAD_LISTVIEW1 1
#define MAXNODE 999
#define MAXTEXT 39999

struct TextAttr Topaz80 =
{
   "topaz.font",
   8,
   0,
   0,
};

extern struct Library *SysBase;
struct GfxBase *GfxBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library *GadToolsBase = NULL;
struct TextFont *font = NULL;
struct Screen *mysc = NULL;
struct Gadget *glist = NULL;
struct Window *mywin = NULL;
void *vi = NULL;
struct Library *AslBase;

struct Node ListView1Node[1000];/* max nodes */
struct MinList ListView1List;

UBYTE *vers = "$VER: CtagSel 1.3 ("__DATE__")";
UWORD code1 = 0, nodenum = 0;
UWORD altsize[4] =
{510, 10, 130, 10};
BOOL terminated = FALSE;
char texts[40000];      /* max total size */

int
main (xac, xav)
     int xac;
     char *xav[];
{
   struct IntuiMessage *imsg;
   struct Gadget *gad;
   ULONG imsgClass;
   UWORD imsgCode;
   UWORD topborder;

   if (!(AslBase = OpenLibrary ("asl.library", 36L)))
      leave (20, "Requires V36 asl.library");

   if (!(GfxBase = (struct GfxBase *)
         OpenLibrary ("graphics.library", 36L)))
      leave (20, "Requires V36 graphics.library");

   if (!(IntuitionBase = (struct IntuitionBase *)
         OpenLibrary ("intuition.library", 36L)))
      leave (20, "Requires V36 intuition.library");

   if (!(GadToolsBase = OpenLibrary ("gadtools.library", 36L)))
      leave (20, "Requires V36 gadtools.library");

   if (!(font = OpenFont (&Topaz80)))
      leave (20, "Failed to open Topaz 80");

   if (!(mysc = LockPubScreen (NULL)))
      leave (20, "Couldn't lock default public screen");

   if (!(vi = GetVisualInfo (mysc,
              TAG_DONE)))
      leave (20, "GetVisualInfo() failed");

   CreateSelList (&ListView1List);

   topborder = mysc->WBorTop + (mysc->Font->ta_YSize + 1);

   if (!CreateSelGadget (&glist, vi, topborder))
     {
        leave (20, "CreateSelGadget() failed");
     }
   if (!(mywin = OpenWindowTags (NULL,
                  WA_Left, 0,
                  WA_Width, 420,
                  WA_Height, 200,
                  WA_Activate, TRUE,
                  WA_DragBar, TRUE,
                  WA_DepthGadget, TRUE,
                  WA_CloseGadget, TRUE,
                  WA_SizeGadget, FALSE,
                  WA_SimpleRefresh, TRUE,
            WA_IDCMP, CLOSEWINDOW | REFRESHWINDOW | LISTVIEWIDCMP,
                  WA_MinWidth, 0,
                  WA_MinHeight, 0,
                  WA_MaxWidth, 0,
                  WA_MaxHeight, 0,
                  WA_Zoom, altsize,
             WA_Title, "CTagSel 1.3, © 1993 David A. Faught",
                  WA_Gadgets, glist,
                  TAG_DONE)))
      leave (20, "OpenWindow() failed");

   GT_RefreshWindow (mywin, NULL);

   while (!terminated)
     {
        Wait (1 << mywin->UserPort->mp_SigBit);
        while ((!terminated) && (imsg = GT_GetIMsg (mywin->UserPort)))
          {
             imsgClass = imsg->Class;
             imsgCode = imsg->Code;
             gad = (struct Gadget *) imsg->IAddress;
             GT_ReplyIMsg (imsg);
             switch (imsgClass)
               {
               case GADGETDOWN:
               case MOUSEMOVE:
               case GADGETUP:
                  terminated = HandleGadgetEvent (mywin, gad, imsgCode);
                  break;

               case CLOSEWINDOW:
                  leave (5, NULL);
                  break;

               case REFRESHWINDOW:
                  GT_BeginRefresh (mywin);
                  GT_EndRefresh (mywin, TRUE);
                  break;
               }
          }
     }
   leave (0, NULL);
}

void
leave (code, error)
     int code;
     STRPTR error;

{
   if (mywin)
     {
        CloseWindow (mywin);
     }
   if (GadToolsBase)
     {
        FreeVisualInfo (vi);
        FreeGadgets (glist);
        CloseLibrary (GadToolsBase);
     }
   if (mysc)
     {
        UnlockPubScreen (NULL, mysc);
     }
   if (font)
     {
        CloseFont (font);
     }
   if (IntuitionBase)
     {
        CloseLibrary (IntuitionBase);
     }
   if (GfxBase)
     {
        CloseLibrary (GfxBase);
     }
   if (AslBase)
     {
        CloseLibrary (AslBase);
     }
   if (error)
     {
        printf ("Error: %s\n", error);
     }
   exit (code);
}

BOOL
HandleGadgetEvent (win, gad, code)
     struct Window *win;
     struct Gadget *gad;
     UWORD code;

{
   BOOL terminated = TRUE;
   char cmdbuff[200];

   switch (gad->GadgetID)
     {
     case GAD_LISTVIEW1:
        code1 = code;
        sprintf (cmdbuff, "rx \"a=setclip('CTagSel','%s')\"", ListView1Node[code1].ln_Name);
        system (cmdbuff);
        break;

     }
   return (terminated);
}

void
CreateSelList (listptr)
     struct MinList **listptr;

{

   struct Node *ln;

   char c;
   char *textptr, *textlin;
   int flds = 0;
   BOOL chcopy = TRUE;

   NewList (listptr);

   textlin = textptr = texts;
   while ((c = getchar ()) != EOF)
     {
        if (textlin == textptr)
           chcopy = TRUE;
        switch (c)
          {
          case ('\n'):
             *textptr++ = '\0';
             chcopy = FALSE;
             ListView1Node[nodenum].ln_Type = NULL;
             ListView1Node[nodenum].ln_Pri = NULL;
             ListView1Node[nodenum].ln_Name = textlin;
             AddTail (listptr, &ListView1Node[nodenum]);
             if (++nodenum >= MAXNODE)
                leave (20, "Too many nodes!");
             textlin = textptr;
             break;
          case ('\"'):
             c=' ';
             break;
          }
        if (chcopy)
           *textptr++ = c;
     }
}

struct Gadget *
CreateSelGadget (glistptr, vi, topborder)
     struct Gadget **glistptr;
     void *vi;
     UWORD topborder;

{
   struct NewGadget ng;
   struct Gadget *gad;

   gad = CreateContext (glistptr);

   ng.ng_TextAttr = &Topaz80;
   ng.ng_VisualInfo = vi;

   ng.ng_LeftEdge = 4;
   ng.ng_TopEdge = topborder;
   ng.ng_Width = 420 - 8;
   ng.ng_Height = 200 - topborder - 2;
   ng.ng_GadgetText = "";
   ng.ng_GadgetID = GAD_LISTVIEW1;
   ng.ng_Flags = PLACETEXT_ABOVE;
   gad = CreateGadget (LISTVIEW_KIND, gad, &ng,
             GTLV_Labels, &ListView1List, TAG_DONE);

   return (gad);
}
