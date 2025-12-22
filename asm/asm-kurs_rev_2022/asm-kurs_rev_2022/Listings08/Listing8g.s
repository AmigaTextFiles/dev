
; Listing8g.s - Parallaxe "Boden" Test - 10 Ebenen.

*****************************************************************************
*	PARALLAX 0.5	Copyright © 1994 by Federico "GONZO" Stango			    *
*			Modifiziert von Fabio Ciucci									*
*****************************************************************************

	SECTION	MAINPROGRAM,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA
;			 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA

START:
	move.l	#PARALLAXPIC,d0		; Adresse Pic laden in d0
	lea	BPLPointers,a1			; Adresse der Zeiger auf bitplanes
	moveq	#5-1,d1				; Anzahl -1 für den DBRA
	move.w	#40*56,d2			; Bits pro Ebene in d2
	bsr.w	PointBpls			; Aufruf subroutine PointBpls

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#MyCopList,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

MainLoop:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.s	ParallaxFX			; Springe zum Unterprogramm "Parallaxe"

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	MainLoop			; Wenn "NEIN" erneut starten
	rts

******************************************************************************
*			 Teil für Unterprogramme										 *
******************************************************************************

; Dies ist die Parallaxenroutine. Die Funktionsweise ist sehr einfach.
; Tatsächlich werden nur die Werte der 10 BPLCON1 ($dff102) geändert, die eine
; unter der anderen mit WAITs im "Boden"-Bereich sind. Nun, wir haben bereits
; in den vorangegangenen Listings gesehen, wie ein Bild "geschwungen" werden
; kann unter Verwendung einer copperlist mit vielen BPLCON1 ($dff102), die den
; Bildschirm um bis zu 15 Pixel nach rechts verschiebt, mit dem Wert $FF,
; während bei $00 die Verschiebung null ist. Wenn wir nun, anstatt der 
; Wellenform den Eindruck erwecken wollen, das es unendlich fließen würde
; ergibt sich das Problem, das wir höchstens bis zum Wert 15 scrollen können.
; 15 Pixel sind nicht unendlich. Wir könnten auch ein Bild machen, das in der
; Breite einen Kilometer im Speicher lang ist, und Sie auch mit mit den
; Bitplanepointern scrollen, aber das wäre nicht wirtschaftlich. 
; Deshalb müssen wir einen Scroll machen, der unendlich aussieht, nach rechts
; mit einem Bild mit nur 320 Pixel Breite. Der "Trick" ist folgender: Wenn
; das betreffende Bild in gleich große "Blöcke" aufgeteilt ist, von jeweils
; 16 Pixeln Breite, können wir das Auge täuschen, indem wir die Tatsache
; verbergen, dass wir nur 15 Pixel verschieben können und dann wieder von Null
; anfangen. In der Tat reicht es aus, eine "Kachelbreite" zu haben mit einer
; Gesamtzahl von Pixeln, zum Beispiel 16, die auf dem gesamten Bildschirm
; wiederholt werden, um einen kontinuierlichen Bildlauf zu simulieren. Es
; reicht nämlich aus, das ganze Bild pixelweise nach rechts zu verschieben,
; bis die letzte "Kachel" auf der rechten Seite den Rand verlässt und eine
; "ganze" Kachel auf der linken Seite "hineingekommen" ist: Anstatt auf das
; 16. Pixel, was aufgrund der Beschränkung des BPLCON1 unmöglich ist, gehen wir
; einfach 15 Pixel "zurück", und fangen von vorne an.
; Die Realität wird dieselbe sein wie wenn man ein Pixel vorwärts bewegt 
; hätte: Die letzte Kachel rechts wäre komplett verschwunden
; und die erste links wäre komplett "eingetreten". Um Ebenen zu erstellen
; die mit unterschiedlichen Geschwindigkeiten fließen, ist es ausreichend,
; jede dieser Ebenen zu verschieben.
; Die Ebenen werden verschoben, die erste alle 25 Frames, die zweite alle
; 16 Frames und so weiter, bis zu den letzten, die sich nicht bei jeden
; Frame verschieben.
; Um zu zählen, ab wie vielen Frames der Bildlauf der einzelnen Ebenen
; ausgeführt wurde; wurden Zähler verwendet, die dann bei jedem Frame
; inkrementiert werden. Bei einem CMP wird geprüft, ob die richtige Anzahl
; von Frames gescrollt wurde.
; PxCounter1,2 ... sind die Zähler, Parallax1,2 ... sind die BPLCON1 in COPLIST

