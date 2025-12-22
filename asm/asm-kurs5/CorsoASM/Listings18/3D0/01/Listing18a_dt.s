; Listing18a.s = Lezione3d-1a.s

	section	DotCube3d,code

; Perspektive + Translation X,Y,Z (Dot-Cube)
; rechts / links mit Maus für Auf / Ab: Translation X und Y
; Linke / rechte Maustaste = Z bewegen (näher / weiter weg bewegen)

*****************************************************************************
	;include	"Assembler2:sorgenti4/startup1.s" ; copperlist speichern etc.
	include "startup2.s"
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper, bitplane und blitter
WaitDisk EQU	%0				; wegen startup2
LarghSchermo	=	320
LunghSchermo	=	256

START:
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.l	#0,$108(a5)

	move.b	$dff00a,mouse_y		; JOY0DAT vertikale Mausposition
	move.b	$dff00b,mouse_x		; horizontale Mausposition

LoopMain:
	lea	$dff000,a5
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2			; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $12c
	BNE.S	Waity1

	BSR.w	ScambiaEpulisci		; Bildschirme im Doppelpuffer tauschen und
								; alten Bildschirm reinigen

	bsr.s	LeggiMouse			; Liest die Bewegung der Maus um
								; die X- und Y-Translationswerte zu aktualisieren

; Jetzt mit der rechten und linken Taste der Maus können wir eine Translation
; in Bezug auf die Z-Achse ausführen, die das Objekt näher oder weiter weg bringt.

	btst.b	#6,$bfe001			; linke Maustaste?
	bne.s	NonAllontana
	cmp.w	#40*50,ZADD			; sind wir sehr weit weg?
	beq.s	NonAllontana		; wenn ja, anhalten
	ADD.W	#40,ZADD			; Translation von uns weg
NonAllontana:
	btst.b	#2,$dff016			; rechte Maustaste?
	bne.s	NonAvvicina
	CMP.W	#-40,ZADD			; sind wir zu uns sehr nah?
	beq.s	NonAvvicina			; wenn ja, das reicht!
	SUB.W	#40,ZADD			; Translation der Annäherung an uns
	btst.b	#6,$bfe001			; wird auch die linke Taste gedrückt?
	beq.s	ESCIMI				; Wenn ja, dann raus!
NonAvvicina:

	BSR.w	TRASLAZIONE			; TRANSLATION des Objekts gemäß den Werten
								; der Variablen XADD, YADD und ZADD.

	BSR.w	PROSPETTIVA			; PERSPEKTIVE PROJEKTION. Die bewegten Punkte
								; werden auf den "Monitor" projiziert.

	bsr.w	DisegnaOggetto		; Objekt zeichnen (einfache X-, Y-Punkte)

	bra.s 	LoopMain			; Bereit für den nächsten Frame

ESCIMI:
	rts

******************************************************************************
; Diese Routine liest die Maus und aktualisiert die Werte in den
; XADD- und YADD-Variablen, die für die Translation verwendet werden.
******************************************************************************

LeggiMouse:
	move.b	$dff00a,d1			; JOY0DAT vertikale Mausposition
	move.b	d1,d0				; Kopie in d0
	sub.b	mouse_y(PC),d0		; alte Mausposition subtrahieren
	beq.s	no_vert				; wenn die Differenz = 0 ist, wird die Maus gestoppt
	ext.w	d0					; wandelt das Byte in ein Wort um
								; (siehe am Ende der Listings)
	add.w	d0,YADD				; Würfelposition ändern
no_vert:
  	move.b	d1,mouse_y			; speichern der Mausposition für das nächste Mal

	move.b	$dff00b,d1			; horizontale Mausposition
	move.b	d1,d0				; Kopie in d0
	sub.b	mouse_x(PC),d0		; alte Position subtrahieren
	beq.s	no_oriz				; wenn die Differenz = 0 ist, wird die Maus gestoppt
	ext.w	d0					; wandelt das Byte in ein Wort um
								; (siehe am Ende der Listings)
	add.w	d0,XADD				; Würfelposition ändern 
no_oriz:
  	move.b	d1,mouse_x			; speichern der Mausposition für das nächste Mal
	RTS

mouse_y:	dc.b	0			; hier wird das Y der Maus gespeichert
mouse_x:	dc.b	0			; Hier wird das X der Maus gespeichert

