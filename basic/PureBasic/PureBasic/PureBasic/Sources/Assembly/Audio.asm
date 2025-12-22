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
;  10/09/2005
;     -Doobrey- Just preserved regs
;
;
; Note: Should add debugger check on channel # in params..
; Version 1.00

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

_BeginIO=-30


 initlib "Audio", "Audio", "FreeAudios", 0, 1, 0
;---------------------------------------------------------------------------------------

 name      "FreeAudios","()"
 flags      NoResult 
 amigalibs _ExecBase,a6
 params
 debugger   0

 MOVEM.l d2-d3/d6-d7/a2,-(a7)    ; Save registers
 MOVE.l  (a5),d7
 BEQ.w   quit0             ; ...

 MOVE.w  14(a5),d6         ; get allocmask
 BEQ.w   l02               ; false

 MOVEQ   #10,d2            ; int counter
 MOVEQ   #3,d3             ; bit counter
 MOVE.l  d7,a2             ; use global
 LEA     438(a2),a2        ; ptr to AInt3

loop0
 BTST    d3,d6             ; see if channel is in use
 BEQ.w   l01               ; yes it is

 MOVE.l  d2,d0             ; arg1.
 MOVE.l  22(a2),a1         ; arg2.
 JSR    _SetIntVector(a6)  ; (intnum,interrupt) - d0/a1

l01
 SUBQ.b  #1,d2             ; dec int counter
 SUB.w   #26,a2            ; dec AInt ptr
 DBRA    d3,loop0          ; dec bit counter

l02
 TST.l 4(a5)
 BEQ.w   l03               ; false

 MOVE.l 8(a5),a1
 JSR    _CloseDevice(a6)   ; (ioreq) - a1

l03
 MOVE.l  d7,a1             ; arg1.
 JSR    _FreeVec(a6)       ; (memblock) - a1 

quit0
 MOVEM.l (a7)+,d2-d3/d6-d7/a2,-(a7)   ; Restore registers
 RTS

 endfunc 0
;---------------------------------------------------------------------------------------


 name      "InitAudio","()"
 flags      LongResult ; Can't be as InitFunction, because the result needs the be checked (if the channels are in use)
 amigalibs _ExecBase,a6
 params
 debugger   1

 ;--MOVE.l  a2,d7              ; save A2
 MOVEM.l  d2-d6/a2, -(a7)

 MOVE.l  #532,d0            ; arg1.
 MOVEQ   #1,d1              ; }
 SWAP    d1                 ; } arg2. any cleared mem wanted
 JSR    _AllocVec(a6)       ; (size,requirement) - d0/d1
 ;-- MOVE.l  d0,(a5)+           ; set global
 MOVE.l d0,(a5)
 BEQ.w   quit10             ; no mem

 ADDQ.l  #4,d0              ; ...
 MOVE.l  d0,24(a4)          ; ...
 MOVE.l  d0,a2              ; use global

 MOVEQ   #3,d0              ; loop counter
 MOVE.w  #128,d1            ; first mask bit
 MOVE.w  #160,d2            ; first offset value
 MOVEQ   #0,d3              ; ...
 BSET    #9,d3              ; #NT_INTERRUPT LSL 8
 ;--LEA     26(a5),a0          ; ptr to name
 LEA 30(a5),a0
 MOVE.l  a0,d4              ; ...
 LEA     308(a2),a0         ; ptr to data
 MOVE.l  a0,d5              ; ...
 LEA     HandlerCode(pc),a1 ; ptr to code
 MOVE.l  a1,d6              ; ...
 LEA     362(a2),a1         ; ptr into interrupt

