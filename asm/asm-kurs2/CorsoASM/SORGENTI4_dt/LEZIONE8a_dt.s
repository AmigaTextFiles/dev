
; Lezione8a.s - Das universelle Startup, um DMA-Kanäle zu studieren

; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper- und Bitplane-DMA aktiviert
;			 -----a-bcdefghij

;	a: Blitter Nasty   (Im Moment ist es uns egal, lassen wir es auf Null)
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA	   (Auch die copperliste wird nicht auf Null zurückgesetzt)
;	d: Blitter DMA	   (Im Moment sind wir nicht interessiert)
;	e: Sprite DMA	   (Nur die 8 Sprites verschwinden)
;	f: Disk DMA		   (Im Moment sind wir nicht interessiert)
;	g-j: Audio 3-0 DMA (Wir setzen den Amiga auf Null zurück)

******************************************************************************
;    680X0 & AGA STARTUP BY FABIO CIUCCI - Komplexitätsgrad 1
******************************************************************************

MAINCODE:
	movem.l	d0-d7/a0-a6,-(SP)	; Speichern Sie die Register auf dem stack
	move.l	4.w,a6				; ExecBase in a6
	LEA	GfxName(PC),A1			; Name der zu öffnenden Bibliothek
	JSR	-$198(A6)				; OldOpenLibrary - öffne die lib
	MOVE.L	d0,GFXBASE			; Speichern Sie die GfxBase in einem label
	BEQ.w	EXIT2				; Wenn ja, beenden Sie das Programm, ohne den Code auszuführen
	LEA	IntuiName(PC),A1		; Intuition.lib
	JSR	-$198(A6)				; Openlib
	MOVE.L	D0,IntuiBase
	BEQ.w	EXIT1				; Wenn Null, raus! Fehler!

	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; version 39 oder größer? (kick3.0+)
	BLT.s	VecchiaIntui
	BSR.w	ResettaSpritesV39
VecchiaIntui:

	MOVE.L	GfxBase(PC),A6
	MOVE.L	$22(A6),WBVIEW		; Speichern Sie das aktuelle System WBView

	SUBA.L	A1,A1				; Nullansicht, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)				; Null LoadView - Videomodus zurückgesetzt
	SUBA.L	A1,A1				; View null
	JSR	-$DE(A6)				; LoadView (zweimal für die Sicherheit...)
	JSR	-$10E(A6)				; WaitOf (Diese beiden Aufrufe von WaitOf)
	JSR	-$10E(A6)				; WaitOf (werden verwendet, um das Interlace zurückzusetzen )
	JSR	-$10E(A6)				; Noch zwei, vah!
	JSR	-$10E(A6)

	MOVEA.L	4.w,A6
	SUBA.L	A1,A1				; NULL task - finde diese Aufgabe
	JSR	-$126(A6)				; findtask (d0=task, FindTask(name) in a1)
	MOVEA.L	D0,A1				; Task in a1
	MOVEQ	#127,D0				; Priorität in d0 (-128, +127) - MAXIMUM!
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0=Priorität, a1=task)

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)				; OwnBlitter, das gibt uns die Exklusivität auf den Blitter
								; Verhinderung seiner Verwendung durch das Betriebssystem.
	jsr	-$E4(A6)				; WaitBlit - Wartet auf das Ende jeder Blittings
	JSR	-$E4(A6)				; WaitBlit

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$84(a6)				; FORBID - Deaktivieren Sie die Multitasking
	JSR	-$78(A6)				; DISABLE - Deaktivieren Sie auch die interrupts
								; des Betriebssystems

	bsr.w	HEAVYINIT			; Jetzt können Sie den Teil ausführen, der 
								; auf Hardware-Registern funktioniert

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$7E(A6)				; ENABLE - System Interrupts ermöglichen
	JSR	-$8A(A6)				; PERMIT - Multitasking ermöglichen

	SUBA.L	A1,A1				; NULL task - finde diese Aufgabe
	JSR	-$126(A6)				; findtask (d0=task, FindTask(name) in a1)
	MOVEA.L	D0,A1				; Task in a1
	MOVEQ	#0,D0				; Priorität in d0 (-128, +127) - NORMAL
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0=Priorität', a1=task)

	MOVE.W	#$8040,$DFF096		; blit ermöglichen
	BTST.b	#6,$dff002			; WaitBlit...
