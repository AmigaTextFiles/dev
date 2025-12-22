/* **************************************************************************

$RCSfile: ResizingExample.c $

$Revision: 1.5 $
    $Date: 1994/12/18 15:20:27 $

    GUIEnvironment example: Resizing, GUIEnvironment gadgets

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

************************************************************************** */

/* This example shows, how the gadget descriptions can be used for
   resizable gadgets. It also shows the GUIEnvironment gadgets in action !
   It shows also the simple to use font adaptivity */

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <proto/exec.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <libraries/gadtools.h>

#include "guienv.h"
#include "guienvsupport.h"

UBYTE *vers = "\0$VER: ResizingExample 37.6 (18.12.94)\n";

struct Library *GUIEnvBase;

struct GUIInfo *gui;
struct Window  *win;

int loop;

LONG prg;                      /* for the progressIndicatorKind */

struct MinList alist, clist;   /* Lists for ListviewKind gadget */

char *listviewALabs[] = {"Amiga 500", "Amiga 500+", "Amiga 600",
                         "Amiga 1000", "Amiga 1200", "Amiga 2000",
                         "Amiga 3000", "Amiga 4000/030", "Amiga 4000/040",
                         "Amiga XXXX/yyy"};
char *listviewCLabs[] = {"8086", "80286", "80386", "80486", "Pentium",
                         "68000", "68020", "68030", "68040", "68060"};



