
; Listing8q.s  Verwendung von Bildern mit der Palette unten gespeichert (HINTER).
			; Linke Taste zum "Färben", rechte zum Beenden.

	SECTION	Behind,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern Sie Copperlist Etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur Copper und Bitplane DMA

START:
	MOVE.L	#Logo1,d0			; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#4-1,D1				; Anzahl der Bitplanes (hier sind es 4)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0			; + Länge einer Bitplane (84 Zeilen hoch hier)
	addq.w	#8,a1
	dbra	d1,POINTBP


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren


mouse:
	btst.b	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse

;	          |||||
;	_____.oOo_/o_O\_oOo.____.

Puntacolori:
	lea	logo1+(40*84*4),a0		; in a0 ist Adresse der Palette nach dem Bild,
								; man erhält sie durch Addition der Länge
								; der Bitebenen vom Anfang vom Bild
								; Die Farben bleiben!
	lea	CopColors+2,a1			; Adresse der Farbregister in der Coplist
	moveq	#16-1,d0			; Anzahl der Farben
MettiLoop2:
	move.w	(a0)+,(a1)			; Farben von der Palette in die copperliste kopieren								
	addq.w	#4,a1				; zum nächsten Farbregister gehen
	dbra	d0,mettiloop2		; mache alle Farben

mouse2:
	btst.b	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	mouse2

	rts

*****************************************************************************
;			Copper List
*****************************************************************************
	section	copper,data_c		; Chip data

Copperlist:
	dc.w	$8E,$2c81			; DiwStrt - window start
	dc.w	$90,$2cc1			; DiwStop - window stop
	dc.w	$92,$38				; DdfStart - data fetch start
	dc.w	$94,$d0				; DdfStop - data fetch stop
	dc.w	$102,0				; BplCon1 - scroll register
	dc.w	$104,0				; BplCon2 - priority register
	dc.w	$108,0				; Bpl1Mod - modulo pl. ungerade
	dc.w	$10a,0				; Bpl2Mod - modulo pl. gerade

				; 5432109876543210
	dc.w	$100,%0100001000000000	; BPLCON0 - 4 planes lowres (16 color)

; Bitplane pointers

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste	 bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte bitplane
	dc.w	$ec,$0000,$ee,$0000	; vierte bitplane

; Die ersten 16 Farben sind für das LOGO

CopColors:
	dc.w	$180,0,$182,0,$184,0,$186,0	; Jetzt sind sie zurückgesetzt, wird
	dc.w	$188,0,$18a,0,$18c,0,$18e,0	; durch die Routine zum Kopieren von 
	dc.w	$190,0,$192,0,$194,0,$196,0	; Werten vom unteren Rand des Bildes
	dc.w	$198,0,$19a,0,$19c,0,$19e,0 ; gefüllt.

;	Lassen Sie uns ein paar Nuancen für die Szenografie setzen...

	dc.w	$8007,$fffe			; Wait - $2c+84=$80
	dc.w	$100,$200			; bplcon0 - no bitplanes
	dc.w	$180,$003			; color0
	dc.w	$8207,$fffe			; wait
	dc.w	$180,$005			; color0
	dc.w	$8507,$fffe			; wait
	dc.w	$180,$007			; color0
	dc.w	$8a07,$fffe			; wait
	dc.w	$180,$009			; color0
	dc.w	$9207,$fffe			; wait
	dc.w	$180,$00b			; color0
	dc.w	$9e07,$fffe			; wait
	dc.w	$180,$999			; color0
	dc.w	$a007,$fffe			; wait
	dc.w	$180,$666			; color0
	dc.w	$a207,$fffe			; wait
	dc.w	$180,$222			; color0
	dc.w	$a407,$fffe			; wait
	dc.w	$180,$001			; color0
	dc.l	$ffff,$fffe			; Ende copperlist


*****************************************************************************
;				DESIGN
*****************************************************************************

	section	gfxstuff,data_c

; Design Größe 320 pixel, Hoch 84, 4 Bitplanes (16 Farben).

Logo1:
	incbin	'/Sources/logo320x84x16c.raw'

	end

Wie nützlich es ist, die Palette in der .raw Datei zu speichern, zeigt sich
beim Umgang mit viele Bildern, zum Beispiel in Abenteuerspielen oder in
Diashows. In meiner "World of Manga" habe ich zum Beispiel dieses System
verwendet, mit den AGA Bildern, gespeichert durch den AGA iffconverter mit der
24-Bit-Palette am unteren Rand.


