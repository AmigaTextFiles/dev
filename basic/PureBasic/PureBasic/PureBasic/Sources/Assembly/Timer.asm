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
; 13/05/2005 -Doobrey
;
;	FreeTimers() - changed d7->d1 for new lib rules on saving regs.
;	.. also move.l(a5)+,d1 etc is now move.l(a5),d1 and 4(a5),d0.. so no need to save a5
;     .. and changed to NoResult. 
;		
;     InitTimer()  - a5 use changed (as above), also removed d7 use, and added error check on OpenDevice()
;                    ..also now an auto init type..
;	StartTimer() - now saves a6 and does JSR/RTS instead of JMP cos a6 needs restoring.
;	StopTimer()  - now saves a6.
; Version 1.10

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


 initlib "Timer", "Timer", "FreeTimers", 0, 1, 0
;------------------------------------------------------------------------------------------
 name      "FreeTimers", "()"
 flags	NoResult
 amigalibs _ExecBase,a6
 params
 debugger  0

 MOVE.l (a5),d1
 BEQ.w   quit0           ; ..

 MOVE.l 4(a5),d0
 BEQ.w   l0              ; ...

 MOVE.l  d1,a1           ; arg1.
 MOVE.l  d1,-(a7)		 ; save d1.. gets whacked on api call
 JSR    _CloseDevice(a6) ; (ioreq) - a1
 MOVE.l (a7)+,d1		 ; restore d1...

l0
 MOVE.l  d1,a1           ; arg1.
 JMP    _FreeVec(a6)     ; (mem) - a1

quit0
 RTS

 endfunc 0
;------------------------------------------------------------------------------------------
 name		"InitTimer","()"
 flags	LongResult | InLine
 amigalibs
 params
 debugger	1
    MOVE.l 4(a5),d0
    I_RTS
 endfunc	1
;------------------------------------------------------------------------------------------

 name      "AutoInitTimer", "()"
 flags     InitFunction
 amigalibs _ExecBase,a6
 params
 debugger  2

 MOVEQ  #40,d0           ; arg1.
 MOVEQ  #1,d1            ; arg2
 SWAP   d1               ; ...
 JSR   _AllocVec(a6)     ; (size,requierments) - d0/d1

 MOVE.l d0,a1		 ; saves doing it below..
 BEQ.w  quit10           ; ...

 LEA    24(a5),a0        ; arg1.
 MOVEQ  #2,d0            ; arg2.
 MOVE.l a1,-(a7)		 ; save it..
 MOVEQ  #0,d1            ; arg4.
 JSR   _OpenDevice(a6)   ; (devname,unit,ioreq,flags) - a0/d0/a1/d1 ;-- Huh.. where`s the error check??
 MOVEA.l (a7)+,a1		 ; restore timerequest
 TST.l d0			 ; OpenDevice returns null for success..
 BNE	quit_freemem

 MOVE.l a1,(a5)

 MOVE.l 20(a1),d0
 BMI.w  quit11           ; ...

 MOVE.l d0,4(a5)
quit10
 RTS

quit_freemem		; for error on opendevice!
 JSR	_FreeVec(a6)
quit11
 CLR.l  d0               ; ...
 RTS

 endfunc 2
;------------------------------------------------------------------------------------------

 name      "StartTimer", "()"
 flags     LongResult
 amigalibs
 params
 debugger  3,Error0

 MOVE.l  a6,-(a7)		 ; save a6 ..new rules.
 MOVE.l   4(a5),a6       ; use timerbase
 LEA     16(a5),a0       ; arg1.
 JSR	   -60(a6)		; ReadEClock (eclockval) - a0
 MOVEA.l  (a7)+,a6	; restore a6...
 RTS

 endfunc 3
;------------------------------------------------------------------------------------------

 name      "StopTimer", "()"
 flags     LongResult
 amigalibs
 params
 debugger  4,Error0
 
 MOVE.l   a6,-(a7)	 ; save a6..new rules.
 MOVE.l   4(a5),a6       ; use timerbase

 LEA      8(a5),a0       ; arg1.
 JSR    -60(a6)          ; ReadEClock (eclockval) - a0
 MOVEA.l  (a7)+,a6	 ; restore a6..

 MOVE.l   4(a0),d0       ; get time2 low value
 SUB.l   12(a0),d0       ; sub time1 low value

 RTS

 endfunc 4
;------------------------------------------------------------------------------------------

 base

timerequest: Dc.l 0
timerbase:   Dc.l 0

time2:       Dc.l 0
             Dc.l 0

time1:       Dc.l 0
             Dc.l 0

dev_name:    Dc.b "timer.device",0,0

 endlib
;------------------------------------------------------------------------------------------

 startdebugger

Error0:
 TST.l   (a5)
 BEQ.w  Err0
 TST.l  4(a5)
 BEQ.w  Err0
 RTS


Err0:  DebugError "Incorrect Initcode or Lack of ErrorTest"

 enddebugger

