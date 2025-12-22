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
;  -Doobrey- Ooops! changed a debugger check to preserve regs!

; 04/09/2005
;  -Doobrey  Checked over for reg usage and tidied up source.
;   TODO: look over CreateCommodityObject()! Ppossible bug, d4 used but not set anywhere first!



 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


 initlib "Commodity", "Commodity", "FreeCommoditys", 0, 1, 0

;--------------------------------------------------------------------------------------

 name "FreeCommoditys","()"
 flags ; No Returnvalue
 amigalibs _ExecBase,a6
 params
 debugger 1

  MOVEM.l  d6-d7/a5,-(a7)
.FreeCommoditys
  MOVE.l  (a5)+,d0            ; get *objbase.
  BEQ.w   quit                ; false

  MOVE.l  d0,a1               ; arg1.
  JSR    _FreeVec(a6)         ; (*memblock) - a1

  MOVE.l  (a5)+,d7            ; get *cxbase.
  BEQ.w   quit                ; false

  MOVE.l  (a5)+,d6            ; get *msgport
  BEQ.w   l1                  ; false

  MOVE.l  (a5),d0             ; get *broker
  BEQ.w   loop                ; false

  MOVE.l  d0,a0               ; arg1.
  EXG.l   d7,a6               ; use cxbase
  JSR    _DeleteCxObjAll(a6)  ; (*broker) - a0
  EXG.l   d7,a6               ; use execbase

loop
  MOVE.l  d6,a0               ; arg1.
  JSR    _GetMsg(a6)          ; (*msgport) - a0
  TST.l   d0                  ; *message
  BEQ.w   l0                  ; quit if *message = 0

  MOVE.l  d0,a1               ; *message
  JSR    _ReplyMsg(a6)        ; (*message) - a1
  BRA     loop                ;

l0
  MOVE.l  d6,a0               ; arg1.
  JSR    _DeleteMsgPort(a6)   ; (*msgport) - a0

l1
  MOVE.l  d7,a1               ; arg1.
  JSR    _CloseLibrary(a6)    ; (*library) - a1

quit
  MOVEM.l (a7)+,d6-d7/a5    ; Restore registers
  RTS

 endfunc 1

;--------------------------------------------------------------------------------------

 name "InitCommodity","(Objects.l,Name$,Title$,Description$,Flag.w,Priority.b)"
 flags ByteResult ; Return signal from msgport
 amigalibs _ExecBase,a6
 params d0_l,d1_l,d2_l,d3_l,d4_w,d5_b
 debugger 2,Error1

  MOVEM.l d7/a2/a5,-(a7)   ; Save registers.
.InitCommodity
  MOVE.l  d1,d7               ; save D1 to D7

  ADDQ.w  #1,d0               ; at least one object
  LSL.w   #4,d0               ; arg1. (objects * 16 = needed mem)
  MOVEQ   #1,d1               ; instead of -> MOVE.l #$10000,d1
  SWAP    d1                  ; arg2.
  JSR    _AllocVec(a6)        ; (size, requierments) - d0/d1
  MOVE.l  d0,(a5)+            ; set *objbase
  BEQ.w   quit11              ; no mem allocated

  LEA     50(a5),a2           ; ptr to NewBroker

  MOVE.l  d7,(a2)+            ; name
  MOVE.l  d2,(a2)+            ; title
  MOVE.l  d3,(a2)+            ; discr
  ADDQ.w  #2,a2               ; upcount
  MOVE.w  d4,(a2)+            ; flags
  LSL.w   #8,d5               ; make a word
  MOVE.w  d5,(a2)+            ; pri

  LEA     24(a5),a1           ; arg1.
  CLR.l   d0                  ; arg2.
  JSR    _OpenLibrary(a6)     ; (*name, version) - a1/d0
  MOVE.l  d0,(a5)             ; set *cxbase
  BEQ.w   quit10              ; couldn't open library

  JSR    _CreateMsgPort(a6)   ; ()
  MOVE.l  (a5)+,a6            ; use *cxbase
  MOVE.l  d0,(a5)+            ; set *msgport
  BEQ.w   quit10              ; couldn't open msgport

  MOVE.l  d0,(a2)             ; *msgport to NewBroker
  MOVE.l  d0,a2               ; use *msgport

  LEA     40(a5),a0           ; arg1.
  CLR.l   d0                  ; arg2.
  JSR    _CxBroker(a6)        ; (*newbroker, *long) - a0/d0
  MOVE.l  d0,(a5)+            ; set *broker
  BEQ.w   quit10              ;

  MOVE.b  15(a2),d0           ; get *port/sigbit
  MOVE.l  (a5),d1             ; get sigmask
  BSET    d0,d1               ; manipulate mask
  MOVE.l  d1,(a5)             ; set sigmask

