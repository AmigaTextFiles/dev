
;  Lezione11i5.s - ein Wechsel zu einer gewöhnlichen Bar....

; Rechte Taste zum Absenken der Leiste; Sie könnten einen Tabelle machen
; um auf und ab zu bewegen

	SECTION	Coppex,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2	; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $12c
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; warte auf Zeile $12c
	BEQ.S	Aspetta

	btst	#2,$dff016	; rechte Maustaste?
	bne.s	NonAbbassare
	cmp.b	#$c0,OrizzCoord	; Bar schon niedrig genug?
	bhi.s	NonAbbassare
	addq.b	#1,OrizzCoord

NonAbbassare:
	bsr.s	CoolRaster

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************
;	Hauptroutine
*****************************************************************************

CoolRaster:
	ADDQ.W	#2,OrizzCoord
	BSR.S	CoolEffetto
	BSR.S	ScorriColori	; schieben Sie die Farben der Tabelle
	rts


*****************************************************************************
; Bildlaufroutine für die Farben des roten Teils des Effekts
; Die Farben werden direkt in das ColorTab1 gerollt
*****************************************************************************

ScorriColori:
	LEA	ColorTab1(PC),A0
	MOVE.W	(A0),30*2(A0)	; speichern Sie die erste Farbe unten
	LEA	ColorTab1+2(PC),A1	; Adresse zweite Farbe
	MOVEQ	#31-1,D1		; 30 Farben zum "Bewegen"
ScorriTAB:
	MOVE.W	(A1)+,(A0)+		; Farbe 2 in Farbe 1, Farbe 3 in
	DBRA	D1,ScorriTAB	; Farbe 2 etc.
	RTS

*****************************************************************************

;	       _ ____   ____ _
;	             \ /
;	   .:::::::::: ::::::::::.
;	( :::        + +        ::: )
;	   `:::::::::: ::::::::::'
;	       /__  /  \\  __\
;	       \_\ (_____) /_/ 
;	    _/    \_ ___ _/    \_
;	    |       V   V       |
;	   /|\                 /|\
;	   |||                 |||
;

CoolEffetto:
	LEA	CopperBuffer1,A0
	LEA	ColorTab1(PC),A1		; Farbtabelle 1
	LEA	ColorTab2(PC),A2		; Farbtabelle 2

	MOVEQ	#29-1,D0			; 29 Zeilen für den Effekt
	MOVE.W	OrizzCoord(PC),D1	; aktuelle Wartezeit horizontal und vertikal in d1
WRITEBOTHLINES:
	MOVE.W	D1,(A0)+			; pack es in die copperlist
	MOVE.W	#$FFFE,(A0)+		; gefolgt von $FFFE
	MOVE.W	#$0180,(A0)+		; Color0
	MOVE.W	(A1)+,(A0)+			; setzen Sie die Farbe aus Tabelle1
	ADD.W	#$0020,D1			; bewegen Sie die Wartezeit 20 Schritte voraus
	MOVE.W	D1,(A0)+			; und lege es in die copperlist
	MOVE.W	#$FFFE,(A0)+		; gefolgt von $FFFE
	MOVE.W	#$0180,(A0)+		; color0
	MOVE.W	(A2)+,(A0)+			; setzen Sie die Farbe aus Tabelle2
	ADD.W	#$0020,D1			; bewegen Sie die Wartezeit 20 Schritte voraus
	DBRA	D0,WRITEBOTHLINES
	RTS


;	Tabelle des roten Schattens

ColorTab1:	; 30 Werte .w RGB für color0 in copperlist

	dc.W	$100,$200,$300
	dc.W	$400,$500,$600,$700,$800,$900,$A00,$B00,$C00,$D00,$E00,$F00
	dc.W 	$E00,$D00,$C00,$B00,$A00,$900,$800,$700,$600,$500,$400,$300
	dc.W	$200,$100,$101



;	Tabelle des grauen Schattens

ColorTab2:	; 30  Werte .w RGB für color0 in copperlist

	dc.W	$000
	dc.W	$111,$222,$333,$444,$555,$666,$777,$888,$999,$AAA,$BBB,$CCC
	dc.W	$DDD,$EEE,$DDD,$CCC,$BBB
	dc.W	$AAA,$999,$888,$777,$666,$555,$444,$333,$222,$111,$000
	dc.w	$000

;	Dies ist die erste Wartezeit

OrizzCoord:
 	dc.W $3A07


*****************************************************************************
;	Copperlist
*****************************************************************************

	SECTION	COP,DATA_C

COPPERLIST:
	dc.w	$100,$200	; bplcon0 - keine bitplanes
	DC.W	$0180,$0000	; color0 schwarz
	DC.W	$2B07,$FFFE	; warte auf Zeile $2b
CopperBuffer1:
 	dcb.W	29*8,0

	dc.W	$0180,$000	; color0 schwarz


	dc.w	$d007,$fffe	; warte auf Zeile $d0
	dc.w	$180,$035
	dc.w	$d207,$fffe	; warte auf Zeile $d0
	dc.w	$180,$047
	dc.w	$d607,$fffe	; warte auf Zeile $d0
	dc.w	$180,$059

	dc.W	$FFFF,$FFFE	; Ende copperlist

	end

