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
;- 18/03/2005
;      Minor changes to comply with the API style reg use/save
;      Added some NoResult flags for future use.
;      Todo : Add error checking for debugger !
;------------------------------------------------------------------------
;
; Version 1.00

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

P96SA_Width       equ  (1<<31)+$20000+96+$03
P96SA_Height      equ  (1<<31)+$20000+96+$04
P96SA_Depth       equ  (1<<31)+$20000+96+$05
P96SA_Title       equ  (1<<31)+$20000+96+$08
P96SA_BitMap      equ  (1<<31)+$20000+96+$0e

_P96AllocBitMap   equ  -$1e
_P96FreeBitMap    equ  -$24
_P96GetBitMapAttr equ  -$2a
_P96LockBitMap    equ  -$30
_P96UnlockBitMap  equ  -$36
_P96OpenScreen    equ  -$5a
_P96CloseScreen   equ  -$60

;--_LibBase    = 0
_MemPtr1    = l_MemPtr1-LibBase
_MemPtr2    = l_MemPtr2-LibBase
_NrObj1     = l_NrObj1-LibBase
_NrObj2     = l_NrObj2-LibBase
_P96Base    = l_P96Base-LibBase
_CurrBitMap = l_CBitmap-LibBase
_CurrScreen = l_CScreen-LibBase
_LibName    = l_LibName-LibBase


 initlib "Picasso96", "Picasso96", "FreePicasso96", 0, 1, 0

;----------------------------------------------------------------------------
 name      "FreePicasso96", "()"
 flags  NoResult
 amigalibs _ExecBase,a6
 params
 debugger   0

  MOVEM.l   d2-d4/a2,-(a7) 
 
  MOVE.l  _MemPtr1(a5),d4
  BEQ      FP96_End

  MOVE.l  _P96Base(a5),d3
  BEQ      FP96_l1

  MOVE.l  _NrObj1(a5),d2
  MOVE.l   d4,a2
  EXG.l    d3,a6

FP96_loop0
  MOVE.l   (a2)+,a0
  JSR     _P96FreeBitMap(a6)
  DBRA     d2,FP96_loop0

  MOVE.l  _NrObj2(a5),d2

FP96_loop1
  MOVE.l   (a2)+,d0
  BEQ      FP96_l0

  MOVE.l   d0,a0
  JSR     _P96CloseScreen(a6)

FP96_l0
  DBRA     d2,FP96_loop1

  EXG.l    d3,a6

  MOVE.l   d3,a1
  JSR     _CloseLibrary(a6)

FP96_l1
  MOVE.l   d4,a1
  JSR     _FreeVec(a6)

FP96_End
  MOVEM.l   (a7)+,d2-d4/a2
  RTS

 endfunc 0
;----------------------------------------------------------------------------

 name      "InitPicasso96", "(#MaxPicasso96BitMaps,#MaxPicasso96Screens)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d2_l,d3_l
 debugger   1

  MOVEM.l  d2-d3,_NrObj1(a5)
  ADDQ.l   #1,d2
  LSL.l    #2,d2
  ADDQ.l   #1,d3
  LSL.l    #2,d3

  MOVE.l   d2,d0
  ADD.l    d3,d0
  MOVEQ    #1,d1
  SWAP     d1
  JSR     _AllocVec(a6)
  MOVE.l   d0,_MemPtr1(a5)
  BEQ      IP96_End

  ADD.l    d0,d2
  MOVE.l   d2,_MemPtr2(a5)

  LEA     _LibName(a5),a1
  MOVEQ    #2,d0
  JSR     _OpenLibrary(a6)
  MOVE.l   d0,_P96Base(a5)

IP96_End
  MOVEM.l  _NrObj1(a5),d2-d3 ; Restore
  RTS

 endfunc 1

;----------------------------------------------------------------------------
 name      "AllocatePicasso96BitMap", "(#P96BitMap,Width,Height,Depth)"
 flags      LongResult
 amigalibs
 params     d3_l,d0_l,d1_l,d2_l
 debugger   2

  MOVEM.l   d3/a2,-(a7)

  MOVE.l  _MemPtr1(a5),a2
  LSL.l    #2,d3
  ADD.l    d3,a2
  MOVE.l  _P96Base(a5),a6

  MOVEQ    #0,d3
  SUB.l    a0,a0
  MOVEQ    #1,d7
  JSR     _P96AllocBitMap(a6)
  MOVE.l   d0,(a2)

  MOVEM.l  (a7)+, d3/a2
  RTS

 endfunc 2
