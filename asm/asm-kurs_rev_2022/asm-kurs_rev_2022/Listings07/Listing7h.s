
; Listing7h.s	4 SPRITE ZU 16 FARBEN IM ATTACHED-MODE WERDEN AM BILDSCHIRM
;				MITTELS TABELLEN BEWEGT (vorausberechnete X- und Y-Koordinaten)
;
;	** BEMERKUNG** Um das Programm zu sehen und um auszusteigen:
;	LINKE TASTE RECHTE TASTE, LINKE TASTE, RECHTE TASTE

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Libname
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0	; wohin pointen
	LEA	BPLPOINTERS,A1		; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)


;	Pointen auf die 8 Sprite, die im Attaced-Modus 4 zu 16 Farben ergeben.
;	Die Sprite 1,3,5,7, die ungeraden, müssen das Bit 7 des zweiten Word
;	auf 1 haben.


	MOVE.L	#MEINSPRITE0,d0 ; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE1,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE2,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE3,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE4,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE5,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE6,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE7,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

; Setzen das Attached-Bit

	bset	#7,MEINSPRITE1+3	; Setzt das Bit für Attached beim
								; Sprite. Wird es nicht gesetzt,
								; entstehen nur zwei Sprites mit
								; drei Farben, die sich überlappen
	
	bset	#7,MEINSPRITE3+3
	bset	#7,MEINSPRITE5+3
	bset	#7,MEINSPRITE7+3

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!

;	Schaffen eine Positionsdifferenz in den Pointern der Tabelle zwischen
;	den 4 Sprites um sie in verschiedenen Richtungen zu bewegen.

	MOVE.L	#TABX+55,TABXPOINT0
	MOVE.L	#TABX+86,TABXPOINT1
	MOVE.L	#TABX+130,TABXPOINT2
	MOVE.L	#TABX+170,TABXPOINT3
	MOVE.L	#TABY-1,TABYPOINT0
	MOVE.L	#TABY+45,TABYPOINT1
	MOVE.L	#TABY+90,TABYPOINT2
	MOVE.L	#TABY+140,TABYPOINT3


Mouse1:
	bsr.w	BewegeSprite		; Wartet ein Fotogramm, bewegt die Sprites
								; und kommt zurück

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse1

	MOVE.L	#TABX+170,TABXPOINT0
	MOVE.L	#TABX+130,TABXPOINT1
	MOVE.L	#TABX+86,TABXPOINT2
	MOVE.L	#TABX+55,TABXPOINT3
	MOVE.L	#TABY-1,TABYPOINT0
	MOVE.L	#TABY+45,TABYPOINT1
	MOVE.L	#TABY+90,TABYPOINT2
	MOVE.L	#TABY+140,TABYPOINT3

Mouse2:
	bsr.w	BewegeSprite		; Wartet ein Fotogramm, bewegt die Sprites
								; und kommt zurück

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse2

; SPRITE IM GÄNSEMARSCH

	MOVE.L	#TABX+30,TABXPOINT0
	MOVE.L	#TABX+20,TABXPOINT1
	MOVE.L	#TABX+10,TABXPOINT2
	MOVE.L	#TABX-1,TABXPOINT3
	MOVE.L	#TABY+30,TABYPOINT0
	MOVE.L	#TABY+20,TABYPOINT1
	MOVE.L	#TABY+10,TABYPOINT2
	MOVE.L	#TABY-1,TABYPOINT3

Mouse3:
	bsr.w	BewegeSprite		; Wartet ein Fotogramm, bewegt die Sprites
								; und kommt zurück

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse3

; BESOFFENE SPRITES AM BILDSCHIRM

	MOVE.L	#TABX+220,TABXPOINT0
	MOVE.L	#TABX+30,TABXPOINT1
	MOVE.L	#TABX+102,TABXPOINT2
	MOVE.L	#TABX+5,TABXPOINT3
	MOVE.L	#TABY-1,TABYPOINT0
	MOVE.L	#TABY+180,TABYPOINT1
	MOVE.L	#TABY+20,TABYPOINT2
	MOVE.L	#TABY+100,TABYPOINT3


