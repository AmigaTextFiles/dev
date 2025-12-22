
; Lezione9d1.s	 SCHLEIFE VON EINEM BLITTATA MIT HÖHE VON 6 ZEILEN UND MODULO

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:
;	Wir zeigen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	lea	bitplane,a0			; Adresse bitplane Ziel
	move.w	#(150-6)-1,d7	; -6 weil die Figur 6 Zeilen hoch ist,
				; so "kommt" es 6 Zeilen niedriger an
				; wo es stehen bleibt.
BlitLoop:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$10800,d2	; Warte auf Zeile = $108
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Linie zu warten $108
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $108
	Beq.S	Waity2

	btst	#6,2(a5) ; dmaconr
WBlit:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit

;	/\ ___
;	\ (_ _)
;	 \ \ª/ )
;	  \ , /
;	  / \/\
;	 /__I__\

	move.w	#$ffff,$44(a5)		; BLTAFWM wir erklären es später
	move.w	#$ffff,$46(a5)		; BLTALWM wir erklären es später
	move.w	#$09f0,$40(a5)		; BLTCON0 (Kanal A und D einschalten)
	move.w	#$0000,$42(a5)		; BLTCON1 wir erklären es später
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#36,$66(a5)			; BLTDMOD (40-4=36)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Ziel: Bildschirmzeilen)
	move.w	#(64*6)+2,$58(a5)	; BLTSIZE (Blitter starten !)
					; Jetzt werden wir ein Bild von
					; 2 Wörtern X 6 Zeilen mit nur einem
					; blittata, welches wir mit den Modulo entsprechend
					; für den Bildschirm richtig eingestellt, blitten.

	add.w	#40,a0	; Lass uns zum nächsten Blitt gehen
					; Zeile in der nächsten Schleife.
					; 40 ist die Anzahl der Bytes in einer Zeile.
					; Wenn wir diese Zahl hinzufügen, bewegen wir uns
					; an das Ende einer Reihe.

	dbra	d7,blitloop

mouse:
	btst	#6,$bfe001	; linke Mausetaste gedrueckt?
	bne.s	mouse

	btst	#6,2(a5)	; dmaconr
WBlit3:
	btst	#6,2(a5)	; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit3

	rts

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$1200	; Bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$eee	; color1
	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

; Wir definieren binär die Figur, die 16 Bits breit oder 2 Wörter und 
; 6 Zeilen hoch ist

Figura:
	dc.l	%00000000000000000000110001100000
	dc.l	%00000000000000000011000110000000
	dc.l	%00000000000000001100011000000000
	dc.l	%00000110000000110001100000000000
	dc.l	%00000001100011000110000000000000
	dc.l	%00000000011100011000000000000000

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel sehen wir ein Beispiel für Animationen mit dem Blitter.
Sehr einfach zeichnest du die Figur immer eine Position niedriger 
mit dem Blitter bei jedem vertical blank.
Die Position der Figur wird durch die Adresse bestimmt, die in das
BLTDPT-Register geschrieben wird. Beachten Sie, dass der Wert der in 
dieses Register geschrieben wird im Rahmen geändert wird:

	add.w	#40,a0	; Lass uns zum nächsten Blitten gehen
					; Zeile in der nächsten Schleife.
					; 40 ist die Anzahl der Bytes in einer Zeile.
					; Wenn wir diese Zahl hinzufügen, bewegen wir uns
					; an das Ende einer Reihe.

Die Figur "verlässt die Spur", weil wir die Figur nicht jedes Mal abbrechen.
Es ist wie ein Pinsel des DPaint.
