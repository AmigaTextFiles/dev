******************************************************************************
;    680X0 & AGA STARTUP BY FABIO CIUCCI - Komplexität 1
******************************************************************************

MAINCODE:
	movem.l	d0-d7/a0-a6,-(SP)	; Speichern Sie die Register auf dem Stack
	move.l	4.w,a6				; ExecBase in a6
	LEA	GfxName(PC),A1			; Name der zu öffnenden Bibliothek
	JSR	-$198(A6)				; OldOpenLibrary - öffne die lib
	MOVE.L	d0,GFXBASE			; Speichern Sie die GfxBase in einem Label
	BEQ.w	EXIT2				; Wenn ja, beenden Sie das Programm, ohne den Code auszuführen
	LEA	IntuiName(PC),A1		; Intuition.lib
	JSR	-$198(A6)				; Openlib
	MOVE.L	D0,IntuiBase
	BEQ.w	EXIT1				; Wenn Null, raus! Fehler!

	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; Version 39 oder höher? (kick3.0+)
	BLT.s	VecchiaIntui
	BSR.w	ResettaSpritesV39
VecchiaIntui:

	MOVE.L	GfxBase(PC),A6
	MOVE.L	$22(A6),WBVIEW		; Speichern Sie das aktuelle System WBView

	SUB.L	A1,A1				; Nullansicht, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)	; LoadView null - Videomodus zurückgesetzt
	SUB.L	A1,A1	; View null
	JSR	-$DE(A6)	; LoadView (zweimal für die Sicherheit...)
	JSR	-$10E(A6)	; WaitOf ( Diese beiden Anrufe nach WaitOf    )
	JSR	-$10E(A6)	; WaitOf ( Sie werden verwendet, um das Interlace zurückzusetzen )
	JSR	-$10E(A6)	; Noch zwei, vah!
	JSR	-$10E(A6)

	move.L	4.w,A6
	SUBA.L	A1,A1	; NULL task - finde diese Aufgabe
	JSR	-$126(A6)	; findtask (d0=task, FindTask(name) in a1)
	move.L	D0,A1	; Task in a1
	MOVEQ	#127,D0	; Priorität ' in d0 (-128, +127) - MAXIMUM!
	JSR	-$12C(A6)	;_LVOSetTaskPri (d0=Priorität, a1=task)

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)	; OwnBlitter, das gibt uns die exklusivität auf den blitter
					; Verhinderung seiner Verwendung durch das Betriebssystem.
	jsr	-$E4(A6)	; WaitBlit - Wartet auf das Ende jeder Blittata
	JSR	-$E4(A6)	; WaitBlit

	move.l	4.w,a6	; ExecBase in A6
	JSR	-$84(a6)	; FORBID - Deaktivieren Sie das Multitasking
	JSR	-$78(A6)	; DISABLE - Deaktivieren Sie auch die Interrupts
					; des Betriebssystems

	bsr.w	HEAVYINIT	; Jetzt können Sie den Teil ausführen, der 
						; auf Hardware-Registern funktioniert

	move.l	4.w,a6	; ExecBase in A6
	JSR	-$7E(A6)	; ENABLE - ermöglichen System Interrupts
	JSR	-$8A(A6)	; PERMIT - ermöglichen multitasking

	SUBA.L	A1,A1	; NULL task - finde diese Aufgabe
	JSR	-$126(A6)	; findtask (d0=task, FindTask(name) in a1)
	move.L	D0,A1	; Task in a1
	MOVEQ	#0,D0	; Priorität' in d0 (-128, +127) - NORMAL
	JSR	-$12C(A6)	;_LVOSetTaskPri (d0=Priorität, a1=task)

	MOVE.L	GFXBASE(PC),A6	; GFXBASE in A6
	jsr	-$E4(A6)	; Erwarten Sie das Ende einer blittate
	JSR	-$E4(A6)	; WaitBlit
	jsr	-$1ce(a6)	; DisOwnBlitter, das Betriebssystem jetzt
					; kann den Blitter wieder benutzen
	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)	; V39+?
	BLT.s	Vecchissima
	BSR.w	RimettiSprites
Vecchissima:

	MOVE.L	GFXBASE(PC),A6	; GFXBASE in A6
	MOVE.L	WBVIEW(PC),A1	; alt WBVIEW in A1
	JSR	-$DE(A6)			; loadview - lege den alten View zurück
	JSR	-$10E(A6)			; WaitOf ( Setzen Sie alle zurück interlace)
	JSR	-$10E(A6)			; WaitOf
	MOVE.W	#$11,$DFF10C	; Dies stellt es nicht von selbst wieder her..!
	MOVE.L	$26(a6),$dff080	; COP1LC - Zeigen Sie auf das alte System copper1
	MOVE.L	$32(a6),$dff084	; COP2LC - Zeigen Sie auf das alte System copper2

	move.L	IntuiBase(PC),A6
	JSR	-$186(A6)		; _LVORethinkDisplay - Zeichnet alles neu
						; Displays, einschließlich ViewPorts und alle
						; Interlace- oder Multisync-Modus.
	MOVE.L	a6,A1		; IntuiBase in a1 um die Bibliothek zu schließen
	move.l	4.w,a6		; ExecBase in A6
	jsr	-$19E(a6)		; CloseLibrary - intuition.library GESCHLOSSEN
