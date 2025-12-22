
; Listing9n2.s		Immer noch Scrolltext !! Der im Intro von Diskette 1!
				; Linke Taste zum Beenden.

	Section	BigScroll,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen
; werden sollen

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA

START:
	MOVE.L	#BITPLANE+100*44,d0	; Zeiger auf die Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitebenen (hier sind 3)
POINTB:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addi.l	#44*256,d0			; + Länge einer Bitplane !!!!!
	addq.w	#8,a1
	dbra	d1,POINTB

	bsr.s	makecolors			; Wirkung in der Copperliste

	lea	$dff000,a6				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a6)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a6)	; Zeiger COP
	move.w	d0,$88(a6)			; Start COP
	move.w	#0,$1fc(a6)			; AGA deaktivieren
	move.w	#$c00,$106(a6)		; AGA deaktivieren
	move.w	#$11,$10c(a6)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf die Zeile $130 (304)
Waity1:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf die Zeile $130 (304)
	BNE.S	Waity1

	bsr.w	MainScroll			; Scrollroutine 

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:
	rts

;*****************************************************************************
; Diese Routine erzeugt einen Farbton in der Copperliste
; In der Praxis gibt es den leeren Raum in der Copperliste, der wird
; mit dieser Routine gefüllt, der die richtigen Copperanweisungen setzt.
; Wir werden viele dieser Routinen in Lektion 11 sehen
;*****************************************************************************

MAKECOLORS:
	lea	scol,a0					; Adresse, an der die Copperliste geändert werden soll
	lea	coltab,a1				; Color Tabelle 1
	lea	coltab2,a2				; Color Tabelle 2
	move.l	#$a807,d1			; Startzeilex = $A0
	moveq	#63,d0				; Anzahl der Zeilen
col1:
	move.w	d1,(a0)+			; erstellt eine WAIT-Anweisung
	move.w	#$fffe,(a0)+

	move.w	#$0182,(a0)+		; Modifikationsanweisung COLOR01
	move.w	(a1)+,(a0)+
	move.w	#$018E,(a0)+		; Modifikationsanweisung COLOR07
	move.w	(a2)+,(a0)+

	add.w	#$100,d1			; nächste Zeile
	dbra	d0,col1
	rts

coltab:
	 dc.w	$00,$11,$22,$33,$44,$55,$66,$77,$88,$99
	 dc.w	$aa,$bb,$cc,$dd,$ee,$ff,$ff,$ee,$dd,$cc
	 dc.w	$bb,$aa,$99,$88,$77,$66,$55,$44,$33,$22
	 dc.w	$11,$00
	 dc.w	$000,$110,$220,$330,$440,$550,$660,$770,$880,$990
	 dc.w	$aa0,$bb0,$cc0,$dd0,$ee0,$ff0,$ff0,$ee0,$dd0,$cc0
	 dc.w	$bb0,$aa0,$990,$880,$770,$660,$550,$440,$330,$220
	 dc.w	$110,$000
	 dc.w	$000,$101,$202,$303,$404,$505,$606,$707,$808,$909
	 dc.w	$a0a,$b0b,$c0c,$d0d,$e0e,$f0f,$f0f,$e0e,$d0d,$c0c
	 dc.w	$b0b,$a0a,$909,$808,$707,$606,$505,$404,$303,$202
	 dc.w	$101,$000,0,0

coltab2:
	 dc.w	$000,$101,$202,$303,$404,$505,$606,$707,$808,$909
	 dc.w	$a0a,$b0b,$c0c,$d0d,$e0e,$f0f,$f0f,$e0e,$d0d,$c0c
	 dc.w	$b0b,$a0a,$909,$808,$707,$606,$505,$404,$303,$202
	 dc.w	$101,$000,0,0
	 dc.w	$000,$011,$022,$033,$044,$055,$066,$077,$088,$099
	 dc.w	$0aa,$0bb,$0cc,$0dd,$0ee,$0ff,$0ff,$0ee,$0dd,$0cc
	 dc.w	$0bb,$0aa,$099,$088,$077,$066,$055,$044,$033,$022
	 dc.w	$011,$000
	 dc.w	$000,$110,$220,$330,$440,$550,$660,$770,$880,$990
	 dc.w	$aa0,$bb0,$cc0,$dd0,$ee0,$ff0,$ff0,$ee0,$dd0,$cc0
	 dc.w	$bb0,$aa0,$990,$880,$770,$660,$550,$440,$330,$220
	 dc.w	$110,$000


