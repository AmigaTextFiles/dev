
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_main.c
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

/* Created: Thu/26/Feb/1998 */

#include <Hexy.h>

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


#define ARGPLATE "FILE,ASCII/S" /* Move this to Hexy_main.h */

/* Prototypes */

Prototype BOOL InitPrg( void );
Prototype void ExitPrg( void );
Prototype void ParseEvents( void );
Prototype void DEBUG( void );
Prototype void IDCMP_MAIN( void );
Prototype BOOL IDCMP_CheckRAWKEYS( void );
Prototype ULONG stream[], aa[], WaitFlags, SigFlag_IDCMP;
Prototype UBYTE CurFileLoaded[];
Prototype BOOL NoFileToLoad;
Prototype struct VCtrl VC;
Prototype struct Process *Proc;
Prototype struct RDArgs *ArgInfo;
Prototype struct MsgPort *WinPort;
Prototype UWORD _VERSION;
Prototype UWORD _REVISION;
Prototype UBYTE _DATE[];   
Prototype UBYTE _VERS[];
Prototype UBYTE _VSTRING[];
Prototype UBYTE _VERSTAG[];
Prototype UWORD putChProc[];
Prototype BOOL GUIActive;
Prototype struct FileRequester *FR;
Prototype struct rtReqInfo *RTFR;
Prototype struct Library *ReqToolsBase;
Prototype struct Library *WorkbenchBase;
Prototype struct IntuiMessage IM;
Prototype struct Gadget *Gad;

/* Variables and data */

UBYTE *VersionTag = VERSTAG;
ULONG stream[99], aa[ARG_AMT], WaitFlags, SigFlag_IDCMP;
UBYTE CurFileLoaded[256+4];
BOOL NoFileToLoad = TRUE;
UWORD _VERSION   = VERSION; /* Global version data, all modules should refer to these variables */
UWORD _REVISION  = REVISION;
UBYTE _DATE[]    = DATE;
UBYTE _VERS[]    = VERS;
UBYTE _VSTRING[] = VSTRING;
UBYTE _VERSTAG[] = VERSTAG;
struct VCtrl VC;
struct Process *Proc;
struct WBStartup *HexyWBMsg = NULL;
struct RDArgs *ArgInfo = NULL;
struct MsgPort *WinPort;
UWORD putChProc[] = { 0x16c0, 0x4e75 };
BOOL GUIActive = FALSE;
struct FileRequester *FR = NULL;
struct rtReqInfo *RTFR = NULL;
struct Library *ReqToolsBase;
struct Library *WorkbenchBase;
struct Library *GadToolsBase;
struct Library *AslBase;
struct Library *CxBase;
struct Library *UtilityBase;
UBYTE CurrentUserDir[258+4];
UBYTE CurrentUserFile[258+4];
struct IntuiMessage IM;
struct Gadget *Gad;
BOOL running = TRUE;

LONG main( void )
{
  /*************************************************
   *
   * Start of all our problems :-) 
   *
   */

  Proc = (struct Process *) FindTask(NULL);

  if (InitPrg())
  {
    if (ViewGUI())
    {
      ParseEvents();
      FreeVC(&VC);
    }
    else VPrintf("Failed to initilize GUI!\n", NULL);

    ClearGUI();
  }
  else VPrintf("Failed to initilize program!\n", NULL);

  ExitPrg();

  return RETURN_OK;
}

void wbmain( struct WBStartup *WBS )
{
  HexyWBMsg = WBS;

  main();
}