Exit1:
	MOVE.L	GfxBase(PC),A1	; GfxBase in a1 um die Bibliothek zu schließen
	jsr	-$19E(a6)			; CloseLibrary - graphics.library GESCHLOSSEN
Exit2:
	movem.l	(SP)+,d0-d7/a0-a6 ; stellen Sie die alten Registerwerte wieder her
	RTS						 ; Zurück zu ASMONE oder Dos/WorkBench

*******************************************************************************
;	Sprite-Auflösung "legal" zurücksetzen
*******************************************************************************

ResettaSpritesV39:
	MOVE.L	IntuiBase(PC),A6
	LEA	Workbench(PC),A0 ; Workbench-Bildschirmname (für Sperre) in a0
	JSR	-$1FE(A6)		; _LVOLockPubScreen - Wir "blockieren" den Bildschirm
						; (dessen Name in a0 steht).
	MOVE.L	D0,SchermoWBLocckato
	BEQ.s	ErroreSchermo
	MOVE.L	D0,A0		; Struttura Screen in a0
	MOVE.L	$30(A0),A0	; sc_ViewPort + vp_ColorMap: in a0 haben wir jetzt
						; die ColorMap-Struktur des Bildschirms, die es gibt
						; dient (in a0) zur Durchführung einer "video_control"
						; von graphics.library.
	LEA	GETVidCtrlTags(PC),A1	; In a1 die TagList für die Routine
						; "Video_control" - die Anforderung, dass
						; Lassen Sie uns diese Routine zu tun ist
						; VTAG_SPRITERESN_GET oder zu wissen
						; die aktuelle Sprite-Auflösung.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)		; Video_Control (in a0 die cm und in a1 die tags)
						; Berichte in der Tagliste, in der langen
						; "resolution", die aktuelle Auflösung des
						; Sprite in diesem Bildschirm.

; Jetzt speichern wir die Auflösung auch für den eventuellen "Vordergrund" -Bildschirm.
; Zum Beispiel der Assembler-Bildschirm:

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0	; Ib_FirstScreen ("Featured!" - Bildschirm)
	MOVE.L	$30(A0),A0	; Struktur sc_ViewPort + vp_ColorMap in a0
	LEA	GETVidCtrlTags2(PC),A1	; In a1 die TagList GET
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)		; Video_Control (in a0 die cm und in a1 die tags)

; Ora chiediamo alla routine VideoControl di settare la risoluzione.
; SPRITERESN_140NS -> ossia lowres!

	MOVE.L	SchermoWBLocckato(PC),A0
	MOVE.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList Das setzt die Sprites zurück.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; video_control... Sprites zurücksetzen!

	move.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0	; Ib_FirstScreen - "Fischen" Sie den Bildschirm in
						; Vordergrund (zB ASMONE)
	move.L	$30(A0),A0	; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList Das setzt die Sprites zurück.
	move.L	GfxBase(PC),A6
	JSR	-$2C4(A6)		; video_control... Sprites zurücksetzen!

	move.L	SchermoWBLocckato(PC),A0
	move.L	IntuiBase(PC),A6
	JSR	-$17A(A6)		; _LVOMakeScreen - müssen den Bildschirm wiederholen
	move.l	$3c(a6),a0	; Ib_FirstScreen -"angeln" den Bildschirm ein
						; Vordergrund (zB ASMONE)
	JSR	-$17A(A6)		; _LVOMakeScreen - müssen den Bildschirm wiederholen
						; um sicher zu gehen, dass das zurückgesetzt wurde, ist es notwendig
						; MakeScreen aufrufen, gefolgt von ...
	JSR	-$186(A6)		; _LVORethinkDisplay -was das ganze neu gestaltet
						; Displays, einschließlich ViewPorts und alle
ErroreSchermo:			; Interlace- oder Multisync-Modus.
	RTS

; Jetzt müssen wir die Sprites auf die Startauflösung zurücksetzen.

RimettiSprites:
	MOVE.L	SchermoWBLocckato(PC),D0	; Adresse Struktur Screen
	BEQ.S	NonAvevaFunzionato			; Wenn = 0, dann ...
	MOVE.L	D0,A0
	MOVE.L	OldRisoluzione(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen.
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0					; Struktur ColorMap des screen
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)		; _LVOVideoControl - Auflösung auflösen

