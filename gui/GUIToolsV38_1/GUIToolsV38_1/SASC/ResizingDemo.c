/**********************************************************************
:Program.    ResizingDemo.c
:Contents.   guitools.library demonstration: Resizing, GUITools gadgets
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to GUITools documentation
:Language.   C
:Translator. SASC 6.51
:Remark.     OS 2.0 required
:Remark.     requires guitools.library V38.1
:History.    v1.0  Carsten Ziegeler  19-Apr-94
***********************************************************************/

/* ATTENTION: This modul is a straight translation of the modula2-demo.
              It may not take in some cases the easiest way to achive
              things, but it works ! */

/* This example shows, how the gadget descriptions can be used for
   resizable gadgets. It also shows the GUITools gadgets in action ! */

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>
#include <proto/exec.h>
#include "guitools.h"


struct Library *GUIToolsBase;

UBYTE *vers = "\0$VER: ResizingDemo 1.0 (19.04.94)";

char *listviewALabs[] = {"Amiga 500", "Amiga 500+", "Amiga 600",
                         "Amiga 1000", "Amiga 1200", "Amiga 2000",
                         "Amiga 3000", "Amiga 4000/030",
                         "Amiga 4000/040", "Amiga XXXX/yyy"};

char *listviewCLabs[] = {"2086", "80286", "80386", "80486",
                         "Pentium", "MC 68000", "MC 68020",
                         "MC 68030", "MC 68040", "MC 68060"};


/* Libraries will be opened by the auto init code ! Except GUITools !!*/

