
BRA MUSON ;requires memadr in a0
BRA DRIVER
BRA MUSOFF

;*******************************************************************
;*
;* Future Composer Music Driver v1.02  Do the following To play
;* your tune:
;*
;* JSR MUSON  = prepare tune For play
;* JSR DRIVER = play tune (Call from your Interrupt)
;* JSR MUSOFF = clear out all Sound Registers (Tune is over)
;*
;*******************************************************************

.MUSON:
  MOVE.l a0,d0
  ADDI.l #4,d0
  MOVE.l d0,TRK0
  ADDI.L #$400,d0
  MOVE.L d0,BLOX
  ADDI.L #$4004,d0
  MOVE.L d0,DIGBLOK
  ADDI.L #$3F4,d0
  MOVE.L d0,DIGIDAT
  MOVE.L DIGIDAT,a0 ;BASE ADDRESS OF DIGIS
  MOVE.L DIGBLOK,a1
  MOVE.W #63,D0

.PRPLOOP:
  MOVE.L A0,(a1)
  ADD.L 4(a1),A0
  MOVE.l a1,d1
  ADDI.L #16,d1
  DBF D0,PRPLOOP
  MOVE.W #2,TEMPO
  MOVE.L #$00100010,D0
  MOVE.L D0,DUR0
  MOVE.L D0,DUR0+4
  LSR.L #4,D0
  MOVE.L D0,RP0
  MOVE.L D0,RP0+4
  MOVE.L #$FFFFFFFF,D0
  MOVE.L D0,BF0
  MOVE.L D0,BF0+4
  LEA CDUR0,A0
  MOVE.W #36,D0

.CLDRVS:
  CLR.W (A0)+
  DBF D0,CLDRVS
  RTS

.MUSOFF:
  MOVE.W #$000F,$DFF096
  LEA $DFF0A0,A0
  CLR.W $8(A0)
  CLR.W $18(A0)
  CLR.W $28(A0)
  CLR.W $38(A0)
  RTS

;********** THE ALMIGHTY INTERRUPT **********

.IRQ:
  MOVEM.L D0-D7/A0-A6,-(A7)
  MOVE $DFF01E,D1
  BTST #4,D1
  BNE IREXIT
  BSR DRIVER

.IREXIT:
  MOVE #$70,$DFF09C
  MOVEM.L (A7)+,D0-D7/A0-A6
  RTE

;********** Let THE MUSIC PLAY... **********

.DRIVER:
  TST.W SONPLAY
  BNE DMOFF
  SUBI.W #1,TMCNT
  BPL DRVEX
  MOVE.W TEMPO,TMCNT
  MOVEQ #3,D5

.DRVLP:
  BSR DRIVOI
  DBF D5,DRVLP

.DRVEX:
  RTS

.DMOFF:
  MOVE.W #$000F,$DFF096
  RTS

;********** DRIVE VOICE D5.B **********

.DRIVOI:
  CLR.W INFCHK
  LEA $DFF0A0,A4
  MOVE.W D5,D6
  ASL.W #1,D6
  MOVE.W D5,D7
  ASL.W #4,D7
  LEA GLDUD(PC),A3

  ADD.w d6,a3
  TST.w (a3)
;  TST.W (A3,D6.W)

  BEQ DODRIVE
  SUB.w d6,a3
  LEA DETUN0(PC),A2

  MOVE.w a2,d1
  ADD.w d6,d1
;  MOVE.W (A2,D6.W),D1

  ADD.w d6,a3
  TST.w (a3)
;  TST.W (A3,D6.W)

  BMI GLIDEUP
  NEG.W D1

.GLIDEUP:
  SUB.w d6,a3
  LEA PERVAL(PC),A3

  ADD.w a3,d1
  ADD.w d6,d1
;  ADD.W (A3,D6.W),D1

  ANDI.L #$FFFF,D1
  CMPI.L #127,D1
  BGT CHKDGL
  MOVE.W #127,D1

.CHKDGL:
  CMPI.L #$0800,D1
  BLT NOCHKP
  MOVE.W #$0800,D1

.NOCHKP:

  MOVE.w d1,6(a4)
  ADD.w d7,6(a4)
;  MOVE.W D1,6(A4,D7.W)

  MOVE.w d1,a3
  ADD.w d6,a3
