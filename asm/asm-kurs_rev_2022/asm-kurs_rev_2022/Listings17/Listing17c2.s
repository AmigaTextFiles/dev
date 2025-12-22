
; Listing17c2.s = plasma2.s
; Plasma2.s	Plasma RGB 0-bitplanes
;		linke Taste zum Beenden

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA

WaitDisk	EQU	10

Largh_plasm	equ	40				; Plasmabreite ausgedrückt
								; als Anzahl der Gruppen von 8 Pixeln

BytesPerRiga	equ	(Largh_plasm+2)*4	; Anzahl der belegten Bytes
								; in der Copperliste von jeder Zeile
								; des Plasmas: jede 
								; Copper Anweisung belegt 4 Bytes

Alt_plasm	equ	190				; Plasmahöhe ausgedrückt
								; als Anzahl der Zeilen

NuovaColR	equ	-2				; Wert zum Index R in der SinTab zwischen
								; einer Farbe und der andere hinzugefügt
								; Es kann zum Erhalten verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovoFrameR	equ	8				; Wert vom Index R abgezogen
								; SinTab zwischen einem Frame und einem anderen
								; Es kann zum Erhalten verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovaColG	equ	2				; wie "NuovaColR", aber für Komponente G
NuovoFrameG	equ	2				; wie "NuovoFrameR" aber für Komponente G

NuovaColB	equ	4				; wie "NuovaColR" aber für Komponente B
NuovoFrameB	equ	-6				; wie "NuovoFrameR" aber für Komponente B


START:
	lea	$dff000,a5				; CUSTOM REGISTER in a5

	bsr	InitPlasma				; initialisiert die copperlist

; Initialisieren der Blitter-Register

	Btst	#6,2(a5)
WaitBlit_init:
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit_init

	move.l	#$4FFE8000,$40(a5)	; BLTCON0/1 - D=A+B+C
								; shift A = 4 pixel
								; shift B = 8 pixel
					
	moveq	#-1,d0				; D0 = $FFFFFFFF
	move.l	d0,$44(a5)			; BLTAFWM/BLTALWM

mod_A	set	0					; modulo Kanal A
mod_D	set	2					; modulo Kanal D: nächste Spalte

	move.l	#mod_A<<16+mod_D,$64(a5)	; Modulo-Register laden

; modulo Kanäle B und C = 0

	moveq	#0,d0
	move.l	d0,$60(a5)			; schreibt BLTBMOD und BLTCMOD


; Initialisierung andere Hardware Register

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST1,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.w	#$000,$180(a5)		; COLOR00 - schwarz
	move.w	#$0200,$100(a5)		; BPLCON0 - keine bitplanes aktiviert

mouse:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.s	ScambiaClists		; copperlist austauschen

	bsr.s	DoPlasma

	btst	#6,$bfe001			; Maus gedrückt?
	bne.w	mouse
	rts

;****************************************************************************
; Diese Routine realisiert den "double buffer" zwischen den copperlisten.
; In der Praxis beginnt es, wo es gezeichnet wird, und visualisiert
; es durch Kopieren der Adresse in COP1LC. Tauschen Sie die Variablen so aus,
; dass im folgenden frame auf der anderen copperlist gezeichnet wird. 
;****************************************************************************

ScambiaClists:
	move.l	draw_clist(pc),d0	; Adresse clist auf dem es geschrieben steht
	move.l	view_clist(pc),draw_clist	; austauschen clists
	move.l	d0,view_clist

	move.l	d0,$80(a5)			; kopiere die Adresse der copperlist
								; in COP1LC damit es
								; im nächsten Frame angezeigt wird 

	rts


;****************************************************************************
; Diese Routine initialisiert die copperliste, die das Plasma erzeugt. System
; WAIT Anweisungen und die erste Hälfte des COPPERMOVE. Am Ende der Zeile
; des Plasmas wird ein letzter COPPERMOVE eingefügt, der die Farbe 
; schwarz in COLOR00 lädt.
;****************************************************************************

InitPlasma:
	lea	Plasma1,a0				; Adresse plasma 1
	lea	Plasma2,a1				; Adresse plasma 2
	move.l	#$383dFFFE,d0		; Laden Sie die erste wait Anweisung in $38.
								; warte in Zeile $38 und in horizontaler
								; Position $3c
	move.w	#$180,d1			; setzt die erste Hälfte eines Befehls in D1
								; "copper move" in COLOR00 (=$dff180)

	move.w	#Alt_plasm-1,d3		; Schleife für jede Zeile
