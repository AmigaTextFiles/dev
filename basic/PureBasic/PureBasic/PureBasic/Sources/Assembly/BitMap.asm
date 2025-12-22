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
; 18/03/2005
;     Starting to make progress, changing to API style reg use
;     .. and also stop getting execbase from $4, when you can specify it as a reg in the amiglibs macro !!
;
;
; PureBasic 'BitMap' library
;
;
;  WARNING ********* Added Interleaved feature for test purpose...
;
;
; 05/03/2000
;   Added ShowBackBitMap()
;
; 19/01/2000
;   Added the routine to free the 2 type of BitMaps.
;   Fixed a big bug...
;
; 12/12/1999
;   Added AllocateLinearBitMap()
;
; 11/12/1999
;   Rewritten for PhxAss
;
; 03/08/1999
;   Added debugger support
;
; 13/07/1999
;   FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16
MEMF_CHIP = 2

BMF_CLEAR = 1
BMF_DISPLAYABLE = 2
BMF_INTERLEAVED = 4

ObjectShift = 4

_BitMapPtr  = 0
_BMRastPort = _BitMapPtr+4
_ObjNum     = _BMRastPort+4
_MemPtr     = _ObjNum+4

;-- The old silly method...
;_GetPositionBase = _MemPtr+4
;_UseBitMapBase   = _GetPositionBase+14
;_FreeBitMapBase  = _UseBitMapBase+24

;-- The new funky poulet method ..
_GetPositionBase = l_GetPosition-LibBase
_UseBitMapBase   = l_UseBitMap - LibBase
_FreeBitMapBase  = l_FreeBitMap - LibBase

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
;   + Number of functions in this lib. MUST be changed manually at each add.
;

 initlib "BitMap", "BitMap", "FreeBitMaps", 0, 1, 0

;
; Now do the functions...
;

;----------------------------------------------------------------------------------------
 name      "InitBitMap", "()"
 flags      LongResult
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   1

  ADDQ.l   #1, d0              ; Needed to have the correct number  
  MOVE.l   d0, _ObjNum(a5)     ; Set the Objects Numbers
  LSL.l    #ObjectShift, d0    ; d0*16
  MOVE.l   #MEMF_CLEAR, d1     ; Fill memory of '0'
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  RTS

 endfunc   1

;----------------------------------------------------------------------------------------
 name      "FreeBitMaps", "()"
 flags  NoResult
 amigalibs  _GraphicsBase,  a6, _ExecBase, a2
 params
 debugger   2

  MOVE.l  d4,-(a7)
  MOVE.l  _ObjNum(a5), d4     ; Num Objects
  ;BNE     _LoopFreeBitMaps
  ;RTS
  BEQ  _EndFreeBitMaps

_LoopFreeBitMaps:             ; Close all the opened palette
  SUBQ.l   #1, d4             ;
  MOVE.l   d4, d0             ;
  JSR     _FreeBitMapBase(a5) ; No need for a6 loaded stuffs
  TST.l    d4                 ;
  BNE     _LoopFreeBitMaps    ; Repeat:Until d4 = 0

  EXG.l    a2,a6
  MOVEA.l _MemPtr(a5), a1     ;
  JSR     _FreeVec(a6)        ; (a1) - RTS done automagically
  EXG.l    a2,a6
_EndFreeBitMaps:
  MOVE.l  (a7)+,d4
  RTS
 endfunc   2

;----------------------------------------------------------------------------------------

 name      "FreeBitMap", "( BitMap)"
 flags  NoResult | InLine
 amigalibs  _GraphicsBase,  a6 ,_ExecBase, a2
 params     d0_l
 debugger   3, _ExistCheck

  I_JSR     _FreeBitMapBase(a5)

 endfunc   3
;----------------------------------------------------------------------------------------

 name      "UseBitMap", "( BitMap)"
 flags  NoResult | InLine
 amigalibs  _ExecBase,  a6
 params     d0_l
 debugger   4, _ExistCheck

  I_JSR     _UseBitMapBase(a5)

 endfunc   4

