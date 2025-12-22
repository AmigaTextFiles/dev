
; Lezione8g.s - Parallaxe "Boden" Test - 10 Ebenen.

*****************************************************************************
*	PARALLAX 0.5	Copyright © 1994 by Federico "GONZO" Stango	    *
*			Modificato da Fabio Ciucci			    *
*****************************************************************************

	SECTION	MAINPROGRAM,CODE	; Abschnittscode: überall im Speicher

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist Etc.
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
	move.l	#PARALLAXPIC,d0		; Adresse laden Pic in d0
	lea	BPLPointers,a1			; Adresse der Zeiger auf bitplanes
	moveq	#5-1,d1				; Anzahl -1 für den DBRA
	move.w	#40*56,d2			; Bits pro Ebene in d2
	bsr.w	PointBpls			; Aufruf subroutine PointBpls

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#MyCopList,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

MainLoop:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0		; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.s	ParallaxFX		; Springe zum Unterprogramm "Parallaxe"

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0		; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001		; LMT gedrückt?
	bne.s	MainLoop		; Wenn "NEIN" erneut startet
	rts

******************************************************************************
*			 Teil für Unterprogramme		     *
******************************************************************************

; Dies ist die Parallaxenroutine. Es funktioniert auf sehr einfache Weise.
; Tatsächlich werden nur die Werte der 10 BPLCON1-Plätze ($dff102) geändert
; unter dem anderen mit WAITs im "Floor" -Bereich. Na ja, haben wir schon
; in früheren Lektionen gesehen, wie eine Figur "gewellt" werden kann
; mit einer copperlist mit vielen BPLCON1 ($dff102). Sie können
; den Bildschirm mit dem Wert um maximal 15 Pixel SFF nach rechts bewegen,
; während bei $00 die Verschiebung null ist. Nun, anstatt zu winken
; die Zahl, die wir machen wollen, damit es scheint, als würde das Problem für 
; immer weitergehen was sich ergibt, ist das, was wir höchstens durch die Zahl 15 
; scrollen können. 15 Pixel sind nicht unendlich. Wir könnten auch eine große Figur 
; machen einen Kilometer im Speicher, und scrollen Sie auch mit den bplpointers, aber
; es wäre nicht einfach.
; Deshalb müssen wir eine Schriftrolle machen, die unendlich scheint,
; rechts mit nur 320 Pixel Breite. Der "Trick" ist: wenn
; Die betreffende Figur besteht aus "Blöcken" mit einer Größe von jeweils 16 Pixeln
; Sie können das Auge täuschen, indem Sie die Tatsache verbergen, dass wir nur 15 bewegen
; Pixel und dann von vorne "neu starten". In der Tat ist es genug, eine große "Fliese"
; zu haben. Eine Gesamtzahl von Pixeln, zum Beispiel 16, die auf dem gesamten Bildschirm
; wiederholt werden, um zu simulieren.
; Es reicht nämlich aus, das ganze Pixel auf das Bild zu bewegen
; nach rechts drehen, bis das letzte "Plättchen" rechts aus dem ist
; Kante und ein "Ganzes" von der linken Kante "eingegeben" anstatt zu schießen
; auf das sechzehnte Pixel, unter anderem aufgrund der Begrenzung der BPLCON1 unmöglich,
; nur "Schritt zurück" um 15 Pixel, von vorne anfangen, es ist die Situation in
; Die Realität wird dieselbe sein wie die, die sich ergeben hätte, wenn man eine bewegt hätte
; Pixel voraus: Die letzte Kachel rechts wäre komplett verschwunden
; und der erste links wäre komplett "eingetreten". Ebenen zu machen
; die mit unterschiedlichen Geschwindigkeiten laufen, stellen Sie einfach sicher, dass jeder von diesen
; Die Ebenen werden alle 25 Frames, alle 16 Frames und nacheinander verschoben
; so weiter, bis zu den letzten, die nicht nur jeden Frame verschieben müssen, sondern
; Nehmen Sie 2 oder 4 Pixel auf einmal, um schneller als 50 Hz zu sein.
; Um zu zählen, ab wie vielen Frames die Schriftrolle der einzelnen Ebenen ausgeführt wurde
; Es wurden Zähler verwendet, die dann bei jedem Frame inkrementiert werden
; Bei einem CMP wird geprüft, ob die richtige Anzahl von Frames erwartet wurde.
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
	addq.b	#$01,PxCounter1	; Erhöhen Sie den Parallaxenzähler 1
	cmpi.b	#25,PxCounter1	; Geschwindigkeitszähler = 25?
	bne.s	Para2			; noch nicht 25 Frames...
	clr.b	PxCounter1		; letzten 25 Frames! Zähler zurücksetzen
	cmp.b	#$ff,Parallax1	; Wir haben den Scrollwert erreicht
							; Maximum? (15 Pixel nach rechts)
	beq.s	riazzera1		; wenn ja, müssen wir von vorne anfangen!
	add.b	#$11,Parallax1	; wenn noch nicht, verschiebe Level 1
	bra.s	para2
