
; Lezione11f.s - Verwendung von COPER- und VERTB-Interrupt per Level 3 ($6c).
; In diesem Fall definieren wir alle Interrupts richtig neu, 
; um eine Vorstellung davon zu geben, wie es gemacht wird.
; Der Unterschied zu Lezione11e.s ist "formal", tatsächlich wird es 
; verwendet für Interrupts dem Standard des Amiga ROM. Wenn Sie wollen
; folgen Sie einfach dem Label, wie in diesem Beispiel.

	Section	Interrupt,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

		;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:
	move.l	BaseVBR(PC),a0	    ; in a0 ist der Wert des VBR

	MOVE.L	#NOINT1,$64(A0)		; Interrupt "leer"
	MOVE.L	#NOINT2,$68(A0)		; int leer
	move.l	#MioInt6c,$6c(a0)	; ich lege meinen Interrupt-Level 3 fest
	MOVE.L	#NOINT4,$70(A0)		; int leer
	MOVE.L	#NOINT5,$74(A0)		; " "
	MOVE.L	#NOINT6,$78(A0)		; " "

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper								
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; initialisieren der Musik Routine
	movem.l	(SP)+,d0-d7/a0-a6

			; 5432109876543210
	move.w	#%1111111111111111,$9a(a5)  ; INTENA - aktivieren Sie alle
										; interrupts!

mouse:
	btst	#6,$bfe001	; Maus gedrückt? (Der Prozessor 
	bne.s	mouse		; unterbricht die Schleife zu jedem vertical blank
						; um die Musik zu spielen!
						; sowie jedes WAIT der Rasterzeile $a0).						
				
	bsr.w	mt_end		; Ende der Wiederholung!

	rts					; exit


*****************************************************************************
*	INTERRUPT-ROUTINE $64 (Level 1)
*****************************************************************************

;	.-==-.
;	| __ |
;	C °° )
;	| C. |
;	| __ |
;	|(__)|xCz
;	`----'

;02	SOFT	1 ($64)	Reserviert für durch Software ausgelöste Interrupts.
;01	DSKBLK	1 ($64)	Ende der Übertragung eines Datenblocks von der Diskette.
;00	TBE		1 ($64)	Puffer UART-Übertragungs der seriellen Schnittstelle leer

NOINT1:	; $64
	movem.l	d0-d7/a0-a6,-(SP)
	LEA	$DFF000,A0		; custom in A0
	MOVE.W	$1C(A0),D1	; INTENAR in d1
	BTST.l	#14,D1		; Bit Master Reset aktivieren?
	BEQ.s	NoInts1		; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1	; INREQR - in d1 bleiben nur die Bits gesetzt
						; die in INTENA und INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert war.
	btst.l	#0,d1		; TBE?
	beq.w	NoTBE
	; tbe Routine
NoTBE:
	btst.l	#1,d1		; DSKBLK?
	beq.w	NoDSKBLK
	; DSKBLK Routine
NoDSKBLK:
	btst.l	#2,d1		; INTREQR - SOFT?
	beq.w	NoSOFT
	; SOFT Routine
NoSOFT:
NoInts1:	; 210
	move.w	#%111,$dff09c	; INTREQ - soft,dskblk,serial port tbe
	movem.l	(SP)+,d0-d7/a0-a6
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE $68 (Level 2)
*****************************************************************************

;	             ... 
;	             :  ·:
;	             :   :
;	         ____¦,.,l____
;	        /·.·.·   .·.·.\
;	      _/ _____  _____  \_
;	     C/_  (°  C  °)     \).
;	      \ \_____________/ /-'
;	       \  \___l_____/  /xCz
;	   ____ \__`-------'__/ _____
;	  /    ¯¯ `---------' ¯¯    ¬\
;	 /                            ·
;	·

;03	PORTS	2 ($68)	Input/Output Ports und Timers, verbunden mit der INT2-Leitung

NOINT2:	; $68
	movem.l	d0-d7/a0-a6,-(SP)
	LEA	$DFF000,A0		; custom in A0
	MOVE.W	$1C(A0),D1	; INTENAR in d1
	BTST.l	#14,D1		; Bit Master Reset aktivieren?
	BEQ.s	NoInts2		; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1	; INREQR - in d1 bleiben nur die Bits gesetzt
						; die in INTENA und INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert war.

	btst.l	#3,d1		; INTREQR - PORTS?
	beq.w	NoPORTS
	; Routine PORTS
NoPORTS:
	move.l	d0,-(sp)	; speichern d0
	move.b	$bfed01,d0	; CIAA icr - ist es ein Interrupt der Tastatur?
	and.b	#$8,d0
	beq.w	NoTastiera
	; Routine zum Lesen der Tastatur
NoTastiera:
	move.l	(sp)+,d0		; Wiederherstellung d0
NoInts2:	; 3210
	move.w	#%1000,$dff09c	; INTREQ - ports
	movem.l	(SP)+,d0-d7/a0-a6
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE $6c (Level 3) - VERTB und COPER benutzt.	    *
*****************************************************************************

;	 _.--._     _ 
;	|   _ .|   (_)
;	|   \__|   ||
;	|______|   ||
;	.-`--'-.   ||
;	| | |  |\__l|
;	|_| |__|__|_))
;	 ||_| |    ||
;	 |(_) |
;	 |    |
;	 |____|__
;	 |______/g®m


