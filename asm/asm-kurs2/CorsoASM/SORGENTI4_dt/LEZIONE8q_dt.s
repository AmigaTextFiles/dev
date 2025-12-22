
; Lezione8q.s  Verwendung von Bildern mit der Palette unten gespeichert (HINTER).
			; Linke Taste zum "Färben", rechte zum Beenden.

	SECTION	Behind,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Sie Copperlist Etc.
*****************************************************************************

		;5432109876543210
DMASET	EQU	%1000001110000000	; nur Copper und Bitplane DMA

START:
;	Wir zielen auf die Figur

	MOVE.L	#Logo1,d0	; Zeiger
	LEA	BPLPOINTERS,A1	; Zeiger COP
	MOVEQ	#4-1,D1		; Anzahl der Bitflächen (hier sind es 4)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0	; + Bitplane-Länge (84 Zeilen hoch hier)
	addq.w	#8,a1
	dbra	d1,POINTBP


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie AGA


mouse:
	btst.b	#6,$bfe001	;Linke Maustaste gedrückt?
	bne.s	mouse

;	          |||||
;	_____.oOo_/o_O\_oOo.____.

Puntacolori:
	lea	logo1+(40*84*4),a0	; in einer Adresspalette nach dem Bild,
						; erhältlich durch Addition der Länge
						; von Bitplane am Anfang von
						; Bild: Die Farben bleiben!
	lea	CopColors+2,a1	; Farbregisteradresse in der Coplist
	moveq	#16-1,d0	; Anzahl der Farben
MettiLoop2:
	move.w	(a0)+,(a1)	; Kopieren Sie die Farbe von der Palette in die copperliste
	addq.w	#4,a1		; Zum nächsten Farbregister springen
	dbra	d0,mettiloop2	; Mache alle Farben

mouse2:
	btst.b	#2,$dff016	; Rechte Maustaste gedrückt?
	bne.s	mouse2

	rts

*****************************************************************************
;			Copper List
*****************************************************************************
	section	copper,data_c		; Chip data

Copperlist:
	dc.w	$8E,$2c81	; DiwStrt - window start
	dc.w	$90,$2cc1	; DiwStop - window stop
	dc.w	$92,$38		; DdfStart - data fetch start
	dc.w	$94,$d0		; DdfStop - data fetch stop
	dc.w	$102,0		; BplCon1 - scroll register
	dc.w	$104,0		; BplCon2 - priority register
	dc.w	$108,0		; Bpl1Mod - modulo pl. ungerade
	dc.w	$10a,0		; Bpl2Mod - modulo pl. gerade

		    ; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste	 bitplane
	dc.w $e4,$0000,$e6,$0000	; zweite bitplane
	dc.w $e8,$0000,$ea,$0000	; dritte bitplane
	dc.w $ec,$0000,$ee,$0000	; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

CopColors:
	dc.w $180,0,$182,0,$184,0,$186,0	; Jetzt sind sie zurückgesetzt, es wird der
	dc.w $188,0,$18a,0,$18c,0,$18e,0	; Routine zum Kopieren von Werten
	dc.w $190,0,$192,0,$194,0,$196,0	; vom unteren Rand des Bildes.
	dc.w $198,0,$19a,0,$19c,0,$19e,0

;	Lassen Sie uns ein paar Nuancen für die Szenografie setzen...

	dc.w	$8007,$fffe	; Wait - $2c+84=$80
	dc.w	$100,$200	; bplcon0 - no bitplanes
	dc.w	$180,$003	; color0
	dc.w	$8207,$fffe	; wait
	dc.w	$180,$005	; color0
	dc.w	$8507,$fffe	; wait
	dc.w	$180,$007	; color0
	dc.w	$8a07,$fffe	; wait
	dc.w	$180,$009	; color0
	dc.w	$9207,$fffe	; wait
	dc.w	$180,$00b	; color0

	dc.w	$9e07,$fffe	; wait
	dc.w	$180,$999	; color0
	dc.w	$a007,$fffe	; wait
	dc.w	$180,$666	; color0
	dc.w	$a207,$fffe	; wait
	dc.w	$180,$222	; color0
	dc.w	$a407,$fffe	; wait
	dc.w	$180,$001	; color0

	dc.l	$ffff,$fffe	; Ende copperlist


*****************************************************************************
;				DESIGN
*****************************************************************************

	section	gfxstuff,data_c

; Design Größe 320 pixel, Hoch 84, 4 Bitplanes (16 Farben).

Logo1:
	;incbin	'logo320*84*16c.raw'
	 blk.b 13440,$80
	end

Die Nützlichkeit des Ablegens der Palette in die .raw-Datei zeigt sich, wenn Sie 
sie viele Figuren verwalten müssen, zum Beispiel in Abenteuerspielen oder Diashows.
Zum Beispiel in meiner "World of Manga" habe ich dieses System mit den AGA-Figuren 
verwendet, gespeichert von der AGA mit der 24-Bit-Palette unten.

