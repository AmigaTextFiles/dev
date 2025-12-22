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
; 10/09/2005
;      -Doobrey-  Just small changes to preserve registers (commands and debug tests)

;---------------------------------------------------------------------------------------------------------

; Version 1.00
 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

VTAG_END_CM       = 0
VTAG_USERCLIP_SET = $80000024


 initlib  "Rainbow", "Rainbow", "FreeRainbows", 0, 1, 0

;---------------------------------------------------------------------------------------------------------
; Trashes d2,d6 a2,a6

 name      "FreeRainbows", "()"
 flags
 amigalibs _GraphicsBase,a6, _ExecBase,d7
 params
 debugger   0

 MOVE.l   (a5),d6               ; ...
 BEQ      FRs_End               ; ...

 MOVE.l   d6,a2                 ; - A2 hold #Rainbows
 MOVE.l   4(a5),d2              ; get nr_obj

FRs_loop0
 MOVE.l   (a2)+,20(a5)          ; put \uCopList in UCopIns
 BEQ      FRs_l0                ; nothing to free

 TST.l    (a2)                  ; test \Screen
 BNE      FRs_l0                ; ...

 MOVE.l   a5,a0                 ; arg1.
 JSR     _FreeVPortCopLists(a6) ; (viewport) - a0

FRs_l0
 LEA      4(a2),a2              ; inc #Rainbows
 DBRA     d2,FRs_loop0          ; ...

 MOVE.l   d7,a6                 ; use execbase

 MOVE.l   d6,a1                 ; arg1.
 JMP     _FreeVec(a6)           ; (memblock) - a1

FRs_End
 RTS

 endfunc 0

;---------------------------------------------------------------------------------------------------------

 name      "InitRainbow", "(Rainbows.l)"
 flags      LongResult
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   1, Error0

 MOVEM.l  d7/a5,-(a7)  ; Save registers
 MOVE.l   d0,d7        ; use later

 ADDQ.l   #1,d0        ; arg1.
 LSL.l    #3,d0        ; ...
 MOVEQ    #1,d1        ; ...
 SWAP     d1           ; arg2.
 JSR     _AllocVec(a6) ; (size,req) - d0/d1

 MOVE.l   d0,(a5)+     ; set objbase
 MOVE.l   d7,(a5)      ; set nr_obj
 MOVEM.l (a7)+,d7/a5
 RTS

 endfunc 1

;---------------------------------------------------------------------------------------------------------

 name      "CreateRainbow", "(#Rainbow.l,NumOfCol.l)"
 flags      LongResult
 amigalibs _ExecBase,a6, _GraphicsBase,d7
 params     d0_l, d1_w
 debugger   2, Error1

 MOVEM.l d6-d7/a2,-(a7)	      ; Save registers

 MOVE.l   (a5),a2             ; ...
 LSL.l    #3,d0               ; ...
 ADD.l    d0,a2               ; - A2 hold #Rainbow

 MULU.w   #5,d1               ; color * 5
 MOVE.l   d1,d6               ; use later

 MOVEQ    #12,d0              ; arg1.
 MOVEQ    #1,d1               ; ...
 SWAP     d1                  ; arg2.
 JSR     _AllocVec(a6)        ; (size,req) - d0/d1

 MOVE.l   d0,(a2)             ; set \uCopList
 BEQ      CR_End              ; ...

 CLR.l    4(a2)               ; clr \Screen
 EXG.l    d7,a6               ; use gfxbase

 MOVE.l   d0,a0               ; arg1.
 MOVE.l   d6,d0               ; arg2.
 JSR     _UCopperListInit(a6) ; (ucop,numins) - a0/d0

 TST.l    d0                  ; ...
 BNE      CR_End              ; ...

 MOVE.l   d7,a6               ; use execbase

 MOVE.l   (a2),a1             ; arg1.
 CLR.l    (a2)                ; clr \uCopList
 JSR     _FreeVec(a6)         ; (memblock) - a1

 CLR.l    d0                  ; ...

CR_End
 MOVEM.l (a7)+,d6-d7/a2	      ; Restore registers
 RTS

 endfunc 2

