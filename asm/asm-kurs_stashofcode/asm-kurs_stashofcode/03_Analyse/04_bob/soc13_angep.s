
; soc13_angep.s = bobRAWB.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Anzeigen und Bewegen eines 32 x 32 Pixel großen BOB in 32 Farben auf einem
; Hintergrund aus 5 Bitplanes im RAW-Blitter-Modus, mit Maskierung.

; Beachten Sie, dass bei der Berechnung der Adressen, um auf die Ordinate des BOBs
; in den Bitplanes zu zeigen, ADD.L Dn,An und nicht LEA (An,Dn.W),An verwendet
; werden, da bei 5 verschachtelten Bitplanes (RAW Blitter)
; der Offset 320*(256-BOB_DY)*5/8 > 32767... erreichen kann.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=5
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4
	; 10*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*4	Palette
	; 4						$FFFFFFFE
;----------------------------------------------------------
DIWSTRT_val = (DISPLAY_Y<<8)!DISPLAY_X
DIWSTOP_val = (((DISPLAY_Y+DISPLAY_DY)&255)<<8)!((DISPLAY_X+DISPLAY_DX)&255)	; Begrenzung bis $7F
DDFSTRT_val = ((DISPLAY_X-17)>>1)&$00FC											; oder &$00F8
DDFSTOP_val = (((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00F8)				; oder &$00F8

BPLCON0_val = (DISPLAY_DEPTH<<12)!$0200
BPLCON1_val = 0
BPLCON2_val = 0	; $0008															; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
BPL1MOD_val = (DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)
BPL2MOD_val = (DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)
;----------------------------------------------------------
BOB_X=DISPLAY_DX>>1				; Startadresse des Bobs auf dem Bildschirm X - Mitte des Bildschirms
BOB_Y=DISPLAY_DY>>1				; Startadresse des Bobs auf dem Bildschirm Y - Mitte des Bildschirms
BOB_DX=64
BOB_DY=64
BOB_DEPTH=DISPLAY_DEPTH
DEBUG=0

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
	move.l d0,copperlist

	; Speicher in Chip zuweisen auf 0 gesetzt für Hintergrund (background)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,background

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist angezeigt (front buffer)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanesA
	move.l bitplanesA,frontBuffer

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist Arbeit (back buffer)

	move.l #DISPLAY_DEPTH*(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanesB
	move.l bitplanesB,backBuffer

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

	movea.l copperlist,a0
	
	move.w #DIWSTRT,(a0)+				; Konfiguration des Bildschirms				
	move.w #DIWSTRT_val,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #DIWSTOP_val,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #DDFSTRT_val,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #DDFSTOP_val,(a0)+

	move.w #BPLCON0,(a0)+
	move.w #BPLCON0_val,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #BPLCON1_val,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #BPLCON2_val,(a0)+	

	move.w #BPL1MOD,(a0)+
	move.w #BPL1MOD_val,(a0)+			; RAW Blitter für ungerade Bitplanes
	move.w #BPL2MOD,(a0)+
	move.w #BPL1MOD_val,(a0)+			; RAW Blitter für gerade Bitplanes

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l frontBuffer,d1
	moveq #DISPLAY_DEPTH-1,d2			; Anzahl der Bitebenen, hier 5
_bitplanes:
	move.w d0,(a0)+						; Registeradresse BPL1PTH in Copperlist 
	swap d1								; Hi-Lo Anteil Adresse Wörter tauschen
	move.w d1,(a0)+						; hohes Wort der Adresse in Copperlist
	addq.w #2,d0						; Registeradresse 2 Bytes addieren 
	move.w d0,(a0)+						; Registeradresse BPL1PTL in Copperlist
	swap d1								; Hi-Lo Anteil Adresse Wörter tauschen
	move.w d1,(a0)+						; niedriges Wort der Adresse in Copperlist
	addq.w #2,d0						; Registeradresse 2 Bytes addieren, ergibt BPL2PTH
	addi.l #DISPLAY_DX>>3,d1			; Adresse nächste Bitplane (320/8=40 Bytes)	hier Unterschied zu normal !
	dbf d2,_bitplanes					; wiederholen für alle Bitebenen

	;Palette

	lea palette,a1
	move.w #COLOR00,d0
	moveq #(1<<DISPLAY_DEPTH)-1,d1
	IFNE DEBUG							; Füge einen unnötigen MOVE hinzu, der COLOR00 nicht beeinflusst,
										; um die Größe der Copperlist nicht zu verändern (kann nützlich sein)
	addq.w #2,d0
	move.w d0,(a0)+
	move.w (a1)+,(a0)+
	subq.w #1,d1
	ENDIF
_palette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_palette

	; Ende

	move.l #$FFFFFFFE,(a0)

	; copperlist aktivieren

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Wiederherstellung der DMA

	move.w #$83C0,DMACON(a5)			; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

;********** Hauptprogramm **********

	; Zeichnen Sie den Hintergrund aus 16 x 16 Quadraten aufeinanderfolgender
	; Farben, die auf Farbe 0 zurückspringen.

	moveq #0,d0							; Anfangsfarbe 
	movea.l background,a0				; Anfangsadresse Hintergrund 
	move.w #(DISPLAY_DY>>4)-1,d1		; 256/16=16 Reihen
_checkerDrawRows:
	move.w #(DISPLAY_DX>>4)-1,d2		; 320/16=20 Spalten
_checkerDrawCols:
	move.b d0,d3						; Farbenwert kopieren
	movea.l a0,a1						; Kopie Anfangsadresse Hintergrund
	move.w #DISPLAY_DEPTH-1,d4			; über alle Bitebenen
_checkerDrawBitplanes:
	lsr.b #1,d3							; nächster Farbwert
	bcc _checkerSkipBitplane			; Muster nicht in die Bitebene drucken, wenn Bedingung nicht erfüllt ist
	movea.l a1,a2						; Kopie Anfangsadresse Hintergrund
	move.w #16-1,d5						; jeweils 16 Zeilen
_checkerDrawLines:
	move.w #$FFFF,(a2)					; Muster
	lea DISPLAY_DEPTH*(DISPLAY_DX>>3)(a2),a2	; 5*(320/8) - nächste Zeile in der Bitebene
	dbf d5,_checkerDrawLines			; wiederholen, bis alle Zeilen fertig
_checkerSkipBitplane:
	lea DISPLAY_DX>>3(a1),a1			; 320/8=40 Bytes, nächste Bitebene	
	dbf d4,_checkerDrawBitplanes		; wiederholen für alle Bitebenen	 
	lea 2(a0),a0						; nächstes Quadtrat 16 Pixel weiter
	addq.b #1,d0						; nächste Farbe
	dbf d2,_checkerDrawCols				; nächste Spalte
	lea (16*DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)(a0),a0	; (16*5-1)*(320/8) zur Adresse hinzufügen
	dbf d1,_checkerDrawRows				; wiederholen bis alle 16 Reihen fertig sind

	; Kopieren Sie den Hintergrund in den Front- und Backpuffer.

	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),BLTBMOD(a5)	; Modulo B = (5-1)*(320/8)=160
	move.w #(DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),BLTDMOD(a5)	; Modulo D = (5-1)*(320/8)=160
	move.w #$05CC,BLTCON0(a5)			; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)			; keine Sondermodi	
	move.l background,a0				; Hintergrund
	move.l frontBuffer,a1				; Frontbuffer
	move.l backBuffer,a2				; Backbuffer
	move.w #DISPLAY_DEPTH-1,d0			; Anzahl Bitebenen
_copyBackground:
	move.l a0,BLTBPTH(a5)				; Quelle = Hintergrund
	move.l a1,BLTDPTH(a5)				; Ziel = Frontbuffer
	WAIT_BLITTER
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; 256 Zeilen * 320/16=20 Wörter Breite

	move.l a0,BLTBPTH(a5)				; Quelle = Hintergrund
	move.l a2,BLTDPTH(a5)				; Ziel = Backbuffer
	WAIT_BLITTER
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; 256 Zeilen * 320/16=20 Wörter Breite

	lea DISPLAY_DX>>3(a0),a0			; 320/8=40 Bytes , nächste Bitebene
	lea DISPLAY_DX>>3(a1),a1			; 320/8=40 Bytes , nächste Bitebene
	lea DISPLAY_DX>>3(a2),a2			; 320/8=40 Bytes , nächste Bitebene
	dbf d0,_copyBackground

	; Hauptschleife

_loop:

	; Warten, bis das Ende der Bildschirmdarstellung erreicht ist

	move.w #DISPLAY_Y+DISPLAY_DY,d0		; Zeile=$2c+256
	bsr _waitRaster						; auf die Rasterzeile warten

	; Debugging: Hintergrundfarbe am Anfang der Schleife auf rot ändern

	IFNE DEBUG
	move.w #$0F00,COLOR00(a5)			; rot
	ENDIF

	; Front- und Backpuffer umkehren

	move.l backBuffer,d0				; Adresse backBuffer speichern
	move.l frontBuffer,backBuffer		; Adresse frontBuffer nach backBuffer kopieren
	move.l d0,frontBuffer				; Adresse backBuffer nach frontBuffer kopieren
	movea.l copperlist,a0				; Adresse copperlist
	lea 10*4+2(a0),a0					; zur Anfangsadresse der Copperliste hinzufügen
	moveq #DISPLAY_DEPTH-1,d1			; über alle Bitebenen
_swapBuffers:
	swap d0								; Adresse backBuffer Hi-Lo tauschen
	move.w d0,(a0)						; hohen Teil der Adresse in Copperlist
	swap d0								; Adresse backBuffer Hi-Lo zurücktauschen
	move.w d0,4(a0)						; niedrigen Teil der Adresse in Copperlist
	lea 8(a0),a0						; nächster Bitplanepointer in Copperlist
	addi.l #DISPLAY_DX>>3,d0			; 320/8=40 Bytes nächste Bitebene
	dbf d1,_swapBuffers					; wiederholen bis alle fertig	

	; Löschen Sie die Zeilen im Backpuffer, in denen sich der Bob befand (recover not sophisticated!).

	move.w #0,BLTBMOD(a5)				; Modulo B = 0
	move.w #0,BLTDMOD(a5)				; Modulo D = 0
	move.w #$05CC,BLTCON0(a5)			; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)			; keine Sondermodi
	move.l background,a0				; Adresse Hintergrund
	move.w bobY+2,d0					; alte aktuelle Y-Position
	mulu #DISPLAY_DEPTH*(DISPLAY_DX>>3),d0  ; 5*(320/8=40 Bytes) 
	add.l d0,a0							; zur Anfangsadresse der Bitebene addieren
	move.l backBuffer,a1				; Adresse backBuffer
	add.l d0,a1							; zur Anfangsadresse der Bitebene addieren
	move.l a0,BLTBPTH(a5)				; Quelle = Hintergrund
	move.l a1,BLTDPTH(a5)				; Ziel = Backpuffer
	move.w #((BOB_DEPTH*BOB_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)	; 5*64 Zeilen * 320/16=20 Wörter Breite
	WAIT_BLITTER

	; Bewegen Sie den BOB, indem Sie ihn von den Rändern abprallen lassen.

	move.w bobX,d0						; aktuelle X-Position des Bobs
	move.w d0,bobX+2					; aktuelle X-Position des Bobs kopieren
	add.w bobSpeedX,d0					; neue X-Position, Geschwindigkeit addieren 
	bge _moveBobNoUnderflowX			; X-Rand nicht unterschritten? dann überspringen
	neg.w bobSpeedX						; Richtung umkehren
	add.w bobSpeedX,d0					; neue X-Position, Geschwindigkeit addieren 
	bra _moveBobNoOverflowX				; neuen Wert speichern
_moveBobNoUnderflowX:					;
	cmpi.w #DISPLAY_DX-BOB_DX,d0		; 320-64=256, d0 < 256 ?
	blt _moveBobNoOverflowX				; überspringen und neuen Wert speichern, ansonsten
	neg.w bobSpeedX						; Richtung umkehren
	add.w bobSpeedX,d0					; neue X-Position, Geschwindigkeit addieren 
_moveBobNoOverflowX:					;
	move.w d0,bobX						; neue X-Position des Bobs speichern

	move.w bobY,d0						; aktuelle Y-Position des Bobs
	move.w d0,bobY+2					; aktuelle Y-Position des Bobs kopieren
	add.w bobSpeedY,d0					; neue Y-Position, Geschwindigkeit addieren 
	bge _moveBobNoUnderflowY			;
	neg.w bobSpeedY						; Richtung umkehren
	add.w bobSpeedY,d0					; neue Y-Position, Geschwindigkeit addieren 
	bra _moveBobNoOverflowY				;
_moveBobNoUnderflowY:
	cmpi.w #DISPLAY_DY-BOB_DY,d0		; 256-64, d0 < 192?
	blt _moveBobNoOverflowY				; überspringen und neuen Wert speichern, ansonsten
	neg.w bobSpeedY						; Richtung umkehren
	add.w bobSpeedY,d0					; neue Y-Position, Geschwindigkeit addieren 
_moveBobNoOverflowY:
	move.w d0,bobY						; neue Y-Position des Bobs speichern

	; BOB zeichnen

	;moveq #0,d1						; wird nicht benötigt
	move.w bobX,d0						; aktuelle X-Position des Bobs
	move.w d0,d1						; Kopie
	and.w #$F,d0						; niedriges Wort maskieren
	ror.w #4,d0							; ins High-Byte verschieben	
	move.w d0,BLTCON1(a5)				; BSH3-0=Verschiebung
	or.w #$0FF2,d0						; ASH3-0=Verschiebung, USEA=1, USEB=0, USEC=1, USED=1, D=A+bC
	move.w d0,BLTCON0(a5)				; fertigen Wert in BPLCON0 laden
	lsr.w #3,d1							; multiplizieren * 8
	and.b #$FE,d1						; nur gerade Bytes zulassen

	move.w bobY,d0						; aktuelle Y-Position des Bobs
	mulu #DISPLAY_DEPTH*(DISPLAY_DX>>3),d0  ; 5*(320/8) = 200 Bytes , d0=d0*200 Zeile in der Bitebene finden
	add.l d1,d0							; das richtige Byte in der Zeile finden

	movea.l backBuffer,a0				; Adresse backBuffer
	add.l d0,a0							; richtige Bob-Adresse im backpuffer finden
	move.w #$FFFF,BLTAFWM(a5)			; alles passiert
	move.w #$0000,BLTALWM(a5)			; alles gelöscht 
	move.w #-2,BLTAMOD(a5)				; Modulo Bob
	move.w #0,BLTBMOD(a5)				; Modulo Maske
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTCMOD(a5)	; Modulo (320-(64+16))/8 = 30
	move.w #(DISPLAY_DX-(BOB_DX+16))>>3,BLTDMOD(a5)	; Modulo (320-(64+16))/8 = 30
	move.l #bob,BLTAPTH(a5)				; Quelle A - Bob
	move.l #mask,BLTBPTH(a5)			; Quelle B - Maske
	move.l a0,BLTCPTH(a5)				; Quelle C - backBuffer (Hintergrund)
	move.l a0,BLTDPTH(a5)				; Ziel D - backBuffer 
	move.w #(BOB_DEPTH*(BOB_DY<<6))!((BOB_DX+16)>>4),BLTSIZE(a5)	; 5*64 Zeilen * 64/16=4 Wörter Breite
	WAIT_BLITTER

	; Debugging: Hintergrundfarbe am Ende der Schleife auf grün ändern

	IFNE DEBUG
	move.w #$00F0,COLOR00(a5)			; grün
	ENDIF

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

	movea.l background,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanesA,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanesB,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l copperlist,a1
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

;---------- Warten auf vertikal blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!)  ----------

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
copperlist:			DC.L 0
background:			DC.L 0
bitplanesA:			DC.L 0
bitplanesB:			DC.L 0
backBuffer:			DC.L 0
frontBuffer:		DC.L 0
palette:
					DC.W $0000
					DC.W $0FFF
					DC.W $0700
					DC.W $0900
					DC.W $0B00
					DC.W $0D00
					DC.W $0F00
					DC.W $0070
					DC.W $0090
					DC.W $00B0
					DC.W $00D0
					DC.W $00F0
					DC.W $0007
					DC.W $0009
					DC.W $000B
					DC.W $000D
					DC.W $000F
					DC.W $0770
					DC.W $0990
					DC.W $0BB0
					DC.W $0DD0
					DC.W $0FF0
					DC.W $0707
					DC.W $0909
					DC.W $0B0B
					DC.W $0D0D
					DC.W $0F0F
					DC.W $0077
					DC.W $0099
					DC.W $00BB
					DC.W $00DD
					DC.W $00FF
