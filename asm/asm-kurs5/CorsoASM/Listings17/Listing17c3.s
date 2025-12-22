; Listing17c3.s = plasma3.s
; Plasma3.s	Plasma RGB mit 0-bitplanes
;		rechte Taste zum Aktivieren der Welligkeit, linke Taste zum Beenden

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA

WaitDisk	EQU	10

Largh_plasm	equ	48				; Plasmabreite ausgedrückt
								; als Anzahl der Gruppen von 8 Pixeln
								; das Plasma ist größer als der Bildschirm

BytesPerRiga	equ	(Largh_plasm+2)*4	; Anzahl der belegten Bytes
								; in der Copperliste von jeder Zeile
								; des Plasmas: jede 
								; Copper Anweisung belegt 4 Bytes

Alt_plasm	equ	190				; Plasmahöhe ausgedrückt
								; als Anzahl der Zeilen

NuovaRigaR	equ	4				; Wert hinzufügen zum Index in der
								; SinTab zwischen einer Zeile und einer anderen
								; Es kann zum Erhalten von verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovoFrameR	equ	6				; Wert abiehen vom Index R in der
								; SinTab zwischen einem Frame und einem anderen
								; Es kann zum Erhalten von verschiedenen Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovaRigaG	equ	2				; wie "NuovaRigaR" aber für Komponente G
NuovoFrameG	equ	8				; wie "NuovoFrameR" aber für Komponente G

NuovaRigaB	equ	8				; wie "NuovaRigaR" aber für Komponente B
NuovoFrameB	equ	4				; wie "NuovoFrameR" aber für Komponente B

NuovaRigaO	equ	4				; wie "NuovaRigaR" aber für Oszillation
NuovoFrameO	equ	2				; wie "NuovoFrameR" aber für Oszillation


START:
	lea	$dff000,a5				; CUSTOM REGISTER in a5

	bsr	InitPlasma				; initialisiert die copperlist

; Blitter Register initialisieren

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
mod_D	set	BytesPerRiga-2		; modulo Kanal D: geht zur nächsten Zeile

	move.l	#mod_A<<16+mod_D,$64(a5)	; Modulo-Register laden

; modulo Kanäle B und C = 0

	moveq	#0,d0
	move.l	d0,$60(a5)			; schreibt BLTBMOD und BLTCMOD

; Hardware-Register initialisieren

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#Copperlist1,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.w	#$000,$180(a5)		; COLOR00 - schwarz
	move.w	#$0200,$100(a5)		; BPLCON0 - keine bitplanes aktiviert

; erste Schleife: ohne horizontalen Schwung

mouse1:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr	ScambiaClists			; copperlist austauschen

	bsr	DoPlasma				; routine plasma

	btst	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse1

; zweite Schleife: mit horizontalem Schwung

mouse2:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity2

	bsr	ScambiaClists			; copperlist austauschen

	bsr	DoOriz					; horizontaler Swing-Effekt
	bsr	DoPlasma

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse2

	rts

;****************************************************************************
; Diese Routine realisiert den horizontalen Schwingeffekt.
; Der Effekt wird durch Ändern der horizontalen Position auf jeder Linie erreicht
; des Beginns des Plasmas, das ist die horizontale Position des beginnenden WAIT
; der Linie. Die Positionswerte werden aus einer Tabelle gelesen.
;****************************************************************************

DoOriz:
	lea	OrizTab(pc),a0			; Adresse Tabelle Oszillation
	move.l	draw_clist(pc),a1	; Adresse copperlist schreiben
	addq.w	#1,a1				; Adresse zweites Byte des ersten
								; Wortes des Waits
; liest und ändert den Index

	move.w	IndiceO(pc),d4		; liest den Startindex vom
								; vorherigen frame
	sub.w	#NuovoFrameO,d4		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$007F,d4			; hält den Index im Bereich
								; 0 - 127 (Offset in einer Tabelle von
								; 128 Byte)
	move.w	d4,IndiceO			; speichert den Startindex für
								; den nächsten frame

	move.w	#Alt_plasm-1,d3		; Schleife für jede Reihe
OrizLoop:
	move.b	0(a0,d4.w),d0		; Oszillationswert ablesen
	or.b	#$01,d0				; Bit 0 auf 1 setzen (notwendig
								; für WAIT-Anweisung)
	move.b	d0,(a1)				; schreibt die horizontale Position
								; von WAIT in der copperliste

	lea	BytesPerRiga(a1),a1		; zeigt auf die nächste Zeile
								; in der copperliste