;---------------------------------------------------------------------------------------------------------

 name      "FreeRainbow", "(#Rainbow.l)"
 flags
 amigalibs _GraphicsBase,a6
 params     d0_l
 debugger   3, Error2

 MOVE.l   (a5),a0               ; ...
 LSL.l    #3,d0                 ; ...
 ADD.l    d0,a0                 ; - A0 hold #Rainbow

 MOVE.l   (a0),20(a5)           ; put \uCopList in UCopIns
 CLR.l    (a0)+                 ; clr \uCopList
 MOVE.l   (a0),a0               ; get \Screen
 CLR.l    64(a0)                ; clr Screen\ViewPort\UCopIns

 MOVE.l   a5,a0                 ; arg1.
 JMP     _FreeVPortCopLists(a6) ; (viewport) - a0

 endfunc 3

;---------------------------------------------------------------------------------------------------------

 name      "RainbowColor", "(#Rainbow.l,Height.w,Red.b,Green.b,Blue.b)"
 flags
 amigalibs _GraphicsBase,a6
 params     d0_l, d1_w, d2_b, d3_b, d4_b
 debugger   4, Error2

 
 MOVEM.l d2-d7,-(a7)		; Save registers
 MOVE.l   (a5),a0               ; ...
 LSL.l    #3,d0                 ; ...
 ADD.l    d0,a0                 ; - A0 hold #Rainbow

 MOVE.b   d2,d5                 ; red
 ANDI.w   #$f0,d2               ; hi red
 ANDI.w   #$0f,d5               ; lo red
 LSL.w    #4,d5                 ; ...

 MOVE.b   d3,d6                 ; green
 LSR.b    #4,d3                 ; hi green
 ANDI.b   #$0f,d6               ; lo green

 MOVE.b   d4,d7                 ; blue
 LSR.b    #4,d4                 ; hi blue
 ANDI.b   #$0f,d7               ; lo blue

 OR.b     d3,d2                 ; add lo green
 LSL.w    #4,d2                 ; ...
 OR.b     d4,d2                 ; add lo blue
 OR.b     d6,d5                 ; add hi green
 LSL.w    #4,d5                 ; ...
 OR.b     d7,d5                 ; add hi blue

 MOVE.l   (a0),d7               ; get \uCopList

 MOVE.l   d7,a1                 ; arg1.
 MOVE.w   d1,d0                 ; arg2.
 CLR.w    d1                    ; arg3.
 JSR     _CWait(a6)             ; (ucop,vert,hori) - a1/d0/d1

 MOVE.l   d7,a1                 ; arg1.
 JSR     _CBump(a6)             ; (ucop) - a1

 MOVE.l   d7,a1                 ; arg1.
 MOVE.l   #$dff106,d0           ; arg2.
 CLR.w    d1                    ; arg3.
 JSR     _CMove(a6)             ; (ucop,reg,data) - a1/d0/d1

 MOVE.l   d7,a1                 ; arg1.
 JSR     _CBump(a6)             ; (ucop) - a1

 MOVE.l   d7,a1                 ; arg1.
 MOVE.l   #$dff180,d0           ; arg2.
 MOVE.w   d2,d1                 ; arg3.
 JSR     _CMove(a6)             ; (ucop,reg,data) - a1/d0/d1

 MOVE.l   d7,a1                 ; arg1.
 JSR     _CBump(a6)             ; (ucop) - a1

 MOVE.l   d7,a1                 ; arg1.
 MOVE.l   #$dff106,d0           ; arg2.
 MOVE.w   #512+128,d1           ; arg3.
 JSR     _CMove(a6)             ; (ucop,reg,data) - a1/d0/d1

 MOVE.l   d7,a1                 ; arg1.
 JSR     _CBump(a6)             ; (ucop) - a1

 MOVE.l   d7,a1                 ; arg1.
 MOVE.l   #$dff180,d0           ; arg2.
 MOVE.w   d5,d1                 ; arg3.
 JSR     _CMove(a6)             ; (ucop,reg,data) - a1/d0/d1

 MOVE.l   d7,a1                 ; arg1.
 MOVEM.l  (a7)+,d2-d7		; Restore registers

 JMP     _CBump(a6)             ; (ucop) - a1

 endfunc 4

