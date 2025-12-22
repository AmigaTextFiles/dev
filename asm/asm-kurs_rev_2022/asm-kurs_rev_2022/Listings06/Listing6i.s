
; Listing6i.s		TEXT IN 3 FARBEN, BEI DEM EINE FARBE BLINKT
;					WIR VERWENDEN DAZU EINE VORDEFINIERTE TABELLE

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
	swap	d0				; vertauscht die 2 Word in d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das hochw. Word der Adresse des Plnae

;	POINTEN AUF UNSER BITPLANE

	MOVE.L	#BITPLANE2,d0	; in d0 kommt die Adresse des PIC
	LEA	BPLPOINTERS2,A1		; Pointer in der Copperlist
	move.w	d0,6(a1)		; kopiert das niederw. Word der Planeadresse
	swap	d0				; vertauscht die 2 word in d0 (1234 > 3412)
	move.w	d0,2(a1)		; kopiert das hochw. Word der Planeadresse
	
	move.l	#COPPERLIST,$dff080	; COP1LC - "Zeiger" auf unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

	LEA	TEXT(PC),A0			; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE,A3			; Adresse des Ziel-Bitplanes in a3
	bsr.w	print			; Bringt den Text auf den Bildschirm

	LEA	TEXT2(PC),A0		; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE2,A3		; Adresse des Ziel-Bitplanes in a3
	bsr.w	print			; Bringt den Text auf den Bildschirm
 
mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	beq.s	Warte			; gehe zu Warte

	bsr.w	BLINKEN			; ansonsten gehe zu BLINKEN

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

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


;	Blinkroutine, die eine vorgefertigte Farbverlauf-TABELLE verwendet.
;	Diese Tabelle ist nicht anderes als eine Reihe von Words mit den
;	verschiedenen RGB-Werten, die COLOR1 annehmen wird.
;	Diese Routine nimmt bei jedem Durchgang den nächsten Wert in der 
;	Tabelle, und wenn sie ein Word (2 Bytes) vor dem Label ENDECOLORTAB
;	angekommen ist, beginnt der Lesevorgang wieder beim ersten Element:
;
;	dc.w	1,3,5,7,9,8,6,4,2,1	; unsere "Mini"-Tabelle
;
;	Während der nächsten Fotogramme wird die Reihenfolge der kopierten
;	word so aussehen, in einem unendlichen Loop:
;
;	1,3,5,7,9,8,6,4,2,1,1,3,5,7,9,8,6,4,2,1,1,3,5,7,9,8,6,4,2,1....
;
;	Die Adresse des letzten gelesenen Word wird im Longword COLTABPOINT
;	gespeichert.

BLINKEN:
	ADDQ.L	#2,COLTABPOINT		; Pointet auf das nächste Word
	MOVE.L	COLTABPOINT(PC),A0  ; Adresse, die im Long COLTABPOINT steht
								; wird in a0 kopiert
	CMP.L	#ENDECOLORTAB-2,A0  ; Sind wir beim letzten Word in der TAB?
	BNE.S	NOBSTART2			; noch nicht? dann geh´ weiter
	MOVE.L	#COLORTAB-2,COLTABPOINT ; Starte wieder beim ersten Word
NOBSTART2:
	MOVE.W	(A0),Farbe1			; kopiere das Word der Tabelle in die COP
	rts