;  MOVE.W D1,(A3,D6.W)

  ADD.w d6,a3

.DODRIVE:
  SUB.w d6,a3
  LEA 1+BF0(PC),A3

  ADD.w d6,a3
  CMPI.b #$ff,(a3)
;  CMPI.B #$FF,(A3,D6.W)

  BNE BLGO
  SUB.w d6,a3

.BEGBLK:
  LEA BF0(PC),A3

  CLR.w (a3)
;  CLR.W (A3,D6.W)

  LEA RP0(PC),A3

  ADD.w d6,a3
  SUBI.w #1,(a3)
;  SUBI.W #1,(A3,D6.W)

  BNE BLGO
  SUB.w d6,a3

.NXV:
  LEA RP0(PC),A3

  MOVE.w #1,a3
;  MOVE.W #1,(A3,D6.W)

.NXVA:
  ADDI.W #1,INFCHK  ;THIS TRAPS AN FF VALUE IN
  BTST #8,INFCHK    ;POSITION 0 OF EACH TRACK...
  BNE SONEND
  CLR.L D0
  MOVE.W D5,D0
  ASL.W #8,D0
  MOVE.L TRK0,A0
  ADD.L D0,A0
  LEA V0(PC),A3

  MOVE.w a3,d0
  ADD.w d6,d0
;  MOVE.W (A3,D6.W),D0

  CLR.W D1

  MOVE.b a0,d1
  ADD.w d0,d1
;  MOVE.B (A0,D0.W),D1

  CMPI.W #$40,D1
  BLT FBL
  CMPI.W #$80,D1
  BLT RPX
  CMPI.W #$FB,D1
  BGT CTR
  CMPI.B #$BF,D1
  BGT FILTMOD

.TRXPOSE:
  ANDI.W #$3F,D1
  CMPI.W #35,D1
  BGT FILTMOD
  LEA TRX0(PC),A3

  MOVE.w d1,a3
;  MOVE.W D1,(A3,D6.W)

  BRA VINC

.FILTMOD:
  MOVE.B $BFE001,D0
  ANDI.B #$FD,D0
  ANDI.B #1,D1  ;MODIFY FILTER...
  ASL.B #1,D1
  OR.B D1,D0
  MOVE.B D0,$BFE001

.VINC:
  LEA 1+V0(PC),A3

  ADDI.b #1,(a3)
;  ADDI.B #1,(A3,D6.W)

  BRA NXVA

.RPX:
  SUBI.W #$3F,D1
  LEA RP0(PC),A3

  MOVE.w d1,a3
;  MOVE.W D1,(A3,D6.W)

  BRA VINC

.FBL:
  LEA 1+V0(PC),A3

  ADDI.b #1,(a3)
;  ADDI.B #1,(A3,D6.W)

  LEA 1+BLK0(PC),A3

  MOVE.b d1,a3
;  MOVE.B D1,(A3,D6.W)

  BRA BLGO

.CTR:
  CMPI.B #$FC,D1
  BEQ VOL
  CMPI.B #$FD,D1
  BEQ GT
  CMPI.B #$FE,D1
  BEQ SONEND
  CMPI.B #$FF,D1
  BNE VINC
  LEA V0(PC),A3 ;THE $FF BYTE

  CLR.w (a3)
;  CLR.W (A3,D6.W)

  BRA NXV

.SONEND:
  ST SONPLAY
  RTS

.VOL:
  ADDI.B #1,D0
  LEA 1+V0(PC),A3

  MOVE.b d0,a3
;  MOVE.B D0,(A3,D6.W)

  MOVE.b a0,d1
  ADD.w d0,d1
;  MOVE.B (A0,D0.W),D1

  MOVE.w d1,8(a4) ;SET VOLUME...
;  MOVE.W D1,8(A4,D7.W)

  LEA VOL0(PC),A3

  MOVE.w d1,a3
;  MOVE.W D1,(A3,D6.W)

  BRA VINC

.GT:
  ADDI.B #1,D0
  LEA 1+V0(PC),A3

  MOVE.b a0,a3
  ADD.w d0,a3
;  MOVE.B (A0,D0.W),(A3,D6.W)

  BRA NXV

.BLGO:
  SUB.w d6,a3
  LEA CDUR0(PC),A3

  SUBI.w #1,(a3)
