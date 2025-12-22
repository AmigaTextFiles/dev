
;  Listing11i6.s - schattierter Coppereffekt "pseudo 3d"

	SECTION	Barrex,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	bsr.s	makerast			; mache copperlist

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2			; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	BEQ.S	Aspetta

	bsr.s	MakeRast			; Farben rollen

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************
;	Routine die die copperlist erstellt
*****************************************************************************

;	  Oo 
;	 `--'

MakeRast:
	lea Offsets(PC),a2			; Tabelle mit 8 * 20 Offsetwerten zwischen
								; den Wartezeilen
	sub.w	#1*20,ContatoreWaitAnim
	bpl.s	nocolscroll
	addq.b	#1,ContatoreColore
	move.w	#7*20,ContatoreWaitAnim
nocolscroll:
	moveq	#0,d0				; d0 löschen
	move.w	ContatoreWaitAnim(PC),d0
	add.w	d0,a2				; Finden Sie den richtigen Versatz in der Versatztabelle
	lea	CopBuffer,a0

	moveq	#0,d0
	move.b	ContatoreColore(PC),d0

	moveq	#20,d3				; Anzahl Schleifen FaiCopper
	lea Colors(PC),a1			; Tabelle mit Farben
FaiCopper:
	and.w	#%01111111,d0		; es werden nur die ersten 7 Bits von d0 benötigt
	move.w	d0,d2				; Gib den letzten Farbwert an d2 zurück
								; gespeichert
	asl.l	#1,d2				; und bewegen Sie es um 1 Bit nach links
								; bedeutet, dass der angegebene Wert mit 2 multipliziert wird
								; dass die Werte in der Tabelle .w (2 Bytes) sind
								; auf diese Weise ist der Wert von d2 fertig
								; für das Ende "move.w (a1,2),(a0)+"

	addq.b	#1,d0				; nächste Farbe für die nächste Schleife

	moveq	#0,d1				; d1 löschen
	move.b	(a2)+,d1			; nimm den nächsten Versatz aus der Tabelle

	add.b	#$0f,d1				; Versatz von der $00-Zeile, dh vom Anfang
								; des Bildschirms, der zu den Werten hinzugefügt werden soll
								; Lesen Sie in der TAB
	asl.w	#8,d1				; verschiebt den Wert um 8 Bit nach links, da
								; es ist die vertikale Koordinate
								; zB: bevor es $0019 war, wird es $1900

	or.w	#$07,d1				; horizontale Wait Zeile: 07 (mit ODER 
								; fügt die letzte 07 hinzu, zB: $ 1907,$fffe ...)
	move.w	d1,(a0)+			; erstes Wort der Wartezeit mit Zeile und Spalte
	move.w	#$fffe,(a0)+		; zweites Wort des WAIT
	move.w	#$0180,(a0)+		; COLOR0
	move.w	(a1,d2),(a0)+		; Kopieren Sie die richtige Farbe aus der Tabelle nach
								; copperlist
	dbra	d3,FaiCopper
	rts



;	Tabelle mit Verlaufsfarben 128 Wert.w

Colors:
	dc.w $111,$444,$222,$777,$333,$aaa,$333,$aaa	; erster grauer Teil
	dc.w $333,$aaa,$333,$aaa,$333,$aaa,$333,$aaa
	dc.w $222,$777,$222,$444,$111,$000

	dc.w $000,$100,$200,$300,$400,$500,$600,$700	; farbiger Teil
	dc.w $800,$900,$a00,$b00,$c00,$d00,$e00
	dc.w $f00,$f10,$f20,$f30,$f40,$f50,$f60,$f70
	dc.w $f80,$f90,$fa0,$fb0,$fc0,$fd0,$fe0
	dc.w $ff0,$ef0,$df0,$cf0,$bf0,$af0,$9f0,$8f0
	dc.w $7f0,$6f0,$5f0,$4f0,$3f0,$2f0,$1f0
	dc.w $0f0,$0f1,$0f2,$0f3,$0f4,$0f5,$0f6,$0f7
	dc.w $0f8,$0f9,$0fa,$0fb,$0fc,$0fd,$0fe
	dc.w $0ff,$0ef,$0df,$0cf,$0bf,$0af,$09f,$08f
	dc.w $07f,$06f,$05f,$04f,$03f,$02f,$01f
	dc.w $00f,$10f,$20f,$30f,$40f,$50f,$60f,$70f
	dc.w $80f,$90f,$a0f,$b0f,$c0f,$d0f,$e0f
	dc.w $f0f,$e0e,$d0d,$c0c,$b0b,$a0a,$909,$808
	dc.w $707,$606,$505,$404,$303,$202,$101,$000
	

; Tabelle für Abstände zwischen einer Linie und einer anderen.
; Es gibt 8 Zeilen mit 20 Werten für insgesamt 20 * 8 = 160 Bytes
; Beachten Sie, dass die ersten Werte jeder Zeile sehr weit voneinander entfernt sind
; (0,16,28,37 ...) die letzten kommen aufeinanderfolgend an (77,78,79)
; Dies ist eine Art um eine Perspektive zu machen:
;
;	------------------------------------------------------------
;
;	------------------------------------------------------------
;	____________________________________________________________
;	____________________________________________________________
;	------------------------------------------------------------
;
; Es gibt 8 Zeilen mit 20 Werten, bei jedem Frame "bewegt" sich das Wait
; nach oben (Anmerkung: 0.16 .. erste Zeile, 2.18 ... die zweite, 6.21 die
; dritte). Auf diese Weise, neben der Anordnung in der "Pseudoperspektive",
; gleiten sie nach oben, wodurch der Effekt glaubwürdiger wird. Wir könnten das 
; sagen, das dies eine Tabelle mit 8 "Frames" der Wait Animation ist!!!

Offsets:
	dc.b  0,16,28,37,44,50,54,58,61,64,66,68,70,72,74,75,76,77,78,79
	dc.b  2,18,29,38,45,50,55,58,61,64,66,68,70,72,74,75,76,77,78,79
	dc.b  4,20,31,39,45,51,55,58,62,64,67,69,71,72,74,75,76,77,78,79
	dc.b  6,21,32,40,46,51,56,59,62,65,67,69,71,72,74,75,76,77,78,79
	dc.b  8,23,33,41,47,52,56,60,62,65,67,69,71,72,74,75,76,77,78,79
	dc.b 10,24,34,42,48,52,56,60,63,65,68,69,71,73,74,75,76,77,78,79
	dc.b 12,25,35,42,48,53,57,60,63,66,68,70,71,73,74,75,76,77,78,79
	dc.b 14,27,36,43,49,54,57,61,63,66,68,70,71,73,74,75,76,77,78,79

ContatoreWaitAnim:
 	dc.w	7*20

ContatoreColore:
	dc.b	0

	even

*****************************************************************************
;	Copperlist
*****************************************************************************

	Section	Grafica,data_C

copperlist:
	;dc.w	$8e,$2c81			; DiwStrt
	;dc.w	$90,$2cc1			; DiwStop
	;dc.w	$92,$38				; DdfStart
	;dc.w	$94,$d0				; DdfStop
	;dc.w	$102,0				; BplCon1
	;dc.w	$104,0				; BplCon2
	;dc.w	$108,40				; Bpl1Mod
	;dc.w	$10a,40				; Bpl2Mod

	dc.w	$180,$000			; Color0 schwarz
	dc.w	$100,$200			; bplcon0 - keine bitplanes

CopBuffer:
	dcb.w	21*4,0				; Raum, in dem der Effekt erzeugt wird

	dc.w	$6007,$fffe			; "grauer Bodenbelag
	dc.w	$0180,$0444
	dc.w	$6207,$fffe
	dc.w	$0180,$0666
	dc.w	$6507,$fffe
	dc.w	$0180,$0888
	dc.w	$6907,$fffe
	dc.w	$0180,$0aaa

	dc.w	$FFFF,$FFFE			; Ende copperlist


	end