Mouse4:
	bsr.w	BewegeSprite		; Wartet ein Fotogramm, bewegt die Sprites
								; und kommt zurück

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse4

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte COP


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


; Diese Routine startet die einzelnen Bewegungsroutinen der Sprites
; und beinhaltet auch den Warte-Loop des Fotogrammes für das Timing.

BewegeSprite:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	BewegeSprite

	bsr.s	BEWEGESPRITEX0		; bewege den Sprite 0 horizontal
	bsr.w	BEWEGESPRITEX1		; bewege den Sprite 1 horizontal
	bsr.w	BEWEGESPRITEX2		; bewege den Sprite 2 horizontal
	bsr.w	BEWEGESPRITEX3		; bewege den Sprite 3 horizontal
	bsr.w	BEWEGESPRITEY0		; bewege den Sprite 0 vertikal
	bsr.w	BEWEGESPRITEY1		; bewege den Sprite 1 vertikal
	bsr.w	BEWEGESPRITEY2		; bewege den Sprite 2 vertikal
	bsr.w	BEWEGESPRITEY3		; bewege den Sprite 3 vertikal

Warte:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte

	rts							; Zurück zum MOUSE - LOOP


; ********************* ROUTINEN ZUR HORIZONTALEN BEWEGUNG ******************

; Diese Routine bewegt den Sprite indem die auf das Byte HSTART, also dem
; Byte seiner X-Position, zugreift. Es werden die Werte einer vorausberechneten
; Tabelle (TABX) eingesetzt.

; Für den Sprite0 ATTACCHED: (also Sprite0+Sprite1)

BEWEGESPRITEX0:
	ADDQ.L	#1,TABXPOINT0		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT0(PC),A0	; Adresse, die im Long TABXPOINT enthalten
								; ist wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTX0			; noch nicht? dann mach´ weiter
	MOVE.L	#TABX-1,TABXPOINT0	; Starte wieder beim ersten Long
NOBSTARTX0:
	MOVE.b	(A0),MEINSPRITE0+1 ; Kopie das Byte aus der Tabelle in HSTART0
	MOVE.b	(A0),MEINSPRITE1+1 ; Kopie das Byte aus der Tabelle in HSTART1
	rts

TABXPOINT0:
	dc.l	TABX+55				; ACHTUNG: Die Werte der Tabelle sind Bytes


; Für den Sprite1 ATTACCHED: (also Sprite2+Sprite3)

BEWEGESPRITEX1:
	ADDQ.L	#1,TABXPOINT1		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT1(PC),A0	; Adresse, die im Long TABXPOINT enthalten
								; ist wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTX1			; noch nicht? dann mach´ weiter
	MOVE.L	#TABX-1,TABXPOINT1	; Starte wieder beim ersten Long
NOBSTARTX1:
	MOVE.b	(A0),MEINSPRITE2+1	; Kopie das Byte aus der Tabelle in HSTART0
	MOVE.b	(A0),MEINSPRITE3+1	; Kopie das Byte aus der Tabelle in HSTART1
	rts

TABXPOINT1:
	dc.l	TABX+86				; ACHTUNG: Die Werte der Tabelle sind Bytes
	

; Für den Sprite2 ATTACCHED: (also Sprite4+Sprite5)

BEWEGESPRITEX2:
	ADDQ.L	#1,TABXPOINT2		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT2(PC),A0	; Adresse, die im Long TABXPOINT enthalten
								; ist wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTX2			; noch nicht? dann mach´ weiter
	MOVE.L	#TABX-1,TABXPOINT2  ; Starte wieder beim ersten Long
NOBSTARTX2:
	MOVE.b	(A0),MEINSPRITE4+1  ; Kopie das Byte aus der Tabelle in HSTART0
	MOVE.b	(A0),MEINSPRITE5+1  ; Kopie das Byte aus der Tabelle in HSTART1
	rts

TABXPOINT2:
	dc.l	TABX+130			; ACHTUNG: Die Werte der Tabelle sind Bytes


; Für den Sprite3 ATTACCHED: (also Sprite6+Sprite7)