riazzera1:
	clr.b	Parallax1		; Beginnen Sie von vorne mit der Schriftrolle
Para2:
	addq.b	#$01,PxCounter2	; Erhöhen Sie den Parallaxenzähler 2
	cmpi.b	#16,PxCounter2	; Geschwindigkeitsmesser'=16?
	bne.s	Para3			; (Die Kommentare wären ähnlich wie Para1)
	clr.b	PxCounter2
	cmp.b	#$ff,Parallax2
	beq.s	riazzera2
	add.b	#$11,Parallax2	; Bewegen Sie die Parallaxe 2
	bra.s	para3
riazzera2:
	clr.b	Parallax2
Para3:
	addq.b	#$01,PxCounter3	; Erhöhen Sie den Parallaxenzähler 3
	cmpi.b	#10,PxCounter3	; Geschwindigkeitsmesser'=10?
	bne.s	Para4
	clr.b	PxCounter3
	cmp.b	#$ff,Parallax3
	beq.s	riazzera3
	add.b	#$11,Parallax3	; Bewegen Sie die Parallaxe 3
	bra.s	para4
riazzera3:
	clr.b	Parallax3
Para4:
	addq.b	#$01,PxCounter4	; Erhöhen Sie den Parallaxenzähler 4
	cmpi.b	#5,PxCounter4	; Geschwindigkeitsmesser'=5?
	bne.s	Para5
	clr.b	PxCounter4
	cmp.b	#$ff,Parallax4
	beq.s	riazzera4
	add.b	#$11,Parallax4	; Bewegen Sie die Parallaxe 4
	bra.s	para5
riazzera4:
	clr.b	Parallax4
Para5:
	addq.b	#$01,PxCounter5	; Erhöhen Sie den Parallaxenzähler 5
	cmpi.b	#4,PxCounter5	; Geschwindigkeitsmesser'=4?
	bne.s	Para6
	clr.b	PxCounter5
	cmp.b	#$ff,Parallax5
	beq.s	riazzera5
	add.b	#$11,Parallax5	; Bewegen Sie die Parallaxe 5
	bra.s	para6
riazzera5:
	clr.b	Parallax5
Para6:
	addq.b	#$01,PxCounter6	; Erhöhen Sie den Parallaxenzähler 6
	cmpi.b	#3,PxCounter6	; Geschwindigkeitsmesser'=3?
	bne.s	Para7
	clr.b	PxCounter6
	cmp.b	#$ff,Parallax6
	beq.s	riazzera6
	add.b	#$11,Parallax6	; Bewegen Sie die Parallaxe 6
	bra.s	para7
riazzera6:
	clr.b	Parallax6
Para7:
	addq.b	#$01,PxCounter7	; Erhöhen Sie den Parallaxenzähler 7
	cmpi.b	#2,PxCounter7	; Geschwindigkeitsmesser'=2?
	bne.s	Para8
	clr.b	PxCounter7
	cmp.b	#$ff,Parallax7
	beq.s	riazzera7
	add.b	#$11,Parallax7	; Bewegen Sie die Parallaxe 7
	bra.s	Para8
