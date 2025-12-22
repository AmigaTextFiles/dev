
; Listing10i2.s		1-Pixel-Sinus-Scroller
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	lea	testo(pc),a0			; zeigt auf den scrolltext

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2			; Warte auf Zeile $108
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits von pos. vertikal
	CMPI.L	D2,D0				; Warte auf Zeile $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $108
	Beq.S	Waity2

	bsr.s	printchar			; Routine, die die neuen Zeichen druckt
	bsr.s	Scorri				; Führen Sie die Scroll-Routine aus

	bsr.w	CancellaSchermo		; Reinigen Sie den Bildschirm
	bsr.w	Sine				; Führen Sie die Sinus-Bildlauffunktion aus

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; wenn nicht, gehe zurück zu mouse:
	rts

;****************************************************************************
; Diese Routine druckt ein Zeichen. Das Zeichen wird in einem gedruckt
; Teil des unsichtbaren Bildschirms.
; A0 zeigt auf den zu druckenden Text.
;****************************************************************************

PRINTCHAR:
	subq.w	#1,contatore		; Verringere den Zähler um 1
	bne.s	NoPrint				; wenn es sich von 0 unterscheidet, drucken wir nicht,
	move.w	#16,contatore		; sonst ja; den Zähler zurücksetzen

	MOVEQ	#0,D2				; d2 löschen
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	bne.s	noreset				; Wenn es anders als 0 ist, drucken Sie es
	lea	testo(pc),a0			; Andernfalls starten Sie den Text erneut
	MOVE.B	(A0)+,D2			; Erstes Zeichen in d2
noreset
	SUB.B	#$20,D2				; SUBTRAHIERE 32 VOM ASCII-WERT DES CHARAKTERS
								; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
								; (Das $20 entspricht), IN $00, DAS
								; AUSRUFUNGSZEICHEN ($21) IN $01...
	ADD.L	D2,D2				; MULTIPLIZIERE DIE ERHALTENE ZAHL MIT 2,
								; weil jedes Zeichen 16 Pixel breit ist
	MOVE.L	D2,A2

	ADD.L	#FONT,A2			; DEN GESUCHTEN CHARAKTER IM FONT FINDEN ...

	btst	#6,$02(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit:
	btst	#6,$02(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0: Kopie von A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM es passiert alles

	move.l	a2,$50(a5)			; BLTAPT: Adresse Font
	move.l	#buffer+40,$54(a5)	; BLTDPT: Adresse bitplane						
	move	#120-2,$64(a5)		; BLTAMOD: Modulo font
	move	#42-2,$66(a5)		; BLTDMOD: Modulo bit planes
	move	#(20<<6)+1,$58(a5) 	; BLTSIZE: font 16*20
NoPrint:
	rts

contatore
	dc.w	16

;****************************************************************************
; Diese Routine scrollt den Text nach links
;****************************************************************************

Scorri:

; Die Quell- und Zieladressen sind gleich.
; Wir bewegen uns nach links, also benutzen wir den absteigenden Weg.

	move.l	#buffer+((21*20)-1)*2,d0	; Adresse Quelle und Ziel										
ScorriLoop:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
waitblit2:
	btst	#6,2(a5)
	bne.s	waitblit2

	move.l	#$19f00002,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
								; mit einer Ein-Pixel-Verschiebung

	move.l	#$ffff7fff,$44(a5)	; BLTAFWM und BLTALWM
								; BLTAFWM = $ffff - es passiert alles
								; BLTALWM = $7fff = %0111111111111111
								; lösche das linke Bit
; Lade die Zeiger
	move.l	d0,$50(a5)			; bltapt - Quelle
	move.l	d0,$54(a5)			; bltdpt - Ziel

; Lassen Sie uns dann ein breites Bild über den Bildschirm scrollen
; Das Modulo Register wird zurückgesetzt.

	move.l	#$00000000,$64(a5)	; bltamod und bltdmod 
	move.w	#(20*64)+21,$58(a5)	; bltsize
								; Höhe 20 Zeilen, Breite 21
	rts							; words (der ganze Bildschirm)


;****************************************************************************
; Diese Routine realisiert den Sinus-Scroll-Effekt. Aufmerksamkeit für BLTALWM, weil
; Es ist das Register, in dem wir jedes Mal die "Scheibe" oder "Striscina" auswählen
; vertikal, auf dem zu operieren ist. Hier sind die Unterschiede mit dem 2 Pixel Sinus!
;****************************************************************************

