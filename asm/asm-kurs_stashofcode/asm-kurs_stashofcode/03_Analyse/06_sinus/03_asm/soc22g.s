
; soc22g.s
; Blitter init und Blitter draw

DMACONR=$002

BLTAFWM=$044
BLTALWM=$046
BLTAPTL=$052
BLTCPTH=$048
BLTDPTH=$054
BLTAMOD=$064
BLTBMOD=$062
BLTCMOD=$060
BLTDMOD=$066
BLTADAT=$074
BLTBDAT=$072
BLTCON0=$040
BLTCON1=$042
BLTSIZE=$058

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C

LINE_DX=15						; That's the number of lines of the line - 1 : LINE_DX=max (abs(15-0),abs(0,0))
LINE_DY=0						; That's the number of columns of the line - 1 : LINE_DY=min (abs(15-0),abs(0,0))
LINE_OCTANT=1

WAITBLIT:	MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM


	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern die alte COP

	MOVE.L	#BITPLANE,d0			; 
	LEA	BPLPOINTERS,A1				; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106

blit_init:
	lea $dff000,a5
	
	WAITBLIT
	move.w #4*(LINE_DY-LINE_DX),BLTAMOD(a5)			; 4*(0-15)=-60
	move.w #4*LINE_DY,BLTBMOD(a5)					; LINE_DY=0							; That's the number of columns of the line - 1 : LINE_DY=min (abs(15-0),abs(0,0))
	move.w #DISPLAY_DX>>3,BLTCMOD(a5)				; DISPLAY_DX=320	320>>3 (um drei Stellen nach rechts, d.h.durch 8 (2^3) 40 Bytes
	move.w #DISPLAY_DX>>3,BLTDMOD(a5)				; DISPLAY_DX=320	320>>3 (um drei Stellen nach rechts, d.h.durch 8 (2^3) 40 Bytes
	move.w #(4*LINE_DY)-(2*LINE_DX),BLTAPTL(a5)		; (4*0)-(2*15)=-30
	move.w #$FFFF,BLTAFWM(a5)						; alle Bits
	move.w #$FFFF,BLTALWM(a5)						; alle Bits
	move.w #$8000,BLTADAT(a5)						; 1 Pixel!
	move.w #(LINE_OCTANT<<2)!$F041,BLTCON1(a5)		; BSH3-0=15, SIGN=1, OVF=0, SUD/SUL/AUL=octant, SING=0, LINE=1

	bsr blit_line

mainloop:
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

;------------------------

blit_line:
	lea font16,a1
	move.w #0*32,d1			; x*32
	lea (a1,d1.w),a1

	move.w #12,d7									; SCROLL_X  
	lea $dff000,a5
	lea bitplane,a4

	WAITBLIT
	lea LINE_DX*(DISPLAY_DX>>3)(a4),a4				; Ort in Bitplane Offset Ermittlung
	move.l a4,BLTCPTH(a5)							; Quelle
	move.l a4,BLTDPTH(a5)							; Ziel
	move.w (a1),BLTBDAT(a5)							; das Muster, Addresse der aktuellen Spalte von dem Zeichen im Font
	move.w d7,d2									; d2=12
	ror.w #4,d2										; ins hohe Byte verschieben ASH
	or.w #$0B4A,d2									; BLTCON0 zusammenbauen	
	move.w d2,BLTCON0(a5)							; ASH3-0=pixel, USEA=1, USEB=0, USEC=1, USED=1, LF7-0=$4A = Exklusiv-ODER-Operation
	move.w #((LINE_DX+1)<<6)!$0002,BLTSIZE(a5)		; Breite 2 Wörter = 16 Bytes, Höhe	
		
	rts

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
	EVEN
		
