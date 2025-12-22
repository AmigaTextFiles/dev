
; Lezione8c.s Eine FADE-Routine (dh Fade) zum und vom SCHWARZEN. ROUTINE Nr.1
; Drücken Sie die linke und rechte Taste

	SECTION	Fade1,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist Etc.
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
;	Zeiger auf unsere Bild

	MOVE.L	#Logo1,d0	; 
	LEA	BPLPOINTERS,A1	; Zeiger COP
	MOVEQ	#4-1,D1		; Anzahl der Bitplanes (hier sind es 4)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0	; + Bitplane-Länge (84 Zeilen hoch hier)
	addq.w	#8,a1
	dbra	d1,POINTBP


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren Sie bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA


mouse1:
	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse1

	clr.w	FaseDelFade	; Setzen Sie die Bildnummer zurück

;	********** erstes verblassen: von SCHWARZ zu Farben *********

mouse2:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse2
Aspetta1:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta1

	bsr.w	FadeIN			; Fade!!!

	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse2

	move.w	#16,FaseDelFade	; Setzen Sie die Bildnummer zurück

;	********** zweites verblassen: von Farben zu SCHWARZ *********

mouse3:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse3
Aspetta2:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta2

	bsr.w	FadeOUT			; Fade!!!

	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse3
	rts


*****************************************************************************
;	Routinen, warten und Fade zur richtigen Zeit aufrufen
*****************************************************************************

FadeIn:
	cmp.w	#17,FaseDelFade
	beq.s	FinitoFadeIn
	moveq	#0,d0
	move.w	FaseDelFade(PC),d0
	moveq	#15-1,d7		; D7 = Anzahl der Farben
	lea	TabColoriPic(PC),a0	; A0 = Adresse Farbtabelle 
							; der Figur "auflösen"
	lea	CopColors+6,a1		; A1 = Farbadresse in copperlist
							; zu beachten ist, dass es von FARBE 1 und 
							; nicht von color0 beginnt,
							; color0 ist = $000 und bleibt so.
	bsr.s	Fade
	addq.w	#1,FaseDelFade	; System für die nächste Phase
FinitoFadeIn:
	rts


FadeOut:
	tst.w	FaseDelFade		; Haben wir die letzte Phase überstanden? (16)?
	beq.s	FinitoOut
	subq.w	#1,FaseDelFade	; System für die nächste Phase zu tun
	moveq	#0,d0
	move.w	FaseDelFade(PC),d0
	moveq	#15-1,d7		; D7 = Anzahl der Farben
	lea	TabColoriPic(PC),a0	; A0 = Adresse Farbtabelle 
							; der Figur "auflösen"
	lea	CopColors+6,a1		; A1 = Farbadresse in copperliste
							; zu beachten ist, dass es von FARBE 1 und 
							; nicht von color0 beginnt,
							; color0 ist = $000 und bleibt so.
	bsr.s	Fade
FinitoOut:
	rts

FaseDelFade:				; aktuelle Phase der Überblendung (0-16)
	dc.w	0

*****************************************************************************
*		Routine zum Ein- und Ausblenden von und nach SCHWARZ	    *
* Eingang:								    *
*									    *
* d7 = Anzahl Farben-1							    *
* a0 = Adresstabelle mit den Farben der Abbildung			    *
* a1 = Erste Farbadresse in copperliste			    *
* d0 = Moment der Überblendung, Multiplikator - zum Beispiel mit d0 = 0 der Bildschirm *
* ist total schwarz, mit d0 = 8 sind wir halb verblasst und mit d0 = 16 *
* sind wir in der vollen Farbe. Es gibt also 17 Phasen von 0 bis 16. *
* Um ein Einblenden von Schwarz zur Farbe zu machen, müssen Sie in jedem *
* Aufruf der Routine einen Wert von d0 erhöhen, der von 0 auf 16 ansteigt *
* Für ein Ausblenden müssen wir von d0 = 16 bis d0 = 0 gehen   *
*									    *
* Das Verfahren von FADE besteht darin, jede Farb-Komponente R, G, B * 
* mit einem Multiplikator von 0 für SCHWARZ (x * 0 = 0) bis 16 für *
* normale Farben zu multiplizieren. Darum wird die Farbe durch 16 geteilt. *
* Eine Farbe mit 16 zu multiplizieren und zu zerlegen bedeutet nichts anderes, 
* als sie gleich zu lassen. *
*									    *
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
	moveq	#0,d1		; leer D1
	moveq	#0,d2		; leer D2

; Finde die resultierende ROTE Komponente (Rot) und trage sie in die copperliste ein ($0R)

	move.b	(a0)+,d1	; D1.b = ROTE Komponente (ROT) der Farbe
						; oder $0R (das Wort ist $0RGB)
	mulu.w	d0,d1		; Multiplizieren Sie es mit der aktuellen Farbstufe
	lsr.w	#4,d1		; Teilen Sie es durch 16 (mit LSR #4) und bringen Sie das
						; Ergebnis rechts (das Byte ist %00001111)
	move.b	d1,(a1)+	; Setzen Sie die neue ROTE Komponente in die
						; copperliste (dh Byte $0R)

; Finde die resultierende Komponente GRÜN (Grün) und setze sie in d1

	move.b	(a0),d1		; D1.b = Grüne Komponente, Blau (GRÜN, BLAU)
						; oder $GB (das Wort ist $0RGB)
	lsr.b	#4,d1		; Bewegen Sie das GRÜNE ganz nach rechts
						; der Wert rechts von 4 Bits (1 Nibble)
						; also haben wir in d1.b nur grün
	mulu.w	d0,d1		; Multiplizieren Sie es mit der aktuellen Farbstufe
	and.b	#$f0,d1		; Wir maskieren, um nur das Ergebnis auszuwählen
						; dass es an diesem Punkt fertig ist, ist es nicht notwendig
						; verschiebe es nach rechts, da im register
						; Farbe ist in dieser Position richtig.
						; in der Tat ist das Low-Byte $ GB (das Wort $ 0RGB)

;  Suchen Sie die resultierende BLAUE Komponente und fügen Sie sie in d2 ein

	move.b	(a0)+,d2	; D2.b = Grüne Komponente, Blau (GRÜN, BLAU)
						; oder $GB (das Wort ist $0RGB)
	and.b	#$0f,d2		; Wir maskieren, um nur BLAU ($0B) auszuwählen
	mulu.w	d0,d2		; Multiplizieren Sie es mit der aktuellen Farbstufe
	lsr.w	#4,d2		; Teilen Sie durch 16 und stellen Sie das Ergebnis nach rechts
						; so dass das Ergebnis $0B ist

; Verbinden Sie die resultierende Komponente GRÜN mit der BLAUEN Komponente mit ODER

	or.w	d2,d1		; BLAU ODER mit GRÜN, um sie in Bytes "zusammenzufügen"
						; resultierendes Finale: $ GB

; Und setzen Sie das resultierende Byte $GB in die copperliste

	move.b	d1,(a1)+	; Geben Sie den Wert GRÜN und BLAU in das Feld ein
						; Low-Byte-$GB der Farbe in der copperliste
	addq.w	#2,a1		; Gehe zur nächsten Farbe der copperliste und springe
						; das $18x Wort
	dbra	d7,ColorLoop	; Wiederholen Sie dies für die anderen Farben
	rts


; Die $180, color0, sind $000, also nicht ändern! Die Tabelle beginnt mit color 1

TabColoriPic:
	dc.w $fff,$200,$310,$410,$620,$841,$a73
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446


*****************************************************************************
;			Copper List
*****************************************************************************
	section	copper,data_c		; Chip data

Copperlist:
	dc.w	$8E,$2c81	; DiwStrt - window start
	dc.w	$90,$2cc1	; DiwStop - window stop
	dc.w	$92,$38		; DdfStart - data fetch start
	dc.w	$94,$d0		; DdfStop - data fetch stop
	dc.w	$102,0		; BplCon1 - scroll register
	dc.w	$104,0		; BplCon2 - priority register
	dc.w	$108,0		; Bpl1Mod - modulo pl. ungleich
	dc.w	$10a,0		; Bpl2Mod - modulo pl. gleich

		    ; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000	; zweite bitplane
	dc.w $e8,$0000,$ea,$0000	; dritte bitplane
	dc.w $ec,$0000,$ee,$0000	; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

CopColors:
	dc.w $180,0,$182,0,$184,0,$186,0
	dc.w $188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0
	dc.w $198,0,$19a,0,$19c,0,$19e,0

;	dc.w $180,$000,$182,$fff,$184,$200,$186,$310
;	dc.w $188,$410,$18a,$620,$18c,$841,$18e,$a73
;	dc.w $190,$b95,$192,$db6,$194,$dc7,$196,$111
;	dc.w $198,$222,$19a,$334,$19c,$99b,$19e,$446

;	Lassen Sie uns ein paar Nuancen für die Szenografie setzen...

	dc.w	$8007,$fffe	; Wait - $2c+84=$80
	dc.w	$100,$200	; bplcon0 - no bitplanes
	dc.w	$180,$003	; color0
	dc.w	$8207,$fffe	; wait
	dc.w	$180,$005	; color0
	dc.w	$8507,$fffe	; wait
	dc.w	$180,$007	; color0
	dc.w	$8a07,$fffe	; wait
	dc.w	$180,$009	; color0
	dc.w	$9207,$fffe	; wait
	dc.w	$180,$00b	; color0

	dc.w	$9e07,$fffe	; wait
	dc.w	$180,$999	; color0
	dc.w	$a007,$fffe	; wait
	dc.w	$180,$666	; color0
	dc.w	$a207,$fffe	; wait
	dc.w	$180,$222	; color0
	dc.w	$a407,$fffe	; wait
	dc.w	$180,$001	; color0

	dc.l	$ffff,$fffe	; Ende copperlist


*****************************************************************************
;				DESIGN
*****************************************************************************

	section	gfxstuff,data_c

; Zeichnen von 320 Pixel breiten, 84 hohen 4-Bit-Ebenen (16 Farben).

; Logo copyright FLENDER/RAM JAM

Logo1:
	;incbin	'logo320*84*16c.raw'
	blk.b 4*3360,$FF		; 4 Bitplanes 
	end

Dieses Listings bietet die Vision eines FADE, dh eines Fades von
SCHWARZ zu Farbe und von Farbe zu SCHWARZ. Da die FADE-Routine erfordert
16 Mal aufgerufen zu werden, um die Farben von SCHWARZ auf die Finale umzustellen
und 16 weitere Male, um danach von Farbe zu Schwarz zurückzukehren, war es 
notwendig die 2 Hilfsroutinen  FadeIn und FadeOut zu schreiben. Die
Fade-Routine, die echte, die einen Multiplikatorwert übergibt
jedes Mal anders, gespeichert im FaseDelFade-Label.
Die Prozedur von FADE besteht darin, jede Farb-Komponente R,G,B mit einen
Multiplikator zu multiplizieren. Von 0 für SCHWARZ (x * 0 = 0) bis 16 für 
die normale Farben. Dafür wird die Farbe durch 16 geteilt. Multiplizieren 
und Teilen Sie eine Farbe mit 16 ist nichts anderes, als sie unverändert zu lassen.
Die Routine in diesem Beispiel ist NUMMER 1 und arbeitet separat auf den
zwei Bytes des Farbwortes. Das nächste Listing enthält eine Routine, die
das gleiche Verfahren wie Multiplikatormultiplikation und Division durch 16 
verwendet, aktualisiert aber das Farbwort nicht byteweise und wird
möglicherweise auch nicht klarer sein. 
Sie verstehen jedoch entweder dieses oder das nächste Beispiel!

