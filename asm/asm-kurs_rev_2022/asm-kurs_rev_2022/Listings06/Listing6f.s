
; Listing6f.s		SCHREIBEN "ÜBER" EINEM BILD

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
							; bzw. wo ihr erste Bitplane beginnt

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
	LEA	BITPLANE,A3			; Adresse der Ziel-Bitplane in a3
	MOVEQ	#26-1,D3		; ANZAHL DER ZEILEN, DIE ZU DRUCKEN SIND -> 25
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
	dc.b	'            ...                         ' ; 26


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

	dc.w	$190,$454		; color8  ; Die Farben der Schrift:
	dc.w	$192,$7a8		; color9  ; in diesem Fall erzeugen wir
	dc.w	$194,$eef		; color10 ; 8 verschieden Farben für die
	dc.w	$196,$cde		; color11 ; 8 Überlagerungsmöglichkeiten, die
	dc.w	$198,$aab		; color12 ; sich ergeben können- bemerkt
	dc.w	$19a,$786		; color13 ; ihr, daß sie ähnlich zu den
	dc.w	$19c,$9aa		; color14 ; ersten 8 sind, nur leuchtender:
	dc.w	$19e,$789		; color15 ; es kommt der "TRASPARENZ"-Effekt
							; zustande

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Der FONT, Charakter 8x8

FONT:
;	incbin	"/Sources/metal.fnt"	; Breiter Zeichensatz
;	incbin	"/Sources/normal.fnt"	; Ähnlich dem aus dem Kickstart 1.3
	incbin	"/Sources/nice.fnt"		; Schmaler Zeichensatz

PIC:
	incbin	"/Sources/Amiga_320_256_3.raw"	; hier laden wir das Bild in RAW

	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	40*256			; ein Bitplane LOWRES 320x256

	end

In diesem Beispiel haben wir das Bitplane 4 dazugenommen, auf ihm wird der
Text geschrieben. Mit dieser vierten Bitplane gehen wir von 8 zu 16 Farben
über, um also die Schrift in jeder Position gleichfarbig zu behalten, müßen wir
alle 8 zusätzlichen Farben, die sich ergeben können, gleich sezten.
Sie alle erhalten die "Textfarbe".
Wenn die "neuen" 8 Farben aber ähnlich sind wie die ersten 8, nur heller,
dann kann man eine Art "Transparenz" erzeugen. Denn jedesmal wenn sich das
"Textplane" einem Pixel überlagert, wird eine Farbe aus dem "neuen"
Repertoir angezeigt, und wenn diese gleich mit der alten ist, nur etwas heller,
kommt es automatisch zu diesem Effekt.
Versucht mal, die Palette der letzten 8 Farben mit diesen zu ersetzen:

	dc.w	$190,$454		; color8  ; Die Farben der Schrift:
	dc.w	$192,$7a8		; color9  ; in diesem Fall erzeugen wir
	dc.w	$194,$eef		; color10 ; 8 verschieden Farben für die
	dc.w	$196,$cde		; color11 ; 8 Überlagerungsmöglichkeiten, die
	dc.w	$198,$aab		; color12 ; sich ergeben können- bemerkt
	dc.w	$19a,$786		; color13 ; ihr, daß sie ähnlich zu den
	dc.w	$19c,$9aa		; color14 ; ersten 8 sind, nur leuchtender:
	dc.w	$19e,$789		; color15 ; es kommt der "TRASPARENZ"-Effekt
							; zustande


	dc.w	$190,$d6e		; Color8  ; Die Farben der Schrift:
	dc.w	$192,$d6e		; Color9  ; beim Überlagern würden sich
	dc.w	$194,$d6e		; Color10 ; immer andere Farben ergeben, aber
	dc.w	$196,$d6e		; Color11 ; wir geben ihnen allen den gleichen
	dc.w	$198,$d6e		; Color12 ; Wert, so ist es immer die gleiche
	dc.w	$19a,$d6e		; Color13 ; Farbe
	dc.w	$19c,$d6e		; Color14
	dc.w	$19e,$d6e		; Color15