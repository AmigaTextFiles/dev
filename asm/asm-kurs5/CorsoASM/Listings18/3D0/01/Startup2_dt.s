******************************************************************************
;    680X0 & AGA STARTUP BY FABIO CIUCCI - Komplexität 2
******************************************************************************

MAINCODE:
	movem.l	d0-d7/a0-a6,-(SP)	; speichern der Register auf dem Stack
	move.l	4.w,a6				; ExecBase in a6
	LEA	DosName(PC),A1			; Dos.library
	JSR	-$198(A6)				; OldOpenlib
	MOVE.L	D0,DosBase
	BEQ.w	EXIT3				; Wenn Null, raus! Fehler!
	LEA	GfxName(PC),A1			; Name der zu öffnenden Bibliothek
	JSR	-$198(A6)				; OldOpenLibrary - öffne die lib
	MOVE.L	d0,GfxBase
	BEQ.w	EXIT2				; wenn ja, raus! Fehler!
	LEA	IntuiName(PC),A1		; Intuition.library
	JSR	-$198(A6)				; OldOpenlib
	MOVE.L	D0,IntuiBase
	BEQ.w	EXIT1				; Wenn Null, raus! Fehler!

	MOVE.L	d0,A0
	CMP.W	#39,$14(A0)			; Versione 39 oder höher? (kick3.0+)
	BLT.s	VecchiaIntui
	BSR.w	ResettaSpritesV39	; wenn kick3.0+ dann Sprites zurücksetzen
VecchiaIntui:

	MOVE.L	GfxBase(PC),A6
	MOVE.L	$22(A6),WBVIEW		; Speichern Sie das aktuelle System WBView
	SUB.L	A1,A1				; Nullansicht, um den Videomodus zurückzusetzen
	JSR	-$DE(A6)				; LoadView null - Videomodus zurückgesetzt
	SUB.L	A1,A1				; View null
	JSR	-$DE(A6)				; LoadView (zweimal für die Sicherheit...)
	JSR	-$10E(A6)				; WaitOf ( Diese beiden Anrufe nach WaitOf    )
	JSR	-$10E(A6)				; WaitOf ( Sie werden verwendet, um das Interlace zurückzusetzen )
	JSR	-$10E(A6)				; Noch zwei, vah!
	JSR	-$10E(A6)

	LEA	$DFF006,A5				; VhPosr
	MOVE.w	#$dd,D0				; Zeile zu warten
	MOVE.w	#WaitDisk,D1		; Wie lange warten ... (Natürlich
WaitaLoop:						; disk drives oder Hard Disk sind fertig).
	CMP.B	(A5),D0
	BNE.S	WaitaLoop
