
; Listing17c6.s = plasma6.s
; Plasma6.s	Plasma RGB 4-Bitplanes und Welligkeit
; linke Taste zum Beenden

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

; Anzahl der Bytes, die in der Copperliste von jeder Zeile des Plasmas belegt sind:
; jeder Copperbefehl benötigt 4 Bytes. Jede Zeile besteht aus 1 WAIT, Width_plasm
; "Copper moves" für Plasma.

BytesPerRiga	equ	(Largh_plasm+1)*4

Alt_plasm	equ	190				; Plasmahöhe ausgedrückt
								; als Anzahl der Zeilen

NuovaRigaR	equ	-4				; Wert hinzufügen zum Index R in der
								; SinTab zwischen einer Zeile und einer anderen
								; Es kann zum Erhalten von verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovoFrameR	equ	16				; Wert abziehen vom Index R in der
								; SinTab zwischen einem Frame und einem anderen
								; Es kann zum Erhalten von verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovaRigaG	equ	-22				; wie "NuovaRigaR" aber für Komponente G
NuovoFrameG	equ	2				; wie "NuovoFrameR" aber für Komponente G

NuovaRigaB	equ	40				; wie "NuovaRigaR" aber für Komponente B
NuovoFrameB	equ	4				; wie "NuovoFrameR" aber für Komponente B

NuovaRigaO	equ	4				; wie "NuovaRigaR" aber für Oszillation
NuovoFrameO	equ	2				; wie "NuovoFrameR" aber für Oszillation


START:

; Zeiger bitplanes in copperlist

	LEA	COPPERLIST1,A1			; Zeiger COP 1
	LEA	COPPERLIST2,A2			; Zeiger COP 2
	MOVE.L	#BUFFER,d0			; Zeiger Puffer
	move.w	d0,6(a1)			; schreibt in copperlist 1 
	move.w	d0,6(a2)			; schreibt in copperlist 2
	swap	d0
	move.w	d0,2(a1)			; schreibt in copperlist 1
	move.w	d0,2(a2)			; schreibt in copperlist 2

; bitplane 2 - Teil 2 Byte später

	MOVE.L	#BUFFER+2,d0
	move.w	d0,6+8(a1)
	move.w	d0,6+8(a2)
	swap	d0
	move.w	d0,2+8(a1)
	move.w	d0,2+8(a2)

; bitplane 3 - Teil 2 Byte später

	MOVE.L	#BUFFER+2,d0
	move.w	d0,6+8*2(a1)
	move.w	d0,6+8*2(a2)
	swap	d0
	move.w	d0,2+8*2(a1)
	move.w	d0,2+8*2(a2)

; bitplane 4 - Teil 4 Byte später

	MOVE.L	#BUFFER+4,d0
	move.w	d0,6+8*3(a1)
	move.w	d0,6+8*3(a2)
	swap	d0
	move.w	d0,2+8*3(a1)
	move.w	d0,2+8*3(a2)

	lea	$dff000,a5				; CUSTOM REGISTER in a5

	bsr	InitPlasma				; initialisiert die copperlist

; Blitter Register initialisieren

	Btst	#6,2(a5)
WaitBlit_init:
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit_init

	moveq	#-1,d0				; D0 = $FFFFFFFF
	move.l	d0,$44(a5)			; BLTAFWM/BLTALWM

	move.w	#$8000,$42(a5)		; BLTCON1 - shift 8 pixel Kanal B
								; (verwendet für Plasma)

mod_A	set	0					; modulo Kanal A
mod_D	set	BytesPerRiga-2		; modulo Kanal D: geht zur nächsten Zeile

	move.l	#mod_A<<16+mod_D,$64(a5)	; Modulo Register laden

; modulo Kanäle B und C = 0

	moveq	#0,d0
	move.l	d0,$60(a5)			; schreibt BLTBMOD und BLTCMOD

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST1,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP

;  Hardware-Register initialisieren
; D0=0
	move.w	d0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.l	d0,$180(a5)			; COLOR00 und COLOR01 - schwarz
	move.w	#$30b8,$8e(a5)		; DiwStrt - Wir benutzen ein weiteres Fenster
								; kleiner Bildschirm zum Maskieren der
								; welligen Kanten.
	move.w	#$ee90,$90(a5)		; DiwStop

	move.w	#$0038,$92(a5)		; DDFStrt - sind geholt 40 bytes
	move.w	#$00d0,$94(a5)		; DDFStop
	move.w	d0,$104(a5)			; BPLCON2
	move.w	#$0080,$102(a5)		; BPLCON1 - sogar Ebenen werden verschoben
								; 8 Pixel nach rechts
	move.w	#4,$108(a5)			; BPL1MOD = 4 - 40 Bytes von 44 abrufen
	move.w	#4,$10a(a5)			; BPL2MOD = 4 - 40 Bytes von 44 abrufen
	move.w	#$4200,$100(a5)		; BPLCON0 - 4 bitplanes aktiv

mouse2:
	MOVE.L	#$1ff00,d1			; Bits durch UND auswählen
	MOVE.L	#$13000,d2			; warte auf Zeile $130 (304)
Waity2:	
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $130 (304)
	BNE.S	Waity2

	bsr	ScambiaClists			; copperlist austauschen

	bsr	DoOriz					; horizontaler Welleneffekt
	bsr	DoPlasma

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse2
	rts

;****************************************************************************
; Diese Routine erzeugt die Bitebenen, die den Swing-Effekt realisieren.
; Der Puffer bei "PlasmaLine" enthält eine Zeile der Figur.
; Dieser Puffer wird so oft in den Videopuffer kopiert, wie das Plasma hoch
; ist und bildet so die ganze Figur. Jede Zeile wird in Richtung rechts 
; um einen variablen Wert verschoben, wodurch die Welligkeit erzeugt wird.
;****************************************************************************

DoOriz:
	lea	OrizTab(pc),a0			; Adresse Tabelle Oszillation
	lea	BUFFER,a1				; Adresse video buffer (Ziel)
	lea	PlasmaLine,a3			; Adresse buffer der die Zeile
								; enthält (Quelle)

	move.w	#1*64+19,d2			; Größe blittata:
								; Breite 38 bytes
								; Höhe 1 Zeile

; liest und ändert den Index

	move.w	IndiceO(pc),d4		; liest den Startindex vom
								; vorheriger Rahmen
	sub.w	#NuovoFrameO,d4		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d4			; hält den Index im Bereich
								; 0 - 127 (Offset in einer Tabelle von
								; 128 Byte)
	move.w	d4,IndiceO			; speichert den Startindex für
								; den nächsten frame

	move.w	#Alt_plasm-1,d3		; Schleife für jede Zeile
OrizLoop:
	move.b	0(a0,d4.w),d0		; Oszillationswert ablesen

	moveq	#0,d1				; reinigt D1
	move.b	d0,d1				; Kopie Wert Oszillation
	and.w	#$000f,d0			; nur die unteren 4 Bits lassen
	ror.w	#4,d0				; auf die obersten Positionen verschieben
	or.w	#$09f0,d0			; zu schreibender Wertin BLTCON0

	asr.w	#4,d1			
	add.w	d1,d1				; Anzahl Bytes berechnen
	lea	(a1,d1.w),a2			; Adresse Quelle

	Btst	#6,2(a5)
WaitBlit_Oriz:
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit_Oriz

	move.w	d0,$40(a5)			; BLTCON0 - kopieren mit Shift von A nach D 
	move.l	a3,$50(a5)			; BLTAPT - Adresse Quelle
	move.l	a2,$54(a5)			; BLTDPT - Adresse Ziel
	move.w	d2,$58(a5)			; BLTSIZE

	lea	44(a1),a1				; zeigt auf die nächste Zeile
								; des Videopuffers

; Index für nächste Zeile bearbeiten

	add.w	#NuovaRigaO,d4		; Ändern des Index in der Tabelle
								; für die nächste Zeile

	and.w	#$00FF,d4			; hält den Index im Bereich
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
	move.l	#$303FFFFE,d0		; lädt die erste wait-Anweisung in D0.
								; warte auf Zeile $30 und Position
								; horizontal $3E

	move.w	#Alt_plasm-1,d3		; Schleife für jede Zeile
InitLoop1:

	move.l	d0,(a0)+			; schreibe WAIT - (clist 1)
	move.l	d0,(a1)+			; schreibe WAIT - (clist 2)
	add.l	#$01000000,d0		; Ändere das WAIT, um in
								; der folgenden Zeile zu warten

	moveq	#Largh_plasm/8-1,d2	; jede Iteration schreibt 8 copper moves

InitLoop2:

; copperlist 1

	move.w	#$0194,(a0)+		; Kamm 10
	addq.w	#2,a0				; Platz für den zweiten Teil
								; des "copper move"
	move.w	#$019a,(a0)+		; color 13
	addq.w	#2,a0
	move.w	#$018c,(a0)+		; color 6
	addq.w	#2,a0
	move.w	#$0196,(a0)+		; color 11
	addq.w	#2,a0
	move.w	#$018a,(a0)+		; color 5
	addq.w	#2,a0
	move.w	#$0184,(a0)+		; color 2
	addq.w	#2,a0
	move.w	#$0192,(a0)+		; color 9
	addq.w	#2,a0
	move.w	#$0188,(a0)+		; color 4
	addq.w	#2,a0

; copperlist 2

	move.w	#$0194,(a1)+		; color 10
	addq.w	#2,a1				; Platz für den zweiten Teil
								; des "copper move"
	move.w	#$019a,(a1)+		; color 13
	addq.w	#2,a1
	move.w	#$018c,(a1)+		; color 6
	addq.w	#2,a1
	move.w	#$0196,(a1)+		; colore 11
	addq.w	#2,a1
	move.w	#$018a,(a1)+		; color 5
	addq.w	#2,a1
	move.w	#$0184,(a1)+		; color 2
	addq.w	#2,a1
	move.w	#$0192,(a1)+		; color 9
	addq.w	#2,a1
	move.w	#$0188,(a1)+		; color 4
	addq.w	#2,a1
	dbra	d2,InitLoop2
	dbra	d3,InitLoop1
	rts


;****************************************************************************
; Diese Routine macht das Plasma. Es macht jeweils eine Schleife von Blitts
; bei denen es eine "Spalte" des Plasmas schreibt, das heißt, es schreibt
; die Farben in die COPPERMOVES-Spalte.
; Die in jeder Spalte geschriebenen Farben werden aus einer Tabelle gelesen,
; beginnend mit einer Adresse, die von einer Spalte zur anderen variiert,
; basierend auf Offsets die aus einer anderen Tabelle gelesen werden.
; Auch zwischen einem frame und einem anderen variieren die Offsets um
; den Effekt der Bewegung zu realisieren.
;****************************************************************************

DoPlasma:
	lea	Color,a0				; Adresse Farben
	lea	SinTab,a6				; Adresse Tabelle Offsets
	move.l	draw_clist(pc),a1	; Adresse copperlist schreiben
	lea	38(a1),a1				; Adresse des ersten Wortes der ersten
								; Plasmasäule
; liest und ändert den Index Komponente R

	move.w	IndiceR(pc),d4		; liest den Startindex vom
								; vorherigen frame
	sub.w	#NuovoFrameR,d4		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d4			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d4,IndiceR			; speichert den Startindex für
								; das nächste Bild
; liest und ändert den Index Komponente G

	move.w	IndiceG(pc),d5		; liest den Startindex vom
								; vorherigen frame
	sub.w	#NuovoFrameG,d5		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d5			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d5,IndiceG			; speichert den Startindex für
								; das nächste Bild
; liest und ändert den Index Komponente B

	move.w	IndiceB(pc),d6		; liest den Startindex vom
								; vorherigen frame
	sub.w	#NuovoFrameB,d6		; Ändern des Index in der Tabelle
								; aus dem vorherigen Frame
	and.w	#$00FF,d6			; hält den Index im Bereich
								; 0 - 255 (Offset in einer Tabelle von
								; 128 words)
	move.w	d6,IndiceB			; speichert den Startindex für
								; das nächste Bild

	move.w	#Alt_plasm<<6+1,d3	; Größe blitt
								; Breite 1 word, Höhe gesamtes Plasma

	moveq	#Largh_plasm-6-1,d2	; die Schleife wird NICHT über die Breite durchgehend
								; wiederholt. Die Spalten weiter
								; rechts sind nicht sichtbar
								
	Btst	#6,2(a5)			; initialisiert die Blitterregister
WaitBlit_Plasma:				; für plasma
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit_Plasma

	move.w	#$4FFE,$40(a5)		; BLTCON0 - D=A+B+C, shift A = 4 pixel

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
draw_clist:	dc.l	COPPERLIST2	; Adresse clist wo soll man zeichnen

; Diese Variable enthält den Wert des Index in der Tabelle von
; Oszillationen

