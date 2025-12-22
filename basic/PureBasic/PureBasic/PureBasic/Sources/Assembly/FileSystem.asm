; --------------------------------------------------------------------------------------
;
; This source file is part of PureBasic
; For the latest info, see http://www.purebasic.com/
; 
; Copyright (c) 1998-2006 Fantaisie Software
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU Lesser General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
; Place - Suite 330, Boston, MA 02111-1307, USA, or go to
; http://www.gnu.org/copyleft/lesser.txt.
;
; Note: As PureBasic is a compiler, the programs created with PureBasic are not
; covered by the LGPL license, but are fully free, license free and royality free
; software.
;
; --------------------------------------------------------------------------------------
;
; PureBasic 'FileSystem' library
;
; 18/03/2005
;   -Doobrey-
;     Added DirectoryEntrySize(),DirectoryEntryAttributes()
;     Added IsDirectory(), IsFile()
;
; 14/03/2005
;   -Doobrey-
;   Delete(),Rename() inlined..
;   DirectoryEntryName().. small optimise.. move.l a3,a2 ..<blah blah>... move.l a2,d0, now just move.l a3,d0 .
;
;   FileSize() .. saved regs d2-d4.
;   ExamineDirectory() pattern$ not used !! <!------------- NEEDS FIX
;   FreeFileSystems() & NextDirectoryEntry() saved reg d2
;
;--------------------------------------------------------------------------------------
; 14/05/2001
;   First version
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

OFFSET_BEGINNING = -1
OFFSET_CURRENT   = 0

MODE_OLDFILE   = 1005
MODE_NEWFILE   = 1006
MODE_READWRITE = 1004

_CurrentLock = 0
_FIB         = _CurrentLock+4

fib_Protection=116
fib_Size=124
fib_DirEntryType=4


; Init the library stuff
; ----------------------
;
; In the order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Name of the 'end function' automatically called
;   + Priority of the 'end function' (high number say it will be called sooner)
;   + Version of the library
;   + Revision of the library (ie: 0.12 here)
;

 initlib "FileSystem", "FileSystem", "FreeFileSystems", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------

 name      "ExamineDirectory", "(DirectoryName$, Pattern$)"
 flags      LongResult
 amigalibs  _DosBase,  a6
 params     d2_l,  d3_l
 debugger   1

   MOVE.l   d2,-(a7)     ;
   BSR      ED_CloseLock ; If a previously opened directory wasn't closed, close it now
   MOVE.l   d2,d1
   MOVEQ.l  #-2,d2       ; AccessMode
   JSR     _Lock(a6)     ; (Name, AccessMode) - d1/d2
   TST.l    d0
   BEQ      ED_End
   MOVE.l   d0,(a5)      ; Store the Lock() ptr to global bank
   MOVE.l  _FIB(a5),d0
   BNE      ED_SkipAlloc
   MOVEQ.l  #2,d1               ; DOS_FIB id
   MOVEQ.l  #0,d2               ; TagList
   JSR     _AllocDosObject(a6)  ; Allocate the DOS FIB buffer as it MUST be long aligned..
   MOVE.l   d0,_FIB(a5)
ED_SkipAlloc
   MOVE.l   (a5),d1      ; Get the Lock
   MOVE.l  _FIB(a5),d2   ; Get the FileInfoBlock memory address
   JSR     _Examine(a6)
   TST.l    d0
   BEQ      ED_CloseLock
   MOVE.l   (a7)+,d2   ; Restore
   MOVE.l   (a5),d0
   RTS                   ; returns the lock value if success..

ED_End:
   MOVE.l   (a7)+,d2  ; Restore
   MOVEQ.l  #0,d0
   RTS

ED_CloseLock:             ; Safe close lock routine..
   MOVE.l   (a5),d1
   BEQ      ED_NoLock
   CLR.l    (a5)
   JMP     _UnLock(a6)    ; Unlock returns from the BSR

ED_NoLock:
   MOVEQ.l  #0,d0
   RTS

 endfunc    1

