
; Listing6a.s	GEBEN EINEN BUCHSTABEN AM BILDSCHIRM AUS!!!

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase in a6
	jsr	-$78(a6)			; Disable - stoppt das Multitasking
	lea	GfxName(PC),a1		; Adresse des Namen der zu öffnenden Lib in a1
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		; speichere diese Adresse in GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; hier speichern wir die Adresse der Copperlist
							; des Betriebssystemes

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#BITPLANE,d0	; in d0 kommt die Adresse unseres Bitplane
	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist

	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)

	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist

	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

	bsr.w	print			; Bringt das Wort auf den Bildschirm

mouse:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse			; wenn nicht, zurück zu mouse:

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable - stellt Multitasking wieder her
	move.l	GfxBase(PC),a1	; Basis der Library, die es zu schließen gilt
							; (Libraries werden geöffnet UND geschlossen!)
	jsr	-$19e(a6)			; Closelibrary - schließt die Graphics lib
	rts

; DATEN

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:		; Hier hinein kommt die Basisadresse der graphics.lib,
	dc.l	0	; ab hier werden die Offsets gemacht

OldCop:			; Hier hinein kommt die Adresse der Orginal-Copperlist des
	dc.l	0	; Betriebssystemes

;	Routine, die 8x8 Pixel große Buchstaben druckt

TEXT:
	dc.b	'A'	; der zu schreibende Text. Hier ist es nur ein "A",
			; also $41

	EVEN	; biege die Adresse auf gerade

PRINT:
	;LEA	TEXT(PC),A0	; Adresse des zu schreibenden Textes in a0
	LEA	TEXT,A0	
	;LEA	BITPLANE,A3		; Adresse des Ziel-Bitplanes in a3
	;LEA	BITPLANE+(40*120),A3 ; Zieladresse
	LEA	BITPLANE+19+(40*120),A3 ; Zieladresse
	MOVEQ	#0,D2			; Lösche d2
	MOVE.B	(A0),D2			; Nächster Charakter in d2
	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT

	
	*			; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	;MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	;MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	;MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile 3  "	"
	;MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile 4  "	"
	;MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile 5  "	"
	;MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile 6  "	"
	;MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile 7  "	"
	;MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile 8  "	"
	

	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"

	RTS


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	;dc.w	$92,$0038		; DdfStart
	;dc.w	$94,$00d0		; DdfStop

	dc.w	$92,$003c		; DdfStart HIRES normal
	dc.w	$94,$00d4		; DdfStop HIRES normal

	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod
				; 5432109876543210
	;dc.w	$100,%0001001000000000  ; 1 Bitplane LOWRES 320x256
	dc.w	$100,%1001001000000000  ; 1 Bitplane HIRES 640x256


BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane

	dc.w	$0180,$000		; color0 - HINTERGRUND
	dc.w	$0182,$19a		; color1 - SCHRIFTEN


	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
	incbin	"/Sources/nice.fnt"		; ohne ALT-Charakter

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	;ds.b	40*256	; ein Bitplane LowRes 320x256
	ds.b	80*256	; ein Bitplane Hires 640x256

	end


Und  ein  "A" erscheint am Monitor!!! In der linken oberen Ecke. Ihr könnt
den "Text" ändern, aber es ist keine große Neuheit, ein  "B"  statt  einem
"A" zu drucken.

* ÄNDERUNG 1:

Probiert,  nur  den  halben Charakter zu drucken, also nur die ersten vier
Zeilen:


	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile 4  "	"
;	MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile 5  "	"
;	MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile 6  "	"
;	MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile 7  "	"
;	MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile 8  "	"
	
Jede Zeile ist ein Byte, also 4 BIT

	12345678

	...###.. Zeile  1 - 8 Bit, 1 Byte
	..#...#. 2
	..#...#. 3
	..#####. 4
	..#...#. 5
	..#...#. 6
	..#...#. 7
	........ 8

* ÄNDERUNG 2:

Probiert, das EVEN nach dem String zu entfernen:

	dc.b	"A"

Beim assemblieren wird euch der ASMONE einen Fehler  mitteilen:  "Word  at
ODD  Address",  oder  "UNGERADE  ADRESSE!!".  Also  einfach entweder einen
Nuller hinten dran oder EVEN schreiben.


* ÄNDERUNG 3:

Um  die  Position  des  "A"  zu  verändern, muß man nur das Ziel von PRINT
verändern:

PRINT:
	LEA	TEXT(PC),A0
	LEA	BITPLANE+(40*120),A3	; Zieladresse

Somit kommt das A 120 Zeilen weiter unten ins Bild, mitten im Monitor.  Um
den Buchstaben vorrücken zu lassen, braucht es noch einige Bytes:

	LEA	BITPLANE+19+(40*120),A3 ; Zieladresse

Auf diese Art rücken wir ihn 19 Bytes weiter nach rechts, und er wird  ins
zwanzigste  Byte geschrieben, also in der Mitte (Ein LowRes ist ja 40 Byte
breit).

* ÄNDERUNG 4:

Probieren wir, den Buchstaben in einem HIRES-Bitplane darzustellen: um das
zu tun, macht folgendes:


In  der  Routine  werden  die  40er  mit  80ern  ausgewechselt,	da	der
HiRes-Schirm ja 80 Byte breit ist:

	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"


In der Copperlist: BIT 15 in BPLCON0 setzen, aktivieren das HIRES

				; 5432109876543210
	dc.w	$100,%1001001000000000  ; 1 Bitplane HIRES 640x256

Dann  nicht  das  DDFSTART/DDFSTOP  für  den  HiRes  vergessen!  Ansonsten
schneidet  ihr  mir  die ersten Zeilen links ab! Wenn ihr diese Änderungen
nicht anbringt, dann wird das "A" nicht erscheinen, wenn es sich am linken
Rand befindet.

	dc.w	$92,$003c	; DdfStart HIRES normal
	dc.w	$94,$00d4	; DdfStop HIRES normal

Zum  Schluß  och  die  SECTION BSS: wir müßen sie klarerweise das BITPLANE
vergrößern!

	ds.b	80*256		; ein Bitplane Hires 640x256


