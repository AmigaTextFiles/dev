
; extra - diese Datei ist nicht aud stashofcode zu finden
; Anzeige eines Bildes im RAWC-Format

;---------- Direktiven ----------

	SECTION yragael,CODE_C

;---------- Konstanten ----------

; Register

VPOSR=$004
FMODE=$1FC
INTENA=$09A
INTENAR=$01C
INTREQ=$09C
INTREQR=$01E
DMACON=$096
DMACONR=$002
COLOR00=$180
COLOR01=$182
COP1LCH=$080
COP1LCL=$082
COPJMP1=$088
DIWSTRT=$08E
DIWSTOP=$090
BPLCON0=$100
BPLCON1=$102
BPLCON2=$104
DDFSTRT=$092
DDFSTOP=$094
BPL1MOD=$108
BPL2MOD=$10A
BPL1PTH=$0E0
BPL1PTL=$0E2
BPL2PTH=$0E4
BPL2PTL=$0E6
BPL3PTH=$0E8
BPL3PTL=$0EA
BPL4PTH=$0EC
BPL4PTL=$0EE
BPL5PTH=$0F0
BPL5PTL=$0F2
BLTAFWM=$044
BLTALWM=$046
BLTAPTH=$050
BLTAPTL=$052
BLTBPTH=$04C
BLTCPTH=$048
BLTDPTH=$054
BLTAMOD=$064
BLTBMOD=$062
BLTCMOD=$060
BLTDMOD=$066
BLTADAT=$074
BLTBDAT=$072
BLTCON0=$040
BLTCON1=$042
BLTSIZE=$058

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1
PICTURE_DX=320		; vielfaches von 8
PICTURE_DY=256
PICTURE_DEPTH=5
COPPER_X=DISPLAY_X
COPPER_Y=DISPLAY_Y
COPPER_DX=41		; Breite in 8-Pixel-Blöcken
COPPER_DY=32		; Höhe in Blöcken von 8 Reihen
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+(COPPER_DY<<3)*(4+COPPER_DX*4)+4
; 10*4										Konfiguration der Anzeige
; DISPLAY_DEPTH*2*4							für Adressen der Bitebenen
; (1<<DISPLAY_DEPTH)*4						Palette
; (COPPER_DY<<3)*(4+COPPER_DX*4)			Bild über Copper
; 4											$FFFFFFFE

;---------- Macros ----------

WAIT_BLITTER:		MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)		; Äquivalent zum Testen von Bit 14%8=6 des höchstwertigen Bytes von DMACONR, das gut BBUSY entspricht
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM

;---------- Initialisierung ----------

; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5
	
; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanes

; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

; Hardware-Interrupts und DMA ausschalten

	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)
	
;---------- Copperlist ----------

; Konfiguration des Bildschirms

	movea.l copperlist,a0
	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+

; Kompatibilität OCS mit AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l bitplanes,d1
	move.w #DISPLAY_DEPTH-1,d2
_copperlistBitplanes:
	move.w d0,(a0)+
	addq.w #2,d0
	swap d1
	move.w d1,(a0)+
	move.w d0,(a0)+
	addq.w #2,d0
	swap d1
	move.w d1,(a0)+	
	addi.l #DISPLAY_DX>>3,d1
	dbf d2,_copperlistBitplanes

; Farben (in diesem Beispiel unbrauchbar)

	move.w #COLOR00,d0
	move.w #(1<<DISPLAY_DEPTH)-1,d1
_copperlistColors:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #$0000,(a0)+
	dbf d1,_copperlistColors

; Bild per MOVE

	move.w #((COPPER_Y&$00FF)<<8)!((((COPPER_X-4)>>2)<<1)&$00FE)!$0001,d0
	move.w #(COPPER_DY<<3)-1,d1
	move.b #-2,d3
_copperlistRows:
	add.b d3,d0
	neg.b d3
	move.w d0,(a0)+
	move.w #$FFFE,(a0)+
	move.w #COPPER_DX-1,d2