;	          .=============.
;	         /st!            \
;	____ ___/_________________\___ ____
;	\  (/                         \)  /
;	 \_______________________________/
;	    \__/ ______     ______ \__/
;	    /_\  ¬----/     \----¬  /_\
;	    \/\\_    (_______)    _//\/
;	     \__/ _______________ \__/
;	      /   /\| | | | | |/\   \
;	      \     `-^-^-^-^-'     /
;	       \_____         _____/
;	            `---------'

ParallaxFX:
para1:
	addq.b	#$01,PxCounter1		; den Parallaxenzähler 1 erhöhen
	cmpi.b	#25,PxCounter1		; Geschwindigkeitszähler = 25?
	bne.s	Para2				; noch nicht 25 Frames...
	clr.b	PxCounter1			; letzten 25 Frames! Zähler zurücksetzen
	cmp.b	#$ff,Parallax1		; haben wir den maximalen Scrollwert erreicht?
								; (15 Pixel nach rechts)
	beq.s	riazzera1			; wenn ja, müssen wir von vorne anfangen!
	add.b	#$11,Parallax1		; wenn noch nicht, verschiebe Ebene 1
	bra.s	para2
riazzera1:
	clr.b	Parallax1			; mit der Bildlauf von vorne beginnen 
Para2:
	addq.b	#$01,PxCounter2		; den Parallaxenzähler 2 erhöhen
	cmpi.b	#16,PxCounter2		; Geschwindigkeitszähler=16?
	bne.s	Para3				; (Die Kommentare wären ähnlich wie Para1)
	clr.b	PxCounter2
	cmp.b	#$ff,Parallax2
	beq.s	riazzera2
	add.b	#$11,Parallax2		; Bewegt die Parallaxe 2
	bra.s	para3
riazzera2:
	clr.b	Parallax2
Para3:
	addq.b	#$01,PxCounter3		; den Parallaxenzähler 3 erhöhen
	cmpi.b	#10,PxCounter3		; Geschwindigkeitszähler=10?
	bne.s	Para4
	clr.b	PxCounter3
	cmp.b	#$ff,Parallax3
	beq.s	riazzera3
	add.b	#$11,Parallax3		; Bewegt die Parallaxe 3
	bra.s	para4
riazzera3:
	clr.b	Parallax3
Para4:
	addq.b	#$01,PxCounter4		; den Parallaxenzähler 4 erhöhen
	cmpi.b	#5,PxCounter4		; Geschwindigkeitsmesser=5?
	bne.s	Para5
	clr.b	PxCounter4
	cmp.b	#$ff,Parallax4
	beq.s	riazzera4
	add.b	#$11,Parallax4		; Bewegt die Parallaxe 4
	bra.s	para5
riazzera4:
	clr.b	Parallax4
Para5:
	addq.b	#$01,PxCounter5		; den Parallaxenzähler 5 erhöhen
	cmpi.b	#4,PxCounter5		; Geschwindigkeitsmesser=4?
	bne.s	Para6
	clr.b	PxCounter5
	cmp.b	#$ff,Parallax5
	beq.s	riazzera5
	add.b	#$11,Parallax5		; Bewegt die Parallaxe 5
	bra.s	para6
riazzera5:
	clr.b	Parallax5
Para6:
	addq.b	#$01,PxCounter6		; den Parallaxenzähler 6 erhöhen
	cmpi.b	#3,PxCounter6		; Geschwindigkeitszähler=3?
	bne.s	Para7
	clr.b	PxCounter6
	cmp.b	#$ff,Parallax6
	beq.s	riazzera6
	add.b	#$11,Parallax6		; Bewegt die Parallaxe 6
	bra.s	para7
riazzera6:
	clr.b	Parallax6
Para7:
	addq.b	#$01,PxCounter7		; den Parallaxenzähler 7 erhöhen
	cmpi.b	#2,PxCounter7		; Geschwindigkeitszähler=2?
	bne.s	Para8
	clr.b	PxCounter7
	cmp.b	#$ff,Parallax7
	beq.s	riazzera7
	add.b	#$11,Parallax7		; Bewegt die Parallaxe 7
	bra.s	Para8
riazzera7:
	clr.b	Parallax7
								; BEACHTEN SIE, DASS PARA8, PARA9, PARA10
								; BEI JEDEM FRAME AUSCHGEFÜHRT WIRD. ALSO,