;----------------------------------------------------------------------------
 name      "OpenPicasso96Screen", "(#P96Screen,#P96BitMap,Title$)"
 flags      LongResult
 amigalibs
 params     d0_l,d1_l,d2_l
 debugger   3

  MOVEM.l  d6-d7/a2-a3,-(a7)

  MOVEM.l _MemPtr1(a5),a2-a3
  LSL.l    #2,d0
  LSL.l    #2,d1
  ADD.l    d1,a2
  ADD.l    d0,a3
  MOVE.l  _P96Base(a5),a6

  MOVEQ    #2,d7
  MOVE.l   (a2),d6
  LEA      tags+4(pc),a2

OP96S_loop0
  MOVE.l   d6,a0
  MOVEQ    #2,d0
  SUB.l    d7,d0
  JSR     _P96GetBitMapAttr(a6)
  MOVE.l   d0,(a2)
  ADDQ.l   #8,a2
  DBRA     d7,OP96S_loop0

  MOVE.l   d2,0(a2)
  MOVE.l   d6,8(a2)

  LEA      tags(pc),a0
  JSR     _P96OpenScreen(a6)
  MOVE.l   d0,(a3)
  MOVE.l   d0,_CurrScreen(a5)

  MOVEM.l  (a7)+,d6-d7/a2-a3
  RTS
  
  CNOP 0,4 ;

tags: Dc.l P96SA_Width,  0
      Dc.l P96SA_Height, 0
      Dc.l P96SA_Depth,  0
      Dc.l P96SA_Title,  0
      Dc.l P96SA_BitMap, 0
      Dc.l 0,0

 endfunc 3

;----------------------------------------------------------------------------
 name      "ShowPicasso96BitMap", "(#P96BitMap,x,y)"
 flags  ;<< Check return type..
 amigalibs _GraphicsBase,a6
 params     d0_l,d1_l,d2_l
 debugger   4

  MOVE.l  _MemPtr1(a5),a0
  LSL.l    #2,d0
  ADD.l    d0,a0

  MOVE.l   (a0),-(a7)
  MOVE.l  _CurrScreen(a5),a0
  MOVE.l   80(a0),a1
  MOVE.l   (a7)+, 4(a1)
  MOVE.w   d1, 8(a1)
  MOVE.w   d2,10(a1)
  LEA      44(a0),a0
  JMP     _ScrollVPort(a6)

 endfunc 4
;----------------------------------------------------------------------------

 name      "Picasso96Plot", "(#P96BitMap,x,y,color)"
 flags
 amigalibs
 params     d0_l,d2_l,d3_l,d4_l
 debugger   5

  MOVEM.l  d3/d5/a6,-(a7)
  MOVE.l  _MemPtr1(a5),a0
  LSL.l    #2,d0
  ADD.l    d0,a0
  MOVE.l  _P96Base(a5),a6

  MOVE.l   (a0),d5

  MOVE.l   d5,a0
  MOVEQ    #0,d0
  JSR     _P96GetBitMapAttr(a6)

  MULU.w   d0,d3
  ADD.l    d2,d3

  MOVE.l   d5,a0
  MOVEQ    #3,d0
  JSR     _P96GetBitMapAttr(a6)

  ADD.l    d0,d3
  MOVE.l   d3,a0
  MOVE.b   d4,(a0)
  MOVEM.l  (a7)+,d3/d5/a6
  RTS

 endfunc 5

;----------------------------------------------------------------------------
 base
LibBase:
l_MemPtr1: Dc.l 0 ; MemPtr1
l_MemPtr2: Dc.l 0 ; MemPtr2
l_NrObj1:  Dc.l 0 ; NrObj1
l_NrObj2:  Dc.l 0 ; NrObj2
l_P96Base: Dc.l 0 ; P96Base
l_CBitmap: Dc.l 0 ; CurrBitMap
l_CScreen: Dc.l 0 ; CurrScreen

l_LibName: Dc.b "Picasso96API.library",0,0

 endlib
;----------------------------------------------------------------------------

 startdebugger

Error0: debugerror "Must Call InitPicasso96() First"

 enddebugger

