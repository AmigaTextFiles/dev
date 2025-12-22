
; Listing8h2.s		8 * 8-Scrolltext-Routine, die nur bplcon1 zum 
					; Scrollen verwendet. Original von Lorenzo Di Gaetano.

	SECTION	SysInfo,CODE

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern vopperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA
;			 -----a-bcdefghij
START:

;	Zeiger auf bitplanes in copperlist

	MOVE.L	#schermo,d0			; in d0 setzen wir die Adresse der bitplane
	LEA	BPLPOINTERS,A1			; Zeiger in der COPPERLIST
	move.w	d0,6(a1)			; Kopiere das LOW-Wort der Bitplane-Adresse
	swap	d0					; Vertausche die 2 Wörter von d0 (zB: 1234> 3412)
	move.w	d0,2(a1)			; Kopiere das HIGH-Wort der Bitplane-Adresse

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	clr.w	ContaScroll			; den Scroll-Zähler zurücksetzen 
	bsr.w	Print				; Drucke das erste Mal

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2			; Warte auf Zeile = $12c
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $12c
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $12c
	Beq.S	Waity2

	bsr.s	Scroll				; Routine ist der Text auf der linken Seite
								; mit bplcon1 und alle 16 Pixel drucke es neu
								; 2 Zeichen (8 * 2 = 16 Pixel) voraus
								; bplcon1 zurücksetzen -> SCROLLING !!!

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
	rts

*****************************************************************************
; Routine, die entscheidet, ob mit bplcon1 gescrollt oder der gesamte Text 
; neu gedruckt werden soll
; 2 Zeichen (16 Pixel) weiter links (dies natürlich alle 16 Pixel)
*****************************************************************************

Scroll:
	tst.b	Scrolling			; Haben wir bplcon1 optimal genutzt?
	bne.s	AlloraAdda			; Wenn noch nicht, wird die Subtraktion fortgesetzt

; Andernfalls starten wir von $FF aus neu und drucken den Text 2 Zeichen weiter!

	addq.w	#2,ContaScroll		; 2 Zeichen voraus -> 16 Pixel voraus
	move.b	#$FF,Scrolling		; rücksetzen bplcon1
	bsr.s	Print				; und drucken den ScrollText 2 weitere Zeichen
	rts							; vorwärts, dh 2 * 8 = 16 Pixel.

AlloraAdda:
	sub.b	#$11,Scrolling		; 1 Pixel nach links mit bplcon1
	rts

*****************************************************************************
; Die Routine 8 * 8 wurde für den Bildlauf geändert
*****************************************************************************

Print:
	lea	Schermo+(42*192),a0		; Adresse, an der gedruckt werden soll
	lea	ScrollText(PC),a1		; Adresse Scrolltext (ascii)
	moveq	#42-1,d2			; Anzahl der zu druckenden Zeichen
	moveq	#0,d0
	move.w	ContaScroll(PC),d0	; Offset von Anfang an ScrollText
	add.l	d0,a1				; Finde den Charakter im Scrolltext
Printriga:
	sub.l	a2,a2				; lösche a2
	moveq	#0,d1
	move.b	(a1)+,d1
	cmp.b	#$ff,d1				; Flag Ende ScrollText?
	bne.s	NonRipartire		; Wenn noch nicht, fahren Sie fort
	clr.w	Contascroll			; Oder beginnen Sie erneut am Anfang des ScrollText
NonRipartire:
	sub.b	#$20,d1
	lsl.w	#3,d1				; multiplizieren mit 8
	move.l	d1,a2
	add.l	#Fonts,a2			; Finde das Charakter im Font
	move.b	(a2)+,(a0)
	move.b	(a2)+,42(a0)		; 42, um den ddfstart zu kompensieren und dann gehe
	move.b	(a2)+,42*2(a0)		; jenseits des Bildschirms
	move.b	(a2)+,42*3(a0)
	move.b	(a2)+,42*4(a0)
	move.b	(a2)+,42*5(a0)
	move.b	(a2)+,42*6(a0)
	move.b	(a2)+,42*7(a0)
	addq.w	#1,a0				; nächstes Zeichen
	dbra	d2,Printriga
	rts