BEWEGESPRITEX3:
	ADDQ.L	#1,TABXPOINT3	    ; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT3(PC),A0   ; Adresse, die im Long TABXPOINT enthalten
							    ; ist wird in a0 kopiert
	CMP.L	#ENDETABX-1,A0	    ; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTX3		    ; noch nicht? dann mach´ weiter
	MOVE.L	#TABX-1,TABXPOINT3  ; Starte wieder beim ersten Long
NOBSTARTX3:
	MOVE.b	(A0),MEINSPRITE6+1  ; Kopie das Byte aus der Tabelle in HSTART0
	MOVE.b	(A0),MEINSPRITE7+1  ; Kopie das Byte aus der Tabelle in HSTART1
	rts

TABXPOINT3:
	dc.l	TABX+170			; ACHTUNG: Die Werte der Tabelle sind Bytes

; ********************* ROUTINES ZUR VERTIKALEN BEWEGUNG *******************

; Diese Routine bewegt den Sprite nach Oben und nach Unten, indem sie auf
; die Bytes VSTART und VSTOP zugreift, also den Anfangs- und Endkoordinaten
; des Sprites. Es werden schon vordefinierte Koordinaten aus TABY eingesetzt.

BEWEGESPRITEY0:
	ADDQ.L	#1,TABYPOINT0		; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT0(PC),A0	; Adresse, die im Long TABXPOINT enthalten
								; ist wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0		; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTY0			; noch nicht? dann mach´ weiter
	MOVE.L	#TABY-1,TABYPOINT0  ; Starte wieder beim ersten Long
NOBSTARTY0:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopiere das Byte aus der Tabelle in d0
	MOVE.b	d0,MEINSPRITE0		; kopiere das Byte in VSTART0
	MOVE.b	d0,MEINSPRITE1		; kopiere das Byte in VSTART1
	ADD.B	#15,D0				; Addiere die Länge des Sprites
								; um die Endposition zu ermitteln (VSTOP)
	move.b	d0,MEINSPRITE0+2	; setze den richtigen Wert in VSTOP0
	move.b	d0,MEINSPRITE1+2	; setze den richtigen Wert in VSTOP1
	rts

TABYPOINT0:
	dc.l	TABY-1				; ACHTUNG: Die Werte der Tabelle sind Bytes

	
; Für den Sprite1 ATTACCHED: (also Sprite2+Sprite3)

BEWEGESPRITEY1:
	ADDQ.L	#1,TABYPOINT1	    ; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT1(PC),A0	; Adresse, die im Long TABXPOINT enthalten
								; ist wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0	    ; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTY1			; noch nicht? dann mach´ weiter
	MOVE.L	#TABY-1,TABYPOINT1  ; Starte wieder beim ersten Long
NOBSTARTY1:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopiere das Byte aus der Tabelle in d0
	MOVE.b	d0,MEINSPRITE2		; kopiere das Byte in VSTART2
	MOVE.b	d0,MEINSPRITE3		; kopiere das Byte in VSTART3
	ADD.B	#15,D0				; Addiere die Länge des Sprites
								; um die Endposition zu ermitteln (VSTOP)
	move.b	d0,MEINSPRITE2+2    ; setze den richtigen Wert in VSTOP2
	move.b	d0,MEINSPRITE3+2    ; setze den richtigen Wert in VSTOP3
	rts

TABYPOINT1:
	dc.l	TABY+45				; ACHTUNG: Die Werte der Tabelle sind Bytes


; Für den Sprite2 ATTACCHED: (also Sprite4+Sprite5)

BEWEGESPRITEY2:
	ADDQ.L	#1,TABYPOINT2	    ; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT2(PC),A0   ; Adresse, die im Long TABXPOINT enthalten
							    ; ist wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0	    ; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTY2		    ; noch nicht? dann mach´ weiter
	MOVE.L	#TABY-1,TABYPOINT2  ; Starte wieder beim ersten Long
NOBSTARTY2:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopiere das Byte aus der Tabelle in d0
	MOVE.b	d0,MEINSPRITE4		; kopiere das Byte in VSTART4
	MOVE.b	d0,MEINSPRITE5		; kopiere das Byte in VSTART5
	ADD.B	#15,D0				; Addiere die Länge des Sprites
								; um die Endposition zu ermitteln (VSTOP)
	move.b	d0,MEINSPRITE4+2	; setze den richtigen Wert in VSTOP4
	move.b	d0,MEINSPRITE5+2	; setze den richtigen Wert in VSTOP5
	rts
	
