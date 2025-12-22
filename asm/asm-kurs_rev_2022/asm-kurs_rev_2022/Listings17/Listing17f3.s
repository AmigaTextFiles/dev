
; Listing17f3.s
; vertikale Positionierung eines Lowres-Screens 320x256
; dynamisch	- oberhalb $80
; keine Änderung der DDFSTRT-DDFSTOP Werte

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6				; Execbase
	jsr	-$78(a6)				; Disable
	lea	GfxName(PC),a1			; Libname
	jsr	-$198(a6)				; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop		; speichern die alte COP

;	Pointen auf das "leere" PIC
	MOVE.L	#BITPLANE,d0		; wohin pointen
	LEA	BPLPOINTERS,A1			; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106

Init:
	move #$1a,d7				; start y position
	move #1,d6					; y add

mainloop:
	cmpi.b	#$aa,$dff006		; Zeile $aa?
	bne.s	mainloop

;-----frame loop start---
	btst	#2,$dff016
	beq.s	Warte
	bsr.w	BewegeDIW			; Bewege Screen vertikal (über $FF)

Warte:
	cmpi.b	#$aa,$dff006		; Zeile $aa?
	beq.s	Warte

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mainloop

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

BewegeDIW:
	add.b d6,d7
	cmp.b #$80,d7		; bottom check - sind wir unten?		$80		; tausche diesen Wert mit $FF
	bne ok1				; 				
	neg d6				; change direction	1 wird -1
ok1:
	cmp.b #$1a,d7		; sind wir oben?						$1a
	bne ok2				; 
	neg d6				; change direction
ok2:	
	move.b d7,waitdiw1
	;move.b d7,waitdiw2 ; teste das
	rts


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E
waitdiw1:
	dc.w	$1a81		; DiwStrt		; 1a - kleinster Wert (sichtbar)
	dc.w	$90
waitdiw2:
	dc.w	$80c1		; DiwStop			
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres
	
BPLPOINTERS:
	dc.w	$e0,0,$e2,0	; erste Bitplane

	dc.w	$180,$000	; Color0	; Hintergrund Schwarz
	dc.w	$182,$0f0	; Color1	; Farbe 1 der Bitplane

; ein paar Orientierungsmarken setzen
	dc.w	$2021,$fffe	; 20 ist die erste Zeile die angesprochen werden kann
	dc.w	$180,$aaa
	dc.w	$203f,$fffe	
	dc.w	$180,$000
		
	dc.w	$7f21,$fffe	; 7F bis hier her kann DIWSTRT VV verschoben werden
	dc.w	$180,$aaa
	dc.w	$7f3f,$fffe	
	dc.w	$180,$000
							
	dc.w	$ffff,$fffe	; Ende der Copperlist

BITPLANE:
	blk.b 10240,$55
	;incbin "/Sources/320x256x1_raster.raw"
	blk.b 10240,$00		; Bildschirm reinigen
	end

Als Ergänzung zu Listing17f2.s nochmal ein Beispiel für vertikale DIWSTRT-
Positionen bis $80.