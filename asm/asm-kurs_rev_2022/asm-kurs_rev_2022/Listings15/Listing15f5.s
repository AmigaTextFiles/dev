
; Listing15f5.s		UniMuoviSprite-Routine zum Scrollen von AGA horizontal
			; in Schritten von 1/4 Pixel verbessert. Mit einer Tabelle
			; machen wir die größere Scrollfähigkeit deutlicher.

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110100000	; copper, bitplane, sprite DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das leere Bild

	MOVE.L	#BITPLANE,d0	
	LEA	BPLPOINTERS,A1			; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	alle Sprites zeigen auf das Null-Sprite 

	MOVE.L	#SpriteNullo,d0		; Adresse des Sprites in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	MOVEQ	#8-1,d1				; alle 8 sprites
NulLoop:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	addq.w	#8,a1
	dbra	d1,NulLoop

;	Zeiger auf sprite

	MOVE.L	#MIOSPRITE64,d0		; Adresse des Sprites in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2			; warte auf Zeile $120
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $120
	BNE.S	Waity1

	bsr.s	MuoviSpriteX		; liest aus der Tabelle und bewegt das Sprite

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12000,d2			; warte auf Zeile $120
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $120
	BEQ.S	Aspetta

	btst.b	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	NonScambiareRes	; Wenn nicht, ändern Sie das Ergebnis des Sprites nicht

	bchg.b	#7,BplCon3		; Wenn ja, wechseln Sie von LowRes zu Hires oder umgekehrt.

NonScambiareRes:
	btst.b	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse
	rts

MuoviSpriteX:
	ADDQ.L	#2,TABXPOINT		; auf das nächste Wort zeigen
	MOVE.L	TABXPOINT(PC),A0	; Adresse in langem TABXPOINT enthalten
								; kopiert nach a0
	CMP.L	#FINETABX-2,A0		; sind wir beim letzten Wort der TAB?
	BNE.S	NOBSTARTX			; noch nicht? dann weiter
	MOVE.L	#TABX-2,TABXPOINT	; wir beginnen bei dem ersten word-2
NOBSTARTX:
	moveq	#0,d1				; zurücksetzen d0
	MOVE.w	(A0),d1				; wir setzen den Wert der Tabelle in d0
;	add.w	#128*4,D1			; 128*4 - um das Sprite zu zentrieren.
	moveq	#100,d0				; Position Y
	moveq	#52,d2				; Höhe sprite
	lea	MIOSPRITE64,a1			; Adresse sprite
	bsr.w	UniMuoviSprite64F	; universelle Routine aufrufen
	rts

TABXPOINT:
	dc.l	TABX-2		; HINWEIS: Die Werte in der Tabelle hier sind Wörter.

; Hier erfahren Sie, wie Sie die Tabelle bekommen:

;			            ___1280
; DEST> tabx	                   /   \ 640 (1280/2)
; BEG> 0		      \___/     0
; END> 360
; AMOUNT> 150*4
; AMPLITUDE> (1280-64*4)/2	; Amplitude sowohl über Null als auch unter Null
							; es muss halb über und halb unter Null sein,
							; Das heißt, wir teilen die Amplitude durch 2
; YOFFSET> (1280-64*4)/2	; und wir bewegen alles nach oben
; SIZE (B/W/L)> w
; MULTIPLIER> 1