Para8:							; WIR BRAUCHEN KEINEN VERZÖGERUNGSZÄHLER!
	cmp.b	#$ff,Parallax8		; Haben wir den maximalen Bildlauf erreicht?
	bne.s	NonRiazzera8
	clr.b	Parallax8			; parallax8 zurücksetzen
	bra.s	para9
NonRiazzera8:
	add.b	#$11,Parallax8		; Bewegt die Parallaxe 8
Para9:
	cmp.b	#$ee,Parallax9		; Haben wir den maximalen Bildlauf erreicht?
								; Das Maximum ist $ee und nicht $ff, weil diese Ebene
								; in 2er Schritten durchlaufen werden muss
								; Frame, also: 00,22,44,66,88, aa, cc, ee
	bne.s	NonRiazzera9
	clr.b	Parallax9			; parallax9 zurücksetzen
	bra.s	Para10
NonRiazzera9:
	add.b	#$22,Parallax9		; Bewegt die Parallaxe 9 (2 pixel!)
Para10:
	cmp.b	#$cc,Parallax10		; Haben wir den maximalen Bildlauf erreicht?
								; Das Maximum ist $cc und nicht $ff, weil diese Ebene
								; in 4er Schritten durchlaufen werden muss
								; Frame, also: 00, 44, 88, cc
	bne.s	NonRiazzera10
	clr.b	Parallax10			; parallax10 zurücksetzen
	bra.s	ParaFinito
NonRiazzera10:
	add.b	#$44,Parallax10		; Bewegt die Parallaxe 10 (4 pixel)
ParaFinito:
	rts

; Die Variablen, die zur Zählung der Verzögerungen für die ersten 7 Ebenen
; verwendet werden,
; die einmal alle 25,16,10 usw. Frames die Bilder verschieben

PxCounter1:	dc.b	$00
PxCounter2:	dc.b	$00
PxCounter3:	dc.b	$00
PxCounter4:	dc.b	$00
PxCounter5:	dc.b	$00
PxCounter6:	dc.b	$00
PxCounter7:	dc.b	$00
	even

; SubRoutine für Zeiger auf Bitplanes... 

************* d0=Adresse Bild		| d2=Anzahl der Bits pro Ebene
* PointBpls * d1=Anzahl Ebenen-1 für den DBRA		|
************* a1=Adresse Zeiger auf bitplanes	|
PointBpls:
	move.w	d0,6(a1)			; .w low im rechten .w in der CopperList
	swap	d0					; Vertausche die 2 .w von d0
	move.w	d0,2(a1)			; .w high in das rechte .w in der CopperList
	swap	d0					; d0 wieder an seinen Platz setzen
	add.l	d2,d0				; Länge der Bitebenenlänge zu d0 hinzufügen
	addq.w	#8,a1				; Adresse des nächsten bplpointers
	dbra	d1,PointBpls		; Ich beginne den Zyklus erneut
	rts

*****************************************************************************
	SECTION	PROGDATA,DATA_C		; Daten: Das geht in CHIPRAM				*
*****************************************************************************

MyCopList:
	dc.w	$8e,$2c91			; DiwStrt (Videofenster 16 Pixel
								; weiter nach rechts gemacht)
								; um den Fehler zu vertuschen)
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; BplMod1
	dc.w	$10a,0				; BplMod2
	dc.w	$100,$200			; No Bitplanes...

Rainbow:
	dc.w	$180,$a9c
	dc.w	$eb07,$fffe
	dc.w	$180,$bad
	dc.w	$ed07,$fffe
	dc.w	$180,$cbe
	dc.w	$ef07,$fffe
	dc.w	$180,$dce
	dc.w	$f107,$fffe
	dc.w	$180,$ede
	dc.w	$f307,$fffe
	dc.w	$180,$fef

	dc.w	$f407,$fffe			; wait - voraussichtlich

	dc.w	$100,%0101001000000000	; LowRes 32Colors

BPLPointers:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte bitplane
	dc.w	$ec,$0000,$ee,$0000	; vierte bitplane
	dc.w	$f0,$0000,$f2,$0000	; fünfte bitplane

	dc.w	$0180
Colours:
	dc.w	$fff,$182,$f10,$184,$f21,$186,$f42
	dc.w	$188,$f53,$18a,$f63,$18c,$f74,$18e,$f85
	dc.w	$190,$f96,$192,$fa6,$194,$fb7,$196,$fb8
	dc.w	$198,$fc9,$19a,$f21,$19c,$f10,$19e,$f00
	dc.w	$1a0,$eff,$1a2,$eff,$1a4,$dff,$1a6,$dff
	dc.w	$1a8,$cff,$1aa,$bef,$1ac,$bef,$1ae,$adf
	dc.w	$1b0,$9df,$1b2,$9cf,$1b4,$8bf,$1b6,$7bf
	dc.w	$1b8,$7af,$1ba,$69f,$1bc,$68f,$1be,$57f