;06	BLIT	3 ($6c)	Wenn der Blitter eine Blittata beendet hat, wird es auf 1 gesetzt
;05	VERTB	3 ($6c)	Wird jedes Mal generiert, wenn der Elektronenstrahl in Betrieb ist
					; und zur Zeile 00 geht, dh zu jedem vertical blank.
;04	COPER	3 ($6c)	; Sie können es mit dem copper einstellen, um ihn zu einem 
					; bestimmten Zeitpunkt (Videozeile) zu erzeugen. Fordern Sie ihn  
					; einfach nach einer gewissen Wartezeit an.

MioInt6c:
	movem.l	d0-d7/a0-a6,-(SP)
	LEA	$DFF000,A0			; custom in A0
	MOVE.W	$1C(A0),D1		; INTENAR in d1
	BTST.l	#14,D1			; Bit Master Reset aktiviert?
	BEQ.s	NoInts3			; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1		; INREQR - in d1 bleiben nur die Bits gesetzt
							; die in INTENA und INTREQ gesetzt sind
							; um sicher zu sein, dass wenn der Interrupt
							; auftritt, auch aktiviert war.
	btst.l	#6,d1			; INTREQR - BLIT?
	beq.w	NoBLIT
	; Routine BLIT
NoBLIT:
	btst.l	#5,d1			; INTREQR - Bit 5, VERTB, ist zurückgesetzt?
	beq.s	NointVERTB		; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:
	btst.l	#4,d1			; INTREQR - COPER ist zurückgesetzt?
	beq.s	NointCOPER		; wenn ja, ist es kein COPER Interrupt!
	move.w	#$F00,$dff180	; int COPER, dann COLOR0 = ROT
NointCOPER:
NoInts3:	 ;6543210
	move.w	#%1110000,$dff09c ; INTREQ - Löschen Flag BLIT,VERTB,COPER
	movem.l	(SP)+,d0-d7/a0-a6
	rte						;  Ende vom Interrupt BLIT,VERTB,COPER

*****************************************************************************
*	INTERRUPT-ROUTINE $70 (Level 4)
*****************************************************************************

;	  .:::::.
;	 ¦:::·:::¦
;	 |·     ·|
;	C| ¬   - l)
;	 ¡_°(_)°_|
;	 |\_____/|
;	 l__`-'__!
;	   `---'xCz

;10	AUD3	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 3 beendet
;09	AUD2	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 2 beendet
;08	AUD1	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 1 beendet
;07	AUD0	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 0 beendet

NOINT4: ; $70
	movem.l	d0-d7/a0-a6,-(SP)
	LEA	$DFF000,A0		; custom in A0
	MOVE.W	$1C(A0),D1	; INTENAR in d1
	BTST.l	#14,D1		; Bit Master Reset aktivieren?
	BEQ.s	NoInts4		; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1	; INREQR - in d1 bleiben nur die Bits gesetzt
						; die in INTENA und INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert war.
	BTST.l	#7,d1		; INTREQR - AUD0?
	BEQ.W	NoAUD0
	; Routine aud0
NoAUD0:
	BTST.l	#8,d1		; INTREQR - AUD1?
	BEQ.W	NoAUD1
	; Routine aud1
NoAUD1:
	BTST.l	#9,d1		; INTREQR - AUD2?
	Beq.W	NoAUD2
	; Routine aud2
NoAUD2:
	BTST.l	#10,d1		; INTREQR - AUD3?
	Beq.W	NoAUD3
	; Routine aud3
NoAUD3:
NoInts4:	; 09876543210
	MOVE.W	#%11110000000,$DFF09C	; aud0,aud1,aud2,aud3
	movem.l	(SP)+,d0-d7/a0-a6
	RTE

*****************************************************************************
*	INTERRUPT-ROUTINE $74 (Level 5)
*****************************************************************************

