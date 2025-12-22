
; Listing11o2.s		Hochladen einer Datendatei mit der dos.library
; Drücken Sie die linke Taste zum Laden, die rechte zum Verlassen

	Section DosLoad,code

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern interrupt, dma etc.
*****************************************************************************

; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper,bitplane DMA aktivieren

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

START:

; Zeiger auf PIC

	MOVE.L	#PICTURE2,d0
	LEA	BPLPOINTERS2,A1
	MOVEQ	#5-1,D1				; Anzahl der bitplanes
POINTBT2:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#34*40,d0			; Länge der bitplane
	addq.w	#8,a1
	dbra	d1,POINTBT2			; D1-mal wiederholen (D1 = Anzahl der bitplanes)

; Wir zeigen auf das PIC das geladen wird (jetzt ist es nur ein leerer Puffer)

	LEA	bplpointers,A0
	MOVE.L	#LOGO+40*40,d0		; Logo-Adresse (etwas abgesenkt)
	MOVEQ	#6-1,D7				; 6 bitplanes HAM.
pointloop:
	MOVE.W	D0,6(A0)
	SWAP	D0
	MOVE.W	D0,2(A0)
	SWAP	D0
	ADDQ.w	#8,A0
	ADD.L	#176*40,D0			; Länge plane
	DBRA	D7,pointloop


; Wir zeigen auf unseren int-Level 3

	move.l	BaseVBR(PC),a0		; In a0 ist der Wert des VBR
	move.l	oldint6c(PC),crappyint	; für DOS LOAD - wir springen zum oldint
	move.l	#MioInt6c,$6c(a0)	; Ich lege meine rout. int. Level 3 fest

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_init				; Musikroutine initialisieren
	movem.l	(SP)+,d0-d7/a0-a6

	move.w	#$c020,$9a(a5)		; INTENA - aktivieren interrupt "VERTB"
								; per Level 3 ($6c)

mouse:
	btst	#6,$bfe001			; Maus gedrückt? (Der Prozessor 
	bne.s	mouse				; unterbricht die Schleife zu jedem vertical blank
								; um die Musik zu spielen!).
								; sowie jedes WAIT der Rasterzeile $a0

	bsr.w	DosLoad				; Laden Sie eine Datei legal mit der dos.lib hoch
								; während wir uns die Ausführung unseres Interrupts
								; der copperliste sansehen
	TST.L	ErrorFlag
	bne.s	ErroreLoad			; Datei nicht geladen? Lass es uns dann nicht benutzen!

mouse2:
	btst	#2,$dff016			; Maus gedrückt? (Der Prozessor macht das
	bne.s	mouse2				; Schleifen und jede vertical blank

ErroreLoad:
	bsr.w	mt_end				; Ende der Wiederholung!

	rts							; exit

*****************************************************************************
*	INTERRUPT-ROUTINE  $6c (Level 3) - VERTB und COPER benutzt.
*****************************************************************************

MioInt6c:
	btst.b	#5,$dff01f			; INTREQR - ist Bit 5, VERTB zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	bsr.w	ColorCicla			; Wechseln der Farben des Bildes
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
NointVERTB:
	move.w	#$70,$dff09c		; INTREQ - int ausgeführt, löschen der Anforderung
								; da der 680x0 es nicht von selbst löscht!!!
	rte							; Ende vom Interrupt VERTB

*****************************************************************************
*	Routine, die die Farben der gesamten Palette "rotiert".				    *
*	Diese Routine rotiert die ersten 15 Farben getrennt von der zweiten     *
*   (zweiter Farbblock). Es funktioniert wie das "RANGE" des Dpaint.	    *
*****************************************************************************

; Der "cont" -Zähler wird verwendet, um 3 Frames vorher warten zu lassen
; Führen Sie die cont-Routine aus. In der Praxis "verlangsamen" wir die Ausführung. 

cont:
	dc.w	0

ColorCicla:
	addq.b	#1,cont
	cmp.b	#3,cont				; Handle nur einmal alle 3 Frames
	bne.s	NonAncora			; Sind wir noch nicht auf dem dritten Platz? Quit!
	clr.b	cont				; Wir sind am dritten, setzen Sie den Zähler zurück

; Rückwärtsdrehung der ersten 15 Farben

	lea	cols+2,a0				; Erste Farbadresse der ersten Gruppe
	move.w	(a0),d0				; speichern Sie die erste Farbe in d0
	moveq	#15-1,d7			; 15 Farben zum "rotieren" in der ersten Gruppe
