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
; QuickSort library
;
; 04/09/2005
;   -Doobrey-  Just added save/restore of trashed regs.

;-----------------------------------------------------------------------------------------------------------
; 21/11/1999
;   Adapted to PureBasic
;   Rewritten under PhxAss for maximum performances (gained 104 bytes (on 600 bytes) against Blitz 2 !)
;

  INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

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

 initlib "Sort", "Sort", "", 0, 1, 0

;
; Now do the functions...
;
;------------------------------------------------------------------------------------------------------

 name      "SortUp", "()"
 flags
 amigalibs
 params    a0_l, d1_l, d2_l
 debugger  1


  MOVEM.l d2-d5/a5-a6,-(a7)	; Save registers.
_SortUp:
  MOVE.w  -2(a0), d3 ; Get Type of array...
  MOVE.l  a0, a1

_UpByte:
  CMP.w   #1, d3  ; If it's a byte array
  BNE    _UpWord
  ADD.l   d1, a0  ;
  ADD.l   d2, a1  ;
  MOVEQ   #1, d5
  BSR    _SortB
  BRA    _SortUpEnd

_UpWord:
  CMP.w   #3, d3  ; If it's a word array
  BNE    _UpLong
  LSL.l   #1, d1
  LSL.l   #1, d2
  ADD.l   d1, a0
  ADD.l   d2, a1
  MOVEQ   #2, d5
  BSR    _SortW
  BRA    _SortUpEnd

_UpLong:
  LSL.l   #2, d1 ; If it's a long array
  LSL.l   #2, d2
  ADD.l   d1, a0
  ADD.l   d2, a1
  MOVEQ   #4, d5
  BSR    _SortL

_SortUpEnd:
  MOVEM.l (a7)+,d2-d5/a5-a6	; Restore registers.
  RTS


; a0 = start of the sort ; g
; a1 = end of the sort   ; d
;
_SortL:

  CMP.l  a1, a0       ; If g < d
  BGE    EndSortL     ;

  MOVE.l a0, a5   ; i=g-1
  SUB.l  d5, a5   ;

  MOVE.l a1, a6   ; j=d

  MOVE.l (a1), d2 ; v=a(d)

Loop1L:

      ADD.l  d5, a5        ; i+1
Loop2L:
      CMP.l   (a5)+, d2    ; UNTIL a(i) >= v
      BGT     Loop2L       ;


Loop3L:
      CMP.l   a0, a6       ; If j>0 Then j-1 Else QuitLoop
      BLE     QuitLoop3L   ;
      CMP.l  -(a6), d2     ;
      BLT     Loop3L       ; Until a(j) <= v

QuitLoop3L:

    MOVE.l  -(a5), d4     ; Exchange a(i), a(j)
    MOVE.l   (a6), (a5)   ;
    MOVE.l     d4, (a6)   ;


  CMP.l a5, a6 ; Until j <= i
  BGT   Loop1L ;

  MOVE.l (a6), d4     ; t = a(j)
  MOVE.l (a5), (a6)   ; a(j) = a(i)
  MOVE.l (a1), (a5)   ; a(i) = a(d)
  MOVE.l   d4, (a1)   ; a(d) = t


  MOVEM.l a1/a5,-(a7)
  SUB.l   d5, a5         ; NQuickSort{g, i-1}
  MOVE.l  a5, a1         ;
  BSR    _SortL

  MOVEM.l (a7)+,a1/a5
  ADD.l   d5, a5         ;  NQuickSort{i+1, d}
  MOVE.l  a5, a0         ;
  BSR    _SortL

EndSortL:
  RTS


_SortW:

  CMP.l  a1, a0       ; If g < d
  BGE    EndSortW     ;

  MOVE.l a0, a5   ; i=g-1
  SUB.l  d5, a5   ;

  MOVE.l a1, a6   ; j=d

  MOVE.w (a1), d2 ; v=a(d)

LoopW1:

      ADD.l  d5, a5        ; i+1
LoopW2:
      CMP.w   (a5)+, d2    ; UNTIL a(i) >= v
      BGT     LoopW2       ;


LoopW3:
      CMP.l   a0, a6       ; If j>0 Then j-1 Else QuitLoop
      BLE     QuitLoopW3   ;
      CMP.w  -(a6), d2     ;
      BLT     LoopW3       ; Until a(j) <= v

