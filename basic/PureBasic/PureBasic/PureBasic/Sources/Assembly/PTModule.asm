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
; 10/10/2005
;   -Doobrey- Just preserved regs in commands and debugger checks, smaller commands can be inlined now.


;-----------------------------------------------------------------------------------------------------
; Version 1.00

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

M.K. = $4D2E4B2E

PTm_SamplePtrs  =000 ; Maindata structure. Global data.
PTm_ModulePtr   =124
PTm_PattPos     =128
PTm_DMAConTemp  =130
PTm_ChanMask    =132
PTm_ChanTest    =133
PTm_Speed       =134
PTm_Counter     =135
PTm_SongPos     =136
PTm_PattBrkPos  =137
PTm_PosJumpFlag =138
PTm_PattBrkFlag =139
PTm_LowMask     =140
PTm_PtDelTime2  =141
PTm_LoopPos     =142
PTm_SyncVal     =143
PTm_OverStep    =144
PTm_PtDelTime   =145
PTm_Pad         =146

PTv_Step0       =00  ; Chantemp structure. Data for each channel.
PTv_Step2       =02
PTv_Step3       =03
PTv_SmpStart    =04
PTv_SmpRepStart =08
PTv_WaveStart   =12
PTv_SmpLength   =16
PTv_SmpFinetune =18
PTv_SmpVolume   =19
PTv_SmpRepLen   =20
PTv_DMAMask     =22
PTv_Period      =24
PTv_TPDestPer   =26
PTv_TPDir       =28
PTv_TPSpeed     =29
PTv_VibPara     =30
PTv_VibPos      =31
PTv_TremPara    =32
PTv_TremPos     =33
PTv_WaveCtrl    =34
PTv_GlissFunk   =35
PTv_SampleOffs  =36
PTv_PattPos     =37
PTv_LoopCount   =38
PTv_FunkOffs    =39


 initlib "Module", "Module", "FreePTModules", 0, 1, 0

;-------------------------------------------------------------------------------------------

 name      "FreePTModules", "()"
 flags
 amigalibs _ExecBase,a6
 params
 debugger   0

 MOVEM.l d2/d6-d7/a2/a5-a6, -(a7) ;-Save regs.
 MOVE.l  (a5)+,d7          ; get objbase
 BEQ.w   quit0             ; ...

 TST.l   38(a5)            ; test global
 BEQ     l1                ; ...

 MOVE.l  d7,a2             ; - A2 hold objbase
 MOVE.w  (a5)+,d2          ; get nr_obj

loop0
 MOVE.l  (a2)+,d0          ; get InfoPtr
 BEQ.w   l0                ; ...

 MOVE.l  d0,a1             ; arg1.
 JSR    _FreeVec(a6)       ; (mem) - a1

 MOVE.l  (a2),d0           ; get SamplePtr
 BEQ.w   l0                ; ...

 MOVE.l  d0,a1             ; arg1.
 JSR    _FreeVec(a6)       ; (mem) - a1

l0
 ADD.w   #508,a2           ; add size of obj
 DBRA    d2,loop0          ; dec counter & loop if > -1

 MOVE.w  (a5)+,d0          ; arg1.
 BMI.w   l1                ; no timer allocated

 MOVE.l  a6,d6             ; save execbase
 MOVE.l  (a5),a6           ; use cia_res

 LEA     12(a5),a1         ; arg2.
 JSR    _RemICRVector(a6)  ; (icrbit,int) - d0/a1

 MOVE.l  d6,a6             ; use execbase

l1
 MOVE.l  d7,a1             ; arg1.
 JSR    _FreeVec(a6)       ; (mem) - a1

quit0
 MOVEM.l (a7)+,d2/d6-d7/a2/a5-a6 ; Save registers.
 RTS

 endfunc 0

;-----------------------------------------------------------------------------------------------------------

 name      "InitPTModule", "(Modules.l)"
 flags
 amigalibs _ExecBase,a6
 params     d0_l
 debugger   1,Error0

 MOVEM.l d3-d6/a2/a5-a6 ,-(a7) ; Save registers

 MOVE.w  d0,d6             ; save nr_obj

 ADDQ.w  #1,d0             ; atleast one obj
 ADD.l   d0,d0             ; ...
 LSL.w   #8,d0             ; arg1.
 MOVEQ   #1,d1             ; ...   }
 SWAP    d1                ; arg2. }
 JSR    _AllocVec(a6)      ; (size,requierments) - d0/d1
 MOVE.l  d0,(a5)+          ; set objbase
 BEQ.w   quit10            ; no mem

 MOVE.l  24(a4),d0         ; passed from Audio Lib
 MOVE.l  d0,38(a5)         ; set global
 MOVE.w  d6,(a5)+          ; set nr_obj

 LEA     PB_Play(pc),a0    ; ptr to code
 MOVE.l  d0,28(a5)         ; set is_Data
 MOVE.l  a0,32(a5)         ; set is_Code

 MOVE.l  a6,d6             ; save execbase
 LEA     54(a5),a2         ; ptr to cia name

 MOVE.l  #$bfd000,d4       ; ptr to timer b
 BSR     AllocateTimer     ; ...      Trashes d3-d5/a6
 TST.b   d0                ; is timer b allocated <<<< ?
 BMI.w   l10               ; yep

 MOVE.l  d6,a6             ; use execbase
 MOVE.b  #"a",3(a2)        ; change cia name

 MOVE.l  #$bfe001,d4       ; ptr to timer a
 BSR     AllocateTimer     ; ...
 TST.b   d0                ; is timer a allocated <<<< ?
 BEQ.w   quit10            ; nop

l10
 MOVE.w  d2,(a5)+          ; set ciabit
 MOVEM.l d3-d5,(a5)        ; set cia variables

quit10
 MOVEM.l (a7)+,d3-d6/a2/a5-a6   ; Restore registers
 RTS


; Trashes d3-d5/a6 --

AllocateTimer
 MOVE.l  d4,d5             ; ...
 ADD.w   #$600,d4          ; add to tblo
 ADD.w   #$f00,d5          ; add to tcrb

 MOVE.l  a2,a1             ; arg1.
 JSR    _OpenResource(a6)  ; (name) - a1
 MOVE.l  d0,d3             ; is cia resource open
 BEQ.w   quit101           ; nop

 MOVEQ   #1,d2             ; counter
 MOVE.l  d0,a6             ; use ciabase

loop101
 MOVE.w  d2,d0             ; arg1.
 LEA     14(a5),a1         ; arg2.
 JSR    _AddICRVector(a6)  ; (icrbit,int) - d0/a1
 TST.l   d0                ; is value false then..
 BEQ.w   l101              ; a timer is allocated

 SUB.w   #$200,d4          ; dec to talo reg
 SUB.w   #$100,d5          ; dec to tcra reg

 DBRA    d2,loop101        ; dec counter loop if > -1

l101
 TST.b   d2                ; is counter plus then
 SPL     d0                ; return -1 else 0

quit101
 RTS


PB_Play
;----------------------------------------------------------------
    MOVEM.l d2-d7/a2-a4,-(a7)

    MOVE.l  a1,a4                          ; get addr to main data
    ADDQ.b  #1,PTm_Counter(a4)             ; dec frame counter
    MOVE.b  PTm_Counter(a4),d0             ; get frame counter

    CMP.b   PTm_Speed(a4),d0               ; is frame counter equal to speed
    BMI.w   PT_nonewnote                   ; nop, do effects 0-7, 10 and 14

    CLR.b   PTm_Counter(a4)                ; zero to frame counter
    TST.b   PTm_PtDelTime2(a4)             ; if zero then..
    BEQ.w   PT_getnewnote                  ; time to play some notes

    BSR     PT_nonewallchannels            ; else do the effects
    BRA     PT_dskip                       ; ????


PT_nonewnote
    BSR     PT_nonewallchannels            ; do effects
    BRA     PT_nonewposyet                 ; ????


PT_nonewallchannels
    BTST    #0,PTm_ChanTest(a4)
    BEQ     PB_skip11

    LEA     $dff0a0,a5                     ; get addr to audio chan 0
    LEA     148(a4),a6                     ; get addr to chan data
    BSR     PT_checkefx                    ; check the effects

PB_skip11
    BTST    #1,PTm_ChanTest(a4)
    BEQ     PB_skip12

    LEA     $dff0b0,a5                     ; get addr to audio chan 0
    LEA     188(a4),a6                     ; get addr to chan data
    BSR     PT_checkefx                    ; check the effects

PB_skip12
    BTST    #2,PTm_ChanTest(a4)
    BEQ     PB_skip13

    LEA     $dff0c0,a5                     ; get addr to audio chan 0
    LEA     228(a4),a6                     ; get addr to chan data
    BSR     PT_checkefx                    ; check the effects