InitLoop1:
	move.l	d0,(a0)+			; schreibt das WAIT - (clist 1)
	move.l	d0,(a1)+			; schreibt das WAIT - (clist 2)
	add.l	#$01000000,d0		; Wait ändern, um in der
								; nächsten Zeile zu warten

	moveq	#Largh_plasm,d2		; loop über die gesamte Breite
								; von Plasma + einmal pro
								; der letzte "copper move" setzt
								; schwarz als Hintergrund zurück

InitLoop2:
	move.w	d1,(a0)+			; schreibt den ersten Teil des
								; "copper move" - clist 1
	addq.l	#2,a0				; Platz für den zweiten Teil
								; des "copper move" - clist 1

	move.w	d1,(a1)+			; schreibt den ersten Teil des
								; "copper move" - clist 2
	addq.l	#2,a1				; Platz für den zweiten Teil
								; des "copper move" - clist 2

	dbra	d2,InitLoop2

	dbra	d3,InitLoop1	
	rts


;****************************************************************************
; Diese Routine macht das Plasma. Es macht jeweils eine Schleife von Blitts
; bei denen es eine "Zeile" des Plasmas schreibt, das heißt, es schreibt die
; Farben in COPPERMOVES-Reihen aneinander.
; Ein RGB-Plasma wird hergestellt. Die 3 Komponenten werden separat gelesen
; und zusammen "ge-OR-ed". Für die 3 Komponenten wird jedoch nur eine einzige 
; Tabelle verwendet. Es wird von verschiedenen Positionen gelesen und mit
; unterschiedlichen Geschwindigkeiten zwischen einer Linie und einer anderen
; und zwischen einem Frame und einem anderen "gefahren". Auf diese Weise ist
; es wie mit 3 verschiedenen Tabellen.
; Die Tabelle enthält tatsächlich die Werte der R-Komponente. Bei den Werten
; der anderen Komponenten müssen die gelesenen Daten verschoben werden
; 4 nach rechts für G und 8 für B. Dies geschieht "on the fly" vom
; Blitter Shifter.
;****************************************************************************

DoPlasma:

	lea	Color,a0				; Adresse Farben
	lea	SinTab,a6				; Adresse Tabelle offsets
	move.l	draw_clist(pc),a1	; Adresse copperlist schreiben
	lea	22(a1),a1				; fügt Offset hinzu, das benötigt wird um
								; auf das erste Wort der ersten
								; Plasmalinie zu zeigen
								; (Sie müssen die 4 Anweisungen überspringen
								; die Start-of-Line-Wartezeit
								; und das erste Wort des "copper move")

; liest und ändert den Index der Komponente R

	move.w	IndiceR(pc),d4		; liest den Startindex vom
								; vorherigen Frame
	sub.w	#NuovoFrameR,d4		; den Index in der Tabelle
								; aus dem vorherigen Frame ändern
	and.w	#$00FF,d4			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d4,IndiceR			; speichert den Startindex für
								; das nächste Bild

; liest und ändert den Index der Komponente G

	move.w	IndiceG(pc),d5		; liest den Startindex vom
								; vorherigen Frame
	sub.w	#NuovoFrameG,d5		; den Index in der Tabelle
								; aus dem vorherigen Frame ändern
	and.w	#$00FF,d5			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d5,IndiceG			; speichert den Startindex für
								; das nächste Bild

; liest und ändert den Index der Komponente B

	move.w	IndiceB(pc),d6		; liest den Startindex vom
								; vorherigen Frame
	sub.w	#NuovoFrameB,d6		; den Index in der Tabelle
								; aus dem vorherigen Frame ändern
	and.w	#$00FF,d6			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d6,IndiceB			; speichert den Startindex für
								; das nächste Bild

	move.w	#Largh_plasm<<6+1,d3	; Größe blitt
								; Breite 1 word, Höhe gesamtes Plasma

	move.w	#Alt_plasm-1,d2		; Schleife für die ganze Höhe

PlasmaLoop:						; Anfang loop blitt

