
; Lezione8i - Einfacher zeitgesteuerter Equalizer mit der Musik Routine
			; - RECHTE TASTE, um die Geschwindigkeit der Balken zu ändern

	SECTION	MAINPROGRAM,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist Etc.
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
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#MyCopList,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

	bsr.w	mt_init			; Initialisieren Sie die Musik Routine

MainLoop:
	MOVE.L	#$1ff00,d1		; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2		; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0		; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0			; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0			; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	mt_music		; spielt die Musik

	btst	#2,$dff016		; richtige Taste gedrückt?
	beq.s	VaiForte
	move.b	#2,EqualSpeed	; Abnahmegeschwindigkeit = 2 Pixel pro Bild
	bra.s	VaiPiano
Vaiforte:
	move.b	#8,EqualSpeed	; Abnahmegeschwindigkeit = 8 Pixel pro Bild
VaiPiano:

	bsr.s	Equalizzatori	; Einfache Equalizer-Routine

	MOVE.L	#$1ff00,d1		; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2		; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0		; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0			; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0			; Warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001		; LMT gedrückt?
	bne.s	MainLoop		; Wenn "NEIN" erneut starten

	bsr.w	mt_end			; Stoppen Sie die Musik Routine
	rts


; Hier ist die Equalizer-Routine, der Audio-Analysator. Als erstes ist
; zu wissen, wo man Informationen über die Verwendung der 4 Artikel der 
; Musik Routine findet. Normalerweise wird es verwendet, um die Variable der 
; Wiederholungsroutine zu überprüfen, die uns signalisieren kann, wenn eine Stimme 
; zum Spielen aktiviert ist, ein Tool, normalerweise "mt_chanXtemp", wobei X 1,2,3 oder
; 4 sein kann. Aber dieses System ist keine Perfektion, da wir nur wissen können
; wenn "die Verwendung eines der 4 Elemente kommuniziert" , also wenn zum Beispiel
; ein Instrument gespielt wird, das 10 Sekunden lang weiter spielt.
; Der Balken dieser Stimme reicht bis zur ersten Sekunde und signalisiert den Gebrauch
; dieser Stimme in diesem Moment, aber dann wird er leiser und ruhig bleiben
; bis diese Stimme verwendet wird, um ein anderes Instrument zu spielen.
; Wenn eine Stimme für kurze Töne wie Schlagzeug verwendet wird, beachten Sie dies nicht
; getan, da zum Zeitpunkt der BUM! Die Messlatte steigt und wenn es runter geht
; wieder ist der Ton fertig oder geht zu Ende. Das Problem wird tragisch
; wenn Sie ein Werkzeug verwenden möchten, das die "Schleife" macht, zum Beispiel die Stimmen,
; der Balken macht also nur einen "Sprung", dann bleibt er während der Schleife unten.
; Dieses System ist dasselbe wie die Balken auf den 4 alten Spuren
; Soundtracker und Protracker bis Version 2. Für Type Equalizer
; von dem protracker 3, der dem "volumen" der stimmen getreuer folgt, ist es notwendig
; ändern Sie die musikalische Routine selbst, das gleiche gilt für die Equalizer
; die die Wellenform anzeigen. Mach einfach eine "tst.w mt_chanXtemp" und bei ja
; kann man dementsprechend handeln. In diesem Fall sind die Balken mit dem copper gemacht,
; mit der horizontalen Position der copperlist warten.
; Auf diese Weise verwenden wir nur die Hintergrundfarbe $dff180 ohne Bitebenen.
; Warten Sie einfach auf den Anfang der Zeile, geben Sie die Farbe des Balkens ein und dann
; Warten Sie, bis eine weiter fortgeschrittene horizontale Position erreicht ist, aber
; ersetzen Sie in der gleichen Zeile die Hintergrundfarbe. Auf diesem Weg, wenn 
; wir also auf dieses Warten reagieren, "bewegen" wir den Balken vorwärts und rückwärts.
; Wir haben es in Lezione3g.s und Lezione3h.s gesehen.
; Die Routine in der Praxis sieht so aus: Jeder Frame lässt die Balken fallen, bis
; sie nicht zurückgesetzt werden . Wenn also keine Musik vorhanden ist, bleiben sie bei 
; Null. In dem Fall, wenn dass das tt des mt_chanXtemp ein in dieser Stimme
; gespieltes Sample signalisiert, wird der Maximalwert des Balkens, dh $a7 gesetzt.
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
	move.b	EqualSpeed(PC),d0	; "drop" Geschwindigkeit der Balken in d0
	cmp.b	#$07,WaitEqu1+1		; Ist der erste Balken auf Null gefallen?
	bls.s	NonAbbass1			; wenn ja, nicht weiter absenken!
				; * bls bedeutet weniger oder gleich, es ist besser
				; Verwenden Sie es anstelle von beq, weil subtrahieren
				; mit d0 kann eine zu große nummer
				; Es kommt vor, dass Sie sich für $05 oder $03 entscheiden!
	sub.b	d0,WaitEqu1+1	; ansonsten senkt es die Balken, zusammengesetzt aus
	sub.b	d0,WaitEqu1b+1	; zwei farbigen Linien und einer schwarzen
	sub.b	d0,WaitEqu1c+1
