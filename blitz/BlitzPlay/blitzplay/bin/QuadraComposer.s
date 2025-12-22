
BRA InitPlay  ;requires memadr in a0 and size in d0
BRA InitSnd
BRA Interrupt
BRA EndSnd
BRA EndPlay
BRA SetVol    ;requires leftvol in d0, rightvol in d1 and vol in d2

;For the jumptable I compiled this source, and hexedited the exe
;header to jump to the above entries.  Makes things easier.

;*-----------------------------------------------------------------------*
;
; Interrupt f|r Replay

.Interrupt:
  MOVEM.l d2-d7/a2-a6,-(a7)
  BSR QC_music  ;DudelDiDum
  MOVEM.l (a7)+,d2-d7/a2-a6
  RTS

;*-----------------------------------------------------------------------*
;
; Init Player

.InitPlay:
  BSR QC_reloc  ;relocate Module
  TST.l d0
  BNE EndPlay   ;error !
  RTS

;*-----------------------------------------------------------------------*
;
; End Player

.EndPlay:
  MOVEQ #-1,d0
  RTS

;*-----------------------------------------------------------------------*
;
; Init Module

.InitSnd:
  BSR QC_init
  RTS

;*-----------------------------------------------------------------------*
;
; Clean up Module

.EndSnd:
  BSR QC_end
  RTS

;*-----------------------------------------------------------------------*
;
; Copy Volume and Balance Data to internal Buffer

.SetVol:
  MULU d2,d0
  LSR.w #6,d0
  LEA QC_chan1(pc),a0
  LEA $dff0a0,a1
  MOVEM.l d1-d2,-(a7)
  MOVEQ #2-1,d1

.SetVolL:
  MOVE.w d0,62(a0)
  MOVE.w 12(a0),d2
  MULU d0,d2
  LSR.w #6,d2
  MOVE.w d2,64(a0)
  MOVE.w d2,8(a1)
  LEA QC_chan4-QC_chan1(a0),a0
  LEA $30(a1),a1
  DBRA d1,SetVolL
  MOVEM.l (a7)+,d1-d2
  MOVE.w d1,d0
  MULU d2,d0
  LSR.w #6,d0
  LEA QC_chan2(pc),a0
  LEA $dff0b0,a1
  MOVEQ #2-1,d1

.SetVolR:
  MOVE.w d0,62(a0)
  MOVE.w 12(a0),d2
  MULU d0,d2
  LSR.w #6,d2
  MOVE.w d2,64(a0)
  MOVE.w d2,8(a1)
  LEA QC_chan3-QC_chan2(a0),a0
  LEA $10(a1),a1
  DBRA d1,SetVolR
  RTS

;*-----------------------------------------------------------------------*
;
; QuadraComposer2.1-Replay

;** This is a CIA replayroutine For EMOD's **
;** It handles all commands AND tempo      **
;** You may INCLUDE this in your own       **
;** applications, If you wish...           **
;** If you want To Use this routinne in a  **
;** player, you should write a "smart"     **
;** load routine, which allocates a        **
;** specific memory range For each sample  **
;** AND pattern etc.                       **
;**                          /Bo Lincoln   **

.QC_reloc:
  MOVE.l a0,d1  ;pointer to module
  CMP.l #"FORM",(a0)
  BNE QC_initerr
  CMP.l #"EMOD",8(a0)
  BNE QC_initerr
  CMP.l #"EMIC",12(a0)
  BNE QC_initerr
  CMP.w #1,20(a0)
  BNE QC_initerr
  MOVE.w #256-1,d7
  LEA QC_samplepointers,a1

.QC_spclear:
  MOVE.l #QC_quietsamp,(a1)+
  DBRA d7,QC_spclear
  MOVEQ #0,d7       ;Get the adresses to the sampleinfos
  MOVE.b 62(a0),QC_tempo+1
  MOVE.b 63(a0),d7  ;and init the real adresses in the infos
  SUBQ #1,d7
  LEA 64(a0),a0
  LEA QC_samplepointers,a1

.QC_sploop:
  MOVEQ #0,d0
  MOVE.b (a0),d0
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a0,a1
  ADD.w d0,a1
;  MOVE.l a0,(a1,d0.w)

  ADD.l d1,30(a0)
  MOVE.l 30(a0),a2
  CLR.w (a2)
  LEA 34(a0),a0
  DBF d7,QC_sploop
  LEA QC_patternpointers,a1 ;Get the patternadresses
  MOVEQ #0,d7
  ADDQ #1,a0
  MOVE.b (a0)+,d7
  SUBQ #1,d7

.QC_pploop:
  MOVEQ #0,d0
  MOVE.b (a0),d0
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a0,a1
  ADD.w d0,a1
;  MOVE.l a0,(a1,d0.w)

  ADD.l d1,22(a0)
  LEA 26(a0),a0
  DBF d7,QC_pploop
  CLR.w QC_nrofpos
  MOVE.b (a0)+,QC_nrofpos+1
  MOVE.l a0,QC_posstart
  MOVE.l #1776200,QC_ciaspeed
  MOVEQ #0,d0
  RTS

.QC_initerr:
  MOVEQ #-1,d0
  RTS

.QC_init:
  MOVE.l QC_posstart(pc),a0
  LEA QC_patternpointers,a1
  MOVEQ #0,d0
  MOVE.b (a0),d0
  ADD.w d0,d0
  ADD.w d0,d0

  ADD.w d0,a1
;  MOVE.l (a1,d0.w),a1

  MOVE.l 22(a1),QC_currpattpointer
  MOVE.b 1(a1),QC_breakrow+1
  MOVE.w #6,QC_speed
  MOVE.w QC_speed(pc),QC_speedcount
  CLR.b QC_newposflag
  CLR.w QC_rowcount
  CLR.w QC_pos
  OR.b #1,QC_event
  MOVE.w #1,14+QC_chan1
  MOVE.w #1,14+QC_chan2
  MOVE.w #1,14+QC_chan3
  MOVE.w #1,14+QC_chan4
  MOVE.w #1,8+QC_chan1
  MOVE.w #1,8+QC_chan2
  MOVE.w #1,8+QC_chan3
  MOVE.w #1,8+QC_chan4
  ST QC_introrow  ;You must reset this every time
                  ;you restart the module

