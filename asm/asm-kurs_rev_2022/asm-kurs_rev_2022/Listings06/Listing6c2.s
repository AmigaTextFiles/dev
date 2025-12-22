
; Listing6c2.s	GEBEN MEHRERE ZEILEN AM BILDSCHIRM AUS!!!
;				- mit einem leicht modifizierbaren Binärfont!!!

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
	MOVEQ	#25-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 25
PRINTZEILE:
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

	ADD.W	#40*7,A3		; "Return", neue Zeile

	DBRA	D3,PRINTZEILE	; Wir drucken D3 Zeilen
	RTS

;			VORHANDENE CHARAKTER IM FONT:
;
;	 !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ
;
;		NICHT IM FONT ENTHALTENE CHARS, NICHT VERWENDEN:
;
;			[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
;
;
; Bemerkung: Das Symbol "@" druckt ein lachendes Gesicht aus... wieso nicht?


TEXT:
             ;            1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'   ERSTE ZEILE                          ' ; 1
	dc.b	'                ZWEITE ZEILE            ' ; 2
	dc.b	'     /\  /                              ' ; 3
	dc.b	'    /  \/                               ' ; 4
	dc.b	'                                        ' ; 5
	dc.b	'        SECHSTE ZEILE                   ' ; 6
	dc.b	'                                        ' ; 7
	dc.b	'                                        ' ; 8
	dc.b	'FABIO CIUCCI COMMUNICATION INTERNATIONAL' ; 9
	dc.b	'                                        ' ; 10
	dc.b	'   1234567890 !@#$%^&*()_+|\=-[]{}      ' ; 11
	dc.b	'                                        ' ; 12
	dc.b	'     EIN BISSCHEN DANTE IN ORGINAL      ' ; 15
	dc.b	'             GEFAELLIG?                 ' ; 25
	dc.b	'                                        ' ; 16
	dc.b	'  NEL MEZZO DEL CAMMIN DI NOSTRA VITA   ' ; 17
	dc.b	'                                        ' ; 18
	dc.b	'    MI RITROVAI PER UNA SELVA OSCURA    ' ; 19
	dc.b	'                                        ' ; 20
	dc.b	'    CHE LA DIRITTA VIA ERA SMARRITA     ' ; 21
	dc.b	'                                        ' ; 22
	dc.b	'  AHI QUANTO A DIR QUAL ERA...          ' ; 23
	dc.b	'                                        ' ; 24
	dc.b	'   @ @ @ NUR GROSSBUCHSTABEN @ @ @      ' ; 25
	dc.b	'                                        ' ; 26
	dc.b	'                                        ' ; 27

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

;	Charakter:  !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ
;	ACHTUNG! Es gibt nicht: [\]^_`abcdefghijklmnopqrstuvwxyz{|}~


FONT:
; ' '
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
; '!'
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00000000
	dc.b	%00011000
	dc.b	%00000000
; '"'
	dc.b	%00011011
	dc.b	%00011011
	dc.b	%00011011
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
; '#'
	dc.b	%00010100
	dc.b	%00010100
	dc.b	%00010100
	dc.b	%01111111
	dc.b	%00010100
	dc.b	%00010100
	dc.b	%00010100
	dc.b	%00000000
; '$'
	dc.b	%00001000
	dc.b	%00011110
	dc.b	%00100000
	dc.b	%00011100
	dc.b	%00000010
	dc.b	%00111100
	dc.b	%00001000
	dc.b	%00000000
; '%'
	dc.b	%00000001
	dc.b	%00110011
	dc.b	%00110110
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00110110
	dc.b	%01100110
	dc.b	%00000000
; '&'
	dc.b	%00011000
	dc.b	%00100100
	dc.b	%00011000
	dc.b	%00011001
	dc.b	%00100110
	dc.b	%00111110
	dc.b	%00011001
	dc.b	%00000000
; "'"
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
; "("
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00110000
	dc.b	%00110000
	dc.b	%00110000
	dc.b	%00011000
	dc.b	%00001100
	dc.b	%00000000
; ")"
	dc.b	%00110000
	dc.b	%00011000
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00110000
	dc.b	%00000000
; "*"
	dc.b	%01100011
	dc.b	%00110110
	dc.b	%00011100
	dc.b	%01111111
	dc.b	%00011100
	dc.b	%00110110
	dc.b	%01100011
	dc.b	%00000000
; '+'
	dc.b	%00000000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%01111110
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00000000
	dc.b	%00000000
; ","
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00110000
	dc.b	%00000000
; "-"
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%01111110
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
; "."
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00000000
; "/"
	dc.b	%00000001
	dc.b	%00000011
	dc.b	%00000110
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00110000
	dc.b	%01100000
	dc.b	%00000000
; '0'
	dc.b	%01111111
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%00000000
; '1'
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000000
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000000
; '2'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000000
; '3'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%00000011
	dc.b	%00011111
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000000
; '4'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000000
; '5'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000000
; '6'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%00000000
; '7'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000000
; '8'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%00000000
; '9'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000000
; ':'
	dc.b	%00000000
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00000000
; ';'
	dc.b	%00000000
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00000000
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00000000
; "<"
	dc.b	%00000110
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00110000
	dc.b	%00011000
	dc.b	%00001100
	dc.b	%00000110
	dc.b	%00000000
; "="
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%01111110
	dc.b	%00000000
	dc.b	%01111110
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
; ">"
	dc.b	%00011000
	dc.b	%00001100
	dc.b	%00000110
	dc.b	%00000011
	dc.b	%00000110
	dc.b	%00001100
	dc.b	%00110000
	dc.b	%00000000
; '?'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%00000011
	dc.b	%00001111
	dc.b	%00001100
	dc.b	%00000000
	dc.b	%00001100
	dc.b	%00000000
; "@"
	dc.b	%00000000	; :-)
	dc.b	%11100111
	dc.b	%11100111
	dc.b	%00000000
	dc.b	%00010000
	dc.b	%00011000
	dc.b	%10000001
	dc.b	%01111110
; "A"
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
; "B"
	dc.b	%01111110
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01111110
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111110
	dc.b	%00000000
; 'C'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000000
; 'D'
	dc.b	%01111110
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111110
	dc.b	%00000000
; 'E'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01111100
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000000
; 'F'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01111100
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%00000000
; 'G'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01100111
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%00000000
; 'H'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01101111
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
; 'I'
	dc.b	%00111111
	dc.b	%00000000
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00001100
	dc.b	%00111111
	dc.b	%00000000
; 'J'
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000000
; 'K'
	dc.b	%01100011
	dc.b	%01100110
	dc.b	%00001100
	dc.b	%01111000
	dc.b	%01101100
	dc.b	%01100110
	dc.b	%01100011
	dc.b	%00000000
; 'L'
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%00000000
	dc.b	%01111111
	dc.b	%00000000
; 'M'
	dc.b	%01100011
	dc.b	%01110111
	dc.b	%01101011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
; 'N'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
; 'O'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%00000000
; 'P'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01111111
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%01100000
	dc.b	%00000000
; 'Q'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100111
	dc.b	%01111111
	dc.b	%00000000
; 'R'
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%01100011
	dc.b	%01111100
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
; 'S'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%01100000
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000000
; 'T'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%00000000
; 'U'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000000
; 'V'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00110110
	dc.b	%00011100
	dc.b	%00000000
; 'W'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%01101011
	dc.b	%01110111
	dc.b	%01100011
	dc.b	%00000000
; 'X'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00110110
	dc.b	%00001000
	dc.b	%00110110
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000000
; 'Y'
	dc.b	%01100011
	dc.b	%01100011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000011
	dc.b	%00000011
	dc.b	%01111111
	dc.b	%00000000
; 'Z'
	dc.b	%01111111
	dc.b	%00000000
	dc.b	%00000110
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%00110000
	dc.b	%01111111
	dc.b	%00000000
;
; Es fehlen die Kleinbuchstaben... Wenn ihr die Geduld aufweist, dann macht
; nur! Oder ihr macht eine Zeichnung, die sich beim zusammenstellen ergibt...
;


	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	40*256			; ein Bitplane LowRes 320x256

	end


Dieses  Listing  ist  identisch  mit dem in Listing6c.s, aber der Font ist
"handgemacht". Anstatt ihn ins Listing zu laden liegt er  hier  direkt  in
Form von dc.b vor (binär).


			;12345678
; "A"
	dc.b	%01111111	;1
	dc.b	%00000011	;2
	dc.b	%01100011	;3
	dc.b	%01111111	;4
	dc.b	%01100011	;5
	dc.b	%01100011	;6
	dc.b	%01100011	;7
	dc.b	%00000000	;8

Das  z.B.  ist  das  "A".  Achtung,  verwendet im zu druckenden Text keine
Kleinbuchstaben, weil es sie im Font nicht gibt. Derjenige, der  den  Font
gezeichnet  hat,  hat  wohl  nach  dem großen "Z" den Geist aufgegeben! In
Wahrheit fehlten auch viele Symbole wie "*;<>=", ich habe sie  dazugemalt.
Nun  ist  vielleicht  auch  der Aufbau eines Font etwas klarer! Ihr werdet
auch ahnen, daß ein 16x16 Font ungefähr genau so aussehen wird:


			;1234567890123456
; "A"
	dc.w	%0000111111111100	;1
	dc.w	%0011111111111111	;2
	dc.w	%0011110000001111	;3
	dc.w	%0011110000001111	;4
	dc.w	%0011110000001111	;5
	dc.w	%0011110000001111	;6
	dc.w	%0011111111111111	;7
	dc.w	%0011111111111111	;8
	dc.w	%0011110000001111	;9
	dc.w	%0011110000001111	;10
	dc.w	%0011110000001111	;11
	dc.w	%0011110000001111	;12
	dc.w	%0011110000001111	;13
	dc.w	%0011110000001111	;14
	dc.w	%0000000000000000	;15
	dc.w	%0000000000000000	;16

Aber es zahlt sich aus, ihn zu zeichnen und dann in RAW zu konvertieren!

In diesem Listing empfehle ich euch, den  Font  zu  verändern,  indem  ihr
Bildchen und  komische  Zeichen  hinzufügt.  Ihr  könntet  euch  einen
persönlichen Font zulegen!

