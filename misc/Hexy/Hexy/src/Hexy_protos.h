
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_protos.h
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


/* Hexy_main.c          */

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
Prototype struct WBStartup *HexyWBMsg;
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

/* Hexy_functions.c     */

Prototype BOOL UnpackFile(struct VCtrl *TmpVC);
Prototype BOOL CheckForViruses(struct VCtrl *TmpVC);
Prototype UWORD CheckXPK(struct VCtrl *TmpVC);
Prototype ULONG ConvertBinStr(void *Source, void *Dest);
Prototype void UpdateBinResult( void );
Prototype void DisplayFileInfos(struct VCtrl *TmpVC);
Prototype BOOL ValidFile(struct VCtrl *TmpVC);
Prototype BOOL LMBActive( void );
Prototype void FreeVC(struct VCtrl *TmpVC);
Prototype void FlashScreen( void );
Prototype BOOL EnableFlash;
Prototype struct Library *xfdMasterBase;
Prototype struct Library *FilevirusBase;
Prototype struct Library *XpkBase;
Prototype struct XpkFib *XFIB;

/* Hexy_edit.c          */

Prototype void Edit_Begin( void );
Prototype void Edit_End( void );
Prototype void Edit_DisplayCursor( void );
Prototype void Edit_WriteChar( register __d0 LONG TempCursorOffset, register __d1 UBYTE Ch );
Prototype void Edit_WipeCursor( void );
Prototype BOOL Edit_ShiftCursor( register __d0 LONG Offset );
Prototype BOOL Edit_DoEditIDCMP( struct IntuiMessage *IM );
Prototype BOOL EditFlag;

/* Hexy_fileio.c        */

Prototype BOOL ReadFile( UBYTE *FileName, struct VCtrl *VC );
Prototype UBYTE *ObtainInFile( void );
Prototype UBYTE *ObtainOutFile( void );
Prototype void SaveSplit( struct VCtrl *TmpVC );
Prototype void SaveToNewLocation( struct VCtrl *TmpVC );

/* Hexy_wb.c            */

Prototype BOOL InitCX( void );
Prototype void FreeCX( void );
Prototype BOOL DoCxEvent( void );
Prototype BOOL InitApp( void );
Prototype void FreeApp( void );
Prototype void KillAppIcon( void );
Prototype BOOL DoIconify( void );
Prototype BOOL DoAppEvent( void );
Prototype ULONG CxErrCode;
Prototype CxObj *CxBrok;
Prototype struct MsgPort *CxMP;
Prototype ULONG SigFlag_Cx;
Prototype struct MsgPort *AppMP;
Prototype ULONG SigFlag_App;
Prototype struct AppIcon *AI;

/* Hexy_guicontrol.c    */

Prototype BOOL ViewGUI( void );
Prototype void ClearGUI( void );
Prototype void SwapPort(struct Window *Win, struct MsgPort *NewMP);
Prototype void FlushWindow(struct Window *Win);
Prototype void SetMODE( void );
Prototype void UpdateMODE( void );
Prototype UBYTE *MakeUniqueScrName( UBYTE *FmtString, UBYTE *PubScreenNameBuf );
Prototype void PrintStatus( register __a0 UBYTE *String, register __a1 APTR Fmt );
Prototype void SetVDragBar( struct VCtrl *CurVC );
Prototype void DoError( BOOL UseDOS );
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
Prototype struct Screen *Scr;
Prototype struct Gadget *MAINGList;
Prototype struct Gadget *MAINGadgets[];
Prototype struct Window *MAINWnd;
Prototype struct Gadget *FINDGadgets[];
Prototype struct Window *FINDWnd;
Prototype struct Gadget *FINDGList;
Prototype struct Gadget *HUNKLISTGadgets[];
Prototype struct Window *HUNKLISTWnd;
Prototype struct Gadget *HUNKLISTGList;
Prototype struct Gadget *JUMPGadgets[];
Prototype struct Window *JUMPWnd;
Prototype struct Menu *MAINMenus;

/* Hexy_winjump.c       */

Prototype void ViewJumpWindow( void );
Prototype void ClearJumpWindow( void );
Prototype void UpdateFindWindow( void );
Prototype void IDCMP_JUMP( void );

/* Hexy_winhunk.c       */

Prototype void ViewHunkListWindow( void );
Prototype void ClearHunkListWindow( void );
Prototype void UpdateHunkListWindow( void );
Prototype void IDCMP_HUNKLIST( void );
Prototype void BuildHunkList( void );
Prototype void RemoveHunkList( void );
Prototype struct HunkListNode *AddHunkListEntry( UBYTE *String, APTR Fmt, ULONG Offset );
Prototype struct HunkListNode *GetHLNAddress( ULONG Index );

/* Hexy_winfind.c       */

Prototype void ViewFindWindow( void );
Prototype void ClearFindWindow( void );
Prototype void UpdateJumpWindow( void );
Prototype void IDCMP_FIND( void );

/* MACHINE GENERATED */