PB_skip13
    BTST    #3,PTm_ChanTest(a4)
    BEQ     PB_skip14

    LEA     $dff0d0,a5                     ; get addr to audio chan 0
    LEA     268(a4),a6                     ; get addr to chan data
    BSR     PT_checkefx                    ; check the effects

PB_skip14
    RTS                                    ; then quit
;----------------------------------------------------------------


PT_getnewnote
;----------------------------------------------------------------
    MOVE.l  PTm_ModulePtr(a4),a0           ; get addr to the mod
    LEA     12(a0),a3                      ; calc addr to sampleinfos
    LEA     952(a0),a2                     ; calc addr to patternpos
    LEA     1084(a0),a0                    ; calc addr to patterndata
    MOVEQ   #0,d0                          ; ...
    MOVEQ   #0,d1                          ; ...
    MOVE.b  PTm_SongPos(a4),d0             ; get song pos
    MOVE.b  0(a2,d0.w),d1                  ; get pattern nr
    LSL.l   #8,d1                          ; }
    LSL.l   #2,d1                          ; } calc pattern offset
    ADD.w   PTm_PattPos(a4),d1             ; add addr of next row
    ADD.l   d1,a0                          ; ...
    CLR.b   PTm_DMAConTemp+1(a4)           ; zero to ??
    MOVE.w  -2(a4),PTm_ChanMask(a4)        ; ...

    ; !(a0,d1) points to the patterndata

    BTST    #0,PTm_ChanTest(a4)
    BEQ     PB_skip21

    LEA     $dff0a0,a5                     ; get addr to audio chan 0
    LEA     148(a4),a6                     ; get addr to chan data
    BSR     PT_playvoice                   ; play a note

PB_skip21
    ADDQ.l  #4,a0
    BTST    #1,PTm_ChanTest(a4)
    BEQ     PB_skip22

    LEA     $dff0b0,a5                     ; get addr to audio chan 0
    LEA     188(a4),a6                     ; get addr to chan data
    BSR     PT_playvoice                   ; play a note

PB_skip22
    ADDQ.l  #4,a0
    BTST    #2,PTm_ChanTest(a4)
    BEQ     PB_skip23

    LEA     $dff0c0,a5                     ; get addr to audio chan 0
    LEA     228(a4),a6                     ; get addr to chan data
    BSR     PT_playvoice                   ; play a note

PB_skip23
    ADDQ.l  #4,a0
    BTST    #3,PTm_ChanTest(a4)
    BEQ     PB_skip24

    LEA     $dff0d0,a5                     ; get addr to audio chan 0
    LEA     268(a4),a6                     ; get addr to chan data
    BSR     PT_playvoice                   ; play a note

PB_skip24
    BRA     PT_setdma                      ; jump ????
;----------------------------------------------------------------


PT_playvoice
;----------------------------------------------------------------
    TST.w   PTv_Step0(a6)                  ; test msb of smp & period
    BNE.w   PT_plvskip                     ; if anything then skip...

    MOVE.w  PTv_Period(a6),6(a5)           ; ...

PT_plvskip
    MOVE.l  (a0),PTv_Step0(a6)             ; save one track data
    MOVEQ   #0,d2                          ; ...
    MOVE.b  PTv_Step2(a6),d2               ; get low part of sample nr
    AND.b   #$f0,d2                        ; sort it out and...
    LSR.b   #4,d2                          ; put it in right place
    MOVE.b  PTv_Step0(a6),d0               ; get high part of sample nr
    AND.b   #$f0,d0                        ; sort it out
    OR.b    d0,d2                          ; put together low and high part
    BEQ.w   PT_setregs                     ; nop, use old data ?

    MOVEQ   #0,d3                          ; ...
    LEA     PTm_SamplePtrs(a4),a1          ; calc addr to samples
    MOVE.l  d2,d4                          ; save sample nr to d4

    MOVE.w  d4,d3     ; *30                ; }
    LSL.w   #5,d4                          ; } calc offset to
    ADD.w   d3,d3                          ; } right sample info
    SUB.w   d3,d4                          ; }

    SUBQ.l  #1,d2                          ; dec sample nr
    LSL.l   #2,d2                          ; calc offset to sample ptr
    MOVE.l  0(a1,d2.l),PTv_SmpStart(a6)    ; save sample ptr

    MOVE.w  0(a3,d4.l),PTv_SmpLength(a6)   ; length   }
    MOVE.b  2(a3,d4.l),PTv_SmpFinetune(a6) ; finetune }
    MOVE.b  3(a3,d4.l),PTv_SmpVolume(a6)   ; volume   }
    MOVE.w  4(a3,d4.l),d3                  ; get repeat
    BEQ.w   PT_noloop                      ; nop

    MOVE.l  PTv_SmpStart(a6),d2            ; get sample ptr
    ADD.w   d3,d3                          ; convert repeat from word to byte
    ADD.l   d3,d2                          ; add repeat to sample ptr
    MOVE.l  d2,PTv_SmpRepStart(a6)         ; save to repeat start
    MOVE.l  d2,PTv_WaveStart(a6)           ; save to wave start <<<< ?
    MOVE.w  4(a3,d4.l),d0                  ; get repeat start
    ADD.w   6(a3,d4.l),d0                  ; replen to rep start
    MOVE.w  d0,PTv_SmpLength(a6)           ; save sample length
    MOVE.w  6(a3,d4.l),PTv_SmpRepLen(a6)   ; save replen
    MOVEQ   #0,d0                          ; ...

    MOVE.b  PTv_SmpVolume(a6),d0           ; get volume

    MOVE.w  d0,8(a5)                       ; set volume in audio reg
    BRA     PT_setregs                     ; jump to ????

PT_noloop
    MOVE.l  PTv_SmpStart(a6),d2            ; get sample ptr
    ADD.l   d3,d2                          ; add repeat start to sample ptr
    MOVE.l  d2,PTv_SmpRepStart(a6)         ; save sample start
    MOVE.l  d2,PTv_WaveStart(a6)           ; save sample start
    MOVE.w  6(a3,d4.l),PTv_SmpRepLen(a6)   ; save replen
    MOVEQ   #0,d0                          ; ...
    MOVE.b  PTv_SmpVolume(a6),d0           ; get volume

    MOVE.w  d0,8(a5)                       ; set volume in audio reg
;----------------------------------------------------------------


PT_setregs
;----------------------------------------------------------------
    MOVE.w  PTv_Step0(a6),d0               ; A new note is to be played
    AND.w   #$0fff,d0                      ; is there any note
    BEQ.w   PT_checkmoreefx                ; nop, check effect instead

    MOVE.w  PTv_Step2(a6),d0               ; get all effect data
    AND.w   #$0ff0,d0                      ; sort it out to see..
    CMP.w   #$0e50,d0                      ; is it a E5 effect
    BEQ.w   PT_dosetfinetune               ; yep, jump to ????

    MOVE.b  PTv_Step2(a6),d0               ; get high bits of effect data
    AND.b   #$0f,d0                        ; sort out effect command
    CMP.b   #3,d0                          ; is it toneportamento
    BEQ.w   PT_chktoneporta                ; yep, jump to ????

    CMP.b   #5,d0                          ; is it ????
    BEQ.w   PT_chktoneporta                ; yep, jump to ????

    CMP.b   #9,d0                          ; is it sample offset
    BNE.w   PT_setperiod                   ; nop, jump to ????

    BSR     PT_checkmoreefx                ; do effect
    BRA     PT_setperiod                   ; ...


PT_dosetfinetune
    BSR     PT_setfinetune                 ; ...
    BRA     PT_setperiod                   ; ...


PT_chktoneporta
    BSR     PT_settoneporta                ; ...
    BRA     PT_checkmoreefx                ; ...
;----------------------------------------------------------------


PT_setperiod
;----------------------------------------------------------------
    MOVE.w  PTv_Step0(a6),d7               ; get ms word
    AND.w   #$0fff,d7                      ; sort out period

    LEA.l   PT_periodtable(pc),a1          ; calc addr to period table
    MOVEQ   #0,d0                          ; ...
    MOVEQ   #36,d2                         ; note counter

PT_ftuloop
    CMP.w   0(a1,d0.w),d7                  ; is notes equal
    BGE.w   PT_ftufound                    ; yes
    ADDQ.l  #2,d0                          ; inc offset
    DBRA    d2,PT_ftuloop                  ; loop again

PT_ftufound
    MOVEQ   #0,d7                          ; ...
    MOVE.b  PTv_SmpFinetune(a6),d7         ; get finetune
    MULU.w  #36*2,d7                       ; finetune * 72 <<<< ?
    ADD.l   d7,a1                          ; add offset to period table ptr
    MOVE.w  0(a1,d0.w),PTv_Period(a6)      ; set period
;----------------------------------------------------------------


