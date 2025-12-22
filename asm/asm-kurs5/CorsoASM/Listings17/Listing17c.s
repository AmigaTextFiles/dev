; Listing17c.s = plasma1.s
; Plasma1.s	Plasma 0-bitplanes
;		linke Taste zum Beenden

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	incdir ""
	include	"startup2.s"		; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA

WaitDisk	EQU	10

Largh_plasm	equ	30				; Plasmabreite ausgedrückt
								; als Anzahl der Gruppen von 8 Pixeln

BytesPerRiga	equ	(Largh_plasm+2)*4	; Anzahl der belegten Bytes
								; in der Copperliste von jeder Zeile
								; des Plasmas: jede 
								; Copper Anweisung belegt 4 Bytes

Alt_plasm	equ	100				; Plasmahöhe ausgedrückt
								; als Anzahl der Zeilen

NuovaRiga	equ	4				; Wert hinzufügen zum Index in der
								; SinTab zwischen einer Zeile und einer anderen
								; Es kann zum Erhalten von verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

NuovoFrame	equ	6				; Wert abziehen vom Index in der
								; SinTab zwischen einem Frame und einem anderen
								; Es kann zum Erhalten von verschiedener Plasmen 
								; variiert werden, aber es MUSS IMMER GERADE SEIN !!

START:
	lea	$dff000,a5				; CUSTOM REGISTER in a5

	bsr.s	InitPlasma			; initialisiert die copperlist

; Initialisieren der Blitter-Register

	Btst	#6,2(a5)
WaitBlit_init:
	Btst	#6,2(a5)			; auf den blitter warten
	bne.s	WaitBlit_init

	move.l	#$09f00000,$40(a5)	; BLTCON0/1 - Kopie normal
	moveq	#-1,d0				; D0 = $FFFFFFFF
	move.l	d0,$44(a5)			; BLTAFWM/BLTALWM

mod_A	set	0					; modulo Kanal A
mod_D	set	BytesPerRiga-2		; modulo Kanal D: geht zur nächsten Zeile
	move.l	#mod_A<<16+mod_D,$64(a5)	; modulo Register laden

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

; Initialisieren der anderen Hardwareregister

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

	bsr	DoPlasma

	btst	#6,$bfe001			; Maus gedrückt?
	bne.w	mouse

	rts

;****************************************************************************
; Diese Routine initialisiert die copperliste, die das Plasma erzeugt. System
; WAIT Anweisungen und die erste Hälfte des COPPERMOVE. Am Ende der Zeile
; des Plasmas wird ein letzter COPPERMOVE eingefügt, der die Farbe
; schwarz in COLOR00 lädt.
;****************************************************************************

InitPlasma:
	lea	PLASMA,a0				; Adresse plasma
	move.l	#$6051FFFE,d0		; lädt die erste wait-Anweisung in D0.
								; warte in Zeile $60 und in horizontaler 
								; Position $50
	move.w	#$180,d1			; setzt die erste Hälfte einer Anweisung in D1
								; "copper move" in COLOR00 (=$dff180)

	moveq	#Alt_plasm-1,d3		; Schleife für jede Zeile
InitLoop1:
	move.l	d0,(a0)+			; schreibt die WAIT
	add.l	#$01000000,d0		; Wait ändern, um in der
								; nächsten Zeile zu warten

	moveq	#Largh_plasm,d2		; Schleifen über die gesamte Breite
								; von Plasma + einmal pro
								; der letzte "copper move" setzt
								; schwarz als Hintergrund zurück

InitLoop2:
	move.w	d1,(a0)+			; schreibt den ersten Teil des
								; "copper move"
	addq.l	#2,a0				; Platz für den zweiten Teil
								; des "copper move"
								; (dann gefüllt durch routine DoPlasma)

	dbra	d2,InitLoop2

	dbra	d3,InitLoop1
	
	rts