TABX:
	DC.W	$0203,$0208,$020D,$0213,$0218,$021D,$0223,$0228,$022E,$0233
	DC.W	$0238,$023E,$0243,$0248,$024D,$0253,$0258,$025D,$0263,$0268
	DC.W	$026D,$0272,$0278,$027D,$0282,$0287,$028C,$0291,$0297,$029C
	DC.W	$02A1,$02A6,$02AB,$02B0,$02B5,$02BA,$02BF,$02C4,$02C9,$02CE
	DC.W	$02D3,$02D8,$02DC,$02E1,$02E6,$02EB,$02F0,$02F4,$02F9,$02FE
	DC.W	$0302,$0307,$030C,$0310,$0315,$0319,$031E,$0322,$0326,$032B
	DC.W	$032F,$0333,$0338,$033C,$0340,$0344,$0348,$034D,$0351,$0355
	DC.W	$0359,$035D,$0360,$0364,$0368,$036C,$0370,$0373,$0377,$037B
	DC.W	$037E,$0382,$0385,$0389,$038C,$0390,$0393,$0396,$0399,$039D
	DC.W	$03A0,$03A3,$03A6,$03A9,$03AC,$03AF,$03B2,$03B5,$03B7,$03BA
	DC.W	$03BD,$03BF,$03C2,$03C4,$03C7,$03C9,$03CC,$03CE,$03D0,$03D3
	DC.W	$03D5,$03D7,$03D9,$03DB,$03DD,$03DF,$03E1,$03E3,$03E4,$03E6
	DC.W	$03E8,$03E9,$03EB,$03EC,$03EE,$03EF,$03F1,$03F2,$03F3,$03F4
	DC.W	$03F5,$03F6,$03F7,$03F8,$03F9,$03FA,$03FB,$03FC,$03FC,$03FD
	DC.W	$03FD,$03FE,$03FE,$03FF,$03FF,$03FF,$0400,$0400,$0400,$0400
	DC.W	$0400,$0400,$0400,$0400,$03FF,$03FF,$03FF,$03FE,$03FE,$03FD
	DC.W	$03FD,$03FC,$03FC,$03FB,$03FA,$03F9,$03F8,$03F7,$03F6,$03F5
	DC.W	$03F4,$03F3,$03F2,$03F1,$03EF,$03EE,$03EC,$03EB,$03E9,$03E8
	DC.W	$03E6,$03E4,$03E3,$03E1,$03DF,$03DD,$03DB,$03D9,$03D7,$03D5
	DC.W	$03D3,$03D0,$03CE,$03CC,$03C9,$03C7,$03C4,$03C2,$03BF,$03BD
	DC.W	$03BA,$03B7,$03B5,$03B2,$03AF,$03AC,$03A9,$03A6,$03A3,$03A0
	DC.W	$039D,$0399,$0396,$0393,$0390,$038C,$0389,$0385,$0382,$037E
	DC.W	$037B,$0377,$0373,$0370,$036C,$0368,$0364,$0360,$035D,$0359
	DC.W	$0355,$0351,$034D,$0348,$0344,$0340,$033C,$0338,$0333,$032F
	DC.W	$032B,$0326,$0322,$031E,$0319,$0315,$0310,$030C,$0307,$0302
	DC.W	$02FE,$02F9,$02F4,$02F0,$02EB,$02E6,$02E1,$02DC,$02D8,$02D3
	DC.W	$02CE,$02C9,$02C4,$02BF,$02BA,$02B5,$02B0,$02AB,$02A6,$02A1
	DC.W	$029C,$0297,$0291,$028C,$0287,$0282,$027D,$0278,$0272,$026D
	DC.W	$0268,$0263,$025D,$0258,$0253,$024D,$0248,$0243,$023E,$0238
	DC.W	$0233,$022E,$0228,$0223,$021D,$0218,$0213,$020D,$0208,$0203
	DC.W	$01FD,$01F8,$01F3,$01ED,$01E8,$01E3,$01DD,$01D8,$01D2,$01CD
	DC.W	$01C8,$01C2,$01BD,$01B8,$01B3,$01AD,$01A8,$01A3,$019D,$0198
	DC.W	$0193,$018E,$0188,$0183,$017E,$0179,$0174,$016F,$0169,$0164
	DC.W	$015F,$015A,$0155,$0150,$014B,$0146,$0141,$013C,$0137,$0132
	DC.W	$012D,$0128,$0124,$011F,$011A,$0115,$0110,$010C,$0107,$0102
	DC.W	$00FE,$00F9,$00F4,$00F0,$00EB,$00E7,$00E2,$00DE,$00DA,$00D5
	DC.W	$00D1,$00CD,$00C8,$00C4,$00C0,$00BC,$00B8,$00B3,$00AF,$00AB
	DC.W	$00A7,$00A3,$00A0,$009C,$0098,$0094,$0090,$008D,$0089,$0085
	DC.W	$0082,$007E,$007B,$0077,$0074,$0070,$006D,$006A,$0067,$0063
	DC.W	$0060,$005D,$005A,$0057,$0054,$0051,$004E,$004B,$0049,$0046
	DC.W	$0043,$0041,$003E,$003C,$0039,$0037,$0034,$0032,$0030,$002D
	DC.W	$002B,$0029,$0027,$0025,$0023,$0021,$001F,$001D,$001C,$001A
	DC.W	$0018,$0017,$0015,$0014,$0012,$0011,$000F,$000E,$000D,$000C
	DC.W	$000B,$000A,$0009,$0008,$0007,$0006,$0005,$0004,$0004,$0003
	DC.W	$0003,$0002,$0002,$0001,$0001,$0001,$0000,$0000,$0000,$0000
	DC.W	$0000,$0000,$0000,$0000,$0001,$0001,$0001,$0002,$0002,$0003
	DC.W	$0003,$0004,$0004,$0005,$0006,$0007,$0008,$0009,$000A,$000B
	DC.W	$000C,$000D,$000E,$000F,$0011,$0012,$0014,$0015,$0017,$0018
	DC.W	$001A,$001C,$001D,$001F,$0021,$0023,$0025,$0027,$0029,$002B
	DC.W	$002D,$0030,$0032,$0034,$0037,$0039,$003C,$003E,$0041,$0043
	DC.W	$0046,$0049,$004B,$004E,$0051,$0054,$0057,$005A,$005D,$0060
	DC.W	$0063,$0067,$006A,$006D,$0070,$0074,$0077,$007B,$007E,$0082
	DC.W	$0085,$0089,$008D,$0090,$0094,$0098,$009C,$00A0,$00A3,$00A7
	DC.W	$00AB,$00AF,$00B3,$00B8,$00BC,$00C0,$00C4,$00C8,$00CD,$00D1
	DC.W	$00D5,$00DA,$00DE,$00E2,$00E7,$00EB,$00F0,$00F4,$00F9,$00FE
	DC.W	$0102,$0107,$010C,$0110,$0115,$011A,$011F,$0124,$0128,$012D
	DC.W	$0132,$0137,$013C,$0141,$0146,$014B,$0150,$0155,$015A,$015F
	DC.W	$0164,$0169,$016F,$0174,$0179,$017E,$0183,$0188,$018E,$0193
	DC.W	$0198,$019D,$01A3,$01A8,$01AD,$01B3,$01B8,$01BD,$01C2,$01C8
	DC.W	$01CD,$01D2,$01D8,$01DD,$01E3,$01E8,$01ED,$01F3,$01F8,$01FD