;----------------------------------------------------------------
    MOVE.w  PTv_Step2(a6),d0               ; get hole effect data
    AND.w   #$0ff0,d0                      ; sort it out
    CMP.w   #$0ed0,d0                      ; is it notedelay
    BEQ.w   PT_checkmoreefx                ; yep, jump ????

    MOVE.w  PTv_DMAMask(a6),$dff096        ; Shut off DMA

    MOVEQ   #1,d0
    BSR     PB_Wait                        ; Wait for DMA to come off

    BTST    #2,PTv_WaveCtrl(a6)            ; ????
    BNE.w   PT_vibnoc                      ; ????
    CLR.b   PTv_VibPos(a6)                 ; ????

PT_vibnoc
    BTST    #6,PTv_WaveCtrl(a6)            ; ????
    BNE.w   PT_trenoc                      ; ????

    CLR.b   PTv_TremPos(a6)                ; ????

PT_trenoc
    MOVE.l  PTv_SmpStart(a6),(a5)          ; set start in audio reg
    MOVE.w  PTv_SmpLength(a6),4(a5)        ; set length in audio reg
    MOVE.w  PTv_Period(a6),6(a5)           ; set period in audio reg
    MOVE.w  PTv_DMAMask(a6),d0             ; ????
    OR.w    d0,PTm_DMAConTemp(a4)          ; ????
    BRA     PT_checkmoreefx                ; jump to effects
;----------------------------------------------------------------


PT_setdma
;----------------------------------------------------------------
    MOVEQ   #4,d0
    BSR     PB_Wait                        ; Wait for DMA to come off

;    MOVE.w  PTm_DMAConTemp(a4),d0          ; get mask
;    OR.w    #$8000,d0                      ; set set/clear bit
;    MOVE.w  d0,$dff096                     ; Enable audio DMA

    MOVE.w  PTm_DMAConTemp(a4),$dff096     ; get mask


    MOVEQ   #1,d0                          ; ...
    BSR     PB_Wait                        ; Wait for DMA to come off

    LEA     $dff000,a5                     ; ...

    BTST    #0,PTm_ChanTest(a4)
    BEQ     PB_skip31

    LEA     148(a4),a6                     ; calc addr to chan data
    MOVE.l  PTv_SmpRepStart(a6),$a0(a5)    ; set sample ptr in audio reg
    MOVE.w  PTv_SmpRepLen(a6),$a4(a5)      ; set sample len in audio reg

PB_skip31
    BTST    #1,PTm_ChanTest(a4)
    BEQ     PB_skip32

    LEA     188(a4),a6                     ; calc addr to chan data
    MOVE.l  PTv_SmpRepStart(a6),$b0(a5)    ; set sample ptr in audio reg
    MOVE.w  PTv_SmpRepLen(a6),$b4(a5)      ; set sample len in audio reg

PB_skip32
    BTST    #2,PTm_ChanTest(a4)
    BEQ     PB_skip33

    LEA     228(a4),a6                     ; calc addr to chan data
    MOVE.l  PTv_SmpRepStart(a6),$c0(a5)    ; set sample ptr in audio reg
    MOVE.w  PTv_SmpRepLen(a6),$c4(a5)      ; set sample len in audio reg

PB_skip33
    BTST    #3,PTm_ChanTest(a4)
    BEQ     PT_dskip

    LEA     268(a4),a6                     ; calc addr to chan data
    MOVE.l  PTv_SmpRepStart(a6),$d0(a5)    ; set sample ptr in audio reg
    MOVE.w  PTv_SmpRepLen(a6),$d4(a5)      ; set sample len in audio reg
;----------------------------------------------------------------


PT_dskip
;----------------------------------------------------------------
    ADD.w   #16,PTm_PattPos(a4)            ; add 16 to row ptr
    MOVE.b  PTm_PtDelTime(a4),d0           ; ????
    BEQ.w   PT_dskc                        ; ????

    MOVE.b  d0,PTm_PtDelTime2(a4)          ; ????
    CLR.b   PTm_PtDelTime(a4)              ; ????

PT_dskc
    TST.b   PTm_PtDelTime2(a4)             ; ????
    BEQ.w   PT_dska                        ; ????

    SUBQ.b  #1,PTm_PtDelTime2(a4)          ; ????
    BEQ.w   PT_dska                        ; ????

    SUB.w   #16,PTm_PattPos(a4)            ; sub 16 of row ptr

PT_dska
    TST.b   PTm_PattBrkFlag(a4)            ; is pattern breake flag set
    BEQ.w   PT_nnpysk                      ; nop

    SF      PTm_PattBrkFlag(a4)            ; ????
    MOVEQ   #0,d0                          ; ...
    MOVE.b  PTm_PattBrkPos(a4),d0          ; get break pos
    CLR.b   PTm_PattBrkPos(a4)             ; clear it

    LSL.w   #4,d0                          ; calc row to restart at
    MOVE.w  d0,PTm_PattPos(a4)             ; save it

PT_nnpysk
    CMP.w   #1024,PTm_PattPos(a4)          ; is pattern at end
    BMI.w   PT_nonewposyet                 ; nop

PT_nextposition
    MOVEQ   #0,d0                          ; ...
    MOVE.b  PTm_PattBrkPos(a4),d0          ; get break pos
    LSL.w   #4,d0                    ; ...
    MOVE.w  d0,PTm_PattPos(a4)             ; save it
    CLR.b   PTm_PattBrkPos(a4)             ; clear break pos
    CLR.b   PTm_PosJumpFlag(a4)            ; clear jump flag
    ADDQ.b  #1,PTm_SongPos(a4)             ; inc song pos
    ANDI.b  #$7f,PTm_SongPos(a4)           ; is song pos at end
    MOVE.b  PTm_SongPos(a4),d1             ; get song pos

    MOVE.l  PTm_ModulePtr(a4),a0           ; get ptr to module
    CMP.b   950(a0),d1                     ; is song pos at end of song
    BMI.w   PT_nonewposyet                 ; nop

    CLR.b   PTm_SongPos(a4)                ; clear song pos

PT_nonewposyet
    TST.b   PTm_PosJumpFlag(a4)            ; is jump flag set
    BNE.w   PT_nextposition                ; yep

PT_return                                  ; here is END of player routine
    MOVEM.l (a7)+,d2-d7/a2-a4              ; ...
    RTS
;----------------------------------------------------------------


.effects1
PT_checkefx
    BSR     PT_updatefunk
    MOVE.w  PTv_Step2(a6),d0
    AND.w   #$0fff,d0
    BEQ.w   PT_pernop
    MOVE.b  PTv_Step2(a6),d0
    AND.b   #$0f,d0
    BEQ.w   PT_arpeggio
    CMP.b   #1,d0
    BEQ.w   PT_portaup
    CMP.b   #2,d0
    BEQ.w   PT_portadown
    CMP.b   #3,d0
    BEQ.w   PT_toneportamento
    CMP.b   #4,d0
    BEQ.w   PT_vibrato
    CMP.b   #5,d0
    BEQ.w   PT_toneplusvolslide
    CMP.b   #6,d0
    BEQ.w   PT_vibratoplusvolslide
    CMP.b   #$e,d0
    BEQ.w   PT_e_commands

setback
    MOVE.w  PTv_Period(a6),6(a5)
    CMP.b   #7,d0
    BEQ.w   PT_tremolo
    CMP.b   #$a,d0
    BEQ.w   PT_volumeslide
    RTS

PT_pernop
    MOVE.w  PTv_Period(a6),6(a5)
    RTS

PT_arpeggio                              ; Effect 0: Arpeggio
    MOVEQ   #0,d0
    MOVE.b  PTm_Counter(a4),d0
    DIVS.w  #3,d0
    SWAP.w  d0
    TST.w   d0
    BEQ.w   PT_arpeggio2
    CMP.w   #2,d0
    BEQ.w   PT_arpeggio1
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    LSR.b   #4,d0
    BRA     PT_arpeggio3

PT_arpeggio1
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #15,d0
    BRA     PT_arpeggio3

PT_arpeggio2
    MOVE.w  PTv_Period(a6),d2
    BRA     PT_arpeggio4

PT_arpeggio3
    ADD.w   d0,d0
    MOVEQ   #0,d1
    MOVE.b  PTv_SmpFinetune(a6),d1
    MULU.w  #36*2,d1
    LEA     PT_periodtable(pc),a0
    ADD.l   d1,a0
    MOVEQ   #0,d1
    MOVE.w  PTv_Period(a6),d1
    MOVEQ   #36,d3

PT_arploop
    MOVE.w  0(a0,d0.w),d2
    CMP.w   (a0),d1
    BGE.w   PT_arpeggio4
    ADDQ.l  #2,a0
    DBRA    d3,PT_arploop
    RTS

PT_arpeggio4
    MOVE.w  d2,6(a5)
    RTS

PT_fineportaup                           ; Effect 1: Portamento Up
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_1
    MOVE.b  #$0f,PTm_LowMask(a4)

