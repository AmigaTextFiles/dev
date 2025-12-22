
; Listing7t4.s	KUGELN

;	In diesem Listing machen wir eine Reihe von Kugeln, die sich
;	bewegen, indem wir 4 Attached-Sprites verwenden, jeden 11 mal,
;	was insgesamt 44 Kugeln ausmacht.
;	Jeder einzelne der Sprites wird verwendet, um eine Scroll-"Ebene"
;	zu erzeugen, es gibt also vier verschiedene Geschwindigkeiten.
;	Die kleinen und langsamen Sterne, die weiter weg erscheinen,
;	sind alle durch Wiederverwendung des Attached-Sprite Nummer 4
;	hergestellt, sie bestehen also aus den Sprites 6 und 7 zusammen.

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop


	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Pointen auf die Sprites

	MOVE.L	#SPRITE0,d0		; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Wir pointen auf alle 8 Sprites, da wir sie alle verwenden, um
;	4 Attached-Sprites zu erzeugen, die die vier "Ebenen" von Kugeln
;	(oder Sternen) mit verschiedener Geschwindigkeit ergeben.

	MOVE.L	#SPRITE1,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#SPRITE2,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#SPRITE3,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#SPRITE4,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#SPRITE5,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#SPRITE6,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#SPRITE7,d0
	addq.w	#8,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!

mouse:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	mouse

	bsr.s	BewegeSprites_01	; diese Routine bewegt die Sprite 0 und 1
								; (Attached), also die größten Kugeln mit
								; der höchsten Geschwindigkeit: 8 Pixel

	bsr.s	BewegeSprites_23	; diese Routine bewegt die Sprite 2 und 3
								; (Attached), also die großen Kugeln mit
								; einer Geschwindigkeit von 6 Pixel

	bsr.w	BewegeSprites_45	; diese Routine bewegt die Sprite 4 und 5
								; (Attached), also die	mittlern Kugeln
								; mit mittlerer Geschwindigkeit: Pixel

	bsr.w	BewegeSprites_67	; diese Routine bewegt die Sprite 6 und 7
								; (Attached), also die	langsamen, kleinen
								; Kugeln mit 2 Pixeln Geschwindigkeit

Warte:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; diese Routine bewegt die Sprite 0 und 1, die attached sind, deshalb
; müssen sie die selben Koordinaten haben


BewegeSprites_01:
	lea	Sprite0,a0		; Adresse des Sprite 0
	lea	Sprite1,a1		; Adresse des Sprite 1
	moveq	#11-1,d7	; Anzahl der Sprite-wiederverwendungen
loop01:
	addq.b	#4,1(a0)	; bewegt um 8 Pixel (nach rechts)den Sprite 0
						; durch Eingreifen auf sein HSTART
	addq.b	#4,1(a1)	; bewegt um 8 Pixel (nach rechts)den Sprite 1
						; durch Eingreifen auf sein HSTART
	lea	68(a0),a0 		; Koordinaten der nächsten Wiederv. des Sprite0
	lea	68(a1),a1 		; Koordinaten der nächsten Wiederv. des Sprite1
	dbra	d7,loop01 	; loop
	rts

; diese Routine bewegt die Sprite 2 und 3, die attached sind, deshalb
; müssen sie die selben Koordinaten haben

BewegeSprites_23:
	lea	Sprite2,a0		; Adresse des Sprite 2
	lea	Sprite3,a1		; Adresse des Sprite 3
	moveq	#11-1,d7	; Anzahl der Sprite-wiederverwendungen
loop23:
	addq.b	#3,1(a0)	; bewegt um 6 Pixel (nach rechts)den Sprite 2
						; durch Eingreifen auf sein HSTART
	addq.b	#3,1(a1)	; bewegt um 6 Pixel (nach rechts)den Sprite 3
						; durch Eingreifen auf sein HSTART
	lea	68(a0),a0		; Koordinaten der nächsten Wiederv. des Sprite2
	lea	68(a1),a1		; Koordinaten der nächsten Wiederv. des Sprite3
	dbra	d7,loop23	; loop
	rts

; diese Routine bewegt die Sprite 4 und 5, die attached sind, deshalb
; müssen sie die selben Koordinaten haben

BewegeSprites_45:
	lea	Sprite4,a0		; Adresse des Sprite 4
	lea	Sprite5,a1		; Adresse des Sprite 5
	moveq	#11-1,d7	; Anzahl der Sprite-wiederverwendungen