TABYPOINT2:
	dc.l	TABY+90				; ACHTUNG: Die Werte der Tabelle sind Bytes
	

; Für den Sprite3 ATTACCHED: (also Sprite6+Sprite7)

BEWEGESPRITEY3:
	ADDQ.L	#1,TABYPOINT3		; Pointe auf das nächste Byte
	MOVE.L	TABYPOINT3(PC),A0	; Adresse, die im Long TABXPOINT enthalten
								; ist wird in a0 kopiert
	CMP.L	#ENDETABY-1,A0	    ; Sind wir beim letzten Long der TAB?
	BNE.S	NOBSTARTY3			; noch nicht? dann mach´ weiter
	MOVE.L	#TABY-1,TABYPOINT3  ; Starte wieder beim ersten Long
NOBSTARTY3:
	moveq	#0,d0				; Lösche d0
	MOVE.b	(A0),d0				; kopiere das Byte aus der Tabelle in d0
	MOVE.b	d0,MEINSPRITE6		; kopiere das Byte in VSTART6
	MOVE.b	d0,MEINSPRITE7		; kopiere das Byte in VSTART7
	ADD.B	#15,D0				; Addiere die Länge des Sprites
								; um die Endposition zu ermitteln (VSTOP)
	move.b	d0,MEINSPRITE6+2	; setze den richtigen Wert in VSTOP6
	move.b	d0,MEINSPRITE7+2	; setze den richtigen Wert in VSTOP7
	rts

TABYPOINT3:
	dc.l	TABY+140			; ACHTUNG: Die Werte der Tabelle sind Bytes



; Tabelle mit vorausberechneten X-Werten.

TABX:
	incbin	"/Sources/XCOORDINAT.TAB"	; 334 Werte
ENDETABX:

; Tabelle mit vorausberechneten Y-Werten.

TABY:
	incbin	"/Sources/YCOORDINAT.TAB"	; 200 Werte
ENDETABY:


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
	dc.w	$100,%0001001000000000	; Bit 12 an, 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

;	Palette der PIC

	dc.w	$180,$000		; color0	; schwarzer Hintergrund
	dc.w	$182,$123		; color1	; Color1 des Bitplane, das in
							; diesem Fall leer ist, und
							; deshalb nicht erscheint

;	Palette der Attached-SPRITES

	dc.w	$1A2,$FFC		; color17, Farbe 1 für die Attached-Sprites
	dc.w	$1A4,$EEB		; color18, Farbe 2 für die Attached-Sprites
	dc.w	$1A6,$CD9		; color19, Farbe 3 für die Attached-Sprites
	dc.w	$1A8,$AC8		; color20, Farbe 4 für die Attached-Sprites
	dc.w	$1AA,$8B6		; color21, Farbe 5 für die Attached-Sprites
	dc.w	$1AC,$6A5		; color22, Farbe 6 für die Attached-Sprites
	dc.w	$1AE,$494		; color23, Farbe 7 für die Attached-Sprites
	dc.w	$1B0,$384		; color24, Farbe 7 für die Attached-Sprites
	dc.w	$1B2,$274		; color25, Farbe 9 für die Attached-Sprites
	dc.w	$1B4,$164		; color26, Farbe 10 für die Attached-Sprites
	dc.w	$1B6,$154		; color27, Farbe 11 für die Attached-Sprites
	dc.w	$1B8,$044		; color28, Farbe 12 für die Attached-Sprites
	dc.w	$1BA,$033		; color29, Farbe 13 für die Attached-Sprites
	dc.w	$1BC,$012		; color30, Farbe 14 für die Attached-Sprites
	dc.w	$1BE,$001		; color31, Farbe 15 für die Attached-Sprites

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

; ************ Hier die Sprites: KLARERWEISE in CHIP RAM! **********

MEINSPRITE0:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.PARI"

MEINSPRITE1:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.DISPARI"

MEINSPRITE2:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.PARI"

MEINSPRITE3:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.DISPARI"

MEINSPRITE4:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.PARI"

MEINSPRITE5:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.DISPARI"

