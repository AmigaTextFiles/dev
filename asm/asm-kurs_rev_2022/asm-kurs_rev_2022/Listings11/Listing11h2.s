
; Listing11h2.s	- Routine, die ausgeblendete Balken erzeugt - BENUTZEN SIE DIE 
			; RECHTE MAUSTASTE UM DIE BALKENNHÖHE ZU ERHÖHEN.

	SECTION	Barrex,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

LINEE:	equ	211

START:
	bsr.s	FaiCopp1			; Copperliste erstellen

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper	
	move.l	#OURCOPPER,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$10500,d2			; warte auf Zeile $105
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $105
	BNE.S	Waity1

 	BSR.s	changecop			; Rufe die Routine auf, die den copper ändert

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************
; Routine die die copperlist erstellt
*****************************************************************************

FaiCopp1:
	LEA	copcols,a0				; Adresse Puffer in copperlist
	MOVE.L	#$2c07fffe,d1		; copper Wait-Anweisung, die startet
								; Warten auf Zeile $2c
	MOVE.L	#$1800000,d2		; $dff180 = colore 0 für das copper
	MOVE.w	#LINEE-1,d0			; Anzahl der Zeilen des loop
	;MOVEQ	#$000,d3			; Farbe setzen = schwarz
coploop:
	MOVE.L	d1,(a0)+			; Setzen des WAIT
	MOVE.L	d2,(a0)+			; Setzen des $180 (color0) auf SCHWARZ gelöscht
	ADD.L	#$01000000,d1		; Warten Sie eine Zeile darunter WAIT 1
	DBRA	d0,coploop			; Wiederholen Sie dies bis zum Ende der Zeilen
	rts

*****************************************************************************
; Routine, die die Farben in der copperlist ändert 
*****************************************************************************

;	            ________________________
;	           /                        \
;	  ___   ___\       ehHHHHhHh?        \
;	 /_  ¯¯¯  _\\_ ______________________/
;	 \ \_____/ / / /
;	  \_(°I°)_/ / /
;	  _l_¯U¯_l_ \/
;	 /  T¯¬¯T  \
;	/ _________ \ xCz
;	¯¯         ¯¯

changecop:
	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	noadd				; Wenn nicht, springe zu noadd
	cmp.b	#$24,barlen			; Andernfalls überprüfen wir, ob wir bereits bei $24 sind
	beq.s	noadd				; In diesem Fall springt es zu noadd
	addq.b	#1,barlen			; oder die copperbar vergrößern (BARLEN)
noadd:
	LEA	copcols,a0				; Adresse Puffer in copperlist
	MOVE.w	#LINEE-1,d0			; Anzahl der Zeilen des loop
	MOVE.L	PuntatoreTABCol(PC),a1	; Beginn der Farbtabelle in a1
	move.l	a1,PuntatTemporaneo	; gespeichert in PuntatoreTemporaneo
	moveq	#0,d1				; d1 zurücksetzen
LineeLoop:
	move.w	(a1)+,6(a0)			; Kopiere die Farbe aus der Tabelle in die copperliste
	addq.w	#8,a0				; nächste color0 in copperlist
 	addq.b	#1,d1				; notiere die Länge des Unterstrichs in d1
 	cmp.b	barlen(PC),d1		; Ende der Unterleiste?
	bne.s	AspettaSottoBarra

	MOVE.L	PuntatTemporaneo(PC),a1
	addq.w	#2,a1				; Punkt nach färben
	cmp.l	#FINETABColBarra,PuntatTemporaneo	; sind wir am Ende der Tab?
	bne.s	NonRipartire		; wenn nicht, weiter mit NonRipartire
	lea	TABColoriBarra(pc),a1	; ansonsten ab dem ersten col!
NonRipartire:
	move.l	a1,PuntatTemporaneo	; und speichern den Wert in Pun. vorübergehend
	moveq	#0,d1				; d1 zurücksetzen
AspettaSottoBarra:
	dbra d0,LineeLoop			; Mach alle Zeilen


	addq.l	#2,PuntatoreTABCol	 ; nächste Farbe
	cmp.l	#FINETABColBarra+2,PuntatoreTABCol ; wir sind am Ende der
								; Farbttabelle?
	bne.s FineRoutine			; wenn nicht, raus, sonst...
	move.l #TABColoriBarra,PuntatoreTABCol	 ; ab dem ersten Wert von
								; TABColoriBarra
FineRoutine:
	rts

; Balkenhöhe

barlen:
	dc.b	1

	even


; Tabelle mit RGB-Farbwerten. In diesem Fall handelt es sich um Blautöne

TABColoriBarra:
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007
	dc.w	$008,$009,$00A,$00B,$00C,$00D,$00D,$00E
	dc.w	$00E,$00F,$00F,$00F,$00E,$00E,$00D,$00D
	dc.w	$00C,$00B,$00A,$009,$008,$007,$006,$005
	dc.w	$004,$003,$002,$001,$000,$000,$000,$000
	dcb.w	10,$000
FINETABColBarra:
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007	; Diese Werte werden benötigt
	dc.w	$008,$009,$00A,$00B,$00C,$00D,$00D,$00E ; für die Nebenstangen
	dc.w	$00E,$00F,$00F,$00F,$00E,$00E,$00D,$00D
	dc.w	$00C,$00B,$00A,$009,$008,$007,$006,$005
	dc.w	$004,$003,$002,$001,$000,$000,$000,$000


PuntatTemporaneo:
 	dc.l	TABColoriBarra

PuntatoreTABCol:
 	DC.L	TABColoriBarra

*****************************************************************************

	Section	Coppy,data_C

OURCOPPER:
	dc.w	$180,$000			; Color0 schwarz
	dc.w	$100,$200			; bplcon0 - keine bitplanes

copcols:
	dcb.b	LINEE*8,0			; Platz für 100 Zeilen in diesem Format:
				; WAIT xx07,$fffe
				; MOVE $180,$xxx	; color0
	dc.w	$ffdf,$fffe
	dc.w	$0107,$fffe
	dc.w	$180,$010
	dc.w	$0207,$fffe
	dc.w	$180,$020
	dc.w	$0307,$fffe
	dc.w	$180,$030
	dc.w	$0507,$fffe
	dc.w	$180,$040
	dc.w	$0707,$fffe
	dc.w	$180,$050
	dc.w	$0907,$fffe
	dc.w	$180,$060
	dc.w	$0c07,$fffe
	dc.w	$180,$070
	dc.w	$0f07,$fffe
	dc.w	$180,$080
	dc.w	$1207,$fffe
	dc.w	$180,$090
	dc.w	$1507,$fffe
	dc.w	$180,$0a0

	dc.w	$180,$000			; color0 schwarz
	dc.w	$FFFF,$FFFE			; Ende copperlist
 
	end