Wblittez:
	BTST.b	#6,$dff002
	BNE.S	Wblittez

	MOVE.L	GFXBASE(PC),A6		; GFXBASE in A6
	jsr	-$E4(A6)				; Erwarten Sie das Ende eines Blittings
	JSR	-$E4(A6)				; WaitBlit
	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem 
								; kann den Blitter jetzt wieder benutzen
	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; V39+?
	BLT.s	Vecchissima
	BSR.w	RimettiSprites
Vecchissima:

	MOVE.L	GFXBASE(PC),A6		; GFXBASE in A6
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeigen Sie auf das alte System copper1
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeigen Sie auf das alte System copper2
	JSR	-$10E(A6)				; WaitOf (Setzt Interlace zurück)
	JSR	-$10E(A6)				; WaitOf
	MOVE.L	WBVIEW(PC),A1		; alter WBVIEW in A1
	JSR	-$DE(A6)				; loadview - lege den alten View zurück
	JSR	-$10E(A6)				; WaitOf (Setzt Interlace zurück)
	JSR	-$10E(A6)				; WaitOf
	MOVE.W	#$11,$DFF10C		; Dies stellt es nicht von selbst wieder her ..!
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeigen Sie auf das alte System copper1
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeigen Sie auf das alte System copper2
	moveq	#100,d7
RipuntLoop:
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeigen Sie auf das alte System copper1
	move.w	d0,$dff088
	dbra	d7,RipuntLoop		; Zur Sicherheit...

	MOVEA.L	IntuiBase(PC),A6
	JSR	-$186(A6)				; _LVORethinkDisplay - Zeichnet alles neu
								; Displays, einschließlich ViewPorts und alle
								; Interlace- oder Multisync-Modus.
	MOVE.L	a6,A1				; IntuiBase in a1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - intuition.library GESCHLOSSEN
Exit1:
	MOVE.L	GfxBase(PC),A1		; GfxBase in a1 um die Bibliothek zu schließen
	jsr	-$19E(a6)				; CloseLibrary - graphics.library GESCHLOSSEN
Exit2:
	movem.l	(SP)+,d0-d7/a0-a6	; Setzen Sie alte Registerwerte fort
	RTS							; Kehren Sie zu ASMONE oder Dos / WorkBench zurück

*******************************************************************************
;	Sprite-Auflösung "legal" zurücksetzen
*******************************************************************************

ResettaSpritesV39:
	LEA	Workbench(PC),A0		; Bildschirmname von Workbench in a0
	MOVE.L	IntuiBase(PC),A6
	JSR	-$1FE(A6)				; _LVOLockPubScreen - Wir "blockieren" den Bildschirm
								; (dessen Name in a0 steht).
	MOVE.L	D0,SchermoWBLocckato
	BEQ.s	ErroreSchermo
	MOVE.L	D0,A0				; Struktur Screen in a0
	MOVE.L	$30(A0),A0			; sc_ViewPort + vp_ColorMap: in a0 haben wir jetzt
								; die ColorMap-Struktur des Bildschirms, die es gibt
								; dient (in a0) zur Durchführung einer "video_control"
								; von graphics.library.
	LEA	GETVidCtrlTags(PC),A1	; In a1 die TagList für die Routine
								; "Video_control" - die Anforderung, dass
								; Lassen Sie uns diese Routine zu tun ist
								; VTAG_SPRITERESN_GET oder zu wissen
								; die aktuelle Sprite-Auflösung.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)	; Video_Control (in a0 die cm und in a1 die tags)
					; Berichte in der Tagliste, in der langen
					; "resolution", die aktuelle Auflösung des
					; Sprite in diesem Bildschirm.

; Lassen Sie uns nun die VideoControl-Routine bitten, die Auflösung einzustellen.
; SPRITERESN_140NS -> dh lowres!

	MOVE.L	SchermoWBLocckato(PC),A0
	MOVE.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList, die Sprites zurücksetzt.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; video_control... Setzen Sie die sprites zurück!

