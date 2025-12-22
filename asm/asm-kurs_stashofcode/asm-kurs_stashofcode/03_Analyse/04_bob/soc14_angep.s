
; soc14_angep.s = perfectBob.s

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Anzeige und Verschieben eines 64 x 64 Pixel großen BOBs (die Abmessungen können über die
; Konstanten BOB_DX und BOB_DY verändert werden, sofern BOB_DX ein Vielfaches von 16 ist)
; in 32 Farben auf einem Hintergrund aus 5 Bitplanes im RAW-Blitter-Modus, mit Maskierung.
; Im Gegensatz zu bobRAWB.s wird der Hintergrund auf dem einzigen rechteckigen Bereich 
; wiederhergestellt, den das BOB einnahm, bevor es verschoben wurde (fast perfekte
; Wiederherstellung, denn wenn das BOB keine transparenten Pixel enthält, weil es ein
; Rechteck ist, kann man sagen, dass nur die Pixel, die sie überdecken, wiederhergestellt
; werden, was nützlich ist, um Fenster zu verwalten).

; In der Realität könnte man auch einfach nur den Hintergrund wiederherstellen, ohne ihn
; zu verdecken. Wenn sich der Hintergrund zwischen dem Zeitpunkt, an dem das BOB angezeigt
; wurde, und dem Zeitpunkt, an dem das BOB gelöscht werden soll, nicht geändert hat,
; können Sie die Wörter in jeder Zeile, die das BOB überdeckt hat, auch wenn es nur ein 
; Teil davon war, vollständig kopieren. Was perfekt ist, ist nicht unbedingt das Beste,
; denn es ist nicht immer das Effektivste :) Daher habe ich eine optimierte Version von
; _clearBOB hinzugefügt, _clearBOBFast. Verwenden Sie die Konstante CLEARFAST, um zwischen
; _clearBOB und _clearBOBFAst zu wechseln.

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=5
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*2*4+4
	; 10*4						Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4			Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*2*4	Palette
	; 4							$FFFFFFFE
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
DEBUG=1			; 0 : Zeigen Sie die verbrauchte Zeit an, indem Sie während der Berechnungen die Farbe von 0 auf rot ändern.
				; 1 : Verbrauchte Zeit nicht anzeigen
CLEARFAST=1		; 0 : _clearBOB verwenden (d.h. den Hintergrund möglichst genau wiederherstellen)
				; 1 : _clearBOBFast verwenden (d.h.: den Hintergrund auf breitester Ebene wiederherstellen)

;********** Macros **********

; Warten Sie auf den Blitter. Wenn der zweite Operand eine Adresse ist, testet BTST
; nur die Bits 7-0 des gezeigten Bytes, aber da der erste Operand als Modulo-8-Bitnummer
; behandelt wird, bedeutet BTST #14,DMACONR(a5), dass das Bit 14%8=6 des höchstwertigen
; Bytes von DMACONR getestet wird, was gut zu BBUSY passt...

WAIT_BLITTER:	MACRO
_WAIT_BLITTER0\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER0\@
_WAIT_BLITTER1\@
	btst #14,DMACONR(a5)
	bne _WAIT_BLITTER1\@
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

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist (für Anzeige) (front buffer)

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,frontBuffer

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt (für Erstellung) (back buffer)

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,backBuffer

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

	;---------- Copperlist ----------

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

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l frontBuffer,d1
	moveq #DISPLAY_DEPTH-1,d2			; Anzahl der Bitebenen, hier 5
_copperListBitplanes:
	move.w d0,(a0)+						; Registeradresse BPL1PTH in Copperlist 
	swap d1								; Hi-Lo Anteil Adresse Wörter tauschen
	move.w d1,(a0)+						; hohes Wort der Adresse in Copperlist
	addq.w #2,d0						; Registeradresse 2 Bytes addieren 
	move.w d0,(a0)+						; Registeradresse BPL1PTL in Copperlist
	swap d1								; Hi-Lo Anteil Adresse Wörter tauschen
	move.w d1,(a0)+						; niedriges Wort der Adresse in Copperlist
	addq.w #2,d0						; Registeradresse 2 Bytes addieren, ergibt BPL2PTH
	addi.l #DISPLAY_DX>>3,d1			; Adresse nächste Bitplane (320/8=40 Bytes)	hier Unterschied zu normal !
	dbf d2,_copperListBitplanes			; wiederholen für alle Bitebenen

	; Palette

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

	; DMA aktivieren

	bsr _waitVERTB
	move.w #$83C0,DMACON(a5)			; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; die Copperlist starten

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

BOB_DX=64		; Vielfaches von 16 (nur für _drawBOB, da _clearBOB flexibler ist: siehe dessen Anleitung)
BOB_DY=64
BOB_X=(DISPLAY_DX-BOB_DX)>>1
BOB_Y=(DISPLAY_DY-BOB_DY)>>1

	; Zeichnen Sie den Hintergrund aus 16 x 16 Quadraten aufeinanderfolgender
	; Farben, die auf Farbe 0 zurückspringen.

	moveq #0,d0							; Anfangsfarbe 
	movea.l background,a0				; Anfangsadresse Hintergrund 
	move.w #(DISPLAY_DY>>4)-1,d1		; 256/16=16 Reihen