BOOL InitPrg( void )
{
  /*************************************************
   *
   * Setup the program. 
   *
   */

  WorkbenchBase = OpenLibrary("workbench.library", 39L);

  if (!WorkbenchBase) return FALSE;

  if (!HexyWBMsg)
  {
    ArgInfo = (struct RDArgs *)
      ReadArgs(ARGPLATE, (LONG *) &aa, NULL);

    if (aa[ARG_FILE] == NULL)
      NoFileToLoad = TRUE;
    else
      NoFileToLoad = FALSE;

    /*SetProgramName(VERS);*/
  }
  else NoFileToLoad = TRUE;

  WinPort = (struct MsgPort *) CreateMsgPort();

  if (!WinPort) return(FALSE);

  SigFlag_IDCMP = (1 << WinPort->mp_SigBit);

  if (!(GadToolsBase = OpenLibrary("gadtools.library", 39L)))
  {
    HexyInformation("Unable to open gadtools.library v39+", NULL);

    return FALSE;
  }

  if (!(AslBase = OpenLibrary("asl.library", 39L)))
  {

    HexyInformation("Unable to open asl.library v39+", NULL);

    return FALSE;
  }

  if (!(ReqToolsBase = OpenLibrary("reqtools.library", 38L)))
  {
    HexyInformation("Unable to open reqtools.library v38+", NULL);

    return FALSE;
  }

  if (!(CxBase = OpenLibrary("commodities.library", 39L)))
  {
    HexyInformation("Unable to open commodities.library v39+", NULL);

    return FALSE;
  }

  if (!(UtilityBase = OpenLibrary("utility.library", 39L)))
  {
    HexyInformation("Unable to open utility.library v39+", NULL);

    return FALSE;
  }

  /* Setup the paths & filenames for the requester */

  if (NoFileToLoad == FALSE)
  {
    /* If the user loaded a file via CLI params then extract path & name
       from that string. */

    strcpy( (UBYTE *) &CurrentUserDir, (UBYTE *) aa[ARG_FILE] );
    strcpy( (STRPTR) &CurrentUserFile, FilePart((STRPTR) &CurrentUserDir) );
    PathPart((STRPTR) &CurrentUserDir)[0] = 0;
  }
  else
  {
    /* Terminate file buffer */

    CurrentUserFile[0] = 0;

    if (!GetCurrentDirName( (STRPTR) &CurrentUserDir, 256))
    {
      CurrentUserDir[0] = 0;  /* Null terminate buffer */
    }
  }

  FR = (struct FileRequester *) AllocAslRequestTags(ASL_FileRequest,
    ASLFR_SleepWindow,    TRUE,
    ASLFR_InitialDrawer,  &CurrentUserDir,
    ASLFR_InitialFile,    &CurrentUserFile,
    ASLFR_DoPatterns,     "#?",
    ASLFR_InitialPattern, "#?",
    ASLFR_RejectIcons,    FALSE,
    TAG_DONE);

  if (!FR) return(FALSE);

  RTFR = (struct rtReqInfo *) rtAllocRequestA(RT_REQINFO, NULL);

  if (!RTFR) return(FALSE);

  if (!InitCX()) return(FALSE);
  if (!InitApp()) return(FALSE);

  return(TRUE);
}

void ExitPrg( void )
{
  /*************************************************
   *
   * Close down program. 
   *
   */

  FreeApp();
  FreeCX();

  if (FR) { FreeAslRequest(FR); FR = NULL; }
  if (RTFR) { rtFreeRequest(RTFR); RTFR = NULL; }
  if (WinPort) { DeleteMsgPort(WinPort); WinPort = NULL; }
  if (ArgInfo) { FreeArgs(ArgInfo); ArgInfo = NULL; }

  if (ReqToolsBase)
  {
    CloseLibrary(ReqToolsBase); ReqToolsBase = NULL;
  }

  if (UtilityBase)
  {
    CloseLibrary(UtilityBase); UtilityBase = NULL;
  }

  if (WorkbenchBase)
  {
    CloseLibrary(WorkbenchBase); WorkbenchBase = NULL;
  }

  if (GadToolsBase)
  {
    CloseLibrary(GadToolsBase); GadToolsBase = NULL;
  }

  if (AslBase)
  {
    CloseLibrary(AslBase); AslBase = NULL;
  }
  
  if (CxBase)
  {
    CloseLibrary(CxBase); CxBase = NULL;
  }
}

