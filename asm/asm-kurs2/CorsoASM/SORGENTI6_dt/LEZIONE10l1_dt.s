
; Lezione10l1.s		Zyklische Animation mit dem Blitter
		; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#2-1,D1			; Anzahl der Bitplanes (hier sind es 2)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0		; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

mouse:

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile $130 (304)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile $130 (304)
	BNE.S	Waity1

	bsr.s	Animazione		; verschiebe den Frame in der Tabelle
	move.l	Frametab(pc),a0	; Zeichnen Sie den ersten Frame der Tabelle
	bsr.s	DisegnaFrame	; Frame zeichnen

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse				; Wenn nicht, gehe zurück zu mouse:
	rts


;****************************************************************************
; Diese Routine erstellt die Animation und verschiebt die Rahmenadressen
; so dass jedes Mal, der erste zum letzten Platz der Tabelle geht,
; die anderen liegen alle in der Richtung des ersten
;****************************************************************************

Animazione:
	addq.b	#1,ContaAnim    ; Diese drei Anweisungen machen das die
	cmp.b	#4,ContaAnim    ; Frames immer einmal geändert werden 
	bne.s	NonCambiare     ; 3x nein und 1 x ja
	clr.b	ContaAnim		; für die Geschwindigkeit der Animation
	LEA	FRAMETAB(PC),a0		; Tabelle mit den Adressen der 8 Bilder
	MOVE.L	(a0),d0			; Speichere die erste Adresse in d0
	MOVE.L	4(a0),(a0)		; verschiebe die anderen 7 Adressen zurück
	MOVE.L	4*2(a0),4(a0)	; Diese Anweisungen "rotieren" die Adressen
	MOVE.L	4*3(a0),4*2(a0) ; von der Tabelle.
	MOVE.L	4*4(a0),4*3(a0)
	MOVE.L	4*5(a0),4*4(a0)
	MOVE.L	4*6(a0),4*5(a0)
	MOVE.L	4*7(a0),4*6(a0)
	MOVE.L	d0,4*7(a0)		; Stellen Sie die erste Adresse auf den achten Platz

NonCambiare:
	rts

ContaAnim:
	dc.w	0

; Dies ist die Frame-Adressentabelle. Die Adressen die in der Tabelle 
; vorhanden sind rotieren innerhalb der Animationsroutine. so dass
; der erste in der Tabelle das erste Mal Frame1 ist, durch die Rotation
; dann Frame2, dann die 3,4,5,6,7,8 und dann wieder der erste, immer 
; zyklisch. Auf diese Weise nehmen Sie einfach die Adresse, die am  
; Anfang der Tabelle steht.

FRAMETAB:
	DC.L	Frame1
	DC.L	Frame2
	DC.L	Frame3
	DC.L	Frame4
	DC.L	Frame5
	DC.L	Frame6
	DC.L	Frame7
	DC.L	Frame8


;****************************************************************************
; Diese Routine kopiert einen Animationsrahmen auf den Bildschirm.
; Die Position auf dem Bildschirm und die Größe der Bilder sind konstant
; A0 - Quelladresse
;****************************************************************************

