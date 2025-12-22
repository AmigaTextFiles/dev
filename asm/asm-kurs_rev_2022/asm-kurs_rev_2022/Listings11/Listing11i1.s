
; Listing11i1.s	- Vollbild-Farbscrolling PAL

	SECTION	Scorricol,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	;  nur copper DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	BSR.w	MAKECOP				; copperlist erstellen

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#MYCOP,$80(a5)		; Zeiger COP
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

	btst	#2,$16(a5)			; richtige Taste gedrückt?
	beq.s	Mouse2				; wenn ja ColorScrollPAL nicht ausführen

	bsr.s	ColorScrollPAL		; Scrollen von Farben

mouse2:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2			; warte auf Zeile $12c
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

*****************************************************************************
;	Routine die die copperlist erstellt
*****************************************************************************

;	   .__ _  __..... .   .    .
;	-\-'_ \\// _`-/-- -  -    -
;	  \(-)____(-)/// /  /    /
;	  -'_/V""V\_`- _  _    _
;	    \ \    /__ _  _    _
;	     \ \,,/__ _  _    _
;	        \/-Mo!

MakeCop:
	lea	MYCOP,a0				; Adresse der zu erledigenden copperlist
	move.l	#$1f07fffe,d0		; WAIT-Anweisung, erste Zeile $1f
								; dh WAIT starten
	move.l	#$0007fffe,d1		; Letzte NTSC-Zeile der copperlist
								; dh endgültiges WAIT
	bsr.w	FaiColors			; Mache dieses Stück copperliste
								; von $1f bis $ff, dh der NTSC-Teil

	move.l	#$ffdffffe,(a0)+	; Wait Besonders, um auf das Ende 
								; des NTSC-Bereichs zu warten.
	move.l	#$0007fffe,d0		; Erste Zeile des PAL-Bereichs (WAIT)
								; dh WAIT starten
	move.l	#$3707fffe,d1		; Letzte Zeile am unteren Bildschirmrand
								; dh endgültiges WAIT
	bsr.s	FaiColors2			; Mache das PAL-Stück der copperlist
	move.l	#$fffffffe,(a0)+	; Ende copperlist
	rts


*****************************************************************************
; SubRoutine, die die copperliste erstellt - in a0 die Adresse der
; copperliste, in d0 die erste Wartezeit, in d1 die letzte
*****************************************************************************

;	  _    _  _ ___
;	(( _ \--/ _ ) )
;	\_\(°/__\°)/_/
;	 \-'_/VV\_`-/
;	 \\_\'  `/_/   
;	  \ \\..//
;	   \ `\/'

FaiColors:
	lea	ColorTabel(PC),a1		; Adresse Farbtabelle
FaiColors2:
	move.l	d0,(a0)+			; Gebe das WAIT in die coplist ein
	move.w	#$0180,(a0)+		; Gebe das Register COLOR0 ein 
	move.w	(a1)+,(a0)+			; Und die Farbe von der Tabelle
	cmp.l	#ColorTabelEnd,a1	; sind wir bei der letzten Farbe der Tabelle?
	bne.s	labelok				; Noch nicht? dann geh nicht
	lea	ColorTabel(PC),a1		; ansonsten von der ersten Farbe beginnen
labelok:
	addi.l	#$01000000,d0		; Erhöhe die Y-Position von WAIT
	cmp.l	d0,d1				; Haben wir bis zum letzten Mal gewartet?
	bne.s	FaiColors2			; Wenn noch nicht, machen Sie eine andere Zeile
	rts


*****************************************************************************
; Routine die die Farben bewegt
*****************************************************************************

;	 \  /
;	  oO
;	 \__/

ColorScrollPAL:
	move.l	PuntatorecolTab(PC),a0	; PuntatorecolTab in a0
	lea	MYCOP+6,a1				; Adresse der ersten Farbe in copper
	move.l	#225-1,d0			; 225 Farben im Bereich NTSC bewegen
	bsr.s	scroll				; Scrollen durch den NTSC-Teil des Bildschirms
	addq.w	#4,a1				; überspringen Sie die spezielle Wartezeit am Ende
								; der NTSC Zone ($FFDFFFFE)
	moveq	#54-1,d0			; 54 Farben im Bereich PAL bewegen
	bsr.s	scroll				; Scrollen durch den PAL-Teil des Bildschirms

	lea.l	PuntatorecolTab(PC),a0	; PuntatorecolTab in a0
	addq.l	#2,(a0)				; Eine Farbe für die nächste vorrücken
								; routinemäßige Ausführung
	cmp.l	#ColorTabelEnd,(a0)	; sind wir bei der letzten Farbe 
								; der Tabelle angekommen??
	bne.s	NonRipartire		; Wenn wir noch nicht aus der Routine sind
	move.l #ColorTabel,(a0)		; Ansonsten fange von der Tabelle 
								; von vorne an
NonRipartire:
	rts

*****************************************************************************
; Subroutine, die die Farben verschiebt; die Anzahl der Farben muss in d0 
; eingegeben werden, die Farbtabellenadresse in a0
; und die Farben in coplist in a1
*****************************************************************************

scroll:
	move.w	(a0)+,(a1)			; Kopiere die Farbe aus der Tabelle in die
								; copperlist
	cmp.l	#ColorTabelEnd,a0	; haben wir die letzte Farbe 
								; von der Tabelle kopiert?
	bne.s	okay				; Wenn noch nicht, weiter machen
	lea	ColorTabel(PC),a0		; ColorTabel in a0 - von der ersten 
								; Tabellenfarbe starten
okay:
	addq.w	#8,a1				; Gehe zur nächsten Farbe in copperlist
	dbra	d0,scroll			; d0 = Anzahl der einzugebenden Farben
	rts


;	Tabelle mit RGB-Farben

ColorTabel:
	dc.w	$000,$100,$200,$300,$400,$500,$600,$700
	dc.w	$800,$900,$a00,$b00,$c00,$d00,$e00,$f00
	dc.w	$e00,$d00,$c00,$b00,$a00,$900,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$010
	dc.w	$020,$030,$040,$050,$060,$070,$080,$090
	dc.w	$0a0,$0b0,$0c0,$0d0,$0e0,$0f0,$0e0,$0d0
	dc.w	$0c0,$0b0,$0a0,$090,$080,$070,$060,$050
	dc.w	$040,$030,$020,$010,$000,$001,$002,$003
	dc.w	$004,$005,$006,$007,$008,$009,$00a,$00b
	dc.w	$00c,$00d,$00e,$00f,$00e,$00d,$00c,$00b
	dc.w	$00a,$009,$008,$007,$006,$005,$004,$003
	dc.w	$002,$001
ColorTabelEnd:

;	Dies ist der Zeiger auf die ColorTabel-Tabelle

PuntatorecolTab:
	dc.l	ColorTabel+2

*****************************************************************************
; Copperliste vollständig aus der MAKECOP-Routine erstellt; auf diese Weise
; mache einfach einen BSS-Abschnitt!
*****************************************************************************

	Section	Copperlist,bss_C

MYCOP:
	ds.b	225*8				; Platz für die Fläche NTSC
	ds.b	4					; Platz für die $FFDFFFFE
	ds.b	55*8				; Platz für die Fläche PAL
	ds.b	4					; Platz für das Ende von copperlist $FFFFFFFE

	end