; Jetzt setzen wir auch den möglichen "Vordergrund" -Bildschirm zurück, zum Beispiel den
; Assembler-Bildschirm:

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0			; Ib_FirstScreen (Großaufnahme!")
	MOVE.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	GETVidCtrlTags2(PC),A1	; In a1 die TagList GET
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; Video_Control (in a0 die cm und in a1 die tags)

	MOVEA.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0			; Ib_FirstScreen -"angeln" den Bildschirm ein
								; Vordergrund (zB ASMONE)
	MOVEA.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList Das setzt die Sprites zurück.
	MOVEA.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; video_control... Sprites zurücksetzen!

	MOVEA.L	SchermoWBLocckato(PC),A0
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$17A(A6)				; _LVOMakeScreen - müssen den Bildschirm wiederholen
	move.l	$3c(a6),a0			; Ib_FirstScreen - "angeln" den Bildschirm ein
								; Vordergrund (zB ASMONE)
	JSR	-$17A(A6)				; _LVOMakeScreen - müssen den Bildschirm wiederholen
			; um sicher zu gehen, dass das zurückgesetzt wurde, ist es notwendig
			; Rufen Sie MakeScreen auf, gefolgt von...
	JSR	-$186(A6)	; _LVORethinkDisplay - was das ganze neu gestaltet
					; Displays, einschließlich ViewPorts und alle
ErroreSchermo:		; Interlace- oder Multisync-Modus.
	RTS

; Jetzt müssen wir die Sprites auf die Startauflösung zurücksetzen.

RimettiSprites:
	MOVE.L	SchermoWBLocckato(PC),D0	; Adresse Struktur Screen
	BEQ.S	NonAvevaFunzionato			; Se = 0, dann sünde...
	MOVE.L	D0,A0
	MOVE.L	OldRisoluzione(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0					; Struktur ColorMap des Bildschirms
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; _LVOVideoControl - Auflösung auflösen

; Bildschirmzeit im Vordergrund (falls vorhanden)...

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0	; Ib_FirstScreen - "angeln" den Bildschirm ein
						; Vordergrund (zB ASMONE)
	MOVE.L	OldRisoluzioneP(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen.
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0	; Struktur ColorMap des Bildschirms
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)		; _LVOVideoControl - Auflösung auflösen

	MOVEA.L	SchermoWBLocckato(PC),A0
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$17A(A6)		; RethinkDisplay - wir "überdenken" die Anzeige
	move.l	$3c(a6),a0	; Ib_FirstScreen - Bildschirm im Vordergrund
	JSR	-$17A(A6)		; RethinkDisplay - wir "überdenken" die Anzeige
	MOVE.L	SchermoWBLocckato(PC),A1
	SUB.L	A0,A0		; null
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$204(A6)		; _LVOUnlockPubScreen - und "entsperren"
NonAvevaFunzionato:		; screen Workbench.
	RTS

SchermoWBLocckato:
	dc.l	0

; Dies ist die Struktur zur Verwendung von Video_Control. Das erste lange ist für
; ÄNDERN (SETZEN) Sie die Auflösung von Sprites oder Sie möchten die alte 
; Auflösung kennen (GET).

GETVidCtrlTags:
	dc.l	$80000032	; GET
OldRisoluzione:
	dc.l	0	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden der TagList)

GETVidCtrlTags2:
	dc.l	$80000032	; GET
OldRisoluzioneP:
	dc.l	0	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden der TagList)

SETVidCtrlTags:
	dc.l	$80000031	; SET
	dc.l	1	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden der TagList)

SETOldVidCtrlTags:
	dc.l	$80000031	; SET