; Index für nächste Zeile bearbeiten

	add.w	#NuovaRigaO,d4		; Ändern Sie den Index in der Tabelle
								; für die nächste Zeile

	and.w	#$007F,d4			; hält den Index im Bereich
								; 0 - 127 (Offset in einer Tabelle von
								; 128 Byte)
	dbra	d3,OrizLoop
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
; WAIT-Anweisungen und die erste Hälfte der COPPERMOVE. Am Ende der Zeile
; des Plasmas wird ein letzter COPPERMOVE eingefügt, der die Farbe 
; schwarz in COLOR00 lädt.
;****************************************************************************

InitPlasma:
	lea	Copperlist1,a0			; Adresse copperlist 1
	lea	Copperlist2,a1			; Adresse copperlist 2
	move.l	#$3025FFFE,d0		; lädt die erste wait-Anweisung in D0.
								; warte auf Zeile $30 und Position
								; horizontal $24
	move.w	#$180,d1			; setzt die erste Hälfte einer Anweisung in D1
								; "copper move" in COLOR00 (= $dff180)

	move.w	#Alt_plasm-1,d3		; Schleife für jede Zeile
InitLoop1:
	move.l	d0,(a0)+			; schreibt das WAIT - (clist 1)
	move.l	d0,(a1)+			; schreibt das WAIT - (clist 2)
	add.l	#$01000000,d0		; WAIT ändern, um in
								; der folgenden Zeile zu warten

	moveq	#Largh_plasm,d2		; Schleife über die gesamte Breite
								; von Plasma + einmal pro
								; der letzte "copper move" setzt
								; schwarz als Hintergrund zurück

InitLoop2:
	move.w	d1,(a0)+			; schreibt den ersten Teil des
								; "copper move" - clist 1
	addq.w	#2,a0				; Platz für den zweiten Teil
								; des "copper move" - clist 1

	move.w	d1,(a1)+			; schreibt den ersten Teil des
								; "copper move" - clist 2
	addq.w	#2,a1				; Platz für den zweiten Teil
								; des "copper move" - clist 2

	dbra	d2,InitLoop2
	dbra	d3,InitLoop1
	rts

;****************************************************************************
; Diese Routine macht das Plasma. Es macht jeweils eine Schleife von Blitts
; bei denen es eine "Zeile" des Plasmas schreibt, das heißt, es schreibt
; die Farben in die COPPERMOVES-Spalte.
; Die in jeder Spalte geschriebenen Farben werden aus einer Tabelle gelesen,
; beginnend mit einer Adresse, die von einer Spalte zur anderen variiert,
; basierend auf Offsets aus einer anderen Tabelle lesen.
; Auch zwischen einem frame und einem anderen variieren die Offsets um
; den Effekt der Bewegung zu realisieren.
;****************************************************************************

DoPlasma:
	lea	Color,a0				; Adresse Farben
	lea	SinTab,a6				; Adresse Tabelle offsets
	move.l	draw_clist(pc),a1	; Adresse copperlist schreiben
	addq.w	#6,a1				; Adresse erstes Wort der ersten
								; Plasmasäule
; liest und ändert den Index der Komponente R

	move.w	IndiceR(pc),d4		; liest den Startindex vom
								; vorherigen frame
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

	move.w	#Alt_plasm<<6+1,d3	; Größe blitt
								; Breite 1 word, Höhe gesamtes Plasma

	moveq	#Largh_plasm-1,d2	; Schleife über die gesamte Breite
PlasmaLoop:						; Startschleife blitt