;----------------------------------------------------------------------------------------

 name      "AllocateBitMap", "( BitMap, Width, Height, Depth)"
 flags      LongResult
 amigalibs  _GraphicsBase,  a6,  _ExecBase,  a2
 params     d0_l,  d3_l,  d1_l,  d2_l
 debugger  5, _MaxiCheck

  MOVEM.l  d2-d4/a2-a3,-(a7)
  MOVE.l   d0, d4               ; Store the value for future use
  JSR     _GetPositionBase(a5)  ; Input d0, Result a1 - a3 store the current pos.
  MOVE.l   d3, d0               ;
  MOVEQ    #7,d3 ;#BMF_DISPLAYABLE | BMF_CLEAR | BMF_INTERLEAVED, d3 ;
  SUB.l    a0, a0               ;
  JSR     _AllocBitMap(a6)      ; (Width,Height,Depth,Flags,FriendBitMap) d0,d1,d2,d3,a0
  TST.l    d0                   ;
  BEQ     _EndNBitMap           ;
  MOVE.l   d0, (a3)+            ; Set *BitMap
  MOVE.l   d0, d2               ; Store for later use
                                ;
  EXG.l    a2, a6               ; Invert *Exec <-> *Graphics
  MOVEQ    #100, d0             ;
  MOVEQ    #0, d1
  JSR     _AllocVec(a6)         ; (d0,d1)

  EXG.l    a2, a6               ; Invert *Exec <-> *Graphics
  MOVE.l   d0, (a3)             ; Set *RastPort
  MOVE.l   d0, a1               ; InitRastPort to correct values..
  JSR     _InitRastPort(a6)     ;

  MOVE.l   (a3)+, a0            ; Attach the bitmap to this RastPort
  CLR.w    (a3)                 ; Set the flag 'Real BitMap'
  MOVE.l   d2, 4(a0)            ;

  MOVE.l   d4, d0               ; Set to used state.
  JSR     _UseBitMapBase(a5)    ;

  MOVE.l   d2, d0               ; Return the BitMap pointer
_EndNBitMap:
  MOVEM.l  (a7)+,d2-d4/a2-a3
  RTS

 endfunc   5

;----------------------------------------------------------------------------------------

 name      "BitMapRastPort", "()"
 flags      LongResult| InLine
 amigalibs
 params
 debugger  6, _CurrentCheck

  MOVE.l  _BMRastPort(a5), d0
  I_RTS

 endfunc   6

;----------------------------------------------------------------------------------------

 name      "ShowBitMap", "(#BitMap, ScreenID(), x, y)"
 flags  NoResult
 amigalibs  _GraphicsBase,  a6
 params     d0_l,  a0_l,  d2_w,  d3_w
 debugger  7, _ExistCheck

  ;-MOVE.l   a3,d4
  MOVE.l   a5,-(a7)
  JSR     _GetPositionBase(a5)
  LEA.l    44(a0), a5     ; Get the viewport adress
  MOVE.l   80(a0), a0     ; Get *RasInfo
  MOVE.l   a1, 4(a0)      ; Set *BitMap to RasInfo
  MOVE.w   d2, 8(a0)      ; Set RxOffset
  MOVE.w   d3, 10(a0)     ; Set RyOffset
  MOVE.l   a5, a0
  ;-MOVE.l   d4,a3
  MOVE.l  (a7)+,a5
  JMP     _ScrollVPort(a6); (*Viewport) - a0

 endfunc   7

