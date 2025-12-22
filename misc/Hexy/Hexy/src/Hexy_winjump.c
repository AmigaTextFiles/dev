
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_winjump.c
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

#include <Hexy.h>

Prototype void ViewJumpWindow( void );
Prototype void ClearJumpWindow( void );
Prototype void UpdateFindWindow( void );
Prototype void IDCMP_JUMP( void );

void ViewJumpWindow( void )
{
  /*************************************************
   *
   * 
   *
   */

  if ( JUMPWnd )
  {
    WindowToFront( JUMPWnd );
    ActivateWindow( JUMPWnd );
    return;
  }

  if (!ValidFile(&VC)) return;

  if (!OpenJUMPWindow())
  {
    SwapPort(JUMPWnd, WinPort);
    UpdateJumpWindow();
  }
  else
  {
    CloseJUMPWindow();
  }
}

void ClearJumpWindow( void )
{
  /*************************************************
   *
   * 
   *
   */

  if (!JUMPWnd) return;

  FlushWindow(JUMPWnd);
  CloseJUMPWindow();
}

UBYTE TmpBuf[128+4];

void UpdateJumpWindow( void )
{
  /*************************************************
   *
   * 
   *
   */

}

void IDCMP_JUMP( void )
{
  /*************************************************
   *
   * 
   *
   */

  switch(IM.Class)
  {
    case IDCMP_CLOSEWINDOW:
      ClearJumpWindow();
      break;

    case IDCMP_MOUSEBUTTONS:
    case IDCMP_ACTIVEWINDOW:
      ActivateGadget(JUMPGadgets[GD_FGSTRING], JUMPWnd, NULL);
      break;

    case IDCMP_REFRESHWINDOW:
      JUMPRender();
      break;

    case IDCMP_GADGETUP:
      switch(Gad->GadgetID)
      {
        case GD_JGSTRING:
        {
          UBYTE *OffsetString;
          ULONG Offset;
          char *Tail;       /* Not used */
          GT_GetGadgetAttrs(JUMPGadgets[GD_JGSTRING], JUMPWnd, NULL, GTST_String, &OffsetString, TAG_DONE);

          if (OffsetString[0] == '$')
          {
            Offset = strtoul(OffsetString+1, &Tail, 16);
          }
          else
          {
            Offset = strtoul(OffsetString, &Tail, 0);
          }

          /* Note: Do more error checking here */

          if (Offset <= VC.VC_FileLength)
          {
            VC.VC_CurrentPoint = Offset;
            UpdateView(&VC, NULL);
          }
          else DisplayBeep(HexyScreen);

          UpdateJumpWindow();
          break;
        }

        case GD_JGDONE:
          ClearJumpWindow();
          break;
      }
      break;

    default:
      break;
  }
}

/*************************************************
 *
 * 
 *
 */

