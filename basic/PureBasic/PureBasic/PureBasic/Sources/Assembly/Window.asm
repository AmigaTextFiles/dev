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
; PureBasic Window Library (Amiga)
;  
; 09/09/2005
;  -Doobrey- All funcs now preserve d2-d7/a2-a7
;            Changed many of the smaller commands to be inline type (uses macros, so still normal commands for now)
;            Removed hard coded offset for common funcs in base.
;            To do: Add some missing debugger checks, move object system to dynamic object banks..no more init(x) !
;
;--------------------------------------------------------------------------------------------------
; 10/06/2001
;   Removed DeattacheGadgetList() and BevelBox(), into Gadget Lib.
;   Added EventMenuID(). Rename to EventGadgetID().
;
; 04/06/2001
;   Use 72(a4) to share the current Window ptr for Gadget lib..
;
; 03/06/2001
;   Changed EventWindow() to EventWindowID()
;
; 25/05/2001
;   OpenWindow() and CloseWindow() now use PB_AllocateNewString
;   and PB_FreeString with global stringpool from PB globalbase.
;   And also allocate objbase with PB_AllocateGlobalMemory.
;
; 11/05/2001
;   Added WA_NewLookMenus to the TagList..
;   Added IDCMP_ACTIVEWINDOW and IDCMP_CHANGEWINDOW to the default IDCMP
;
; 09/05/2001
;   Changed a bit in OpenWindow() and probably fixed IDCMP port bug.
;
; 08/05/2001
;   Changed parameters for OpenWindow() and added SetWindowTagList().
;   Fixed up InitWindow() and FreeWindows(). It still worked.
;
; 07/05/2001
;   Converted source to PhxAss. The demo, Window.pb, worked. Fixed
;   WaitWindowEvent() bug.
;
; 11/01/2001
;   CloseWindow() now free the Used window pointer if it was
;   the used window (useful for Debugger..)
;
; 30/06/2000
;   Fixed a bug in WindowMouseX() and WindowMouseY()
;
; 15/01/2000
;   Added the Boopsi Support !! Yeaahh.
;
; 12/11/1999
;   Fixed 2 bugs in WindowInnerHeight/Width()
;
; 24/10/1999
;   Fixed a big bug in the OpenWindow() routine !
;   Added ChangeIDCMP()
;
; 02/08/1999
;   Added full debugger support
;
; 16/07/1999
;   Added BevelBox()
;
; 14/06/1999
;   Added Long result for Word/Byte return
;
; 11/05/1999
;   Replaced 'CLR.l dx' by 'MOVEQ #0,dx'
;   Added 'a2' register protection
;
; 10/05/1999
;   Added Registers protection (a3)
;
; 11/04/1999
;   Added GetPosition and CloseWindow to the base..
;
; 10/04/1999
;   Added different return type (Byte, Word, Long)
;
; 02/04/1999
;   First version
;   Optimized a bit by replacing LEA.l _WinPtr(pc), a0 - MOVE.w d0,(a0) -> MOVE.w d0, _WinPtr(a5)
;   Conversion finished at 14h08 (Cool :)
;

; To Do.
; =====
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

TAG_MORE           = $00000002

IDCMP_GADGETDOWN   = $00000020
IDCMP_GADGETUP     = $00000040
IDCMP_MENUPICK     = $00000100
IDCMP_CLOSEWINDOW  = $00000200
IDCMP_MOUSEBUTTONS = $00000008
IDCMP_ACTIVEWINDOW = $00040000
IDCMP_VANILLAKEY   = $00200000
IDCMP_IDCMPUPDATE  = $00800000
IDCMP_CHANGEWINDOW = $02000000

WA_Left            = $80000063+$01
WA_Top             = $80000063+$02
WA_IDCMP           = $80000063+$07
WA_Flags           = $80000063+$08
WA_Title           = $80000063+$0b
WA_InnerWidth      = $80000063+$13
WA_InnerHeight     = $80000063+$14
WA_NewLookMenus    = $80000063+$30
WA_BusyPointer     = $80000063+$35

GA_ID              = $80030000+$10
GT_VisualInfo      = $80080000+51
GTBB_Recessed      = $80080000+52