cloop1:
	move.w	4(a0),(a0)			; Kopieren Sie die Farbe vorwärts in die erste
	addq.w	#4,a0				; springe zur nächsten Spalte "Schritt zurück"
	dbra	d7,cloop1			; wiederhole d7 mal
	move.w	d0,(a0)				; stellen Sie die erste als letzte gespeicherte Farbe ein.

; Vorwärtsrotation der zweiten 15 Farben

	lea	cole-2,a0				; Adresse letzte Farbe der zweiten Gruppe
	move.w	(a0),d0				; Speichern Sie die letzte Farbe in d0
	moveq	#15-1,d7			; weitere 15 Farben separat "rotieren"
cloop2:	
	move.w	-4(a0),(a0)			; Kopieren Sie die Farbe zurück zum nächsten
	subq.w	#4,a0				; zur vorherigen Spalte springen "vorrücken"
	dbra	d7,cloop2			; wiederhole d7 mal
	move.w	d0,(a0)				; stellen Sie die zuletzt als erste gespeicherte Farbe ein
NonAncora:
	rts


*****************************************************************************
; Routine, die eine Datei lädt, während wir in das Metall schlagen.
*****************************************************************************

DosLoad:
	bsr.w	PreparaLoad			; Multitask zurücksetzen und Interrupt laden

	moveq	#5,d1				; Anzahl der frames zu warten
	bsr.w	AspettaBlanks		; warte 5 frames

	bsr.s	CaricaFile			; Laden Sie die Datei mit der dos.library
	move.l	d0,ErrorFlag		; Speichern Sie den Erfolgs- oder Fehlerstatus

; Hinweis: jetzt müssen wir auf das Diskettenlaufwerk warten, oder die
; arme Festplatte oder CD-ROM schaltet sich aus, bevor alles blockiert wird
; oder es verursacht einen spektakulärer Systemabsturz.

	move.w	#150,d1				; Anzahl der frames zu warten
	bsr.w	AspettaBlanks		; warte 150 frames
		
	bsr.w	DopoLoad			; Multitask deaktivieren und Interrupt zurückgeben
	rts

ErrorFlag:
	dc.l	0

*****************************************************************************
; Routine, die eine Datei einer bestimmten Länge mit einem Namen lädt.
; Der ganze Pfad muss angegeben werden!
*****************************************************************************

CaricaFile:
	move.l	#filename,d1		; Adresse mit String "file name + Pfad"
	MOVE.L	#$3ED,D2			; AccessMode: MODE_OLDFILE - Datei die es 
								; schon gibt, damit wir lesen können.
	MOVE.L	DosBase(PC),A6
	JSR	-$1E(A6)				; LVOOpen - "Öffnen" Sie die Datei
	MOVE.L	D0,FileHandle		; speichern sie den handle
	BEQ.S	ErrorOpen			; wenn d0 = 0 dann ist da ein Fehler!

; Wir laden die Datei hoch

	MOVE.L	D0,D1				; FileHandle in d1 für das Lesen
	MOVE.L	#buffer,D2			; Zieladresse in d2
	MOVE.L	#42240,D3			; Dateilänge (GENAU!)
	MOVE.L	DosBase(PC),A6
	JSR	-$2A(A6)				; LVORead - Lesen Sie die Datei und kopieren Sie sie in den Puffer
	cmp.l	#-1,d0				; Fehler gefunden? (hier mit -1 angegeben)
	beq.s	ErroreRead

; Chiudiamolo

	MOVE.L	FileHandle(pc),D1	; FileHandle in d1
	MOVE.L	DosBase(PC),A6
	JSR	-$24(A6)				; LVOClose - Datei schließen

; Beachten Sie, dass die anderen Programme dies nicht tun, wenn Sie die Datei NICHT SCHLIESSEN
; kann auf diese Datei zugreifen (Sie können sie nicht löschen oder verschieben).

	moveq	#0,d0				; Wir berichten über Erfolge
	rts

; Hier die traurigen Notizen im Fehlerfall:

ErroreRead:
	MOVE.L	FileHandle(pc),D1	; FileHandle in d1
	MOVE.L	DosBase(PC),A6
	JSR	-$24(A6)				; LVOClose - Datei schließen
ErrorOpen:
	moveq	#-1,d0				; Wir melden einen Misserfolg
	rts


FileHandle:
	dc.l	0

; Textzeichenfolge, um mit einer 0 zu enden, auf die Sie d1 vorher zeigen müssen
; mach das ÖFFNEN der dos.lib. Es ist besser, den gesamten Pfad zu setzen.

