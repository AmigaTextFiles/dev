
; Lezione11o2.s  Laden einer Datendatei mithilfe der dos.library
; Drücken Sie die linke Taste zum Laden, die rechte zum Verlassen

	Section DosLoad,code

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"	; speichern interrupt, dma etc.
*****************************************************************************

;Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper,bitplane DMA aktivieren

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

; Zeiger auf Bild

	MOVE.L	#PICTURE2,d0
	LEA	BPLPOINTERS2,A1
	MOVEQ	#5-1,D1			; Anzahl der bitplanes
POINTBT2:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#34*40,d0		; Länge der bitplane
	addq.w	#8,a1
	dbra	d1,POINTBT2		; mach das D1 mal (D1=Anzahl der bitplanes)

; Wir zeigen auf das PIC, das geladen wird (jetzt ist es nur ein leerer Puffer)

	LEA	bplpointers,A0
	MOVE.L	#LOGO+40*40,d0	; Adresse logo (etwas abgesenkt)
	MOVEQ	#6-1,D7			; 6 bitplanes HAM.
pointloop:
	MOVE.W	D0,6(A0)
	SWAP	D0
	MOVE.W	D0,2(A0)
	SWAP	D0
	ADDQ.w	#8,A0
	ADD.L	#176*40,D0		; Länge plane
	DBRA	D7,pointloop


; Wir zeigen auf unseren Level 3 Int

	move.l	BaseVBR(PC),a0	     ; in a0 ist der Wert des VBR
	move.l	oldint6c(PC),crappyint	; für DOS LOAD - wir springen zum oldint
	move.l	#MioInt6c,$6c(a0)	; meine Routine Int. Level 3 anlegen

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; initialisieren Sie die Musik Routine
	movem.l	(SP)+,d0-d7/a0-a6

	move.w	#$c020,$9a(a5)		; INTENA - aktivieren interrupt "VERTB"
								; per Level 3 ($6c)

mouse:
	btst	#6,$bfe001	; linke Maustaste gedrückt? (Der Prozessor 
	bne.s	mouse		; unterbricht die Schleife zu jedem vertical blank
						; sowie jedes WAIT der Rasterzeile $a0 und
						; unterbricht um die Musik zu spielen!)

	bsr.w	DosLoad		; Laden Sie eine Datei mit dos.lib hoch
						; während wir unsere eigene copperliste ansehen
						; und unser Interrupts starten
	TST.L	ErrorFlag
	bne.s	ErroreLoad	; Datei nicht geladen? Dann lass es uns nicht benutzen!

mouse2:
	btst	#2,$dff016	; rechte Maustaste gedrückt? (Der Prozessor 
	bne.s	mouse2		; unterbricht die Schleife zu jedem vertical blank)

ErroreLoad:
	bsr.w	mt_end		; Ende der Wiederholung!

	rts					; exit

*****************************************************************************
*	INTERRUPTROUTINE  $6c (Level 3) -  VERTB und COPER benutzt.
*****************************************************************************

MioInt6c:
	btst.b	#5,$dff01f		; INTREQR - Bit 5, VERTB, ist zurückgesetzt?
	beq.s	NointVERTB		; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music		; Musik spielen
	bsr.w	ColorCicla		; Wechseln der Farben des Bildes
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
NointVERTB:
	move.w	#$70,$dff09c	; INTREQ - Löschen Flag BLIT,VERTB,COPER
							; da der 680x0 es nicht von selbst löscht!!!
	rte						; Ende vom Interrupt VERTB

*****************************************************************************
*	Routine, die die Farben der gesamten Palette "wechselt".		     *
*	Diese Routine wechselt die ersten 15 Farben getrennt vom			 *
*   zweiten Farbblock. Es funktioniert wie das "RANGE" des Dpaint.       *
*****************************************************************************

;  Der "cont" -Zähler wird verwendet, um 3 Frames vorher warten zu lassen
;  Laufroutine fortsetzen In der Praxis "verlangsamen" wir die Ausführung. 

cont:
	dc.w	0

ColorCicla:
	addq.b	#1,cont
	cmp.b	#3,cont		; Handle nur einmal alle 3 Frames
	bne.s	NonAncora	; sind wir noch nicht auf dem dritten Platz? Exit!
	clr.b	cont		; wir sind am dritten, setzen Sie den Zähler zurück

; Rückwärtsrotation der ersten 15 Farben

	lea	cols+2,a0		; Erste Farbadresse der ersten Gruppe
	move.w	(a0),d0		; Speichern der ersten Farbe in d0
	moveq	#15-1,d7	; 15 Farben zum "drehen" in der ersten Gruppe