quit10
quit11
  MOVEM.l (a7)+,d7/a2/a5   ; Restore registers.
  RTS

 endfunc 2

;--------------------------------------------------------------------------------------

 name "ActivateCommodity","(Status.l)"
 flags InLine; No Return Value
 amigalibs
 params d0_l
 debugger 3,Error2

.ActivateCommodity
  MOVE.l  a6,-(a7)
  MOVE.l  4(a5),a6            ; use *cxbase
  MOVE.l  12(a5),a0           ; arg1.
  JSR    _ActivateCxObj(a6)   ; (*object, true/false) - a0/d0
  MOVEA.l (a7)+,a6
  I_RTS

 endfunc 3

;--------------------------------------------------------------------------------------

 name "CommodityEvent","()"
 flags ; Return True/False
 amigalibs _ExecBase,a6
 params
 debugger 4,Error2
 
  MOVEM.l d2/d6-d7/a5,-(a7)  ; Save registers
.PB_CommodityEvent
  MOVE.l  4(a5),d7           ; - D7 hold *cxbase
  MOVE.l  8(a5),d6           ; - D6 hold *brport
  ADD.w   #16,a5             ; ptr to sigmask

  CLR.l   d0                 ; arg1.
  MOVE.l  (a5),d1            ; arg2.
  JSR    _SetSignal(a6)      ; (long, long) - d0/d1

  AND.l   (a5)+,d0           ; quit if not..
  BEQ.w   quit31             ; any signal

  MOVE.l  d0,(a5)+           ; set signals

loop30
  MOVE.l  d6,a0              ; arg1.
  JSR    _GetMsg(a6)         ; (*msgport) - a0
  MOVE.l  d0,d2              ; *message
  BEQ.w   quit30             ; quit if *message = 0

  EXG.l   d7,a6              ; use *cxbase.

  MOVE.l  d2,a0              ; arg1.
  JSR    _CxMsgType(a6)      ; (*message) - a0
  MOVE.w  d0,(a5)            ; set msgtype.

  MOVE.l  d2,a0              ; arg1.
  JSR    _CxMsgID(a6)        ; (*message) - a0
  MOVE.w  d0,2(a5)           ; set msgid.

  EXG.l   d7,a6              ; use *execbase

  MOVE.l  d2,a1              ; *message
  JSR    _ReplyMsg(a6)       ; (*message) - a1
  BRA     loop30             ;

quit30
  MOVEQ   #1,d0              ;
quit31
  MOVEM.l (a7)+,d2/d6-d7/a5  ; Restore registers.
  RTS

 endfunc 4
;--------------------------------------------------------------------------------------

 name "WaitCommodityEvent","()"
 flags ; No Return Value
 amigalibs _ExecBase,a6
 params
 debugger 5,Error2

  MOVEM.l d2/d6-d7/a5,-(a7)  ; Save registers

