
; Lezione8f.s Eine FADE-Routine (dh Fade) von und nach JEDER FARBE
; Drücken Sie abwechselnd die linke und rechte Taste, um die verschiedenen Optionen 
; anzuzeigen

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

;	********** erstes verblassen: von SCHWARZ zu Farben *********

mouse2:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse2
Aspetta1:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta1

	lea	Cstart1-2,a1		; Start Farbtabelle
	lea	Cend1-2,a2			; End Farbtabelle
	bsr.w	dofade			; Fade!!!


	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse2

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück

;	********** zweites verblassen: von Farben zu SCHWARZ *********

mouse3:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse3
Aspetta2:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta2

	lea	Cstart2-2,a1		; Start Farbtabelle
	lea	Cend2-2,a2			; End Farbtabelle
	bsr.w	dofade			; Fade!!!


	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse3

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück

;	********** drittes verblassen: von WEISS zu Farben *********

mouse4:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse4
Aspetta3:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta3

	lea	Cstart3-2,a1		; Start Farbtabelle
	lea	Cend3-2,a2			; End Farbtabelle
	bsr.w	dofade			; Fade!!!


	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse4

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück

;	********** viertes verblassen: von FARBEN zu anderen verschiedenen Farben! *********

mouse5:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse5
Aspetta4:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta4

	lea	Cstart4-2,a1		; Start Farbtabelle
	lea	Cend4-2,a2			; End Farbtabelle
	bsr.w	dofade			; Fade!!!


	btst	#6,$bfe001		; Maus gedrückt?
	bne.s	mouse5

	clr.w	FaseDelFade		; Setzen Sie die Bildnummer zurück

;	********** fünftes verblassen: von FARBEN zu anderen verschiedenen Farben! *********

mouse6:
	CMP.b	#$ff,$dff006	; Zeile 255
	bne.s	mouse6
Aspetta5:
	CMP.b	#$ff,$dff006	; Zeile 255
	beq.s	Aspetta5

	lea	Cstart5-2,a1		; Start-color-table
	lea	Cend5-2,a2			; End Farbtabelle
	bsr.w	dofade			; Fade!!!

	btst	#2,$dff016		; Maus gedrückt?
	bne.s	mouse6

	rts


*****************************************************************************
*	Routine zum Ein- und Ausblenden in und aus einer beliebigen Farbe!		    *
* Eingabe:								    *
*									    *
* d6 = Anzahl Farben-1							    *
* a1 = Adresstabelle 1 mit den Farben des Bildes (Quelle)	    *
* a2 = Adresstabelle 2 mit den Farben des Bildes (Ziel)    *
* a0 = erste Farbadresse in copperlist				    *
* FaseDelFade-Label als d0 für vorherige Routinen verwendet, *
* = Moment der Überblendung, Multiplikator, in diesem Fall ist es jedoch notwendig, *
*  ihn zurückzusetzen. Einfach, um eine neue Überblendung zu starten		    *
*									    *
* Der Ablauf der Routine ist komplexer als die vorherigen und *
* eigentlich weiß ich gar nicht mehr, wie genau das funktioniert. *
* Lesen Sie meine alten Kommentare, aber Sie wissen, wie man es benutzt  *
*									    *
*****************************************************************************

;	           .--._.--. 
;	          ( O     O ) 
;	          /   . .   \ 
;	         .`._______.'. 
;	        /(    \_/    )\ 
;	      _/  \  \   /  /  \_ 
;	   .~   `  \  \ /  /  '   ~. 
;	  {    -.   \  V  /   .-    } 
;	_ _`.    \  |  |  |  /    .'_ _ 
;	>_       _} |  |  | {_       _< 
;	 /. - ~ ,_-'  .^.  `-_, ~ - .\ 
;	         '-'|/   \|`-` 

dofade:
	cmp.w	#17,FaseDelFade	; Haben wir die letzte Phase überstanden? (16)?
	beq.s	FadeFinito
	lea	CopColors+2,a0		; Copper
	move.w	#15-1,d6		; Anzahl Farben 
	bsr.w	fade2			; Aufruf Fading!
FadeFinito:
	rts

; benutze d0-d6/a0-a2

fade2:
f2main:
	addq.w	#4,a0			; gehe zum nächsten Farbregister in der copperliste
	addq.w	#2,a1			; gehe zur nächsten Farbe der Quell-Farbtabelle.
	addq.w	#2,a2			; Das Gleiche gilt für die Zielfarbentabelle
	move.w	(a0),d0			; Farbe von copperlist in d0
	move.w	(a2),d1			; Farbe Zieltabelle in d1
	cmp.w	d0,d1			; Sie sind die gleichen?
	beq.w	ProssimoColore		; wenn ja, gehe zur nächsten Farbe
	move.w	FaseDelFade(PC),d4	; Phase der Überblendung in d4 (0-16)
	clr.w	ColoreFinale		; Setzen Sie die endgültige Farbe zurück

