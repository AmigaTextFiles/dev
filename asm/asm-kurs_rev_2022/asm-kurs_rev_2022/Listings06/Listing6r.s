
; Listing6r.s	ZUSAMMENFASSUNG VON VERSCHIEDENEN LISTINGS AUS
;				DIESER LEKTION + MUSIK-ROUTINE

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Namen der Lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		;
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	POINTEN AUF UNSERE BITPLANES

	MOVE.L	#BITPLANETEXT-2,d0	; Adresse des Ziel-Bitplane in d0
	LEA	BPLPOINTERS,A1		; COP - Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.L	#BITPLANEMATRIX-2,d0	; Adresse Ziel-Bitplane in d0,
	LEA	BPLPOINTERS2,A1		; COP - Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA
 
	bsr.w	Matrix3			; Bringt ein Schachmuster auf Bitplane!

	bsr.w	mt_init			; Initialisiert die Musikroutine

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse

	bsr.w	PrintCharakter	; Druckt Buchstaben für Buchstaben den Text
	bsr.w	MEGAScroll		; Scoll eines 640 Pixel breiten Bildes
							; auf einem LowRes-Screen zu 320 Pixel
	bsr.w	BOING			; Läßt das Text-Bitplane "springen"
	bsr.w	mt_music		; Spielt eine Musik

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte		

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	bsr.w	mt_end

	move.l	OldCop(PC),$dff080	; COP1LC - "Zeiger" auf die Orginal-COP
	move.w	d0,$dff088		; COPJMP1 - und starten sie

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)			; Closelibrary 
	rts


; DATEN

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

;************************************************************************
;*	Druckt einen Charakter pro Frame auf einen Screnn von 640 Pixel *
;************************************************************************

PRINTCharakter:
	MOVE.L	PointeText(PC),A0 ; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2			; Lösche d2
	MOVE.B	(A0)+,D2		; Nächster Buchstaben in d2
	CMP.B	#$ff,d2			; Ende-Text Signal? ($FF)
	beq.s	EndeTEXT		; Wenn ja, raus, ohne was zu drucken
	TST.B	d2				; Ende-Zeile Signal? ($00)
	bne.s	NichtEndeZeile	; Wenn nicht, nimm keine neue (Text-)Zeile

	ADD.L	#80*7,PointeBitplane	; NEUE TEXTZEILE
	ADDQ.L	#1,PointeText	; erster Buchstabe in der neuen Zeile
							; (überspringen die NULL)
	move.b	(a0)+,d2		; erster Buchstabe in der neuen Zeile
							; (überspringen die NULL)

NichtEndeZeile:
	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT

	MOVE.L	PointeBitplane(PC),A3 ; Adresse des Ziel-Bitplane in a3

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"

	ADDQ.L	#1,PointeBitplane ; 8 Bit weiter vor (NÄCHSTER BUCHSTABE)
	ADDQ.L	#1,PointeText	; nächster zu druckende Buchstabe

EndeTEXT:
	RTS


PointeText:
	dc.l	TEXT

PointeBitplane:
	dc.l	BITPLANETEXT


TEXT:
        dc.b    "          DIESES DEMO FASST DIE LEKTION "
        dc.b    "6 ZUSAMMEN, ES ENTHAELT SEI ES          ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          DIE DRUCKROUTINE FUER 8X8 PIXE"
        dc.b    "L GROSSE CHARAKTER, WIE AUCH            ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          DEN HORIZONTALEN SCROLL MIT DE"
        dc.b    "M BPLCON1 ($dff102) UND DEN BIT-        ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          PLANEPOINTERS UND DIE VERWENDU"
        dc.b    "NG EINER VORDEFINIERTEN TABELLE         ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          FUER DEN VERTIKALSCROLL DIESES"
        dc.b    " TEXTES.                                ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          DAS PLAYFIELD, AUF DEM DIESER "
        dc.b    "TEXT GEDRUCKT WIRD, IST SO GROSS        ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          WIE EIN HIRES-SCHIRM, ALSO 640"
        dc.b    " PIXEL IN DER BREITE UND 256 IN         ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          DER HOEHE, ES WIRD SOWOHL VERT"
        dc.b    "IKAL WIE AUCH HORIZONTAL GESCROLLT,     ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          WAEHREND DAS BITPLANE MIT DEM "
        dc.b    "SCHACHMUSTER NUR HORIZONTAL HIN UND     ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          HER GESCROLLT WIRD. DER VERTIK"
        dc.b    "ALSCROLL HAT EIN VARIABLES TEMPO,       ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          WEIL ER VON EINER TABELLE BEST"
        dc.b    "IMMT WIRD, DER HORIZONTALE IST IMMER    ",0
        dc.b    "                                        "
        dc.b    "                                        ",0
        dc.b    "          ZU 2 PIXEL PRO FOTOGRAMM (FRAM"
        dc.b    "E).                                     ",$FF

	EVEN

