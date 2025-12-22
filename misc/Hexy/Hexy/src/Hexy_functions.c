
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_functions.c
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

/* Prototypes */

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

/* Variables and data */

BOOL EnableFlash = TRUE;
struct Library *xfdMasterBase = NULL;
struct Library *FilevirusBase = NULL;
struct Library *XpkBase = NULL;
struct XpkFib *XFIB = NULL;

void FlashScreen( void )
{
  /*************************************************
   *
   * Special flash routine for Hexy 
   *
   */

  if (EnableFlash) DisplayBeep(Scr);
}

BOOL UnpackFile(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Unpack the file using xfdmaster.library
   *
   */

  BOOL Result = FALSE;
  struct xfdBufferInfo *xfdBI;
  UWORD uresult = CheckXPK(TmpVC);
  ULONG TempLen;

  if (uresult == HEXYUCODE_NOTPACKED || uresult == HEXYUCODE_ABORT) return TRUE;

  /* Create a CheckXFD() sub, then move this code to it! */

  if (xfdMasterBase = OpenLibrary("xfdmaster.library", 38L))
  {
    if (xfdBI = (struct xfdBufferInfo *) xfdAllocObject(XFDOBJ_BUFFERINFO))
    {
      xfdBI->xfdbi_SourceBuffer = TmpVC->VC_FileAddress;
      xfdBI->xfdbi_SourceBufLen = TmpVC->VC_FileLength;

      if (xfdRecogBuffer(xfdBI))
      {
        /* XFDPFB_USERTARGET may cause some problems */

        struct EasyStruct PackES =
        {
          sizeof(struct EasyStruct),
          NULL,
          "File info...",
          "File is compressed with\n[ %s ]\nDecompress it?",
          "Yes|No"
        };

        stream[0] = (ULONG) xfdBI->xfdbi_PackerName;
        if (EasyRequestArgs(MAINWnd, &PackES, NULL, &stream))
        {

          /* Check for password here */

          xfdBI->xfdbi_Flags |= XFDFF_USERTARGET;
          TempLen = xfdBI->xfdbi_MinTargetLen;
          if (TempLen)
          {
            APTR TempVec;
            if (TempVec = AllocVec(TempLen, xfdBI->xfdbi_TargetBufMemType))
            {
              xfdBI->xfdbi_UserTargetBuf = TempVec;
              xfdBI->xfdbi_UserTargetBufLen = TempLen;
              stream[0] = (ULONG)xfdBI->xfdbi_PackerName;
              PrintStatus("Please wait, decrunching file (%.40s)...", &stream);

              if (xfdDecrunchBuffer(xfdBI))
              {
                FreeVec(TmpVC->VC_FileAddress);
                TmpVC->VC_FileAddress = TempVec;
                TmpVC->VC_FileLength = xfdBI->xfdbi_FinalTargetLen;
                TmpVC->VC_CurrentPoint = NULL;
                Result = TRUE;
              }
              else
              {
                PrintStatus("Failed to decompress file!", &stream);
              }
            }
            else
            {
              PrintStatus("No memory to decompress file!", &stream);
            }
          }
        }
        else
        {
          PrintStatus("File NOT decompressed!", &stream);
        }
      }
      xfdFreeObject(xfdBI);
    }
    CloseLibrary(xfdMasterBase);
    xfdMasterBase = NULL;
  }
  return Result;
}

