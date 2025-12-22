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
; PureBasic 'MISC' library
; Inlined the Peek/Poke routines
;
; -Note to self, check GetPathPart against lib on WinUAE !!
;
; 18/03/2005
;   Made the Peek/Poke stuff "inline-able", added API style reg saving.
;   Also, added the NoResult flag for funcs that dont return a val.
;   Added  GetExtensionPart(),Red(),Green(),Blue(),RGB()
;
; 03/05/2001
;   Added the QuickHelp stuffs
;
; 04/09/2000
;   Added 4 commands (MouseButtons(), GetCliArgs(), NumberCliArgs(), FreeMisc())
;
; 14/12/1999
;   Fixed a bug in 'PeekS' function
;
; 23/11/1999
;   Adapted to PhxAss for maximum performances
;
; 22/11/1999
;   Added the Poke/Peek series...
;
; 16/07/1999
;   Added RunProgram(), GetFilePart(), GetPathPart()
;
; 13/07/1999
;   Fixed lot of enforcer hits
;
; 07/07/1999
;   Changed to support the new resident (argument  d0_w..)
;
; 14/05/1999
;   Added PrintF()
;
; 11/05/1999
;   Convertion finished
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

TAG_USER   = 1 << 31

SYS_Dummy  = TAG_USER + 32

SYS_Input  = SYS_Dummy + 1
SYS_Output = SYS_Dummy + 2
SYS_Asynch = SYS_Dummy + 3

NP_Dummy = TAG_USER + 1000

NP_Error     = NP_Dummy + 8
NP_StackSize = NP_Dummy + 11


; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Version of the library
;   + Priority of the library
;   + Revision of the library (ie: 1.2 here)
;

 initlib "Misc", "Misc", "FreeMisc", 0, 1, 2

;
; Now do the functions...
;
;---------------------------------------------------------------------------------------

 name      "MouseWait", "()"
 flags      NoBase | NoResult
 amigalibs _GraphicsBase,  a6
 params
 debugger   1

_MouseWait:
_Loop:
  MOVE.b    $BFE001, d2 ; Get the Joy Fire State
  JSR      _WaitTOF(a6) ; WaitTOF()
  BTST      #6, d2      ; Test if it's the Fire 0 (Mouse Port)
  BNE      _Loop        ; Loop
  RTS

 endfunc    1

;---------------------------------------------------------------------------------------

 name      "ProgramPriority", "(Priority)"
 flags      LongResult | NoBase
 amigalibs  _ExecBase,  a6
 params     d2_w
 debugger   2

_ProgramPriority:
  SUB.l     a1, a1         ; NULL Value
  JSR      _FindTask(a6)   ; (*TaskName) - a1
  MOVE.l    d0, a1
  MOVE.w    d2, d0
  JMP      _SetTaskPri(a6) ; (a1/d0)

 endfunc    2

;---------------------------------------------------------------------------------------

 name      "VWait", "()"
 flags      InLine | NoBase | NoResult
 amigalibs _GraphicsBase,  a6
 params
 debugger   3

_VWait:
  I_JSR      _WaitTOF(a6) ; WaitTOF()

 endfunc    3

;---------------------------------------------------------------------------------------

 name      "Delay", "(TimeToWait)"
 flags  InLine | NoBase | NoResult
 amigalibs _DosBase,  a6
 params     d1_l
 debugger   4

_PBDelay:
  I_JSR      _Delay(a6)

 endfunc    4

;---------------------------------------------------------------------------------------

 name      "PrintN", "(Text$)"
 flags      NoBase | NoResult
 amigalibs _DosBase,  a6
 params     d1_l
 debugger   5

_PrintN:
  MOVE.l   d2,-(a7)
  JSR     _PutStr(a6)    ; (d1)
  LEA.l    NP_Buffer(pc), a0
  MOVE.l   a0, d1
  MOVEQ    #1, d2
  JSR     _WriteChars(a6) ; (Buffer, Length) - d1/d2
  JSR     _Output(a6)
  MOVE.l   (a7)+,d2
  MOVE.l   d0,d1
  JMP     _Flush(a6)      ;
  
NP_Buffer:
  Dc.b 10,0

 endfunc   5
;---------------------------------------------------------------------------------------


 name      "PrintNumber", "(Number)"
 flags      NoBase | NoResult
 amigalibs _DosBase,  a6
 params     d0_l
 debugger   6

_PrintNum:
  MOVE.l   d2,-(a7)
  LEA.l    PNum_Buffer(pc), a0
  MOVE.l   a0, d1
  LEA.l    PNum_NumBuffer(pc), a0
  MOVE.l   d0, (a0)
  MOVE.l   a0, d2
  JSR     _VPrintf(a6)    ; (d1/d2)
  JSR     _Output(a6)
  MOVE.l   (a7)+,d2
  MOVE.l   d0,d1
  JMP     _Flush(a6)      ;