_checkerDrawRows:
	move.w #(DISPLAY_DX>>4)-1,d2		; 320/16=20 Spalten
_checkerDrawCols:
	move.b d0,d3						; Farbwert kopieren
	movea.l a0,a1						; Kopie Anfangsadresse Hintergrund
	move.w #DISPLAY_DEPTH-1,d4			; über alle Bitebenen, hier 5
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

	lea DISPLAY_DX>>3(a0),a0			; 320/8=40 Bytes , nächste Bitebene Hintergrund
	lea DISPLAY_DX>>3(a1),a1			; 320/8=40 Bytes , nächste Bitebene frontbuffer
	lea DISPLAY_DX>>3(a2),a2			; 320/8=40 Bytes , nächste Bitebene backbuffer
	dbf d0,_copyBackground

	; Erstellen Sie das BOB, indem Sie einen Teil des Hintergrunds kopieren und
	; ihn gleichzeitig mit der Maske kombinieren (dieser Schritt ist erforderlich, 
	; da die transparenten Pixel des BOBs in diesem tatsächlich transparent sein müssen,
	; da die Maske bei der Anzeige des BOBs nur auf den Hintergrund angewendet wird:
	; Die in _drawBOB verwendete Formel lautet D=A+bC und nicht D=BA+bC).

	move.w #$0788,BLTCON0(a5)			; USEA=0, USEB=1, USEC=1, USED=1, D=BC
	move.w #$0000,BLTCON1(a5)			; keine Sondermodi
	move.w #2,BLTBMOD(a5)				; Modulo B = 2
	move.w #(DISPLAY_DX-BOB_DX)>>3,BLTCMOD(a5)	; Modulo C = (320-64)/8=32
	move.w #0,BLTDMOD(a5)				; Modulo D = 0
	move.l #BOBMask,BLTBPTH(a5)			; Quelle B = Bob Maske
	move.l background,BLTCPTH(a5)		; Quelle C = Hintergrund
	move.l #BOB,BLTDPTH(a5)				; Ziel D - Bob
	move.w #((DISPLAY_DEPTH*BOB_DY)<<6)!(BOB_DX>>4),BLTSIZE(a5)	; 5*64 Zeilen und 64/16=4 Wörter Breite
	WAIT_BLITTER
	
	; Hauptschleife

_loop:

	; BOB löschen

	lea clearBOBData,a0					; Zeiger auf Block mit 20 Bytes Nullen 
	move.w #DISPLAY_DEPTH,OFFSET_CLEARBOB_DEPTH(a0)		; 0(a0)  - Anzahl Bitebenen
	move.w oldBobX,OFFSET_CLEARBOB_X(a0)				; 2(a0)	 - Position X
	move.w oldBobY,OFFSET_CLEARBOB_Y(a0)				; 4(a0)	 - Position Y
	move.w #BOB_DX,OFFSET_CLEARBOB_DX(a0)				; 6(a0)	 - Breite X
	move.w #BOB_DY,OFFSET_CLEARBOB_DY(a0)				; 8(a0)  - Höhe Y
	move.l background,OFFSET_CLEARBOB_SRC(a0)			; 10(a0) - Adresse background
	move.l backBuffer,OFFSET_CLEARBOB_DST(a0)			; 14(a0) - Adresse backBuffer
	move.w #DISPLAY_DX,OFFSET_CLEARBOB_SRCDSTWIDTH(a0)	; 18(a0) - Displaybreite 320
	IFNE CLEARFAST
	bsr _clearBOB										; Löschen eines BOB in einer Fläche in RAWB
	ELSE
	bsr _clearBOBFast									; optimierte Version 
	ENDC
	
	; Bewegen Sie den BOB, indem Sie ihn von den Rändern abprallen lassen.

	move.w bobX,d0						; aktuelle X-Position des Bobs
	move.w d0,oldBobX					; aktuelle X-Position des Bobs kopieren
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
	move.w d0,oldBobY					; aktuelle Y-Position des Bobs kopieren
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

	; BOB anzeigen

	lea drawBOBData,a0								; Adresse auf Anfang von Block von 30 Bytes mit Nullen
	move.w #DISPLAY_DEPTH,OFFSET_DRAWBOB_DEPTH(a0)	; 0(a0) -  Anzahl Bitebenen
	move.w bobX,OFFSET_DRAWBOB_X(a0)				; 2(a0)	-  Position X
	move.w bobY,OFFSET_DRAWBOB_Y(a0)				; 4(a0) -  Position Y
	move.w #BOB_DX,OFFSET_DRAWBOB_DX(a0)			; 6(a0) -  Breite X (64)
	move.w #BOB_DY,OFFSET_DRAWBOB_DY(a0)			; 8(a0) -  Breite Y (64)
	move.l #BOBMask,OFFSET_DRAWBOB_MASK(a0)			; 10(a0) - Adresse Bob-Maske
	move.l #BOB,OFFSET_DRAWBOB_SRC(a0)				; 14(a0) - Adresse Bob
	move.w #BOB_DX,OFFSET_DRAWBOB_SRCWIDTH(a0)		; 18(a0) - Breite X (64)
	move.w #0,OFFSET_DRAWBOB_SRCX(a0)				; 20(a0) - 0
	move.w #0,OFFSET_DRAWBOB_SRCY(a0)				; 22(a0) - 0
	move.l backBuffer,OFFSET_DRAWBOB_DST(a0)		; 24(a0) - Adresse backBuffer
	move.w #DISPLAY_DX,OFFSET_DRAWBOB_DSTWIDTH(a0)	; 28(a0) - Displaybreite 320
	bsr _drawBOB									; Bob zeichnen

	; Debugging: Hintergrundfarbe am Ende der Schleife auf xxx ändern

	WAIT_BLITTER
	IFNE DEBUG
	move.w #$0000,COLOR00(a5)
	ENDC
	moveq #1,d0
	jsr _wait
	IFNE DEBUG
	move.w #$0F00,COLOR00(a5)
	ENDC

	; Front- und Backpuffer umkehren

	move.l frontBuffer,d0				; Adresse frontBuffer in d0
	move.l backBuffer,d1				; Adresse backBuffer in d1
	move.l d0,backBuffer				; Adressen frontBuffer und
	move.l d1,frontBuffer				; backpuffer tauschen
	movea.l copperlist,a0				; Adresse copperlist
	lea 10*4+2(a0),a0					; zur Anfangsadresse der Copperliste hinzufügen
	moveq #DISPLAY_DEPTH-1,d0			; über alle Bitebenen
	move.l frontBuffer,d1				; Bitplanepointer in Copperliste auf frontbuffer
