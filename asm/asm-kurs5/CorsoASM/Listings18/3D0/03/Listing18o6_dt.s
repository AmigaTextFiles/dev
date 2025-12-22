; Listing18o6.s	= 3dstars6.2
; "3d" Sterne entfernen sich vom "Zentrum" in 2 Bitplanes

	Section	stellucce,code

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern interrupt, dma etc.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper und bitplane DMA

WaitDisk	equ	30

START:

	MOVE.L	#MioBuf,d0
	LEA	BPLPOINTERS,A1
	MOVEQ	#2-1,D1				; Anzahl bitplanes
POINTBT:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#320*40,d0			; Länge der bitplane
	addq.w	#8,a1
	dbra	d1,POINTBT			; D1-mal Wiederholen (D1 = Anzahl der Bitebenen)

	bsr.s	star_init			; Generiere Sterne nach dem Zufallsprinzip

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	movem.l	d0-d7/a0-a7,-(SP)
	bsr.s	stars				; Stelle "3d".
	movem.l	(SP)+,d0-d7/a0-a7

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
	rts							; exit


******************************************************************************
*		Routine, die zufällige Sterne generiert
******************************************************************************

star_init:						; zufällige Sterne generieren
	moveq	#70-1,D3			; 70 Sterne
	lea	ran_tab(PC),A0
ran_loop:
	bsr.w	get_ran				; Nimm einen zufälligen Wert
	add.w	#4008,d0			; HINZUFÜGEN 4008
	MOVE.W	D0,(A0)+			; Speichern Sie den Wert in der Tabelle ran_tab
	BSR.w	get_ran				; Nimm einen anderen zufälligen Wert
	add.w	#4008,d0			; hinzufügen 4008
	MOVE.W	D0,(A0)+			; speichern
	BSR.w	get_ran				; Nimm den Zufallswert
	AND.W	#$1FF,D0			; Es werden nur die ersten 9 Bits benötigt (max. 511)
	MOVE.W	D0,(A0)+			; speichern
	DBRA	D3,ran_loop
	rts		

; jeder Stern besteht aus 3 .word-Werten.

stars:
	lea	ran_tab(PC),A4			; randomtab in a4	
	MOVEQ	#70,D3				; 70 Sterne
	lea	ran2_tab(PC),A5			; neue randomtab in a5
star_loop:
	MOVE.W	(A4)+,D4			; Wert 1 in d4
 	MOVE.W	(A4)+,D5			; Wert 2 in d5
 	MOVE.W	(A4),D6				; Wert 3 in d6
	SUBQ.W	#2,(A4)+			; sub 2 den vorherigen Wert 3, und weiter
	TST.W	D6					; D6 = 0?
	BLE.w	routMioran			; Dann "fertiger" Stern, angekommen .. neue cas.
	EXT.L	D4					; d4 -> longword
	DIVS.w	D6,D4				; dividiere d4/d6 (Wert horizontal)
	ADD.W	#160,D4				; +160 = Mitte
	EXT.L	D5					; Erweiterung von d5
	DIVS.w	D6,D5				; dividiere Wert vertikal
	ADD.W	#128,D5				; +128 = Mitte
	TST.W	D4					; d4 = 0?
	BLT.w	routMioran			; Also neuer Zufallswert!
	TST.W	D5					; d5 = 0?
	BLT.w	routMioran			; Dann neuer Wert. willkürlich
	CMP.W	#319,D4				; das horizontale Ende erreicht? (320*)
	BGT.w	routMioran			; neuer Zufallswert
	CMP.W	#255,D5				; das vertikale Ende erreicht? (*256)
	BGT.w	routMioran			; dann neu Zufallswert!
	MOVE.W	(A5),D0				; a5 (newtab val1) in d0
	MOVE.W	D4,(A5)+			; d4 kopiert in newtab val1
	MOVE.W	(A5),D1				; a5 (newtab val2) in d1
	MOVE.W	d5,(A5)+			; d5 kopiert in newtab val2
	BSR.w	CacellaStella		; Stern löschen!
	MOVE.W	D4,D0				; d4 in d0 = x
	MOVE.W	D5,D1				; d5 in d1 = y
	MULU.w	#40,D1				; Y * Bildschirmbreite
	MOVE.W	D0,D2				; d0 in d2
	ASR.W	#3,D2				; dividiert durch 8
	ADD.W	D2,D1				; ergänzen offset Y*Bildschirmbreite
	ASL.W	#3,D2				; multiplizieren mit 8
	SUB.W	D0,D2				; sub x (Ich denke das ist der Fehler?)
	SUBQ.B	#1,D2				; minus 1
	CMP.W	#350,D6				; d6 = 400 (Distanz)
	BGT.S	PlotColore1			; wenn größer > color1
	CMP.W	#250,D6				; d6 = 300 (Distanz)
	BGT.S	PlotColore2			; wenn größer color2
	BRA.S	PlotColore3			; Andernfalls color3

