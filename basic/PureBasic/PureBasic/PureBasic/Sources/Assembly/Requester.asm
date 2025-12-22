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
; PureBasic 'Requesters' library
;
; 14/03/2005
;	Inlined a few reqs...
;	EasyRequester() missing NoBase
;     InitLib had mispelled exitfunction name !! (or vice versa)
;	  .. also changed to auto init..
;	FileRequester - saved d2
;     FreeRequester could be inlined.
;
; 21/01/2001
;   Font/ScreenRequester() doesn't returns 0 when cancelled..
;
; 10/09/2000
;   Fixed a little bug (FileRequester)..
;
; 28/02/2000
;   Converted to PhxAss
;   Optimized a bit...
;   Added 'EasyRequest()'
;
; 03/08/1999
;   Added debugger support
;
; 20/07/1999
;   Fixed a big bug which doesn't release memory if
;   the user cancelled the requester
;
; 12/07/1999
;   Fixed an enforcer hit & some other stuffs 
;
; 14/06/1999
;   Added Long result even for Word/Byte return..
;
; 08/06/1999
;   FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

_ASL   = 0

_ASL_X      = _ASL+4
_ASL_Y      = _ASL_X+2
_ASL_Width  = _ASL_Y+2
_ASL_Height = _ASL_Width+2

_ASL_Data = _ASL_Height+2


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
;

 initlib "Requester", "Requester", "FreeRequester", 0, 1, 0

;
; Now do the functions...
;
;-----------------------------------------------------------------------------------------
 name      "FileRequester", "(TagList)"
 flags      StringResult
 amigalibs
 params     a0_l
 debugger   1, _InitCheck

  MOVEM.l    d2/a2/a6,-(a7)    ; Save registers

  MOVEA.l  _ASL(a5), a6        ; *ASL
  MOVE.l  a0, d2
  MOVEQ   #0,d0                ; For the 'file' descirptor
  JSR    _AllocAslRequest(a6)  ; (d0/a0)
  TST.l   d0
  BEQ    _EndASLFile           ; Can't alloc the asl memory space
  MOVE.l  d0, a2               ; Store the alloc pointer
  MOVE.l  d2, a1               ; Tags
  MOVE.l  a2, a0               ;
  JSR    _AslRequest(a6)       ; (a0/a1)
  TST.l   d0
  BEQ    _EndASLFile2          ; If Cancelled
  MOVE.l  8(a2), a0            ; Path$ Pointer
  MOVEQ   #-1,d0
_LoopPath:
  ADDQ.w  #1,d0
  MOVE.b  (a0)+, (a3)+
  BNE    _LoopPath  ; NULL Terminated string

  SUB.w   #2, a3
  TST.w   d0
  BEQ    _NoPath
  CMP.b   #"/", (a3)
  BEQ    _NoPath
  CMP.b   #":", (a3)
  BEQ    _NoPath
  ADD.w   #1, a3
  MOVE.b  #"/", (a3)

_NoPath:
  ADD.w   #1, a3
  MOVE.l  4(a2), a0 ; FileName Pointer
_Read_FileName:
  MOVE.b  (a0)+, (a3)+
  BNE    _Read_FileName

  SUB.w   #1, a3

  LEA.l   _ASL_X(a5), a0
  MOVE.l   22(a2), (a0)+   ; X, Y
  MOVE.l   26(a2), (a0)    ; Width, Height

_EndASLFile2:
  CLR.b    (a3)
  MOVE.l   a2, a0 ;
  JSR     _FreeAslRequest(a6) ; (a0)

_EndASLFile:
  MOVEM.l   (a7)+,d2/a2/a6
  RTS

 endfunc   1
;-----------------------------------------------------------------------------------------
 name      "FontRequester", "(TagList)"
 flags      LongResult
 amigalibs
 params     a0_l
 debugger   2, _InitCheck

  MOVEM.l   d2/a2/a6,-(a7)
  MOVEA.l _ASL(a5), a6

  MOVE.l   a0, d2

  MOVEQ.l  #1,d0    ; For the 'font' descriptor
  JSR     _AllocAslRequest(a6)   ; (d0/a0)
  TST.l    d0
  BEQ     _EndFontASL ; Can't alloc the asl memory space

  MOVE.l   d0, a2     ; a2 store the alloc pointer

  MOVE.l   d2, a1         ; Tags
  MOVEQ.l  #0, d2         ; d2=0 so, if the requester is cancelled, it will return 0
  MOVE.l   a2, a0         ; FontRequest Ptr
  JSR     _AslRequest(a6) ; (a0/a1)
  TST.l    d0
  BEQ     _EndFontASL2     ; If cancelled

  ; Fill the structure...
  LEA.l   _ASL_Data(a5), a0
  MOVE.l   a0, d2
  MOVE.l    8(a2),  (a0)+     ; *Name.b
  MOVE.l   12(a2),  (a0)+     ; YSize.w, Style.b, Flags.b
  MOVE.l   16(a2),  (a0)      ; FrontPen.b, BackPen.b, DrawMode.b

  LEA.l   _ASL_X(a5), a0
  MOVE.l   24(a2), (a0)+      ; X, Y
  MOVE.l   28(a2), (a0)       ; Width, Height

_EndFontASL2:
  MOVE.l   a2, a0 ;
  JSR     _FreeAslRequest(a6) ; - a0

  MOVE.l   d2, d0

_EndFontASL:
  MOVEM.l   (a7)+,d2/a2/a6
  RTS

 endfunc   2

