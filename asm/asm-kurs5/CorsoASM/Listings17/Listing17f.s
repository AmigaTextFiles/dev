; Listing17f.s 
; Positionierung eines Lowres-Screens 320x256 und Overscan-Screens
; durch Änderung der DIWSTRT-DIWSTOP und DDFSTRT-DDFSTOP Werte
; zusätzlich Sprite-Positionierung
; mit rechter Maustaste Screen-Verschiebung überspringen
; mit linker Maustaste raus

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

;	Pointen auf den Sprite
	MOVE.L	#MEINSPRITE,d0			; Adresse des Sprite in d0
	LEA	SpritePointers,a1			; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106
	
	moveq	#0,d2					; Startwert Zähler
	lea	diwtab,a0
	lea	diwtab_end,a1
	lea diwddf,a2

	lea sprite_pos,a3
	lea sprite_pos_end,a4
	lea MEINSPRITE,a5

mainloop: 
	move.l $dff004,d1
	and.l #$000fff00,d1
	cmp.l #$00013700,d1				; auf Ende des-Rasterdurchlaufs warten
	bne.s	mainloop
	add		#1,d2					
	cmp		#200,d2					; etwas Zeit verschwenden
	blo.s mainloop

	moveq	#0,d2					; Startwert Zähler zurücksetzen
	btst	#2,$dff016				; rechte Maustaste gedrückt?
	bne.s	weiter					; wenn nicht, bewege_diw überspringen	
	bsr	bewege_diw					; wenn ja, bewege Screen
weiter
	bsr	bewege_sprite				; bewege sprites

mouse:
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mainloop


	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	d0,$dff088				; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)					; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)					; Closelibrary
	rts					

bewege_diw:	
	move.l (a0)+,(a2)+				; Datensatz kopieren
	move.l (a0)+,(a2)+
	move.l (a0)+,(a2)+
	move.l (a0)+,(a2)
	lea diwddf,a2					
	cmp.l  a0,a1					; am Ende der Tabelle angekommen?
	bne.s no						; wenn nicht überspringen
	lea diwtab,a0					; Tabelle wieder von vorn 	
no:
	rts

bewege_sprite:
	move.l (a3)+,(a5)				; Datensatz kopieren 
	cmp.l  a3,a4					; am Ende der Tabelle angekommen?
	bne.s no2						; wenn nicht überspringen
	lea sprite_pos,a3				; Tabelle wieder von vorn 	
no2:
	rts

	
;	Daten
GfxName:
	dc.b	"graphics.library",0,0
GfxBase:
	dc.l	0
OldCop:
	dc.l	0

; Hier ist die Tabelle mit den DIW- und DDF-Werten
; die Hardwareregister sind nur der Übersicht wegen aufgeführt
; also nicht weg optimiert...

diwtab:			
	dc.w $8e,$2c81,$90,$2cc1,$92,$38,$94,$d0	; 1. normale Bildschirmposition für (320x256)	
	dc.w $8e,$1a5c,$90,$1a9c,$92,$20,$94,$b8	; 2. linke, obere Ecke   - DiwStop ($5c+320=$19c=412)
	dc.w $8e,$1a94,$90,$1ad4,$92,$40,$94,$d8	; 3. rechte, obere Ecke  - DiwStop ($94+320=$1d4=468)
	dc.w $8e,$385c,$90,$389c,$92,$20,$94,$b8	; 4. linke, untere Ecke  - DiwStop ($5c+320=$19c=412)
	dc.w $8e,$3894,$90,$38d4,$92,$40,$94,$d8	; 5. rechte, untere Ecke - DiwStop ($94+320=$1d4=468)
	dc.w $8e,$1a81,$90,$1ac1,$92,$38,$94,$d0	; 6. das Bild ist ganz oben $1a bis $11a		26 bis 282 (26+256=282)
	dc.w $8e,$3781,$90,$37c1,$92,$38,$94,$d0	; 7. das Bild ist ganz unten $37 bis $137		55 bis 311 (55+256=311)
	dc.w $8e,$FF81,$90,$37c1,$92,$38,$94,$d0	; 8. maximale verschiebung nach unten	
	dc.w $8e,$1a5c,$90,$38d4,$92,$20,$94,$d8	; 9. Overscan
	dc.w $8e,$1b51,$90,$37d1,$92,$20,$94,$d8	; 10. Copper list for a 384 x 284 screen: (photons overscan) 
	dc.w $8e,$30b1,$90,$f891,$92,$50,$94,$b8	; 11. irgendein mittlerer Screen
	dc.w $8e,$2c71,$90,$2cc1,$92,$30,$94,$d0	; 12. Some games used 336x256 (DDF 30 to d0)
	dc.w $8e,$1aFF,$90,$389c,$92,$70,$94,$b8	; 13. DIWSTRT horizontal ist maximal $FF=255
	dc.w $8e,$1a5c,$90,$3800,$92,$20,$94,$70	; 14. DIWSTOP horizontal ist minimal $(1)00=256
	dc.w $8e,$1aFF,$90,$3800,$92,$70,$94,$70	; 15. schmalster Screen ever
