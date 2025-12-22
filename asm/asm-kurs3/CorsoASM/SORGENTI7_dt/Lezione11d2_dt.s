
; Lezione11d2.s -  Verwendung von COPER- und VERTB-Interrupt per Level 3 ($6c).
			; Diesmal wechselt die Palette. Rechte Maustaste 
			; um die Routine vorübergehend zu sperren.

	Section	Interrupt,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper und bitplane DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

	MOVE.L	#PICTURE2,d0
	LEA	BPLPOINTERS2,A1
	MOVEQ	#5-1,D1			; Anzahl der bitplanes
POINTBT2:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#34*40,d0		; Bitplane-Länge
	addq.w	#8,a1
	dbra	d1,POINTBT2		; D1-mal wiederholen (D1 = Anzahl der Bitplanes)

; Wir zeigen auf unseren Level 3 Int

	move.l	BaseVBR(PC),a0	    ; in a0 ist der Wert des VBR
	move.l	#MioInt6c,$6c(a0)	; ich lege meinen Interrupt-Level 3 fest
	
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper								
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; initialisieren der Musik Routine
	movem.l	(SP)+,d0-d7/a0-a6

	move.w	#$c030,$9a(a5)		; INTENA - aktivieren interrupt "VERTB" 
								; und "COPER" per Level 3 ($6c)

mouse:
	btst	#6,$bfe001	; Maus gedrückt? (Der Prozessor 
	bne.s	mouse		; unterbricht die Schleife zu jedem vertical blank
						; um die Musik zu spielen!
						; sowie jedes WAIT der Rasterzeile $a0).						
				
	bsr.w	mt_end		; Ende der Wiederholung!

	rts					; exit

*****************************************************************************
*	INTERRUPT-ROUTINE  $6c (Level 3) -  VERTB und COPER benutzt.
*****************************************************************************