;************************************************************************
;*	Scroll von 320 Pixel nach Links und Rechts  (Listing6o.s)       *
;************************************************************************

; Bemerkung: So modifizieren, daß auf das Bitplane MATRIX zugegriffen
; wird!


MEGAScroll:
	addq.w	#1,WieOft		; Signalisieren einen weiteren Durchgang
	cmp.w	#160,WieOft		; Sind wir auf 320?
	bne.S	BewegNochMal	; Wenn nicht, scrolle noch weiter
	BCHG.B	#1,RechtsLinks	; Wenn wir aber auf 320 sind, wechsle Richtung
	CLR.w	WieOft			; und setze "WieOft" auf NULL
	rts

BewegNochMal:
	BTST	#1,RechtsLinks	; Müssen wir rechts oder links gehen?
	BEQ.S	GehLinks
	bsr.s	Rechts			; Scrollt ein Pixel nach Rechts
	bsr.s	Rechts			; Scrollt ein Pixel nach Rechts
							; 2 Pixel pro Frame, also doppelte Geschwindigkeit
	rts

GehLinks:
	bsr.s	Links			; Scrollt ein Pixel nach Links
	bsr.s	Links			; Scrollt ein Pixel nach Links
							; Auch hier zwei mal, doppelte Geschwindigkeit
	rts

; Dieses Word zählt, wie oft wir Links bzw. Rechts gegangen sind.

WieOft:
	DC.W	0

; Wenn das Bit 1 von RechtsLinks auf NULL ist, dann scrollt die Routine
; nach links, wenn es auf EINS ist, dann nach rechts

RechtsLinks:
	DC.W	0

; Diese Routine scrollt ein Bitplane nach rechts, indem es auf das BPLCON1
; und den Bitplanepointers in der Copperlist einwirkt. MEINBPCON1 ist das 
; Byte des BPLCON1.

Rechts:
	CMP.B	#$ff,MEINBPCON1 ; sind wir bei maximalen Scroll angelangt (15)?
	BNE.s	CON1ADDA		; wenn nicht, weiter um ein weiteres
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	LEA	BPLPOINTERS2,A2		; Take address from copperlist
	move.w	2(a2),d1
	swap	d1
	move.w	6(a2),d1

	subq.l	#2,d0			; pointet 16 Bit weiter nach hinten, das Bild
							; scrollt um 16 Pixel nach Rechts

	subq.l	#2,d1			; pointet 16 Bit weiter nach hinten...

	clr.b	MEINBPCON1		; löscht den Hardwarescroll des BPLCON1 ($dff102)
							; denn wir haben 16 Pixel schon mit den Bitplane-
							; Pointers "übersprungen", wir müssen wieder bei
							; NULL beginnen, um mit dem $dff102 um jeweils
							; 1 Pixel nach rechts zu gehen.

;	Pointen auf das Text-Bitplane

	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane


;	Pointen auf das MATRIX-Bitplane

	move.w	d1,6(a2)		; kopiert das niederw. Word der Adress des Plane
	swap	d1				; vertauscht die 2 Word von d1 (z.B.: 1234 > 3412)
	move.w	d1,2(a2)		; kopiert das höherw. Word der Adresse des Plane

	rts


CON1ADDA:
	add.b	#$11,MEINBPCON1 ; scrolle ein Pixel nach vorne
	rts

;	Routine, die nach Links scrollt, identisch mit der vorherigen:

LINKS:
	TST.B	MEINBPCON1		; sind wir bei minimalen Scroll angelangt (00)?
	BNE.s	CON1SUBBA		; wenn nicht, zurück um ein weiteres

	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	LEA	BPLPOINTERS2,A2		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a2),d1		; Copperlist die Adresse, wohin das $dff0e0
	swap	d1				; gerade pointet und geben diesen Wert
	move.w	6(a2),d1		; in d0
	
	addq.l	#2,d0			; pointet 16 Bit weiter nach vorne, das Bild
							; scrollt um 16 Pixel nach Links
 
	addq.l	#2,d1			; pointet 16 Bit weiter nach vorne, das Bild
							; scrollt um 16 Pixel nach Links

	move.b	#$FF,MEINBPCON1	; Hardwarescroll auf 00 (BPLCON1, $dff102)

;	Pointen auf das Text-Bitplane

	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane

;	Pointen auf das MATRIX-Bitplane

	move.w	d1,6(a2)		; kopiert das niederw. Word der Adress des Plane
	swap	d1				; vertauscht die 2 Word von d1 (z.B.: 1234 > 3412)
	move.w	d1,2(a2)		; kopiert das höherw. Word der Adresse des Plane

	rts


CON1SUBBA:
	sub.b	#$11,MEINBPCON1 ; scrolle ein Pixel nach hinten
	rts

;************************************************************************
;*  Scrollt RAUF/RUNTER unter Verwendung einer Tabelle (Listing6m.s)    *
;************************************************************************


BOING:
	LEA	BPLPOINTERS,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0

	ADDQ.L	#4,BOINGTABPOINT    ; Pointe auf das nächste Longword
	MOVE.L	BOINGTABPOINT(PC),A0 ; Adresse, die im Long BOINGTABPOINT steht
								; wird in a0 kopiert
	CMP.L	#ENDEBOINGTAB-4,A0	; Sind wir beim letzten Longword in der TAB?
	BNE.S	NOBSTART2			; noch nicht? dann fahr´ fort
	MOVE.L	#BOINGTAB-4,BOINGTABPOINT ; Starte wieder beim ersten Long
NOBSTART2:
	MOVE.l	(A0),d1			; kopiere das Long aus der Tabelle in d1

	sub.l	d1,d0			; subtrahieren den Wert aud der Tabelle, somit
							; scrollt das Bild rauf oder runter

	LEA	BPLPOINTERS,A1		; Pointer in der COPPERLIST
	MOVEQ	#1,D1			; Anzahl der Bitplanes -1 (hier sind es 2)


POINTBP2:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adress des Plane
	swap	d0				; vertauscht die 2 Word von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert das höherw. Word der Adresse des Plane
	swap	d0				; vertauscht die 2 Word von d0 (3412 > 1234)
	ADD.L	#80*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; zu den nächsten bplpointers in der Cop
;	dbra	d1,POINTBP2		; Wiederhole D1 Mal POINTBP (D1=num of bitplanes)
	rts