; Startadresse der Komponente R berechnen

	move.w	(a6,d4.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a2			; Startadresse = Farben
								; mehr Offset
; Startadresse der Komponente G berechnen

	move.w	(a6,d5.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a3			; Startadresse = Farben
								; mehr Offset
; Startadresse der Komponente B berechnen

	move.w	(a6,d6.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a4			; Startadresse = Farben
								; mehr Offset
	Btst	#6,2(a5)
WaitBlit:
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit

	move.l	a2,$48(a5)			; BLTCPT - Adresse Quelle R
	move.l	a3,$50(a5)			; BLTAPT - Adresse Quelle G
	move.l	a4,$4C(a5)			; BLTBPT - Adresse Quelle B
	move.l	a1,$54(a5)			; BLTDPT - Adresse Ziel
	move.w	d3,$58(a5)			; BLTSIZE

	addq.w	#4,a1				; zeigt auf die nächste Spalte von
								; "copper moves" in der copperliste
; Ändern Index Komponente R für die nächste Zeile

	add.w	#NuovaRigaR,d4		; Ändern des Index in der Tabelle
								; für die nächste Zeile

	and.w	#$00FF,d4			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 Wörter)
; Ändern Index Komponente G für die nächste Zeile

	add.w	#NuovaRigaG,d5		; Ändern des Index in der Tabelle
								; für die nächste Zeile
	
	and.w	#$00FF,d5			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 Wörter)

; Ändern Index Komponente B für die nächste Zeile

	add.w	#NuovaRigaB,d6		; Ändern des Index in der Tabelle
								; für die nächste Zeile

	and.w	#$00FF,d6			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 Wörter)
	dbra	d2,PlasmaLoop
	rts


; Diese 2 Variablen enthalten die Adressen der 2 copperlisten

view_clist:	dc.l	Copperlist1	; Adresse clist Visualisierung
draw_clist:	dc.l	Copperlist2	; Adresse clist Zeichnen

; Diese Variable enthält den Wert des Index in der Tabelle von
; Schwingungen (horizontale Positionen der WAITs)

IndiceO:	dc.w	0

; Diese Tabelle enthält die Werte der Schwingungen (horizontale Positionen
; von WAIT)

OrizTab:
	DC.B	$2C,$2C,$2C,$2E,$2E,$2E,$2E,$2E,$30,$30,$30,$30,$30,$30,$32,$32
	DC.B	$32,$32,$32,$32,$32,$32,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34
	DC.B	$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$32,$32,$32,$32,$32,$32
	DC.B	$32,$32,$30,$30,$30,$30,$30,$30,$2E,$2E,$2E,$2E,$2E,$2C,$2C,$2C
	DC.B	$2C,$2C,$2C,$2A,$2A,$2A,$2A,$2A,$28,$28,$28,$28,$28,$28,$26,$26
	DC.B	$26,$26,$26,$26,$26,$26,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
	DC.B	$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$26,$26,$26,$26,$26,$26
	DC.B	$26,$26,$28,$28,$28,$28,$28,$28,$2A,$2A,$2A,$2A,$2A,$2C,$2C,$2C

; Diese Variablen enthalten die Indexwerte für die erste Spalte

IndiceR:	dc.w	0
IndiceG:	dc.w	0
IndiceB:	dc.w	0

; Diese Tabelle enthält die Offsets für die Startadresse in der
; Farbtabelle

SinTab:
	DC.W	$0034,$0036,$0038,$003A,$003C,$0040,$0042,$0044,$0046,$0048
	DC.W	$004A,$004C,$004E,$0050,$0052,$0054,$0056,$0058,$005A,$005A
	DC.W	$005C,$005E,$005E,$0060,$0060,$0062,$0062,$0062,$0064,$0064
	DC.W	$0064,$0064,$0064,$0064,$0064,$0064,$0062,$0062,$0062,$0060
	DC.W	$0060,$005E,$005E,$005C,$005A,$005A,$0058,$0056,$0054,$0052
	DC.W	$0050,$004E,$004C,$004A,$0048,$0046,$0044,$0042,$0040,$003C
	DC.W	$003A,$0038,$0036,$0034,$0030,$002E,$002C,$002A,$0028,$0024
	DC.W	$0022,$0020,$001E,$001C,$001A,$0018,$0016,$0014,$0012,$0010
	DC.W	$000E,$000C,$000A,$000A,$0008,$0006,$0006,$0004,$0004,$0002
	DC.W	$0002,$0002,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	DC.W	$0002,$0002,$0002,$0004,$0004,$0006,$0006,$0008,$000A,$000A
	DC.W	$000C,$000E,$0010,$0012,$0014,$0016,$0018,$001A,$001C,$001E
	DC.W	$0020,$0022,$0024,$0028,$002A,$002C,$002E,$0030
EndSinTab:

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

; Wir haben 2 copperlists 

Copperlist1:

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

	dcb.b	Alt_plasm*BytesPerRiga,0
	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

Copperlist2:

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

	dcb.b	Alt_plasm*BytesPerRiga,0

	dc.w	$FFFF,$FFFE			; Ende copperlist


;****************************************************************************
; Hier ist die Farbtabelle, die in das Plasma geschrieben wird.
; Es müssen genügend Farben vorhanden sein, um die Adresse des Starts
; lesen zu können. In diesem Beispiel kann die Startadresse von 
; der "Farbe" (erste Farbe) bis "Farbe + 100" (50. Farbe) abweichen, weil
; 100 der maximale Offset ist, der in der "SinTab" enthalten ist.
; Wenn Alt_plasm = 190 ist, bedeutet dies, dass jeder Blitt 190 Farben liest.
; Insgesamt müssen also 240 Farben vorhanden sein.
;****************************************************************************

Color:
	dc.w	$0f00,$0f00,$0e00,$0e00,$0e00,$0d00,$0d00,$0d00
	dc.w	$0c00,$0c00,$0c00,$0b00,$0b00,$0b00,$0a00,$0a00,$0a00
	dc.w	$0900,$0900,$0900,$0800,$0800,$0800,$0700,$0700,$0700
	dc.w	$0600,$0600,$0600,$0500,$0500,$0500,$0400,$0400,$0400
	dc.w	$0300,$0300,$0300,$0200,$0200,$0200,$0100,$0100,$0100
	dcb.w	18,0
	dc.w	$0100,$0100,$0100,$0100,$0200,$0200,$0200,$0200
	dc.w	$0300,$0300,$0300,$0300,$0400,$0400,$0400,$0400
	dc.w	$0500,$0500,$0500,$0500,$0600,$0600,$0600,$0600
	dc.w	$0700,$0700,$0700,$0700,$0800,$0800,$0800,$0800
	dc.w	$0900,$0900,$0900,$0900,$0a00,$0a00,$0a00,$0a00
	dc.w	$0b00,$0b00,$0b00,$0b00,$0c00,$0c00,$0c00,$0c00
	dc.w	$0d00,$0d00,$0d00,$0d00,$0e00,$0e00,$0e00,$0e00
	dc.w	$0f00,$0f00,$0f00,$0f00

	dc.w	$0f00,$0f00,$0f00,$0f00,$0e00,$0e00,$0e00,$0e00
	dc.w	$0d00,$0d00,$0d00,$0d00,$0c00,$0c00,$0c00,$0c00
	dc.w	$0b00,$0b00,$0b00,$0b00,$0a00,$0a00,$0a00,$0a00
	dc.w	$0900,$0900,$0900,$0800,$0800,$0800,$0800
	dc.w	$0700,$0700,$0700,$0700,$0600,$0600,$0600,$0600
	dc.w	$0500,$0500,$0500,$0500,$0400,$0400,$0400,$0400
	dc.w	$0300,$0300,$0300,$0300,$0200,$0200,$0200,$0200
	dc.w	$0100,$0100,$0100
	dcb.w	18,0
	dc.w	$0100,$0100,$0100,$0200,$0200,$0200,$0300,$0300,$0300
	dc.w	$0400,$0400,$0400,$0500,$0500,$0500,$0600,$0600,$0600
	dc.w	$0700,$0700,$0700,$0800,$0800,$0900,$0900,$0900
	dc.w	$0a00,$0a00,$0a00,$0b00,$0b00,$0b00,$0c00,$0c00,$0c00
	dc.w	$0d00,$0d00,$0d00,$0e00,$0e00,$0e00,$0f00

	end

;****************************************************************************

In diesem Beispiel wird ein RGB-Plasma pro Spalte hergestellt (d.h. die Farben)
werden spaltenweise in die Copperliste eingefügt (geblittet), zu der wir eine
horizontale Schwingung hinzufügen. Bei Ausführen des Programms ist der
Schwingeffekt nicht aktiv. Durch Drücken der rechten Taste wird es aktiviert.
Um die Schwingung zu realisieren, benötigt man ein Plasma, das größer als der
Bildschirm ist, wodurch es nur teilweise sichtbar ist. Durch Variation der
Startposition von jeder Zeile (dh die horizontale Position des WAIT am Anfang
der Zeile), können Sie verschiedene Bereiche des Plasmas zeigen. Im Programm
ist jeder Zeile eine andere Startposition zugeordnet, die aus einer Sinus-
Tabelle gelesen wird. Das Lesen von der Tabelle erfolgt auf die gleiche Weise
wie für Tabellen der Komponenten R, G, B. 
Die Indizes, denen sie ausgesetzt sind, können durch Änderung der Parameter 
die am Anfang des Listings stehen, variiert werden. Dieser Effekt hat eine
gute visuelle Wiedergabe bei den "NewRigaX" -Parametern der Komponenten
R, G, B niedrige Werte annehmen. Durch Erhöhen dieser Werte (zB 20) Die
Grenzen dieses Effekts sind hervorgehoben. Speziell die horizontale Welligkeit
erfolgt in Schritten von 4 Pixeln, der minimalen Auflösung des WAITs. Wir
werden später sehen, wie man weniger gezackte Wellen erreicht.

