
; soc22s2.s
; nach der Programmausführung erreichte Rasterzeile auf dem Bildschirm ausgeben
; ausgehend von einer anfänglich eingestellten Zeile auf die gewartet wird

DEBUGDISPLAYTIME=1
VPOSR=$004
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
COLOR00=$180

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
	
;waitmouse:
;	btst	#2,$dff016				; right mousebutton?
;	bne.s	waitmouse

mainloop:
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	;cmp.l #$00010100,d0				; $101 = 257  angezeigter Wert ist 271, 271-257=14
	cmp.l #$00005600,d0					; $056 = 86   angezeigter Wert ist 100, 100-86=14

; auf Ende des-Rasterdurchlaufs warten
	bne loop
	
	lea $dff000,a5
	IFNE DEBUGDISPLAYTIME
	move.w #$00F0,COLOR00(a5)
	ENDC
;********** DEBUGDISPLAYTIME (start) **********
	; display the decimal number of lines since the end of the
	; screen (ie: since line DISPLAY_Y+DISPLAY_DY included)
	; the frame ends at DISPLAY_Y+DISPLAY_DY-1
	; the time is the number of lines since line DISPLAY_Y+DISPLAY_DY included

;-----------------------------------------------
	movem.l d0-d2/a0-a3,-(sp)		; Register retten

	;clr.w d0						; unnötig ?
	move.l VPOSR(a5),d0				; D0 00C00276		Bit 15 - Bit0 = V8-V0	xxC0xxxx von Interesse
	lsr.l #8,d0						;                                           xxxxxxC0
	and.w #$01FF,d0					
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0	; $2c+256=$12c = 300
	bge _timeBelowBitplanes
									; we looped to the top of the screen
	add.w #1+312-(DISPLAY_Y+DISPLAY_DY-1),d0	; 312 is the very last line that the electron beam may draw
									; (1+312)-($2c+256=$12c-1 = 299) = 313-299=14 = $E
	bra _timeDisplayCounter
_timeBelowBitplanes:
									; we are still at the bottom of the screen
	sub.w #DISPLAY_Y+DISPLAY_DY-1,d0
	

;--- Zeile ---------
	;move.w #100,d0
_timeDisplayCounter:
	and.l #$0000FFFF,d0
	moveq #0,d1
	moveq #3-1,d2
_timeLoopNumber:
	divu #10,d0						; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0				; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
	lsl.l #8,d1
	clr.w d0
	swap d0
	dbf d2,_timeLoopNumber
	
	divu #10,d0						; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0				; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1

									; => d1 : d1 : sequence of 4 ASCII offsets in the font for the 4
									; characters to display, but in reverse order (ex: 123 => "3210")


;--- Zeichen drucken ---------
	;move.l #$11191210,d1			; Zeichen  0291
	lea font8,a0					; Adresse Font 8x8 Pixel			
	lea Bitplane,a1					; Startadresse Bitplane
	moveq #4-1,d0					; Anzahl der Zeichen
_timeLoopDisplay:					; Label Schleife
	clr.w d2	
	move.b d1,d2					; zu druckendes Zeichen in d2 kopieren
	lsl.w #3,d2						; *8, weil Zeichen 8x8 Pixel hat um zu Überspringen
	lea (a0,d2.w),a2				; das entsprechende Zeichen im Font finden (Anfangsadresse)
	move.l a1,a3					; Adresse Bitplane kopieren
	moveq #8-1,d2					; Schleife über 8 Zeilen des Zeichens
_timeLoopDisplayChar:				; Label Schleife Charakter
	move.b (a2)+,(a3)				; Zeichen nach Bitplane kopieren
	;lea DISPLAY_DX>>3(a3),a3		; ?320>>3=$28 = 40Bytes --> nächste Zeile	
	lea 320>>3(a3),a3
	dbf d2,_timeLoopDisplayChar
	lea 1(a1),a1					; 1 Byte vor in Bitplane
	lsr.l #8,d1						; in d1 stehen 4 Werte, den nächsten Wert auswählen
	dbf d0,_timeLoopDisplay

	movem.l (sp)+,d0-d2/a0-a3
;-----------------------------------------------
	move.w #$0000,COLOR00(a5)

	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne	mainloop	

;------------------------
; exit
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
	
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop	
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
	dc.w	$182,$0F0	; Color1	; Farbe 1 der Bitplane
							
	dc.w	$ffff,$fffe	; Ende der Copperlist

font8:		
	INCBIN "font8.fnt"
	
BITPLANE:
	blk.b 10240,$00		; Bildschirm reinigen

	end


