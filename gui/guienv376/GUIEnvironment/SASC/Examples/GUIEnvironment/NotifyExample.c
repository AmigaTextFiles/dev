/****************************************************************************

$RCSfile: NotifyExample.c $

$Revision: 1.7 $
    $Date: 1994/12/15 15:27:04 $

    GUIEnvironment example: Notify functions

    SASC V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************/

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <intuition/gadgetclass.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <libraries/gadtools.h>
#include <proto/exec.h>
#include <stdio.h>
#include <string.h>

#include "guienv.h"
#include "guienvsupport.h"

/* Let's open an own hires-pal-screen with a full-sized window. All gadget-
   kinds from GADTools are displayed. The results will be printed using
   printf */

/* NotifyExample uses the following catalog strings 1.. : gadgets
                                                    30..: menus
                                                    50..: misc
                                                    100 : END       */

#define ListViewNode Node

UBYTE *vers = "\0$VER: NotifyExample 37.6 (11.12.94)";

struct Library *GUIEnvBase;

struct GUIInfo *G;  /* The most important one */

/* Labels for Cylce-, MX- and Listview-Gadget */

char *cycleLabs[] = {"ZERO", "ONE", "TWO", NULL};

char *mxLabs[]    = {"Man", "Woman", "Child", NULL};

char *listviewLabs[] = {"Amiga 500", "Amiga 500+", "Amiga 600",
                        "Amiga 1000", "Amiga 1200", "Amiga 2000",
                        "Amiga 3000", "Amiga 4000/030",
                        "Amiga 4000/040", "Amiga XXXX/yyy"};

/*  Hook-Funktion, ,so we can use also chars which are not letters as
    key-equivalents, this is a amiga callback hook ! */

LONG __asm VanKeyHookFct(register __a2 LONG key)
{
  /* We get in A2 the key as a LONG ! This function returns the belonging
     gadget nbr

       MXKind-gadgets do not support gadget-text, so we have to immitate
       the key-equivalent.
       We also use for the sliderKind-gadget a key-equivalent with the
       + and - keys */
  LONG ret;
  ret = GEH_KeyUnknown;
  switch ((char)key) {
  case 'm' : ret = 9;
             break;
  case 'M' : ret = 9 + GEH_KeyShifted;
             break;

  case '+' : ret = 8;
             break;
  case '-' : ret = 8 + GEH_KeyShifted;
             break;
  }
  return ret;
}

/* Menu-Functions :
   Because GUIEnv sets A4 for us, we don't need __saveds !
   If the result is true, GUIEnv will stay in the waiting-loop,
   otherwise it will return ! */

LONG MenuAbout(VOID)
{
  GUIRequest(G, "GUIEnvironment example for version 37.6\n© 1994 C.Ziegeler",
             GER_RTOKKind,
             GER_LocaleID, 51, NULL);
  return 1;
}

LONG MenuQuit(VOID)
{
  if (GUIRequest(G, "Really quit example ?",
                 GER_RTDoItKind,
                 GER_LocaleID, 52, NULL) == GER_Yes)
    return 0;
  else
    return 1;
}


/* Libraries will be opened by the auto init code ! Except GUIEnv !!*/

