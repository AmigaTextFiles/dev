
; Lezione15b.s		copper-AGA-Nuance unter Verwendung der 24-Bit-Palette.
;			Wir verwenden eine Routine, um das Mischen durchzuführen.
;			Linke und rechte Taste zum Beenden

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

	move.l	#$2c07fffe,d1	; erste Zeile YY wait: $2c
	moveq	#$00,d5			; Farbe Start
	move.w	#200-1,d7		; Anzahl Zeilen: 200!
	bsr.w	FaiAGACopR		; Machen Sie einen roten Farbton

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

LOOP1:
	BTST.b	#6,$BFE001		; linke Maustaste?
	BNE.S	LOOP1


	move.l	#$2c07fffe,d1	; erste Zeile YY wait: $2c
	moveq	#$00,d5			; Farbe Start
	move.w	#200-1,d7		; Anzahl Zeilen: 200!
	bsr.w	FaiAGACopG		; Farbverlauf machen GREEN (grün)

LOOP2:
	BTST.b	#2,$16(a5)		; rechte Maustaste?
	BNE.S	LOOP2

	move.l	#$2c07fffe,d1	; erste Zeile YY wait: $2c
	moveq	#$00,d5			; Farbe Start
	move.w	#200-1,d7		; Anzahl Zeilen: 200!
	bsr.w	FaiAGACopB		; Farbverlauf machen BLAU

LOOP3:
	BTST.b	#6,$BFE001		; Linke Maustaste?
	BNE.S	LOOP3

	move.l	#$2c07fffe,d1	; erste Zeile YY wait: $2c
	moveq	#$00,d5			; Farbe Start
	move.w	#150-1,d7		; Anzahl Zeilen: 150!
	bsr.s	FaiAGACopG		; Farbverlauf machen GREEN (grün)

LOOP4:
	BTST.b	#2,$16(a5)		; rechte Maustaste?
	BNE.S	LOOP4

	move.l	#$2c07fffe,d1	; erste Zeile YY wait: $2c
	moveq	#$00,d5			; Farbe Start
	move.w	#60-1,d7		; Anzahl Zeilen: 60!
	bsr.w	FaiAGACopR		; Farbverlauf machen ROT

LOOP5:
	BTST.b	#6,$BFE001		; linke Maustaste?
	BNE.S	LOOP5

	RTS

;*****************************************************************************
; Routine, die ROTE AGA-Farben erzeugt:
;
; d1 = erste Zeile zu warten (Wait, bei: $2c07fffe bei Zeile Y=$2c)
; d5 = Beginn Farbton ($00-$ff)
; d7 = Anzahl Zeilen zu machen
;*****************************************************************************

FaiAGACopR:
	lea	AgaCopEff1,a0
	move.l	#$01060c00,d4	; BplCon3 - nibble hoch
	move.l	#$01060e00,d3	; BplCon3 - nibble niedrig
	move.w	#$180,d2		; Register Color0
FaiAGALoopR:
	move.l	d1,(a0)+		; warte YYXXFFFE
	add.l	#$01000000,d1	; warte eine Zeile tiefer für die nächste
	move.l	d4,(a0)+		; BplCon3 - Auswahl nibble hoch
	move.w	d2,(a0)+		; Register Color0
	addq.b	#1,d5			; "Hellt" die $Gg-Farbe leicht auf
	move.w	d5,d6			; Kopie in d6
	and.w	#%11110000,d6	; Auswahl nur nibble HOCH
	lsl.w	#4,d6			; an die richtige Position, d.h. bei ROT ($Rxx)
	move.w	d6,(a0)+		; Wert Color0 (nibble hoch)
	move.l	d3,(a0)+		; BplCon3 - Auswahl nibble niedrig
	move.w	d2,(a0)+		; Register Color0
	move.w	d5,d6			; Color $xx in d6
	and.w	#%00001111,d6	; Auswahl nur nibble niedrig
	lsl.w	#8,d6			; in die rote Position bewegen
	move.w	d6,(a0)+		; Farbe in copperlist (nibble niedrig) eingeben
	dbra	d7,FaiAGALoopR
	rts