;	BLAU

	move.w	(a1),d0		; aktuelle Farbe der QuellFarbtabelle in d0
	move.w	(a2),d2		; Farbe der Ziel-Farbentabelle in d2
	and.l	#$00f,d0	; Wählen Sie nur das BLAU von der Farbe der Quelltabelle
	and.l	#$00f,d2	; Farbe der Zielfarbentabelle
	cmp.w	d2,d0		; sind BLAU Quelle und Ziel gleich?
	bhi.b	SottraiD2	; wenn d2>d0, FadCh1a
	beq.b	SottraiD2	; wenn sie gleich sind, subtrahiere d2
	sub.w	d0,d2		; wenn d2<d0, sub d0 bis d2!
	bra.b	SottFatto
SottraiD2:
	sub.w	d2,d0		; sonst subba d2 bis d0!
	bra.b	SottFatto2

SottFatto:
	move.w	d2,d0
SottFatto2:
	moveq	#16,d1
	bsr.w	dodivu
	and.w	#$00f,d1	; nur BLAU auswählen
	move.w	(a1),d0		; aktuelle Farbe der Quell-Farbtabelle in d0
	move.w	(a2),d2		; Farbe der Ziel-Farbtabelle in d2
	and.w	#$00f,d0	; Wählen Sie nur das BLAU von der Farbe der Quelltabelle
	and.w	#$00f,d2	; Farbe der Zielfarbentabelle
	cmp.w	d0,d2		; sind BLAU Quelle und Ziel gleich?
	bhi.b	SommaD1		; wenn d0>d2, Summe d1 bis d0
	beq.b	OkBlu		; wenn sie gleich sind, ok
	sub.w	d1,d0		; d0=d0-d1
	bra.b	OkBlu
SommaD1:
	add.w	d1,d0		; d0=d0+d1
OkBlu:
	move.w	d0,ColoreFinale	; Speichern Sie das endgültige BLAU

; GRÜN

	move.w	(a1),d0		; aktuelle Farbe der Quell-Farbtabelle in d0
	move.w	(a2),d2		; Farbe der Ziel-Farbtabelle in d2
	and.l	#$0f0,d0	; Wählen Sie nur das GRÜN von der Farbe der Quelltabelle
	and.l	#$0f0,d2	; Farbe der Zielfarbentabelle
	cmp.w	d2,d0		; sind GRÜN Quelle und Ziel gleich?
	bhi.b	SottraiD2v	; wenn d2>d0, FadCh1a
	beq.b	SottraiD2v	; wenn sie gleich sind, subtrahiere d2
	sub.w	d0,d2		; wenn d2<d0, subba d0 bis d2!
	bra.b	SottFattov
SottraiD2v:
	sub.w	d2,d0		; sonst sub d2 bis d0!
	bra.b	SottFatto2v

SottFattov:
	move.w	d2,d0
SottFatto2v:
	moveq	#16,d1
	bsr.w	dodivu
	and.w	#$0f0,d1	; wähle nur GRÜN
	move.w	(a1),d0		; aktuelle Farbe der Quell-Farbtabelle in d0
	move.w	(a2),d2		; Farbe der Ziel-Farbtabelle in d2
	and.w	#$0f0,d0	; Wählen Sie nur das GRÜN von der Farbe der Quelltabelle
	and.w	#$0f0,d2	; Farbe der Zielfarbentabelle
	cmp.w	d0,d2		; sind GRÜN Quelle und Ziel gleich?
	bhi.b	SommaD1v	; wenn d0>d2, Summe d1 bis d0
	beq.b	OkVERDE		; wenn sie gleich sind, ok
	sub.w	d1,d0		; d0=d0-d1
	bra.b	OkVERDE
SommaD1v:
	add.w	d1,d0		; d0=d0+d1
OkVERDE:
	or.w	d0,ColoreFinale	; mit dem OP-System die grüne Komponente

;	ROT

	move.w	(a1),d0		; aktuelle Farbe der Quell-Farbtabelle in d0
	move.w	(a2),d2		; Farbe der Ziel-Farbtabelle in d2
	and.l	#$f00,d0	; Wählen Sie nur das ROT von der Farbe der Quelltabelle
	and.l	#$f00,d2	; Farbe der Zielfarbentabelle
	cmp.w	d2,d0		; sind ROT Quelle und Ziel gleich?
	bhi.b	SottraiD2r	; wenn d2>d0, FadCh1a
	beq.b	SottraiD2r	; wenn sie gleich sind, subtrahiere d2
	sub.w	d0,d2		; wenn d2<d0, sub d0 bis d2!
	bra.b	SottFattor
