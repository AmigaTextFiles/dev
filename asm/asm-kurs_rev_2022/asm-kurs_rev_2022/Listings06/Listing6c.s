
; Listing6c.s	GEBEN MEHRERE ZEILEN AM BILDSCHIRM AUS!!!

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
	MOVEQ	#23-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 23
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
	dc.b	'   PREISFRAGE: WER KENNT DEN AUTOR?     ' ; 15
	dc.b	'                                        ' ; 25
	dc.b	'                                        ' ; 16
	dc.b	'  Das Fraeulein stand am Meere          ' ; 17
	dc.b	'                                        ' ; 18
	dc.b	'  Und seufzte lang und bang.            ' ; 19
	dc.b	'                                        ' ; 20
	dc.b	'  Es RueHrtE sIe sO sEhRe               ' ; 21
	dc.b	'                                        ' ; 22
	dc.b	'  der Sonnenuntergang.                  ' ; 23
	dc.b	'                                        ' ; 24
	dc.b	'        ...                             ' ; 25
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

	dc.w	$6c07,$fffe		; Farbverlauf auf Textzeile 9
	dc.w	$182,$451		; Zeile1 des Charakters
	dc.w	$6d07,$fffe
	dc.w	$182,$671		; Zeile 2
	dc.w	$6e07,$fffe
	dc.w	$182,$891		; Zeile 3
	dc.w	$6f07,$fffe
	dc.w	$182,$ab1		; Zeile 4
	dc.w	$7007,$fffe
	dc.w	$182,$781		; Zeile 5
	dc.w	$7107,$fffe
	dc.w	$182,$561		; Zeile 6
	dc.w	$7207,$fffe
	dc.w	$182,$451		; Zeile 7  die letzte, weil die achte auf
							;  NULL steht, um einen Abstand zwischen
							;  den Buchstaben zu lassen

	dc.w	$7307,$fffe
	dc.w	$182,$19a		; Normale Farbe

	dc.w	$8c07,$fffe		; Farbverlauf auf Textzeile 11
	dc.w	$182,$516		; Zeile1 des Buchstaben
	dc.w	$8d07,$fffe
	dc.w	$182,$739		; Zeile 2
	dc.w	$8e07,$fffe
	dc.w	$182,$95b		; Zeile 3
	dc.w	$8f07,$fffe
	dc.w	$182,$c6f		; Zeile 4
	dc.w	$9007,$fffe
	dc.w	$182,$84a		; Zeile 5
	dc.w	$9107,$fffe
	dc.w	$182,$739		; Zeile 6
	dc.w	$9207,$fffe
	dc.w	$182,$517		; Zeile 7  die letzte, weil die achte auf NULL

	dc.w	$9307,$fffe
	dc.w	$182,$19a		; Normale Farbe

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
;	incbin	"/Sources/metal.fnt"	; breite Charakter
;	incbin	"/Sources/normal.fnt"	; ähnlich den Kickstart 1.3 Fonts
	incbin	"/Sources/nice.fnt"	; schmale Charakter

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	40*256			; ein Bitplane LowRes 320x256

	end

Wie ihr gesehen habt,ist der Umstand, daß der Font nur in einer Farbe ist, noch
lange kein Grund, um nicht mit dem Copper etwas Farbe ins Spiel zu bringen!

Um mehrere Zeilen  zu  schreiben,  muß  man  nur "Zeile-wechseln" und dann die
nächste auf den Schirm pulvern! Das wiederholt sich D3 Mal.

	ADD.W	#40*7,A3		; "RETURN"
	DBRA	D3,PRINTZEILE	; MACHEN D3 ZEILEN

Bemerkung: Um eine neue Zeile zu nehmen, also "RETURN", muß man 7 Zeilen  nach
unten  gehen. Mit neuer  Zeile  meinte ich TEXTZEILE, 8 Pixel hoch, die andere
Zeile war die effektive VideoZeile.

Darum braucht es ein "ADD.W #40*7,A3" für ein RETURN:

Das Probelm besteht darin, daß man den Eindruck haben könnte, man befinde sich
mit A3 schon auf der untersten V-Zeile des zuletzt gedruckten Buchstaben,und es
reiche, eine einzige nach unten zu gehen, um sich in die nächsten  Textzeile zu
begeben. Aber in A3 ist und bleibt immer nur die Adresse der ersten V-Zeile des
Charakters, denn die weiteren 7 werden ja mittels OFFSET erzeugt:

	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile 8  "	"

Aber in Register  A3  steht immer die Adresse der ersten Zeile. Denn jedesmal,
wenn ein Buchstabe gedruckt wird, dann begeben wir uns zum nächsten  Charakter,
indem wir 8  Bit, also ein Byte, zur Adresse in A3 dazuzählen. Diese wird dann
auf die erste (Video)Zeile dieses Buchstaben pointen.

	ADDQ.w	#1,A3			; A3+1, wir gehen um 8 Bit weiter (zum
							; nächsten Buchstaben

An diesem Punkt, um den "nächsten Charakter" zu drucken, braucht  man  nur  die
Routine mit  den  Offsets zu wiederholen. Schauen wir die Situation genauer an,
wenn wir den Buchstaben ganz rechts  gedruckt  haben,  also den  letzten  einer
T-Zeile: in A3 haben wir die Adresse des letzten Buchstaben,und nach den ganzen
Offsets kommt die Anweisung zum  Zuge,  die  A3  um  8  Bit weitersetzt.  Damit
befinden wir uns aber schon in der nächsten V-Zeile, aber ganz links,weil es ja
"zu weit" gerutscht ist! Deswegen brauchen wir nur 7 -und nicht 8- dazuzählen,
weil  wir uns ja schon auf der "zweiten" VideoZeile nach der gerade gedruckten
Textzeile befinden.

