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
; PureBasic '2D Drawing' library
;
; 18/03/2005
;   Some funcs now inline type when possible.
;   Checked for API style reg use/save
;
; 31/05/2001
;   PhxAss conversion..
;
; 11/01/2001
;   Fixed a bug in DrawingFont()
;
; 26/09/1999
;   Changed BoxFill() and Line()
;
; 21/07/1999
;   Corrected TextLenght() and PrintText()
;
; 07/07/1999
;  FirstVersion
;


 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

_RastPort = 0

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

 initlib "2DDrawing", "2DDrawing", "", 0, 1, 0

;
; Now do the functions...
;
;---------------------------------------------------------------------------------------

 name      "BoxFill", "(x,y,Width,Height)"
 flags      NoResult
 amigalibs  _GraphicsBase,  a6
 params     d0_w,  d1_w,  d2_w,  d3_w
 debugger   1, _InitCheck

.BoxFill_TEST:
  MOVEM.l   d2-d3,-(a7)
  ADD.w     d0, d2
  ADD.w     d1, d3
  CMP.w     d0, d2    ; are in the clock order like
  BHI      _NBF_Ok_X  ; requested by RectFill()
  EXG       d0, d2    ;
_NBF_Ok_X:            ;
  CMP.w     d1, d3    ;
  BHI      _NBF_Ok_Y  ;
  EXG       d1, d3    ;
_NBF_Ok_Y:            ;
  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  JSR      _RectFill(a6)      ; RectFill(rp, x, y, x2, y2) - a1/d0/d1/d2/d3
  MOVEM.l  (a7)+,d2-d3
  RTS

 endfunc    1
;---------------------------------------------------------------------------------------

 name      "Plot", "(x,y)
 flags	 NoResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_w,  d1_w
 debugger   2, _InitCheck

  MOVEA.l  _RastPort(a5), a1   ; Get *RastPort
  I_JSR      _WritePixel(a6)     ; WritePixel(rp, x, y) - a1/d0/d1

 endfunc    2
;---------------------------------------------------------------------------------------


 name      "Line", "(x,y,Width,Height)"
 flags     NoResult
 amigalibs  _GraphicsBase,  a6
 params     d2_w,  d3_w,  d0_w,  d1_w
 debugger   3, _InitCheck

.Line_TEST:
  MOVEA.l _RastPort(a5), a1  ; Get *RastPort
  MOVE.w   d2, 36(a1)     ; Fill the RastPort Structure (cp_x)
  MOVE.w   d3, 38(a1)     ;                             (cp_y)
  ADD.w    d2, d0         ; Get the real x pos
  ADD.w    d3, d1         ; Get the real y pos
  JMP     _Draw(a6)       ; Draw(rp, x2, y2) - a1/d0/d1

 endfunc    3
;---------------------------------------------------------------------------------------


 name      "Circle", "(x,y,radius)"
 flags      NoResult
 amigalibs  _GraphicsBase,  a6
 params     d0_w,  d1_w,  d2_w
 debugger   4, _InitCheck

  MOVE.l    d3,-(a7)
  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  MOVE.w    d2, d3            ; Set same radius
  JSR      _DrawEllipse(a6)   ; DrawEllipse(rp, x, y, RadiusX, RadiusY) - a1/d0/d1/d2/d3
  MOVE.l   (a7)+,d3
  RTS

 endfunc    4

;---------------------------------------------------------------------------------------

 name      "Ellipse", "(x,y,RadiusX,RadiusY)"
 flags      NoResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_w,  d1_w,  d2_w,  d3_w
 debugger   5, _InitCheck

  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  I_JSR      _DrawEllipse(a6)   ; DrawEllipse(rp, x, y, x2, y2) - a1/d0/d1/d2/d3

 endfunc    5

;---------------------------------------------------------------------------------------

 name      "FrontColour", "(Colour)"
 flags	NoResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_w
 debugger   6, _InitCheck

  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  I_JSR      _SetAPen(a6)       ; SetAPen(rp, colour) - a1/d0

 endfunc    6
;---------------------------------------------------------------------------------------


 name      "BackColour", "(Colour)"
 flags	NoResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_w
 debugger   7, _InitCheck

  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  I_JSR      _SetBPen(a6)       ; SetBPen(rp, colour) - a1/d0

 endfunc    7
;---------------------------------------------------------------------------------------


 name      "DrawingMode", "(Mode)"
 flags	NoResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_l
 debugger   8, _InitCheck

  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  I_JSR      _SetDrMd(a6)       ; SetDrMd(rp, Jam) - a1/d0

 endfunc    8

;---------------------------------------------------------------------------------------

 name      "DrawingOutput", "(Output)"
 flags	NoResult | InLine
 amigalibs
 params     d0_l
 debugger   9

  MOVE.l    d0, _RastPort(a5)
  I_RTS

 endfunc    9

;---------------------------------------------------------------------------------------

 name      "CopyBitMap", "(BitMapID,SourceX,SourceY,DestX,DestY,Width,Height)"
 flags	NoResult
 amigalibs  _GraphicsBase,  a6
 params     a0_l,  d0_w,  d1_w,  d2_w,  d3_w,  d4_w,  d5_w
 debugger   10, _InitCheck

  MOVE.l    d6,-(a7)
  MOVE.l    #$C0, d6; Standard copy
  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  JSR      _BltBitMapRastPort(a6) ; *MyBitmap, 0, 0, *RPort, 10, 20, 82, 100, $c0
  MOVE.l   (a7)+,d6
  RTS
 endfunc    10
