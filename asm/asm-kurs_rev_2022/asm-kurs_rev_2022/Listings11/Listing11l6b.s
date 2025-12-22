
; Listing11l6b.s	Interlaced Mode Management-Routinen (640x512)
;			über das bit 15 (LOF) des VPOSR ($dff004).
;			Wenn Sie die rechte Taste drücken, wird diese Prozedur nicht ausgeführt
;			und Sie bemerken, wie die geraden Linien oder sogar Linien manchmal 
;			seltsam in "pseudo-non-lace" bleiben.

	SECTION	Interlaccione,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include "/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110000000	; nur copper und bitplane DMA

WaitDisk	EQU	30

scr_bytes	= 40				; Anzahl der Bytes für jede horizontale Zeile.
								; Daraus berechnen wir die Bildschirmbreite,
								; Multiplizieren von Bytes mit 8: normaler Bildschirm 320/8 = 40
								; z.B. für einen 336 Pixel breiten Bildschirm 336/8 = 42
								; Beispielbreiten:
								; 264 pixel = 33 / 272 pixel = 34 / 280 pixel = 35
								; 360 pixel = 45 / 368 pixel = 46 / 376 pixel = 47
								; ... 640 pixel = 80 / 648 pixel = 81 ...

scr_h		= 256				; Bildschirmhöhe in Zeilen
scr_x		= $81				; Startbildschirm, XX-Position (normal $xx81) (129)
scr_y		= $2c				; Startbildschirm, YY-Position (normal $2cxx) (44)
scr_res		= 1					; 2 = HighRes (640*xxx) / 1 = LowRes (320*xxx)
scr_lace	= 1					; 0 = non interlace (xxx*256) / 1 = interlace (xxx*512)
ham			= 0					; 0 = nicht ham / 1 = ham
scr_bpl		= 4					; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe des Bildschirms in Bytes 
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)


START:
;	Zeiger Bild

	MOVE.L	#Logo1,d0			; Zeiger Bild
	LEA	BPLPOINTERS,A1			; Zeiger COP
	MOVEQ	#4-1,D1				; Anzahl Bitplanes (hier sind es 4)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*84,d0			; + Länge der Bitplane (hier sind es 84 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP


	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper								
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$01000,d2			; warte auf Zeile $000
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	BNE.S	Waity1
Waity2:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	Beq.S	Waity2

	btst	#2,$16(A5)			; rechte Maustaste gedrückt?
	beq.s	NonLaceint

	bsr.s	laceint				; Routine-Zeiger ungerade oder gerade Linien
								; je nach LOF-Bit für
								; das Interlace
NonLaceint:
	btst.b	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
	rts

******************************************************************************
; INTERLACE ROUTINE - Testen des Bit LOF (Long Frame) um zu wissen, ob Sie
; gerade oder ungerade Zeilen anzeigen und entsprechend wechseln müssen.
******************************************************************************

LACEINT:
	MOVE.L	#Logo1,D0			; Adresse bitplanes
	btst.b	#15-8,4(A5)			; VPOSR LOF bit?
	Beq.S	Faidispari			; wenn ja, zeigen Sie auf ungerade Zeilen
	ADD.L	#40,D0				; Oder fügen Sie die Länge einer Zeile hinzu,
								; Starten der Ansicht von den geraden Zeilen!
								; zweitens: gerade Zeilen werden angezeigt!
FaiDispari:
	LEA	BPLPOINTERS,A1			; PLANE POINTERS IN COPLIST
	MOVEQ	#4-1,D7				; Anzahl der BITPLANES -1
LACELOOP:
	MOVE.W	D0,6(A1)			; Zeiger auf das Bild
	SWAP	D0
	MOVE.W	D0,2(A1)
	SWAP	D0
	ADD.L	#40*84,D0			; Länge bitplane
	ADDQ.w	#8,A1				; nächste Zeiger
	DBRA	D7,LACELOOP
	RTS

*****************************************************************************
;			Copper List
*****************************************************************************
	section	copper,data_c		; Chip data

Copperlist:
	dc.w	$8e,DIWS			; DiwStrt
	dc.w	$90,DIWSt			; DiwStop
	dc.w	$92,DDFS			; DdfStart
	dc.w	$94,DDFSt			; DdfStop

	dc.w	$102,0				; BplCon1 - scroll register
	dc.w	$104,0				; BplCon2 - priority register
	dc.w	$108,40				; Bpl1Mod - \ INTERLACE: Länge einer Zeile
	dc.w	$10a,40				; Bpl2Mod - / um gerade Zeilen zu überspringen oder anzuzeigen

; Bitplane pointers

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste	 bitplane
	dc.w	$e4,$0000,$e6,$0000	; zweite bitplane
	dc.w	$e8,$0000,$ea,$0000	; dritte bitplane
	dc.w	$ec,$0000,$ee,$0000	; vierte bitplane

;				; 5432109876543210
;	dc.w	$100,%0100001000000100	; BPLCON0 - 4 planes lowres (16 Farben)
;								; INTERLACE (bit 2!)

	dc.w	$100,BPLC0			; BplCon0 - automatisch berechnet


; die ersten 16 Farben sind für das LOGO

	dc.w	$180,$000,$182,$fff,$184,$200,$186,$310
	dc.w	$188,$410,$18a,$620,$18c,$841,$18e,$a73
	dc.w	$190,$b95,$192,$db6,$194,$dc7,$196,$111
	dc.w	$198,$222,$19a,$334,$19c,$99b,$19e,$446

;	Lassen Sie uns eine kleine Nuance für das Bild setzen...

	dc.w	$5607,$fffe			; Wait - $2c+84=$80
	dc.w	$100,$204			; bplcon0 - keine bitplanes, ABER BIT LACE IST GESETZT!
	dc.w	$8007,$fffe			; wait
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

; Design Größe 320 pixel, Höhe 84, mit 4 bitplanes (16 Farben).

Logo1:
	incbin	"/Sources/logo320x84x16c.raw"

	end

Haben Sie bemerkt, dass bei ALLEN bplcon0s der copperliste das Bit 2,
das Interlace, gesetzt sein muss? Wenn der letzte BPLCON0 nicht das
Bit-Set hat, auch wenn es andere auf dem Bildschirm haben, wäre es nicht
Interlaced!