.WaitCommodityEvent
  MOVE.l  4(a5),d7           ; - D7 hold *cxbase
  MOVE.l  8(a5),d6           ; - D6 hold *brport
  ADD.w   #16,a5             ; ptr to sigmask

  MOVE.l  (a5),d0            ; arg1.
  JSR    _Wait(a6)           ; (signal) - d0

  AND.l   (a5)+,d0           ; quit if not
  BEQ.w   quit40             ; any signal

  MOVE.l  d0,(a5)+           ; set signals

loop40
  MOVE.l  d6,a0              ; arg1.
  JSR    _GetMsg(a6)         ; (*msgport) - a0
  MOVE.l  d0,d2              ; *message
  BEQ.w   quit40             ; quit if *message = 0

  EXG.l   d7,a6              ; use *cxbase

  MOVE.l  d2,a0              ; arg1.
  JSR    _CxMsgType(a6)      ; (*message) - a0
  MOVE.w  d0,(a5)            ; set msgtype.

  MOVE.l  d2,a0              ; arg1.
  JSR    _CxMsgID(a6)        ; (*message) - a0
  MOVE.w  d0,2(a5)           ; set msgid

  EXG.l   d7,a6              ; use *execbase

  MOVE.l  d2,a1              ; *message
  JSR    _ReplyMsg(a6)       ; (*message) - a1
  BRA     loop40             ;

quit40

  MOVEM.l (a7)+,d2/d6-d7/a5 ; Restore registers
  RTS

 endfunc 5
;--------------------------------------------------------------------------------------

 name "CommodityType","()"
 flags InLine                ; Return msgtype
 amigalibs
 params
 debugger 6,Error2

.CommodityType
  MOVE.w  24(a5),d0          ; return msgtype
  I_RTS

 endfunc 6

;--------------------------------------------------------------------------------------

 name "CommodityID","()"
 flags    InLine; Return msgid
 amigalibs
 params
 debugger 7,Error2

.CommodityID
  MOVE.w  26(a5),d0           ; return msgid
  I_RTS

 endfunc 7

;--------------------------------------------------------------------------------------

 name "CommoditySignal","()"
 flags InLine ; Return signal
 amigalibs
 params
 debugger 8,Error2

.CommoditySignal
  MOVE.w   20(a5),d0          ; get signal
  CLR.w    20(a5)             ; clear old signal
  I_RTS

 endfunc 8

;--------------------------------------------------------------------------------------

 name "CommodityCtrlCSignal","()"
 flags InLine  ; Return signal
 amigalibs
 params
 debugger 9,Error2

.CommodityCtrlCSignal
  MOVE.w   22(a5),d0          ; get signal
  CLR.w    22(a5)             ; clear old signal
  I_RTS

 endfunc 9

;--------------------------------------------------------------------------------------

 name "CreateCommodityObject","(#Obj.l,Filter$,*InputEvent)"
 flags ByteResult ; Return from CxObjError()
 amigalibs
 params d0_l, d1_l, d2_l
 debugger 10,Error3

.CreateCommodityObject
  MOVE.l  a7,d7              ; save A7 to D7
  MOVE.l  a2,d6              ; save A2 to D6

  CLR.l   -(a7)              ; zero
  MOVE.l  d2,-(a7)           ; inputevent
  MOVE.l  d0,-(a7)           ; id/object
  MOVE.l  8(a5),-(a7)        ; msgport
  CLR.l   -(a7)              ; zero
  MOVE.l  d1,-(a7)           ; filter

  MOVE.l  (a5)+,a2            ; calc ptr..
  LSL.w   #4,d0               ; to Obj
  ADD.w   d0,a2               ; - A2 hold ptr to Obj
  MOVE.l  (a5)+,a6            ; get *cxbase

  MOVEQ   #2,d2              ; counter
  MOVE.l  d2,d3              ; compare
  MOVE.l  a2,d5              ; save ptr to Obj
  ADD.w   #40,a5             ; ptr to object types