;  SUBI.W #1,(A3,D6.W)

  BEQ BLDO
  BMI BLDO
  RTS

.BLDO:
  ADDI.W #1,INFCHK  ;ENDS SONG IF AN INFINITE
  BTST #8,INFCHK    ;LOOP IS FOUND...
  BNE SONEND
  LEA BF0(PC),A3

  MOVE.w a3,d0
  ADD.w d6,d0
;  MOVE.W (A3,D6.W),D0

  LEA BLK0(PC),A3

  MOVE.w a3,d1
  ADD.w d6,d1
;  MOVE.W (A3,D6.W),D1

  ASL.W #8,D1
  ADD.W D1,D0
  MOVE.L BLOX,A0
  CLR.W D1

  MOVE.b a0,d1
  ADD.w d0,d1       ;VAL IN THE BLOCK...
;  MOVE.B (A0,D0.W),D1

  CMPI.B #$FF,D1
  BEQ BEGBLK
  CMPI.W #$30,D1
  BLT PNOT
  CMPI.W #$70,D1
  BLT DETFIX
  CMPI.W #$80,D1
  BLT TEMFIX
  CMPI.W #$C0,D1
  BLT DURFIX
  ANDI.W #$3F,D1    ;GET SOUND NR.
  LEA SN0(PC),A3

  MOVE.w d1,a3
;  MOVE.W D1,(A3,D6.W)

.NXBF:
  LEA 1+BF0(PC),A3

  ADDI.b #1,(a3)
;  ADDI.B #1,(A3,D6.W)

  BRA BLDO

.TEMFIX:
  ANDI.W #$0F,D1
  MOVE.W D1,TEMPO
  BRA NXBF

.DETFIX:
  LEA GLDUD(PC),A3
  SUBI.W #$30,D1
  CMPI.B #$3D,D1
  BEQ DNGLD
  CMPI.B #$3E,D1
  BEQ NOGLD
  CMPI.B #$3F,D1
  BEQ UPGLD
  ASL.W #1,D1
  LEA DETUN0(PC),A3

  MOVE.w d1,a3
;  MOVE.W D1,(A3,D6.W)

  BRA NXBF

.DNGLD:

  MOVE.w #$ffff,a3
;  MOVE.W #$FFFF,(A3,D6.W)

  BRA NXBF

.NOGLD:

  CLR.w (a3)
;  CLR.W (A3,D6.W)

  BRA NXBF

.UPGLD:

  MOVE.w #$0001,a3
;  MOVE.W #$0001,(A3,D6.W)

  BRA NXBF

.DURFIX:
  ANDI.W #$3F,D1
  TST.B D1
  BNE DUROK
  MOVE.B #$40,D1

.DUROK:
  LEA DUR0(PC),A3

  MOVE.w d1,a3
;  MOVE.W D1,(A3,D6.W)

  BRA NXBF

.PNOT:
  MOVE.W D5,D4
  ASL.W #1,D4
  LEA DMA(PC),A3

  MOVE.w a3,DMV
  ADD.w d4,DMV
;  MOVE.W (A3,D4.W),DMV

  MOVE.L DIGBLOK,A1
  LEA SN0(PC),A3

  MOVE.w a3,d0
  ADD.w d6,d0
;  MOVE.W (A3,D6.W),D0

  ASL.W #4,D0

  ADD.w d0,4(a1)
  TST.l 4(a1)     ;SKIP IF SOUND NOT LOADED...
;  TST.L 4(A1,D0.W)

  BEQ PNENDA
  SUB.w d0,4(a1)
  MOVE.W DMV,$DFF096
  MOVE.W #$1D0,D2 ;LET DMA CATCH UP...

.DF:
  DBF D2,DF

  MOVE.l 0(a1),a4
  ADD.w d0,a4
;  MOVE.L 0(A1,D0.W),(A4,D7.W)

  MOVE.l 4(a1),d2
  ADD.w d0,d2
;  MOVE.L 4(A1,D0.W),D2

  LSR.L #1,D2

  MOVE.w d2,4(a4)
;  MOVE.W D2,4(A4,D7.W)

  LEA TRX0(PC),A2 ;D1 NOTEVAL + THE TRANSPOSE VALUE...

  ADD.w a2,d1
  ADD.w d6,d1
