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
; PureBasic 'File' library
;
; 13/03/2005
;   -Doobrey-  Just preserved regs, LW aligned some stuff
;
;-------------------------------------------------------------------------
; 03/05/2001
;   Updated to use the PBAllocateMemory() new feature
;
; 25/01/2001
;   Fixed a bug ReadString()..
;
; 30/06/2000
;   Fixed a bug (Read/Write)
;
; 23/11/1999
;   Added WriteStringN()
;   Optimized WriteStringN() and WriteString()
;   Rewritten for PhxAss for optimal speed (Gain 84 bytes over Blitz2)
;
; 11/10/1999
;   Added RenameFile(), DeleteFile(), MakeDirectory()
;
; 05/10/1999
;   Finally changed the EOF() function, much better but slower.
;
; 13/07/1999
;   Changed a bit the WriteString routine
;
; 10/07/1999
;   Changed the ReadString function a little bit
;
; 14/06/1999
;   Added Long result for Word/Byte return
;
; 09/06/1999
;   FirstVersion
;   Optimized LOF() function    <- COOL.
;   Seems to work FULLY in the PBCompiler...
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

OFFSET_BEGINNING = -1
OFFSET_CURRENT   = 0

MODE_OLDFILE   = 1005
MODE_NEWFILE   = 1006
MODE_READWRITE = 1004

_ActFile   = 0
_ObjNum    =  _ActFile+4
_MemPtr    =  _ObjNum+4
_NumBuffer =  _MemPtr+4

;_GetPosition    =  _NumBuffer+4
;_Base_CloseFile =  _GetPosition+12
;_Base_Read      =  _Base_CloseFile+22

_GetPosition    =  l_GetPosition - LibBase
_Base_CloseFile =  l_CloseFile - LibBase
_Base_Read      =  l_Read - LibBase

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

 initlib "File", "File", "FreeFiles", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------

 name      "OpenFile", "(#File, Name$)"
 flags  LongResult
 amigalibs  _DosBase,  a6
 params     d0_l,  d1_l
 debugger   1

OpenFile_TEST:
  MOVEM.l   d2/a3,-(a7)
  JSR     _GetPosition(a5)
  MOVE.l   #MODE_READWRITE, d2
  JSR     _Open(a6)    ; (Name, AccessMode) d1/d2
  MOVE.l   d0, (a3)    ; Set *File
  MOVE.l   d0, (a5)    ;
  MOVEM.l   (a7)+,d2/a3
  RTS

  endfunc  1

;------------------------------------------------------------------------------------

 name      "ReadFile", "(#File, Name$)"
 flags  LongResult
 amigalibs  _DosBase,  a6
 params     d0_l,  d1_l
 debugger  2

ReadFile_TEST:
  MOVEM.l   d2/a3,-(a7)
  JSR     _GetPosition(a5)
  MOVE.l   #MODE_OLDFILE, d2
  JSR     _Open(a6)    ; (Name, AccessMode) d1/d2
  MOVE.l   d0, (a3)    ; Set *File
  MOVE.l   d0, (a5)   ;
  MOVEM.l   (a7)+,d2/a3
  RTS

  endfunc  2

;------------------------------------------------------------------------------------

 name      "CreateFile", "(#File, Name$)"
 flags  LongResult
 amigalibs  _DosBase,  a6
 params     d0_l,  d1_l
 debugger   3

CreateFile_TEST:
  MOVEM.l   d2/a3,-(a7)
  JSR     _GetPosition(a5)
  MOVE.l   #MODE_NEWFILE, d2
  JSR     _Open(a6)    ; (Name, AccessMode) d1/d2
  MOVE.l   d0, (a3)    ; Set *File
  MOVE.l   d0, (a5)    ;
  MOVEM.l   (a7)+,d2/a3
  RTS

  endfunc  3
;------------------------------------------------------------------------------------

 name      "CloseFile", "(#File)"
 flags  NoResult | InLine
 amigalibs  _DosBase,  a6
 params     d0_l
 debugger  4

CloseFile_TEST:
  I_JSR      _Base_CloseFile(a5)

  endfunc  4
;------------------------------------------------------------------------------------

 name      "FileSeek", "(Position)"
 flags  LongResult
 amigalibs  _DosBase,  a6
 params     d2_l
 debugger  5