Wait2:
	CMP.B	(A5),D0
	Beq.s	Wait2
	dbra	D1,WaitaLoop

	MOVE.L	4.w,A6
	SUB.L	A1,A1				; NULL task - finde diese task
	JSR	-$126(A6)				; findtask (Task(name) in a1, -> d0=task)
	MOVE.L	D0,A1				; Task in a1
	MOVE.L	$B8(A1),pr_Win		; An diesem Offset ist die Adresse
								; des Fensters, aus dem das
								; Programm geladen war und die
								; DOS, um zu wissen, wo die Reqs zu öffnen sind.
	MOVE.L	#-1,$B8(A1)			; Wenn Sie es auf -1 DOS setzen, werden Reqs nicht geöffnet
								; Tatsächlich, wenn es Fehler beim Öffnen
								; von Dateien mit dos.lib gab, würde das System
								; versuchen, einen Requester zu öffnen, aber mit
								; Blitter deaktiviert (OwnBlit), 
								; könnte es nicht zeichnen, alles blockiert!
	MOVEQ	#127,D0				; Priorität in d0 (-128, +127) - MAXIMUM!
	JSR	-$12C(A6)				; LVOSetTaskPri (d0=Priorität, a1=task)

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)				; OwnBlitter, das gibt uns den exklusiven Zugriff auf dem blitter
								; verhindern, dass das Betriebssystem es verwendet.
	jsr	-$E4(A6)				; WaitBlit - Wartet auf das Ende jedes Blittings
	JSR	-$E4(A6)				; WaitBlit

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$84(a6)				; FORBID - Multitasking deaktivieren
	JSR	-$78(A6)				; DISABLE - Interrupts 
								; des Betriebssystems deaktivieren

	bsr.w	HEAVYINIT			; Jetzt können Sie den Teil ausführen, der 
								; auf Hardware-Registern funktioniert

	move.l	4.w,a6				; ExecBase in A6
	JSR	-$7E(A6)				; ENABLE - System Interrupts aktivieren 
	JSR	-$8A(A6)				; PERMIT - Multitasking aktivieren

	SUB.L	A1,A1				; NULL task - finde diesen task
	JSR	-$126(A6)				; findtask (Task(name) in a1, -> d0=task)
	MOVE.L	D0,A1				; Task in a1
	MOVE.L	pr_Win(PC),$B8(A1)  ; Windowsadresse zurücksetzen
	MOVEQ	#0,D0				; Priorität in d0 (-128, +127) - NORMAL
	JSR	-$12C(A6)				; LVOSetTaskPri (d0=Priorität', a1=task)

	MOVE.W	#$8040,$DFF096		; aktivieren blit
	BTST.b	#6,$dff002			; WaitBlit via hardware...
Wblittez:
	BTST.b	#6,$dff002
	BNE.S	Wblittez

	MOVE.L	GfxBase(PC),A6		; GfxBase in A6
	jsr	-$E4(A6)				; Warten auf das Ende aller Blittings
	JSR	-$E4(A6)				; WaitBlit
	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem 
								; kann den Blitter jetzt wieder verwenden

	MOVE.L	IntuiBase(PC),A0
	CMP.W	#39,$14(A0)			; V39+?
	BLT.s	Vecchissima
	BSR.w	RimettiSprites
Vecchissima:

	MOVE.L	GfxBase(PC),A6		; GfxBase in A6
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeiger auf das alte Copper1-System
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeiger auf das alte Copper2-System
	JSR	-$10E(A6)				; WaitOf (reset eventuell interlace)
	JSR	-$10E(A6)				; WaitOf
	MOVE.L	WBVIEW(PC),A1		; alt WBVIEW in A1
	JSR	-$DE(A6)				; loadview -stell den alten View wieder ein
	JSR	-$10E(A6)				; WaitOf (reset eventuell interlace)
	JSR	-$10E(A6)				; WaitOf
	MOVE.W	#$11,$DFF10C		; Dies stellt es nicht von selbst wieder her ..!
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeigen Sie auf das alte System copper1
	MOVE.L	$32(a6),$dff084		; COP2LC - Zeigen Sie auf das alte System copper2
	moveq	#100,d7
RipuntLoop:
	MOVE.L	$26(a6),$dff080		; COP1LC - Zeigen Sie auf das alte System copper1
	move.w	d0,$dff088
	dbra	d7,RipuntLoop		; Zur Sicherheit...

	MOVE.L	IntuiBase(PC),A6
	JSR	-$186(A6)				; _LVORethinkDisplay - Zeichnet alles neu
								; Displays, einschließlich ViewPorts und alle
								; Interlace- oder Multisync-Modus.
	MOVE.L	A6,A1				; IntuiBase in a1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - intuition.library GESCHLOSSEN
EXIT1:
	MOVE.L	GfxBase(PC),A1		; GfxBase in A1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - graphics.library GESCHLOSSEN
EXIT2:
	MOVE.L	DosBase(PC),A6		; DosBase in A1 um die Bibliothek zu schließen
	move.l	4.w,a6				; ExecBase in A6
	jsr	-$19E(a6)				; CloseLibrary - dos.library GESCHLOSSEN
EXIT3:
	movem.l	(SP)+,d0-d7/a0-a6	; stellen Sie die alten Registerwerte wieder her
	RTS							;  Zurück zu ASMONE oder Dos/WorkBench

pr_Win:
	dc.l	0

*******************************************************************************
;	Sprite-Auflösung "legal" zurücksetzen
*******************************************************************************

ResettaSpritesV39:
	LEA	Workbench(PC),A0		; Bildschirmname der Workbench in a0
	MOVE.L	IntuiBase(PC),A6
	JSR	-$1FE(A6)				; _LVOLockPubScreen -  Wir "blockieren" den Bildschirm
								; (dessen Name in a0 steht).
	MOVE.L	D0,SchermoWBLocckato
	BEQ.s	ErroreSchermo
	MOVE.L	D0,A0				; Struktur Screen in a0
	MOVE.L	$30(A0),A0			; sc_ViewPort + vp_ColorMap: in a0 haben wir jetzt
								; die ColorMap-Struktur des Bildschirms, die es gibt
								; dient (in a0) zur Durchführung einer "video_control"
								; von graphics.library.
	LEA	GETVidCtrlTags(PC),A1	;  In a1 die TagList für die Routine
								; "Video_control" - die Anforderung, dass
								; Lassen Sie uns diese Routine zu tun ist
								; VTAG_SPRITERESN_GET oder zu wissen
								; die aktuelle Sprite-Auflösung.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; ; Video_Control (in a0 die cm und in a1 die tags)
								; Berichte in der Tagliste, in der langen
								; "resolution", die aktuelle Auflösung des
								; Sprite in diesem Bildschirm.

; Jetzt bitten wir die VideoControl-Routine, die Auflösung einzustellen.
; SPRITERESN_140NS -> d.h. lowres!

	MOVE.L	SchermoWBLocckato(PC),A0
	MOVE.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList Das setzt die Sprites zurück.
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; video_control... Sprites zurücksetzen!

; Jetzt setzen wir auch den eventuellen "Vordergrund"-Bildschirm zurück, zum Beispiel den
; Assembler-Bildschirm:

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0			; Ib_FirstScreen (Vordergrundbildschirm!")
	MOVE.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	GETVidCtrlTags2(PC),A1	; In a1 die TagList GET
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; Video_Control (in a0 die cm und in a1 die tags)

	MOVEA.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0			; Ib_FirstScreen - "picken" den Bildschirm ein
								; Vordergrund (zB ASMONE)
	MOVEA.L	$30(A0),A0			; Struktur sc_ViewPort+vp_ColorMap in a0
	LEA	SETVidCtrlTags(PC),A1	; TagList Das setzt die Sprites zurück.
	MOVEA.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; video_control... Sprites zurücksetzen!

	MOVEA.L	SchermoWBLocckato(PC),A0
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$17A(A6)				; _LVOMakeScreen - der Bildschirm muss neu gemacht werden
	move.l	$3c(a6),a0			; Ib_FirstScreen - "picken" den Bildschirm ein
								; Vordergrund (zB ASMONE)
	JSR	-$17A(A6)				; _LVOMakeScreen - der Bildschirm muss neu gemacht werden
								; um sicher zu gehen, dass das zurückgesetzt wurde, ist es notwendig
								; MakeScreen aufrufen, gefolgt von ...
	JSR	-$186(A6)				; _LVORethinkDisplay - was das ganze neu gestaltet
								; Displays, einschließlich ViewPorts und alle
ErroreSchermo:					; Interlace- oder Multisync-Modus.
	RTS

; Jetzt müssen wir die Sprites auf die Startauflösung zurücksetzen.

RimettiSprites:
	MOVE.L	SchermoWBLocckato(PC),D0 ; Adresse Struktur Screen
	BEQ.S	NonAvevaFunzionato	; Wenn = 0, dann ...
	MOVE.L	D0,A0
	MOVE.L	OldRisoluzione(PC),OldRisoluzione2 ; Alte Auflösung zurücksetzen.
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0			; Struktur ColorMap des Screens
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; _LVOVideoControl - Auflösung zurücksetzen

; Bildschirmzeit im Vordergrund (falls vorhanden)...

	MOVE.L	IntuiBase(PC),A6
	move.l	$3c(a6),a0			; Ib_FirstScreen - "picken" den Bildschirm ein
								; Vordergrund (zB ASMONE)
	MOVE.L	OldRisoluzioneP(PC),OldRisoluzione2 ; alte Auflösung zurücksetzen
	LEA	SETOldVidCtrlTags(PC),A1
	MOVE.L	$30(A0),A0			; Struktur ColorMap des Screens
	MOVE.L	GfxBase(PC),A6
	JSR	-$2C4(A6)				; _LVOVideoControl - Auflösung zurücksetzen

	MOVEA.L	SchermoWBLocckato(PC),A0
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$17A(A6)				; RethinkDisplay - wir "überdenken" die Anzeige
	move.l	$3c(a6),a0			; Ib_FirstScreen - Bildschirm im Vordergrund
	JSR	-$17A(A6)				; RethinkDisplay - wir "überdenken" die Anzeige
	MOVE.L	SchermoWBLocckato(PC),A1
	SUB.L	A0,A0				; null
	MOVEA.L	IntuiBase(PC),A6
	JSR	-$204(A6)				; _LVOUnlockPubScreen - und "entsperren"
NonAvevaFunzionato:				; Workbench-Bildschirm.
	RTS

SchermoWBLocckato:
	dc.l	0

; Dies ist die Struktur zur Verwendung von Video_Control. Das erste long ist für
; ÄNDERN (SETZEN) der Auflösung von Sprites oder Sie möchten die alte Auflösung kennen (GET).

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
;	Ab hier können Sie direkt an der Hardware arbeiten
******************************************************************************

HEAVYINIT:
	LEA	$DFF000,A5				; Basis von CUSTOM-Registern für Offsets
	MOVE.W	$2(A5),OLDDMA		; Speichern des alten Status von DMACON
	MOVE.W	$1C(A5),OLDINTENA	; Speichern desn alten Status von INTENA
	MOVE.W	$10(A5),OLDADKCON	; Speichern des alten Status von ADKCON
	MOVE.W	$1E(A5),OLDINTREQ	; Speichern des alten Status von INTREQ
	MOVE.L	#$80008000,d0		; Bereiten Sie die High-Bit-Maske vor
								; in die Worte setzen, wo die
								; Register wurden gespeichert
	OR.L	d0,OLDDMA			; Bit 15 alle gespeicherten Werte setzen
	OR.L	d0,OLDADKCON		; von Hardware-Registern, unverzichtbar zum
								; Zurücksetzen der Werte in die Register..

	MOVE.L	#$7FFF7FFF,$9A(a5)	; INTERRUPTS & INTREQS deaktivieren
	MOVE.L	#0,$144(A5)			; SPR0DAT - Nullzeiger!
	MOVE.W	#$7FFF,$96(a5)		; DMA deaktivieren

	move.l	4.w,a6				; ExecBase in a6
	btst.b	#0,$129(a6)			; Testen, ob wir auf einem 68010 oder höher sind
	beq.s	IntOK				; Es ist ein 68000! Dann ist die Basis immer Null.
	lea	SuperCode(PC),a5		; Routine, die im Supervisor durchgeführt werden muss
	jsr	-$1e(a6)				; LvoSupervisor - führe die Routine durch
	bra.s	IntOK				; Wir haben den Wert des VBR, lasst uns fortfahren ...

;********************** SUPERVISOR-CODE für 68010+ **********************
SuperCode:
	dc.l  	$4e7a9801			; Movec Vbr,A1 (Anweisung 68010+).
								; Es ist hexadezimal, weil nicht alle
								; Assembler den movec assemblieren.
	move.l	a1,BaseVBR			; Label, wo der VBR-Wert gespeichert werden soll
	RTE							; Rückkehr aus der Ausnahme
;*****************************************************************************

BaseVBR:		; Wenn es nicht geändert wird, bleibt es Null! (für 68000).
	dc.l	0

IntOK:
	move.l	BaseVBR(PC),a0		; In a0 il valore del VBR
	move.l	$64(a0),OldInt64	; Sys int liv 1 speichern (softint,dskblk)
	move.l	$68(a0),OldInt68	; Sys int liv 2 speichern (I/O,ciaa,int2)
	move.l	$6c(a0),OldInt6c	; Sys int liv 3 speichern (coper,vblanc,blit)
	move.l	$70(a0),OldInt70	; Sys int liv 4 speichern (audio)
	move.l	$74(a0),OldInt74	; Sys int liv 5 speichern (rbf,dsksync)
	move.l	$78(a0),OldInt78	; Sys int liv 6 speichern (exter,ciab,inten)

	bsr.w	ClearMyCache

	lea	$dff000,a5				; Custom register in a5
	bsr.w	START				; Programm ausführen

	bsr.w	ClearMyCache

	LEA	$dff000,a5				; Custom base per offsets
	MOVE.W	#$7FFF,$96(A5)		; DMA ALLE DEAKTIVIEREN
	MOVE.L	#$7FFF7FFF,$9A(A5)	; INTERRUPTS & INTREQS ALLE DEAKTIVIEREN
	MOVE.W	#$7fff,$9E(a5)		; ADKCON Deaktivieren

	move.l	BaseVBR(PC),a0	     ; In a0 Wert von VBR
	move.l	OldInt64(PC),$64(a0) ; Sys int liv1 speichern (softint,dskblk)
	move.l	OldInt68(PC),$68(a0) ; Sys int liv2 speichern (I/O,ciaa,int2)
	move.l	OldInt6c(PC),$6c(a0) ; Sys int liv3 speichern (coper,vblanc,blit)
	move.l	OldInt70(PC),$70(a0) ; Sys int liv4 speichern (audio)
	move.l	OldInt74(PC),$74(a0) ; Sys int liv5 speichern (rbf,dsksync)
	move.l	OldInt78(PC),$78(a0) ; Sys int liv6 speichern (exter,ciab,inten)

	MOVE.W	OLDADKCON(PC),$9E(A5)	; ADKCON 
	MOVE.W	OLDDMA(PC),$96(A5)		; alten DMA-Status zurücksetzen
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ
	RTS

;	vom Startup gespeicherte Daten

WBVIEW:			; Adresse des View der WorkBench
	DC.L	0
GfxName:
	dc.b	'graphics.library',0,0
IntuiName:
	dc.b	'intuition.library',0
DosName:
	dc.b	"dos.library",0
GfxBase:		; Zeiger auf die Basis von Graphics Library
	dc.l	0
IntuiBase:		; Zeiger auf die Basis von Intuition Library
	dc.l	0
DosBase:		; Zeiger auf die Basis von Dos Library
	dc.l	0
OLDDMA:			; alter status DMACON
	dc.w	0
OLDINTENA:		; alter status INTENA
	dc.w	0
OLDADKCON:		; alter status ADKCON
	DC.W	0
OLDINTREQ:		; alter status INTREQ
	DC.W	0

; alte interrupts des Systems

OldInt64:
	dc.l	0
OldInt68:
	dc.l	0
OldInt6c:
	dc.l	0
OldInt70:
	dc.l	0
OldInt74:
	dc.l	0
OldInt78:
	dc.l	0

; Routine zum Aufrufen bei selbstmodifizierendem Code, Änderung von Tabellen
; beim Fast RAM, beim Laden von Datenträgern usw.

ClearMyCache:
	movem.l	d0-d7/a0-a6,-(SP)
	move.l	4.w,a6
	btst.b	#1,$129(a6)	; Test ob 68020 oder höher
	beq.s	nocaches
	MOVE.W	$14(A6),D0	; lib version
	CMPI.W	#37,D0		; und V37+? (kick 2.0+)
	blo.s	nocaches	; wenn kick1.3, das problem ist, dass es nicht geht
						; Ich weiß nicht einmal, ob es ein 68040 ist, also
						; es ist riskant .. und hoffentlich eins
						; dumm wer einen 68020+ auf einem kick1.3 hat 
						; hat auch Caches deaktiviert!
	jsr -$27c(a6)		; Cache clear U (für Ladevorgänge, Modifikationen etc.)
nocaches:
	movem.l	(sp)+,d0-d7/a0-a6
	rts