;*****************************************************************************
; 		Hauptaufgabe SCROLLTEXT
;*****************************************************************************

MainScroll:
	lea	$dff000,a6
	;btst.b	#10,$16(a6)			; rechte Maustaste gedrückt?
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	beq.s	SaltaScroll			; Wenn ja, die Schrift vertikal verschieben
								; ohne zu scrollen
								; (folgende Zeilen wurden vom Übersetzer auskommmentiert
								; da der Scrollzähler in diesem Programm immer gleich ist)
	;move.l	noscroll(pc),d0		; Scrollzähler laden (hier immer 0)		
	;subq.l	#1,d0				; Zähler -1
	;bmi.s	do_scrolling		; wenn es negativ ist, scrollt es
	;move.l	d0,noscroll			; Scrollzähler speichern
	;bra.s	SaltaScroll			; ansonsten die Schrift nur vertikal verschieben

do_scrolling:					; Scrolleffekt
	;clr.l	noscroll			; Scrollzähler zurücksetzen
	bsr.w	PrintChar			; drucke neues Zeichen
	bsr.s	DoScroll			; Scrolltext

SaltaScroll:
	bsr.s	Drawscroll			; ruft die Routine zum Zeichnen des
								; Textes auf dem Bildschirm auf

	lea	sinustab(PC),a0			; Diese Anweisungen drehen die Werte
	lea	4(a0),a1				; die Tabelle der Positionen
	move.l	(a0),d0				; vertikaler Scrolltext
copysinustab:
	move.l	(a1)+,(a0)+
	cmpi.l	#$ffff,(a1)			; Ende Flagge? Wenn noch nicht,
	bne.s	copysinustab		; in Bewegung bleiben...
	move.l	d0,(a0)				; Am Ende den ersten Wert eingeben. in Boden!
	rts						

;*****************************************************************************
; Diese Routine führt das eigentliche Scrollen aus. Zu bemerken ist, dass wir
; die Scroll-Geschwindigkeit "speedlogic" festlegen. Dieser hängt von dem Wert 
; in BLTCON0 ab. Jede Geschwindigkeit hat einen anderen Verschiebungswert.
;*****************************************************************************

