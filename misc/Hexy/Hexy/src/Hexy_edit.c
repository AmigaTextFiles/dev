
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_edit.c
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

Prototype void Edit_Begin( void );
Prototype void Edit_End( void );
Prototype void Edit_DisplayCursor( void );
Prototype void Edit_WriteChar( register __d0 LONG TempCursorOffset, register __d1 UBYTE Ch );
Prototype void Edit_WipeCursor( void );
Prototype BOOL Edit_ShiftCursor( register __d0 LONG Offset );
Prototype BOOL Edit_DoEditIDCMP( struct IntuiMessage *IM );
Prototype BOOL EditFlag;

BOOL EditFlag = FALSE;
LONG CursorOffset = 0;
LONG CursorOffsetNibble;  /* 0 = Lower 4 bits ($0F), 1 = upper 4 bits ($F0) */

#define LOWER_NIBBLE 0  /* ($0F) */
#define UPPER_NIBBLE 1  /* ($F0) */

ULONG OldCursX1, OldCursY1;
ULONG OldCursX2, OldCursY2;

void Edit_Begin( void )
{
  /*************************************************
   *
   * Start edit mode 
   *
   */

  ULONG Sel;

  if (EditFlag) return;

  if (GT_GetGadgetAttrs(MAINGadgets[GD_GEDIT], MAINWnd, NULL,
        GTCB_Checked, &Sel,
        TAG_DONE))
  {
    if (!Sel) GT_SetGadgetAttrs(MAINGadgets[GD_GEDIT], MAINWnd, NULL,
      GTCB_Checked, TRUE,
      TAG_DONE);
  }

  EditFlag = TRUE;
  CursorOffsetNibble = UPPER_NIBBLE;
  OldCursX1 = -1;
  Edit_DisplayCursor();
}

void Edit_End( void )
{
  /*************************************************
   *
   * End edit mode 
   *
   */

  ULONG Sel;

  if (!EditFlag) return;

  if (GT_GetGadgetAttrs(MAINGadgets[GD_GEDIT], MAINWnd, NULL,
        GTCB_Checked, &Sel,
        TAG_DONE))
  {
    if (Sel) GT_SetGadgetAttrs(MAINGadgets[GD_GEDIT], MAINWnd, NULL,
              GTCB_Checked, FALSE,
              TAG_DONE);
  }

  EditFlag = FALSE;
  Edit_WipeCursor();

  PrintStatus("", NULL);  
}

/* Initial offset for invisible HEX edit grid */

#define DUMPGRIDHEX_XPOS ((13 + (9 * 8)) - 5)
#define DUMPGRIDHEX_YPOS (18-10)
#define DUMPGRIDHEXASC_XPOS (DUMPGRIDHEX_XPOS + (((XAMOUNT_HEX * 2) + 6) * 8))
#define DUMPGRIDHEXASC_YPOS 18            

/* Initial offset for invisible ASCII edit grid */

#define DUMPGRIDASC_XPOS ((13 + (10 * 8)) - 5)
#define DUMPGRIDASC_YPOS (18-10)
#define CURSOR_XSIZE 8
#define CURSOR_YSIZE 7