Filename:
	dc.b	"/Sources/amiet.raw",0	; Pfad+Dateiname
	even

*****************************************************************************
; Interrupt-Routine, die während des Ladens ausgeführt werden soll. Die Routinen, 
; die in diesem Interrupt gesetzt sind, werden auch während des Laden ausgeführt,
; unabhängig davon, ob es von einer Diskette, einer Festplatte oder einer CD-ROM erfolgt.
; BITTE BEACHTEN SIE, DASS WIR DEN INTERRUPT COPER UND NICHT DEN VBLANK VERWENDEN.
; DER GRUND IST WÄHREND DES LADENS VON DER DISKETTE, INSBESONDERE UNTER KICK 1.3,
; INTERRUPT VERTB IST NICHT STABIL, so sehr, dass die Musik springen würde.
; Wenn wir stattdessen "$9c,$8010" auf unsere copperliste setzen, sind wir sicher
; dass diese Routine nur einmal pro Frame ausgeführt wird.
*****************************************************************************

myint6cLoad:
	btst.b	#4,$dff01f			; INTREQR - ist Bit 4, COPER zurückgesetzt?
	beq.s	nointL				; Wenn ja, ist es kein "echter" int COPER!
	move.w	#%10000,$dff09c		; Wenn nicht, ist es die richtige Zeit, lasst uns die Anforderung entfernen!
	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6
nointL:
	dc.w	$4ef9				; Hex-Wert von JMP
Crappyint:
	dc.l	0					; Adresse, zu der gesprungen werden soll, um zu automatisieren ...
								; ACHTUNG: Der selbstmodifizierende Code sollte  nicht
								; verwendet werden. Wie auch immer, wenn Sie einen 
								; ClearMyCache vorher und nachher aufrufen funktioniert es!

*****************************************************************************
; Routine, die das Betriebssystem mit Ausnahme der copperliste wiederherstellt.
; Stellen Sie außerdem unseren $6c-Interrupt ein, der dann zum System-Interrupt springt.
; Beachten Sie, dass der Interrupt während des Ladens vom int "COPER" verwaltet wird.
*****************************************************************************

PreparaLoad:
	LEA	$DFF000,A5				; CUSTOM Basisregister für Offsets
	MOVE.W	$2(A5),OLDDMAL		; alten Zustand speichern von DMACON
	MOVE.W	$1C(A5),OLDINTENAL	; alten Zustand speichern von INTENA
	MOVE.W	$1E(A5),OLDINTREQL	; alten Zustand speichern von INTREQ
	MOVE.L	#$80008000,d0		; die Maske der hohen Bits vorbereiten
	OR.L	d0,OLDDMAL			; Bit 15 der gespeicherten Werte setzen
	OR.W	d0,OLDINTREQL		; der Register, um sie zurückzustellen.

	bsr.w	ClearMyCache

	MOVE.L	#$7FFF7FFF,$9A(a5)	; Deaktivieren INTERRUPTS & INTREQS

	move.l	BaseVBR(PC),a0	     ; In a0 der Wert des VBR
	move.l	OldInt64(PC),$64(a0) ; Sys int liv1 gespeichert (softint,dskblk)
	move.l	OldInt68(PC),$68(a0) ; Sys int liv2 gespeichert (I/O,ciaa,int2)
	move.l	#myint6cLoad,$6c(a0) ; Int, das dann zu dem von sys springt. 
	move.l	OldInt70(PC),$70(a0) ; Sys int liv4 gespeichert (audio)
	move.l	OldInt74(PC),$74(a0) ; Sys int liv5 gespeichert (rbf,dsksync)
	move.l	OldInt78(PC),$78(a0) ; Sys int liv6 gespeichert (exter,ciab,inten)

	MOVE.W	#%1000001001010000,$96(A5) ; Blit und Disk aus Sicherheitsgründen aktivieren
	MOVE.W	OLDINTENA(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQ(PC),$9C(A5)	; INTREQ
	move.w	#$c010,$9a(a5)		; Wir müssen sicher sein, dass COPER
								; (interrupt über copperlist) ON ist!

	move.l	4.w,a6
	JSR	-$7e(A6)				; Enable
	JSR	-$8a(a6)				; Permit

	MOVE.L	GfxBase(PC),A6
	jsr	-$E4(A6)				; Warten Sie auf das Ende einer Blittata
	JSR	-$E4(A6)				; WaitBlit
	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem 
								; kann den Blitter jetzt wieder benutzen
	; (In Kick 1.3 wird es zum Laden von der Festplatte verwendet.)
	MOVE.L	4.w,A6
	SUBA.L	A1,A1				; NULL task - finde diese Aufgabe
	JSR	-$126(A6)				; findtask (Task(name) in a1, -> d0=task)
	MOVE.L	D0,A1				; Task in a1
	MOVEQ	#0,D0				; Priorität in d0 (-128, +127) - NORMAL
								; (Damit die Laufwerke atmen können)
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0=Priorität, a1=task)
	rts