_swapBitplanes:
	swap d1								; Adresse frontBuffer Hi-Lo tauschen
	move.w d1,(a0)						; hohen Teil der Adresse in Copperlist
	swap d1								; Adresse frontBuffer Hi-Lo zurücktauschen
	move.w d1,4(a0)						; niedrigen Teil der Adresse in Copperlist
	addi.l #DISPLAY_DX>>3,d1			; 320/8=40 Bytes nächste Bitebene
	lea 2*4(a0),a0						; nächster Bitplanepointer in Copperlist
	dbf d0,_swapBitplanes				; wiederholen bis alle fertig	

	; Testen eines Drucks der linken Maustaste

	btst #6,$BFE001
	bne _loop

;********** Ende **********

	; Hardware-Interrupts und DMAs ausschalten

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

	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l background,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l frontBuffer,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l backBuffer,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

	; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"
	INCLUDE "common/wait.s"


;---------- Löschen eines BOB in einer Fläche in RAWB ----------

; Eingang(s) :
;	(die Struktur clearBOBData)
; Ausgang(s) :
;	(nichts)
; Hinweis:
; Das ist etwas mehr als das Löschen eines BOB, da die Breite des Bereichs
; von der Quelle in das Ziel kopiert wird, kann beliebig sein.
;
; Die Breite des zu kopierenden Bereichs ist auf DISPLAY_DX beschränkt
; (ansonsten müssen Sie die Größe von copyMaskData ändern).
;
; Achtung! Kein WAIT_BLITTER am Ende.

_clearBOB:
	movem.l d0-d4/a0-a1,-(sp)			; Register auf dem Stack retten
	lea clearBOBData,a0					; Adresse auf Anfang von Block mit 20 Bytes

	WAIT_BLITTER

	;++++++++++ Die Maske aufbauen (Erinnerung: In Bezug auf A werden BLTAFWM und 
	; BLTALWM mit AND verknüpft, wenn der BOB auf einem Wort steht). ++++++++++

; In jedem Fall enthält die Maske mindestens ein Wort, das standardmäßig auf $FFFF initialisiert und
; gezählt wird. Beachten Sie, dass die Anzahl der Wörter sicherlich nicht 255 übersteigt, sodass die 
; Anrechnung in einem Byte erfolgt (d.h. ADDQ.B und nicht ADDQ.W im Folgenden).
	
	lea clearBOBMask,a1					; Zeiger auf Anfang von Block von 20 Wörtern mit Null
	move.w #$FFFF,(a1)					; an den Anfang des Blocks $FFFF speichern
	moveq #1,d4							; d4=Anzahl Wörter mindestens 1
	move.w OFFSET_CLEARBOB_X(a0),d0		; 2(a0) - Position X
	move.w OFFSET_CLEARBOB_DX(a0),d1	; 6(a0) - Breite X (64)
	move.w d0,d2						; Kopie  Position X
	add.w d1,d2							; Position X + Breite X

; Verschiebt das erste Wort der Maske, falls der BOB nicht auf einer Abszisse beginnt, die ein Vielfaches von 16 ist.

	move.w #$FFFF,d3	; 
	and.w #$000F,d0		; Zur Erinnerung: LSR Dx,Dy = LSR (Dx % 64),Dy: Für LSR (Dx % 16),Dy würde es also genügen,
						; die Bits 5-4 von D0 durch AND.B #$0F,D0 zu löschen, aber D0 wird für ein späteres ADD.W
						; verwendet, so dass auch seine 8 höchstwertigen Bits gelöscht werden müssen.
	beq _copyAreaNoFirstWordShift		; wenn Ergebnis 0, dann überspringen
	lsr.w d0,d3							; ansonsten verschieben
	move.w d3,(a1)						; Ergebnis im Block speichern

