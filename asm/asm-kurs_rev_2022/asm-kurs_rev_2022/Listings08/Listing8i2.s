
; Listing8i2.s - Einfacher zeitgesteuerter Equalizer mit der Musik Routine
; - RECHTE TASTE, um die Geschwindigkeit der Balken zu ändern

	SECTION	MAINPROGRAM,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA
;			 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA

START:
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#MyCopList,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	bsr.w	mt_init				; Initialisieren der Musik Routine

MainLoop:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	bsr.w	mt_music			; spielt die Musik

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	beq.s	Uscita				; Wenn ja, beenden

	bsr.s	Equalizzatori		; Einfache Equalizer-Routine

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	MainLoop			; Wenn "NEIN" wird erneut gestartet,
								; ansonsten ändert sich die Musik

	lea	musiche(PC),a0			; tauscht die Musik aus
	move.l	(a0),d0
	move.l	4(a0),d1
	move.l	4*2(a0),d2
	move.l	4*3(a0),d3
	move.l	d0,4(a0)
	move.l	d1,4*2(a0)
	move.l	d2,4*3(a0)
	move.l	d3,(a0)

	move.l	musiche(PC),mt_data	; Zeiger aktuelle Musik
	bsr.w	mt_init				; Setzen Sie die Musik zurück
SpettaLascia:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	beq.s	SpettaLascia		; warte bis es übrig ist
	bra.s	MainLoop

Uscita:
	bsr.w	mt_end				; stoppt die Musik Routine
	rts

; Tabelle mit Musik ... durch drehen der Adressen und kopieren
; können wir sie ändern ...

musiche:
	dc.l	mt_data1,mt_data2,mt_data3,mt_data4


; Hier ist die Equalizer-Routine, der Audio-Analysator. Als erstes ist
; zu wissen, wo man Informationen über die Verwendung der 4 Stimmen durch die 
; Musik Routine findet. Normalerweise wird sie verwendet, um die Variable der 
; Wiederholungsroutine zu überprüfen, die uns sagen kann, ob eine Stimme 
; zum Abspielen aktiviert ist, ein Instrument, normalerweise "mt_chanXtemp",
; wobei X 1,2,3 oder 4 sein kann.
; In dieser Version wird auch der Wert, den mt_chanXtemp hat für 
; zusätzliche Analyse verwendet.

