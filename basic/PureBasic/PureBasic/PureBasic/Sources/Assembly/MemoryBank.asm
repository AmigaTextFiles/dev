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
; Memory Bank library for PureBasic
;
; © 2000, 2001 Martin konrad
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

 initlib "MemoryBank", "MemoryBank", "FreeAllMemoryBanks", 0, 0, 1

MEMF_CLEAR = 1 << 16 ; clear mem

;----------------------------;
; InitMemoryBank(MaxBanks.l) ;
;----------------------------;
 name      "InitMemoryBank", "(MaxBanks.l)"
 flags     LongResult
 amigalibs _ExecBase, a6
 params    d0_l
 debugger  1

   MOVE.l   d0, 4(a5)           ; write MaximumBanks to 4(a5)
   ADDQ.l   #1, d0              ; MaxBanks + 1
   LSL.l    #3, d0              ; each entry needs 8 bytes
   MOVE.l   #MEMF_CLEAR, d1
   JSR     _AllocVec(a6)
   MOVE.l   d0, (a5)            ; set ptr to memory bank infos
   RTS

 endfunc   1

;-----------------------------------------------;
; AllocateMemoryBank(Bank.l, Size.l, MemType.l) ;
;-----------------------------------------------;
 name      "AllocateMemoryBank", "(Bank.l, Size.l, MemType.l)"
 flags     LongResult
 amigalibs _ExecBase, a6
 params    d2_l, d3_l, d4_l
 debugger  2, _ParCheckA

   MOVE.l  a3, -(a7)      ; Save a3 on the stack

   LSL.l   #3, d2         ; address of memory bank info = bank * 8 + (a5)
   ADD.l   (a5), d2
   MOVE.l  d2, a3

   MOVE.l  (a3), a1       ; free memory bank first
   JSR    _FreeVec(a6)    ; (*Memory) - a1

   MOVE.l  d3, d0         ; setup the function
   MOVE.l  d4, d1         ; MemType to d1
   JSR    _AllocVec(a6)   ; (Size, MemType) - d0/d1

   MOVE.l  d0, (a3)+      ; save address (might be 0, too) and
   MOVE.l  d3, (a3)       ; size in memory bank table

;
;   TST.l   d0             ; test if memory has been allocated
;   BNE.s   .success
;
;   CLR.l   (a3)           ; clear memory bank size if not allocated
;                          ; no 4(a3) because of the (a3)+ above
;
;.success
;

   MOVE.l  (a7)+, a3      ; restore 'a3'

   RTS

 endfunc   2

;------------------------;
; FreeMemoryBank(Bank.l) ;
;------------------------;
 name      "FreeMemoryBank", "(Bank.l)"
 flags
 amigalibs _ExecBase, a6
 params    d2_l
 debugger  3, _ParCheck

   LSL.l   #3, d2      ; address of memory bank info = (bank * 8 + (a5))
   ADD.l   (a5), d2
   MOVE.l  d2, a0

   MOVE.l  (a0), a1    ; write (a0) to a1 before clearing (a0)
   CLR.l   (a0)        ; clear memory bank address
;   CLR.l   (a0)        ; clear memory bank size
   JMP    _FreeVec(a6) ; RTS is done by the function

 endfunc   3

;------------------------;
; MemoryBankSize(Bank.l) ;
;------------------------;
 name      "MemoryBankSize", "(Bank.l)"
 flags     LongResult
 amigalibs
 params    d2_l
 debugger  4, _ParCheck

   LSL.l   #3, d2
   ADD.l   (a5), d2
   MOVE.l  d2, a0

   MOVE.l  4(a0), d0

   RTS

 endfunc   4

;---------------------------;
; MemoryBankAddress(Bank.l) ;
;---------------------------;
 name      "MemoryBankAddress", "(Bank.l)"
 flags     LongResult
 amigalibs
 params    d2_l
 debugger  5, _ParCheck

   LSL.l   #3, d2
   ADD.l   (a5), d2
   MOVE.l  d2, a0

   MOVE.l  (a0), d0

   RTS

 endfunc   5

;----------------------------;
; AvailableMemory(MemType.l) ;
;----------------------------;
 name      "AvailableMemory", "(MemType.l)"
 flags     LongResult | NoBase
 amigalibs _ExecBase, a6
 params    d1_l
 debugger  6

   JMP   _AvailMem(a6) ; RTS is done by the function

 endfunc   6