void ParseEvents( void )
{
  /*************************************************
   *
   * Process all signals for this task. 
   *
   */

  struct IntuiMessage *TmpIM;

  if (NoFileToLoad)
  {
    UBYTE *TempPath;
    PrintStatus("Select a file to load...", NULL);
    TempPath = ObtainInFile();
    if (TempPath)
    {
      if (ReadFile(TempPath, &VC))
      {
        /*PrintStatus("File loaded OK", &stream);*/
      }
    }
  }
  else
  {
    if (ReadFile((UBYTE *) aa[ARG_FILE], &VC))
    {
      /*PrintStatus("File loaded OK", &stream);*/
    }
  }

  /*PrintStatus("Do something...", NULL);*/

  while(running)
  {
    ULONG SigEvent;

    WaitFlags = (SigFlag_App | SigFlag_Cx |
                SigFlag_IDCMP | SIGBREAKF_CTRL_C);

    SigEvent = Wait(WaitFlags);
    
    if (SigEvent & SigFlag_IDCMP)
    {
      while (TmpIM = (struct IntuiMessage *) GT_GetIMsg(WinPort))
      {
        CopyMem(TmpIM, &IM, sizeof(struct IntuiMessage));
        Gad = IM.IAddress;
        GT_ReplyIMsg(TmpIM);

        if ((IM.IDCMPWindow == MAINWnd) && EditFlag)
        {
          if (Edit_DoEditIDCMP(&IM)) continue;
        }

        if (IDCMP_CheckRAWKEYS()) continue;
        if (IM.IDCMPWindow == MAINWnd) IDCMP_MAIN();
        else if (IM.IDCMPWindow == JUMPWnd) IDCMP_JUMP();
        else if (IM.IDCMPWindow == FINDWnd) IDCMP_FIND();
        else if (IM.IDCMPWindow == HUNKLISTWnd) IDCMP_HUNKLIST();
      }
    }
    else if (SigEvent & SigFlag_App) DoAppEvent();
    else if (SigEvent & SigFlag_Cx) if (DoCxEvent()) running = FALSE;
    else if (SigEvent & SIGBREAKF_CTRL_C) running = FALSE;
    continue;
  }
}

#define ESC 0x1B  /* Escape key */

