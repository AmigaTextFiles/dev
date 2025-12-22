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
; Joystick/Joypad (CD32) development file for PureBasic

; 04/09/2005
;  -Doobrey- Just added some save/restore of trashed regs.
;    To do : Pretty sure JoypadMovement() can be optimised with bittests instead of And.b xxx,d1
;
;
;---------------------------------------------------------------------------------------------------------
; 05/03/2000
;   Some changes (JoypadMovement)
;
; 21/02/2000
;   Added PressedRawKey()
;
; It uses the SetJoyPortAttrs() to have the fastest access possible
; to the datas. -- No More ! -- Autosense is used because joystick/joypad
; aren't the same... Pffff...
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

TAG_USER = 1 << 31

SJA_Dummy        = TAG_USER+$c00100
SJA_Type         = SJA_Dummy+1 ; force type to mouse, joy, game cntrlr
SJA_Reinitialize = SJA_Dummy+2 ; free potgo bits, reset to autosense

; Controller types for SJA_Type tag
SJA_TYPE_AUTOSENSE = 0
SJA_TYPE_GAMECTLR  = 1
SJA_TYPE_MOUSE     = 2
SJA_TYPE_JOYSTK    = 3

JPB_BUTTON_BLUE    = 23   ; Blue - Stop Right Mouse
JPB_BUTTON_RED     = 22   ; Red - Select Left Mouse Joystick Fire
JPB_BUTTON_YELLOW  = 21   ; Yellow - Repeat
JPB_BUTTON_GREEN   = 20   ; Green - Shuffle
JPB_BUTTON_FORWARD = 19   ; Charcoal - Forward
JPB_BUTTON_REVERSE = 18   ; Charcoal - Reverse
JPB_BUTTON_PLAY    = 17   ; Grey - Play/Pause Middle Mouse
JPF_BUTTON_BLUE    = 1 << JPB_BUTTON_BLUE
JPF_BUTTON_RED     = 1 << JPB_BUTTON_RED
JPF_BUTTON_YELLOW  = 1 << JPB_BUTTON_YELLOW
JPF_BUTTON_GREEN   = 1 << JPB_BUTTON_GREEN
JPF_BUTTON_FORWARD = 1 << JPB_BUTTON_FORWARD
JPF_BUTTON_REVERSE = 1 << JPB_BUTTON_REVERSE
JPF_BUTTON_PLAY    = 1 << JPB_BUTTON_PLAY
JP_BUTTON_MASK     = JPF_BUTTON_BLUE | JPF_BUTTON_RED | JPF_BUTTON_YELLOW | JPF_BUTTON_GREEN | JPF_BUTTON_FORWARD | JPF_BUTTON_REVERSE | JPF_BUTTON_PLAY


JPB_JOY_UP        = 3
JPB_JOY_DOWN      = 2
JPB_JOY_LEFT      = 1
JPB_JOY_RIGHT     = 0
JPF_JOY_UP        = 1 << JPB_JOY_UP
JPF_JOY_DOWN      = 1 << JPB_JOY_DOWN
JPF_JOY_LEFT      = 1 << JPB_JOY_LEFT
JPF_JOY_RIGHT     = 1 << JPB_JOY_RIGHT

_LowLevel = 0

; Init the library stuffs
; -----------------------
;
; In the Order:
;   * Name of the library
;   * Name of the help file in which are documented all the functions
;   * Name of the function which will be called automatically when the program end
;   * Priority of this call (small numbers = the faster it will be called)
;   * Version of the library
;   * Revision of the library (ie: 0.12 here)
;

 initlib "Joypad", "Joypad", "FreeJoypads", 0, 1, 0

;-------------------------------------------------------------------------------------------------------
;
; The functions...
;

 name      "InitJoypad", "()"
 flags
 amigalibs _ExecBase, a6
 params
 debugger  1

  LEA.l   _LowLevelName(pc), a1 ;
  MOVEQ.l  #40, d0              ; V40+
  JSR     _OpenLibrary(a6)      ; (*LibraryName, Version) - a1/d0
  MOVE.l   d0, _LowLevel(a5)    ;
  TST.l    d0
  BEQ     _InitJoypad_End
  ;MOVE.l   d0, a6   ; Doobrey: Not needed cos lowlevel calls were commented out below!
  MOVEQ.l  #-1, d0

  ;LEA.l   _SetJoyPortTags(pc),a1
  ;JSR     _SetJoyPortAttrsA(a6)
  ;MOVEQ.l  #1, d0
  ;LEA.l   _SetJoyPortTags(pc),a1
  ;JSR     _SetJoyPortAttrsA(a6)

_InitJoypad_End:
  RTS                           ;

_LowLevelName:
  Dc.b "lowlevel.library",0
;  Even

