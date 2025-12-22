
; Listing6b.s	GEBEN EINEN GANZE ZEILE TEXT AM BILDSCHIRM AUS!!!

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

	bsr.w	print			; Bringt die Zeile auf den Bildschirm

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


PRINT:
	LEA	TEXT(PC),A0			; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE,A3			; Adresse des Ziel-Bitplanes in a3
	MOVEQ	#40-1,D0		; ANZAHL DER SPALTEN EINER ZEILE: 40 (also die
							; Anzahl der Buchstaben, die in einer Zeile
							; Platz haben).
PRINTCHAR2:
	MOVEQ	#0,D2			; Löscht D2
	MOVE.B	(A0)+,D2		; Nächster Charakter in d2
	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUFUNGSZEICHEN ($21) IN $01...
	MULU.W	#8,D2			; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
							; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D2,A2
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile 8  "	"

	ADDQ.w	#1,A3			; A3+1, wir gehen um 8 Bit weiter (zum
							; nächsten Buchstaben

	DBRA	D0,PRINTCHAR2	; DRUCKEN D0 (40) ZEICHEN PRO ZEILE
	RTS


TEXT:
		;         1111111111222222222233333333334
		;1234567890123456789012345678901234567890
	;dc.b	'   ERSTE ZEILE AM MONITOR! 123 PROBE    '
	dc.b    '0123456789abcdef0123456789abcdef0123456789ab'  
	EVEN


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0001001000000000  ; 1 Bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane

	dc.w	$0180,$000		; color0 - HINTERGRUND
	dc.w	$0182,$19a		; color1 - SCHRIFTEN


	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
	incbin	"/Sources/metal.fnt"	; breite Charakter
;	incbin	"/Sources/normal.fnt"	; ähnlich den Kickstart 1.3 Fonts
;	incbin	"/Sources/nice.fnt"	; schmale Charakter

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	40*256			; ein Bitplane LowRes 320x256

	end


In eine Zeile kann man viel schreiben. Um 40 Zeichen zu drucken, reicht ein
DBRA-Zyklus, hier PRINTCHAR2 genannt:

	MOVEQ	#40-1,D0		; ANZAHL DER SPALTEN PRO ZEILE: 40
PRINTCHAR2:

Da  jeder  Buchstabe  1  Byte  "breit" ist, haben in einer LowRes-Zeile 40
solche Buchstaben Platz, in  einer  HiRes-Zeile  80.  Bevor  die  Schleife
wiederholt	wird,  die  einen  Buchstaben  ausgibt,  wird  noch  ein  ADD
ausgeführt, das unseren imaginären Cursor  ein  Byte  weiter  schiebt,  um
diesen neben den vorher gedruckten plaziert:

	ADDQ.w	#1,A3			; A1+1, weiter um 8 Bit (NÄCHSTER CHARAKTER)

	DBRA	D0,PRINTCHAR2	; DRUCKEN D0 (40) ZEICHEN PRO ZEILE


Ihr könnt aus drei verschiedenen Fonts  auswählen,  einfach  einen  der  ;
entfernen, wenn euch dieser Font interessiert, die anderen "ausklammern".

Wenn  ihr  es mit HiRes versuchen wollt, dann macht die Änderungen, wie in
Listing6a.s beschrieben. Damit habt ihr jetzt 80 Zeichen pro Zeile  platz.
Dafür müßt ihr aber den PRINTCHAR-Loop verändern: MOVEQ #80-1,d0. Den Text
könnt ihr auch in zwei Zeilen schreiben:

	dc.b	' ERSTE ZEILE am Bildschirm!! 123 Probe  ' 0-40
	dc.b	' ich bin immer noch auf der ersten Zeile' 41-80

	dc.b	" ZWEITE ZEILE!.........................."
	dc.b	"........................................"

	dc.b	" DRITTE ZEILE!.... etcetera.

