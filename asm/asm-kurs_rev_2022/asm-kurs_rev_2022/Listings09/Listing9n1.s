
; Listing9n1.s		Ladies and gentlemen, the SCROLLTEXT !!!!!
				; Left button to exit.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	lea	testo(pc),a0			; zeigt auf den Scrolltext Text

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2			; Warte auf Zeile $108
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $108
	Beq.S	Waity2

	bsr.s	printchar			; Routine, die die neuen Zeichen druckt
	bsr.s	Scorri				; Scroll-Routine ausführen

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:
	rts

;****************************************************************************
; Diese Routine druckt ein Zeichen. Das Zeichen wird in einem 
; unsichtbaren Teil des Bildschirms gedruckt.
; A0 zeigt auf den zu druckenden Text.
;****************************************************************************

PRINTCHAR:
	subq.w	#1,contatore		; Verringere den Zähler um 1
	bne.s	NoPrint				; wenn es sich von 0 unterscheidet, drucken wir nicht,
	move.w	#16,contatore		; sonst ja; den Zähler zurücksetzen

	MOVEQ	#0,D2				; d2 löschen
	MOVE.B	(A0)+,D2			; Nächstes Zeichen in d2
	bne.s	noreset				; Wenn es anders als 0 ist, drucken wir es,
	lea	testo(pc),a0			; Andernfalls starten wir den Text erneut
	MOVE.B	(A0)+,D2			; erstes Zeichen in d2
noreset
	SUB.B	#$20,D2				; ZIEHE 32 VOM ASCII-WERT DES BUCHSTABEN AB,
								; SOMIT VERWANDELN WIR Z.B. DAS LEERZEICHEN
								; (Das $20 entspricht), IN $00, DAS
								; AUSRUFUNGSZEICHEN ($21) IN $01....
	ADD.L	D2,D2				; WIR MULTIPLIZIEREN DEN WERT MIT 2,
								; weil jedes Zeichen 16 Pixel breit ist.
	MOVE.L	D2,A2
	ADD.L	#FONT,A2			; DEN GEFUNDENEN CHARAKTER IM FONT FINDEN ...

	btst	#6,$02(a5)			; warte auf das Ende des Blitters
waitblit:
	btst	#6,$02(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0: Kopie von A nach D
	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM alles passiert

	move.l	a2,$50(a5)			; BLTAPT: Adresse font
	move.l	#bitplane+50*42+40,$54(a5)	; BLTDPT: Adresse bitplane						
								; nicht sichtbar auf dem Bildschirm.
	move	#120-2,$64(a5)		; BLTAMOD: modulo font
	move	#42-2,$66(a5)		; BLTDMOD: modulo bit planes
	move	#(20<<6)+1,$58(a5) 	; BLTSIZE: font 16*20
NoPrint:
	rts

contatore
	dc.w	16

;****************************************************************************
; Diese Routine scrollt den Text nach links
;****************************************************************************

;	                            :
;	                            .
;	
;	        . · ·. ¦:.:.:.:.:.:.¦  . · .     . · .
;	    ° ·       ·|            |.·     . . ·     ·
;	       . ··.   |        __  |                  ·
;	     ·      ·. |       /  ` |     .··.          °
;	  ·            | ,___   ___ |   .·    ·
;	°              | ____  /   \|  ·       .
;	         .···. l/   o\/°   /l
;	        °     (¯\____/\___/ ¯)          °
;	               T   (____)   T
;	               l            j xCz
;	                \___ O ____/
;	                   `---'

Scorri:

; Die Quell- und Zieladressen sind gleich.
; Wir bewegen uns nach links, also benutzen wir den absteigenden Weg.

	move.l	#bitplane+((21*(50+20))-1)*2,d0		; Adresse Quelle und Ziel
					
ScorriLoop:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
waitblit2:
	btst	#6,2(a5)
	bne.s	waitblit2

	move.l	#$19f00002,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
								; mit einer Ein-Pixel-Verschiebung
	
	move.l	#$ffff7fff,$44(a5)	; BLTAFWM und BLTALWM
								; BLTAFWM = $ffff - alles passiert
								; BLTALWM = $7fff = %0111111111111111
								; lösche das Bit am linken Rand
								; (testen Sie auch BLTALWM = $ffff und $0000
								; um es besser zu verstehen)

								; Lade die Zeiger
	move.l	d0,$50(a5)			; bltapt - Quelle
	move.l	d0,$54(a5)			; bltdpt - Ziel

; Lassen Sie uns dann ein breites Bild über den Bildschirm scrollen
; Das Modulo wird zurückgesetzt.

	move.l	#$00000000,$64(a5)	; bltamod und bltdmod 
	move.w	#(20*64)+21,$58(a5)	; bltsize
								; Höhe 20 Zeilen, Breite 21
	rts							; Wörter (der ganze Bildschirm)

; Dies ist der Text, der mit 0 endet. Die verwendete Schriftart enthält
; als Schriftzeichen nur Großbuchstaben, Achtung!

