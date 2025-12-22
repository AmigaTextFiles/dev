
; Listing6h.s	DRUCKEN MEHRERE ZELEN AUF, IN * 3 * FARBEN,
;				DAZU VERWENDEN WIR DAS ZWEITE BITPLANE, AUF DEM
;				DER TEXT2 KOMMT

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

	MOVE.L  #BITPLANE2+(40*5),d0
	;MOVE.L	#BITPLANE2,d0	; in d0 kommt die Adresse des PIC
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
	MOVEQ	#32-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 26
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
	dc.b	'           ...                          ' ; 28
	dc.b	'                                        ' ; 29
	dc.b	'                                        ' ; 30
	dc.b	'                                        ' ; 31
	dc.b	'                       a                ' ; 32


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
	dc.b	'           ...                          ' ; 28
	dc.b	'                                        ' ; 29
	dc.b	'                                        ' ; 30
	dc.b	'                                        ' ; 31
	dc.b	'                       a                ' ; 32


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
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane
BPLPOINTERS2:
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane

	dc.w	$0180,$000		; Color0 - Hintergrund
	dc.w	$0182,$19a		; Color1 - SCHRIFT erste Bitplane (BLAU)
	dc.w	$0184,$f62		; Color2 - SCHRIFT zweite Bitplane (ORANGE)
	dc.w	$0186,$1e4		; Color3 - SCHRIFT erste+zweite Bitplane (GRÜN)

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


Um  den  Text  in  3  Farben  anzuzeigen  (4,  wenn  man  den  Hintergrund
mitrechnet), braucht man nur eine weitere Bitplane einschalten, und darauf
den  Text2 drucken. Wenn man nun einige Worte oder Buchstaben ausläßt, sei
es nun im einen oder im anderen Bitplane, dann ergeben  sich  verschiedene
Überlagerungsmuster,  die  jeweils  zu  verschiedenen  Farben  führen. Ihr
erinnert euch ja: Bitplane1 und Bitplane2 aus: Hintergrundfarbe; Bitplane1
aus,  Bitplane2  ein Color1, ... , Bitplane1 ein und Bitplane2 ein Color3.
Um beide Texte auszugeben, verwenden wir  die  gleiche  Routine,  nur  mit
einer kleinen Änderung: die ersten zwei Anweisungen, die den zu druckenden
Text und das ZielBitplane anpointen, werden  herausgenommen  und  vor  dem
Aufruf der PRINT: - Routine selbst hingeschrieben. Die Routine verarbeitet
nun jeden Text, der vorher in a0 geladen wurde (dessen  Adresse,  versteht
sich), und gibt ihn auf das Bitplane aus, auf das a3 pointet.

	LEA	TEXT(PC),A0			; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE,A3			; Adresse des Ziel-Bitplanes in a3
	bsr.w	print			; Bringt den Text auf den Bildschirm

	LEA	TEXT2(PC),A0		; Adresse des zu schreibenden Textes in a0
	LEA	BITPLANE2,A3		; Adresse des Ziel-Bitplanes in a3
	bsr.w	print			; Bringt den Text auf den Bildschirm

Somit kann die Routine auf jede  Bitplane und  mit  jedem  Text  verwendet
werden,  und  nicht nur ausschließlich mit der Bitplane "BITPLANE" und den
Text "TEXT"! Beim ersten bsr.w ist alles wie  bei  den  vorigen  Listings,
beim zweiten aber kommt BITPLANE2 und TEXT" zum Zuge. Je nach Überlagerung
der Bitplane kommt es zu einer der folgenden 3 Farben (die erste -  Farbe0
- ist wie immer der Hintergrund):

	dc.w	$0180,$000		; Color0 - Hintergrund
	dc.w	$0182,$19a		; Color1 - SCHRIFT erstes Bitplane (BLAU)
	dc.w	$0184,$f62		; Color2 - SCHRIFT zweites Bitplane (ORANGE)
	dc.w	$0186,$1e4		; Color3 - SCHRIFT erstes+zweites Bitplane (GRÜN)

Um das alles ein bißchen besser zu sehen, versucht, die zweite Bitplane um
5 Pixel nach oben zu verschieben:

	MOVE.L  #BITPLANE2+(40*5),d0


