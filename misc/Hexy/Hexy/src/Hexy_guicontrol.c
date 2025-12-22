
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_guicontrol.c
 * Author    : Andrew Bell
 * Copyright : Copyright © 1998-1999 Andrew Bell (See GNU GPL)
 * Created   : Saturday 28-Feb-98 16:00:00
 * Modified  : Sunday 22-Aug-99 23:31:45
 * Comment   : 
 *
 * (Generated with StampSource 1.2 by Andrew Bell)
 *
 * [!END - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 */

/* Created: Sun/09/Aug/1998 */

/*
 *  Hexy, binary file viewer and editor for the Amiga.
 *  Copyright (C) 1999 Andrew Bell
 *
 *  Author's email address: andrew.ab2000@bigfoot.com
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* At one time Hexy's GUI was created with IEditor. Some of the
   IEditor code remains in this file */

#include <Hexy.h>

/* Prototypes */

Prototype BOOL ViewGUI( void );
Prototype void ClearGUI( void );
Prototype void SwapPort(struct Window *Win, struct MsgPort *NewMP);
Prototype void FlushWindow(struct Window *Win);
Prototype void SetMODE( void );
Prototype void UpdateMODE( void );
Prototype UBYTE *MakeUniqueScrName(UBYTE *FmtString, UBYTE *PubScreenNameBuf);
Prototype void PrintStatus( register __a0 UBYTE *String, register __a1 APTR Fmt);
Prototype void SetVDragBar(struct VCtrl *CurVC);
Prototype void DoError(BOOL UseDOS);
Prototype LONG SetupScreen( void );
Prototype void CloseDownScreen( void );
Prototype LONG OpenJUMPWindow( void );
Prototype void CloseJUMPWindow( void );
Prototype void JUMPRender( void );
Prototype LONG OpenMAINWindow( void );
Prototype void CloseMAINWindow( void );
Prototype void MAINRender( void );
Prototype LONG OpenFINDWindow( void );
Prototype void CloseFINDWindow( void );
Prototype void FINDRender( void );
Prototype LONG OpenHUNKLISTWindow( void );
Prototype LONG CloseHUNKLISTWindow( void );
Prototype void HexyInformation( UBYTE *String, APTR Fmt );
Prototype struct Screen *HexyScreen;
Prototype ULONG ScreenError;
Prototype UBYTE PubScreenNameBuf[];
Prototype struct PubScreenNode *HexyPSN;

#define AMTGADS_MAIN      10
#define GD_GVDRAGBAR      0
#define GD_GNEXTL         1
#define GD_GPREVL         2
#define GD_GNEXTP         3
#define GD_GPREVP         4
#define GD_GSEARCH        5
#define GD_GQUIT          6
#define GD_GMODE          7
#define GD_GSTATUS        8
#define GD_GEDIT          9

Prototype struct Screen *Scr;

struct Screen *Scr = NULL;
struct Screen *HexyScreen = NULL;
ULONG ScreenError = NULL;
UBYTE PubScreenNameBuf[256+4];
struct PubScreenNode *HexyPSN = NULL;
UWORD YOffset = NULL;
UWORD XOffset = NULL;
APTR VisualInfo;
UBYTE *PubScreenName = NULL;

Prototype struct Gadget *MAINGList;
Prototype struct Gadget *MAINGadgets[];
Prototype struct Window *MAINWnd;

struct Gadget *MAINGList = NULL;
struct Gadget *MAINGadgets[AMTGADS_MAIN];
struct Window *MAINWnd = NULL;

struct TextAttr HexyTextAttr =
{
  "topaz.font",
  8,
  FS_NORMAL,
  FPF_ROMFONT
};

struct TextFont *HexyTextFont = NULL;

BOOL ViewGUI( void )
{
  /*************************************************
   *
   * 
   *
   */

  UWORD Gimme3DEmbrossedLook = -1;

  if (GUIActive) return(TRUE);

  HexyTextFont = OpenFont( (struct TextAttr *) &HexyTextAttr );

  if (!HexyTextFont) return FALSE;

  PubScreenName = MakeUniqueScrName("HEXY_SCREEN.%lu", (UBYTE *) &PubScreenNameBuf);

  /*
  ** use NewScreen structure here
  */
  HexyScreen = (struct Screen *) OpenScreenTags(NULL,
              SA_Left,       0,
              SA_Top,        0,
              SA_Width,      640,
              SA_Height,     256,
              SA_Depth,      2, /* 2 planes = 4 colours */
              SA_Title,      VERS " (" DATE ") screen (Status = PUBLIC)",
              SA_Type,       PUBLICSCREEN,
              SA_DisplayID,  (HIRES_KEY | PAL_MONITOR_ID),
              SA_AutoScroll, TRUE,
              SA_PubName,    PubScreenName,
              SA_Pens,       &Gimme3DEmbrossedLook,
              SA_ErrorCode,  &ScreenError,
              SA_Font,       &HexyTextAttr,
              TAG_DONE);

  if (!HexyScreen) return(FALSE);
  PubScreenStatus(HexyScreen, 0);   /* Make screen public */

  if (SetupScreen()) return(FALSE);
  if (OpenMAINWindow()) return(FALSE);

  VC.VC_RPort = MAINWnd->RPort;

  SwapPort(MAINWnd, WinPort);
  SetMODE();

  KillAppIcon(); /* Kill AppIcon (If it exists) */

  if (VC.VC_FileAddress)  /* If VC contains a file then display it! */
  {
    UpdateView(&VC, NULL);
    SetVDragBar(&VC);
  }

  DisplayFileInfos(&VC);

  GUIActive = TRUE;
  return(TRUE);
}

void ClearGUI( void )
{
  /*************************************************
   *
   * 
   *
   */

  if (HexyScreen) PubScreenStatus(HexyScreen, PSNF_PRIVATE);

  ClearJumpWindow();
  ClearFindWindow();
  ClearHunkListWindow();

  /* Check for visitor windows on the public Hexy screen */

  FlushWindow( MAINWnd );
  CloseMAINWindow();
  CloseDownScreen();

  if (HexyScreen)
  {
    while (!CloseScreen(HexyScreen))
    {
      struct EasyStruct VisitorES =
      {
        sizeof(struct EasyStruct),
        NULL,
        "Hexy info...",
        "Unable to close Hexy screen!\n%lu (<-- Remember to fix this Andrew) alien windows are present!",
        "Retry"
      };

      SetupScreen();
      OpenMAINWindow();

      stream[0] = (ULONG) HexyPSN->psn_VisitorCount;
      EasyRequestArgs(MAINWnd, &VisitorES, NULL, &stream);

      CloseMAINWindow();
      CloseDownScreen();
    }
    HexyScreen = NULL;
    Scr = NULL;
  }

  if (HexyTextFont)
  {
    CloseFont(HexyTextFont);
    HexyTextFont = NULL;
  }

  GUIActive = FALSE;
}

void SwapPort(struct Window *Win, struct MsgPort *NewMP)
{
  /*************************************************
   *
   * 
   *
   */

  ULONG TempIDCMPFlags = Win->IDCMPFlags;
  ModifyIDCMP(Win, NULL);           /* Check result */
  Win->UserPort = NewMP;
  ModifyIDCMP(Win, TempIDCMPFlags);
}

void FlushWindow(struct Window *Win)
{
  /*************************************************
   *
   * 
   *
   */

  if (!Win) return;

  Forbid();

  if (Win->UserPort)
  {
    struct IntuiMessage *ThisNode = (struct IntuiMessage *) Win->UserPort->mp_MsgList.lh_Head;

    if ( (((ULONG)ThisNode) != ~NULL) && (ThisNode != NULL) )
    {
      do
      {
        if ( ThisNode->IDCMPWindow == Win )
        {
          Remove((struct Node *)ThisNode);
          ReplyMsg((struct Message *)ThisNode);
        }
      }
      while (ThisNode = (struct IntuiMessage *) ((struct Node *)ThisNode)->ln_Succ);
    }

    Win->UserPort = NULL;
  }

  Permit();
}

void SetMODE( void )
{
  /*************************************************
   *
   * 
   *
   */

  if (!HexyWBMsg)
  {
    /* From Shell */

    /*HexyInformation("Hexy was started from Shell", NULL);*/

    if (aa[ARG_ASCII])
    {
      VC.VC_Mode = HEXYMODE_ASCII;
    }
    else
    {
      VC.VC_Mode = HEXYMODE_HEX;
    }
  }
  else
  {
    VC.VC_Mode = HEXYMODE_HEX;
  }
    
  UpdateMODE();
}

void UpdateMODE( void )
{
  /*************************************************
   *
   * 
   *
   */

  UWORD CY_Active;

  if (VC.VC_Mode == HEXYMODE_ASCII)
  {
    CY_Active = HEXYMODE_ASCII;
  }
  else
  {
    CY_Active = HEXYMODE_HEX;
  }
  
  GT_SetGadgetAttrs(MAINGadgets[GD_GMODE], MAINWnd, NULL,
        GTCY_Active, CY_Active,
        TAG_DONE);
}

UBYTE *MakeUniqueScrName(UBYTE *FmtString, UBYTE *PubScreenNameBuf)
{
  /*************************************************
   *
   * 
   *
   */

  struct List *ScreenList = LockPubScreenList();
  ULONG cnt = NULL;

  do
  {
    RawDoFmt(FmtString, &cnt, (void *) &putChProc, PubScreenNameBuf); cnt++;
  }
  while (FindName(ScreenList, PubScreenNameBuf));

  UnlockPubScreenList();
  return(PubScreenNameBuf);
}

void PrintStatus( register __a0 UBYTE *String, register __a1 APTR Fmt)
{
  /*************************************************
   *
   * 
   *
   */

  UBYTE FmtBuf[256+4];

  if (!GUIActive) return;

  RawDoFmt(String, Fmt, (void *) &putChProc, &FmtBuf);
  GT_SetGadgetAttrs(MAINGadgets[GD_GSTATUS], MAINWnd, NULL,
            GTTX_Text, &FmtBuf,
            TAG_DONE);
}

void SetVDragBar(struct VCtrl *CurVC)
{
  /*************************************************
   *
   * 
   *
   */

  ULONG XByte;

  if (CurVC->VC_Mode == HEXYMODE_HEX)
  {
    XByte = XAMOUNT_HEX;
  }
  else
  {
    XByte = XAMOUNT_ASCII;
  }

  GT_SetGadgetAttrs(MAINGadgets[GD_GVDRAGBAR], MAINWnd, NULL,
        GTSC_Top,     (CurVC->VC_CurrentPoint/XByte),
        GTSC_Total,   (CurVC->VC_FileLength/XByte) + 1,
        GTSC_Visible, YLINES,
        TAG_DONE);
}

void DoError(BOOL UseDOS)
{
  /*************************************************
   *
   * 
   *
   */

  /* If UseDOS is TRUE then the output goes to Shell */

  if (UseDOS)
  {
    PrintFault(IoErr(), "Hexy error ");
  }
  else
  {
    UBYTE TmpErrStrBuf[256+4];
    Fault(IoErr(), "", (UBYTE *) &TmpErrStrBuf, 256);

    stream[0] = (ULONG) IoErr();
    stream[1] = (ULONG) &TmpErrStrBuf;
    PrintStatus("Operation failed! DOS: %lu %s", &stream);
  }
}

struct TextFont *HexyFont = NULL;

LONG SetupScreen( void )
{
  /*************************************************
   *
   * 
   *
   */

  if(!( Scr = LockPubScreen( PubScreenName )))
  {
    return( 1L );
  }

  YOffset = Scr->WBorTop + Scr->Font->ta_YSize;
  XOffset = Scr->WBorLeft;

  if(!( VisualInfo = GetVisualInfo( Scr, TAG_DONE )))
  {
    return( 1L );
  }

  return( 0L );
}


void CloseDownScreen( void )
{
  /*************************************************
   *
   * 
   *
   */

  if( VisualInfo )
  {
    FreeVisualInfo( VisualInfo );
    VisualInfo = NULL;
  }

  if( Scr )
  {
    UnlockPubScreen( NULL, Scr );
    Scr = NULL;
  }
}

/*************************************************
 *
 * 
 *
 */

struct Gadget *FINDGadgets[20+4];
struct Window *FINDWnd = NULL;
struct Gadget *FINDGList = NULL;

Prototype struct Gadget *FINDGadgets[];
Prototype struct Window *FINDWnd;
Prototype struct Gadget *FINDGList;

LONG OpenFINDWindow( void )
{
  if ( Gad = CreateContext( &FINDGList ) )
  {
    struct NewGadget ng_GD_FGFINDNEXT   = { 129, 56, 85,  13,   "Find Next",     NULL, GD_FGFINDNEXT,   NULL,            VisualInfo, NULL };
    ULONG gt_GD_FGFINDNEXT[]            = { TAG_DONE };
    struct NewGadget ng_GD_FGDONE       = { 340, 56, 85,  13,   "Done",          NULL, GD_FGDONE,       NULL,            VisualInfo, NULL };
    ULONG gt_GD_FGDONE[]                = { TAG_DONE };
    struct NewGadget ng_GD_FGSTRING     = { 78,  7,  343, 12,   "String:",       NULL, GD_FGSTRING,     NULL,            VisualInfo, NULL };
    ULONG gt_GD_FGSTRING[]              = { TAG_DONE };
    struct NewGadget ng_GD_FGIGNORECASE = { 14,  38, 26,  11,   "Ignore case",   NULL, GD_FGIGNORECASE, PLACETEXT_RIGHT, VisualInfo, NULL };
    ULONG gt_GD_FGIGNORECASE[]          = { GA_Disabled, TRUE, TAG_DONE };
    struct NewGadget ng_GD_FGBINSEARCH  = { 153, 38, 26,  11,   "Binary search", NULL, GD_FGBINSEARCH,  PLACETEXT_RIGHT, VisualInfo, NULL };
    ULONG gt_GD_FGBINSEARCH[]           = { GA_Disabled, TRUE, TAG_DONE }; /* Bin search has been disabled because it's too unstable. */
    struct NewGadget ng_GD_FGFINDPREV   = { 14,  56, 85,  13,   "Find Prev",     NULL, GD_FGFINDPREV,   NULL,            VisualInfo, NULL };
    ULONG gt_GD_FGFINDPREV[]            = { TAG_DONE };
    struct NewGadget ng_GD_FGBINRESULT  = { 80,  21, 343, 12,   "Bin:",          NULL, GD_FGBINRESULT,  NULL,            VisualInfo, NULL };
    ULONG gt_GD_FGBINRESULT[]           = { GTTX_CopyText, TRUE, GTTX_Border, TRUE, GTTX_Clipped, TRUE, TAG_DONE };

    FINDGadgets[GD_FGFINDNEXT]   = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_FGFINDNEXT,   (struct TagItem *) &gt_GD_FGFINDNEXT   );
    FINDGadgets[GD_FGDONE]       = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_FGDONE,       (struct TagItem *) &gt_GD_FGDONE       );
    FINDGadgets[GD_FGSTRING]     = Gad = CreateGadgetA( STRING_KIND,   Gad, &ng_GD_FGSTRING,     (struct TagItem *) &gt_GD_FGSTRING     );
    FINDGadgets[GD_FGIGNORECASE] = Gad = CreateGadgetA( CHECKBOX_KIND, Gad, &ng_GD_FGIGNORECASE, (struct TagItem *) &gt_GD_FGIGNORECASE );
    FINDGadgets[GD_FGBINSEARCH]  = Gad = CreateGadgetA( CHECKBOX_KIND, Gad, &ng_GD_FGBINSEARCH,  (struct TagItem *) &gt_GD_FGBINSEARCH  );
    FINDGadgets[GD_FGFINDPREV]   = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_FGFINDPREV,   (struct TagItem *) &gt_GD_FGFINDPREV   );
    FINDGadgets[GD_FGBINRESULT]  = Gad = CreateGadgetA( TEXT_KIND,     Gad, &ng_GD_FGBINRESULT,  (struct TagItem *) &gt_GD_FGBINRESULT  );

    if ( Gad )
    {
      FINDWnd = OpenWindowTags( NULL,
        WA_Left,      75,
        WA_Top,       111,
        WA_Width,     441,
        WA_Height,    86,
        WA_MinWidth,  0,
        WA_MaxWidth,  -1,
        WA_MinHeight, 0,
        WA_MaxHeight, -1,
        WA_PubScreen, Scr,
        WA_Title,     "Find...",
        WA_Flags,     ( WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_NEWLOOKMENUS | WFLG_GIMMEZEROZERO ),
        WA_IDCMP,     ( BUTTONIDCMP | CHECKBOXIDCMP | STRINGIDCMP | TEXTIDCMP | IDCMP_REFRESHWINDOW | IDCMP_MOUSEBUTTONS | IDCMP_GADGETUP | IDCMP_CLOSEWINDOW | IDCMP_RAWKEY | IDCMP_ACTIVEWINDOW | IDCMP_VANILLAKEY | IDCMP_MENUHELP | IDCMP_GADGETHELP ),
        WA_Gadgets,   FINDGList,
        TAG_DONE );

        if ( FINDWnd )
        {
          FINDRender();

          return 0;
        }
        else
        {
          HexyInformation( "Unable to create find window", NULL);
        }

    }
    else
    {
      HexyInformation( "Unable to create gadgets for find window", NULL);
      return 1; /* FAIL */
    }

  }
  else
  {
    HexyInformation( "Unable to init find window gadget list", NULL);
    return 1; /* FAIL */
  }

  return 1;
}