loop10
 MOVE.w  d1,(a0)            ; set mask
 LSL.w   #1,d1              ; mask * 2
 MOVE.w  d2,4(a0)           ; set offset
 ADD.w   #16,d2             ; inc offset

 MOVEM.l d3-d6,(a1)         ; set ln_Type, ln_Pri, ln_Name, is_Data & is_Code

 LEA     12(a0),a0          ; inc sound data ptr
 LEA     26(a1),a1          ; inc interrupt ptr
 MOVE.l  a0,d5              ; ...
 DBRA    d0,loop10          ; dec counter

 ;LEA     12(a5),a0          ; arg1.
 LEA  16(a5),a0
 CLR.l   d0                 ; arg2.
 LEA     460(a2),a1         ; arg3.
 MOVE.l  a1,d6              ; ...
 CLR.l   d1                 ; arg4.
 JSR    _OpenDevice(a6)     ; (name,unit,ioreq,flag) - a0/d0/a1/d1

 MOVE.l  d6,a0              ; use ptr to *ioreq
 MOVE.w  32(a0),d0          ; get IOAudio\ioa_AllocKey
 EXT.l   d0                 ; <<<<
 BEQ.w   quit10             ; false

 ;--LEA     8(a5),a1           ; ptr to array1
 LEA  12(a5),a1
 MOVE.l  a1,34(a0)          ; set IOAudio\ioa_Data
 MOVE.b  #2,41(a0)          ; set IOAudio\ioa_Length

 ;MOVE.l  20(a0),(a5)+       ; set device
 ;MOVE.l  d6,(a5)            ; set ioreq
  MOVE.l 20(a0),4(a5)
  MOVE.l d6,8(a5)
quit10
 MOVEM.l  (a7)+,d2-d6/a2
 RTS

  CNOP 0,4  ; LW align


HandlerCode
 AND.w   (a1)+,d1         ; sort out right interrupt
 MOVE.w  d1,$9c(a0)       ; clear audio bit in intreq

 SUBQ.w  #1,(a1)+         ; dec counter
 BMI.w   q2               ; ...
 BNE.w   q1               ; ...

 MOVE.w  d1,$9a(a0)       ; clear audio bit in intena
 LSR.w   #7,d1            ; ...
 MOVE.w  d1,$96(a0)       ; stop audio dma

q1
 RTS

q2
 MOVE.w  d1,$9a(a0)       ; clear audio bit in intena
 ; set regs for repeat here
 RTS

 endfunc 1
;---------------------------------------------------------------------------------------


 name      "AllocateAudioChannels", "(Channels.w)"
 flags      LongResult ; (Channels)
 amigalibs _ExecBase,d6
 params     d0_w
 debugger   2 ;, Error1

 
 MOVEM.l d2-d5/a2/a5-a6 ,-(a7)

 MOVE.w  14(a5),d1        ; get allocmask
 AND.b   d0,d1            ; sort out what chan..
 EOR.b   d1,d0            ; to allocate
 BEQ.w   quit21           ; ...

 MOVE.l  (a5)+,d4         ; for later use
 MOVE.l  (a5)+,a6         ; - A6 hold device
 MOVE.l  (a5)+,a2         ; - A2 hold ioreq

 MOVE.b  d0,(a5)+         ; set first and second..
 MOVE.b  d0,(a5)+         ; byte in data array

 MOVE.b  #-128,9(a2)      ; set ln_Pri
 MOVE.w  #32,28(a2)       ; set io_Command to #ADCMD_ALLOCATE
 MOVE.b  #65,30(a2)       ; set io_Flags to ADIOF_NOWAIT|IOF_QUICK

 MOVE.l  a2,a1            ; arg1.
 JSR    _BeginIO(a6)      ; (ioreq) - a1

 MOVE.l  24(a2),d5        ; get allocated channels from io_Unit
 BEQ.w   quit20           ; ...

 MOVE.b  #127,9(a2)       ; set ln_Pri
 MOVE.w  #10,28(a2)       ; set io_Command to #ADCMD_SETPREC
 MOVE.b  #1,30(a2)        ; set io_Flags to IOF_QUICK

 MOVE.l  a2,a1            ; arg1.
 JSR    _BeginIO(a6)      ; (ioreq) - a1

 MOVE.l  d6,a6            ; use execbase

 MOVEQ   #10,d2           ; - D5 hold int counter
 MOVEQ   #3,d3            ; - D6 hold bit counter
 MOVE.l  d4,a2            ; use global
 LEA     438(a2),a2       ; - A2 hold ptr to AInt3

loop20
 BTST    d3,d5            ; is the chan allocated
 BEQ.w   l20              ; nop

 MOVE.l  d2,d0            ; arg1.
 MOVE.l  a2,a1            ; arg2.
 JSR    _SetIntVector(a6) ; (intnum,interrupt) - d0/a1
 MOVE.l  d0,22(a2)        ; save old inthandler