SottraiD2r:
	sub.w	d2,d0		; sonst sub d2 bis d0!
	bra.b	SottFatto2r

SottFattor:
	move.w	d2,d0
SottFatto2r:
	moveq	#16,d1
	bsr.w	dodivu
	and.w	#$f00,d1	; wähle nur ROT
	move.w	(a1),d0		; aktuelle Farbe der Quell-Farbtabelle in d0
	move.w	(a2),d2		; Farbe der Ziel-Farbtabelle in d2
	and.w	#$f00,d0	; Wählen Sie nur das ROT von der Farbe der Quelltabelle
	and.w	#$f00,d2	; Farbe der Zielfarbentabelle
	cmp.w	d0,d2		; sind ROT Quelle und Ziel gleich?
	bhi.b	SommaD1r	; wenn d0>d2, Summe d1 bis d0
	beq.b	OkROSSO		; wenn sie gleich sind, ok
	sub.w	d1,d0		; d0=d0-d1
	bra.b	OkROSSO
SommaD1r:
	add.w	d1,d0		; d0=d0+d1
OkROSSO:
	or.w	d0,ColoreFinale	; mit dem OP-System die rote Komponente

;	Gib die Farbe in copperlist ein!

	move.w	ColoreFinale(PC),(a0)	; und legen Sie die endgültige Farbe in copper!

ProssimoColore:
	dbra	d6,f2main	; Wiederholen Sie dies für jede Farbe

	addq.w	#1,FaseDelFade	; System für die nächste Phase zu tun
nocrs:
	rts

***
* Eingang -> D0 = Anzahl
*			 D1 = Nenner	(16)
*			 D4 = * Multiplikationsfaktor
*
* Ausgang -> D1 = Ergebnis
***

DoDivu:
	divu.w	d1,d0		; Division durch 16, nicht optimierbar mit lsr
	move.l	d0,d1
	swap	d1
	move.l	#$31000,d2	; $10003 (65539) divu 16
	moveq	#0,d3
	move.w	d1,d3
	mulu.w	d3,d2
	move.w	d2,d1

	and.l	#$ffff,d1
	mulu.w	d4,d1		; multiplizieren Sie mit der Fade-Phase
	swap	d1
	mulu.w	d4,d0		; multiplizieren Sie mit der Fade-Phase
	add.w	d0,d1
	and.l	#$ffff,d1
	rts

FaseDelFade:		; aktuelle Phase der Überblendung (0-16)
	dc.w	0

;	Die endgültige Farbe wird jedes Mal in diesem Label gespeichert

ColoreFinale:
	dc.w	0

; ---

Cstart1:
	dcb.w	15,0	; Lass uns von Schwarz ausgehen
Cend1:
	dc.w $fff,$200,$310,$410,$620,$841,$a73		; und wir kommen zu den Farben
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446
;=----------

Cstart2:
	dc.w $fff,$200,$310,$410,$620,$841,$a73		; Beginnen wir mit Farben
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446
Cend2:
	dcb.w	15,0								; und wir landen in schwarz
;=----------

Cstart3:
	dcb.w	15,$FFF	; Fangen wir mit WEISS an
Cend3:
	dc.w $fff,$200,$310,$410,$620,$841,$a73		; und wir kommen zu den Farben
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446
;=----------

Cstart4:
	dc.w $fff,$200,$310,$410,$620,$841,$a73		; Beginnen wir mit Farben
	dc.w $b95,$db6,$dc7,$111,$222,$334,$99b,$446
Cend4:
	dc.w $fff,$020,$031,$041,$062,$184,$3a7			; und wir bekommen Farben
	dc.w $5b9,$6db,$7dc,$111,$222,$433,$b99,$644	; anders! (grüner Ton)
;=----------

Cstart5:
	dc.w $fff,$020,$031,$041,$062,$184,$3a7			; Beginnen wir mit Farben
	dc.w $5b9,$6db,$7dc,$111,$222,$433,$b99,$644	; anders! (grüner Ton)
Cend5:
	dc.w $fff,$002,$013,$014,$026,$148,$37a			; zu anderen noch
	dc.w $59b,$6bd,$7cd,$111,$222,$334,$99b,$446	; anders! (blauer Ton)
;=----------


; Die $180, color0, sind $000, also nicht ändern! Die Tabelle beginnt mit color1

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
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 Farben)

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

Hier ist eine Routine, die Farben nach Belieben "transformiert".
Das Funktionsprinzip ist daher komplexer als bei einer normalen Überblendung.
Versteht einfach, wie du es benutzen kannst. Wenn Sie Ihr Gehirn braten wollen,
habe ich jedoch Kommentare abgegeben.

