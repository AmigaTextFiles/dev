
; Listing9g3.s		Wieder die Kacheln, aber diesmal mit dem INTERLEAVED-Bildschirm
		; Timing mit Vblank bringt es auf den Punkt
		; nur eine Zeile pro Frame.
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"			; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitebenen (hier sind 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0					; HIER IST DER ERSTE UNTERSCHIED ZU
								; DEN NORMALEN BILDERN !!!!!!
	ADD.L	#40,d0				; + LÄNGE einer ZEILE !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	bsr.s	fillmem				; "Kachel" Routine ausführen

mouse2:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse2				; Wenn nicht, gehe zurück zu mouse2:
	rts							; Ausgang

*****************************************************************************
; Routine, die das Kacheln ausführt
*****************************************************************************

;	    ________
;	   (___  ___)
;	  (¡ (°)(°) ¡)
;	  `| ¯(··)¯ |'
;	   |  /¬¬\  | xCz
;	   l__¯¯¯¯__!
;	  ___T¯¯¯¯T___
;	 /   `----'  ¬\
;	·              ·

fillmem:
	lea	Bitplane,a0				; bitplanes
	lea	gfxdata,a3				; Adresse Figur

	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; BLTAFWM und BLTALWM wir erklären es später
	move.w	#0,$64(a5)			; BLTAMOD = 0
	move.w	#38,$66(a5)			; BLTDMOD (40-2=38), tatsächlich alle
								; "Kacheln" sind 16 Pixel breit,
								; das sind 2 Bytes, die wir entfernen müssen
								; auf die gesamte Breite einer Zeile,
								; die ist 40, und das Ergebnis ist 40-2 = 38!
	move.w	#$0000,$42(a5)		; BLTCON1 - wir erklären es später
	move.w	#$09f0,$40(a5)		; BLTCON0 (Kopie A nach D)

	moveq	#16-1,d7			; 16 Kacheln um am Ende 
								; anzukommen, tatsächlich
								; die Kacheln sind 15 Pixel hoch,
								; 1 Pixel "Abstand" zwischen einer und
								; der anderen, unter jeder, macht eine
								; Größe von 16 Pixeln pro Kachel,
								; deshalb 256/16 = 16 Kacheln.
FaiTutteLeRighe:
	moveq	#20-1,d6			; 20 Blöcke pro Zeile, tatsächlich
								; die Kacheln sind 16 Pixel breit,
								; das sind 2 Bytes, daraus abgeleitet
								; für eine horizontale Zeile
								; sind das 320/16 = 20 

WaitWblank:
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

FaiUnaRigaLoop:

; Blittet die erste Bitebene einer Kachel

	move.l	a0,$54(a5)			; BLTDPT - Ziel (bitpl 1)
	move.l	a3,$50(a5)			; BLTAPT - Quelle (fig1)
	move.w	#(2*15*64)+1,$58(a5)	; BLTSIZE - Höhe: 2 Ebenen
								; 15 Zeilen hoch
								; 1 Wortbreite

	btst	#6,2(a5)			; dmaconr
WBlit2:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2
	
	addq.w	#2,a0				; Überspringt 1 Wort (16 Pixel) in der Bitebene 1
								; in "vorwärts" für die nächste Kachel
	dbra	d6,FaiUnaRigaLoop	; und Schleife bis alle fertig gezeichnet sind
								; Blittet alle 20 Kacheln einer Zeile
 
	lea	40+2*15*40(a0),a0				
								; Mit ADDQ #2,A0 haben wir den Zeiger a0 erhöht
								; bis das letzte Wort von Zeile 0 der Ebene 1 
								; überschritten wird. So sind wir beim ersten
								; Wort der Zeile 0 von Ebene 2 angekommen.
								; Jetzt wollen wir zum ersten Wort von Zeile 16
								; der Ebene 1 gehen.
								; Wir müssen daher 40 zu A0 addieren, um zum 
								; ersten Wort der Zeile 1 von Ebene 1 zu gelangen
								; und dann 2 * 15 * 40 addieren um sich dahin zu
								; bewegen, wo wir hinwollen.

	dbra	d7,FaiTutteLeRighe	; mache alle 16 Zeilen
 	rts

*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2

								; HIER IST DER ZWEITE UNTERSCHIED 
								; ZU DEN NORMALEN BILDERN !!!!!!
	dc.w	$108,40				; Wert MODULO = 2*20*(2-1)= 40
	dc.w	$10a,40				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$2200			; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000

	dc.w	$180,$000			; Color0
	dc.w	$182,$FED			; Color1
	dc.w	$184,$33a			; Color2
	dc.w	$186,$888			; Color3

	dc.w	$FFFF,$FFFE			; Ende copperlist

; Abbildung, bestehend aus 2 Bitebenen. Breite = 1 Wort, Höhe = 15 Zeilen

**************************************************************************
; Figur der Kachel

; Es ist die gleiche Figur des Beispiels Listing9f3.s nur dort war es
; im normalen Format. Um es ins interleaved Format zu bringen, 
; "mische" die Zeilen.

