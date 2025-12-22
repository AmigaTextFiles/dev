
; Listing14-10d.s	Verwendung der Routine player6.1a für ein komprimiertes Modul

; VERSION CIA! Die Routine P61_Music sollte niemals aufgerufen werden!

	SECTION	Usoplay61a,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA		 

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
;­ Call P61_Init to initialize the playroutine	­
;­ D0 --> Timer detection (for CIA-version)	­
;­ A0 --> Address to the module			­
;­ A1 --> Address to samples/0			­
;­ A2 --> Address to sample buffer		­
;­ D0 <-- 0 if succeeded			­
;­ A6 <-- $DFF000				­
;­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­

	movem.l	d0-d7/a0-a6,-(SP)
	moveq	#0,d0				; Timer Detection: Autodetect
;	moveq	#1,d0				; Timer Detection: PAL
;	moveq	#2,d0				; Timer Detection: NTSC
	lea	P61_data,a0				; Adresse des Moduls in a0
	lea	$dff000,a6				; wir merken uns $dff000 in a6!
	sub.l	a1,a1				; die samples sind nicht getrennt, wir setzen Null
	lea	samples,a2				; Modul komprimiert! Zeiger auf Zielpuffer für
								; die samples (in chip ram) !
	bsr.w	P61_Init			; Hinweis: das Dekomprimieren dauert einige Sekunden!
	movem.l	(SP)+,d0-d7/a0-a6

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - nur copper aktivieren
								; + bitplane und sprites (%1000001111000000)

	move.w	#$e000,$9a(a5)		; INTENA - aktivieren Master und lev6
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$08000,d2			; warte auf Zeile $80
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

; version CIA, Sie müssen nicht P61_music... aufrufen

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse


	lea	$dff000,a6				; wir merken uns $dff000 in a6!
	bsr.w	P61_End

	rts


*****************************************************************************
*		 The Player 6.1A for Asm-One 1.09 and later 						*
*****************************************************************************

fade  = 0	; 0 = Normal, NO master volume control possible
			; 1 = Use master volume (P61_Master)

jump = 0	; 0 = do NOT include position jump code (P61_SetPosition)
			; 1 = Include

system = 0	; 0 = killer
			; 1 = friendly

CIA = 1		; 0 = CIA disabled
			; 1 = CIA enabled

exec = 1	; 0 = ExecBase destroyed
			; 1 = ExecBase valid

opt020 = 0	; 0 = MC680x0 code
			; 1 = MC68020+ or better

use = $b55a	; Usecode (Setze den von p61con angegebenen Wert zum Speichern
			; für jedes Modul unterschiedlich!)

*****************************************************************************
	include	"/Sources/play.s"	; die wahre Routine!
*****************************************************************************


*****************************************************************************
;	Copperlist
*****************************************************************************

	SECTION	COP,DATA_C

COPPERLIST:
	dc.w	$100,$200			; bplcon0 - keine bitplanes
	DC.W	$180,$003			; color0 schwarz
	dc.W	$FFFF,$FFFE			; Ende copperlist

*****************************************************************************
;	Musikmodul in Format P61 konvertiert, KOMPRIMIERT! (Option pack!)
*****************************************************************************

	Section	modulozzo,data		; Es muss nicht im Chip-RAM sein, weil es ist
								; komprimiert ist und woanders entpackt wird!

; Modul von Jester/Sanity. Original 153676, gepackt 71950

P61_data:
	incbin	"/Sources/P61.stardust"	; komprimiert, (Option PACK SAMPLES)
				; Sie können es auch in den FAST RAM legen: es wird verwendet
				; zum Entpacken der Samples in den Puffer Samples
				; und wird nicht direkt "gespielt".
				; Es geht also nicht direkt über die Audio DMA-Kanäle
				; sondern nur über die Depack-Routine durch den Prozessor.
				; Also nur DATEN (nicht _C!)


*****************************************************************************
;	Wo die Samples entpackt werden (section bss in chip ram!)
*****************************************************************************

	section	smp,bss_c

samples:
	ds.b	132112				; Länge gemeldet von p61con

	end

Verwendung der CIA-Versionsroutine mit einem komprimierten Modul... nur aus
Liebe einige Beispiele.