ContaScroll:
	dc.w	0



ScrollText:
	dc.b	"                                              "
	dc.b	"QUESTO TESTO VIENE SPOSTATO CON IL REGISTRO BPLCON1:"
	DC.B	" DOPO AVERLO SPOSTATO DI 16 PIXEL VIENE AZZERATO,"
	DC.B	" E INVECE DI PUNTARE ALLA PROSSIMA WORD DELL` IMMAGINE IL TE"
	DC.B	"STO VIENE RISTAMPATO SULLO SCHERMO 2 LETTERE DOPO."
	DC.B	"L'AUTORE, LORENZO DI GAETANO, (The Amiga Dj) HA FATTO QUESTA"
	dc.b	" ROUTINE CON LE SOLE CONOSCENZE DEL DISCO 1 DEL CORSO."
	dc.b	"... FORZA AMIGA!!!                    "
	DC.B	"                                       "
	dc.b	$FF					; Flag für das Ende Scrolltext

	even

; Font 8x8

Fonts:
	incbin	"/Sources/nice.fnt"

;****************************************************************************

	SECTION	GRAPHIC,DATA_C


COPPERLIST:
	dc.w    $08e,$2c81			; Hier sind die Standardregister
	dc.w    $090,$2cc1
	dc.w    $092,$0038
	dc.w    $094,$00d0
	dc.w	$102,0
	dc.w    $104,0
	dc.w    $108,2				; 2, um die Leere des Bildes zu überspringen
	dc.w    $10a,2

bplpointers:
	dc.w    $e0,$0000,$e2,$0000    ; Zeiger auf bitplane

	dc.w    $100,%0001001000000000 ; Bplcon0 2 Farben

	dc.w	$180,$000
	dc.w	$182,$888

; Hier könnte ein beliebiges Bild stehen...

	dc.w	$eb07,$fffe			; Hier beginnt die copperliste zum Scrollen.
	dc.w    $092,$0030			; So verbergen Sie den Bildlauffehler
	dc.w    $094,$00d0

	dc.w    $104,0
	dc.w    $108,0
	dc.w    $10a,0
	dc.w    $102				; bplcon1
	dc.b	$00
Scrolling:
	dc.b	$ff
	dc.w	$182,$200
	dc.w	$ec07,$FFFe
	dc.w	$182,$400
	dc.w	$ed07,$fffe
	dc.w	$182,$600
	dc.w	$ee07,$fffe
	dc.w	$182,$800
	dc.w	$ef07,$fffe
	dc.w	$182,$a00
	dc.w	$f007,$fffe
	dc.w	$182,$d00
	dc.w	$f107,$fffe
	dc.w	$182,$a00
	dc.w	$f207,$fffe
	dc.w	$182,$800
	dc.w	$f307,$fffe	
	
	dc.w	$182,$000			; Effekte copper...
	dc.w	$180,$001
	dc.w	$108,-84
	dc.w	$10a,-84
	dc.w	$f4ff,$fffe
	dc.w	$180,$003
	dc.w	$f5ff,$fffe
	dc.w	$180,$005
	dc.w	$f6ff,$fffe
	dc.w	$180,$007
	dc.w	$f7ff,$fffe
	dc.w	$180,$009
	dc.w	$f8ff,$fffe
	dc.w	$180,$00b
	dc.w	$f8ff,$fffe
	dc.w	$180,$00c
	dc.w	$f9ff,$fffe
	dc.w	$180,$00f
	dc.w	$faff,$fffe
	dc.w	$180,$00f
	dc.w	$fbff,$fffe
	dc.w	$180,$000
	dc.w	$108,0
	dc.w	$10a,0
	dc.w	$ffff,$fffe			; Ende copperlist

;****************************************************************************

	Section	Bitplanozzo,bss_C

Schermo:
	ds.b	42*256

	end

