
; Lezione10g1.s	BLITTED, in dem wir gestreifte Rechtecke auf dem Bildschirm zeichnen
	; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE1,d0	;	
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#1-1,D1			; Anzahl der Bitplanes (hier ist es 1)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten


; Parameter für das Zeichnen von Routinen

	move.w	#16,d0			; X obere linke Ecke
	move.w	#10,d1			; Y obere linke Ecke
	move.w	#48,d2			; Breite
	move.w	#20,d3			; Höhe
	move.w	#$aaaa,d4		; "pattern" zu zeichnen
	bsr.s	BlitRett		; Führen Sie die Zeichenroutine aus

mouse1:
	btst	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	mouse1

;  Parameter für das Zeichnen von Routinen

	move.w	#64,d0			; X obere linke Ecke
	move.w	#70,d1			; Y obere linke Ecke
	move.w	#32,d2			; Breite
	move.w	#40,d3			; Höhe 
	move.w	#$8FF1,d4		; "pattern"  zu zeichnen
	bsr.s	BlitRett		; Führen Sie die Zeichenroutine aus

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:

	rts

;****************************************************************************
; Diese Routine zeichnet ein Rechteck auf dem Bildschirm.
;
; D0 - X Koordinate des oberen linken Eckpunkts
; D1 - Y-Koordinate des oberen linken Eckpunkts
; D2 - Rechteckbreite in Pixel
; D3 - Rechteckhöhe
; D4 - "Muster", mit dem ein Rechteck gezeichnet werden soll
;****************************************************************************

;	             |\__/,|   (`\
;	             |o o  |__ _) )
;	           _.( T   )  `  /
;	 n n._    ((_ `^--' /_<  \
;	 <" _ }=- `` `-'(((/  (((/
;	  `" "

BlitRett:
	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

; Berechnung der Startadresse des Blitters

	lea	bitplane1,a1	; Adresse bitplane
	mulu.w	#40,d1		; offset Y
	add.l	d1,a1		; zur Adresse hinzufügen
	lsr.w	#3,d0		; teile das X durch 8
	and.w	#$fffe,d0	; mach es gerade
	add.w	d0,a1		; Summe zur Adresse der Bitebene, Finden
						; der richtigen Zieladresse

; Berechnung Modulo Blitter

	lsr.w	#3,d2		; dividiere die Breite durch 8
	and.w	#$fffe,d2	; Ich nulle Bit 0 (ich bin gerade)
	move.w	#40,d5		; Bildschirmbreite in Bytes
	sub.w	d2,d5		; modulo=Breite Bildschirm - Breite Rechteck

; Berechnung Dimension blittata

	lsl.w	#6,d3		; Höhe mal 64 (wegen Position im BLTSIZE)
	lsr.w	#1,d2		; Pixelbreite geteilt durch 16
						; das heißt, Breite in Worten
	or	d2,d3			; lege die Dimensionen zusammen

; Lade die Register

	move.l	#$01f00000,$40(a5)	; BLTCON0 und BLTCON1
				; NUR Kanal D verwenden
				; LF = $F0 (Kopie von A nach D)
				; aufsteigender Weg

	move.w	d4,$74(a5)		; BLTADAT
	move.w	d5,$66(a5)		; BLTDMOD
	move.l	a1,$54(a5)		; BLTDPT  Zeiger Ziel
	move.w	d3,$58(a5)		; BLTSIZE (Blitter starten !)

	rts

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$1200	; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$aaa	; color1

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

	SECTION	bitplane,BSS_C

BITPLANE1:
	ds.b	40*256

;****************************************************************************

	end

In diesem Beispiel verwenden wir den Blitter, um Rechtecke mit einem "Muster"
zu zeichnen. Das heißt mit einem sich wiederholenden grafischen Muster.
Wir benutzen eine parametrische Routine, die ein Rechteck zeichnet, mit den
Koordinaten des oberen linken Eckpunkts und den Abmessungen (Breite und Höhe)
des Rechtecks. Zur Vereinfachung der Routine werden die Breite und die Position 
von X (des Gipfels) zu einem Vielfachen von 16 angenähert. 
Das "Muster" wird auch als Parameter in einem Register übergeben. Auf diese Weise
können wir alle "Muster", die wir wollen mit nur einer Routine nachzeichnen.
Die Zeichnung wird durch eine Blittata gemacht, bei der nur Kanal D aktiviert wird,
aber den Inhalt des BLTADAT-Registers zum Ausgang kopiert.
Sie müssen den gleichen LF-Wert verwenden, der auch bei der normalen Kopie von A 
nach D verwendet wird, aber Sie müssen Kanal A nicht aktivieren. Daher ist der Wert, 
der in BLTCON0 geschrieben werden soll $01F0 oder LF = $F0 (Kopie von A nach D) 
und nur der Kanal D ist aktiv. Der Wert des "Musters", das in die Ausgabe kopiert
wird, wird in das Register BLTADAT geschrieben.