gfxdata:
	dc.w	%1111111111111100	; Reihe 0, plane 1
	dc.w	%0000000000000010	; Reihe 0, plane 2
	dc.w	%1111111111111100	; Reihe 1, plane 1
	dc.w	%0111111111111110	; Reihe 1, plane 2
	dc.w	%1100000000001100	; Reihe 3, plane 1
	dc.w	%0111111111110110	; Reihe 3, plane 2
	dc.w	%1101111111111100
	dc.w	%0111111111110110
	dc.w	%1101111111111100
	dc.w	%0111000000010110
	dc.w	%1101111111011100
	dc.w	%0111011111110110
	dc.w	%1101110011011100
	dc.w	%0111011101110110
	dc.w	%1101110111011100
	dc.w	%0111011101110110
	dc.w	%1101111111011100
	dc.w	%0111010001110110
	dc.w	%1101111111011100
	dc.w	%0111011111110110
	dc.w	%1101100000011100
	dc.w	%0111011111110110
	dc.w	%1101111111111100
	dc.w	%0111111111110110
	dc.w	%1111111111111100
	dc.w	%0100000000000110
	dc.w	%1111111111111100
	dc.w	%0111111111111110
	dc.w	%0000000000000000	; Reihe 15, plane 1
	dc.w	%1111111111111110	; Reihe 15, plane 2

*****************************************************************************

	section	gnippi,bss_C

bitplane:
		ds.b	2*40*256		; 2 bitplanes

	end

*****************************************************************************

In diesem Beispiel finden wir die Kacheln wieder, diesmal im interleaved 
Format. Beachten Sie zunächst, die Figur der Kachel. Im Listing9f3.s hatten wir
die 2 separaten Bitebenen. Hier sind die Zeilen stattdessen gemischt. In der
Routine werden die Kacheln mit nur einem Blitt kopiert, während wir in
Listing9f3.s für jede Bitplane einen Blitt machen mussten.
Die Höhe des Blitts ist gleich dem Produkt der Höhe der Figur (15 Zeilen) und
der Anzahl der Bitebenen (2), wie wir es in der Lektion erläutert haben. Auch
die Berechnung der Zieladresse ist (natürlich) anders. (Die Quelle ist fest und
bleibt daher immer gleich). Die Kacheln der gleichen Zeile haben immer ein Wort
Abstand zueinander. Wie gesehen unterscheidet sich Interleaved nur durch die
Anordnung der Zeilen im Unterschied zu den normalen Bildern.
Der Unterschied liegt nach der internen Schleife, wenn wir das Ende einer
horizontalen Reihe von Kacheln erreicht haben und wir mit der folgende beginnen
wollen. Wenn wir mit Y die Zeile angeben, bei der wir zu blitten beginnen,
müssen wir uns in der Zeile um Y + 16 bewegen.

In der inneren Schleife erhöhen wir den Zeiger jedes Mal um 2, um ihn jeweils
ein Wort nach rechts zu bewegen. Am Ende der Schleife befinden wir uns
unmittelbar nach dem letzten Wort der aktuellen Zeile, also das erste Wort von
Ebene 2 der Zeile Y.
 
Zuerst müssen wir uns auf der Ebene 1 zur Linie Y + 1 bewegen. Dazu addieren
wir 40 (Anzahl der Bytes, die von einer Ebene einer Zeile belegt sind). An
diesem Punkt müssen wir weitere 15 Zeilen hinuntergehen. Da eine Bitebene
40 Bytes belegt, haben wir jeweils zwei Ebenen Zeilen. 
Wir müssen 2 * 15 * 40 hinzufügen.
Natürlich können wir beide Mengen auf einmal hinzufügen und das macht ein
LEA 40+15*2*40(A1),A1.

Wir fassen die Situation mit der folgenden Abbildung zusammen:

- Zu Beginn der internen Schleife zeigt der Zeiger auf das mit (0) angegebene Wort.
- Am Ende der internen Schleife zeigt der Zeiger auf das mit (1) angegebene Wort.
- Mit 40 addiert der Zeiger zeigt auf das mit (2) angegebene Wort.
- durch Hinzufügen von 2 * 40 * 15 bewegen wir uns 15 Zeilen nach unten und der 
  Zeiger zeigt auf das mit (3) angegebene Wort, welches das Wort ist, das wir 
  wollten.
  (Es gibt 2 * 40 Bytes zwischen den Zeilen, wenn wir nur 2 * 40 hinzugefügt haben
   wären wir vom Wort (2) nur zum Wort (2') gegangen.

Reihe Y     plane 1	| (0)  |      |      |    . . .   |      |
Reihe Y     plane 2	| (1)  |      |      |    . . .   |      |
Reihe Y+1   plane 1	| (2)  |      |      |    . . .   |      | \
Reihe Y+1   plane 2	|      |      |      |    . . .   |      |  |
Reihe Y+1   plane 1	| (2') |      |      |    . . .   |      |  |
Reihe Y+1   plane 2	|      |      |      |    . . .   |      |  |
																|
.																|
																| 15 Zeilen
.																|
																|
.																|
																|
															   /
Reihe Y+16  plane 1	| (3)  |      |      |    . . .   |      |
Reihe Y+16  plane 2	|      |      |      |    . . .   |      |