;	    _____________
;	   /  ---  ____ ¬\
;	 _/ ¬____,¬_____-'\_
;	(_   ¬(°T..(°)_¬   _)
;	 T`--  ¯____¯ __,¬ T
;	 l_ ,-¬/----\-`    !
;	  \__ /______\-¯¯¬/
;	    | `------'  T¯ xCz
;	    `-----------'

DoScroll:
	lea	BITPLANE+2,a0			; Source (16 Pixel später)
	lea	BITPLANE,a1				; Ziel   (Anfang ... dann <- von 16 Pixeln!)
	moveq	#3-1,d7				; Anzahl blitt = 3 für 3 planes
BlittaLoop1:
	btst	#6,2(a6)			; dmaconr - waitblit
bltx:
	btst	#6,2(a6)			; dmaconr - waitblit
	bne.s	bltx

	moveq	#0,d1
	move.w	d1,$42(a6)			; BLTCON1
	move.l	d1,$64(a6)			; BLTAMOD, BLTDMOD
	moveq	#-1,d1				; $FFFFFFFF
	move.l	d1,$44(a6)			; BLTAFWM, BLTALWM
	move.w	speedlogic(PC),$40(a6)	; BLTCON0 (Scroll-Geschwindigkeit
								; durch die Shiftwerte)

	btst	#6,2(a6)			; dmaconr - waitblit
blt23:
	btst	#6,2(a6)			; dmaconr - waitblit
	bne.s	blt23

	move.l	a0,$50(a6)			; BLTAPT
	move.l	a1,$54(a6)			; BLTDPT
	move.w	#(32*64)+22,$58(a6)	; BLTSIZE

	add.w	#32*44,a0			; nächste Quelle Ebene
	add.w	#32*44,a1			; nächste Ziel Ebene

	dbra	d7,BlittaLoop1
	rts

;*****************************************************************************
; Diese Routine zeichnet den Scrolltext auf eine variable vertikale Position 
; entsprechend den Werten einer Sinuswelle (dh ein schönen SIN TAB!) auf dem 
; Bildschirm.
; Anstatt es mit geblitteten Objekten zu kopieren, könnte man es auch 
; "ökonomischer" nur durch ändern der Zeiger auf die Bitplanes und die
; gleiche Arbeit mit wenigen Zügen erledigen. Aber das ist eine Quelle die 
; dem Blitter gewidmet ist, also lasst uns blitten!
;*****************************************************************************

Drawscroll:
	lea	BITPLANE,a0				; Zeiger Quelle
	lea	sinustab(pc),a5			; Tabelle Sinus
	move.l	(a5),d4				; gesetzte Koordinate Y
								; (der erste der Tabelle)
	lea	BITPLANE+(112*44),a5	; Adresse Ziel
	add.l	d4,a5				; Koordinate Y hinzufügen 

	btst	#6,2(a6)			; warte auf das Ende des Blitters
blt1e:							; vor dem Ändern der Register
	btst	#6,2(a6)
	bne.s	blt1e

	moveq	#-1,d1
	move.l	d1,$44(a6)			; BLATLWM, BLTAFWM
	moveq	#0,d1
	move.l	d1,$64(a6)			; BLTAMOD/BLTDMOD
	move.l	#$09f00000,$40(a6)	; BLTCON0 - normal Kopie

	moveq	#3-1,d7				; Anzahl der Bitplanes
copialoopa:
	btst	#6,2(a6)			; warte auf das Ende des Blitters
blt1f:
	btst	#6,2(a6)
	bne.s	blt1f

	move.l	a0,$50(a6)			; BLTAPT
	move.l	a5,$54(a6)			; BLTDPT
	move.w	#32*64+22,$58(a6)	; BLTSIZE - copyscroll

	add.w	#32*44,a0			; nächste Bitplane Quelle
	add.w	#256*44,a5			; nächste Bitplane Ziel

	dbra	d7,copialoopa
	rts

; Diese Tabelle enthält die Offsets für die Y-Koordinaten für den Übergang 

sinustab:
	dc.l	0,44,88,132,176,220,264,308,352,396
	dc.l	440,484,528,572,616,660,704,748,792
	dc.l	836,880,924,968,1012,1056,1100,1144,1188,1232
	dc.l	1276,1276,1232
	dc.l	1188,1144,1100,1056,1012,968,924,880,836,792,748,704
	dc.l	660,616,572,528,484,440,396,352,308
	dc.l	264,220,176,132,88,44,0
sinusend:
	 dc.l	0
	 dc.l	$ffff				; Flag für das Ende der Tabelle


;*****************************************************************************
; Diese Routine druckt die neuen Zeichen. Beachten Sie, dass es im Text auch
; die FLAGs gibt, in diesem Fall die Zahlen von 1 bis 5, die die 
; Scrollgeschwindigkeit ändern. Dies ändert den Wert der Verschiebung, in
; bltcon0, sowie die Anzahl der Zeichen, um jedes Bild zu drucken (es ist klar
; dass bei Überschallgeschwindigkeit mehr Zeichen auf den Rahmen gedruckt werden 
; müssen!). Ein weiterer besonderer Punkt, der zu beachten ist, ist, dass das 
; System zum Erstellen der Schriftart sich von denen bisher gesehen unterscheidet.
; In der Tat die Schriftart ist nichts anderes als ein 320 * 200 großer
; 8-farbiger Bildschirm mit den platzierten Zeichen eins neben dem anderen und
; eine Zeile unter der anderen. Das macht es einfacher.
; Zeichne deine eigene Schrift, benötigt aber eine andere Routine, um die Schrift 
; zu finden. In der Tat ist es notwendig, eine Tabelle zu erstellen, die die 
; Offsets vom Anfang der Schriftart jedes Zeichens und abhängig von dem Ascii-
; Wert enthält, den wir drucken. Nehmen Sie den entsprechenden Wert aus der 
; Tabelle um die Position des betreffenden Charakters zu kennen.
; Dies mag komplex erscheinen, aber da die Zeichen in der Schriftart in der 
; ASCII-Reihenfolge stehen, werden Sie sehen, dass es sehr einfach ist, die 
; Tabelle mit den Offsets zu schreiben!
; Die Schriftart ist jedoch auch im .iff-Format verfügbar, um das System 
; übersichtlicher zu gestalten und die Entwicklung einer neuen Schriftart zu
; erleichtern.
;*****************************************************************************

PrintChar:
	tst.w	textctr				; Wenn der Zähler positiv ist, wird nicht gedruckt
	bne.w	noPrint
	move.l	textptr(PC),a0		; lies das zu druckende Zeichen
	moveq	#0,d0
	move.b	(a0)+,d0
	cmp.l	#textend,textptr	; sind wir am Ende des Textes?
	bne.s	noend
	lea	scrollmsg(PC),a0		; wenn du nochmal von vorn anfängst!
	move.b	(a0)+,d0			; Zeichen in d0
noend:
	cmp.b	#1,d0				; FLAG 1? Dann Geschwindigkeit = 1
	bne.s	nots1
	move.w	#32,scspeed			; Anfangswert von textctr
	move.w	#$f9f0,speedlogic	; Wert BLTCON0
	move.b	(a0)+,d0			; nächstes Zeichen in d0
	bra.s	contscroll
nots1:
	cmpi.b	#2,d0				; FLAG 2? Dann Geschwindigkeit = 2
	bne.s	nots2
	move.w	#16,scspeed
	move.w	#$e9f0,speedlogic	; Wert BLTCON0
	move.b	(a0)+,d0
	bra.s	contscroll
nots2:
	cmpi.b	#3,d0				; FLAG 3? Dann Geschwindigkeit = 3
	bne.s	nots3
	move.w	#8,scspeed
	move.w	#$c9f0,speedlogic	; Wert BLTCON0
	move.b	(a0)+,d0
	bra.s	contscroll
nots3:
	cmpi.b	#4,d0				; FLAG 4? Dann Geschwindigkeit = 4
	bne.s	nots4
	move.w	#4,scspeed
	move.w	#$89f0,speedlogic	; Wert BLTCON0
	move.b	(a0)+,d0
	bra.s	contscroll
nots4:
	cmpi.b	#5,d0				; Flag 5? Dann Geschwindigkeit = 5
	bne.s	contscroll
	move.w	#2,scspeed
	move.w	#$19f0,speedlogic	; Wert BLTCON0
	move.b	(a0)+,d0

; Hier wird nach dem Überprüfen der Flags das Zeichen gedruckt. Beachten Sie den Weg
; Wo sich das Zeichen befindet, verwenden Sie die Tabelle mit den Offsets.

contscroll:
	move.l	a0,textptr			; speichert den Zeiger auf das nächste Zeichen
	subi.b	#$20,d0				; ascii - 20 = Das erste Zeichen ist das Leerzeichen
	lsl.w	#2,d0				; multiplizieren Sie * 4, um die Adresse in der Tabelle zu finden,
								; da jeder Wert im Tab '.L (4 Bytes) ist
	lea	addresses(PC),a0
	move.l	0(a0,d0.w),a0		; Kopiere in a0 die Adresse des Zeichens
								; der Tabelle.

	btst	#6,2(a6)			; dmaconr - waitblit
blt30:
	btst	#6,2(a6)			; dmaconr - waitblit
	bne.s	blt30

	moveq	#-1,d1
	move.l	d1,$44(a6)	 		; BLTALWM, BLTAFWM
	move.l	#$09F00000,$40(a6)	; BLTCON0/1 - normale Kopie
	move.l	#$00240028,$64(a6)	; BLTAMOD = 36, BLTDMOD = 40

	lea	BITPLANE+40,a1			; Zeiger Ziel
	moveq	#3-1,d7				; Anzahl Bitplanes
CopyCharL:

	btst	#6,2(a6)			; dmaconr - waitblit
blt31:
	btst	#6,2(a6)			; dmaconr - waitblit
	bne.s	blt31

	move.l	a0,$50(a6)			; BLTAPT (Zeichen im font)
	move.l	a1,$54(a6)			; BLTDPT (bitplane)
	move.w	#32*64+2,$58(a6)	; BLTSIZE

	add.w	#32*44,a1			; nächstes Bitebene Ziel
	lea	40*200(a0),a0			; 1 Bitplane des Bildes mit der Schrift

	dbra	d7,copycharL

	move.w	scspeed(PC),textctr	; Anfangswert des Druckzählers
noPrint:
	subq.w	#1,textctr			; dekrementiert den Zähler, der anzeigt, wann
								; wir drucken
endPrint:
	rts

; Variablen

textptr:	 dc.l	scrollmsg	; Zeiger auf das zu druckende Zeichen
textctr:	 dc.w	0			; Zähler, der anzeigt, wann gedruckt werden soll
noscroll:	 dc.l	0			; Zähler, der angibt, wann gescrollt werden soll

scspeed:	 dc.w	0			; Anfangswert des Zählers, der
								; anzeigt, wann gedruckt werden soll
								; variiert je nach Geschwindigkeit

speedlogic:	 dc.w	0			; Wert von BLTCON0
								; variiert je nach Geschwindigkeit
								; weil der Wert der Verschiebung variiert

;*****************************************************************************
; Diese Tabelle enthält eine Reihe von Fontadressen, auf die Position der
; ASCII-Zeichen in der Schriftart selbst: zum Beispiel das erste ist BigF ohne
; Offset. In der Tat ist das erste Zeichen in der Schriftart, der Ort an dem 
; auch das erste Ascii ist. Das zweite (in ascii ist das Ausrufungszeichen !)
; ist ein bigF + 4, in der Tat das ! befindet sich im Font auf dem zweiten
; Platz, dh 4 Bytes (32 Pixel) nach dem ersten. Wir haben jeweils ein 32 Pixel 
; breites und hohes Zeichen.
; Da der Font in einem 320 * 200-Figur vorliegt, wird es nur 10 Zeichen pro
; horizontaler Zeile geben, also die Zeichen von 11 bis 20 müssen in einer
; Reihe darunter sein, diejenigen von 21 bis 30 darunter, und so weiter.
;*****************************************************************************

addresses:
	 dc.l BigF					; erstes Zeichen: " "
	 dc.l BigF+4				; zweites Zeichen: "!"
	 dc.l BigF+8
	 dc.l BigF+12,BigF+16,BigF+20,BigF+24,BigF+28,BigF+32,BigF+36

; zweite Reihe von Zeichen in der Schriftart: Wir beginnen in der Tat von 1280 oder 32 * 40
; Sie müssen die 32 Zeilen der ersten Zeichenreihe überspringen

	 dc.l BigF+1280				; elftes Zeichen: "
	 dc.l BigF+1284
	 dc.l BigF+1288
	 dc.l BigF+1292
	 dc.l BigF+1296,BigF+1300,BigF+1304,BigF+1308,BigF+1312,BigF+1316

; dritte Reihe von Zeichen in der Schriftart

	 dc.l BigF+2560,BigF+2564,BigF+2568,BigF+2572,BigF+2576,BigF+2580
	 dc.l BigF+2584,BigF+2588,BigF+2592,BigF+2596
; vierte
	 dc.l BigF+3840,BigF+3844,BigF+3848,BigF+3852,BigF+3856,BigF+3860
	 dc.l BigF+3864,BigF+3868,BigF+3872,BigF+3876
; fünfte
	 dc.l BigF+5120,BigF+5124,BigF+5128,BigF+5132,BigF+5136,BigF+5140
	 dc.l BigF+5144,BigF+5148,BigF+5152,BigF+5156
; sechste
	 dc.l BigF+6400,BigF+6404,BigF+6408,BigF+6412,BigF+6416,BigF+6420
	 dc.l BigF+6424,BigF+6428,BigF+6432,BigF+6436



;*****************************************************************************
; Hier ist der Text: Einstellung 1,2,3,4 ändert die Bildlaufgeschwindigkeit
;*****************************************************************************

scrollmsg:
 dc.b 4,"AMIGA EXPERT TEAM",1,"        ",3
 dc.b " IL NUOVO GRUPPO ITALIANO DI UTENTI AMIGA EVOLUTI  ",2
 dc.b "       ",3
 dc.b "  SE VUOI METTERTI IN CONTATTO CON APPASSIONATI DI AMIGA ",2
 dc.b "CHE LO USANO PER FARCI MUSICA, GRAFICA, PROGRAMMAZIONE O ALTRO,"
 dc.b " SIA PER HOBBY CHE PER LAVORO, SCRIVI A: (MOUSE DESTRO PER STOP) ",1
 dc.b " MIRKO LALLI - VIA VECCHIA ARETINA 64 - 52020 LATERINA STAZIONE - ",2
 dc.b "AREZZO - ",3
 dc.b " CREDITI PER QUESTA DEMO: ",1
 dc.b "PROGRAMMAZIONE ASSEBLER E GRAFICA BY FABIO CIUCCI -",2
 dc.b " MUSICA PRESA DA UNA LIBRERIA PD ",3
 dc.b "-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-",4
 dc.b "=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-"
 dc.b "                                                 "
textend:

; Hinweis: Anderer CLUB für Amiga ist APU: für Informationen tel. 081/5700434
; 081/7314158
; Donnerstag-Freitag 19-22

******************************************************************************
;		COPPERLIST:
******************************************************************************

	section	copper,data_c

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,$24			; BplCon2 - Alle Sprites über der Bitebene
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
	dc.w	$100,$200			; BplCon0 - no bitplanes

	dc.w	$0180,$000			; color0 - Hintergrund
	dc.w	$0182,$1af			; color1 - Schrift

	dc.w	$9707,$FFFE			; WAIT - ziehe die Leiste oben an
	dc.w	$180,$110			; Color0
	dc.w	$9807,$FFFE			; wait....
	dc.w	$180,$120
	dc.w	$9a07,$FFFE
	dc.w	$180,$130
	dc.w	$9b07,$FFFE
	dc.w	$180,$240
	dc.w	$9c07,$FFFE
	dc.w	$180,$250
	dc.w	$9d07,$FFFE
	dc.w	$180,$370
	dc.w	$9e07,$FFFE
	dc.w	$180,$390
	dc.w	$9f07,$FFFE
	dc.w	$180,$4b0
	dc.w	$a007,$FFFE
	dc.w	$180,$5d0
	dc.w	$a107,$FFFE
	dc.w	$180,$4a0
	dc.w	$a207,$FFFE
	dc.w	$180,$380
	dc.w	$a307,$FFFE
	dc.w	$180,$360
	dc.w	$a407,$FFFE
	dc.w	$180,$240
	dc.w	$a507,$FFFE
	dc.w	$180,$120
	dc.w	$a607,$FFFE
	dc.w	$180,$110

	dc.w	$A707,$FFFE
	dc.w	$180,$000

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste  bitplane
	dc.w	$e4,0,$e6,0			; zweite bitplane
	dc.w	$e8,0,$ea,0			; dritte bitplane

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

	dc.w	$108,4				; bpl1mod - wir überspringen die 4 Bytes wo es ist
	dc.w	$10a,4				; bpl2mod - wir würden den Text sonst drucken sehen ...
								; Denken Sie daran, dass der Bildschirm eigentlich 44 Bytes
								; breit ist, um ganz nach rechts zu gehen,
								; aus dem Sichtbaren,
								; alle Scrolltexte tun das

	dc.w	$180,$000			; color
	dc.w	$182,$111
	dc.w	$184,$233
	dc.w	$186,$555
	dc.w	$188,$778
	dc.w	$18a,$aab
	dc.w	$18c,$fff
	dc.w	$18e,$fff

scol:
	dcb.w	6*64,0				; Platz für die erzeugten Farbtöne
								; aus der Routine "Makefarben"

	dc.w	$EE07,$fffe
	dc.w	$180,$004

	dc.w	$184,$023,$186,$118		; mehr "blaue" Farben
	dc.w	$188,$25b,$18a,$38e,$18c,$acf

	dc.w	$182,$550			; dieser Teil der copperlist
	dc.w	$18e,$155			; realisiert den Spiegeleffekt, 
	dc.w	$108,-84			; sie sollten es wissen wie !!
	dc.w	$10A,-84	
	dc.w	$F307,$fffe

	dc.w	$182,$440
	dc.w	$18e,$144
	dc.w	$108,-172
	dc.w	$10A,-172
	dc.w	$108,-84
	dc.w	$10A,-84
	dc.w	$180,$004
	dc.w	$F407,$fffe
	dc.w	$182,$330
	dc.w	$18e,$133
	dc.w	$108,-172
	dc.w	$10A,-172
	dc.w	$180,$005
	dc.w	$F607,$fffe
	dc.w	$182,$220
	dc.w	$18e,$123
	dc.w	$108,-84
	dc.w	$10A,-84
	dc.w	$180,$006
	dc.w	$FA07,$fffe
	dc.w	$182,$110
	dc.w	$18e,$012
	dc.w	$108,-172
	dc.w	$10A,-172
	dc.w	$180,$007
	dc.w	$FD07,$fffe
	dc.w	$182,$110
	dc.w	$18e,$011
	dc.w	$108,-84
	dc.w	$10A,-84
	dc.w	$180,$008
	dc.w	$ffdf,$fffe
	dc.w	$0107,$fffe
	dc.w	$0407,$fffe
	dc.w	$182,$001
	dc.w	$18e,$011
	dc.w	$108,-172
	dc.w	$10A,-172
	dc.w	$180,$009
	dc.w	$0607,$fffe
	dc.w	$182,$002
	dc.w	$18e,$111
	dc.w	$108,-84
	dc.w	$10A,-84
	dc.w	$180,$00A
	dc.w	$0A07,$fffe
	dc.w	$182,$003
	dc.w	$18e,$101
	dc.w	$108,-172
	dc.w	$10A,-172
	dc.w	$180,$00B
	dc.w	$0D07,$fffe
	dc.w	$182,$004
	dc.w	$18e,$202
	dc.w	$108,-84
	dc.w	$10A,-84
	dc.w	$180,$00e

	dc.w	$1307,$fffe
	dc.w	$100,$200			; no bitplanes

	dc.w	$FFFF,$FFFE			; Ende copperlist

;*****************************************************************************

; Hier ist die Schrift, die in einem 320*200 Bild mit 3 Bitplanes (8 Farben) steht

BigF:
	incbin	"/Sources/font4"	

;*****************************************************************************

	SECTION	BUFY,BSS_C

BITPLANE:
	ds.b	3*44*256			; Platz für 3 bitplanes

	END


In diesem Listing sehen wir ein weiteres Beispiel für einen Scrolltext, das 
komplexer ist, als das vorherige. Es handelt sich um die im Intro AMIGAET
verwendete Scroll-Routine von Fabio Ciucci. In diesem Programm bewegt sich der
Scrolltext nach oben und unten. Um diesen Effekt zu erzielen, werden zwei
Textpuffer verwendet.
In den ersten (unsichtbaren) werden die Zeichen gedruckt und der Text wird
gescrollt. Von hier wird der Text in den anderen Puffer (den sichtbaren) an
eine vertikale Position, die von Bild zu Bild gemäß einer Tabelle varriert
kopiert. Der zweite Puffer wird nie gelöscht, da beim Kopieren vom ersten
Puffer auch einige "saubere" (auf Null gesetzte) Zeilen kopiert werden, die
den alten Teil des Textes löschen, der nicht durch den neuen Text 
überschrieben wird.
Um Speicherplatz zu sparen, wurden die 2 Puffer zu einem zusammengegelegt
(an der Adresse BITPLANE) von der Größe eines 320*256 Bildschirms mit
3 Ebenen. Dies ist möglich, weil in der Realität nur ein Bildschirm mit
180 Zeilen verwendet wird. Tatsächlich wird die Anzeige der Bitebenen durch die
copperliste nur ab der Zeile $A7 des Displays aktiviert. Eine weitere
Besonderheit dieses Listings ist, dass ein Teil der copperliste von einer
Prozessorroutine "makecolors" erzeugt wird.
Das Thema vom Prozessor (und vom Blitter!) erzeugte (gesteuerte) copperliste
wird in einer zukünftigen Lektion behandelt. Für den Moment, gib es trotzdem 
ein Blick.