PT_portaup
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   PTm_LowMask(a4),d0
    MOVE.b  #$ff,PTm_LowMask(a4)
    SUB.w   d0,PTv_Period(a6)
    MOVE.w  PTv_Period(a6),d0
    AND.w   #$0fff,d0
    CMP.w   #113,d0
    BPL.w   PT_portauskip
    ANDI.w  #$f000,PTv_Period(a6)
    OR.w    #113,PTv_Period(a6)

PT_portauskip
    MOVE.w  PTv_Period(a6),d0
    AND.w   #$0fff,d0
    MOVE.w  d0,6(a5)

PT_return_1
    RTS

PT_fineportadown                         ; Effect 2: Portamento Down
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_2
    MOVE.b  #$0f,PTm_LowMask(a4)

PT_portadown
    CLR.w   d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   PTm_LowMask(a4),d0
    MOVE.b  #$ff,PTm_LowMask(a4)
    ADD.w   d0,PTv_Period(a6)
    MOVE.w  PTv_Period(a6),d0
    AND.w   #$0fff,d0
    CMP.w   #856,d0
    BMI.w   PT_portadskip
    ANDI.w  #$f000,PTv_Period(a6)
    OR.w    #856,PTv_Period(a6)

PT_portadskip
    MOVE.w  PTv_Period(a6),d0
    AND.w   #$0fff,d0
    MOVE.w  d0,6(a5)

PT_return_2
    RTS


PT_settoneporta
    MOVE.l  a0,-(a7)
    MOVE.w  PTv_Step0(a6),d2
    AND.w   #$0fff,d2
    MOVEQ   #0,d0
    MOVE.b  PTv_SmpFinetune(a6),d0
    MULU.w  #37*2,d0
    LEA     PT_periodtable(pc),a0
    ADD.l   d0,a0
    MOVEQ   #0,d0

PT_stploop
    CMP.w   0(a0,d0.w),d2
    BGE.w   PT_stpfound
    ADDQ.w  #2,d0
    CMP.w   #37*2,d0
    BMI.w   PT_stploop
    MOVEQ   #35*2,d0

PT_stpfound
    MOVE.b  PTv_SmpFinetune(a6),d2
    AND.b   #8,d2
    BEQ.w   PT_stpgoss
    TST.w   d0
    BEQ.w   PT_stpgoss
    SUBQ.w  #2,d0

PT_stpgoss
    MOVE.w  0(a0,d0.w),d2
    MOVE.l  (a7)+,a0
    MOVE.w  d2,PTv_TPDestPer(a6)
    MOVE.w  PTv_Period(a6),d0
    CLR.b   PTv_TPDir(a6)
    CMP.w   d0,d2
    BEQ.w   PT_cleartoneporta
    BGE.w   PT_return_3
    MOVE.b  #1,PTv_TPDir(a6)
    RTS

PT_cleartoneporta
    CLR.w   PTv_TPDestPer(a6)
    RTS

PT_toneportamento                        ; Effect 3: TonePortamento
    MOVE.b  PTv_Step3(a6),d0
    BEQ.w   PT_toneportnochange
    MOVE.b  d0,PTv_TPSpeed(a6)
    CLR.b   PTv_Step3(a6)

PT_toneportnochange
    TST.w   PTv_TPDestPer(a6)
    BEQ.w   PT_return_3
    MOVEQ   #0,d0
    MOVE.b  PTv_TPSpeed(a6),d0
    TST.b   PTv_TPDir(a6)
    BNE.w   PT_toneportaup

PT_toneportadown
    ADD.w   d0,PTv_Period(a6)
    MOVE.w  PTv_TPDestPer(a6),d0
    CMP.w   PTv_Period(a6),d0
    BGT.w   PT_toneportasetper
    MOVE.w  PTv_TPDestPer(a6),PTv_Period(a6)
    CLR.w   PTv_TPDestPer(a6)
    BRA     PT_toneportasetper

PT_toneportaup
    SUB.w   d0,PTv_Period(a6)
    MOVE.w  PTv_TPDestPer(a6),d0
    CMP.w   PTv_Period(a6),d0
    BLT.w   PT_toneportasetper
    MOVE.w  PTv_TPDestPer(a6),PTv_Period(a6)
    CLR.w   PTv_TPDestPer(a6)

PT_toneportasetper
    MOVE.w  PTv_Period(a6),d2
    MOVE.b  PTv_GlissFunk(a6),d0
    AND.b   #$0f,d0
    BEQ.w   PT_glissskip
    MOVEQ   #0,d0
    MOVE.b  PTv_SmpFinetune(a6),d0
    MULU.w  #36*2,d0
    LEA     PT_periodtable(pc),a0
    ADD.l   d0,a0
    MOVEQ   #0,d0

PT_glissloop
    CMP.w   0(a0,d0.w),d2
    BGE.w   PT_glissfound
    ADDQ.w  #2,d0
    CMP.w   #36*2,d0
    BMI.w   PT_glissloop
    MOVEQ   #35*2,d0

PT_glissfound
    MOVE.w  0(a0,d0.w),d2

PT_glissskip
    MOVE.w  d2,6(a5)    ; set period

PT_return_3
    RTS

PT_vibrato                               ; Effect 4: Vibrato
    MOVE.b  PTv_Step3(a6),d0
    BEQ.w   PT_vibrato2
    MOVE.b  PTv_VibPara(a6),d2
    AND.b   #$0f,d0
    BEQ.w   PT_vibskip
    AND.b   #$f0,d2
    OR.b    d0,d2

PT_vibskip
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$f0,d0
    BEQ.w   PT_vibskip2
    AND.b   #$0f,d2
    OR.b    d0,d2

PT_vibskip2
    MOVE.b  d2,PTv_VibPara(a6)

PT_vibrato2
    MOVE.b  PTv_VibPos(a6),d0
    LEA     PT_vibratotable(pc),a1
    LSR.w   #2,d0
    AND.w   #$001f,d0
    MOVEQ   #0,d2
    MOVE.b  PTv_WaveCtrl(a6),d2
    AND.b   #$03,d2
    BEQ.w   PT_vib_sine
    LSL.b   #3,d0
    CMP.b   #1,d2
    BEQ.w   PT_vib_rampdown
    MOVE.b  #255,d2
    BRA     PT_vib_set

PT_vib_rampdown
    TST.b   PTv_VibPos(a6)
    BPL.w   PT_vib_rampdown2
    MOVE.b  #255,d2
    SUB.b   d0,d2
    BRA     PT_vib_set

PT_vib_rampdown2
    MOVE.b  d0,d2
    BRA     PT_vib_set

PT_vib_sine
    MOVE.b  0(a1,d0.w),d2

PT_vib_set
    MOVE.b  PTv_VibPara(a6),d0
    AND.w   #15,d0
    MULU.w  d0,d2
    LSR.w   #7,d2
    MOVE.w  PTv_Period(a6),d0
    TST.b   PTv_VibPos(a6)
    BMI.w   PT_vibratoneg
    ADD.w   d2,d0
    BRA     PT_vibrato3

PT_vibratoneg
    SUB.w   d2,d0

PT_vibrato3
    MOVE.w  d0,6(a5)
    MOVE.b  PTv_VibPara(a6),d0
    LSR.w   #2,d0
    AND.w   #$003c,d0
    ADD.b   d0,PTv_VibPos(a6)
    RTS

PT_toneplusvolslide                      ; Effect 5: Portamento + Volume slide
    BSR     PT_toneportnochange
    BRA     PT_volumeslide

PT_vibratoplusvolslide                   ; Effect 6: Vibrato + Volume slide
    BSR     PT_vibrato2
    BRA     PT_volumeslide

PT_tremolo                               ; Effect 7: Tremolo
    MOVE.b  PTv_Step3(a6),d0
    BEQ.w   PT_tremolo2
    MOVE.b  PTv_TremPara(a6),d2
    AND.b   #$0f,d0
    BEQ.w   PT_treskip
    AND.b   #$f0,d2
    OR.b    d0,d2

PT_treskip
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$f0,d0
    BEQ.w   PT_treskip2
    AND.b   #$0f,d2
    OR.b    d0,d2

PT_treskip2
    MOVE.b  d2,PTv_TremPara(a6)

PT_tremolo2
    MOVE.b  PTv_TremPos(a6),d0
    LEA     PT_vibratotable(pc),a1
    LSR.w   #2,d0
    AND.w   #$001f,d0
    MOVEQ   #0,d2
    MOVE.b  PTv_WaveCtrl(a6),d2
    LSR.b   #4,d2
    AND.b   #$03,d2
    BEQ.w   PT_tre_sine
    LSL.b   #3,d0
    CMP.b   #1,d2
    BEQ.w   PT_tre_rampdown
    MOVE.b  #255,d2
    BRA     PT_tre_set

PT_tre_rampdown
    TST.b   PTv_VibPos(a6)
    BPL.w   PT_tre_rampdown2
    MOVE.b  #255,d2
    SUB.b   d0,d2
    BRA     PT_tre_set

