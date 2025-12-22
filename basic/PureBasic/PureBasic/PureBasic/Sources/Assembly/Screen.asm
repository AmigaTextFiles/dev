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
; Screen library for PureBasic
;
; 09/09/2005
;     -Doobrey- Changed to preserve d2-d7/a2-a7, changed smaller funcs to be inline type
;               Removed hard-coded offset to base functions.
;
; 02/01/2000
;   Fixed a big bug in this lib ! (Used MEMCLEAR instead of #MEMCLEAR)
;
; 21/09/1999
;   Adapted to PhxAss
;
; 03/07/1999
;   Added Debugger support
;   Optimized a bit
;
; 20/07/1999
;   Added FlashScreen()
;   Corrected some bugs
;
; 14/06/1999
;   Added Long result for Word/Byte return
;
; 11/05/1999
;   Changed 'Clr.l dX' by 'MOVEQ #0,dX'
;   Added Protected 'a2' and 'a3' handling...
;
; 10/05/1999
;   Changed all ADD.b #1,(aX) by ADD.w #1,(aX)
;
; 10/04/1999
;   Added different return type (Byte, Word, Long)
;
; 02/04/1999
;   Converted in PowerBasic format
;   Remove WbToScreen function (useless with the FindScreen())
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

TAG_USER   = 1 << 31
TAG_MORE   = 2

SA_Dummy   = TAG_USER + 32

SA_Left    = SA_Dummy + $0001
SA_Top     = SA_Dummy + $0002
SA_Width   = SA_Dummy + $0003
SA_Height  = SA_Dummy + $0004
SA_Depth   = SA_Dummy + $0005

OBP_Precision = $84000000

VTAG_PF1_BASE_SET = $8000002A
VTAG_PF2_BASE_SET = $8000002B

_ScrPtr = 0
_RPort  = _ScrPtr + 4
_ObjNum = _RPort  + 4
_MemPtr = _ObjNum + 4

_GetPosition      = l_GetPosition - LibBase
_Base_CloseScreen = l_CloseScreen - LibBase


; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Name of the function automatically called at the end
;   + Priority of the end call
;   + Version of the library
;   + Revision of the library (ie: 0.12 here)
;

 initlib "Screen", "Screen", "FreeScreens", 100, 0, 12

;
; Now do the functions...
;

;--------------------------------------------------------------------------------------------------------
 name      "FindScreen", "()"
 flags      LongResult
 amigalibs _IntuitionBase, a6
 params     d0_l, a0_l
 debugger   1, _ScreenCheck

   MOVE.l   a3,-(a7)
   JSR     _GetPosition(a5)     ; Input d0, Result a1 - a3 store the current pos.
   MOVE.l   a0,d0               ; Fast CMP.l #0, a0
   BEQ     _SkipPubScreen       ; Case of the Default Screen
   MOVE.b   (a0),d0             ; Fast CMP.l #0, (a0)
   BNE     _SkipPubScreen       ; Case of the Default Screen
   SUB.l    a0, a0              ;
_SkipPubScreen:
   JSR     _LockPubScreen(a6)   ; (Name$) - a0
   TST.l    d0                  ;
   BEQ     _EndPublicScreen     ;
   MOVE.l   d0, (a3)            ; Save Screen Adresse
   MOVE.l   d0, a1              ; Screen Adresse
   SUB.l    a0, a0              ; Put "" Adresse into a0
   JSR     _UnlockPubScreen(a6) ; UnLockScreen()
   MOVE.l   (a3), (a5)          ; Fill the active screen structure
   MOVE.l   (a3)+, d0           ;
   ADD.w    #1, (a3)            ; We shouldn't close it at end
_EndPublicScreen:
   MOVE.l   (a7)+,a3
   RTS

 endfunc    1

;--------------------------------------------------------------------------------------------------------

 name      "OpenScreen", "(#Screen, x, y, Width, Height, Depth, TagListID())"
 flags      LongResult
 amigalibs _IntuitionBase, a6
 params     d0_l, d1_w, d2_w, d3_w, d4_l
 debugger   2, _ScreenCheck

   MOVE.l   a3,-(a7)
   JSR     _GetPosition(a5); Input d0, Result a1 - a3 store the current pos.
   LEA.l   _ScrTag(pc), a1 ; Directly load TagArray in a1
   MOVE.w   d1,  6(a1)     ; Width
   MOVE.w   d2, 14(a1)     ; Height
   MOVE.w   d3, 22(a1)     ; Depth
   MOVE.l   d4, 28(a1)     ; NextTagList
   SUB.l    a0, a0         ; NULL
   JSR     _OpenScreenTagList(a6) ; (Null, Tag) - a0/a1
   MOVE.l   d0, (a3)+             ;
   CLR.w    (a3)              ; It must be closed at the end
   MOVE.l   d0, (a5)       ; Fill The Actual Screen Structure
   MOVE.l   (a7)+,a3
   RTS
 
   CNOP 0,4 ; Align

_ScrTag:
   Dc.l SA_Width  , 0
   Dc.l SA_Height , 0
   Dc.l SA_Depth  , 0
   Dc.l TAG_MORE  , 0

 endfunc   2

;--------------------------------------------------------------------------------------------------------

 name      "ScreenMouseX", "()"
 flags	   InLine
 amigalibs
 params
 debugger  3, _CurrentCheck

   MOVEA.l  (a5), a0 ; Real Screen Addr
   MOVEQ    #0, d0
   MOVE.w   18(a0), d0     ; MouseX
   I_RTS

 endfunc   3

;--------------------------------------------------------------------------------------------------------

 name      "ScreenMouseY", "()"
 flags     InLine
 amigalibs
 params
 debugger  4, _CurrentCheck

   MOVEA.l  (a5), a0 ; Real Screen Addr
   MOVEQ    #0, d0
   MOVE.w   16(a0), d0     ; MouseY
   I_RTS

 endfunc   4

;--------------------------------------------------------------------------------------------------------

 name      "ScreenWidth", "()"
 flags     InLine
 amigalibs
 params
 debugger  5, _CurrentCheck

   MOVEA.l  (a5), a0 ; Real Screen Addr
   MOVEQ    #0, d0
   MOVE.w   12(a0), d0     ; ScreenWidth
   I_RTS

 endfunc   5

;--------------------------------------------------------------------------------------------------------

 name      "ScreenHeight", "()"
 flags     InLine
 amigalibs
 params
 debugger  6, _CurrentCheck

   MOVEA.l  (a5), a0 ; Real Screen Addr
   MOVEQ    #0, d0
   MOVE.w   14(a0), d0     ; ScreenHeight
   I_RTS

 endfunc   6

;--------------------------------------------------------------------------------------------------------

 name      "ShowScreen", "()"
 flags     InLine
 amigalibs _IntuitionBase, a6
 params
 debugger  7, _CurrentCheck

   MOVEA.l  (a5), a0    ; Real Screen Addr
   I_JSR     _ScreenToFront(a6) ; (Screen) - a0

 endfunc   7

;--------------------------------------------------------------------------------------------------------

 name      "HideScreen", "()"
 flags      InLine
 amigalibs _IntuitionBase, a6
 params
 debugger   8, _CurrentCheck

   MOVEA.l  (a5), a0   ;
   I_JSR     _ScreenToBack(a6) ; (Screen) - a0

 endfunc    8

;--------------------------------------------------------------------------------------------------------

 name      "UseScreen", "()"
 flags     InLine
 amigalibs
 params     d0_l
 debugger   9, _ExistCheck

   MOVE.l   a3,-(a7)
   JSR     _GetPosition(a5) ; Input d0, Result a1 - a3 store the current pos
   MOVE.l   a1, (a5)        ; Fill The Actual Screen Structure
   MOVE.l   a1, d0          ; To NScreen
   MOVE.l   (a7)+,a3
   I_RTS

 endfunc    9

;--------------------------------------------------------------------------------------------------------

 name      "CloseScreen", "()"
 flags      InLine
 amigalibs _IntuitionBase, a6
 params     d0_l
 debugger   10, _ExistCheck

   I_JSR _Base_CloseScreen(a5)

 endfunc    10

;--------------------------------------------------------------------------------------------------------

 name      "InitScreen", "()"
 flags
 amigalibs _ExecBase, a6
 params     d0_l
 debugger   11

   ADDQ.l  #1, d0              ; Needed to have the correct number
   MOVE.l  d0, _ObjNum(a5)     ; Set the Objects Numbers
   LSL.l   #4, d0              ; d0*16
   MOVE.l  #MEMF_CLEAR, d1     ; Fill memory of 0
   JSR    _AllocVec(a6)        ; (d0,d1)
   MOVE.l  d0, _MemPtr(a5)     ; Set the *MemPtr
   RTS

 endfunc   11

;--------------------------------------------------------------------------------------------------------

 name      "FreeScreens", "()"
 flags
 amigalibs _ExecBase, d5, _IntuitionBase, a6
 params
 debugger   12
   MOVEM.l d4-d6/a6,-(a7)     ; Save registers
   MOVE.l  _MemPtr(a5), d6
   BNE     _FreeScreensNext
   RTS
_FreeScreensNext:
   MOVE.l  _ObjNum(a5), d4     ; Num Objects
_LoopFreeScreen:               ; Close all the opened screen
   SUBQ.l   #1, d4
   MOVE.l   d4, d0
   JSR     _Base_CloseScreen(a5)
   TST.l    d4
   BNE     _LoopFreeScreen     ; Repeat:Until d4 = d0

   MOVE.l   d6, a1             ; Get the *MemPtr
   MOVE.l   d5, a6             ; Restore Exec PTR
   JSR     _FreeVec(a6)        ; (a1/d0)          
   MOVEM.l (a7)+,d4-d6/a6      ; Restore registers
   RTS                         ;
 endfunc    12

;--------------------------------------------------------------------------------------------------------

 name      "ScreenID", "()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   13, _CurrentCheck

   MOVE.l   (a5), d0
   I_RTS

 endfunc    13

;--------------------------------------------------------------------------------------------------------

 name      "ScreenRastPort", "()"
 flags      LongResult |InLine
 amigalibs
 params
 debugger   14, _CurrentCheck

   MOVE.l   (a5), d0
   ADD.w    #84, d0
   I_RTS

 endfunc    14

;--------------------------------------------------------------------------------------------------------

 name      "ScreenViewPort", "()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   15, _CurrentCheck

   MOVE.l   (a5), d0
   ADD.w    #44, d0         ; Get ViewPort addr
   I_RTS

 endfunc    15

;--------------------------------------------------------------------------------------------------------

 name      "ObtainBestPen", "()"
 flags
 amigalibs _GraphicsBase, a6
 params     d1_w, d2_w, d3_w,d4_l
 debugger   16, _CurrentCheck

   MOVEM.l d2-d4,-(a7)       ; Save registers
   MOVEA.l  (a5), a0
   MOVE.l   48(a0), a0       ; Get colormap addr
   LEA.l   _ObtainTag(pc), a1
   MOVE.l d4,4(a1)		       ; was d3
   MOVEQ    #24, d0
   LSL.l    d0, d1           ; 32 bit left justified component
   LSL.l    d0, d2           ;
   LSL.l    d0, d3           ;
   JSR     _ObtainBestPenA(a6) ;
   MOVEM.l (a7)+,d2-d4         ; Restore registers
   RTS

   CNOP 0,4   ; Align tags

_ObtainTag:
   Dc.l OBP_Precision, 0
   Dc.l 0

 endfunc    16

;--------------------------------------------------------------------------------------------------------

 name      "ReleasePen", "()"
 flags      InLine
 amigalibs _GraphicsBase, a6
 params     d0_w
 debugger   17, _CurrentCheck

   MOVEA.l  (a5), a0
   MOVE.l   48(a0), a0       ; Get colormap addr
   I_JSR     _ReleasePen(a6)

 endfunc    17

;--------------------------------------------------------------------------------------------------------

 name      "ScreenBarHeight", "()"
 flags      InLine
 amigalibs
 params
 debugger   18, _CurrentCheck

   MOVEA.l  (a5), a0
   MOVEQ    #0, d0
   MOVE.b   30(a0), d0
   I_RTS

 endfunc    18

;--------------------------------------------------------------------------------------------------------

 name      "ScreenFontHeight", "()"
 flags     InLine
 amigalibs
 params
 debugger   20, _CurrentCheck

   MOVEA.l  (a5), a0
   MOVE.l   40(a0), a0
   MOVEQ    #0, d0
   MOVE.w   4(a0), d0
   I_RTS

 endfunc    20

;--------------------------------------------------------------------------------------------------------

 name      "FindFrontScreen", "()"
 flags      LongResult
 amigalibs _IntuitionBase, a6
 params     d0_l
 debugger   21, _ScreenCheck

   MOVEM.l   d2/a3,-(a7)
   JSR     _GetPosition(a5)  ; Input d0, Result a1 - a3 store the current pos.
   MOVEQ    #0,d0
   JSR     _LockIBase(a6)
   MOVE.l   d0, a0
   MOVE.l   60(a6), d2       ; Get *FirstScreen value.
   JSR     _UnlockIBase(a6)  ; (ILock) - a0
   MOVE.l   d2, d0           ;
   MOVE.l   d0, (a3)+        ; Save Screen Adresse
   ADDQ     #1, (a3)         ; We shouldn't close it at end
   MOVE.l   d0, (a5)         ; Fill the active struct
   MOVEM.l   (a7)+,d2/a3
   RTS

 endfunc    21

;--------------------------------------------------------------------------------------------------------

 name      "ScreenDepth", "()"
 flags     InLine
 amigalibs
 params
 debugger   22, _CurrentCheck

   MOVEA.l    (a5), a0  ; Real Screen Addr
   MOVEQ      #0, d0
   MOVE.b  189(a0), d0  ; Get RastPort\BitMap ptr
   I_RTS

 endfunc    22

;--------------------------------------------------------------------------------------------------------

 name      "FlashScreen", "()"
 flags      InLine
 amigalibs _IntuitionBase, a6
 params
 debugger   23, _CurrentCheck

   MOVEA.l    (a5), a0  ; Real Screen Addr
   I_JSR       _DisplayBeep(a6)

 endfunc    23

;--------------------------------------------------------------------------------------------------------

 name      "CreateDualPlayField", "(BitMapID)"
 flags
 amigalibs _ExecBase, a6, _GraphicsBase, d3, _IntuitionBase, d4
 params     d2_l
 debugger   24, _CurrentCheck

   MOVEM.l   a5-a6,-(a7)      ; Save registers
   MOVEQ.l   #12, d0          ; Allocate some memory for our RasInfo_Bis
   MOVE.l    #MEMF_CLEAR, d1  ; structure...
   JSR      _AllocVec(a6)     ;
   MOVE.l    d0,a0          ; Set *RasInfo\BitMap
   MOVE.l    d2,4(a0)       ;

   MOVEA.l    (a5), a5  ; Real Screen Addr

   JSR      _Forbid(a6)
   MOVE.l    80(a5), a0     ; *Screen\ViewPort\RasInfo
   MOVE.l    d0, (a0)       ; RasInfo\Next = RasInfo_Bis
   OR.w      #1024, 76(a5)  ; Set the #DPLAYFIELD flags in *Screen\ViewPort\Modes
   JSR      _Permit(a6)

   MOVE.l    d3, a6
   LEA.l     VideoControlTags(pc), a1
   MOVE.l    48(a5), a0         ; Get *Screen\ViewPort\ColorMap
   JSR      _VideoControl(a6)   ; (*ColorMap, *TagList) - a0/a1

   MOVE.l    d4, a6
   MOVE.l    a5, a0
   JSR      _MakeScreen(a6)     ; (*Screen) - a0
   JSR      _RethinkDisplay(a6) ; ()
   MOVEM.l   (a7)+,a5-a6        ; Restore registers
   RTS

   CNOP 0,4   ; Align tags

VideoControlTags:
   Dc.l VTAG_PF2_BASE_SET, 0
   Dc.l VTAG_PF1_BASE_SET, 16
   Dc.l 0,0

 endfunc    24

;--------------------------------------------------------------------------------------------------------

 name      "RemoveDualPlayField", "()"
 flags
 amigalibs _ExecBase, a6
 params
 debugger   25, _CurrentCheck
   
   MOVE.l      a5,-(a7)     ; Save a5
   MOVEA.l     (a5), a5     ; *Screen Addr
   MOVE.l    80(a5), a0     ; *Screen\ViewPort\RasInfo
   MOVE.l     4(a0), a1
   CLR.l      4(a0)         ; RasInfo\Next = 0
   JSR      _FreeVec(a6)   ; (*Memory) - a1
   MOVEQ.l   #10, d0        ;
   BCLR.w    d0, 76(a5)     ; Remove the #DPLAYFIELD flags in *Screen\ViewPort\Modes
   MOVE.l   (a7)+,a5        ; Restore a5
   RTS

 endfunc    25

;--------------------------------------------------------------------------------------------------------

;
; And the common part
;

 base
LibBase:

   Dc.l 0      ; Active Screen Ptr
   Dc.l 0      ; Screen RastPort
   Dc.l 0      ; Objects numbers
   Dc.l 0      ; Ptr to membank


; GetPosition                 ; Function is in the
l_GetPosition:
   MOVEA.l _MemPtr(a5), a3    ; base bank
   LSL.l    #4, d0            ;
   ADD.l    d0, a3            ;
   MOVE.l   (a3), a1          ;
   RTS                        ;


; CloseScreen
l_CloseScreen:
   MOVE.l   a3,-(a7)
   JSR     _GetPosition(a5)    ; Input d0, Result a1 - a3 store the current pos
   MOVE.l   a1,d0
   BEQ     _EndCloseScreen
   MOVE.w   4(a3), d0
   TST.w    d0
   BNE     _EndCloseScreen
   MOVE.l   a1, a0
   JSR     _CloseScreen(a6)    ; (Screen) - a0
   CLR.l    (a3)
_EndCloseScreen:
   MOVE.l   (a7)+,a3
   RTS

 endlib

;--------------------------------------------------------------------------------------------------------

 startdebugger

_ScreenCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGE      Error1
  RTS


_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS


_MaxiObjCheck:
  CMP.l   _ObjNum(a5),d0
  BGE      Error1
  RTS


_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _ScrPtr(a5)
  BEQ      Error2
  RTS


_ExistCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGE      Error1
  MOVEA.l _MemPtr(a5), a0           ; Now see if the given number
  MOVE.l   d0, d1                   ; is really initialized
  LSL.l    #4, d1                   ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error3
  RTS


Error0: debugerror "InitScreen() doesn't have been called before"
Error1: debugerror "Maximum 'Screen' objects reached"
Error2: debugerror "There is no current used 'Screen'"
Error3: debugerror "Specified #Screen object number isn't initialized"

 enddebugger


