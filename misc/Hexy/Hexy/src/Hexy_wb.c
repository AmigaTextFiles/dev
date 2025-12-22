
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_wb.c
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
Prototype struct DiskObject *AI_GetDiskObject( void );
Prototype void AI_FreeDiskObject( void );

/* Variables and data */

ULONG CxErrCode = NULL;
CxObj *CxBrok = NULL;
struct MsgPort *CxMP = NULL;
ULONG SigFlag_Cx = NULL;
struct MsgPort *AppMP = NULL;
ULONG SigFlag_App = NULL;
struct AppIcon *AI = NULL;

struct NewBroker CxBrokerInfo =
{
  NB_VERSION,
  "Hexy",
  VERS " Copyright © " YEAR " Andrew Bell",
  "The worlds best hex viewer/editor :-)",
  NBU_NOTIFY,
  COF_SHOW_HIDE,   /* Flags    */
  0,               /* Priority */
  0,               /* Port     */
  0                /* Reserved */
};

BOOL InitCX( void )
{
  /*************************************************
   *
   * Setup CX releated stuff 
   *
   */

  CxMP = NULL;
  SigFlag_Cx = NULL;

  if (CxMP = CreateMsgPort())
  {
    CxBrokerInfo.nb_Port = CxMP;
    if (CxBrok = CxBroker((struct NewBroker *) &CxBrokerInfo,
                  (LONG *) &CxErrCode))
    {
      ActivateCxObj( (CxObj *) CxBrok, -1L);
      SigFlag_Cx = 1 << CxMP->mp_SigBit;
    }
    else return FALSE;
  }
  return TRUE;
}

void FreeCX( void )
{
  /*************************************************
   *
   * Free CX related stuff
   *
   */

  if (CxBrok) DeleteCxObj(CxBrok);
  if (CxMP) DeleteMsgPort(CxMP);
}

BOOL DoCxEvent( void )
{
  /*************************************************
  *
  * Process CX releated events
  *
  */

  CxMsg *ThisMsg;
  BOOL result = FALSE;

  while(ThisMsg = (CxMsg *) GetMsg( CxMP ) )
  {
    LONG CxMID = CxMsgID( (CxMsg *) ThisMsg );
    ULONG CxMType = CxMsgType( (CxMsg *) ThisMsg );
    ReplyMsg( (struct Message *) ThisMsg);

    /* if (CxMType == CX_INVALID) continue; */

    switch(CxMType)
    {
      case CXM_COMMAND:
        switch(CxMID)
        {
          case CXCMD_UNIQUE:
            break;
          case CXCMD_KILL:
            result = TRUE;
            break;
          case CXCMD_APPEAR:
            if (GUIActive)
            {
              ScreenToFront(HexyScreen);
              ActivateWindow(MAINWnd);
            }
            else if (ViewGUI())
            {
              UpdateView(&VC, NULL);
              SetVDragBar(&VC);
            }
            else
            {
              ClearGUI(); DisplayBeep(NULL);
            }
            break;
          case CXCMD_DISAPPEAR:
            DoIconify();
            break;
        }
        break;
    }
  }
  return result;
}

BOOL InitApp( void )  /* AppIcon stuff */
{
  /*************************************************
  *
  * Init Hexy AppIcon 
  *
  */

  AppMP = NULL;
  SigFlag_App = NULL;

  if (AppMP = CreateMsgPort())
  {
    SigFlag_App = 1 << AppMP->mp_SigBit;
  }
  else return FALSE;
  
  AI_GetDiskObject();
  
  return TRUE;
}

void FreeApp( void )
{
  /*************************************************
   *
   * Remove Hexy AppIcon for good 
   *
   */

  KillAppIcon();

  AI_FreeDiskObject();
  
  if (AppMP)
  {
    DeleteMsgPort(AppMP);
    AppMP = NULL;
  }
}

/* Ported from FloppyFlux 1.3 in August 1999 :) */

struct DiskObject *DiskObj;

struct DiskObject *AI_GetDiskObject( void )
{
  /*************************************************
   *
   * 
   *
   */

  UBYTE PrgNameBuf[256+4];
  BPTR PrgDirLock = GetProgramDir();
  BOOL success = FALSE;
  UBYTE *tmp = NULL;

  PrgNameBuf[0] = 0;

  if (PrgDirLock)
  {
    NameFromLock(PrgDirLock, (UBYTE *) &PrgNameBuf, 256L);

    /* Note: We don't need to unlock PrgDirLock. */
  }

  /* Locate Hexy's program name */

  if (HexyWBMsg)
  {
    UBYTE *WBName = HexyWBMsg->sm_ArgList->wa_Name;

    if (WBName)
    {
      AddPart((UBYTE *) &PrgNameBuf, WBName, 256L);
      
      success = TRUE;
    }
  }
  else
  { 
    UBYTE TmpName[128+4];
    
    if (GetProgramName((UBYTE *) &TmpName, 128L))
    {
      AddPart((UBYTE *) &PrgNameBuf, (UBYTE *) &TmpName, 256L);
      
      success = TRUE;
    }
    else HexyInformation("Failed to get program's name!", NULL);
  }

  /* Load Hexy's icon and convert it to an AppIcon */