;	           ,-~~-.___.
;	          / ()=(()   \
;	         (  |         0
;	          \_,\, ,----'
;	     ##XXXxxxxxxx
;	            /  ---'~;
;	           /    /~|-
;	         =(   ~~  |
;	   /~~~~~~~~~~~~~~~~~~~~~\
;	  /_______________________\
;	 /_________________________\
;	/___________________________\
;	   |____________________|
;	   |____________________| W<
;	   |____________________|
;	   |                    |

DisegnaFrame:

	moveq	#2-1,d7				; Anzahl bitplanes
	lea	bitplane+80*40+6,a1		; Adresse Ziel

DisegnaLoop:
	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 (A+D)
								; normale Kopie
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#32,$66(a5)			; BLTDMOD (40-8=32)
	move.l	a0,$50(a5)			; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)			; BLTDPT  Zeiger Ziel
	move.w	#(64*55)+4,$58(a5)	; BLTSIZE (Blitter starten!)
								; Breite 4 word
								; Höhe 55 Zeile

	lea	2*4*55(a0),a0			; zeigt auf die nächste Quellenebene
								; Jedes plane ist 4 Wörter breit und 
								; 55 Zeilen hoch

	lea	40*256(a1),a1			; zeigt auf die nächste Zielebene

	dbra	d7,DisegnaLoop

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

	dc.w	$100,$2200	; bplcon0

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane
	dc.w $e4,$0000,$e6,$0000

	dc.w	$180,$000	; color0
	dc.w	$182,$00b	; color1
	dc.w	$184,$cc0	; color2
	dc.w	$186,$b00	; color3

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************
; Dies sind die Frames, die die Animation ausmachen

Frame1:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffcf,$fffff800,$7fffff87,$fffffc00,$7fffff03,$fffffc00
	dc.l	$7ffffe01,$fffffc00,$fffffc00,$fffffe00,$fffff800,$7ffffe00
	dc.l	$fffff000,$3ffffe00,$ffffff87,$fffffe00,$ffffff87,$fffffe00
	dc.l	$ffffff87,$fffffe00,$ffffff87,$fffffe00,$ffffff87,$fffffe00
	dc.l	$ffffff87,$fffffe00,$ffffff87,$fffffe00,$ffffff87,$fffffe00
	dc.l	$7fffff87,$fffffc00,$7fffff87,$fffffc00,$7fffff87,$fffffc00
	dc.l	$3fffff87,$fffff800,$3fffff87,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffcf,$fffff800
	dc.l	$3fffffb7,$fffff800,$7fffff7b,$fffffc00,$7ffffefd,$fffffc00
	dc.l	$7ffffdfe,$fffffc00,$fffffbff,$7ffffe00,$fffff7ff,$bffffe00
	dc.l	$ffffefff,$dffffe00,$ffffe078,$1ffffe00,$ffffff7b,$fffffe00
	dc.l	$ffffff7b,$fffffe00,$ffffff7b,$fffffe00,$ffffff7b,$fffffe00
	dc.l	$ffffff7b,$fffffe00,$ffffff7b,$fffffe00,$ffffff7b,$fffffe00
	dc.l	$7fffff7b,$fffffc00,$7fffff7b,$fffffc00,$7fffff7b,$fffffc00
	dc.l	$3fffff7b,$fffff800,$3fffff7b,$fffff800,$3fffff03,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000


Frame2:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7fffffff,$fffffc00
	dc.l	$7fffff80,$3ffffc00,$ffffffc0,$3ffffe00,$ffffffe0,$3ffffe00
	dc.l	$fffffff0,$3ffffe00,$ffffffe0,$3ffffe00,$ffffffc0,$3ffffe00
	dc.l	$ffffff82,$3ffffe00,$ffffff07,$3ffffe00,$fffffe0f,$bffffe00
	dc.l	$fffffc1f,$fffffe00,$fffff83f,$fffffe00,$fffff07f,$fffffe00
	dc.l	$7fffe0ff,$fffffc00,$7ffff1ff,$fffffc00,$7ffffbff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7ffffe00,$1ffffc00
	dc.l	$7ffffe7f,$dffffc00,$ffffff3f,$dffffe00,$ffffff9f,$dffffe00
	dc.l	$ffffffcf,$dffffe00,$ffffff9f,$dffffe00,$ffffff3f,$dffffe00
	dc.l	$fffffe7d,$dffffe00,$fffffcf8,$dffffe00,$fffff9f2,$5ffffe00
	dc.l	$fffff3e7,$1ffffe00,$ffffe7cf,$9ffffe00,$ffffcf9f,$fffffe00
	dc.l	$7fff9f3f,$fffffc00,$7fffce7f,$fffffc00,$7fffe4ff,$fffffc00
	dc.l	$3ffff1ff,$fffff800,$3ffffbff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000


Frame3:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7ffffffd,$fffffc00
	dc.l	$7ffffffc,$fffffc00,$fffffffc,$7ffffe00,$fffffffc,$3ffffe00
	dc.l	$fffffffc,$1ffffe00,$ffff8000,$0ffffe00,$ffff8000,$07fffe00
	dc.l	$ffff8000,$07fffe00,$ffff8000,$0ffffe00,$fffffffc,$1ffffe00
	dc.l	$fffffffc,$3ffffe00,$fffffffc,$7ffffe00,$fffffffc,$fffffe00
	dc.l	$7ffffffd,$fffffc00,$7fffffff,$fffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7ffffff9,$fffffc00,$7ffffffa,$fffffc00
	dc.l	$7ffffffb,$7ffffc00,$fffffffb,$bffffe00,$fffffffb,$dffffe00
	dc.l	$ffff0003,$effffe00,$ffff7fff,$f7fffe00,$ffff7fff,$fbfffe00
	dc.l	$ffff7fff,$fbfffe00,$ffff7fff,$f7fffe00,$ffff0003,$effffe00
	dc.l	$fffffffb,$dffffe00,$fffffffb,$bffffe00,$fffffffb,$7ffffe00
	dc.l	$7ffffffa,$fffffc00,$7ffffff9,$fffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000


Frame4:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7ffffbff,$fffffc00,$7ffff1ff,$fffffc00
	dc.l	$7fffe0ff,$fffffc00,$fffff07f,$fffffe00,$fffff83f,$fffffe00
	dc.l	$fffffc1f,$fffffe00,$fffffe0f,$bffffe00,$ffffff07,$3ffffe00
	dc.l	$ffffff82,$3ffffe00,$ffffffc0,$3ffffe00,$ffffffe0,$3ffffe00
	dc.l	$fffffff0,$3ffffe00,$ffffffe0,$3ffffe00,$ffffffc0,$3ffffe00
	dc.l	$7fffff80,$3ffffc00,$7fffffff,$fffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3ffffbff,$fffff800
	dc.l	$3ffff1ff,$fffff800,$7fffe4ff,$fffffc00,$7fffce7f,$fffffc00
	dc.l	$7fff9f3f,$fffffc00,$ffffcf9f,$fffffe00,$ffffe7cf,$9ffffe00
	dc.l	$fffff3e7,$1ffffe00,$fffff9f2,$5ffffe00,$fffffcf8,$dffffe00
	dc.l	$fffffe7d,$dffffe00,$ffffff3f,$dffffe00,$ffffff9f,$dffffe00
	dc.l	$ffffffcf,$dffffe00,$ffffff9f,$dffffe00,$ffffff3f,$dffffe00
	dc.l	$7ffffe7f,$dffffc00,$7ffffe00,$1ffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000


Frame5:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffc3,$fffff800
	dc.l	$3fffffc3,$fffff800,$7fffffc3,$fffffc00,$7fffffc3,$fffffc00
	dc.l	$7fffffc3,$fffffc00,$ffffffc3,$fffffe00,$ffffffc3,$fffffe00
	dc.l	$ffffffc3,$fffffe00,$ffffffc3,$fffffe00,$ffffffc3,$fffffe00
	dc.l	$ffffffc3,$fffffe00,$ffffffc3,$fffffe00,$ffffffc3,$fffffe00
	dc.l	$fffff800,$1ffffe00,$fffffc00,$3ffffe00,$fffffe00,$7ffffe00
	dc.l	$7fffff00,$fffffc00,$7fffff81,$fffffc00,$7fffffc3,$fffffc00
	dc.l	$3fffffe7,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffff81,$fffff800,$3fffffbd,$fffff800
	dc.l	$3fffffbd,$fffff800,$7fffffbd,$fffffc00,$7fffffbd,$fffffc00
	dc.l	$7fffffbd,$fffffc00,$ffffffbd,$fffffe00,$ffffffbd,$fffffe00
	dc.l	$ffffffbd,$fffffe00,$ffffffbd,$fffffe00,$ffffffbd,$fffffe00
	dc.l	$ffffffbd,$fffffe00,$ffffffbd,$fffffe00,$fffff03c,$0ffffe00
	dc.l	$fffff7ff,$effffe00,$fffffbff,$dffffe00,$fffffdff,$bffffe00
	dc.l	$7ffffeff,$7ffffc00,$7fffff7e,$fffffc00,$7fffffbd,$fffffc00
	dc.l	$3fffffdb,$fffff800,$3fffffe7,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000

Frame6:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$bffffc00,$7fffffff,$1ffffc00
	dc.l	$7ffffffe,$0ffffc00,$fffffffc,$1ffffe00,$fffffff8,$3ffffe00
	dc.l	$fffffff0,$7ffffe00,$fffffbe0,$fffffe00,$fffff9c1,$fffffe00
	dc.l	$fffff883,$fffffe00,$fffff807,$fffffe00,$fffff80f,$fffffe00
	dc.l	$fffff81f,$fffffe00,$fffff80f,$fffffe00,$fffff807,$fffffe00
	dc.l	$7ffff803,$fffffc00,$7fffffff,$fffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$bffff800
	dc.l	$3fffffff,$1ffff800,$7ffffffe,$4ffffc00,$7ffffffc,$e7fffc00
	dc.l	$7ffffff9,$f3fffc00,$fffffff3,$e7fffe00,$fffff3e7,$cffffe00
	dc.l	$fffff1cf,$9ffffe00,$fffff49f,$3ffffe00,$fffff63e,$7ffffe00
	dc.l	$fffff77c,$fffffe00,$fffff7f9,$fffffe00,$fffff7f3,$fffffe00
	dc.l	$fffff7e7,$fffffe00,$fffff7f3,$fffffe00,$fffff7f9,$fffffe00
	dc.l	$7ffff7fc,$fffffc00,$7ffff000,$fffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000


Frame7:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7fffffff,$fffffc00
	dc.l	$7fffff7f,$fffffc00,$fffffe7f,$fffffe00,$fffffc7f,$fffffe00
	dc.l	$fffff87f,$fffffe00,$fffff07f,$fffffe00,$ffffe000,$03fffe00
	dc.l	$ffffc000,$03fffe00,$ffffc000,$03fffe00,$ffffe000,$03fffe00
	dc.l	$fffff07f,$fffffe00,$fffff87f,$fffffe00,$fffffc7f,$fffffe00
	dc.l	$7ffffe7f,$fffffc00,$7fffff7f,$fffffc00,$7fffffff,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7fffff3f,$fffffc00
	dc.l	$7ffffebf,$fffffc00,$fffffdbf,$fffffe00,$fffffbbf,$fffffe00
	dc.l	$fffff7bf,$fffffe00,$ffffef80,$01fffe00,$ffffdfff,$fdfffe00
	dc.l	$ffffbfff,$fdfffe00,$ffffbfff,$fdfffe00,$ffffdfff,$fdfffe00
	dc.l	$ffffef80,$01fffe00,$fffff7bf,$fffffe00,$fffffbbf,$fffffe00
	dc.l	$7ffffdbf,$fffffc00,$7ffffebf,$fffffc00,$7fffff3f,$fffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000


Frame8:
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7fffffff,$fffffc00
	dc.l	$7ffff803,$fffffc00,$fffff807,$fffffe00,$fffff80f,$fffffe00
	dc.l	$fffff81f,$fffffe00,$fffff80f,$fffffe00,$fffff807,$fffffe00
	dc.l	$fffff883,$fffffe00,$fffff9c1,$fffffe00,$fffffbe0,$fffffe00
	dc.l	$fffffff0,$7ffffe00,$fffffff8,$3ffffe00,$fffffffc,$1ffffe00
	dc.l	$7ffffffe,$0ffffc00,$7fffffff,$1ffffc00,$7fffffff,$bffffc00
	dc.l	$3fffffff,$fffff800,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000
	dc.l	$000003ff,$80000000,$00001fff,$f0000000,$0000ffff,$fe000000
	dc.l	$0003ffff,$ff800000,$0007ffff,$ffc00000,$001fffff,$fff00000
	dc.l	$003fffff,$fff80000,$007fffff,$fffc0000,$00ffffff,$fffe0000
	dc.l	$01ffffff,$ffff0000,$03ffffff,$ffff8000,$07ffffff,$ffffc000
	dc.l	$07ffffff,$ffffc000,$0fffffff,$ffffe000,$1fffffff,$fffff000
	dc.l	$1fffffff,$fffff000,$3fffffff,$fffff800,$3fffffff,$fffff800
	dc.l	$3fffffff,$fffff800,$7fffffff,$fffffc00,$7ffff000,$fffffc00
	dc.l	$7ffff7fc,$fffffc00,$fffff7f9,$fffffe00,$fffff7f3,$fffffe00
	dc.l	$fffff7e7,$fffffe00,$fffff7f3,$fffffe00,$fffff7f9,$fffffe00
	dc.l	$fffff77c,$fffffe00,$fffff63e,$7ffffe00,$fffff49f,$3ffffe00
	dc.l	$fffff1cf,$9ffffe00,$fffff3e7,$cffffe00,$fffffff3,$e7fffe00
	dc.l	$7ffffff9,$f3fffc00,$7ffffffc,$e7fffc00,$7ffffffe,$4ffffc00
	dc.l	$3fffffff,$1ffff800,$3fffffff,$bffff800,$3fffffff,$fffff800
	dc.l	$1fffffff,$fffff000,$1fffffff,$fffff000,$0fffffff,$ffffe000
	dc.l	$07ffffff,$ffffc000,$07ffffff,$ffffc000,$03ffffff,$ffff8000
	dc.l	$01ffffff,$ffff0000,$00ffffff,$fffe0000,$007fffff,$fffc0000
	dc.l	$003fffff,$fff80000,$001fffff,$fff00000,$0007ffff,$ffc00000
	dc.l	$0003ffff,$ff800000,$0000ffff,$fe000000,$00001fff,$f0000000
	dc.l	$000003ff,$80000000

;****************************************************************************

	SECTION	bitplane,BSS_C

BITPLANE:
	ds.b	40*256		; 2 bitplanes
	ds.b	40*256

;****************************************************************************

	end

In diesem Beispiel zeigen wir eine Animation, die mit dem Blitter erstellt wurde.
Wir haben 8 Frames, die sich zyklisch wiederholen. Um die Animation zu realisieren
genügt es, die verschiedenen Rahmen mit dem Blitter zu zeichnen. In diesem Beispiel
haben die verschiedenen Rahmen alle die gleichen Abmessungen und sind in der
gleichen Position auf dem Bildschirm, die die Realisierung der Zeichnungsroutine
erleichtert. Um auszuwählen, welcher Frame die Zeichnung ist, es ist ein sehr 
ähnliches Verfahren wie im Beispiel lesson7z.s für animierte Sprites. Wir
haben eine Tabelle mit Adressen der verschiedenen Rahmen. Die Adressen werden 
von Zeit zu Zeit gedreht, so dass der Rahmen immer an der ersten Stelle steht.
Auch gibt es einen Counter (ContaAnim), der es uns erlaubt den neuen Frame 
nicht jedes Mal zu zeichnen, wenn die Routine ausgeführt wird. (nur ein paar.) 
Dieser Zähler wird jedes Mal erhöht, aber nur dann, wenn ein bestimmten Wert
erreicht ist, werden die Frame-Adressen gedreht. Indem Sie diesen Wert ändern, 
können Sie die Geschwindigkeit der Animation steuern.