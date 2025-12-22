
; Lezione11e.s - Verwendung von COPER- und VERTB-Interrupt per Level 3 ($6c).
; In diesem Fall definieren wir alle Interrupts richtig neu, 
; um eine Vorstellung davon zu geben, wie es gemacht wird.

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

;	.:·.·...·..
;	 ·::::::::::.
;	  ·::::::::::
;	  ( _____·:::
;	   \____` ::|
;	   _(° _)  ·l
;	  / ¯¯¯     .)
;	 /         ¯T
;	/  ,_  ___ _j
;	¯¯¬ l____\  \
;	        ¬\\  \ xCz
;	__________)   \
;	\_      _____  \
;	 `------'   \___)

;02	SOFT	1 ($64)	Reserviert für durch Software ausgelöste Interrupts.
;01	DSKBLK	1 ($64)	Ende der Übertragung eines Datenblocks von der Diskette.
;00	TBE		1 ($64)	Puffer UART-Übertragungs der seriellen Schnittstelle leer
				
NOINT1:	; $64
	btst.b	#0,$dff01f	; INTREQR - TBE?
	beq.w	NoTBE
	; tbe Routine
NoTBE:
	btst.b	#1,$dff01f	; INTREQR - DSKBLK?
	beq.w	NoDSKBLK
	; DSKBLK Routine
NoDSKBLK:
	btst.b	#2,$dff01f	; INTREQR - SOFT?
	beq.w	NoSOFT
	; SOFT Routine
NoSOFT:
			; 210
	move.w	#%111,$dff09c	; INTREQ - soft,dskblk,serial port tbe
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE $68 (Level 2)
*****************************************************************************

;	    .:::::::::.
;	   ¦:·       ·:¦
;	   |'         `|
;	   |    ,      |
;	   |  ¯¯   `-- |
;	  _!   __  __  |
;	 (C \ ( °)(o ) |
;	  7 /\ ¯(__)¯ _!
;	 / /  \______/\\
;	/  \_______l__//
;	\   \:::::::::\\ xCz
;	 \   \:::::::::\\
;	  \___¯¯¯¯¯¯¯¯¯¯/
;	     `---------'

;03	PORTS	2 ($68)	Input/Output Ports und Timer, die an die INT2-Leitung angeschlossen sind
					
NOINT2:	; $68
	btst.b	#3,$dff01f	; INTREQR - PORTS?
	beq.w	NoPORTS
	; Routine PORTS
NoPORTS:
	move.l	d0,-(sp)	; speichern d0
	move.b	$bfed01,d0	; CIAA icr - ist es ein Interrupt der Tastatur?
	and.b	#$8,d0
	beq.w	NoTastiera
	; Routine zum Lesen der Tastatur
NoTastiera:
	move.l	(sp)+,d0	; Wiederherstellung d0
			; 3210
	move.w	#%1000,$dff09c	; INTREQ - ports
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE $6c (Level 3) - VERTB und COPER benutzt.				*
*****************************************************************************
;	    __________________
;	 __/  _______________/
;	( .      ¬(___©)\©_T
;	 \_,             \ |
;	  T            C. )|
;	  l____________  _ |
;	       T      l__¬_!
;	       |   (_) T`-'
;	       l__     ¦ xCz
;	         `-----'

;06	BLIT	3 ($6c)	Wenn der Blitter eine Blittata beendet hat, wird es auf 1 gesetzt
;05	VERTB	3 ($6c)	Wird jedes Mal generiert, wenn der Elektronenstrahl in Betrieb ist
					; und zur Zeile 00 geht, dh zu jedem vertical blank.
;04	COPER	3 ($6c)	; Sie können es mit dem copper einstellen, um ihn zu einem 
					; bestimmten Zeitpunkt (Videozeile) zu erzeugen. Fordern Sie ihn  
					; einfach nach einer gewissen Wartezeit an.

MioInt6c:
	btst.b	#6,$dff01f		; INTREQR - BLIT?
	beq.w	NoBLIT
	; Routine BLIT
NoBLIT:
	btst.b	#5,$dff01f		; INTREQR - Bit 5, VERTB, ist zurückgesetzt?
	beq.s	NointVERTB		; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:
	btst.b	#4,$dff01f			; INTREQR - COPER ist zurückgesetzt?
	beq.s	NointCOPER			; wenn ja, ist es kein COPER Interrupt!
	move.w	#$F00,$dff180		; int COPER, dann COLOR0 = ROT
NointCOPER:
			 ;6543210
	move.w	#%1110000,$dff09c	; INTREQ - Löschen Flag BLIT,VERTB,COPER
	rte							; Ende vom Interrupt BLIT,VERTB,COPER

*****************************************************************************
*	INTERRUPT-ROUTINE $70 (Level 4)
*****************************************************************************

;	    _/\__/\_
;	  _/ '_  _`¬\_
;	 (/  (¤)(¤)  \)
;	 /  _ ¯··¯ _  \
;	/    ¯Y¯¯Y¯    \
;	\____ '  ` ____/
;	   `--------' xCz

;10	AUD3	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 3 beendet
;09	AUD2	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 2 beendet
;08	AUD1	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 1 beendet
;07	AUD0	4 ($70)	Lesen eines Datenblocks über den Kanal Audio 0 beendet


NOINT4: ; $70
	BTST.b	#7,$dff01f		; INTREQR - AUD0?
	BEQ.W	NoAUD0
	; Routine aud0
NoAUD0:
	BTST.b	#8-7,$dff01e	; INTREQR - AUD1? Notiz: $dff01e und nicht $dff01f
							; weil das bit> 7 ist!
	BEQ.W	NoAUD1
	; Routine aud1
NoAUD1:
	BTST.b	#9-7,$dff01e	; INTREQR - AUD2?
	Beq.W	NoAUD2
	; Routine aud2
NoAUD2:
	BTST.b	#10-7,$dff01e	; INTREQR - AUD3?
	Beq.W	NoAUD3
	; Routins aud3
NoAUD3:
			; 09876543210
	MOVE.W	#%11110000000,$DFF09C	; aud0,aud1,aud2,aud3
	RTE

*****************************************************************************
*	INTERRUPT-ROUTINE $74 (Level 5)
*****************************************************************************

;	 .:::::.
;	 ¦:·_ _!
;	 ! (°T°)
;	( , ¯,\\
;	 \`---¯/
;	  `---' xCz

;12	DSKSYN	5 ($74)	wird generiert, wenn das DSKSYNC-Register mit den Daten übereinstimmt
				; Lesen Sie von der Diskette im Laufwerk. Achten Sie auf Hardwarelader.
;11	RBF		5 ($74)	UART-Puffer zum Empfangen des FULL-Serial-Ports.


NOINT5: ; $74
	BTST.b	#12-7,$dff01e	; INTREQR - DSKSYN?
	BEQ.W	NoDSKSYN
	; Routine dsksyn
NoDSKSYN:
	BTST.b	#11-7,$dff01e	; INTREQR - RBF?
	BEQ.W	NoRBF
	; Routine rbf
NoRBF:
			; 2109876543210
	MOVE.W	#%1100000000000,$DFF09C	; serial port rbf, dsksyn
	rte

*****************************************************************************
*	INTERRUPT-ROUTINE  $78 (Level 6)				    *
*****************************************************************************

;	 ......
;	¡·¸ ,·:¦
;	| °u°. )
;	l_`--'_!
;	 `----'xCz