;	  .:::::.
;	 ¦:::·:::¦
;	 |· - - ·|
;	C|  q p  l)
;	 |  (_)  |
;	 |\_____/|
;	 l__  ¬__!
;	   `---'xCz

;12	DSKSYN	5 ($74)	wird generiert, wenn das DSKSYNC-Register mit den Daten übereinstimmt
				; Lesen Sie von der Diskette im Laufwerk. Achten Sie auf Hardwarelader.
;11	RBF		5 ($74)	UART-Puffer zum Empfangen des FULL-Serial-Ports.


NOINT5: ; $74
	movem.l	d0-d7/a0-a6,-(SP)
	LEA	$DFF000,A0		; custom in A0
	MOVE.W	$1C(A0),D1	; INTENAR in d1
	BTST.l	#14,D1		; Bit Master Reset aktivieren?
	BEQ.s	NoInts5		; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1	; INREQR - in d1 bleiben nur die Bits gesetzt
						; die in INTENA und INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert war.
	BTST.l	#12,d1		; INTREQR - DSKSYN?
	BEQ.W	NoDSKSYN
	; Routine dsksyn
NoDSKSYN:
	BTST.l	#11,d1		; INTREQR - RBF?
	BEQ.W	NoRBF
	; Routine rbf
NoRBF:
NoInts5:	; 2109876543210
	MOVE.W	#%1100000000000,$DFF09C	; serial port rbf, dsksyn
	movem.l	(SP)+,d0-d7/a0-a6
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE $78 (Level 6)				    *
*****************************************************************************

;	  .:::::.
;	 ¦:::·:::¦
;	 |· - - ·|
;	C|  O p  l)
;	/ _ (_) _ \
;	\_\_____/_/
;	 l_\___/_!
;	  `-----'xCz

;14	INTEN	6 ($78)
;13	EXTER	6 ($78)	Interrupt extern, an die Leitung angeschlossen INT6 + TOD CIAB

NOINT6: ; $78
	movem.l	d0-d7/a0-a6,-(SP)
	tst.b	$bfdd00		; CIAB icr - Reset interrupt timer
	LEA	$DFF000,A0		; custom in A0
	MOVE.W	$1C(A0),D1	; INTENAR in d1
	BTST.l	#14,D1		; BitMaster Reset aktivieren?
	BEQ.s	NoInts6		; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1	; INREQR - in d1 bleiben nur die Bits gesetzt
						; die in INTENA und INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert war.
	BTST.l	#14,d1		; INTREQR - INTEN?
	BEQ.W	NoINTEN
	; Routine inten
NoINTEN:
	BTST.l	#13,d1		; INTREQR - EXTER?
	BEQ.W	NoEXTER
	; Routine exter
NoEXTER:
NoInts6:	; 432109876543210
	MOVE.W	#%110000000000000,$DFF09C ; INTREQ - external int + ciab
	movem.l	(SP)+,d0-d7/a0-a6
	rte

*****************************************************************************
;	Wiederholungsroutine protracker/soundtracker/noisetracker
;
	include	"assembler2:sorgenti4/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200	; BPLCON0 - no bitplanes
	dc.w	$180,$00e	; color0 BLAU
	dc.w	$a007,$fffe	; WAIT - warte auf Zeile $a0
	dc.w	$9c,$8010	; INTREQ - Fordern Sie einen COPER-Interrupt an,
						; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$FFFF,$FFFE	; Ende copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"assembler2:sorgenti4/mod.yellowcandy"

	end

Wie Sie sehen, verwenden wir in dieser "Version" alle Tricks, die
Verwenden Sie Betriebssystem-Interrupts:

	LEA	$DFF000,A0		; custom in A0
	MOVE.W	$1C(A0),D1	; INTENAR in d1
	BTST.l	#14,D1		; Bit Master Reset aktivieren?
	BEQ.s	NoInts1		; wenn ja, Interrupt ist nicht aktiv!
	AND.W	$1E(A0),D1	; INREQR - in d1 bleiben nur die Bits gesetzt
						; die in INTENA und INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert war.
	btst.l	#0,d1		; TBE?
	...

In der Praxis wird eine weitere Überprüfung der Interrupt-Gültigkeit gemacht.
Es wird geprüft, ob das in INTREQR gesetzte Bit auch in INTENAR gesetzt ist, dh
ob es aktiviert ist. Eigentlich, wenn Sie einen Interrupt mit dem Register 
INTENA ($dff09a) deaktivieren, sollte es nicht weiter funktionieren. Es kann
jedoch sein, dass die Hardware nicht perfekt ist. Wenn Sie seltsame 
Inkompatibilitäten in ihren Interrupts finden, überprüfen Sie dies auch, wer 
weiß ob "deaktivierte" Interrupts nicht doch ausgeführt werden!

Anm. vom Übersetzer: während der Programmausführung z.B. "Hallo Welt" 
eingeben. Bei Ende des Programms kann man die Eingabe bewundern.