VOID main(VOID)
{


  struct Node *entry;
  int i;
  /* open GUIEnvironment.library */

  GUIEnvBase = OpenLibrary(GUIEnvName, 37);

  /* Creates two exec.lists. One contains some amiga-models and the other
     some cpu-kinds ! */

  NewList(&alist);
  NewList(&clist);

  /* make the list-entries */
  for(i=0; i<=9; i++)
  {
    entry = AllocMem(sizeof(struct Node), MEMF_CLEAR);
    if (entry)
    {
      entry->ln_Name = listviewALabs[i];
      Insert(&alist, entry, NULL);
    }
    entry = AllocMem(sizeof(struct Node), MEMF_CLEAR);
    if (entry)
    {
      entry->ln_Name = listviewCLabs[i];
      Insert(&clist, entry, NULL);
    }
  }


  win = OpenGUIWindow( 50, 50, 300, 150, "GUIEnvironment - ResizingExample",
                      IDCMP_GADGETUP|IDCMP_CLOSEWINDOW|
                      IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW|
                      IDCMP_VANILLAKEY|IDCMP_GADGETDOWN,
                      WFLG_ACTIVATE|WFLG_SIZEGADGET|
                      WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_DRAGBAR, NULL,
                      WA_MinWidth, 250,
                      WA_MinHeight,120,
                      WA_MaxWidth, 500,
                      WA_MaxHeight,200, NULL);
  if (win)
  {
    gui = CreateGUIInfo(win, GUI_CreationFont, TopazAttr(), NULL);
    if (gui)
    {
      /* This gadget is always 10 points away from the left, the top and
         the also the right window border. And it is also always 35 points
         away from the bottom window border */

      CreateGUIGadget(gui, 10, 20, -10, -35, GEG_ProgressIndicatorKind,
                      GEG_Text, "Progress",
                      GEG_Flags, PLACETEXT_ABOVE,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjTop,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjBottom),
                      NULL);

      /* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points right of the window border.
         Its size is constant. */
      CreateGUIGadget(gui, 10, 10, 70, 18, BUTTON_KIND,
                      GEG_Text, "_Plus",
                      GEG_Flags, PLACETEXT_IN,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjGadget+GEG_ObjBottom,
                                               GEG_DistNorm,
                                               GEG_DistNorm),
                      NULL);

      /* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points left of the window border.
         Its size is constant. Now we need the gegObjects tag,
         because we don't refer to the previous gadget !
         To say, this gadget is 10 points left of the right window border,
         we must say it is 10+width away from the border !*/
      CreateGUIGadget(gui, -80, 10, 70, 18, BUTTON_KIND,
                      GEG_Text, "_Minus",
                      GEG_Flags, PLACETEXT_IN,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistAbs+GEG_ObjGadget+GEG_ObjBottom,
                                               GEG_DistNorm,
                                               GEG_DistNorm),
                      GEG_Objects, GADOBJS(0, 0, 0, 0),
                      NULL);

      if (DrawGUI(gui, NULL) == GE_Done)
      {
        loop = 0;
        prg = 0;
        while (loop == 0)
        {
          WaitGUIMsg(gui);

          if (gui->msgClass == IDCMP_CLOSEWINDOW) loop = 1;
          if ((gui->msgClass == IDCMP_GADGETUP)||(gui->msgClass == IDCMP_GADGETDOWN))
          {
            if (gui->msgGadNbr == 1)
            {
              if (prg < 10) prg++;
              SetGUIGadget(gui, 0, GEG_PICurrentValue, prg * 10, NULL);
            }
            if (gui->msgGadNbr == 2)
            {
              if (prg > 0) prg--;
              SetGUIGadget(gui, 0, GEG_PICurrentValue, prg * 10, NULL);
            }
          }
          if (gui->msgClass == IDCMP_NEWSIZE) loop = 1;
            /* We only get this message if GUIEnvironment can't resize ! */
        }
      }

      /* And now a total new GUI: */
      ChangeGUI(gui, GUI_RemoveGadgets, 1, NULL);

      /* We don't know the actual size of the window now, but our GUI was
        designed for the size 300/150, so we have to say this to GUIEnv.
        We don't want to resize the window, so using the preserve window
        tag tells GUIEnvironment to do so */
      ChangeGUI(gui, GUI_CreationWidth, 300,
                     GUI_CreationHeight, 150,
                     GUI_PreserveWindow, GUI_PWFull, NULL);

      /* This string gadget is for the listview gadget to display the
         selected entry ! To the left and to the right it is 20 points
         away from the window border. */
      CreateGUIGadget(gui, 20, -45, -20, 13, STRING_KIND,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjBottom,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistNorm),
                      NULL);

      /* This gadget is always 20 points away from the left and the right
         window border. And it is also always 45 points away from the
         bottom window border and 30 from the top window border. */

      CreateGUIGadget(gui, 20, 30, -20, -45, LISTVIEW_KIND,
                      GEG_Text, "_List",
                      GEG_Flags, PLACETEXT_ABOVE,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjTop,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjBottom),
                      GTLV_Labels, &alist,
                      GTLV_ShowSelected, GetGUIGadget(gui, 0, GEG_Address), /* the prev. gadget*/
                      NULL);

      /* This gadget is always 10 points below the listviewKind
         gadget and always 20 points right of the window border.
         Its size is constant. */
      CreateGUIGadget(gui, 20, 10, 70, 18, BUTTON_KIND,
                      GEG_Text, "_Amigas",
                      GEG_Flags, PLACETEXT_IN,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjGadget+GEG_ObjBottom,
                                               GEG_DistNorm,
                                               GEG_DistNorm),
                      NULL);

      /* This gadget is always 10 points below the listviewKind gadget
         as the previous gadget is also and always 20 points left of the
         window border. Its size is constant.
         To say this gadget is 20 points left of the right window border,
         we must say it is 20+width away from the border !*/
      CreateGUIGadget(gui, -90, 0, 70, 18, BUTTON_KIND,
                      GEG_Text, "_CPUs",
                      GEG_Flags, PLACETEXT_IN,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistAbs+GEG_ObjGadget+GEG_ObjTop,
                                               GEG_DistNorm,
                                               GEG_DistNorm),
                      NULL);

      /* This gadget draws a border around all gadgets which is always
         10 points away from every border */
      CreateGUIGadget(gui, 10, 10, -10, -10, GEG_BorderKind,
                     GEG_Text, "Choose something",
                     GEG_Flags, PLACETEXT_ABOVE|NG_HIGHLABEL,
                     GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                              GEG_DistAbs+GEG_ObjBorder+GEG_ObjTop,
                                              GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                              GEG_DistAbs+GEG_ObjBorder+GEG_ObjBottom),
                     NULL);

      if (DrawGUI(gui, NULL) == GE_Done)
      {
        loop = 0;
        while (loop == 0)
        {
          WaitGUIMsg(gui);

          if (gui->msgClass == IDCMP_CLOSEWINDOW) loop = 1;
          if ((gui->msgClass == IDCMP_GADGETUP)||(gui->msgClass == IDCMP_GADGETDOWN))
          {
            if (gui->msgGadNbr == 2) /* Amiga-list */
              SetGUIGadget(gui, 1, GTLV_Labels, &alist, NULL);
            if (gui->msgGadNbr == 3) /* CPU-list */
              SetGUIGadget(gui, 1, GTLV_Labels, &clist, NULL);
          }
          if (gui->msgClass == IDCMP_NEWSIZE) loop = 1;
            /* We only get this message if GUIEnvironment can't resize ! */
        }
      }
    }
  }

  if (win) CloseGUIWindow(win);
  while (alist.mlh_TailPred != &alist)  /* free list */
    FreeMem(RemTail(&alist), sizeof(struct Node));
  while (clist.mlh_TailPred != &clist)  /* free list */
    FreeMem(RemTail(&clist), sizeof(struct Node));
}