diwtab_end:	


; Hier ist die Tabelle mit den Sprite-Positionswerten

sprite_pos:					; VSTART,HSTART,VSTOP		
	dc.b $2c,$40,$39,$00	; normale Position links oben
	dc.b $2c,$d8,$39,$00	; normale Position rechts oben
	dc.b $f2,$40,$FF,$00	; normale Position links unten bis $FF
	dc.b $f2,$d8,$FF,$00	; normale Position rechts unten bis $FF
	dc.b $1F,$40,$2c,$06	; normale Position links unten
	dc.b $1F,$d8,$2c,$06	; normale Position rechts unten
	dc.b $1a,$32,$27,$00	; Overscan - Position links oben	
	dc.b $1a,$de,$27,$00	; Overscan - Position rechts oben						
	dc.b $2a,$32,$37,$06	; Overscan - Position links unten	
	dc.b $2a,$de,$37,$06	; Overscan - Position rechts unten
	dc.b $1a,$2a,$27,$00	; Overscan - Position links oben	; fast verschwunden
	dc.b $1a,$e5,$27,$00	; Overscan - Position rechts oben	; fast verschwunden
	dc.b $2a,$2a,$37,$06	; Overscan - Position links unten	; fast verschwunden
	dc.b $2a,$e5,$37,$06	; Overscan - Position rechts unten	; fast verschwunden
sprite_pos_end:


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

diwddf:
	dc.w $8e,$1a5c,$90,$38d4,$92,$20,$94,$d8	; diese Werte werden ausgetauscht	
;----------------------------------------------------------	
	;dc.w	$8E,$2c81	; DiwStrt
	;dc.w	$90,$2cc1	; DiwStop
	;dc.w	$92,$38		; DdfStart
	;dc.w	$94,$d0		; DdfStop
;----------------------------------------------------------
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

			    ; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres
	
BPLPOINTERS:
	dc.w	$e0,0,$e2,0	; erste Bitplane

	dc.w	$180,$000	; Color0	; Hintergrund Schwarz
	dc.w	$182,$080	; Color1	; Farbe 1 der Bitplane

	dc.w	$1A2,$F00	; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$0F0	; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$FF0	; Color19, oder COLOR3 des Sprite0 - GELB
							
	dc.w	$ffff,$fffe	; Ende der Copperlist


 ************ Hier ist der Sprite: NATÜRLICH muß er in CHIP RAM sein! ************

MEINSPRITE:	  ; Länge 13 Zeilen
VSTART:
	dc.b $1a  ; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART:
	dc.b $e5  ; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP:
	dc.b $27  ; $30+13=$3d - Vertikale Endposition des Sprite
	dc.b $00																						
																						
 dc.w	%0000000000000000,%0000110000110000 ; Binäres Format für ev. Änderungen			
 dc.w	%0000000000000000,%0000011001100000
 dc.w	%0000000000000000,%0000001001000000
 dc.w	%0000000110000000,%0011000110001100 ;BINÄR 00=COLOR 0 (Transparent)
 dc.w	%0000011111100000,%0110011111100110 ;BINÄR 10=COLOR 1 (ROT)
 dc.w	%0000011111100000,%1100100110010011 ;BINÄR 01=COLOR 2 (GRÜN)
 dc.w	%0000110110110000,%1111100110011111 ;BINÄR 11=COLOR 3 (GELB)
 dc.w	%0000011111100000,%0000011111100000
 dc.w	%0000011111100000,%0001111001111000
 dc.w	%0000001111000000,%0011101111011100
 dc.w	%0000000110000000,%0011000110001100
 dc.w	%0000000000000000,%1111000000001111
 dc.w	%0000000000000000,%1111000000001111
 dc.w	0,0	; 2 word auf NULL definieren das Ende des Sprite.

BITPLANE:
	blk.b 10240,$80		; für 320x256						$FF für Vollbild
	blk.b 10240,$80		; wegen overscan mehr Bilddaten		$FF für Vollbild
	;incbin "320x256x1_raster.raw"
	blk.b 10240,$00		; Bildschirm reinigen
	end


