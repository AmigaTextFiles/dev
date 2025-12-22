; Listing17c4.s = plasma4.s
; Plasma4.s	Plasma RGB zu 1-Bitplanes und Ripple
; linke Taste zum Beenden

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup2.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA

WaitDisk	EQU	10

Largh_plasm	equ	38				; Plasmabreite ausgedrückt
								; als Anzahl der Gruppen von 8 Pixeln

; Anzahl der von jeder Plasmazeile belegten Bytes in der copperliste:
; Der copperbefehl benötigt 4 Bytes. Jede Reihe besteht aus 1 "copper move" in
; BPLCON1, 1 WAIT, Width_plasm "copper move" für Plasma (einschließlich
; letzter "copper move" in COLOR00, um den Hintergrund schwarz zu machen.

BytesPerRiga	equ	(Largh_plasm+2)*4

Alt_plasm	equ	190				; Plasmahöhe ausgedrückt
								; als Anzahl der Zeilen

NuovaRigaR	equ	-24				; Wert hinzufügen zum Index R in der
								; SinTab zwischen einer Zeile und einer anderen
								; Es kann zum Erhalten von verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovoFrameR	equ	6				; Wert abziehen vom Index R in der
								; SinTab zwischen einem Frame und einem anderen
								; Es kann zum Erhalten von verschiedenen Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovaRigaG	equ	12				; wie "NuovaRigaR" aber für Komponente G
NuovoFrameG	equ	8				; wie "NuovoFrameR" aber für Komponente G

NuovaRigaB	equ	18				; wie "NuovaRigaR" aber für Komponente B
NuovoFrameB	equ	4				; wie "NuovoFrameR" aber für Komponente B

NuovaRigaO	equ	8				; wie "NuovaRigaR" aber für Oszillation
NuovoFrameO	equ	2				; wie "NuovoFrameR" aber für Oszillation


START:

;	Zeiger Bild in copperlist

	MOVE.L	#BITPLANE,d0		; Zeiger
	LEA	COPPERLIST1,A1			; Zeiger COP 1
	LEA	COPPERLIST2,A2			; Zeiger COP 2
	move.w	d0,6(a1)			; schreibt in copperlist 1 
	move.w	d0,6(a2)			; schreibt in copperlist 2
	swap	d0
	move.w	d0,2(a1)			; schreibt in copperlist 1
	move.w	d0,2(a2)			; schreibt in copperlist 2
		
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

	move.l	#mod_A<<16+mod_D,$64(a5)	; Modulo Register laden

; modulo Kanäle B und C = 0

	moveq	#0,d0
	move.l	d0,$60(a5)			; schreibt in BLTBMOD und BLTCMOD

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST1,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP

; Hardware-Register initialisieren
; D0=0
	move.w	d0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.l	d0,$180(a5)			; COLOR00 und COLOR01 - schwarz
	move.w	#$3e90,$8e(a5)		; DiwStrt - Wir benutzen ein weiteres Fenster
								; kleiner Bildschirm
	move.w	#$fcb1,$90(a5)		; DiwStop
	move.w	#$0036,$92(a5)		; DDFStrt - 40 Bytes werden geholt
	move.w	#$00ce,$94(a5)		; DDFStop
	move.l	d0,$102(a5)			; BPLCON1/2
	move.w	#-40,$108(a5)		; BPL1MOD = -40 wiederholt sich immer gleich
								; Linie
	move.w	#$1200,$100(a5)		; BPLCON0 - 1 bitplane attivo

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
; Der Effekt wird durch die Änderung des Hardware-Scroll-Werts in jeder Zeile
; der Bitebene 1 erreicht. Die Werte werden aus einer Tabelle gelesen und in
; die copperliste geschrieben.
;****************************************************************************

DoOriz:
	lea	OrizTab(pc),a0			; Adresse Tabelle Oszillation
	move.l	draw_clist(pc),a1	; Adresse copperlist schreiben
	lea	11(a1),a1				; Adresse zweites Byte des zweiten
								; Wortes des "copper moves" in BPLCON1
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

	move.w	#Alt_plasm-1,d3		; Schleife für jede Zeile
OrizLoop:
	move.b	0(a0,d4.w),d0		; Oszillationswert ablesen

	move.b	d0,(a1)				; schreibt den Scroll-Wert in den
								; "copper move" in BPLCON1

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
; Diese Routine initialisiert die Copperliste, die das Plasma erzeugt. System
; WAIT-Anweisungen und die erste Hälfte der COPPERMOVE.
;****************************************************************************

InitPlasma:
	lea	Plasma1,a0				; Adresse plasma 1
	lea	Plasma2,a1				; Adresse plasma 2
	move.l	#$3e43FFFE,d0		; lädt die erste wait-Anweisung in D0.
								; warte auf Zeile $3e und Position
								; horizontal $42
	move.w	#$180,d1			; setzt die erste Hälfte einer Anweisung in D1
								; "copper move" in COLOR00 (=$dff180)
	move.w	#$182,d4			; setzt die erste Hälfte einer Anweisung in D4 
								; "copper move" in COLOR01 (=$dff182)
	move.w	#$102,d5			; setzt die erste Hälfte einer Anweisung in D5
								; "copper move" in BPLCON1 (=$dff102)

	move.w	#Alt_plasm-1,d3		; Schleife für jede Zeile
InitLoop1:
	move.w	d5,(a0)+			; schreibt den ersten Teil des
								; "copper move" in BPLCON1 - clist 1
	addq.w	#2,a0				; Platz für den zweiten Teil
								; des "copper move" - clist 1

	move.w	d5,(a1)+			; schreibt den ersten Teil des
								; "copper move" in BPLCON1 - clist 2
	addq.w	#2,a1				; Platz für den zweiten Teil
								; des "copper move" - clist 2

	move.l	d0,(a0)+			; schreibe WAIT - (clist 1)
	move.l	d0,(a1)+			; schreibe WAIT - (clist 2)
	add.l	#$01000000,d0		; Ändere das WAIT, um in
								; der folgenden Zeile zu warten

	moveq	#Largh_plasm/2-1,d2	; Schleife über die gesamte Breite
								; des plasmas + 2 "copper moves"
								; das schwarz zurückbringt in COLOR00/01
InitLoop2:
	move.w	d4,(a0)+			; schreibt den ersten Teil des
								; "copper move" in COLOR00 - clist 1
	addq.w	#2,a0				; Platz für den zweiten Teil
								; des "copper move" - clist 1

	move.w	d4,(a1)+			; schreibt den ersten Teil des
								; "copper move" in COLOR00 - clist 2
	addq.w	#2,a1				; Platz für den zweiten Teil
								; des "copper move" - clist 2

	move.w	d1,(a0)+			; schreibt den ersten Teil des
								; "copper move" in COLOR01 - clist 1
	addq.w	#2,a0				; Platz für den zweiten Teil
								; des "copper move" - clist 1

	move.w	d1,(a1)+			; schreibt den ersten Teil des
								; "copper move" in COLOR01 - clist 2
	addq.w	#2,a1				; Platz für den zweiten Teil
								; des "copper move" - clist 2
	dbra	d2,InitLoop2
	dbra	d3,InitLoop1
	rts

;****************************************************************************
; Diese Routine macht das Plasma. Es macht jeweils eine Schleife von Blitts
; bei denen es eine "Spalte" des Plasmas schreibt, das heißt, es schreibt
; die Farben in die COPPERMOVES-Spalte.
; Die in jeder Spalte geschriebenen Farben werden aus einer Tabelle gelesen,
; beginnend mit einer Adresse, die von einer Spalte zur anderen variiert,
; basierend auf Offsets aus einer anderen Tabelle lesen.
; Auch zwischen einem frame und einem anderen variieren die Offsets um
; den Effekt der Bewegung zu realisieren.
;****************************************************************************

DoPlasma:
	lea	Color,a0				; Adresse Farben
	lea	SinTab,a6				; Adresse Tabelle Offsets
	move.l	draw_clist(pc),a1	; Adresse copperlist schreiben
	lea	18(a1),a1				; Adresse erstes Wort des ersten
								; Plasmasäule
; liest und ändert den Index der Komponente R

	move.w	IndiceR(pc),d4		; liest den Startindex vom
								; vorherigen frame
	sub.w	#NuovoFrameR,d4		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d4			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d4,IndiceR			; speichert den Startindex für
								; das nächste Bild
; liest und ändert den Index der Komponente G

	move.w	IndiceG(pc),d5		; liest den Startindex vom
								; vorherigen Frame
	sub.w	#NuovoFrameG,d5		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d5			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d5,IndiceG			; speichert den Startindex für
								; das nächste Bild
; liest und ändert den Index der Komponente B

	move.w	IndiceB(pc),d6		; liest den Startindex vom
								; vorherigen Frame
	sub.w	#NuovoFrameB,d6		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d6			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d6,IndiceB			; speichert den Startindex für
								; das nächste Bild

	move.w	#Alt_plasm<<6+1,d3	; Größe blitt
								; Breite 1 word, Höhe gesamtes Plasma

	moveq	#Largh_plasm-2,d2	; die Schleife wird NICHT über die Breite durchgehend
								; wiederholt. Die letzten 2 Spalten
								; werden in Ruhe gelassen, damit
								; wird die Farbe schwarz in die
								; Register COLOR01 und COLOR00 geschrieben 

PlasmaLoop:						; Startschleife blitt

; Berechnung der Startadresse der Komponente R

	move.w	(a6,d4.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a2			; Startadresse = Farben
								; mehr Offset

; Berechnung der Startadresse der Komponente G

	move.w	(a6,d5.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a3			; Startadresse = Farben
								; mehr Offset

; Berechnung der Startadresse der Komponente B

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

view_clist:	dc.l	COPPERLIST1	; Adresse clist Visualisierung
draw_clist:	dc.l	COPPERLIST2	; Adresse clist Zeichnen

; Diese Variable enthält den Wert des Index in der Tabelle von
; Schwingungen (horizontale Positionen der WAITs)

IndiceO:	dc.w	0

; Diese Tabelle enthält die Werte der Schwingungen (Scrollwerte)

OrizTab:
	DC.B	$03,$03,$03,$03,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05
	DC.B	$05,$05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
	DC.B	$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$05,$05,$05,$05
	DC.B	$05,$05,$05,$05,$05,$05,$04,$04,$04,$04,$04,$04,$04,$03,$03,$03
	DC.B	$03,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$01
	DC.B	$01,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	DC.B	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01
	DC.B	$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$03,$03,$03

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

COPPERLIST1:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

Plasma1:
	dcb.b	Alt_plasm*BytesPerRiga,0
	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

COPPERLIST2:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

Plasma2:
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

; Bildzeile, die mit dem BPLMOD1 wiederholt wird
; es besteht aus 40 Bytes alternativ zu 0 oder $FF

BITPLANE:	dcb.w	20,$00FF

	end


;****************************************************************************

In diesem Beispiel zeigen wir ein 1-Bitplane-Plasma mit einer Schwingung, die
durch den Hardware-Scroll realisiert wird.
Es wird eine vertikal gestreifte Bitebene verwendet, wie in der Theorie
erklärt. Da alle Zeilen der Bitebene gleich ausgefallen wären, haben wir
nur eine gespeichert, die mit dem Trick des negativen Modulos wiederholt wird.
Das Bild ist 40 Byte breit. Aber es wird nicht alles angezeigt um das
Hardware-Scrollen zu ermöglichen. Wir verwenden dann ein schmaleres "display
window" als üblich, auch um einige Defekte der Plasmas an den Kanten zu
maskieren. Die Werte der Register DDFSTRT, DDFSTOP, DIWSTRT und DIWSTOP sind
daher ein wenig anders als üblich und wurden durch Versuch und Irrtum gefunden.
Um den Ripple-Effekt zu erzielen, wird der Wert in jeder Zeile per Hardware-
Scroll variiert. Die Werte werden wie gewohnt aus einer Tabelle gelesen.
Die copperliste für jede Plasmalinie hat einen "copper move" in BPLCON1
(um den Scroll-Wert zu schreiben), gefolgt von einem WAIT zum Synchronisieren
mit dem Start des Bitplane-Fetch, und schließlich gibt es die "copper moves"
des Plasmas, dessen Ziel alternativ COLOR01 und COLOR00 ist.
Der erste "copper move" jeder Zeile ist in COLOR01 und beginnt 8 Pixel vor dem
Starten der Anzeige des Bildes. Dies liegt daran, dass dieser "copper move"
verwendet wird, um die Farbe der Pixel zu bestimmen, die vom rechten Rand des
Bildschirms durch den Hardware-Scroll kommen. Wenn diese Pixel auf 1 gesetzt
sind, ist es notwendig, in COLOR01 zu schreiben. Der nächste "copper move" in
COLOR00 ist am Anfang des Videofensters ausgerichtet. Dann folgen einander
abwechselnd andere "copper moves" in COLOR01 und COLOR00. Die Routine
"DoPlasma" schreibt eine Spalte auf einmal, mit Ausnahme der letzten 2, die
verwendet werden, um schwarz wieder in die 2 Farbregister einzufügen.