OldRisoluzione2:
	dc.l	0	; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0	; 3 Nullen für TAG_DONE (Beenden der TagList)

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
	OR.L	d0,OLDDMA		    ; Bit 15 aller gespeicherten Werte setzen
	OR.L	d0,OLDADKCON		; von Hardware-Registern, unverzichtbar für
								; setze diese Werte zurück in die Register.

	MOVE.L	#$7FFF7FFF,$9A(a5)	; DEAKTIVIEREN INTERRUPTS & INTREQS
	MOVE.L	#0,$144(A5)			; SPR0DAT - töte den Zeiger!
	MOVE.W	#$7FFF,$96(a5)		; DEAKTIVIEREN DMA

	bsr.s	START				; Führen Sie das Programm aus.

	LEA	$dff000,a5				; Basis von CUSTOM-Registern für Offsets
	MOVE.W	#$7FFF,$96(A5)		; DEAKTIVIEREN Alles DMA
	MOVE.L	#$7FFF7FFF,$9A(A5)	; DEAKTIVIEREN INTERRUPTS & INTREQS
	MOVE.W	#$7fff,$9E(a5)		; Deaktivieren Sie die Bits von ADKCON
	MOVE.W	OLDADKCON(PC),$9E(A5)	; ADKCON 
	MOVE.W	OLDDMA(PC),$96(A5)	; Setzen Sie den alten DMA-Status zurück
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ
	RTS

;	Beim Start gespeicherte Daten

WBVIEW:			; WorkBench View-Adresse
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

START:
;	 WIR PLATZIEREN UNSER BITPLANE

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane und copper

	move.l	#COPPERLIST,$80(a5)	; Wir zielen auf unsere COP
	move.w	d0,$88(a5)			; Beginnen wir mit dem COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

mouse:
	btst	#6,$bfe001
	bne.s	mouse
	rts


	Section	CopProva,data_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
		    ; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste bitplane

	dc.w	$0180,$000	; color0 - HINTERGRUND
	dc.w	$0182,$19a	; color1 - SCRITTE

;	Gradient copperlist

	dc.w	$5007,$fffe	; WAIT Zeile $50
	dc.w	$180,$001	; color0
	dc.w	$5207,$fffe	; WAIT Zeile $52
	dc.w	$180,$002	; color0
	dc.w	$5407,$fffe	; WAIT Zeile $54
	dc.w	$180,$003	; color0
	dc.w	$5607,$fffe	; WAIT Zeile $56
	dc.w	$180,$004	; color0
	dc.w	$5807,$fffe	; WAIT Zeile $58
	dc.w	$180,$005	; color0
	dc.w	$5a07,$fffe	; WAIT Zeile $5a
	dc.w	$180,$006	; color0
	dc.w	$5c07,$fffe	; WAIT Zeile $5c
	dc.w	$180,$007	; color0
	dc.w	$5e07,$fffe	; WAIT Zeile $5e
	dc.w	$180,$008	; color0
	dc.w	$6007,$fffe	; WAIT Zeile $60
	dc.w	$180,$009	; color0
	dc.w	$6207,$fffe	; WAIT Zeile $62
	dc.w	$180,$00a	; color0

	dc.w	$FFFF,$FFFE	; Ende copperlist

;	Mit dem Befehl dcb erstellen wir eine zufällige Zeichnung für die Bitebene

BITPLANE:
	dcb.l	10240/4,$FF00FF00

	end

Es gibt zwei Details, die in der Lektion nicht enthalten sind: Das erste ist, 
dass es eine Routine gibt, die den Sprite-Videomodus zurücksetzt, falls die
Version 3.0 oder höher ist.
Das zweite Detail ist, dass eine Anweisung hinzugefügt wurde,
um die AGA zu deaktivieren:

	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

In Wirklichkeit ist diese Anweisung meist überflüssig, weil es so gut wie nie
vorhanden ist, aber auch hier sollte die Sicherheit nicht übersehen werden.

Schalten Sie die Bitmap- und Copper-DMA-Kanäle nacheinander aus.
Sie werden feststellen, dass die Zeichnung verschwindet, wenn der Bitplane-Kanal 
ausgeschaltet wird. Wenn Sie das Copper deaktivieren, wird auch die Nuance ausgeblendet.
Versuchen Sie auch, Bit 9, den allgemeinen Schalter, auszuschalten, und Sie werden sehen
dass, auch wenn die anderen Bits aktiviert sind, alles ausgeschaltet wird.
Es ist unnötig zu versuchen, Bit 15 zurückzusetzen!