void IDCMP_MAIN( void )
{
  /*************************************************
   *
   * Handle IDCMP for main window.
   *
   */

  if (Edit_DoEditIDCMP(&IM)) return;

  switch(IM.Class)
  {
    case IDCMP_VANILLAKEY:

      switch((UBYTE)IM.Code)
      {
        case ESC: /* ESC */
        case 'Q':
        case 'q':
          running = FALSE;
          break;
      }
      break;

    case IDCMP_CLOSEWINDOW:
      running = FALSE;
      break;

    case IDCMP_REFRESHWINDOW:
      MAINRender();
      break;

    case IDCMP_MENUPICK:            /* Control Hexy's menus */
    {
      BOOL menudone = FALSE;
      UWORD menuNumber = IM.Code;
      
      while ((menuNumber != MENUNULL) && (!menudone))
      {
        struct MenuItem *item = ItemAddress(MAINMenus, menuNumber);
        UWORD menuNum = MENUNUM(menuNumber);
        UWORD itemNum = ITEMNUM(menuNumber);
        UWORD subNum  = SUBNUM(menuNumber);
        
        switch(menuNum)
        {       
          /*****************************************/
          
          case 0:                   /* Project */
          {
            switch(itemNum)
            {
              case 0:               /* Load */
              {
                UBYTE *TempPath = ObtainInFile();
                if (TempPath)
                {
                  ReadFile(TempPath, &VC);
                }
                UpdateJumpWindow();
                break;
              }
              case 1: break;        /* BAR */
              case 2:               /* Save... */
                SaveToNewLocation(&VC);
                break;
              case 3:               /* Split save... */
                SaveSplit(&VC);
                break;
              case 4: break;        /* BAR */
              case 5:               /* Iconify */
                DoIconify();
                break;
              case 6: break;        /* BAR */
              case 7:               /* About */
              {         
                struct EasyStruct AboutES =
                {
                  sizeof(struct EasyStruct),
                  NULL,
                  "About Hexy...", VERS " (" DATE ")\n"
                  " Copyright © " YEAR " Andrew Bell\n"
                  "This is a beta version!",
                  "Continue"
                };
                EasyRequest(MAINWnd, &AboutES, NULL, NULL);
                break;
              }
              case 8:               /* Quit */
                menudone = TRUE;
                running = FALSE;
                break;
            }
            break;
          }

          /*****************************************/

          case 1:                   /* Control */
          {
            switch(itemNum)
            {
              case 0: ViewJumpWindow(); break;
              case 1: ViewFindWindow(); break;
              case 2: ViewHunkListWindow(); break;
              default: break;
            }
            break;
          }
          default:
            break;
        }
        
        menuNumber = item->NextSelect;
      }
      break;
    }


    case IDCMP_MOUSEMOVE:
      switch(Gad->GadgetID)
      {
        case GD_GVDRAGBAR:
          if (VC.VC_Mode == HEXYMODE_HEX)
          {
            VC.VC_CurrentPoint = (ULONG)(IM.Code * XAMOUNT_HEX);
          }
          else
          {
            VC.VC_CurrentPoint = (ULONG)(IM.Code * XAMOUNT_ASCII);
          }

          UpdateView(&VC, NULL);
          UpdateJumpWindow();
          break;
        default:
          break;
      }
      break;

    case IDCMP_GADGETDOWN:
      switch(Gad->GadgetID)
      {
        case GD_GVDRAGBAR:
          if (VC.VC_Mode == HEXYMODE_HEX)
          {
            VC.VC_CurrentPoint = (ULONG)(IM.Code * XAMOUNT_HEX);
          }
          else
          {
            VC.VC_CurrentPoint = (ULONG)(IM.Code * XAMOUNT_ASCII);
          }
          UpdateView(&VC, NULL);
        break;
      }
      break;

    case IDCMP_GADGETUP:
    {
      ULONG MoveAmt;
      if (VC.VC_Mode == HEXYMODE_HEX)
      {
        MoveAmt = XAMOUNT_HEX;
      }
      else
      {
        MoveAmt = XAMOUNT_ASCII;
      }

      switch(Gad->GadgetID)
      {
        case GD_GVDRAGBAR:
        {
          if (VC.VC_Mode == HEXYMODE_HEX)
          {
            VC.VC_CurrentPoint = (ULONG)(IM.Code * XAMOUNT_HEX);
          }
          else
          {
            VC.VC_CurrentPoint = (ULONG)(IM.Code * XAMOUNT_ASCII);
          }
          UpdateView(&VC, NULL);
          break;
        }
        case GD_GNEXTL:
          AdjustView(&VC, MoveAmt); SetVDragBar(&VC);
          break;
        case GD_GPREVL:
          AdjustView(&VC, -MoveAmt); SetVDragBar(&VC);
          break;
        case GD_GNEXTP:
          AdjustView(&VC, MoveAmt * YLINES); SetVDragBar(&VC);
          break;
        case GD_GPREVP:
          AdjustView(&VC, -(MoveAmt * YLINES)); SetVDragBar(&VC);
          break;
        case GD_GSEARCH:
          ViewFindWindow();
          break;
        case GD_GQUIT:
          running = FALSE;
          break;
        case GD_GMODE:
        {
          switch(IM.Code)
          {
            default:
            case HEXYMODE_HEX:
              Edit_WipeCursor();
              VC.VC_Mode = HEXYMODE_HEX;
              UpdateView(&VC, NULL);
              break;

            case HEXYMODE_ASCII:
              Edit_WipeCursor();
              VC.VC_Mode = HEXYMODE_ASCII;
              UpdateView(&VC, NULL);
              break;
          }
          if (EditFlag) Edit_ShiftCursor(0);
          SetVDragBar(&VC);
          break;
        }

        case GD_GEDIT:
        {
          ULONG TestFlag;
          ULONG r = GT_GetGadgetAttrs(MAINGadgets[GD_GEDIT], MAINWnd, NULL,
                    GTCB_Checked, &TestFlag,
                    TAG_DONE);

          if (r) if (TestFlag) Edit_Begin(); else Edit_End();
          break;
        }
      }

      UpdateJumpWindow();
      break;
    }

    default:
      ;
  } /* switch(CLASS) */
}