;----------------------------------------------------------------------------------------

 name      "ShowBackBitMap", "(#BitMap, ScreenID(), x, y)"
 flags  NoResult
 amigalibs _GraphicsBase,  a6
 params     d0_l,  a0_l,  d2_w,  d3_w
 debugger   10, _ExistCheck

  ;--MOVE.l   a3,d4
  MOVE.l  a5,-(a7)
  JSR     _GetPositionBase(a5)
  LEA.l    44(a0), a5     ; Get the viewport adress
  MOVE.l   80(a0), a0     ; Get *RasInfo
  MOVE.l   (a0), a0       ; Get next *RasInfo
  MOVE.l   a1, 4(a0)      ; Set *BitMap to RasInfo
  MOVE.w   d2, 8(a0)      ; Set RxOffset
  MOVE.w   d3, 10(a0)     ; Set RyOffset
  MOVE.l   a5, a0
  ;--MOVE.l   d4,a3
  MOVE.l  (a7)+,a5
  JMP     _ScrollVPort(a6); (*Viewport) - a0

 endfunc   10

;----------------------------------------------------------------------------------------

 name      "BitMapID", "()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   8, _CurrentCheck

  MOVE.l  _BitMapPtr(a5), d0
  I_RTS

 endfunc   8
;----------------------------------------------------------------------------------------

 name      "AllocateLinearBitMap", "(BitMap, Width, Height, Depth)"
 flags      LongResult
 amigalibs  _GraphicsBase, a0, _ExecBase,  a6
 params     d0_l,  d1_w,  d2_w,  d3_w
 debugger  9, _MaxiCheck

  MOVEM.l  d2-d6/a2-a3,-(a7)
  MOVE.l   a0, a2
  MOVE.l   d0, d4               ; Store the value for future use
  JSR     _GetPositionBase(a5)  ; Input d0, Result a1 - a3 store the current pos.
  MOVE.w   d1, d5
  MOVE.w   d1, d0               ;
  MULU.w   d2, d0               ; Get the size
  LSR.l    #3, d0               ; Divide by 8 to have the length of one plane...
  MOVE.l   d0, d6
  MULU.w   d3, d0               ; Get the memory size needed
  ADD.l    #40, d0              ; Size of the header (8 planes max)
  MOVE.l   #MEMF_CLEAR | MEMF_CHIP, d1      ;
  JSR     _AllocVec(a6)         ; d0/d1
  TST.l    d0                   ;
  BEQ     _AllocateLinearBitMap_End
  MOVE.l   d0, (a3)+            ; Set *BitMap
  
  MOVE.l   d0, a0
  LSR.w    #3, d5               ; BytesPerRow = PlaneWidth/8
  MOVE.w   d5, (a0)+            ; *BitMap\BytesPerRow
  MOVE.w   d2, (a0)+            ; *BitMap\Rows
  CLR.b    (a0)+                ; *BitMap\Flags
  MOVE.b   d3, (a0)             ; *BitMap\Depth
  ADD.l    #3, a0               ; Pad

  MOVE.l   d0, a1
  ADD.l    #40, a1

_Loop1:
  MOVE.l   a1,(a0)+             ; Setup BitPlanes pointers..
  ADD.l    d6,a1                ;
  SUBQ.w   #1,d3                ;
  BNE     _Loop1                ;

  MOVE.l   d0, d2               ; Store for later use
                                ;
  MOVEQ    #100, d0             ;
  MOVEQ    #0, d1
  JSR     _AllocVec(a6)         ; (d0,d1)

  MOVE.l   a2, a6               ; Restore *Graphics
  MOVE.l   d0, (a3)             ; Set *RastPort
  MOVE.l   d0, a1               ; InitRastPort to correct values..
  JSR     _InitRastPort(a6)     ;

  MOVE.l   (a3)+, a0            ; Attach the bitmap to this RastPort
  MOVE.w   #1, (a3)             ; Set the flag 'Linear BitMap'
  MOVE.l   d2, 4(a0)            ; RastPort

  MOVE.l   d4, d0               ; Set to used state.
  JSR     _UseBitMapBase(a5)    ;

  MOVE.l   d2, d0               ; Return the BitMap pointer