BOOL CheckForViruses(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Check file for viruses 
   *
   */

  /* Returns TRUE if file is infected with a virus. */

  /* Note, August 1999:
  
     Following code was removed because filevirus.library is out
     of date. Development of it has stopped. Maybe one day I'll
     add support for xvs.library. */

/*
  if (FilevirusBase = OpenLibrary("filevirus.library", 2))
  {
    struct FilevirusNode *fvnode;

    if (fvnode = (struct FilevirusNode *) fvAllocNode())
    {
      fvnode->fv_Buffer = TmpVC->VC_FileAddress;
      fvnode->fv_BufferLen = TmpVC->VC_FileLength;

      if (!fvCheckFile(fvnode, NULL))
      {
        if (fvnode->fv_FileInfection)
        {
          stream[0] = (ULONG) fvnode->fv_FileInfection->fi_VirusName;

          struct EasyStruct VirusES =
          {
            sizeof(struct EasyStruct),
            NULL,
            "WARNING!!!",
            "This file seems to be infected with the\n'%s'\nvirus!!!",
            "Oh Shit!"
          };
          EasyRequestArgs(MAINWnd, &VirusES, NULL, &stream);

        }
      }

      fvFreeNode(fvnode);
    }

    CloseLibrary(FilevirusBase); FilevirusBase = NULL;
  }
*/
  return FALSE;
}

UWORD CheckXPK(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Check and see if the file has been compressed with XPK
   *
   */

  BOOL Result = HEXYUCODE_NOTPACKED;

  if (XpkBase = OpenLibrary("xpkmaster.library", 5L))
  {
    if (XFIB = (struct XpkFib*) XpkAllocObject(XPKOBJ_FIB, NULL))
    {
      stream[0] = (ULONG) XPK_InBuf;
      stream[1] = (ULONG) TmpVC->VC_FileAddress;
      stream[2] = (ULONG) XPK_InLen;
      stream[3] = (ULONG) TmpVC->VC_FileLength;
      stream[4] = (ULONG) TAG_DONE;
      if (!XpkExamine(XFIB, (struct TagItem *) &stream))
      {
        if (XFIB->xf_Type == XPKTYPE_PACKED)
        {
          struct EasyStruct PackES =
          {
            sizeof(struct EasyStruct),
            NULL,
            "File info...",
            "File is compressed with\n[ XPK METHOD %.4s ]\nDecompress it?",
            "Yes|No"
          };
          stream[0] = (ULONG) &XFIB->xf_Packer;
          if (EasyRequestArgs(MAINWnd, &PackES, NULL, &stream))
          {
            APTR TempVec;
            ULONG TempVecRealLen = XFIB->xf_ULen;
            ULONG TempVecLen = TempVecRealLen + XPK_MARGIN;
            if (TempVec = AllocVec(TempVecLen, MEMF_ANY))
            {
              LONG XPKECODE;
              stream[0] = (ULONG) &XFIB->xf_Packer;
              PrintStatus("Please wait, decrunching XPK file (%-4.4s)...", &stream);
              stream[0] = (ULONG) XPK_InBuf;
              stream[1] = (ULONG) TmpVC->VC_FileAddress;
              stream[2] = (ULONG) XPK_InLen;
              stream[3] = (ULONG) TmpVC->VC_FileLength;
              stream[4] = (ULONG) XPK_OutBuf;
              stream[5] = (ULONG) TempVec;
              stream[6] = (ULONG) XPK_OutBufLen;
              stream[7] = (ULONG) TempVecLen;
              stream[8] = (ULONG) TAG_DONE;
              if (!(XPKECODE = XpkUnpack( (struct TagItem *) &stream)))
              {
                FreeVec(TmpVC->VC_FileAddress);
                TmpVC->VC_FileAddress = TempVec;
                TmpVC->VC_FileLength = TempVecRealLen;
                TmpVC->VC_CurrentPoint = NULL;
                Result = HEXYUCODE_OK;
              }
              else
              {
                stream[0] = XPKECODE;
                PrintStatus("XPK decompression failed (XPK ERROR CODE: %ld)", &stream);
                FlashScreen();
                Result = HEXYUCODE_ABORT;
              }
            }
          }
        }
      }
      XpkFreeObject(XPKOBJ_FIB ,XFIB);
    }
    CloseLibrary(XpkBase); XpkBase = NULL;
  }
  return Result;
}