****************************************************************************
* ROUTINE, DIE DIE PERSPEKTIVE DER ROTATION DURCHFÜHRT.					   *
*																		   *
* Quelle: Tabelle "PuntiXYZtraslati", mit 3 Koordinaten XYZ pro Punkt	   *
*																		   *
* Ziel: Tabelle "PuntiXYproiettati", mit 2 Koordinaten X¹,Y¹			   *
*																		   *
* Die einzige andere Variable ist der Abstand Z des Beobachters vom        *
* Bildschirm, was in diesem Fall 256 ist, so dass Sie eine "ASL #8"        * 
* anstelle von einer zeitintensiven Multiplikation ausführen können.	   *
****************************************************************************

PROSPETTIVA:
	LEA	PuntiXYZtraslati(PC),A0	 ; Adresse Tab. der X,Y,Z aus
								 ; Projektion (bereits bewegt)
	LEA	PuntiXYproiettati(PC),A1 ; Tabelle, wo die  projizierten Koordinaten X¹,Y¹
								 ; platziert werden sollen.
	MOVE.w	#LarghSchermo/2,D3  ; X Bildschirmmitte (für Mitte)
	MOVE.W 	#LunghSchermo/2,D4  ; Y Bildschirmmitte (für Mitte)

	MOVE.w	#NPuntiOggetto-1,D7	; Anzahl der zu projizierenden Punkte
Proiez:
	MOVEM.W	(a0)+,d0-d2			; Koord. X in d0, Y in d1, Z in d2
	ASL.L	#8,d0				; (MULS #256) DistZossSchermo*Xogg
	ASL.L	#8,d1				; (MULS #256) DistZossSchermo*Yogg
	ADD.W	#256,d2			    ; Zogg+DistZossSchermo
	DIVS.w	D2,D0				; (DistZoss_Schermo*Xogg)/(Zogg+DistZossSchermo)
	DIVS.w	D2,D1				; (DistZoss_Schermo*Yogg)/(Zogg+DistZossSchermo)
	ADD.W	d3,D0				; + Koordinate X Mitte des Bildschirms (zur Mitte)
	ADD.W 	d4,D1				; + Koordinate Y Mitte des Bildschirms (zur Mitte)
	MOVEM.W	D0-D1,(A1)			; speichern der projizierten und bewegten X¹- und Y¹-Werte
	ADDQ.W	#2+2,A1				; zu den nächsten 2 Werten springen
	DBRA 	D7,Proiez			; Wiederholen Sie NumberPoints-Zeiten für alle Punkte.
	RTS							; bis alle gescreent sind

****************************************************************************
* Translationsroutine, die einfach den Wert der Variablen XADD, YADD, ZADD * 
* zu den Objektkoordinaten addiert, wodurch die "Verschiebung" im Raum     *
* verursacht wird.														   * 
****************************************************************************

TRASLAZIONE:
	lea	Oggetto1(PC),a0			; Koord x,y,z Objekt (Quelle)
	LEA	PuntiXYZtraslati(PC),A1	; Tabelle für gedrehte Punkte X,
								; das ist das Ziel!
	MOVE.w	#NPuntiOggetto-1,D7	; Anzahl der zu bewegenden Punkte
TRLOOP:
	movem.w	(a0)+,d0/d1/d2		; X in d0, Y in d1, Z in d2
	add.w	XADD(PC),d0			; X Translation (+ = rechts, - = links)
	add.w	YADD(PC),d1			; Y Translation (+ = unten, - = oben)
	add.w	ZADD(PC),d2			; Z Translation (+ = zurück, - = vorwärts)
	move.w	D0,(A1)+			; speichern X in PuntiXYZtraslati
	move.w	D1,(A1)+			; speichern Y in PuntiXYZtraslati
	move.w	D2,(A1)+			; speichern Z in PuntiXYZtraslati
	DBRA 	D7,TRLOOP			; Führen Sie NumberPoints-Male aus, um alle
	RTS							; Punkte zu drehen.

XADD:
	dc.w	0
YADD:
	dc.w	0
ZADD:
	dc.w	0

******************************************************************************
**	ROUTINE ZUM ZEICNEN DES 3D OBJEKTES AUF DER BITPLANE (mit Punkten!)	    **
******************************************************************************

