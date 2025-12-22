
; Listing8a.s - Das universelle Startup, um DMA-Kanäle zu studieren

; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen
; werden sollen

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
	movem.l	d0-d7/a0-a6,-(SP)	; speichern der Register auf dem stack
	move.l	4.w,a6				; ExecBase in a6
	LEA	GfxName(PC),A1			; Name der zu öffnenden Bibliothek
	JSR	-$198(A6)				; OldOpenLibrary - öffne die Bibliothek
	MOVE.L	d0,GFXBASE			; speichern der GfxBase in einem Label
	BEQ.w	EXIT2				; wenn ja, beenden wir das Programm, ohne den
								; Code auszuführen
	LEA	IntuiName(PC),A1		; Intuition.lib
	JSR	-$198(A6)				; Openlib
	MOVE.L	D0,IntuiBase
	BEQ.w	EXIT1				; Wenn Null, geh raus! Fehler!

	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; Version 39 oder größer? (kick3.0+)
	BLT.s	VecchiaIntui		; alte Intui
	BSR.w	ResettaSpritesV39
VecchiaIntui:

	MOVE.L	GfxBase(PC),A6
	MOVE.L	$22(A6),WBVIEW		; speichern des aktuellen System WBView

	SUBA.L	A1,A1				; View null, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)				; LoadView Null - Videomodus zurücksetzen
	SUBA.L	A1,A1				; View null
	JSR	-$DE(A6)				; LoadView (zweimal zur Sicherheit...)
	JSR	-$10E(A6)				; WaitOf (Diese beiden Aufrufe von WaitOf)
	JSR	-$10E(A6)				; WaitOf (werden verwendet, um das Interlace
	JSR	-$10E(A6)				; zurückzusetzen) Noch zwei, vah!
	JSR	-$10E(A6)

	MOVEA.L	4.w,A6
	SUBA.L	A1,A1				; NULL task - finde den Task
	JSR	-$126(A6)				; findtask (d0=task, FindTask(name) in a1)
	MOVEA.L	D0,A1				; Task in a1
	MOVEQ	#127,D0				; Priorität in d0 (-128, +127) - MAXIMUM!
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0=Priorität, a1=task)

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)				; OwnBlitter, gibt uns den exklusiven Zugang auf den Blitter
								; verhindert, dass er vom Betriebssystem verwendet wird.
	jsr	-$E4(A6)				; WaitBlit - warten auf das Ende eines Blitts
	JSR	-$E4(A6)				; WaitBlit

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$84(a6)				; FORBID -  Multitasking deaktivieren
	JSR	-$78(A6)				; DISABLE - deaktiviert auch die Interrupts
								; des Betriebssystems

	bsr.w	HEAVYINIT			; Jetzt können Sie den Teil ausführen, der 
								; auf den Hardware-Registern arbeitet

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$7E(A6)				; ENABLE - ermöglicht System Interrupts
	JSR	-$8A(A6)				; PERMIT - ermöglicht Multitasking

	SUBA.L	A1,A1				; NULL task - finde den Task
	JSR	-$126(A6)				; findtask (d0=task, FindTask(name) in a1)
	MOVEA.L	D0,A1				; Task in a1
	MOVEQ	#0,D0				; Priorität in d0 (-128, +127) - NORMAL
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0=Priorität', a1=task)

	MOVE.W	#$8040,$DFF096		; blitt ermöglichen
	BTST.b	#6,$dff002			; WaitBlit...
Wblittez:
	BTST.b	#6,$dff002
	BNE.S	Wblittez

	MOVE.L	GFXBASE(PC),A6		; GFXBASE in A6
	jsr	-$E4(A6)				; WaitBlit - warten auf das Ende eines Blitts
	JSR	-$E4(A6)				; WaitBlit
	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem 
								; kann den Blitter jetzt wieder verwenden
	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; V39+?
	BLT.s	Vecchissima
	BSR.w	RimettiSprites
Vecchissima:

	MOVE.L	GFXBASE(PC),A6		; GFXBASE in A6
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte System "Copper1"
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeiger auf das alte System "Copper2"
	JSR	-$10E(A6)				; WaitOf (setzt Interlace zurück)
	JSR	-$10E(A6)				; WaitOf
	MOVE.L	WBVIEW(PC),A1		; alten WBVIEW in A1
	JSR	-$DE(A6)				; loadview - den alten View zurücksetzen
	JSR	-$10E(A6)				; WaitOf (setzt Interlace zurück)
	JSR	-$10E(A6)				; WaitOf
	MOVE.W	#$11,$DFF10C		; Dies stellt es nicht von selbst wieder her ..!
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte System "Copper1"
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeiger auf das alte System "Copper2"
	moveq	#100,d7
RipuntLoop:
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte System "Copper1"
	move.w	d0,$dff088
	dbra	d7,RipuntLoop		; zur Sicherheit...

	MOVEA.L	IntuiBase(PC),A6
	JSR	-$186(A6)				; _LVORethinkDisplay - zeichnet alles neu
								; Displays, einschließlich ViewPorts und alle
								; Interlace- oder Multisync-Modi.
	MOVE.L	a6,A1				; IntuiBase in a1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - intuition.library GESCHLOSSEN
