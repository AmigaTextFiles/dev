
; Lezione11m2.s - Verwenden von Level 2 Interrupt ($68) zum Lesen von
;		  gedrückten Tastencodes auf der Tastatur.
;		  In diesem Fall dekodieren wir auch den Leseknopf
;         Umwandlung in das entsprechende ASCII-Zeichen.

	Section	InterruptKey,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern interrupt, dma etc.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper,bitplane und DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger bitplanes in copperlist

	MOVE.L	#BITPLANE,d0	; in d0 setzen wir die Adresse der bitplane
	LEA	BPLPOINTERS,A1		; Zeiger COPPERLIST
	move.w	d0,6(a1)		; Kopiere das niedrige word der Bitplaneadresse
	swap	d0				; tauscht die 2 Wörter von d0 (z.B.: 1234 > 3412)
	move.w	d0,2(a1)		; Kopiere das hohe word der Bitplaneadresse

	move.l	BaseVBR(PC),a0			; In a0 der Wert des VBR

	MOVE.L	#MioInt68KeyB,$68(A0)	; Routine Tastatur Int. Level 2
	move.l	#MioInt6c,$6c(a0)		; unsere Routine Int. Level 3

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; initialisieren Sie die Musik Routine
	movem.l	(SP)+,d0-d7/a0-a6

			; 5432109876543210
	move.w	#%1100000000101000,$9a(a5)  ; INTENA - aktivieren nur VERTB
										; per Level 3 und Level 2
Mouse:
	btst	#6,$bfe001
	bne.s	mouse

	bsr.w	mt_end				; Ende der Wiederholung!
	rts							; exit

	even

*****************************************************************************
*	INTERRUPT-ROUTINE $68 (Level 2) - Tastaturverwaltung
*****************************************************************************

;03	PORTS	2 ($68)	Input/Output Port und Timer, verbunden mit Leitung INT2

MioInt68KeyB:		; $68
	movem.l d0/a0,-(sp)	; Register speichern auf dem stack
	lea	$dff000,a0		; custom register offset

	MOVE.B	$BFED01,D0	; Ciaa icr - in d0 (Lesen der ICR, die wir verursachen
						; auch sein Reset, so ist das int
						; "gelöscht" wie in intreq).
	BTST.l	#7,D0	; bit IR, (interrupt cia autorisiert), ist zurückgesetzt?
	BEQ.s	NonKey	; wenn ja, exit
	BTST.l	#3,D0	; bit SP, (interrupt der Tastatur), ist zurückgesetzt?
	BEQ.s	NonKey	; wenn ja, exit

	MOVE.W	$1C(A0),D0	; INTENAR in d0
	BTST.l	#14,D0		; Bit Master Aktivierung ist zurückgesetzt?
	BEQ.s	NonKey		; wenn ja, interrupt ist nicht aktiviert!
	AND.W	$1E(A0),D0	; INREQR - in d1 bleiben nur die bits gesetzt
						; welche sowohl in INTENA als auch in INTREQ gesetzt sind
						; Also sei sicher, dass der Interrupt der
						; aufgetreten ist, aktiviert war.
	btst.l	#3,d0		; INTREQR - PORTS?
	beq.w	NonKey		; wenn nein, dann geh raus!

; Wenn wir nach den Kontrollen hier sind, heißt das, dass wir den Charakter nehmen müssen!

	moveq	#0,d0
	move.b	$bfec01,d0	; CIAA sdr (serial data register - verbunden
						; zur Tastatur - enthält das von Tastaturchip gesendete Byte)
						; LESEN SIE DAS CHAR!

	bsr.s	convertichar	; Konvertieren Sie das Zeichen in ASCII

; Jetzt müssen wir der Tastatur mitteilen, dass wir die Daten aufgenommen haben!

	bset.b	#6,$bfee01	; CIAA cra - sp ($bfec01) output, 
						; Senken Sie die KDAT-Zeile, um dies zu bestätigen
						; Wir haben den Charakter erhalten.

	st.b	$bfec01		; $FF in $bfec01 - ue'! ho ricevuto il dato!

; Hier müssen wir eine Routine aufstellen, die 90 Mikrosekunden darauf wartet
; Die KDAT-Leitung muss genügend Zeit haben, um von allen Arten von Tastaturen
; "verstanden" zu werden. Sie können beispielsweise auf 3 oder 4 Rasterzeilen warten.

	moveq	#4-1,d0	; Anzahl der zu wartenden Zeilen = 4 (im Grunde 3 weitere)
					; die Fraktion, in der wir uns am Anfang befinden)