PT_tre_rampdown2
    MOVE.b  d0,d2
    BRA     PT_tre_set

PT_tre_sine
    MOVE.b  0(a1,d0.w),d2

PT_tre_set
    MOVE.b  PTv_TremPara(a6),d0
    AND.w   #15,d0
    MULU.w  d0,d2
    LSR.w   #6,d2
    MOVEQ   #0,d0
    MOVE.b  PTv_SmpVolume(a6),d0
    TST.b   PTv_TremPos(a6)
    BMI.w   PT_tremoloneg
    ADD.w   d2,d0
    BRA     PT_tremolo3

PT_tremoloneg
    SUB.w   d2,d0

PT_tremolo3
    BPL.w   PT_tremoloskip
    CLR.w   d0

PT_tremoloskip
    CMP.w   #$40,d0
    BLS.w   PT_tremolook
    MOVE.w  #$40,d0

PT_tremolook
    MOVE.w  d0,8(a5)
    MOVE.b  PTv_TremPara(a6),d0
    LSR.w   #2,d0
    AND.w   #$003c,d0
    ADD.b   d0,PTv_TremPos(a6)
    RTS

PT_syncval                               ; Effect 8: ????
    MOVE.b  PTv_Step3(a6),PTm_SyncVal(a4)
    RTS

PT_sampleoffset                          ; Effect 9: Sample Offset
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    BEQ.w   PT_sononew
    MOVE.b  d0,PTv_SampleOffs(a6)

PT_sononew
    MOVE.b  PTv_SampleOffs(a6),d0
    LSL.w   #7,d0
    CMP.w   PTv_SmpLength(a6),d0
    BGE.w   PT_sofskip
    SUB.w   d0,PTv_SmpLength(a6)
    ADD.w   d0,d0
    ADD.l   d0,PTv_SmpStart(a6)
    RTS

PT_sofskip
    MOVE.w  #$0001,PTv_SmpLength(a6)
    RTS

PT_volumeslide                           ; Effect A: Volume Slide
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    LSR.b   #4,d0
    TST.b   d0
    BEQ.w   PT_volslidedown

PT_volslideup
    ADD.b   d0,PTv_SmpVolume(a6)
    CMP.b   #$40,PTv_SmpVolume(a6)
    BMI.w   PT_vsuskip
    MOVE.b  #$40,PTv_SmpVolume(a6)

PT_vsuskip
    MOVE.b  PTv_SmpVolume(a6),d0

    MOVE.w  d0,8(a5)
    RTS

PT_volslidedown
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0

PT_volslidedown2
    SUB.b   d0,PTv_SmpVolume(a6)
    BPL.w   PT_vsdskip
    CLR.b   PTv_SmpVolume(a6)

PT_vsdskip
    MOVEQ   #0,d0
    MOVE.b  PTv_SmpVolume(a6),d0
    MOVE.w  d0,8(a5)
    RTS

PT_positionjump                          ; Effect B: Position Jump
    MOVE.b  PTv_Step3(a6),d0
    SUBQ.b  #1,d0
    MOVE.b  d0,PTm_SongPos(a4)
    MOVE.w  #1,PTm_OverStep(a4)

PT_pj2
    CLR.b   PTm_PattBrkPos(a4)
    ST      PTm_PosJumpFlag(a4)
    RTS

PT_volumechange                          ; Effect C: Set Volume
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    CMP.b   #$40,d0
    BLS.w   PT_volumeok
    MOVEQ   #$40,d0

PT_volumeok
    MOVE.b  d0,PTv_SmpVolume(a6)
    MOVE.w  d0,8(a5)
    RTS

PT_patternbreak                          ; Effect D: Break Pattern
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    MOVE.l  d0,d2
    LSR.b   #4,d0
    MULU.w  #10,d0
    AND.b   #$0f,d2
    ADD.b   d2,d0
    CMP.b   #63,d0
    BHI.w   PT_pj2
    MOVE.b  d0,PTm_PattBrkPos(a4)
    ST      PTm_PosJumpFlag(a4)
    RTS

PT_setspeed                              ; Effect F: Set Speed
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0

    CMP.b   #32,d0
    BMI.w   setspeed
    RTS

setspeed
    CLR.b   PTm_Counter(a4)
    MOVE.b  d0,PTm_Speed(a4)
    RTS


.effects2
PT_checkmoreefx
    BSR     PT_updatefunk
    MOVE.b  PTv_Step2(a6),d0
    AND.b   #$0f,d0
    CMP.b   #$8,d0
    BEQ.w   PT_syncval
    CMP.b   #$9,d0
    BEQ.w   PT_sampleoffset
    CMP.b   #$b,d0
    BEQ.w   PT_positionjump
    CMP.b   #$d,d0
    BEQ.w   PT_patternbreak
    CMP.b   #$e,d0
    BEQ.w   PT_e_commands
    CMP.b   #$f,d0
    BEQ.w   PT_setspeed
    CMP.b   #$c,d0
    BEQ.w   PT_volumechange
    BRA     PT_pernop

PT_e_commands                            ; Effect E: E - Commands
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$f0,d0
    LSR.b   #4,d0
    BEQ.w   PT_filteronoff
    CMP.b   #1,d0
    BEQ.w   PT_fineportaup
    CMP.b   #2,d0
    BEQ.w   PT_fineportadown
    CMP.b   #3,d0
    BEQ.w   PT_setglisscontrol
    CMP.b   #4,d0
    BEQ.w   PT_setvibratocontrol
    CMP.b   #5,d0
    BEQ.w   PT_setfinetune
    CMP.b   #6,d0
    BEQ.w   PT_jumploop
    CMP.b   #7,d0
    BEQ.w   PT_settremolocontrol
    CMP.b   #9,d0
    BEQ.w   PT_retrignote
    CMP.b   #$a,d0
    BEQ.w   PT_volumefineup
    CMP.b   #$b,d0
    BEQ.w   PT_volumefinedown
    CMP.b   #$c,d0
    BEQ.w   PT_notecut
    CMP.b   #$d,d0
    BEQ.w   PT_notedelay
    CMP.b   #$e,d0
    BEQ.w   PT_patterndelay
    CMP.b   #$f,d0
    BEQ.w   PT_funkit
    RTS

PT_filteronoff                           ; E-Command 0: Filter On/Off
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #1,d0
    ADD.b   d0,d0
    ANDI.b  #$fd,$bfe001
    OR.b    d0,$bfe001
    RTS

PT_setglisscontrol                       ; E-Command 3: Glissando Control
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    ANDI.b  #$f0,PTv_GlissFunk(a6)
    OR.b    d0,PTv_GlissFunk(a6)
    RTS

PT_setvibratocontrol                     ; E-Command 4: Vibrato Control
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    ANDI.b  #$f0,PTv_WaveCtrl(a6)
    OR.b    d0,PTv_WaveCtrl(a6)
    RTS

PT_setfinetune                           ; E-Command 5: Set FineTune
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    MOVE.b  d0,PTv_SmpFinetune(a6)
    RTS

PT_jumploop                              ; E-Command 6: Set Jump Pos
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_6
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    BEQ.w   PT_setloop
    TST.b   PTv_LoopCount(a6)
    BEQ.w   PT_jumpcnt
    SUBQ.b  #1,PTv_LoopCount(a6)
    BEQ.w   PT_return_6

PT_jmploop
    MOVE.b  PTv_PattPos(a6),PTm_PattBrkPos(a4)
    ST      PTm_PattBrkFlag(a4)

PT_return_6
    RTS

PT_jumpcnt
    MOVE.b  d0,PTv_LoopCount(a6)
    BRA     PT_jmploop

PT_setloop
    MOVE.w  PTm_PattPos(a4),d0
    LSR.w   #4,d0
    MOVE.b  d0,PTv_PattPos(a6)
    RTS

PT_settremolocontrol                     ; E-Command 7: Tremolo Control
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    LSL.b   #4,d0
    ANDI.b  #$0f,PTv_WaveCtrl(a6)
    OR.b    d0,PTv_WaveCtrl(a6)
    RTS

PT_retrignote                            ; E-Command 9: Retrig Note
    MOVE.l  d1,-(a7)
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    BEQ.w   PT_rtnend
    MOVEQ   #0,d1
    MOVE.b  PTm_Counter(a4),d1
    BNE.w   PT_rtnskp
    MOVE.w  PTv_Step0(a6),d1
    AND.w   #$0fff,d1
    BNE.w   PT_rtnend
    MOVEQ   #0,d1
    MOVE.b  PTm_Counter(a4),d1

PT_rtnskp
    DIVU.w  d0,d1
    SWAP.w  d1
    TST.w   d1
    BNE.w   PT_rtnend