Exit1:
	MOVE.L	GfxBase(PC),A1		; GfxBase in a1 um die Bibliothek zu schließen
	jsr	-$19E(a6)				; CloseLibrary - graphics.library GESCHLOSSEN
Exit2:
	movem.l	(SP)+,d0-d7/a0-a6	; die alten Registerwerte wiederherstellen
	RTS							; zu ASMONE oder Dos / WorkBench zurückkehren

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
								; die ColorMap-Struktur des Bildschirms, die dient
								; (in a0) zur Durchführung einer "video_control"
								; von graphics.library.
	LEA	GETVidCtrlTags(PC),A1	; In a1 die TagList für die Routine
								; "Video_control" - die Anforderung, dass
								; Lassen Sie uns diese Routine zu tun ist
								; VTAG_SPRITERESN_GET oder zu wissen
								; die aktuelle Sprite-Auflösung.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; Video_Control (in a0 die cm und in a1 die tags)
								; Berichte in der Tagliste, in der langen
								; "resolution", die aktuelle Auflösung des
								; Sprite in diesem Bildschirm.

; Lassen Sie uns nun durch die VideoControl-Routine, die Auflösung einstellen.
; SPRITERESN_140NS -> dh lowres!

	MOVE.L	SchermoWBLocckato(PC),A0
	MOVE.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList, das setzt die Sprites zurück.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; video_control... die Sprites zurücksetzen!

; Jetzt setzen wir auch den möglichen "Vordergrund" -Bildschirm zurück, zum
; Beispiel den Assembler-Bildschirm:

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
	JSR	-$186(A6)				; _LVORethinkDisplay - was das ganze neu gestaltet
								; Displays, einschließlich ViewPorts und alle
ErroreSchermo:					; Interlace- oder Multisync-Modus.
	RTS

; Jetzt müssen wir die Sprites auf die Startauflösung zurücksetzen.

