
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_winhunk.c
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

Prototype void ViewHunkListWindow( void );
Prototype void ClearHunkListWindow( void );
Prototype void UpdateHunkListWindow( void );
Prototype void IDCMP_HUNKLIST( void );
Prototype void BuildHunkList( void );
Prototype void RemoveHunkList( void );
Prototype struct HunkListNode *AddHunkListNode( UBYTE *String, APTR Fmt, ULONG Offset );
Prototype struct HunkListNode *GetHLNAddress( ULONG Index );

struct List HunkList;

struct HunkListNode
{
  struct Node HLN_Node;
  ULONG       HLN_Offset;
  ULONG       HLN_Length;           /* currently not used */
  UBYTE       HLN_ViewString[128];
};

void ViewHunkListWindow( void )
{
  /*************************************************
   *
   * Show the HunkList window 
   *
   */

  if ( HUNKLISTWnd )
  {
    WindowToFront( HUNKLISTWnd );
    ActivateWindow( HUNKLISTWnd );
    return;
  }

  if (!ValidFile(&VC)) return;

  if (!OpenHUNKLISTWindow())
  {
    SwapPort(HUNKLISTWnd, WinPort);

    BuildHunkList();

    UpdateHunkListWindow();
  }
  else
  {
    CloseHUNKLISTWindow();
  }
}

void ClearHunkListWindow( void )
{
  /*************************************************
   *
   * Hide the HunkList window 
   *
   */

  if (!HUNKLISTWnd) return;

  FlushWindow(HUNKLISTWnd);
  CloseHUNKLISTWindow();
  RemoveHunkList();
}

void UpdateHunkListWindow( void )
{
  /*************************************************
   *
   * 
   *
   */
}

void IDCMP_HUNKLIST( void )
{
  /*************************************************
   *
   * Process any IDCMP events relating to the HunkList window
   *
   */

  if (IDCMP_CheckRAWKEYS()) return;
  
  switch(IM.Class)
  {
    case IDCMP_CLOSEWINDOW:
      ClearHunkListWindow();
      break;

    case IDCMP_MOUSEBUTTONS:
    case IDCMP_ACTIVEWINDOW:
      break;

    case IDCMP_REFRESHWINDOW:
      /* HUNKLISTRender(); */
      break;

    case IDCMP_GADGETUP:
      switch(Gad->GadgetID)
      {
        case GD_HLLV:
          break;
        case GD_HLDONE:
          ClearHunkListWindow();
          break;
        case GD_HLGOTO:
        {
          ULONG Sel = -1;

          GT_GetGadgetAttrs(HUNKLISTGadgets[GD_HLLV], HUNKLISTWnd, NULL,
            GTLV_Selected, &Sel, TAG_DONE );

          if (Sel != -1)
          {
            struct HunkListNode *HLN = (struct HunkListNode *) GetHLNAddress( Sel );
            if ( HLN )
            {
              if (HLN->HLN_Offset != -1)
              {
                if (HLN->HLN_Offset <= VC.VC_FileLength)
                {
                  VC.VC_CurrentPoint = HLN->HLN_Offset;
                  UpdateView(&VC, NULL);
                  SetVDragBar(&VC);
                }
                else DisplayBeep(HexyScreen);
              }
              else DisplayBeep(HexyScreen);
            }
            else DisplayBeep(HexyScreen);
          }
          else DisplayBeep(HexyScreen);
          break;
        }
        default:
          break;
      }
      break;

    default:
      break;
  } /* switch(CLASS) */
}