testo:
	;dc.b	"ECCO FINALMENTE LO SCROLLTEXT, CHE TUTTI STAVANO"
	;dc.b	" ASPETTANDO... IL FONT E' DI 16*20 PIXEL!..."
	;dc.b	" LO SCROLL AVVIENE CON TRANQUILLITA'...",0

	dc.b "ICH HABE ENDLICH DEN SCROLLTEXT, AUF DEN ALLE"
	dc.b "WARTEN !!! ... DIE SCHRIFT IST 16 * 20 PIXEL!"
	dc.b "DER SCROLL KOMMT MIT TRAUMQUALITÄT ...", 0


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
								; Bytes sind sichtbar, dann hat das Modulo den
								; Wert 42-40 = 2
	; dc.w $ 10a,2				; Wir verwenden nur eine Bitebene, dann ist
								; BPLMOD2 nicht notwendig

	dc.w	$100,$1200			; bplcon0 - 1 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color 0

; Diese Copperlisten Anweisungen ändern die Farbe 1 alle 2 Zeilen

	dc.w	$5e01,$fffe			; erste Zeile scrolltext
	dc.w	$0182,$f50			; color 1
	dc.w	$6001,$fffe
	dc.w	$0182,$d90
	dc.w	$6201,$fffe
	dc.w	$0182,$dd0
	dc.w	$6401,$fffe
	dc.w	$0182,$5d2
	dc.w	$6601,$fffe
	dc.w	$0182,$2f4
	dc.w	$6801,$fffe
	dc.w	$0182,$0d7
	dc.w	$6a01,$fffe
	dc.w	$0182,$0dd
	dc.w	$6c01,$fffe
	dc.w	$0182,$07d
	dc.w	$6e01,$fffe
	dc.w	$0182,$22f
	dc.w	$7001,$fffe
	dc.w	$0182,$40d
	dc.w	$7201,$fffe
	dc.w	$0182,$80d

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Der FONT von 16x20 Zeichen ist hier gespeichert

FONT:
	incbin	"/Sources/font16x20.raw"
	

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C

BITPLANE:
	ds.b	42*256				; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel präsentieren wir einen der klassischen Effekte der Demos:
den Scrolltext. Dies ist ein Text, der auf dem Bildschirm von rechts nach
links scrollt und er enthält in der Regel Grüße von den Autoren der Demo an die 
anderen Demo-Coder. Wie schafft man einen Scrolltext? 
Sie könnten daran denken, den gesamten Text auf eine Bitplane zu drucken der
größer als der sichtbare Bildschirm ist und dann scrollen Sie die Bitebene. 
Diese Technik hat den Nachteil, viel Speicher zu beanspruchen, weil sie eine
Bitebene benötigt, die den gesamten Text enthält.
Wir verwenden eine andere Technik, die auf den Blitter basiert, für die eine
Bitebene ausreicht, die nur 16 Pixel breit (1 Wort) größer als der sichtbare
Bereich ist. Also haben wir eine Spalte mit einem unsichtbaren Wort auf der
rechten Seite des Bildschirms.
Nehmen wir an, wir drucken ein Zeichen in den unsichtbaren Teil der Bitebene
und gleichzeitig verschiebt man die Bitebene nach links mit dem Blitter. Es
passiert, wie Sie sich vorstellen können, dass der Charakter sich ein Pixel
zu einem Zeitpunkt nach links bewegt. Beachten Sie, dass die Bitebenen-Zeiger
immer fest bleiben.
Wenn der Charakter komplett sichtbar ist, erfolgt nach 16 Verschiebungen von
1 Pixel, da der Charakter 16 Pixel breit ist, dass wir das nächste Zeichen in
den unsichtbaren Teil des Bildschirms drucken können. Die Zeichen, die am
linken Rand ankommen, werden über die Maske vom Blitter gelöscht.
In der Praxis wird der Effekt unter Verwendung von 2 Routinen gewonnen. Die
erste "Printchar" befasst sich mit dem Drucken der Zeichen auf dem Bildschirm.
Der Druckvorgang muss nur stattfinden, wenn das zuvor gedruckte Zeichen
vorhanden ist und vollständig sichtbar geworden ist, um eine Überlappung 
der 2 Zeichen zu vermeiden.
Da jedes Zeichen 16 Pixel breit ist, fließt der Text um ein Pixel nach. Im
Wesentlichen muss der Druck alle 16 Male auftreten, wenn die Routine
aufgerufen wird.
Dazu wird ein Zähler verwendet, der bei jedem Aufruf dekrementiert wird.
Wenn es den Wert 0 annimmt, wird das Zeichen gedruckt und der Zähler auf 16
neu initialisiert. Der eigentliche Druck ist eine einfache Kopie mit dem
Blitter (aufsteigend) und wird in der uns bekannten Weise hergestellt.
Die "Scroll" -Routine ist für das Scrollen des Textes mit der Verschiebung
durch den Blitter nach links (also absteigend) in der Art, wie wir es im
Beispiel Listing9m2.s gesehen haben verantwortlich. Da die Charakter 20 Zeilen
hoch sind, belegt der gesamte Text ein 20 Zeilen hohes Screen-"Band". Es ist
notwendig, dieses "Band" oder ein 20 Zeilen hohes Rechteck zu verschieben.
Die Zeilen und so breit wie jede Bitebene (einschließlich natürlich des 
UNSICHTBAREN Teils, um die Zeichen in den sichtbaren Bereich zu scrollen.
Die Maske des letzten Wortes löscht die Zeichen, wenn sie die linke Kante 
erreichen. Wir haben einen 1-Bitplane-Bildschirm verwendet, und die Farben
erhalten wir durch den copper (sind wir schlau?).