  if (success)
  {
    if (DiskObj = GetDiskObjectNew( (UBYTE *) &PrgNameBuf ))
    {
      DiskObj->do_Magic = 0;
      DiskObj->do_Version = 0;
      DiskObj->do_Gadget.NextGadget = NULL;
      DiskObj->do_Gadget.LeftEdge = 0;
      DiskObj->do_Gadget.TopEdge = 0;
      DiskObj->do_Gadget.Activation = 0;
      DiskObj->do_Gadget.GadgetType = 0;
      ((struct Image *)DiskObj->do_Gadget.GadgetRender)->LeftEdge = 0;
      ((struct Image *)DiskObj->do_Gadget.GadgetRender)->TopEdge = 0;
      ((struct Image *)DiskObj->do_Gadget.GadgetRender)->PlaneOnOff = 0;
      ((struct Image *)DiskObj->do_Gadget.GadgetRender)->NextImage = NULL;
      DiskObj->do_Gadget.GadgetText = NULL;
      DiskObj->do_Gadget.MutualExclude = 0;
      DiskObj->do_Gadget.SpecialInfo = NULL;
      DiskObj->do_Gadget.GadgetID = 0;
      DiskObj->do_Gadget.UserData = NULL;
      DiskObj->do_Type = 0;
      DiskObj->do_DefaultTool = NULL;
      DiskObj->do_ToolTypes = NULL;
      DiskObj->do_CurrentX = NO_ICON_POSITION;
      DiskObj->do_CurrentY = NO_ICON_POSITION;
      DiskObj->do_DrawerData = NULL;
      DiskObj->do_ToolWindow = NULL;
      DiskObj->do_StackSize = 0;
    }
    else
    {
    }
  }
  else HexyInformation("Cannot locate program name!", NULL);

  if (!DiskObj)
  {
    /*HexyInformation("Failed to get AppIcon object!", NULL);*/
  }

  return DiskObj;
}

void AI_FreeDiskObject( void )
{
  /*************************************************
   *
   * Free the AppIcon that Hexy is using for
   * iconification.
   *
   */

  if (DiskObj)
  {
    FreeDiskObject(DiskObj);
    DiskObj = NULL;
  }
}

void KillAppIcon( void )
{
  /*************************************************
   *
   * Remove AppIcon for view 
   *
   */

  if (AI)
  {
    RemoveAppIcon(AI);
    AI = NULL;
  }
}

BOOL DoIconify( void )
{
  /*************************************************
   *
   * Perform iconification of Hexy 
   *
   */

  /* Returns TRUE on success, else FALSE on failure! */

  UBYTE TempBuffer[256+4]; /* Note: this is eating up stack space */

  if (!DiskObj)
  {
    DisplayBeep(NULL);  /* Temp */

    HexyInformation("Cannot iconify because there is no .info file\n"
                    "associated with Hexy's executable or there was\n"
                    "an error while Hexy was trying to obtain it."
                    "\n\n"
                    "Hexy needs an .info file to create an WB AppIcon.",  NULL);
    
    return FALSE;
  }

  AI = NULL;

  /* Get the filename */

  stream[0] = (ULONG) "<< No file loaded >>";

  if (VC.VC_FIB)
  {
    stream[0] = (ULONG) &VC.VC_FIB->fib_FileName;
  }
  RawDoFmt("Hexy: %.128s", &stream, (void *) &putChProc, &TempBuffer);

  /* Create the AppIcon */

  AI = (struct AppIcon *) AddAppIcon(NULL, NULL, (UBYTE *) &TempBuffer, AppMP, NULL, DiskObj, NULL);

  if (AI)               /* Did the AppIcon appear OK? */
  {
    ClearGUI();         /* If so, remove GUI! */
    return TRUE;
  }
  else
  {
    DisplayBeep(NULL);  /* Temp */

    HexyInformation("Cannot iconify because Hexy was unable to create a WB AppIcon.", NULL);

    return FALSE;
  }
}

BOOL DoAppEvent( void ) /* This will un-iconify the Hexy GUI */
{
  /*************************************************
   *
   * Process any events related to the AppIcon 
   *
   */

  /* If the user double clicks the icon, then Hexy's GUI will open up
     normally, else if an icon is dropped onto the AppIcon the a new
     file is loaded and the GUI opened. */

  struct AppMessage *ThisMsg;

  while(ThisMsg = (struct AppMessage *) GetMsg(AppMP))
  {
    switch(ThisMsg->am_Type)
    {
      case AMTYPE_APPICON:
        if (!ThisMsg->am_NumArgs && !ThisMsg->am_ArgList)
        {
          /* User has just double clicked AppIcon */

          if (!ViewGUI()) DisplayBeep(NULL);  /* Temp */
        }
        break;

      case AMTYPE_APPWINDOW:    /* Not supported yet! */
      case AMTYPE_APPMENUITEM:  /* Not supported yet! */
      default:
        break; /* We got an unknown message type! */
    }

    /*if (ThisMsg->? == CX_INVALID) continue;*/

    ReplyMsg( (struct Message *) ThisMsg);
  }

  return TRUE;  /* Result not in use yet*/
}

/*************************************************
 *
 * 
 *
 */

