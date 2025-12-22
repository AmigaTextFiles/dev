
; Listing9h4.s		durch Scrollen nach rechts verschwindet ein Bild
		; durch Shift + BLTALWM Maske.
		; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Länge einer Bitplane !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse1:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1				; Wenn nicht, gehe zurück zu mouse1:

	bsr.s	Scorri				; Scroll-Routine ausführen

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:

	rts


;******************************************************************************
; Diese Routine lässt ein Bild nach und nach verschwinden
; durch Verschieben nach rechts
;******************************************************************************

;	     .----------.
;	     ¦          ¦
;	     |          |
;	     |          |
;	     | ¯¯¯  --- |
;	    _l___    ___|_
;	   /   _¬\  / _  ¬\
;	 _/   ( °/--\° )   \_
;	/¬\_____/¯¯¯¯\_____/¬\
;	\ ____(_,____,_)____ /
;	 \_\ `----------' /_/
;	   \\___      ___//
;	    \__`------'__/
;	      |  ¯¯¯¯  | xCz
;	      `--------'

Scorri:
	move.w	#160-1,d7			; Die Schleife muss für jedes Pixel einmal ausgeführt 
								; werden, da das Bild 160 Pixel breit ist (10 Wörter)

; In diesem Beispiel kopieren wir ein Bild auf sich selbst, aber verschieben 
; es kontinuierlich um ein Pixel, um es fließen zu lassen.
; Daher sind die Quell- und Zieladressen identisch

ScorriLoop:

; Warten, bis das vblank das Bild um jeweils ein Pixel verschoben hat

WaitWblank:
	CMP.b	#$ff,$dff006		; vhposr - warte auf die Zeile 255
	bne.s	WaitWblank
Aspetta:
	CMP.b	#$ff,$dff006		; vhposr - noch Zeile 255?
	beq.s	Aspetta

	move.l	#bitplane+((20*50)+64/16)*2,d0		; Adresse Quelle und Ziel
							
	moveq	#3-1,d5				; wiederhole es für jede Ebene
PlaneLoop:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$19f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
								; mit einer Ein-Pixel-Verschiebung

	move.l	#$ffffffffe,$44(a5)	; BLTAFWM und BLTALWM
								; BLTAFWM = $ffff - alles
								; BLTALWM = $fffe = %1111111111111110
								; lösche das letzte Bit

								; Lade die Zeiger
	move.l	d0,$50(a5)			; bltapt - Quelle
	move.l	d0,$54(a5)			; bltdpt - Ziel

; Die Werte werden wie üblich berechnet

	move.l	#$00140014,$64(a5)		; bltamod und bltdmod 
	move.w	#(20*64)+160/16,$58(a5)	; bltsize
								; Höhe 20 Zeilen
								; 160 Pixel breit (= 10 Wörter)

	add.l	#40*256,d0			; auf die nächste Ebene zeigen
	dbra	d5,PlaneLoop

	dbra	d7,ScorriLoop		; für alle Pixel wiederholen
						
	btst	#6,$02(a5)			; dmaconr - warte auf das Ende des Blitters
waitblit2:
	btst	#6,$02(a5)
	bne.s	waitblit2
	rts

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; WERT MODULO = 0
	dc.w	$10a,0				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

BITPLANE:
	incbin	"/Sources/amiga.raw"					
								; Hier laden wir die Figur ein					
								; mit KEFCON konvertiert.
	end

;****************************************************************************


In diesem Beispiel sehen wir einen neuen Effekt. Wir werden ein Bild vom 
Bildschirm verschwinden lassen, indem wir es nach rechts schieben und die
Pixel löschen, die in einer bestimmten horizontalen Position ankommen. Dieser
Effekt wird mit Hilfe des Blitters durch Kombination von Verschieben nach
rechts und Maskieren zusammen erreicht. 
Es wird natürlich durch die Verschiebung erreicht. Das Bild wird vom
Bildschirm über Kanal A (es ist nicht in einem anderen Puffer gespeichert) 
gelesen. Es wird um ein Pixel verschoben und an der gleichen Stelle auf dem 
Bildschirm neu gezeichnet.
Die Quelle und das Ziel stimmen genau überein. Die Maske des ersten Wortes
übergibt alle Bits. Die Maske des letzten Wortes stattdessen hat den Wert
%11111111.11111110 und löscht damit das rechte Bit.
Wenn wir diesen Trick nicht benutzen, kommen die Pixel aus dem Wort rechts
heraus und würden eine Zeile tiefer im linken Wort enthalten sein. (Wir haben
darüber während der Erklärung zum Shiften gesprochen). Weil wir einen 
verschachtelten Bildschirm benutzen, die untere Zeile gehört zu einer anderen
Ebene und wenn Pixel von einer Ebene zur nächsten verschoben werden, entsteht
Chaos. Versuchen Sie dies zu realisieren, indem Sie BLTALWM auf $ffff setzen.
Dank der Maske passiert das nicht, weil die Maske auf das letzte gelesene Wort
angewendet wird, bevor die Verschiebung erfolgt.
Dann wird das Bit, das rechts ausgehen würde, von der Maske zurückgesetzt.
Ein verschwommener Effekt der auf diese Weise bewirkt, dass die Figur nach
rechts mit einem Pixel scrollt.
Wiederhole den Blitt so oft wie die Anzahl der Pixel, aus denen er besteht.
Da das Bild in der Breite (in unserem Fall 160 ist) erhalten wir ein
vollständiges Verschwinden.
Es ist möglich, das Bild schneller mit einem Shift-Wert größer als 1 zu
scrollen. In diesem Fall müssen Sie jedoch auch die Maske ändern, so dass alle
Pixel gelöscht werden, die die Verschiebung hinterlassen würde.
Wenn Sie beispielsweise eine 4-Pixel-Verschiebung verwenden, muss die Maske
die 4 Pixel rechts löschen, denn sonst würden sie herauskommen. Da das Bild
schneller scrollt, ist es außerdem notwendig, die Routine einige Male zu
wiederholen um es vollständig verschwinden zu lassen.
Im Falle einer 4-Pixel-Verschiebung werden 160/4 = 40 Iterationen der Routine
benötigt.
Versuchen Sie, die Geschwindigkeit zu ändern, und probieren sie andere
Verschiebewerte aus, zum Beispiel 2,8 oder 3.