cloop1:
	move.w	4(a0),(a0)	; Kopieren Sie die Farbe vorwärts in die erste
	addq.w	#4,a0		; springe zur nächsten Spalte "zurück"
	dbra	d7,cloop1	; wiederhole d7 mal
	move.w	d0,(a0)		; Ordne die erste als letzte gespeicherte Farbe an

; Vorwärtsrotation der zweiten 15 Farben

	lea	cole-2,a0		; Erste Farbadresse der zweiten Gruppe
	move.w	(a0),d0		; Speichern der ersten Farbe in d0
	moveq	#15-1,d7	; Weitere 15 Farben müssen separat "rotiert" werden
cloop2:	
	move.w	-4(a0),(a0)	; Kopieren Sie die Farbe zurück zum nächsten
	subq.w	#4,a0		; zur vorherigen Spalte springen "vorrücken"
	dbra	d7,cloop2	; wiederhole d7 mal
	move.w	d0,(a0)		; Ordne die erste als letzte gespeicherte Farbe an
NonAncora:
	rts


*****************************************************************************
; Routine, die eine Datei lädt, während wir ins Metall schlagen.
*****************************************************************************

DosLoad:
	bsr.w	PreparaLoad		; Stellen Sie Multitasking wieder her und 
							; stellen Sie das Interrupt-Load ein
	moveq	#5,d1			; Anzahl der zu wartenden frames
	bsr.w	AspettaBlanks	; warte 5 frames

	bsr.s	CaricaFile		; Laden Sie die Datei mit der dos.library
	move.l	d0,ErrorFlag	; Speichern Sie den Erfolgs- oder Fehlerstatus
	
; Bemerkung: Jetzt müssen wir auf den Laufwerksmotor warten
; Eine schlechte Festplatte oder CD-ROM wird heruntergefahren, bevor wir alles 
; einfrieren oder einen spektakulären Systemabsturz verursachen.

	move.w	#150,d1			; Anzahl der frames zu warten
	bsr.w	AspettaBlanks	; warte 150 frames

	bsr.w	DopoLoad		; Deaktiviere multitask und vergebene interrupt
	rts

ErrorFlag:
	dc.l	0

*****************************************************************************
; Prozedur, die eine Datei einer angegebenen Länge und mit einem angegebenen
; Namen lädt. Wir müssen den ganzen Weg gehen!
*****************************************************************************

CaricaFile:
	MOVE.L	DosBase(PC),A6
	MOVE.L	#filename,d1	; handle speichern
	MOVE.L	#1,d2			; handle speichern
	MOVE.L	#81158,d3		; handle speichern
	JSR	-$42(A6)			; SEEK - "Seeka" die Datei

	move.l	#filename,d1	; Adresse mit String "file name + Pfad"
	MOVE.L	#$3ED,D2		; AccessMode: MODE_OLDFILE - File das es 
							; schon gibt, und deshalb können wir lesen.
	MOVE.L	DosBase(PC),A6
	JSR	-$1E(A6)			; LVOOpen - "Öffnen" Sie die Datei
	MOVE.L	D0,FileHandle	; Speichern Sie seinen handle
	BEQ.S	ErrorOpen		; wenn d0 = 0 dann liegt ein Fehler vor!

; Wir laden die Datei hoch

	MOVE.L	D0,D1			; FileHandle in d1 für das Lesen
	MOVE.L	#buffer,D2		; Adresse Ziel in d2
	MOVE.L	#42240,D3		; Dateilänge (GENAU!)
	MOVE.L	DosBase(PC),A6
	JSR	-$2A(A6)			; LVORead - Lesen Sie die Datei und kopieren Sie sie in den Puffer
	cmp.l	#-1,d0			; Fehler gefunden? (hier ist es mit -1 angegeben)
	beq.s	ErroreRead

; Chiudiamolo

	MOVE.L	FileHandle(pc),D1	; FileHandle in d1
	MOVE.L	DosBase(PC),A6
	JSR	-$24(A6)				; LVOClose - schließe die Datei

; Beachten Sie, dass die anderen Programme dies nicht tun, wenn Sie die Datei nicht SCHLIESSEN
; Sie können auf diese Datei zugreifen (Sie können sie nicht löschen oder verschieben).

	moveq	#0,d0	; Wir berichten über Erfolge
	rts

; Hier sind die schmerzhaften Notizen im Fehlerfall:

ErroreRead:
	MOVE.L	FileHandle(pc),D1	; FileHandle in d1
	MOVE.L	DosBase(PC),A6
	JSR	-$24(A6)				; LVOClose - schließe die Datei