waitlines:
	move.b	6(a0),d1	; $dff006 - aktuelle vertikale Zeile in d1
stepline:
	cmp.b	6(a0),d1	; sind wir immer noch auf der gleichen Zeile?
	beq.s	stepline	; wenn ja warte
	dbra	d0,waitlines	; Zeile "warten", warte d0-1 Zeilen

; Nachdem wir gewartet haben, können wir $bfec01 wieder in den Eingabemodus versetzen...

	bclr.b	#6,$bfee01	; CIAA cra - sp (bfec01) erneut eingeben.

NonKey:		; 3210
	move.w	#%1000,$9c(a0)	; INTREQ Anfrage entfernen, int ausgeführt!
	movem.l (sp)+,d0/a0		; Register vom stack nehmen
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE  $6c (Level 3) -  VERTB und COPER benutzt.	    *
*****************************************************************************

;06	BLIT	3 ($6c)	Wenn der Blitter eine Blittata beendet hat, wird sie auf 1 gesetzt
;05	VERTB	3 ($6c)	Wird jedes Mal generiert, wenn der Elektronenstrahl die
			; Zeile 00 erreicht, d. h. bei jedem Beginn des vertikalen Austastens.
;04	COPER	3 ($6c)	Sie können es mit dem copper einstellen, um es bei einer bestimmten 
			; Videozeile zu erzeugen.
			; Fordern Sie es einfach nach einer gewissen Wartezeit an.

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - Bit 5, VERTB, ist zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.s	PrintaChar			; Zeichen drucken
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:
NointCOPER:
NoBLIT:		 ;6543210
	move.w	#%1110000,$dff09c	; INTREQ - Anfoderung löschen BLIT,VERTB und COPER
	rte							; Ende vom Interrupt COPER/BLIT/VERTB


*****************************************************************************
; SubRoutine, die das Zeichen nach ASCII konvertiert
*****************************************************************************

ConvertiChar:
	movem.l	d1-d2/a0,-(SP)

; data received bit : 6 5 4 3 2 1 0 7
; Bit 7 ist 1, wenn die Taste losgelassen wird

	not.b	d0				
	lsr.b	#1,d0			; und nach links gedreht
	bcs.b	Tasto_up

	cmp.b	#$60,d0			; left shift
	blo.b	To_Ascii
	bset	d0,Control_Key
	bra.b	exit

Tasto_up:
	cmp.b	#$60,d0			; left shift
	blo.b	exit
	bclr	d0,Control_Key
	bra.b	exit

;			bit	7 6     5 4     3    2     1 0
;              Amiga    Alt   Ctrl  caps  shift
;               r l     r l         lock   r l

to_ascii:
	move.b	Control_Key(PC),d1
	beq.b	Get_Char
	move.b	d1,d2
	and.b	#%00000111,d1
	beq.b	tst_alt
	add.w	#$68,d0
	bra.b	Get_Char
tst_alt:
	and.b	#%00110000,d2
;	beq	....
	add.w	#$68*2,d0
Get_Char:
	lea	Raw_2_Ascii(pc),a0
	move.b	(a0,d0.w),d0
	move.b	d0,ascii_char
	clr.b	received	; Die Daten sind fertig!
exit:
	movem.l	(SP)+,d1-d2/a0
	rts

*****************************************************************************

PrintaChar:
	tst.b	received	; Daten erhalten?
	bne.s	NonPremuto
	st.b	received
	moveq	#0,d0
	move.b	ascii_char(pc),d0
	cmp.b	#-1,d0
	beq.b	NonValido  ; es war ein Sonderzeichen wie z.B. Hilfe-Tab etc.
	bsr.s	PrintaD0   ; Andernfalls wird das Zeichen auf dem Bildschirm gedruckt
NonValido:
NonPremuto:
	rts

Control_Key:	dc.b	0
ascii_char:	dc.b	0
received: 	dc.b	-1
contariga:	dc.b	0

	even

*****************************************************************************
; Druck Routine Charakter in d0
*****************************************************************************