IndiceO:	dc.w	0

; Diese Tabelle enthält die Werte der Schwingungnen

OrizTab:
	DC.B	$1C,$1D,$1E,$1E,$1F,$20,$20,$21,$22,$22,$23,$24,$24,$25,$25,$26
	DC.B	$27,$27,$28,$28,$29,$2A,$2A,$2B,$2B,$2C,$2C,$2D,$2D,$2E,$2E,$2F
	DC.B	$2F,$30,$30,$31,$31,$31,$32,$32,$33,$33,$33,$34,$34,$34,$35,$35
	DC.B	$35,$35,$36,$36,$36,$36,$36,$36,$37,$37,$37,$37,$37,$37,$37,$37
	DC.B	$37,$37,$37,$37,$37,$37,$37,$37,$36,$36,$36,$36,$36,$36,$35,$35
	DC.B	$35,$35,$34,$34,$34,$33,$33,$33,$32,$32,$31,$31,$31,$30,$30,$2F
	DC.B	$2F,$2E,$2E,$2D,$2D,$2C,$2C,$2B,$2B,$2A,$2A,$29,$28,$28,$27,$27
	DC.B	$26,$25,$25,$24,$24,$23,$22,$22,$21,$20,$20,$1F,$1E,$1E,$1D,$1C
	DC.B	$1C,$1B,$1A,$1A,$19,$18,$18,$17,$16,$16,$15,$14,$14,$13,$13,$12
	DC.B	$11,$11,$10,$10,$0F,$0E,$0E,$0D,$0D,$0C,$0C,$0B,$0B,$0A,$0A,$09
	DC.B	$09,$08,$08,$07,$07,$07,$06,$06,$05,$05,$05,$04,$04,$04,$03,$03
	DC.B	$03,$03,$02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01
	DC.B	$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$03,$03
	DC.B	$03,$03,$04,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07,$08,$08,$09
	DC.B	$09,$0A,$0A,$0B,$0B,$0C,$0C,$0D,$0D,$0E,$0E,$0F,$10,$10,$11,$11
	DC.B	$12,$13,$13,$14,$14,$15,$16,$16,$17,$18,$18,$19,$1A,$1A,$1B,$1C

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
	dc.w	$e0,$0000,$e2,$0000	; bitplane 1
	dc.w	$e4,$0000,$e6,$0000	; bitplane 2
	dc.w	$e8,$0000,$ea,$0000	; bitplane 3
	dc.w	$ec,$0000,$ee,$0000	; bitplane 4

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

Plasma1:
	dcb.b	Alt_plasm*BytesPerRiga,0
	dc.w	$FFFF,$FFFE			; Ende der copperlist

;****************************************************************************

COPPERLIST2:
	dc.w	$e0,$0000,$e2,$0000	; bitplane 1
	dc.w	$e4,$0000,$e6,$0000	; bitplane 2
	dc.w	$e8,$0000,$ea,$0000	; bitplane 3
	dc.w	$ec,$0000,$ee,$0000	; bitplane 4

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

Plasma2:
	dcb.b	Alt_plasm*BytesPerRiga,0

	dc.w	$FFFF,$FFFE			; Ende der copperlist


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

;****************************************************************************
; Puffer, das eine Bildzeile (44 Byte) enthält, die die Ebenen bildet.
; Das Bild wird erstellt, indem dieser Puffer so oft kopiert wird, wie das 
; Plasma im Videopuffer groß ist.
;****************************************************************************

PlasmaLine:
	rept	5
	dc.l	$00ff00ff,$ff00ff00
	endr
	dc.l	$00ff00ff

;****************************************************************************

	SECTION	PlasmaBit,BSS_C

; Platz für Bitplanes. Ein breites Bild wird für alle 4 Bitplanes verwendet
; 44 Bytes und so hoch wie das Plasma

BUFFER:
	ds.b	44*Alt_plasm

	end



;****************************************************************************

