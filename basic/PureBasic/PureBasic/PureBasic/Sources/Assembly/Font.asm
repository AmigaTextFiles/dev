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
; PureBasic 'Font' library
;
; 10/09/2005
;  Removed hard-coded base function offsets..
;
; 14/03/2005
; FreeFonts() .. saved regs.
;     CloseFont was fucked... it used ExecBase instead of GraphicsBase for JSR _CloseFont(a6) !!
; Saved on some reg & stack use on support funcs GetPosition and CloseFont.
;     LoadFont, now saves a6.
;
; Poss inline FontID()??
;     Inlined FontID() and CloseFont()
;
; 30/05/2001
;   Converted to PhxAss
;
; 10/01/2001
;   Fixed a FontID() bug (a3 was still used)
;
; 25/11/1999
;   Fixed a big bug in LoadFont() routine (passed ExecBase instead of GfxBase..)
;
; 03/08/1999
;   Added debugger support
;
; 21/07/1999
;   Finished the library
;
; 14/07/1999
;   Continued the work....
;
; 13/07/1999
;   FirstVersion
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

_DiskFont = 0
_FontPtr  = _DiskFont+4
_ObjNum   = _FontPtr+4
_MemPtr   = _ObjNum+4

GetPosition  = l_GetPosition-LibBase
CloseFont    = l_CloseFont-LibBase


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

 initlib "Font", "Font", "FreeFonts", 0, 1, 0

;
; Now do the functions...
;
;----------------------------------------------------------------------------------
 name      "InitFont", "(#NbMaxFont)"
 flags      LongResult
 amigalibs _ExecBase, a6
 params    d0_l
 debugger  1

  ADDQ.l   #1, d0              ; Needed to have the correct number  
  MOVE.l   d0, _ObjNum(a5)     ; Set ObjNum
  LSL.l    #2, d0              ; d0*4
  MOVE.l   #MEMF_CLEAR, d1     ;
  JSR     _AllocVec(a6)        ; (d0,d1)
  MOVE.l   d0, _MemPtr(a5)     ; Set *MemPtr
  LEA.l   _FontName(pc), a1    ; Library name
  MOVEQ    #36, d0             ; Version
  JSR     _OpenLibrary(a6)     ; (*Name$, Version) - a1/d0
  MOVE.l   d0, _DiskFont(a5)   ; Set *DiskFont
_Quit:
  RTS


_FontName:
 Dc.b "diskfont.library",0 
 even

 endfunc   1
;----------------------------------------------------------------------------------

 name      "FreeFonts", "()"
 flags    NoResult
 amigalibs _GraphicsBase, a6, _ExecBase,a2
 params
 debugger  2
  
  MOVE.l   d4,-(a7)   ; save d4.
  MOVE.l  _ObjNum(a5),d4      ; Num Objects
  BEQ     .End

.Loop:                ; Close all the opened font
  SUBQ.l   #1, d4
  MOVE.l   d4, d0
  JSR      CloseFont(a5)
  TST.l    d4
  BNE     .Loop       ; Loop until d4, d0

  EXG.l     a2,a6
  MOVEA.l _DiskFont(a5), a1   ;
  JSR     _CloseLibrary(a6)   ; (*Library) - a1
  MOVEA.l _MemPtr(a5), a1     ;
  JSR _FreeVec(a6) ; (a1/d0)
  EXG.l a2,a6     ; restore the regs.
.End:
  MOVE.l  (a7)+,d4    ; restore d4
  RTS
 endfunc   2

;----------------------------------------------------------------------------------
 name      "LoadFont", "(#Font, Name$, Size)"
 flags     LongResult
 amigalibs _GraphicsBase, a6
 params    d0_l, d1_l, d2_l
 debugger  3, _MaxiCheck

  MOVEM.l  a2-a3,-(a7)
  JSR      GetPosition(a5)     ; Input d0, Result a1 - a3 store the current pos.
  LEA.l   _TextAttr(pc), a2    ; Get TextAttr allocated space
  MOVE.l   d1,  (a2)           ; Give the Name Ptr.
  MOVE.w   d2, 4(a2)           ; Fill the Y parameter
  MOVE.l   a2, a0              ; Get Ptr
  JSR     _OpenFont(a6)        ; (*TextAttr) - a0
  TST.l    d0                  ;
  BNE.l   _EndLoadFont         ; If not null, finish the procedure
  MOVE.l  a6,-(a7)     ; Save GfxBase
  MOVEA.l _DiskFont(a5), a6    ; Get Diskfont.library ptr.
  MOVE.l   a2, a0              ;
  JSR     _OpenDiskFont(a6)    ; (*TextAttr) - a0
  MOVEA.l (a7)+,a6     ; Restore GfxBase