PRINTAd0:
	movem.l	a2-a3,-(SP)

	SUB.B	#$20,D0		; ZÄHLE 32 VOM ASCII-WERT DES BUCHSTABEN WEG
						; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
						; (Das $20 entspricht), IN $00, DAS
						; AUSRUFUNGSZEICHEN ($21) IN $01...
	LSL.W	#3,D0		; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 8,
						; da die Charakter ja 8 Pixel hoch sind
	MOVE.L	D0,A2
	ADD.L	#FONT,A2	; FINDE DEN GEWÜNSCHTEN BUCHSTABEN IM FONT...

	cmp.b	#80,ContaRiga		; 80 gedruckte Zeichen?
	bne.s	NonFine
	add.l	#80*7,PuntaBitplane	
	clr.b	ContaRiga
NonFine:
	MOVE.L	PuntaBITPLANE(PC),A3 ; Adresse Ziel-Bitplane in a3

				; DRUCKE DEN BUCHSTABEN ZEILE FÜR ZEILE
	MOVE.B	(A2)+,(A3)	; Drucke Zeile 1 des Zeichens
	MOVE.B	(A2)+,80(A3)	; Drucke Zeile  2  " "
	MOVE.B	(A2)+,80*2(A3)	; Drucke Zeile  3  " "
	MOVE.B	(A2)+,80*3(A3)	; Drucke Zeile  4  " "
	MOVE.B	(A2)+,80*4(A3)	; Drucke Zeile  5  " "
	MOVE.B	(A2)+,80*5(A3)	; Drucke Zeile  6  " "
	MOVE.B	(A2)+,80*6(A3)	; Drucke Zeile  7  " "
	MOVE.B	(A2)+,80*7(A3)	; Drucke Zeile  8  " "

	ADDQ.L	#1,PuntaBitplane ; wir rücken 8 Bits vor (NÄCHSTES ZEICHEN)
	ADDQ.B	#1,ContaRiga

	movem.l	(SP)+,a2-a3
	RTS

PuntaBitplane:
	dc.l	BITPLANE


; ASCII-Konvertierungstabelle. Leicht bearbeitbar für die Tastatur
; Italienisch oder andere.

