	
; Listing19s1b.s
; geripptes Bild "in Betrieb nehmen"

	SECTION CiriCop,CODE


Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern die alte COP
	
	MOVE.L	#BITPLANE,d0			; wohin pointen
	LEA	BPLPOINTERS,A1				; Bitplane-Pointer
	MOVEQ	#1,D1					; Anzahl der Bitplanes -1 (hier sind es 2)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*200,d0				; Logohöhe 200 Zeilen
	addq.w	#8,a1
	dbra	d1,POINTBP				; Wiederhole D1 mal POINTBP (D1=num of bitplanes)
	
	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106
	
mouse:
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mouse
	
	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	d0,$dff088				; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)					; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)					; Closelibrary
	rts					

;	Daten
GfxName:
	dc.b	"graphics.library",0,0
GfxBase:
	dc.l	0
OldCop:
	dc.l	0


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$0100, $0200
	dc.w	$102,0	; $24		; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod

	dc.w	$8E,$0581			; DiwStrt	; screen mit workbench hand 1.3
	dc.w	$90,$40C1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	
	dc.w	$2b01, $fffe
colors:
	dc.w	$0180,$0fff,$0182,$0000,$0184,$077c,$0186,$0bbb
BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste  Bitplane - BPL0PT
	dc.w	$e4,0,$e6,0			; zweite Bitplane - BPL1PT
	
	dc.w	$2c01, $fffe
	dc.w	$0100, $2200
	dc.w	$0180, $000F		; blau

	dc.w	$8c01, $fffe			
	dc.w	$0180, $0FF0		; gelb

	dc.w	$ec01, $fffe
	dc.w	$0100, $0200			
	dc.w	$0180, $0FFF		; weiß
							
	dc.w	$ffff,$fffe			; Ende der Copperlist
	
BITPLANE:
	incbin "Hand"

	end

	