RimettiSprites:
	MOVE.L	SchermoWBLocckato(PC),D0	; Adresse Struktur Screen
	BEQ.S	NonAvevaFunzionato			; wenn = 0, dann sünde...
	MOVE.L	D0,A0
	MOVE.L	OldRisoluzione(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0			; Struktur ColorMap des Bildschirms
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; _LVOVideoControl - Auflösung auflösen

; Bildschirmzeit im Vordergrund (falls vorhanden)...

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0			; Ib_FirstScreen - "angeln" den Bildschirm ein
								; Vordergrund (zB ASMONE)
	MOVE.L	OldRisoluzioneP(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen.
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0			; Struktur ColorMap des Bildschirms
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; _LVOVideoControl - Auflösung auflösen

	MOVEA.L	SchermoWBLocckato(PC),A0
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$17A(A6)				; RethinkDisplay - wir "überdenken" die Anzeige
	move.l	$3c(a6),a0			; Ib_FirstScreen - Bildschirm im Vordergrund
	JSR	-$17A(A6)				; RethinkDisplay - wir "überdenken" die Anzeige
	MOVE.L	SchermoWBLocckato(PC),A1
	SUB.L	A0,A0				; null
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$204(A6)				; _LVOUnlockPubScreen - und "entsperren"
NonAvevaFunzionato:				; screen Workbench.
	RTS

SchermoWBLocckato:
	dc.l	0

; Dies ist die Struktur zur Verwendung von Video_Control. Das erste long ist zum
; ÄNDERN (SET) der Auflösung der Sprites oder Sie möchten die alte Auflösung 
; kennen (GET).

GETVidCtrlTags:
	dc.l	$80000032	; GET
OldRisoluzione:
	dc.l	0			; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0		; 3 Nullen für TAG_DONE (Beenden der TagList)

GETVidCtrlTags2:
	dc.l	$80000032	; GET
OldRisoluzioneP:
	dc.l	0			; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0		; 3 Nullen für TAG_DONE (Beenden der TagList)

SETVidCtrlTags:
	dc.l	$80000031	; SET
	dc.l	1			; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0		; 3 Nullen für TAG_DONE (Beenden der TagList)

SETOldVidCtrlTags:
	dc.l	$80000031	; SET
OldRisoluzione2:
	dc.l	0			; Auflösung sprite: 0=ECS, 1=lowres, 2=hires, 3=shres
	dc.l	0,0,0		; 3 Nullen für TAG_DONE (Beenden der TagList)

; WorkBench-Bildschirmname

Workbench:
	dc.b	'Workbench',0

******************************************************************************
;	Ab hier können Sie direkt auf der Hardware arbeiten
******************************************************************************

HEAVYINIT:
	LEA	$DFF000,A5				; Basis der CUSTOM-Register für Offsets
	MOVE.W	$2(A5),OLDDMA		; alten Status von DMACONR speichern
	MOVE.W	$1C(A5),OLDINTENA	; alten Status von INTENA speichern
	MOVE.W	$10(A5),OLDADKCON	; alten Status von ADKCON speichern
	MOVE.W	$1E(A5),OLDINTREQ	; alten Status von INTREQ speichern
	MOVE.L	#$80008000,d0		; die High-Bit-Maske vorbereiten
								; zum Setzen der Bits die in den
								; Worten gespeichert wurden 
	OR.L	d0,OLDDMA			; Bit 15 aller gespeicherten Werte setzen
	OR.L	d0,OLDADKCON		; der Hardware-Register,  unverzichtbar für
								; das zurücksetzen dieser Werte in die Register.

	MOVE.L	#$7FFF7FFF,$9A(a5)	; deaktiviert INTERRUPTS & INTREQS
	MOVE.L	#0,$144(A5)			; SPR0DAT - Nullzeiger!
	MOVE.W	#$7FFF,$96(a5)		; deaktiviert alle DMA

	bsr.s	START				; das Programm ausführen

	LEA	$dff000,a5				; Basis von CUSTOM-Registern für Offsets
	MOVE.W	#$7FFF,$96(A5)		; deaktiviert alle DMA
	MOVE.L	#$7FFF7FFF,$9A(A5)	; deaktiviertT INTERRUPTS & INTREQS
	MOVE.W	#$7fff,$9E(a5)		; deaktiviert die Bits von ADKCON
	MOVE.W	OLDADKCON(PC),$9E(A5)	; ADKCON 
	MOVE.W	OLDDMA(PC),$96(A5)		; den alten DMA-Status zurücksetzen
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ
	RTS

;	Beim Start gespeicherte Daten

WBVIEW:							; WorkBench View-Adresse
	DC.L	0
GfxName:
	dc.b	'graphics.library',0,0
IntuiName:
	dc.b	'intuition.library',0

GfxBase:						; Zeiger auf die Basis der Graphics Library
	dc.l	0
IntuiBase:						; Zeiger auf die Basis der Intuition Library
	dc.l	0
OLDDMA:							; alter Status DMACON
	dc.w	0
OLDINTENA:						; alter Status INTENA
	dc.w	0
OLDADKCON:						; alter Status ADKCON
	DC.W	0
OLDINTREQ:						; alter Status INTREQ
	DC.W	0

START:
	MOVE.L	#BITPLANE,d0		; Adresse der Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer in der copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane und copper

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse
	rts							; exit


	Section	CopProva,data_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
				; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste bitplane

	dc.w	$0180,$000			; color0 - HINTERGRUND
	dc.w	$0182,$19a			; color1 - SCHRIFT

;	Gradient copperlist

	dc.w	$5007,$fffe			; WAIT Zeile $50
	dc.w	$180,$001			; color0
	dc.w	$5207,$fffe			; WAIT Zeile $52
	dc.w	$180,$002			; color0
	dc.w	$5407,$fffe			; WAIT Zeile $54
	dc.w	$180,$003			; color0
	dc.w	$5607,$fffe			; WAIT Zeile $56
	dc.w	$180,$004			; color0
	dc.w	$5807,$fffe			; WAIT Zeile $58
	dc.w	$180,$005			; color0
	dc.w	$5a07,$fffe			; WAIT Zeile $5a
	dc.w	$180,$006			; color0
	dc.w	$5c07,$fffe			; WAIT Zeile $5c
	dc.w	$180,$007			; color0
	dc.w	$5e07,$fffe			; WAIT Zeile $5e
	dc.w	$180,$008			; color0
	dc.w	$6007,$fffe			; WAIT Zeile $60
	dc.w	$180,$009			; color0
	dc.w	$6207,$fffe			; WAIT Zeile $62
	dc.w	$180,$00a			; color0

	dc.w	$FFFF,$FFFE			; Ende copperlist

;	Mit dem Befehl dcb erstellen wir eine zufällige Zeichnung in der Bitebene

BITPLANE:
	dcb.l	10240/4,$FF00FF00

	end

Es gibt zwei Details, die in der Lektion nicht enthalten sind: Das erste ist, 
dass es eine Routine gibt, die den Videomodus der Sprits zurücksetzt, falls
Kickstart Version 3.0 oder höher ist.
Das zweite Detail ist, dass eine Anweisung hinzugefügt wurde, um AGA zu
deaktivieren:

	move.w	#$11,$10c(a5)		; AGA deaktivieren

In Wirklichkeit ist diese Anweisung meist überflüssig, weil es so gut wie nie
vorhanden ist, aber auch hier sollte die Sicherheit nicht vernachlässigt
werden.

Schalten Sie die Bitmap- und Copper-DMA-Kanäle nacheinander aus. Sie werden
feststellen, dass das Balkenmuster verschwindet, wenn der Bitplane-Kanal 
ausgeschaltet wird. Wenn Sie Copper deaktivieren, wird auch der Schatten
ausgeblendet. Versuchen Sie auch, Bit 9, den allgemeinen Schalter,
auszuschalten, und Sie werden sehen dass, auch wenn die anderen Bits aktiviert
sind, alles ausgeschaltet wird.
Der Versuch, Bit 15 zurückzusetzen, ist sinnlos!

