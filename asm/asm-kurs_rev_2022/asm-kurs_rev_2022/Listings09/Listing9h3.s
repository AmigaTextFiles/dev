
; Listing9h3.s		Wir lassen ein Bild erscheinen
		; immer eine Pixelspalte gleichzeitig 
		; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne die; vor dem Speichern mit "WO"

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

	bsr.s	Mostra				; Routine ausführen

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:

	rts


; ************************ DIE ROUTINE, DIE DIE FIGUR ZEIGT *******************

;	     .øØØØØØø.
;	     |¤¯_ _¬¤|
;	    _|___ ___|_
;	   (_| (·T.) l_)
;	    /  ¯(_)¯  \
;	   /____ _ ____\
;	  //    Y Y    \\
;	 //__/\_____/\__\\ xCz
;	(_________________)

Mostra:
; Anfangswerte von Zeigern

	lea	picture,a0				; zeigt auf den Anfang der Figur
	lea	bitplane,a1				; zeigt auf den Anfang der ersten Bitebene

	moveq	#20-1,d7			; alle Wort- "Spalten" ausführen
								; Der Bildschirm ist 20 Wörter breit
								; Es gibt 20 Spalten.

FaiTutteLeWord:
	moveq	#16-1,d6			; 16 Pixel für jedes Wort.
	move.w	#%1000000000000000,d0	; Wert der Maske am Anfang von
								; interner Schleife. Wir übergeben nur das
								; Pixel ganz links vom Wort.
FaiUnaWord:
; warte auf Vblank, um jeweils eine Pixelspalte pro Frame zu zeichnen

WaitWblank:
	CMP.b	#$ff,$dff006		; vhposr - warte auf die Zeile 255
	bne.s	WaitWblank
Aspetta:
	CMP.b	#$ff,$dff006		; vhposr - noch Zeile 255 ?
	beq.s	Aspetta

	moveq	#3-1,d5				; wiederhole es für jede Ebene

	move.l	a0,a2				; Kopiere die Zeiger auf 2 andere Register
	move.l	a1,a3				; Dies liegt an der inneren Schleife
								; das zeichnet die verschiedenen Ebenen
								; Wechsel von einer Bitplane zur anderen 
								; Ziel.

FaiUnPlane:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
waitblit:
	btst	#6,2(a5)
	bne.s	waitblit

	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 - Kopie von A nach D
	move.w	#$ffff,$44(a5)		; BLTAFWM - alle Bits übergeben
	move.w	d0,$46(a5)			; Wert der Maske in das BLTALWM Register laden

								; Lade die Zeiger
	move.l	a2,$50(a5)			; bltapt
	move.l	a3,$54(a5)			; bltdpt

; Sowohl für die Quelle als auch für das Ziel blitten wir ein Wort auf einen 
; 20 Wörter breiten Bildschirm. Also hat das Modulo den Wert 2 * (20-1) = 38 = $26.
; Da die 2 Register aufeinanderfolgende Adressen haben, braucht man nur eine
; Anweisung anstatt 2 zu verwenden:

	move.l #$00260026,$64(a5)	; bltamod und bltdmod 

; wir blitten ein 256 Zeilen hohes Wort "Spalte" (den ganzen Bildschirm)

	move.w	#(256*64)+1,$58(a5)	; bltsize
								; 256 Zeilen Höhe
								; 1 Wortbreite

	lea	40*256(a2),a2			; zeigt auf die nächste Quellenebene
	lea	40*256(a3),a3			; zeigt auf die nächste Zielebene

	dbra	d5,FaiUnPlane		; für alle Ebenen wiederholen

	asr.w	#1,d0				; die Maske für den nächsten Blitt vorbereiten

	dbra	d6,FaiUnaWord		; für alle Pixel wiederholen 
	
	addq.w	#2,a0				; auf das nächste Wort zeigen
	addq.w	#2,a1				; auf das nächste Wort zeigen
	
	dbra	d7,FaiTutteLeWord	; für alle Wörter wiederholen 

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
	dc.w	$e0,$0000,$e2,$0000	; erste	 bitplane
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