DisegnaOggetto:
	lea	PuntiXYproiettati(PC),a4 ; Puffer Koordinate X¹ und Y¹
	moveq	#NPuntiOggetto-1,d7	; Anzahl der zu zeichnenden Punkte
	move.l	DrawPlane(pc),a0	; aktuelle Bildschirmadresse in a0
PlottaLoop:
	movem.w	(a4)+,d0-d1			; Koord X¹ in d0 und Koord Y¹ in d1
	bsr.s	PlotPIX				; Punkt drucken auf Koordinate X=d0, Y=d1
	dbra	d7,PlottaLoop		; alle Punkte drucken
	rts

*****************************************************************************
;			Routine zur Darstellung von Punkten (dots)
*****************************************************************************

;	Eingabeparameter PlotPIX:
;
;	a0 = Adresse bitplane Ziel
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

Largschermo	equ	40				; Bildschirmbreite in Bytes

PlotPIX:
	cmp.w	#320,d0				; sind wir raus?
	blo.s	Ok1
	rts
Ok1:
	cmp.w	#256,d1				; sind wir raus?
	blo.s	Ok2
	rts
Ok2:
	move.w	d0,d2				; Kopie der X Koordinate in d2
	lsr.w	#3,d0				; In der Zwischenzeit finden Sie den horizontalen Versatz,
								; durch Teilen der X-Koordinate durch 8.
	mulu.w	#Largschermo,d1
	add.w	d1,d0				; Summenversatz vertikal bis horizontal

	and.w	#%111,d2			; Wählen Sie nur die ersten 3 Bits von X.
								; (Eigentlich wäre es der Rest der Division
								; für 8 früher gemacht)
	not.w	d2

	bset.b	d2,(a0,d0.w)		; Setzt das d2-Bit des entfernten Bytes d0 Bytes
								; vom Anfang des Bildschirms.
	rts

*************************************************
*	Swap Logical and Physical Screens	*
*************************************************

ScambiaEpulisci:
	MOVE.L 	SCREEN(PC),D0
	CMP.L 	DrawPlane(PC),D0	; Is current screen=screen1
	BNE.s	SWAPIT				; No then branch
	MOVE.L 	SCREEN(PC),D0		; Display Screen1
	BSR.s	PuntaPlaneInCop		; Insert it Into Copper
	MOVE.L 	SCREEN1(PC),DrawPlane	; Screen2 = Logical 
	MOVE.L 	SCREEN1(PC),A1		; Address to Clear
	BSR.w	CpuClearScreen		; Do it !!!
  	RTS
  	
SWAPIT:
	MOVE.L 	SCREEN1(PC),D0		; Use screen2
	BSR.s	PuntaPlaneInCop		; Insert screen
	MOVE.L 	SCREEN(PC),DrawPlane	; screen1=logical
	MOVE.L 	SCREEN(PC),A1		; address to clear
	BSR.w	CpuClearScreen
	RTS
	
PuntaPlaneInCop:
	LEA	BplPointer,A0			; Zeiger copperlist
	MOVE 	D0,6(A0)			; auf die plane zeigen 
	SWAP 	D0
	MOVE 	D0,2(A0)
	RTS


DrawPlane:
	dc.l	Bitplane

; Zeiger auf die 2 Bildschirme für das Double Buffering

SCREEN:
	dc.l Bitplane0
SCREEN1:
	dc.l Bitplane

******************************************************************************
*	Bildschirm CLEAR-Routine über den Prozessor
*
*	A1 = Adresse des zu reinigenden Bildschirms
******************************************************************************

CpuClearScreen:
	MOVEM.L	D0-D7/A0-A6,-(SP)	; alle Register speichern
	MOVE.L	SP,OLDSP			; Speichern des STACK POINTER, um ihn zu verwenden
	LEA	40*LunghSchermo(a1),SP	; Laden Sie die hohe Adresse, also
								; das Ende des Bildschirms, da Movems
								; "rückwärts" reinigen.
	MOVEM.L	CLREG(PC),D0-D7/A0-A6	; Wir setzen alle Register mit nur
								; einem Movem aus einem Puffer von Nullen zurück.