NonAbbass1:
	tst.w	mt_chan1temp	; Punkt 1 nicht "gespielt"?
	beq.s	anal2			; Wenn nicht, springe zu Anal2
	clr.w	mt_chan1temp	; Zurücksetzen, um auf das nächste Schreiben zu warten
	move.b	#$a7,WaitEqu1+1	; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu1b+1
	move.b	#$a7,WaitEqu1c+1
anal2:
	cmp.b	#$07,WaitEqu2+1	; Ist der zweite Balken auf Null gefallen?
	bls.s	NonAbbass2		; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu2+1	; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu2b+1
	sub.b	d0,WaitEqu2c+1
NonAbbass2:
	tst.w	mt_chan2temp	; Punkt 2 nicht "gespielt"?
	beq.s	anal3			; Wenn nicht, springe zu Anal3
	clr.w	mt_chan2temp	; Zurücksetzen, um auf das nächste Schreiben zu warten
	move.b	#$a7,WaitEqu2+1	; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu2b+1
	move.b	#$a7,WaitEqu2c+1
anal3:
	cmp.b	#$07,WaitEqu3+1	; Ist der dritte Balken auf Null gefallen?
	bls.s	NonAbbass3		; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu3+1	; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu3b+1
	sub.b	d0,WaitEqu3c+1
NonAbbass3:
	tst.w	mt_chan3temp	; Punkt 3 nicht "gespielt"?
	beq.s	anal4			; Wenn nicht, springe zu Anal4
	clr.w	mt_chan3temp	; Zurücksetzen, um auf das nächste Schreiben zu warten
	move.b	#$a7,WaitEqu3+1	; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu3b+1
	move.b	#$a7,WaitEqu3c+1
anal4:
	cmp.b	#$07,WaitEqu4+1	; Ist der vierte Balken auf Null gefallen?
	bls.s	NonAbbass4		; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu4+1	; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu4b+1
	sub.b	d0,WaitEqu4c+1
NonAbbass4:
	tst.w	mt_chan4temp	; Punkt 4 nicht "gespielt"?
	beq.s	analizerend		; wenn nicht, raus!
	clr.w 	mt_chan4temp	; Zurücksetzen, um auf das nächste Schreiben zu warten
	move.b	#$a7,WaitEqu4+1	; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu4b+1
	move.b	#$a7,WaitEqu4c+1
analizerend:
	rts

EqualSpeed:
	dc.b	4
	even

*******************************************************************************
;	ROUTINE MUSIK

	include	"music.s"
*******************************************************************************

	Section	DatiChippy,data_C

MyCopList:
	dc.w	$100,$200	; Bplcon0 - keine bitplanes
	dc.w	$180,$00e	; color0 blau
	dc.w	$ffdf,$fffe	; Warte auf Zeile $FF

