
; Listing8d.s	Eine FADE-Routine (dh Ein-und Ausblenden) von und nach SCHWARZ.
; ROUTINE Nr.2
; Drücken Sie die linke und rechte Taste

	SECTION	Fade1,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA
;			 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA

START:
	MOVE.L	#Logo1,d0			; Adresse der Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer in der copperlist
	MOVEQ	#4-1,D1				; Anzahl der Bitplanes (hier sind es 4)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0			; + Länge einer Bitplane (84 Zeilen hoch hier)
	addq.w	#8,a1
	dbra	d1,POINTBP

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse1:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse1

	clr.w	FaseDelFade			; die Bildnummer zurücksetzen

;	********** erstes Fade (Einblenden): von SCHWARZ zu Farben *********

mouse2:
	CMP.b	#$ff,$dff006		; Zeile 255
	bne.s	mouse2
Aspetta1:
	CMP.b	#$ff,$dff006		; Zeile 255
	beq.s	Aspetta1

	bsr.w	FadeIN				; Fade!!!

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse2

	move.w	#16,FaseDelFade		; die Bildnummer zurücksetzen

;	********** zweites Fade (Ausblenden): von Farben zu SCHWARZ *********
mouse3:
	CMP.b	#$ff,$dff006		; Zeile 255
	bne.s	mouse3
Aspetta2:
	CMP.b	#$ff,$dff006		; Zeile 255
	beq.s	Aspetta2

	bsr.w	FadeOUT				; Fade!!!

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse3
	rts

	
*****************************************************************************
;	Routinen, warten und Fade zur richtigen Zeit aufrufen
*****************************************************************************

FadeIn:
	cmp.w	#17,FaseDelFade
	beq.s	FinitoFadeIn
	;moveq	#0,d0
	move.w	FaseDelFade(PC),d0
	moveq	#15-1,d7			; D7 = Anzahl der Farben
	lea	TabColoriPic(PC),a0		; A0 = Adresse Farbtabelle 
								; Figur "aufbauen"
	lea	CopColors+6,a1			; A1 = Farbadresse in copperliste
								; zu beachten ist, dass es von color1 und 
								; nicht von color0 beginnt,
								; color0 ist = $000 und bleibt so.
	bsr.s	Fade
	addq.w	#1,FaseDelFade		; den nächsten Schritt vorbereiten
FinitoFadeIn:
	rts


FadeOut:
	tst.w	FaseDelFade			; Haben wir die letzte Phase erreicht? (16)?
	beq.s	FinitoOut
	subq.w	#1,FaseDelFade		; den nächsten Schritt vorbereiten
	;moveq	#0,d0
	move.w	FaseDelFade(PC),d0
	moveq	#15-1,d7			; D7 = Anzahl der Farben
	lea	TabColoriPic(PC),a0		; A0 = Adresse Farbtabelle 
								; Figur "auflösen"
	lea	CopColors+6,a1			; A1 = Farbadresse in copperliste
								; zu beachten ist, dass es von color1 und 
								; nicht von color0 beginnt,
								; color0 ist = $000 und bleibt so.
	bsr.s	Fade
FinitoOut:
	rts

FaseDelFade:					; aktuelle Phase der Überblendung (0-16)
	dc.w	0

*****************************************************************************
*		Routine zum Ein- / Ausblenden von und nach SCHWARZ (Version 2)	    *
* Eingang:																	*
*																			*
* d7 = Anzahl der Farben-1													*
* a0 = Adresse Tabelle mit den Farben des Bildes							*
* a1 = Erste Farbadresse in copperliste										*
* d0 = Moment der Überblendung, Multiplikator -								*
* zum Beispiel mit d0 = 0 der Bildschirm ist völlig weiß,					*
* mit d0 = 8 sind wir halb verblasst und mit d0 = 16						*
* sind wir in der vollen Farbe. Es gibt also 17 Phasen von 0 bis 16.		*
* Um ein Einblenden von Weiß zur Farbe zu machen, müssen Sie in jedem		*
* Aufruf der Routine einen Wert von d0 erhöhen, der von 0 auf 16 ansteigt	*
* Für ein Ausblenden müssen Sie von d0 = 16 bis d0 = 0 gehen				*
*																			*
* Das FADE Prozedur besteht darin, jede Farb-Komponente R, G, B				*
* mit einem Multiplikator von 0 für SCHWARZ (x * 0 = 0) bis 16 für			*
* normale Farben zu multiplizieren. Darum wird die Farbe durch 16 geteilt.  *
* Eine Farbe mit 16 zu multiplizieren und zu dividieren bedeutet nichts		*
* anderes, als sie gleich zu lassen.										*
*																			*
*****************************************************************************

;	   .      .-~\
;	  / `-'\.'    `- :
;	  |    /          `._
;	  |   |   .-.        {
;	   \  |   `-'         `.
;	 .  \ |                /
;	~-.`. \|            .-~_
;	  `.\-.\       .-~      \
;	    `-'/~~ -.~          /
;	  .-~/|`-._ /~~-.~ -- ~
;	 /  |  \    ~- . _\

