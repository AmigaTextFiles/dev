
; Lezione10u1.s	Linie in Bewegung
		; linke Taste zum Beenden

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	bsr.w	InitLine	; initialisiert line-mode

	move.w	#$ffff,d0	; durchgehende Linie
	bsr.w	SetPattern	; definiert pattern

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2	; Warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $12c
	BNE.S	Waity1

	bsr.w	CancellaSchermo	; Reinigen Sie den Bildschirm

	bsr.s	MuoviPunti	; Ändere die Koordinaten der Punkte

; Zeichne die Linie

	move.w	CoordX1(pc),d0	; lies die Koordinaten der Punkte
	move.w	CoordY1(pc),d1
	move.w	CoordX2(pc),d2
	move.w	CoordY2(pc),d3
	lea	bitplane,a0
	bsr.w	Drawline

	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.w	mouse
	rts

;***************************************************************************
; Diese Routine liest die Koordinaten der verschiedenen Punkte aus Tabellen
; und speichert sie in den entsprechenden Variablen.
; Das Lesen von den Tabellen erfolgt durch die indirekte Adressierung mit
; Index. Um die Tabellen zu verschieben, ändern wir die Indizes (das sind
; Wörter) anstelle von Zeigern (Langwörter). Das erlaubt uns zu vermeiden
; mit einem einfachen AND aus dem Tabelle zu kommen. 
; Der Index liegt im Bereich 0 - 512 (tatsächlich sind die Tabellen 
; aus 256 Wörtern (512 Bytes) zusammengesetzt.
;***************************************************************************

;	  @..@
;	 (----)
;	( >__< )
;	^^ ~~ ^^

MuoviPunti:
	lea	TabX(pc),a0

; Koordinate X1

	move.w	indiceX1(pc),d0		; Index der vorherigen Koordinate
	add.w	addX1(pc),d0		; Ändern Sie den Index des Punktes
								; der neuen Koordinate
	and.w	#$1FF,d0			; behalte den Index in der Tabelle
	move.w	d0,indiceX1			; speichert den Index
	move.w	0(a0,d0.w),d1		; lies die Koordinate aus der Tabelle
	move.w	d1,CoordX1			; kopiere die Koordinate in die Variable

; Koordinate X2

	move.w	indiceX2(pc),d0		; Index der vorherigen Koordinate
	add.w	addX2(pc),d0		; Ändern Sie den Index des Punktes
								; der neuen Koordinate
	and.w	#$1FF,d0			; behalte den Index in der Tabelle								
	move.w	d0,indiceX2			; speichert den Index
	move.w	0(a0,d0.w),d1		; lies die Koordinate aus der Tabelle
	move.w	d1,CoordX2			; kopiere die Koordinate in die Variable

	lea	TabY(pc),a0

; Koordinate Y1

	move.w	indiceY1(pc),d0		; Index der vorherigen Koordinate
	add.w	addY1(pc),d0		; Ändern Sie den Index des Punktes
								; der neuen Koordinate
	and.w	#$1FF,d0			; behalte den Index in der Tabelle						
	move.w	d0,indiceY1			; speichert den Index
	move.w	0(a0,d0.w),d1		; lies die Koordinate aus der Tabelle
	move.w	d1,CoordY1			; kopiere die Koordinate in die Variable

; Koordinate Y2

	move.w	indiceY2(pc),d0		; Index der vorherigen Koordinate
	add.w	addY2(pc),d0		; Ändern Sie den Index des Punktes
								; der neuen Koordinate
	and.w	#$1FF,d0			; behalte den Index in der Tabelle								
	move.w	d0,indiceY2			; speichert den Index
	move.w	0(a0,d0.w),d1		; lies die Koordinate aus der Tabelle
	move.w	d1,CoordY2			; kopiere die Koordinate in die Variable
	
	rts


; Diese Tabelle enthält die X-Koordinaten

TabX:
	DC.W	$00A2,$00A6,$00A9,$00AD,$00B1,$00B4,$00B8,$00BB,$00BF,$00C3
	DC.W	$00C6,$00CA,$00CD,$00D1,$00D4,$00D8,$00DB,$00DE,$00E2,$00E5
	DC.W	$00E8,$00EC,$00EF,$00F2,$00F5,$00F8,$00FB,$00FE,$0101,$0103
	DC.W	$0106,$0109,$010B,$010E,$0110,$0113,$0115,$0117,$011A,$011C
	DC.W	$011E,$0120,$0122,$0123,$0125,$0127,$0128,$012A,$012B,$012D
	DC.W	$012E,$012F,$0130,$0131,$0132,$0133,$0133,$0134,$0135,$0135
	DC.W	$0135,$0136,$0136,$0136,$0136,$0136,$0136,$0135,$0135,$0135
	DC.W	$0134,$0133,$0133,$0132,$0131,$0130,$012F,$012E,$012D,$012B
	DC.W	$012A,$0128,$0127,$0125,$0123,$0122,$0120,$011E,$011C,$011A
	DC.W	$0117,$0115,$0113,$0110,$010E,$010B,$0109,$0106,$0103,$0101
	DC.W	$00FE,$00FB,$00F8,$00F5,$00F2,$00EF,$00EC,$00E8,$00E5,$00E2
	DC.W	$00DE,$00DB,$00D8,$00D4,$00D1,$00CD,$00CA,$00C6,$00C3,$00BF
	DC.W	$00BB,$00B8,$00B4,$00B1,$00AD,$00A9,$00A6,$00A2,$009E,$009A
	DC.W	$0097,$0093,$008F,$008C,$0088,$0085,$0081,$007D,$007A,$0076
	DC.W	$0073,$006F,$006C,$0068,$0065,$0062,$005E,$005B,$0058,$0054
	DC.W	$0051,$004E,$004B,$0048,$0045,$0042,$003F,$003D,$003A,$0037
	DC.W	$0035,$0032,$0030,$002D,$002B,$0029,$0026,$0024,$0022,$0020
	DC.W	$001E,$001D,$001B,$0019,$0018,$0016,$0015,$0013,$0012,$0011
	DC.W	$0010,$000F,$000E,$000D,$000D,$000C,$000B,$000B,$000B,$000A
	DC.W	$000A,$000A,$000A,$000A,$000A,$000B,$000B,$000B,$000C,$000D
	DC.W	$000D,$000E,$000F,$0010,$0011,$0012,$0013,$0015,$0016,$0018
	DC.W	$0019,$001B,$001D,$001E,$0020,$0022,$0024,$0026,$0029,$002B
	DC.W	$002D,$0030,$0032,$0035,$0037,$003A,$003D,$003F,$0042,$0045
	DC.W	$0048,$004B,$004E,$0051,$0054,$0058,$005B,$005E,$0062,$0065
	DC.W	$0068,$006C,$006F,$0073,$0076,$007A,$007D,$0081,$0085,$0088
	DC.W	$008C,$008F,$0093,$0097,$009A,$009E

; Diese Tabelle enthält die Y-Koordinaten

TabY:
	DC.W	$0080,$0083,$0086,$0088,$008B,$008E,$0090,$0093,$0096,$0098
	DC.W	$009B,$009E,$00A0,$00A3,$00A5,$00A8,$00AA,$00AD,$00AF,$00B2
	DC.W	$00B4,$00B6,$00B9,$00BB,$00BD,$00BF,$00C2,$00C4,$00C6,$00C8
	DC.W	$00CA,$00CC,$00CE,$00D0,$00D1,$00D3,$00D5,$00D7,$00D8,$00DA
	DC.W	$00DB,$00DD,$00DE,$00DF,$00E1,$00E2,$00E3,$00E4,$00E5,$00E6
	DC.W	$00E7,$00E8,$00E9,$00E9,$00EA,$00EB,$00EB,$00EC,$00EC,$00EC
	DC.W	$00ED,$00ED,$00ED,$00ED,$00ED,$00ED,$00ED,$00ED,$00EC,$00EC
	DC.W	$00EC,$00EB,$00EB,$00EA,$00E9,$00E9,$00E8,$00E7,$00E6,$00E5
	DC.W	$00E4,$00E3,$00E2,$00E1,$00DF,$00DE,$00DD,$00DB,$00DA,$00D8
	DC.W	$00D7,$00D5,$00D3,$00D1,$00D0,$00CE,$00CC,$00CA,$00C8,$00C6
	DC.W	$00C4,$00C2,$00BF,$00BD,$00BB,$00B9,$00B6,$00B4,$00B2,$00AF
	DC.W	$00AD,$00AA,$00A8,$00A5,$00A3,$00A0,$009E,$009B,$0098,$0096
	DC.W	$0093,$0090,$008E,$008B,$0088,$0086,$0083,$0080,$007E,$007B
	DC.W	$0078,$0076,$0073,$0070,$006E,$006B,$0068,$0066,$0063,$0060
	DC.W	$005E,$005B,$0059,$0056,$0054,$0051,$004F,$004C,$004A,$0048
	DC.W	$0045,$0043,$0041,$003F,$003C,$003A,$0038,$0036,$0034,$0032
	DC.W	$0030,$002E,$002D,$002B,$0029,$0027,$0026,$0024,$0023,$0021
	DC.W	$0020,$001F,$001D,$001C,$001B,$001A,$0019,$0018,$0017,$0016
	DC.W	$0015,$0015,$0014,$0013,$0013,$0012,$0012,$0012,$0011,$0011
	DC.W	$0011,$0011,$0011,$0011,$0011,$0011,$0012,$0012,$0012,$0013
	DC.W	$0013,$0014,$0015,$0015,$0016,$0017,$0018,$0019,$001A,$001B
	DC.W	$001C,$001D,$001F,$0020,$0021,$0023,$0024,$0026,$0027,$0029
	DC.W	$002B,$002D,$002E,$0030,$0032,$0034,$0036,$0038,$003A,$003C
	DC.W	$003F,$0041,$0043,$0045,$0048,$004A,$004C,$004F,$0051,$0054
	DC.W	$0056,$0059,$005B,$005E,$0060,$0063,$0066,$0068,$006B,$006E
	DC.W	$0070,$0073,$0076,$0078,$007B,$007E


; Hier werden die Koordinaten der Eckpunkte der Linie jedes Mal gespeichert

CoordX1:	dc.w	0
CoordY1:	dc.w	0
CoordX2:	dc.w	0
CoordY2:	dc.w	0

; Hier werden die Indizes innerhalb der Tabelle für jede Koordinate gespeichert

IndiceX1:	dc.w	10
IndiceY1:	dc.w	20
IndiceX2:	dc.w	30
IndiceY2:	dc.w	0

; Hier werden die jeweils hinzuzufügenden Werte für jede Koordinate gespeichert
; wiederum zu den Tabellenindizes

addX1:	dc.w	-2
addY1:	dc.w	2
addX2:	dc.w	4
addY2:	dc.w	6

;******************************************************************************
; Diese Routine zeichnet die Linie. Sie benötigt als Parameter die Koordinaten
; der Punkte P1 und P2 und die Adresse der Bitebene, auf der gezeichnet werden soll.
; D0 - X1 (X-Koordinate von P1)
; D1 - Y1 (Y-Koordinate von P1)
; D2 - X2 (X-Koordinate von P2)
; D3 - Y2 (Y-Koordinate von P2)
; A0 - Bitplane Adresse
;******************************************************************************

; Konstanten

DL_Fill		=	0		; 0=NOFILL / 1=FILL

	IFEQ	DL_Fill
DL_MInterns	=	$CA
	ELSE
DL_MInterns	=	$4A
	ENDC


DrawLine:
	sub.w	d1,d3		; D3=Y2-Y1

	IFNE	DL_Fill
	beq.s	.end		; Für die Füllung werden keine horizontalen Linien benötigt
	ENDC

	bgt.s	.y2gy1		; springen wenn positiv ..
	exg	d0,d2			; .. Ansonsten tauschen Sie Punkte aus
	add.w	d3,d1		; setzt das kleinere Y in D1
	neg.w	d3			; D3=DY
.y2gy1:
	mulu.w	#40,d1		; Offset Y
	add.l	d1,a0
	moveq	#0,d1		; D1-Index in der Oktantentabelle
	sub.w	d0,d2		; D2=X2-X1
	bge.s	.xdpos		; springen wenn positiv ..
	addq.w	#2,d1		; .. andernfalls verschieben Sie den Index
	neg.w	d2			; und machen den Unterschied positiv
.xdpos:
	moveq	#$f,d4		; Maske für die 4 niedrigen Bits
	and.w	d0,d4		; wählen sie D4 aus
		
	IFNE	DL_Fill		; Diese Anweisungen sind zusammengestellt
						; nur wenn DL_Fill = 1
	move.b	d4,d5		; berechnet die Nummer des zu invertierenden Bits
	not.b	d5			; (das BCHG nummeriert die inversen Bits)
	ENDC

	lsr.w	#3,d0		; Offset X:
						; In Bytes ausrichten (dient für BCHG)
	add.w	d0,a0		; zur Adresse hinzufügen
						; Beachten Sie, dass auch wenn die Adresse
						; Es ist seltsam, dass es nichts macht, weil
						; der Blitter berücksichtigt nicht die
						; niedrigstwertiges Bit von BLTxPT

	ror.w	#4,d4		; D4 = Wert der Verschiebung A
	or.w	#$B00+DL_MInterns,d4	; füge das passende hinzu
						; Minterm (OR oder EOR)
	swap	d4			; Wert von BLTCON0 im High-Word
		
	cmp.w	d2,d3		; vergleiche DiffX und DiffY
	bge.s	.dygdx		; überspringen wenn >=0..
	addq.w	#1,d1		; andernfalls setzen Sie das Bit 0 des Indexes
	exg	d2,d3			; und tausche das Diff
.dygdx:
	add.w	d2,d2		; D2 = 2*DiffX
	move.w	d2,d0		; Kopie in D0
	sub.w	d3,d0		; D0 = 2*DiffX-DiffY
	addx.w	d1,d1		; multiplizieren Sie den Index mit 2 und
						; gleichzeitig fügt er die Flagge hinzu
						; X ist 1, wenn 2 * DiffX-DiffY <0 ist
						; (eingestellt von sub.w)
	move.b	Oktants(PC,d1.w),d4	; liest den Oktanten
	swap	d2			; BLTBMOD-Wert in High-Word
	move.w	d0,d2		; niedriges Word D2=2*DiffX-DiffY
	sub.w	d3,d2		; niedriges Word D2=2*DiffX-2*DiffY
	moveq	#6,d1		; Wert der Verschiebung und Test für
						; die Wartezeit Blitter

	lsl.w	d1,d3		; berechnet den Wert von BLTSIZE
	add.w	#$42,d3

	lea	$52(a5),a1		; A1 = BLTAPTL-Adresse
						; Er schreibt einige Register
						; nacheinander mit
						; MOVE #XX,(Ax)+

	btst	d1,2(a5)	; warte auf den Blitter
.wb:
	btst	d1,2(a5)
	bne.s	.wb

	IFNE	DL_Fill		; Diese Anweisung ist zusammengestellt
						; nur wenn DL_Fill = 1
	bchg	d5,(a0)		; Invertiert das erste Bit der Zeile
	ENDC

	move.l	d4,$40(a5)	; BLTCON0/1
	move.l	d2,$62(a5)	; BLTBMOD und BLTAMOD
	move.l	a0,$48(a5)	; BLTCPT
	move.w	d0,(a1)+	; BLTAPTL
	move.l	a0,(a1)+	; BLTDPT
	move.w	d3,(a1)		; BLTSIZE
.end:
	rts

; Wenn wir Zeilen für die Füllung ausführen möchten, setzt der Octant-Code 
; durch die Konstante SML das SING-Bit auf 1

	IFNE	DL_Fill
SML		= 	2
	ELSE
SML		=	0
	ENDC

; Tabelle Oktanten

Oktants:
	dc.b	SML+1,SML+1+$40
	dc.b	SML+17,SML+17+$40
	dc.b	SML+9,SML+9+$40
	dc.b	SML+21,SML+21+$40

;******************************************************************************
; Diese Routine legt die Blitter-Register fest, die sich 
; zwischen einer Zeile und einer anderen nicht ändern
;******************************************************************************

InitLine
	btst	#6,2(a5) 	; dmaconr
WBlit_Init:
	btst	#6,2(a5) 	; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Init

	moveq.l	#-1,d5
	move.l	d5,$44(a5)		; BLTAFWM/BLTALWM = $FFFF
	move.w	#$8000,$74(a5)	; BLTADAT = $8000
	move.w	#40,$60(a5)		; BLTCMOD = 40
	move.w	#40,$66(a5)		; BLTDMOD = 40
	rts

;******************************************************************************
; Diese Routine definiert das Muster, das zum Zeichnen der Linien verwendet
; werden soll. In der Praxis setzt man einfach das BLTBDAT-Register.
; D0 - enthält das Linienmuster
;******************************************************************************

SetPattern:
	btst	#6,2(a5) ; dmaconr
WBlit_Set:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	Wblit_Set

	move.w	d0,$72(a5)	; BLTBDAT = Linienmuster
	rts


;****************************************************************************
; Diese Routine löscht den Bildschirm mit dem Blitter.
;****************************************************************************

CancellaSchermo:
	lea	bitplane,a0			; Adresse die gelöscht werden soll

	btst	#6,2(a5)
WBlit3:
	btst	#6,2(a5)		 ; warte auf das Ende des Blitters
	bne.s	wblit3

	move.l	#$01000000,$40(a5)	; BLTCON0 und BLTCON1: Löschung
	move	#$0000,$66(a5)		; BLTDMOD=0
	move.l	a0,$54(a5)			; BLTDPT
	move.w	#(64*256)+20,$58(a5)	; BLTSIZE (Blitter starten!)
								; lösche den gesamten Bildschirm
	rts


;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$1200	; Bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$eee	; color1
	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

	Section	IlMioPlane,bss_C

BITPLANE:
	ds.b	40*256		; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel sehen Sie, wie Sie eine Linie erstellen, die sich auf dem 
Bildschirm bewegt. Die Linie wird zu jedem frame an einer anderen Position gezeichnet.
Die X- und Y-Koordinaten der Zeilenenden werden aus Sinus-Tabellen gelesen.