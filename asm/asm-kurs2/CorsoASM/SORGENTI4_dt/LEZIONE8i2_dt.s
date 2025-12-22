
; Lezione8i2 - Einfacher zeitgesteuerter Equalizer mit der Musik Routine
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
	CMPI.L	D2,D0			; Warte auf Zeile = $130 (304)
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A5),D0		; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0			; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0			; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	bsr.w	mt_music		; spielt die Musik

	btst	#2,$dff016		; richtige Taste gedrückt?
	beq.s	Uscita			; Wenn ja, beenden

	bsr.s	Equalizzatori	; Einfache Equalizer-Routine

	btst	#6,$bfe001		; LMT gedrückt?
	bne.s	MainLoop		; Wenn "NEIN" wird erneut gestartet, ändert sich die Musik

	lea	musiche(PC),a0		; Tauschen Sie die Musik aus
	move.l	(a0),d0
	move.l	4(a0),d1
	move.l	4*2(a0),d2
	move.l	4*3(a0),d3
	move.l	d0,4(a0)
	move.l	d1,4*2(a0)
	move.l	d2,4*3(a0)
	move.l	d3,(a0)

	move.l	musiche(PC),mt_data	; Zeiger aktuelle Musik
	bsr.w	mt_init			; Setzen Sie die Musik zurück
SpettaLascia:
	btst	#6,$bfe001		; LMT immer gedrückt?
	beq.s	SpettaLascia	; warte bis es übrig ist
	bra.s	MainLoop

Uscita:
	bsr.w	mt_end			; Stoppen Sie die Musik Routine
	rts

; Tabelle mit Musik ... Adressen drehen und immer kopieren
; Zuerst können wir sie ändern ...

musiche:
	dc.l	mt_data1,mt_data2,mt_data3,mt_data4


; Hier ist die Equalizer-Routine, der Audio-Analysator. Als erstes ist
; zu wissen, wo man Informationen über die Verwendung der 4 Artikel der
; musikalischen Routine findet. Normalerweise wird es verwendet, um die Variable 
; der Wiederholungsroutine zu überprüfen, die uns signalisieren kann, wenn eine 
; Stimme zum Spielen aktiviert ist.
; ein Tool, normalerweise "mt_chanXtemp", wobei X 1,2,3 oder 4 sein kann.
; In dieser Version wird auch der Wert mit mt_chanXtemp verwendet
; zusätzlicher Analysator.

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
	move.b	EqualSpeed(PC),d0	; "drop" Geschwindigkeit der Balken in d0
	cmp.b	#$07,WaitEqu1+1		; Ist der erste Balken auf Null gefallen?
	bls.s	NonAbbass1			; wenn ja, nicht weiter absenken!
					; * bls bedeutet weniger oder gleich, es ist besser
					; Verwenden Sie es anstelle von beq, weil subtrahieren
					; mit d0 kann eine zu große nummer
					; Es kommt vor, dass Sie sich für $05 oder $03 entscheiden!
	sub.b	d0,WaitEqu1+1	; ansonsten senkt es die Latte, zusammengesetzt von
	sub.b	d0,WaitEqu1b+1	; zwei farbige Linien und eine schwarze
	sub.b	d0,WaitEqu1c+1
NonAbbass1:
	tst.w	mt_chan1temp	; Punkt 1 nicht "gespielt"?
	beq.s	anal2			; Wenn nicht, springe zu Anal2
	move.w	mt_chan1temp,COLORE1
	move.w	mt_chan1temp,COLORE1b
	and.w	#$f0,COLORE1	; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE1	; mindestens $30!
	and.w	#$0f,COLORE1b	; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE1b	; mindestens $03!
	clr.w	mt_chan1temp	; Zurücksetzen, um auf das nächste Schreiben zu warten
	move.b	#$a7,WaitEqu1+1	; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu1b+1
	move.b	#$a7,WaitEqu1c+1
anal2:
	cmp.b	#$07,WaitEqu2+1	; Ist der zweite Balken auf Null gefallen?
	bls.s	NonAbbass2		; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu2+1	; Ansonsten senken Sie die Messlatte
	sub.b	d0,WaitEqu2b+1
	sub.b	d0,WaitEqu2c+1
NonAbbass2:
	tst.w	mt_chan2temp	; Punkt 2 nicht "gespielt"?
	beq.s	anal3			; Wenn nicht, springe zu Anal3
	move.w	mt_chan2temp,COLORE2
	move.w	mt_chan2temp,COLORE2b
	and.w	#$f0,COLORE2	; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE2	; mindestens $30!
	and.w	#$0f,COLORE2b	; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE2b	; mindestens $03!
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
	move.w	mt_chan3temp,COLORE3
	move.w	mt_chan3temp,COLORE3b
	and.w	#$f0,COLORE3	; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE3	; mindestens $30!
	and.w	#$0f,COLORE3b	; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE3b	; mindestens $03!
	clr.w	mt_chan3temp	; Zurücksetzen, um auf das nächste Schreiben zu warten
	move.b	#$a7,WaitEqu3+1	; BAR BIS ZUM MAXIMUM!
	move.b	#$a7,WaitEqu3b+1
	move.b	#$a7,WaitEqu3c+1
