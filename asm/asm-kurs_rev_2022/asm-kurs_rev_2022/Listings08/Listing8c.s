
; Listinge8c.s		Eine FADE-Routine (dh Ein-und Ausblenden) zum und vom
; SCHWARZEN. ROUTINE Nr.1
; Drücken Sie die linke und rechte Taste

	SECTION	Fade1,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper- und Bitplane-DMA aktiviert
;			 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA

START:
	MOVE.L	#Logo1,d0			; Adresse der Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer in der copperlist
	MOVEQ	#4-1,D1				; Anzahl der Bitplanes (hier sind es 4)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0			; + Länge einer Bitplane (84 Zeilen hoch hier)
	addq.w	#8,a1
	dbra	d1,POINTBP


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren Sie bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren


mouse1:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse1

	clr.w	FaseDelFade			; die Bildnummer zurücksetzen

;	********** erstes Fade (Einblenden): von SCHWARZ zu Farben *********

mouse2:
	CMP.b	#$ff,$dff006		; Zeile 255
	bne.s	mouse2
Aspetta1:
	CMP.b	#$ff,$dff006		; Zeile 255
	beq.s	Aspetta1

	bsr.w	FadeIN				; Fade!!!

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse2

	move.w	#16,FaseDelFade		; die Bildnummer zurücksetzen

;	********** zweites Fade (Ausblenden): von Farben zu SCHWARZ *********

mouse3:
	CMP.b	#$ff,$dff006		; Zeile 255
	bne.s	mouse3
Aspetta2:
	CMP.b	#$ff,$dff006		; Zeile 255
	beq.s	Aspetta2

	bsr.w	FadeOUT				; Fade!!!

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse3
	rts


*****************************************************************************
;	Routinen, warten und Fade zur richtigen Zeit aufrufen
*****************************************************************************

FadeIn:
	cmp.w	#17,FaseDelFade
	beq.s	FinitoFadeIn
	;moveq	#0,d0
	move.w	FaseDelFade(PC),d0
	moveq	#15-1,d7			; D7 = Anzahl der Farben
	lea	TabColoriPic(PC),a0		; A0 = Adresse Farbtabelle 
								; der Figur "aufbauen"
	lea	CopColors+6,a1			; A1 = Farbadresse in copperlist
								; zu beachten ist, dass es von color1 und 
								; nicht von color0 beginnt,
								; color0 ist = $000 und bleibt so.
	bsr.s	Fade
	addq.w	#1,FaseDelFade		; den nächsten Schritt vorbereiten
FinitoFadeIn:
	rts


FadeOut:
	tst.w	FaseDelFade			; Haben wir die letzte Phase erreicht? (16)?
	beq.s	FinitoOut
	subq.w	#1,FaseDelFade		; den nächsten Schritt vorbereiten
	;moveq	#0,d0
	move.w	FaseDelFade(PC),d0
	moveq	#15-1,d7			; D7 = Anzahl der Farben
	lea	TabColoriPic(PC),a0		; A0 = Adresse Farbtabelle 
								; der Figur "auflösen"
	lea	CopColors+6,a1			; A1 = Farbadresse in copperliste
								; zu beachten ist, dass es von color1 und 
								; nicht von color0 beginnt,
								; color0 ist = $000 und bleibt so.
	bsr.s	Fade
FinitoOut:
	rts

FaseDelFade:					; aktuelle Phase der Überblendung (0-16)
	dc.w	0

*****************************************************************************
*		Routine zum Ein- / Ausblenden von und nach SCHWARZ				    *
* Eingang:																	*
*																			*
* d7 = Anzahl der Farben-1													*
* a0 = Adresse Tabelle mit den Farben des Bildes							*
* a1 = Adresse der ersten Farbe in der copperliste							*
* d0 = Moment der Überblendung, Multiplikator -								*
* zum Beispiel mit d0 = 0 ist der Bildschirm völlig schwarz,				*
* mit d0 = 8 sind wir bei halber Helligkeit und mit d0 = 16					*
* sind wir in der vollen Farbe. Es gibt also 17 Phasen von 0 bis 16.		*
* Um ein Einblenden von schwarz zur Farbe zu machen, müssen wir mit jedem	*
* Aufruf der Routine den Wert von d0 erhöhen, der von 0 auf 16 ansteigt		*
* Für ein Ausblenden müssen wir von d0 = 16 bis d0 = 0 gehen				*
*																			*
* Die FADE Prozedur besteht darin, jede Farb-Komponente R, G, B				*
* mit einem Multiplikator von 0 für SCHWARZ (x * 0 = 0) bis 16 für			*
* normale Farben zu multiplizieren. Darum wird die Farbe durch 16 geteilt.  *
* Eine Farbe mit 16 zu multiplizieren und zu dividieren bedeutet nichts		*
* anderes, als sie gleich zu lassen.										*
*																			*
*****************************************************************************


;	        \   / 
;	        .\-/.
;	    /\ ()   ()
;	   /  \/~---~\.-~^-.
;	.-~^-./   |   \---.
;	     {    |    }   \
;	   .-~\   |   /~-.
;	  /    \  I  /    \
;	        \/ \/

Fade:
ColorLoop:
	moveq	#0,d1				; d1 zurückgesetzt
	moveq	#0,d2				; d2 zurückgesetzt

; Finde die resultierende ROTE Komponente und trage sie in der copperliste ein ($0R)

	move.b	(a0)+,d1			; d1.b = ROTE Komponente der Farbe
								; oder $0R (das Wort ist $0RGB)
	mulu.w	d0,d1				; mit der aktuellen Farbstufe multiplizieren
	lsr.w	#4,d1				; durch 16 teilen (mit LSR #4) und das Ergebnis nach
								; rechts bringen (das Byte ist %00001111)
	move.b	d1,(a1)+			; die neue ROTE Komponente in der
								; copperliste (dh Byte $0R) speichern

; Finde die resultierende GRÜNE Komponente und setze sie in d1

	move.b	(a0),d1				; d1.b = GRÜNE, BLAUE Komponente
								; oder $GB (das Wort ist $0RGB)
	lsr.b	#4,d1				; wir verschieben das GRÜNE ganz nach rechts
								; um 4 Bits (1 Nibble)
								; also haben wir in d1.b nur grün
	mulu.w	d0,d1				; mit der aktuellen Farbstufe multiplizieren
	and.b	#$f0,d1				; wir maskieren, um nur das Ergebnis auszuwählen
								; da es an diesem Punkt fertig ist, ist es nicht notwendig
								; es nach rechts zu verschieben , da im Register
								; die Farbe sich in dieser Position befindet.
								; tatsächlich ist das Low-Byte $GB (das Wort $0RGB)

;  Finde die resultierende BLAUE Komponente und setze sie in d2 ein

	move.b	(a0)+,d2			; d2.b = GRÜNE, BLAUE Komponente
								; oder $GB (das Wort ist $0RGB)
	and.b	#$0f,d2				; wir maskieren, um nur BLAU ($0B) auszuwählen
	mulu.w	d0,d2				; mit der aktuellen Farbstufe multiplizieren
	lsr.w	#4,d2				; durch 16 dividieren und das Ergebnis nach rechts
								; übertragen, so dass das Ergebnis $0B ist

; die resultierende GRÜNE Komponente mit der BLAUEN Komponente mit ODER "verbinden"

	or.w	d2,d1				; GRÜN ODER BLAU, um sie in Bytes "zusammenzufügen"
								; resultierendes Ergebnis: $GB

; Und das resultierende Byte $GB in die copperliste einsetzen

	move.b	d1,(a1)+			; den GRÜNEN und BLAUEN Wert in das Feld 
								; niedriges $GB-Byte der Farbe in der copperliste eingeben
	addq.w	#2,a1				; zur nächsten Farbe der copperliste gehen und
								; das Wort $18x überspringen
	dbra	d7,ColorLoop		; für die anderen Farben wiederholen
	rts


; die $180, color0, sind $000, also nicht ändern! Die Tabelle beginnt mit color 1

TabColoriPic:
	dc.w $fff,$200,$310,$410,$620,$841,$a73
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446


*****************************************************************************
;			Copper List
*****************************************************************************
	section	copper,data_c		; Chip data

Copperlist:
	dc.w	$8E,$2c81			; DiwStrt - window start
	dc.w	$90,$2cc1			; DiwStop - window stop
	dc.w	$92,$38				; DdfStart - data fetch start
	dc.w	$94,$d0				; DdfStop - data fetch stop
	dc.w	$102,0				; BplCon1 - scroll register
	dc.w	$104,0				; BplCon2 - priority register
	dc.w	$108,0				; Bpl1Mod - modulo pl. ungleich
	dc.w	$10a,0				; Bpl2Mod - modulo pl. gleich

				; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte bitplane
	dc.w	$ec,$0000,$ee,$0000	; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

CopColors:
	dc.w	$180,0,$182,0,$184,0,$186,0
	dc.w	$188,0,$18a,0,$18c,0,$18e,0
	dc.w	$190,0,$192,0,$194,0,$196,0
	dc.w	$198,0,$19a,0,$19c,0,$19e,0

;	dc.w	$180,$000,$182,$fff,$184,$200,$186,$310
;	dc.w	$188,$410,$18a,$620,$18c,$841,$18e,$a73
;	dc.w	$190,$b95,$192,$db6,$194,$dc7,$196,$111
;	dc.w	$198,$222,$19a,$334,$19c,$99b,$19e,$446

;	Lassen Sie uns ein paar Nuancen für die Szenografie setzen...

	dc.w	$8007,$fffe			; Wait - $2c+84=$80
	dc.w	$100,$200			; bplcon0 - no bitplanes
	dc.w	$180,$003			; color0
	dc.w	$8207,$fffe			; wait
	dc.w	$180,$005			; color0
	dc.w	$8507,$fffe			; wait
	dc.w	$180,$007			; color0
	dc.w	$8a07,$fffe			; wait
	dc.w	$180,$009			; color0
	dc.w	$9207,$fffe			; wait
	dc.w	$180,$00b			; color0
	dc.w	$9e07,$fffe			; wait
	dc.w	$180,$999			; color0
	dc.w	$a007,$fffe			; wait
	dc.w	$180,$666			; color0
	dc.w	$a207,$fffe			; wait
	dc.w	$180,$222			; color0
	dc.w	$a407,$fffe			; wait
	dc.w	$180,$001			; color0
	dc.l	$ffff,$fffe			; Ende copperlist


*****************************************************************************
;				DESIGN
*****************************************************************************

	section	gfxstuff,data_c

; Zeichnung 320 Pixel breit, 84 hoch 4 Bitebenen (16 Farben).

; Logo copyright FLENDER/RAM JAM

Logo1:
	incbin	"/Sources/logo320x84x16c.raw"	; 4 Bitplanes 

	end

Dieses Listings bietet einen Blick auf einen FADE, dh eine Überblendung von
SCHWARZ zu Farbe und von Farbe zu SCHWARZ. Da die FADE-Routine 16 Mal
aufgerufen werden muss, um die Farben von SCHWARZ in die endgültigen Farben
und weitere 16 Mal, um von der Farbe zu Schwarz zurückzukehren, war es
notwendig, die 2 Hilfsroutinen FadeIn und FadeOut zu schreiben. 
Die Fade-Routine, die echte, die einen Multiplikatorwert übergibt jedes Mal
einen anderen Wert, gespeichert im Label FaseDelFade. Die FADE-Routine
multipliziert jede R,G,B-Farb-Komponente mit einen Multiplikator von 0 für
SCHWARZ (x * 0 = 0) bis 16 für die normalen Farben und teilt sie dann durch 16.
Multiplizieren und Teilen einer Farbe mit 16 ist nichts anderes, als sie
unverändert zu lassen.
Die Routine in diesem Beispiel ist Version 1 und arbeitet separat auf den
zwei Bytes des Farbwortes. Das nächste Listing enthält eine Routine, mit
dem gleichen Verfahren wie die Multiplikation mit dem Multiplikator und
Division durch 16, aktualisiert aber das Farbwort nicht byteweise, und
vielleicht wird es Ihnen dann etwas klarer werden. Wie auch immer, entweder
Sie verstehen dieses Beispiel oder das nächste!