;  MOVE.l a0,-(sp)
;  MOVE.l delibase(pc),a0      ; added by Delirium
;  MOVE.l QC_ciaspeed,d0
;  DIVU #125,d0
;  MOVE.w d0,dtg_Timer(a0)
;  MOVE.l (sp)+,a0

.QC_end:
  MOVE.w #$f,$dff096
  CLR.w $dff0a8
  CLR.w $dff0b8
  CLR.w $dff0c8
  CLR.w $dff0d8
  RTS

;**********************************************
;;;******** Replayrutinen + interrupt *********
;**********************************************

.QC_music:  ;Ny (hela replayen)
  ADDQ #1,QC_speedcount
  MOVE.w QC_speed,d0
  CMP.w QC_speedcount,d0
  BGT QC_nonew
  TST.b QC_pattwait
  BEQ QC_getnotes
  SUBQ.b #1,QC_pattwait
  CLR.w QC_speedcount

.QC_nonew:
  LEA QC_samplepointers,a4
  LEA QC_periods(pc),a3
  LEA QC_chan1(pc),a6
  LEA $dff0a0,a5
  BSR QC_chkplayfx
  LEA QC_chan2-QC_chan1(a6),a6
  LEA $10(a5),a5
  BSR QC_chkplayfx
  LEA QC_chan2-QC_chan1(a6),a6
  LEA $10(a5),a5
  BSR QC_chkplayfx
  LEA QC_chan2-QC_chan1(a6),a6
  LEA $10(a5),a5
  BSR QC_chkplayfx
  TST.w QC_dmacon
  BEQ QC_mend
  MOVE.w QC_dmacon(pc),$dff096
  OR.w #$8000,QC_dmacon
  MOVE.w QC_dmacon(pc),$dff096
  CLR.w QC_dmacon
  LEA QC_chan1+4(pc),a0
  LEA $dff000,a5
  MOVE.l (a0),d0
  CMP.l #$c00000,d0
  BLT ok11
  SUB.l #$b80000,d0

.ok11:
  MOVE.l d0,$a0(a5)
  MOVE.w 4(a0),$a4(a5)
  MOVE.l QC_chan2-QC_chan1(a0),d0
  CMP.l #$c00000,d0
  BLT ok21
  SUB.l #$b80000,d0

.ok21:
  MOVE.l d0,$b0(a5)
  MOVE.w 4+QC_chan2-QC_chan1(a0),$b4(a5)
  MOVE.l QC_chan3-QC_chan1(a0),d0
  CMP.l #$c00000,d0
  BLT ok31
  SUB.l #$b80000,d0

.ok31:
  MOVE.l d0,$c0(a5)
  MOVE.w 4+QC_chan3-QC_chan1(a0),$c4(a5)
  MOVE.l QC_chan4-QC_chan1(a0),d0
  CMP.l #$c00000,d0
  BLT ok41
  SUB.l #$b80000,d0

.ok41:
  MOVE.l d0,$d0(a5)
  MOVE.w 4+QC_chan4-QC_chan1(a0),$d4(a5)
  RTS

.QC_chkplayfx:
  LEA QC_playfx(pc),a2
  MOVE.b 2(a6),d0
  AND.w #$f,d0
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a2,a0
  ADD.w d0,a0
;  MOVE.l (a2,d0.w),a0

  JMP (a0)

.QC_getnotes:
  TST.b QC_introrow
  BNE QC_ok
  TST.b QC_event
  BEQ QC_tstnewpos
  BTST #0,QC_event
  BEQ QC_tstnewpos

  MOVE.l d0,-(a7)
  MOVE.b QC_event,d0
  AND.b #$fe,d0
  MOVE.b d0,QC_event
  MOVE.l (a7)+,d0
;  AND.b #$fe,QC_event

.QC_settempo:
  MOVE.l QC_ciaspeed,d0
  DIVU QC_tempo,d0

QC_ciab:

;  MOVE.l a0,-(sp)
;  MOVE.l delibase(pc),a0      ; added by Delirium
;  MOVE.w d0,dtg_Timer(a0)
;  MOVE.l dtg_SetTimer(a0),a0
;  JSR (a0)
;  MOVE.l (sp)+,a0

.QC_tstnewpos:
  TST.b QC_newposflag
  BEQ QC_tstend
  CLR.b QC_newposflag
  MOVE.w QC_newposnr,QC_pos ;Ny
  BRA QC_newpos

.QC_tstend:
  TST.b QC_jumpbreakflag
  BEQ QC_tstend2
  CLR.b QC_jumpbreakflag
  MOVE.w QC_looprow(pc),d0
  CMP.w QC_breakrow(pc),d0
  BGT QC_ok
  MOVE.w d0,QC_rowcount
  BRA QC_ok

.QC_tstend2:
  ADDQ.w #1,QC_rowcount
  MOVE.w QC_rowcount(pc),d0
  CMP.w QC_breakrow(pc),d0
  BLE QC_ok
  TST.b QC_playpatt
  BNE QC_nonewpatt
  ADDQ.w #1,QC_pos

.QC_newpos:
  MOVE.w QC_pos(pc),d0
  CMP.w QC_nrofpos(pc),d0
  BLT QC_getpos
  CLR.w QC_pos

;  MOVE.l a0,-(sp)
;  MOVE.l delibase(pc),a0      ; added by Delirium
;  MOVE.l dtg_SongEnd(a0),a0
;  JSR (a0)
;  MOVE.l (sp)+,a0

  MOVEQ #0,d0

.QC_getpos:
  MOVE.w d0,-(a7)
  MOVE.w QC_pos,d0
  MOVE.w (a7)+,d0
  MOVE.l QC_posstart,a0

  ADD.w d0,a0
  MOVE.b a0,d0
  SUB.w d0,a0