FileSeek_TEST:
  MOVE.l   d3,-(a7)
  MOVE.l   (a5),d1
  MOVE.l   #OFFSET_BEGINNING, d3
  JSR     _Seek(a6)    ; (File, Position, Mode) d1/d2/d3
  MOVE.l   (a7)+,d3
  RTS
 
  endfunc   5

;------------------------------------------------------------------------------------
; Doobrey: WTF.. Just get the position and test it on file length ?
 name      "Eof", "()"
 flags      ByteResult
 amigalibs  _DosBase,  a6
 params
 debugger  6

Eof_TEST:
  MOVE.l   (a5),d1
  JSR     _FGetC(a6)
  TST.l    d0
  BGE     _EofEnd
  MOVEQ    #1,d0
  RTS

_EofEnd:
  MOVE.l   (a5),d1
  MOVE.l   d2,-(a7)
  MOVEQ    #-1,d2
  JSR     _UnGetC(a6)
  MOVE.l   (a7)+,d2
  MOVEQ    #0,d0
  RTS

  endfunc  6

;------------------------------------------------------------------------------------

 name      "Lof", "()"
 flags      LongResult
 amigalibs  _DosBase,  d3,  _ExecBase,  a6
 params
 debugger   7

Lof_TEST:
  MOVE.l    d2,-(a7)
  MOVE.l    #260,d0       ; Size of FileInfoBlock struct
  MOVEQ     #0,d1         ;
  JSR      _AllocVec(a6)  ; Alloc some mem...
;  JSR        40(a4)
  MOVE.l    d0,d2         ;
  EXG.l     a6,d3         ;
  MOVE.l    (a5),d1       ;
  JSR      _ExamineFH(a6) ; (d1/d1) - Get some infos on the file...
  MOVE.l    d2,a1         ;
  MOVE.l    124(a1),d2    ; Get the size ..
  EXG.l     a6,d3         ;
  JSR      _FreeVec(a6)   ; (a1) - Free the mem
  MOVE.l    d2,d0         ;
  MOVE.l    (a7)+,d2
  RTS

  endfunc   7

;------------------------------------------------------------------------------------

 name      "Loc", "()"
 flags      LongResult
 amigalibs  _DosBase,  a6
 params
 debugger   8

Loc_TEST:
  MOVEM.l d2-d3,-(a7)
  MOVE.l    (a5),d1
  MOVEQ     #0,d2
  MOVE.l    #OFFSET_CURRENT, d3
  JSR      _Seek(a6)    ; (File, Position, Mode) d1/d2/d3
  MOVEM.l (a7)+,d2-d3
  RTS

  endfunc   8
;------------------------------------------------------------------------------------

 name      "WriteString", "(String$)"
 flags  LongResult
 amigalibs  _DosBase,  a6
 params     d2_l
 debugger   9

WriteString_TEST:
  TST.l    d2
  BEQ     _WriteStringEnd
  MOVE.l   (a5), d1
  JMP     _FPuts(a6)    ; (File, String) d1/d2
_WriteStringEnd:
  RTS

  endfunc   9
;------------------------------------------------------------------------------------

 name      "WriteStringN", "(String$)"
 flags  NoResult
 amigalibs  _DosBase,  a6
 params     d2_l
 debugger   10

WriteStringN_TEST:
  MOVEM.l   d2-d3,-(a7)
  MOVEQ.l  #0,d3        ; for returning length
  TST.l    d2
  BEQ     _WriteStringNNext
  MOVE.l   (a5), d1
  JSR     _FPuts(a6)    ; (File, String) d1/d2
  MOVE.l   d0,d3
_WriteStringNNext:
  MOVE.l   (a5), d1
  MOVEQ    #10, d2
  JSR     _FPutC(a6)    ; (File, Char) d1/d2
  ADD.l    d3,d0        ; Get new write length
  MOVEM.l   (a7)+,d2-d3
  RTS

  endfunc  10
;------------------------------------------------------------------------------------

 name      "WriteLong", "(Long)"
 flags  LongResult  ;-- should return 4 or 0
 amigalibs  _DosBase,  a6
 params     d0_l
 debugger   11