PT_doretrig
    MOVE.w  PTv_DMAMask(a6),$dff096   ; channel dma off
    MOVE.l  PTv_SmpStart(a6),(a5)     ; set sampledata pointer
    MOVE.w  PTv_SmpLength(a6),4(a5)   ; set length
    MOVE.w  #300,d0

PT_rtnloop1
    DBRA    d0,PT_rtnloop1
    MOVE.w  PTv_DMAMask(a6),d0
    BSET    #15,d0
    MOVE.w  d0,$dff096
    MOVE.w  #300,d0

PT_rtnloop2
    DBRA    d0,PT_rtnloop2
    MOVE.l  PTv_SmpRepStart(a6),(a5)
    MOVE.l  PTv_SmpRepLen(a6),4(a5)

PT_rtnend
    MOVE.l  (a7)+,d1
    RTS

PT_volumefineup                          ; E-Command A: Fineslide Volume Up
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_A
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$f,d0
    BRA     PT_volslideup

PT_return_A
    RTS

PT_volumefinedown                        ; E-Command B: Fineslide Volume Down
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_B
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    BRA     PT_volslidedown2

PT_return_B
    RTS

PT_notecut                               ; E-Command C: Note Cut
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    CMP.b   PTm_Counter(a4),d0
    BNE.w   PT_return_C
    CLR.b   PTv_SmpVolume(a6)
    MOVE.w  #0,8(a5)

PT_return_C
    RTS

PT_notedelay                             ; E-Command D: Note Delay
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    CMP.b   PTm_Counter(a4),d0
    BNE.w   PT_return_D
    MOVE.w  PTv_Step0(a6),d0
    BEQ.w   PT_return_D
    MOVE.l  d1,-(a7)
    BRA     PT_doretrig

PT_return_D
    RTS

PT_patterndelay                          ; E-Command E: Pattern Delay
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_E
    MOVEQ   #0,d0
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    TST.b   PTm_PtDelTime2(a4)
    BNE.w   PT_return_E
    ADDQ.b  #1,d0
    MOVE.b  d0,PTm_PtDelTime(a4)

PT_return_E
    RTS

PT_funkit                                ; E-Command F: Invert Loop <<<< ?
    TST.b   PTm_Counter(a4)
    BNE.w   PT_return_F
    MOVE.b  PTv_Step3(a6),d0
    AND.b   #$0f,d0
    LSL.b   #4,d0
    ANDI.b  #$0f,PTv_GlissFunk(a6)
    OR.b    d0,PTv_GlissFunk(a6)
    TST.b   d0
    BEQ.w   PT_return_F


PT_updatefunk
    MOVEM.l a0/d1,-(a7)
    MOVEQ   #0,d0
    MOVE.b  PTv_GlissFunk(a6),d0
    LSR.b   #4,d0
    BEQ.w   PT_funkend
    LEA     PT_funktable(pc),a0
    MOVE.b  0(a0,d0.w),d0
    ADD.b   d0,PTv_FunkOffs(a6)
    BTST    #7,PTv_FunkOffs(a6)
    BEQ.w   PT_funkend
    CLR.b   PTv_FunkOffs(a6)

    MOVE.l  PTv_SmpRepStart(a6),d0
    MOVEQ   #0,d1
    MOVE.w  PTv_SmpRepLen(a6),d1
    ADD.l   d1,d0
    ADD.l   d1,d0
    MOVE.l  PTv_WaveStart(a6),a0
    ADDQ.l  #1,a0
    CMP.l   d0,a0
    BMI.w   PT_funkok
    MOVE.l  PTv_SmpRepStart(a6),a0

PT_funkok
    MOVE.l  a0,PTv_WaveStart(a6)
    MOVEQ   #-1,d0
    SUB.b   (a0),d0
    MOVE.b  d0,(a0)

PT_funkend
    MOVEM.l (a7)+,a0/d1

PT_return_F
    RTS


PB_Wait
    LEA.l   $dff006+1,a1
    MOVE.b  (a1),d7
    AND.b   #$f0,d7

loop1
    MOVE.b  (a1),d6
    AND.b   #$f0,d6
    CMP.b   d7,d6
    BEQ.w   loop1

loop2
    MOVE.b  (a1),d6
    AND.b   #$f0,d6
    CMP.b   d7,d6
    BNE.w   loop2
    DBF     d0,loop1
    RTS


PT_funktable
    Dc.b  0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128


PT_vibratotable
    Dc.b  000,024,049,074,097,120,141,161
    Dc.b  180,197,212,224,235,244,250,253
    Dc.b  255,253,250,244,235,224,212,197
    Dc.b  180,161,141,120,097,074,049,024


PT_periodtable
; tuning 0, normal
    Dc.w  856,808,762,720,678,640,604,570,538,508,480,453
    Dc.w  428,404,381,360,339,320,302,285,269,254,240,226
    Dc.w  214,202,190,180,170,160,151,143,135,127,120,113
; tuning 1
    Dc.w  850,802,757,715,674,637,601,567,535,505,477,450
    Dc.w  425,401,379,357,337,318,300,284,268,253,239,225
    Dc.w  213,201,189,179,169,159,150,142,134,126,119,113
; tuning 2
    Dc.w  844,796,752,709,670,632,597,563,532,502,474,447
    Dc.w  422,398,376,355,335,316,298,282,266,251,237,224
    Dc.w  211,199,188,177,167,158,149,141,133,125,118,112
; tuning 3
    Dc.w  838,791,746,704,665,628,592,559,528,498,470,444
    Dc.w  419,395,373,352,332,314,296,280,264,249,235,222
    Dc.w  209,198,187,176,166,157,148,140,132,125,118,111
; tuning 4
    Dc.w  832,785,741,699,660,623,588,555,524,495,467,441
    Dc.w  416,392,370,350,330,312,294,278,262,247,233,220
    Dc.w  208,196,185,175,165,156,147,139,131,124,117,110
; tuning 5
    Dc.w  826,779,736,694,655,619,584,551,520,491,463,437
    Dc.w  413,390,368,347,328,309,292,276,260,245,232,219
    Dc.w  206,195,184,174,164,155,146,138,130,123,116,109
; tuning 6
    Dc.w  820,774,730,689,651,614,580,547,516,487,460,434
    Dc.w  410,387,365,345,325,307,290,274,258,244,230,217
    Dc.w  205,193,183,172,163,154,145,137,129,122,115,109
; tuning 7
    Dc.w  814,768,725,684,646,610,575,543,513,484,457,431
    Dc.w  407,384,363,342,323,305,288,272,256,242,228,216
    Dc.w  204,192,181,171,161,152,144,136,128,121,114,108
; tuning -8
    Dc.w  907,856,808,762,720,678,640,604,570,538,508,480
    Dc.w  453,428,404,381,360,339,320,302,285,269,254,240
    Dc.w  226,214,202,190,180,170,160,151,143,135,127,120
; tuning -7
    Dc.w  900,850,802,757,715,675,636,601,567,535,505,477
    Dc.w  450,425,401,379,357,337,318,300,284,268,253,238
    Dc.w  225,212,200,189,179,169,159,150,142,134,126,119
; tuning -6
    Dc.w  894,844,796,752,709,670,632,597,563,532,502,474
    Dc.w  447,422,398,376,355,335,316,298,282,266,251,237
    Dc.w  223,211,199,188,177,167,158,149,141,133,125,118
; tuning -5
    Dc.w  887,838,791,746,704,665,628,592,559,528,498,470
    Dc.w  444,419,395,373,352,332,314,296,280,264,249,235
    Dc.w  222,209,198,187,176,166,157,148,140,132,125,118
; tuning -4
    Dc.w  881,832,785,741,699,660,623,588,555,524,494,467
    Dc.w  441,416,392,370,350,330,312,294,278,262,247,233
    Dc.w  220,208,196,185,175,165,156,147,139,131,123,117
; tuning -3
    Dc.w  875,826,779,736,694,655,619,584,551,520,491,463
    Dc.w  437,413,390,368,347,328,309,292,276,260,245,232
    Dc.w  219,206,195,184,174,164,155,146,138,130,123,116
; tuning -2
    Dc.w  868,820,774,730,689,651,614,580,547,516,487,460
    Dc.w  434,410,387,365,345,325,307,290,274,258,244,230
    Dc.w  217,205,193,183,172,163,154,145,137,129,122,115
; tuning -1
    Dc.w  862,814,768,725,684,646,610,575,543,513,484,457
    Dc.w  431,407,384,363,342,323,305,288,272,256,242,228
    Dc.w  216,203,192,181,171,161,152,144,136,128,121,114

 endfunc 1

