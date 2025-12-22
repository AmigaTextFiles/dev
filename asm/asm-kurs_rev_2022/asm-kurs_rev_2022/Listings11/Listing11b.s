
; Listing11b.s - Erste Verwendung des neuen startup2.s und eines Interrupts.

	Section	PrimoInterrupt,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; Speichern Sie Interrupt, DMA und so weiter.
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

	move.w	#$c020,$9a(a5)		; INTENA - "VERTB"-Interrupt aktivieren per
								; Level 3 ($6c), was einmal pro Frame
								; (an der Zeile $00) generiert wird.		
	;move.w	#$4000,$9a(a5)		; Test des Bit 14  Master Enable - deaktiviert alle Interrupts			
	;move.w #$c000,$9a(a5)		; Interrupts wieder einschalten	

mouse:
	btst	#6,$bfe001			; Maus gedrückt? (Der Prozessor 
	bne.s	mouse				; unterbricht die Schleife zu jedem vertical blank
								; um die Musik zu spielen!).						 

	bsr.w	mt_end				; Ende der Wiederholung!

	rts							; exit

*****************************************************************************
*	INTERRUPT-ROUTINE  $6c (Level 3) - es wird nur der VERTB benutzt
*****************************************************************************
;	     ..,..,.,
;	   /~""~""~""~\
;	  /_____ ¸_____)
;	 _) ¬(_° \°_)¬\
;	( __   (__)    \
;	 \ \___ _____, /
;	  \__  Y  ____/xCz
;	    `-----'

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - ist Bit 5, VERTB zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:	; 6543210
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
	dc.w	$FFFF,$FFFE			; Ende copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"/Sources/mod.yellowcandy"

	end

Wenn wir den VERTB-Interrupt von Level 3 ($6c) in diesem Listing nicht gesetzt
haben, würde es in einer einzigen Schleife enden:

mouse:
	btst	#6,$bfe001			; Maus gedrückt? (Der Prozessor 
	bne.s	mouse				; unterbricht die Schleife zu jedem vertical blank
								; um die Musik zu spielen!).	

Stattdessen arbeitet der Prozessor im "Multitasking" und unterbricht jedes Mal
die Schleife, wenn der Elektronenstrahl die Zeile $00 erreicht und führt die
Routine MT_MUSIC aus und kehrt zurück um die einfache Schleife auszuführen.
Anstelle dieser abscheulichen Maus-Warteschleife hätten wir auch eine Routine
zur Berechnung eines Fraktals, die mehrere Sekunden dauern kann, während die
Musik "zeitgemäß" synchronisiert spielen würde, einsetzen können ohne die
Berechnung des Fraktals zu stören. Es verlangsamt nur das Wenige, was es zum
Abspielen der Musik in jedem Frame braucht.
  
Beachten Sie die 2 EQUATES am Anfang des Programms, eine zum Einschalten der
DMAs, was wir schon wissen, und das neue:

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

Das "wartet" ein wenig, bevor es die Kontrolle über die Hardware übernimmt. Für
eine Berechnung der zu wartenden Zeit wird 50 als 1 Sekunde angenommen da wir
das Vblank nutzen. Also 150 sind 3 Sekunden. Wenn Ihr Programm jedoch eine
ziemlich große und komprimierte Datei ist, um es zu entpacken, braucht es eine
oder zwei Sekunden. Ansonsten können Sie es auch auf einem niedrigen Wert
belassen. 
Wenn Sie stattdessen die unkomprimierte Datei gespeichert haben, und wenn Sie
von der Diskette gestartet haben, würde die Ausführung beginnen bevor das Lesen
vom Laufwerk beendet wurde und ein von 5 Mal kommt es vor, das am Ende das DOS
im totalen Koma ist. Um dies zu vermeiden, berechnen Sie immer den Zeitverlust
mit der "waitdisk" - Schleife beim Auspacken und das Programm startet nach 
mindestens 3 Sekunden nach dem Ende des Uploads.