loop45:
	addq.b	#2,1(a0)	; bewegt um 4 Pixel (nach rechts)den Sprite 4
	addq.b	#2,1(a1)	; bewegt um 4 Pixel (nach rechts)den Sprite 5
	lea	68(a0),a0		; Koordinaten der nächsten Wiederv. des Sprite4
	lea	68(a1),a1		; Koordinaten der nächsten Wiederv. des Sprite5
	dbra	d7,loop45	; loop
	rts

; diese Routine bewegt die Sprite 6 und 7, die attached sind, deshalb
; müssen sie die selben Koordinaten haben


BewegeSprites_67:
	lea	Sprite6,a0		; Adresse des Sprite 6
	lea	Sprite7,a1		; Adresse des Sprite 7
	moveq	#11-1,d7	; Anzahl der Sprite-wiederverwendungen
loop67:
	addq.b	#1,1(a0)	; bewegt um 2 Pixel (nach rechts)den Sprite 6
	addq.b	#1,1(a1)	; bewegt um 2 Pixel (nach rechts)den Sprite 7
	lea	68(a0),a0		; Koordinaten der nächsten Wiederv. des Sprite6
	lea	68(a1),a1		; Koordinaten der nächsten Wiederv. des Sprite7
	dbra	d7,loop67	; loop
	rts


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38			; DdfStart
	dc.w	$94,$d0			; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

	dc.w	$180,$000		; color0	; schwarzer Hintergrund
	dc.w	$182,$000		; color1	; Color1 des Bitplane, das
							; in diesem Fall leer ist, und
							; deshalb nicht erscheint

	dc.w	$1a0,$000,$1a2,$fff	; Palette der Sprites
	dc.w	$1a4,$f00,$1a6,$b00
	dc.w	$1a8,$600,$1aa,$F40
	dc.w	$1ac,$F80,$1ae,$Fa0
	dc.w	$1b0,$Ff0,$1b2,$00f
	dc.w	$1b4,$04f,$1b6,$08f
	dc.w	$1b8,$0ff,$1ba,$0f0
	dc.w	$1bc,$283,$1be,$f0f


	dc.w	$FFFF,$FFFE		; Ende der Copperlist

; Hier sind die Sprites. Jeder von ihnen wird 11 mal wiederverwendet.
; Die ungeraden Sprites haben das Attached-Bit gesetzt, um 16-Farben-Sprites
; zu werden. Wie ihr seht, sind die "Kugeln" alle gleich.

Sprite0:
	dc.w	$38D0,$4800	; Kontrollwords
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 1
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$4943,$5900	; Kontrollwords
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 2
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$6087,$7000
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318	; Kugel 3
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$71af,$8100
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318	; Kugel 4
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$8213,$9200
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 5
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$93D0,$a300
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 6
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$a443,$b400
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 7
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$b587,$c500
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 8
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$c6af,$d600
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 9
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$d713,$e700
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 10
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$e8b9,$f800
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel 11
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000
	dc.w	0,0	; Ende sprite0

Sprite1:
	dc.w	$38D0,$4880	; Kontrollwords
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000 ; Kugel
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$4943,$5980	; Kontrollwords
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000 ; Kugel
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$6087,$7080
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$71af,$8180
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$8213,$9280
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$93D0,$a380
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$a443,$b480
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$b587,$c580
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$c6af,$d680
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$d713,$e780
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$e8b9,$f880
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000
	dc.w	0,0 ; Ende sprite 1

Sprite2:
	dc.w	$44D0,$5400	; Kontrollwords
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$5543,$6500	; Kontrollwords
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318 ; Kugel
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$6687,$7600
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$77af,$8700
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$8813,$9800
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$99D0,$a900
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$aa43,$ba00
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$bb87,$cb00
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$ccaf,$dc00
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$dd13,$ed00
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000

	dc.w	$ee5c,$fe00
	dc.w	$0000,$0000,$0200,$0200,$0db0,$0d80,$1520,$1318
	dc.w	$2e30,$3208,$3e70,$260c,$3464,$2c1c,$70e0,$7018
	dc.w	$20c8,$2038,$01c0,$0030,$0390,$0070,$0720,$00e0
	dc.w	$0e40,$01c0,$0000,$0700,$0000,$0000,$0000,$0000
	dc.w	0,0	; Ende sprite 2