FINETABX:


; Universelle Positionierungsroutine für Sprites mit einer Breite von 64 pixel, mit
; Position X von 0 bis 1280, wobei der neue 1/4 Pixel AGA-Scroll verwendet wird

;
;	Eingehende Parameter von UniMuoviSprite64F:
;
;	a1 = Adresse des sprites
;	d0 = vertikale Y-Position des Sprites auf dem Bildschirm (0-1280)
;	d1 = horizontale X-Position des Sprites auf dem Bildschirm (0-320)
;	d2 = Höhe des sprites
;

UniMuoviSprite64F:
; vertikale Platzierung
	ADD.W	#$2c,d0		; Versatz des Bildschirmanfangs hinzufügen

; a1 enthält die Adresse des Sprites
	MOVE.b	d0,(a1)			; Kopie byte in VSTART
	btst.l	#8,d0
	beq.s	NonVSTARTSET
	bset.b	#2,3+4+2(a1)	; Bit 8 von VSTART setzen (Nummer > $FF)
	bra.s	ToVSTOP
NonVSTARTSET:
	bclr.b	#2,3+4+2(a1)	; Bit 8 von VSTART zurücksetzen (Nummer < $FF)
ToVSTOP:
	ADD.w	D2,D0			; die Höhe des Sprites hinzufügen
							; Bestimmen der Endposition (VSTOP)
	move.b	d0,2+4+2(a1)	; den richtigen Wert in VSTOP verschieben
	btst.l	#8,d0
	beq.s	NonVSTOPSET
	bset.b	#1,3+4+2(a1)	; Bit 8 von VSTOP setzen  (Nummer > $FF)
	bra.w	VstopFIN
NonVSTOPSET:
	bclr.b	#1,3+4+2(a1)	; Bit 8 von VSTOP zurücksetzen (Numer < $FF)
VstopFIN:

; horizontale Platzierung - Hier sind die Änderungen !!!

	add.w	#128*4,D1		; 128*4 - um das Sprite zu zentrieren.
	btst.l	#0,D1			; niedriges Bit 0 der X-Koordinate gelöscht?
	beq.s	BitBassoZERO
	bset.b	#3,3+4+2(a1)	; SH0 - das niedrige Bit von HSTART setzen
	bra.w	PlaceCoords1

BitBassoZERO:
	bclr.b	#3,3+4+2(a1)	; das niedrige Bit von HSTART löschen
PlaceCoords1:
	btst.l	#1,D1			; niedriges Bit 1 der X-Koordinate gelöscht?
	beq.s	BitBassoZERO1
	bset.b	#4,3+4+2(a1)	; SH1 - das niedrige Bit von HSTART setzen
	bra.w	PlaceCoords2

