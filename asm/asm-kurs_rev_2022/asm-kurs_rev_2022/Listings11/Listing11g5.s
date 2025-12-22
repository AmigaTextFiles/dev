
; Listing11g5.s -  Verwendung der Coppereigenschaft,  einen "MOVE"
				; durchzuführen erfordert horizontal 8 Pixel.
				; Rechte Taste, um das "Seil" herunter zu bringen.

	SECTION	Spago,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	bsr.w	FaiCopper			; Erstellen der copperlist...

	lea	$dff000,a6
	MOVE.W	#DMASET,$96(a6)		; DMACON - aktivieren copper
	move.l	#COPLIST,$80(a6)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	btst	#2,$16(a6)			; rechte Maustaste gedrückt?
	bne.s	NonScendere
	addq.b	#1,WaitLine			; Wenn ja, lass alles runter!
NonScendere:

	bsr.w	MuoviCopper			; Rolle das Seil...

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Aspetta:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts							; exit


******************************************************************************
; Routine, die die copperliste erstellt. Um eine horizontale Zeile zu 
; ziehen sind 52 copper-MOVEs erforderlich. In diesem Fall nehmen wir
; alternativ 32 MOVE pro Farbe, damit sie keine exakte Zeile beenden,
; aber die 2 Farben "kreuzen" sich in horizontalen Punkten anders.
; Dies erzeugt ein Gefühl der "Welle".
******************************************************************************
;	               ______________
;	              /              \
;	  ..::;::..  /  HaI CaPiTo?!  \
;	 ¡ ________) \_ ______________/
;	 l_`--°'\°¬)  / /
;	 /______·)¯\  \/
;	( \±±±±±)  /
;	 \________/
;	   T____T xCz

NumeroIntrecci	EQU	8
IngombroCopEf	EQU	NumeroIntrecci*(32*2)


FaiCopper:
	LEA	CopBuf,A0				; Adresse buffer in CopList
	MOVEQ	#NumeroIntrecci-1,D6	; Anzahl der Webarten
MAIN0:
	LEA	COLORS1(PC),A1			; Tabelle COLORS1
	MOVEQ	#32-1,D7			; 32 color0 für Farben von COLORS1
COP0:
	MOVE.W	#$0180,(A0)+		; Register COLOR0
	MOVE.W	(A1)+,(A0)+			; Farbwert von Tabelle COLORS1
	DBRA	d7,COP0				; mache die ganze "Zeile" (nicht 1 ganze ...)
	LEA	COLORS2(PC),A1			; Tabelle COLORS2
	MOVEQ	#32-1,D7			; 32 color0 für Farben von COLORS2
COP1:
	MOVE.W	#$0180,(A0)+		; Register COLOR0
	MOVE.W	(A1)+,(A0)+			; Wert color0 aus der Tabelle COLORS2
	DBRA	d7,COP1				; mache die ganze "Zeile" (nicht 1 ganze ...)
	DBRA	d6,MAIN0			; mache alle "Webarten".
	RTS


COLORS1:
	DC.W	$003,$001,$002,$003,$004,$005,$006,$007
	DC.W	$008,$009,$00A,$00B,$00C,$00D,$00E,$10F
	DC.W	$10F,$00E,$00D,$00C,$00B,$00A,$009,$008
	DC.W	$007,$006,$005,$004,$003,$002,$001,$003

COLORS2:
	DC.W	$010,$010,$020,$030,$040,$050,$060,$070
	DC.W	$080,$090,$0A0,$0B0,$0C0,$0D0,$0E0,$0F0
	DC.W	$0F0,$0E0,$0D0,$0C0,$0B0,$0A0,$090,$080
	DC.W	$070,$060,$050,$040,$030,$020,$010,$010


******************************************************************************
; Routine die die Farben dreht ...
******************************************************************************

;	   _
;	 _( )_
;	(_-O-_)
;	  (_)

MuoviCopper:
	LEA	CopBuf,A0				; Buffer in copperlist
	move.w	#(IngombroCopEf*4)-2,d6	; Offset, um die letzte Farbe zu finden
	MOVE.W	0(A0,D6.W),D0		; letzte Farbe in d0 (a0 + Offset!)
	MOVE.W	D6,D5				; Kopie
	SUBQ.W	#4,D5				; vorheriger Farboffset in d5
	MOVE.w	#IngombroCopEf-1,d7
SYNC0:
	MOVE.W	0(A0,D5.W),0(A0,D6.W)	; vorherige Farbe in der "danach" Farbe
	SUBQ.W	#4,D6				; Berechne den nächsten Farboffset
	SUBQ.W	#4,D5				; Berechne den nächsten Farboffset
	dbra	d7,SYNC0			; Laufen Sie für den gesamten "Knoten"
	MOVE.W	D0,2(A0)			; lege die letzte Farbe, die wir gespeichert hatten,
								; als erste Farbe, um den Zyklus nicht zu unterbrechen.
	RTS

******************************************************************************

	section	coop,data_C

COPLIST:
	DC.W	$100,$200			; BplCon0 - keine bitplanes
	DC.W	$180,$003			; Color0 - dunkelblau
WaitLine:
	DC.W	$4001,$FFFE			; warte auf Zeile $40.
CopBuf:
	DCB.L	IngombroCopEf,0		; Platz für den Cop-Effekt
	DC.W	$180,3				; Color0 - dunkelblau
	DC.w	$ffff,$fffe			; Ende Copperlist

	END

Eine andere Verwendung der Besonderheit des copper sich 8 Pixel vorwärts zu
bewegen ist folgender. Wir können sehen, das wir diesen Effekt auch
erhalten wenn Dutzende von COLOR0 unten platziert sind. Dadurch ändern sie
die Wartezeit vor "ihnen" um alle nach unten zu verschieben.