void CloseFINDWindow( void )
{
  if ( FINDWnd )
  {
    FlushWindow( FINDWnd );
    CloseWindow( FINDWnd );
    FINDWnd = NULL;
  }

  if ( FINDGList )
  {
    FreeGadgets( FINDGList );
    FINDGList = NULL;
  }
}

void FINDRender( void )
{
  DrawBevelBox( FINDWnd->RPort, 0, 0, 434, 73,
    GT_VisualInfo, VisualInfo, TAG_DONE );
}

/*************************************************
 *
 * 
 *
 */

struct Gadget *HUNKLISTGadgets[20+4];
struct Window *HUNKLISTWnd = NULL;
struct Gadget *HUNKLISTGList = NULL;

Prototype struct Gadget *HUNKLISTGadgets[];
Prototype struct Window *HUNKLISTWnd;
Prototype struct Gadget *HUNKLISTGList;

LONG OpenHUNKLISTWindow( void )
{
  struct Gadget *Gad;
  BOOL Failure = FALSE;

  if (Gad = CreateContext( &HUNKLISTGList ))
  {
    /* New gads and tags here */

    struct NewGadget ng_GD_HLLV   = {   5,  16, 480, 103, "Offset     Hunk ID       Information                       ", NULL, GD_HLLV, PLACETEXT_ABOVE, VisualInfo, NULL };
    ULONG gt_GD_HLLV[]            = { GTLV_ShowSelected, NULL, TAG_DONE };
    struct NewGadget ng_GD_HLDONE = { 374, 118, 110,  12,  "Done",      NULL, GD_HLDONE, NULL, VisualInfo, NULL };
    ULONG gt_GD_HLDONE[]          = { TAG_DONE };
    struct NewGadget ng_GD_HLGOTO = {   5, 118, 110,  12,  "Goto",      NULL, GD_HLGOTO, NULL, VisualInfo, NULL };
    ULONG gt_GD_HLGOTO[]          = { TAG_DONE };

    HUNKLISTGadgets[GD_HLLV]   = Gad = CreateGadgetA( LISTVIEW_KIND, Gad, &ng_GD_HLLV,       (struct TagItem *) &gt_GD_HLLV   );
    HUNKLISTGadgets[GD_HLDONE] = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_HLDONE,     (struct TagItem *) &gt_GD_HLDONE );
    HUNKLISTGadgets[GD_HLGOTO] = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_HLGOTO,     (struct TagItem *) &gt_GD_HLGOTO );

    if ( Gad )
    {
      HUNKLISTWnd = OpenWindowTags(NULL,
        WA_Left,      50,
        WA_Top,       66,
        WA_Width,     500,
        WA_Height,    147,
        WA_MinWidth,  0,
        WA_MaxWidth,  -1,
        WA_MinHeight, 0,
        WA_MaxHeight, -1,
        WA_PubScreen, Scr,
        WA_Title,     "Select a hunk to jump to...",
        WA_Flags,     WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_NOCAREREFRESH | WFLG_NEWLOOKMENUS | WFLG_GIMMEZEROZERO,
        WA_IDCMP,     BUTTONIDCMP | LISTVIEWIDCMP | IDCMP_REFRESHWINDOW | IDCMP_GADGETUP | IDCMP_CLOSEWINDOW | IDCMP_RAWKEY,
        WA_Gadgets,   HUNKLISTGList,
        TAG_DONE );

        if ( HUNKLISTWnd )
        {
          return 0;
        }
        else
        {
          HexyInformation( "Unable to create hunk-list window", NULL);
        }

    }
    else
    {
      HexyInformation( "Unable to create gadgets for hunk-list window", NULL);
      return 1; /* FAIL */
    }

  }
  else
  {
    HexyInformation( "Unable to init hunk-list window gadget list", NULL);
    return 1; /* FAIL */
  }

  return 1;
}