;-----------------------------------------------------------------------------------------------------------

 name      "LoadPTModule", "(#Module.w,FileName$)"
 flags      LongResult
 amigalibs _DosBase,a6, _ExecBase,d7
 params     d0_w,d1_l
 debugger   2,Error1

 MOVEM.l d2-d6/a2-a3,-(a7)   ; save regs to stack

 ADD.w   d0,d0         ; ...
 LSL.w   #8,d0         ; ...
 MOVE.l  (a5),a2       ; ...
 ADD.w   d0,a2         ; - A2 hold #Module

 MOVE.l  #1005,d2      ; arg2.
 JSR    _Open(a6)      ; (name,accessmode) - d1/d2
 MOVE.l  d0,d6         ; - D6 hold file
 BEQ.w   quit22        ; couldn't open file

 MOVE.l  d6,d1         ; arg1.
 MOVEQ   #0,d2         ; arg2.
 MOVEQ   #1,d3         ; arg3.
 JSR    _Seek(a6)      ; (file,pos,mode) - d1/d2/d3

 MOVE.l  d6,d1         ; arg1.
 MOVEQ   #-1,d3        ; arg3.
 JSR    _Seek(a6)      ; (file,pos,mode) - d1/d2/d3
 MOVE.l  d0,d5         ; - D5 hold file length

 MOVE.l  d6,d1         ; arg1.
 MOVE.w  #950,d2       ; arg2.
 JSR    _Seek(a6)      ; (file,pos,mode) - d1/d2/d3

 MOVE.l  d6,d1         ; arg1.
 MOVE.l  a2,d2         ; arg2.
 MOVE.l  #134,d3       ; arg3.
 JSR    _Read(a6)      ; (file,buffer,length) - d1/d2/d3

 MOVE.l  d6,d1         ; arg1.
 MOVEQ   #0,d2         ; arg2.
 MOVEQ   #-1,d3        ; arg3.
 JSR    _Seek(a6)      ; (file,pos,mode) - d1/d2/d3

 CMPI.l  #M.K.,130(a2) ; ...
 BEQ     LPTM_l0       ; ...

 CLR.l   (a2)          ; ...
 BRA     quit21        ; ...

LPTM_l0
 MOVEQ   #127,d0       ; song pos counter
 MOVEQ   #0,d3         ; lowest pattern nr
 MOVE.l  d3,d4         ; ...
 MOVE.l  a2,a0         ; use obj
 MOVE.w  (a0)+,d4      ; get songlen and ?

loop20
 MOVE.b  (a0)+,d1      ; get pattern nr
 CMP.b   d3,d1         ; see if it's bigger than old one
 BLE.w   l20           ; ...

 MOVE.b  d1,d3         ; new largest pattern nr

l20
 DBRA    d0,loop20     ; dec counter and loop if > -1

; where to save this
; LSR.w   #8,d4         ; sort out songlen
; MOVE.l  d4,8(a2)      ; zero to row, songpos, ?? and set maxpos

 ADDQ.b  #1,d3         ; add one (as zero are valid)
 LSL.l   #8,d3         ; } pattern nr *
 LSL.l   #2,d3         ; } pattern size
 ADD.l   #1084,d3      ; add size of sampinfo & patterndata
 MOVE.l  d3,d4         ; save sampinfo & patterndata size

 EXG.l   d7,a6         ; use execbase

 MOVE.l  d3,d0         ; arg1.
 MOVEQ   #4,d1         ; arg2.
 JSR    _AllocVec(a6)  ; (size,requierments) - d0/d1
 MOVE.l  d0,(a2)       ; set InfoPtr
 BEQ.w   l21           ; no fastmem

 EXG.l   d7,a6         ; use dosbase

 MOVE.l  d6,d1         ; arg1.
 MOVE.l  d0,d2         ; arg2.
 JSR    _Read(a6)      ; (file,buffer,length) - d1/d2/d3

 SUB.l   d3,d5         ; ...
 EXG.l   d7,a6         ; use execbase

l21
 MOVE.l  d5,d0         ; arg1.
 MOVEQ   #2,d1         ; arg2.
 JSR    _AllocVec(a6)  ; (size,requierments) - d0/d1
 MOVE.l  d0,d2         ; arg2.
 BEQ.w   quit20        ; no chipmem

 EXG.l   d7,a6         ; use dosbase

 MOVE.l  d6,d1         ; arg1.
 MOVE.l  d5,d3         ; arg3.
 JSR    _Read(a6)      ; (file,buffer,length) - d1/d2/d3

 MOVE.l  (a2),d3       ; is InfoPtr false
 BNE.w   l22           ; nop

 MOVEM.l d2-d3,(a2)    ; set InfoPtr & SamplePtr
 ADD.l   d4,d2         ; add info & pattern size to modptr
 BRA     l23           ; ...

l22
 MOVE.l  d2,4(a2)      ; set SamplePtr

l23
 MOVEQ   #30,d0        ; loop counter
 MOVEQ   #42,d1        ; ...
 MOVE.l  (a2),a0       ; use InfoPtr
 ADD.l   d1,a0         ; sampinfo\samplelen
 LEA     8(a2),a1      ; calc ptr to Obj\SampPtrs

loop21
 MOVE.l  d2,(a1)+      ; set Obj\SampPtr

 MOVE.w  (a0),d1       ; get sample len
 LSL.l   #1,d1         ; convert to byte
 ADD.l   d1,d2         ; calc new sample ptr

 ADD.w   #30,a0        ; inc sampinfoptr
 DBRA    d0,loop21     ; dec counter & loop if > -1

 BRA     quit21        ; ...

quit20
 MOVE.l  (a2),d0       ; ...
 BEQ.w   quit21        ; ...

 EXG.l   d7,a6         ; use execbase

 MOVE.l  d0,a1         ; arg1.
 JSR    _FreeVec(a6)   ; (mem) - a1

 EXG.l   d7,a6         ; use dosbase
 CLR.l   (a2)          ; zero to InfoPtr

quit21
 MOVE.l  d6,d1         ; arg1.
 JSR    _Close(a6)     ; (file) - d1

 MOVE.l  (a2),d0       ; return InfoPtr

quit22
 MOVEM.l (a7)+,d2-d6/a2-a3   ; restore regs
 RTS

 endfunc 2

;-----------------------------------------------------------------------------------------------------------

 name      "FreePTModule", "(#Module.w)"
 flags
 amigalibs _ExecBase,a6
 params     d0_w
 debugger   3,Error2

 MOVE.l a2,-(a7)       ; Save registers

 ADD.w   d0,d0         ; ...
 LSL.w   #8,d0         ; calc ptr
 MOVE.l  (a5),a2       ; to obj
 ADD.w   d0,a2         ; - A2 hold ptr Obj

 MOVE.l  (a2),d0       ; get InfoPtr
 BEQ.w   quit30        ; ...

 MOVE.l  d0,a1         ; arg1.
 JSR    _FreeVec(a6)   ; (mem) - a1

 CLR.l   (a2)+         ; zero to InfoPtr

 MOVE.l  (a2),d0       ; get SamplePtr
 BEQ.w   quit30        ; ...

 MOVE.l  d0,a1         ; arg1.
 JSR    _FreeVec(a6)   ; (mem) - a1

quit30
 MOVE.l (a7)+,a2            ; Restore registers
 RTS

 endfunc 3

;-----------------------------------------------------------------------------------------------------------

 name      "PlayPTModule", "(#Module.w)"
 flags
 amigalibs
 params     d0_w
 debugger   4,Error2

 MOVEM.l a2-a3,-(a7)               ; save A2 A3 to stack

 ADD.w   d0,d0                     ; ...
 LSL.w   #8,d0                     ; ...
 MOVE.l  (a5),a0                   ; ...
 ADD.w   d0,a0                     ; - A0 hold #PTModule

 MOVEM.l 12(a5),a2-a3              ; get ptr to tlo & tcr
 BCLR    #0,(a3)                   ; stop timer

 MOVE.l  42(a5),a1                 ; get Global
 MOVEM.l a0-a1,-(a7)               ; save #PTModule & Global

 MOVEQ   #30,d0                    ; ...
 ADDQ.w  #8,a0                     ; ...

loop40
 MOVE.l  (a0)+,(a1)+               ; move a sampptr
 DBRA    d0,loop40                 ; ...

 MOVEQ   #0,d0                     ; ...
 MOVEQ   #45,d1                    ; ...

loop41
 MOVE.l  d0,(a1)+                  ; clear one long
 DBRA    d1,loop41                 ; ...

 MOVEM.l (a7)+,a0-a1               ; ...

 MOVE.l  (a0),PTm_ModulePtr(a1)    ; set PTm_ModulePtr
 MOVE.w  #32768,PTm_DMAConTemp(a1) ; ...
 MOVE.w  -2(a1),PTm_ChanMask(a1)   ; ...
 MOVE.b  #6,PTm_Speed(a1)          ; set PTm_Speed

 MOVE.w  #1,170(a1)                ; set DMAMask
 MOVE.w  #2,170+40(a1)             ; set DMAMask
 MOVE.w  #4,170+80(a1)             ; set DMAMask
 MOVE.w  #8,170+120(a1)            ; set DMAMask

 MOVE.l  a0,46(a5)                 ; set modul

 MOVE.w  #14209,d0                 ; timer val
 MOVE.b  d0,(a2)                   ; set tlo
 LSR.w   #8,d0                     ; sort out
 MOVE.b  d0,256(a2)                ; set thi

 OR.b    #5,(a3)                   ; start timer

 MOVEM.l (a7)+,a2-a3               ; restore A2 A3
 RTS

 endfunc 4