;	     ,,,,;;;;;;;;;;;;;;;;;;;;;,
;	  ,;;;;;;;;;;'''''''';;;;;;;;;;;;,
;	  ;|                     \   ';;'
;	  ;|   _______  ______,   )
;	  _| _________   ________/
;	 / T ¬/   ¬©) \ /  ¬©) \¯¡
;	( C|  \_______/ \______/ |
;	 \_j ______      \  ____ |
;	  `|     /        \  \   l
;	   |    /     (, _/   \  /
;	   |  _   __________    /
;	   |  '\   --------¬   /
;	   |    \_____________/
;	   |          __,   T
;	   l________________! xCz

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - Bit 5, VERTB, ist zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
	move.w	#$20,$dff09c		; INTREQ - int ausgeführt, Anfoderung löschen
								; da der 680x0 es nicht von selbst löscht!!!
	rte							; Ende vom Interrupt VERTB

nointVERTB:
	btst.b	#4,$dff01f			; INTREQR - COPER ist zurückgesetzt?
	beq.s	NointCOPER			; wenn ja, ist es kein COPER Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	ColorCicla			; Wechseln Sie die Farben des Bildes
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen

NointCOPER:
			 ;6543210
	move.w	#%0110000,$dff09c	; INTREQ - Anfoderung löschen VERTB und COPER
	rte							; Ende vom Interrupt VERTB,COPER


*****************************************************************************
* Routine, die die Farben der gesamten Palette "wechselt".					*
* Diese Routine wechselt die ersten 15 Farben getrennt von dem zweiten		*
* Farbblock. Es funktioniert wie die "RANGE" des Dpaint.					*
*****************************************************************************

; Der "cont" Zähler wird verwendet, um vor der Ausführung der cont-Routine
; 3 Frames zu warten. In der Praxis wird damit die Ausführung "verlangsamt"

cont:
	dc.w	0

ColorCicla:
	btst.b	#2,$dff016	; Rechte Maustaste gedrückt?
	beq.s	NonAncora	; Wenn ja, beenden
	addq.b	#1,cont
	cmp.b	#3,cont		; Handle nur einmal alle 3 Frames
	bne.s	NonAncora	; Sind wir noch nicht im dritten Durchlauf? Quit!
	clr.b	cont		; Wir sind im dritten, setzen Sie den Zähler zurück

; Rückwärtsrotation der ersten 15 Farben

	lea	cols+2,a0		; Erste Farbadresse der ersten Gruppe
	move.w	(a0),d0		; Speichern Sie die erste Farbe in d0
	moveq	#15-1,d7	; 15 Farben zum "rotieren" in der ersten Gruppe
cloop1:
	move.w	4(a0),(a0)	; Kopieren Sie die Farbe vorwärts zum Ersten
	addq.w	#4,a0		; zur nächsten Spalte springen "zurückgehen"
	dbra	d7,cloop1	; wiederhole d7 mal
	move.w	d0,(a0)		; Stellen Sie die erste als letzte gespeicherte Farbe ein.

; Vorwärtsrotation der zweiten 15 Farben

	lea	cole-2,a0		; Adresse letzte Farbe der zweiten Gruppe
	move.w	(a0),d0		; Speichern Sie die letzte Farbe in d0
	moveq	#15-1,d7	; weitere 15 Farben separat "rotieren"
cloop2:	
	move.w	-4(a0),(a0)	; Kopieren Sie die Farbe zurück zum nächsten
	subq.w	#4,a0		; zur vorherigen Spalte springen "vorrücken"
	dbra	d7,cloop2	; wiederhole d7 mal
	move.w	d0,(a0)		; Stellen Sie die letzte als erste gespeicherte Farbe ein
NonAncora:
	rts


*****************************************************************************
;	Wiederholungsroutine protracker/soundtracker/noisetracker
;
	include	"assembler2:sorgenti4/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$200	; BPLCON0 - keine bitplanes
	dc.w	$180,$00e	; color0 BLAU

	dc.w	$b807,$fffe	; WAIT - warte auf Zeile $b8
	dc.w	$9c,$8010	; INTREQ - Fordern Sie einen COPER-Interrupt an,
						; dadurch rotieren die 32 Farben der Palette.

	dc.w	$b907,$fffe	; WAIT - warte auf Zeile $b9
BPLPOINTERS2:
	dc.w $e0,0,$e2,0		; erste		bitplane
	dc.w $e4,0,$e6,0		; zweite		"
	dc.w $e8,0,$ea,0		; dritte	    "
	dc.w $ec,0,$ee,0		; vierte	    "
	dc.w $f0,0,$f2,0		; fünfte	    "

	dc.w	$100,%0101001000000000	; BPLCON0 - 5 bitplanes LOWRES

cols:
	dc.w $180,$040,$182,$050,$184,$060,$186,$080	; Grünton
	dc.w $188,$090,$18a,$0b0,$18c,$0c0,$18e,$0e0
	dc.w $190,$0f0,$192,$0d0,$194,$0c0,$196,$0a0
	dc.w $198,$090,$19a,$070,$19c,$060,$19e,$040

	dc.w $1a0,$029,$1a2,$02a,$1a4,$13b,$1a6,$24b	; Blauton
	dc.w $1a8,$35c,$1aa,$36d,$1ac,$57e,$1ae,$68f
	dc.w $1b0,$79f,$1b2,$68f,$1b4,$58e,$1b6,$37e
	dc.w $1b8,$26d,$1ba,$15d,$1bc,$04c,$1be,$04c
cole:

	dc.w	$da07,$fffe	; WAIT - warte auf Zeile $da
	dc.w	$100,$200	; BPLCON0 - deaktivieren bitplanes
	dc.w	$180,$00e	; color0 BLAU

	dc.w	$FFFF,$FFFE	; Ende copperlist

	; Die Palette, die in 2 Gruppen von 16 Farben "gedreht" wird.



*****************************************************************************
; 		DESIGN 320*34 mit 5 bitplanes (32 color)
*****************************************************************************

PICTURE2:
	;INCBIN	"pic320*34*5.raw"
	blk.b 5*10880,$0A
*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"assembler2:sorgenti4/mod.fuck the bass"

	end

In diesem Beispiel wird die Palette nur eine Zeile vor der Zeichnung geändert.
Tatsächlich ändern Sie es einfach eine Zeile zuvor! In der Zwischenzeit können 
Sie mit dem Prozessor verschiedene Aufgaben ausführen, aber wir haben 
sichergestellt, dass sich die Farben vor der Zeile $b9 jedes Mal geändert haben.
Eine andere Sache die zu beachten ist, ist das trotz der Unterbrechung die
bei jedem Bild auftritt, durch einen "Zähler" es möglich ist, die Routine nur
einmal pro alle 3 Frames auszuführen. So haben wir gesehen, dass es möglich ist, 
mehr Routinen und weitere Interrupts in derselben copperliste in verschiedenen 
Zeilen in Lesson11d.s zu setzen.
Stellen Sie einfach sicher, dass die Routine für diese Zeile jedes Mal ausgeführt
wird. Nun können wir sehen, dass Sie einige dieser Routinen einmal alle X Frames
ausführen können, so das Sie alles machen können!
Aber denken Sie daran, dass jeder Interrupt ein wenig Zeit für Sprünge benötigt,
die getan werden müssen.

Ein Hinweis: Die beiden Zahlen stammen tatsächlich von Grossetos BBS Fidonet 
AmigaLink. Dies ist ein "Stück" der kleinen Demo, die ich im sysop dieses 
BBS gemacht habe. Sie sind als "Fabio Ciucci" gekennzeichnet, aber ich rufe 
aus Gründen der galaktischen Rechnung selten an. Solange wie es keinen freien
Internet Zugang in den Städten gibt, ist es schwer für Programmierer sich 
via Modem auszutauschen. Besser ist per Post!