_copyAreaNoFirstWordShift:

; Reduzieren Sie die Anzahl der noch zu verarbeitenden Maskenbits um die Anzahl der Maskenbits, die im ersten Wort
; vorkommen (oder vorkommen können, da die Maske vielleicht weniger breit ist): DX -= 16 - X. Diese Länge wird
; null oder negativ, wenn die Maske nur das erste Wort fasst. In diesem Fall sollten Sie direkt damit beginnen,
; das letzte Wort zu bestimmen.

	subi.w #16,d1						; -16
	add.w d0,d1							; Position X 
	ble _copyAreaNoMiddleWords			; <=0?, wenn ja überspringen

; An dieser Stelle wissen wir, dass sich die Maske über das erste Wort hinaus auf mindestens ein weiteres Wort
; erstreckt. Es gibt drei mögliche Fälle (ein mittleres Wort ist ein Wort, bei dem alle Bits auf 1 gesetzt sind,
; das Endwort ist ein Wort, bei dem nur einige Bits auf 1 gesetzt sind): 
; (1) mittlere Wörter ohne Endwort,
; (2) mittlere Wörter und ein Endwort, 
; (3) nur ein Endwort. 
; Zählen Sie vorerst ein weiteres Wort und initialisieren Sie dieses Wort auf $FFFF.
	
	moveq #2,d4							; d4=2 Anzahl Wörter 2
	addq.l #2,a1						; Adresse um 2 Bytes erhöhen um
	move.w #$FFFF,(a1)					; in das 2. Wort des Blocks $FFFF zu speichern

; Zählen Sie die mittleren Wörter: Das ist die verbleibende Länge geteilt durch 16. Wenn es keine
; mittleren Wörter gibt, versuchen Sie direkt, das letzte Wort zu bestimmen.

	lsr.w #4,d1							; /16
	beq _copyAreaNoMiddleWords			; 0?, wenn ja überspringen