PNum_Buffer:
  Dc.b "%ld",0

  CNOP 0,4
PNum_NumBuffer:
  Dc.l 0,0

 endfunc   6
;---------------------------------------------------------------------------------------


 name      "Print", "(Text$)"
 flags      NoBase | NoResult
 amigalibs _DosBase,  a6
 params     d1_l
 debugger   7

_Print:
  MOVE.l  d2,-(a7)
  MOVEQ     #0,d2
  JSR      _VPrintf(a6)    ; (d1/d2)
  JSR      _Output(a6)
  MOVE.l    d0,d1
  MOVE.l    (a7)+,d2
  JMP      _Flush(a6)      ;

 endfunc    7
;---------------------------------------------------------------------------------------


 name      "RunProgram", "(Path$, CommandLine$, ASynchronous, Stack)"
 flags      NoBase | LongResult
 amigalibs _DosBase,  a6
 params     d1_l,  d5_l,  d0_w,  d2_l
 debugger   8

_RunProgram:
  MOVEM.l  d2-d4,-(a7)   ;
  LEA.l   _RunProgramTags(pc),a0
  MOVE.w   d0,6(a0)
  MOVE.l   d2,12(a0)

  MOVEQ    #-2,d2
  JSR     _Lock(a6)    ; (DirectoryName$, Mode) - d1/d2
  TST.l    d0
  BEQ     _RunProgramEnd

  MOVE.l   d0,d3       ; Store *Lock
  MOVE.l   d0,d1
  JSR     _CurrentDir(a6)
  TST.l    d0
  BEQ     _RunProgramEnd2
  MOVE.l   d0,d4       ; Store *OldCurrentDir

  LEA.l   _RunProgramTags(pc),a0
  MOVE.l   a0,d2
  MOVE.l   d5,d1
  JSR     _SystemTagList(a6) ; - (Command$, *TagList) - d1/d2

  MOVE.l   d4,d1
  JSR     _CurrentDir(a6)
_RunProgramEnd2:
  MOVE.l   d3,d1
  MOVEM.l  (a7)+,d2-d4
  JMP     _UnLock(a6)

_RunProgramEnd:
  RTS

  CNOP 0,4

_RunProgramTags:
  Dc.l SYS_Asynch   , 0
  Dc.l NP_StackSize , 0
  Dc.l NP_Error     , 0
  Dc.l SYS_Input    , 0
  Dc.l SYS_Output   , 0
  Dc.l 0,0

  endfunc  8

;---------------------------------------------------------------------------------------

 name      "GetFilePart", "(FileName$)"
 flags      StringResult | NoBase
 amigalibs _DosBase,  a6
 params     d1_l
 debugger   9

_GetFilePart:
  TST.l     d1
  BEQ      _GetFileNameEnd
  JSR      _FilePart(a6)
  MOVE.l    d0,a0
_GetFileNameLoop:
  MOVE.b    (a0)+,(a3)+
  BNE      _GetFileNameLoop
  MOVEQ     #1,d0
  SUB.l     d0,a3
_GetFileNameEnd:
  RTS

 endfunc    9
;---------------------------------------------------------------------------------------

 name      "GetPathPart", "(FileName$)"
 flags      StringResult | NoBase
 amigalibs _DosBase,  a6
 params     d1_l
 debugger   10

_GetPathPart:
  MOVE.l   d2,-(a7)
  MOVE.l   d1,d2
  BEQ     _GetPathNameEnd
  JSR     _PathPart(a6)
  MOVE.l   d2,a0
_GetPathNameLoop:
  CMP.l    a0,d0
  BEQ     _GetPathNameEnd
  MOVE.b   (a0)+,(a3)+
  BRA     _GetPathNameLoop
_GetPathNameEnd:
  CLR.b    (a3)
  MOVE.l  (a7)+,d2
  RTS

 endfunc    10

;---------------------------------------------------------------------------------------

 name      "PeekB", "(*Address)"
 flags      ByteResult  | InLine | NoBase
 amigalibs
 params     a0_l
 debugger   11

_PeekB:
  MOVEQ.l   #0,d0
  MOVE.b    (a0),d0
  I_RTS

 endfunc    11

;---------------------------------------------------------------------------------------

 name      "PeekW", "(*Address)"
 flags  InLine | NoBase
 amigalibs
 params     a0_l
 debugger   12

_PeekW:
  MOVEQ     #0,d0
  MOVE.w    (a0),d0
  I_RTS

 endfunc    12

;---------------------------------------------------------------------------------------

 name      "PeekL", "(*Address)"
 flags      LongResult | InLine | NoBase
 amigalibs
 params     a0_l
 debugger   13