ULONG ConvertBinStr(void *Source, void *Dest)
{
  ULONG Len = 0;

  /* This code was removed for the public release, too buggy :( */

  return 0;
  
  /*************************************************
   *
   * Convert "hello",1,$5f,4,5,51 to binary, etc.
   *
   */

  if (strlen(Source) > 128)
  {
    PrintStatus("String too big!", NULL); return NULL;
  }

  /* Len = FmtStrToRaw(Source, Dest, 128L); */

  if (Len)
  {
    return Len;
  }
  else
  {
    FlashScreen();
    PrintStatus("Invalid binary string!", NULL);
    return NULL;
  }
  return NULL;
}

void UpdateBinResult( void )
{
  UBYTE *Str;
  ULONG Check, Len, r;

   /* Note: This is taking up a lot of stack space! */
 
  UBYTE TmpBuf[512+4];
  /*UBYTE FmtBuf[512+4];*/

  /* Removed from release version, too buggy :( */
  
  return;
  
  /*************************************************
   *
   * Move this to the findwin module
   *
   */

  r = GT_GetGadgetAttrs(FINDGadgets[GD_FGSTRING], MAINWnd, NULL, GTST_String, &Str, TAG_DONE);

  if (!r) return;

  r = GT_GetGadgetAttrs(FINDGadgets[GD_FGBINSEARCH], MAINWnd, NULL, GTCB_Checked, &Check, TAG_DONE);

  if (!r)
  {
    FlashScreen(); return;
  }
  if (Check)
  {
    if (Len = ConvertBinStr(Str, &TmpBuf))
    {
      Str = (UBYTE *) &TmpBuf;
    }
    else return;
  }
  else
  {
    Len = strlen(Str);
  }

  /*BinToBinStr(Str, Len, (UBYTE *) &FmtBuf, 512L);

  GT_SetGadgetAttrs(FINDGadgets[GD_FGBINRESULT], FINDWnd, NULL,
    GTTX_Text, &FmtBuf,
    TAG_DONE);*/
}

UBYTE TitleBuffer[512+4];

void DisplayFileInfos(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Display info on the file in the title bar
   *
   */

  if (TmpVC->VC_FileAddress && MAINWnd)
  {
    stream[0] = (ULONG) &TmpVC->VC_FIB->fib_FileName;
    stream[1] = (ULONG) TmpVC->VC_FileLength;
    RawDoFmt("Hexy screen (%s, %lu bytes)", &stream, (void *) &putChProc, &TitleBuffer);
    SetWindowTitles(MAINWnd, (UBYTE *) -1, (UBYTE *) &TitleBuffer);
  }
}

BOOL ValidFile(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Check for valid file in a VC 
   *
   */

  if (!TmpVC->VC_FileAddress) return FALSE;
  if (!TmpVC->VC_FileLength) return FALSE;
  return TRUE;
}

BOOL LMBActive( void )
{
  /*************************************************
   *
   * Check for a press of the LMB
   *
   */

  BOOL result = FALSE;
  struct IntuiMessage *TmpIM;
  TmpIM = (struct IntuiMessage *) GT_GetIMsg(WinPort);

  if (TmpIM)
  {
    if (TmpIM->Class == IDCMP_MOUSEBUTTONS)
    {
      if (TmpIM->Code == SELECTDOWN) result = TRUE;
    }
    GT_ReplyIMsg(TmpIM);
  }
  return result;
}

void FreeVC(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Free the contents of a VC struct
   *
   */

  if (TmpVC->VC_FIB)
  {
    FreeDosObject(DOS_FIB, TmpVC->VC_FIB);
    TmpVC->VC_FIB = NULL;
  }

  if (TmpVC->VC_FileAddress)
  {
    FreeVec(TmpVC->VC_FileAddress);
    TmpVC->VC_FileAddress = NULL;
  }
}

/*************************************************
 *
 * 
 *
 */