; HIER IST DER TEIL DER COPPERLISTE, DER FÜR DIE PARALLAXEN VERANTWORTLICH IST:

	dc.w	$f507,$fffe			; Warte Zeile $f5
	dc.w	$180,$f52			; Color0 - orangefarbener Hintergrund für
								; "Einblenden" der Figur

	dc.w	$102				; BPLCON1
	dc.b	$00					; High-Byte, nicht verwendet
Parallax1:
	dc.b	$00					; Low-Byte, Scroll-Wert!!!!

	dc.w	$f607,$fffe			; wait
	dc.w	$102				; BPLCON1
	dc.b	$00					; usw. für jedes "Level"
Parallax2:
	dc.b	$00

	dc.w	$f807,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax3:
	dc.b	$00

	dc.w	$fb07,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax4:
	dc.b	$00

	dc.w	$ff07,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax5:
	dc.b	$00

	dc.w	$ffdf,$fffe			; über die Zeile $FF kommen 

	dc.w	$0407,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax6:
	dc.b	$00

	dc.w	$0b07,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax7:
	dc.b	$00

	dc.w	$1207,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax8:
	dc.b	$00

	dc.w	$1a07,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax9:
	dc.b	$00

	dc.w	$2307,$fffe
	dc.w	$102				; BPLCON1
	dc.b	$00
Parallax10:
	dc.b	$00

	dc.w	$2c07,$fffe
	dc.w	$180,$f30

	dc.w	$FFFF,$FFFE			; Ende CopList

; Das ist das Bild 320 Pixel breit und 56 hoch, 5 Bitebenen (32 Farben)

PARALLAXPIC:
	incbin	"/Sources/Lava320x56x5.raw"	

	END

Dieses Listing wurde von meinem Schüler "Gonzo" erstellt, nachdem er Lektion5
gelesen hatte. Er rief mich an und fragte, wie man eine Parallaxe macht und 
ich antwortete ihm, dass er, sobald, er Lektion 5 gelesen habe, wäre in der
Lage sein werde, obwohl es kein spezifisches Listing dazu gab. Wie Sie sehen,
hat er richtig vermutet wie es geht.
Es gibt jedoch einen kleinen Fehler, der leicht zu beheben ist, nämlich die
Tatsache, dass der klassische "Bildlauffehler" in den ersten 16 Pixeln links
auftritt. Die Figur ist tatsächlich nur 320 Pixel breit, so dass bei der
Bewegung der Figur der Parallaxe mit den verschiedenen Parallaxenstufen auch
der linke Teil der fraglichen Ebene entfernt wird.
Um den Fehler zu sehen, setzen sie DiwStart auf normale Werte zurück, was in
diesem Listing geändert wurde, um das Problem zu "beheben":

	dc.w	$8e,$2c91			; DiwStrt (Videofenster 16 Pixel
								; weiter nach rechts gemacht)
								; um den Fehler zu vertuschen)

Ersetzen Sie ihn durch das Standard $2c81 und Sie werden den Schaden auf der
linken Seite bemerken. Um das Problem dauerhaft zu umgehen, reicht es aus,
das zu tun, was wir für den Scroll einer größeren Figur auf dem Bildschirm
getan haben:
Das Bild muss neu gezeichnet werden, indem es um 16 Pixel breiter gemacht wird,
d.h. 336 Pixel, d.h. wir müssen eine zusätzliche "Kachel" hinzufügen.
An diesem Punkt ist es notwendig, sich daran zu erinnern, dass die Figur sich
bei dieser "Erweiterung" wie im Fall des "riesigen" Bildlaufs verhält,
wobei der Fehler in den 16 "Off-Screen"-Pixeln auf der linken Seite verbleibt.
Dies ist nur eine Grundlage für einen Parallaxenboden. Sie können auch 
Folgendes für einen flüssigen Bildlauf machen, z.B. Zeile für Zeile präzise
vorberechnen, und in einer Tabelle speichern, und Sie können auch die
Palette für jede Ebene ändern, um die Farben mehr zu vermischen. Wenn Sie
möchten, dann fügen Sie Parallaxenwolken, Berge und Vögel hinzu, bitte senden
Sie mir ihre Arbeit!