;-----------------------------------------------------------------------------------------------------------

 name      "StopPTModule", "()"
 flags
 amigalibs
 params
 debugger   5,Error3

 MOVE.l  16(a5),a0           ; use tcr ptr
 BCLR    #0,(a0)             ; stop timer
 CLR.l   46(a5)              ; zero to modul

 MOVE.l  42(a5),a0           ; ...
 MOVE.w  PTm_ChanMask(a0),d0 ; ...
 MOVE.w  d0,$dff096          ; turn off channels
 RTS

 endfunc 5

;-----------------------------------------------------------------------------------------------------------

 name      "PausePTModule", "()"
 flags
 amigalibs
 params
 debugger   6,Error3

 MOVE.l  16(a5),a0            ; use tcr ptr
 BCLR    #0,(a0)              ; stop timer

 MOVE.l  42(a5),a0            ; get global
 MOVEQ   #3,d0                ; loop counter
 MOVE.w  PTm_ChanMask(a0),d1  ; ...
 MOVE.l  #$dff0d8,a1          ; channel four

loop60
 BTST    d0,d1                ; is chan in use
 BEQ     l60                  ; nop

 CLR.w   (a1)                 ; turn down volume

l60
 SUBA.w  #16,a1               ; prev channel
 DBRA    d0,loop60            ; ...

 MOVE.w  #d1,$dff096          ; turn off channels

 MOVEQ   #45,d0               ; loop counter
 LEA     124(a0),a0           ; skip sampptrs
 MOVE.l  46(a5),a1            ; get modul
 LEA     132(a1),a1           ; skip \Info, \Samples, \SampPtrs

loop61
 MOVE.l  (a0)+,(a1)+          ; ...
 DBRA    d0,loop61            ; ...

 RTS

 endfunc 6

;-----------------------------------------------------------------------------------------------------------

 name      "ResumePTModule", "(#Module.w)"
 flags
 amigalibs
 params     d0_w
 debugger   7,Error4

 MOVE.l  a6,-(a7)      ; Save registers
 ADD.w   d0,d0         ; ...
 LSL.w   #8,d0         ; ...
 MOVE.l  (a5),a0       ; ...
 ADD.w   d0,a0         ; - A0 ptr to #Module

 MOVE.l  16(a5),a6     ; use tcr ptr
 BCLR    #0,(a6)       ; stop timer

 CMPA.l  46(a5),a0     ; current module to resume
 BEQ     l70           ; yep

 MOVE.l  a0,46(a5)     ; set modul

 MOVEQ   #76,d0        ; loop counter
 ADDQ.l  #8,a0         ; skip \Info, \Samples
 MOVE.l  42(a5),a1     ; get global

loop70
 MOVE.l  (a0)+,(a1)+   ; ...
 DBRA    d0,loop70     ; ...

l70
 ORI.b   #5,(a6)       ; start timer
 MOVEA.l (a7)+,a6      ; Restore registers.
 RTS

 endfunc 7

;-----------------------------------------------------------------------------------------------------------

 name      "SetPTModuleSpeed", "(Speed.w)"
 flags
 amigalibs
 params     d0_w
 debugger   8,Error3

 MOVE.l  42(a5),a0           ; use global
 MOVE.b  d0,PTm_Speed(a0)    ; set PTm_Speed
 CLR.b   PTm_Counter(a0)     ; set PTm_Counter
 I_RTS

 endfunc 8

;-----------------------------------------------------------------------------------------------------------

 name      "GetPTModuleRow", "()"
 flags      ByteResult
 amigalibs
 params
 debugger   9,Error3

 MOVE.l  42(a5),a0           ; use global
 MOVE.w  PTm_PattPos(a0),d0  ; get PTm_PattPos
 LSR.w   #4,d0               ; sort out row
 I_RTS

 endfunc 9

;-----------------------------------------------------------------------------------------------------------

 name      "SetPTModuleRow", "(Row.w)"
 flags     InLine
 amigalibs
 params     d0_w
 debugger   10,Error3

.PB_SetPTModuleRow
 MOVE.l  42(a5),a0           ; use global
 LSL.w   #4,d0               ; ...
 MOVE.w  d0,PTm_PattPos(a0)  ; set PTm_PattPos
 I_RTS

 endfunc 10

;-----------------------------------------------------------------------------------------------------------

 name      "GetPTModulePos", "()"
 flags      ByteResult | InLine
 amigalibs
 params
 debugger   11,Error3

 MOVE.l  42(a5),a0           ; use global
 MOVE.b  PTm_SongPos(a0),d0  ; get PTm_SongPos
 I_RTS

 endfunc 11

;-----------------------------------------------------------------------------------------------------------

 name      "SetPTModulePos", "(Pos.w)"
 flags     InLine
 amigalibs
 params     d0_w
 debugger   12,Error3

 MOVE.l  42(a5),a0           ; use global
 MOVE.b  d0,PTm_SongPos(a0)  ; set PTm_SongPos
 CLR.w   PTm_PattPos(a0)     ; clear PTm_PattPos
 I_RTS

 endfunc 12

;-----------------------------------------------------------------------------------------------------------

 base

objbase:  Dc.l 0         ; 4
nr_obj:   Dc.w 0         ; 2

cia_bit:  Dc.w -1        ; 2
cia_res:  Dc.l 0         ; 4
cia_tlo:  Dc.l 0         ; 4
cia_tcr:  Dc.l 0         ; 4

cia_int:  Dc.l 0,0
          Dc.b 2
          Dc.b 0
          Dc.l int_name
          Dc.l 0, 0      ; 22

global:   Dc.l 0         ; 4
modul:    Dc.l 0         ; 4

int_name: Dc.b "PureBasic",0
cia_name: Dc.b "ciab.resource",0

 endlib

;-----------------------------------------------------------------------------------------------------------

 startdebugger

Error0
  TST.l   24(a4)
  BEQ     Err_00
  TST.l   d0
  BMI     Err_01
  CMPI.l  #62,d0
  BGT     Err_01
  RTS

Error1
  TST.l   (a5)
  BEQ     Err1
  TST.w   d0
  BMI     Err2
  CMP.w   4(a5),d0
  BGT     Err2

  ; Doobrey: Changed to preserve regs.
  ;MOVE.w  d0,d2
  ;ADD.w   d2,d2
  ;LSL.w   #8,d2
  ;MOVE.l  (a5),a0
  ;ADD.w   d2,a0

  MOVE.l  d0,-(a7)
  ADD.w   d0,d0
  LSL.w   #8,d0
  MOVE.l  (a5),a0
  ADD.w   d0,a0
  MOVE.l  (a7)+,d0

  TST.l   (a0)
  BNE     Err3
  RTS

Error2
  TST.l   (a5)
  BEQ     Err1
  TST.w   d0
  BMI     Err2
  CMP.w   4(a5),d0
  BGT     Err2

  ; Doobrey: Changed to preserve regs.
  ;MOVE.w  d0,d2
  ;ADD.w   d2,d2
  ;LSL.w   #8,d2
  ;MOVE.l  (a5),a0
  ;ADD.w   d2,a0

  MOVE.l  d0,-(a7)
  ADD.w   d0,d0
  LSL.w   #8,d0
  MOVE.l  (a5),a0
  ADD.w   d0,a0
  MOVE.l (a7)+,d0

  TST.l   (a0)
  BEQ     Err4
  RTS

Error3
  TST.l   46(a5)
  BEQ     Err5
  RTS

Error4
  TST.l   (a5)
  BEQ     Err1

  ; Doobrey Changed to preserve regs.
  ;MOVE.w  d0,d2
  ;ADD.w   d2,d2
  ;LSL.w   #8,d2
  ;MOVE.l  (a5),a0
  ;ADD.w   d2,a0

  MOVE.l d0,-(a7)
  ADD.w  d0,d0
  LSL.w  #8,d0
  MOVE.l (a5),a0
  ADD.w  d0,a0
  MOVE.l (a7)+,d0

  TST.l   (a0)
  BEQ     Err4

  TST.l   132(a0)
  BEQ     Err6
  RTS


Err_00: DebugError "Must Call InitAudio() First"
Err_01: DebugError "Modules out of Range"
Err1:   DebugError "Call InitPTModule() First or No Error Check Done"
Err2:   DebugError "#Module out of Range"
Err3:   DebugError "#Module is already Initialized"
Err4:   DebugError "#Module are not Initialized"
Err5:   DebugError "No module is played"
Err6:   DebugError "#Module is not Paused"

 enddebugger