LONG CloseHUNKLISTWindow( void )
{
  if ( HUNKLISTWnd )
  {
    FlushWindow( HUNKLISTWnd );
    CloseWindow( HUNKLISTWnd );
    HUNKLISTWnd = NULL;
  }

  if ( HUNKLISTGList )
  {
    FreeGadgets( HUNKLISTGList );
    HUNKLISTGList = NULL;
  }

  return 0;
}

/*************************************************
 *
 * 
 *
 */

Prototype struct Gadget *JUMPGadgets[];
Prototype struct Window *JUMPWnd;

struct Gadget *JUMPGadgets[20+4];
struct Window *JUMPWnd = NULL;
struct Gadget *JUMPGList = NULL;

LONG OpenJUMPWindow( void ) /* BUG: Jump has a hidden string gadget ! */
{
  struct Gadget *Gad;
  BOOL Failure = FALSE;

  if (Gad = CreateContext( &JUMPGList ))
  {
    struct NewGadget ng_GD_JGSTRING = { 10, 20, 177, 14, "Jump to offset", NULL, GD_JGSTRING, PLACETEXT_LEFT, VisualInfo, NULL };
    ULONG gt_GD_JGSTRING[] = { TAG_DONE };

    struct NewGadget ng_GD_JGDONE =   { 189, 20, 58, 14, "Done",           NULL, GD_JGDONE, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_JGDONE[] = { TAG_DONE };

    JUMPGadgets[GD_JGSTRING]   = Gad = CreateGadgetA(STRING_KIND,     Gad, &ng_GD_JGSTRING,   (struct TagItem *) &gt_GD_JGSTRING );
    JUMPGadgets[GD_JGDONE]     = Gad = CreateGadgetA(BUTTON_KIND,     Gad, &ng_GD_JGDONE,     (struct TagItem *) &gt_GD_JGDONE );

    if ( Gad )
    {
      JUMPWnd = OpenWindowTags(NULL,
        WA_Left,         76,
        WA_Top,          62,
        WA_Width,        262,
        WA_Height,       44,
        WA_MinWidth,     0,
        WA_MaxWidth,     -1,
        WA_MinHeight,    0,
        WA_MaxHeight,    -1,
        WA_PubScreen,    Scr,
        WA_Title,        "Jump to offset",
        WA_Flags,        (WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_ACTIVATE | WFLG_NEWLOOKMENUS),
        WA_IDCMP,        (BUTTONIDCMP | STRINGIDCMP | IDCMP_REFRESHWINDOW | IDCMP_MOUSEBUTTONS | IDCMP_GADGETUP | IDCMP_CLOSEWINDOW | IDCMP_RAWKEY | IDCMP_ACTIVEWINDOW | IDCMP_VANILLAKEY | IDCMP_MENUHELP | IDCMP_GADGETHELP ),
        WA_Gadgets,      JUMPGList,
        TAG_DONE );

        if ( JUMPWnd )
        {
          JUMPRender();

          return 0;
        }
        else
        {
          HexyInformation( "Unable to create jump window", NULL);
        }

    }
    else
    {
      HexyInformation( "Unable to create gadgets for jump window", NULL);
      return 1; /* FAIL */
    }

  }
  else
  {
    HexyInformation( "Unable to init jump window gadget list", NULL);
    return 1; /* FAIL */
  }

  return 0; /* OK */
}

void CloseJUMPWindow( void )
{
  if ( JUMPWnd )
  {
    FlushWindow( JUMPWnd );
    CloseWindow( JUMPWnd );
    JUMPWnd = NULL;
  }

  if ( JUMPGList )
  {
    FreeGadgets( JUMPGList );
    JUMPGList = NULL;
  }
}

void JUMPRender( void )
{
  DrawBevelBox( JUMPWnd->RPort, 0 + XOffset, 1 + YOffset, 254, 31,
    GT_VisualInfo, VisualInfo, TAG_DONE );
}

UBYTE *Array0[] =
{
  "HEX",
  "ASCII",
  NULL
};

/*************************************************
 *
 * 
 *
 */

Prototype struct Menu *MAINMenus;

struct Menu *MAINMenus;

LONG OpenMAINWindow( void )
{
  struct Gadget *Gad;

  if (Gad = CreateContext( &MAINGList ))
  {
    struct NewGadget ng_GD_GVDRAGBAR = { 608, 4, 17, 199, NULL, NULL, GD_GVDRAGBAR, NULL, VisualInfo, NULL };
    ULONG gt_GD_GVDRAGBAR[]          = { GTSC_Arrows, 8, PGA_Freedom, LORIENT_VERT, GA_Immediate, TRUE, GA_RelVerify, TRUE, TAG_DONE };
    struct NewGadget ng_GD_GNEXTL    = { 9, 218, 81, 12, "Line+", NULL, GD_GNEXTL, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_GNEXTL[]             = { TAG_DONE };
    struct NewGadget ng_GD_GPREVL    = { 97, 218, 81, 12, "Line-", NULL, GD_GPREVL, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_GPREVL[]             = { TAG_DONE };
    struct NewGadget ng_GD_GNEXTP    = { 185, 218, 81, 12, "Page+", NULL, GD_GNEXTP, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_GNEXTP[]             = { TAG_DONE };
    struct NewGadget ng_GD_GPREVP    = { 273, 218, 81, 12, "Page-", NULL, GD_GPREVP, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_GPREVP[]             = { TAG_DONE };
    struct NewGadget ng_GD_GSEARCH   = { 361, 218, 81, 12, "Find", NULL, GD_GSEARCH, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_GSEARCH[]            = { TAG_DONE };
    struct NewGadget ng_GD_GQUIT     = { 542, 218, 81, 12, "Quit", NULL, GD_GQUIT, PLACETEXT_IN, VisualInfo, NULL };
    ULONG gt_GD_GQUIT[]              = { TAG_DONE };
    struct NewGadget ng_GD_GMODE     = { 449, 218, 81, 12, NULL, NULL, GD_GMODE, NULL, VisualInfo, NULL };
    ULONG gt_GD_GMODE[]              = { GTCY_Labels, (ULONG) &Array0, GTCY_Active, HEXYMODE_HEX, TAG_DONE };
    struct NewGadget ng_GD_GSTATUS   = { 71, 204, 481, 12, "Status", NULL, GD_GSTATUS, PLACETEXT_LEFT, VisualInfo, NULL };
    ULONG gt_GD_GSTATUS[]            = { GTTX_Text, (ULONG) "Welcome to Hexy!", GTTX_CopyText, TRUE, GTTX_Border, TRUE, GTTX_Clipped, TRUE, TAG_DONE };
    struct NewGadget ng_GD_GEDIT     = { 597, 204, 26, 11, "Edit", NULL, GD_GEDIT, NULL, VisualInfo, NULL };
    ULONG gt_GD_GEDIT[]              = { TAG_DONE };

    /*
     *
     * Create the gadgets for the main window
     *
     */
     
    MAINGadgets[GD_GVDRAGBAR] = Gad = CreateGadgetA( SCROLLER_KIND, Gad, &ng_GD_GVDRAGBAR, (struct TagItem *) &gt_GD_GVDRAGBAR );
    MAINGadgets[GD_GNEXTL]    = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_GNEXTL,    (struct TagItem *) &gt_GD_GNEXTL    );
    MAINGadgets[GD_GPREVL]    = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_GPREVL,    (struct TagItem *) &gt_GD_GPREVL    );
    MAINGadgets[GD_GNEXTP]    = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_GNEXTP,    (struct TagItem *) &gt_GD_GNEXTP    );
    MAINGadgets[GD_GPREVP]    = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_GPREVP,    (struct TagItem *) &gt_GD_GPREVP    );
    MAINGadgets[GD_GSEARCH]   = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_GSEARCH,   (struct TagItem *) &gt_GD_GSEARCH   );
    MAINGadgets[GD_GQUIT]     = Gad = CreateGadgetA( BUTTON_KIND,   Gad, &ng_GD_GQUIT,     (struct TagItem *) &gt_GD_GQUIT     );
    MAINGadgets[GD_GMODE]     = Gad = CreateGadgetA( CYCLE_KIND,    Gad, &ng_GD_GMODE,     (struct TagItem *) &gt_GD_GMODE     );
    MAINGadgets[GD_GSTATUS]   = Gad = CreateGadgetA( TEXT_KIND,     Gad, &ng_GD_GSTATUS,   (struct TagItem *) &gt_GD_GSTATUS   );
    MAINGadgets[GD_GEDIT]     = Gad = CreateGadgetA( CHECKBOX_KIND, Gad, &ng_GD_GEDIT,     (struct TagItem *) &gt_GD_GEDIT     );

    if (Gad)
    {
      struct NewMenu MAINNewMenu[] =
      {
        /*
         *
         * Project menu
         *
         */

        NM_TITLE, "Project",                  NULL,  NULL, 0L,  0L,
        NM_ITEM,  "Load file...",             "l",   NULL, 0L,  0L,
        NM_ITEM,  NM_BARLABEL,                NULL,  NULL, 0L,  0L,
        NM_ITEM,  "Save file...",             "s",   NULL, 0L,  0L,
        NM_ITEM,  "Split save file...",       NULL,  NULL, 0L,  0L,
        NM_ITEM,  NM_BARLABEL,                NULL,  NULL, 0L,  0L,
        NM_ITEM,  "Iconify",                  NULL,  NULL, 0L,  0L,
        NM_ITEM,  NM_BARLABEL,                NULL,  NULL, 0L,  0L,
        NM_ITEM,  "About Hexy...",            "a",   NULL, 0L,  0L,
        NM_ITEM,  "Quit Hexy",                "q",   NULL, 0L,  0L,

        /*
         *
         * Control menu
         *
         */

        NM_TITLE, "Control",                  NULL,  NULL, 0L,  0L,
        NM_ITEM,  "Jump to offset",           "j",   NULL, 0L,  0L,
        NM_ITEM,  "Find ASCII/Bin string...", "f",   NULL, 0L,  0L,
        NM_ITEM,  "Find hunk/segment",        "h",   NULL, 0L,  0L,

        NM_END,    NULL,                      NULL,  0,    0L,  0L
      };

      if(MAINMenus = CreateMenus( (struct NewMenu *) &MAINNewMenu, TAG_END ))
      {
        register BOOL layoutres = LayoutMenus(MAINMenus, VisualInfo,
            /*GTMN_TextAttr, NULL,*/
            GTMN_NewLookMenus, TRUE,
            TAG_DONE);

        if ( layoutres )
        {
          MAINWnd = OpenWindowTags(NULL,

            WA_Left,          0,
            WA_Top,           11,
            WA_Width,         640,
            WA_Height,        245,
            WA_MinWidth,      0,
            WA_MaxWidth,      -1,
            WA_MinHeight,     0,
            WA_MaxHeight,     -1,
            WA_PubScreen,     HexyScreen,

            WA_Title,         "Main Hexy window",
            WA_Flags,         WFLG_CLOSEGADGET | WFLG_BACKDROP | WFLG_ACTIVATE | WFLG_NEWLOOKMENUS | WFLG_GIMMEZEROZERO,
            WA_IDCMP,         BUTTONIDCMP | CHECKBOXIDCMP | CYCLEIDCMP | SCROLLERIDCMP | TEXTIDCMP | IDCMP_REFRESHWINDOW | IDCMP_MOUSEBUTTONS | IDCMP_MOUSEMOVE | IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_MENUPICK | IDCMP_CLOSEWINDOW | IDCMP_RAWKEY | IDCMP_ACTIVEWINDOW | IDCMP_INACTIVEWINDOW | IDCMP_VANILLAKEY | IDCMP_INTUITICKS | IDCMP_MENUHELP | IDCMP_GADGETHELP,
            WA_ScreenTitle,   "Hexy screen is active",
            WA_AutoAdjust,    FALSE,
            WA_Gadgets,       MAINGList,

            TAG_DONE);

          if ( MAINWnd )
          {
            SetFont(MAINWnd->RPort, HexyTextFont);
            
            MAINRender();
            GT_RefreshWindow(MAINWnd, NULL);
            SetMenuStrip(MAINWnd, MAINMenus);
            return 0;
          }
          else
          {
            HexyInformation( "Unable to open main window", NULL );
            return 1;
          }
        }
        else
        {
          HexyInformation( "Unable to layout menus for main window", NULL );
          return 1;
        }
      }
      else
      {
        HexyInformation( "Unable to create menus for main window", NULL );
        return 1;
      }
    }
    else
    {
      HexyInformation( "Unable to create gadgets for main window", NULL );
      return 1;
    }
  } /* CreateContext() */
  else
  {
    HexyInformation( "Unable to create gadgets for main window", NULL );
    return 1;
  }
}

void CloseMAINWindow( void )
{
    if ( MAINWnd )
    {
      ClearMenuStrip( MAINWnd );
      CloseWindow( MAINWnd ); MAINWnd = NULL;
    }

    if (MAINGList)
    {
      FreeGadgets( MAINGList ); MAINGList = NULL;
    }

    if (MAINMenus)
    {
      FreeMenus( MAINMenus ); MAINMenus = NULL;
    }
}

void MAINRender( void )
{
  DrawBevelBox( MAINWnd->RPort, 7, 217, 618, 14,  GT_VisualInfo, VisualInfo, GTBB_Recessed, TRUE, TAG_DONE );
  DrawBevelBox( MAINWnd->RPort, 5, 4,   603, 199, GT_VisualInfo, VisualInfo, TAG_DONE );
  DrawBevelBox( MAINWnd->RPort, 0, 0,   632, 232, GT_VisualInfo, VisualInfo, TAG_DONE );
}

/*************************************************
 *
 * 
 *
 */

void HexyInformation( UBYTE *String, APTR Fmt )
{
  struct EasyStruct HexyInfoES =
  {
    sizeof(struct EasyStruct),
    NULL,
    "Hexy information...",
    String,
    "Understood"
  };
  EasyRequestArgs(MAINWnd, &HexyInfoES, NULL, Fmt);
}

/*************************************************
 *
 * 
 *
 */

