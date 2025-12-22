
; Listing6g.s	SCHREIBEN "ÜBER" EINEM BILD (IN TRANSPARENZ)
;				Linke Maustaste um vorzugehen, rechte um
;				zurückzugehen, beide, um auszusteigen - man kann
;				auch den ganzen Speicher durchsuchen wie in Listing5l.s

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

	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von unserer PIC
							; bzw. wo ihre erste Bitplane beginnt

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
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse			; Wenn nicht, geh nicht weiter

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte			; Wenn nicht, geh nicht weiter

	btst	#2,$dff016		; wenn die rechte Maustaste gedrückt ist,
	bne.s	NichtRunter		; gehe zu NichtRunter

	bsr.w	GehRunter		; ansonsten auf GehRunter

NichtRunter:
	btst	#6,$bfe001		; linke Taste gedrückt?
	beq.s	ScrollRauf		; wenn ja, scrolle rauf
	bra.s	mouse			; nein? Dann wiederhole den Zyklus noch ein
							; FRAME lang

ScrollRauf:
	bsr.w	GehRauf			; läßt das Bild nach oben scrollen

	btst	#2,$dff016		; Right mouse button pressed?
	bne.s	mouse

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
	MOVEQ	#26-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 25
PRINTZEILE:
	MOVEQ	#40-1,D0		; ANZAHL DER SPALTEN EINER ZEILE: 40 (LOWRES!)

PRINTCHAR2:			
	MOVEQ	#0,D2			; Löscht D2
	MOVE.B	(A0)+,D2		; Nächster Charakter in d2
	SUB.B	#$20,D2			; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG,
							; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
							; (Das $20 entspricht), IN $00, DAS
							; AUSRUNFUNGSZEICHEN ($21) IN $01...
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
                ; Anzahl Charakter pro Zeile: 80, also 2 von diesen zu 40!


             ;            1111111111222222222233333333334
             ;   1234567890123456789012345678901234567890

	dc.b	'                                        ' ; 1
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
	dc.b	' -=-    ICH DENKE, ALSO BIN ICH...  -=- ' ; 13
	dc.b	' ## sagte mal jemand, aber er gefiel ## ' ; 14
	dc.b	' ///dem Cartoonzeichner nicht und   \\\ ' ; 15
	dc.b	'       so wurde er ausradiert...        ' ; 16
	dc.b	'                                        ' ; 17
	dc.b	'  Das Fraeulein stand am Meere          ' ; 18
	dc.b	'                                        ' ; 19
	dc.b	'    und seufzte lang und bang,          ' ; 20
	dc.b	'                                        ' ; 21
	dc.b	'    ES RUEHRTE SIE SO SEHRE,            ' ; 22
	dc.b	'                                        ' ; 23
	dc.b	'  der Sonnenuntergang.                  ' ; 24
	dc.b	'                                        ' ; 25
	dc.b	'             ...                        ' ; 26

	EVEN


;	Diese Routine bewegt das Bild nach oben und unten, indem es auf die
;	Bitplane-Pointers in der Copperlist (mittels dem Label BPLPOINTERS2)
;	zugreift. Aus Listing5l.s.

GehRunter:
	LEA	BPLPOINTERS2,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0
	
	sub.l	#40,d0			; subtrahieren 80*3, also 3 Zeilen, somit
							; scrollt das Bild nach unten
	bra.s	ENDE


GehRauf:
	LEA	BPLPOINTERS2,A1		; Mit diesen 4 Anweisungen holen wir aus der
	move.w	2(a1),d0		; Copperlist die Adresse, wohin das $dff0e0
	swap	d0				; gerade pointet und geben diesen Wert
	move.w	6(a1),d0		; in d0
		
	add.l	#40,d0			; addieren 80*3, also 3 Zeilen, somit
							; scrollt das Bild nach oben

ENDE:						; WIR POINTEN AUF UNSERE BITPLANES
	move.w	d0,6(a1)		; kopiert das niederw. Word der Adresse des Plane
	swap	d0				; vertauscht die 2 Word in d0 (Z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; kopiert ds hochw. Word der Adresse des Plane
	rts


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
	dc.w	$100,%0100001000000000  ; Bit 14 - 4 Bitplanes, 16 Farben HIRES

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane
BPLPOINTERS2: 
	dc.w	$ec,$0000,$ee,$0000	; vierte Bitplane

	dc.w	$180,$000		; Color0 ; Farben des Bildes, ein bißchen
	dc.w	$182,$354		; Color1 ; gedämpft
	dc.w	$184,$678		; Color2
	dc.w	$186,$567		; Color3
	dc.w	$188,$455		; Color4
	dc.w	$18a,$121		; Color5
	dc.w	$18c,$455		; Color6
	dc.w	$18e,$233		; Color7

	dc.w	$190,$454		; color8	; Colors of text:
	dc.w	$192,$7a8		; color9	;
	dc.w	$194,$eef		; color10	; 8 colors for 8 types of
	dc.w	$196,$cde		; color11	; transparency.
	dc.w	$198,$aab		; color12
	dc.w	$19a,$786		; color13
	dc.w	$19c,$9aa		; color14
	dc.w	$19e,$789		; color15

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
;	incbin	"/Sources/metal.fnt"	; Breiter Zeichensatz
;	incbin	"/Sources/normal.fnt"	; Ähnlich dem aus dem Kickstart 1.3
	incbin	"/Sources/nice.fnt"	; Schmaler Zeichensatz

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"	; hier laden wir das Bild in RAW

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	40*256			; eine Bitplane LOWRES 320x256

	end

Ihr könnt auch den ganzen Speicher über dem Bild laufen lassen!	Wenn  ihr
mit  dem  rechten Mausknopf nach hinten geht, werdet ihr auch auf die drei
Bitplanes des Bildes stoßen, dann die Charakter des Font (nicht recht  gut
sichtbar wegen des nicht übereinstimmenden Modulo).

