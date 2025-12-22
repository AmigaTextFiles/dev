
; Lezione11i2.s	- Bar in "pseudoparallaxe"

	SECTION	ParaCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
	bsr.w	WriteWaits	; erstelle 2 copperlist...

	lea	$dff000,a6
	MOVE.W	#DMASET,$96(a6)		; DMACON - aktivieren copper
	move.l	#KOPLIST1,$80(a6)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	bsr.w	waitvb				; warte auf vertical Blank
	move.l	#koplist2,$dff080
	move.l	#koplist1Waits+6,stampa		; Anfang cop
	move.l	#koplist1Waits+6+(8*200),a5	; Ende cop
	bsr.w	cleacop				; Reinigen Sie die copperlist
	bsr.w	makeBeams			; erstelle die Bar

	bsr.w	waitvb				; warte auf vertical Blank
	move.l	#koplist1,$dff080
	move.l	#koplist2Waits+6,stampa		; Anfang  cop
	move.l	#koplist2Waits+6+(8*200),a5	; Ende cop
	bsr.w	cleacop				; Reinigen Sie die copperlist
	bsr.w	makeBeams			; erstelle die Bar

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts			; exit

*****************************************************************************
;	Routine die 2 copperlist erstellt
*****************************************************************************

;	__/\__
;	\(Oo)/
;	/_()_\
;	  \/

WriteWaits:
	lea	koplist1waits,a1
	lea	koplist2waits,a2
	move.l	#$2c07ff00,d0	; Wait (erste Zeile $2c)
	move.l	#$01800000,d2	; Color0
	move.w	#200-1,d1		; Anzahl waits (200 für Bereich NTSC)
WWLoop:
	move.l	d0,(a1)+		; Wait in coplist 1
	move.l	d0,(a2)+		; Wait in coplist 2

	move.l	d2,(a1)+		; Color0 in coplist1
	move.l	d2,(a2)+		; Color0 in coplist2
	add.l	#$01000000,d0	; Warten Sie 1 Zeile darunter
	dbra	d1,WWLoop
	RTS

*****************************************************************************
;	Routine die den Hintergrund "säubert"
*****************************************************************************

;	__/\__
;	\[oO]/
;	/_--_\
;	  \/

CleaCop:
	move.l	stampa(PC),a0	; copper aktuell
	moveq	#$001,d0		; Hintergrundfarbe
	move.w	#(200/4)-1,d1	; Anzahl waits
Clealoop:
	move.w	d0,(a0)			; löschen
	move.w	d0,8(a0)		; ...
	move.w	d0,8*2(a0)
	move.w	d0,8*3(a0)
	lea	8*4(a0),a0
	dbra	d1,Clealoop		; 200/4 mal wiederholen, weil es 4 
	rts						; words pro Schleife reinigt! (schneller!)

*****************************************************************************
;	Routine warten auf vblank
*****************************************************************************

;	__/\__
;	\-OO-/
;	/_\/_\
;	  \/

Waitvb:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$0ff00,d2	; warte auf Zeile $FF
Waity1:
	MOVE.L	4(A6),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $FF
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A6),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $FF
	BEQ.S	Aspetta
	RTS

*****************************************************************************
;	Routine die die copperlist modifiziert
*****************************************************************************

;	__/\__
;	\(OO)/
;	/_==_\
;	  \/

MakeBeams:
	lea	beam01(pc),a1		; Tabelle Farbe Bar 1
	move.l	beam01x(pc),d0	; das x...
	moveq	#10,d1			; Abstand zwischen dem einen und dem anderen
	bsr.w	writebeam

	lea	beam02(PC),a1		; Tabelle Farbe Bar 2
	move.l	beam02x(PC),d0	; das x...
	moveq	#25,d1			; Abstand zwischen dem einen und dem anderen
	bsr.w	writebeam

	lea	beam03(PC),a1		; Tabelle Farbe Bar 2
	move.l	beam03x(PC),d0	; das x...
	moveq	#55,d1			; Abstand zwischen dem einen und dem anderen
	bsr.w	writebeam

; BEAM01x sinkt um 1 alle 2 Frames.

	subq.b	#1,timer01x		; 1 frame jeder 2.
	bne.s	Non01x			; frame vorbei? (timer1x=0?)
	move.b	#2,timer01x		; Reset 2 frame

	addq.l	#1,beam01x		; heruntergehen um 1 Beam01x
	cmp.l	#8+10,beam01x	; sind wir ganz unten?
	bne.s	Non01x
	clr.l	beam01x			; wenn ja, wieder starten
Non01x:

; BEAM02x sinkt um 1 bei jedem Frame .

	addq.l	#1,beam02x		; heruntergehen um 1 beam02x
	cmp.l	#16+25,beam02x	; sind wir ganz unten?
	bmi.s	NONON2
	clr.l	beam02x			; wenn ja, wieder starten
NONON2:

; BEAM03x sinkt um 2 pro Frame.

	addq.l	#2,beam03x		; heruntergehen um 2 beam03x

	cmp.l	#16+55,beam03x	; sind wir ganz unten?
	bmi.s	NONON3

	clr.l	beam03x			; wenn ja, wieder starten.
NONON3:
	RTS

timer01x:
	dc.b	2

	even

stampa:		dc.l	koplist1Waits+6		; Copper aktuell

beam01x:	dc.l 10
beam02x:	dc.l 5
beam03x:	dc.l 2


*****************************************************************************
;	Routine die die Bars "schreibt"
*****************************************************************************
;	lea	beam01(pc),a1	; Farbtabelle Beam01
;	move.l	beam01x(pc),d0	; das x...
;	moveq	#10,d1		; der Abstand zwischen dem einen und dem anderen

;	__/\__
;	\ $$ /
;	/_()_\
;	  \/  

WriteBeam:
	move.l	stampa(PC),a0	; Adresse copper atktuell
	move.l	a1,a2		; Adresse Farbtabelle in a1 und a2
	lsl.w	#3,d0		; X * 8
	lsl.w	#3,d1		; Abstand zwischen den Stäben * 8
	add.w	d0,a0		; Offset legen (x*8)
WBLoop2:
	move.l	a2,a1		; Farbtabelle
WBLoop:
	tst.w	(a1)		; Ende Farbtabelle?
	beq.s	EndOfBeam	; wenn ja, raus!
	move.w	(a1)+,(a0)	; Kopieren Sie die Farbe aus der Tabelle in die Copbar
	addq.w	#8,a0		; gehe zur nächsten color0
	cmp.l	a5,a0		; Ende copperlist?
	bmi.s	WBloop		; wenn noch nicht, bleiben
EndOfBeam:
	add.w	d1,a0		; Sobald ein Takt fertig ist, wird ein weiterer mehr gemacht
						; unten: Wir addieren den Abstand * 8 per
						; Finden Sie heraus, wo der nächste Takt beginnt
	cmp.l	a5,a0		; und wir stellen sicher, dass wir kein copper mehr haben
	bmi.s	WBloop2		; Wenn wir nicht draußen sind, können wir gehen!
	RTS


; Farbtabelle der "entferntesten" und langsamsten Balken (blau)

Beam01:
	dc.w	$003
	dc.w	$005
	dc.w	$007
	dc.w	$009
	dc.w	$00a
	dc.w	$007
	dc.w	$005
	dc.w	$003
	dc.w	0

; Farbtabelle der Zwischenstäbe (grün)

Beam02:
	dc.w	$001
	dc.w	$001

	dc.w	$010
	dc.w	$020
	dc.w	$030
	dc.w	$040
	dc.w	$050
	dc.w	$060
	dc.w	$070
	dc.w	$060
	dc.w	$050
	dc.w	$040
	dc.w	$030
	dc.w	$020
	dc.w	$010

	dc.w	$001
	dc.w	0

; Farbtabelle "in der Nähe" Balken (orange)

Beam03:
	dc.w	$110
	dc.w	$320
	dc.w	$520
	dc.w	$730
	dc.w	$940
	dc.w	$b50
	dc.w	$d60
	dc.w	$f70
	dc.w	$f60
	dc.w	$b50
	dc.w	$940
	dc.w	$730
	dc.w	$520
	dc.w	$420
	dc.w	$320
	dc.w	$210
	dc.w	$110
	dc.w	0


*****************************************************************************

	SECTION	koplists,DATA_C

; erste copper

koplist1:
	dc.w	$180,$666	; Color0
	dc.w	$100,$200	; bplcon0 - keine bitplanes
koplist1waits:
	dcb.w	4*200,0		; Raum für Effekt
	dc.w	$180,$666	; Color0
	dc.w    $ffff,$fffe	; Ende copperlist

; Zweites copper, ausgetauscht mit dem ersten gegen eine Art "Doppelpufferung"
; durch copperliste, um die Möglichkeit auszuschließen, nicht in der Lage zu sein, 
; rein zu schreiben der Zeit in color0, um das selbst "Schreiben" zu verhindern.

koplist2:
	dc.w	$180,$666	; Color0
	dc.w	$100,$200	; bplcon0 - keine bitplanes
koplist2waits:
	dcb.w	4*200,0		; Raum für Effekt
	dc.w	$180,$666	; Color0
	dc.w    $ffff,$fffe	; Ende copperlist

	end

Dieses Listing hat die Besonderheit, eine "doppelte Vercopperrung" zu sein, dh
er schreibt auf einen copper, während man ein anderes sieht, das vorher geschrieben  
wurde, um zu vermeiden, dass Sie ein langsames Schreiben auf dem Bildschirm bemerken. 
Sie könnten auch das COP2LC + COPJMP2-System verwenden, um copperlisten auszutauschen.