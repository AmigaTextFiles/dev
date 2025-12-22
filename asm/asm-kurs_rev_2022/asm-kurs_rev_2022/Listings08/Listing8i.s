
; Listing8i.s - Einfacher zeitgesteuerter Equalizer mit der Musik Routine
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

	bsr.w	mt_init				; Musik Routine initialisieren

MainLoop:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	mt_music			; spielt die Musik

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	beq.s	VaiForte
	move.b	#2,EqualSpeed		; Abnahmegeschwindigkeit = 2 Pixel pro Bild
	bra.s	VaiPiano
Vaiforte:
	move.b	#8,EqualSpeed		; Abnahmegeschwindigkeit = 8 Pixel pro Bild
VaiPiano:

	bsr.s	Equalizzatori		; Einfache Equalizer-Routine

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	MainLoop			; Wenn "NEIN" erneut starten

	bsr.w	mt_end				; stoppt die Musik Routine
	rts


; Hier ist die Equalizer-Routine, der Audio-Analysator. Als erstes ist
; zu wissen, wo man Informationen über die Verwendung der 4 Stimmen durch die 
; Musik Routine findet. Normalerweise wird sie verwendet, um die Variable der 
; Wiederholungsroutine zu überprüfen, die uns sagen kann, ob eine Stimme 
; zum Abspielen aktiviert ist, ein Instrument, normalerweise "mt_chanXtemp",
; wobei X 1,2,3 oder 4 sein kann.
; Dieses System ist jedoch nicht perfekt, da wir nur wissen können wenn es
; die Verwendung eines der 4 Stimmen "mitteilt", wenn also zum Beispiel ein 
; Instrument gespielt wird, das 10 Sekunden lang weiter gespielt wird, wird
; der Balken dieser Stimme verlängert in der ersten Sekunde und signalisiert
; damit den Einsatz dieser Stimme in diesem Moment, aber dann wird sie leiser
; und bleibt ruhig bis diese Stimme zum Spielen eines anderen Instruments
; verwendet wird.
; Wenn eine Stimme für kurze Töne wie Schlagzeug verwendet wird, werden Sie
; dies nicht bemerken, denn zum Zeitpunkt des BUM! geht der Balken nach oben
; und wenn er nach unten gekommen ist, ist der Ton zu Ende oder wird gerade
; beendet. Das Problem wird tragisch, wenn ein Loop-Instrument verwendet wird,
; zum Beispiel Stimmen, wobei der Balken einen einzigen "Sprung" macht
; und dann während der Schleife unten bleibt.
; Dieses System ist dasselbe wie die Balken auf den 4 Spuren des alten
; Soundtrackers und Protrackers bis Version 2. Für Equalizer des Typs
; von Protracker 3, die der "Lautstärke" der Stimmen besser folgen, ist es
; notwendig müssen Sie die Musikroutine selbst ändern. Das gleiche gilt für
; die Equalize, die die Wellenform anzeigen.
; Machen sie einfach eine "tst.w mt_chanXtemp" und handeln sie entsprechend.
; In diesem Fall werden die Balken mit dem copper gemacht, unter Verwendung
; der horizontalen Position mit der copperlist warten.
; Auf diese Weise verwenden wir nur die Hintergrundfarbe $dff180 ohne
; Bitebenen. Wir warten einfach auf den Anfang der Zeile, geben die Farbe des
; Balkens ein und dann warten wir, auf bis eine weiter fortgeschrittene 
; horizontale Position erreicht ist und ersetzen in der gleichen Zeile die
; Hintergrundfarbe. Auf diesem Weg, wenn wir also auf dieses Warten reagieren,
; "bewegen" wir den Balken vorwärts und rückwärts, wie wir es in Listing3g.s 
; und Listing3h.s gesehen haben.
; Die Routine funktioniert in der Praxis im Wesentlichen so: Mit jedem Frame
; werden die Balken abgesenkt, bis sie auf Null gesetzt sind, d.h. wenn keine
; Musik gespielt wird, bleiben sie auf Null. In dem Fall, wenn dass der tst
; des mt_chanXtemp ein in dieser Stimme gespieltes Sample signalisiert, wird
; der Maximalwert des Balkens, dh $a7 gesetzt.
; 