;*****************************************************************************
; Routine, die GRÜNE AGA-Farbtöne erzeugt:
;
; d1 = erste Zeile zu warten (Wait, bei: $2c07fffe bei Zeile Y=$2c)
; d5 = Beginn Farbton ($00-$ff)
; d7 = Anzahl Zeilen zu machen
;*****************************************************************************

FaiAGACopG:
	lea	AgaCopEff1,a0
	move.l	#$01060c00,d4	; BplCon3 - nibble hoch
	move.l	#$01060e00,d3	; BplCon3 - nibble niedrig
	move.w	#$180,d2		; Register Color0
FaiAGALoopG:
	move.l	d1,(a0)+		; warte YYXXFFFE
	add.l	#$01000000,d1	; warte eine Zeile tiefer für die nächste
	move.l	d4,(a0)+		; BplCon3 - Auswahl nibble hoch
	move.w	d2,(a0)+		; Register Color0
	addq.b	#1,d5			; "Hellt" die $Gg-Farbe leicht auf
	move.w	d5,d6			; Kopie in d6
	and.w	#%11110000,d6	; Auswahl nur nibble HOCH (es ist schon an
							; der richtigen Position, d.h. bei GRÜN $xGx)
	move.w	d6,(a0)+		; Wert Color0 (nibble hoch)
	move.l	d3,(a0)+		; BplCon3 - Auswahl nibble niedrig
	move.w	d2,(a0)+		; Register Color0
	move.w	d5,d6			; Color $xx in d6
	and.w	#%00001111,d6	; Auswahl nur nibble niedrig
	lsl.w	#4,d6			; in die grüne Position bewegen
	move.w	d6,(a0)+		; Farbe in copperlist (nibble niedrig) eingeben
	dbra	d7,FaiAGALoopG
	rts

;*****************************************************************************
; Routine, die BLAUE AGA-Farbtöne erzeugt:
;
; d1 = erste Zeile zu warten (Wait, bei: $2c07fffe bei Zeile Y=$2c)
; d5 = Beginn Farbton ($00-$ff)
; d7 = Anzahl Zeilen zu machen
;*****************************************************************************

FaiAGACopB:
	lea	AgaCopEff1,a0
	move.l	#$01060c00,d4	; BplCon3 - nibble hoch
	move.l	#$01060e00,d3	; BplCon3 - nibble niedrig
	move.w	#$180,d2		; Register Color0
FaiAGALoopB:
	move.l	d1,(a0)+		; warte YYXXFFFE
	add.l	#$01000000,d1	; warte eine Zeile tiefer für die nächste
	move.l	d4,(a0)+		; BplCon3 - Auswahl nibble hoch
	move.w	d2,(a0)+		; Register Color0
	addq.b	#1,d5			; "Hellt" die $Gg-Farbe leicht auf
	move.w	d5,d6			; Kopie in d6
	and.w	#%11110000,d6	; Auswahl nur nibble HOCH
	lsr.w	#4,d6			; an der richtigen Position, d.h. BLAU $xxB)
	move.w	d6,(a0)+		; Wert Color0 (nibble hoch)
	move.l	d3,(a0)+		; BplCon3 - Auswahl nibble niedrig
	move.w	d2,(a0)+		; Register Color0
	move.w	d5,d6			; Color $xx in d6
	and.w	#%00001111,d6	; Auswahl nur nibble niedrig - Position $xxB
	move.w	d6,(a0)+		; Farbe in copperlist (nibble niedrig) eingeben
	dbra	d7,FaiAGALoopB
	rts

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	section	coppera,data_C

COPLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
	dc.w	$100,$201	; keine bitplanes (bit 1 aktiviert jedoch!)

	dc.w	$106,$c00	; AUSWAHL NIBBLE HOCH
	dc.w	$180,$000	; Color0 - nibble hoch
						; (Wir lassen die niedrigen Nibble bei Null...)

AgaCopEff1:
	dcb.l	200*5		; das ist: 200 Zeilen * 5 long:
						; 1 für wait,
						; 1 für bplcon3
						; 1 für color0 (nib hoch)
						; 1 für bplcon3
						; 1 für color0 (nib niedrig)

	dc.w	$FFFF,$FFFE	; Ende copperlist

	end

Es hat sich gelohnt, eine Routine für diese Nuance zu erstellen. Können Sie
sich vorstellen, wie viele Zeilen wir hätten schreiben sollen???

