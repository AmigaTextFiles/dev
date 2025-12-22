
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Hexy (Binary file viewer/editor for the Amiga.)
 * Version   : 1.6
 * File      : Work:Source/!WIP/HisoftProjects/Hexy/Hexy_fileio.c
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

Prototype BOOL ReadFile(UBYTE *FileName, struct VCtrl *VC);
Prototype UBYTE *ObtainInFile( void );
Prototype UBYTE *ObtainOutFile( void );
Prototype void SaveSplit(struct VCtrl *TmpVC);
Prototype void SaveToNewLocation(struct VCtrl *TmpVC);

BOOL ReadFile(UBYTE *FileName, struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Load a file into a VC structure 
   *
   */

  BPTR InLock = NULL, InFile = NULL;
  BOOL lresult = TRUE;

  Edit_End();

  FreeVC(TmpVC);  /* Deallocate any previously loaded file */

  if (InLock = Lock(FileName, SHARED_LOCK))
  {
    if (TmpVC->VC_FIB = (struct FileInfoBlock *) AllocDosObject(DOS_FIB, NULL))
    {
      if (Examine(InLock, TmpVC->VC_FIB))
      {
        strcpy( (UBYTE *) &CurFileLoaded, TmpVC->VC_FIB->fib_FileName);

        TmpVC->VC_FileLength = TmpVC->VC_FIB->fib_Size;
        TmpVC->VC_CurrentPoint = NULL;    /* Start of file */
        TmpVC->VC_InitialYPos = 24-10;
        TmpVC->VC_YAmount = YLINES;
        TmpVC->VC_XPos = 14-4;

        if (TmpVC->VC_FIB->fib_DirEntryType < 0)
        {
          if (TmpVC->VC_FileLength)
          {
            if (TmpVC->VC_FileAddress = (APTR) AllocVec(TmpVC->VC_FileLength, MEMF_ANY))
            {
              if (InFile = Open(FileName, MODE_OLDFILE))
              {
                stream[0] = (ULONG) &(TmpVC->VC_FIB->fib_FileName);
                stream[1] = (ULONG) TmpVC->VC_FIB->fib_Size;
                PrintStatus("Loading file: %.35s (%lu bytes)", &stream);

                if (Read(InFile, TmpVC->VC_FileAddress, TmpVC->VC_FileLength) == TmpVC->VC_FileLength)
                {
                  UnpackFile(TmpVC);
                  CheckForViruses(TmpVC);
                  SetVDragBar(TmpVC);
                  UpdateView(TmpVC, NULL);
                  DisplayFileInfos(&VC);
                }
                else
                {
                  DoError(FALSE); lresult = FALSE;
                }
                Close(InFile);
              }
              else
              {
                DoError(FALSE); lresult = FALSE;
              }
            }
            else
            {
              DoError(FALSE); lresult = FALSE;
            }
          }
          else
          {
            /* Empty file */
          }
        }
        else
        {
          DoError(FALSE); lresult = FALSE;
        }
      }
      else
      {
        DoError(FALSE); lresult = FALSE;
      }
      /* FreeDosObject(DOS_FIB, VC_FIB); */
    }
    else
    {
      DoError(FALSE); lresult = FALSE;
    }
    UnLock(InLock);
  }
  else
  {
    DoError(FALSE); lresult = FALSE;
  }

  if (!lresult) FreeVC(TmpVC);

  return lresult;
}

UBYTE FullInPath[1024+4];

UBYTE *ObtainInFile( void )
{
  /*************************************************
   *
   * Open requester and load a file 
   *
   */

  BOOL res = AslRequestTags(FR, ASLFR_Window, MAINWnd,
                  ASLFR_TitleText, "Select input file...",
                  ASLFR_PositiveText, "Load",
                  TAG_DONE);
  if (res)
  {
    if (FR->fr_File[0] == 0)
    {
      PrintStatus("No filename was given!", &stream);
      return NULL;
    }
    strcpy(FullInPath, FR->fr_Drawer);
    if (AddPart( (UBYTE *) &FullInPath, FR->fr_File, 1024))
    {
      return FullInPath;
    }
    else
    {
      PrintStatus("Unable to load selected file: Path is too long!", NULL);
    }
  }
  else
  {
    PrintStatus("Requester aborted!", NULL);
  }
  return NULL;
}

UBYTE FullOutPath[1024+4];