ErrorOpen:
	moveq	#-1,d0				; Wir melden einen Misserfolg
	rts


FileHandle:
	dc.l	0

; Textstring, der mit einer 0 endet, auf die d1 vorher zeigen muss
; Öffnen Sie die Datei dos.lib. Es lohnt sich, den ganzen Weg zu legen.

Filename:
	dc.b	"assembler3:sorgenti7/amiet.raw",0	; Pfad+Name file
	even

*****************************************************************************
; Interruptroutine, die beim Laden ausgeführt werden soll. Die Routinen dafür
; wird in diesem Interrupt abgelegt und auch während des 
; Ladens von Diskette, Festplatte oder CD-ROM ausgeführt.
; BITTE BEACHTEN SIE, DASS WIR DEN INTERRUPT COPER UND NICHT DEN VBLANK VERWENDEN
; DIES WEIL WÄHREND DES LADENS VON DER DISKETTE, INSBESONDERE UNTER KICK 1.3,
; DER INTERRUPT VERTB NICHT STABIL IST, so dass die Musik stockt.
; Wenn wir stattdessen "$9c,$8010" in unsere copperliste setzen, sind wir sicher
; dass diese Routine nur einmal pro Frame ausgeführt wird.
*****************************************************************************

myint6cLoad:
	btst.b	#4,$dff01f		; INTREQR - Bit 4, COPER, gelöscht?
	beq.s	nointL			; Wenn ja, ist es kein "echter" int COPER!
	move.w	#%10000,$dff09c	; Wenn nicht, ist es die richtige Zeit, lasst uns 
	movem.l	d0-d7/a0-a6,-(SP) ; die Anforderung entfernen!
	bsr.w	mt_music		; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6
nointL:
	dc.w	$4ef9			; Hexadezimalwert von JMP
Crappyint:
	dc.l	0	; Adresse, an die gesprungen werden soll, um AUTOMATISIERT zu werden...
				; VORSICHT: der selbstmodifizierende Code sollte
				; nicht verwendet werden. Jedenfalls, mit
				; ClearMyCache vorher und nachher funktioniert es!

*****************************************************************************
; Routine, die das Betriebssystem mit Ausnahme der copperliste wiederherstellt
; Außerdem setzen Sie unseren $6c-Interrupt, der dann zum System-Interrupt springt.
; Beachten Sie, dass der Interrupt während des Ladevorgangs vom int "COPER" verwaltet wird.
*****************************************************************************

PreparaLoad:
	LEA	$DFF000,A5				; Basis der CUSTOM-Register für Offset
	MOVE.W	$2(A5),OLDDMAL		; Speichern Sie den alten Status von DMACON
	MOVE.W	$1C(A5),OLDINTENAL	; Speichern Sie den alten Status von INTENA
	MOVE.W	$1E(A5),OLDINTREQL	; Speichern Sie den alten Status von INTREQ
	MOVE.L	#$80008000,d0		; Bereiten Sie die Maske der High-Bits vor
	OR.L	d0,OLDDMAL			; Bit 15 der gespeicherten Werte setzen
	OR.W	d0,OLDINTREQL		; der Register, um sie zurückzusetzen.

	bsr.w	ClearMyCache

	MOVE.L	#$7FFF7FFF,$9A(a5)	; DEAKTIVIEREN SIE INTERRUPTS & INTREQS

	move.l	BaseVBR(PC),a0	     ; in a0 ist der Wert des VBR
	move.l	OldInt64(PC),$64(a0) ; Sys int lev1 speichern (softint,dskblk)
	move.l	OldInt68(PC),$68(a0) ; Sys int lev2 speichern (I/O,ciaa,int2)
	move.l	#myint6cLoad,$6c(a0) ; Int was dann zu dem von sys springt. 
	move.l	OldInt70(PC),$70(a0) ; Sys int lev4 speichern (audio)
	move.l	OldInt74(PC),$74(a0) ; Sys int lev5 speichern (rbf,dsksync)
	move.l	OldInt78(PC),$78(a0) ; Sys int lev6 speichern (exter,ciab,inten)

	MOVE.W	#%1000001001010000,$96(A5) ; Aktivieren Sie aus Sicherheitsgründen "blit" und "disk"
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ
	move.w	#$c010,$9a(a5)			; Wir müssen sicher sein, dass COPER
									; (interrupt über copperlist) ON ist!

	move.l	4.w,a6
	JSR	-$7e(A6)	; Enable
	JSR	-$8a(a6)	; Permit

	MOVE.L	GfxBase(PC),A6
	jsr	-$E4(A6)	; Warten Sie, bis alle blittata verschwunden sind
	JSR	-$E4(A6)	; WaitBlit
	jsr	-$1ce(a6)	; DisOwnBlitter, das Betriebssystem 
					; kann den Blitter jetzt wieder benutzen
					; (In Kick 1.3 wird es zum Laden von der Diskette verwendet.)
	MOVE.L	4.w,A6
	SUBA.L	A1,A1	; NULL task - finde diese Aufgabe
	JSR	-$126(A6)	; findtask (Task(name) in a1, -> d0=task)
	MOVE.L	D0,A1	; Task in a1
	MOVEQ	#0,D0	; Priorität in d0 (-128, +127) - NORMAL
					; (damit die Laufwerke atmen können)
	JSR	-$12C(A6)	; _LVOSetTaskPri (d0=Priorität, a1=task)
	rts

