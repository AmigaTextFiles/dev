
; Listing6p.s	DRUCKEN EINEN BUCHSTABEN PRO FRAME AUF DEN BILDSCHIRM

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

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1		; COP - Pointer
	move.w	d0,6(a1)
	swap	d0		
	move.w	d0,2(a1)	

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

mouse:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	bne.s	mouse

	bsr.w	PRINTCharakter	; Drucken einen Buchstaben pro Frame

Warte:
	cmpi.b	#$ff,$dff006	; Sind wir auf Zeile 255?
	beq.s	Warte		

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

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


; Diese Routine ist eine Art Mischling zwischen der normalen PRINT-Routine
; und der Tabellenroutine, denn wir verwenden einen Text auf dieselbe Art
; wie es bei der Tabelle der Fall war, einen Wert nach dem anderen, einen
; pro Fotogramm, und der kommt dann auf den Screen. Des Weiteren müssen wir
; auch die Adresse im Bitplane der letzten vom Print erreichten Position 
; abspeichern, um den nächsten genau nach ihn setzen zu können. Um zwischen
; einem Frame und dem anderen die Adresse im Text und im Bitplane zu merken,
; verwenden wir zwei Longword als Pointer:
;
; PointeText:
;	dc.l	TEXT
;
; PointeBitplane:
;	dc.l	BITPLANE
;
; Jedesmal, wenn die Routine ausgeführt wird, wird ein Buchstabe
; gedruckt, und es wird der Pointer auf TEXT "upgedatet" (mit einem
; ADDQ.L #1, das ihn auf den nächsten Buchstaben bringt, da einer
; genau 1 Byte lang ist) und auch der Pointer auf das Bitplane, denn
; jeder Buchstaben hat seinen Platz im Bitplane.
; Das erste Problem besteht darin, daß alle 40 Zeichen eine neue (Text-)
; Zeile genommen werden muß, also 40*7 Bytes zum Bitplanepointer dazugezählt
; werden muß. Um dieses Problem zu lösen wurde einfach eine NULL am Ende
; einer jeden Textzeile angehängt, die uns mitteilt, daß wir am Ende sind
; und wir 40*7 zum Bitplanepointer und 1 zum Textpointer dazuzählen müssen.
; Das zweite Problem war, daß wir aufhören müssen Buchstaben zu drucken,
; wenn wir am Ende des Textes angekommen sind. Per Konvention schließen wir
; somit die Zeile statt mit $00 mit $FF ab, somit können wir die Routine
; verlassen, wenn wir dieses "Zeichen" erreichen. Einfach das gelesene Byte
; kontrollieren, und wenn es $FF ergibt, nichts mehr drucken, keine Pointer
; verstellen, nix mehr. Wenn wir nun beim nächsten Durchgang wieder auf $FF
; treffen (weil wir den Pointer nicht vorgestellt haben), wird wieder nichts 
; getan, usw.
; Ihr könnt euch mehrere solcher "Spezialzeichen" erfinden, Hauptsache,
; sie liegen nicht im Bereich zwischen $20 und $80, also den Buchstaben
; gewidmeten Bytes.


PRINTCharakter:
	MOVE.L	PointeText(PC),A0 ; Adresse des zu druckenden Textes in a0
	MOVEQ	#0,D2			; Lösche d2
	MOVE.B	(A0)+,D2		; Nächster Buchstaben in d2
	CMP.B	#$ff,d2			; Ende-Text Signal? ($FF)
	beq.s	EndeTEXT		; Wenn ja, raus, ohne was zu drucken
	TST.B	d2				; Ende-Zeile Signal? ($00)
	bne.s	NichtEndeZeile	; Wenn nicht, nimm keine neue (Text-)Zeile

	ADD.L	#40*7,PointeBitplane	; NEUE TEXTZEILE
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
	MOVE.B	(A2)+,40(A3)	; Drucke Zeile 2  "	"
	MOVE.B	(A2)+,40*2(A3)	; Drucke Zeile 3  "	"
	MOVE.B	(A2)+,40*3(A3)	; Drucke Zeile 4  "	"
	MOVE.B	(A2)+,40*4(A3)	; Drucke Zeile 5  "	"
	MOVE.B	(A2)+,40*5(A3)	; Drucke Zeile 6  "	"
	MOVE.B	(A2)+,40*6(A3)	; Drucke Zeile 7  "	"
	MOVE.B	(A2)+,40*7(A3)	; Drucke Zeile 8  "	"

	ADDQ.L	#1,PointeBitplane ; 8 Bit weiter vor (NÄCHSTER BUCHSTABE)
	ADDQ.L	#1,PointeText	; nächster zu druckende Buchstabe

EndeTEXT:
	RTS


PointeText:
	dc.l	TEXT

PointeBitplane:
	dc.l	BITPLANE

;	$00 für "Ende Zeile" - $FF für "Ende TEXT"

		; Anzahl Charakter pro Zeile: 40
TEXT:           ;         1111111111222222222233333333334
	dc.b	'   ERSTE ZEILE                          ',0 ; 1
	dc.b	'                ZWEITE ZEILE            ',0 ; 2
	dc.b	'     /\  /                              ',0 ; 3
	dc.b	'    /  \/                               ',0 ; 4
	dc.b	'                                        ',0 ; 5
	dc.b	'        SECHSTE ZEILE                   ',0 ; 6
	dc.b	'                                        ',0 ; 7
	dc.b	'                                        ',0 ; 8
	dc.b	'FABIO CIUCCI COMMUNICATION INTERNATIONAL',0 ; 9
	dc.b	'                                        ',0 ; 10
	dc.b	'   1234567890 !@#$%^&*()_+|\=-[]{}      ',0 ; 11
	dc.b	'                                        ',0 ; 12
	dc.b	'     ICH DENKE, ALSO BIN ICH...         ',0 ; 15
	dc.b	'                                        ',0 ; 16
	dc.b	'                                        ',0 ; 17
	dc.b	'  Das Fraeulein stand am Meere,         ',0 ; 18
	dc.b	'    Und seufzte lang und bang,          ',0 ; 19
	dc.b	'    Es ruehrte sie so sehre,            ',0 ; 20
	dc.b	'  Der Sonnenuntergang.   (...)          ',0 ; 21
	dc.b	'                                        ',0 ; 22
	dc.b	' Schon draufgekommen...? Noch nicht...? ',0 ; 23
	dc.b	' Es war: . . . . . . . Heinrich Heine ! ',$FF ; 24 Ende


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
	dc.w	$100,%0001001000000000  ; Bit 12 an - 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane

	dc.w	$0180,$000		; Color0 - Hintergrund
	dc.w	$0182,$19a		; Color1 - Schrift

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
	ds.b	40*256			; eine Bitplane, 320x256 LowRes

	end