QuitLoopW3:

    MOVE.w  -(a5), d4     ; Exchange a(i), a(j)
    MOVE.w   (a6), (a5)   ;
    MOVE.w     d4, (a6)   ;


  CMP.l a5, a6 ; Until j <= i
  BGT   LoopW1 ;

  MOVE.w (a6), d4     ; t = a(j)
  MOVE.w (a5), (a6)   ; a(j) = a(i)
  MOVE.w (a1), (a5)   ; a(i) = a(d)
  MOVE.w   d4, (a1)   ; a(d) = t


  MOVEM.l a1/a5,-(a7)
  SUB.l   d5, a5         ; NQuickSort{g, i-1}
  MOVE.l  a5, a1         ;
  BSR    _SortW

  MOVEM.l (a7)+,a1/a5
  ADD.l   d5, a5         ;  NQuickSort{i+1, d}
  MOVE.l  a5, a0         ;
  BSR    _SortW

EndSortW:
  RTS



_SortB:

  CMP.l  a1, a0       ; If g < d
  BGE    EndSortB     ;

  MOVE.l a0, a5   ; i=g-1
  SUB.l  d5, a5   ;

  MOVE.l a1, a6   ; j=d

  MOVE.b (a1), d2 ; v=a(d)

LoopB1:

      ADD.l  d5, a5        ; i+1
LoopB2:
      CMP.b   (a5)+, d2    ; UNTIL a(i) >= v
      BGT     LoopB2       ;


LoopB3:
      CMP.l   a0, a6       ; If j>0 Then j-1 Else QuitLoop
      BLE     QuitLoopB3   ;
      CMP.b  -(a6), d2     ;
      BLT     LoopB3       ; Until a(j) <= v

QuitLoopB3:

    MOVE.b  -(a5), d4     ; Exchange a(i), a(j)
    MOVE.b   (a6), (a5)   ;
    MOVE.b     d4, (a6)   ;


  CMP.l a5, a6 ; Until j <= i
  BGT   LoopB1 ;

  MOVE.b (a6), d4     ; t = a(j)
  MOVE.b (a5), (a6)   ; a(j) = a(i)
  MOVE.b (a1), (a5)   ; a(i) = a(d)
  MOVE.b   d4, (a1)   ; a(d) = t


  MOVEM.l a1/a5,-(a7)
  SUB.l   d5, a5         ; NQuickSort{g, i-1}
  MOVE.l  a5, a1         ;
  BSR    _SortB

  MOVEM.l (a7)+,a1/a5
  ADD.l   d5, a5         ;  NQuickSort{i+1, d}
  MOVE.l  a5, a0         ;
  BSR    _SortB

EndSortB:
  RTS

 endfunc  1

;------------------------------------------------------------------------------------------------------

 name      "SortDown", "()"
 flags
 amigalibs
 params    a0_l, d1_l, d2_l
 debugger  2

  MOVEM.l  d2-d5/a5-a6,-(a7)	; Save registers
_SortDown:
  
  MOVE.w  -2(a0), d3
  MOVE.l  a0, a1

_DownByte:
  CMP.w   #1, d3
  BNE    _DownWord
  ADD.l   d1, a0
  ADD.l   d2, a1
  MOVEQ   #1, d5
  BSR    _SortInvB
  BRA    _SortDownEnd

_DownWord:
  CMP.w   #3, d3
  BNE    _DownLong
  LSL.l   #1, d1
  LSL.l   #1, d2
  ADD.l   d1, a0
  ADD.l   d2, a1
  MOVEQ   #2, d5
  BSR    _SortInvW
  BRA    _SortDownEnd

_DownLong:
  LSL.l   #2, d1
  LSL.l   #2, d2
  ADD.l   d1, a0
  ADD.l   d2, a1
  MOVEQ   #4, d5
  BSR    _SortInvL

_SortDownEnd:
  MOVEM.l  (a7)+,d2-d5/a5-a6	; Restore registers
  RTS

_SortInvL:

  CMP.l  a1, a0       ; If g < d
  BGE    EndSortInvL     ;

  MOVE.l a0, a5   ; i=g-1
  SUB.l  d5, a5   ;

  MOVE.l a1, a6   ; j=d

  MOVE.l (a1), d2 ; v=a(d)

LoopInvL1:

      ADD.l  d5, a5        ; i+1
LoopInvL2:
      CMP.l   (a5)+, d2    ; UNTIL a(i) >= v
      BLT     LoopInvL2       ;


LoopInvL3:
      CMP.l   a0, a6       ; If j>0 Then j-1 Else QuitLoop
      BLE     QuitLoopInvL3   ;
      CMP.l  -(a6), d2     ;
      BGT     LoopInvL3       ; Until a(j) <= v