COLTABPOINT:				; Dieses Longword "POINTET" auf COLORTAB, also
	dc.l	COLORTAB-2		; enthält es die Adresse von COLORTAB. Es wird
						    ; die Adresse des zuletzt gelesenen Word innerhalb
						    ; der Tabelle beinhalten. (hier beginnt es bei 
						    ; COLORTAB-2, weil das Blinken ja mit ADDQ.L #2,C..
						    ; beginnt. Es dient zum "Ausgleich" dieser ersten
						    ; Anweisung.

;	Die Tabelle mit den vordefinierten Werten, die das Blinken ergeben:

COLORTAB:
	dc.w	$26F,$27E,$28D,$29C,$2AB,$2BA,$2C9,$2D8,$2E7,$2F6
	dc.w	$4E7,$6D8,$8C9,$ABA,$CAA,$D9A,$E8A,$F7A,$F6B,$F5C
	dc.w	$D6D,$B6E,$96F,$76F,$56F,$36F
ENDECOLORTAB:


;	Routine, die 8x8 Pixel große Buchstaben druckt

PRINT:
	MOVEQ	#27-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 26
PRINTZEILE:
	MOVEQ	#40-1,D0		; ANZAHL DER SPALTEN EINER ZEILE: 40 (LOWRES!)

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

	DBRA	D0,PRINTCHAR2	; DRUCKEN D0 (80) ZEICHEN PRO ZEILE

	ADD.W	#40*7,A3		; "Return", neue Zeile

	DBRA	D3,PRINTZEILE	; Wir drucken D3 Zeilen
	RTS

TEXT:
             ; Anzahl Charakter pro Zeile: 40
             ;            1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'   ERSTE ZEILE (nur TEXT1)              ' ; 1
	dc.b	'                                        ' ; 2
	dc.b	'     /\  /                              ' ; 3
	dc.b	'    /  \/                               ' ; 4
	dc.b	'                                        ' ; 5
	dc.b	'        SECHSTE ZEILE (beide Bitplanes) ' ; 6
	dc.b	'                                        ' ; 7
	dc.b	'                                        ' ; 8
	dc.b	'FABIO CIUCCI               INTERNATIONAL' ; 9
	dc.b	'                                        ' ; 10
	dc.b	'   1  4 6 89  !@ $ ^& () +| =- ]{       ' ; 11
	dc.b	'                                        ' ; 12
	dc.b	'     I H D N E,  L O BIN I H            ' ; 13
	dc.b	'                                        ' ; 24
	dc.b	'                                        ' ; 15
	dc.b	'  Das Fraeulein stand am Meere,         ' ; 16
	dc.b	'                                        ' ; 17
	dc.b	'    Und seufzte lang und bang,          ' ; 18
	dc.b	'                                        ' ; 19
	dc.b	'    Es ruehrte sie so sehre,            ' ; 20
	dc.b	'                                        ' ; 21
	dc.b	'      Sonnenuntergang.                  ' ; 22
	dc.b	'                                        ' ; 23
	dc.b	'           ...                          ' ; 24
	dc.b	'                                        ' ; 25
	dc.b	'                                        ' ; 26
	dc.b	'                                        ' ; 27
	
    EVEN

TEXT2:
             ; Anzahl Charakter pro Zeile: 40
             ;            1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890
	dc.b	'                                        ' ; 1
	dc.b	'  ZWEITE ZEILE (nur TEXT2)              ' ; 2
	dc.b	'     /\  /                              ' ; 3
	dc.b	'    /  \/                               ' ; 4
	dc.b	'                                        ' ; 5
	dc.b	'        SECHSTE ZEILE (beide Bitplanes) ' ; 6
	dc.b	'                                        ' ; 7
	dc.b	'                                        ' ; 8
	dc.b	'FABIO        COMMUNICATION INTERNATIONAL' ; 9
	dc.b	'                                        ' ; 10
	dc.b	'   1234567 90  @#$%^&*( _+|\=-[]{}      ' ; 11
	dc.b	'                                        ' ; 12
	dc.b	'     ICH DENKE, ALSO     ICH            ' ; 13
	dc.b	'                                        ' ; 14
	dc.b	'                                        ' ; 15
	dc.b	'  Das           stand am                ' ; 16
	dc.b	'                                        ' ; 17
	dc.b	'    Und s u  te l n  und b  g,          ' ; 18
	dc.b	'                                        ' ; 19
	dc.b	'    Es ruehrte        sehre,            ' ; 20
	dc.b	'                                        ' ; 21
	dc.b	'  Der Sonnen     gang.                  ' ; 22
	dc.b	'                                        ' ; 23
	dc.b	'           ...                          ' ; 24
	dc.b	'                                        ' ; 25
	dc.b	'                                        ' ; 26
	dc.b	'                                        ' ; 27

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
	dc.w	$100,%0010001000000000  ; 2 BITPLANES LOWRES, 4 FARBEN

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane
BPLPOINTERS2:
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane

	dc.w	$0180,$000		; Color0 - HINTERGRUND
	dc.w	$0182

Farbe1:
	dc.w	$000
	dc.w	$0184,$f62		; Color2 - SCHRIFT zweites Bitplane (ORANGE)
	dc.w	$0186,$1e4		; Color3 - SCHRIFT erstes+zweites Bitplane (GRÜN)


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

BITPLANE:
	ds.b	40*256			; eine Bitplane LOWRES 320x256
BITPLANE2:
	ds.b	40*256			; eine Bitplane LOWRES 320x256


	end


Unter Verwendung von vordefinierten oder "vorberechneten" Werten kann  man
viel  bessere  Bewegungen oder Farbverläufe herstellen, als mit bloßen ADD
und SUB.
Die einzige "Neuigkeit" in diesem Listing besteht in der Auscodierung  der
Routine  "BLINKEN",  die  die  Werte  aus einer Tabelle liest, die dann in
"FARBE1" kommen. Dabei wird ein POINTER  auf  das  zuletzt  gelesene  Word
verwendet, also  ein LONGWORD, das die Adresse dieses Wordes innerhalb der
Tabelle speichert. Zu Bemerken ist, daß ein:

COLTABPOINT:
	dc.l	COLORTAB

gleich einem

COLTABPOINT:
	DC.L	0

ist, nachdem ein MOVE.L #COLORTAB,COLTABPOINT ausgeführt  wurde,  es  wird
also  ein  Longword  assembliert,  das  die Adresse eines bestimmten Label
enthält. In dieser Routine ist ein

	dc.l	COLORTAB-2

vorzufinden, es ist aber nur dazu da, um beim ersten Mal das erste Word zu
lesen, da die Routine ja mit

BLINKEN:
	ADDQ.L	#2,COLTABPOINT	; Pointet auf das nächste Word

beginnt.  COLTABPOINT  muß  den  Anfang  des  ersten	Word-2	enthalten,
jedenfalls  nach  dem ersten ADDQ.L #2 wird beim ersten jsr das erste Word
kopiert und nicht das zweite.
Danach wird das Longword COLTABPOINT jedesmal um 2  erhöht,  die  Adresse,
die  es enthält, wird also jedesmal die nächste sein, bis nicht das letzte
Word erreicht wird, das zwei Bytes vor dem ENDE der Tabelle steht:

; wir sind auf dieser Adresse, wenn wir das letzte Word lesen...

	dc.w	$000			; wieder DUNKEL
ENDECOLORTAB:

Hier wird dann mit einem

	MOVE.L	#COLORTAB-2,COLTABPOINT ; Starte wieder beim ersten Word


das Label COLTABPOINT wieder mit der Adresse des ersten Word geladen.

Ihr könnt diese Routine für viele verschiedene Zwecke verwenden,  z.B.  um
Sprites zum springen oder wellen zu bringen. Einfach die Tabelle ersetzen.

Probiert, die Tabelle mit dieser zu ersetzen:

COLORTAB:
	dc.w	$26F,$27E,$28D,$29C,$2AB,$2BA,$2C9,$2D8,$2E7,$2F6
	dc.w	$4E7,$6D8,$8C9,$ABA,$CAA,$D9A,$E8A,$F7A,$F6B,$F5C
	dc.w	$D6D,$B6E,$96F,$76F,$56F,$36F
ENDECOLORTAB:

COLORTAB:
	dc.w	$000,$000,$001,$011,$011,$011,$012,$012 ; Beginn DUNKEL
	dc.w	$022,$022,$022,$023,$023
	dc.w	$033,$033,$034
	dc.w	$044,$044
	dc.w	$045,$055,$055
	dc.w	$056,$056,$066,$066,$066
	dc.w	$167,$167,$177,$177,$177,$177,$177
	dc.w	$278,$278,$278,$288,$288,$288,$288,$288
	dc.w	$389,$389,$399,$399,$399,$399
	dc.w	$39a,$39a,$3aa,$3aa,$3aa
	dc.w	$3ab,$3bb,$3bb,$3bb
	dc.w	$4bc,$4cc,$4cc,$4cc
	dc.w	$4cd,$4cd,$4dd,$4dd,$4dd
	dc.w	$5de,$5de,$5ee,$5ee,$5ee,$5ee
	dc.w	$6ef,$6ff,$6ff,$7ff,$7ff,$8ff,$8ff,$9ff ; Maximum HELL
	dc.w	$5ee,$5ee,$5ee,$5de,$5de,$5de
	dc.w	$4dd,$4dd,$4dd,$4cd,$4cd
	dc.w	$4cc,$4cc,$4cc,$4bc
	dc.w	$3cb,$3bb,$3bb
	dc.w	$3ba,$3aa,$3aa
	dc.w	$3a9,$399,$399
	dc.w	$298,$288
	dc.w	$187,$177
	dc.w	$076,$066
	dc.w	$065,$055
	dc.w	$054,$044
	dc.w	$034
	dc.w	$022
	dc.w	$011
	dc.w	$000			; wieder DUNKEL
ENDECOLORTAB: