
; Lezione8e.s Eine FADE-Routine (dh Fade) mit einer Änderung in Bezug auf die Mischung
; Tatsächlich ist es möglich, einen RGB-Farbverlauf anzugeben, der angestrebt wird.
; Drücken Sie die linke und rechte Taste mehrmals, um zu sehen und zu beenden.

	SECTION	Fade1,CODE

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

	MOVE.W	#DMASET,$96(a5)		; DMACON - Aktivieren Sie Bitplane, copper
								; und Sprites.
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA
	
mouse1:
	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse1

;	****************+ Teil 1 mit einer Tendenz zu ROT *****************

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück
	move.w	#$b12,Tendenza	; setzt die Tendenz auf rot ******

mouse2:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse2
Aspetta1:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta1

	bsr.w	FadeIN			; Fade!!!

	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse2

	move.w	#16,FaseDelFade	; Teile von Rahmen 16

mouse3:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse3
Aspetta2:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta2

	bsr.w	FadeOUT			; Fade!!!

	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse3

;	****************+Teil 2 mit einer Tendenz zu GRÜN *****************

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück
	move.w	#$373,Tendenza	; setzt den grünen Trend ******

mouse2x:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse2x
Aspetta1x:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta1x

	bsr.w	FadeIN			; Fade!!!

	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse2x

	move.w	#16,FaseDelFade	; Teile von Rahmen 16

mouse3x:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse3x
Aspetta2x:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta2x

	bsr.w	FadeOUT			; Fade!!!

	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse3x


;	****************+ Teil 3 mit einer Tendenz zu BLAU*****************

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück
	move.w	#$33c,Tendenza	; setzt die Tendenz auf BLAU ******

mouse2y:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse2y
Aspetta1y:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta1y

	bsr.w	FadeIN			; Fade!!!

	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse2y

	move.w	#16,FaseDelFade	; Teile von Rahmen 16

mouse3y:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse3y
Aspetta2y:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta2y

	bsr.w	FadeOUT			; Fade!!!

	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse3y

	rts


*****************************************************************************
;	Routinen,  warten und Fade zur richtigen Zeit aufrufen
*****************************************************************************

FadeIn:
	cmp.w	#17,FaseDelFade
	beq.s	FinitoFadeIn
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
	addq.w	#1,FaseDelFade	; System für die nächste Phase zu tun
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
*		Routine zum Ein- und Ausblenden von und zu WEISS		    *
* Eingang:								    *
*									    *
* d7 = Anzahl der Farben-1							    *
* a0 = Adresstabelle mit den Farben der Abbildung			    *
* a1 = Adresse der ersten Farbe in copperliste				    *
* d0 = Moment der Überblendung, Multiplikator - zum Beispiel mit d0 = 0 der Bildschirm *
* ist völlig weiß, mit d0 = 8 sind wir halb verblasst und mit d0 = 16 *
* sind wir in der vollen Farbe. Es gibt also 17 Phasen von 0 bis 16. *
* Um ein Einblenden von Weiß zur Farbe zu machen, müssen Sie in jedem *
* Aufruf der Routine einen Wert von d0 erhöhen, der von 0 auf 16 ansteigt *
* Für ein Ausblenden müssen Sie von d0 = 16 bis d0 = 0 gehen *
* d6 = Farbe, die der Überblendung hinzugefügt werden soll, um bestimmte 
* Farbtöne zu erzielen	    *
*									    *
* Die Prozedur von FADE ist, jede Farb-Komponente R, G, B  *
* mit einem Multiplikator von 0 für SCHWARZ (x * 0 = 0) bis 16 für *
* normale Farben zu multiplizieren. Darum wird die Farbe durch 16 geteilt. *
* Eine Farbe mit 16 zu multiplizieren und zu zerlegen bedeutet nichts anderes, *
* als sie gleich zu lassen.*
* Die Modifikation besteht einfach aus dem Hinzufügen der Farben in d6 *
* und dividiere das Ergebnis durch 2, um insgesamt $f * nicht zu überschreiten.
*									    *
*****************************************************************************

;	               .-~~~-.
;	             /        }
;	            /      .-~
;	  \        |        }
;	___\.~~-.-~|     .-~_
;	   { O  |  `  -~      ~-._
;	    ~--~/-|_\         .-~
;	       /  |  \~ - - ~
;	      /   |   \

Fade:
	MOVE.W	Tendenza(PC),D6	;	; RGB-Trendmaske
Fade1:
	MOVE.W	D6,D1		; Kopie Farbtendenz in d1
	MOVE.W	D6,D2		; in d2
	MOVE.W	D6,D3		; in d3
	ANDI.W	#$00f,D1	; SELEK. NUR BLAU
	ANDI.W	#$0f0,D2	; SELEK. NUR GRÜN
	ANDI.W	#$f00,D3	; SELEK. NUR ROT

;	Berechnen Sie die BLAUE Komponente

	MOVE.W	(A0),D4		; Setze die Farbe aus der Farbtabelle in d4 ein
	AND.W	#$00f,D4	; Wählen Sie nur die blaue Komponente ($RGB -> $00B)					
	ADD.W	D1,D4		; Fügen Sie die BLAUE Trend-Komponente hinzu
	LSR.W	#1,D4		; und dividiere durch 2 durch eine Verschiebung von 1 Bit a>
						; Ende der Änderung
	MULU.W	D0,D4		; Mit der Fade-Phase multiplizieren (0-16)
	ASR.W	#4,D4		; Verschieben Sie 4 BITS nach rechts, dh dividieren Sie durch 16
	AND.W	#$00f,D4	; Wählen Sie nur die BLAUE Komponente
	MOVE.W	D4,D5		; Speichern Sie die BLAUE Komponente in d5
	
;	Berechnen Sie die GRÜNE Komponente

	MOVE.W	(A0),D4		; Setze die Farbe aus der Farbtabelle in d4 ein
	AND.W	#$0f0,D4	; Wählen Sie nur die grüne Komponente ($RGB->$0G0)		
	ADD.W	D2,D4		; Fügen Sie die GRÜNE Trendkomponente hinzu
	LSR.W	#1,D4		; und dividiere durch 2 durch eine Verschiebung von 1 Bit a>
						; Ende der Änderung
	MULU.W	D0,D4		; Mit der Fade-Phase multiplizieren (0-16)
	ASR.W	#4,D4		; Verschieben Sie 4 BITS nach rechts, dh dividieren Sie durch 16
	AND.W	#$0f0,D4	; Wählen Sie nur die GRÜNE Komponente
	OR.W	D4,D5		; Speichern Sie die GRÜNE Komponente zusammen mit der BLAUEN
	
;	Berechnen Sie die ROTE Komponente

	MOVE.W	(A0)+,D4	; Lesen Sie die Farbe aus der Tabelle
						; und auf die nächste Spalte zeigen
	AND.W	#$f00,D4	; Wählen. nur die rote Komponente ($RGB -> $R00)
	ADD.W	D3,D4		; Fügen Sie die ROTE Trend-Komponente hinzu
	LSR.W	#1,D4		; und dividiere durch 2 durch eine Verschiebung von 1 Bit a>
						; Ende der Änderung
	MULU.W	D0,D4		; Mit der Fade-Phase multiplizieren (0-16)
	ASR.W	#4,D4		; Verschieben Sie 4 BITS nach rechts, dh dividieren Sie durch 16
	AND.W	#$f00,D4	; Wählen sie nur die rote Komponente ($RGB->$R00)
	OR.W	D4,D5		; Speichern Sie die Farbe ROT zusammen mit BLAU und GRÜN

	MOVE.W	D5,(A1)		; Und setzen Sie die endgültige Farbe $0RGB in die copperliste
	addq.w	#4,a1		; nächste Farbe in copperliste
	DBRA	D7,Fade1	; Mach alle Farben
	rts


Tendenza:
	dc.w	0

; die $180, color0, sind $ 000, also nicht ändern! Die Tabelle beginnt mit color1

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
	dc.w	$108,0		; Bpl1Mod - modulo pl. ungerade
	dc.w	$10a,0		; Bpl2Mod - modulo pl. gerade

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

Logo1:
	;incbin	'logo320*84*16c.raw'
	blk.b 4*3360,$FF
	end

Dies ist eine einfache Modifikation der vorherigen Routine.

