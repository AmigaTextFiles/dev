
; Listing11c.s - Verwendung von COPER- und VERTB-Interrupt per Level 3 ($6c).

	Section	Interrupt,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:
	move.l	BaseVBR(PC),a0	    ; in a0 ist der Wert des VBR
	move.l	#MioInt6c,$6c(a0)	; ich lege meinen Interrupt-Level 3 fest

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper								
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; initialisieren der Musik Routine
	movem.l	(SP)+,d0-d7/a0-a6

	move.w	#$c030,$9a(a5)		; INTENA - Interrupt "VERTB" aktivieren 
								; und "COPER" per Level 3 ($6c)

mouse:
	btst	#6,$bfe001			; Maus gedrückt? (Der Prozessor 
	bne.s	mouse				; unterbricht die Schleife zu jedem vertical blank
								; um die Musik zu spielen!).						

	bsr.w	mt_end				; Ende der Wiederholung!

	rts							; exit

*****************************************************************************
*	INTERRUPTROUTINE  $6c (Level 3) -  VERTB und COPER benutzt.
*****************************************************************************

;	,;)))(((;,
;	¦'__  __`¦
;	|,-.  ,-.l
;	( © )( © )
;	¡`-'_)`-'¡
;	|  ___   |
;	l__ ¬  __!
;	 T`----'T xCz
;	 '      `

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - ist Bit 5, VERTB zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:
	btst.b	#4,$dff01f			; INTREQR - ist COPER zurückgesetzt?
	beq.s	NointCOPER			; wenn ja, ist es kein COPER int!
	move.w	#$F00,$dff180		; int COPER, dann COLOR0 = ROT
NointCOPER:
			 ;6543210
	move.w	#%1110000,$dff09c	; INTREQ - Löschen Flag BLIT,VERTB,COPER
								; da der 680x0 es nicht von selbst löscht!!!
	rte							; Ende vom Interrupt BLIT,VERTB,COPER

*****************************************************************************
;	Wiederholungsroutine protracker/soundtracker/noisetracker
;
	include	"/Sources/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$100,$200			; BPLCON0 - keine bitplanes
	dc.w	$180,$00e			; color0 BLAU
	dc.w	$a007,$fffe			; WAIT - warte auf Zeile $a0
	dc.w	$9c,$8010			; INTREQ - Fordern Sie einen COPER-Interrupt an,
								; wodurch das color0 mit einem "MOVE.W" geändert wird.
	dc.w	$FFFF,$FFFE			; Ende der copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"/Sources/mod.yellowcandy"

	end

Dieses Mal haben wir auch den COPPER-Interrupt namens COPER ausgenutzt. Dies
ist nützlich für die Durchführung von Operationen auf einer bestimmten Videozeile.
Tatsächlich können Sie von der Copperlist aus auch auf das INTREQ-Register
($dff09c) zugreifen und in diesem Fall setzen wir nur Bit 4, COPER, zusammen mit
Bit 15 Set/Clr.
In diesem Fall setzen wir nur ein "MOVE.W #$f00,$dff180", das ist nicht viel für
eine Routine, aber bedenken Sie den Nutzen, wenn es viele Dinge zu tun gibt,
und es sich lohnt keine Zeit zu verschwenden, um in einer Schleife den 
vertical blank mit dem Prozessor zu vergleichen.