UBYTE *ObtainOutFile( void )  /* Add FR param */
{
  /*************************************************
   *
   * Open a file requeter that request an output file
   *
   */

  UBYTE *Result = (UBYTE *) &FullOutPath;

  BOOL res = AslRequestTags(FR, ASLFR_Window, MAINWnd,
                  ASLFR_Flags1, FRF_DOSAVEMODE,
                  ASLFR_TitleText, "Select output file...",
                  ASLFR_PositiveText, "Save",
                  TAG_DONE);
  if (res)
  {
    if (FR->fr_File[0] == 0)
    {
      PrintStatus("No filename was given!", &stream);
      return NULL;
    }
    strcpy(FullOutPath, FR->fr_Drawer);
    if (AddPart( (UBYTE *) &FullOutPath, FR->fr_File, 1024))
    {
      BPTR InLock;
      if (InLock = Lock(FullOutPath, SHARED_LOCK))
      {
        struct FileInfoBlock *FIB;
        if (FIB = (struct FileInfoBlock *) AllocDosObject(DOS_FIB, NULL))
        {
          if (Examine(InLock, FIB))
          {
            if (FIB->fib_Protection & FIBF_DELETE)
            {
              struct EasyStruct ProtectedES =
              {
                sizeof(struct EasyStruct),
                NULL,
                "Hexy info...",
                "File already exists and is protected from deletetion\nOverwrite it anyway?",
                "Yes|No"
              };
              if (EasyRequestArgs(MAINWnd, &ProtectedES, NULL, &stream))
              {
                ULONG PFlags = FIB->fib_Protection & ~FIBF_DELETE;
                SetProtection(FullOutPath, PFlags);
                PrintStatus("File overwritten.", NULL);
              }
              else
              {
                Result = (UBYTE *) NULL;
                PrintStatus("File was not overwritten.", NULL);
              }
            }
          }
          else DoError(FALSE);
          FreeDosObject(DOS_FIB, FIB);
        }
        else DoError(FALSE);
        UnLock(InLock);
      }
      else DoError(FALSE);

      return Result;
    }
    else PrintStatus("Unable to save file: Path is too long!", NULL);
  }
  else PrintStatus("Requester aborted!", NULL);

  return NULL;
}

ULONG OutLen = NULL;

UWORD putchproc[] = { 0x16c0, 0x4e75 };

void SaveSplit(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Perform a split save 
   *
   */

  UBYTE *OutFileName;

  if (!ValidFile(TmpVC)) return;

  stream[0] = (ULONG) RT_Window;
  stream[1] = (ULONG) MAINWnd;
  stream[2] = (ULONG) RTGL_Min;
  stream[3] = (ULONG) 1;
  stream[4] = (ULONG) RTGL_Max;
  stream[5] = (ULONG) TmpVC->VC_FileLength;
  stream[6] = (ULONG) RTGL_TextFmt;
  stream[7] = (ULONG) "Enter save chunk length...";
  stream[8] = (ULONG) RTGL_Flags;
  stream[9] = (ULONG) GLREQF_CENTERTEXT;
  stream[10] = (ULONG) RT_LockWindow;
  stream[11] = (ULONG) TRUE;
  stream[12] = (ULONG) TAG_DONE;

  OutLen = 0; /* 1024*10; */ /* This is temp */

  if ( rtGetLongA( (ULONG *) &OutLen, "Split save...", RTFR, (struct TagItem *) &stream) )
  {
    if (OutFileName = ObtainOutFile())
    {
      UBYTE TempPathBuf[1024+4];
      ULONG LoopCnt = NULL, BytesLeft = TmpVC->VC_FileLength;
      UBYTE *SaveAddress = TmpVC->VC_FileAddress;

      BPTR OutFile;

      if (TmpVC->VC_FileLength < OutLen) OutLen = TmpVC->VC_FileLength;
      do
      {
        stream[0] = (ULONG) OutFileName;
        stream[1] = (ULONG) LoopCnt++;
        RawDoFmt("%.1000s.%04lu", &stream, (void *) &putchproc, &TempPathBuf);

        stream[0] = (ULONG) FilePart(TempPathBuf);
        PrintStatus("Saving '%s'... (LMB = Abort)", &stream);
        if (OutFile = Open(TempPathBuf, MODE_NEWFILE))
        {
          if (Write(OutFile, SaveAddress, OutLen) == OutLen)
          {
            SaveAddress += OutLen; Close(OutFile);
          } else DoError(FALSE);
        }
        BytesLeft -= OutLen;
        if (BytesLeft < OutLen) OutLen = BytesLeft;

        if (LMBActive()) break;
      }
      while(BytesLeft > 0);

      stream[0] = (ULONG) LoopCnt;
      PrintStatus("Saved %lu chunks.", &stream);
    }
  }
}

void SaveToNewLocation(struct VCtrl *TmpVC)
{
  /*************************************************
   *
   * Save file to another location 
   *
   */

  UBYTE *OutFileName;

  if (!ValidFile(TmpVC)) return;
  if (OutFileName = ObtainOutFile())
  {
    BPTR OutFile;

    if (OutFile = Open(OutFileName, MODE_NEWFILE))
    {
      if (Write(OutFile, TmpVC->VC_FileAddress, TmpVC->VC_FileLength) != TmpVC->VC_FileLength)
      {
        DoError(FALSE);
      }
      else
      {
        PrintStatus("File was saved OK.", &stream);
      }
      Close(OutFile);

      SetProtection(OutFileName, TmpVC->VC_FIB->fib_Protection);
      SetComment(OutFileName, (UBYTE *) &TmpVC->VC_FIB->fib_Comment);

    }
    else DoError(FALSE);
  }
}

/*************************************************
 *
 * 
 *
 */