PICTURE:
	incbin	"/Sources/amiga.raw"
								; Hier laden wir die Figur ein			
								; mit KEFCON konvertiert.

;****************************************************************************

	section	gnippi,bss_C

bitplane:
		ds.b	40*256			; 3 bitplanes
		ds.b	40*256
		ds.b	40*256
	end

;****************************************************************************

In diesem Beispiel sehen wir einen neuen Effekt dank einer Maske. Wir 
zeichnen ein Bild auf dem Bildschirm immer eine Spalte von Pixeln zu einem
Zeitpunkt beginnend von links. In der Praxis müssen wir vom Bild immer eine 
"Spalte" von Pixeln zu einer Zeit auf dem Bildschirm kopieren. Die minimale 
Breite eines Blitts ist jedoch ein Wort, d.h. 16 Pixel. Wenn wir also 
einfache Kopien machen, könnten wir nur Gruppen von 16 Pixeln kopieren. Zum
Glück gibt es jedoch Masken. Indem man ein Wort breit blittet, gelten beide
Masken für den Blitt. Für uns reicht jedoch eine, zum Beispiel BLTALWM 
(Es wäre aber das Gleiche, wenn wir BLTAFWM verwenden.)
Der Trick ist folgender:
Wir kopieren die gleiche Spalte von 1 Wort 16 Mal, jedes Mal an der gleichen 
Stelle des Bildschirms und jedes Mal ändern wir die Maske, um eine zusätzliche
Pixelspalte zu zeigen.
In der Praxis machen wir die Kopie zum ersten Mal mit der Maske die den Wert
%10000000.00000000 hat, um nur die erste Pixelspalte anzuzeigen.
Der zweite Blitt befindet sich dann in derselben Position wie der vorherige
überschreibt aber, was wir beim ersten Mal gezeichnet haben. Als Maske benutzen 
wir den Wert %11000000.00000000. Sie sehen also nur die ersten beiden Spalten
von Pixeln. Das dritte Mal benutzen wir als Maske %11100000.00000000 und 
zeichnen die ersten 3 Spalten von Pixeln und so weiter. Das 16. Mal benutzen 
wir als Maske %11111111.11111111, um alle 16 Pixelspalten zu zeichnen, die die
Wortspalte ausmachen. 
An diesem Punkt Zeichnen wir wieder vom Anfang. Also verschieben wir die erste
Pixelspalte zur nächsten Wortspalte, ein Wort nach rechts, sowohl in der Quelle
als auch im Ziel und beginnen mit der Maske mit dem Wert %10000000.00000000 von
vorne. Weil unsere Blitts nur ein Wort breit sind, werden die vorherigen 
Wortspalten nicht überschrieben. Deshalb bleiben sie gezeichnet.
Beachten Sie, wie sie die Maskenwerte erhalten. Am Anfang setzen sie den 
Startwert (%10000000.00000000) in das Register D0. Dieses Register wird nach
BLTALWM kopiert, so dass der erste Blitt nur in der ersten Pixelspalte passiert.
Nach dem Blitt wird ein ASR #1,D0 ausgeführt. Wie Sie wissen, verschiebt diese
Anweisung den Inhalt des Registers D0 nach rechts. Außerdem (im Gegensatz zu
LSR) bewahrt es das Zeichen, das Bit ganz links (das ist das Vorzeichenbit) bei
der Verschiebung. In diesem Fall ist das Vorzeichenbit 1, also kommt ganz links
eine 1. Auf diese Weise nimmt das Register D0 den Wert %11000000.00000000 an.
Dieser Wert wird als eine Maske für den zweiten Blitt verwendet und dann wird
der nächste ASR durchgeführt was D0 auf den Wert %11100000.00000000 bringt.
Dieser Vorgang wird wiederholt. Bei jeder Iteration werden alle Werte der Maske 
generiert. Weitere Erläuterungen zu ASR finden Sie in der Lektion 68000-2.TXT.