;---------------------------------------------------------------------------------------------------------

 name      "RainbowEnd", "(#Rainbow.l)"
 flags
 amigalibs _GraphicsBase,a6
 params     d0_l
 debugger   5, Error2

 MOVE.l   (a5),a0               ; ...
 LSL.l    #3,d0                 ; ...
 ADD.l    d0,a0                 ; - A0 hold #Rainbow

 MOVE.l   (a0),a1               ; arg1.
 MOVE.w   #$2710,d0             ; arg2.
 MOVE.w   #255,d1               ; arg3.
 JMP     _CWait(a6)             ; (ucop,vert,hori) - a1/d0/d1

 endfunc 5

;---------------------------------------------------------------------------------------------------------

 name      "ShowRainbow", "(#Rainbow.l,ScreenID.l)"
 flags
 amigalibs _GraphicsBase,a6, _IntuitionBase,d7
 params     d0_l, d1_l
 debugger   6, Error2

 MOVE.l   (a5),a0               ; ...
 LSL.l    #3,d0                 ; ...
 ADD.l    d0,a0                 ; - A0 hold #Rainbow

 MOVE.l   (a0)+,d0              ; get \uCopList
 MOVE.l   d1,(a0)               ; set \Screen

 MOVE.l   d1,a0                 ; use Screen
 MOVE.l   d0,64(a0)             ; set Screen\ViewPort\UCopIns

 MOVE.l   48(a0),a0             ; arg1.
 LEA      tags(pc),a1           ; arg2.
 JSR     _VideoControl(a6)      ; (colmap,tags)

 EXG.l  d7,a6
 JSR	_RethinkDisplay(a6)
 EXG.l d7,a6
 RTS

 CNOP 0,4 ; Align tags

tags: Dc.l VTAG_USERCLIP_SET,0,VTAG_END_CM,0

 endfunc 6

;---------------------------------------------------------------------------------------------------------

 name      "HideRainbow", "(#Rainbow.l)"
 flags
 amigalibs _IntuitionBase,a6
 params     d0_l
 debugger   7, Error2

 MOVE.l   (a5),a0               ; ...
 LSL.l    #3,d0                 ; ...
 ADD.l    d0,a0                 ; - A0 hold #Rainbow

 ADDQ.l   #4,a0                 ; ...
 MOVE.l   (a0),a1               ; use \Screen
 CLR.l    (a0)                  ; clr \Screen

 CLR.l    64(a1)                ; clr Screen\ViewPort\UCopIns
 JMP     _RethinkDisplay(a6)    ; ()

 endfunc 7

;---------------------------------------------------------------------------------------------------------

 base

objbase:  Dc.l 0
nr_obj:   Dc.l 0

DspIns:   Dc.l 0
SprIns:   Dc.l 0
ClrIns:   Dc.l 0
UCopIns:  Dc.l 0

 endlib

;---------------------------------------------------------------------------------------------------------

 startdebugger

Error0:
  TST.l   d0
  BMI     Err0
  CMPI.l  #4094,d0
  BGT     Err0
  RTS

Error1:
  TST.l   (a5)
  BEQ     Err1
  TST.l   d0
  BMI     Err2
  CMP.l   4(a5),d0
  BGT     Err2

  ; MOVE.l  d0,d7
  ; LSL.l   #3,d7
  ; MOVE.l  (a5),a0
  ; ADD.l   d7,a0

  MOVE.l  d0,-(a7)  ; Doobrey: Changed to preserve regs.
  LSL.l   #3,d0
  MOVE.l  (a5),a0
  ADD.l   d0,a0
  MOVE.l (a7)+,d0	

  TST.l   (a0)
  BNE     Err3
  RTS

Error2:
  TST.l   (a5)
  BEQ     Err1
  TST.l   d0
  BMI     Err2
  CMP.l   4(a5),d0
  BGT     Err2

  ;MOVE.l  d0,d7
  ;LSL.l   #3,d7
  ;MOVE.l  (a5),a0
  ;ADD.l   d7,a0

  MOVE.l  d0,-(a7)  ; Doobrey: Changed to preserve regs.
  LSL.l   #3,d0
  MOVE.l  (a5),a0
  ADD.l   d0,a0
  MOVE.l (a7)+,d0

  TST.l   (a0)
  BEQ     Err4
  RTS

Err0: DebugError "Rainbows out of Range"
Err1: DebugError "Incorrect InitCode or Lack of ErrorTest"
Err2: DebugError "Rainbow out of Range"
Err3: DebugError "Rainbow is already Initialized"
Err4: DebugError "Rainbow are not Initialized"

 enddebugger

