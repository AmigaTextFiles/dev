
; Listing17e2.s = MStars.s
; Animation von Sprites, um "magische" Sterne zu machen
; Original version: Autor unbekannt
; Fixed version: Randy/Ram Jam

	SECTION	stars6,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110100000		; copper,bitplane,sprites

WaitDisk	EQU	10

START:

; Zeiger auf leere biplane

	MOVE.L	#PLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.
	move.l	#COPPERSTELL,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$12c00,d2			; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $12c
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $12c
	Beq.S	Waity2

	btst	#2,$16(A5)			; rechte Maustaste gedrückt?
	beq.s	NonStell

	bsr.s	Stellozze

NonStell:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
	rts

*****************************************************************************
; Routine, die die richtigen Sprites zeigt, um den "magischen Sterne"-Effekt
; zu erzielen
*****************************************************************************

WaitTime	=	2				; 0 = max Geschwindigkeit

Stellozze:
	MOVEQ	#8-1,D0				; Anzahl sprites: 8
	LEA	SpritePosXYTab(PC),A0	; seine Adresse wird für zwei 
								; Tabellen verwendet: mit positiven Offsets
								; greift es auf die Tabelle mit den XY Positionen
								; im "Kontrollwörter" Format zu,
								; während mit negativen Offsets der
								; Zugriff auf die Tabelle .b, für 
								; zufällige Animation verwendet wird

	LEA	COPSPR,A1				; Zeiger sprites in COPPERLIST
FaiUnoSpriteLoop:

; Lassen Sie uns die Ausführung etwas verlangsamen...

	SUBQ.B	#1,-8(A0,D0.W)			; subtrahieren Sie 1 von der Wartezeit
	BPL.S	NonAncZero				; ist noch nicht = 0?
	MOVE.B	#WaitTime,-8(A0,D0.W)	; Wartezeit zurückstellen

; Jetzt kümmern wir uns darum, die Werte und Frames aus dem Anitab zu durchlaufen

	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVE.B	-16(A0,D0.W),D1		; val1
	MOVE.B	-24(A0,D0.W),D2		; val2
	ADDQ.W	#1,D1				; val1+1
	CMP.B	#13,D1				; sind wir bei 13? (maximale frames)
	BLT.S	NonMax1				; wenn noch nicht, ok
	MOVEQ	#0,D1				; wenn ja, fangen Sie von vorne an
	ADDQ.W	#1,D2
	CMP.B	#45,D2				; Wir sind bei 45? (maximale word
								; Steuerung SpritePosXYTab)
	BLT.S	NonMax2				; wenn noch nicht, ok
	MOVEQ	#0,D2				; ja?, fang von vorne an! (oder wir gehen von der Tabelle)
NonMax2:
	MOVE.B	D2,-24(A0,D0.W)		; Wert speichern (pos XY aktuell der tab)
NonMax1:
	MOVE.B	D1,-16(A0,D0.W)		; Wert speichern

; Jetzt müssen wir den richtigen Frame finden (Sprite)

	MULU.W	#68,D1				; aktuelle Frame * Länge 1 Rahmen,
								; und wir bekommen den Offset vom Anfang des
								; nur spriteanim
	MOVE.W	D0,D3				; Nummer sprite aktuell in d3
	MULU.W	#13*68,D3			; * Länge 1 spriteanim = Offset für
								; nur spriteanim
	ADD.L	#AnimSprites-2,D1	; offset frames + Adresse AnimSprites
	ADD.L	D3,D1				; + offset sprite anim = richtige Adresse!!!

; Wir haben in d1 die Adresse des richtigen Sprites... wir müssen es aber 
; die X- und Y-Position (HSTART/VSTART) ändern, Nehmen Sie diese Werte von der Tabelle
; SpritePosXYTab, welches es bereits in Form von 2 schönen Kontrollwörtern
; bereithält. In d2 haben wir die Registerkarte ... d2 * 4 für den Offset!

	MOVE.L	D1,A2				; die Adresse des Sprites direkt in a2 kopieren 
	ADD.W	D2,D2				;\ d2*4, in der Tat jedes Element der Tabelle
	ADD.W	D2,D2				;/       ist 2 words (4 bytes) lang
	MOVE.L	0(A0,D2.W),(A2)		; SpritePosXYTab + Offset ok in den 2 Wörtern von
								; Überprüfen Sie das richtige Sprite.