void Edit_DisplayCursor( void )
{
  /*************************************************
   *
   * Display the edit cursor
   *
   */

  /* This fuction should check to see if cursor is out of bounds,
     if so, modify it to fit within the bounds. */

  ULONG CursorOffset_X, CursorOffset_Y;

  if (!EditFlag) return;

  SetDrMd(MAINWnd->RPort, COMPLEMENT);

  if (OldCursX1 != -1)  /* Delete old cursor, if it exists! */
  {
    RectFill( MAINWnd->RPort,
      OldCursX1, OldCursY1,
      OldCursX2, OldCursY2 );
  }

  /* Has the cursor move passed EOF? */

  if (CursorOffset > ((VC.VC_FileLength - VC.VC_CurrentPoint) - 1 ))
  {
    CursorOffset = (VC.VC_FileLength - VC.VC_CurrentPoint) - 1;
  }

  if (VC.VC_Mode == HEXYMODE_HEX)
  {
    CursorOffset_X = CursorOffset % XAMOUNT_HEX;
    CursorOffset_Y = CursorOffset / XAMOUNT_HEX;

    CursorOffset_X *= 2;

    if (CursorOffset_X >= (16 * 2)) CursorOffset_X += 4;
    else if (CursorOffset_X >= (12 * 2)) CursorOffset_X += 3;
    else if (CursorOffset_X >= (8 * 2)) CursorOffset_X += 2;
    else if (CursorOffset_X >= (4 * 2)) CursorOffset_X++;

    RectFill(MAINWnd->RPort,
      OldCursX1 = ((CursorOffset_X * 8) + DUMPGRIDHEX_XPOS + 1),
      OldCursY1 = ((CursorOffset_Y * 8) + DUMPGRIDHEX_YPOS),
      OldCursX2 = ((CursorOffset_X * 8) + DUMPGRIDHEX_XPOS +
                                          (CURSOR_XSIZE * 2) + 1),
      OldCursY2 = ((CursorOffset_Y * 8) + DUMPGRIDHEX_YPOS +
                                          CURSOR_YSIZE));

  }
  else if (VC.VC_Mode == HEXYMODE_ASCII)
  {
    CursorOffset_X = CursorOffset % XAMOUNT_ASCII;
    CursorOffset_Y = CursorOffset / XAMOUNT_ASCII;

    RectFill(MAINWnd->RPort,
      OldCursX1 = ((CursorOffset_X * 8) + DUMPGRIDASC_XPOS + 1),
      OldCursY1 = ((CursorOffset_Y * 8) + DUMPGRIDASC_YPOS),
      OldCursX2 = ((CursorOffset_X * 8) + DUMPGRIDASC_XPOS + (CURSOR_XSIZE * 1) + 1),
      OldCursY2 = ((CursorOffset_Y * 8) + DUMPGRIDASC_YPOS + CURSOR_YSIZE));
  }

  SetDrMd(MAINWnd->RPort, JAM2);

  {
    ULONG res;    
    res = VC.VC_CurrentPoint + CursorOffset;
    PrintStatus("Offset = %lu", &res);
  }

}

UBYTE HexByte;
UBYTE HexByte_UpperCode;
UBYTE HexByte_LowerCode;
UBYTE HexByte_Upper;
UBYTE HexByte_Lower;