_copperlistCols:
	move.w #COLOR01,(a0)+
	move.w #$0000,(a0)+
	dbf d2,_copperlistCols
	addi.w #$0100,d0
	dbf d1,_copperlistRows

; Ende

	move.l #$FFFFFFFE,(a0)

;---------- Hauptprogramm ----------

; DMAs wieder herstellen

	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

; Füllen Sie die Bitebene so, dass alle Pixel auf COLOR01 abgebildet werden

	move.w #$FFFF,BLTBDAT(a5)
	move.w #0,BLTDMOD(a5)
	move.w #$01CC,BLTCON0(a5)	; Verwenden Sie nicht Quelle B, um BLTBDAT mit Strom zu versorgen, sondern D = B
	move.w #$0000,BLTCON1(a5)
	move.l bitplanes,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

; Hauptschleife


	WAIT_BLITTER
	move.w #$05CC,BLTCON0(a5)	; USEB=1, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTBMOD(a5)
	move.w #2,BLTDMOD(a5)


	; debug (start)
	move.w #1,incX
	move.w #1,incY
	move.w #0,d6
	move.w #0,d7
	; debug (end)
_loop:

_waitVERTB0:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #DISPLAY_Y+DISPLAY_DY,d0
	bne _waitVERTB0
_waitVERTB1:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #DISPLAY_Y+DISPLAY_DY+1,d0
	bne _waitVERTB1


	; Copperlist erstellen

	lea picture,a0
	; debug (start)
	move.w d7,d0
	mulu #PICTURE_DX<<1,d0
	add.l d6,d0
	add.l d0,a0
	; debug (end)
	movea.l copperlist,a1
	lea 10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+6(a1),a1
	move.w #COPPER_DY-1,d0
_copyMoves:
	moveq #8-1,d1
_copyMovesLines:
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(COPPER_DX<<6)!1,BLTSIZE(a5)
	lea COPPER_DX*4+4(a1),a1
	WAIT_BLITTER
	dbf d1,_copyMovesLines
	lea PICTURE_DX<<1(a0),a0
	dbf d0,_copyMoves

	; debug (start)
	; das Copperbild auf dem Bildschirm ist 40x32
	; Beachten Sie, dass, wenn Sie ganz rechts im Bild ankommen, der letzte MOVE einer Zeile
	; von zwei die erste Farbe der folgenden Zeile anzeigt	move.w incX,d0
	add.w d0,d6
	bge _xok1
	neg.w d0
	move.w d0,incX
	moveq #0,d6
	bra _xok2
_xok1:
	cmpi.w #PICTURE_DX-COPPER_DX-1,d6
	ble _xok2
	neg.w d0
	move.w d0,incX
	move.w #PICTURE_DX-COPPER_DX-1,d6
_xok2:
	move.w incY,d0
	add.w d0,d7
	bge _yok1
	neg.w d0
	move.w d0,incY
	moveq #0,d7
	bra _yok2
_yok1:
	cmpi.w #PICTURE_DY-COPPER_DY-1,d7
	ble _yok2
	neg.w d0
	move.w d0,incY
	move.w #PICTURE_DY-COPPER_DY-1,d7
_yok2:
	; debug (end)



	btst #6,$BFE001
	bne _loop

;---------- Ende ----------

_end:

; schalten Sie alle Hardware-Interrupts und DMAs aus.

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

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

	lea graphicslibrary,a1
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

	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanes,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Daten ----------

graphicslibrary:	dc.b "graphics.library",0
	even
copperlist:		dc.l 0
olddmacon:		dc.w 0
oldintena:		dc.w 0
oldintreq:		dc.w 0
picture:		incbin "dragonsun.rawc"			;320*256 5 bitplanes
incX:			DC.W 0
incY:			DC.W 0
bitplanes:		DC.L 0