; Bildschirmzeit im Vordergrund (falls vorhanden)...

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0	; Ib_FirstScreen - "angeln" den Bildschirm ein
						; Vordergrund (zB ASMONE)
	MOVE.L	OldRisoluzioneP(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0	; Struktur ColorMap des screen
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)		; _LVOVideoControl - Auflösung auflösen

	move.L	IntuiBase(PC),A6
	move.L	SchermoWBLocckato(PC),A0
	JSR	-$17A(A6)		; RethinkDisplay - wir "überdenken" die Anzeige
	move.l	$3c(a6),a0	; Ib_FirstScreen - Bildschirm im Vordergrund
	JSR	-$17A(A6)		; RethinkDisplay - wir "überdenken" die Anzeige
	MOVE.L	SchermoWBLocckato(PC),A1
	SUB.L	A0,A0		; null
	move.L	IntuiBase(PC),A6
	JSR	-$204(A6)		; _LVOUnlockPubScreen - und "entsperren"
NonAvevaFunzionato:		; Workbench-Bildschirm.
	RTS

SchermoWBLocckato:
	dc.l	0

; Dies ist die Struktur zur Verwendung von Video_Control. Das erste lange ist für
; ÄNDERN (SETZEN) Sie die Auflösung von Sprites oder Sie möchten die alte Auflösung kennen (GET).

GETVidCtrlTags:
	dc.l	$80000032	; GET
OldRisoluzione:
	dc.l	0	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden Sie die TagList)

GETVidCtrlTags2:
	dc.l	$80000032	; GET
OldRisoluzioneP:
	dc.l	0	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden Sie die TagList)

SETVidCtrlTags:
	dc.l	$80000031	; SET
	dc.l	1	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden Sie die TagList)

SETOldVidCtrlTags:
	dc.l	$80000031	; SET
OldRisoluzione2:
	dc.l	0	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden Sie die TagList)

; WorkBench-Bildschirmname

Workbench:
	dc.b	'Workbench',0

******************************************************************************
;	Ab hier können Sie direkt an der Hardware arbeiten
******************************************************************************

HEAVYINIT:
	LEA	$DFF000,A5				; Basis von CUSTOM-Registern für Offsets
	MOVE.W	$2(A5),OLDDMA		; Speichern Sie den alten Status von DMACON
	MOVE.W	$1C(A5),OLDINTENA	; Speichern Sie den alten Status von INTENA
	MOVE.W	$10(A5),OLDADKCON	; Speichern Sie den alten Status von ADKCON
	MOVE.W	$1E(A5),OLDINTREQ	; Speichern Sie den alten Status von INTREQ
	MOVE.L	#$80008000,d0		; Bereiten Sie die High-Bit-Maske vor
								; in die Worte setzen, wo sie sind
								; Register wurden gespeichert
	OR.L	d0,OLDDMA			; Bit 15 aller gespeicherten Werte setzen
	OR.L	d0,OLDADKCON		; von Hardware-Registern, unverzichtbar für
								; setze diese Werte zurück in die Register.

	MOVE.L	#$7FFF7FFF,$9A(a5)	; DEAKTIVIERE INTERRUPTS & INTREQS
	MOVE.L	#0,$144(A5)			; SPR0DAT - Nullzeiger!
	MOVE.W	#$7FFF,$96(a5)		; DEAKTIVIERE DMA
	MOVE.L	#0,$144(A5)

	bsr.w	START				; Führen Sie das Programm aus.

	LEA	$dff000,a5				; Custom base für offsets
	MOVE.W	#$8240,$96(a5)		; dmacon - aktivieren blit
	BTST.b	#6,2(a5)			; WaitBlit via hardware...
Wblittez:
	BTST.b	#6,2(a5)
	BNE.S	Wblittez

	MOVE.W	#$7FFF,$96(A5)		; DEAKTIVIEREN ALLE DMA
	MOVE.L	#$7FFF7FFF,$9A(A5)	; DEAKTIVIEREN DER INTERRUPTS & INTREQS
	MOVE.W	#$7fff,$9E(a5)		; Deaktivieren Sie die Bits von ADKCON
	MOVE.W	OLDADKCON(PC),$9E(A5)	; ADKCON
	MOVE.W	OLDDMA(PC),$96(A5)	; Setzen Sie den alten Status zurück DMA
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ
	RTS

;	Beim Start gespeicherte Daten

WBVIEW:			; Adresse der Ansicht von WorkBench
	DC.L	0
GfxName:
	dc.b	'graphics.library',0,0
IntuiName:
	dc.b	'intuition.library',0

GfxBase:		; Zeiger auf die Basis der Graphics Library
	dc.l	0
IntuiBase:		; Zeiger auf die Basis der Intuition Library
	dc.l	0
OLDDMA:			; alter status DMACON
	dc.w	0
OLDINTENA:		; alter status INTENA
	dc.w	0
OLDADKCON:		; alter status ADKCON
	DC.W	0
OLDINTREQ:		; alter status INTREQ
	DC.W	0