loop90
  CLR.l   d0                 ; ready for a byte
  MOVE.b  (a5)+,d0           ; arg1.
  MOVE.l  (a7)+,a0           ; arg2.
  MOVE.l  (a7)+,a1           ; arg3.
  JSR    _CreateCxObj(a6)    ; (type, arg1, arg2) - d0/a0/a1
  MOVE.l  d0,(a2)+           ; set *object.
  BEQ.w   quit90             ; couldn't create object.

  MOVE.l  d4,a0              ; arg1.  ; Doobrey: Where did d4 come from ?
  MOVE.l  d0,a1              ; arg2.

  CMP.b   d2,d3              ; check counter
  BNE.w   l90                ;
  MOVE.l  d0,d4              ; save *filter
  MOVE.l  -37(a5),a0         ; arg1. (first time)

l90
  JSR    _AttachCxObj(a6)    ; (*headobj, *obj) - a0/a1
  DBRA    d2,loop90          ; loop until counter = -1

  MOVE.l  d2,(a2)            ; set translaterstatus to true
  MOVE.l  d6,a2              ; restore A2

  MOVE.l  d4,a0              ; arg1.
  JMP    _CxObjError(a6)     ; (*headobj) - a0
  ; Doobrey: Change JMP to JSR and restore regs? STACK NOT RESTORED !

quit90
  MOVE.l  d7,a7              ; restore stackptr

  MOVE.l  d5,a2              ; get ptr to Obj

  MOVE.l  (a2),a0            ; arg1.
  CLR.l   (a2)+              ; clear *filter
  CLR.l   (a2)+              ; clear *sender
  CLR.l   (a2)               ; clear *translater
  JSR    _DeleteCxObjAll(a6) ; (*headobj) - a0

  MOVE.l  d6,a2              ; restore A2
  MOVEQ   #1,d0              ; set error
  RTS

 endfunc 10

;--------------------------------------------------------------------------------------

 name "FreeCommodityObject","(#Obj.l)"
 flags ; No Return Value
 amigalibs
 params d0_l
 debugger 11,Error3

.FreeCommodityObject
  MOVE.l  a6,-(a7)             ; Save a6
  MOVE.l  (a5)+,a1             ; calc ptr..
  LSL.w   #4,d0                ; to Obj
  ADD.w   d0,a1                ; - A1 hold ptr to Obj
  MOVE.l  (a5),a6              ; get *cxbase

  MOVE.l  (a1),a0              ; arg1.
  CLR.l   (a1)+                ; clear *filter
  CLR.l   (a1)+                ; clear *sender
  CLR.l   (a1)                 ; clear *translater
  JSR    _DeleteCxObjAll(a6)   ; (*headobj) - a0
  MOVEA.l  (a7)+,a6            ; Restore a6

  RTS
 endfunc 11

;--------------------------------------------------------------------------------------

 name "ActivateCommodityObject","(#Obj.l,Status.l)"
 flags ; No Return Value
 amigalibs
 params d0_l,d1_l
 debugger 12,Error3

.ActivateCommodityObject
  MOVEM.l d2-d3/a2/a5-a6,-(a7); Save registers.

  MOVE.l  (a5)+,a2            ; calc ptr..
  LSL.w   #4,d0               ; to Obj
  ADD.w   d0,a2               ; - A2 hold ptr to Obj
  MOVE.l  (a5)+,a6            ; get *cxbase

  MOVEQ   #2,d2               ; counter
  MOVE.l  d1,d3               ; save activation status

loopB0
  MOVE.l  (a2)+,a0            ; arg1.
  MOVE.l  d3,d0               ; arg2.

  TST.b   d2                  ; if counter is zero then..
  BNE.w   lB0                 ; use Obj/TranslaterStatus
  MOVE.l  (a2),d0             ; arg2.

lB0
  JSR    _ActivateCxObj(a6)   ; (*object, true/false) - a0/d0
  DBRA    d2,loopB0           ; dec counter

  MOVEM.l (a7)+,d2-d3/a2/a5-a6     ; Restore registers.
  RTS

 endfunc 12