raw_2_ascii:
	dc.b	'`'
	dc.b	'1'
	dc.b	'2'
	dc.b	'3'
	dc.b	'4'
	dc.b	'5'
	dc.b	'6'
	dc.b	'7'
	dc.b	'8'
	dc.b	'9'
	dc.b	'0'
	dc.b	'-'
	dc.b	'='
	dc.b	'\'
	dc.b	-1	;<<<<<<<<<<<<<<
	dc.b	'0'	;Tastenfeld numerisch
	dc.b	'q'
	dc.b	'w'
	dc.b	'e'
	dc.b	'r'
	dc.b	't'
	dc.b	'y'
	dc.b	'u'
	dc.b	'i'
	dc.b	'o'
	dc.b	'p'
	dc.b	'['
	dc.b	']'
	dc.b	-1	;<<<<<<<<<<<<<<<<<
	dc.b	'1'
	dc.b	'2'
	dc.b	'3'
	dc.b	'a'
	dc.b	's'
	dc.b	'd'
	dc.b	'f'
	dc.b	'g'
	dc.b	'h'
	dc.b	'j'
	dc.b	'k'
	dc.b	'l'
	dc.b	';'
	dc.b    39
	dc.b	-1	;not used
	dc.b	-1	;<<<<<<<<<<<<<<<<<<<<
	dc.b	'4'
	dc.b	'5'
	dc.b	'6'
	dc.b	'<'
	dc.b	'z'
	dc.b	'x'
	dc.b	'c'
	dc.b	'v'
	dc.b	'b'
	dc.b	'n'
	dc.b	'm'
	dc.b	','
	dc.b	'.'
	dc.b	'/'
	dc.b	-1	;<<<<<<<<<<<<<<<<<<
	dc.b	'.'
	dc.b	'7'
	dc.b	'8'
	dc.b	'9'
	dc.b	' '	;space
	dc.b	-1	;back space
	dc.b	-1	;tab
	dc.b	-1	;return	Tastenfeld
	dc.b	-1	;return
	dc.b	-1	;esc
	dc.b	-1	;del
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;<<<<<<<<<
	dc.b	'-'
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;up
	dc.b	-1	;down
	dc.b	-1	;dx
	dc.b	-1	;sx
	dc.b	-1	;f1
	dc.b	-1	;f2
	dc.b	-1	;f3
	dc.b	-1	;f4
	dc.b	-1	;f5
	dc.b	-1	;f6
	dc.b	-1	;f7
	dc.b	-1	;f8
	dc.b	-1	;f9
	dc.b	-1	;f10
	dc.b	'('
	dc.b	')'
	dc.b	'/'
	dc.b	'*'
	dc.b	'+'
	dc.b	-1	;help
	dc.b	-1	;lshift
	dc.b	-1	;rshift
	dc.b	-1	;caps lock
	dc.b	-1	;ctrl
	dc.b	-1	;lalt
	dc.b	-1	;ralt
	dc.b	-1	;lamiga
	dc.b	-1	;ramiga

	dc.b	'~'	;shift-tati
	dc.b	'!'
	dc.b	'@'
	dc.b	'#'
	dc.b	'$'
	dc.b	'%'
	dc.b	'^'
	dc.b	'&'
	dc.b	'*'
	dc.b	'('
	dc.b	')'
	dc.b	'_'
	dc.b	'+'
	dc.b	'|'
	dc.b	-1	;<<<<<<<<<<<<<<
	dc.b	'0'	;Tastenfeld numerisch
	dc.b	'Q'
	dc.b	'W'
	dc.b	'E'
	dc.b	'R'
	dc.b	'T'
	dc.b	'Y'
	dc.b	'U'
	dc.b	'I'
	dc.b	'O'
	dc.b	'P'
	dc.b	'{'
	dc.b	'}'
	dc.b	-1	;<<<<<<<<<<<<<<<<<
	dc.b	'1'	;Tastenfeld
	dc.b	'2'	;Tastenfeld
	dc.b	'3'	;Tastenfeld
	dc.b	'A'
	dc.b	'S'
	dc.b	'D'
	dc.b	'F'
	dc.b	'G'
	dc.b	'H'
	dc.b	'J'
	dc.b	'K'
	dc.b	'L'
	dc.b	':'
	dc.b    '"'
	dc.b	-1	;not used
	dc.b	-1	;<<<<<<<<<<<<<<<<<<<<
	dc.b	'4'	;Tastenfeld
	dc.b	'5'	;Tastenfeld
	dc.b	'6'	;Tastenfeld
	dc.b	'>'
	dc.b	'Z'
	dc.b	'X'
	dc.b	'C'
	dc.b	'V'
	dc.b	'B'
	dc.b	'N'
	dc.b	'M'
	dc.b	'<'
	dc.b	'>'
	dc.b	'?'
	dc.b	-1	;<<<<<<<<<<<<<<<<<<
	dc.b	'.'	;Tastenfeld
	dc.b	'7'	;Tastenfeld
	dc.b	'8'	;Tastenfeld
	dc.b	'9'	;Tastenfeld
	dc.b	' '	;space
	dc.b	-1	;back space
	dc.b	-1	;tab
	dc.b	-1	;return Tastenfeld
	dc.b	-1	;return
	dc.b	-1	;esc
	dc.b	-1	;del
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;<<<<<<<<<
	dc.b	'-'
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;up
	dc.b	-1	;down
	dc.b	-1	;dx
	dc.b	-1	;sx
	dc.b	-1	;f1
	dc.b	-1	;f2
	dc.b	-1	;f3
	dc.b	-1	;f4
	dc.b	-1	;f5
	dc.b	-1	;f6
	dc.b	-1	;f7
	dc.b	-1	;f8
	dc.b	-1	;f9
	dc.b	-1	;f10
	dc.b	'('
	dc.b	')'
	dc.b	'/'
	dc.b	'*'
	dc.b	'+'
	dc.b	-1	;help
	dc.b	-1	;lshift
	dc.b	-1	;rshift
	dc.b	-1	;caps lock
	dc.b	-1	;ctrl
	dc.b	-1	;lalt
	dc.b	-1	;ralt
	dc.b	-1	;lamiga
	dc.b	-1	;ramiga

	dc.b	'`'	;alt-tati
	dc.b	'¹'
	dc.b	'²'
	dc.b	'³'
	dc.b	'¢'
	dc.b	'¼'
	dc.b	'½'
	dc.b	'¾'
	dc.b	'·'
	dc.b	'«'
	dc.b	'»'
	dc.b	'-'
	dc.b	'='
	dc.b	'\'
	dc.b	-1	;<<<<<<<<<<<<<<
	dc.b	'0'	;Tastenfeld numerico
	dc.b	'å'
	dc.b	'°'
	dc.b	'©'
	dc.b	'®'
	dc.b	'þ'
	dc.b	'¤'
	dc.b	'µ'
	dc.b	'¡'
	dc.b	'ø'
	dc.b	'¶'
	dc.b	'['
	dc.b	']'
	dc.b	-1	;<<<<<<<<<<<<<<<<<
	dc.b	'1'	;Tastenfeld
	dc.b	'2'	;Tastenfeld
	dc.b	'3'	;Tastenfeld
	dc.b	'æ'
	dc.b	'ß'
	dc.b	'ð'
	dc.b	''
	dc.b	''
	dc.b	''
	dc.b	''
	dc.b	''
	dc.b	'£'
	dc.b	';'
	dc.b    39
	dc.b	'ù'	;not used
	dc.b	-1	;<<<<<<<<<<<<<<<<<<<<
	dc.b	'4'	;Tastenfeld
	dc.b	'5'	;Tastenfeld
	dc.b	'6'	;Tastenfeld
	dc.b	'<'
	dc.b	'±'
	dc.b	'×'
	dc.b	'ç'
	dc.b	'ª'
	dc.b	'º'
	dc.b	'­'
	dc.b	'¸'
	dc.b	','
	dc.b	'.'
	dc.b	'/'
	dc.b	-1	;<<<<<<<<<<<<<<<<<<
	dc.b	'.'	;Tastenfeld
	dc.b	'7'	;Tastenfeld
	dc.b	'8'	;Tastenfeld
	dc.b	'9'	;Tastenfeld
	dc.b	' '	;space
	dc.b	-1	;back space
	dc.b	-1	;tab
	dc.b	-1	;return	Tastenfeld
	dc.b	-1	;return
	dc.b	'›'	;esc
	dc.b	-1	;del
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;<<<<<<<<<
	dc.b	'-'
	dc.b	-1	;<<<<<<<<<
	dc.b	-1	;up
	dc.b	-1	;down
	dc.b	-1	;dx
	dc.b	-1	;sx
	dc.b	-1	;f1
	dc.b	-1	;f2
	dc.b	-1	;f3
	dc.b	-1	;f4
	dc.b	-1	;f5
	dc.b	-1	;f6
	dc.b	-1	;f7
	dc.b	-1	;f8
	dc.b	-1	;f9
	dc.b	-1	;f10
	dc.b	'['
	dc.b	']'
	dc.b	'/'
	dc.b	'*'
	dc.b	'+'
	dc.b	-1	;help
	dc.b	-1	;lshift
	dc.b	-1	;rshift
	dc.b	-1	;caps lock
	dc.b	-1	;ctrl
	dc.b	-1	;lalt
	dc.b	-1	;ralt
	dc.b	-1	;lamiga
	dc.b	-1	;ramiga

	even