; Lassen Sie uns nun den Speicher mit vielen ausgeführten "MOVEM.L D0-D7/A0-A6,-(SP)" 
; nacheinander löschen. Jeder Befehl setzt 60 Bytes zurück (15 Register long, das
; macht 15*4=60 Bytes) und schreibe in -(SP). Passen Sie auf, dass es vom Ende des
; Bildschirms (unten) beginnt und "nach oben geht" und so den Speicher zurückgeht.
; In hex wird das Movem als "$48E7FFFE" zusammengesetzt, es ist also genug
; eine "dcb.l number_instructions, $48e7fffe" einzugeben.

	dcb.l	170,$48E7FFFE		; 60*170=10200 bytes löschen

	movem.l	d0-d7/a0-a1,-(SP)	; die Letzten 40 bytes... (total 10240)

	MOVE.L	OLDSP(PC),SP		; den alten SP zurücksetzen
	MOVEM.L	(SP)+,D0-D7/A0-A6	; Wert der Register zurücksetzen
	RTS

; 15 Longs gelöscht, um in die Register geladen zu werden, um sie zu löschen

CLREG:
	dcb.l	15,0

OLDSP:
	dc.l	0

******************************************************************************
* Definition des 3D-Volumenkörpers durch die X-, Y-, Z-Koordinaten seiner Punkte.  *
******************************************************************************

;	WENIGER< X >MEHR'		WENIGER			MEHR'
;							 ^				/|
;							 Y		       Z
;							 v		     |/
;							MEHR'		   WENIGER

;	      (P4) -50,-50,+50______________+50,-50,+50 (P5)
;					     /|			   /|
;					    / |		      / |
;					   /  |			 /  |
;					  /   |			/   |
;	 (P0) -50,-50,-50/____|________/+50,-50,-50 (P1)
;					|     |       |     |
;				    |     |_______|_____|+50,+50,+50 (P6)
;					|    /-50,+50,+50 (P7)
;					|   /	      |   /
;					|  /	      |  /
;					| /			  | /
;					|/____________|/+50,+50,-50 (P2)
;	 (P3) -50,+50,-50

Oggetto1:  ; Hier sind die 8 durch die Koordinate  X, Y, Z definierten Punkte.
	dc.w	-50,-50,-50	; P0 (X,Y,Z)
	dc.w	+50,-50,-50	; P1 (X,Y,Z)
	dc.w	+50,+50,-50	; P2 (X,Y,Z)
	dc.w	-50,+50,-50	; P3 (X,Y,Z)
	dc.w	-50,-50,+50	; P4 (X,Y,Z)
	dc.w	+50,-50,+50	; P5 (X,Y,Z)
	dc.w	+50,+50,+50	; P6 (X,Y,Z)
	dc.w	-50,+50,+50	; P7 (X,Y,Z)

NPuntiOggetto	= 8

******************************************************************************
;		    Daten und Variablen der Routine			     *
******************************************************************************

; Puffer für geänderte Punkte (gedreht und / oder bewegt im 3D-Raum).

PuntiXYZtraslati:
	DS.W	NPuntiOggetto*3

; --------------------------------------------------------------------------

; Koordinaten X¹ und Y¹ projiziert, dh perspektivisch, bereit gezeichnet zu
; werden. Die Koordinaten werden paarweise im Puffer gespeichert
; Aufeinanderfolgende X¹ und Y¹: XY, XY, XY, XY, XY ..., ein Wort für jede Koordinate.

PuntiXYproiettati:
	DS.W	NPuntiOggetto*2

; --------------------------------------------------------------------------

	Section	Copperlist,data_C

COPPERLIST:
	DC.W $120,0
	DC.W $122,0
	DC.W $008e,$2C81
	DC.W $0090,$20C1
	DC.W $0092,$0038
	DC.W $0094,$00d0
	DC.W $0108,0
	DC.W $010a,0
	DC.W $0102,0
	DC.W $100,%0001001000000000
	DC.W $180,0,$182,$FFFF,$184,$ffff
BplPointer:
	DC.W $E0,0,$E2,0
	DC.W $FFFF,$FFFE

	section	planes,bss_C

Bitplane0:
	ds.b	40*LunghSchermo

Bitplane:
	ds.b	40*LunghSchermo

	end

; Xogg, Yogg, Zogg			- X,Y,Z des Objekts
; DistZossSchermo			- Entfernung (Distanz) vom Auge zum Bildschirm