WriteLong_TEST:
  MOVEM.l d2-d4,-(a7)
  MOVE.l    (a5), d1
  LEA.l    _NumBuffer(a5), a0
  MOVE.l    d0,(a0)
  MOVE.l    a0, d2
  MOVEQ     #4, d3
  MOVEQ     #1, d4
  JSR      _FWrite(a6)    ; (File, Buffer, BlockLength, NbBlock) d1/d2/d3/d4
  MOVEM.l  (a7)+,d2-d4
  RTS

  endfunc   11
;------------------------------------------------------------------------------------

 name      "WriteWord", "(Word)"
 flags  LongResult  ;-- should return 2 or 0
 amigalibs  _DosBase,  a6
 params     d0_w
 debugger   12

WriteWord_TEST:
  MOVEM.l d2-d4,-(a7)
  MOVE.l   (a5), d1
  LEA.l   _NumBuffer(a5), a0
  MOVE.w   d0,(a0)
  MOVE.l   a0, d2
  MOVEQ    #2, d3
  MOVEQ    #1, d4
  JSR     _FWrite(a6)    ; (File, Buffer, BlockLength, NbBlock) d1/d2/d3/d4
  MOVEM.l  (a7)+,d2-d4
  RTS
  endfunc  12
;------------------------------------------------------------------------------------

 name      "WriteByte", "(Byte)"
 flags  LongResult  ;-- should return 1 or 0
 amigalibs  _DosBase,  a6
 params     d2_b
 debugger   13

WriteByte_TEST:

  MOVE.l   d2,-(a7)
  MOVE.l   (a5), d1
  MOVEQ    #10, d2
  JSR     _FPutC(a6)    ; (File, Char) d1/d2
  MOVE.l  (a7)+,d2
  RTS

;-- The old way...
  ;MOVE.l   (a5), d1
  ;LEA.l   _NumBuffer(a5), a0
  ;MOVE.b   d0,(a0)
  ;MOVE.l   a0, d2
  ;MOVEQ    #1, d3
  ;MOVEQ    #1, d4
  ;JMP     _FWrite(a6)    ; (File, Buffer, BlockLength, NbBlock) d1/d2/d3/d4

  endfunc  13

;------------------------------------------------------------------------------------
 name      "ReadString", "()"
 flags      StringResult
 amigalibs  _DosBase,  a6
 params
 debugger   14

ReadString_TEST:
  MOVEM.l  d2-d3,-(a7)
  MOVE.l   (a5), d1
  MOVE.l   a3,d2
  MOVE.l   #4900, d3
  JSR     _FGets(a6)    ; (File, String) d1/d2/d3
  TST.l    d0
  BEQ     _ReadString_End
  TST.b    (a3)
  BEQ     _ReadString_End
_ReadString_Loop:
  MOVE.b   (a3)+,d0
  BNE     _ReadString_Loop
  SUBQ.l   #1,a3
  CMP.b    #13,(a3)
  BNE     _ReadString_End
  CLR.b    -(a3)
_ReadString_End
  MOVEM.l  (a7)+,d2-d3
  RTS

  endfunc  14

;------------------------------------------------------------------------------------
 name      "ReadLong", "()"
 flags       LongResult
 amigalibs  _DosBase,  a6
 params
 debugger   15

ReadLong_TEST:
  MOVEM.l d2-d5,-(a7)
  MOVEQ     #4, d3
  JSR      _Base_Read(a5) ; trashes d2,d4,d5
  MOVE.l    (a0), d0
  MOVEM.l    (a7)+,d2-d5
  RTS

  endfunc   15

;------------------------------------------------------------------------------------
 name      "ReadWord", "()"
 flags
 amigalibs  _DosBase,  a6
 params
 debugger   16

ReadWord_TEST:
  MOVEM.l d2-d5,-(a7)
  MOVEQ     #2, d3
  JSR      _Base_Read(a5) ; trashes d2,d4,d5
  MOVE.w    (a0), d0
  EXT.l     d0
  MOVEM.l    (a7)+,d2-d5
  RTS

  endfunc   16
;------------------------------------------------------------------------------------

 name      "ReadByte", "()"
 flags      ByteResult
 amigalibs  _DosBase,  a6
 params
 debugger   17


ReadByte_TEST:
  MOVEM.l d2-d5,-(a7)
  MOVEQ     #1, d3
  JSR      _Base_Read(a5) ; trashes d2,d4,d5
  MOVE.b    (a0), d0
  EXT.w     d0
  EXT.l     d0
  MOVEM.l    (a7)+,d2-d5
  RTS

  endfunc   17