BitBassoZERO1:
	bclr.b	#4,3+4+2(a1)	; SH1 - das niedrige Bit von HSTART löschen
PlaceCoords2:
	btst.l	#2,D1			; niedriges Bit 2 der X-Koordinate gelöscht?
	beq.s	BitBassoZERO2
	bset.b	#0,3+4+2(a1)	; SH2 - das niedrige Bit von HSTART setzen
	bra.w	PlaceCoords3

BitBassoZERO2:
	bclr.b	#0,3+4+2(a1)	; SH2 - das niedrige Bit von HSTART löschen
PlaceCoords3:
	lsr.w	#3,D1			; SHIFT, das heißt, wir verschieben den Wert von
							; HSTART um 1 Bit nach rechts, um ihn in "umzuwandeln"
							; Wert setzt in das HSTART-Byte, ohne die
							; niedrige 3 Bits.
	move.b	D1,1(a1)		; wir setzen den Wert XX in das HSTART-Byte
	rts

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8	; auf 64 Bit ausrichten

	section	coppera,data_C

COPLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop

	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; Bpl1Mod (burst 64bit, modulo=modulo-8)
	dc.w	$10a,-8		; Bpl2Mod (wie oben)

			    ; 5432109876543210
	dc.w	$100,%0001001000000001	; 1 bitplane LORES 320x256.

	dc.w	$1fc,%1111	; Burst mode 64 bit, sprite Größe 64 pixel


BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste 	bitplane
	dc.w $e4,0,$e6,0	; zweite	   "
	dc.w $e8,0,$ea,0	; dritte	   "
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte		   "

; Beachten Sie, dass die Sprite-Farben 24 Bit sind, auch wenn es nur 3 sind.

	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
COLP0:
	dc.w	$180,$000	; color0	; schwarzer Hintergrund
	dc.w	$182,$123	; color1	; Farbe 1 der Bitebene, die
									; in diesem Fall leer ist,
									; so erscheint sie nicht.

	dc.w	$1A2,$F00	; color17, das ist COLOR1 von sprite0 - ROT
	dc.w	$1A4,$0F0	; color18, das ist COLOR2 von sprite0 - GRÜN
	dc.w	$1A6,$FF0	; color19, das ist COLOR3 von sprite0 - GELB


	DC.W	$106,$e00	; AUSWAHL  PALETTE 0 (0-31), NIBBLE NIEDRIG
COLP0B:
	dc.w	$180,$000	; color0	; schwarzer Hintergrund
	dc.w	$182,$000	; color1	; Farbe 1 der Bitebene, die
									; in diesem Fall leer ist,
									; so erscheint sie nicht.

	dc.w	$1A2,$462	; color17, nibble niedrig
	dc.w	$1A4,$2e4	; color18, nibble niedrig
	dc.w	$1A6,$672	; color19, nibble niedrig

	dc.w	$106		; BPLCON3
	dc.b	0
BplCon3:
	       ; 76543210
	dc.b	%00000000	; bit 7: sprites hires oder lowres. Wenn
		; sowohl Bit 7 als auch Bit 6 gesetzt sind ist das Sprite
		; in Superhires (1280x256), aber es kommt viel zu  "eng",
		; ich denke es ist nutzlos, nur hires!

	dc.w	$FFFF,$FFFE	; Ende copperlist


;*****************************************************************************
; Hier sind die Sprites: Offensichtlich müssen sie sich im CHIP-RAM befinden!
;*****************************************************************************

	cnop	0,8

SpriteNullo:			; Null-Sprite, um in der copperliste auf sie zu zeigen
	dc.l	0,0,0,0		; in nicht verwendeten Zeigern


	cnop	0,8