; Punkt drucken mit Farbe1, plotten nur in plane1

PlotColore1:
	lea	MioBuf,A1				; plane1
	ADDA.L	D1,A1
	BSET.b	D2,(A1)				; Punkt drucken
	DBRA	D3,star_loop
	RTS

; Punkt drucken mit Farbe2, plotten nur in plane2

PlotColore2:
	lea	MioBuf2,A1				; plane2
	ADDA.L	D1,A1
	BSET	D2,(A1)				; Punkt drucken
	DBRA	D3,star_loop
	RTS

; Punkt drucken mit Farbe3, plotten in plane1 und plane2

PlotColore3:
	lea	MioBuf,A1				; plane1
	ADDA.L	D1,A1
	BSET	D2,(A1)				; Punkt drucken
	lea	MioBuf2,A1				; plane2
	ADDA.L	D1,A1
	BSET	D2,(A1)				; Punkt drucken
	DBRA	D3,star_loop
	RTS

ran_pointer:	dc.w	0

; Routine, ddie zufällige Werte generiert über $dff006 (VHPOSR).

get_ran:
	move.w	$dff006,d0			; VHPOSR - immer andere Position!
	LEA	RandomMult(PC),A3
	MULS.w	(A3),D0
	ADDI.W	#$1249,D0
	EXT.L	D0
	LEA	RandomMult(PC),A3
	MOVE.W	D0,(A3)
 	RTS

routMioran:
	SUBA.L #6,A4
	BSR get_ran
 	MOVE.W D0,(A4)+
 	BSR get_ran
 	MOVE.W D0,(A4)+
 	BSR get_ran
	and.w	#600,d0	 
	MOVE.W d0,(A4)+
	DBRA	D3,star_loop
	RTS

CacellaStella:
	MULU.w	#40,D1				; Y * Bildschirmbreite
 	MOVE.W	D0,D2				; X in d2
 	ASR.W	#3,D2				; dividiert durch 8
 	ADD.W	D2,D1				; Summe für offset
 	ASL.W	#3,D2				; Multiplikation mit 8
 	SUB.W	D0,D2				; sub X
 	SUBQ.B	#1,D2				; sub 1
 	lea	MioBuf,A1
 	ADDA.L	D1,A1				; + offset um das richtige Byte zu finden
 	BCLR.b	D2,(A1)				; löscht den Punkt in plane1
 	lea	MioBuf2,A1
 	ADDA.L	D1,A1				; + offset um das richtige Byte zu finden
 	BCLR	D2,(A1)				; löscht den Punkt in plane2
 	RTS

RandomMult:
	dc.w	0
	dc.w	0

ran_tab:
	dcb.w	210,0
ran2_tab:
	dcb.w	210,0


	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

BPLPOINTERS:
	dc.w $e0,0,$e2,0			; erste bitplane
	dc.w $e4,0,$e6,0			; zweite   "

	dc.w	$100,$2200			; BPLCON0 - 2 bitplanes lowres

	dc.w	$180,$000			; COLOR0
	dc.w	$182,$555			; COLOR1
	dc.w	$184,$aaa			; COLOR2
	dc.w	$186,$fff			; COLOR3

	dc.w	$FFFF,$FFFE			; Ende copperlist

******************************************************************************

	Section	Bitplanebuf,bss_C

; 2 bitplanes 320*256

MioBuf:
	ds.b	320*40				; bitplane 320*256
MioBuf2:
	ds.b	320*40				; bitplane 320*256

	end