;------------------------------------------------------------------------------------

 name      "UseFile", "(#File)"
 flags
 amigalibs
 params     d0_l
 debugger   18

UseFile_TEST:
  MOVE.l   a3,-(a7)
  JSR     _GetPosition(a5)      ; Input d0, Result a1 - a3 store the current pos.
  MOVE.l   a1, d0               ; Fast CMP.l #0, a1
  BEQ     _EndUseFile           ; If 'a1' is NULL
  MOVE.l   a1, (a5)+            ; *File
  MOVE.l   a1, d0               ; For PB_File return
_EndUseFile:
  MOVE.l   (a7)+,a3
  RTS

  endfunc  18

;------------------------------------------------------------------------------------
 name      "InitFile", "(NumMaxFiles)"
 flags      LongResult
 amigalibs
 params     d0_l
 debugger   19

InitFile_TEST:
  ADDQ.l   #1, d0              ; Needed to have the correct number
  MOVE.l   d0, _ObjNum(a5)     ; Set the Objects Numbers
  LSL.l    #2, d0              ; d0*4
  PB_AllocMem a0               ; (d0) - a0 is changed
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  RTS

  endfunc  19

;------------------------------------------------------------------------------------
 name      "FreeFiles", "()"
 flags  NoResult
 amigalibs  _DosBase,  a6
 params
 debugger   20

FreeFile_TEST:
  MOVE.l   d3,-(a7)
  TST.l   _MemPtr(a5)
  BEQ     _EndFreeFile
  MOVE.l  _ObjNum(a5), d4    ; Num Objects
  BEQ     _EndFreeFile
_LoopFreeFiles:              ; Close all the opened Files
  SUBQ     #1, d4
  MOVE.l   d4, d0
  JSR     _Base_CloseFile(a5)
  TST.l    d4
  BNE     _LoopFreeFiles      ; Repeat:Until d4 = d0

_EndFreeFile:
  MOVE.l   (a7)+,d3
  RTS

  endfunc  20

;------------------------------------------------------------------------------------
 name      "ReadData", "(*Buffer, Length)"
 flags      LongResult
 amigalibs _DosBase,  a6
 params     d2_l, d3_l
 debugger   24

ReadMemory:
  MOVE.l    (a5), d1   ; Get the current file
  JMP      _Read(a6)   ; (File, Buffer, Length) - d1/d2/d3

  endfunc   24

;------------------------------------------------------------------------------------
 name      "WriteData", "(*Buffer, Length)"
 flags      LongResult
 amigalibs _DosBase,  a6
 params     d2_l, d3_l
 debugger   25

WriteMemory:
  MOVE.l    (a5), d1   ; Get the current file
  JMP      _Write(a6)  ; (File, Buffer, Length) - d1/d2/d3

  endfunc   25
;------------------------------------------------------------------------------------

 base
LibBase:
  Dc.l 0 ; *File
  Dc.l 0 ; ObjNum
  Dc.l 0 ; MemPtr
  Dc.l 0 ; NumBuffer

;-----------------------------------------------------

; GetPosition()
l_GetPosition:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #2, d0
  ADD.l    d0, a3
  MOVE.l   (a3), a1
  RTS

  CNOP 0,4

;-----------------------------------------------------
; CloseFile()
l_CloseFile:
  MOVE.l   a3,-(a7)
  JSR     _GetPosition(a5)
  MOVE.l   a1, d0
  BEQ      CloseFile_End
  MOVE.l   a1,d1
  JSR     _Close(a6)    ; (FileHandle) d1
  CLR.l    (a3)
CloseFile_End:
  MOVE.l   (a7)+,a3
  RTS

  CNOP 0,4

;-----------------------------------------------------
; Trashes d2,d4,d5
; DosBase must be in a6
; ReadByte(), ReadWord(), ReadLong()
;
l_Read:
  MOVE.l   (a5), d1
  LEA.l   _NumBuffer(a5), a0
  MOVE.l   a0, d5
  MOVE.l   a0, d2
  MOVEQ.l  #1, d4
  JSR     _FRead(a6)    ; (File, Buffer, BlockLength, BlockNb) d1/d2/d3/d4
  MOVE.l   d5, a0
  RTS

Even

 endlib
;------------------------------------------------------------------------------------
 startdebugger

 enddebugger