;14	INTEN	6 ($78)
;13	EXTER	6 ($78)	Interrupt extern, an die INT6 + TOD CIAB-Leitung angeschlossen

NOINT6: ; $78
	tst.b	$bfdd00			; CIAB icr - rücksetzen interrupt timer
	BTST.b	#14-7,$dff01e	; INTREQR - INTEN?
	BEQ.W	NoINTEN
	; Routine inten
NoINTEN:
	BTST.b	#13-7,$dff01e	; INTREQR - EXTER?
	BEQ.W	NoEXTER
	; Routine exter
NoEXTER:
			; 432109876543210
	MOVE.W	#%110000000000000,$DFF09C ; INTREQ - external int + ciab
	rte

*****************************************************************************
;	Wiederholungsroutine protracker/soundtracker/noisetracker
;
	include	"assembler2:sorgenti4/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200	; BPLCON0 - keine bitplanes
	dc.w	$180,$00e	; color0 BLAU
	dc.w	$a007,$fffe	; WAIT - warte auf Zeile $a0
	dc.w	$9c,$8010	; INTREQ - Fordern Sie einen COPER-Interrupt an,
						; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$FFFF,$FFFE	; Ende der copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"assembler2:sorgenti4/mod.fairlight"

	end

Wir haben alle Interrupts neu definiert. Dies kann ein Schema für den
Start sein, um ein "Betriebssystem" zu machen, aber ich empfehle es nicht!