; Jetzt haben wir in d1 die Adresse des richtigen Sprites zum Zeigen ...
; lasst es uns zeigen!

	MOVE.W	D0,D3				; aktuelle Sprite-Nummer in d3...
	ASL.W	#3,D3				; d3 * 8, um den Versatz vom ersten zu finden
								; Zeiger in copperliste, in der Tat jeder
								; Zeiger belegt 8 Bytes .....
	MOVE.W	D1,6(A1,D3.W)		; Zeiger word hohe address sprite in cop,
								; tatsächlich: a1(erster Zeiger)+d3(Offset vom
	SWAP	D1					; (erster Zeiger)=Addresse Zeiger rechts!
	MOVE.W	D1,2(A1,D3.W)		; Zeiger word unten
NonAncZero:
	DBRA	D0,FaiUnoSpriteLoop
	RTS



; 24 bytes (3*8)

Anitab:
	dc.b	34,8,28,41,19,16,42,26	; Tabelle mit nicht übereinstimmenden Werten für
	dc.b	0,7,7,1,6,7,11,4		; Erlaube "ähnliche" Animation
	dc.b	1,1,0,0,2,2,2,1			; zufällige Sterne.
SpritePosXYTab:
	DC.W	$2770,$3600,$434B,$5200,$7F43,$8E00	; Tabelle mit word
	DC.W	$874B,$9600,$8655,$9500,$6F62,$7E00	; Steuerung mit dem
	DC.W	$4362,$5200,$416C,$5000,$6060,$6F00	; verschiedenen X Y Positionen
	DC.W	$6569,$7400,$6B66,$7A00,$4A70,$5900	; für die sprites.
	DC.W	$646F,$7300,$3978,$4800,$577D,$6600	; Hinweis: 45 Kopien
	DC.W	$6078,$6F00,$3687,$4500,$3891,$4700
	DC.W	$438B,$5200,$538D,$6200,$5D87,$6C00
	DC.W	$2C91,$3B00,$2E96,$3D00,$4F92,$5E00
	DC.W	$5E96,$6D00,$3A9A,$4900,$39A1,$4800
	DC.W	$46A8,$5500,$599E,$6800,$61A2,$7000
	DC.W	$5AA5,$6900,$43AB,$5200,$44B3,$5300
	DC.W	$65B0,$7400,$4FB8,$5E00,$6DBC,$7C00
	DC.W	$28B8,$3700,$33BE,$4200,$3EC4,$4D00
	DC.W	$49CA,$5800,$49BB,$5800,$72BF,$8100
	DC.W	$7CC5,$8B00,$82D5,$9100,$86CE,$9500

*****************************************************************************

	section	copper,data_C

COPPERSTELL:
	dc.w	$8e,$2c81	; diwstart
	dc.w	$90,$2cc1	; diwstop
	dc.w	$92,$38		; ddfstart
	dc.w	$94,$d0		; ddfstop

COPSPR:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0,$12a,0,$12c,0,$12e,0
	dc.w	$130,0,$132,0,$134,0,$136,0,$138,0,$13a,0,$13c,0,$13e,0

	dc.w	$108,0		; bpl1mod
	dc.w	$10a,0		; bpl2mod
	dc.w	$102,0		; bplcon1
	dc.w	$104,0		; bplcon2

BPLPOINTERS:
	dc.w	$e0,0,$e2,0	; plane 1

	dc.w	$100,$1200	; bplcon0 - 1 plane lowres

	dc.w	$180,0		; color0 - schwarz
	dc.w	$182,$fff	; color1 - weiß

	DC.W	$180,$000,$182,$000

; Sprite-Farben - color17 bis color31

	DC.W	$1A2,$F00,$1A4,$A00,$1A6,$600
	DC.W	$1A8,$000,$1AA,$0F0,$1AC,$0A0
	DC.W	$1AE,$060,$1B0,$000,$1B2,$00F
	DC.W	$1B4,$00A,$1B6,$006,$1B8,$000
	DC.W	$1BA,$FFF,$1BC,$AAA,$1BE,$666

	dc.w	$ffff,$fffe	; Ende copperlist

*****************************************************************************

; 68*13*8	dh 68 Bytes pro Frame * 13 Frames * 8 spriteanim

	dc.w	0	; wir schreiben auch hier! das hohe Wort ... das ist alles
				; um 1 Wort phasenverschoben .. frag mich nicht warum!
AnimSprites:
	incdir "/Sources/"
	incbin	"spranim1"	; 13 Frames
	incbin	"spranim2"	; 13 Frames
	incbin	"spranim3"	; 13 Frames
	incbin	"spranim4"	; 13 Frames
	incbin	"spranim5"	; 13 Frames
	incbin	"spranim6"	; 13 Frames
	incbin	"spranim7"	; 13 Frames
	incbin	"spranim8"	; 13 Frames

; ****************************************************************************

	section	grafica,bss_C

PLANE:
	ds.b	40*256	; 1 plane lowres "schwarz" wie Hintergrund.

	end

