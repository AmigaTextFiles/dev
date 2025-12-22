
; Listing11d.s - Verwendung von COPER- und VERTB-Interrupt per Level 3 ($6c).

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

	move.w	#$c030,$9a(a5)		; INTENA - aktivieren interrupt "VERTB" 
								; und "COPER" per Level 3 ($6c)

mouse:
	btst	#6,$bfe001			; Maus gedrückt? (Der Prozessor 
	bne.s	mouse				; unterbricht die Schleife zu jedem vertical blank
								; um die Musik zu spielen!
								; sowie jedes WAIT der Rasterzeile $a0).
				
	bsr.w	mt_end				; Ende der Wiederholung!

	rts							; exit

*****************************************************************************
*	INTERRUPTROUTINE  $6c (Level 3) -  VERTB und COPER benutzt.
*****************************************************************************
;	    ______________
;	   ¡¯            ¬\
;	   | ______ _______)
;	  _| /¯ © \ / ø ¬\|_
;	 C,l \____/_\____/|.)
;	 `-|  ___   \ ___ |-'
;	   |  _/  ,  \ \_ |
;	   |_ ` _ ¯--'_ ' ! xCz
;	  _j \  ¯¯¯¯¯¯¬  /
;	/¯    \__ ¯¯¯ __/¯¯¯\
;	        `-----'

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - ist Bit 5, VERTB zurückgesetzt?											
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:
	btst.b	#4,$dff01f			; INTREQR - ist COPER zurückgesetzt?
	beq.s	NointCOPER			; wenn ja, ist es kein COPER int!
	addq.b	#1,Attuale
	cmp.b	#6,Attuale
	bne.s	Vabene
	clr.b	attuale				; mit Null starten
VaBene:
	move.b	Attuale(PC),d0
	cmp.b	#1,d0
	beq.s	Col1
	cmp.b	#2,d0
	beq.s	Col2
	cmp.b	#3,d0
	beq.s	Col3
	cmp.b	#4,d0
	beq.s	Col4
	cmp.b	#5,d0
	beq.s	Col5
Col0:
	move.w	#$300,$dff180		; COLOR0
	bra.s	Colorato
Col1:
	move.w	#$d00,$dff180		; COLOR0
	bra.s	Colorato
Col2:
	move.w	#$f31,$dff180		; COLOR0
	bra.s	Colorato
Col3:
	move.w	#$d00,$dff180		; COLOR0
	bra.s	Colorato
Col4:
	move.w	#$a00,$dff180		; COLOR0
	bra.s	Colorato
Col5:
	move.w	#$500,$dff180		; COLOR0
Colorato:
NointCOPER:
			 ;6543210
	move.w	#%1110000,$dff09c	; INTREQ -  Löschen Flag BLIT,VERTB,COPER
								; da der 680x0 es nicht von selbst löscht!!!
	rte							; Ende vom Interrupt BLIT,VERTB,COPER

Attuale:
	dc.w	0

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
	dc.w	$9c,$8010			; INTREQ - Fordere einen COPER-Interrupt an, 
								; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$a207,$fffe			; WAIT - warte auf Zeile $a2
	dc.w	$9c,$8010			; INTREQ - Fordere einen COPER-Interrupt an, 
								; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$a407,$fffe			; WAIT - warte auf Zeile $a4
	dc.w	$9c,$8010			; INTREQ - Fordere COPER-Interrupt an, 
								; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$a607,$fffe			; WAIT - warte auf Zeile $a6
	dc.w	$9c,$8010			; INTREQ - Fordere COPER-Interrupt an, 
								; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$a807,$fffe			; WAIT - warte auf Zeile $a8
	dc.w	$9c,$8010			; INTREQ - Fordere COPER-Interrupt an, 
								; wodurch color0 mit einem "MOVE.W" geändert wird.
	dc.w	$aa07,$fffe			; WAIT - warte auf Zeile $aa
	dc.w	$9c,$8010			; INTREQ - Fordere COPER-Interrupt an, 
								; wodurch color0 mit einem "MOVE.W" geändert wird.

	dc.w	$FFFF,$FFFE			; Ende copperlist

*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"/Sources/mod.yellowcandy"

	end

In diesem Beispiel sehen wir, wie es möglich ist, den Interrupt an verschiedenen 
Stellen aufzurufen und wie sie durch die Verwendung eines Zählers, mit dem Label 
"Attuale" (current), bei jedem Aufruf jedes Mal eine andere Routine ausführen 
können. Wenn diese Reihenfolge geändert wird, z.B. durch ein entfernen der 
Routine, wird ein "Durchlaufen" der Routinen passieren. 

Versuchen Sie es zum Beispiel diese Änderung:

nointVERTB:
	btst.b	#4,$dff01f			; INTREQR - ist COPER zurückgesetzt?
	beq.s	NointCOPER			; wenn ja, ist es kein COPER int!
	addq.b	#1,Attuale
	cmp.b	#5,Attuale			; ** ÄNDERUNG ** -> 5 und nicht 6 !!!!!!!!!

Auf diese Weise sehen Sie einen Farbfluss. Hier ist es wenig, daher ist der
Effekt ein wenig zu schnell, aber denken Sie an die Nützlichkeit, wenn Sie 
mit jeden Interrupt die gesamte Palette von 32 Farben ändern und noch andere
Dinge machen! Ganz zu schweigen von der Tatsache, dass Sie auch etwas in der 
"Benutzer"-Routine tun können. Hier ist es nur ein langweiliger Zyklus, der 
darauf wartet, dass die Maus gedrückt wird.