_EndLoadFont:
  MOVE.l   d0, (a3)            ; Put *Font in the bank at the right pos
  MOVE.l   d0, _FontPtr(a5)    ;
  MOVEM.l  (a7)+,a2-a3
  MOVE.l   _FontPtr(a5),d0
  RTS

  CNOP 0,4

_TextAttr:
 Dc.l 0,0 ; 8 bytes for the TextAttr structure

 endfunc   3
;----------------------------------------------------------------------------------

 name      "UseFont", "(#Font)"
 flags  LongResult
 amigalibs
 params    d0_l
 debugger  4, _ExistCheck

  MOVE.l   a3,-(a7)
  JSR      GetPosition(a5)      ; Input d0, Result a1 - a3 store the current pos.
  MOVEA.l  (a7)+,a3
  MOVE.l   a1,d0
  BEQ     _EndUseFont           ;
  MOVE.l   a1, _FontPtr(a5)     ; Current *Font
_EndUseFont:
  RTS

 endfunc   4
;----------------------------------------------------------------------------------

 name      "CloseFont", "(#Font)"
 flags    InLine | NoResult
 amigalibs _GraphicsBase, a6
 params    d0_l
 debugger  5, _ExistCheck

  I_JSR      CloseFont(a5)

 endfunc   5
;----------------------------------------------------------------------------------

 name      "FontID", "()"
 flags     LongResult | InLine
 amigalibs
 params
 debugger  6, _CurrentCheck

  MOVE.l  _FontPtr(a5), d0
  I_RTS

 endfunc   6

;------------------------ Base ------------------------

 base
LibBase:
 Dc.l 0  ; *DiskFont.library
 Dc.l 0  ; *Font (current used font)
 Dc.l 0  ; Object Numbers (maximum)
 Dc.l 0  ; *Memory bank for objects


; GetPosition *****************************************
;
;
l_GetPosition:
  MOVEA.l _MemPtr(a5), a3 ; Saves on reg use ..
  LSL.l    #2, d0
  ADD.l    d0, a3 
  MOVE.l   (a3), a1
  MOVEA.l (a1),a1
  RTS


; CloseFont *******************************************
;
; GraphicsBase 'a6'
;
l_CloseFont:
  MOVE.l   a3,-(a7)
  JSR      GetPosition(a5)
  MOVE.l   a1,d0
  BEQ     _EndCloseFont
  JSR     _CloseFont(a6)   ; - a1
  CLR.l    (a3)
_EndCloseFont:
  MOVEA.l (a7)+,a3
  RTS

  Even

 endlib
;----------------------------------------------------------------------------------
;------------------------ Debugger ---------------------

 startdebugger

_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ Error0
  RTS


_MaxiCheck:
  TST.l   _MemPtr(a5)
  BEQ Error0
  CMP.l   _ObjNum(a5),d0
  BGE Error1
  RTS


_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ Error0
  TST.l   _FontPtr(a5)
  BEQ Error2
  RTS


_ExistCheck:
  TST.l   _MemPtr(a5)
  BEQ Error0
  CMP.l   _ObjNum(a5), d0
  BGE Error1
  MOVEA.l _MemPtr(a5), a0           ; Now see if the given number
  MOVE.l   d0, d1                   ; is really initialized
  LSL.l    #2, d1                   ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error3
  RTS


Error0:  DebugError "InitFont() hasn't been called before"
Error1:  DebugError "Maximum 'Font' objects reached"
Error2:  DebugError "There is no current used 'Font'"
Error3:  DebugError "Specified #Font object number isn't initialized"

 enddebugger