void main(void)
{
  struct Window *win;
  struct GUIInfo *gui;

  int  prg, ende;

  struct MinList alist, clist;        /* Lists for ListviewKind-Gadget */

  /* Creates two exec.lists. One contains some amiga-models and the other
     some cpu-kinds ! */
  struct Node *entry;
  int i;

  /* Init amiga-list & cpu-list */
  NewList(&alist);
  NewList(&clist);

  for(i=0; i<=9; i++)    /* make the list-entries */
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

  /* open GUITools.library */

  GUIToolsBase = OpenLibrary(GUIToolsName, 38);

  if ((GUIToolsBase == NULL) || (GUIToolsBase->lib_Version < 38) ||
     ((GUIToolsBase->lib_Version == 38) && (GUIToolsBase->lib_Revision == 0)))
    SimpleReq("You need at least the guitools.library V38.1 !", okReqKind);
  else
  {

    win = OpenIntWindowTags( 50, 50, 300, 150, "ResizingDemo",
                            IDCMP_GADGETUP | IDCMP_CLOSEWINDOW |
                            IDCMP_NEWSIZE | IDCMP_REFRESHWINDOW |
                            IDCMP_VANILLAKEY,
                            WFLG_ACTIVATE | WFLG_SIZEGADGET |
                            WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
                            WFLG_DRAGBAR, NULL,
                            WA_MinWidth, 250,
                            WA_MinHeight,120,
                            WA_MaxWidth, 500,
                            WA_MaxHeight,200, NULL);
    if (win)
    {
    /* The GFLG_DoResizing flags says GUITools to self resize the gadgets,
       and the GUI_UseGadDesc tag says use the objective orientated way to
       define gadgets ! The GUI_ResizableGads tag must also be set for
       resizing ! */

      gui = CreateGUIInfoTags(win, 5, 0, GUI_ResizableGads, 1,
                                         GUI_UseGadDesc, 1,
                   GUI_Flags, GFLG_AddBorderDims | GFLG_DoRefresh |
                              GFLG_VanillaKeysNotify | GFLG_ConvertKeys |
                              GFLG_DoResizing | GFLG_ListviewNotify,
                   GUI_GadFont, TopazAttr(), NULL);
      if (gui)
      {
        /* This gadget is always 10 points away from the left, the top and
           the also the right window border. And it is also always 35 points
           away from the bottom window border */

        CreateGadgetNew(gui, 10, 20, -10, -35, progressIndicatorKind,
                        SG_GadgetText, "Progress",
                        SG_GadgetFlags, PLACETEXT_ABOVE,
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                               distAbs+objBorder+objTop,
                                               distAbs+objBorder+objRight,
                                               distAbs+objBorder+objBottom),
                        NULL);

        gui->flags += GFLG_AddStdUnderscore;

        /* This gadget is always 10 points below the progessIndicatorKind
           gadget and always 10 points right of the window border.
           Its size is constant. */
        CreateGadgetNew(gui, 10, 10, 70, 18, BUTTON_KIND,
                        SG_GadgetText, "_Plus",
                        SG_GadgetFlags, PLACETEXT_IN,
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                               distAbs+objGadget+objBottom,
                                               distNorm,
                                               distNorm),
                        NULL);

        /* This gadget is always 10 points below the progessIndicatorKind
           gadget and always 10 points left of the window border.
           Its size is constant. Now we need the SG_GadgetObjects tag,
           because we refer not to the previous gadget !
           To say this gadget is 10 points left of the right window border,
           we must say it is 10+width away from the border ! */
        CreateGadgetNew(gui, -80, 10, 70, 18, BUTTON_KIND,
                        SG_GadgetText, "_Minus",
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objRight,
                                              distAbs+objGadget+objBottom,
                                              distNorm,
                                              distNorm),
                        SG_GadgetObjects, GADOBJS(0, 0, 0, 0), NULL);

        gui->flags -= GFLG_AddStdUnderscore;

        if (SetGUI(gui) == guiSet)
        {
          prg = 0;
          ende = 0;
          while (ende == 0)
          {
            WaitIntMsg(gui);

            if (gui->msgClass == IDCMP_CLOSEWINDOW) ende = 1;
            if (gui->msgClass == IDCMP_GADGETUP)
            {
              if (gui->gadID == 1)
              {
                if (prg < 10) prg++;
                ModifyGadget(gui, 0, SGPI_CurrentValue, prg * 10, NULL);
              }
              if (gui->gadID == 2)
              {
                if (prg >  0) prg--;
                ModifyGadget(gui, 0, SGPI_CurrentValue, prg * 10, NULL);
              }
            }
            if (gui->msgClass == IDCMP_NEWSIZE)
            {
              /* This does the GFLG_DoResizing flag for us, but:
                 The internal call to RedrawGadgets failt, so EXIT */
              ende = 1;
            }
          }
        }

        /* And now a total new GUI: */
        RemoveGadgets(gui, 1);
        ClearWindow(gui);

        /* We don't know the actual size of the window now, but our GUI was
          designed for the size 300/150, we have to say this to GUITools */
        gui->winIWidth  = 300;
        gui->winIHeight = 150;

        /* This string gadget is for the listview gadget to display the
           selected entry ! To the left and to the right it is 20 points
           away from the window border. */
        CreateGadgetNew(gui, 20, -45, -20, 13, STRING_KIND,
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                               distAbs+objBorder+objBottom,
                                               distAbs+objBorder+objRight,
                                               distNorm),
                        NULL);

        /* This gadget is always 20 points away from the left and the right
           window border. And it is also always 45 points away from the
           bottom window border and 30 from the top window border. */

        gui->flags += GFLG_AddStdUnderscore;
        CreateGadgetNew(gui, 20, 30, -20, -45, LISTVIEW_KIND,
                        SG_GadgetText, "_List",
                        SG_GadgetFlags,PLACETEXT_ABOVE,
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                               distAbs+objBorder+objTop,
                                               distAbs+objBorder+objRight,
                                               distAbs+objBorder+objBottom),
                        GTLV_Labels, &alist,
                        GTLV_ShowSelected, gui->gadget, /* the prev. gadget*/
                        NULL);

        /* This gadget is always 10 points below the listview
           gadget and always 20 points right of the window border.
           Its size is constant. */
        CreateGadgetNew(gui, 20, 10, 70, 18, BUTTON_KIND,
                        SG_GadgetText, "_Amigas",
                        SG_GadgetFlags, PLACETEXT_IN,
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                               distAbs+objGadget+objBottom,
                                               distNorm,
                                               distNorm),
                        NULL);

        /* This gadget is always 10 points below the listview gadget
           as the previous gadget is also and always 20 points left of the
           window border. Its size is constant.
           To say this gadget is 20 points left of the right window border,
           we must say it is 20+width away from the border ! */
        CreateGadgetNew(gui, -90, 0, 70, 18, BUTTON_KIND,
                        SG_GadgetText, "_CPUs",
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objRight,
                                               distAbs+objGadget+objTop,
                                               distNorm,
                                               distNorm),
                        NULL);

        /* This gadget draws a border around all gadgets which is always
           10 points away from every border */
        CreateGadgetNew(gui, 10, 10, -10, -10, bevelboxKind,
                        SGBB_Recessed, 1,
                        SG_GadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                               distAbs+objBorder+objTop,
                                               distAbs+objBorder+objRight,
                                               distAbs+objBorder+objBottom),
                        NULL);

        if (SetGUI(gui) == guiSet)
        {
          ende = 0;
          while (ende == 0)
          {
            WaitIntMsg(gui);

            if (gui->msgClass == IDCMP_CLOSEWINDOW) ende = 1;
            if (gui->msgClass == IDCMP_GADGETUP)
            {
              if (gui->gadID == 2)    /* Amiga-list */
                ModifyGadget(gui, 1, GTLV_Labels, &alist, NULL);
              if (gui->gadID == 3)    /* CPU-list */
                ModifyGadget(gui, 1, GTLV_Labels, &clist, NULL);
            }
            if (gui->msgClass == IDCMP_NEWSIZE)
            {
              /* This does the GFLG_DoResizing flag for us, but:
                 The internal call to RedrawGadgets failt, so EXIT */
              ende = 1;
            }
          }
        }
      }
      else
        SimpleReq("Unable to create gui-info-structure !", okReqKind);
    }
    else
      SimpleReq("Unable to open window !", okReqKind);

  }
  if (win != NULL)
  {
    CloseIntWindow(win);
  }
  while (alist.mlh_TailPred != &alist)  /* free list */
    FreeMem(RemTail(&alist), sizeof(struct Node));
  while (clist.mlh_TailPred != &clist)  /* free list */
    FreeMem(RemTail(&clist), sizeof(struct Node));

  if (GUIToolsBase) CloseLibrary(GUIToolsBase);
}