;  ADD.W (A2,D6.W),D1

  ASL.W #1,D1
  LEA PERTAB(PC),A2

  ADD.w a2,d1
;  MOVE.W (A2,D1.W),D1

  LEA DETUN0(PC),A3

  ADD.w a3,d1
  ADD.w d6,d1
;  ADD.W (A3,D6.W),D1

  MOVE.w d1,6(a4)
;  MOVE.W D1,6(A4,D7.W)

  LEA PERVAL(PC),A2

  MOVE.w d1,a2
;  MOVE.W D1,(A2,D6.W)

  ORI.W #$8000,DMV
  MOVE.W DMV,$DFF096

  ADD.w d0,12(a1)
  TST.l 12(a1)
;  TST.L 12(A1,D0.W)

  BNE WAVE
  SUB.w d0,12(a1)

  MOVE.w #1,4(a4)
;  MOVE.W #1,4(A4,D7.W)

  BRA PNEND

.WAVE:
  SUB.w d0,12(a1)
  MOVE.W #$30,D1

.DMAWT:
  DBF D1,DMAWT

  MOVE.l 12(a1),d1
  ADD.w d0,d1
;  MOVE.L 12(A1,D0.W),D1

  LSR.L #1,D1

  MOVE.w d1,4(a4)
;  MOVE.W D1,4(A4,D7.W)

  MOVE.l a1,d1
  ADD.w d0,d1
;  MOVE.L (A1,D0.W),D1

  ADD.l 8(a1),d1
  ADD.w d0,d1
;  ADD.L 8(A1,D0.W),D1

  MOVE.l d1,a4
;  MOVE.L D1,(A4,D7.W)

.PNEND:
  LEA VOL0(PC),A3

  MOVE.w a3,8(a4)
  ADD.w d6,8(a4)
;  MOVE.W (A3,D6.W),8(A4,D7.W)

.PNENDA:
  SUB.l d0,4(a1)
  LEA DUR0(PC),A3
  LEA CDUR0(PC),A1

  MOVE.w a3,a1
  ADD.w d6,a1
;  MOVE.W (A3,D6.W),(A1,D6.W)

  LEA BF0(PC),A3

  ADDI.w #1,(a3)
;  ADDI.W #1,(A3,D6.W)

  RTS

;********** THE PERIOD TABLE **********

.PERTAB:
  Dc.w 1712,1616,1520,1440,1360,1280,1200,1136,1072,1016,960,904
  Dc.w 856,808,760,720,680,640,600,568,536,508,480,452
  Dc.w 428,404,380,360,340,320,300,284,268,254,240,226
  Dc.w 214,202,190,180,170,165,150,142,134,127,120,113
  Dc.w 107,101,95,90,85,83,75,71,67,64,60,57  ;TRXPOSE VALS...
  Dc.w 54,51,48,45,43,41,38,36,34,32,30,28
  Dc.w 27,25,24,23,21,20,19,18,17,16,15,14

.DMA:
  Dc.w $0001,$0002,$0004,$0008

.DMV:
  Dc.w 0

;********** VARIABLES Used IN THE DRIVER **********

.TEMPO:
  Dc.w 2

.TMCNT:
  Dc.w 0

.DUR0:
  Dc.w $10,$10,$10,$10

.CDUR0:
  Dc.w 0,0,0,0

.GLDUD:
  Dc.w 0,0,0,0

.TRX0:
  Dc.w 0,0,0,0

.GLDVAL:
  Dc.w 0,0,0,0

.PERVAL:
  Dc.w 0,0,0,0

.BLK0:
  Dc.w 0,0,0,0

.V0:
  Dc.w 0,0,0,0

.DETUN0:
  Dc.w 0,0,0,0

.SN0:
  Dc.w 0,0,0,0

.SONPLAY:
  Dc.w 0

.INFCHK:
  Dc.w 0  ;CHECKS FOR ENDLESS LOOPS IN MUSIC...

.BF0:
  Dc.w $FF,$FF,$FF,$FF

.RP0:
  Dc.w 1,1,1,1

.VOL0:
  Dc.w 64,64,64,64

.TRK0:
  Dc.l 0

.BLOX:
  Dc.l 0

.DIGBLOK:
  Dc.l 0

.DIGIDAT:
  Dc.l 0