OLDDMAL:
	dc.w	0
OLDINTENAL:						; alter Status INTENA
	dc.w	0
OLDINTREQL:						; alter Status INTREQ
	DC.W	0

*****************************************************************************
; Routine, die das Betriebssystem schließt und unseren Interrupt zurücksetzt
*****************************************************************************

DopoLoad:
	MOVE.L	4.w,A6
	SUBA.L	A1,A1				; NULL task - finde diese Aufgabe
	JSR	-$126(A6)				; findtask (Task(name) in a1, -> d0=task)
	MOVE.L	D0,A1				; Task in a1
	MOVEQ	#127,D0				; Priorität in d0 (-128, +127) - MAXIMUM
	JSR	-$12C(A6)				; _LVOSetTaskPri (d0=Priorität, a1=task)

	JSR	-$84(a6)				; Forbid
	JSR	-$78(A6)				; Disable

	MOVE.L	GfxBase(PC),A6
	jsr	-$1c8(a6)				; OwnBlitter, das gibt uns den exklusive Zugriff auf den Blitter
								; Verhinderung der Verwendung durch das Betriebssystem.
	jsr	-$E4(A6)				; WaitBlit - Wartet auf das Ende jeder Blittata
	JSR	-$E4(A6)				; WaitBlit

	bsr.w	ClearMyCache

	LEA	$dff000,a5				; CUSTOM Basisregister für Offsets