;****************************************************************************
; Diese Routine macht das Plasma. Sie macht jeweils eine Schleife von Blitts
; bei denen es eine "Spalte" des Plasmas schreibt, das heißt, es schreibt
; die Farben in die COPPERMOVES-Spalte.
; Die Farben die in jede Spalte geschrieben werden, werden aus einer Tabelle
; gelesen; beginnend mit einer Adresse, die je nach Versatz von Spalte zu Spalte
; variiert basierend auf einen Offset, der aus einer anderen Tabelle gelesen wird.
; Weiterhin variieren die Offsets zwischen einem Frame und einem anderen
; um den Effekt der Bewegung zu realisieren.
;****************************************************************************

DoPlasma:
	lea	Color,a0				; Adresse Farbe
	lea	SinTab,a3				; Adresse Tabelle offsets
	lea	PLASMA+6,a1				; Adresse erstes word der ersten
								; Spalte des Plasmas

	move.w	Indice(pc),d0		; liest den Startindex vom
								; vorherigen Frame
	sub.w	#NuovoFrame,d0		; den Index in der Tabelle
								; aus dem vorherigen Frame ändern 
	and.w	#$00FF,d0			; hält den Index im Bereich
								; 0 - 255 (Versatz in einer Tabelle von
								; 128 Wörter)
	move.w	d0,Indice			; speichert den Startindex für
								; das nächste Bild

	move.w	#Alt_plasm<<6+1,d3	; Größe blittata
								; Breite 1 word, Höhe gesamtes Plasma

	moveq	#Largh_plasm-1,d2	; Schleifen über die gesamte Breite
PlasmaLoop:						; Anfang loop blittata

	move.w	(a3,d0.w),d1		; liest Offset aus der Tabelle

	lea	(a0,d1.w),a2			; Startadresse = Adr. Farben
								; mehr Offset

	Btst	#6,2(a5)
WaitBlit:
	Btst	#6,2(a5)			; auf den blitter warten 
	bne.s	WaitBlit

	move.l	a2,$50(a5)			; BLTAPT - Adresse Quelle
	move.l	a1,$54(a5)			; BLTDPT - Adresse Ziel
	move.w	d3,$58(a5)			; BLTSIZE

	addq.w	#4,a1				; zeigt auf die nächste Spalte von
								; "copper moves" in der copper list

	add.w	#NuovaRiga,d0		; den Index in der Tabelle
								; für die nächste Zeile ändern 

	and.w	#$00FF,d0			; hält den Index im Bereich
								; 0 - 255 (offset in einer Tabelle mit
								; 128 words)
	
	dbra	d2,PlasmaLoop
	rts


; Diese Variable enthält den Indexwert für die erste Spalte

Indice:	dc.w	0

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

COPPERLIST:

	dc.w	$4007,$fffe			; warte auf Zeile $40
	dc.w	$0180,$c00			; color0
	dc.w	$4407,$fffe			; warte auf Zeile $44
	dc.w	$0180,$000			; color0

; Hier bleibt etwas Platz für das Stück Copperliste, dass das Plasma erzeugt.
; Dieser Raum wird von den Routinen die den Effekt erstellen ausgefüllt.

PLASMA:
	dcb.b	Alt_plasm*BytesPerRiga,0

	dc.w	$e007,$fffe			; warte auf Zeile $e0
	dc.w	$0180,$c00			; color0
	dc.w	$e407,$fffe			; warte auf Zeile $e4
	dc.w	$0180,$000			; color0

	dc.w	$FFFF,$FFFE			; Ende der copperlist


;****************************************************************************
; Hier ist die Farbtabelle, die in das Plasma geschrieben wird.
; Es müssen genügend Farben vorhanden sein, um die Adresse des Starts
; lesen zu können. In diesem Beispiel kann die Startadresse von 
; der "Farbe" (erste Farbe) bis "Farbe + 100" (50. Farbe) abweichen, weil
; 100 der maximale Offset ist, der in der "SinTab" enthalten ist.
; Wenn Alt_plasm = 100 ist, bedeutet dies, dass jeder Blitt 100 Farben liest.
; Insgesamt müssen also 150 Farben vorhanden sein.
;****************************************************************************

