
; soc15.s = unlimitedBobs.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; "Unlimited bobs" mit einem BOB von 16 x 16 Pixeln in vier Farben.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=2
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; 4						$FFFFFFFE
BOB_DX=16
BOB_DY=16
BOB_DEPTH=DISPLAY_DEPTH
NBFRAMES=7
RADIUS_MIN=10
RADIUS_MAX=(DISPLAY_DY-BOB_DY)>>1
RADIUS_SPEED=2
ANGLE_SPEED=2

;********** Macros **********

WAIT_BLITTER:		MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)		; Entspricht dem Testen von Bit 14 % 8 = 6 des höchstwertigen Bytes von DMACONR, also BBUSY
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM	

;********** Initialisierung **********

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist
	; für die Bilder der Animation (eines nach dem anderen, um unter der
	; maximalen Größe eines verfügbaren Blocks zu bleiben)

	movea.l $4,a6
	lea images,a0
	moveq #NBFRAMES-1,d2
_allocImages:
	move.l #$10002,d1
	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movem.l a0/d2,-(sp)
	jsr -198(a6)
	movem.l (sp)+,a0/d2
	move.l d0,(a0)+
	dbf d2,_allocImages

	; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	bsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

	; Umleitung von Hardware-Interrupt-Vektoren (Stufe 1 bis 6 entspricht
	; den Vektoren 25 bis 30, die auf die Adressen $64 bis $78 zeigen)

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a0),(a1)+
	move.l #_rte,(a0)+
	ENDR

;********** Copperlist **********

	movea.l copperList,a0

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #0,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC, wenn DISPLAY_DX ein Vielfaches von 16 ist.
	move.w #BPL1MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+			; RAW Blitter für ungerade Bitplanes
	move.w #BPL2MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+			; RAW Blitter für gerade Bitplanes

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l images,d1
	moveq #DISPLAY_DEPTH-1,d2
_bitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	addi.l #DISPLAY_DX>>3,d1
	dbf d2,_bitplanes

	; Palette

	lea bob+BOB_DEPTH*BOB_DY*(BOB_DX>>3),a1
	move.w #COLOR00,d0
	moveq #(1<<DISPLAY_DEPTH)-1,d1
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

;********** Hauptprogramm **********

	; Erstellen Sie die Bob-Maske

	lea bob,a0
	lea bobMask,a1
	moveq #BOB_DY-1,d0
_maskRows:
	moveq #(BOB_DX>>4)-1,d1

_maskCols:
	movea.l a0,a2
	moveq #0,d3
	moveq #BOB_DEPTH-1,d2

_maskGetWord:
	or.w (a2),d3
	lea BOB_DX>>3(a2),a2
	dbf d2,_maskGetWord

	movea.l a1,a2
	moveq #BOB_DEPTH-1,d2
_maskSetWord:
	move.w d3,(a2)
	lea (BOB_DX+16)>>3(a2),a2
	dbf d2,_maskSetWord
	
	lea 2(a0),a0
	lea 2(a1),a1
	dbf d1,_maskCols

	lea ((BOB_DEPTH-1)*BOB_DX)>>3(a0),a0
	lea 2+(((BOB_DEPTH-1)*(BOB_DX+16))>>3)(a1),a1
	dbf d0,_maskRows
	
	; Den Bob in die Ausgangsposition bringen

	move.w #0,bobX
	move.w #0,bobY
	move.w #RADIUS_MIN,radius
	move.w #RADIUS_SPEED,radiusSpeed
	
	; Hauptschleife

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist

	move.w #DISPLAY_Y+DISPLAY_DY,d0
	bsr _waitRaster

	; Bilder zirkulär austauschen (das zweite wird zum ersten, ...,
	; das erste wird zum letzten)

	lea images,a0
	move.l (a0),d1
	lea 4(a0),a1
	moveq #NBFRAMES-2,d0
_swapImages:
	move.l (a1)+,(a0)+
	dbf d0,_swapImages
	move.l d1,(a0)

	; Das angezeigte Bild ändern

	move.l images,d0
	movea.l copperList,a0
	lea 10*4+2(a0),a0
	moveq #DISPLAY_DEPTH-1,d1
_swapBuffers:
	swap d0
	move.w d0,(a0)
	swap d0
	move.w d0,4(a0)
	lea 8(a0),a0
	addi.l #DISPLAY_DX>>3,d0
	dbf d1,_swapBuffers

	; die Position beleben

	move.w angle,d0
	subi.w #ANGLE_SPEED<<1,d0
	bge _noAngleUnderflow
	addi.w #360<<1,d0
