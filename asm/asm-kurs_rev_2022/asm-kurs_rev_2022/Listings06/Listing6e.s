
; Listing6e.s	ÜBERLAGERUNG VON ZWEI BITPLANES MIT EINER KLEINEN
;				VERSCHIEBUNG NACH UNTEN, UM EINEN RELIEF-EFFEKT ZU ERZEUGEN
 
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

	MOVE.L	#BITPLANE,d0	; in d0 kommt die Adresse des PIC
	LEA	BPLPOINTERS,A1		; Pointer in der Copperlist
	move.w	d0,6(a1)		; kopiert das niederw. Word der Planeadresse
	swap	d0				; vertauscht die 2 word in d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das hochw. Word der Planeadresse
 
; BEACHTET DAS -80!!!!
 
	MOVE.L	#BITPLANE-80,d0 ; in d0 kommt die Adresse des Bitplane-80,
							; also eine Zeile nach UNTEN verschoben!! ****
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
	MOVEQ	#25-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 15
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
	ADD.L	#FONT,A2		; FINDE DEN GEWÜNSCHTEN BUCHSTEBEN IM FONT

							; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)		; Drucke Zeile 1 des Buchstaben
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile 2	"	"
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile 8  "	"

	ADDQ.w	#1,A3			; A3+1, wir gehen um 8 Bit weiter (zum
							; nächsten Buchstaben
	
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
	dc.w	$92,$003c		; DdfStart \ HIRES...
	dc.w	$94,$00d4		; DdfStop  /
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%1010001000000000  ; Bit 13 - 2 Bitplanes, 4 Farben HIRES

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane
BPLPOINTERS2:
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane

	dc.w	$180,$103		; Color0 - HINTERGRUND
	dc.w	$182,$fff		; Color1 - Plane 1 Normalposition, es ist das
							; Stück, das oben "übersteht"
	dc.w	$184,$745		; Color2 - Plane 2 (nach unten verschoben)
	dc.w	$186,$abc		; Color3 - beide Plane - Überlagerung

	dc.w	$FFFF,$FFFE		; Ende der Copperlist
 
;	Der FONT, Charakter 8x8

FONT:
;	incbin	"/Sources/metal.fnt"	; Breiter Zeichensatz
;	incbin	"/Sources/normal.fnt"	; Ähnlich dem aus dem Kickstart 1.3
	incbin	"/Sources/nice.fnt"	; Schmaler Zeichensatz


	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll
	
	ds.b	80				; Die Zeile, die "übersteht"
BITPLANE:
	ds.b	80*256			; ein Bitplane HIRES 640x256

	end
 
Hier ein kleiner "Trick", um unsere Schrift  etwas  netter  zu  gestalten:
einfach  das  zweite Bitplane aktivieren und dem ersten überlagern, jedoch
um eine Zeile nach unten verschoben, um folgende Situation hervorzurufen:


	...###..				...111..	; 1 = Color1 (Hell)
	..#...#.	...###..	..12221.	; 2 = Color2 (Dunkel)
	..#...#.	..#...#.	..3...3.	; 3 = Color3 (Mittel)
	..#####.+	..#...#.=	..31113.
	..#...#.	..#####.	..32223.
	..#...#.	..#...#.	..3...3.
	..#...#.	..#...#.	..3...3.
	........	..#...#.	..2...2.
			........
				
	dc.w	$180,$103		; Color0 - HINTERGRUND
	dc.w	$182,$fff		; Color1 - Plane 1 Normalposition, es ist das
							; Stück, das oben "übersteht"
	dc.w	$184,$345		; Color2 - Plane 2 (nach unten verschoben)
	dc.w	$186,$abc		; Color3 - beide Plane - Überlagerung
 

Dieser Überlagerungseffekt von gleichen Bitplanes wird oft  verwendet,  um
Reliefs und Schattierungen vorzutäuschen.

Um  diesen Aspekt noch weiters hervorzuheben, wird oft auch noch zur Seite
verschoben, probiert das:

	dc.w	$102,$10		; BplCon1 - Plane 2 um ein Pixel nach rechts

(Diese Zeile kommt in der Copperlist zwischen die beiden BPLPOINTER!)

Bei kleinen Fonts verschlechtert das zwar oft die Leserbarkeit,  aber  bei
großen Flächen kann es manchmal toll aussehen:

	......
	.:::::#
	.:::::#
	.:::::#
	 ######