_AllocateLinearBitMap_End
  MOVEM.l  (a7)+,d2-d6/a2-a3
  RTS

 endfunc   9
;----------------------------------------------------------------------------------------

 base
LibBase:
 DC.l 0   ; _BitMapPTR
 DC.l 0   ; _BMRastPort
 DC.l 0   ; _ObjNum
 DC.l 0   ; _MemPtr


; GetPosition ***********************************************
; Flush: d0 - a1/a3

l_GetPosition:
  MOVEA.l _MemPtr(a5), a3
  LSL.l    #ObjectShift, d0
  ADD.l    d0,a3
  MOVE.l   (a3), a1   ;
  MOVE.l   a1, d0           ; 15/11/1998 added to allow fast TST.l instead of CMP.l #0, a1
  RTS


; UseBitMap *************************************************

l_UseBitMap:
  MOVEM.l  a3,-(a7)
  JSR     _GetPositionBase(a5)  ; Input d0, Result a1 - a3 store the current pos.
  TST.l    d0                   ;
  BEQ     _EndUseBitMap         ;
  LEA.l   _BitMapPtr(a5), a0    ;
  MOVE.l   (a3)+, (a0)+         ; *BitMap
  MOVE.l   (a3) , (a0)          ; *BitMapRastPort
_EndUseBitMap:                  ;
  MOVEM.l  (a7)+,a3             ;
  RTS                           ;


; FreeBitMap ************************************************
; This must be called with gfxbase in a6 and execbase in a2 !


l_FreeBitMap:
  MOVE.l   a3,-(a7)
  JSR     _GetPositionBase(a5) ; Input d0, Result a1 - a3 store the current pos.
  TST.l    d0                  ;
  BEQ     _EndFreeBitMap       ;
  CLR.l    (a3)+                ;
  MOVE.w   4(a3), d0
  BNE     _FreeLinearBitMap
  MOVE.l   a1, a0              ;
  JSR     _FreeBitMap(a6)      ; (*BitMap) - a0
  MOVE.l   (a3), a1            ; Get *RastPort
  ;--MOVEA.l  $4, a6              ;
  EXG.l a2,a6

  JSR     _FreeVec(a6)         ; (a1)
  BRA     _EndFreeBitMap
_FreeLinearBitMap:
  ;--MOVEA.l  $4,a6
  EXG.l    a2,a6
  JSR     _FreeVec(a6)
  MOVE.l   (a3), a1            ; Get *RastPort
  JSR     _FreeVec(a6)         ; (a1)
_EndFreeBitMap:
  EXG.l   a2,a6                ;-- return a2/a6 the way they were on entry..
  MOVE.l  (a7)+,a3
  RTS

 endlib

;----------------------------------------------------------------------------------------
 startdebugger

_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS

;------------------------------

_MaxiCheck:
  TST.l   _MemPtr(a5)     ; If the lib wasn't initialized..
  BEQ      Error0         ;
  TST.l    d0             ; If  BitMap < 0
  BMI      Error1         ;
  ;ADDQ.l   #1,d0          ;
  CMP.l   _ObjNum(a5),d0  ; If  BitMap > #NumMax
  BGE      Error1         ;
  ;SUBQ.l   #1,d0          ;
  RTS

;------------------------------

_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _BitMapPtr(a5)
  BEQ      Error2
  RTS

;------------------------------

_ExistCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGE      Error1
  MOVEA.l _MemPtr(a5), a0           ; Now see if the given number
  MOVE.l   d0, d1                   ; is really initialized
  LSL.l    #ObjectShift, d1         ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error3
  RTS

;------------------------------

Error0:  debugerror "InitBitMap() doesn't have been called before"
Error1:  debugerror "Maximum 'BitMap' objects reached"
Error2:  debugerror "There is no current used 'BitMap'"
Error3:  debugerror "Specified  BitMap object number isn't initialized"

 enddebugger