Fade:
;	Berechnen der BLAUEN Komponente

	MOVE.W	(A0),D4				; die Farbe aus der Farbtabelle in d4 einsetzen
	AND.W	#$00f,D4			; nur die BLAUE Komponente ($RGB -> $00B) auswählen
	MULU.W	D0,D4				; mit der Fade-Phase multiplizieren (0-16)
	ASR.W	#4,D4				; 4 BIT nach rechts verschieben, dh dividieren durch 16
	AND.W	#$00f,D4			; nur die BLAUE Komponente wählen
	MOVE.W	D4,D5				; die BLAUE Komponente in d5 speichern

;	Berechnen der GRÜNEN Komponente

	MOVE.W	(A0),D4				; die Farbe aus der Farbtabelle in d4 einsetzen 
	AND.W	#$0f0,D4			; nur die GRÜNE Komponente ($RGB->$0G0) auswählen
	MULU.W	D0,D4				; mit der Fade-Phase multiplizieren (0-16)
	ASR.W	#4,D4				; 4 BIT nach rechts verschieben, dh dividieren durch 16
	AND.W	#$0f0,D4			; nur die GRÜNE Komponente wählen
	OR.W	D4,D5				; die GRÜNE Komponente in d5 speichern 

;	Berechnen der ROTEN Komponente

	MOVE.W	(A0)+,D4			; die Farbe aus der Tabelle kopieren
								; und auf die nächste Spalte zeigen
	AND.W	#$f00,D4			; nur die ROTE Komponente ($RGB->$R00) auswählen
	MULU.W	D0,D4				; mit der Fade-Phase multiplizieren (0-16)
	ASR.W	#4,D4				; 4 BIT nach rechts verschieben, dh dividieren durch 16
	AND.W	#$f00,D4			; nur die ROTE Komponente ($RGB->$R00) auswählen
	OR.W	D4,D5				; die Farben ROT zusammen mit BLAU und GRÜN speichern

	MOVE.W	D5,(A1)				; und die endgültige $0RGB-Farbe in die copperliste setzen 
	addq.w	#4,a1				; nächste Farbe in der copperliste
	DBRA	D7,Fade				; mach alle Farben
	rts


; die $180, color0, sind $000, also nicht ändern! Die Tabelle beginnt mit color1

TabColoriPic:
	dc.w $fff,$200,$310,$410,$620,$841,$a73
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446


*****************************************************************************
;			Copper List
*****************************************************************************
	section	copper,data_c		; Chip data

Copperlist:
	dc.w	$8E,$2c81			; DiwStrt - window start
	dc.w	$90,$2cc1			; DiwStop - window stop
	dc.w	$92,$38				; DdfStart - data fetch start
	dc.w	$94,$d0				; DdfStop - data fetch stop
	dc.w	$102,0				; BplCon1 - scroll register
	dc.w	$104,0				; BplCon2 - priority register
	dc.w	$108,0				; Bpl1Mod - modulo pl. ungerade
	dc.w	$10a,0				; Bpl2Mod - modulo pl. gerade

				; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte bitplane
	dc.w	$ec,$0000,$ee,$0000	; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

CopColors:
	dc.w	$180,0,$182,0,$184,0,$186,0
	dc.w	$188,0,$18a,0,$18c,0,$18e,0
	dc.w	$190,0,$192,0,$194,0,$196,0
	dc.w	$198,0,$19a,0,$19c,0,$19e,0

;	dc.w	$180,$000,$182,$fff,$184,$200,$186,$310
;	dc.w	$188,$410,$18a,$620,$18c,$841,$18e,$a73
;	dc.w	$190,$b95,$192,$db6,$194,$dc7,$196,$111
;	dc.w	$198,$222,$19a,$334,$19c,$99b,$19e,$446

;	Lassen Sie uns ein paar Nuancen für die Szenographie setzen...

	dc.w	$8007,$fffe			; Wait - $2c+84=$80
	dc.w	$100,$200			; bplcon0 - no bitplanes
	dc.w	$180,$003			; color0
	dc.w	$8207,$fffe			; wait
	dc.w	$180,$005			; color0
	dc.w	$8507,$fffe			; wait
	dc.w	$180,$007			; color0
	dc.w	$8a07,$fffe			; wait
	dc.w	$180,$009			; color0
	dc.w	$9207,$fffe			; wait
	dc.w	$180,$00b			; color0
	dc.w	$9e07,$fffe			; wait
	dc.w	$180,$999			; color0
	dc.w	$a007,$fffe			; wait
	dc.w	$180,$666			; color0
	dc.w	$a207,$fffe			; wait
	dc.w	$180,$222			; color0
	dc.w	$a407,$fffe			; wait
	dc.w	$180,$001			; color0
	dc.l	$ffff,$fffe			; Ende copperlist


*****************************************************************************
;				DESIGN
*****************************************************************************

	section	gfxstuff,data_c

; Zeichnung 320 Pixel breit, 84 hoch 4 Bitebenen (16 Farben).

Logo1:
	incbin	"/Sources/logo320x84x16c.raw"	; 4 Bitplanes 
	
	end

Diese Routine funktioniert genauso wie die vorherige, schreibt aber nicht das
Farbwort ein Byte nach dem anderen. Diese Routine eignet sich eher für
Änderungen wenn es AGA ist. Tatsächlich werden wir es in der AGA-Lektion 
"AGAisiert" sehen. Die Multiplikation und Division der R,G,B-Komponenten wird
auf ein Byte pro R,G,B-Komponente erweitert.