Color:
	dc.w	$100,$200,$300,$400,$500,$600,$700
	dc.w	$800,$900,$A00,$B00,$C00,$D00,$E00,$F00

	dc.w	$F00,$E00,$D00,$C00,$B00,$A00,$900,$800
	dc.w	$700,$600,$500,$400,$300,$200

	dc.w	$002,$003,$004,$005,$006,$007
	dc.w	$008,$009,$00A,$00B,$00C,$00D,$00E,$00F

	dc.w $00e,$01d,$02d,$03d,$04d,$05d,$06d,$07d,$08d,$09d	; Blau Grün
	dc.w $0Ad,$0Bd,$0Cd,$0Dd,$0Ed,$0Fd,$0Fd,$0Ed,$0Dd,$0Cd
	dc.w $0Bd,$0Ad,$09d,$08d,$07d,$06d,$05d,$04d,$03d,$02d
	dc.w $01d,$00e

	dc.w $00e,$01d,$02c,$03b,$04a,$059,$068,$077,$086,$095	; Blau Grün
	dc.w $0A4,$0B3,$0C2,$0D1,$0E0


	dc.w	$0F0,$0E0,$0D0,$0C0,$0B0,$0A0,$090,$080
	dc.w	$070,$060,$050,$040,$030,$020,$010

	dc.w	$010,$020,$030,$040,$050,$060,$070
	dc.w	$080,$090,$0A0,$0B0,$0C0,$0D0,$0E0,$0F0

	dc.w	$1F0,$2F0,$3F0,$4F0,$5F0,$6F0,$7F0,$8F0
	dc.w	$9F0,$AF0,$BF0,$CF0,$DF0,$EF0,$FF0

	dc.w	$FF0,$EE0,$DD0,$CC0,$BB0,$AA0,$990,$880
	dc.w	$770,$660,$550,$440,$330,$220,$110

	end

;****************************************************************************

In diesem Beispiel haben wir eine Plasma-0-Bitebene.
Der Effekt basiert auf einer copperliste, die von der Routine "InitPlasma"
erstellt wird. Das Stück funktioniert so: Für jede Zeile auf dem Bildschirm
werden eine Reihe von "copper moves" ausgeführt, die den Wert von COLOR00
ändern. Der letzte "copper move" setzt den Wert von $000 (schwarz) wieder in
COLOR00. Dadurch wird eine rechteckige Tabelle mit "copper moves" erstellt.
Die Anzahl der "copper moves" die in jeder Zeile vorhanden sind (mit Ausnahme
der letzten, welche den Hintergrund auf schwarz setzt) entspricht dem Wert des
Parameters "Width_plasm". Die Anzahl der Zeilen, die das Plasma bilden, 
entspricht dem Parameter "Alt_plasm". Insgesamt haben wir also eine Reihe von
"copper moves" (immer ohne diejenigen, die schwarz ersetzen) gleich
Width_plasm * Alt_plasm. Die Routine "InitPlasma" schreibt keine Farben
die durch diese "copper moves" geladen würden (dh es werden nicht die zweiten
Wörter geschrieben).
Diese Aufgabe bleibt der Routine "DoPlasma" überlassen, die in jedem frame
ausgeführt wird, und die jedes Mal unterschiedliche Werte in die zweiten Wörter
von "copper move" schreibt. Das Schreiben erfolgt über eine Blitter Schleife.
Jede Blittata füllt eine "Spalte" mit "copper moves". Zum Beispiel die erste 
Blittata schreibt jeweils das zweite Wort der ersten "copper moves" von jeder 
Zeile. Die Farbwerte werden aus einer Tabelle gelesen. Bei jeder Iteration
werden die Farben von einer anderen Position aus der Tabelle gelesen. Auch
zwischen einem Frame und einem anderen wird die Startposition geändert. Alle
Variationen der Position erfolgen auf der Grundlage von Tabellen und können
durch Einwirken auf die 2 Parameter "NuovaRiga" und "NuovoFrame"variiert
werden. Beachten Sie, dass die Routine durch die Initialisierung aller 
Register des Blitters zu Beginn des Programms optimiert wurde.