font16:
	dc.w $800F, $0000, $0000, $0000, $0000, $0000, $0000, $0000			; erstes Wort wurde angepasst normalerweise $0000
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $33FF, $33FF, $33FF, $33FF
	dc.w $33FF, $33FF, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $0C30, $0C30, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $0C30, $0C30, $FFFC, $FFFC, $FFFC, $FFFC, $0C30, $0C30
	dc.w $0C30, $0C30, $0CCC, $0CCC, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $3FFF, $3FFF, $0CCC, $0CCC, $0300, $0300, $0000, $0000
	dc.w $3C3F, $3C3F, $3F3F, $3F3F, $3F00, $3F00, $03C0, $03C0
	dc.w $00FC, $00FC, $FCFC, $FCFC, $FC3C, $FC3C, $0000, $0000
	dc.w $0F30, $0F30, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $0FFC, $0FFC, $FF30, $FF30, $FCC0, $FCC0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $00CF, $00CF, $00FF, $00FF
	dc.w $003F, $003F, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0FF0, $0FF0
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C, $0000, $0000
	dc.w $300C, $300C, $3FFC, $3FFC, $3FFC, $3FFC, $0FF0, $0FF0
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0300, $0300, $3330, $3330, $3FF0, $3FF0, $0FC0, $0FC0
	dc.w $3FF0, $3FF0, $3330, $3330, $0300, $0300, $0000, $0000
	dc.w $0300, $0300, $0300, $0300, $3FF0, $3FF0, $3FF0, $3FF0
	dc.w $3FF0, $3FF0, $0300, $0300, $0300, $0300, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $CC00, $CC00, $FC00, $FC00
	dc.w $3C00, $3C00, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0300, $0300, $0300, $0300, $0300, $0300, $0300, $0300
	dc.w $0300, $0300, $0300, $0300, $0300, $0300, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3C00, $3C00, $3C00, $3C00
	dc.w $3C00, $3C00, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $FC00, $FC00, $FF00, $FF00, $FF00, $FF00, $03C0, $03C0
	dc.w $00FF, $00FF, $00FF, $00FF, $003F, $003F, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $330C, $330C
	dc.w $30CC, $30CC, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $300C, $300C, $300C, $300C, $3FFC, $3FFC, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $3000, $3000, $3000, $3000, $0000, $0000
	dc.w $3F00, $3F00, $3FCC, $3FCC, $3FCC, $3FCC, $30CC, $30CC
	dc.w $30FC, $30FC, $3CFC, $3CFC, $3C30, $3C30, $0000, $0000
	dc.w $3C3C, $3C3C, $3C3C, $3C3C, $30CC, $30CC, $30CC, $30CC
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $0F30, $0F30, $0000, $0000
	dc.w $0C00, $0C00, $0F00, $0F00, $0FC0, $0FC0, $0CF0, $0CF0
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $0000, $0000
	dc.w $3CFC, $3CFC, $3CFC, $3CFC, $30FC, $30FC, $30CC, $30CC
	dc.w $3FCC, $3FCC, $3FCC, $3FCC, $0F00, $0F00, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3FCC, $3FCC, $0F00, $0F00, $0000, $0000
	dc.w $003C, $003C, $003C, $003C, $FF0C, $FF0C, $FFCC, $FFCC
	dc.w $FFFC, $FFFC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $0F30, $0F30, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3FFC, $3FFC, $0F30, $0F30, $0000, $0000
	dc.w $00F0, $00F0, $33FC, $33FC, $330C, $330C, $330C, $330C
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3CF0, $3CF0, $3CF0, $3CF0
	dc.w $3CF0, $3CF0, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $CCF0, $CCF0, $FCF0, $FCF0
	dc.w $3CF0, $3CF0, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $00C0, $00C0, $03F0, $03F0, $0FFC, $0FFC
	dc.w $3F3F, $3F3F, $3C0F, $3C0F, $3003, $3003, $0000, $0000
	dc.w $0000, $0000, $0CC0, $0CC0, $0CC0, $0CC0, $0CC0, $0CC0
	dc.w $0CC0, $0CC0, $0CC0, $0CC0, $0CC0, $0CC0, $0000, $0000
	dc.w $0000, $0000, $C00C, $C00C, $F03C, $F03C, $FCFC, $FCFC
	dc.w $3FF0, $3FF0, $0FC0, $0FC0, $0300, $0300, $0000, $0000
	dc.w $0030, $0030, $003C, $003C, $330C, $330C, $330C, $330C
	dc.w $33FC, $33FC, $03FC, $03FC, $00F0, $00F0, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $300C, $300C, $33FC, $33FC
	dc.w $33FC, $33FC, $33FC, $33FC, $03F0, $03F0, $0000, $0000
	dc.w $3FF0, $3FF0, $3FFC, $3FFC, $3FFC, $3FFC, $030C, $030C
	dc.w $030C, $030C, $FFFC, $FFFC, $FFF0, $FFF0, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3FFC, $3FFC, $0F30, $0F30, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $300C, $300C, $3C3C, $3C3C, $3C3C, $3C3C, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $300C, $300C, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3C3C, $3C3C, $3C3C, $3C3C, $0000, $0000
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $00CC, $00CC
	dc.w $00CC, $00CC, $003C, $003C, $003C, $003C, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $30CC, $30CC, $3FCC, $3FCC, $3FC0, $3FC0, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $00C0, $00C0
	dc.w $00C0, $00C0, $FFFC, $FFFC, $FFFC, $FFFC, $0000, $0000
	dc.w $300C, $300C, $300C, $300C, $3FFC, $3FFC, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $300C, $300C, $300C, $300C, $0000, $0000
	dc.w $0C00, $0C00, $3C00, $3C00, $3000, $3000, $3000, $3000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $0FFF, $0FFF, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $03F0, $03F0
	dc.w $0FFC, $0FFC, $FF3C, $FF3C, $FC0C, $FC0C, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3000, $3000
	dc.w $3000, $3000, $3C00, $3C00, $3C00, $3C00, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FF0, $3FF0, $03C0, $03C0
	dc.w $00F0, $00F0, $FFFC, $FFFC, $FFFC, $FFFC, $0000, $0000
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFF0, $FFF0, $03C0, $03C0
	dc.w $0F00, $0F00, $3FFF, $3FFF, $3FFF, $3FFF, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $300C, $300C, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $030C, $030C
	dc.w $030C, $030C, $03FC, $03FC, $00F0, $00F0, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $330C, $330C
	dc.w $0F0C, $0F0C, $FCFC, $FCFC, $F3F0, $F3F0, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $030C, $030C
	dc.w $030C, $030C, $FFFC, $FFFC, $FCF0, $FCF0, $0000, $0000
	dc.w $3C00, $3C00, $3C30, $3C30, $30FC, $30FC, $30FC, $30FC
	dc.w $3FCC, $3FCC, $3FCC, $3FCC, $0F00, $0F00, $0000, $0000
	dc.w $000C, $000C, $000C, $000C, $FFFC, $FFFC, $FFFC, $FFFC
	dc.w $FFFC, $FFFC, $000C, $000C, $000C, $000C, $0000, $0000
	dc.w $0FFF, $0FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3000, $3000
	dc.w $3000, $3000, $3FFC, $3FFC, $0FFC, $0FFC, $0000, $0000
	dc.w $00FF, $00FF, $03FF, $03FF, $0FFF, $0FFF, $3C00, $3C00
	dc.w $0F00, $0F00, $03FC, $03FC, $00FC, $00FC, $0000, $0000
	dc.w $0FFF, $0FFF, $3FFF, $3FFF, $0FFF, $0FFF, $03C0, $03C0
	dc.w $0F00, $0F00, $3FFC, $3FFC, $0FFC, $0FFC, $0000, $0000
	dc.w $3C0F, $3C0F, $3F3F, $3F3F, $3FFC, $3FFC, $03F0, $03F0
	dc.w $03FC, $03FC, $FF3C, $FF3C, $FC0C, $FC0C, $0000, $0000
	dc.w $003F, $003F, $00FF, $00FF, $FFFF, $FFFF, $FFC0, $FFC0
	dc.w $FFC0, $FFC0, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $3C3C, $3C3C, $3F3C, $3F3C, $3F0C, $3F0C, $33CC, $33CC
	dc.w $30FC, $30FC, $3CFC, $3CFC, $3C3C, $3C3C, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3FFC, $3FFC, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $300C, $300C, $300C, $300C, $0000, $0000
	dc.w $0000, $0000, $003F, $003F, $00FF, $00FF, $00FF, $00FF
	dc.w $03C0, $03C0, $FF00, $FF00, $FF00, $FF00, $FC00, $FC00
	dc.w $0000, $0000, $300C, $300C, $300C, $300C, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $0000, $0000, $0000, $0000
	dc.w $00C0, $00C0, $0030, $0030, $FFFC, $FFFC, $FFFF, $FFFF
	dc.w $FFFC, $FFFC, $0030, $0030, $00C0, $00C0, $0000, $0000
	dc.w $F000, $F000, $F000, $F000, $F000, $F000, $F000, $F000
	dc.w $F000, $F000, $F000, $F000, $F000, $F000, $F000, $F000
	dc.w $0000, $0000, $0000, $0000, $000F, $000F, $003F, $003F
	dc.w $0033, $0033, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $3FC0, $3FC0, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $0F00, $0F00, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $30C0, $30C0, $30C0, $30C0, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FFF, $3FFF, $3FFF, $3FFF, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $3CC0, $3CC0, $3FC0, $3FC0, $33C0, $33C0, $0000, $0000
	dc.w $0000, $0000, $00C0, $00C0, $FFF0, $FFF0, $FFFC, $FFFC
	dc.w $FFFC, $FFFC, $00CC, $00CC, $000C, $000C, $0000, $0000
	dc.w $0300, $0300, $0FC0, $0FC0, $CFC0, $CFC0, $CCC0, $CCC0
	dc.w $CCC0, $CCC0, $FFC0, $FFC0, $3FC0, $3FC0, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $00C0, $00C0
	dc.w $00C0, $00C0, $3FC0, $3FC0, $3F00, $3F00, $0000, $0000
	dc.w $0000, $0000, $30C0, $30C0, $3FCC, $3FCC, $3FCC, $3FCC
	dc.w $3FCC, $3FCC, $3000, $3000, $0000, $0000, $0000, $0000
	dc.w $3000, $3000, $F000, $F000, $C000, $C000, $C0C0, $C0C0
	dc.w $FFCC, $FFCC, $FFCC, $FFCC, $3FCC, $3FCC, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $0300, $0300
	dc.w $0FC0, $0FC0, $FFC0, $FFC0, $FCC0, $FCC0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $3FFF, $3FFF, $3000, $3000, $0000, $0000, $0000, $0000
	dc.w $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $0F00, $0F00
	dc.w $03C0, $03C0, $3FC0, $3FC0, $3F00, $3F00, $0000, $0000
	dc.w $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $00C0, $00C0
	dc.w $00C0, $00C0, $3FC0, $3FC0, $3F00, $3F00, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $0F00, $0F00, $0000, $0000
	dc.w $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $0F00, $0F00, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $30C0, $30C0, $30C0, $30C0
	dc.w $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $0000, $0000
	dc.w $3FC0, $3FC0, $3FC0, $3FC0, $3F00, $3F00, $03C0, $03C0
	dc.w $00C0, $00C0, $03C0, $03C0, $03C0, $03C0, $0000, $0000
	dc.w $3000, $3000, $3300, $3300, $33C0, $33C0, $3FC0, $3FC0
	dc.w $3FC0, $3FC0, $3CC0, $3CC0, $0CC0, $0CC0, $0000, $0000
	dc.w $0000, $0000, $0030, $0030, $0FFF, $0FFF, $3FFF, $3FFF
	dc.w $3FFF, $3FFF, $3030, $3030, $3000, $3000, $0000, $0000
	dc.w $0FC0, $0FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3000, $3000
	dc.w $3000, $3000, $3FC0, $3FC0, $3FC0, $3FC0, $0000, $0000
	dc.w $03C0, $03C0, $0FC0, $0FC0, $3FC0, $3FC0, $3C00, $3C00
	dc.w $3C00, $3C00, $0FC0, $0FC0, $03C0, $03C0, $0000, $0000
	dc.w $0FC0, $0FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3C00, $3C00
	dc.w $0F00, $0F00, $3FC0, $3FC0, $0FC0, $0FC0, $0000, $0000
	dc.w $30C0, $30C0, $3FC0, $3FC0, $3FC0, $3FC0, $0F00, $0F00
	dc.w $0F00, $0F00, $3FC0, $3FC0, $30C0, $30C0, $0000, $0000
	dc.w $03C0, $03C0, $CFC0, $CFC0, $CC00, $CC00, $CC00, $CC00
	dc.w $FFC0, $FFC0, $FFC0, $FFC0, $3FC0, $3FC0, $0000, $0000
	dc.w $30C0, $30C0, $3CC0, $3CC0, $3FC0, $3FC0, $3FC0, $3FC0
	dc.w $3FC0, $3FC0, $33C0, $33C0, $30C0, $30C0, $0000, $0000
	dc.w $0000, $0000, $00C0, $00C0, $0FFC, $0FFC, $3FFF, $3FFF
	dc.w $3F3F, $3F3F, $3003, $3003, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $C00C, $C00C, $FCFC, $FCFC
	dc.w $FFFC, $FFFC, $3FF0, $3FF0, $0300, $0300, $0000, $0000
	dc.w $0000, $0000, $FCFF, $FCFF, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $0FC0, $0FC0
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000


BITPLANE:
	blk.b 10240,$00		; Bildschirm reinigen

	end


Programmbeschreibung:

Die Pixelspalten werden hier mit dem Blitter in die Bitebene kopiert. Dafür 
wird der Linienmodus verwendet und eingerichtet. Die Linie die dabei 
gezeichnet wird entspricht einem 16 Bit-Muster.
Das Muster kommt in BLTBDAT und die Linie wird senkrecht von unten nach oben
gezeichnet. Dies entspricht dem Oktant 1.
Der Beginn der Linie ist somit jeweils 16 Zeilen tiefer auf der Bitebene.
Der horizontale Beginn in dem Word der Zeile wird durch einen 
Verschiebungswert in ASH angegeben und dieser wird über Register d7 übergeben.
d7=0	; Pixelspalte beginnt ganz links 
d7=15	; Pixelspalte beginnt 15 Bits nach rechts versetzt

Initialisierung usw. erfolgt entsprechend für den Linien-Modus.	

	