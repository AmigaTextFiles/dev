/**********************************************************************
:Program.    NotifyDemo.c
:Contents.   guitools.library demonstration: Notify functions
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to GUITools documentation
:Language.   C
:Translator. SASC 6.51
:Remark.     OS 2.0 required
:Remark.     requires guitools.library V38.0
:Remark.     Written without any C-Experience ! Sorry !!
:History.    v1.0  Carsten Ziegeler  19-Apr-94
***********************************************************************/

/* ATTENTION: This modul is a straight translation of the modula2-demo.
              It may not take in some cases the easiest way to achive
              things, but it works ! */

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

#include "guitools.h"

/* Let's open an own hires-pal-screen with a full-sized window. All gadget-
   kinds from GADTools are displayed. The results will be printed using
   printf */

#define ListViewNode Node

UBYTE *vers = "\0$VER: NotifyDemo 1.0 (19.04.94)";

struct Library *GUIToolsBase;

struct GUIInfo *G;  /* The most important one */

/* Labels for Cylce-, MX- and Listview-Gadget */

char *cycleLabs[] = {"ZERO", "ONE", "TWO", NULL};

char *mxLabs[]    = {"Man", "Woman", "Child", NULL};

char *listviewLabs[] = {"Amiga 500", "Amiga 500+", "Amiga 600",
                        "Amiga 1000", "Amiga 1200", "Amiga 2000",
                        "Amiga 3000", "Amiga 4000/030",
                        "Amiga 4000/040", "Amiga XXXX/yyy"};

/*  Hook-Funktion, ,so we can use also chars which are not letters as
    key-equivalents */

ULONG __saveds __asm VanKeyHookFct(register __d0 char key,
                                   register __a0 WORD *nbr,
                                   register __a1 WORD *shifted)
{
  /* We get in D0 the key. This function will put in A0 the gadget-number
     that corresponds to the key and we will put in A1 if the key should
     be treated as shifted (1).
     If the key can be evaluated, the result is 1, otherwise 0.
     We don't need --saveds, because no global data is used
       MXKind-gadgets do not support gadget-text, so we have to immitate
       the key-equivalent.
       We also use for the sliderKind-gadget a key-equivalent with the
       + and - keys */
  ULONG ret;
  ret = 0;
  switch (key) {
  case 'm' : *nbr = 9;
             *shifted = 0;
             ret = 1;
             break;
  case 'M' : *nbr = 9;
             *shifted = 1;
             ret = 1;
             break;

  case '+' : *nbr = 8;
             *shifted = 0;
             ret = 1;
             break;
  case '-' : *nbr = 8;
             *shifted = 1;
             ret = 1;
             break;
  }
  return ret;
}

/* Menu-Functions :
   Don't forget __saveds ! If the result is 1, GUITools will stay in the
   waiting-loop, otherwise it will return ! */

__saveds ULONG MenuAbout(void)
{
  ShowRequester(G, "GUITools-Demo for Version 38.0\nGUITools © C.Ziegeler",
                okReqKind, NULL);
  return 1;
}

__saveds ULONG MenuQuit(void)
{
  if (ShowRequester(G, "Really quit demo ?", doitReqKind, NULL) == reqDo)
    return 0;
  else
    return 1;
}


/* Libraries will be opened by the auto init code ! Except GUITools !!*/