; Doobrey: Not needed? assume so cos code is commented out above!
;_SetJoyPortTags:
;  Dc.l SJA_Type, 0 ; SJA_TYPE_JOYSTK
;  Dc.l 0,0

 endfunc   1

;-------------------------------------------------------------------------------------------------------

 name      "FreeJoypads", "()"
 flags      InLine
 amigalibs _ExecBase, a6
 params
 debugger  2

  MOVEA.l _LowLevel(a5), a1
  I_JSR     _CloseLibrary(a6)     ; (*Library) - a1

 endfunc   2
 
;-------------------------------------------------------------------------------------------------------

 name      "JoypadMovement", "(Port)"
 flags
 amigalibs
 params    d0_l
 debugger  3, _InitCheck

  MOVEM.l   d2/a6,-(a7)   ; Save registers
  MOVEA.l _LowLevel(a5),a6      ;
  JSR     _ReadJoyPort(a6)      ; (Port) - d0
  MOVE.l   d0,d2
  MOVEQ.w  #0, d0

  MOVE.l   d2,d1                ; If it's UP
  AND.b    #JPF_JOY_UP, d1      ;
  BEQ     _JoyDown              ;
  MOVEQ.w  #1,d0                ;

  MOVE.l   d2,d1                ; Test UP-RIGHT
  AND.b    #JPF_JOY_RIGHT, d1   ;
  BEQ     _JoyUpLeft            ;
  MOVEQ.w  #2,d0                ;
  RTS                           ;

_JoyUpLeft:
  MOVE.l   d2,d1                ; Or UP-LEFT
  AND.b    #JPF_JOY_LEFT, d1    ;
  BEQ     _JoyEnd               ;
  MOVEQ.w  #8,d0                ;
  MOVEM.l   (a7)+,d2/a6         ; Restore d2/a6!
  RTS                           ;

_JoyDown:
  MOVE.l   d2,d1                ; Now, It's DOWN
  AND.b    #JPF_JOY_DOWN, d1    ;
  BEQ     _JoyRight             ;
  MOVEQ.w  #5,d0                ;

  MOVE.l   d2,d1
  AND.b    #JPF_JOY_RIGHT, d1
  BEQ     _JoyDownLeft
  MOVEQ.w  #4,d0
  MOVEM.l  (a7)+,d2/a6    ; Restore d2/a6
  RTS

_JoyDownLeft:
  MOVE.l   d2,d1
  AND.b    #JPF_JOY_LEFT, d1
  BEQ     _JoyEnd
  MOVEQ.w  #6,d0
  MOVEM.l   (a7)+,d2/a6   ; Restore d2/a6
  RTS


_JoyRight:
  MOVE.l   d2,d1
  AND.b    #JPF_JOY_RIGHT, d1
  BEQ     _JoyLeft
  MOVEQ.w  #3,d0
  MOVEM.l   (a7)+,d2/a6   ; Restore d2/a6
  RTS

_JoyLeft:
  MOVE.l   d2,d1
  AND.b    #JPF_JOY_LEFT, d1
  BEQ     _JoyEnd
  MOVEQ.w  #7,d0

_JoyEnd:
  MOVEM.l  (a7)+,d2/a6    ; Restore d2/a6
  RTS                     ;

 endfunc   3

;-------------------------------------------------------------------------------------------------------

 name      "JoypadButtons", "(Port)"
 flags      LongResult
 amigalibs
 params     d0_l
 debugger   4, _InitCheck

  MOVE.l  a6,-(a7)              ; Save a6
  MOVEA.l _LowLevel(a5),a6      ;
  JSR     _ReadJoyPort(a6)      ; (Port) - d0
  AND.l    #JP_BUTTON_MASK, d0  ; We just want button report
  MOVEA.l (a7)+,a6              ; Restore a6
  RTS

 endfunc   4

;-------------------------------------------------------------------------------------------------------

 name      "PressedRawKey", "()"
 flags
 amigalibs
 params
 debugger   5, _InitCheck

  MOVE.l   a6,-(a7)   ; Save a6
  MOVEQ.l  #0, d0
  MOVEA.l _LowLevel(a5),a6      ;
  JSR     _GetKey(a6)           ; (Port) - d0
  MOVEA.l (a7)+,a6    ; Restore a6
  CMP.b    #$FF,d0
  BEQ     _NoPressedRawKey
  AND.l    #$000000FF, d0       ; We just want the pressed key...
_End_PressedRawKey:
  RTS

_NoPressedRawKey:
  MOVEQ.l  #0,d0
  RTS

 endfunc   5

;-------------------------------------------------------------------------------------------------------

;
; And the common part
;

 base

  Dc.l 0

 endlib
;-------------------------------------------------------------------------------------------------------

 startdebugger

_InitCheck:
  TST.l    (a5)
  BEQ      Error0
  RTS

Error0: debugerror "InitJoypad() doesn't have been called before or 'lowlevel.library' is missing."

 enddebugger