; wait & mode des Routineanalysators - Verwenden Sie die horizontale Position
; warte bis die Balken "vor" und "zurück" sind

	dc.w	$1507,$fffe	; Warten auf die Startzeile
	dc.w	$180,$00e	; color0 blau

	dc.w	$1607,$fffe	; Warten auf die Startzeile
	dc.w	$180,$f55	; color0 rot - colore erste BAR
WaitEqu1:
	dc.w	$1617,$fffe	; wait (wird dann als Zeilenende geändert
						; es wird um 4 in 4 fallen, bis es zu $07 zurückkehrt)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1707,$fffe	; Warten auf die Startzeile
	dc.w	$180,$f55	; color0 rot (Balken 2 Zeilen hoch!)
WaitEqu1b:
	dc.w	$1717,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1807,$fffe	; Warten auf die Startzeile
	dc.w	$180,$002	; color0 BLACK ("shadow" unter dem ersten Balken)
WaitEqu1c:
	dc.w	$1817,$fffe	; wait (modifiziert für Stablänge)
	dc.w	$180,$00e	; color0 blau

; zweite Bar

	dc.w	$1b07,$fffe	; Warten auf die Startzeile
	dc.w	$180,$a5f	; color0 lila (zweiter Balken)
WaitEqu2:
	dc.w	$1b17,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1c07,$fffe	; Warten auf die Startzeile
	dc.w	$180,$a5f	; ZWEITE LEISTE Farbe (2 Zeilen hoch!)
WaitEqu2b:
	dc.w	$1c17,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1d07,$fffe	; Warten auf die Startzeile
	dc.w	$180,$002	; color0 schwarz ("Schatten")
WaitEqu2c:
	dc.w	$1d17,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

; dritte Bar

	dc.w	$2007,$fffe	; Warten auf die Startzeile
	dc.w	$180,$ff0	; colore DRITTER STAB
WaitEqu3:
	dc.w	$2017,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2107,$fffe	; Warten auf die Startzeile
	dc.w	$180,$ff0	; colore DRITTER STAB (2 Zeilen hoch!)
WaitEqu3b:
	dc.w	$2117,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2207,$fffe	; Warten auf die Startzeile
	dc.w	$180,$002	; color0 schwarz ("Schatten")
WaitEqu3c:
	dc.w	$2217,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

; vierte Bar

	dc.w	$2507,$fffe	; Warten auf die Startzeile
	dc.w	$180,$5F0	; color VIERTE BAR
WaitEqu4:
	dc.w 	$2517,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2607,$fffe	; Warten auf die Startzeile
	dc.w	$180,$5F0	; colore VIERTE BAR (2 Zeilen hoch!)
WaitEqu4b:
	dc.w 	$2617,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2707,$fffe	; Warten auf die Startzeile
	dc.w	$180,$002	; color0 schwarz ("Schatten")
WaitEqu4c:
	dc.w 	$2717,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

	DC.W	$FFFF,$FFFE	; Ende copperlist


; Musik. Achtung: Die "music.s" -Routine von Diskette 2 ist nicht dieselbe wie 
; Die beiden Änderungen betreffen die Entfernung eines BUG.
; Manchmal trat ein Guru beim Verlassen des Programms auf. Aufgrund, dass mt_data
; ein Hinweis auf Musik, aber nicht Musik war. 
; Dies ermöglicht es Ihnen, die Musik leichter zu ändern.

; Sie können einen der 4 Titel von der Diskete auswählen.

mt_data:
	dc.l	mt_data1

Mt_data1:
;	incbin	"mod.fairlight"		; by d-zire/silents 92 (lungo solo 2k!)
	incbin	"mod.fuck the bass"	; by m.c.m/remedy 91
;	incbin	"mod.yellowcandy"	; by sire/supplex
;	incbin	"mod.JamInexcess"	; by raiser/ram jam

	end

Sie können diese Quelle verwenden, um die 4 Protracker-Songs von der Diskette zu hören.
Das "mod.fairlight" ist eine der "synthetischsten" Musikarten. In der Tat ist es nur
2374 Bytes lang, und wenn es mit PowerPacker komprimiert wird ist es 952 Bytes lang!!!