BOOL IDCMP_CheckRAWKEYS( void )
{
  /*************************************************
   *
   * Check for global raw keys 
   *
   */

  /*
   * All keyboard shortcut should be placed into these procedures:
   *
   * IDCMP_KeyNavigation, controls Up/Dn/Lf/Rt arrows, etc.
   * IDCMP_KeyControl, controls ESC key, HELP keys, etc.
   *
   * IDCMP_KeyNavigation is not called when EditMode is active because
   * the Edit_DoEditIDCMP (aka Edit_DoEdit) handles edit cursor
   * navigation.
   *
   * IDCMP_CheckRAWKEYS should then become obsolete.
   *
   */

  if (EditFlag) return(FALSE);

  if (IM.Class == IDCMP_RAWKEY)
  {
    LONG Amount = NULL;
    BOOL QFlag;
    BOOL CFlag;

    if ((IM.Qualifier & IEQUALIFIER_LSHIFT) ||
      (IM.Qualifier & IEQUALIFIER_RSHIFT))
    {
      QFlag = TRUE;
    }
    else
    {
      QFlag = FALSE;
    }

    if  (IM.Qualifier & IEQUALIFIER_CONTROL)
    {
      CFlag = TRUE;
    }
    else
    {
      CFlag = FALSE;
    }

    switch(IM.Code)
    {
      /* Add HELP etc here */
    }

    if (VC.VC_Mode == HEXYMODE_HEX)
    {
      switch(IM.Code)
      {
        case CURSORUP:
          if (CFlag)
          {
            VC.VC_CurrentPoint = NULL;
            Amount = NULL;
            break;
          }
          else
          {
            if (QFlag)
              Amount = -(XAMOUNT_HEX * YLINES);
            else
              Amount = -XAMOUNT_HEX;
            break;
          }
        case CURSORDOWN:
          if (CFlag)
          {
            VC.VC_CurrentPoint = VC.VC_FileLength - (XAMOUNT_HEX * YLINES);
            Amount = NULL;
            break;
          }
          else
          {
            if (QFlag)
              Amount = (XAMOUNT_HEX*YLINES);
            else
              Amount = XAMOUNT_HEX;

            break;
          }

        case CURSORLEFT:
          if (QFlag) Amount = -4; else Amount = -1; break;
        case CURSORRIGHT:
          if (QFlag) Amount = 4; else Amount = 1; break;
        default: break;
      }
      UpdateJumpWindow();
    }
    else
    {
      switch(IM.Code)
      {
        case CURSORUP:
          if (QFlag) Amount = -(XAMOUNT_ASCII*YLINES); else Amount = -XAMOUNT_ASCII; break;
        case CURSORDOWN:
          if (QFlag) Amount = (XAMOUNT_ASCII*YLINES); else Amount = XAMOUNT_ASCII; break;
        case CURSORLEFT:
          if (QFlag) Amount = -4; else Amount = -1; break;
        case CURSORRIGHT:
          if (QFlag) Amount = 4; else Amount = 1; break;
        default: break;
      }
      UpdateJumpWindow();
    }
    AdjustView(&VC, Amount);
    SetVDragBar(&VC);
    return(TRUE);
  }
  else
  {
    return(FALSE);
  }
}

void DEBUG( void )
{
  /*************************************************
   *
   * Special procedure use for debugging.
   *
   */

  /* This is a dummy function that is used for MonAm break points, etc. */
}

/*************************************************
 *
 * 
 *
 */

