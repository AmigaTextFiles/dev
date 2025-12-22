
; Listing17f4.s
; vertikale Positionierung eines Lowres-Screens 320x256
; dynamisch	- im oberen, unteren und mittleren Bereich gleichzeitig
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
	move #$20,d1				; start y1 position oben
	move #$81,d2				; start y2 position mitte
	move #$20,d3				; start y3 position unten
	move #1,d4					; y1 add
	move #1,d5					; y2 add
	move #1,d6					; y3 add

mainloop:
	cmpi.b	#$aa,$dff006		; Zeile $aa?
	bne.s	mainloop

;-----frame loop start---
	btst	#2,$dff016			; mit rechter Maustaste überspringen
	beq.s	Warte
	bsr.w	BewegeDIW_oben		; Bewege Screen vertikal (oben)
	bsr.w	BewegeDIW_mitte		; Bewege Screen vertikal (mitte)
	bsr.w	BewegeDIW_unten		; Bewege Screen vertikal (unten)

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


BewegeDIW_oben:
	add.b d4,d1
	cmp.b #$80,d1		; bottom check - sind wir unten?		$80
	bne ok1				; 				
	neg d4				; change direction	1 wird -1
ok1:
	cmp.b #$1a,d1		; sind wir oben?						$1a
	bne ok2				; 
	neg d4				; change direction
ok2:	
	move.b d1,waitdiw1
	;move.b d1,waitdiw2 ; teste das
	rts


BewegeDIW_mitte:
	add.b d5,d2
	cmp.b #$FF,d2		; bottom check - sind wir unten?		$FF
	bne ok3				; 			
	neg d5				; change direction	1 wird -1
ok3:
	cmp.b #$81,d2		; sind wir oben?						$81
	bne ok4				; 
	neg d5				; change direction
ok4:	
	move.b d2,waitdiw3
	;move.b d2,waitdiw4 ; teste das
	rts


BewegeDIW_unten:
	add.b d6,d3
	cmp.b #$37,d3		; bottom check - sind wir unten?		$37
	bne ok5				; 			
	neg d6				; change direction	1 wird -1
ok5:
	cmp.b #$0,d3		; sind wir oben?						$0
	bne ok6				; 
	neg d6				; change direction
ok6:	
	;move.b d3,waitdiw5 ; teste das
	move.b d3,waitdiw6
	rts
	

	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0
;----------------------------------------------------------		
	dc.w	$8E
waitdiw1:
	dc.w	$1a81		; DiwStrt		; $1a
	dc.w	$90
waitdiw2:
	dc.w	$80c1		; DiwStop		; $80
;----------------------------------------------------------	
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
	
	dc.w	$7f21,$fffe	; bis $7F kann DIWSTRT VV verschoben werden
	dc.w	$180,$aaa
	dc.w	$7f3f,$fffe	
	dc.w	$180,$000

	dc.w	$8021,$fffe	; FF Zeile 255
	dc.w	$182,$00f	
;----------------------------------------------------------	
	dc.w	$8e
waitdiw3:
	dc.w	$8181		; DiwStrt		; $81
	dc.w	$90
waitdiw4:
	dc.w	$ffc1		; DiwStop		; $FF
;----------------------------------------------------------	
	dc.w	$ff21,$fffe	; FF Zeile 255
	dc.w	$180,$aaa
	dc.w	$ff3f,$fffe	
	dc.w	$180,$000
	dc.w	$182,$0ff
;----------------------------------------------------------	
	dc.w	$8e
waitdiw5:
	dc.w	$FF81		; DiwStrt		; $FF
	dc.w	$90
waitdiw6:
	dc.w	$37c1		; DiwStop		; $37 
;----------------------------------------------------------	
	dc.w	$ffdf,$fffe ; > Zeile 255

	dc.w	$3721,$fffe	; 37 ist die letzt Zeile die angesprochen werden kann
	dc.W	$180,$aaa
	dc.w	$373f,$fffe	
	dc.w	$180,$000	
							
	dc.w	$ffff,$fffe	; Ende der Copperlist

BITPLANE:
	blk.b 10240,$55
	;incbin "/Sources/320x256x1_raster.raw"
	end