riazzera7:
	clr.b	Parallax7
					;ZU BEACHTEN, DASS PARA8, PARA9, PARA10
					; JEDER FRAME WIRD DURCHGEFÜHRT
Para8:				; BRAUCHEN SIE EINEN VERZÖGERUNGSZÄHLER!
	cmp.b	#$ff,Parallax8	; Haben wir die maximale Schriftrolle erreicht?
	bne.s	NonRiazzera8
	clr.b	Parallax8		; löschen parallax8
	bra.s	para9
NonRiazzera8:
	add.b	#$11,Parallax8	; Bewegen Sie die Parallaxe 8
Para9:
	cmp.b	#$ee,Parallax9	; Haben wir die maximale Schriftrolle erreicht?
					; Das Maximum ist $ee und nicht $ff, weil das Level so ist
					; muss in 2er Schritten ausgelöst werden
					; Frame, für den: 00,22,44,66,88, aa, cc, ee
	bne.s	NonRiazzera9
	clr.b	Parallax9		; löschen parallax9
	bra.s	Para10
NonRiazzera9:
	add.b	#$22,Parallax9	; Bewegen Sie die Parallaxe 9 (2 pixel!)
Para10:
	cmp.b	#$cc,Parallax10	; Haben wir die maximale Schriftrolle erreicht?
					; Das Maximum ist $cc und nicht $ff, da dies
					; Level muss in 4er Schritten ausgelöst werden
					; Frame, für den: 00.44,88, cc
	bne.s	NonRiazzera10
	clr.b	Parallax10		; löschen parallax10
	bra.s	ParaFinito
NonRiazzera10:
	add.b	#$44,Parallax10	; Bewegen Sie die Parallaxe 10 (4 pixel)
ParaFinito:
	rts

; Die Variablen, mit denen die Verzögerungen für die ersten 7 Ebenen gezählt 
; werden, die gezählt werden müssen
; einmal alle 25.16,10 Frames bewegt werden usw. .

PxCounter1:	dc.b	$00
PxCounter2:	dc.b	$00
PxCounter3:	dc.b	$00
PxCounter4:	dc.b	$00
PxCounter5:	dc.b	$00
PxCounter6:	dc.b	$00
PxCounter7:	dc.b	$00
	even

; SubRoutine für Zeiger auf Bitplanes... 

************* d0=Adresse Bild		| d2=Anzahl der Bits pro Etage
* PointBpls * d1=Anzahl Ebenen-1 für den DBRA		|
************* a1=Adresse Zeiger auf bitplanes	|
PointBpls:
	move.w	d0,6(a1)	; .w unten rechts .w in der CopperList
	swap	d0			; Vertausche die 2 .w von d0
	move.w	d0,2(a1)	; .w ganz rechts .w in der CopperList
	swap	d0			; Ich lege es zurück d0
	add.l	d2,d0		; Ich füge Länge hinzu bitplane a d0 - pross. BITP.
	addq.w	#8,a1		; Adresse des nächsten bplpointers
	dbra	d1,PointBpls	; Ich beginne den Zyklus erneut
	rts

*****************************************************************************
	SECTION	PROGDATA,DATA_C		; Daten: Das geht in CHIPRAM	    *
*****************************************************************************

