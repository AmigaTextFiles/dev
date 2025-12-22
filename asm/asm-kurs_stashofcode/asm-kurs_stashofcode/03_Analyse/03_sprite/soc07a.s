
; soc07a.s

; a) erklärt Bildung der Werte der Displaywerte und Steuerregister

;********** Konstanten **********

DIWSTRT=$008E
DIWSTOP=$0090
DDFSTRT=$0092
DDFSTOP=$0094
BPLCON0=$0100
BPLCON1=$0102
BPLCON2=$0104
BPL1MOD=$0108
BPL2MOD=$010A

; Programm

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1
COPSIZE=9*4+DISPLAY_DEPTH*2*4+18*4+8*2*4+4
	; 9*4					Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4		für Adressen der Bitebenen
	; 18*4					Palette (Farben 0-1 für Bitplane, 16-31 für Sprite)
	; 8*2*4					für Adressen der Sprites
	; 4						$FFFFFFFE
SPRITE_X=DISPLAY_X+14		; SPRITE_X-1 wird kodiert, da die Anzeige von Bitplanes durch
							; die Hardware um ein Pixel gegenüber der Anzeige von Sprites
							; verzögert wird (nicht dokumentiert).
SPRITE_Y=DISPLAY_Y+14
SPRITE_DX=16				; kann nicht verändert werden
SPRITE_DY=16


;********** Copperlist **********

	;movea.l copperlist,a0
	lea copperlist,a0	

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+						
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0008,(a0)+			; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC,
																		; wenn DISPLAY_DX ein Vielfaches von 16 ist.
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+

	; ... weiter
	
	move.l #$FFFFFFFE,(a0)+
	rts

copperlist:
	blk.w 20,0

	end

;------------------------------------------------------------------------------	
>r
Filename:soc07a.s
>a
Pass1
Pass2
No Errors
>j				
>h.w copperlist

...

;------------------------------------------------------------------------------
; Erklärung:

DIWSTRT=$008E
DIWSTOP=$0090
DDFSTRT=$0092
DDFSTOP=$0094
BPLCON0=$0100
BPLCON1=$0102
BPLCON2=$0104
BPL1MOD=$0108
BPL2MOD=$010A

DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DEPTH=1


	move.w #DIWSTRT,(a0)+														; register DIWSTRT=$008E	dc.w $008E			; DIWS	= (scr_y<<8)+scr_x
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+										;							dc.w $2C81
	
	move.w #DIWSTOP,(a0)+														; register DIWSTOP=$0090	dc.w $0090
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+	; $2C+256-%100000000		dc.w $2CC1
																				; $81+320-%100000000
																				
	move.w #DDFSTRT,(a0)+														; register DDFSTRT=$0092
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+										; $81-17					00000000.00000000.00000000.01000000
																				; $81-17>>1					00000000.00000000.00000000.00111000
																				; (($81-17)>>1)&$00FC		00000000.00000000.00000000.00111000		$38
																					
	move.w #DDFSTOP,(a0)+														; register DDFSTOP=$0094
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+			; Dies entspricht ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC,
																				; wenn DISPLAY_DX ein Vielfaches von 16 ist.
																				
	move.w #BPLCON0,(a0)+														; register BPLCON0=$0100
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+										; DISPLAY_DEPTH<<12			00000000.00000000.00010000.00000000
																				; !$0200					00000000.00000000.00000010.00000000

	move.w #BPLCON1,(a0)+														; register BPLCON1=$0102
	move.w #0,(a0)+
	
	move.w #BPLCON2,(a0)+														; register BPLCON2=$0104
	move.w #$0008,(a0)+																						; PF2P2-0=1 => Bitplane des einzigen Playfields hinter dem Sprite 0
	

	move.w #BPL1MOD,(a0)+														; register BPL1MOD=$0108	
	move.w #0,(a0)+

	; Kompatibilität OCS mit AGA

	move.l #$01FC0000,(a0)+