;------------------------------------------------------------------------------------------

 name      "NextDirectoryEntry", "()"
 flags      LongResult
 amigalibs  _DosBase,  a6
 params
 debugger   2
   MOVE.l d2,-(a7)       ; Save
   MOVE.l   (a5),d1      ; Lock
   MOVE.l  _FIB(a5),d2   ; Get the FileInfoBlock memory address
   JSR     _ExNext(a6)   ; (Lock, FileInfoBlock) - d1/d2
   MOVE.l   (a7)+,d2     ; Restore
   TST.l    d0
   BEQ      NDE_End
   MOVE.l  _FIB(a5),a0   ; Get the fib_DirEntryType address
   MOVE.l   4(a0),d0
   BLT      NDE_NotADir
   MOVEQ.l  #2,d0
   RTS
NDE_NotADir:
   MOVEQ.l  #1,d0
   RTS                   ; returns the lock value if success..

NDE_End:
   MOVE.l   (a5),d1
   JSR     _UnLock(a6)
   CLR.l    (a5)
   MOVEQ.l  #0,d0
   RTS

 endfunc    2
;------------------------------------------------------------------------------------------

 name      "FreeFileSystems", "()"
 flags  NoResult
 amigalibs  _DosBase,  a6
 params
 debugger   3

   MOVE.l   (a5),d1
   BEQ      FFS_NoLock
   CLR.l    (a5)
   JSR     _UnLock(a6)
FFS_NoLock:
   MOVE.l d2,-(a7)   ; Save
   MOVE.l  _FIB(a5),d2
   BEQ      FFS_NoFIB
   MOVEQ.l  #2,d1
   JSR     _FreeDosObject(a6)
FFS_NoFIB:
   MOVE.l (a7)+,d2   ; Restore
   RTS

 endfunc    3

;------------------------------------------------------------------------------------------

 name      "DirectoryEntryName", "()"
 flags      StringResult
 amigalibs  _DosBase,  a6
 params
 debugger   4

   MOVE.l  _FIB(a5),a0
   LEA  8(a0),a0
DEN_CopyLoop:
   MOVE.b   (a0)+,(a3)+
   BNE      DEN_CopyLoop
   SUBQ.l   #1,a3
   RTS

 endfunc    4
;------------------------------------------------------------------------------------------

 name      "FileSize", "(FileName.s)"
 flags      LongResult | NoBase
 amigalibs  _DosBase,  a6
 params     d1_l
 debugger   5

  MOVEM.l d2-d4,-(a7)      ;
  MOVE.l    #MODE_OLDFILE, d2
  JSR      _Open(a6)       ; (Name, AccessMode) d1/d2
  TST.l     d0
  BEQ       FS_End

  MOVE.l    d0,d3
  MOVEQ.l   #2,d1               ; DOS_FIB id
  MOVEQ.l   #0,d2               ; TagList
  JSR      _AllocDosObject(a6)  ; Allocate the DOS FIB buffer as it MUST be long aligned..
  MOVE.l    d0,d2         ;
  MOVE.l    d3,d1         ;
  JSR      _ExamineFH(a6) ; (d1/d2) - Get some infos on the file...
  MOVE.l    d2,a1         ;
  MOVE.l    124(a1),d4    ; Get the size
  MOVEQ.l   #2,d1
  JSR      _FreeDosObject(a6) ; (ObjectType, *Ptr) - d1/d2
  MOVE.l    d3,d1
  JSR      _Close(a6)     ; (*FileHandle) - d1
  MOVE.l    d4,d0         ; Restore the file size..
  MOVEM.l (a7)+,d2-d4   ; Restore the regs.
  RTS

FS_End:
  MOVEM.l (a7)+,d2-d4   ; Restore the regs.
  MOVEQ.l   #-1,d0
  RTS

  endfunc   5

;------------------------------------------------------------------------------------------

 name      "RenameFile", "()"
 flags      LongResult | NoBase | InLine
 amigalibs  _DosBase,  a6
 params     d1_l,  d2_l
 debugger   21

RenameFile
  I_JSR     _Rename(a6)

 endfunc   21

;------------------------------------------------------------------------------------------

 name      "DeleteFile", "()"
 flags      LongResult | NoBase | InLine
 amigalibs  _DosBase,  a6
 params     d1_l
 debugger   22

DeleteFile:
  I_JSR     _DeleteFile(a6)

  endfunc   22

;------------------------------------------------------------------------------------------

 name      "MakeDirectory", "()"
 flags      LongResult | NoBase
 amigalibs  _DosBase,  a6
 params     d1_l
 debugger   23

