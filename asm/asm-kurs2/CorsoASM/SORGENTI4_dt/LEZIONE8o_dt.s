
; Lezione8o.s	8 hohe Balken mit jeweils 13 * 2 Zeilen, die abprallen.
; Klicken Sie mit der rechten Maustaste, um die Hintergrundbereinigung zu deaktivieren.

	SECTION	Barre,CODE

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
	BSR.s	INITCOPPER		; Erstellen Sie die copperliste mit einer Routine

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2	; Warte auf Zeile = $108
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $108
	BNE.S	Waity1

	btst	#2,$16(a5)	; Rechte Maustaste gedrückt?
	beq.s	SaltaPulizia	; Wenn Sie nicht "putzen"

	BSR.s	CLRCOPPER	; Copperhintergrund "säubern"

SaltaPulizia:
	BSR.s	DOBARS		; Mach die BAR

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse

	rts

*************************************************************************
*	BARRE COL COPPER - istruzioni:					*
*									*
*	BSR.s INITCOPPER ; vor dem Setzen der Copperlist für * durchführen
*					 ; erstelle die copperlist (aus WAIT und COLOR0) *
*									*
*	BSR.s CLRCOPPER	 ; ausführen um alte Balken zu löschen *
*					 ; "Schwärzen" aller FARBEN0 der copperrlist *
*					 ; HINWEIS: Sie können die Hintergrundfarbe ändern *
*					 ; auf das Gleichgewicht einwirken BACKGROUND = $xxx *
*									*
*	BSR.s DOBARS	 ; Anzeigen der Balken durch Aufrufen von PUTBARS *
*									*
*************************************************************************

coplines	=	100 	; Anzahl der zu erledigenden copperlistenzeilen
						; die Wirkung der Bars.
SFONDO		=	$004	; Color des "Hintergrunds"