MIOSPRITE64:	; Länge 13*4 Zeilen
VSTART:
	dc.b $50	; Vertikale Sprite-Startposition ($2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Sprite-Startposition ($40 bis $d8)
	dc.w 0		; word + longword hinzugefügt, um das Doppelte zu erreichen
	dc.l 0		; longword für sprite Größe 64 pixel (2 long!)
VSTOP:
	dc.b $5d	; $50+13=$5d	; vertikale Position des Endsprites
VHBITS:
	dc.b $00	; bit
	dc.w 0		; word + longword hinzugefügt, um das Doppelte zu erreichen
	dc.l 0		; longword für sprite Größe 64 pixel (2 long!)

	dc.l	$00000000,$00000000,$00003000,$000c0000 ; gespeichert mit PicCon
	dc.l	$00000000,$00000000,$00003800,$001c0000
	dc.l	$00000000,$00000000,$00001c00,$00380000
	dc.l	$00000000,$00000000,$00000e00,$00700000
	dc.l	$00000000,$00000000,$00000700,$00e00000
	dc.l	$00000000,$00000000,$00000380,$01c00000
	dc.l	$00000000,$00000000,$000001c0,$03800000
	dc.l	$00000000,$00000000,$000000e0,$07000000
	dc.l	$00000000,$00000000,$00000070,$0e000000
	dc.l	$00000000,$00000000,$00000038,$1c000000
	dc.l	$00000000,$00000000,$00000038,$1c000000
	dc.l	$00000000,$00000000,$0000001c,$38000000
	dc.l	$0000000f,$f0000000,$000f001f,$f800f000
	dc.l	$0000003f,$fc000000,$003f003f,$fc00fc00
	dc.l	$0000007f,$fe000000,$007c007f,$fe003e00
	dc.l	$000000ff,$ff000000,$00f800ff,$ff001f00
	dc.l	$000001ff,$ff800000,$01f001ff,$ff800f80
	dc.l	$000003ff,$ffc00000,$03e003ff,$ffc007c0
	dc.l	$000007ff,$ffe00000,$07c007ff,$ffe003e0
	dc.l	$00000fff,$fff00000,$0f800fff,$fff001f0
	dc.l	$00001fff,$fff80000,$1f001c3f,$fc3800f8
	dc.l	$00003fff,$fffc0000,$3e00381f,$f81c007c
	dc.l	$00003fff,$fffc0000,$7c00300f,$f00c003e
	dc.l	$00007fff,$fffe0000,$fc00700f,$f00e003f
	dc.l	$00007f8f,$f1fe0000,$fffff00f,$f00fffff
	dc.l	$00007f0f,$f0fe0000,$fffff00f,$f00fffff
	dc.l	$00007f0f,$f0fe0000,$fffff80f,$f01fffff
	dc.l	$00007f1f,$f8fe0000,$7ffffc1f,$f83ffffe
	dc.l	$00003fff,$fffc0000,$00003fff,$fffc0000
	dc.l	$00003fff,$fffc0000,$00003fff,$fffc0000
	dc.l	$00001fff,$fff80000,$00007fff,$fffe0000
	dc.l	$00001fff,$fff80000,$0000ffff,$ffff0000
	dc.l	$00000fff,$fff00000,$0001ff80,$01ff8000
	dc.l	$00000fff,$fff00000,$0003ffc0,$03ffc000
	dc.l	$000007ff,$ffe00000,$0007ffe0,$07ffe000
	dc.l	$000003ff,$ffc00000,$0007fff0,$0fffe000
	dc.l	$000001ff,$ff800000,$000ff1ff,$ff8ff000
	dc.l	$000001ff,$ff800000,$001fe1ff,$ff87f800
	dc.l	$000000ff,$ff000000,$003fc0ff,$ff03fc00
	dc.l	$0000007f,$fe000000,$003fc07f,$fe03fc00
	dc.l	$0000003f,$fc000000,$007f803f,$fc01fe00
	dc.l	$0000001f,$f8000000,$007f801f,$f801fe00
	dc.l	$0000000f,$f0000000,$00ff000f,$f000ff00
	dc.l	$00000003,$c0000000,$00ff0003,$c000ff00
	dc.l	$00000000,$00000000,$03fe0000,$00007fc0
	dc.l	$00000000,$00000000,$0ffe0000,$00007ff0
	dc.l	$00000000,$00000000,$3ffe0000,$00007ffc
	dc.l	$00000000,$00000000,$7fff0000,$0000fffe
	dc.l	$00000000,$00000000,$ffff0000,$0000ffff
	dc.l	$00000000,$00000000,$ffff8000,$0001ffff
	dc.l	$00000000,$00000000,$ffff8000,$0001ffff
	dc.l	$00000000,$00000000,$ffff8000,$0001ffff

	dc.l	0,0,0,0		; Ende sprite (2 doppelte longword).

	cnop	0,8

	SECTION	PLANEVUOTO,BSS_C	; Die von uns verwendete Reset-Bitebene,
								; weil um die Sprites zu sehen
								; muss es aktivierte Bitebenen geben

BITPLANE:
	ds.b	40*256		; bitplane leer lowres

	end

Beachten Sie, dass ein solcher Bildlauf auf MSDOS-PCs nicht möglich ist und 
auch nicht auf dem Super Nintendo, ganz zu schweigen von der Sega Megadrive ...