anal4:
	cmp.b	#$07,WaitEqu4+1	; wird der vierte Balken auf Null abgesenkt?
	bls.s	NonAbbass4		; wenn ja, nicht weiter absenken!
	sub.b	d0,WaitEqu4+1	; Ansonsten senken Sie den Balken
	sub.b	d0,WaitEqu4b+1
	sub.b	d0,WaitEqu4c+1
NonAbbass4:
	tst.w	mt_chan4temp	; Punkt 4 nicht "gespielt"?
	beq.s	analizerend		; wenn nicht, raus!
	move.w	mt_chan4temp,COLORE4
	move.w	mt_chan4temp,COLORE4b
	and.w	#$f0,COLORE4	; Nur blaue Komponente auswählen
	ori.w	#$330,COLORE4	; mindestens $30!
	and.w	#$0f,COLORE4b	; Nur grüne Komponente auswählen
	ori.w	#$303,COLORE4b	; mindestens $03!
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

	dc.w	$4807,$fffe
	dc.w	$180,$ddd
	dc.w	$4a07,$fffe
	dc.w	$180,$777

	dc.w	$5007,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE1:
	dc.w	$060
	dc.w	$5507,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE2:
	dc.w	$060
	dc.w	$5a07,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE3:
	dc.w	$060
	dc.w	$5f07,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE4:
	dc.w	$060
	dc.w	$6407,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE1b:
	dc.w	$00e
	dc.w	$6907,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE2b:
	dc.w	$00e
	dc.w	$6e07,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE3b:
	dc.w	$00e
	dc.w	$7307,$fffe	; Warten Sie auf die Zeile
	dc.w	$180
COLORE4b:
	dc.w	$00e
	dc.w	$7807,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$777
	dc.w	$7e07,$fffe
	dc.w	$180,$333
	dc.w	$8007,$fffe
	dc.w	$180,$00e

	dc.w	$ffdf,$fffe	; Warten Sie auf die Zeile $FF

; wait & mode des Routineanalysators - Verwenden Sie die horizontale Position
; warte bis die Balken "vor" und "zurück" sind

	dc.w	$1507,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$00e	; color0 blau

	dc.w	$1607,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$f55	; color0 ROT - Farbe erste BAR
WaitEqu1:
	dc.w	$1617,$fffe	; wait (wird dann als Zeilenende geändert
				; es wird um 4 in 4 fallen, bis es zu $​​07 zurückkehrt)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1707,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$f55	; color0 ROT (Balken 2 Zeilen!)
WaitEqu1b:
	dc.w	$1717,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1807,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$002	; color0 SCHWARZ ("Schatten" unter dem ersten Balken)
WaitEqu1c:
	dc.w	$1817,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

; zweiter Balken

	dc.w	$1b07,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$a5f	; color0 VIOLETT (zweiter Balken)
WaitEqu2:
	dc.w	$1b17,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1c07,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$a5f	; color zweiter Balken (2 Zeilen!)
WaitEqu2b:
	dc.w	$1c17,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$1d07,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$002	; color0 schwarz ("Schatten")
WaitEqu2c:
	dc.w	$1d17,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

; dritter Balken

	dc.w	$2007,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$ff0	; color dritter Balken
WaitEqu3:
	dc.w	$2017,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2107,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$ff0	; color dritter Balken (2 Zeilen!)
WaitEqu3b:
	dc.w	$2117,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2207,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$002	; color0 schwarz ("Schatten")
WaitEqu3c:
	dc.w	$2217,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

; vierter Balken

	dc.w	$2507,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$5F0	; color vierter Balken
WaitEqu4:
	dc.w 	$2517,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2607,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$5F0	; color vierter Balken (2 Zeilen!)
WaitEqu4b:
	dc.w 	$2617,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau
	dc.w	$2707,$fffe	; Warten Sie auf die Zeile
	dc.w	$180,$002	; color0 schwarz ("Schatten")
WaitEqu4c:
	dc.w 	$2717,$fffe	; Warten (geändert für Taktlänge)
	dc.w	$180,$00e	; color0 blau

	DC.W	$FFFF,$FFFE	; Ende copperlist


; Musik - Sie können einen der 4 Titel von der Diskette auswählen.
; hier "verstehen" wir die Nützlichkeit der als Zeiger verwendeten mt_data.

mt_data:
	dc.l	mt_data1


mt_data1:
	incbin	"mod.fuck the bass"	; by m.c.m/remedy 91
mt_data2:
	incbin	"mod.yellowcandy"	; by sire/supplex
mt_data3:
	incbin	"mod.fairlight"		; by d-zire/silents 92 (lungo solo 2k!)
mt_data4:
	incbin	"mod.JamInexcess"	; by raiser/ram jam

	end