bobX:				DC.W BOB_X, 0
bobY:				DC.W BOB_Y, 0
bobSpeedX:			DC.W 2
bobSpeedY:			DC.W 3
bob:
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0000, $0000, $0000, $0000
					DC.W $F000, $F000, $F000, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $00F0
					DC.W $F000, $F000, $F000, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $00F0
					DC.W $F000, $F000, $F000, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $00F0
					DC.W $F000, $F000, $F000, $F000
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $0000, $0000, $0000, $00F0
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $000F, $0F00, $000F, $0F00
					DC.W $0000, $000F, $0F0F, $0F00
					DC.W $0000, $0000, $0000, $000F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F000, $F000, $F000, $F0F0
					DC.W $00F0, $F000, $00F0, $F000
					DC.W $0000, $00F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $F0F0, $F0F0, $F0F0, $F000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $F0F0, $0000, $F0F0, $0000
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0000, $0000, $0000, $F0F0
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $000F, $000F, $000F, $000F
					DC.W $0F0F, $0000, $0F0F, $0000
					DC.W $0000, $0F0F, $0F0F, $0000
					DC.W $0000, $0000, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $00F0, $00F0, $00F0, $F000
					DC.W $F0F0, $0000, $F0F0, $00F0
					DC.W $0000, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $F000, $F000, $F000, $F000
					DC.W $F000, $00F0, $F000, $00F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $0000, $0000, $00F0, $F0F0
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $0F00, $0F00, $0F00, $0F00
					DC.W $0F00, $000F, $0F00, $000F
					DC.W $000F, $0F0F, $0F00, $0000
					DC.W $0000, $0000, $000F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F000, $F000, $F0F0, $00F0
					DC.W $F000, $00F0, $F000, $F0F0
					DC.W $00F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $F0F0, $F0F0, $F000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0000, $0000, $0000, $0000
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $00F0, $00F0, $00F0, $00F0
					DC.W $0000, $F0F0, $0000, $F0F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $0000, $0000, $F0F0, $F0F0
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $000F, $000F, $000F, $000F
					DC.W $0000, $0F0F, $0000, $0F0F
					DC.W $0F0F, $0F0F, $0000, $0000
					DC.W $0000, $0000, $0F0F, $0F0F
					DC.W $0F0F, $0F0F, $0F0F, $0F0F
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $00F0, $00F0, $F000, $F000
					DC.W $0000, $F0F0, $00F0, $F000
					DC.W $F0F0, $F0F0, $0000, $00F0
					DC.W $F0F0, $F0F0, $0000, $0000
					DC.W $F0F0, $F0F0, $0000, $0000
mask:
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR
					REPT 4
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					DC.W $0F0F, $0F0F, $0F0F, $0F0F, $0000
					ENDR
					REPT 4
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000
					ENDR

