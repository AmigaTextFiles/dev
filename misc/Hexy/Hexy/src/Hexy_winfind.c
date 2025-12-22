
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_winfind.c
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

Prototype void ViewFindWindow( void );
Prototype void ClearFindWindow( void );
Prototype void UpdateJumpWindow( void );
Prototype void IDCMP_FIND( void );

void ViewFindWindow( void )
{
  /*************************************************
   *
   * 
   *
   */

  if ( FINDWnd )
  {
    WindowToFront( FINDWnd );
    ActivateWindow( FINDWnd );
    return;
  }

  if (!ValidFile(&VC)) return;

  if (!OpenFINDWindow())
  {
    SwapPort(FINDWnd, WinPort);
    UpdateFindWindow();
  }
  else
  {
    CloseFINDWindow();
  }
}

void ClearFindWindow( void )
{
  /*************************************************
   *
   * 
   *
   */

  if (!FINDWnd) return;

  FlushWindow(FINDWnd);
  CloseFINDWindow();
}

void UpdateFindWindow( void )
{
  /*************************************************
   *
   * 
   *
   */
}

void IDCMP_FIND( void )
{
  /*************************************************
   *
   * 
   *
   */

  switch(IM.Class)
  {
    case IDCMP_CLOSEWINDOW:
      ClearFindWindow();
      break;

    case IDCMP_MOUSEBUTTONS:
    case IDCMP_ACTIVEWINDOW:
      ActivateGadget(FINDGadgets[GD_FGSTRING], FINDWnd, NULL);
      break;

    case IDCMP_REFRESHWINDOW: /* Check flags */
      FINDRender();
      break;

    case IDCMP_GADGETUP:
    {
      switch(Gad->GadgetID)
      {
        /* Use find next & find prev */

        case GD_FGFINDNEXT:
        {
          UBYTE *HuntString;
          ULONG r = GT_GetGadgetAttrs(FINDGadgets[GD_FGSTRING], MAINWnd, NULL, GTST_String, &HuntString, TAG_DONE);
          if (r)
          {
            ULONG Len;
            if (Len = strlen(HuntString))
            {
              /* Convert bin fmt string to bin */

              UBYTE TmpBuf[512+4];
              ULONG Check;
              ULONG r = GT_GetGadgetAttrs(FINDGadgets[GD_FGBINSEARCH], MAINWnd, NULL, GTCB_Checked, &Check, TAG_DONE);
              ULONG INC = 0; ULONG Offset = 0;
              if (!r)
              {
                DisplayBeep(Scr); break;
              }
              if (Check)
              {
                if (Len = ConvertBinStr(HuntString, &TmpBuf))
                {
                  HuntString = (UBYTE *) &TmpBuf;
                }
                else break;
              }

              PrintStatus("Please wait hunting...", NULL);
              
              if (!memcmp(HuntString, VC.VC_FileAddress + VC.VC_CurrentPoint , Len)) INC++;
              Offset = SearchMem((VC.VC_FileAddress + VC.VC_CurrentPoint) + INC, (VC.VC_FileLength - VC.VC_CurrentPoint) - INC, HuntString, Len);
              if (Offset == -1)
              {
                DisplayBeep(Scr);
                PrintStatus("Sorry string was not found!", NULL);
              }
              else
              {
                VC.VC_CurrentPoint += (Offset + INC);
                UpdateView(&VC, NULL);
                SetVDragBar(&VC);
                PrintStatus("String found at file offset 0x%08lx", &VC.VC_CurrentPoint);
              }
            }
            else
            {
              PrintStatus("I need a string!", NULL);
            }
          }
          break;
        }
        case GD_FGFINDPREV:
        {
          UBYTE *HuntString;
          ULONG r = GT_GetGadgetAttrs(FINDGadgets[GD_FGSTRING], MAINWnd, NULL, GTST_String, &HuntString, TAG_DONE);
          if (r)
          {
            ULONG Len;
            if (Len = strlen(HuntString))
            {
              UBYTE TmpBuf[512+4];
              ULONG Check;
              ULONG r = GT_GetGadgetAttrs(FINDGadgets[GD_FGBINSEARCH], MAINWnd, NULL, GTCB_Checked, &Check, TAG_DONE);
              ULONG Offset;

              if (!r)
              {
                DisplayBeep(Scr); break;
              }
              if (Check)
              {
                if (Len = ConvertBinStr(HuntString, &TmpBuf))
                {
                  HuntString = (UBYTE *) &TmpBuf;
                }
                else break;
              }

              PrintStatus("Please wait hunting...", NULL);
              Offset = SearchMemRev(VC.VC_FileAddress, VC.VC_CurrentPoint, HuntString, Len);
              if (Offset == ~NULL)
              {
                DisplayBeep(Scr);
                PrintStatus("Sorry string was not found!", NULL);
              }
              else
              {
                VC.VC_CurrentPoint = Offset;
                UpdateView(&VC, NULL);
                SetVDragBar(&VC);
                PrintStatus("String found at file offset 0x%08lx", &VC.VC_CurrentPoint);
              }
            }
            else
            {
              PrintStatus("I need a string!", NULL);
            }
          }
          break;
        }
        case GD_FGDONE:
          ClearFindWindow();
          break;
        case GD_FGSTRING:
          UpdateBinResult();
          break;
        case GD_FGIGNORECASE:
          break;
        case GD_FGBINSEARCH:
          UpdateBinResult();
          break;
        default:
          break;
      }
    }
    default:
      break;
  }
}

/*************************************************
 *
 * 
 *
 */