IDCMP1             = IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|IDCMP_GADGETDOWN
IDCMP2             = IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY|IDCMP_MENUPICK
IDCMP3             = IDCMP_ACTIVEWINDOW | IDCMP_CHANGEWINDOW
DefaultIDCMP       = IDCMP1 | IDCMP2 | IDCMP3


_LibBase        = 0
_WinPtr         = _LibBase
_RPort          = _WinPtr+4
_ObjNum         = _RPort+4
_MemPtr         = _ObjNum+4
_MsgPort        = _MemPtr+4
_GadTools       = _MsgPort+4
_GTGadgetID     = _GadTools+4
_GTCode         = _GTGadgetID+2
_GTQualifier    = _GTCode+2
_WindowID       = _GTQualifier+2
_DefaultIDCMP   = _WindowID+4
_TagList        = _DefaultIDCMP+4


_GetPosition   = l_GetPosition - LibBase
_B_CloseWindow = l_CloseWindow - LibBase


_PB_StringPool  = 00
_G_CurrWin      = 72

; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Name of the 'end function' automatically called
;   + Priority of the 'end function' (high number say it will be called sooner)
;   + Version of the library
;   + Revision of the library (ie: 0.12 here)
;

 initlib "Window", "Window", "FreeWindows", 1000, 1, 0

;--------------------------------------------------------------------------------------------------

 name      "FreeWindows","()"
 flags
 amigalibs _ExecBase,d3, _IntuitionBase,a6
 params
 debugger   0

  MOVEM.l d4/a2/a6,-(a7)	  ; Save registers
  LEA     _ObjNum(a5),a2          ;
  MOVE.l   (a2)+,d4               ;
  TST.l    (a2)+                  ;
  BEQ      FWs_End                ;