; Addieren Sie die Anzahl der mittleren Wörter zur Anzahl der Wörter, wobei Sie derzeit davon ausgehen,
; dass das letzte Wort ein mittleres Wort ist, so dass es bereits früher gezählt worden wäre (MOVEQ #2,d4).

	add.b d1,d4							; d4=3+2=5 Bobreite in Wörtern
	subq.b #1,d4						; d4=5-1=4 Bobreite in Wörtern

; Fügen Sie die mittleren Wörter hinzu, die also Wörter mit $FFFF sind.

	move.w #$FFFF,d0					; d0=$FFFF
_copyAreaSetMiddleWords:
	move.w d0,(a1)+						; Wert $FFFF im Block speichern
	subq.w #1,d1						; d1=3-1=2
	bne _copyAreaSetMiddleWords			; <>0?, wenn ja überspringen

; Überprüfen, ob das Endwort ein Mittelwort ist...

	and.b #$0F,d2						; unteres Byte maskieren
	beq _copyAreaNoLastWordShift		; 0?, wenn ja überspringen

; ...und wenn das Endwort kein Medianwort ist, zählen Sie ein weiteres Wort und initialisieren Sie
; dieses Wort auf $FFFF. Da es nicht nötig ist, diesen Test zu wiederholen, beginnen wir direkt 
; damit, das Endwort zu verschieben.

	addq.b #1,d4						; d4 = Bobreite in Wörtern
	move.w #$FFFF,(a1)					; Wert im Block speichern
	bra _copyAreaShiftLastWord			; folgende Zeilen überspringen bis Label
_copyAreaNoMiddleWords:

; Hier kommt man an, egal ob es mittlere Wörter gibt oder nicht. Das laufende Wort ist das
; letzte Wort. Es kann mit dem ersten Wort verwechselt werden. Ist dies nicht der Fall,
; wurde es mit $FFFF initialisiert. Deshalb wird die hier berechnete Maske durch AND mit
; dem aktuellen Wort verknüpft, um das Endwort zu erzeugen.


	move.w #$FFFF,d0					; d0 = $FFFF
	and.b #$0F,d2						; niedrige Byte maskieren
	beq _copyAreaNoLastWordShift		; wenn Null, überspringen
_copyAreaShiftLastWord:
	lsr.w d2,d0							; ansonsten um d2 Stellen verschieben
	not.w d0							; negieren
	and.w d0,(a1)						; Wert maskieren
_copyAreaNoLastWordShift:

; Diese unumgänglichen Zuordnungen wurden an das Ende verschoben, um sie nicht mehrfach in
; all dem Vorangegangenen unterbringen zu müssen.

	move.w d0,BLTALWM(a5)				; BLTALWM - ermittelter Maskenwert	$FFFF
	move.w d3,BLTAFWM(a5)				; BLTAFWM - ermittelter Maskenwert	$FFFF

	;++++++++++ Zeiger und Modulos berechnen ++++++++++

	; Berechnen Sie den Offset die Zeiger der Quelle und des Ziels

	moveq #0,d0									; d0 zurücksetzen
	move.w OFFSET_CLEARBOB_X(a0),d0				; 2(a0) - Position X				128 ($80)
	lsr.w #3,d0									; /8									($10)
	and.b #$FE,d0								; gerade								($10)
	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d1	; 18(a0) - Displaybreite 320		320 ($140)
	lsr.w #3,d1									; /8									($28)
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1			; 0(a0)  - Anzahl Bitebenen hier 5	5*$28=$C8=200
	mulu OFFSET_CLEARBOB_Y(a0),d1				; 4(a0)	 - Position Y			  $60*$c8=$4B00				
	add.l d1,d0									; Adresse Quelle						 =$4B10	

	movea.l OFFSET_CLEARBOB_SRC(a0),a1			; 10(a0) - Adresse background		a1=$26038
	add.l d0,a1									; zur Zieladresse hinzufügen		a1=$26038+$4B10=$2AB48
	move.l a1,BLTAPTH(a5)						; Quelle A = Bob					  =$2AB48
	movea.l OFFSET_CLEARBOB_DST(a0),a1			; 14(a0) - Adresse backBuffer		  =$3F038
	add.l d0,a1									; zur Adresse backpuffer hinzufügen a1=$3F038+$4B10=$43B48
	move.l a1,BLTCPTH(a5)						; Quelle C = $43B48 (Hintergrund)
	move.l a1,BLTDPTH(a5)						; Ziel D =	 $43B48 (Hintergrund)
	move.l #clearBOBMask,BLTBPTH(a5)			; Quelle B = Adresse Anfang von Block von 20 Wörtern mit Null
												; Quelle B - Maske in diesem Fall Wert $FFFFFFFF
	; Modulos berechnen

	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d0	; 18(a0) - Displaybreite 320		320=$140
	lsr.w #3,d0									; /8								 40=$28
	move.w d4,d1								; d1=4
	add.w d1,d1									; *2 --> d1=8						(320/8)-(4*2)=32 = $20
	sub.w d1,d0									; d0=$28-8=$20	fertiger Modulo-Wert
	move.w d0,BLTAMOD(a5)						; Modulo A =$20 (32)	Bob
	move.w d0,BLTCMOD(a5)						; Modulo C =$20 (32)    Hintergrund
	move.w d0,BLTDMOD(a5)						; Modulo D =$20 (32)	Hintergrund
	neg.w d1									; d1=-4 ($FFF8)
	move.w d1,BLTBMOD(a5)						; Modulo B = -4			Bob-Maske

	;++++++++++ Kopieren ++++++++++

	move.w #$0FF2,BLTCON0(a5)			; ASH3-0=0, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w #$0000,BLTCON1(a5)			; keine Sondermodi
	move.w OFFSET_CLEARBOB_DY(a0),d1	; 8(a0)										= $40
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1	; 0(a0)  - Anzahl Bitebenen hier 5			= 5*$40=$140
	lsl.w #6,d1							; *64 (Anzahl Zeilen)
	or.w d4,d1							; d4=4 Anzahl der Wörter 4 = 64Bit breit
	move.w d1,BLTSIZE(a5)				; Blitter starten

	movem.l (sp)+,d0-d4/a0-a1			; Register wiederherstellen
	rts

clearBOBData:
OFFSET_CLEARBOB_DEPTH=0				; die Offsets für 0(a0)
OFFSET_CLEARBOB_X=2					; 2(a0) - Position X
OFFSET_CLEARBOB_Y=4					; 4(a0) - Position Y
OFFSET_CLEARBOB_DX=6				; 6(a0) - Breite X (64)
OFFSET_CLEARBOB_DY=8				; 8(a0)
OFFSET_CLEARBOB_SRC=10				; 10(a0)
OFFSET_CLEARBOB_DST=14				; 14(a0)
OFFSET_CLEARBOB_SRCDSTWIDTH=18		; 18(a0)
DATASIZE_CLEARBOB=20				; 20
	BLK.B DATASIZE_CLEARBOB,0		; Block von 20 Bytes mit Nullen

clearBOBMask:
	BLK.W DISPLAY_DX>>4,0			; 320/16=20 Block von 20 Wörtern mit Null

;---------- Löschen eines BOB in einer Fläche in RAWB (optimierte Version) ----------

; Eingang(s) :
;	(die Struktur clearBOBData)
; Ausgang(s) :
;	(nichts)
; Hinweis:
; Dies ist eine optimierte Version von _clearBOB, die lediglich alle
; Wörter, die auch nur teilweise vom BOB belegt sind, also nicht maskiert werden.
;
; Achtung! Kein WAIT_BLITTER am Ende.

_clearBOBFast:
	movem.l d0-d3/a0-a1,-(sp)			; Register auf dem Stack retten
	lea clearBOBData,a0					;

	WAIT_BLITTER

	; Berechnen Sie die Anzahl der teilweise oder vollständig betroffenen Wörter

	moveq #0,d3
	move.w OFFSET_CLEARBOB_X(a0),d0		; 2(a0) - Position X
	move.w OFFSET_CLEARBOB_DX(a0),d1	; 6(a0) - Breite X (64)
	move.w d1,d2						; Kopie d1
	add.w d0,d2							; Position X + Breite X

	and.w #$000F,d0						; untere Bits maskieren, wenn 0
	beq _clearBOBFastLeftAligned		; wenn 0, weiter bei clearBOBFastLeftAligned
	moveq #1,d3							; d3 = %0001
	subi.w #16,d1						; -16
	add.w d0,d1							; zur X-Position hinzufügen
	ble _clearBOBFastRightAligned		; wenn <0, weiter bei clearBOBFastRightAligned
_clearBOBFastLeftAligned:
	lsr.w #4,d1							; /16
	add.b d1,d3							; Breite in Wörtern für BLTSIZE
	and.b #$0F,d2						; untere Bits maskieren
	beq _clearBOBFastRightAligned		; wenn 0, weiter bei _clearBOBFastRightAligned
	addq.b #1,d3						; Breite in Wörtern für BLTSIZE
_clearBOBFastRightAligned:

	; Berechnen des Offsets der Quell- und Zielzeiger

	moveq #0,d0							; d0 zurücksetzen
	move.w OFFSET_CLEARBOB_X(a0),d0		; 2(a0) - Position X
	lsr.w #3,d0							; /8
	and.b #$FE,d0						; gerade
	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d1	; 18(a0) - Displaybreite 320
	lsr.w #3,d1							; /8 (320/8=40 Bytes)
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1	; 0(a0)  - Anzahl Bitebenen hier 5
	mulu OFFSET_CLEARBOB_Y(a0),d1		; 4(a0)	 - Position Y
	add.l d1,d0							; Offset um richtiges Byte in der Bitebene zu finden

	movea.l OFFSET_CLEARBOB_SRC(a0),a1	; 10(a0) - Adresse background
	add.l d0,a1							; zum Zeiger hinzufügen
	move.l a1,BLTBPTH(a5)				; BLTBPTH
	movea.l OFFSET_CLEARBOB_DST(a0),a1	; 14(a0) - Adresse backBuffer
	add.l d0,a1							; zum Zeiger hinzufügen
	move.l a1,BLTDPTH(a5)				; BLTDPTH

	; Modulos berechnen

	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d0	; 18(a0) - Displaybreite 320
	lsr.w #3,d0							; /8 (320/8=40 Bytes)
	move.w d3,d1						; Breite in Wörtern für BLTSIZE 
	add.w d1,d1							; *2, Modulo wird in Bytes angegeben
	sub.w d1,d0							; (320/8)-(Bobbreite in Bytes)
	move.w d0,BLTBMOD(a5)				; BLTBMOD beide Register gleicher Wert
	move.w d0,BLTDMOD(a5)				; BLTDMOD beide Register gleicher Wert

	; Kopieren

	move.w #$05CC,BLTCON0(a5)			; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)			; keine Sondermodi	
	move.w OFFSET_CLEARBOB_DY(a0),d0	; 8(a0)	Höhe Y (64)
	mulu OFFSET_CLEARBOB_DEPTH(a0),d0	; 0(a0) - Anzahl Bitebenen hier 5
	lsl.w #6,d0							; Anzahl Zeilen an richtige Position (*64) verschieben
	or.w d3,d0							; Anzahl Wörter Breite hinzufügen
	move.w d0,BLTSIZE(a5)				; Blitter starten

	movem.l (sp)+,d0-d3/a0-a1			; Register wiederherstellen
	rts

;---------- Anzeige eines BOB in einer RAWB-Fläche ----------

; Eingang(s) :
;	(die Struktur drawBOBData)
; Ausgang(s) :
;	(nichts)
; Bemerkung:
; Der BOB wird aus der Quelle an einer Abszisse ausgeschnitten, die ein Vielfaches von 16 ist,
; und seine Breite muss ein Vielfaches von 16 sein.
;
; Quelle und Ziel müssen die gleiche Tiefe haben, und ihre
; Daten müssen in RAWBs organisiert sein.
;
; Das Modulo der Maske muss 0 sein (d.h. ihre Breite ist die Breite von BOB + 16).
;
; Achtung! Kein WAIT_BLITTER am Ende.

_drawBOB:
	movem.l d0-d1/a0-a2,-(sp)			; Register auf dem Stack retten
	WAIT_BLITTER

	; Faktorisierbarer Teil, wenn mehrere BOBs nacheinander angezeigt werden

	move.w #$FFFF,BLTAFWM(a5)			; alles passiert
	move.w #$0000,BLTALWM(a5)			; alles gelöscht
	lea drawBOBData,a0					; Adresse Anfang Block mit Bobdaten
	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d0	; 18(a0) - Displaybreite 320
	sub.w OFFSET_DRAWBOB_DX(a0),d0			;  6(a0) - Breite X (64)
	subi.w #16,d0						; -16
	asr.w #3,d0							; /8
	move.w d0,BLTAMOD(a5)				; Modulo A  ((320-64)-16)/8=30
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d0	; 28(a0) Displaybreite 320
	sub.w OFFSET_DRAWBOB_DX(a0),d0		;  6(a0) - Breite X (64)
	subi.w #16,d0						; -16
	asr.w #3,d0							; /8
	move.w d0,BLTCMOD(a5)				; Modulo C  ((320-64)-16)/8=30

	; Holen Sie sich einen Zeiger auf das BOB an seinen Startkoordinaten (seine Abszisse ist ein Vielfaches von 16).

	movea.l OFFSET_DRAWBOB_SRC(a0),a1	; 14(a0) Adresse Bob
	moveq #0,d0							; d0 zurücksetzen
	move.w OFFSET_DRAWBOB_SRCX(a0),d0	; 20(a0) - 0 (Vielfaches von 16)
	lsr.w #3,d0							; /8
	and.b #$FE,d0						; gerade
	add.l d0,a1							; Adresse Bob + Offset Bob (Byte in der Zeile X-Position)
	move.w OFFSET_DRAWBOB_SRCY(a0),d0	; 22(a0) - Zeile (zu Beginn 0)
	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d1	; 18(a0) - Displaybreite 320
	lsr.w #3,d1							; /8 => 40 Bytes
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1	; multipliziert mit Anzahl Bitebenen 5*40 Bytes = 200 Bytes
	mulu d1,d0							; 200 Bytes * 0 = 0
	add.l d0,a1							; zur Anfangsadresse des Bobs hinzufügen

	; Einen Zeiger auf den Standort des BOB an seinen Ankunftskoordinaten abrufen

	movea.l OFFSET_DRAWBOB_DST(a0),a2	; 24(a0) Adresse backBuffer
	moveq #0,d0							; d0 zurücksetzen
	move.w OFFSET_DRAWBOB_X(a0),d0		; 2(a0) - Position X
	lsr.w #3,d0							; /8
	and.b #$FE,d0						; gerade
	add.l d0,a2							; zur Adresse backbuffer hinzufügen (Byte in der Zeile)
	move.w OFFSET_DRAWBOB_Y(a0),d0		; Y-Position des Bobs
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1	; 28(a0) Displaybreite 320
	lsr.w #3,d1							; /8 => 40 Bytes
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1	; multipliziert mit Anzahl Bitebenen 5*40 Bytes = 200 Bytes
	mulu d1,d0							; 200 Bytes * Zeile Bob Position Y 
	add.l d0,a2							; Byte Position in der Bitebene 

	; BOB anzeigen

	move.w OFFSET_DRAWBOB_X(a0),d0		; 2(a0) - Position X
	and.w #$000F,d0						; untere 8 maskieren
	ror.w #4,d0							; und ins hohe Byte verschieben (B-Shifter)
	move.w d0,BLTCON1(a5)				; BSH3-0=Verschiebung
	or.w #$0FF2,d0						; ASH3-0=Verschiebung, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w d0,BLTCON0(a5)				; und Wert in BLTCON0 laden
	move.w OFFSET_DRAWBOB_DX(a0),d0		; 6(a0) - Breite X (64)
	addi.w #16,d0						; Breite um 16 Pixel erhöhen
	 
; Wenn alle Zeilen der Maske identisch sind, könnte die Maske eine Zeile sein, die vom Blitter
; wiederholt wird, anstatt in den Daten wiederholt zu werden :
; BOBMask:	BLK.W BOB_DX>>4,$F0F0
;			DC.W $0000
; Dazu müsste der Modulo der Maske lauten -((BOB_DX+16)>>3) :
;	move.w d0,d1
;	lsr.w #3,d1
;	neg.w d1
;	move.w d1,BLTBMOD(a5)
	move.w #0,BLTBMOD(a5)				; Modulo B
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1	; 28(a0) Displaybreite 320
	sub.w d0,d1							; - Bobbreite 
	lsr.w #3,d1							; /8
	move.w d1,BLTDMOD(a5)				; Modulo D - Ziel
	move.l a1,BLTAPTH(a5)				; Quelle A - Bob
	move.l OFFSET_DRAWBOB_MASK(a0),BLTBPTH(a5)	; 10(a0)
	move.l a2,BLTCPTH(a5)				; Quelle C - backBuffer
	move.l a2,BLTDPTH(a5)				; Ziel D - backBuffer
	move.w OFFSET_DRAWBOB_DY(a0),d1		; 8(a0) Breite X (64)
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1	; * Anzahl Bitebenen
	lsl.w #6,d1							; *64 Anzahl Zeilen
	lsr.w #4,d0							; /16 Anzahl Wörter Breite
	or.w d1,d0							; Blitterwert zusammenbauen
	move.w d0,BLTSIZE(a5)				; Blitter starten

	movem.l (sp)+,d0-d1/a0-a2	; Register wiederherstellen
	rts

drawBOBData:
OFFSET_DRAWBOB_DEPTH=0		; 0(a0) 
OFFSET_DRAWBOB_X=2			; 2(a0) 
OFFSET_DRAWBOB_Y=4			; 4(a0) 
OFFSET_DRAWBOB_DX=6			; 6(a0) Vielfaches von 16
OFFSET_DRAWBOB_DY=8			; 8(a0) 
OFFSET_DRAWBOB_MASK=10		; 10(a0) Modulo 0
OFFSET_DRAWBOB_SRC=14		; 14(a0)
OFFSET_DRAWBOB_SRCWIDTH=18	; 18(a0)
OFFSET_DRAWBOB_SRCX=20		; 20(a0) Vielfaches von 16
OFFSET_DRAWBOB_SRCY=22		; 22(a0)
OFFSET_DRAWBOB_DST=24		; 24(a0)
OFFSET_DRAWBOB_DSTWIDTH=28	; 28(a0)
DATASIZE_DRAWBOB=30			; 30
	BLK.B DATASIZE_DRAWBOB,0	; Block von 30 Bytes mit Nullen

;********** Daten **********

olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
copperlist:			DC.L 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
background:			DC.L 0
frontBuffer:		DC.L 0
backBuffer:			DC.L 0
BOB:				BLK.W DISPLAY_DEPTH*BOB_DY*(BOB_DX>>4),0	; 5*64*(64/16)
BOBMask:			REPT DISPLAY_DEPTH*BOB_DY	; 5*64 Diese Wiederholung kann durch einen negativen Modulo vermieden werden (cf. _drawBOB)
					BLK.W BOB_DX>>4,$F0F0		; 64/16=4 = $F0F0,$F0F0,$F0F0,$F0F0
					DC.W $0000					; + 5. Bitebene $0000	(ein Wort leer für die Verschiebung)
					ENDR
bobX:				DC.W BOB_X
bobY:				DC.W BOB_Y
oldBobX:			DC.W BOB_X
oldBobY:			DC.W BOB_Y
bobSpeedX:			DC.W 1
bobSpeedY:			DC.W 1
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

	end

Programmbeschreibung:

Zu allererst haben wir einen Lowres-Screen 320x256 mit 5 Bitebenen, halten
jedoch 3x den Speicher dafür vor und zwar für den Hintergrund, den Frontbuffer
und Backpuffer. Der Hintergrund bleibt zu allen Zeiten in der Hauptschleife
unverändert. Der Frontbuffer (besser viewbuffer) ist der Bereich der angezeigt
wird, nachdem zuvor in den backpuffer (besser drawbuffer) gezeichnet wurde.

Die Copperliste ist kurz und beinhaltet nur die Standardregister für die
Screen- und Displayeinstellung, die Bitplanepointer und die Palette. Es werden
die Bitplanepointer des Frontpuffers geladen und die Copperliste gestartet. 
Auch werden die DMA-Kanäle eingeschaltet.

Das Hauptprogramm beginnt mit der Erstellung eines Hintergrundbildes, einem 
Muster aus 16x16 Quadraten. Dies erfolgt durch das Kopieren von Bitmustern in
Schleifen in die einzelnen Bitebenene des Hintergrunds.

Anschließend wird dieses Muster, also der Hintergrund durch eine einfache Kopie
durch den Blitter in den Front- und Backpuffer kopiert.

Dann wird der Bob erstellt indem ein Stück des Hintergrunds und der Bob-Maske
über die Logikfunktion D=BC kombiniert wird. Der Bob ist zuvor im Speicher leer
und die Maske ist eine Wiederholung von DC.W $F0F0, $F0F0, $F0F0, $F0F0, $0000.

Die Hauptschleife arbeitet mit Strukturen und Routineaufrufen und zwar:
Struktur: clearBOBData mit Routine: _clearBOB oder _clearBOBFast und
Struktur: drawBOBData mit Routine: _drawBOB

Bei Eintritt in die Hauptschleife werden zunächst die Daten der clearBOBData-
Struktur neu geladen und anschließend eine _clearBOB Routine aufgerufen. 
Nachdem der BOB gelöscht wurde, wird die neue Position des Bobs unter 
Berücksichtigung der Ränder ermittelt und die Werte in den Variablen bobX, bobY
und oldBobX und oldBobY gespeichert.
Anschließend werden die neuen Bobdaten in die drawBOBData Struktur geladen und 
die _drawBOB-Routine aufgerufen.
Nachdem der Bob gezeichnet wurde werden die Adressen von Front- und Backpuffer
ausgetauscht und auf die linke Maustaste abgefragt. 

Die Routinen bieten den Vorteil der Flexibilität hinsichtlich der Größe des
Bobs. BOB_DX und BOB_DY können verändert werden, sofern BOB_DX ein Vielfaches
von 16 ist.

Routine: _drawBOB

In der _drawBOB-Routine wird zunächst das Modulo für Kanal A (Bob) und Kanal C
(Hintergrund) berechnet, dann wird die Adresse des Bobs (der Startkoordinaten)
ermittelt und die Position im backfuffer an der das Bob angezeigt werden soll.
Nachdem die Adressen bestimmt wurden werden die Controlregister BLTCON0 und
BLTCON1 geladen, wobei der Verschiebungswert vorher ermittelt wird und in den
A- und B-Shifter geladen werden. Zum Schluss wird der Modulo B Wert
(Bob-Maske), die Zeigerregister geladen und der BLITSIZE Wert ermittelt und der
Blitter gestartet.

Routine: _clearBOB
???	 Hier bleibt unklar warum und wofür diese BLTxLWM, BLTxFWM berechnung gemacht
wird?

Routine: _clearBOBFast

Am Ende der Routine werden die Controlregister BLTCON0 und BLTCON1 geladen und der
Wert in das BLTSIZE Register geschrieben und der Blitter damit gestartet. Die 
Anzahl der Zeilen sind 64 (Bob Y) und die Breite.

Die Breite in Wörtern wird dabei zuvor ermittelt... d3 ????	

Zuvor wird das Modulo B und D ermittelt welche beide den gleichen Wert haben
(320/8)-(Bobbreite in Bytes)

Davor werden die Zeiger für Kanal B und D ermittelt.