MEINSPRITE6:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.PARI"

MEINSPRITE7:				; Länge 15 Zeilen
	incbin	"/Sources/Sprite16Col.DISPARI"

		SECTION LEERESPLANE,BSS_C ; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

In diesem Listing werden alle 4 Attached-Sprites mit 16 Farben angezeigt.
Die Sprites wurden, einschließlich der Kontrollword, als File abgespeichert,
verwendet wurde dazu der Befehl "WB". Das um im Listing Platz zu sparen
und um die Sprites andere Male wiederverwenden zu können. Auch im Listing
selbst wurde der Sprite öfters wiederverwendet,er ist in Sprite16Col.GERADE
und Sprite16Col.UNGERADE aufgeteilt. Alle vier Sprites wurden damit erzeugt.
Was die Bewegung der Sprites angeht, so hat ein jeder Sprite seine
eigene Routine mit eigenen Tabellenpointern auf X- und Y- Richtung.
Wenn man nun die Bewegungen "außer Fase", also in verschiedenen Punkten
der Tabelle, beginnen läßt, entstehen scheinbar separate Bahnen. Die
Tabelle für X- und Y- Richtung sind aber immer die gleichen für alle
Routinen. Ein Sprite startet z.B. bei Position x,y, ein anderer bei Position
x+n,y+,, und plaziert ihn somit weiter vorne als den anderen. Das ist der
Fall beim "Gänsemarsch". Oder es entstehen scheinbar zufällige Bahnen.
Eine Besonderheit dieses Listings gebührt aber noch etwas Aufmerksamkeit:
da öfters auf den Druck des linken und des rechten Mausknopfes gewartet
werden muß, um die Bewegung der Sprites zu verändern, bevor man aussteigt,
wäre es notwendig gewesen, jedesmal die zwei Loops, die die Zeile $FF
abwarten, neuzuschreiben. Auch alle 8 "BSR BEWEGESPRITE":

; Warte Zeile $FF
; bsr BEWEGESPRITE
; Warte auf linken Mausknopf

; ändere die Bahn des Sprite

; Warte Zeile $FF
; bsr BEWEGESPRITE
; Warte auf rechten Mausknopf

; ändere die Bahn des Sprite

; Warte Zeile $FF
; bsr BEWEGESPRITE
; Warte auf linken Mausknopf

; ändere die Bahn des Sprite

; Warte Zeile $FF
; bsr BEWEGESPRITE
; Warte auf rechten Mausknopf

Um Listingzeilen zu sparen ist eine Lösung die, die Warte-Schleife in die
Subroutine BSR BEWEGESPRITE einzubauen:

; Diese Routine startet die einzelnen Bewegungsroutinen der Sprites
; und beinhaltet auch den Warte-Loop des Fotogrammes für das Timing.

BewegeSprite:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	BewegeSprite

	bsr.s	BEWEGESPRITEX0	; bewege den Sprite 0 horizontal
	bsr.w	BEWEGESPRITEX1	; bewege den Sprite 1 horizontal
	bsr.w	BEWEGESPRITEX2	; bewege den Sprite 2 horizontal
	bsr.w	BEWEGESPRITEX3	; bewege den Sprite 3 horizontal
	bsr.w	BEWEGESPRITEY0	; bewege den Sprite 0 vertikal
	bsr.w	BEWEGESPRITEY1	; bewege den Sprite 1 vertikal
	bsr.w	BEWEGESPRITEY2	; bewege den Sprite 2 vertikal
	bsr.w	BEWEGESPRITEY3	; bewege den Sprite 3 vertikal

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	rts						; zurück zum MOUSE - Loop

Somit muß nur gewartet werden, bis die Maustaste gedrückt wird, ansonsten
wird die Routine BewegeSprite ausgeführt:


Mouse1:
	bsr.w	BewegeSprite	; Wartet ein Fotogramm, bewegt die Sprite
							; und kommt zurück

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse1

	MOVE.L	#TABX+170,TABXPOINT0	; ändere die Bahn des Sprite
	...

Mouse2:
	bsr.w	BewegeSprite	; Wartet ein Fotogramm, bewegt die Sprite
							; und kommt zurück

	btst	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	mouse2