void Edit_WriteChar( register __d0 LONG TempCursorOffset,
                     register __d1 UBYTE Ch )
{
  /*************************************************
   *
   * Write a char to the file 
   *
   */

  ULONG CursorOffset_X, CursorOffset_Y;
  UBYTE ChCode;
  UBYTE *EditBit;
  BOOL r;
  UBYTE TmpCh; 

  if (VC.VC_Mode == HEXYMODE_HEX)
  {
    CursorOffset_X = TempCursorOffset % XAMOUNT_HEX;
    CursorOffset_Y = TempCursorOffset / XAMOUNT_HEX;

    CursorOffset_X *= 2;

    /* VALID HEX DIGITS: 0123456789 abcdef ABCDEF  */
    
    if ((Ch >= 'a') && (Ch <= 'f'))
    {
      Ch -= 0x20;   /* Change lowercase to UPPERCASE */
    }

    /* Make sure we have a valid HEX digit! */

    if (!(((Ch >= 'A') && (Ch <= 'F')) ||
       ((Ch >= '0') && (Ch <= '9'))))
      {
        DisplayBeep(Scr);
        PrintStatus("Not a hexdecimal digit!", NULL);
        return;
      }

    if ((Ch >= 'A') && (Ch <= 'F'))
      ChCode = (Ch - ('A' + 0x10)); /* + $10 */
    else
      ChCode = (Ch - '0');

    if (CursorOffsetNibble == LOWER_NIBBLE)
    {
      HexByte_LowerCode = ChCode;
      HexByte_Lower = Ch;

      if (CursorOffset_X >= (16 * 2)) CursorOffset_X += 4;
      else if (CursorOffset_X >= (12 * 2)) CursorOffset_X += 3;
      else if (CursorOffset_X >= (8 * 2)) CursorOffset_X += 2;
      else if (CursorOffset_X >= (4 * 2)) CursorOffset_X++;

      HexByte = ((HexByte_UpperCode << 4) | HexByte_LowerCode);

      EditBit = (UBYTE *)
        (VC.VC_FileAddress + VC.VC_CurrentPoint + CursorOffset);

      /* A basic safety check */

      if ((EditBit <= (VC.VC_FileAddress + VC.VC_FileLength)) &&
        (EditBit >= (VC.VC_FileAddress)))
      {
        EditBit[0] = HexByte; /* Modify the actual file */
      }
      else
      {
        DisplayBeep(Scr);
        PrintStatus("INTERNAL ERROR: "
                    "Hexadecimal write back out of bounds!", NULL);
      }

      if (r = Edit_ShiftCursor(1)) Edit_WipeCursor();

      SetAPen(MAINWnd->RPort, 1);   /* Pen to black */

      Move(MAINWnd->RPort,                    /* First hex digit */
          (CursorOffset_X * 8) + DUMPGRIDASC_XPOS + 1 - 8,
          (CursorOffset_Y * 8) + DUMPGRIDASC_YPOS + 6);

      Text(MAINWnd->RPort, &HexByte_Upper, 1);

      Move(MAINWnd->RPort,                    /* Second hex digit */
          (CursorOffset_X * 8) + DUMPGRIDASC_XPOS + 1 + 8 - 8,
          (CursorOffset_Y * 8) + DUMPGRIDASC_YPOS + 6);
      Text(MAINWnd->RPort, &HexByte_Lower, 1);

      if (r) Edit_DisplayCursor();

      /* Display text on other side of HEX dump here!!! */

      CursorOffset_X = TempCursorOffset % XAMOUNT_HEX;
      CursorOffset_Y = TempCursorOffset / XAMOUNT_HEX;

      /* Write ch to ASCII dump (at right hand side of screen) */

      Move(MAINWnd->RPort,
          (CursorOffset_X * 8) + DUMPGRIDHEXASC_XPOS + 1 - 8,
          (CursorOffset_Y * 8) + DUMPGRIDHEXASC_YPOS + 6 - 10);

      Text(MAINWnd->RPort, &HexByte, 1);

      CursorOffsetNibble = UPPER_NIBBLE;
    }
    else /* UPPER_NIBBLE */
    {
      HexByte_Upper = Ch;
      HexByte_UpperCode = ChCode;
      CursorOffsetNibble = LOWER_NIBBLE;
    }

  }
  else if (VC.VC_Mode == HEXYMODE_ASCII)
  {
    UBYTE *EditBit = (UBYTE *)
      (VC.VC_FileAddress + VC.VC_CurrentPoint + CursorOffset);

    /* A basic safety check */

    if ((EditBit <= (VC.VC_FileAddress + VC.VC_FileLength)) &&
      (EditBit >= (VC.VC_FileAddress)))
    {
     /* Modify the actual file */

      EditBit[0] = Ch;
    }
    else
    {
      DisplayBeep(Scr);
      PrintStatus("Internal error: "
                  "ASCII write back out of bounds!", NULL);
    }

    r = Edit_ShiftCursor(1); if (r) Edit_WipeCursor();

    CursorOffset_X = TempCursorOffset % XAMOUNT_ASCII;
    CursorOffset_Y = TempCursorOffset / XAMOUNT_ASCII;

    SetAPen(MAINWnd->RPort, 1);

    Move(MAINWnd->RPort,                  /* Display ch */
        (CursorOffset_X * 8) + DUMPGRIDASC_XPOS + 1 ,
        (CursorOffset_Y * 8) + DUMPGRIDASC_YPOS + 6 );

    TmpCh = Ch;

    Text(MAINWnd->RPort, &TmpCh, 1);

    if (r) Edit_ShiftCursor(0);
  }
}

void Edit_WipeCursor( void )
{
  /*************************************************
   *
   * Clear the cursor from view 
   *
   */

  SetDrMd(MAINWnd->RPort, COMPLEMENT);

  if (OldCursX1 != -1)  /* Delete old cursor, if it exists. */
  {
    RectFill( MAINWnd->RPort,
      OldCursX1, OldCursY1,
      OldCursX2, OldCursY2 );
      
    OldCursX1 = ~NULL;
  }

  SetDrMd(MAINWnd->RPort, JAM2);
}