void main(void)
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
  SHORT check; /* boolean */
  UWORD listview;
  UWORD scroller;
  UWORD slider;
  UWORD color;

  int ende;

  /* open GUITools.library */

  GUIToolsBase = OpenLibrary(GUIToolsName, 38);

  if (GUIToolsBase == NULL)
    printf("You need at least the guitools.library V38.0 !\n");
  else
  {
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
    strcpy(string, "This is a text-line !");
    longI  = 33106;
    cycle  = 2;
    mx     = 1;
    check  = 1;
    listview = 65535;
    scroller = 1;
    slider   = 5;
    color    = 0;

    /* open screen with Topaz/8-Font! */

    S = OpenIntScreen(hiresPalID, 2, "Test_Screen", TopazAttr());
    if (S)
    {
      /* And now a full-sized window */
      W = OpenIntWindow(0, 0, asScreen, asScreen, "GUITools-Demo",
                        IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|IDCMP_GADGETDOWN|
                        IDCMP_MENUPICK|IDCMP_REFRESHWINDOW|IDCMP_VANILLAKEY,
                        WFLG_CLOSEGADGET|WFLG_ACTIVATE, S);
      if (W)
      {
        /* create GUIInfo */
        G = CreateGUIInfoTags(W, 20, 20, /* max 20 gadgets and menuitems */
                              GUI_Flags, GFLG_StringNotify|
                                         GFLG_IntegerNotify|
                                         GFLG_MXNotify|
            /* Notify for all gadgets */ GFLG_CycleNotify|
                                         GFLG_CheckboxNotify|
                                         GFLG_ListviewNotify|
                                         GFLG_SliderNotify|
                                         GFLG_ScrollerNotify|
                                         GFLG_PaletteNotify|
            /* conect entry-gadgets */   GFLG_CycleEntryGads|
                                         GFLG_LinkEntryGads|
            /* GUITools will do refresh*/GFLG_DoRefresh|
            /* notify key-equivalents */ GFLG_VanillaKeysNotify|
            /* internal: key-msg to gad-msg */  GFLG_ConvertKeys|
            /* only interesting msgs */  GFLG_InternMsgHandling|
            /* use the hook-function */  GFLG_CallVanillaKeyFct|
            /* Call the function that */ GFLG_CallMenuData|
            /* the userData contains */
            /* Add GT_Underscore-Tag  */ GFLG_AddStdUnderscore,
                          GUI_VanKeyFct, &VanKeyHookFct, NULL);
        if (G)
        {
          CreateGadgetFull(G, 500, 200, 80, 20, BUTTON_KIND, "_Quit",
                           PLACETEXT_IN, NULL);
          CreateGadgetFull(G, 100, 20, 200, 13, STRING_KIND, "S_tring:",
                           PLACETEXT_LEFT, GTST_String, &string,
                                           GTST_MaxChars, 80, NULL);
          CreateGadgetText(G, 100, 40,  80, 13, INTEGER_KIND, "_Longint:",
                           GTIN_Number, &longI,         /* NOTIFY ! */
                           GTIN_MaxChars, 7, NULL);
          CreateGadgetText(G, 100, 60,  80,15, CYCLE_KIND, "C_ycle It:",
                           GTCY_Active, &cycle,         /* NOTIFY */
                           GTCY_Labels, &cycleLabs, NULL);
          CreateGadgetText(G, 270, 100,  0, 0, CHECKBOX_KIND, "_Check it:",
                           GTCB_Checked, &check, NULL);    /* NOTIFY */
          CreateGadgetFull(G, 320, 40, 200, 80, LISTVIEW_KIND,
                           "Choose List_view-Entry", PLACETEXT_ABOVE,
                           GTLV_Selected, &listview,
                           GTLV_Labels, &list,
                           GTLV_ShowSelected, NULL, NULL);
          CreateGadgetText(G, 20, 140, 600, 14, SCROLLER_KIND,
                           "_Scroll Me",
                           GTSC_Top, &scroller,
                           GTSC_Total, 100,
                           GA_Immediate, 1,
                           GA_RelVerify, 1,
                           PGA_Freedom, LORIENT_HORIZ, NULL);
          CreateGadgetText(G, 120, 210, 250, 35, PALETTE_KIND,
                           "This is a _palette !",
                           GTPA_Depth, 2,
                           GTPA_Color, &color,
                           GTPA_IndicatorWidth, 50, NULL);
          G->flags = G->flags - GFLG_AddStdUnderscore; /* clear bit  !
                      Not possible for MX_KIND ! and not desired for
                      SLIDER_KIND ! */
          CreateGadgetText(G, 20, 180, 600, 14, SLIDER_KIND,
                           "Slider me with + and -",
                           GTSL_Min, 0,
                           GTSL_Max, 200,
                           GTSL_Level, &slider,
                           GA_Immediate, 1,
                           GA_RelVerify, 1,
                           PGA_Freedom, LORIENT_HORIZ, NULL);
          CreateGadgetFull(G, 100, 90,  80,17, MX_KIND, NULL,
                           PLACETEXT_LEFT,
                           GTMX_Active, &mx,   /* NOTIFY */
                           GTMX_Labels, &mxLabs, NULL);
          CreateGadgetText(G, 120, 78,  10,12, TEXT_KIND, "MX:",
                           GTTX_Text, "Try pressing m", NULL);

          MakeMenuEntry(G, NM_TITLE, "Project", NULL);
          MakeMenuEntry(G, NM_ITEM,  "About", "A");
          G->menuAdr->nm_UserData = &MenuAbout;
          MakeMenuEntry(G, NM_ITEM,  "Quit", "Q");
          G->menuAdr->nm_UserData = &MenuQuit;

          if (SetGUI(G) == guiSet)  /* Draw all */
          {
            ende = 0;
            while (ende == 0)  /* Input-Loop */
            {
              WaitIntMsg(G);
              if (G->msgClass == IDCMP_CLOSEWINDOW) ende = 1;
              if (G->msgClass == IDCMP_GADGETUP)
              {    /* We are only interested in the button-gadget */
                if (G->gadID == 0) ende = 1;  /* ButtonGadget Quit */
              }
              if (G->msgClass == IDCMP_MENUPICK) ende = 1;
              /* The procedures are automatically called within WaitIntMsg
                 because GFLG_CallMenuData is set */
            }
            UpdateEntryGadgets(G); /* update entry-gadgets */

            /* And now print all values */
            printf("\nYour input:\n");
            printf("String   : %s\n", string);

            printf("Longint  : %ld\n", longI);

            printf("Cycle    : %s\n", cycleLabs[cycle]);

            printf("MX       : %s\n", mxLabs[mx]);

            printf("Check    : ");
            if (check) printf("YES\n"); else printf("NO\n");

            printf("Listview : ");
            if (listview == 65535) printf("nothing\n");
            else
              printf("%s\n", listviewLabs[9-listview]);
              /* The list was created in reverse order ! */

            printf("Slider   : %d\n", slider);

            printf("Scroller : %d\n", scroller);

            printf("Color    : %u\n", color);

          }
        }
      } /* if (W) */
    } /* if (S) */
  } /* if (GUIToolsBase) */

  if (S) CloseIntScreen(S);
      /* The closing of the window etc is done by GUITools ! */

  while (list.mlh_TailPred != &list)  /* free list */
    FreeMem(RemTail(&list), sizeof(struct ListViewNode));

  if (GUIToolsBase) CloseLibrary(GUIToolsBase);
}