;  MOVE.b (a0,d0.w),d0

  MOVE.w d0,QC_currpatt
  ADD.w d0,d0
  ADD.w d0,d0
  LEA QC_patternpointers,a0

  ADD.l a0,a0
  ADD.w d0,a0
;  MOVE.l (a0,d0.w),a0

  MOVE.l 22(a0),QC_currpattpointer
  MOVE.b 1(a0),QC_breakrow+1
  MOVE.w QC_newrow(pc),QC_rowcount
  CLR.w QC_newrow
  MOVE.w QC_breakrow,d0
  CMP.w QC_rowcount,d0
  BGE QC_ok
  MOVE.w d0,QC_rowcount
  BRA QC_ok

.QC_nonewpatt:
  CLR.w QC_rowcount

.QC_ok:
  SF QC_introrow
  CLR.w QC_speedcount
  MOVE.l QC_currpattpointer(pc),a0
  MOVE.w QC_rowcount(pc),d0
  ASL.w #4,d0
  ADD.w d0,a0
  LEA QC_samplepointers,a4
  LEA QC_periods(pc),a3
  LEA $dff0a0,a5
  LEA QC_chan1(pc),a6
  BSR QC_playnote
  LEA $10(a5),a5
  LEA QC_chan2-QC_chan1(a6),a6
  BSR QC_playnote
  LEA $10(a5),a5
  LEA QC_chan2-QC_chan1(a6),a6
  BSR QC_playnote
  LEA $10(a5),a5
  LEA QC_chan2-QC_chan1(a6),a6
  BSR QC_playnote
  TST.w QC_dmacon
  BEQ QC_update
  MOVE.w QC_dmacon(pc),$dff096
  OR.w #$8000,QC_dmacon
  MOVE.w QC_dmacon(pc),$dff096
  CLR.w QC_dmacon
  LEA QC_chan1+4(pc),a0
  LEA $dff000,a5
  MOVE.l (a0),d0
  CMP.l #$c00000,d0
  BLT ok12
  SUB.l #$b80000,d0

.ok12:
  MOVE.l d0,$a0(a5)
  MOVE.w 4(a0),$a4(a5)
  MOVE.l QC_chan2-QC_chan1(a0),d0
  CMP.l #$c00000,d0
  BLT ok22
  SUB.l #$b80000,d0

.ok22:
  MOVE.l d0,$b0(a5)
  MOVE.w 4+QC_chan2-QC_chan1(a0),$b4(a5)
  MOVE.l QC_chan3-QC_chan1(a0),d0
  CMP.l #$c00000,d0
  BLT ok32
  SUB.l #$b80000,d0

.ok32:
  MOVE.l d0,$c0(a5)
  MOVE.w 4+QC_chan3-QC_chan1(a0),$c4(a5)
  MOVE.l QC_chan4-QC_chan1(a0),d0
  CMP.l #$c00000,d0
  BLT ok42
  SUB.l #$b80000,d0

.ok42:
  MOVE.l d0,$d0(a5)
  MOVE.w 4+QC_chan4-QC_chan1(a0),$d4(a5)

QC_update:

.QC_mend:
  RTS

.QC_playnote:
  MOVE.l (a0)+,(a6)
  MOVEQ #0,d0
  MOVE.b (a6),d0
  BEQ QC_isnote
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a4,a1
  ADD.w d0,a1
;  MOVE.l (a4,d0.w),a1

  MOVE.b 1(a1),12+1(a6)
  MOVE.w 2(a1),14(a6)
  MOVE.b 25(a1),d0
  AND.w #$f,d0
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a3,42(a6)
  ADD.w d0,42(a6)
;  MOVE.l (a3,d0.w),42(a6)

  MOVE.l 30(a1),d1
  MOVE.l d1,18(a6)
  MOVE.l d1,56(a6)
  CLR.w 8(a5)
  TST.b 60(a6)
  BEQ novol
  MOVE.w 12(a6),d0
  MULU 62(a6),d0
  LSR.w #6,d0
  MOVE.w d0,64(a6)
  MOVE.w d0,8(a5)

.novol:
  BTST #0,24(a1)
  BEQ noloop
  MOVEQ #0,d0
  MOVE.w 26(a1),d0
  MOVE.w d0,52(a6)
  ADD.l d0,d1
  ADD.l d0,d1
  MOVE.l d1,4(a6)
  MOVEQ #0,d0
  MOVE.w 26(a1),d0
  MOVEQ #0,d1
  MOVE.w 28(a1),d1
  ADD.l d0,d1
  MOVE.w d1,14(a6)
  MOVE.w 28(a1),8(a6)
  BRA QC_isnote

.noloop:
  MOVE.l #QC_quiet,4(a6)
  CLR.w 52(a6)
  MOVE.w #$1,8(a6)

.QC_isnote:
  TST.b 1(a6)
  BLT QC_chkfirstfx
  MOVE.b 1(a6),24+1(a6) ;Ny (flyttad)
  MOVE.w 2(a6),d0
  AND.w #$ff0,d0
  CMP.w #$e50,d0
  BEQ QC_setfinetunefirst
  AND.w #$f00,d0
  CMP.w #$300,d0
  BEQ QC_settoneport
  CMP.w #$500,d0
  BEQ QC_settoneport

.QC_getper:
  MOVE.w 24(a6),d0
  ADD.w d0,d0
  MOVE.l 42(a6),a2

  MOVE.w a2,10(a6)
  ADD.w d0,10(a6)
;  MOVE.w (a2,d0.w),10(a6)

  MOVE.w 2(a6),d0
  AND.w #$ff0,d0
  CMP.w #$ed0,d0
  BEQ QC_notedelay
  MOVE.w 22(a6),d0
  OR.w d0,QC_dmacon
  MOVE.l 18(a6),d0
  CMP.l #$c00000,d0
  BLT ok3
  SUB.l #$b80000,d0

.ok3:
  MOVE.l d0,(a5)
  CLR.l 46(a6)
  MOVE.b (a6),51(a6)
  MOVE.w 14(a6),54(a6)
  SF 41(a6)
  ST 50(a6)
  MOVE.w 14(a6),4(a5)
  MOVE.w 10(a6),6(a5)