BOOL Edit_ShiftCursor( register __d0 LONG ShiftOffset )
{
  /*************************************************
   *
   * Move the cursor 
   *
   */

  /* This function will return TRUE if the cursor cannot be moved
     any further because of EOF! (SOF is not an issue here) */

  ULONG XAmt;
  ULONG EndAmt = (VC.VC_FileLength - VC.VC_CurrentPoint) - 1;

  /* Get the current display mode (HEX/ASCII) dump widths. */

  if (VC.VC_Mode == HEXYMODE_HEX)
  {
    XAmt = XAMOUNT_HEX;
  }
  else/* ASCII */
  {
    XAmt = XAMOUNT_ASCII;
  }

  /* This code will catch a flip from ASCII to HEX (and vise versa),
     when the cursor position is out of bounds. */

  if (CursorOffset > ((XAmt * YLINES) - 1))
  {
    CursorOffset = (XAmt * YLINES) - 1;
  }

  /* Has the cursor passed the display limits? */

  if ((CursorOffset + ShiftOffset) < 0)
  {
    if ((VC.VC_CurrentPoint - XAmt) < 0)  /* SOF check */
    {
      return(FALSE);
    }

    if (ShiftOffset == -1) XAmt = 1;

    AdjustView(&VC, -XAmt);
    SetVDragBar(&VC);
    return(FALSE);
  }
  else if ((CursorOffset + ShiftOffset) > ((XAmt * YLINES) - 1) )
  {
    if ((CursorOffset + ShiftOffset) > EndAmt)  /* EOF check */
    {
      return(TRUE);
    }

    if (ShiftOffset == 1) XAmt = 1;

    AdjustView(&VC, XAmt);
    SetVDragBar(&VC);
    return(FALSE);
  }

  /* Is the cursor at the EOF? */

  if ((CursorOffset + ShiftOffset) > EndAmt)
  {
    PrintStatus("Check 1", NULL);
    CursorOffset = (VC.VC_FileLength - VC.VC_CurrentPoint) - 1;
    Edit_DisplayCursor();
    return(TRUE);
  }

  CursorOffset += ShiftOffset;

  Edit_DisplayCursor();

  return(FALSE);
}

/* This flag is set to TRUE when the users
   scrolls the display while in edit mode. */

BOOL EditScrollFlag = FALSE;

BOOL Edit_DoEditIDCMP(struct IntuiMessage *EditIM)
{
  /*************************************************
   *
   * Parse IDCMP messages while in edit mode 
   *
   */

  /*
   * This function will return FALSE if the message has no use!
   *
   * NOTES: It should also handle scroller events
   *
   */

  struct Gadget *TempGad;

  if (!EditFlag) return(FALSE);

  TempGad = EditIM->IAddress;

  switch( EditIM->Class )
  {
    ULONG XShift;

    case IDCMP_RAWKEY:    

      if (VC.VC_Mode == HEXYMODE_HEX)
        XShift = XAMOUNT_HEX;
      else
        XShift = XAMOUNT_ASCII;
                
      CursorOffsetNibble = UPPER_NIBBLE;
      switch(EditIM->Code)
      {
        case CURSORLEFT: Edit_ShiftCursor(-1); break;
        case CURSORRIGHT: Edit_ShiftCursor(1); break;
        case CURSORUP: Edit_ShiftCursor(-XShift); break;
        case CURSORDOWN: Edit_ShiftCursor(XShift); break;
        default: return(FALSE); break;
      }
      break;

    case IDCMP_VANILLAKEY:
    {
      UBYTE ChStr[2] = {'?', 0};  /* Ch + NULL termination */
      ChStr[0] = (UBYTE) EditIM->Code;
      stream[0] = (ULONG) &ChStr;
      stream[1] = (ULONG) EditIM->Code;
      PrintStatus("Last key press: '%.1s' (0x%lx)", &stream);
      Edit_WriteChar(CursorOffset, (UBYTE) EditIM->Code);
      break;
    }

    case IDCMP_GADGETDOWN:
      if ( TempGad->GadgetID == GD_GVDRAGBAR )
      {
        EditScrollFlag = TRUE;
        switch(TempGad->GadgetID)
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
        return(TRUE);
      }
      return(FALSE);
      break;

    case IDCMP_GADGETUP:
    {
      ULONG XAmt, MoveAmt = -1;

      if (VC.VC_Mode == HEXYMODE_HEX)
        XAmt = XAMOUNT_HEX;
      else
        XAmt = XAMOUNT_ASCII;

      switch( TempGad->GadgetID )
      {
        case GD_GVDRAGBAR:
          EditScrollFlag = FALSE;
          return(TRUE);
          break;

        case GD_GNEXTL: MoveAmt = XAmt; break;
        case GD_GPREVL: MoveAmt = -XAmt; break;
        case GD_GNEXTP: MoveAmt = XAmt * YLINES; break;
        case GD_GPREVP: MoveAmt = -(XAmt * YLINES); break;
        case GD_GSEARCH:
            ViewFindWindow();
            break;
      }

      if (MoveAmt != -1)
      {
        AdjustView(&VC, MoveAmt);
        SetVDragBar(&VC);
        return(TRUE);
      }
      return(FALSE);
      break;
    }
    default: return(FALSE); break;
  }
  return(TRUE);
}

/*************************************************
 *
 * 
 *
 */


