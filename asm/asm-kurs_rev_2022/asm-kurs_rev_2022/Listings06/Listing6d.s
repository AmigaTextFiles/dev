
; Listing6d.s	HIRES UND LOWRES IM GLEICHEN SCREEN

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
 
	;MOVE.L	#PIC,d0
	MOVE.L	#PIC+(40*50),d0 ; in d0 kommt die Adresse von unserer PIC,
							; hier pointen wir 50 weiter nach vorne
							; bzw. wo ihr erstes Bitplane beginnt

	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederw. Word der Planeadresse 
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das hochw. Word der Adresse des Plnae
	swap	d0				; vertauscht erneut die 2 Word von d0
	ADD.L	#40*256,d0		; + Länge Bitplane -> nächstes Bitplane
	addq.w	#8,a1			; auf zum nächsten bplpointer in der COP
	dbra	d1,POINTBP		; wiederhole D1 mal POINTBP (D1=n. bitplanes)
 
;	POINTEN AUF UNSER BITPLANE

	MOVE.L	#BITPLANE,d0	; in d0 kommt die Adresse des PIC
	LEA	BPLPOINTERS2,A1		; Pointer in der Copperlist
	move.w	d0,6(a1)		; kopiert das niederw. Word der Planeadresse
	swap	d0				; vertauscht die 2 word in d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das hochw. Word der Planeadresse
 
	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

	bsr.w	print			; Bringt den Text auf den Bildschirm

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
	MOVEQ	#15-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 15
PRINTZEILE:
	MOVEQ	#80-1,D0		; ANZAHL DER SPALTEN EINER ZEILE: 80 (HIRES!)

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
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTABEN IM FONT

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"

	ADDQ.w	#1,A3			; A3+1, wir gehen um 8 Bit weiter (zum
							; nächsten Buchstaben)

	DBRA	D0,PRINTCHAR2	; DRUCKEN D0 (80) ZEICHEN PRO ZEILE
 
	ADD.W	#80*7,A3		; "Return", neue Zeile

	DBRA	D3,PRINTZEILE	; Wir drucken D3 Zeilen
	RTS


TEXT:
             ; Anzahl Charakter pro Zeile: 80, also 2 von diesen zu 40!

             ;            1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890

	dc.b	'   ERSTE ZEILE IN  HIRES 640  PIXEL  BRE' ; 1a \ ERSTE ZEILE
	dc.b	'ITE!  -- -- -- --  IMMER DIE ERSTE ZEILE' ; 1b /
	dc.b	'                ZWEITE ZEILE            ' ; 2  \ ZWEITE ZEILE
	dc.b	'AUCH NOCH ZWEITE ZEILE                  ' ;    /
	dc.b	'     /\  /                              ' ; 3
	dc.b	'                                        ' ;
	dc.b	'    /  \/                               ' ; 4
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 5
	dc.b	'                                        ' ;
	dc.b	'        SECHSTE ZEILE                   ' ; 6
	dc.b	'                      ENDE SECHSTE ZEILE' ;
	dc.b	'                                        ' ; 7
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 8
	dc.b	'                                        ' ;
	dc.b	'FABIO CIUCCI COMMUNICATION INTERNATIONAL' ; 9
	dc.b	' MARKETING TRUST TRADEMARK COPYRIGHTED  ' ;
	dc.b	'                                        ' ; 10
	dc.b	'                                        ' ;
	dc.b	'   1234567890 !@#$%^&*()_+|\=-[]{}      ' ; 11
	dc.b	'       TECHNISCHER SENDETEST            ' ;
	dc.b	'                                        ' ; 12
	dc.b	'                                        ' ;
	dc.b	'     SEIN ODER NICHT SEIN, DAS IST HIER ' ; 13
	dc.b	' DIE FRAGE...                           ' ;
	dc.b	'                                        ' ; 14
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 15
	dc.b	'                                        ' ;
	dc.b	'  Das Fraeulein stand am Meere          ' ; 16
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 17
	dc.b	'                                        ' ;
	dc.b	'    UnD seufzte LanG uNd Bang,          ' ; 18
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 19
	dc.b	'                                        ' ;
	dc.b	'    Es ruehrte sie so sehre,            ' ; 20
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 21
	dc.b	'                                        ' ;
	dc.b	'  der Sonnenuntergang...                ' ; 22
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 23
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 24
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 25
	dc.b	'                                        ' ;
	dc.b	'                                        ' ; 26
	dc.b	'                                        ' ;

	EVEN


	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt (Register mit Normalwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0011001000000000  ; Bit 12 und 13 an!

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite Btplane
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane
 
	dc.w	$180,$000		; Color0
	dc.w	$182,$475		; Color1
	dc.w	$184,$fff		; Color2
	dc.w	$186,$ccc		; Color3
	dc.w	$188,$999		; Color4
	dc.w	$18a,$232		; Color5
	dc.w	$18c,$777		; Color6
	dc.w	$18e,$444		; Color7

;	HIER WERDEN BPLCON0,FARBEN,DDFSTART/STOP UND POINTER AUF DIE BITPLANES
;	NEUDEFINIERT!

	dc.w	$a007,$FFFE

	dc.w	$92,$003c		; DdfStart HIRES
	dc.w	$94,$00d4		; DdfStop HIRES

				; 5432109876543210
	dc.w	$100,%1001001000000000  ; 1 Bitplane HIRES 640x256

BPLPOINTERS2:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane

	dc.w	$0180,$000		; Color0 - HINTERGRUND
	dc.w	$0182,$19a		; Color1 - SCHRIFT

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
;	incbin	"/Sources/metal.fnt"	; Breiter Zeichensatz
;	incbin	"/Sources/normal.fnt"	; Ähnlich dem aus dem Kickstart 1.3
	incbin	"/Sources/nice.fnt"	; Schmaler Zeichensatz

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"
							; hier laden wir das Bild im RAW-Format

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	80*256			; ein Bitplane HIRES 640x256

	end

Man könnte auch 50 mal in einem Screen die Auflösung wechseln, einfach das
BPLCON0 neu definieren,  die Farben und die Pointer auf die Bitplanes. Das
kann nützlich sein, wenn mitten im Bildschirm 32 Farben nötig  sind,  z.B.
um  ein Männchen  in  einem   Videospiel  zu  bewegen,  darunter,  im
Kontrollfeld/Punktefeld aber nur 16 oder  vielleicht  gar  nur  4.  Dieses
könnte  man  zusätzlich noch in HiRes gestalten. Man braucht nur bedenken,
daß desto mehr Zeilen in HiRes sind, desto langsamer wird  die  Ausführung
des  Programmes  /  Spieles.  Desto  mehr  Farben  ins Spiel kommen, desto
weniger Zeit haben die Coprozessoren und der 68000 selbst. Deswegen  macht
sich  der  Aufwand  bezahlt,  nur  einige  Streifen  in  HiRes oder HAM zu
gestalten, und den Rest in LowRes.  Man  kann  so  einen  guten  Kompromiß
zwischen Augenschmaus und Geschwindigkeit finden.