void BuildHunkList( void ) /* Put hunk list in view control */
{
  /*************************************************
   *
   * The the main hunk list for the HunkList window
   *
   */

  /* Build a linked list for the hunk window LV. */

  BOOL running = TRUE;
  ULONG *Ptr = (ULONG *) VC.VC_FileAddress;
  ULONG *UpperPtr = Ptr;
  ((UBYTE *)UpperPtr) += VC.VC_FileLength;

  NewList( (struct List *) &HunkList );

  if (*Ptr != HUNK_HEADER)
  {
    AddHunkListNode( "This file is not executable!", NULL , ~NULL);
  }
  else
  {
    while( Ptr < UpperPtr && running == TRUE )
    {
      ULONG Offset = ((UBYTE *)Ptr) - VC.VC_FileAddress;
      ULONG HunkID = *Ptr++ & 0x0000ffff;
      ULONG Length = *Ptr++;                   /* Length in longwords */

      switch( HunkID )
      {
        case HUNK_HEADER:
        {
          ULONG AmountOfHunks;
          stream[0] = Offset;
          stream[1] = *Ptr++; /* Total */
          AmountOfHunks = Ptr[1] - Ptr[0];
          stream[2] = *Ptr++; /* Rng1 */
          stream[3] = *Ptr++; /* Rng2 */
          Ptr += AmountOfHunks + 1;
          AddHunkListNode( "0x%08lx HUNK_HEADER   %lu hunks, %lu to %lu", &stream, Offset );
          break;
        }

        case HUNK_CODE:
        {
          stream[0] = Offset;
          stream[1] = Length << 2;
          AddHunkListNode( "0x%08lx HUNK_CODE     %lu bytes in size", &stream, Offset );
          Ptr += Length;
          break;
        }

        case HUNK_DATA:
          stream[0] = Offset;
          stream[1] = Length << 2;
          AddHunkListNode( "0x%08lx HUNK_DATA     %lu bytes in size", &stream, Offset );
          Ptr += Length;
          break;

        case HUNK_BSS:
          stream[0] = Offset;
          stream[1] = Length << 2;
          AddHunkListNode( "0x%08lx HUNK_BSS      %lu bytes in size", &stream, Offset );
          break;

        case HUNK_END:
          stream[0] = Offset;
          Ptr--;
          AddHunkListNode( "0x%08lx HUNK_END", &stream, Offset );
          break;

        case HUNK_DEBUG:
          stream[0] = Offset;
          stream[1] = Length << 2;
          AddHunkListNode( "0x%08lx HUNK_DEBUG    %lu bytes in size", &stream, Offset );
          Ptr += Length;
          break;

        case HUNK_RELOC32:
        {
          ULONG Amount;
          stream[1] = stream[2] = 0;
          
          Ptr--; /* Fix */
          while (Amount = *Ptr++)
          {
            Ptr++; /* Skip hunk index */
            Ptr += Amount;
            stream[1] += Amount;
            stream[2]++;
          }
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_RELOC32  %lu entries, %lu hunks", &stream, Offset );
          break;
        }

        case HUNK_DREL32:
        {
          UWORD Amount;
          stream[1] = stream[2] = NULL;
          
          Ptr--; /* Fix */
          while (Amount = *((UWORD *)Ptr)++)
          {
            ((UWORD *)Ptr)++ ; /* Skip hunk index */
            ((UWORD *)Ptr) += Amount;
            stream[1] += Amount;
            stream[2]++;
          }
          /* Longword align pointer */
          while( (( ((ULONG)Ptr) >> 2) << 2) != ((ULONG)Ptr))
          {   
            ((UBYTE *)Ptr)++;
          } 
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_DREL32   %lu entries, %lu hunks", &stream, Offset );
          break;
        }

        case HUNK_SYMBOL: /* [Length] [Symbol] [Offset] */
        {
          ULONG SymbolLen;
          Ptr--;
          stream[1] = NULL;
          while (SymbolLen = *Ptr++)
          {
            Ptr += SymbolLen + 1; /* Skip symbol plus offset */
            stream[1]++;
          }
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_SYMBOL   %lu symbol entries", &stream, Offset );
          break;
        }

        case HUNK_RELOC32SHORT:
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_RELOC32SHORT Unsupported", &stream, Offset );
          running = FALSE;
          break;

        case HUNK_BREAK:
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_BREAK    Unsupported", &stream, Offset );
          running = FALSE;
          break;

        case HUNK_OVERLAY:
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_OVERLAY  Unsupported", &stream, Offset );
          running = FALSE;
          break;

        default:
          stream[0] = Offset;
          AddHunkListNode( "0x%08lx HUNK_<unknown>", &stream, Offset );
          running = FALSE;
          break;
      }
    }
  }

  GT_SetGadgetAttrs(HUNKLISTGadgets[GD_HLLV], HUNKLISTWnd, NULL,
    GTLV_Labels, &HunkList,
    TAG_DONE );
}

void RemoveHunkList( void )
{
  /*************************************************
   *
   * Free the hunk list
   *
   */

  /* Listview must be deleted before calling this function */

  struct HunkListNode *TempHLN = NULL;
  struct HunkListNode *HLN = NULL;

  for ( HLN = (struct HunkListNode *) HunkList.lh_Head; HLN->HLN_Node.ln_Succ;  )
  {
    TempHLN = (struct HunkListNode *) HLN->HLN_Node.ln_Succ;
    FreeVec( HLN );
    HLN = TempHLN;
  }
  NewList( (struct List *) &HunkList );
}

struct HunkListNode *AddHunkListNode( UBYTE *String, APTR Fmt, ULONG Offset )
{
  /*************************************************
   *
   * Add an entry to the hunk list 
   *
   */

  struct HunkListNode *HLN = (struct HunkListNode *) AllocVec( sizeof( struct HunkListNode ), MEMF_CLEAR );

  if ( HLN )
  {
    HLN->HLN_Offset = Offset;
    HLN->HLN_Node.ln_Name = (UBYTE *) &HLN->HLN_ViewString;
    /*Sprintf(String , (UBYTE *) &HLN->HLN_ViewString, Fmt);*/

    RawDoFmt(String, Fmt, (void *) &putChProc, (UBYTE *) &HLN->HLN_ViewString);


    AddTail( (struct List *) &HunkList, (struct Node *) HLN );
  }

  return HLN;
}

struct HunkListNode *GetHLNAddress( ULONG Index )
{
  /*************************************************
   *
   * Get the address of a HLN 
   *
   */

  struct HunkListNode *HLN;

  for ( HLN = (struct HunkListNode *) HunkList.lh_Head; HLN->HLN_Node.ln_Succ; HLN = (struct  HunkListNode *) HLN->HLN_Node.ln_Succ )
  {
    if (!Index--) return HLN;
  }

  return 0;
}

/*************************************************
 *
 * 
 *
 */