;-----------------------------------------------------------------------------------------
 name      "ScreenRequester", "(TagList)"
 flags      LongResult
 amigalibs
 params     a0_l
 debugger   3, _InitCheck

  ;MOVE.l   a2,-(a7)
  MOVEM.l	d2-d4/a6, -(a7)

  MOVEA.l _ASL(a5), a6		; get aslbase
  MOVE.l  a0, d2			; save Taglist  .. d2 needs saving..

  MOVEQ.l #2,d0               ; For the 'screen' descriptor
  JSR    _AllocAslRequest(a6) ; (d0/a0)
  TST.l   d0
  BEQ    _EndScreenASL        ; Can't alloc the asl memory space

  MOVE.l  d0, a2         ; Store the alloc pointer

  MOVE.l  d2, a1         ; Tags
  MOVE.l  a2, a0         ; FontRequest *PTR
  JSR    _AslRequest(a6) ; (a0/a1)
  TST.l   d0
  BEQ    _EndScreenASL2   ; If cancelled

  ; Fill the structure...
  MOVE.l   a2, d4			;.. save a2 in d4.... d4 needs saving..
  LEA.l   _ASL_Data(a5), a0
  MOVE.l   (a2)+, (a0)+      ; DisplayID.l
  MOVE.l   (a2)+, (a0)+      ; DisplayWidth.l
  MOVE.l   (a2)+, (a0)+      ; DisplayHeight.l
  MOVE.l   (a2)+, (a0)+      ; DisplayDepth.w, OverScanType.w
  MOVE.b   (a2) , (a0)       ; AutoScroll.b

  LEA.l   _ASL_X(a5), a0
  MOVE.l   26(a2), (a0)+     ; X, Y
  MOVE.l   30(a2), (a0)      ; Width, Height

  MOVEA.l	d4,a0
  JSR     _FreeAslRequest(a6) ; (a0)

  LEA.l   _ASL_Data(a5), a0
  MOVE.l   a0, d0

_EndScreenASL:
  MOVEM.l (a7)+,d2-d4/a6
  RTS

_EndScreenASL2:
  MOVE.l   a2, a0             ;
  JSR     _FreeAslRequest(a6) ; (a0)
  MOVEQ.l  #0, d0
  BRA     _EndScreenASL

 endfunc   3
;-----------------------------------------------------------------------------------------
 name      "RequesterX", "()"
 flags	InLine | LongResult
 amigalibs
 params
 debugger   4, _InitCheck

  MOVEQ    #0, d0
  MOVE.w  _ASL_X(a5), d0
  I_RTS

 endfunc   4
;-----------------------------------------------------------------------------------------
 name      "RequesterY", "()"
 flags	InLine | LongResult
 amigalibs
 params
 debugger   5 ,_InitCheck

  MOVEQ     #0, d0
  MOVE.w   _ASL_Y(a5), d0
  I_RTS

 endfunc    5

;-----------------------------------------------------------------------------------------
 name      "RequesterWidth", "()"
 flags	InLine | LongResult
 amigalibs
 params
 debugger   6, _InitCheck

  MOVEQ     #0, d0
  MOVE.w   _ASL_Width(a5), d0
  I_RTS

 endfunc    6

;-----------------------------------------------------------------------------------------
 name      "RequesterHeight", "()"
 flags	InLine | LongResult
 amigalibs
 params
 debugger   7, _InitCheck

  MOVEQ     #0, d0
  MOVE.w   _ASL_Height(a5), d0
  I_RTS

 endfunc    7

;-----------------------------------------------------------------------------------------
 name      "InitRequester", "()"
 flags      InitFunction 
 amigalibs _ExecBase,  a6
 params
 debugger   8

  LEA.l    _Asl_Name(pc), a1   ; Library name
  MOVEQ     #36, d0            ; Version
  JSR      _OpenLibrary(a6)    ; OpenLibrary() - a1/d0
  MOVE.l    d0, _ASL(a5)       ; *Asl
  RTS

_Asl_Name:
  Dc.b "asl.library",0

 endfunc   8
;-----------------------------------------------------------------------------------------

 name      "FreeRequester", "()"
 flags	   NoResult
 amigalibs _ExecBase,  a6
 params
 debugger   9

  MOVEA.l _ASL(a5), a1        ; *Asl
  I_JSR   _CloseLibrary(a6)   ; (*Library) - a1

 endfunc   9

;-----------------------------------------------------------------------------------------
 name      "EasyRequester", "(Title.s, Text.s, Button.s)"
 flags      LongResult | NoBase
 amigalibs _IntuitionBase, a6
 params     d0_l, d1_l, d2_l
 debugger   10

  MOVEM.l   a2-a3, -(a7)
  SUB.l     a0, a0
  LEA.l    _EasyStructure(pc), a1
  MOVE.l    d0,  8(a1)
  MOVE.l    d1, 12(a1)
  MOVE.l    d2, 16(a1)
  MOVE.l    a0, a2
  MOVE.l    a0, a3
  JSR      _EasyRequestArgs(a6) ; (*Library) - a0/a1/a2/a3
  MOVEM.l   (a7)+, a2-a3
  RTS

 CNOP 0,4	; Align

_EasyStructure:
  Dc.l 20
  Dc.l 0
  Dc.l 0, 0, 0

 endfunc    10
;-----------------------------------------------------------------------------------------

 base

 Dc.l 0       ; ASL library pointer

 Dc.w 0,0,0,0 ; ASL x,y,width,height

 Dc.l 0,0,0,0,0,0,0 ; 28 bytes for Datas...

 endlib
;-----------------------------------------------------------------------------------------
 startdebugger

_InitCheck:
  TST.l  _ASL(a5)
  BEQ     Error0
  RTS

Error0:  debugerror "InitRequester() hasn't been called before."

 enddebugger