;		    ,,,,,,,
;		   ,)))))))))
;		   | _______Â¡     ___
;		   |  _Â¬Â©)Â©)     ( )))
;		   l_ |  ,\|     / Â¯/
;		  __| l___Â¯|__  /  /
;		 /Â¯ l__ Â¬ _! Â¬\/  /
;		/  /::`---':\  \ /
;		\  \:::...::Â¡\__/
;		 \  \:::::::|
;		  \  \::::::|
;		  /),,)Â¯Â¯Â¯Â¯Â¯Â¯\
;		 / Â¯Â¯Â¯  /\    \ xCz
;		 \      \_\    \
;		  \______//    /
;		   /  Â¬/ /    /
;		  (___/ /____/_
;		        Â¯\_____)


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
	clr.w	mt_chan1temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu1+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu1b+1
	move.b	#$a7,WaitEqu1c+1
anal2:
	cmp.b	#$07,WaitEqu2+1		; Ist der zweite Balken auf Null gefallen?
	bls.s	NonAbbass2			; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu2+1		; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu2b+1
	sub.b	d0,WaitEqu2c+1
NonAbbass2:
	tst.w	mt_chan2temp		; Stimme 2 nicht "gespielt"?
	beq.s	anal3				; Wenn nicht, springe zu Anal3
	clr.w	mt_chan2temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu2+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu2b+1
	move.b	#$a7,WaitEqu2c+1
anal3:
	cmp.b	#$07,WaitEqu3+1		; Ist der dritte Balken auf Null gefallen?
	bls.s	NonAbbass3			; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu3+1		; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu3b+1
	sub.b	d0,WaitEqu3c+1
NonAbbass3:
	tst.w	mt_chan3temp		; Stimme 3 nicht "gespielt"?
	beq.s	anal4				; Wenn nicht, springe zu Anal4
	clr.w	mt_chan3temp		; Zurücksetzen, um auf den nächsten Eintrag zu warten
	move.b	#$a7,WaitEqu3+1		; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu3b+1
	move.b	#$a7,WaitEqu3c+1
anal4:
	cmp.b	#$07,WaitEqu4+1		; Ist der vierte Balken auf Null gefallen?
	bls.s	NonAbbass4			; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu4+1		; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu4b+1
	sub.b	d0,WaitEqu4c+1
NonAbbass4:
	tst.w	mt_chan4temp		; Stimme 4 nicht "gespielt"?
	beq.s	analizerend			; wenn nicht, raus!
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
	dc.w	$ffdf,$fffe			; Warte auf Zeile $FF

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


; Musik. Achtung: Die "music.s"-Routine von Diskette 2 ist nicht dieselbe wie 
; die von Diskette 1. Die zwei Änderungen betreffen die Entfernung eines BUGs.
; Manchmal trat ein Guru beim Verlassen des Programms auf. Aufgrund, dass mt_data
; auf Musik zeigte, aber keine Musik war. 
; Dies ermöglicht es Ihnen, die Musik leichter zu ändern.

; Sie können einen der 4 Titel von der Diskete auswählen.

mt_data:
	dc.l	mt_data1

Mt_data1:
;	incbin	"/Sources/mod.fairlight"		; by d-zire/silents 92 (lungo solo 2k!)
	incbin	"/Sources/mod.fuck the bass"	; by m.c.m/remedy 91
;	incbin	"/Sources/mod.yellowcandy"	; by sire/supplex
;	incbin	"/Sources/mod.JamInexcess"	; by raiser/ram jam

	end

Sie können diese Quelle verwenden, um die 4 Protracker-Musikstücke von der
Diskette zu hören. Das "mod.fairlight" ist eine der "synthetischsten"
Musikarten überhaupt. Tatsächlich ist es nur 2374 Bytes lang, und wenn es mit
PowerPacker komprimiert wird ist es 952 Bytes lang!!!