;--------------------------------------------------------------------------------------

 name "ChangeCommodityFilter","(#Obj.l,Filter$)"
 flags ByteResult ; Return from CxObjError()
 amigalibs
 params d0_l,d1_l
 debugger 13,Error3

.ChangeCommodityFilter
  MOVEM.l a2/a5-a6,-(a7)      ; Save registers

  MOVE.l  (a5)+,a2            ; calc ptr..
  LSL.w   #4,d0               ; to Obj
  ADD.w   d0,a2               ; - A2 hold ptr to Obj
  MOVE.l  (a5)+,a6            ; get *cxbase

  MOVE.l  (a2),a0             ; arg1.
  MOVE.l  d1,a1               ; arg2.
  JSR    _SetFilter(a6)       ; (*object, *inputxpression) - a0/a1

  MOVE.l  (a2),a0             ; arg1.
  JSR    _CxObjError(a6)      ; (*headobj) - a0
  MOVEM.l (a7)+,a2/a5-a6      ; Restore registers
  RTS

 endfunc 13

;--------------------------------------------------------------------------------------

 name "ChangeCommodityFilterIX","(#Obj.l,*InputXpression)"
 flags ByteResult ; Return from CxObjError()
 amigalibs
 params d0_l,d1_l
 debugger 14,Error3

.ChangeCommodityFilterIX
  
  MOVEM.l a2/a5-a6,-(a7)      ; Save registers

  MOVE.l  (a5)+,a2            ; calc ptr..
  LSL.w   #4,d0               ; to Obj
  ADD.w   d0,a2               ; - A2 hold ptr to Obj
  MOVE.l  (a5),a6

  MOVE.l  (a2),a0             ; arg1.
  MOVE.l  d1,a1               ; arg2.
  JSR    _SetFilterIX(a6)     ; (*object, *inputxpression) - a0/a1

  MOVE.l  (a2),a0             ; arg1.
  JSR    _CxObjError(a6)      ; (*headobj) - a0 ; was JMP
  MOVEM.l (a7)+,a2/a5/a6      ; Restore registers
  RTS

 endfunc 14

;--------------------------------------------------------------------------------------

 name "ActivateCommodityTranslater","(#Obj.l,Status.l)"
 flags ; No Return Value
 amigalibs
 params d0_l,d1_l
 debugger 15,Error3

.ActivateCommodityTranslater
  MOVEM.l a5-a6,-(a7)       ; Save registers
  MOVE.l  (a5)+,a1            ; calc ptr..
  LSL.w   #4,d0               ; to Obj
  ADD.w   d0,a1               ; - A1 hold ptr to Obj
  MOVE.l (a5),a6

  ADDQ.w  #8,a1               ; Obj/Translater

  MOVE.l  (a1)+,a0            ; arg1.
  MOVE.l  d1,d0               ; arg2.
  MOVE.l  d1,(a1)             ; set Obj/TranslaterStatus

  JSR    _ActivateCxObj(a6)   ; (*object, true/false) - a0/d0
  MOVEM.l (a7)+,a5-a6         ; Restore registers
  RTS

 endfunc 15

;--------------------------------------------------------------------------------------

 name "ChangeCommodityTranslater","(#Obj.l,*InputEvent)"
 flags ; No Return Value
 amigalibs
 params d0_l,d1_l
 debugger 16,Error3

.ChangeCommodityTranslater
  MOVEM.l a5-a6,-(a7)         ; Save registers
  MOVE.l  (a5)+,a0            ; calc ptr..
  LSL.w   #4,d0               ; to Obj
  ADD.w   d0,a0               ; - A1 hold ptr to Obj
  MOVE.l  (a5),a6             ; No need to increment a5!
  MOVE.l  8(a0),a0            ; arg1.
  MOVE.l  d1,a1               ; arg2.
  JSR    _SetTranslate(a6)    ; (*object, *InputEvent) - a0/a1
  MOVEM.l (a7)+,a5-a6         ; Restore
  RTS

 endfunc 16