l20
 SUBQ.b  #1,d2            ; dec int counter
 SUB.w   #26,a2           ; dec interrupt ptr
 DBRA    d3,loop20        ; dec bit counter

quit20
 OR.w    d5,(a5)          ; change allocmask
 MOVE.w  d5,d0            ; set returnvalue
 EXT.l   d0               ; <<<<

quit21
 ;--MOVE.l  d7,a2            ; restore A2
 MOVEM.l (a7)+,d2-d5/a2/a5-a6
 RTS

 endfunc 2
;---------------------------------------------------------------------------------------


 name      "FreeAudioChannels", "(Channels.w)"
 flags      LongResult ; (Channels)
 amigalibs _ExecBase,d6
 params     d0_w
 debugger   3 ;, Error1

 MOVEM.l d2-d5/a2/a5-a6,-(a7)

 AND.w   14(a5),d0        ; sort out what..
 MOVE.w  d0,d4            ; chan to free
 BEQ.w   quit30           ; no one

 MOVE.l  (a5)+,d5         ; for later use
 MOVE.l  (a5)+,a6         ; - A6 hold device
 MOVE.l  (a5),a2          ; - A2 hold ioreq

 MOVE.w  d4,26(a2)        ; set chan in io_Unit
 MOVE.w  #9,28(a2)        ; set io_Command to #ADCMD_FREE
 MOVE.b  #1,30(a2)        ; set io_Flags to #IOF_QUICK

 MOVE.l  a2,a1            ; arg1.
 JSR    _BeginIO(a6)      ; (ioreq) - a1

 MOVE.l  d6,a6            ; use execbase

 ; maybe intvectors should be earlyer.

 MOVEQ   #10,d2           ; - D4 hold int counter
 MOVEQ   #3,d3            ; - D5 hold bit counter
 MOVE.l  d5,a2            ; use global
 LEA     438(a2),a2       ; - A2 hold ptr to AInt3

loop30
 BTST    d3,d4            ; is chan in use
 BEQ.w   l30              ; nop

 MOVE.l  d2,d0            ; arg1.
 MOVE.l  22(a2),a1        ; arg2.
 JSR    _SetIntVector(a6) ; (intnum,interrupt) - d0/a1

l30
 SUBQ.b  #1,d2            ; dec int counter
 SUB.w   #26,a2           ; dec interrupt ptr
 DBRA    d3,loop30        ; dec bit counter and loop if > -1

 EOR.w   d4,6(a5)         ; change allocmask
 MOVE.w  d4,d0            ; set returnvalue
 EXT.l   d0               ; <<<<

quit30
 ;--MOVE.l  d7,a2            ; restore A2
 MOVEM.l (a7)+,d2-d5/a2/a5-a6
 RTS

 endfunc 3
;---------------------------------------------------------------------------------------


 name      "UseAsSoundChannels", "(Channels.w)"
 flags  NoResult
 amigalibs
 params     d0_w
 debugger   4 ;, Error1

 MOVE.l  (a5),a0          ; get global
 AND.w   14(a5),d0        ; are the channels allocated
 MOVE.w  d0,(a0)          ; set new Sound chanmask
 RTS

 endfunc 4
;---------------------------------------------------------------------------------------


 name      "UseAsPTModuleChannels", "(Channels.w)"
 flags  NoResult
 amigalibs
 params     d0_w
 debugger   5 ;, Error1

 MOVE.l  (a5),a0          ; get global
 AND.w   14(a5),d0        ; are the channels allocated
 MOVE.w  d0,2(a0)         ; set new PTModule chanmask
 RTS

 endfunc 5
;---------------------------------------------------------------------------------------


 base

global:     Dc.l 0 ; 4
device:     Dc.l 0 ; 4
io_req:     Dc.l 0 ; 4

array1:     Dc.w 0 ; 2
allocmask:  Dc.w 0 ; 2

dev_name:   Dc.b "audio.device",0,0 ; 14
int_name:   Dc.b "PureBasic",0      ; 10

 endlib
;---------------------------------------------------------------------------------------


 startdebugger

;Error1
;  TST.l   (a5)
;  BEQ     Err1
;  RTS


;Err1: DebugError "InitAudio() not called, or no error check on its result."

 enddebugger