OLDDMAL:
	dc.w	0
OLDINTENAL:		; Old status INTENA
	dc.w	0
OLDINTREQL:		; Old status INTREQ
	DC.W	0

*****************************************************************************
; Routine, die das Betriebssystem schließt und unseren Interrupt zurücksetzt
*****************************************************************************

DopoLoad:
	MOVE.L	4.w,A6
	SUBA.L	A1,A1		; NULL task - finde diese Aufgabe
	JSR	-$126(A6)		; findtask (Task(name) in a1, -> d0=task)
	MOVE.L	D0,A1		; Task in a1
	MOVEQ	#127,D0		; Priorität in d0 (-128, +127) - MAXIMUM
	JSR	-$12C(A6)		; _LVOSetTaskPri (d0=priorität, a1=task)

	JSR	-$84(a6)		; Forbid
	JSR	-$78(A6)		; Disable

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)		; OwnBlitter, das gibt uns exklusiv den Blitter
						; Verhinderung seiner Verwendung durch das Betriebssystem.
	jsr	-$E4(A6)		; WaitBlit - Er wartet auf das Ende jeder blittata
	JSR	-$E4(A6)		; WaitBlit

	bsr.w	ClearMyCache

	LEA	$dff000,a5		; Custom base per offsets
AspettaF:
	MOVE.L	4(a5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	#$1ff00,D0	; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	#$12d00,D0	; warte auf Zeile $12d um das zu verhindern
	BEQ.S	AspettaF	; Das Ausschalten des DMA führt zu Flimmern

	MOVE.L	#$7FFF7FFF,$9A(A5)	; DEAKTIVIEREN SIE INTERRUPTS & INTREQS

			; 5432109876543210
	MOVE.W	#%0000010101110000,d0	; DEAKTIVIEREN DMA

	btst	#8-8,olddmal	; test bitplane
	beq.s	NoPlanesA
	bclr.l	#8,d0			; nicht ausschalten planes
NoPlanesA:
	btst	#5,olddmal+2	; test sprite
	beq.s	NoSpritez
	bclr.l	#5,d0			; nicht ausschalten sprite
NoSpritez:
	MOVE.W	d0,$96(A5)		; DEAKTIVIEREN DMA

	move.l	BaseVBR(PC),a0			; in a0 ist der Wert des VBR
	move.l	#MioInt6c,$6c(a0)		; meine Routine int. Level 3.
	MOVE.W	OLDDMAL(PC),$96(A5)		; Gibt den alten DMA-Status zurück
	MOVE.W	OLDINTENAL(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQL(PC),$9C(A5)	; INTREQ
	rts

*****************************************************************************
; Diese Routine wartet D1-Frames. Alle 50 Bilder vergehen 1 Sekunde.
;
; d1 = Anzahl der zu wartenden Frames
;
*****************************************************************************

AspettaBlanks:
	LEA	$DFF000,A5		; OFFSET für CUSTOM REGISTER 
WBLAN1xb:
	MOVE.w	#$80,D0
WBLAN1bxb:
	CMP.B	6(A5),D0	; vhposr
	BNE.S	WBLAN1bxb
WBLAN2xb:
	CMP.B	6(A5),D0	; vhposr
	Beq.S	WBLAN2xb
	DBRA	D1,WBLAN1xb
	rts

*****************************************************************************
;	Wiederholungsroutine protracker/soundtracker/noisetracker
;
	include	"assembler2:sorgenti4/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

BPLPOINTERS:
	dc.w $e0,0,$e2,0		; erste	 bitplane
	dc.w $e4,0,$e6,0		; zweite    "
	dc.w $e8,0,$ea,0		; dritte    "
	dc.w $ec,0,$ee,0		; vierte    "
	dc.w $f0,0,$f2,0		; fünfte    "
	dc.w $f4,0,$f6,0		; sechste   "

	dc.w	$180,0	; Color0 schwarz


				 ;5432109876543210
	dc.w	$100,%0110101000000000	; bplcon0 - 320*256 HAM!

	dc.w $180,$0000,$182,$134,$184,$531,$186,$443
	dc.w $188,$0455,$18a,$664,$18c,$466,$18e,$973
	dc.w $190,$0677,$192,$886,$194,$898,$196,$a96
	dc.w $198,$0ca6,$19a,$9a9,$19c,$bb9,$19e,$dc9
	dc.w $1a0,$0666

	dc.w	$9707,$FFFE	; warte auf Zeile $97

	dc.w	$100,$200	; BPLCON0 - keine bitplanes
	dc.w	$180,$00e	; color0 BLAU

	dc.w	$b907,$fffe	; warte auf Zeile $b9
BPLPOINTERS2:
	dc.w $e0,0,$e2,0		; erste	 bitplane
	dc.w $e4,0,$e6,0		; zweite    "
	dc.w $e8,0,$ea,0		; dritte    "
	dc.w $ec,0,$ee,0		; vierte    "
	dc.w $f0,0,$f2,0		; fünfte    "

	dc.w	$100,%0101001000000000	; BPLCON0 - 5 bitplanes LOWRES

; Die Palette, die in 2 Gruppen von 16 Farben "gedreht" wird.

cols:
	dc.w $180,$040,$182,$050,$184,$060,$186,$080	; Grünton
	dc.w $188,$090,$18a,$0b0,$18c,$0c0,$18e,$0e0
	dc.w $190,$0f0,$192,$0d0,$194,$0c0,$196,$0a0
	dc.w $198,$090,$19a,$070,$19c,$060,$19e,$040

	dc.w $1a0,$029,$1a2,$02a,$1a4,$13b,$1a6,$24b	; Blauton
	dc.w $1a8,$35c,$1aa,$36d,$1ac,$57e,$1ae,$68f
	dc.w $1b0,$79f,$1b2,$68f,$1b4,$58e,$1b6,$37e
	dc.w $1b8,$26d,$1ba,$15d,$1bc,$04c,$1be,$04c
cole:

	dc.w	$da07,$fffe	; warte auf Zeile $da
	dc.w	$100,$200	; BPLCON0 - deaktiviere bitplanes
	dc.w	$180,$00e	; color0 BLAU

	dc.w	$ff07,$fffe	; warte auf Zeile $ff
	dc.w	$9c,$8010	; INTREQ - Ich fordere eine COPER-Unterbrechung an,
						; um  Musik zu spielen (auch während wir
						; mit der dos.library laden).

	dc.w	$FFFF,$FFFE	; Ende copperlist


*****************************************************************************
; 		DESIGN 320*34 mit 5 bitplanes (32 Farben)
*****************************************************************************

PICTURE2:
	;INCBIN	"pic320*34*5.raw"
	blk.b 5*1360,$F0 
*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"assembler2:sorgenti4/mod.fairlight"

******************************************************************************
; Puffer, in den das Bild über doslib von der Diskette geladen wird
******************************************************************************

	section	mioplanaccio,bss_C

buffer:
LOGO:
	ds.b	6*40*176	; 6 bitplanes * 176 lines * 40 bytes (HAM)
	;incbin	"assembler3:sorgenti7/amiet.raw"	; für Test

	end

In diesem Beispiel laden wir das Logo, das unmittelbar darüber erscheint. Wenn 
Sie es von der Diskette laden werden Sie feststellen, dass es plane für plane
in Stücken erscheint, die tatsächlich Stück für Stück geladen sind!
Es wäre besser, es in einen separaten Puffer zu laden, und nach dem Laden alles
zusammen anzuzeigen.
Das Grundlegende beim Laden ist, dass die wartende Zeit nach dem Laden, 
ausreichend ist, bevor Sie alles schließen. Sonst ist es das Ende!
Im Interrupt wird nicht die Farbroutine ausgeführt, sondern nur die Musikroutine, 
zumindest merkt man die Zeit, die man "für die Sicherheit" wartet.
Da diese Zeit sowieso abgewartet werden sollte, wäre es klug, ein Verblassen
oder eine zeitraubende Routine, die vorher etwas Nettes tut zu machen.
Schließe alles, zumindest hast du die Zeit gewartet, aber nicht ohne es zu benutzen!