;	Die Schriftzeichen 8x8.

FONT:
	incbin	"assembler2:sorgenti4/nice.fnt"

*****************************************************************************
;	Routine wiederholen protracker/soundtracker/noisetracker
;
	include	"assembler2:sorgenti4/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8e,$2c81	; DiwStrt	(Register mit normalen Werten)
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$003c	; DdfStart HIRES
	dc.w	$94,$00d4	; DdfStop HIRES
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod \ INTERLACE: modulo = Länge Zeile!
	dc.w	$10a,0		; Bpl2Mod / um sie zu überspringen (gerade oder disp.)

				; 5432109876543210
	dc.w	$100,%1001001000000000	; 1 bitplane, HIRES 640x256

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$180,$226	; color0 - Hintergrund
	dc.w	$182,$0c0	; color1 - plane 1 Position normal,
						; der Teil, der oben "hervorsteht".

	dc.w	$FFFF,$FFFE	; Ende copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"assembler2:sorgenti4/mod.fairlight"

;********************************************************************
;	bitplane
;********************************************************************
	section	bitplane,bss_C

BITPLANE:
	ds.b	80*320

	end

Sie könnten sich ein Dienstprogramm, oder ein Programm erstellen, für das 
eine Eingabe des Namens oder anderer Daten erforderlich ist, oder 
Ihnen antwortet, als wäre es eine Person... wenn du willst!