.QC_chkfirstfx:
  LEA QC_fxaftersetperiod(pc),a2
  MOVEQ #0,d0
  MOVE.b 2(a6),d0
  ADD.w d0,d0
  ADD.w d0,d0

  ADD.l a2,a2
  ADD.w d0,a2
;  MOVE.l (a2,d0.w),a2

  JMP (a2)

.QC_setfinetunefirst:
  MOVE.b 3(a6),d0
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a3,42(a6)
  ADD.w d0,42(a6)
;  MOVE.l (a3,d0.w),42(a6)

  BRA QC_getper

.QC_ecommands:
  LEA QC_efx(pc),a2
  MOVE.b 3(a6),d0
  AND.w #$f0,d0
  LSR.w #2,d0

  ADD.l a2,a2
  ADD.w d0,a2
;  MOVE.l (a2,d0.w),a2

  JMP (a2)

.QC_playecommands:
  LEA QC_playefx(pc),a2
  MOVE.b 3(a6),d0
  AND.w #$f0,d0
  LSR.w #2,d0

  ADD.l a2,a2
  ADD.w d0,a2
;  MOVE.l (a2,d0.w),a2

  JMP (a2)

;********** Effect commands **********

.QC_arpeggio: ;Ny
  TST.b 3(a6)
  BEQ QC_mend
  LEA QC_arptbl,a2
  MOVE.w QC_speedcount,d0

  ADD.w a2,d0
  TST.b d0
;  tst.b (a2,d0.w)

  BEQ QC_arp2
  MOVE.w QC_speedcount,d0
  BLT QC_arp1
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  ADD.w 24(a6),d0
  ADD.w d0,d0
  MOVE.l 42(a6),a2

  MOVE.w a2,6(a5)
  ADD.w d0,6(a5)
;  MOVE.w (a2,d0.w),6(a5)

  RTS

.QC_arp1:
  MOVE.w 10(a6),6(a5)
  RTS

.QC_arp2:
  MOVE.w QC_speedcount,d0
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  LSR.w #4,d0
  ADD.w 24(a6),d0
  ADD.w d0,d0
  MOVE.l 42(a6),a2

  MOVE.w a2,6(a5)
  ADD.w d0,6(a5)
;  MOVE.w (a2,d0.w),6(a5)

  RTS

.QC_slideup:
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  SUB.w d0,10(a6)
  CMP.w #113,10(a6)
  BGT QC_sunotlow
  MOVE.w #113,10(a6)

.QC_sunotlow:
  MOVE.w 10(a6),6(a5)
  RTS

.QC_slidedown:
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  ADD.w d0,10(a6)
  CMP.w #856,10(a6)
  BLT QC_sdnothigh
  MOVE.w #856,10(a6)

.QC_sdnothigh:
  MOVE.w 10(a6),6(a5)
  RTS

.QC_settoneport:
  MOVE.w 24(a6),d0
  ADD.w d0,d0
  MOVE.l 42(a6),a2

  MOVE.l a2,-(a7)
  ADD.w d0,a2
  MOVE.w a2,d0
  MOVE.l (a7)+,a2
;  MOVE.w (a2,d0.w),d0

  MOVE.w d0,26(a6)
  CMP.w 10(a6),d0
  BGT QC_setportdown
  CLR.b 28(a6)
  RTS

.QC_setportdown:
  MOVE.b #1,28(a6)
  RTS

.QC_toneport:
  TST.w 26(a6)
  BEQ QC_mend
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  BEQ QC_tpold
  MOVE.b d0,40(a6)
  TST.b 28(a6)
  BNE QC_portdown
  SUB.w d0,10(a6)
  MOVE.w 26(a6),d0
  CMP.w 10(a6),d0
  BLT QC_notyetwanted
  MOVE.w d0,6(a5)
  MOVE.w d0,10(a6)
  CLR.w 26(a6)
  RTS

.QC_tpold:
  MOVE.b 40(a6),d0
  TST.b 28(a6)
  BNE QC_portdown
  SUB.w d0,10(a6)
  MOVE.w 26(a6),d0
  CMP.w 10(a6),d0
  BLT QC_notyetwanted
  MOVE.w d0,6(a5)
  MOVE.w d0,10(a6)
  CLR.w 26(a6)
  RTS

.QC_portdown:
  ADD.w d0,10(a6)
  MOVE.w 26(a6),d0
  CMP.w 10(a6),d0
  BGT QC_notyetwanted
  MOVE.w d0,6(a5)
  MOVE.w d0,10(a6)
  CLR.w 26(a6)
  RTS

.QC_notyetwanted:
  TST.b 30(a6)
  BEQ QC_nogliss
  MOVE.l 42(a6),a2
  MOVE.w 10(a6),d0

.QC_glissloop:
  CMP.w (a2)+,d0
  BLT QC_glissloop
  MOVE.w -2(a2),6(a5)
  RTS

.QC_nogliss:
  MOVE.w 10(a6),6(a5)
  RTS