_PeekL:
  MOVE.l    (a0),d0
  I_RTS

 endfunc    13

;---------------------------------------------------------------------------------------

 name      "PeekS", "(*Address)"
 flags      StringResult | InLine | NoBase
 amigalibs
 params     a0_l
 debugger   14

_PeekS:
  MOVE.b    (a0)+,(a3)+
  BNE      _PeekS
  SUBQ.l    #1,a3
  I_RTS

 endfunc    14

;---------------------------------------------------------------------------------------

 name      "PokeB", "(*Address, Data)"
 flags  InLine | NoBase | NoResult
 amigalibs
 params     a0_l,  d0_b
 debugger   15

_PokeB:
  MOVE.b    d0,(a0)
  I_RTS

 endfunc    15

;---------------------------------------------------------------------------------------

 name      "PokeW", "(*Address, Data)"
 flags  InLine | NoBase | NoResult
 amigalibs
 params     a0_l,  d0_w
 debugger   16

_PokeW:
  MOVE.w    d0,(a0)
  I_RTS

 endfunc    16

;---------------------------------------------------------------------------------------

 name      "PokeL", "(*Address, Data)"
 flags  InLine | NoBase | NoResult
 amigalibs
 params     a0_l,  d0_l
 debugger   17

_PokeL:
  MOVE.l    d0,(a0)
  I_RTS

 endfunc    17

;---------------------------------------------------------------------------------------

 name      "PokeS", "(*Address, String$)"
 flags     NoResult | NoBase
 amigalibs
 params     a0_l,  a1_l
 debugger   18

_PokeS:
  MOVE.l    a0, d1
  MOVE.b    (a1)+,(a0)+
  BNE      _PokeS
  MOVE.l    a0, d0
  SUBQ.l    #1, d0
  SUB.l     d1, d0        ; Return the String length
  RTS

 endfunc    18
;---------------------------------------------------------------------------------------


 name      "FreeMisc", "()"
 flags      NoResult
 amigalibs _DosBase,a6
 params
 debugger  19

 MOVE.l  8(a5),d1     ; ...
 BEQ     quit00       ; ...
 JMP    _FreeArgs(a6) ; (rdargs) - d1
quit00
 RTS

 endfunc 19
;---------------------------------------------------------------------------------------


 name      "NumberOfCLIArgs", "()"
 flags      LongResult
 amigalibs _DosBase,a6
 params
 debugger  20

 TST.l   8(a5)        ; ...
 BNE     l30          ; ...
 
 MOVEM.l d2-d3,-(a7)
 MOVE.l  a5,d1        ; template
 MOVE.l  a5,d2        ; array 
 ADDQ.l  #4,d2        ; ...
 CLR.l   d3           ; rdargs
 JSR    _ReadArgs(a6) ; (template, array, rdargs) - d1/d2/d3
 MOVEM.l (a7)+,d2-d3

 MOVE.l  d0,8(a5)     ; ...

l30
 MOVE.l  4(a5),d0     ; ...
 BEQ     quit30       ; ...

 MOVE.l  d0,a0        ; ...
 MOVEQ   #-1,d0       ; ...

loop30
 ADDQ.l  #1,d0        ; ...
 TST.l   (a0)+        ; ...
 BNE     loop30       ; ...

quit30
 RTS

 endfunc 20
;---------------------------------------------------------------------------------------
;-- This was GetCLIArg() and CountCLIArgs()..merged to match the PB 3.93 ProgramParameter func

 name      "ProgramParameter", "()"
 flags     StringResult
 amigalibs _DosBase,a6
 params  
 debugger  21

 MOVE.l  d2,-(a7)
 TST.l   8(a5)        ; ...
 BNE     l40          ; ...

 MOVE.l  a5,d1        ; arg1.
 MOVE.l  a5,d2        ; arg2.
 ADDQ.l  #4,d2        ; ...
 CLR.l   d3           ; arg3.
 JSR    _ReadArgs(a6) ; (template, array, rdargs) - d1/d2/d3

 MOVE.l  d0,8(a5)     ; ...

l40
 MOVE.l  4(a5),d0     ; ...
 BEQ     quit40       ; ...

 MOVE.l  d0,a0        ; ...
 MOVEQ   #0,d0        ; ...

loop40
 ADDQ.l  #1,d0        ; ...
 MOVE.l  (a0)+,d1     ; ...
 BEQ     quit40       ; ...

 CMP.w   d0,d2        ; ...
 BEQ     CopyString   ; ...
 BRA     loop40       ; ...


CopyString
 MOVE.l  d1,a0        ; use strptr

loop41
 MOVE.b  (a0)+,(a3)+  ; move one char
 BNE     loop41       ; ...

 SUBQ.l  #1,a3        ; ...