Sprite3:
	dc.w	$44D0,$5480	; Kontrollwords
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000 ; Kugel
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$5543,$6580	; Kontrollwords
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000 ; Kugel
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$6687,$7680
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$77af,$8780
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$8813,$9880
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$99D0,$a980
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$aa43,$ba80
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$bb87,$cb80
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$ccaf,$dc80
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$dd13,$ed80
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000

	dc.w	$ee5c,$fe80
	dc.w	$07c0,$0000,$1df8,$0000,$3278,$0000,$68fc,$0000
	dc.w	$41fc,$0000,$c1fe,$0000,$c3fe,$0000,$8ffa,$0004
	dc.w	$dffa,$0004,$fff2,$000c,$7ff4,$0008,$7fe4,$0018
	dc.w	$3fc8,$0030,$1f30,$00c0,$07c0,$0000,$0000,$0000
	dc.w	0,0	; Ende sprite 3

Sprite4:
	dc.w	$3877,$4800	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 ; Kugel
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$49D0,$5900	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 ; Kugel
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$6043,$7000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$7187,$8100
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$82af,$9200
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$9313,$a300
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$a4D0,$b400
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$b543,$c500
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$c687,$d600
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$d7af,$e700
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 

	dc.w	$e813,$f800
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0540,$0700,$0e60,$0980,$3cc0,$3220,$1a90,$1670
	dc.w	$0490,$1c70,$19a0,$1860,$0320,$00e0,$0640,$01c0
	dc.w	$0080,$0380,$0000,$0000,$0000,$0000,$0000,$0000 
	dc.w	0,0	; Ende sprite 4

Sprite5:
	dc.w	$3877,$4880	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000 ; Kugel
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$49D0,$5980	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000 ; Kugel
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$6043,$7080
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$7187,$8180
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$82af,$9280
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$9313,$a380
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$a4D0,$b480
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$b543,$c580
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$c687,$d680
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$d7af,$e780
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000

	dc.w	$e813,$f880
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$07c0,$0000
	dc.w	$08e0,$0000,$1070,$0000,$01f8,$0000,$21f8,$0000
	dc.w	$23f8,$0000,$27e8,$0010,$3fe8,$0010,$1fd0,$0020
	dc.w	$0fa0,$0040,$07c0,$0000,$0000,$0000,$0000,$0000
	dc.w	0,0	; Ende sprite 5

Sprite6:
	dc.w	$4040,$5000	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 ; Kugel
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$5188,$6100	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 ; Kugel
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$6206,$7200
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$73dd,$8300
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$8469,$9400
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$95e4,$a500
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$a62c,$b600
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$b799,$c700
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$c8d0,$d800
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$d955,$e900
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$eab4,$fa00
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$03a0,$0280,$03e0,$00a0,$0340,$0320
	dc.w	$0180,$0140,$0340,$00c0,$0000,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	0,0

Sprite7:
	dc.w	$4040,$5080	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 ; Kugel
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$5188,$6180	; Kontrollwords
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 ; Kugel
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$6206,$7280
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$73dd,$8380
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$8469,$9480
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$95e4,$a580
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$a62c,$b680
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$b799,$c780
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$c8d0,$d880
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$d955,$e980
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

	dc.w	$eab4,$fa80
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	$01c0,$0000,$0060,$0000,$0470,$0000,$04f0,$0000
	dc.w	$06d0,$0020,$03e0,$0000,$01c0,$0000,$0000,$0000
	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dc.w	0,0	; Ende sprite 7


	SECTION LEERESPLANE,BSS_C
BITPLANE:
	ds.b	40*256

	end

In  diesem  Listing haben wir den Sterneneffekt verbessert. Hier haben wir
statt einem Stern, der ja nur ein Punkt ist, farbige  Kugeln  bewegt.  Wir
verwenden  immer  Sprites,  aber  zu  16  Farben,  da jede Kugel aus einem
zusammengeklebten Spritepaar besteht. Weiters verwenden wir nicht nur  ein
Spritepaar  (die Sterne waren nur aus einem Sprite), sondern alle 4 Paare,
das uns ermöglicht, mehrere  Sprites  auf  der  selben  Zeile  flitzen  zu
lassen. Jedes Paar wird 11 mal wiederverwendet, was zu insgesamt 44 Kugeln
auf dem Bildschirm führt.

Wir verwenden für jedes Spritepaar  eine  separate  Bewegungsroutine.  Die
vier  Routinen  unterscheiden  sich aber lediglich in der Geschwindigkeit,
die sie ihren Kugeln zumuten. Kugeln aus einem Paar haben alle die gleiche
Geschwindigkeit,  die  Kugeln  von  verschiedenen  Paaren  haben  eine
verschiedene.

Ansonsten gibt es keine Unterschiede  zu  den  vorigen  Listings  mit  den
Sternen.