.QC_vibrato:
  MOVEQ #0,d0
  MOVE.b 29(a6),d0
  ASL.w #7,d0
  LEA QC_vibtables(pc),a2
  ADD.w d0,a2
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  BEQ QC_vib
  MOVE.w d0,d1
  AND.b #$f,d0
  BEQ QC_vibusespeed

  MOVE.l d0,-(a7)
  MOVE.b 31(a6),d0
  AND.b #$f0,d0
  MOVE.b d0,31(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f0,31(a6)

  OR.b d0,31(a6)

.QC_vibusespeed:
  AND.b #$f0,d1
  BEQ QC_vib

  MOVE.l d0,-(a7)
  MOVE.b 31(a6),d0
  AND.b #$f,d0
  MOVE.b d0,31(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f,31(a6)

  OR.b d1,31(a6)

.QC_vib:
  MOVE.b 31(a6),d0
  LSR.w #3,d0
  ADD.w d0,32(a6)

  MOVE.l d0,-(a7)
  MOVE.w 32(a6),d0
  AND.w #$7e,d0
  MOVE.w d0,32(a6)
  MOVE.l (a7)+,d0
;  AND.w #$7e,32(a6)

  MOVE.w 32(a6),d0
  MOVE.w 10(a6),d1

  MOVE.l a2,-(a7)
  ADD.w d0,a2
  MOVE.w a2,d0
  MOVE.l (a7)+,a2
;  MOVE.w (a2,d0.w),d0

  MOVE.b 31(a6),d2
  AND.w #$f,d2
  MULS d2,d0
  ADD.l d0,d0
  ADD.l d0,d0
  SWAP d0
  ADD.w d0,d1
  CMP.w #856,d1
  BLT QC_vibnothigh
  MOVE.w #856,6(a5)
  RTS

.QC_vibnothigh:
  CMP.w #113,d1
  BGT QC_vibnotlow
  MOVE.w #113,6(a5)
  RTS

.QC_vibnotlow:
  MOVE.w d1,6(a5)
  RTS

.QC_toneportandvolslide:
  TST.w 26(a6)
  BEQ QC_volslide
  BSR QC_tpold
  BRA QC_volslide

.QC_vibratoandvolslide:
  BSR QC_vib
  BRA QC_volslide

.QC_tremolo:
  MOVEQ #0,d0
  MOVE.b 34(a6),d0
  ASL.w #7,d0
  LEA QC_vibtables(pc),a2
  ADD.w d0,a2
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  BEQ QC_trem
  MOVE.w d0,d1
  AND.b #$f,d0
  BEQ QC_tremusespeed

  MOVE.l d0,-(a7)
  MOVE.b 35(a6),d0
  AND.b #$f0,d0
  MOVE.b d0,35(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f0,35(a6)

  OR.b d0,35(a6)

.QC_tremusespeed:
  AND.b #$f0,d1
  BEQ QC_trem

  MOVE.l d0,-(a7)
  MOVE.b 35(a6),d0
  AND.b #$f,d0
  MOVE.b d0,35(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f,35(a6)

  OR.b d1,35(a6)

.QC_trem:
  MOVE.b 35(a6),d0
  LSR.w #3,d0
  ADD.w d0,36(a6)

  MOVE.l d0,-(a7)
  MOVE.w 36(a6),d0
  AND.w #$7e,d0
  MOVE.w d0,36(a6)
  MOVE.l (a7)+,d0
;  AND.w #$7e,36(a6)

  MOVE.w 36(a6),d0
  MOVE.w 12(a6),d1

  MOVE.l a2,-(a7)
  ADD.w d0,a2
  MOVE.w a2,d0
  MOVE.l (a7)+,a2
;  MOVE.w (a2,d0.w),d0

  MOVE.b 35(a6),d2
  AND.w #$f,d2
  MULS d2,d0
  ASL.l #3,d0
  SWAP d0
  ADD.w d0,d1
  CMP.w #$40,d1
  BLT QC_tremnothigh
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 62(a6),64(a6)
  MOVE.w 62(a6),8(a5)
  RTS

.QC_tremnothigh:
  TST.w d1
  BGT QC_tremnotlow
  TST.b 60(a6)
  BEQ QC_mend
  CLR.w 8(a5)
  RTS

.QC_tremnotlow:
  TST.b 60(a6)
  BEQ QC_mend
  MULU 62(a6),d1
  LSR.w #6,d1
  MOVE.w d1,64(a6)
  MOVE.w d1,8(a5)
  RTS

.QC_sampleoffset:
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  BEQ QC_sook
  MOVE.b d0,38(a6)

.QC_sook:
  MOVE.b 38(a6),d0
  ASL.w #8,d0
  MOVEQ #0,d1
  MOVE.w 14(a6),d1
  MOVE.w d1,54(a6)
  MOVE.l d0,46(a6)
  SUB.l d0,d1
  BLE QC_sotoolong
  MOVE.w d1,14(a6)
  ADD.l d0,d0
  ADD.l d0,18(a6)
  MOVE.l 18(a6),d0
  CMP.l #$c00000,d0
  BLT ok5
  SUB.l #$b80000,d0

.ok5:
  MOVE.l d0,(a5)
  MOVE.b (a6),51(a6)
  SF 41(a6)
  ST 50(a6)
  MOVE.w 14(a6),4(a5)
  RTS

.QC_sotoolong:
  MOVE.w #1,14(a6)
  MOVE.w 14(a6),4(a5)
  RTS

.QC_volslide:
  MOVEQ #0,d0
  MOVE.b 3(a6),d0
  LSR.w #4,d0
  BEQ QC_volslidedown
  ADD.w d0,12(a6)
  CMP.w #$40,12(a6)
  BLT QC_setvol
  MOVE.w #$40,12(a6)

.QC_setvol:
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 12(a6),d0
  MULU 62(a6),d0
  LSR.w #6,d0
  MOVE.w d0,64(a6)
  MOVE.w d0,8(a5)
  RTS

.QC_volslidedown:
  MOVE.b 3(a6),d0
  SUB.w d0,12(a6)
  TST.w 12(a6)
  BGT QC_setvol
  CLR.w 12(a6)
  TST.b 60(a6)
  BEQ QC_mend
  CLR.w 8(a5)
  RTS

.QC_posjump:  ;Ny
  MOVE.b 3(a6),d0
  MOVE.b d0,QC_newposnr+1
  MOVE.b #1,QC_newposflag
  CLR.w QC_newrow
  RTS

.QC_volumechange:
  MOVE.b 3(a6),d0
  CMP.b #$40,d0
  BCS QC_volchhigh
  MOVE.w #$40,12(a6)
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 62(a6),64(a6)
  MOVE.w 62(a6),8(a5)
  RTS

.QC_volchhigh:
  MOVE.b d0,12+1(a6)
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 12(a6),d0
  MULU 62(a6),d0
  LSR.w #6,d0
  MOVE.w d0,64(a6)
  MOVE.w d0,8(a5)
  RTS

.QC_patternbreak: ;Ny
  MOVE.w QC_pos,d0
  ADDQ.w #1,d0
  MOVE.w d0,QC_newposnr
  MOVE.b 3(a6),QC_newrow+1
  MOVE.b #1,QC_newposflag
  RTS

.QC_setspeed:
  MOVE.b 3(a6),d0
  BEQ QC_setspeed1
  CMP.b #$1f,d0
  BHI QC_temposet
  MOVE.b d0,QC_speed+1
  CLR.w QC_speedcount
  RTS

.QC_setspeed1:
  MOVE.w #1,QC_speed
  CLR.w QC_speedcount
  RTS

.QC_temposet:
  MOVE.b d0,QC_tempo+1
  OR.b #$1,QC_event
  RTS

.QC_setfilter:
  MOVE.b 3(a6),d0
  AND.b #1,d0
  ADD.b d0,d0

  MOVE.l d0,-(a7)
  MOVE.b $bfe001,d0
  AND.b #$fd,d0
  MOVE.b d0,$bfe001
  MOVE.l (a7)+,d0
;  AND.b #$fd,$bfe001

  OR.b d0,$bfe001
  RTS

.QC_fineslideup:
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  SUB.w d0,10(a6)
  CMP.w #113,10(a6)
  BGT QC_fsunotlow
  MOVE.w #113,10(a6)

.QC_fsunotlow:
  MOVE.w 10(a6),6(a5)
  RTS

.QC_fineslidedown:
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  ADD.w d0,10(a6)
  CMP.w #856,10(a6)
  BLT QC_fsdnothigh
  MOVE.w #856,10(a6)

.QC_fsdnothigh:
  MOVE.w 10(a6),6(a5)
  RTS

.QC_glisscontrol:
  MOVE.b 3(a6),30(a6)

  MOVE.l d0,-(a7)
  MOVE.b 30(a6),d0
  AND.b #$ff,d0
  MOVE.b d0,30(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f,30(a6)

  RTS

.QC_vibratowave:
  MOVE.b 3(a6),29(a6)

  MOVE.l d0,-(a7)
  MOVE.b 29(a6),d0
  AND.b #$f,d0
  MOVE.b d0,29(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f,29(a6)

  RTS

.QC_finetune:
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  ADD.w d0,d0
  ADD.w d0,d0

  MOVE.l a3,42(a6)
  ADD.w d0,42(a6)
;  MOVE.l (a3,d0.w),42(a6)

  RTS

.QC_jumploop:
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  BEQ QC_saveloop
  TST.b QC_loopcount
  BEQ QC_newloop
  SUBQ.b #1,QC_loopcount
  BEQ QC_mend
  MOVE.b #1,QC_jumpbreakflag
  RTS

.QC_newloop:
  MOVE.b d0,QC_loopcount
  MOVE.b #1,QC_jumpbreakflag
  RTS

.QC_saveloop:
  MOVE.w QC_rowcount(pc),QC_looprow
  RTS

.QC_tremolowave:
  MOVE.b 3(a6),34(a6)

  MOVE.l d0,-(a7)
  MOVE.b 34(a6),d0
  AND.b #$f,d0
  MOVE.b d0,34(a6)
  MOVE.l (a7)+,d0
;  AND.b #$f,34(a6)

  RTS

.QC_initretrig:
  CLR.b 39(a6)

.QC_retrignote:
  ADDQ.b #1,39(a6)
  MOVE.b 3(a6),d0
  AND.b #$f,d0
  CMP.b 39(a6),d0
  BGT QC_mend
  CLR.b 39(a6)
  MOVE.w 22(a6),d0
  OR.w d0,QC_dmacon
  MOVE.l 18(a6),d0
  CMP.l #$c00000,d0
  BLT ok6
  SUB.l #$b80000,d0

.ok6:
  MOVE.l d0,(a5)
  CLR.l 46(a6)
  MOVE.b (a6),51(a6)
  SF 41(a6)
  ST 50(a6)
  MOVE.w 14(a6),4(a5)
  MOVE.w 10(a6),6(a5)
  RTS

.QC_volumefineup:
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  ADD.w d0,12(a6)
  CMP.w #$40,12(a6)
  BLT QC_vfuset
  MOVE.w #$40,12(a6)
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 62(a6),64(a6)
  MOVE.w 62(a6),8(a5)
  RTS

.QC_vfuset:
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 12(a6),d0
  MULU 62(a6),d0
  LSR.w #6,d0
  MOVE.w d0,64(a6)
  MOVE.w d0,8(a5)
  RTS

.QC_volumefinedown:
  MOVE.b 3(a6),d0
  AND.w #$f,d0
  SUB.w d0,12(a6)
  BGE QC_vfdset
  CLR.w 12(a6)
  TST.b 60(a6)
  BEQ QC_mend
  CLR.w 8(a5)
  RTS

.QC_vfdset:
  TST.b 60(a6)
  BEQ QC_mend
  MOVE.w 12(a6),d0
  MULU 62(a6),d0
  LSR.w #6,d0
  MOVE.w d0,64(a6)
  MOVE.w d0,8(a5)
  RTS

.QC_notecut:
  MOVEQ #0,d1
  MOVE.b 3(a6),d1
  AND.b #$f,d1
  CMP.w QC_speedcount(pc),d1
  BGT QC_mend
  CLR.w 12(a6)
  TST.b 60(a6)
  BEQ QC_mend
  CLR.w 8(a5)
  RTS

.QC_notedelay:
  MOVEQ #0,d1
  TST.b 1(a6)
  BLT QC_mend
  MOVE.b 3(a6),d1
  AND.b #$f,d1
  CMP.w QC_speedcount(pc),d1
  BNE QC_mend
  MOVE.w 22(a6),d0
  OR.w d0,QC_dmacon
  MOVE.l 18(a6),d0
  CMP.l #$c00000,d0
  BLT ok7
  SUB.l #$b80000,d0

.ok7:
  MOVE.l d0,(a5)
  CLR.l 46(a6)
  MOVE.b (a6),51(a6)
  SF 41(a6)
  ST 50(a6)
  MOVE.w 14(a6),4(a5)
  MOVE.w 10(a6),6(a5)
  RTS

.QC_patterndelay:
  MOVE.b 3(a6),QC_pattwait

  MOVE.l d0,-(a7)
  MOVE.b QC_pattwait,d0
  AND.b #$f,d0
  MOVE.b d0,QC_pattwait
  MOVE.l (a7)+,d0
;  AND.b #$f,QC_pattwait

  RTS

.QC_arptbl:
  Dc.b -1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1
  Dc.b -1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1
  Dc.b -1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1
  Dc.b -1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1
  Dc.b -1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1
  Dc.b -1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1,0,1,-1

.QC_playfx:
  Dc.l QC_arpeggio
  Dc.l QC_slideup
  Dc.l QC_slidedown
  Dc.l QC_toneport
  Dc.l QC_vibrato
  Dc.l QC_toneportandvolslide
  Dc.l QC_vibratoandvolslide
  Dc.l QC_tremolo
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_volslide
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_playecommands
  Dc.l QC_mend

.QC_playefx:
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_retrignote
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_notecut
  Dc.l QC_notedelay
  Dc.l QC_mend
  Dc.l QC_mend

.QC_efx:
  Dc.l QC_setfilter
  Dc.l QC_fineslideup
  Dc.l QC_fineslidedown
  Dc.l QC_glisscontrol
  Dc.l QC_vibratowave
  Dc.l QC_finetune
  Dc.l QC_jumploop
  Dc.l QC_tremolowave
  Dc.l QC_mend
  Dc.l QC_initretrig
  Dc.l QC_volumefineup
  Dc.l QC_volumefinedown
  Dc.l QC_notecut
  Dc.l QC_notedelay
  Dc.l QC_patterndelay
  Dc.l QC_mend

.QC_fxaftersetperiod:
  Dc.l QC_arpeggio
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_mend
  Dc.l QC_sampleoffset
  Dc.l QC_mend
  Dc.l QC_posjump
  Dc.l QC_volumechange
  Dc.l QC_patternbreak
  Dc.l QC_ecommands
  Dc.l QC_setspeed

.QC_vibtables:
  Dc.w 0,3211,6392,9511,12539,15446,18204,20787,23169,25329
  Dc.w 27244,28897,30272,31356,32137,32609,32767,32609,32137
  Dc.w 31356,30272,28897,27244,25329,23169,20787,18204,15446
  Dc.w 12539,9511,6392,3211
  Dc.w 0,-3211,-6392,-9511,-12539,-15446,-18204,-20787,-23169,-25329
  Dc.w -27244,-28897,-30272,-31356,-32137,-32609,-32767,-32609,-32137
  Dc.w -31356,-30272,-28897,-27244,-25329,-23169,-20787,-18204,-15446
  Dc.w -12539,-9511,-6392,-3211
  Dc.w 32767,31744,30720,29696,28672,27648,26624,25600,24576,23552
  Dc.w 22528,21504,20480,19456,18432,17408,16384,15360,14336,13312
  Dc.w 12288,11264,10240,9216,8192,7168,6144,5120,4096,3072,2048,1024
  Dc.w 0,-1024,-2048,-3072,-4096,-5120,-6144,-8168,-8192,-9216,-10240
  Dc.w -11264,-12288,-13312,-14336,-15360,-16384,-17408,-18432,-19456
  Dc.w -20480,-21504,-22528,-23552,-24576,-25600,-26624,-27648,-28672
  Dc.w -29696,-30720,-31744,-32768
  Dc.w 32767,32767,32767,32767,32767,32767,32767,32767,32767,32767
  Dc.w 32767,32767,32767,32767,32767,32767,32767,32767,32767,32767
  Dc.w 32767,32767,32767,32767,32767,32767,32767,32767,32767,32767
  Dc.w 32767,32767
  Dc.w -32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767
  Dc.w -32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767
  Dc.w -32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767
  Dc.w -32767,-32767

.QC_periods:
  Dc.l QC_periodtable
  Dc.l QC_periodtable+72
  Dc.l QC_periodtable+144
  Dc.l QC_periodtable+216
  Dc.l QC_periodtable+288
  Dc.l QC_periodtable+360
  Dc.l QC_periodtable+432
  Dc.l QC_periodtable+504
  Dc.l QC_periodtable+576
  Dc.l QC_periodtable+648
  Dc.l QC_periodtable+720
  Dc.l QC_periodtable+792
  Dc.l QC_periodtable+864
  Dc.l QC_periodtable+936
  Dc.l QC_periodtable+1008
  Dc.l QC_periodtable+1080

QC_periodtable:
  Dc.w  856,808,762,720,678,640,604,570,538,508,480,453
  Dc.w  428,404,381,360,339,320,302,285,269,254,240,226
  Dc.w  214,202,190,180,170,160,151,143,135,127,120,113
  Dc.w  850,802,757,715,674,637,601,567,535,505,477,450
  Dc.w  425,401,379,357,337,318,300,284,268,253,239,225
  Dc.w  213,201,189,179,169,159,150,142,134,126,119,113
  Dc.w  844,796,752,709,670,632,597,563,532,502,474,447
  Dc.w  422,398,376,355,335,316,298,282,266,251,237,224
  Dc.w  211,199,188,177,167,158,149,141,133,125,118,112
  Dc.w  838,791,746,704,665,628,592,559,528,498,470,444
  Dc.w  419,395,373,352,332,314,296,280,264,249,235,222
  Dc.w  209,198,187,176,166,157,148,140,132,125,118,111
  Dc.w  832,785,741,699,660,623,588,555,524,495,467,441
  Dc.w  416,392,370,350,330,312,294,278,262,247,233,220
  Dc.w  208,196,185,175,165,156,147,139,131,124,117,110
  Dc.w  826,779,736,694,655,619,584,551,520,491,463,437
  Dc.w  413,390,368,347,328,309,292,276,260,245,232,219
  Dc.w  206,195,184,174,164,155,146,138,130,123,116,109
  Dc.w  820,774,730,689,651,614,580,547,516,487,460,434
  Dc.w  410,387,365,345,325,307,290,274,258,244,230,217
  Dc.w  205,193,183,172,163,154,145,137,129,122,115,109
  Dc.w  814,768,725,684,646,610,575,543,513,484,457,431
  Dc.w  407,384,363,342,323,305,288,272,256,242,228,216
  Dc.w  204,192,181,171,161,152,144,136,128,121,114,108
  Dc.w  907,856,808,762,720,678,640,604,570,538,508,480
  Dc.w  453,428,404,381,360,339,320,302,285,269,254,240
  Dc.w  226,214,202,190,180,170,160,151,143,135,127,120
  Dc.w  900,850,802,757,715,675,636,601,567,535,505,477
  Dc.w  450,425,401,379,357,337,318,300,284,268,253,238
  Dc.w  225,212,200,189,179,169,159,150,142,134,126,119
  Dc.w  894,844,796,752,709,670,632,597,563,532,502,474
  Dc.w  447,422,398,376,355,335,316,298,282,266,251,237
  Dc.w  223,211,199,188,177,167,158,149,141,133,125,118
  Dc.w  887,838,791,746,704,665,628,592,559,528,498,470
  Dc.w  444,419,395,373,352,332,314,296,280,264,249,235
  Dc.w  222,209,198,187,176,166,157,148,140,132,125,118
  Dc.w  881,832,785,741,699,660,623,588,555,524,494,467
  Dc.w  441,416,392,370,350,330,312,294,278,262,247,233
  Dc.w  220,208,196,185,175,165,156,147,139,131,123,117
  Dc.w  875,826,779,736,694,655,619,584,551,520,491,463
  Dc.w  437,413,390,368,347,328,309,292,276,260,245,232
  Dc.w  219,206,195,184,174,164,155,146,138,130,123,116
  Dc.w  868,820,774,730,689,651,614,580,547,516,487,460
  Dc.w  434,410,387,365,345,325,307,290,274,258,244,230
  Dc.w  217,205,193,183,172,163,154,145,137,129,122,115
  Dc.w  862,814,768,725,684,646,610,575,543,513,484,457
  Dc.w  431,407,384,363,342,323,305,288,272,256,242,228
  Dc.w  216,203,192,181,171,161,152,144,136,128,121,114

.QC_posstart:
  Dc.l 0

.QC_currpattpointer:
  Dc.l 0

.QC_currpatt:
  Dc.w 0

.QC_nrofpos:
  Dc.w 0

.QC_pos:
  Dc.w 0

.QC_newposnr:
  Dc.w 0

.QC_speed:
  Dc.w 6

.QC_speedcount:
  Dc.w 0

.QC_breakrow:
  Dc.w 0

.QC_newrow:
  Dc.w 0

.QC_rowcount:
  Dc.w 0

.QC_arpcount:
  Dc.w 0

.QC_looprow:
  Dc.w 0

.QC_tempo:
  Dc.w 125

.QC_dmacon:
  Dc.w 0

.QC_newposflag:
  Dc.b 0

.QC_jumpbreakflag:
  Dc.b 0

.QC_loopcount:
  Dc.b 0

.QC_pattwait:
  Dc.b 0

.QC_introrow:
  Dc.b 0,0

.QC_ciaspeed:
  Dc.l 0

.QC_event:
  Dc.b 0  ;bit 0 = check vblank

.QC_playpatt:
  Dc.b 0

.QC_quietsamp:
  Dc.w 0,1
  Dcb.b 20,0
  Dc.w 0
  Dc.w 1
  Dc.l QC_quiet

.QC_chan1:
  Dc.l 0    ;The note and command
  Dc.l 0    ;Repeat
  Dc.w 0    ;Replen
  Dc.w 0    ;Period
  Dc.w 0    ;Volume
  Dc.w 0    ;Length
  Dc.w 0    ;Unused
  Dc.l 0    ;Start
  Dc.w 1    ;DMAbit
  Dc.w 0    ;NoteNr2
  Dc.w 0    ;WantedPeriod
  Dc.b 0    ;Portdir
  Dc.b 0    ;VibWave
  Dc.b 0    ;Glisscont
  Dc.b 0    ;Vibcmd
  Dc.w 0    ;VibPos
  Dc.b 0    ;Tremwave
  Dc.b 0    ;Tremcmd
  Dc.w 0    ;Trempos
  Dc.b 0    ;Sampleoffset
  Dc.b 0    ;Retrig
  Dc.b 0    ;Portspeed
  Dc.b 0    ;Looping
  Dc.l 0    ;Finetune
  Dc.l 0    ;AdrCounter
  Dc.b 0    ;Going
  Dc.b 0    ;Samplenr
  Dc.w 0    ;Repeat in words
  Dc.w 0    ;Allways the length in words
  Dc.l 0    ;Real startpos
  Dc.b $ff  ;True = playable
  Dc.b 0
  Dc.w $40  ;Mainvol
  Dc.w 0    ;Realvol

.QC_chan2:
  Dc.l 0
  Dc.l 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.l 0
  Dc.w 2
  Dc.w 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.l 0
  Dc.l 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.w 0
  Dc.l 0
  Dc.b $ff
  Dc.b 0
  Dc.w $40  ;Mainvol
  Dc.w 0

.QC_chan3:
  Dc.l 0
  Dc.l 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.l 0
  Dc.w 4
  Dc.w 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.l 0
  Dc.l 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.w 0
  Dc.l 0
  Dc.b $ff
  Dc.b 0
  Dc.w $40  ;Mainvol
  Dc.w 0

.QC_chan4:
  Dc.l 0
  Dc.l 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.w 0
  Dc.l 0
  Dc.w 8
  Dc.w 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.b 0
  Dc.l 0
  Dc.l 0
  Dc.b 0
  Dc.b 0
  Dc.w 0
  Dc.w 0
  Dc.l 0
  Dc.b $ff
  Dc.b 0
  Dc.w $40  ;Mainvol
  Dc.w 0

.QC_samplepointers:
  Ds.l 256

.QC_patternpointers:
  Ds.l 256

.QC_quiet:
  Dc.l 0