quit40
 MOVE.l (a7)+,d2
 RTS

 CNOP 0,4
_CurrentArgNum:
  dc.l  0

 endfunc 21

;---------------------------------------------------------------------------------------

 name      "MouseButtons", "()"
 flags  NoBase | LongResult
 amigalibs
 params
 debugger  22

 CLR.l   d0           ; ...

 BTST    #6,$bfe001   ; ...
 BNE     l60          ; ...

 MOVEQ   #1,d0        ; ...

l60
 BTST    #2,$dff016   ; ...
 BNE     quit60       ; ...

 BSET    #1,d0        ; ...

quit60
 RTS

 endfunc 22
;---------------------------------------------------------------------------------------


 name      "PrintNumberN", "(Number)"
 flags     NoResult | NoBase
 amigalibs _DosBase,  a6
 params     d0_l
 debugger   23

_PrintNumberN:
  MOVE.l   d2,-(a7)
  LEA.l    PNumN_Buffer(pc), a0
  MOVE.l   a0, d1
  LEA.l    PNumN_NumBuffer(pc), a0
  MOVE.l   d0, (a0)
  MOVE.l   a0, d2
  JSR     _VPrintf(a6)    ; (d1/d2)
  LEA.l    PNumN_Buffer2(pc), a0
  MOVE.l   a0, d1
  MOVEQ    #1, d2
  JSR     _WriteChars(a6)
  JSR     _Output(a6)
  MOVE.l   d0,d1
  MOVE.l   (a7)+,d2
  JMP     _Flush(a6)      ;

PNumN_Buffer:
  Dc.b "%ld",0
  
  CNOP 0,4

PNumN_NumBuffer:
  Dc.l 0,0

PNumN_Buffer2:
  Dc.b 10,0

 endfunc   23

;---------------------------------------------------------------------------------------
; New commands to match PB 3.93
;---------------------------------------------------------------------------------------

 name      "Red", "(Colour)"
 flags     NoBase
 amigalibs 
 params     d0_l
 debugger   24
   SWAP.l d0
   AND.l  #$FF,d0
   I_RTS
 endfunc  24

;---------------------------------------------------------------------------------------

 name      "Green", "(Colour)"
 flags      NoBase | InLine | LongResult
 amigalibs 
 params     d0_l
 debugger   25
   LSR.l  #8,d0
   AND.w  $FF,d0
   I_RTS
 endfunc  25

;---------------------------------------------------------------------------------------

 name      "Blue", "(Colour)"
 flags      NoBase | InLine | LongResult
 amigalibs 
 params     d0_l
 debugger   26
    AND.l #$FF,d0
    I_RTS
 endfunc  26

;---------------------------------------------------------------------------------------

 name      "RGB", "(Red,Green,Blue)"
 flags     NoBase | InLine | LongResult
 amigalibs 
 params     d0_l,d1_l,d2_l
 debugger   27
   SWAP.l d0  
   LSL.l #8,d1  ;Set Green
   AND.l d1,d0
   AND.l d2,d0
   I_RTS    
 endfunc  27

;---------------------------------------------------------------------------------------

 name      "GetExtensionPart", "(FileName)"
 flags      StringResult | NoBase
 amigalibs _DosBase,  a6
 params     d1_l
 debugger   28
  ;- Have to do this the hard way..no API way..
  TST.l     d1
  BEQ      _GetExtensionPartEnd
  JSR      _FilePart(a6)
  MOVE.l    d0,a0   ; a0= start of filename part.. 
  MOVEA.l  d1,a1

  ;-- Now reverse search for the last "."
_GetNameEnd:
  TST.b  (a1)+   
  BNE _GetNameEnd
  
  ;-- Now search backwards for the "."
_PrevNameChar:
  CMP.b #46,-(a1)   ; Look for "."
  BEQ _GotExtension
  CMPA.l a1,a0
  BEQ _GetExtensionPartEnd  ; Can`t find it :(
  BRA _PrevNameChar

_GotExtension
  MOVE.b (a1)+,(a3)+
  BNE _GotExtension
  SUBQ #1,a3

_GetExtensionPartEnd:
  RTS  

 endfunc    28

;---------------------------------------------------------------------------------------

 name      "OSVersion", "()"
 flags      LongResult | NoBase | InLine
 amigalibs _ExecBase,  a6
 params     
 debugger   29

   ;-- Get execversion.
   MOVEQ.l #0,d0
   MOVE.w 20(a6),d0
   I_RTS
 endfunc    29

;---------------------------------------------------------------------------------------

 base

temp_:   Dc.b "/M",0,0
array_:  Dc.l 0

rdargs_: Dc.l 0

CurrentArgNum:
  dc.l  0
 endlib
;---------------------------------------------------------------------------------------

 startdebugger

 enddebugger