VOID main(VOID)
{
  struct Screen *S;
  struct Window *W;

  struct MinList list;  /* List for ListviewKind-Gadget */
  struct ListViewNode *entry;

  WORD i;

  /* Variables for the entry-fields */
  char string[80];
  LONG longI;
  UWORD cycle;
  UWORD mx;
  BOOL check; /* boolean */
  UWORD listview;
  WORD scroller;
  WORD slider;
  UWORD color;

  int ende;

  /* open GUIEnvironment.library */

  GUIEnvBase = OpenLibrary(GUIEnvName, 37);

  /* Init lists */

  NewList(&list);
  for(i=0; i<=9; i++)
  {
    entry = AllocMem(sizeof(struct ListViewNode), MEMF_CLEAR);
    if (entry)
    {
      entry->ln_Name = listviewLabs[i];
      Insert(&list, entry, NULL);
    }
  }

  /* set values */
  /* the string variable is set later because of localization ! */
  longI  = 33106;
  cycle  = 2;
  mx     = 1;
  check  = TRUE;
  listview = 65535;
  scroller = 1;
  slider   = 5;
  color    = 0;

  /* open screen with Topaz/8-Font! */

  S = OpenGUIScreen(GES_HiresPalID, 2, "GUIEnvExample_Screen",
                    SA_Font, TopazAttr(), NULL);
  if (S)
  {
    /* And now a full-sized window */
    W = OpenGUIWindow(0, 0, 640, 256, "GUIEnviroment - NotifyExample",
                      IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|IDCMP_GADGETDOWN|
                      IDCMP_MENUPICK|IDCMP_REFRESHWINDOW|IDCMP_VANILLAKEY,
                      WFLG_CLOSEGADGET|WFLG_ACTIVATE, S,
                      GEW_OuterSize, TRUE, NULL);
    if (W)
    {
      /* create GUIInfo */
      G = CreateGUIInfo(W, GUI_VanKeyAHook, &VanKeyHookFct,
                           GUI_CatalogFile, "GUIEnvExamples.catalog",
                           GUI_GadgetCatalogOffset, 1,
                           GUI_MenuCatalogOffset, 30, NULL);
      if (G)
      {

        /* Is the locale.library installed and the catalog available,
           so change the texts for the cycle and mx gadget */
        for(i=0; i<4; i++)
          cycleLabs[i] = GetCatStr(G, 54+i, cycleLabs[i]);
        for(i=0; i<3; i++)
          mxLabs[i] = GetCatStr(G, 58+i, mxLabs[i]);
        strcpy(string, GetCatStr(G, 68, "This is a text-line !"));

        /* If this gadget receives a gadgetUp message, GUIEnv will
           call the given function. Only if this returns FALSE
           GUIEnv will send this message to our message port !! */

        CreateGUIGadget(G, 500, 190, 80, 20, BUTTON_KIND,
                        GEG_Text, "_Quit",
                        GEG_Flags, PLACETEXT_IN,
                        GEG_UpAHook, &MenuQuit,
                        GEG_DownAHook, &MenuQuit, NULL);
        CreateGUIGadget(G, 100, 10, 200, 13, STRING_KIND,
                        GEG_Text, "S_tring:",
                        GEG_Flags, PLACETEXT_LEFT,
                        GEG_VarAddress, &string,
                        GEG_StartChain, FALSE,
                        GTST_MaxChars, 80, NULL);
        CreateGUIGadget(G, 100, 30,  80, 13, INTEGER_KIND,
                        GEG_Text, "_Longint:",
                        GEG_Flags, PLACETEXT_LEFT,
                        GEG_VarAddress, &longI,
                        GEG_EndChain, TRUE,
                        GTIN_MaxChars, 7, NULL);
        CreateGUIGadget(G, 100, 50,  80, 15, CYCLE_KIND,
                        GEG_Text, "C_ycle It:",
                        GEG_Flags, PLACETEXT_LEFT,
                        GEG_VarAddress, &cycle,
                        GTCY_Labels, &cycleLabs, NULL);
        CreateGUIGadget(G, 270, 90,  0, 0, CHECKBOX_KIND,
                        GEG_Text, "_Check it:",
                        GEG_Flags, PLACETEXT_LEFT,
                        GEG_VarAddress, &check, NULL);
        CreateGUIGadget(G, 320, 30, 200, 80, LISTVIEW_KIND,
                        GEG_Text, "Choose List_view-Entry",
                        GEG_Flags, PLACETEXT_ABOVE,
                        GEG_VarAddress, &listview,
                        GTLV_Labels, &list,
                        GTLV_ShowSelected, NULL, NULL);
        CreateGUIGadget(G, 20, 130, 600, 14, SCROLLER_KIND,
                        GEG_Text, "_Scroll Me",
                        GEG_Flags, PLACETEXT_ABOVE,
                        GEG_VarAddress, &scroller,
                        GTSC_Total, 100,
                        GA_Immediate, TRUE,
                        GA_RelVerify, TRUE,
                        PGA_Freedom, LORIENT_HORIZ, NULL);
        CreateGUIGadget(G, 120, 200, 250, 35, PALETTE_KIND,
                        GEG_Text, "This is a _palette !",
                        GEG_Flags, PLACETEXT_ABOVE,
                        GTPA_Depth, 2,
                        GEG_VarAddress, &color,
                        GTPA_IndicatorWidth, 50, NULL);
        CreateGUIGadget(G, 20, 170, 600, 14, SLIDER_KIND,
                        GEG_Text, "Slider me with + and -",
                        GEG_Flags, PLACETEXT_ABOVE,
                        GTSL_Min, 0,
                        GTSL_Max, 200,
                        GEG_VarAddress, &slider,
                        GA_Immediate, TRUE,
                        GA_RelVerify, TRUE,
                        PGA_Freedom, LORIENT_HORIZ, NULL);
        CreateGUIGadget(G, 100, 80,  80,17,  MX_KIND,
                        GEG_Flags, PLACETEXT_LEFT,
                        GEG_VarAddress, &mx,
                        GTMX_Labels, &mxLabs, NULL);
        CreateGUIGadget(G, 120, 68,  10, 12, TEXT_KIND,
                        GEG_Text, "MX:",
                        GEG_Flags, PLACETEXT_LEFT,
                        GTTX_Text, GetCatStr(G, 50, "Try pressing m"), NULL);

        CreateGUIMenuEntryA(G, NM_TITLE, "Project", NULL);
        CreateGUIMenuEntry(G, NM_ITEM,  "About",
                           GEM_ShortCut, "A\0",
                           GEM_AHook, &MenuAbout, NULL);
        CreateGUIMenuEntry(G, NM_ITEM,  "Quit",
                           GEM_ShortCut, "Q\0",
                           GEM_AHook, &MenuQuit, NULL);

        if (DrawGUIA(G, NULL) == GE_Done)  /* Draw all */
        {
          ende = 0;
          while (ende == 0)  /* Input-Loop */
          {
            WaitGUIMsg(G);
            if (G->msgClass == IDCMP_CLOSEWINDOW)
              if (!MenuQuit()) ende = 1;
            if ((G->msgClass == IDCMP_GADGETUP) || (G->msgClass == IDCMP_GADGETDOWN))
            {    /* We are only interested in the button-gadget */
              if (G->msgGadNbr == 0) ende = 1;  /* ButtonGadget Quit */
            }
            if (G->msgClass == IDCMP_MENUPICK) ende = 1;
            /* The procedures are automatically called within WaitGUIMsg */
          }

          /* update entry-gadgets */
          GUIGadgetAction(G, GEG_GetVar, GEG_ALLGADGETS, NULL);

          /* And now print all values */

          printf("\n");
          printf(GetCatStr(G, 61, "Your input:"));
          printf("\n");
          printf(GetCatStr(G, 62, "String  :"));
          printf("%s\n", string);

          printf(GetCatStr(G, 63, "Longint :"));
          printf("%ld\n", longI);

          printf("Cycle   :%s\n", cycleLabs[cycle]);

          printf("MX      :%s\n", mxLabs[mx]);

          if (check)
            printf(GetCatStr(G, 64, "Checkbox:YES"));
          else
            printf(GetCatStr(G, 65, "Checkbox:NO"));
          printf("\n");

          printf("Listview:");
          if (listview == 65535) printf(GetCatStr(G, 66, "Nothing"));
          else
            printf("%s", listviewLabs[9-listview]);
            /* The list was created in reverse order ! */
          printf("\n");

          printf("Slider  :%d\n", slider);

          printf("Scroller:%d\n", scroller);

          printf(GetCatStr(G, 67, "Color   :"));
          printf("%u\n\n", color);

        }
      }
    } /* if (W) */
  } /* if (S) */

  if (S) CloseGUIScreen(S);
      /* The closing of the window etc is done by GUIEnv ! */

  while (list.mlh_TailPred != &list)  /* free list */
    FreeMem(RemTail(&list), sizeof(struct ListViewNode));

  if (GUIEnvBase) CloseLibrary(GUIEnvBase);
}