;	    /¯¯¯¯¯¯¯¯¯¯\
;	  .~            ~.
;	  | ·     \/   : |
;	  | |_____||___| |
;	.--./ ___ \/ __\.-.
;	|~\/ ( o~\></o~)\~|
;	`c(   ¯¯¯_/ \¯¯  )'
;	  /\    ( ( )¯) /\
;	 /  .'___~\_/~___ \
;	 \   {IIIII[]II:· /
;	  \   \::.   //  /
;	   \  \::::.//  /
;	    \  \\IIII]_/
;	     \   ¯¯¯¯  )
;	      \  ¯¯¯¯¯/
;	       ¯~~~~¯¯

; INITCOPPER Erstellen Sie die copperliste mit viel WAIT und COLOR0 unten

INITCOPPER:
	lea	barcopper,a0		; Adresse, an der die copperlistdas erstellt werden soll 
	move.l	#$3001fffe,d1	; erstes wait: Zeile $30 - WAIT in d1
	move.l	#$01800000,d2	; COLOR0 in d2
	move.w  #coplines-1,d0	; Anzahl der Zeilen copper
initloop:
	move.l	d1,(a0)+		; leg das WAIT
	move.l	d2,(a0)+		; leg das COLOR0
	add.l	#$02000000,d1	; nächstes Mal warten, 2 Zeilen tiefer warten
	dbra	d0,initloop
	rts

; CLRCOPPER es "reinigt" den coppereffekt und macht jeden SCHWARZ
; die Werte von COLOR0 in der copperlist (bzw. der HINTERGRUND Farbe)

CLRCOPPER:
	lea	barcopper,a0		; Adresse WAIT/COLOR0 in copperlist
	move.w	#coplines-1,d0	; Anzahl Zeilen
	MOVE.W	#SFONDO,d1		; RGB-Hintergrundfarbe
clrloop:
	move.w	d1,6(a0)		; Ändern Sie dies Color 0
	addq.w	#8,a0			; nächste Color0 in copperlist
	dbra 	d0,clrloop
	rts

; DOBARS führt das "Gleiten" der farbigen Balken nacheinander durch,
; Aufrufen des Unterprogramms PUTBAR für jeden Balken

DOBARS:
	lea	bar1(PC),a0
	move.l	barpos1(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos1
	lea	bar2(PC),a0
	move.l	barpos2(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos2
	lea	bar3(PC),a0
	move.l	barpos3(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos3
	lea	bar4(PC),a0
	move.l	barpos4(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos4
	lea	bar5(PC),a0
	move.l	barpos5(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos5
	lea	bar6(PC),a0
	move.l	barpos6(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos6
	lea	bar7(PC),a0
	move.l	barpos7(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos7
	lea	bar8(PC),a0
	move.l	barpos8(PC),d0
	bsr.s	putbar
	move.l 	d0,barpos8
	rts

;	Unterroutine, Eingang:
;	a0 = Adresse BARx, Das sind die Farben der Bars
;	d0 = Lage BARx

putbar:	
	lsl.l	#1,d0		; Verschiebt die Barpos um 1 Bit nach links
	lea	poslist(PC),a1	; Adresstabelle mit Positionen in a1
	add.l	d0,a1		; summiere barpos zu a1 und finde das richtige
						; Positionswert in der Liste
	cmp.b	#$ff,(a1)	; sind wir am letzten poslist wert ??
	bne.s	putbar1		; wenn nicht, fang nicht wieder von vorne an
	moveq	#0,d0
	lea	poslist,a1		; wenn ja, fange von vorne an
putbar1:
	moveq	#0,d2
	move.b	(a1),d2		; Wert aus der POSLIST-Tabelle
	lsl.l	#3,d2		; Verschieben wir nach links um 3 Bit (Multipl.*8)
	lea	barcopper,a2	; Adresse Bar in copperlist
	add.l	d2,a2		; großer Wert aus der Liste genommen und
						; multipliziert mit 8, dh in a2 gefunden
						; die adresse der richtigen warte wo sie sein soll
						; meine Bar
	moveq	#13-1,d4	; Jeder Balken ist 14 Zeilen hoch
putloop:
	move.w	(a0)+,6(a2)	; Ich kopiere die Farbe des Balkens von BARx nach
						; dc.w $180,xxx in copperlist
	addq.w	#8,a2		; Ich gehe zum nächsten Wert von color0
	dbra	d4,putloop	; und 14-mal wiederholen, um die gesamte Leiste zu erstellen

	lsr.l	#1,d0		; Tragen Sie die Barpos rechts von 1 Bit
	addq.l	#1,d0		; und addiere 1 für den nächsten Zyklus.
	rts


; Dies sind die Positionen der Balken relativ zueinander. Wie du siehst
; werden sie nacheinander platziert und folgen in dieser Reihenfolge einander.

barpos1:	dc.l 0
barpos2:	dc.l 4
barpos3:	dc.l 8
barpos4:	dc.l 12
barpos5:	dc.l 16
barpos6:	dc.l 20
barpos7:	dc.l 24
barpos8:	dc.l 28


; Dies sind die 8 Balken, dh die 13 RGB-Farben, aus denen sie sich jeweils 
; zusammensetzt. Beispiel: Bar1 ist BLAU, Bar2 ist GRAU usw.

; color:  RGB, RGB, RGB, RGB, RGB, RGB, RGB, RGB, RGB, RGB, RGB, RGB, RGB
bar1:
	DC.W $002,$004,$006,$008,$00a,$00c,$00f,$00c,$00a,$008,$006,$004,$002
bar2:
	DC.W $222,$444,$666,$888,$aaa,$ccc,$fff,$ccc,$aaa,$888,$666,$444,$222
bar3:
	DC.W $200,$400,$600,$800,$a00,$c00,$f00,$c00,$a00,$800,$600,$400,$200
bar4:
	DC.W $020,$040,$060,$080,$0a0,$0c0,$0f0,$0c0,$0a0,$080,$060,$040,$020
bar5:
	DC.W $012,$024,$036,$048,$05a,$06c,$07f,$06c,$05a,$048,$036,$024,$012
bar6:
	DC.W $202,$404,$606,$808,$a0a,$c0c,$f0f,$c0c,$a0a,$808,$606,$404,$202
bar7:
	DC.W $210,$420,$630,$840,$a50,$c60,$f70,$c80,$a70,$860,$650,$440,$230
bar8:
	DC.W $220,$440,$660,$880,$aa0,$cc0,$ff0,$cc0,$aa0,$880,$660,$440,$220



; Dies ist die Tabelle (oder Liste) der vertikalen Positionen, die möglich 
; sind. Nimm die farbigen Balken an. endet mit dem Wert $FF.
; als Hinweis wird diese Tabelle von "IS" mit diesen Parametern erstellt:
; BEG>0
; END>180
; AMOUNT>150
; AMPLITUDE>85
; YOFFSET>0
; SIZE (B/W/L)>B
; MULTIPLIER>1

poslist:
	DC.B	$01,$03,$04,$06,$08,$0A,$0C,$0D,$0F,$11,$13,$14,$16,$18,$19,$1B
	DC.B	$1D,$1E,$20,$22,$23,$25,$27,$28,$2A,$2B,$2D,$2E,$30,$31,$33,$34
	DC.B	$35,$37,$38,$3A,$3B,$3C,$3D,$3F,$40,$41,$42,$43,$44,$45,$46,$47
	DC.B	$48,$49,$4A,$4B,$4C,$4D,$4D,$4E,$4F,$4F,$50,$51,$51,$52,$52,$53
	DC.B	$53,$53,$54,$54,$54,$54,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
	DC.B	$54,$54,$54,$54,$53,$53,$53,$52,$52,$51,$51,$50,$4F,$4F,$4E,$4D
	DC.B	$4D,$4C,$4B,$4A,$49,$48,$47,$46,$45,$44,$43,$42,$41,$40,$3F,$3D
	DC.B	$3C,$3B,$3A,$38,$37,$35,$34,$33,$31,$30,$2E,$2D,$2B,$2A,$28,$27
	DC.B	$25,$23,$22,$20,$1E,$1D,$1B,$19,$18,$16,$14,$13,$11,$0F,$0D,$0C
	DC.B	$0A,$08,$06,$04,$03,$01

	DC.b	$FF	; Ende Tabelle

	even

*************************************************************************
;	Copperlist
*************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
	dc.w	$100,$200	; 0 bitplanes

barcopper:					; Hier wird die copperliste erstellt
	dcb.w	coplines*4,0	; die Wirkung der Balken - in diesem Fall
							; Es werden 400 Wörter benötigt. (Coplines = 100)

	DC.W	$ffdf,$fffe
	dc.w	$0107,$FFFE
	dc.w	$180,$222	; Color0 grau

	dc.w	$FFFF,$FFFE	; Ende copperlist

	end

Dieses Listing zeigt, wie Sie lange copperlisten "erstellen" können, aber
mit Routinen. Später werden wir sehen, wie die Auswirkungen größer sind
spektakuläre versteckte Copperliste lange Kilometer.

Vorgeschlagene Änderungen: Warten Sie, um das Ganze noch "zerdrückter" zu machen
jede Zeile und nicht alle zwei Zeilen. Ändern Sie einfach INITCOPPER:

	add.l	#$01000000,d1	; nächstes wait, warte 1 Zeile tiefer

Jetzt sind die Balken 13 Zeilen hoch und nicht 13 * 2 Zeilen!
Sie können auch alle 3 Zeilen warten, aber dadurch gehen Sie zu weit
runter, aber versuchen Sie es:

	add.l	#$03000000,d1	; Warten Sie das nächste Mal drei Zeilen tiefer