MakeDirectory:
  JSR      _CreateDir(a6)
  TST.l     d0
  BEQ       MakeDirectory_End
  MOVE.l    d0,d1
  JMP      _UnLock(a6)
MakeDirectory_End:
  RTS

  endfunc   23

;------------------------------------------------------------------------------------------

 name      "DirectoryEntryAttributes", "()"
 flags      LongResult | InLine
 amigalibs  _DosBase,  a6
 params
 debugger   24
   MOVE.l  _FIB(a5),a0
   MOVE.l fib_Protection(a0),d0
   I_RTS
   
 endfunc    24

;------------------------------------------------------------------------------------------

 name      "DirectoryEntrySize", "()"
 flags      LongResult | InLine
 amigalibs  _DosBase,  a6
 params
 debugger   25
   MOVE.l  _FIB(a5),a0
   MOVE.l fib_Size(a0),d0
   I_RTS
   
 endfunc    25
;------------------------------------------------------------------------------------------

 name      "IsDirectory", "(Name$)"
 flags      LongResult
 amigalibs  _DosBase,  a6
 params d1_l
 debugger   26

    ;- Get a lock on it..
     MOVEM.l  d2-d4,-(a7)
     MOVEQ.l  #0,d3 ;-- our return value
     MOVEQ.l  #-2,d2
     JSR _Lock(a6)    ;d1/d2 name/mode
     MOVE.l d0,d4
     BEQ  _EndIsDir

     ;-- Alloc the FIB
     MOVEQ.l  #2,d1               ; DOS_FIB id
     MOVEQ.l  #0,d2               ; TagList
     JSR     _AllocDosObject(a6)  ; Allocate the DOS FIB buffer as it MUST be long aligned..
     MOVE.l   d0,d2
     BEQ  _ReleaseDirLock     ;- If failed..

     JSR _Examine(a6) ;d1/d2 lock/FIB
     TST.l D0
     BEQ  _FreeDirFIB
     MOVEA.l d2,a0
     MOVE.l fib_DirEntryType(a0),d3 

_FreeDirFIB:
     MOVEQ.l  #2,d1
     JSR     _FreeDosObject(a6)

_ReleaseDirLock:
    MOVE.l d4,d1
    JSR _UnLock(a6)
_EndIsDir: 
    MOVE.l  d3,d0
    MOVEM.l (a7)+,d2-d4
    RTS

 endfunc    26

;------------------------------------------------------------------------------------------

 name      "IsFile", "(Name$)"
 flags      LongResult
 amigalibs  _DosBase,  a6
 params d1_l
 debugger   27

    ;- Get a lock on it..
     MOVEM.l  d2-d4,-(a7)
     MOVEQ.l  #0,d3 ;-- our return value
     MOVEQ.l  #-2,d2
     JSR _Lock(a6)    ;d1/d2 name/mode
     MOVE.l d0,d4
     BEQ  _EndIsFile

     ;-- Alloc the FIB
     MOVEQ.l  #2,d1               ; DOS_FIB id
     MOVEQ.l  #0,d2               ; TagList
     JSR     _AllocDosObject(a6)  ; Allocate the DOS FIB buffer as it MUST be long aligned..
     MOVE.l   d0,d2
     BEQ  _ReleaseFileLock      ;- If failed..

     JSR _Examine(a6) ;d1/d2 lock/FIB
     TST.l D0
     BEQ  _FreeFileFIB
     MOVEA.l d2,a0
     TST.l fib_DirEntryType(a0)
     BGE  _FreeFileFIB
     MOVEQ  #1,d3   ;-- OK, it`s a file :)
_FreeFileFIB:
     MOVEQ.l  #2,d1
     JSR     _FreeDosObject(a6)

_ReleaseFileLock:
    MOVE.l d4,d1
    JSR _UnLock(a6)
_EndIsFile: 
    MOVE.l  d3,d0
    MOVEM.l (a7)+,d2-d4
    RTS

 endfunc    27
;------------------------------------------------------------------------------------------
 base
  Dc.l    0  ; Lock
  Dc.l    0  ; FIB
 endlib
;------------------------------------------------------------------------------------------

 startdebugger
 enddebugger