;--------------------------------------------------------------------------------------

 name "AddCommodityInputEvent","(*InputEvent)"
 flags InLine ; No Return Value
 amigalibs
 params a0_l
 debugger 17,Error2

.AddCommodityInputEvent
  MOVE.l  a6,-(a7)
  MOVE.l  4(a5),a6             ; use *cxbase
  JSR    _AddIEvents(a6)       ; (*InputEvent) - a0
  MOVEA.l (a7)+,a6
  I_RTS

 endfunc 17
;--------------------------------------------------------------------------------------

 base

objbase:  Dc.l  0
cxbase:   Dc.l  0
brport:   Dc.l  0
broker:   Dc.l  0

sigmask:  Dc.l  1 << 12
signal:   Dc.w  0
ctrlc:    Dc.w  0

msgtype:  Dc.w  0
msgid:    Dc.w  0

libname:  Dc.b "commodities.library",0

StdObj:   Dc.b 1, 3, 5, 0

  Dc.b    5,0 ; version
  Dc.l    0   ; name
  Dc.l    0   ; title
  Dc.l    0   ; discr
  Dc.w    3   ; uniquie
  Dc.w    0   ; flags
  Dc.b    0,0 ; pri
  Dc.l    0   ; port
  Dc.w    0   ; reseved  ; total size 26 byte

 endlib

;--------------------------------------------------------------------------------------

 startdebugger

Error1 ; Init error check

  MOVE.l d7,-(a7) ; Save registers
  TST.l   d0
  BMI.w   _Do_Err10
  CMP.l   #2046,d0
  BGT.w   _Do_Err10
  LEA     maxobj(pc),a0
  MOVE.l  d0,(a0)
  MOVE.l  d1,a0
  MOVEQ   #-1,d7
strlen1
  ADDQ.l  #1,d7
  TST.b   (a0)+
  BNE.w   strlen1
  CMP.l   #24,d7
  BGT.w   _Do_Err11
  MOVE.l  d2,a0
  MOVEQ   #-1,d7
strlen2
  ADDQ.l  #1,d7
  TST.b   (a0)+
  BNE.w   strlen2
  CMP.l   #40,d7
  BGT.w   _Do_Err11
  MOVE.l  d3,a0
  MOVEQ   #-1,d7
strlen3
  ADDQ.l  #1,d7
  TST.b   (a0)+
  BNE.w   strlen3
  CMP.l   #40,d7
  BGT.w   _Do_Err11
  TST.b   d4
  BEQ.w   errquit
  CMPI.b  #4,d4
  BEQ.w   errquit
  BRA     _Do_Err12

errquit
  MOVE.l (a7)+,d7  ; Restore d7
  RTS

_Do_Err10
  MOVE.l (a7)+,d7
  BRA Err10

_Do_Err11
  MOVE.l (a7)+,d7
  BRA Err11

_Do_Err12
  MOVE.l (a7)+,d7
  BRA Err12


Error2 ; Check if Init routine was succesful
  TST.l   (a5)
  BEQ.w   Err20
  TST.l   4(a5)
  BEQ.w   Err20
  TST.l   8(a5)
  BEQ.w   Err20
  TST.l   12(a5)
  BEQ.w   Err20
  RTS


Error3 ; Object error check
  BSR     Error2
  TST.l   d0
  BMI.w   Err30
  LEA     maxobj(pc),a0
  CMP.l   (a0),d0
  BGT.w   Err30
  RTS


Err10: DebugError "Can't Allocate Objects"
Err11: DebugError "String To Long"
Err12: DebugError "'Flag' must be zero (0) or #COF_SHOW_HIDE (4)"

Err20: DebugError "Incorrect InitCode or Lack of ErrorTest"
Err30: DebugError "Object out of Range"

maxobj: Dc.l 0


 enddebugger