; Startadresse der Komponente R berechnen

	move.w	(a6,d4.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a2			; Startadresse = Adr. Farben
								; mehr Offset

; Startadresse der Komponente G berechnen

	move.w	(a6,d5.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a3			; Startadresse = Adr. Farben
								; mehr Offset

; Startadresse der Komponente B berechnen

	move.w	(a6,d6.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a4			; Startadresse = Adr. Farben
								; mehr Offset

	Btst	#6,2(a5)
WaitBlit:
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit

	move.l	a2,$48(a5)			; BLTCPT - Adresse Quelle R
								; (kopiert wie es ist)
	move.l	a3,$50(a5)			; BLTAPT - Adresse Quelle G
								; (wird um 4 nach rechts verschoben)
	move.l	a4,$4C(a5)			; BLTBPT - Adresse Quelle B
								; (ist 8 nach rechts verschoben)
	move.l	a1,$54(a5)			; BLTDPT - Adresse Ziel
	move.w	d3,$58(a5)			; BLTSIZE

	lea	BytesPerRiga(a1),a1		; zeigt auf die nächste Zeile von
								; "copper moves" in der copper list

; Ändern des Index der Komponente R für die nächste Spalte

	add.w	#NuovaColR,d4		; Ändern des Index in der Tabelle
								; für die nächste Farbe

	and.w	#$00FF,d4			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 Wörter)

; Ändern des Index der Komponente G für die nächste Spalte

	add.w	#NuovaColG,d5		; Ändern des Index in der Tabelle
								; für die nächste Farbe

	and.w	#$00FF,d5			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 Wörter)

; Ändern des Index der Komponente B für die nächste Spalte

	add.w	#NuovaColB,d6		; Ändern des Index in der Tabelle
								; für die nächste Farbe

	and.w	#$00FF,d6			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 Wörter)
	dbra	d2,PlasmaLoop
	rts


; Diese 2 Variablen enthalten die Adressen der 2 Copperlisten

view_clist:	dc.l	COPPERLIST1	; Adresse clist Visualisierung
draw_clist:	dc.l	COPPERLIST2	; Adresse clist Zeichnen


; Diese Variablen enthalten die Indexwerte für die erste Spalte

IndiceR:	dc.w	0
IndiceG:	dc.w	0
IndiceB:	dc.w	0

; Diese Tabelle enthält die Offsets für die Startadresse in der
; Farbtabelle

SinTab:
	DC.W	$000E,$0010,$0010,$0010,$0012,$0012,$0012,$0014,$0014,$0014
	DC.W	$0014,$0016,$0016,$0016,$0018,$0018,$0018,$0018,$001A,$001A
	DC.W	$001A,$001A,$001A,$001A,$001C,$001C,$001C,$001C,$001C,$001C
	DC.W	$001C,$001C,$001C,$001C,$001C,$001C,$001C,$001C,$001C,$001C
	DC.W	$001A,$001A,$001A,$001A,$001A,$001A,$0018,$0018,$0018,$0018
	DC.W	$0016,$0016,$0016,$0014,$0014,$0014,$0014,$0012,$0012,$0012
	DC.W	$0010,$0010,$0010,$000E,$000E,$000C,$000C,$000C,$000A,$000A
	DC.W	$000A,$0008,$0008,$0008,$0008,$0006,$0006,$0006,$0004,$0004
	DC.W	$0004,$0004,$0002,$0002,$0002,$0002,$0002,$0002,$0000,$0000
	DC.W	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	DC.W	$0000,$0000,$0000,$0000,$0002,$0002,$0002,$0002,$0002,$0002
	DC.W	$0004,$0004,$0004,$0004,$0006,$0006,$0006,$0008,$0008,$0008
	DC.W	$0008,$000A,$000A,$000A,$000C,$000C,$000C,$000C
EndSinTab:

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

; Wir haben 2 copperlisten 

COPPERLIST1:
	dc.w	$3007,$fffe			; warte auf Zeile $30
	dc.w	$0180,$c00			; color0
	dc.w	$3407,$fffe			; warte auf Zeile $34
	dc.w	$0180,$000			; color0

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

Plasma1:
	dcb.b	Alt_plasm*BytesPerRiga,0

	dc.w	$FA07,$fffe			; warte auf Zeile $FA
	dc.w	$0180,$c00			; color0
	dc.w	$FE07,$fffe			; warte auf Zeile $FE
	dc.w	$0180,$000			; color0

	dc.w	$FFFF,$FFFE			; Ende der copperlist

;****************************************************************************

COPPERLIST2:
	dc.w	$3007,$fffe			; warte auf Zeile $30
	dc.w	$0180,$c00			; color0
	dc.w	$3407,$fffe			; warte auf Zeile $34
	dc.w	$0180,$000			; color0

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

Plasma2:
	dcb.b	Alt_plasm*BytesPerRiga,0

	dc.w	$FA07,$fffe			; warte auf Zeile $FA
	dc.w	$0180,$c00			; color0
	dc.w	$FE07,$fffe			; warte auf Zeile $FE
	dc.w	$0180,$000			; color0

	dc.w	$FFFF,$FFFE			; Ende der copperlist


;****************************************************************************
; Hier ist die Tabelle, aus der die Farbkomponenten gelesen werden.
; Die Tabelle enthält die Komponenten R. Um die Komponenten G und B zu erhalten
; ist es ausreichend, die mit dem Blitter gelesenen Daten zu verschieben.
; Es müssen genügend Werte vorhanden sein, um unabhängig von der Start-Adresse
; gelesen werden zu können. In diesem Beispiel kann die Startadresse von der
; "Farbe" (erste Farbe) bis "Farbe + 28" (14. Farbe) abweichen, weil
; 60 der maximale Versatz ist, der in der "SinTab" enthalten ist.
; Wenn Width_plasm = 40 ist, bedeutet dies, dass jede Blittata 40 Werte liest.
; Insgesamt müssen also 54 Werte vorhanden sein.
;****************************************************************************

Color:
	dcb.w	2,0

	DC.W	$0100,$0300,$0500,$0600,$0800,$0A00,$0B00,$0C00,$0D00,$0E00
	DC.W	$0F00,$0F00,$0F00,$0F00,$0F00,$0E00,$0D00,$0C00,$0B00,$0A00
	DC.W	$0800,$0600,$0500,$0300,$0100

	dcb.w	2,0

	DC.W	$0100,$0300,$0500,$0600,$0800,$0A00,$0B00,$0C00,$0D00,$0E00
	DC.W	$0F00,$0F00,$0F00,$0F00,$0F00,$0E00,$0D00,$0C00,$0B00,$0A00
	DC.W	$0800,$0600,$0500,$0300,$0100

	end

;****************************************************************************

In diesem Beispiel sehen wir ein RGB-Plasma.
Angesichts der Größe des Plasmas und der Komplexität des Blitts (3-Kanal)
wäre es nicht möglich, die gesamte Copperliste vor dem Ende des vertical blank
zu ändern und folglich wird ein Teil der Copperliste zuerst angezeigt bevor es
geändert worden ist. Um das Problem zu lösen, müssen Sie das "double buffering"
von Copperlisten verwenden. Dies ist eine Technik, die wir bereits im Beispiel
lezione11i2.s gesehen haben: Es werden 2 Copperlisten verwendet, die
abwechselnd angezeigt werden. Während eine der 2 angezeigt wird, schreibt die
Plasma-Routine in die andere. Genau wie "double buffering" der Bitebenen. Der
Austausch der Copperlisten erfolgt routinemäßig durch "ScambiaClists".
Um das RGB-Plasma herzustellen, wird ein Blitt verwendet, der die separat
gelesenen R-, G- und B-Komponenten einer Farbe mit einer ODER-Operation
kombiniert. Um Speicherplatz zu sparen, wird nur eine Tabelle mit Komponenten
verwendet. Diese Tabelle enthält die Komponenten R. Um die Komponenten G und B
zu erhalten ist es ausreichend, die gelesenen Daten nach rechts zu verschieben,
eine Operation, die vom Blitter "on the fly" ausgeführt werden kann. Beachten
Sie jedoch, dass die Werte der Komponenten an verschiedenen Stellen aus der
Tabelle gelesen werden. In der Tat für jede Komponente haben wir einen Index,
der separat inkrementiert wird (und mit einer unterschiedlichen
Geschwindigkeit).
In diesem Plasma wird der Blitt anders als wies es in plasm1.s zu sehen war
"pro Zeile" auftreten. Jede Blittata, füllt eine Linie vom Plasma, während in
plasma1.s jede Blittata eine Spalte füllte.