BOINGTABPOINT:				; Dieses Longword "POINTET" auf BOINGTAB, also
	dc.l	BOINGTAB-4		; enthält es die Adresse von BOINGTAB. Es wird
							; die Adresse des letzten gelesenen Long innerhalb
							; der Tab beinhalten.(hier beginnt es bei BOINGTAB-4
							; weil BOING mit einem  ADDQ.L #4,C.. beginnt
							; es gleicht somit diese Anweisung aus.

;	Die Tabelle mit den "vorgerechneten" Rückprallwerten:

BOINGTAB:
	dc.l	0,0,80,80,80,80,80,80,80,80,80					; ganz Oben
	dc.l	80,80,2*80,2*80
	dc.l	2*80,2*80,2*80,2*80,2*80						; beschleunigen
	dc.l	3*80,3*80,3*80,3*80,3*80
	dc.l	3*80,3*80,3*80,3*80,3*80
	dc.l	2*80,2*80,2*80,2*80,2*80						; bremsen
	dc.l	2*80,2*80,80,80
	dc.l	80,80,80,80,80,80,80,80,80,0,0,0,0,0,0,0		; ganz Unten
	dc.l	-80,-80,-80,-80,-80,-80,-80,-80,-80
	dc.l	-80,-80,-2*80,-2*80
	dc.l	-2*80,-2*80,-2*80,-2*80,-2*80
	dc.l	-3*80,-3*80,-3*80,-3*80,-3*80					; beschleunigen
	dc.l	-3*80,-3*80,-3*80,-3*80,-3*80
	dc.l	-2*80,-2*80,-2*80,-2*80,-2*80					; bremsen
	dc.l	-2*80,-2*80,-80,-80
	dc.l	-80,-80,-80,-80,-80,-80,-80,-80,-80,0,0,0,0,0	; ganz Oben
ENDEBOINGTAB:

;************************************************************************
;* Erstellt ein Schachbrett mit 16 Pixel großen Quadraten (Listing6q.s) *
;************************************************************************

MATRIX3:
	LEA	BITPLANEMATRIX,a0	; Adresse Ziel-Bitplane

	MOVEQ	#8-1,d0			; 8 Paare von 16 Pixel hohen Quadraten
							; 8*2*4=256 totales Ausfüllen des Bildschirmes
MachPaar3:
	move.l	#(20*16)-1,d1	; 10 Bytes um eine Zeile zu füllen
							; 16 Zeilen zu füllen
MachEins3:
	move.l	#%11111111111111110000000000000000,(a0)+
							; Länge eines Quadrates auf 1=16 Pixel
							; Quadrate auf NULL = 16 Pixel
	dbra	d1,MachEins3	; mach 16 Zeilen #.#.#.#.#.#.#.#.#.#

	move.l	#(20*16)-1,d1	; 10 Bytes um eine Zeile zu füllen
							; 16 Zeilen zu füllen
MachAndres3:

	move.l	#%00000000000000001111111111111111,(a0)+
							; Länge eine auf NULL gesetzten Quadr.=16 Pixel
							; Quadrat auf 1 = 16 Pixel
	dbra	d1,MachAndres3	; mach 8 Zeilen .#.#.#.#.#.#.#.#.#.

	DBRA	d0,MachPaar3	; mach 8 Paare von Quadraten
							; #.#.#.#.#.#.#.#.#.#
	rts						; .#.#.#.#.#.#.#.#.#.

; **************************************************************************
; *		ROUTINE; DIE DIE MUSIK SPIELT (SOUNDTRACKER/PROTRACKER)	   *
; **************************************************************************

	include "/Sources/musicE.s"	; Routine 100% funktionsfähig auf allen Amigas


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt (Register mit Normalwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0030		; DdfStart (wegen Scroll modifiziert)
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102			; BplCon1
	dc.b	0				; hochwertiges Byte des $dff102,nicht verwendet
MEINBPCON1:
	dc.b	0				; niederwertiges Byte des $dff102, verwendet
	dc.w	$104,0			; BplCon2
	dc.w	$108,40-2		; Bpl1Mod ( 40 für ein Bild, das 640 breit ist,
	dc.w	$10a,40-2		; Bpl2Mod   -2 um das DDFSTART auszugleichen)

				; 5432109876543210
	dc.w	$100,%0010001000000000  ; Bits 13 an -

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000		; erste Bitplane
BPLPOINTERS2:
	dc.w	$e4,0,$e6,0				; zweite Bitplane

	dc.w	$180,$113		; color0 - DUNKLES QUADRAT
	dc.w	$182,$bb5		; color1 - SCHRIFTEN+dunkles Quadrat
	dc.w	$184,$225		; color2 - Helles Quadrat
	dc.w	$186,$bb5		; color3 - SCHRIFTEN+Helles Quadrat

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
	incbin	"/Sources/metal.fnt"	; Breiter Zeichensatz
;	incbin	"/Sources/normal.fnt"	; Ähnlich dem aus dem Kickstart 1.3
;	incbin	"/Sources/nice.fnt"	; Schmaler Zeichensatz

; **************************************************************************
; *				PROTRACKER-MUSIKSTÜCK			   *
; **************************************************************************

mt_data:
	incbin	"/Sources/mod.purple-shades"



	SECTION MEIPLANE,BSS_C


BITPLANEMATRIX:
	ds.b	80*256			; eine Bitplane, 640x256 breit (wie Hires)


	ds.b	80*100
BITPLANETEXT:
	ds.b	80*256			; eine Bitplane 640x256


	end

Manchmal ergeben einige nicht recht aufsehenerregende Routinen zusammen
einen recht schönes Ergebnis...