AspettaF:
	MOVE.L	4(a5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	#$1ff00,D0			; Wählen Sie nur die Bits der vertikalen Position
	CMP.L	#$12d00,D0			; Warten Sie auf die Zeile $12d, um dies zu vermeiden
	BEQ.S	AspettaF			; Das Ausschalten des DMA führt zum Flimmern

	MOVE.L	#$7FFF7FFF,$9A(A5)	; DEAKTIVIEREN INTERRUPTS & INTREQS

			; 5432109876543210
	MOVE.W	#%0000010101110000,d0	; DEAKTIVIEREN DMA

	btst	#8-8,olddmal		; test bitplane
	beq.s	NoPlanesA
	bclr.l	#8,d0				; planes nicht ausschalten
NoPlanesA:
	btst	#5,olddmal+2		; test sprite
	beq.s	NoSpritez
	bclr.l	#5,d0				; sprite nicht ausschalten
NoSpritez:
	MOVE.W	d0,$96(A5)			; DEAKTIVIEREN DMA

	move.l	BaseVBR(PC),a0		; In a0 der Wert des VBR
	move.l	#MioInt6c,$6c(a0)	; Ich lege meine Routine int. livello 3.
	MOVE.W	OLDDMAL(PC),$96(A5)	; Gibt den alten DMA-Status zurück
	MOVE.W	OLDINTENAL(PC),$9A(A5)	; INTENA STATUS
	MOVE.W	OLDINTREQL(PC),$9C(A5)	; INTREQ
	rts

*****************************************************************************
; Diese Routine wartet auf D1-Frames. Alle 50 Bilder vergehen 1 Sekunde.
;
; d1 = Anzahl der zu wartenden Frames
;
*****************************************************************************

AspettaBlanks:
	LEA	$DFF000,A5				; CUSTOM REG OFFSETS
WBLAN1xb:
	MOVE.w	#$80,D0
WBLAN1bxb:
	CMP.B	6(A5),D0			; vhposr
	BNE.S	WBLAN1bxb
WBLAN2xb:
	CMP.B	6(A5),D0			; vhposr
	Beq.S	WBLAN2xb
	DBRA	D1,WBLAN1xb
	rts

*****************************************************************************
;	Wiederholungsroutine der protracker/soundtracker/noisetracker
;
	include	"/Sources/music.s"
*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste	   bitplane
	dc.w	$e4,0,$e6,0			; zweite	  "
	dc.w	$e8,0,$ea,0			; dritte      "
	dc.w	$ec,0,$ee,0			; vierte      "
	dc.w	$f0,0,$f2,0			; fünfte      "
	dc.w	$f4,0,$f6,0			; sechste     "

	dc.w	$180,0				; Color0 schwarz


				 ;5432109876543210
	dc.w	$100,%0110101000000000	; bplcon0 - 320*256 HAM!

	dc.w	$180,$0000,$182,$134,$184,$531,$186,$443
	dc.w	$188,$0455,$18a,$664,$18c,$466,$18e,$973
	dc.w	$190,$0677,$192,$886,$194,$898,$196,$a96
	dc.w	$198,$0ca6,$19a,$9a9,$19c,$bb9,$19e,$dc9
	dc.w	$1a0,$0666

	dc.w	$9707,$FFFE			; wait Zeile $97

	dc.w	$100,$200			; BPLCON0 - keine bitplanes
	dc.w	$180,$00e			; color0 BLAU

	dc.w	$b907,$fffe			; WAIT - attendi linea $b9
BPLPOINTERS2:
	dc.w	$e0,0,$e2,0			; erste	   bitplane
	dc.w	$e4,0,$e6,0			; zweite	  "
	dc.w	$e8,0,$ea,0			; dritte      "
	dc.w	$ec,0,$ee,0			; vierte      "
	dc.w	$f0,0,$f2,0			; fünfte      "

	dc.w	$100,%0101001000000000	; BPLCON0 - 5 bitplanes LOWRES

; Die Palette, die in 2 Gruppen von 16 Farben "gedreht" wird.

cols:
	dc.w	$180,$040,$182,$050,$184,$060,$186,$080	; Grünton
	dc.w	$188,$090,$18a,$0b0,$18c,$0c0,$18e,$0e0
	dc.w	$190,$0f0,$192,$0d0,$194,$0c0,$196,$0a0
	dc.w	$198,$090,$19a,$070,$19c,$060,$19e,$040

	dc.w	$1a0,$029,$1a2,$02a,$1a4,$13b,$1a6,$24b	; Blauton
	dc.w	$1a8,$35c,$1aa,$36d,$1ac,$57e,$1ae,$68f
	dc.w	$1b0,$79f,$1b2,$68f,$1b4,$58e,$1b6,$37e
	dc.w	$1b8,$26d,$1ba,$15d,$1bc,$04c,$1be,$04c
cole:

	dc.w	$da07,$fffe			; WAIT - warte auf die Zeile $da
	dc.w	$100,$200			; BPLCON0 - deaktivieren bitplanes
	dc.w	$180,$00e			; color0 BLAU

	dc.w	$ff07,$fffe			; WAIT - warte auf die Zeile $ff
	dc.w	$9c,$8010			; INTREQ - Fordern Sie einen COPER-Interrupt an,
								; Musik spielen (auch während wir 
								; Laden mit der dos.library).

	dc.w	$FFFF,$FFFE			; Ende copperlist


*****************************************************************************
; 		DESIGN 320*34 zu 5 bitplanes (32 Farben)
*****************************************************************************

PICTURE2:
	incbin "/Sources/pic320x34x5.raw"


*****************************************************************************
;				MUSIK
*****************************************************************************

mt_data:
	dc.l	mt_data1

mt_data1:
	incbin	"/Sources/mod.fairlight"

******************************************************************************
; Puffer, in dem das Image über doslib von der Festplatte geladen wird
******************************************************************************

	section	mioplanaccio,bss_C

buffer:
LOGO:
	ds.b	6*40*176	; 6 bitplanes * 176 Zeilen * 40 bytes (HAM)

	end

In diesem Beispiel laden wir das Logo, das unmittelbar darüber erscheint. Wenn 
Sie es von der Diskette laden werden Sie feststellen, dass es plane für plane
in Stücken erscheint, die tatsächlich Stück für Stück geladen sind!
Es wäre besser, es in einen separaten Puffer zu laden, und nach dem Laden alles
zusammen anzuzeigen.
Das Grundlegende beim Laden ist, dass die wartende Zeit nach dem Laden, 
ausreichend ist, bevor Sie alles schließen. Sonst ist es das Ende!
Im Interrupt wird nicht die Farbroutine ausgeführt, sondern nur die
Musikroutine, zumindest merkt man die Zeit, die man "für die Sicherheit"
wartet. Da diese Zeit sowieso abgewartet werden sollte, wäre es klug, ein 
Verblassen oder eine zeitraubende Routine, die vorher etwas Nettes tut zu
machen. Schließe alles, zumindest hast du die Zeit gewartet, aber nicht ohne es
zu benutzen!