;------------------------------------;
; CopyMemory(*Source, *Dest, Size.l) ;
;------------------------------------;
 name      "CopyMemory", "(*Source, *Dest, Size.l)"
 flags     NoBase
 amigalibs
 params    a0_l, a1_l, d0_l
 debugger  7

  MOVE.l d0, d1           ; size to d1
  AND.l  #15, d1          ; how many rest bytes
  BEQ.s  .LongCopy        ; if none, goto LongCopy

.ShortCopyLoop
  MOVE.b (a0)+, (a1)+     ; copy each byte
  SUBQ.b #1, d1
  BNE.s  .ShortCopyLoop

.LongCopy
  LSR.l  #4, d0           ; how many 16 byte-chunks
  BEQ.s  .NoLongCopy      ; if none, exit

.LongCopyLoop
  MOVE.l (a0)+, (a1)+     ; copy 16 byte-chunks
  MOVE.l (a0)+, (a1)+
  MOVE.l (a0)+, (a1)+
  MOVE.l (a0)+, (a1)+
  SUBQ.l #1, d0
  BNE.s  .LongCopyLoop

.NoLongCopy

  RTS

 endfunc   7

;---------------------------------------;
; FillMemory(*Dest, Size.l, FillByte.b) ;
;---------------------------------------;
 name      "FillMemory", "(*Dest, Size.l, FillByte.b)"
 flags     NoBase
 amigalibs
 params    a0_l, d0_l, d1_b
 debugger  8

  MOVE.b d1, d3           ; FillByte to d3
  LSL.l  #8, d3           ; set second byte
  ADD.b  d1, d3
  LSL.l  #8, d3           ; set third byte
  ADD.b  d1, d3
  LSL.l  #8, d3           ; set fourth byte
  ADD.b  d1, d3

  MOVE.l d0, d2           ; size to d1
  AND.l  #15, d2          ; how many rest bytes
  BEQ.s  .LongFill        ; if none, goto LongCopy

.ShortFillLoop
  MOVE.b d3, (a0)+        ; fill each byte
  SUBQ.b #1, d2
  BNE.s  .ShortFillLoop

.LongFill
  LSR.l  #4, d0           ; how many 16 byte-chunks
  BEQ.s  .NoLongFill      ; if none, exit

.LongFillLoop
  MOVE.l d3, (a0)+        ; fill 16 byte-chunks
  MOVE.l d3, (a0)+
  MOVE.l d3, (a0)+
  MOVE.l d3, (a0)+
  SUBQ.l #1, d0
  BNE.s  .LongFillLoop

.NoLongFill

  RTS

 endfunc   8

;----------------------;
; FreeAllMemoryBanks() ;
;----------------------;
 name      "FreeAllMemoryBanks", "()"
 flags
 amigalibs _ExecBase, a6
 params
 debugger  9

   TST.l   (a5)
   BEQ.s   .notinit

   MOVE.l  (a5), a2     ; You can only use a2 in the END function
   MOVE.l  4(a5), d2
   ADDQ.l  #1, d2       ; MaximumBanks + 1

.freebankloop

   MOVE.l  (a2), a1     ; free memory bank
   JSR    _FreeVec(a6)

   ADDQ.l  #8, a2       ; next memory bank

   SUBQ.l  #1, d2
;   CMP.l   #0, d2      ; disabled because SUBQ already sets the zero-flag
   BNE.s   .freebankloop

   MOVE.l  (a5), a1     ; free memory bank infos
   JMP    _FreeVec(a6)  ; RTS is done by the function

.notinit

   RTS

 endfunc   9

;
; And the common part
;

 base

 dc.l 0           ; address of memory bank infos
 dc.l 0           ; maximum number of memory banks

 endlib

 startdebugger

_InitCheck
  TST.l (a5)      ; library init test
  BEQ   Error0
  RTS
  
_ParCheck
  TST.l (a5)      ; library init test
  BEQ   Error0
  
  CMP.l 4(a5), d2 ; bank parameter test
  BHI   Error1
  
  MOVE.l d2, d7
  LSL.l  #3, d7   ; memory bank allocation test
  ADD.l  (a5), d7
  MOVE.l d7, a0
  TST.l  (a0)
  BEQ    Error2  
  RTS

_ParCheckA
  TST.l (a5)      ; library init test
  BEQ   Error0
  
  CMP.l 4(a5), d2 ; bank parameter test
  BHI   Error1
  RTS

Error0: debugerror "InitMermoyBank() hasn't been called before or can't correctly setup"
Error1: debugerror "The bank parameter passed to the function is out of range"
Error2: debugerror "The specified memory bank isn't allocated"

 enddebugger