In diesem Beispiel zeigen wir ein 4-Bitplane-Plasma mit Amplitudenwelligkeit
gleich 56 Pixel.
Dazu verwenden wir 8 Farbregister im Plasma, die zyklisch geändert werden.
Dies bedeutet, dass ein Register einen konstanten Wert für 8 * 8 = 64 Pixel
enthält. So kann sich eine Gruppe von 8 Pixeln von 64-8 = 56 Pixel bewegen
und bleiben immer innerhalb des Bereichs, in dem die Farbe konstant bleibt.
Um solch große Wellenbewegungen zu erreichen, können wir den Hardware-Scroll
nicht verwenden. Daher können wir nicht dasselbe Bild für das gesamte Bild
verwenden, wo die Zeilen mit dem negativen Modulo wiederholt werden. Wir
brauchen ein vollständiges Bild, damit jede Zeile unabhängig von der
Anderen verschoben werden kann. Wir werden auf diese Weise vorankommen. Wir
haben einen Puffer, wo die Zeilen sind, die das Bild ausmachen. Der Inhalt
dieses Puffers wird in den Videopuffer kopiert, so oft es Zeilen gibt, aus
denen das Plasma besteht um das gewünschte Bild zeilenweise aufzubauen.
Jede Zeile wird passend verschoben, um die Wellenbewegung zu erreichen.
Wenn wir alle Zeilen aller Bitplanes kopieren müssten, müssten wir eine 
große Anzahl von Blittings ausführen. Um die Anzahl der Blittings zu
reduzieren, verwenden wir einen Aufbbau. Grundsätzlich verwenden wir für alle
Bitplanes das gleiche Bild.
Der Startpuffer erfolgt auf folgende Weise:

 dc.l	$00ff00ff,$ff00ff00,$00ff00ff,$ff00ff00 - - -

Sobald wir es in den Videopuffer kopiert haben, zeigen wir auf die erste
Bitebene am Anfang des Videopuffers das zweite und dritte 2 Byte nach dem
Start des Videopuffers und das vierte, 4 Byte nach dem Start des Videopuffers.
Außerdem verschieben wir die geraden Bitplanes um 8 Pixel.

Zusammenfassung:
bitplane 1 verweist auf BUFFER
bitplane 2 verweist auf BUFFER+2 + Verschiebung um 8 Pixel nach rechts
bitplane 3 verweist auf BUFFER+2
bitplane 4 verweist auf BUFFER+4 + Verschiebung um 8 Pixel nach rechts

Die Ebenen überlappen sich und erzeugen 8 Farben:

bitplane 1: dc.l $00ff00ffff00ff0000 ff00ffff00ff0000 ff00ffff00ff0000
bitplane 2: dc.l $--00ffff00ff0000ff 00ffff00ff0000ff 00ffff00ff0000
bitplane 3: dc.l $00ffff00ff0000ff00 ffff00ff0000ff00 ffff00ff0000
bitplane 4: dc.l $--ff00ff0000ff00ff ff00ff0000ff00ff ff00ff0000
                   | | | | | | | | |  | | | | | | | |
Farbe             --  06  05  09  10   06  05  09  10
					  13  11  02  04   13  11  02  04

wie Sie sehen, erzeugt es eine zyklische Wiederholung von 8 Farben, die 
in der Copperliste verwendet werden, um das Plasma zu erzeugen.
Auf diese Weise haben wir nur ein Bild, das für alle 4 Ebenen verwendet wird
und dann kopieren wir dieses einzelne Bild. Wir kopieren 4 Bitebenen mit
einem Wisch und es beschleunigt die Wirkung enorm.
Kommen wir nun zu den technischen Details. Jede Bitebene ist 40 Byte breit.
Weil Bitebene 4 4 Bytes nach Bitebene 1 beginnt, muss sie auch 4 Byte später
enden. Aufgrund dieser Tatsache ist der Videopuffer (der alle 4 Bitebenen
enthält) 44 Byte breit, sodass die BPLxMOD-Register einen Wert von 4 haben.
Außerdem ist das Bild aufgrund der Bitebenenverschiebungen nicht rechteckig,
sondern es hat wellige Kanten. Ebenfalls am linken Rand ist die Übereinstimmung
der Bitebenen nicht perfekt. Um die Kantenfehler nicht zu zeigen, haben wir das
Videofenster mit DIWSTRT- und DIWSTOP-Registern verengt. Wenn Sie sehen wollen
was an den Rändern passiert, verbreitern sie es.
Aufgrund dieser Verengung sind die Spalten ganz rechts des Plasmas nicht
zu sehen und deshalb ist es sinnlos, sie zu blitten (die weiter links auch, 
wenn nicht können Sie sehen, dass sie eine blitt-Einheit sein sollten, weil
das Band, in dem eine Farbe konstant bleibt teilweise sichtbar ist).