_noAngleUnderflow:
	move.w d0,angle

	move.w radius,d1
	add.w radiusSpeed,d1
	bge _noRadiusUnderflow
	neg.w radiusSpeed
	add.w radiusSpeed,d1
	bra _noRadiusOverflow
_noRadiusUnderflow:
	cmpi.w #RADIUS_MAX,d1
	ble _noRadiusOverflow
	neg.w radiusSpeed
	add.w radiusSpeed,d1
_noRadiusOverflow:
	move.w d1,radius
	
	; Berechnen Sie die nächste Position des Bobs

	lea cosinus,a0
	move.w (a0,d0.w),d2
	muls d1,d2
	swap d2
	rol.l #2,d2
	addi.w #DISPLAY_DX>>1,d2
	move.w d2,bobX
	
	lea sinus,a0
	move.w (a0,d0.w),d2
	muls d1,d2
	swap d2
	rol.l #2,d2
	addi.w #DISPLAY_DY>>1,d2
	move.w d2,bobY

	; Zeichnen Sie den Bob an der nächsten Position im folgenden Bild

	moveq #0,d1
	move.w bobX,d0
	subi.w #BOB_DX>>1,d0
	move.w d0,d1
	and.w #$F,d0
	ror.w #4,d0
	move.w d0,BLTCON1(a5)		; BSH3-0=Verschiebung
	or.w #$0FF2,d0				; ASH3-0=Verschiebung, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w d0,BLTCON0(a5)
	lsr.w #3,d1
	and.b #$FE,d1
	move.w bobY,d0
	subi.w #BOB_DY>>1,d0
	mulu #DISPLAY_DEPTH*(DISPLAY_DX>>3),d0
	add.l d1,d0
	move.l images+4,d1
	add.l d1,d0
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	move.w #-2,BLTAMOD(a5)
	move.w #0,BLTBMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTCMOD(a5)
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTDMOD(a5)
	move.l #bob,BLTAPTH(a5)
	move.l #bobMask,BLTBPTH(a5)
	move.l d0,BLTCPTH(a5)
	move.l d0,BLTDPTH(a5)
	move.w #(BOB_DEPTH*(BOB_DY<<6))!((BOB_DX+16)>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Testen eines Drucks der linken Maustaste

	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und 
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	bsr _waitVERTB
	move.w #$07FF,DMACON(a5)

	; Interrupts wiederherstellen

	lea $64,a0
	lea vectors,a1
	REPT 6
	move.l (a1)+,(a0)+
	ENDR

	; Hardware-Interrupts und DMAs wiederherstellen

	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

	; Copperlist wiederherstellen

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

	; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

	; Speicher freigeben

	movea.l $4,a6
	lea images,a0
	moveq #NBFRAMES-1,d1
_freeImages:
	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l (a0)+,a1
	movem.l a0/d1,-(sp)
	jsr -210(a6)
	movem.l (sp)+,a0/d1
	dbf d1,_freeImages

	movea.l copperList,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"

;---------- Interrrupt-Handler ----------

_rte:
	rte

;---------- Warten auf vertikal blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!) ----------

_waitVERTB:
	movem.w d0,-(sp)
_waitVERTBLoop:
	move.w INTREQR(a5),d0
	btst #5,d0
	beq _waitVERTBLoop
	movem.w (sp)+,d0
	rts

;---------- Warten auf das einzeilige Raster ----------

; Eingang(s) :
;	D0 =  Zeile, in der das Raster erwartet wird
; Ausgang(s) :
;	(keine)
; Bemerkung :
;	Vorsicht, wenn die Schleife, aus der der Aufruf stammt, weniger als eine Zeile
;   zur Ausführung benötigt, denn dann sind zwei Aufrufe erforderlich :
;
;	move.w #Y+1,d0
;	bsr _waitRaster
;	move.w #Y,d0
;	bsr _waitRaster

_waitRaster:
	movem.l d1,-(sp)
_waitRasterLoop:
	move.l VPOSR(a5),d1
	lsr.l #8,d1
	and.w #$01FF,d1
	cmp.w d0,d1
	bne _waitRasterLoop
	movem.l (sp)+,d1
	rts

;********** Daten **********

graphicsLibrary:	DC.B "graphics.library",0
					EVEN
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
vectors:			BLK.L 6
copperList:			DC.L 0
bobX:				DC.W 0
bobY:				DC.W 0
angle:				DC.W 0
radius:				DC.W 0
radiusSpeed:		DC.W 0
bobMask:
					BLK.W BOB_DEPTH*BOB_DY*((BOB_DX+16)>>4),0
bob:
					INCBIN "ballBlue16x16x2.rawb"
images:				BLK.L NBFRAMES,0
sinus:				DC.W 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286
cosinus:			DC.W 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286, 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382