;	       ...._____
;	     .:::··____ \_______
;	    .:·:  /   ¬\ \      \
;	   .:::  /      \________\
;	  .:::  /    (O  \`-o---'/
;	  ::\_  \     ¯  /_,   _/
;	   ·/    \      /  \   \
;	   / _____\____/    \  /
;	  / / T   \      (,_/ /
;	 / /\_l___/\         /
;	/ /_________\     __/
;	\ ¯  -----  ¯     /
;	 \_______________/ xCz
;	     T        T
;	     `--------'

Equalizzatori:
	move.b	EqualSpeed(PC),d0	; Geschwindigkeit der "fallenden" Balken in d0
	cmp.b	#$07,WaitEqu1+1		; ist der erste Balken auf Null gesunken?
	bls.s	NonAbbass1			; wenn ja, nicht weiter senken!
								; * bls bedeutet weniger oder gleich, es ist besser
								; es anstelle von beq zu verwenden, weil die Subtraktion
								; mit d0 eine zu große Zahl ergeben kann
								; es kann zufällig auf $05 oder $03 steigen!
	sub.b	d0,WaitEqu1+1		; ansonsten den Balken senken, bestehend aus
	sub.b	d0,WaitEqu1b+1		; zwei farbigen und einer schwarzen Linie
	sub.b	d0,WaitEqu1c+1
NonAbbass1:
	tst.w	mt_chan1temp		; Stimme 1 nicht "gespielt"?
	beq.s	anal2				; Wenn nicht, springe zu Anal2
	move.w	mt_chan1temp,COLORE1
	move.w	mt_chan1temp,COLORE1b
	and.w	#$f0,COLORE1		; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE1		; mindestens $30!
	and.w	#$0f,COLORE1b		; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE1b		; mindestens $03!
	clr.w	mt_chan1temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu1+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu1b+1
	move.b	#$a7,WaitEqu1c+1
anal2:
	cmp.b	#$07,WaitEqu2+1		; Ist der zweite Balken auf Null gesunken?
	bls.s	NonAbbass2			; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu2+1		; Ansonsten den Balken senken
	sub.b	d0,WaitEqu2b+1
	sub.b	d0,WaitEqu2c+1
NonAbbass2:
	tst.w	mt_chan2temp		; Stimme 2 nicht "gespielt"?
	beq.s	anal3				; Wenn nicht, springe zu Anal3
	move.w	mt_chan2temp,COLORE2
	move.w	mt_chan2temp,COLORE2b
	and.w	#$f0,COLORE2		; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE2		; mindestens $30!
	and.w	#$0f,COLORE2b		; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE2b		; mindestens $03!
	clr.w	mt_chan2temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu2+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu2b+1
	move.b	#$a7,WaitEqu2c+1
anal3:
	cmp.b	#$07,WaitEqu3+1		; Ist der dritte Balken auf Null gesunken?
	bls.s	NonAbbass3			; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu3+1		; Ansonsten den Balken senken
	sub.b	d0,WaitEqu3b+1
	sub.b	d0,WaitEqu3c+1
NonAbbass3:
	tst.w	mt_chan3temp		; Stimme 3 nicht "gespielt"?
	beq.s	anal4				; Wenn nicht, springe zu Anal4
	move.w	mt_chan3temp,COLORE3
	move.w	mt_chan3temp,COLORE3b
	and.w	#$f0,COLORE3		; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE3		; mindestens $30!
	and.w	#$0f,COLORE3b		; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE3b		; mindestens $03!
	clr.w	mt_chan3temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu3+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu3b+1
	move.b	#$a7,WaitEqu3c+1
anal4:
	cmp.b	#$07,WaitEqu4+1		; ist der vierte Balken auf Null gesunken?
	bls.s	NonAbbass4			; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu4+1		; Ansonsten den Balken senken
	sub.b	d0,WaitEqu4b+1
	sub.b	d0,WaitEqu4c+1
NonAbbass4:
	tst.w	mt_chan4temp		; Stimme 4 nicht "gespielt"?
	beq.s	analizerend			; wenn nicht, raus!
	move.w	mt_chan4temp,COLORE4
	move.w	mt_chan4temp,COLORE4b
	and.w	#$f0,COLORE4		; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE4		; mindestens $30!
	and.w	#$0f,COLORE4b		; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE4b		; mindestens $03!
	clr.w 	mt_chan4temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu4+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu4b+1
	move.b	#$a7,WaitEqu4c+1
analizerend:
	rts

EqualSpeed:
	dc.b	4
	even

*******************************************************************************
;	MUSIK ROUTINE 

	include	"/Sources/music.s"
*******************************************************************************

	Section	DatiChippy,data_C

MyCopList:
	dc.w	$100,$200			; Bplcon0 - keine bitplanes
	dc.w	$180,$00e			; color0 blau

	dc.w	$4807,$fffe
	dc.w	$180,$ddd
	dc.w	$4a07,$fffe
	dc.w	$180,$777

	dc.w	$5007,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE1:
	dc.w	$060
	dc.w	$5507,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE2:
	dc.w	$060
	dc.w	$5a07,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE3:
	dc.w	$060
	dc.w	$5f07,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE4:
	dc.w	$060
	dc.w	$6407,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE1b:
	dc.w	$00e
	dc.w	$6907,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE2b:
	dc.w	$00e
	dc.w	$6e07,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE3b:
	dc.w	$00e
	dc.w	$7307,$fffe			; Warten Sie auf die Zeile
	dc.w	$180
COLORE4b:
	dc.w	$00e
	dc.w	$7807,$fffe			; Warten Sie auf die Zeile
	dc.w	$180,$777
	dc.w	$7e07,$fffe
	dc.w	$180,$333
	dc.w	$8007,$fffe
	dc.w	$180,$00e

	dc.w	$ffdf,$fffe			; Warten Sie auf die Zeile $FF

; wait & mode der Analyseroutine - Verwendung der horizontalen Position
; wartet darauf, dass die Balken "vorwärts" und "rückwärts" gehen

	dc.w	$1507,$fffe			; Warte auf den Beginn der Zeile
	dc.w	$180,$00e			; color0 blau

	dc.w	$1607,$fffe			; Warte auf den Beginn der Zeile
	dc.w	$180,$f55			; color0 rot - Farbe der ersten BAR
WaitEqu1:
	dc.w	$1617,$fffe			; wait (wird dann zum Zeilenende geändert
								; es wird um 4 sinken, bis es wieder bei $07 zurückkehrt)
	dc.w	$180,$00e			; color0 blau
	dc.w	$1707,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$f55			; color0 rot erste Bar (2 Zeilen hoch!)
WaitEqu1b:
	dc.w	$1717,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$1807,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$002			; color0 schwarz ("Schatten" unter dem ersten Balken)
WaitEqu1c:
	dc.w	$1817,$fffe			; wait (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau

; zweite Bar

	dc.w	$1b07,$fffe			; Warte auf den Beginn der Zeile
	dc.w	$180,$a5f			; color0 lila (zweite Bar)
WaitEqu2:
	dc.w	$1b17,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$1c07,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$a5f			; color0 zweite Bar (2 Zeilen hoch!)
WaitEqu2b:
	dc.w	$1c17,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$1d07,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$002			; color0 schwarz ("Schatten")
WaitEqu2c:
	dc.w	$1d17,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau

; dritte Bar

	dc.w	$2007,$fffe			; Warte auf den Beginn der Zeile
	dc.w	$180,$ff0			; color0 (dritte Bar)
WaitEqu3:
	dc.w	$2017,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$2107,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$ff0			; color0 dritte Bar (2 Zeilen hoch!)
WaitEqu3b:
	dc.w	$2117,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$2207,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$002			; color0 schwarz ("Schatten")
WaitEqu3c:
	dc.w	$2217,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau

; vierte Bar

	dc.w	$2507,$fffe			; Warte auf den Beginn der Zeile
	dc.w	$180,$5F0			; color0 (vierte Bar)
WaitEqu4:
	dc.w 	$2517,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$2607,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$5F0			; color0 vierte Bar (2 Zeilen hoch!)
WaitEqu4b:
	dc.w 	$2617,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau
	dc.w	$2707,$fffe			; Warten auf den Beginn der Zeile
	dc.w	$180,$002			; color0 schwarz ("Schatten")
WaitEqu4c:
	dc.w 	$2717,$fffe			; Warten (geändert für Taktlänge)
	dc.w	$180,$00e			; color0 blau

	DC.W	$FFFF,$FFFE			; Ende copperlist


; Musik - Sie können einen der 4 Musiktitel von der Diskette auswählen.
; hier "verstehen" sie die Nützlichkeit von mt_data als Zeiger.

mt_data:
	dc.l	mt_data1
	
mt_data1:
	incbin	"/Sources/mod.fuck the bass"	; by m.c.m/remedy 91
mt_data2:
	incbin	"/Sources/mod.yellowcandy"		; by sire/supplex
mt_data3:
	incbin	"/Sources/mod.fairlight"		; by d-zire/silents 92 (lungo solo 2k!)
mt_data4:
	incbin	"/Sources/mod.JamInexcess"		; by raiser/ram jam

	end