;	  ,-~~-.___.
;	 / |  '     \
;	(  )         0
;	 \_/-, ,----'
;	    ====           //
;	   /  \-'~;    /~~~(O)
;	  /  __/~|   /       |
;	=(  _____| (_________|   W<

Sine:
	lea	buffer,a2				; Zeiger auf den enthaltenden Puffer
								; Scrolltext
	lea	bitplane,a1				; Zeiger auf das Ziel

	move.l	SinusPtr(pc),a3		; Adresse erster Sinuswert (* 42)
	subq.w	#2,a3				; Ändere den ersten Wert
	cmp.l	#Sinustab,a3		; wenn wir am Anfang der Tabelle stehen
	bhs.s	nostartptr			; fang wieder vom ende an
	lea	EndSinustab(pc),a3
nostartptr:
	move.l	a3,SinusPtr			; merkt sich den ersten verwendeten Wert

	move.w	#$8000,d5			; Maskenwerte zu Beginn
	moveq	#20-1,d6			; Wiederholen für alle Wörter im Text
FaiUnaWord:
	moveq	#16-1,d7			; 1-Pixel-Routine. Für jedes Wort
								; gibt es 16 "Scheiben" von 1 Pixel

FaiUnaColonna:
	move.w	(a3)+,d0			; liest einen Wert aus der Tabelle
	cmp.l	#EndSinustab,a3		; wenn wir am Ende des Tabelle sind
	blo.s	nostartsine			; fang wieder von vorn an
	lea	sinustab(pc),a3
nostartsine:
	move.l	a1,a4				; Kopie Adresse bitplane
	add.w	d0,a4				; Fügt die Y-Koordinate, Offset hinzu

	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit_sine:
	btst	#6,2(a5)
	bne.s	waitblit_sine

	move.w	#$ffff,$44(a5)		; BLTAFWM
	move.w	d5,$46(a5)			; BLTALWM - enthält die Maske, die
								; den Scrolltext "slices" auswählt
		
	move.l	#$0bfa0000,$40(a5)	; BLTCON0/BLTCON1 - aktiviere A,C,D
								; D=A OR C

	move.w	#$0028,$60(a5)		; BLTCMOD=42-2=$28
	move.l	#$00280028,$64(a5)	; BLTAMOD=42-2=$28
								; BLTDMOD=42-2=$28

	move.l	a2,$50(a5)			; BLTAPT  (Puffer)
	move.l	a4,$48(a5)			; BLTCPT  (Bildschirm)
	move.l	a4,$54(a5)			; BLTDPT  (Bildschirm)
	move.w	#(64*20)+1,$58(a5)	; BLTSIZE (ein Rechteck gemischt
								; 20 Zeilen hoch und 1 Wort breit)

	ror.w	#1,d5				; zur nächsten "Scheibe" bewegt
								; geht nach rechts und nach der letzten "Scheibe"
								; eines Wortes fängt das folgende
								; Wort wieder vom Anfang an.
								; für den 1 Pixel Scroll ist die
								; "Scheibe" 1 Pixel breit

	dbra	d7,FaiUnaColonna

	addq.w	#2,a2				; Zeige auf das nächste Wort
	addq.w	#2,a1				; Zeige auf das nächste Wort
	dbra	d6,FaiUnaWord
	rts

; Dies ist der Text. mit 0 endet es. Die verwendete Schriftart enthält nur 
; die Zeichen Großbuchstaben, Achtung!

testo:
	;dc.b	" ECCO COME SINUSCROLLARE... IL FONT E' DI 16*20 PIXEL!..."
	;dc.b	" LO SCROLL AVVIENE CON TRANQUILLITA'...",0
	;even

	dc.b	" HIER KOMMT DER SINUSSCROLLER... DER FONT IST 16*20 PIXEL! ... "
	dc.b	" DAS SCROLLEN ERFOLGT MIT RUHE ...",0
	even
	
;****************************************************************************
; Diese Routine löscht den Bildschirm mit dem Blitter.
; Nur der Teil des Bildschirms, auf dem der Text fließt, wird gelöscht:
; von Zeile 130 bis Linie 193
;****************************************************************************

CancellaSchermo:
	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschung
	move	#$0000,$66(a5)		; BLTDMOD=0
	move.l	#bitplane+42*130,$54(a5)	; BLTDPT
	move.w	#(64*63)+20,$58(a5)	; BLTSIZE (Blitter starten!)
								; lösche von Zeile 130 bis Linie 193
	rts


;***************************************************************************

; Dieser Zeiger enthält die Adresse des ersten Wertes, von dem gelesen werden soll
; Tabelle

SinusPtr:	dc.l	Sinustab

; Dies ist die Tabelle, die die Werte der vertikalen Positionen enthält
; des Scrolltextes. Die Positionen sind daher bereits mit 42 multipliziert
; Sie können direkt zur BITPLANE-Adresse hinzugefügt werden

Sinustab:
	DC.W	$189C,$18C6,$18F0,$191A,$1944,$196E,$1998,$19C2,$19C2,$19EC
	DC.W	$1A16,$1A40,$1A6A,$1A6A,$1A94,$1ABE,$1ABE,$1AE8,$1B12,$1B12
	DC.W	$1B3C,$1B3C,$1B66,$1B66,$1B90,$1B90,$1BBA,$1BBA,$1BBA,$1BBA
	DC.W	$1BE4,$1BE4,$1BE4,$1BE4,$1BE4,$1BE4,$1BE4,$1BE4,$1BE4,$1BE4
	DC.W	$1BBA,$1BBA,$1BBA,$1BBA,$1B90,$1B90,$1B66,$1B66,$1B3C,$1B3C
	DC.W	$1B12,$1B12,$1AE8,$1ABE,$1ABE,$1A94,$1A6A,$1A6A,$1A40,$1A16
	DC.W	$19EC,$19C2,$19C2,$1998,$196E,$1944,$191A,$18F0,$18C6,$189C
	DC.W	$189C,$1872,$1848,$181E,$17F4,$17CA,$17A0,$1776,$1776,$174C
	DC.W	$1722,$16F8,$16CE,$16CE,$16A4,$167A,$167A,$1650,$1626,$1626
	DC.W	$15FC,$15FC,$15D2,$15D2,$15A8,$15A8,$157E,$157E,$157E,$157E
	DC.W	$1554,$1554,$1554,$1554,$1554,$1554,$1554,$1554,$1554,$1554
	DC.W	$157E,$157E,$157E,$157E,$15A8,$15A8,$15D2,$15D2,$15FC,$15FC
	DC.W	$1626,$1626,$1650,$167A,$167A,$16A4,$16CE,$16CE,$16F8,$1722
	DC.W	$174C,$1776,$1776,$17A0,$17CA,$17F4,$181E,$1848,$1872,$189C
EndSinustab:

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2

	dc.w	$108,2				; Die Bitebene ist 42 Bytes breit, aber nur 40
								; Bytes sind sichtbar,
								; dann ist der Registerwert 42-40 = 2		
								; dc.w $10a,2; Wir verwenden nur eine Bitebene, 
								; dann ist BPLMOD2 nicht notwendig

	dc.w	$100,$1200			; bplcon0 - 1 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$f50			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Das FONT von 16x20 Zeichen ist hier gespeichert

FONT:
	incbin	"/Sources/font16x20.raw"

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C

BITPLANE:
	ds.b	42*256				; bitplane rücksetzen lowres

Buffer:
	ds.b	42*20				; unsichtbarer Puffer, wo der Text gescrollt wird
	end

;****************************************************************************

In diesem Beispiel sehen wir einen 1-Pixel-Sinus-Scroll. Wenn Sie genau 
hinsehen werden Sie bemerken, das die Ränder der Buchstaben beim Sinuslauf viel
weniger gezackt sind. Die "Sinus" -Routine ist der von Listing10i1.s sehr
ähnlich. Die Unterschiede bestehen in der Tatsache, dass wir jetzt ein Pixel
breite Scheiben haben. D.h in einem Wort 16 "Scheiben" anstatt 8. Das bedeutet
natürlich, das die Maske sich jedes Mal um 1 Pixel anstatt um 2 rotieren muss.
Beachten Sie auch, dass wir eine andere Tabelle verwenden. In der Tat, wenn wir
den gleichen Sinuslauf genommen hätten wären wir näher gekommen. Um den
Scroller etwas abwechslungsreicher zu gestalten, lesen wir die Tabellenwerte
jedes Mal ab einem anderen Wert. Dazu verwenden wir einen Zeiger auf die den
ersten zu lesenden Wert, der bei jedem Lesen geändert wird.