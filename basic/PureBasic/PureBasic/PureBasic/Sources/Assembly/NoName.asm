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
; Version 1.00


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


 initlib "NoName", "NoName", "FreeNoNames", 0, 1, 0


 name      "FreeNoNames", "()"
 flags
 amigalibs _DosBase,a6
 params
 debugger  0

 MOVE.l  8(a5),d1     ; ...
 BEQ     quit00       ; ...

 JMP    _FreeArgs(a6) ; (rdargs) - d1

quit00
 RTS

 endfunc 0


 name      "VPos1", "()"
 flags
 amigalibs
 params
 debugger  1

 MOVE.l  $dff004,d0   ; which of VPos1 and VPos2 to use???
 LSR.l   #8,d0        ; ...
 RTS

 endfunc 1


 name      "VPos2", "()"
 flags
 amigalibs
 params
 debugger  2

 MOVE.l  $dff004,d0   ; which of VPos1 and VPos2 to use???
 LSR.l   #8,d0        ; ...
 ANDI.w  #511,d0      ; ...
 RTS

 endfunc 2


 name      "NumberOfCLIArgs", "()"
 flags
 amigalibs _DosBase,a6
 params
 debugger  3

 TST.l   8(a5)        ; ...
 BNE     l30          ; ...

 MOVE.l  a5,d1        ; arg1.
 MOVE.l  a5,d2        ; arg2.
 ADDQ.l  #4,d2        ; ...
 CLR.l   d3           ; arg3.
 JSR    _ReadArgs(a6) ; (template, array, rdargs) - d1/d2/d3

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

 endfunc 3


 name      "GetCLIArg$", "(ArgNum.w)"
 flags     StringResult
 amigalibs _DosBase,a6
 params    d2_w
 debugger  4

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
 RTS

 endfunc 4


 name      "MouseButtons", "()"
 flags
 amigalibs
 params
 debugger  5

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

 endfunc 5



 base

temp_:   Dc.b "/M",0,0
array_:  Dc.l 0

rdargs_: Dc.l 0

 endlib


 startdebugger

 enddebugger