QuitLoopInvL3:

    MOVE.l  -(a5), d4     ; Exchange a(i), a(j)
    MOVE.l   (a6), (a5)   ;
    MOVE.l     d4, (a6)   ;


  CMP.l a5, a6 ; Until j <= i
  BGT   LoopInvL1 ;

  MOVE.l (a6), d4     ; t = a(j)
  MOVE.l (a5), (a6)   ; a(j) = a(i)
  MOVE.l (a1), (a5)   ; a(i) = a(d)
  MOVE.l   d4, (a1)   ; a(d) = t


  MOVEM.l a1/a5,-(a7)
  SUB.l   d5, a5         ; NQuickSort{g, i-1}
  MOVE.l  a5, a1         ;
  BSR    _SortInvL

  MOVEM.l (a7)+,a1/a5
  ADD.l   d5, a5         ;  NQuickSort{i+1, d}
  MOVE.l  a5, a0         ;
  BSR    _SortInvL

EndSortInvL:
  RTS


_SortInvW:

  CMP.l  a1, a0       ; If g < d
  BGE    EndSortInvW     ;

  MOVE.l a0, a5   ; i=g-1
  SUB.l  d5, a5   ;

  MOVE.l a1, a6   ; j=d

  MOVE.w (a1), d2 ; v=a(d)

LoopInvW1:

      ADD.l  d5, a5        ; i+1
LoopInvW2:
      CMP.w   (a5)+, d2    ; UNTIL a(i) >= v
      BLT     LoopInvW2       ;


LoopInvW3:
      CMP.l   a0, a6       ; If j>0 Then j-1 Else QuitLoop
      BLE     QuitLoopInvW3   ;
      CMP.w  -(a6), d2     ;
      BGT     LoopInvW3       ; Until a(j) <= v

QuitLoopInvW3:

    MOVE.w  -(a5), d4     ; Exchange a(i), a(j)
    MOVE.w   (a6), (a5)   ;
    MOVE.w     d4, (a6)   ;


  CMP.l a5, a6 ; Until j <= i
  BGT   LoopInvW1 ;

  MOVE.w (a6), d4     ; t = a(j)
  MOVE.w (a5), (a6)   ; a(j) = a(i)
  MOVE.w (a1), (a5)   ; a(i) = a(d)
  MOVE.w   d4, (a1)   ; a(d) = t


  MOVEM.l a1/a5,-(a7)
  SUB.l   d5, a5         ; NQuickSort{g, i-1}
  MOVE.l  a5, a1         ;
  BSR    _SortInvW

  MOVEM.l (a7)+,a1/a5
  ADD.l   d5, a5         ;  NQuickSort{i+1, d}
  MOVE.l  a5, a0         ;
  BSR    _SortInvW

EndSortInvW:
  RTS


_SortInvB:

  CMP.l  a1, a0       ; If g < d
  BGE    EndSortInvB     ;

  MOVE.l a0, a5   ; i=g-1
  SUB.l  d5, a5   ;

  MOVE.l a1, a6   ; j=d

  MOVE.b (a1), d2 ; v=a(d)

LoopInvB1:

      ADD.l  d5, a5        ; i+1
LoopInvB2:
      CMP.b   (a5)+, d2    ; UNTIL a(i) >= v
      BLT     LoopInvB2       ;


LoopInvB3:
      CMP.l   a0, a6       ; If j>0 Then j-1 Else QuitLoop
      BLE     QuitLoopInvB3   ;
      CMP.b  -(a6), d2     ;
      BGT     LoopInvB3       ; Until a(j) <= v

QuitLoopInvB3:

    MOVE.b  -(a5), d4     ; Exchange a(i), a(j)
    MOVE.b   (a6), (a5)   ;
    MOVE.b     d4, (a6)   ;


  CMP.l a5, a6 ; Until j <= i
  BGT   LoopInvB1 ;

  MOVE.b (a6), d4     ; t = a(j)
  MOVE.b (a5), (a6)   ; a(j) = a(i)
  MOVE.b (a1), (a5)   ; a(i) = a(d)
  MOVE.b   d4, (a1)   ; a(d) = t


  MOVEM.l a1/a5,-(a7)
  SUB.l   d5, a5         ; NQuickSort{g, i-1}
  MOVE.l  a5, a1         ;
  BSR    _SortInvB

  MOVEM.l (a7)+,a1/a5
  ADD.l   d5, a5         ;  NQuickSort{i+1, d}
  MOVE.l  a5, a0         ;
  BSR    _SortInvB

EndSortInvB:
  RTS

 endfunc  2
;------------------------------------------------------------------------------------------------------
 base

 endlib
;------------------------------------------------------------------------------------------------------
 startdebugger

 enddebugger