_LoopFreeWindows                  ; Close all the opened windows
  MOVE.l   d4, d0                 ;
  JSR     _B_CloseWindow(a5)      ; (#Window) - d0
  DBRA     d4,_LoopFreeWindows    ; Repeat:Until d4 = d0

  MOVEA.l  d3, a6                 ; Get Exec Lib PTR

  MOVE.l   (a2)+, d0              ;
  BEQ      FWs_l0                 ;
  MOVEA.l  d0,a0                  ;
  JSR     _DeleteMsgPort(a6)      ; (a0)

FWs_l0
  MOVE.l   (a2), d0               ;
  BEQ      FWs_End                ;
  MOVEA.l  d0,a1                  ;
  JSR     _CloseLibrary(a6)       ; (a1)
  
FWs_End
  MOVEM.l (a7)+,d4/a2/a6          ; Restore registers
  RTS

 endfunc 0

;--------------------------------------------------------------------------------------------------

 name      "InitWindow","()"
 flags      InitFunction
 amigalibs _ExecBase,a6
 params
 debugger   1

  LEA     _MsgPort(a5), a5        ;

  JSR     _CreateMsgPort(a6)      ;
  MOVE.l   d0, (a5)+              ; Set *MsgPort
  BEQ      IW_End                 ;

  LEA     _GadToolsName(pc),a1    ;
  MOVEQ    #36, d0                ;
  JSR     _OpenLibrary(a6)        ; a1/d0
  MOVE.l   d0, (a5)               ; Set *GadTools

IW_End
  RTS

_GadToolsName
  Dc.b "gadtools.library",0,0

 endfunc 1

;--------------------------------------------------------------------------------------------------

 name      "OpenWindow","(#Window,x,y,Width,Heigth,Flags,Title$)"
 flags      LongResult
 amigalibs _IntuitionBase,a6
 params     d0_l,d1_w,d2_w,d3_w,d4_w,d5_l,d6_l
 debugger   2

  MOVEM.l  d6-d7/a3/a5,-(a7)      ; Save registers
  MOVE.l   d0,d7                  ; Save d0 - Used after, in the UserData !!

  CMP.l   _ObjNum(a5),d0          ;
  BLE      OW_ReAllocSkip         ;

  MOVE.l  _MemPtr(a5),a0          ; This address can be 0 (first time)
  ADDQ.l   #8, d0                 ; 8 by 8 step (should be enough)
  MOVE.l   d0,_ObjNum(a5)         ; Update ObjNum
  ADDQ.l   #1, d0                 ; 0 counts, so +1 is necessary
  LSL.l    #2, d0                 ; d0*4
  PB_ReAllocMem a1                ; Call our global allocation routine
  MOVE.l   d0, _MemPtr(a5)        ;

OW_ReAllocSkip:
  MOVE.l   d6,a0                  ; param1.
  MOVE.l  _PB_StringPool(a4),a1   ; param2.
  PB_AllocString A3               ; (string,mempool) - a0/a1
  MOVE.l   d0,d6                  ; save new string
  MOVE.l   d7,d0                  ; Restore d0

  JSR     _GetPosition(a5)        ;
  LEA.l   _WinTag(pc), a1         ; Directly load TagArray in a1
  MOVE.w   d1,  6(a1)             ; x
  MOVE.w   d2, 14(a1)             ; y
  MOVE.w   d3, 22(a1)             ; Width
  MOVE.w   d4, 30(a1)             ; Height
  MOVE.l   d5, 36(a1)             ; Flags
  MOVE.l   d6, 44(a1)             ; Title
  MOVE.l  _TagList(a5), 68(a1)    ; NextTagList
  SUB.l    a0, a0                 ; NULL
  JSR     _OpenWindowTagList(a6)  ; (0, Tag) - a0/a1
  MOVE.l   d0, (a3)               ;
  MOVE.l   d0,_G_CurrWin(a4)      ;
  BEQ      OW_End                 ;

  MOVE.l   d0, a3                 ;
  MOVE.l  _MsgPort(a5),86(a3)     ; set UserPort
  MOVE.l   d7, 120(a3)            ; set UserData
  MOVE.l   d0, (a5)+              ; Window Ptr
  MOVE.l   50(a3), (a5)           ; Window RastPort
  CLR.l   _TagList-4(a5)          ;

  MOVE.l  _DefaultIDCMP-4(a5),d0  ;
  BEQ      OW_l0                  ;

  MOVE.l   a3, a0                 ;
  JSR     _ModifyIDCMP(a6)        ;

OW_l0
  MOVE.l   a3, d0                 ;

OW_End
  MOVEM.l  (a7)+,d6-d7/a3/a5      ; Restore registers
  RTS

 CNOP 0,4	; Align structure..

_WinTag
  Dc.l WA_Left        , 0
  Dc.l WA_Top         , 0
  Dc.l WA_InnerWidth  , 0
  Dc.l WA_InnerHeight , 0
  Dc.l WA_Flags       , 0
  Dc.l WA_Title       , 0
  Dc.l WA_IDCMP       , 0
  Dc.l WA_NewLookMenus, 1
  Dc.l TAG_MORE       , 0
  Dc.l 0

 endfunc 2

;--------------------------------------------------------------------------------------------------

 name      "UseWindow","(#Window)"
 flags      LongResult
 amigalibs
 params     d0_l
 debugger   3,_ExistCheck

  MOVEM.l  a3/a5,-(a7)		  ; Save registers
  JSR     _GetPosition(a5)        ; (#Window) - d0
  MOVE.l   a1, d0                 ;
  BEQ     _EndUseWindow           ;
  MOVE.l      a1 , (a5)+          ; Window Ptr
  MOVE.l   50(a1), (a5)           ; Window RastPort
  MOVE.l   a1,_G_CurrWin(a4)      ;
  MOVE.l   a1, d0                 ; For PB_Window return

_EndUseWindow
  MOVEM.l (a7)+,a3/a5		  ;Restore
  RTS

 endfunc 3

;--------------------------------------------------------------------------------------------------
;D- Just changed to I_RTS macro.

 name      "WindowID","()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   4,_CurrentCheck

  MOVE.l   (a5), d0               ; Get Window Ptr From LibBase.
  I_RTS

 endfunc 4

;--------------------------------------------------------------------------------------------------

 name      "CloseWindow","(#Window)"
 flags     InLine
 amigalibs _ExecBase,d3, _IntuitionBase,a6
 params     d0_l
 debugger   5,_ExistCheck

  JMP     _B_CloseWindow(a5)      ; (#Window) - d0

 endfunc 5

;--------------------------------------------------------------------------------------------------

 name      "ChangeIDCMP","(NewIDCMP)"
 flags
 amigalibs
 params     d0_l
 debugger   6

  MOVE.l   d0, _DefaultIDCMP(a5)  ;
  RTS

 endfunc 6

;--------------------------------------------------------------------------------------------------

 name      "SetWindowTagList","(TagListID)"
 flags     InLine
 amigalibs
 params     d0_l
 debugger   7

  MOVE.l   d0,_TagList(a5)        ;
  I_RTS

 endfunc 7

;--------------------------------------------------------------------------------------------------

 name      "WindowX","()"
 flags    InLine
 amigalibs
 params
 debugger   8,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVEQ.l   #0, d0                ;
  MOVE.w   4(a0), d0              ;
  I_RTS

 endfunc 8

;--------------------------------------------------------------------------------------------------

 name      "WindowY","()"
 flags     InLine
 amigalibs
 params
 debugger   9,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVEQ    #0, d0                 ;
  MOVE.w   6(a0), d0              ;
  I_RTS

 endfunc 9

;--------------------------------------------------------------------------------------------------

 name      "WindowWidth","()"
 flags     InLine
 amigalibs
 params
 debugger   10,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVEQ    #0, d0                 ;
  MOVE.w   8(a0), d0              ;
  I_RTS

 endfunc 10

;--------------------------------------------------------------------------------------------------

 name      "WindowHeight","()"
 flags	   InLine
 amigalibs
 params
 debugger   11,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVEQ    #0, d0                 ;
  MOVE.w   10(a0), d0             ;
  I_RTS

 endfunc 11

;--------------------------------------------------------------------------------------------------

 name      "WindowInnerHeight","()"
 flags
 amigalibs
 params
 debugger   12,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVEQ    #0, d0                 ;
  MOVE.w   10(a0), d0             ; Get the window height
  MOVEQ    #0,d1                  ;
  MOVE.b   55(a0), d1             ; Substract BorderTop
  SUB.w    d1, d0                 ;
  MOVE.b   57(a0), d1             ; Substract BorderBottom
  SUB.w    d1, d0                 ;
  RTS

 endfunc 12

;--------------------------------------------------------------------------------------------------

 name      "WindowInnerWidth","()"
 flags
 amigalibs
 params
 debugger   13,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVEQ    #0, d0                 ;
  MOVE.w    8(a0), d0             ; Get the window width
  MOVEQ    #0,d1                  ;
  MOVE.b   54(a0), d1             ; Substract BorderLeft
  SUB.w    d1,d0                  ;
  MOVE.b   56(a0), d1             ; Substract BorderRight
  SUB.w    d1,d0                  ;
  RTS

 endfunc 13

;--------------------------------------------------------------------------------------------------

 name      "WindowBorderLeft","()"
 flags     InLine
 amigalibs
 params
 debugger   14,_CurrentCheck

  MOVEQ    #0,d0                  ;
  MOVE.l  _WinPtr(a5),a0          ; Get *WScreen
  MOVE.b   54(a0),d0              ;
  I_RTS

 endfunc 14

;--------------------------------------------------------------------------------------------------

 name      "WindowBorderTop","()"
 flags	   InLine
 amigalibs
 params
 debugger   15,_CurrentCheck

  MOVEQ    #0,d0                  ;
  MOVE.l  _WinPtr(a5),a0          ; Get *WScreen
  MOVE.b   55(a0),d0              ;
  I_RTS

 endfunc 15

;--------------------------------------------------------------------------------------------------

 name      "WindowBorderRight","()"
 flags     InLine
 amigalibs
 params
 debugger   16,_CurrentCheck

  MOVEQ    #0,d0                  ;
  MOVE.l  _WinPtr(a5),a0          ; Get *WScreen
  MOVE.b   56(a0),d0              ;
  I_RTS

 endfunc 16

;--------------------------------------------------------------------------------------------------

 name      "WindowBorderBottom","()"
 flags     InLine
 amigalibs
 params
 debugger   17,_CurrentCheck

  MOVEQ    #0,d0                  ;
  MOVE.l  _WinPtr(a5),a0          ; Get *WScreen
  MOVE.b   57(a0),d0              ;
  I_RTS

 endfunc 17

;--------------------------------------------------------------------------------------------------

 name      "WindowMouseX","()"
 flags     InLine
 amigalibs
 params
 debugger   18,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVE.w   14(a0), d0             ;
  EXT.l    d0                     ;
  I_RTS

 endfunc 18

;--------------------------------------------------------------------------------------------------

 name      "WindowMouseY","()"
 flags     InLine
 amigalibs
 params
 debugger   19,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  MOVE.w   12(a0), d0             ;
  EXT.l    d0                     ;
  I_RTS

 endfunc 19

;--------------------------------------------------------------------------------------------------

 name      "BusyPointer","(State)"
 flags
 amigalibs _IntuitionBase,a6
 params     d0_w
 debugger   20,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  LEA.l    PointerTag(pc), a1     ;
  MOVE.w   d0, 6(a1)              ;
  JMP     _SetWindowPointerA(a6)  ;
 
  CNOP 0,4			 ; Align tags

PointerTag
  Dc.l WA_BusyPointer, 0
  Dc.l 0

 endfunc 20

;--------------------------------------------------------------------------------------------------

 name      "ActivateWindow","()"
 flags      InLine
 amigalibs _IntuitionBase,a6
 params
 debugger   21,_CurrentCheck

  MOVEA.l  (a5), a0               ; WinAddr in a0
  I_JSR     _ActivateWindow(a6)     ; (a0)   ;-- macro changes this to JSR if compiler can do InLine..

 endfunc 21

;--------------------------------------------------------------------------------------------------

 name      "MoveWindow","(x,y)"
 flags      InLine
 amigalibs _IntuitionBase,a6
 params     d0_w,d1_w
 debugger   22,_CurrentCheck

  MOVEA.l   (a5), a0              ; WinAddr in a0
  SUB.w    4(a0), d0              ; Get the real position
  SUB.w    6(a0), d1              ;
  I_JSR     _MoveWindow(a6)         ; (Window, offsX, offsY)   a0/d0/d1

 endfunc 22

;--------------------------------------------------------------------------------------------------

 name      "SizeWindow","(Width,Height)"
 flags      InLine
 amigalibs _IntuitionBase,a6
 params     d0_w,d1_w
 debugger   23,_CurrentCheck

  MOVEA.l    (a5), a0             ; WinAddr in a0
  SUB.w     8(a0), d0             ; Get the real position
  SUB.w    10(a0), d1             ;
  I_JSR     _SizeWindow(a6)         ; (Window, offsX, offsY)   a0/d0/d1

 endfunc 23

;--------------------------------------------------------------------------------------------------

 name      "WindowRastPort","()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   24,_CurrentCheck

  MOVE.l  _RPort(a5), d0          ; Get RastPort From LibBase.
  I_RTS

 endfunc 24

;--------------------------------------------------------------------------------------------------

 name      "WindowEvent","()"
 flags      LongResult
 amigalibs _IntuitionBase,d5
 params
 debugger   25,_CurrentCheck

  MOVEM.l d2-d3/a2-a3/a6,-(a7)    ; Save registers
  MOVEA.l _GadTools(a5), a6       ;
  MOVEA.l _MsgPort(a5), a0        ; Get the *UserPort
  JSR     _GT_GetIMsg(a6)         ; (*Port) - a0
  TST.l    d0                     ;
  BEQ     _EndNGadToolsIDCMP      ;

  CLR.w   _GTGadgetID(a5)         ; Reset the EventID Value
  MOVE.l   d0, a1                 ;
  MOVE.l   44(a1), a3             ; *Window
  MOVE.l   120(a3), _WindowID(a5) ; Fill WindowID
  MOVE.l   20(a1), d2             ; Class
  MOVE.w   24(a1), d3             ; Code
  MOVE.w   d3, _GTCode(a5)        ; Set Code
  MOVE.w   26(a1), _GTQualifier(a5) ; Set the Qualifier
  MOVE.l   28(a1), a2             ;
  JSR     _GT_ReplyIMsg(a6)       ; (*Message) - a1
  CMP.l    #IDCMP_GADGETUP, d2    ;
  BEQ     _OkGadget               ;

  CMP.l    #IDCMP_IDCMPUPDATE, d2 ;
  BEQ     _Boopsi                 ;

  CMP.l    #IDCMP_GADGETDOWN, d2  ;
  BNE     _SkipGadget             ;

_OkGadget
  MOVE.w   38(a2), d0             ; Get GadgetID
  SUB.w    #60, d0                ;
  BRA     _SetGadgetID            ;

_Boopsi
  MOVE.l   #GA_ID,d0              ; a2 store a pointer to a TagList   We need to find

_FindTagLoop
  MOVE.l   (a2)+,d1               ; the #GA_ID tag.
  CMP.l    d0,d1                  ;
  BEQ     _BoopsiOk               ;
  ADD.l    #4,a2                  ;
  BRA     _FindTagLoop            ;

_BoopsiOk
  MOVE.l   (a2),d0                ;
  BRA     _SetGadgetID            ;

_SkipGadget
  CMP.l    #IDCMP_MENUPICK, d2    ;
  BNE     _SkipMenu               ;

  CMP.w    #-1, d3                ;
  BEQ     _SkipMenu               ;

  MOVE.l   28(a3), d0             ; Get windows menu strip
  TST.l    d0                     ;
  BEQ     _SkipMenu               ;

  MOVE.l   d5, a6                 ; restore Intuition base
  MOVE.l   d0, a0                 ;
  MOVE.w   d3, d0                 ; Use previouly saved GTCode
  JSR     _ItemAddress(a6)        ; (*Menu, Code) - a0/d0
  MOVE.l   d0, a0                 ;
  MOVE.l   34(a0), d0             ; EvenID

_SetGadgetID
  MOVE.w   d0, _GTGadgetID(a5)    ; Store it

_SkipMenu
  MOVE.l   d2, d0                 ; Restore 'class'

_EndNGadToolsIDCMP
  MOVEM.l (a7)+,d2-d3/a2-a3/a6    ; Restore registers
  RTS

 endfunc 25

;--------------------------------------------------------------------------------------------------

 name      "WaitWindowEvent","()"
 flags      LongResult
 amigalibs _ExecBase,a6, _IntuitionBase,d5
 params
 debugger   26,_CurrentCheck

  MOVEM.l  d2-d3/a2-a3/a6,-(a7)   ; Save registers
  MOVEA.l _MsgPort(a5), a0        ; Get the *UserPort
  JSR     _WaitPort(a6)           ; (*Port) - a0

  MOVEA.l _GadTools(a5), a6       ;
  MOVEA.l _MsgPort(a5), a0        ; Get the *UserPort
  JSR     _GT_GetIMsg(a6)         ; (*Port) - a0
  TST.l    d0                     ;
  BEQ     _EndNGadToolsIDCMP2     ;

  CLR.w   _GTGadgetID(a5)         ; Reset the EventID Value
  MOVE.l   d0, a1                 ;
  MOVE.l   44(a1), a3             ; *Window
  MOVE.l   120(a3), _WindowID(a5) ; Fill WindowID
  MOVE.l   20(a1), d2             ; Class
  MOVE.w   24(a1), d3             ; Code
  MOVE.w   d3, _GTCode(a5)        ; Set Code
  MOVE.w   26(a1), _GTQualifier(a5) ; Set the Qualifier
  MOVE.l   28(a1), a2             ;
  JSR     _GT_ReplyIMsg(a6)       ; (*Message) - a1
  CMP.l    #IDCMP_GADGETUP, d2    ;
  BEQ     _OkGadget2              ;

  CMP.l    #IDCMP_IDCMPUPDATE, d2 ;
  BEQ     _Boopsi2                ;

  CMP.l    #IDCMP_GADGETDOWN, d2  ;
  BNE     _SkipGadget2            ;

_OkGadget2
  MOVE.w   38(a2), d0             ; Get GadgetID
  SUB.w    #60, d0                ;
  BRA     _SetGadgetID2           ;

_Boopsi2
  MOVE.l   #GA_ID,d0              ; a2 store a pointer to a TagList   We need to find

_FindTagLoop2
  MOVE.l   (a2)+,d1               ; the #GA_ID tag.
  CMP.l    d0,d1                  ;
  BEQ     _BoopsiOk2              ;
  ADD.l    #4,a2                  ;
  BRA     _FindTagLoop2           ;

_BoopsiOk2
  MOVE.l   (a2),d0                ;
  BRA     _SetGadgetID2           ;

_SkipGadget2
  CMP.l    #IDCMP_MENUPICK, d2    ;
  BNE     _SkipMenu2              ;

  CMP.w    #-1, d3                ;
  BEQ     _SkipMenu2              ;

  MOVE.l   28(a3), d0             ; Get windows menu strip
  TST.l    d0                     ;
  BEQ     _SkipMenu2              ;

  MOVE.l   d5, a6                 ; restore Intuition base
  MOVE.l   d0, a0                 ;
  MOVE.w   d3, d0                 ; Use previouly saved GTCode
  JSR     _ItemAddress(a6)        ; (*Menu, Code) - a0/d0
  MOVE.l   d0, a0                 ;
  MOVE.l   34(a0), d0             ; EvenID

_SetGadgetID2
  MOVE.w   d0, _GTGadgetID(a5)    ; Store it

_SkipMenu2
  MOVE.l   d2, d0                 ; Restore 'class'

_EndNGadToolsIDCMP2
  MOVEM.l  (a7)+,d2-d3/a2-a3/a6   ; Restore registers
  RTS

 endfunc 26

;--------------------------------------------------------------------------------------------------

 name      "EventGadgetID" ,"()"
 flags      InLine
 amigalibs
 params
 debugger   27,_CurrentCheck

  MOVEQ    #0, d0                 ;
  MOVE.w  _GTGadgetID(a5), d0     ;
  I_RTS

 endfunc 27

;--------------------------------------------------------------------------------------------------

 name      "EventMenuID" ,"()"
 flags      InLine
 amigalibs
 params
 debugger   28,_CurrentCheck

  MOVEQ    #0, d0                 ;
  MOVE.w  _GTGadgetID(a5), d0     ;
  I_RTS

 endfunc 28

;--------------------------------------------------------------------------------------------------

 name      "EventCode","()"
 flags      InLine
 amigalibs
 params
 debugger   29,_CurrentCheck

  MOVEQ    #0, d0                 ;
  MOVE.w  _GTCode(a5), d0         ;
  I_RTS

 endfunc 29

;--------------------------------------------------------------------------------------------------

 name      "EventQualifier","()"
 flags      InLine
 amigalibs
 params
 debugger   30,_CurrentCheck

  MOVEQ    #0, d0                 ;
  MOVE.w  _GTQualifier(a5), d0    ;
  I_RTS

 endfunc 30

;--------------------------------------------------------------------------------------------------

 name      "EventWindowID","()"
 flags      InLine
 amigalibs
 params
 debugger   31,_CurrentCheck

  MOVE.l  _WindowID(a5), d0       ;
  I_RTS

 endfunc 31

;--------------------------------------------------------------------------------------------------

 name      "DetachMenu","()"
 flags     InLine
 amigalibs _IntuitionBase,a6
 params
 debugger   32,_CurrentCheck

  MOVEA.l  (a5), a0               ;
  I_JSR     _ClearMenuStrip(a6)     ; - (a0)

 endfunc 32

;--------------------------------------------------------------------------------------------------

 base
LibBase:

 Dc.l 0                           ; Active Window Ptr
 Dc.l 0                           ; Window RastPort
 Dc.l -1                          ; Object numbers
 Dc.l 0                           ; Ptr to membank
 Dc.l 0                           ; MsgPort
 Dc.l 0                           ; GadTools
 Dc.w 0                           ; GtGadgetID
 Dc.w 0                           ; GTCode
 Dc.w 0                           ; GTQualifier
 Dc.l 0                           ; WindowID
 Dc.l DefaultIDCMP                ; IDCMP Flags
 Dc.l 0                           ; TagList

;---------------------------------
; GetPosition(#Window)
; Input:  d0
; Output: a1/a3   ie. trashes a3.. (just a note to myself)
;---------------------------------
l_GetPosition:
  MOVEA.l _MemPtr(a5), a3         ;
  LSL.l    #2, d0                 ;
  ADD.l    d0, a3                 ;
  MOVE.l   (a3), a1               ;
  RTS

;---------------------------------
; CloseWindow(#Window)
; Input:  d0, d3=IntuitionBase, a6= ExecBase
; Output: --
;---------------------------------

l_CloseWindow:
  MOVEM.l d2-d3/a2-a3/a6,-(a7)    ; Save registers
  JSR     _GetPosition(a5)        ; Input d0, Result a1 - a3 store the current pos.
  MOVE.l   a1, d2                 ; Fast CMP #0, a1
  BEQ     _EndCloseWindow         ;
  CMP.l    (a5),a1                ;
  BNE     _SkipClear              ;
  CLR.l    (a5)                   ;

_SkipClear
  MOVE.l   32(a1),a0              ; param1.
  CLR.l    32(a1)                 ; clr /Title
  MOVE.l  _PB_StringPool(a4),a1   ; param2.
  PB_FreeString A2                ; (string,mempool) - a0/a1

  EXG.l    d3, a6                 ; *Exec <-> *Intuition  result: a6=Exec,d3=Intuition
  JSR     _Forbid(a6)             ;
  MOVE.l   (a3), a0               ; Re-Get window pointer
  BSR      StripWinMsg            ; Input: a0 = *Window, a6 = *Exec
  MOVE.l   (a3), a0               ; Re-Get window pointer
  CLR.l    86(a0)                 ; Clear actual UserPort
  MOVEQ.l  #0,d0                  ;
  EXG.l    d3, a6                 ; *Exec <-> *Intuition result: a6=Intuition,d3=Exec
  JSR     _ModifyIDCMP(a6)        ; a0/d0
  EXG.l    d3, a6                 ; *Exec <-> *Intuition result: a6=Exec, d3=Intuition
  JSR     _Permit(a6)             ;
  EXG.l    d3, a6                 ; *Exec <-> *Intuition result: a6=Intuition,d3=Exec
  MOVE.l   (a3), a0               ;
  JSR     _CloseWindow(a6)        ; (a0)
  CLR.l    (a3)                   ;
  
_EndCloseWindow
  MOVEM.l (a7)+,d2-d3/a2-a3/a6    ; Restore registers
  RTS

; Input: a0 = *Window
;        a6 = *Exec
;

StripWinMsg
  MOVEM.l d5/d7,-(a7)		  ; Save registers
  MOVE.l   a0, d7                 ;
  MOVE.l   86(a0), a0             ; Get Window\UserPort
  MOVE.l   20(a0), a0             ; Get mp_MsgList\Head

_StripMsgLoop
  MOVE.l   (a0), d5               ; Get next message
  CMP.l    44(a0), d7             ;
  BNE     _SkipMsg                ;
  MOVE.l   a0, a1                 ;
  MOVE.l   a1, d6                 ;
  JSR     _Remove(a6)             ; Delete the message of this window
  MOVE.l   d6, a1                 ;
  JSR     _ReplyMsg(a6)           ;

_SkipMsg
  MOVE.l   d5, a0                 ;
  TST.l    d5                     ;
  BNE     _StripMsgLoop           ;
  MOVEM.l (a7)+,d5/d7             ; Restore registers
  RTS

  Even

 endlib

;--------------------------------------------------------------------------------------------------

 startdebugger

_WindowCheck
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGT      Error1
  RTS

_InitCheck
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS

_MaxiObjCheck
  CMP.l   _ObjNum(a5),d0
  BGT      Error1
  RTS

_CurrentCheck
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _WinPtr(a5)
  BEQ      Error2
  RTS

_ExistCheck
  TST.l   _MemPtr(a5)
  BEQ      Error0
  CMP.l   _ObjNum(a5), d0
  BGT      Error1
  MOVEA.l _MemPtr(a5), a0           ; Now see if the given number
  MOVE.l   d0, d1                   ; is really initialized
  LSL.l    #2, d1                   ;
  ADD.l    d1, a0
  MOVE.l   (a0), d1
  BEQ      Error3
  RTS


Error0: debugerror "InitWindow() doesn't have been called before"
Error1: debugerror "Maximum 'Window' objects reached"
Error2: debugerror "There is no current used 'Window'"
Error3: debugerror "Specified #Window object number isn't initialized"

 enddebugger