MyCopList:
	dc.w	$8e,$2c91	; DiwStrt (Videofenster gemacht
						; ab 16 pixel weiter rechts nach
						; den Schrecken verbergen
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; BplMod1
	dc.w	$10a,0		; BplMod2
	dc.w	$100,$200	; No Bitplanes...

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

	dc.w	$f407,$fffe	; wait - voraussichtlich

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

	dc.w	$f507,$fffe	; Warte Zeile $f5
	dc.w	$180,$f52	; Color0 - orangefarbener Hintergrund für "Tarnung"
						; mit der Figur

	dc.w	$102		; BPLCON1
	dc.b	$00			; High-Byte, nicht verwendet
Parallax1:
	dc.b	$00			; Low-Byte, Scroll-Wert!!!!

	dc.w	$f607,$fffe	; wait
	dc.w	$102		; BPLCON1
	dc.b	$00			; usw. für jedes "Level"
Parallax2:
	dc.b	$00

	dc.w	$f807,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax3:
	dc.b	$00

	dc.w	$fb07,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax4:
	dc.b	$00

	dc.w	$ff07,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax5:
	dc.b	$00

	dc.w	$ffdf,$fffe	; über die Linie kommen $FF

	dc.w	$0407,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax6:
	dc.b	$00

	dc.w	$0b07,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax7:
	dc.b	$00

	dc.w	$1207,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax8:
	dc.b	$00

	dc.w	$1a07,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax9:
	dc.b	$00

	dc.w	$2307,$fffe
	dc.w	$102		; BPLCON1
	dc.b	$00
Parallax10:
	dc.b	$00

	dc.w	$2c07,$fffe
	dc.w	$180,$f30

	dc.w	$FFFF,$FFFE	; Ende CopList

; Das Bild ist 320 Pixel breit und 56 hoch, 5 Bitebenen (32 Farben)

PARALLAXPIC:
	;incbin	"Lava320*56*5.Raw"	
	blk.b 4*3360,$FF	

	END

Dieses Listing wurde von meinem Schüler "Gonzo" erstellt, nachdem er LEZIONE5 gelesen 
hatte. Er rief mich an und fragte mich, wie man eine Parallaxe macht, und ich antwortete
ihm. Sofort, wenn er Lektion 5 gelesen hätte, wäre er dazu in der Lage. Obwohl es kein
spezifisches Listing gab. Wie Sie sehen, hat er richtig geraten wie es geht.
Es gibt jedoch einen leicht entfernbaren Fehler, nämlich die Tatsache, dass
der klassische "Fehler" der Schriftrolle in den ersten 16 Pixeln links auftritt. Die
Figur ist in der Tat nur 320 Pixel breit, also wenn er die verschiedenen Ebenen von
Parallaxe bewegt nimmt er auch die linke Seite des fraglichen Niveaus weg. 
Siehe den DiwStart-Fehler, der in diesem Listing auf normaler Ebene gemeldet wird
Er wurde modifiziert, um das Problem zu "stopfen":

	dc.w	$8e,$2c91	; DiwStrt (Videofenster gemacht
						; ab 16 pixel weiter rechts nach
						; vertuschen Sie den Horror äh. Fehler)

Ersetzen Sie es durch das Standard- $2c81 und Sie werden den Schaden auf der linken 
Seite bemerken. Um das Problem endgültig zu überwinden, reicht es aus, das zu tun, was 
wir für den Scroll einer größeren Figur auf dem Bildschirm getan haben:
Die Figur muss neu gezeichnet werden, der Bodenbelag macht es 16 Pixel größer oder 
336 Pixel, das heißt, Wir müssen eine zusätzliche "Kachel" hinzufügen. An diesem Punkt 
ist es notwendig, sich zu konzentrieren. Die Figur erinnert sich an diese "Erweiterung"
und verhält sich wie im Fall des "riesigen" Bildlaufs, wobei der Fehler in den 16 
"Off-Screen" -Pixeln auf der linken Seite verbleibt.
Dies ist nur eine Basis für einen Parallaxenboden. Es könnte auch eine flüssigere 
Strömung erzeugt werden, Zeile für Zeile, die präzise berechnet wird.
Mathematik mit einer Tabelle, und Sie könnten auch die Palette für jede Ebene ändern,
um die Farben mehr zu mischen. Wenn Sie möchten, dann fügen Sie die
Parallaxenwolken hinzu, die Berge und die kleinen Vögel, bitte senden Sie mir
ihre Arbeit!