;---------------------------------------------------------------------------------------


 name      "Cls", "(Colour)"
 flags	NoResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_w
 debugger   11, _InitCheck

  MOVEA.l  _RastPort(a5), a1  ; Get *RastPort
  I_JSR      _SetRast(a6)       ; SetRast(rp, colour) - a1/d0

 endfunc    11
;---------------------------------------------------------------------------------------


 name      "Locate", "(x,y)"
 flags	NoResult
 amigalibs
 params     d0_w,  d1_w
 debugger   12, _InitCheck

  MOVEA.l _RastPort(a5), a0 ; Get RastPort From Structure.
  MOVE.w   d0, 36(a0)       ; Fill the RastPort Structure (cp_x)
  MOVE.w   62(a0), 38(a0)   ; Add the baseline  
  ADD.w    d1, 38(a0)       ;                             (cp_y)
  RTS

 endfunc    12
;---------------------------------------------------------------------------------------


 name      "PrintText", "()"
 flags      ;NoResult <<!------------------------------ Does _Text return?
 amigalibs  _GraphicsBase,  a6
 params     a0_l
 debugger   13, _InitCheck

  MOVE.l   a0,d0
  BEQ     _PrintTextEnd
  MOVE.l   a0,a1
_GetSize:
  MOVE.b   (a1)+,d0
  BNE     _GetSize
  SUB.l    a0,a1
  MOVE.l   a1,d0
  SUBQ.l   #1,d0
  BEQ     _PrintTextEnd
  MOVEA.l _RastPort(a5), a1 ; Get RastPort From Structure.
  JMP     _Text(a6)         ; (rp, String$, Count) a1/a0/d0
_PrintTextEnd:
  RTS

 endfunc    13
;---------------------------------------------------------------------------------------


 name      "TextStyle", "(Style)"
 flags	InLine ;<<-------------------- Return type?
 amigalibs  _GraphicsBase,  a6
 params     d0_l
 debugger   14, _InitCheck

  MOVEA.l _RastPort(a5), a1  ; Get RastPort
  MOVEQ.l  #7, d1            ; All style enabled
  I_JSR     _SetSoftStyle(a6)  ; (Rp, Style, Enabled) a1/d0/d1

 endfunc    14

;---------------------------------------------------------------------------------------

 name      "DrawingFont", "(FontID())"
 flags	InLine ;<<-------------------- Return type?
 amigalibs  _GraphicsBase,  a6
 params     a0_l
 debugger   15, _InitCheck

  MOVEA.l _RastPort(a5), a1 ; Get RastPort From Structure for speed...
  I_JSR     _SetFont(a6)      ; (rp, textFont)  a1/a0

 endfunc    15
;---------------------------------------------------------------------------------------


 name      "TextLength", "()"
 flags      LongResult
 amigalibs  _GraphicsBase,  a6
 params     a0_l
 debugger   16, _InitCheck

  MOVE.l   a0,a1
  MOVE.l   a0,d0
  BNE     _GetSize2
  RTS
_GetSize2:
  MOVE.b   (a1)+,d0
  BNE     _GetSize2
  SUB.l    a0,a1
  MOVE.l   a1,d0
  SUBQ.l   #1,d0
  MOVEA.l _RastPort(a5), a1 ; Get RastPort From Structure for speed...
  JMP     _TextLength(a6)   ; (rp, String$, Count) a1/a0/d0

 endfunc   16

;---------------------------------------------------------------------------------------

 name      "Point", "(x,y)"
 flags      LongResult | InLine
 amigalibs  _GraphicsBase,  a6
 params     d0_w,  d1_w
 debugger   17, _InitCheck

  MOVEA.l _RastPort(a5), a1 ; Get RastPort From Structure for speed...
  I_JSR     _ReadPixel(a6)    ; (rp, x, y) a1/d0/d1

 endfunc    17
;---------------------------------------------------------------------------------------


 name      "DrawingRastPort", "()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   18, _InitCheck

  MOVE.l  _RastPort(a5), d0 ; Get RastPort From Structure for speed...
  I_RTS

 endfunc    18
;---------------------------------------------------------------------------------------


 name      "CursorX", "()"
 flags	InLine | LongResult
 amigalibs
 params
 debugger   19, _InitCheck

  MOVEA.l _RastPort(a5), a0
  MOVEQ    #0, d0
  MOVE.w   34(a0), d0
  I_RTS

 endfunc    19
;---------------------------------------------------------------------------------------


 name      "CursorY", "()"
 flags	 LongResult
 amigalibs
 params
 debugger   20, _InitCheck

  MOVEA.l _RastPort(a5), a0
  MOVEQ    #0, d0
  MOVE.w   36(a0), d0
  SUB.w    62(a0), d0         ; Remove the BaseLine value..
  RTS

 endfunc    20
;---------------------------------------------------------------------------------------

 base

 Dc.l 0 ; RastPort

 endlib

; -------------------------------------- Debugger ---------------------

 startdebugger

_InitCheck:
  TST.l   (a5)
  BEQ Error0
  RTS

Error0:  debugerror "SetDrawingOutput() hasn't have been called."

 enddebugger

