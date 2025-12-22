; Listing17f5.s
; vertikale Positionierung eines Lowres-Screens 320x256
; dynamisch	- im oberen, unteren und mittleren Bereich gleichzeitig
; dynamische Änderung der DDFSTRT-DDFSTOP Werte

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern die alte COP

;	Pointen auf das "leere" PIC
	MOVE.L	#BITPLANE,d0			; wohin pointen
	LEA	BPLPOINTERS,A1				; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106

Init:
	move #$20,d1					; start y1 position oben
	move #$81,d2					; start y2 position mitte
	move #$20,d3					; start y3 position unten
	move #1,d4						; y1 add
	move #1,d5						; y2 add
	move #1,d6						; y3 add
	move #$5c,d0					; start x position
	move #$d4,d7					; ende x position

mainloop:
	cmpi.b	#$aa,$dff006			; Zeile $aa?
	bne.s	mainloop

;-----frame loop start---
	btst	#2,$dff016
	beq.s	Warte
	bsr.w   BewegeDIW_x				; bewege Screen auch horizontal
	bsr.w	BewegeDIW_oben			; Bewege Screen vertikal (oben)
	bsr.w	BewegeDIW_mitte			; Bewege Screen vertikal (mitte)
	bsr.w	BewegeDIW_unten			; Bewege Screen vertikal (unten)


Warte:
	cmpi.b	#$aa,$dff006			; Zeile $aa?
	beq.s	Warte
	
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mainloop
	
	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	#$0,$dff088				; Starten die alte SystemCOP

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
	

BewegeDIW_x:
	add.b x_add_start,d0
	sub.b x_add_ende,d7
	cmp.b #$FF,d0		; sind wir rechts?		$80
	bne ok7				; 				
	neg.b x_add_start	; change direction	1 wird -1
	neg.b x_add_ende
ok7:
	cmp.b #$5c,d0		; sind wir links?		$5c
	bne ok8		; 
	neg.b x_add_start	; change direction
	neg.b x_add_ende
ok8:	
	
	lea waitdiw1,a0
	move.b d0,1(a0)
	move.b d7,5(a0)
	bsr ddf_berechnung	; zum Vergleich mit und ohne DDF-Berechnung
	
	lea waitdiw3,a0
	move.b d0,1(a0)
	move.b d7,5(a0)
	;move.w d7,24(a0)	; change color

	lea waitdiw5,a0
	move.b d0,1(a0)
	move.b d7,5(a0)
	rts	

ddf_berechnung:
	movem.l d0-d3,-(a7)
; Eingangswerte		
	;move.l d0,d0		; move.w  #$5c,d0		; H_START in d0	
	move.l d7,d1		; move.w  #$d4,d1		; H_ENDE in d1
; --- DDFSTRT-Berechnung ---	
	move.w	d0,d2		; Kopie
	mulu	#10,d0		; erweitert mit 10	wegen -8.5
	;lsl.w	#3,d0		; d0=d0*8	; mulu optimieren?
	;add.w	d2,d0		; d0=d0*9
	;add.w	d2,d0		; d0=d0+10
	lsr.w	#1,d0		; /2
	sub.w	#85,d0		; wegen -8.5
	divu	#10,d0		; 	 
	and.w	#$FFF8,d0	; Ergebnis in d0    DDFSTRT
; --- DDFSTOP-Berechnung ---	
	add.w	#$100,d1	; DiwStop richtige Größe
	sub.w	d2,d1		; Pixelentfernung  d2=d2-d0  $1d4-$5c=$178
	lsr.l	#1,d1		; /2
	;sub.w	#8,d1		; -8	; ruckelt am rechten Rand
	add		d0,d1		; Ergebnis in d1	DDFSTOP

	;move.b #$20,9(a0)	; DDFSTRT=(HSTRT/2)-8,5 AND $FFF8        //  ($81/2)-8,5 AND $FFF8	 =$38
	;move.b #$d8,13(a0)	; DDFSTOP=DDFSTRT+(PixelproZeile/2-8)    //  $38+(320/2-8)			 =$d0
	
	move.b d0,9(a0)		; DDFSTRT eintragen
	move.b d1,13(a0)	; DDFSTOP eintragen

	movem.l (a7)+,d0-d3
	rts
	

; Variablen
x_add_start:
	dc.b	$1
x_add_ende:
	dc.b	$1
	

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
	dc.w	$1a5c		; DiwStrt		; $1a
	dc.w	$90
waitdiw2:
	dc.w	$80d4		; DiwStop		; $80
;----------------------------------------------------------	
	dc.w	$92,$20		; DdfStart
	dc.w	$94,$d8		; DdfStop
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
	
	dc.w	$7f21,$fffe	; 7F bis hier her kann DIWSTRT VV verschoben werden
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
	blk.b 10240,$55
	;incbin "320x256x1_raster.raw"
	end
