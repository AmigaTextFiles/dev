
; Der Wechsel zum Burst-Modus für das Lesen von Bitplanes. Die Adressen der Bitplanes müssten nicht mehr ausgerichtet werden.
; Burst total
; Dies ermöglicht eine Steigerung von 70 auf 
; BPL1MOD	0     => -8
; BPL2MOD	0     => -8
; DDFSTRT	$0038 => $0038
; DDFSTOP	$00D0 => $00D8
; DIWSTRT	$2C81 => $2C81
; DIWSTOP	$2CC1 => $2CC1
; FMODE		$0000 => $0003
; Burst weniger wahrscheinlich :
; Damit kann man von 70 auf 150 Partikel erhöhen!
; BPL1MOD	0     => -4
; BPL2MOD	0     => -4
; DDFSTRT	$0038 => $0038
; DDFSTOP	$00D0 => $00D8
; DIWSTRT	$2C81 => $2C81
; DIWSTOP	$2CC1 => $2CC1
; FMODE		$0000 => $0001

; Achtung, es gibt möglicherweise ein Problem, das am Anfang von base.s erwähnt wurde.

; ToDo: Anteil von Chip- und beliebigen Daten
; ToDo:  Auftreten des Half-Bright-Bereichs
; ToDo: Endgültige Fertigstellung des Endes: Trübung des Bildschirms durch weiße 16x16-Quadrate, die von der Zeile 
; nach oben gehen, Zeile für Zeile von Quadrat zu Quadrat, wobei jede Zeile in einer zufälligen Reihenfolge gefüllt wird?

; Hinweis : Um die Farbe N zu ändern, müssen Sie auf die richtige Palette mit 32 Farben gehen:
; (N/32)*33 = (N>>5)*(1<<5+1) = N&$FFE0 + N>>5
; und mit 4 multiplizieren:
; ((N & $FFE0) >> 3) + ((N & $FFE0) << 2)
; damit erreicht man die Palette von 32 Farben.
; dann muss man den Rest multipliziert mit 4 dazuzählen :
; ((N & $FFE0) << 2) + ((N & $FFE0) >> 3) + ((N & $001F) << 2)
; das ist gleichbedeutend mit :
; ((N & $FFE0) >> 3) + (N << 2)
	
	

;-------------------------------------------------------------------------------
;                   .oO Scoopex "ONE" (AGA version) [v6.1] Oo.
;                              A tribute to coders
;
; An first intro for the glorious Scoopex Amiga group, produced in May 2018 and fixed in March 2019.
;
;                Code & Design: Yragael (stashofcode@gmail.com)
;                            Logo & Design: alien^pdx
;                           Music: Notorious / Scoopex
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

; Dieses Werk wird unter den Bedingungen der Lizenz (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Namensnennung
; - Keine kommerzielle Nutzung 4.0 International zur Verfügung gestellt.

; TO DO: See remark in _ptTestTTL

;********** Directives **********

	SECTION code,CODE_C

;********** Constants **********

;Program

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=8
	IFNE DISPLAY_DEPTH>5
DISPLAY_NBPALETTES=(1<<DISPLAY_DEPTH)>>5
DISPLAY_PALETTESIZE=32
	ELSE
DISPLAY_NBPALETTES=1
DISPLAY_PALETTESIZE=1<<DISPLAY_DEPTH
	ENDIF
SP_COPPERLIST=10*4+DISPLAY_DEPTH*2*4+DISPLAY_NBPALETTES*(1+DISPLAY_PALETTESIZE)*4+4
	; 10*4											Display configuration
	; DISPLAY_DEPTH*2*4								Bitplanes addresses
	; DISPLAY_NBPALETTES*(1+DISPLAY_PALETTESIZE)*4	Palette
	; 4												$FFFFFFFE
PT_COPPERLIST=10*4+DISPLAY_DEPTH*2*4+(256/32)*(1+32)*4+4+2*(4+16*4)+4
	; 10*4											Display configuration
	; DISPLAY_DEPTH*2*4								Bitplanes addresses
	; (256/32)*(1+32)*4								Palette (256 colors)
	; 4+2*(4+16*4)									Text color
	; 4												$FFFFFFFE
DEBUG=0
TUNE=1

;********** Macros **********

WAIT_BLITTER:		MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)		; Means testing bit 14%8=6 of the most
	bne _waitBlitter0\@			; significant byte of DMACONR, which is BBUSY
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM

WAIT_ENDOFFRAME:	MACRO
_waitEndOfFrame\@
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0
	blt _waitEndOfFrame\@
	ENDM

;********** Initialisierung **********

; Stack registers

	movem.l d0-d7/a0-a6,-(sp)

; StingRay's stuff
	
	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)				; OpenLibrary ()
	move.l d0,graphicsBase
	move.l graphicsBase,a6
	move.l $22(a6),view
	movea.l #0,a1
	jsr -222(a6)				; LoadView ()
	jsr -270(a6)				; WaitTOF ()
	jsr -270(a6)				; WaitTOF ()
	jsr -228(a6)				; WaitBlit ()
	jsr -456(a6)				; OwnBlitter ()
	move.l graphicsBase,a1
	movea.l $4,a6
	jsr -414(a6)				; CloseLibrary ()

	moveq #0,d0					; Default VBR is $0
	movea.l $4,a6
	btst #0,296+1(a6)			; 68010+?
	beq _is68000
	lea _getVBR,a5
	jsr -30(a6)					; SuperVisor ()
	move.l d0,VBRPointer
	bra _is68000
_getVBR:
	;movec vbr,d0
	dc.l $4e7a0801				; movec vbr,d0
	rte
_is68000:

; Shut down the system

	jsr -132(a6)

; Allocate CHIP memory set to 0 for the front buffer
; (DISPLAY_DEPTH bitplanes) and the back buffer
; (2 bitplanes for triple buffering)

	move.l #(DISPLAY_DEPTH+2)*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	jsr -198(a6)
	move.l d0,bitplanes

; Allocate CHIP memory set to 0 for the Copper lists

	move.l #SP_COPPERLIST,d0
	move.l #$10002,d1
	jsr -198(a6)
	move.l d0,spCopperList

	move.l #PT_COPPERLIST,d0
	move.l #$10002,d1
	jsr -198(a6)
	move.l d0,ptCopperList

; Wait for VERTB (to avoid sprites drooling) and shut down the
; hardware interrupts and the DMAs

	lea $DFF000,a5
	jsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

; Restore level 6 interrupt for the tune player

	move.l VBRPointer,a0
	lea $78(a0),a0
	move.l (a0),vector30
	move.w #$E000,INTENA(a5)

; Activate the DMAs for the Blitter

	move.w #$8240,DMACON(a5)	; DMAEN=1, BLTEN=1

;********** Data creation **********

;---------- Generate bitmaps for the animation of a particle ----------

	lea ptParticleBitmaps,a0
	lea ptParticleBitmapsShifted,a1
	moveq #PARTICLE_NBKEYS-1,d0
_ptShiftParticleBitmaps:

; Copy the bitmap

	movea.l a0,a2
	movea.l a1,a3
	REPT 8
	move.b (a2),(a3)
	lea 2(a3),a3
	lea PARTICLE_NBKEYS(a2),a2
	ENDR

; Generate the 7 bitmaps for 7 consecutive shifts of one pixel
; to the right of the bitmap

	moveq #8-2,d1
_particleShiftBitmap:
	moveq #8-1,d2
_particleShiftRow:
	move.w (a1)+,d3
	lsr.w #1,d3
	move.w d3,(a3)+
	dbf d2,_particleShiftRow
	dbf d1,_particleShiftBitmap

; Next bitmap

	movea.l a3,a1
	lea 1(a0),a0
	dbf d0,_ptShiftParticleBitmaps

;---------- Generate animation of a particle ----------

PARTICLE_SEEDS=5
NB_PARTICLES=300	
PARTICLE_DX=8		; Do not touch!
PARTICLE_DY=8		; Do not touch!
PARTICLE_VX=0
PARTICLE_VY=0
PARTICLE_DELAY=2
PARTICLE_SPEED=2
PARTICLE_TTL=NB_PARTICLES*PARTICLE_DELAY/PARTICLE_SEEDS
					; At least NB_PARTICLES*PARTICLE_DELAY/PARTICLE_SEEDS
					; for displaying NB_PARTICLES
PARTICLE_NBKEYS=8	; The bitmaps for the animation of the particle
					; (see ptParticleBitmaps)
PARTICLE_DISC=1		; 0: Square, 1: Disc
PATH_LENGTH=360
PATH_DELAY=600

; Generate the animation of a particle according to its TTL
; (warning: TTL increases in this loop, but it will decreases in the main loop)

	lea ptParticleAnimation,a0
	move.w #-1,ptAccumulator0
	move.w #-1,ptAccumulator1
	move.w #PARTICLE_NBKEYS-1,d6
	move.w #1,d7
	move.w #PARTICLE_TTL,d5
_particleAnimate:

; Animate the bitmap

	move.w #PARTICLE_NBKEYS-1,d0
	move.w #0,d1
	move.w #PARTICLE_TTL,d2
	move.w ptAccumulator0,d3
	move.w d6,d4
	jsr _interpolate
	move.w d3,ptAccumulator0
	move.w d4,d6
	mulu #8*8*2,d4
	move.w d4,(a0)+

; Animate the speed

	move.w #1,d0
	move.w #PARTICLE_SPEED,d1
	move.w #PARTICLE_TTL,d2
	move.w ptAccumulator1,d3
	move.w d7,d4
	jsr _interpolate
	move.w d3,ptAccumulator1
	move.w d4,d7
	move.w d4,(a0)+

	subq.w #1,d5
	beq _particleAnimateDone
	bra _particleAnimate
_particleAnimateDone:

;********** Splash screen **********

; The bitmap is displayed gradually. It is hidden with a mask in bitplane SP_MASK_BITPLANE
; of color SP_MASK_COLOR. Pulsating 8x8 squares are displayed over the mask in bitplane
; SP_SQUARES_BITPLANE in color SP_SQUARES_COLOR. The scenario for one square plays as follows:
; - The mask behind the square hides the bitmap
; - After a given start delay, the squares starts growing
; - The squares grows until it covers 8x8 pixels (ie : untils its frame is
;   SP_SQUARES_NBFRAMES>>1, the one that is filled)
; - The mask behind the square is cleared
; - The square animation is played in a loop (pulsation)
; - After a given time-to-live (SP_SQUARES_TTL), the square finishes its current animation
;   (ie: until its frame is 0, the one that is empty)
; Each square has a given start delay and an index for its current frame. Those are stored
; in spSquaresData. The start delays are random, the start frame is always 0.

; This part ends when the last active square is deactivated, which happens when its TTL reaches
; -SP_SQUARES_TLL and the index of the frame in its animation (ptSquareBitmaps) reaches 0. Note that:
; - The TTL is not decremented before the square has grown until it covers 8x8 pixels for the first time
; - Then the TTL is decremented on each loop
; - The TTL may reach -SP_SQUARES_TLL before its frame reaches 0. In this case, the animation keeps
; on playing until the frame is 0, and then the square is deactivated
;
; For example, if a square start delay is 5, SP_SQUARES_NBFRAMES=4, SP_SQUARES_TTL=7:
;
;             TTL > 0 (5 to 1)    TTL = 0       TTL < 0 (-1 to -7)
;          |<----------------->|<--------->|<------------------------->|
;TTL (in):   5   4   3   2   1   0   0   0  -1  -2  -3  -4  -5  -6  -7  -7  -7  -7  -7  -7  -7  -7
;          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---
;Frame:    | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2 | 1 | 0 | 3 | 2 | 1 | 0 | 3 | 2 | 1 | 0 |-1 |-1 |-1 |...
;          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---
;TTL (out):  4   3   2   1   0   0   0  -1  -2  -3  -4  -5  -6  -7  -7  -7  -7  -7  -7  -7  -7  -7
;
; To read this (in the loop, the square is displayed, then animated):
;
;                               B                                  B   D
;         +---+               +---+                              +---+---+
; Display | A | then test TTL | A | then change TTL or/and image | A | C |
;         +---+               +---+                              +---+---+
;                                                                  D
;
; All of this means that the exact length of this part, measured in VERTB, is quite difficult to
; compute ("/" being an integer division), which may be a problem to find the exact values so that
; the part is synchronized with the tune. Better try some values until this works.

SP_BITMAP_DX=320		; Must be multiple of 8 (square width)
SP_BITMAP_DY=64			; Must be multiple of 8 (square height)
SP_BITMAP_DEPTH=4
SP_BITMAP_X=0			; Must be multiple of 8 (square width)
SP_BITMAP_Y=0
SP_SQUARES_BITPLANE=5	; Warning! Number, and not index, of the bitplane (ie: first bitplane is 1)
SP_SQUARES_SPEED=2
SP_SQUARES_NBFRAMES=8
SP_SQUARES_COLOR=$0FFF
SP_SQUARES_ANIMATION=1
SP_SQUARES_TTL=25		; Must be <= 127
SP_MASK_BITPLANE=6		; Warning! Number, and not index, of the bitplane (ie: first bitplane is 1)
SP_MASK_COLOR=$0000
SP_WAIT=80

;---------- Copper list ----------

	movea.l spCopperList,a0

; Screen configuration

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #((DISPLAY_DEPTH&$0007)<<12)!((DISPLAY_DEPTH&$0008)<<1)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #$0038,(a0)+		; Retrieved by disassembling the Workbench AGA Copper list :)
	move.w #DDFSTOP,(a0)+
	move.w #$00D8,(a0)+		; Retrieved by disassembling the Workbench AGA Copper list :)
	move.w #BPL1MOD,(a0)+
	move.w #-8,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #-8,(a0)+

; AGA burst mode

	move.w #FMODE,(a0)+
	move.w #$0003,(a0)+

; Bitplanes addresses

	move.w #BPL1PTH,d0
	move.l bitplanes,d1
	move.w #DISPLAY_DEPTH-1,d2
_spCopperListBitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+	
	addq.w #2,d0
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d1
	dbf d2,_spCopperListBitplanes

	;Palette

	IFNE DEBUG
	movem.l a0,-(sp)
	ENDC
	clr.w d0
	moveq #DISPLAY_NBPALETTES-1,d1
_spCopperListPalettes:
	move.w #BPLCON3,(a0)+
	move.w d0,(a0)+
	addi.w #$2000,d0
	move.w #COLOR00,d2
	move.w #DISPLAY_PALETTESIZE-1,d3
_spCopperListPalette:
	move.w d2,(a0)+
	addq.w #2,d2
	move.w #$0000,(a0)+
	dbf d3,_spCopperListPalette
	dbf d1,_spCopperListPalettes
	IFNE DEBUG
	movem.l (sp)+,a1
	move.l #$01820000,4(a1)		; A kind of NOP to preserve COLOR00 for debuging while keeping the size of the palette
	ENDC

; End of Copper list

	move.l #$FFFFFFFE,(a0)

; Activate the DMAs for the Copper (BLTEN already set)

	moveq #1,d0
	jsr _wait
	move.w #$8180,DMACON(a5)	; BPLEN=1, COPEN=1

; Start the Copper list

	move.l spCopperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;---------- Initializations ----------

; Set the bitmap palette

	lea spBitmap,a0
	add.l #SP_BITMAP_DEPTH*SP_BITMAP_DY*(SP_BITMAP_DX>>3),a0
	movea.l spCopperList,a1
	move.w #10*4+DISPLAY_DEPTH*2*4+4+2,d0
	move.w #(1<<SP_BITMAP_DEPTH)-1,d1
_spSetBitmapPalette:
	move.w (a0)+,(a1,d0.w)
	addq.w #4,d0
	dbf d1,_spSetBitmapPalette

; Set the color in the palette for the mask

	movea.l spCopperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4(a0),a0
	move.w #SP_MASK_BITPLANE,d0
	move.w #SP_MASK_COLOR,d1
	move.W #DISPLAY_DEPTH,d2
	bsr _setBitplaneColor

; Set the color in the palette for the squares
; (override the color in the palette for the mask)

	movea.l spCopperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4(a0),a0
	move.w #SP_SQUARES_BITPLANE,d0
	move.w #SP_SQUARES_COLOR,d1
	move.W #DISPLAY_DEPTH,d2
	bsr _setBitplaneColor

; Fill the mask (no Blitter because SP_BITMAP_X and/or SP_BITMAP_DX
; may not be multiples of 16, and it may prove useful to fill the
; mask with squares if some pattern would have to be drawn)

	movea.l bitplanes,a0
	add.l #(SP_MASK_BITPLANE-1)*DISPLAY_DY*(DISPLAY_DX>>3)+SP_BITMAP_Y*(DISPLAY_DX>>3)+(SP_BITMAP_X>>3),a0
	move.l a0,spMask

	move.w #(SP_BITMAP_DY>>3)-1,d1
_spFillMaskY:
	move.w #(SP_BITMAP_DX>>3)-1,d0
_spFillMaskX:
	movea.l a0,a1
	REPT 8
	move.b #$FF,(a1)
	lea DISPLAY_DX>>3(a1),a1
	ENDR
	lea 1(a0),a0
	dbf d0,_spFillMaskX
	lea 7*(DISPLAY_DX>>3)+((DISPLAY_DX-SP_BITMAP_DX)>>3)(a0),a0
	dbf d1,_spFillMaskY

; Copy the bitmap (BOB copy, because it's as fun as it is useless here,
; and it is a ready-to-use BOB copy routine) (no RAW Blitter copy because
; it would require the bitmap depth to match the screen depth and I don't
; want to waste 4 bitplanes in the bitmap data)

	WAIT_BLITTER
	lea spBitmap,a0
	move.w #SP_BITMAP_X,d0
	move.w d0,d1
	and.w #$F,d0
	ror.w #4,d0
	or.w #$0BFA,d0				; ASH3-0=shift, USEA=1, USEB=0, USEC=1, USED=1, D=A+C
	move.w d0,BLTCON0(a5)
	lsr.w #3,d1
	and.b #$FE,d1
	move.w #SP_BITMAP_Y*(DISPLAY_DX>>3),d0
	add.w d1,d0
	movea.l bitplanes,a1
	lea (a1,d0.w),a1
	move.w #$0000,BLTCON1(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$0000,BLTALWM(a5)
	move.w #-2,BLTAMOD(a5)
	move.w #(DISPLAY_DX-(SP_BITMAP_DX+16))>>3,BLTCMOD(a5)
	move.w #(DISPLAY_DX-(SP_BITMAP_DX+16))>>3,BLTDMOD(a5)
	move.w #SP_BITMAP_DEPTH-1,d0
_spCopyBitmap:
	move.l a0,BLTAPTH(a5)
	move.l a1,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SP_BITMAP_DY,BLTSIZV(a5)
	move.w #(SP_BITMAP_DX+16)>>4,BLTSIZH(a5)
	lea SP_BITMAP_DY*(SP_BITMAP_DX>>3)(a0),a0
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a1),a1
	WAIT_BLITTER	
	dbf d0,_spCopyBitmap

; Generate random start indices for the squares

;	lea spSquareIndices,a0
;	move.w #(SP_BITMAP_DX>>3)*(SP_BITMAP_DY>>3)-1,d0
;_spSquaresCreateData:
;	;TODO (I'm too lazy, so this has been precomputed in Excel)
;	dbf d0,_spSquaresCreateData

; Set the backBuffer pointer

	move.l bitplanes,d0
	addi.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l d0,backBuffer

; Start the tune

	IFNE TUNE
	lea $DFF000,a6
	lea module,a0
	moveq #0,d0 ;start at pattern 0
	bsr mt_init
	moveq #1,d0 ;PAL timing
	move.l VBRPointer,a0
	bsr mt_install_cia
;	lea mt_Enable(pc),a0
	movea.l #mt_Enable,a0
	st (a0)
	ENDC

; ---------- Main loop ----------

	move.w #(SP_BITMAP_DX>>3)*(SP_BITMAP_DY>>3),d7
_spLoop:

; Draw squares

	WAIT_BLITTER

	movea.l backBuffer,a0
	add.l #SP_BITMAP_Y*(DISPLAY_DX>>3)+(SP_BITMAP_X>>3),a0
	lea spSquaresData,a1
	clr.w d0
	clr.w d3
	move.w #(SP_BITMAP_DY>>3)-1,d1
_spDrawSquaresY:
	move.w #(SP_BITMAP_DX>>3)-1,d2
_spDrawSquaresX:
	lea 1(a1),a1
	move.b (a1)+,d3
	blt _spSkipSquare		; Image index is -1: square won't be displayed anymore (not required, optimization)
	lsl.b #3,d3
	ext.w d3
	lea spSquareBitmaps,a2
	lea (a2,d3.w),a2
	move.w d0,d3
	REPT 8
	move.b (a2)+,(a0,d3.w)
	addi.w #DISPLAY_DX>>3,d3
	ENDR
_spSkipSquare:
	addq.w #1,d0
	dbf d2,_spDrawSquaresX
	addi.w #7*(DISPLAY_DX>>3)+((DISPLAY_DX-SP_BITMAP_DX)>>3),d0
	dbf d1,_spDrawSquaresY

; Swap the bitplane

	moveq #SP_SQUARES_SPEED,d0
	jsr _wait

	move.l spCopperList,a0
	lea 10*4+(SP_SQUARES_BITPLANE-1)*2*4+2(a0),a0
	move.w (a0),d0
	swap d0
	move.w 4(a0),d0
	move.l backBuffer,d1
	move.l d0,backBuffer
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)

; Clear the new backBuffer (warning: no final WAIT_BLITTER here)

	move.w #0,BLTDMOD(a5)
	move.w #$01CC,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w #$0000,BLTBDAT(a5)	; According to the HRM, always load this
								; register AFTER setting the shift value for B in BLTCON1
	move.l backBuffer,BLTDPTH(a5)
	move.w #DISPLAY_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)

; Animate the squares

	movea.l spMask,a1
	move.b #SP_BITMAP_DX>>3,d1
	move.w #(SP_BITMAP_DX>>3)*(SP_BITMAP_DY>>3)-1,d0
	lea spSquaresData,a0
_spAnimationLoop:
	move.b (a0)+,d2
	ble _spAnimationRun

; (1) Wait until square start delay has expired

	subq.b #1,d2
	move.b d2,-1(a0)
	lea 1(a0),a0
	bra _spAnimationNext

;(2) If square TTL has not expired, animate the square...:
; - If square has not yet fully grown for the first time,
;   animate the square and keep its TTL to 0
; - If square has fully grow for the first time, clear the mask
;   behind it, animate the square and decrement its TTL
; - In other cases, animate the square and decrement its TTL

_spAnimationRun:
	bne _spAnimationRunCheckTTL
	cmpi.b #SP_SQUARES_NBFRAMES>>1,(a0)
	bne _spAnimationRunNextFrame
	move.l a1,a2
	REPT 8
	move.b #$00,(a2)
	lea DISPLAY_DX>>3(a2),a2
	ENDR
	bra _spAnimationRunDecrementTTL

_spAnimationRunCheckTTL:
	cmpi.b #-SP_SQUARES_TTL,d2
	beq _spAnimationEnd
_spAnimationRunDecrementTTL:
	subq.b #1,d2
	move.b d2,-1(a0)

_spAnimationRunNextFrame:
	move.b (a0)+,d2
	bne _spAnimationRunNoAnimationLoop
	move.b #SP_SQUARES_NBFRAMES-1,-1(a0)
	bra _spAnimationNext
_spAnimationRunNoAnimationLoop:
	subq.b #1,d2
	move.b d2,-1(a0)
	bra _spAnimationNext

; (3) ...else finish the square animation

_spAnimationEnd:
	move.b (a0)+,d2
	bgt _spAnimationEndNextFrame
	blt _spAnimationNext
	move.b #-1,-1(a0)	; Image index is -1: square won't be
			 ; displayed anymore (not required, optimization)
	subq.w #1,d7
	beq _spEnd
	bra _spAnimationNext
_spAnimationEndNextFrame:
	subq.b #1,d2
	move.b d2,-1(a0)

; Move pointer in the mask

_spAnimationNext:
	subq.b #1,d1
	beq _spAnimationMaskNewLine
	lea 1(a1),a1
	bra _spAnimationMaskDone
_spAnimationMaskNewLine:
	lea ((DISPLAY_DX-SP_BITMAP_DX)>>3)+1+7*(DISPLAY_DX>>3)(a1),a1
	move.b #SP_BITMAP_DX>>3,d1
_spAnimationMaskDone:

	dbf d0,_spAnimationLoop

	;Loop

	bra _spLoop
_spEnd:

	;Wait a bit

;	WAIT_BLITTER
	move.w #SP_WAIT,d0
	jsr _wait

;********** Transition **********

;Starting from this point :
;
;DISPLAY_DEPTH = 8
;SP_BITMAP_DEPTH = 4
;Bitmap is displayed in bitplanes 1 to 3
;SP_BITMAP_DY <= DISPLAY_DX>>1 (this allows reverse copy)

; Set the color in the palette for the mask to background
; color to hide what is going to happen in bitplane SP_MASK_BITPLANE

	movea.l spCopperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4(a0),a0
	move.w #SP_MASK_BITPLANE,d0
	move.w #$0000,d1
	move.W #DISPLAY_DEPTH,d2
	bsr _setBitplaneColor

; Set the color in the palette for the squares to background color
; to hide what is going to happen in bitplane SP_SQUARES_BITPLANE

	move.w #SP_SQUARES_BITPLANE,d0
	move.w #SP_SQUARES_COLOR,d1
	bsr _setBitplaneColor

; Wait until the raster has drawn the bitmap (what follows does
; occur before the VERTB, so no flickering)

	move.w #DISPLAY_Y+SP_BITMAP_DY,d0
	jsr _waitRaster

; Copy bitmap from bitplanes 1 and 3 to bitplanes 5 and 7

	move.w #$05CC,BLTCON0(a5)	; USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTBMOD(a5)
	move.w #0,BLTDMOD(a5)
	movea.l bitplanes,a0
	movea.l a0,a1
	add.l #SP_BITMAP_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),a1
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SP_BITMAP_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)
	WAIT_BLITTER
	lea 2*DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	lea 2*DISPLAY_DY*(DISPLAY_DX>>3)(a1),a1
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SP_BITMAP_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)
	WAIT_BLITTER

; Copy bitmap from bitplanes 2 and 4 to bitplanes 6 and 8 upside
; down since even bitplanes are being inverted
; (SP_BITMAP_DY must be <= DISPLAY_DY>>1 for this to work)

	move.w #-2*(DISPLAY_DX>>3),BLTDMOD(a5)
	movea.l bitplanes,a0
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	movea.l a0,a1
	add.l #(SP_BITMAP_DEPTH*DISPLAY_DY+DISPLAY_DY-1)*(DISPLAY_DX>>3),a1
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SP_BITMAP_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)
	WAIT_BLITTER
	lea 2*DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	lea 2*DISPLAY_DY*(DISPLAY_DX>>3)(a1),a1
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #SP_BITMAP_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)
	WAIT_BLITTER

; Clear the bitmap in bitplanes 1 to 4

	movea.l bitplanes,a0
	move.w #0,BLTDMOD(a5)
	move.w #$01CC,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w #$0000,BLTBDAT(a5)
	move.w #SP_BITMAP_DEPTH-1,d0
_clearBitmap:
	move.l a0,BLTDPTH(a5)
	move.w #SP_BITMAP_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	WAIT_BLITTER
	dbf d0,_clearBitmap

; Reverse even bitplanes, among which bitplanes 6 and 8

	movea.l spCopperList,a0
	move.w #-((DISPLAY_DX>>3)<<1),8*4+2(a0)

	lea 10*4+2*4+2(a0),a0
	move.l bitplanes,d0
	addi.l #(2*DISPLAY_DY-1)*(DISPLAY_DX>>3),d0	
	moveq #(DISPLAY_DEPTH>>1)-1,d1
_reverseEvenBitplanes:
	swap d0
	move.w d0,(a0)
	swap d0
	move.w d0,4(a0)
	lea 4*4(a0),a0
	addi.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	dbf d1,_reverseEvenBitplanes

; Set colors %xxxx0000 to bitmap palette to show the bitmap
; that is now drawn in bitplanes 5 to 8
; %00010000 (16) = color 1 of the bitmap
; %00100000 (32) = color 2 of the bitmap
; %00110000 (48) = color 3 of the bitmap
; %01000000 (64) = color 4 of the bitmap
; ...
; One color every 16 colors only because bitplanes 1 to 4 have been cleared

	lea spBitmap,a0
	add.l #SP_BITMAP_DEPTH*SP_BITMAP_DY*(SP_BITMAP_DX>>3)+2,a0	; All colors but COLOR00
	movea.l spCopperList,a1
	lea 10*4+DISPLAY_DEPTH*2*4+4+16*4+2(a1),a1
	moveq #16,d0
	move.w #(1<<SP_BITMAP_DEPTH)-2,d1							; All colors but COLOR00
_setBitmapPalette:
	move.w (a0)+,(a1)
	lea 16*4(a1),a1
	subi.w #16,d0
	bne _setBitmapPaletteKeepPalette
	lea 4(a1),a1
	moveq #32,d0
_setBitmapPaletteKeepPalette:
	dbf d1,_setBitmapPalette

;********** Particles **********

HALFBRIGHT_BITPLANE=6		; Do not touch!
HALFBRIGHT_COLOR=$0333
HALFBRIGHT_Y=SP_BITMAP_DY+2*8-1
HALFBRIGHT_DY=DISPLAY_DY-SP_BITMAP_DY-5*8	; Must be even because will be
							; shrinked by half size in both up and down directions during ending
HALFBRIGHT_LINESSPEED=4		; May be 1, 2, 4, 8
TEXT_BITPLANE=5				; Do not touch!
TEXT_COLOR=$0FFF
TEXT_Y=HALFBRIGHT_Y+8
TEXT_DY=HALFBRIGHT_DY-16
TEXT_CHARDELAY=1
TEXT_PAGEDELAY=100
FLAG_BEGINNING_INPROGRESS=0
FLAG_BEGINNING_LINESDRAWN=1
FLAG_ENDING_INPROGRESS=2
FLAG_ENDING_AREASHRINKED=3
FLAG_ENDING_LINESERASED=4

;---------- Copper list ----------

	movea.l ptCopperList,a0

; Screen configuration

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #((DISPLAY_DEPTH&$0007)<<12)!((DISPLAY_DEPTH&$0008)<<1)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #$0038,(a0)+		; Retrieved by disassembling the Workbench AGA Copper list :)
	move.w #DDFSTOP,(a0)+
	move.w #$00D8,(a0)+		; Retrieved by disassembling the Workbench AGA Copper list :)
	move.w #BPL1MOD,(a0)+
	move.w #-8,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #-((DISPLAY_DX>>3)<<1)-8,(a0)+

; AGA burst mode

	move.w #FMODE,(a0)+
	move.w #$0003,(a0)+

; Bitplanes addresses (even planes are reversed for doubling the number of particles)

	move.l bitplanes,d0
	move.w #BPL1PTH,d1
	moveq #(DISPLAY_DEPTH>>1)-1,d2
_ptCopperListOddBitplanes:
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #6,d1
	swap d0
	move.w d0,(a0)+
	addi.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	dbf d2,_ptCopperListOddBitplanes

	move.l bitplanes,d0
	addi.l #(2*DISPLAY_DY-1)*(DISPLAY_DX>>3),d0	
	move.w #BPL2PTH,d1
	moveq #(DISPLAY_DEPTH>>1)-1,d2
_ptCopperListEvenBitplanes:
	move.w d1,(a0)+
	addq.w #2,d1
	swap d0
	move.w d0,(a0)+
	move.w d1,(a0)+
	addq.w #6,d1
	swap d0
	move.w d0,(a0)+
	addi.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	dbf d2,_ptCopperListEvenBitplanes

; Palette

	IFNE DEBUG
	movem.l a0,-(sp)
	ENDC
	clr.w d0
	moveq #(256/32)-1,d1
_ptCopperListPalettes:
	move.w #BPLCON3,(a0)+
	move.w d0,(a0)+
	addi.w #$2000,d0
	move.w #COLOR00,d2
	move.w #32-1,d3
_ptCopperListPalette:
	move.w d2,(a0)+
	addq.w #2,d2
	move.w #$0000,(a0)+
	dbf d3,_ptCopperListPalette
	dbf d1,_ptCopperListPalettes
	IFNE DEBUG
	movem.l (sp)+,a1
	move.l #$01820000,4(a1)		; A kind of NOP to preserve COLOR00 for
								; debuging while keeping the size of the palette
	ENDC

; Text color that must apply to:
;
; - colors %00010000 (16) to %00011111 (31) to override the particles
; - colord %00110000 (48) to %00111111 (63) to override the half-bright area

	move.w #(DISPLAY_Y+HALFBRIGHT_Y-2)<<8!$0001,(a0)+	; -1 because white lines have been
								; added before and after the half-bright area
								; -1 because too many MOVEs for the Copper to execute
								; them before the first pixel of the top white line is drawn
	move.w #$FFFE,(a0)+

	move.w #BPLCON3,(a0)+
	move.w #$0000,(a0)+
	move.w #COLOR16,d0
	moveq #16-1,d1
_ptCopperListTextColorParticles:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #TEXT_COLOR,(a0)+
	dbf d1,_ptCopperListTextColorParticles

	move.w #BPLCON3,(a0)+
	move.w #$2000,(a0)+
	move.w #COLOR16,d0
	moveq #16-1,d1
_ptCopperListTextColorHalfBright:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w #TEXT_COLOR,(a0)+
	dbf d1,_ptCopperListTextColorHalfBright

; End of Copper list

	move.l #$FFFFFFFE,(a0)

; Start the Copper list

	moveq #1,d0
	jsr _wait
	move.w #$8180,DMACON(a5)	; BPLEN=1, COPEN=1
	move.l ptCopperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;---------- Initializations ----------

; Set the bitmap palette

	lea spBitmap,a0
	add.l #SP_BITMAP_DEPTH*SP_BITMAP_DY*(SP_BITMAP_DX>>3)+2,a0	; All colors but COLOR00
	movea.l ptCopperList,a1
	lea 10*4+DISPLAY_DEPTH*2*4+4+16*4+2(a1),a1
	move.w #16,d0
	move.w #(1<<SP_BITMAP_DEPTH)-2,d1							; All colors but COLOR00
_ptSetBitmapPalette:
	moveq #16-1,d2
_ptSetBitmapPaletteColor:
	move.w (a0),(a1)
	lea 4(a1),a1
	dbf d2,_ptSetBitmapPaletteColor
	subi.w #16,d0
	bne _ptSetBitmapPaletteKeepPalette
	lea 4(a1),a1
	move.w #32,d0
_ptSetBitmapPaletteKeepPalette:
	lea 2(a0),a0
	dbf d1,_ptSetBitmapPalette

; Printer setup

	lea prtPrinterSetupData,a0
	move.l bitplanes,d0
	addi.l #((TEXT_BITPLANE-1)*DISPLAY_DY+TEXT_Y)*(DISPLAY_DX>>3),d0
	move.l d0,OFFSET_PRINTERSETUP_BITPLANE(a0)
	move.w #DISPLAY_DX>>3,OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0)
	move.w #0,OFFSET_PRINTERSETUP_BITPLANEMODULO(a0)
	move.w #TEXT_DY,OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a0)
	move.b #TEXT_CHARDELAY,OFFSET_PRINTERSETUP_CHARDELAY(a0)
	move.b #TEXT_PAGEDELAY,OFFSET_PRINTERSETUP_PAGEDELAY(a0)
	move.l #font,OFFSET_PRINTERSETUP_FONT(a0)
	move.l #printerText,OFFSET_PRINTERSETUP_TEXT(a0)
	bsr _prtSetup

; Particles setup

	move.w #NB_PARTICLES,ptMaxNbParticles
	move.w #0,ptNbParticles
	clr.w d6
	move.w #PARTICLE_DELAY,d7
	move.l #ptParticlesStart,ptFirstParticle
	move.l ptFirstParticle,ptNextParticle
	move.l #ptPalettesStart,ptPalette
	move.w #1,ptPaletteDelay	; Not PARTICLE_DELAY because palette for particles
			; has not yet been set (all black) so this must expired in the first loop
	move.w #PATH_DELAY,ptPathDelay
	move.l #ptPathDataStart,ptPathData
	
; Set the backBuffer pointer

	move.l bitplanes,d0
	addi.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l d0,ptBackBufferA
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l d0,ptBackBufferB

; Set flags and various variables for beginning and ending sequences

	move.w #HALFBRIGHT_LINESSPEED,ptHalfBrightLinesHalfWidth
	move.w #0,ptHalfBrightHalfHeight
	move.b #(1<<FLAG_BEGINNING_INPROGRESS),ptFlags

; ---------- Main loop (D6 and D7 reserved) ----------

_ptLoop:

;########## Beginning ##########
	
	move.b ptFlags,d0
	btst #FLAG_BEGINNING_INPROGRESS,d0
	beq _ptNoBeginning

	; (1) Expand lines to the left and to the right until their width 
	; is DISPLAY_DX (have fun guessing how this works with any speed 1, 2, 4 and 8 !)

	btst #FLAG_BEGINNING_LINESDRAWN,d0
	bne _ptLinesDrawn

	movea.l bitplanes,a0
	add.l #((TEXT_BITPLANE-1)*DISPLAY_DY+HALFBRIGHT_Y-1+(HALFBRIGHT_DY>>1))*(DISPLAY_DX>>3),a0
	move.w ptHalfBrightLinesHalfWidth,d1

	move.w #(DISPLAY_DX>>1)-1,d2
	add.w d1,d2											; D2 = XrEnd = XrStart + W - 1 with XrStart = DISPLAY_DX>>1
	move.w d2,d3
	and.b #$07,d3
	addq.b #1,d3
	move.b #$FF>>(8-HALFBRIGHT_LINESSPEED),d4			; 1: %00000001, 2: %00000011, 4: %00001111, 8:%11111111
	ror.b d3,d4
	lsr.w #3,d2
	or.b d4,(a0,d2.w)
	or.b d4,DISPLAY_DX>>3(a0,d2.w)

	move.w #DISPLAY_DX>>1,d2
	sub.w d1,d2											; D2 = XlEnd = XlStart - W + 1 with XlStart = DISPLAY_DX>> 1 - 1
	move.w d2,d3
	not.b d3
	and.b #$07,d3
	addq.b #1,d3										; ~D3 = 7 - D3, so ~D3 + 1 = 8 - D3
	move.b #($FF<<(8-HALFBRIGHT_LINESSPEED))&$FF,d4		; 1: %10000000, 2: %11000000, 4: %11110000, 8:%11111111
	rol.b d3,d4
	lsr.w #3,d2
	or.b d4,(a0,d2.w)
	or.b d4,DISPLAY_DX>>3(a0,d2.w)

	addq.w #HALFBRIGHT_LINESSPEED,d1
	move.w d1,ptHalfBrightLinesHalfWidth
	cmpi.w #DISPLAY_DX>>1,d1
	bne _ptDrawLinesNotDone
	bset #FLAG_BEGINNING_LINESDRAWN,d0
	move.b d0,ptFlags
_ptDrawLinesNotDone:
	bra _ptNoBeginning

	; (2) Expand the half-bright area (fucking offsets!
	; I must confess: I used test320x152x1.raw to check)
	
_ptLinesDrawn:	
	move.w ptHalfBrightHalfHeight,d0
	addi.w #DISPLAY_DX>>3,d0		; Notice that D0 = DISPLAY_DX>>3 the first time
	ext.l d0

	movea.l bitplanes,a0
	move.l #((TEXT_BITPLANE-1)*DISPLAY_DY+HALFBRIGHT_Y+(HALFBRIGHT_DY>>1)-1)*(DISPLAY_DX>>3),d1
	sub.l d0,d1
	add.l d1,a0

	movea.l bitplanes,a1
	move.l #((HALFBRIGHT_BITPLANE-1)*DISPLAY_DY+DISPLAY_DY-HALFBRIGHT_Y-(HALFBRIGHT_DY>>1)-1)*(DISPLAY_DX>>3),d1	; Bitplane is upside down!
	add.l d0,d1
	add.l d1,a1

	lea ptHalfBrightBitmap,a2
	lea (HALFBRIGHT_DY>>1)*(DISPLAY_DX>>3)(a2),a2
	sub.l d0,a2

	move.w #(DISPLAY_DX>>5)-1,d1
_ptRaiseTopLine:
	move.l #$00000000,DISPLAY_DX>>3(a0)
	move.l #$FFFFFFFF,(a0)+
	move.l (a2)+,(a1)+
	dbf d1,_ptRaiseTopLine

	movea.l bitplanes,a0
	move.l #((TEXT_BITPLANE-1)*DISPLAY_DY+HALFBRIGHT_Y+(HALFBRIGHT_DY>>1))*(DISPLAY_DX>>3),d1
	add.l d0,d1
	add.l d1,a0

	movea.l bitplanes,a1
	move.l #((HALFBRIGHT_BITPLANE-1)*DISPLAY_DY+DISPLAY_DY-HALFBRIGHT_Y-(HALFBRIGHT_DY>>1))*(DISPLAY_DX>>3),d1		; Bitplane is upside down!
	sub.l d0,d1
	add.l d1,a1

	lea ptHalfBrightBitmap,a2
	lea ((HALFBRIGHT_DY>>1)-1)*(DISPLAY_DX>>3)(a2),a2
	add.l d0,a2

	move.w #(DISPLAY_DX>>5)-1,d1
_ptLowerBottomLine:
	move.l #$00000000,-DISPLAY_DX>>3(a0)
	move.l #$FFFFFFFF,(a0)+
	move.l (a2)+,(a1)+
	dbf d1,_ptLowerBottomLine

	move.w d0,ptHalfBrightHalfHeight
	cmpi.w #(HALFBRIGHT_DY>>1)*(DISPLAY_DX>>3),d0
	bne _ptMoveLinesNotDone
	bclr #FLAG_BEGINNING_INPROGRESS,d0
	move.b d0,ptFlags
_ptMoveLinesNotDone:

_ptNoBeginning:

; ########## Printer ##########

	move.b ptFlags,d0
	and.b #(1<<FLAG_BEGINNING_INPROGRESS)!(1<<FLAG_ENDING_INPROGRESS),d0
	bne _ptNoPrinter
	bsr _prtPrint
_ptNoPrinter:

; ########## Particles ##########

;---------- Draw the particles and the generators ----------

; Display the number of particles (debug)

	IFNE DEBUG
	movem.l d0/a0,-(sp)
	movea.l bitplanes,a0
	lea 8*(DISPLAY_DX>>3)(a0),a0
	move.w ptNbParticles,d0
	jsr _print4Digits
	movem.l (sp)+,d0/a0
	ENDC

; Remove particles of which TTL has expired (ie : equal to 0) by moving
; the pointer to the data for the particles of which TTL has not expired
; is moved in the circular list of data for the particles

	movea.l ptFirstParticle,a0
	move.w ptNbParticles,d0
	beq _ptTestTTLDone
_ptTestTTL:
	tst.w OFFSET_PARTICLE_TTL(a0)
	bne _ptTestTTLEnd
	lea DATASIZE_PARTICLE(a0),a0
	cmp.l #ptParticlesEnd,a0
	bne _ptTestTTLNoListLoop
	lea ptParticlesStart,a0
_ptTestTTLNoListLoop:
	subq.w #1,d0
	bne _ptTestTTL
_ptTestTTLEnd:
	move.l a0,ptFirstParticle
	move.w d0,ptNbParticles
_ptTestTTLDone:

; Draw the particles

	movea.l ptFirstParticle,a0
	move.w ptNbParticles,d0
_ptDrawParticles:
	beq _ptDrawParticlesEnd

	move.w OFFSET_PARTICLE_BITMAP(a0),d1

	move.w OFFSET_PARTICLE_X(a0),d2
	move.w OFFSET_PARTICLE_Y(a0),d3
	mulu #DISPLAY_DX>>3,d3
	move.w d2,d4
	lsr.w #3,d4
	add.w d4,d3
	and.w #$0007,d2

	lsl.w #4,d2		; D2 contains the offset for the key bitmap,
					; and 1 bitmap = 8 * 2 bytes, thereby a maximum
					; offset of 7 * 8 * 2 = 128 bytes
	add.w d2,d1
	lea ptParticleBitmapsShifted,a1
	lea (a1,d1.w),a1
	movea.l ptBackBufferB,a2
	REPT 8
	move.b (a1)+,d1
	or.b d1,(a2,d3.w)
	move.b (a1)+,d1
	or.b d1,1(a2,d3.w)
	addi.w #DISPLAY_DX>>3,d3
	ENDR

	lea DATASIZE_PARTICLE(a0),a0
	cmp.l #ptParticlesEnd,a0
	bne _ptDrawParticlesNoListLoop
	lea ptParticlesStart,a0
_ptDrawParticlesNoListLoop
	subq.w #1,d0
	bra _ptDrawParticles
_ptDrawParticlesEnd:

; Draw the generators

	movea.l ptPathData,a0
	moveq #PARTICLE_SEEDS-1,d3
	move.w d6,d4
_ptDrawParticleSeeds:

	move.w OFFSET_PATH_X(a0,d4.w),d0
	move.w OFFSET_PATH_Y(a0,d4.w),d1
	mulu #DISPLAY_DX>>3,d1
	move.w d0,d2
	lsr.w #3,d2
	add.w d2,d1
	and.w #$0007,d0

	lsl.w #4,d0		; D2 contains the offset of the key bitmap,
					; and 1 bitmap = 8 * 2 bytes, thereby a maximum 
					; offset of 7 * 8 * 2 = 128 bytes
	lea ptParticleBitmapsShifted,a1
	lea (a1,d0.w),a1
	movea.l ptBackBufferB,a2
	REPT 8
	move.b (a1)+,d0
	or.b d0,(a2,d1.w)
	move.b (a1)+,d0
	or.b d0,1(a2,d1.w)
	addi.w #DISPLAY_DX>>3,d1
	ENDR

	subi.w #(PATH_LENGTH/PARTICLE_SEEDS)*DATASIZE_PATH,d4
	bge _ptDrawParticleSeedsNoUnderflow
	addi.w #PATH_LENGTH*DATASIZE_PATH,d4
_ptDrawParticleSeedsNoUnderflow:

	dbf d3,_ptDrawParticleSeeds

;---------- Animate the particles and the generators ----------

; Move the particles, decrease their TTL, set their bitmap according to their TTL

	movea.l ptFirstParticle,a0
	lea ptParticleAnimation,a1
	move.w ptNbParticles,d0
_ptMoveParticles:
	beq _ptMoveParticlesEnd

; Move the particle
	
	move.w OFFSET_PARTICLE_X(a0),d1
	move.w OFFSET_PARTICLE_Y(a0),d2
	move.w OFFSET_PARTICLE_ACCUMULATOR(a0),d3
	move.w OFFSET_PARTICLE_SPEED(a0),d4
_ptMoveParticleSpeedLoop:
	add.w OFFSET_PARTICLE_MINDXDY(a0),d3
	cmp.w OFFSET_PARTICLE_MAXDXDY(a0),d3
	blt _ptMoveParticlesNoAccumlatorOverflow
	sub.w OFFSET_PARTICLE_MAXDXDY(a0),d3
	add.w OFFSET_PARTICLE_INCX1(a0),d1
	add.w OFFSET_PARTICLE_INCY1(a0),d2
_ptMoveParticlesNoAccumlatorOverflow:
	add.w OFFSET_PARTICLE_INCX0(a0),d1
	add.w OFFSET_PARTICLE_INCY0(a0),d2
	subq #1,d4
	bne _ptMoveParticleSpeedLoop
	move.w d3,OFFSET_PARTICLE_ACCUMULATOR(a0)

; Constrain the position of the particle and make it fall if
; it strikes the upper, left or right border

	tst.w d1
	bge _ptMoveParticleNoXUnderflow
	moveq #0,d1
	neg.w OFFSET_PARTICLE_INCX0(a0)
	neg.w OFFSET_PARTICLE_INCX1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
	bra _ptMoveParticleNoXOverflow
_ptMoveParticleNoXUnderflow:
	cmp.w #DISPLAY_DX-PARTICLE_DX,d1
	ble _ptMoveParticleNoXOverflow
	move.w #DISPLAY_DX-PARTICLE_DX,d1
	neg.w OFFSET_PARTICLE_INCX0(a0)
	neg.w OFFSET_PARTICLE_INCX1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
_ptMoveParticleNoXOverflow:

	tst.w d2
	bge _ptMoveParticleNoYUnderflow
	moveq #0,d2
	neg.w OFFSET_PARTICLE_INCY0(a0)
	neg.w OFFSET_PARTICLE_INCY1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
	bra _ptMoveParticleNoYOverflow
_ptMoveParticleNoYUnderflow:
	cmp.w #DISPLAY_DY-PARTICLE_DY,d2
	ble _ptMoveParticleNoYOverflow
	move.w #DISPLAY_DY-PARTICLE_DY,d2
	neg.w OFFSET_PARTICLE_INCY0(a0)
	neg.w OFFSET_PARTICLE_INCY1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
_ptMoveParticleNoYOverflow:

	move.w d1,OFFSET_PARTICLE_X(a0)
	move.w d2,OFFSET_PARTICLE_Y(a0)

; Decrease the TTL of the particle

	move.w OFFSET_PARTICLE_TTL(a0),d1
	subq.w #1,d1
	move.w d1,OFFSET_PARTICLE_TTL(a0)

; Set the bitmap and the speed of the particle according to its TTL

	lsl.w #2,d1		; This is mulu #DATASIZE_ANIMATION,d1 but we may optimize since DATASIZE_ANIMATION = 4
	move.w OFFSET_ANIMATION_BITMAP(a1,d1.w),OFFSET_PARTICLE_BITMAP(a0)		; Get the offset for the key bitmap according to the TTL
	move.w OFFSET_ANIMATION_SPEED(a1,d1.w),OFFSET_PARTICLE_SPEED(a0)

	lea DATASIZE_PARTICLE(a0),a0
	cmp.l #ptParticlesEnd,a0
	bne _ptMoveParticlesNoListLoop
	lea ptParticlesStart,a0
_ptMoveParticlesNoListLoop:
	subq.w #1,d0
	bra _ptMoveParticles
_ptMoveParticlesEnd:

;---------- Generate one particle per generator ----------

; Do not generate any particle if the delay between two generations has not expired
	
	movea.l ptNextParticle,a1
	tst.w d7
	bne _ptNoNewParticleAndWait

; Particles generation loop

	movea.l ptPathData,a0
	move.w d6,d4
	moveq #PARTICLE_SEEDS-1,d5
_ptNewParticle:

; Exit the particles generation loop if the maximum number of particles has been reached
 
	move.w ptNbParticles,d0
	cmp.w ptMaxNbParticles,d0
	bge _ptNoNewParticle

; Generate a particle at the current generator position

	addq.w #1,d0
	move.w d0,ptNbParticles

	move.w #0*8*8*2,OFFSET_PARTICLE_BITMAP(a1)	; Where 0 is the number of the key bitmap : 0 (8x8), 1 (7x7), 2 (6x6), etc.
	move.w OFFSET_PATH_X(a0,d4.w),OFFSET_PARTICLE_X(a1)
	move.w OFFSET_PATH_Y(a0,d4.w),OFFSET_PARTICLE_Y(a1)
	move.w #PARTICLE_SPEED,OFFSET_PARTICLE_SPEED(a1)
	move.w #PARTICLE_TTL,OFFSET_PARTICLE_TTL(a1)
	moveq #1,d2
	move.w #PARTICLE_VX,d0
	add.w OFFSET_PATH_DX(a0,d4.w),d0
	bge _ptNewParticleDXPositive
	neg.w d0							; D0 = |DX|
	moveq #-1,d2						; D2 = IncX
_ptNewParticleDXPositive:
	moveq #1,d3
	move.w #PARTICLE_VY,d1
	add.w OFFSET_PATH_DY(a0,d4.w),d1
	bge _ptNewParticleDYPositive
	neg.w d1							; D1 = |DY|
	moveq #-1,d3						; D3 = IncY
_ptNewParticleDYPositive:

	btst #0,VHPOSR+1(a5)				; Randomize (|DX| += 2 * bit #1 of raster X position)
					; so that high frequency generated consecutives particles are not aligned
	beq _sngNewParticleNoRandomnessX
	addq.w #2,d0
_sngNewParticleNoRandomnessX:
	btst #0,VHPOSR(a5)					; Randomize (|DY| += 2 * bit #0 of raster Y position)
					; so that high frequency generated consecutives particles are not aligned
	beq _sngNewParticleNoRandomnessY
	addq.w #2,d1
_sngNewParticleNoRandomnessY:

	cmp.w d0,d1
	bge _ptNewParticleDYGreater
	exg d0,d1							; D1 = max (|DX|, |DY|) et d0 = min (|DX|, |DY|)
	move.w d2,OFFSET_PARTICLE_INCX0(a1)
	move.w #0,OFFSET_PARTICLE_INCY0(a1)
	move.w #0,OFFSET_PARTICLE_INCX1(a1)
	move.w d3,OFFSET_PARTICLE_INCY1(a1)
	bra _ptNewParticleDXGreater
_ptNewParticleDYGreater:
	move.w #0,OFFSET_PARTICLE_INCX0(a1)
	move.w d3,OFFSET_PARTICLE_INCY0(a1)
	move.w d2,OFFSET_PARTICLE_INCX1(a1)
	move.w #0,OFFSET_PARTICLE_INCY1(a1)
_ptNewParticleDXGreater:
	move.w d0,OFFSET_PARTICLE_MINDXDY(a1)
	move.w d1,OFFSET_PARTICLE_MAXDXDY(a1)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a1)

	lea DATASIZE_PARTICLE(a1),a1
	cmp.l #ptParticlesEnd,a1
	bne _ptNewParticlesNoListLoop
	lea ptParticlesStart,a1
_ptNewParticlesNoListLoop:

; Move to next generator position

	subi.w #(PATH_LENGTH/PARTICLE_SEEDS)*DATASIZE_PATH,d4
	bge _ptNewParticleSeedsNoUnderflow
	addi.w #PATH_LENGTH*DATASIZE_PATH,d4
_ptNewParticleSeedsNoUnderflow:
	dbf d5,_ptNewParticle

	move.w #PARTICLE_DELAY,d7

; End of or no particles generation

_ptNoNewParticleAndWait:
	subq.w #1,d7
_ptNoNewParticle:
	move.l a1,ptNextParticle

; Move the generator along the path (the position of the others depends on it)

	subi.w #DATASIZE_PATH,d6
	bge _ptPathNoUnderflow
	addi.w #PATH_LENGTH*DATASIZE_PATH,d6
_ptPathNoUnderflow:

; Animate the path

	move.w ptPathDelay,d0
	subq.w #1,d0
	bne _ptKeepPath
	move.w #PATH_DELAY,d0
	move.l ptPathData,d1
	addi.l #PATH_LENGTH*DATASIZE_PATH,d1
	cmpi.l #ptPathDataEnd,d1
	bne _ptPathNoCycling
	move.l #ptPathDataStart,d1
_ptPathNoCycling:
	move.l d1,ptPathData
_ptKeepPath:
	move.w d0,ptPathDelay

; ---------- Swap the palettes -----

	move.w ptPaletteDelay,d0
	subq.w #1,d0
	bne _ptKeepPalette

; Set the palette

	movea.l ptCopperList,a0
	movea.l ptPalette,a1
	IFNE DEBUG
	lea 10*4+DISPLAY_DEPTH*2*4+4+6(a0),a0
	lea 2(a1),a1
	move.w #16-2,d0
	ELSE
	lea 10*4+DISPLAY_DEPTH*2*4+4+2(a0),a0
	move.w #16-1,d0
	ENDC
_ptSetPalette:
	move.w (a1)+,(a0)
	lea 4(a0),a0
	dbf d0,_ptSetPalette

; Attenuate palette colors when particles are in the half-bright area
;
; Since HALFBRIGHT_BITPLANE is 6, this means attenuate colors %0010xxxx :
;
; %00100001 (33) must be an half-bright version of %00000001 (01)
; %00100010 (34) must be an half-bright version of %00000010 (02)
; ...
; %00101111 (47) must be an half-bright version of %00001111 (15)
;
; Moreover, %00100000 (32) must be set to HALFBRIGHT_COLOR
;
; Colors 00 et 01 lie in palette 0, and colors 32 to 47 lie in palette 1

	movea.l ptCopperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4+4+6(a0),a0
	lea 4+31*4(a0),a2
	move.w #HALFBRIGHT_COLOR,(a2)
	lea 4(a2),a2
	moveq #15-1,d0
	clr.w d2
	clr.w d3
_setHalfBright:
	move.w (a0),d1
	move.b d1,d2
	move.b d1,d3
	lsr.w #1,d1
	lsr.b #1,d2
	and.b #$F0,d2
	move.b d2,d1
	and.b #$0F,d3
	lsr.b #1,d3
	or.b d3,d1
	move.w d1,(a2)
	lea 4(a0),a0
	lea 4(a2),a2
	dbf d0,_setHalfBright

	;Next palette

	cmp.l #ptPalettesEnd,a1
	bne _ptNoPalettesCycling
	lea ptPalettesStart,a1
_ptNoPalettesCycling:
	move.l a1,ptPalette
	move.W #PALETTE_DELAY,d0

_ptKeepPalette:
	move.w d0,ptPaletteDelay

;---------- Swap and clear the bitplanes ----------

; Roll the bitplanes

	IFNE DEBUG
	moveq #1,d0
	jsr _wait
	ELSE
	WAIT_ENDOFFRAME
	ENDC

	move.l ptCopperList,a0
	lea 10*4+1*2*4+2(a0),a0		; Bitplane 3

	move.l ptBackBufferA,d0
	move.w (a0),d1				; Bitplane B = Previous bitplane 3
	swap d1
	move.w 4(a0),d1
	move.l d1,ptBackBufferA

	move.w -2*4(a0),d1			; Bitplane 3 = Previous bitplane 1
	move.w d1,0*4(a0)
	swap d1
	move.w -1*4(a0),d1
	move.w d1,1*4(a0)

	move.l ptBackBufferB,d2
	move.w d2,-1*4(a0)			; Bitplane 1 = Previous bitplane C
	swap d2
	move.w d2,-2*4(a0)

	move.l d0,ptBackBufferB		; Bitplane C = Previous bitplane B

	swap d2						; Bitplane 2 = New bitplane 1 (reversed)
	addi.l #(DISPLAY_DY-1)*(DISPLAY_DX>>3),d2
	move.w d2,7*4(a0)
	swap d2
	move.w d2,6*4(a0)

	addi.l #(DISPLAY_DY-1)*(DISPLAY_DX>>3),d1
	move.w d1,9*4(a0)			; Bitplane 4 = New bitplane 3 (reversed)
	swap d1
	move.w d1,8*4(a0)

	; Start clearing the new bitplane B (warning: no final WAIT_BLITTER here)

	WAIT_BLITTER
	move.w #0,BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	; USED=1
	move.w #$0000,BLTCON1(a5)
	move.l ptBackBufferA,BLTDPTH(a5)
	move.w #DISPLAY_DY,BLTSIZV(a5)
	move.w #DISPLAY_DX>>4,BLTSIZH(a5)

	; ########## Ending ##########

	; Test if the left mouse button has been pressed and if yes start ending (unless beginning is not completed)

	move.b ptFlags,d0
	btst #6,$BFE001
	bne _ptMouseButtonNotPressed
	btst #FLAG_BEGINNING_INPROGRESS,d0
	bne _ptMouseButtonNotPressed
	move.w #0,ptMaxNbParticles
	bset #FLAG_ENDING_INPROGRESS,d0
	move.b d0,ptFlags
_ptMouseButtonNotPressed:

	btst #FLAG_ENDING_INPROGRESS,d0
	beq _ptNoEnding

	btst #FLAG_ENDING_LINESERASED,d0
	beq _ptLinesNotErased

	; End if half-bright area height is 0 and number of particles is 0

	tst.w ptNbParticles
	beq _ptEnd
	bra _ptNoEnding

	; (1) Shrink the half-bright area (fucking offsets! I must confess: I used test320x152x1.raw to check)

_ptLinesNotErased:
	btst #FLAG_ENDING_AREASHRINKED,d0
	bne _ptAreaShrinked

	move.w ptHalfBrightHalfHeight,d1
	ext.l d1

	movea.l bitplanes,a0
	move.l #((TEXT_BITPLANE-1)*DISPLAY_DY+HALFBRIGHT_Y+(HALFBRIGHT_DY>>1)-1)*(DISPLAY_DX>>3),d2
	sub.l d1,d2
	add.l d2,a0

	movea.l bitplanes,a1
	move.l #((HALFBRIGHT_BITPLANE-1)*DISPLAY_DY+DISPLAY_DY-HALFBRIGHT_Y-(HALFBRIGHT_DY>>1))*(DISPLAY_DX>>3),d2		; Bitplane is upside down!
	sub.l d1,d2
	add.l d2,a1
	
	move.w #(DISPLAY_DX>>5)-1,d2
_ptLowerTopLine:
	move.l #$FFFFFFFF,DISPLAY_DX>>3(a0)
	move.l #$00000000,(a0)+
	move.l #$00000000,(a1)+
	dbf d2,_ptLowerTopLine

	movea.l bitplanes,a0
	move.l #((TEXT_BITPLANE-1)*DISPLAY_DY+HALFBRIGHT_Y+(HALFBRIGHT_DY>>1))*(DISPLAY_DX>>3),d2
	add.l d1,d2
	add.l d2,a0

	movea.l bitplanes,a1
	move.l #((HALFBRIGHT_BITPLANE-1)*DISPLAY_DY+DISPLAY_DY-HALFBRIGHT_Y-(HALFBRIGHT_DY>>1)-1)*(DISPLAY_DX>>3),d2	; Bitplane is upside down!
	add.l d1,d2
	add.l d2,a1

	move.w #(DISPLAY_DX>>5)-1,d2
_ptRaiseBottomLine:
	move.l #$FFFFFFFF,-DISPLAY_DX>>3(a0)
	move.l #$00000000,(a0)+
	move.l #$00000000,(a1)+
	dbf d2,_ptRaiseBottomLine

	subi.w #DISPLAY_DX>>3,d1
	move.w d1,ptHalfBrightHalfHeight
	tst.w d1
	bne _ptShrinkHalfBrightNotDone
	lea -2*(DISPLAY_DX>>3)(a1),a1
	lea -(DISPLAY_DX>>3)(a1),a2
	move.w #(DISPLAY_DX>>5)-1,d1
_ptClearLastHalfBrightLines:
	move.l #$00000000,(a1)+
	move.l #$00000000,(a2)+
	dbf d1,_ptClearLastHalfBrightLines
	bset #FLAG_ENDING_AREASHRINKED,d0
	move.b d0,ptFlags
_ptShrinkHalfBrightNotDone:
	bra _ptNoEnding

	; (2) Shrink lines from the left and the right until their width is 0

_ptAreaShrinked:
	movea.l bitplanes,a0
	add.l #((TEXT_BITPLANE-1)*DISPLAY_DY+HALFBRIGHT_Y+(HALFBRIGHT_DY>>1)-1)*(DISPLAY_DX>>3),a0
	move.w ptHalfBrightLinesHalfWidth,d1

	move.w #(DISPLAY_DX>>1)-1,d2
	add.w d1,d2											; D2 = XrEnd = XrStart + W - 1 with XrStart = DISPLAY_DX>>1
	move.w d2,d3
	and.b #$07,d3
	addq.b #1,d3
	move.b #($FF<<HALFBRIGHT_LINESSPEED)&$FF,d4			; 1: %11111110, 2: %11111100, 4: %11110000, 8:%00000000
	ror.b d3,d4
	lsr.w #3,d2
	and.b d4,(a0,d2.w)
	and.b d4,DISPLAY_DX>>3(a0,d2.w)

	move.w #DISPLAY_DX>>1,d2
	sub.w d1,d2											; D2 = XlEnd = XlStart - W + 1 with XlStart = DISPLAY_DX>> 1 - 1
	move.w d2,d3
	not.b d3
	and.b #$07,d3
	addq.b #1,d3										; ~D3 = 7 - D3, so ~D3 + 1 = 8 - D3
	move.b #$FF>>HALFBRIGHT_LINESSPEED,d4				; 1: %01111111, 2: %00111111, 4: %00001111, 8:%00000000
	rol.b d3,d4
	lsr.w #3,d2
	and.b d4,(a0,d2.w)
	and.b d4,DISPLAY_DX>>3(a0,d2.w)

	subq.w #HALFBRIGHT_LINESSPEED,d1
	move.w d1,ptHalfBrightLinesHalfWidth
	tst.w d1
	bge _ptEraseLinesNotDone
	bset #FLAG_ENDING_LINESERASED,d0
	move.b d0,ptFlags
_ptEraseLinesNotDone:

_ptNoEnding:
	bra _ptLoop
	
	; End the printer

_ptEnd:
	bsr _prtEnd

	; End the tune

	IFNE TUNE
;	lea mt_Enable(pc),a0
	movea.l #mt_Enable,a0
	sf (a0)
	lea $DFF000,a6
	bsr mt_end
	ENDC

;********** Finalizations **********

_end:
	; Wait for the Blitter (bitplane clearing may be in progress)

	WAIT_BLITTER

	; Shut down the hardware interrupts and the DMAs

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

	; Restore the level 6 interrupt vector

	movea.l VBRPointer,a0
	move.l vector30,$78(a0)

	; Activate the hardware interrupts and the DMAs

	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

	; Restore the Copper list

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)			; OpenLibrary ()
	move.l d0,graphicsBase

	movea.l d0,a0
	move.l 38(a0),COP1LCH(a5)
	clr.w COPJMP1(a5)

	; StingRay's stuff

	movea.l view,a1
	move.l graphicsBase,a6
	jsr -222(a6)			; LoadView ()
	jsr -462(a6)			; DisownBlitter ()
	move.l graphicsBase,a1
	movea.l $4,a6
	jsr -414(a6)			; CloseLibrary ()

	; Restore the system

	jsr -138(a6)			; Permit ()

	; Free allocated memory

	movea.l spCopperList,a1
	move.l #SP_COPPERLIST,d0
	jsr -210(a6)			; FreeMem ()

	movea.l ptCopperList,a1
	move.l #PT_COPPERLIST,d0
	jsr -210(a6)			; FreeMem ()

	movea.l _bitplanes,a1
	move.l #(DISPLAY_DEPTH+1)*DISPLAY_DY*(DISPLAY_DX>>3),d0
	jsr -210(a6)			; FreeMem ()

	; Unstack registers

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routines **********

	INCLUDE "scoopexONEv6.1/common/registers.s"
	INCLUDE "scoopexONEv6.1/common/wait.s"
	INCLUDE "scoopexONEv6.1/common/interpolate.s"
	INCLUDE "scoopexONEv6.1/common/printer.s"
	IFNE DEBUG
	NCLUDE "scoopexONEv6.1/common/debug.s"
	ENDC
	INCLUDE "scoopexONEv6.1/common/ptplayer/ptplayer_FINAL.s"

;---------- Ändern der Farbe für jedes Pixel, das in einer bestimmten Bitplane vorkommt ----------

; Eingabe(n) :
; D0 = Nummer (nicht Index!) des Bitplanes.
; D1 = Farbe
; D2 = Anzahl der Bitplanes auf dem Bildschirm.
; A0 = Adresse des Palettenanfangs in der Copper-Liste.
; Verwendung von Registern :
;	*D0 *D1 *D2 *D3 *D4 *D5 =D6 =D7 *A0 =A1 =A2 =A3 =A4 =A5 =A6
; Hinweis :
; Die Palette muss eine AGA 4-Bit-Palette sein, d.h. sie muss wie folgt strukturiert sein 
; (die Anzahl der Paletten variiert je nach Anzahl der Bitplanes):
;   ; Palette 0 (Farben 0 bis 31)
;	MOVE BPLCON3
;	MOVE COLOR00
;	...
;	MOVE COLOR31
;	; Palette 1 (Farben 32 bis 63)
;	MOVE BPLCON3
;	MOVE COLOR00
;	...
;	MOVE COLOR31
;	...

_setBitplaneColor:
	movem.l d0-d5/a0,-(sp)

	lea 4+2(a0),a0

	subq.b #1,d0
	moveq #1,d3
	lsl.b d0,d3
	move.b d3,d0	;D0 = Motif pour déterminer si une couleur est concernée par le bitplane : 1<<(BITPLANE-1)

	moveq #1,d3
	lsl.b d2,d3
	subq.b #1,d3
	move.b d3,d2	;D2 = Indice de la dernière couleur à passer en revue : (1<<DEPTH)-1

	moveq #32,d3	;D3 = Nombre de couleurs restant à parcourir dans la palette courante de 32 couleurs
	moveq #-1,d4	;D4 = Indice de la couleur courante dans palette globale de 256 couleurs
_setBitplaneColorLoop:
	addq.b #1,d4
	move.b d4,d5
	and.b d0,d5
	beq _setBitplaneColorSkip
	move.w d1,(a0)
_setBitplaneColorSkip:
	subq.b #1,d3
	bne _setBitplaneColorKeepPalette
	lea 4(a0),a0
	moveq #32,d3
_setBitplaneColorKeepPalette:
	lea 4(a0),a0
	cmp.b d4,d2
	bne _setBitplaneColorLoop

	movem.l (sp)+,d0-d5/a0
	rts

;********** Data **********

	SECTION data,DATA_C

;---------- Program ----------

VBRPointer:			DC.L 0
vector30:			DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
graphicsBase:		DC.L 0
view:				DC.L 0
bitplanes:			DC.L 0
backBuffer:			DC.L 0
_bitplanes:			DC.L 0

;---------- Printer ----------

printerText:
	; (DISPLAY_DY-SP_BITMAP_DY-HALFBRIGHT_Y)/8 lines (default is 256-64-32=160 so 20 lines)
	; 40 chars per line
	; $00 to skip a line
	; $FF to end page
	; $FF after end of page to end text
	; No trailing spaces allowed
	; For this demo :
	; 38 chars per line, each line with a leading space
	; 18 lines
	; Page 0
	DC.B 0
	DC.B " /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\",0
	DC.B " \                                    /",0
	DC.B " / .oO Scoopex ""ONE"" (AGA) [v6.1] Oo. \",0
	DC.B " \         A tribute to coders        /",0
	DC.B " /                                    \",0
	DC.B " \  Prod. May 2018 / Fix. March 2019  /",0
	DC.B " /                                    \",0
	DC.B " \       Code & Design: Yragael       /",0
	DC.B " / Graphics & Design: alien / Paradox \",0
	DC.B " \     Music: Notorious / Scoopex     /",0
	DC.B " /                                    \",0
	DC.B " \  Get the source, data and doc at:  /",0
	DC.B " /                                    \",0
	DC.B " \      http://www.stashofcode.fr     /",0
	DC.B " /                                    \",0
	DC.B " \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/",-1
	;Page 1
	DC.B " After I wrote several vintage",0
	DC.B " articles about Amiga coding for the",0
	DC.B " french magazine Programmez!, I coded",0
	DC.B " a bunch of routines in 2017.",0
	DC.B 0
	DC.B " I was sitting on them, waiting to",0
	DC.B " find the courage to assemble them in",0
	DC.B " a demo that I would to show at some",0
	DC.B " demo competition.",0
	DC.B 0
	DC.B " Nothing happened, because producing",0
	DC.B " this demo would have required art,",0
	DC.B " music, and a lot of work.",0
	DC.B 0
	DC.B " Then Galahad gave me the opportuniy",0
	DC.B " to code an intro for Scoopex... So I",0
	DC.B " used some of my code for this!",-1
	;Page 2
	DC.B " Galahad asked Notorious to compose",0
	DC.B " this wonderful chip tune.",0
	DC.B 0
	DC.B " I got in touch with Alien, who drew",0
	DC.B " this astonishing logo in 16 colors",0
	DC.B " and the very nice skull in the",0
	DC.B " background of this text.",0
	DC.B 0
	DC.B " It was a pain in the ass to add some",0
	DC.B " transitions to the particles FX: the",0
	DC.B " lines that grow and then move up and",0
	DC.B " down at the beginning, and do the",0
	DC.B " same thing in reverse at the end.",0
	DC.B 0
	DC.B " But it was worth the effort, don't",0
	DC.B " you think?",0
	DC.B "                          Yragael",-1
	;End of pages
	DC.B -1
	EVEN
font:
	INCBIN "scoopexONEv6.1/data/fontWobbly8x8x1.raw"
	EVEN

;---------- Splash screen ----------

spCopperList:	DC.L 0
spBitmap:		INCBIN "scoopexONEv6.1/data/scoopexONELogo320x64x4.raw"	; Set the SP_BITMAP_* constants accordingly !
				
spMask			DC.L 0
spSquaresData:		; For each square: delay before start (# VERTB), image (index in spSquaresBitmap)
	DC.B 32, 0, 41, 0, 17, 0, 93, 0, 28, 0, 19, 0, 68, 0, 55, 0, 70, 0, 21, 0, 36, 0, 87, 0, 80, 0, 42, 0, 20, 0, 78, 0, 59, 0, 13, 0, 12, 0, 47, 0, 18, 0, 71, 0, 86, 0, 71, 0, 75, 0, 31, 0, 88, 0, 58, 0, 38, 0, 12, 0, 60, 0, 35, 0, 55, 0, 4, 0, 10, 0, 98, 0, 38, 0, 87, 0, 43, 0, 47, 0, 62, 0, 59, 0, 41, 0, 91, 0, 45, 0, 16, 0, 79, 0, 22, 0, 96, 0, 79, 0, 60, 0, 94, 0, 47, 0, 85, 0, 53, 0, 74, 0, 62, 0, 10, 0, 68, 0, 16, 0, 9, 0, 94, 0, 24, 0, 4, 0, 90, 0, 92, 0, 85, 0, 26, 0, 51, 0, 69, 0, 45, 0, 20, 0, 17, 0, 31, 0, 6, 0, 53, 0, 49, 0, 26, 0, 86, 0, 84, 0, 37, 0, 62, 0, 72, 0, 70, 0, 24, 0, 53, 0, 86, 0, 18, 0, 85, 0, 55, 0, 93, 0, 9, 0, 73, 0, 29, 0, 51, 0, 97, 0, 76, 0, 31, 0, 81, 0, 90, 0, 32, 0, 62, 0, 90, 0, 3, 0, 72, 0, 26, 0, 49, 0, 18, 0, 9, 0, 40, 0, 78, 0, 2, 0, 82, 0, 21, 0, 35, 0, 73, 0, 7, 0, 32, 0, 40, 0, 28, 0, 79, 0, 72, 0, 34, 0, 78, 0, 99, 0, 86, 0, 39, 0, 71, 0, 69, 0, 85, 0, 97, 0, 32, 0, 7, 0, 6, 0, 66, 0, 82, 0, 16, 0, 30, 0, 82, 0, 88, 0, 16, 0, 42, 0, 43, 0, 14, 0, 24, 0, 31, 0, 96, 0, 26, 0, 92, 0, 62, 0, 16, 0, 83, 0, 35, 0, 75, 0, 90, 0, 17, 0, 20, 0, 31, 0, 2, 0, 60, 0, 28, 0, 64, 0, 10, 0, 20, 0, 76, 0, 93, 0, 38, 0, 3, 0, 48, 0, 69, 0, 60, 0, 75, 0, 5, 0, 64, 0, 18, 0, 99, 0, 28, 0, 56, 0, 56, 0, 92, 0, 65, 0, 20, 0, 89, 0, 43, 0, 57, 0, 45, 0, 24, 0, 59, 0, 65, 0, 82, 0, 76, 0, 83, 0, 8, 0, 95, 0, 17, 0, 99, 0, 30, 0, 93, 0, 56, 0, 79, 0, 52, 0, 64, 0, 15, 0, 20, 0, 38, 0, 99, 0, 19, 0, 83, 0, 14, 0, 21, 0, 25, 0, 54, 0, 63, 0, 40, 0, 11, 0, 14, 0, 34, 0, 36, 0, 79, 0, 9, 0, 17, 0, 7, 0, 97, 0, 92, 0, 14, 0, 38, 0, 25, 0, 98, 0, 2, 0, 64, 0, 1, 0, 47, 0, 0, 0, 3, 0, 100, 0, 86, 0, 78, 0, 58, 0, 11, 0, 69, 0, 37, 0, 19, 0, 21, 0, 6, 0, 43, 0, 44, 0, 76, 0, 43, 0, 96, 0, 63, 0, 88, 0, 49, 0, 96, 0, 76, 0, 71, 0, 20, 0, 53, 0, 52, 0, 25, 0, 62, 0, 31, 0, 12, 0, 43, 0, 100, 0, 78, 0, 42, 0, 81, 0, 40, 0, 68, 0, 28, 0, 17, 0, 89, 0, 75, 0, 20, 0, 33, 0, 83, 0, 43, 0, 65, 0, 73, 0, 57, 0, 78, 0, 99, 0, 37, 0, 30, 0, 4, 0, 63, 0, 76, 0, 84, 0, 63, 0, 74, 0, 34, 0, 57, 0, 100, 0, 18, 0, 87, 0, 11, 0, 96, 0, 77, 0, 5, 0, 67, 0, 39, 0, 57, 0, 55, 0, 23, 0, 46, 0, 88, 0, 33, 0, 31, 0, 24, 0, 53, 0, 87, 0, 55, 0, 92, 0, 60, 0, 58, 0, 49, 0, 39, 0, 38, 0, 58, 0, 12, 0
spSquareBitmaps:	; Set SP_SQUARES_NBFRAMES accordingly
	; Pulsating square (filled square grows then shrinks then grows)
	IFEQ SP_SQUARES_ANIMATION=0
	DC.B $00, $00, $00, $00, $00, $00, $00, $00
	DC.B $00, $00, $00, $18, $18, $00, $00, $00
	DC.B $00, $00, $3C, $3C, $3C, $3C, $00, $00
	DC.B $00, $7E, $7E, $7E, $7E, $7E, $7E, $00
	DC.B $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	DC.B $00, $7E, $7E, $7E, $7E, $7E, $7E, $00
	DC.B $00, $00, $3C, $3C, $3C, $3C, $00, $00
	DC.B $00, $00, $00, $18, $18, $00, $00, $00
	ENDC
	; Pulsative square (filled square borders grows then shrinks then grows)
	IFEQ SP_SQUARES_ANIMATION=1
	DC.B $00, $00, $00, $00, $00, $00, $00, $00
	DC.B $FF, $81, $81, $81, $81, $81, $81, $FF
	DC.B $FF, $FF, $C3, $C3, $C3, $C3, $FF, $FF
	DC.B $FF, $FF, $FF, $E7, $E7, $FF, $FF, $FF
	DC.B $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	DC.B $FF, $FF, $FF, $E7, $E7, $FF, $FF, $FF
	DC.B $FF, $FF, $C3, $C3, $C3, $C3, $FF, $FF
	DC.B $FF, $81, $81, $81, $81, $81, $81, $FF
	ENDC

;---------- Particles ----------

; ptHalfBrightBitmap:		INCBIN "SOURCES:scoopexONEv6.1/data/test320x152x1.raw"	; Set the HALFBRIGHT_* accordingly
ptHalfBrightBitmap:		INCBIN "scoopexONEv6.1/data/scoopexONESkull320x152x1.raw"	; Set the HALFBRIGHT_* accordingly
ptCopperList:			DC.L 0
PALETTE_DELAY=200
ptPalettesStart:
	; Palette (no transparency): $0000, $0BB0, $0DD0, $00D0, $00B0, $00D0, $0DF0
	DC.W $0000 ; COLOR00
	DC.W $00B0 ; COLOR01
	DC.W $0BB0 ; COLOR02
	DC.W $00B0 ; COLOR03
	DC.W $00D0 ; COLOR04
	DC.W $0DF0 ; COLOR05
	DC.W $00D0 ; COLOR06
	DC.W $0DF0 ; COLOR07
	DC.W $0DD0 ; COLOR08
	DC.W $00B0 ; COLOR09
	DC.W $00D0 ; COLOR10
	DC.W $0DF0 ; COLOR11
	DC.W $00D0 ; COLOR12
	DC.W $0DF0 ; COLOR13
	DC.W $00D0 ; COLOR14
	DC.W $0DF0 ; COLOR15
	; Palette (no transparency): $0000, $000E, $000C, $0F0A, $000F, $000D, $0B03
	DC.W $0000 ; COLOR00
	DC.W $000F ; COLOR01
	DC.W $000E ; COLOR02
	DC.W $000F ; COLOR03
	DC.W $000D ; COLOR04
	DC.W $0B03 ; COLOR05
	DC.W $000D ; COLOR06
	DC.W $0B03 ; COLOR07
	DC.W $000C ; COLOR08
	DC.W $000F ; COLOR09
	DC.W $0F0A ; COLOR10
	DC.W $0B03 ; COLOR11
	DC.W $000D ; COLOR12
	DC.W $0B03 ; COLOR13
	DC.W $000D ; COLOR14
	DC.W $0B03 ; COLOR15
	; Palette (no transparency): $0000, $0F00, $0700, $0FF0, $0FF0, $0770, $0F00
	DC.W $0000 ; COLOR00
	DC.W $0FF0 ; COLOR01
	DC.W $0F00 ; COLOR02
	DC.W $0FF0 ; COLOR03
	DC.W $0770 ; COLOR04
	DC.W $0F00 ; COLOR05
	DC.W $0770 ; COLOR06
	DC.W $0F00 ; COLOR07
	DC.W $0700 ; COLOR08
	DC.W $0FF0 ; COLOR09
	DC.W $0FF0 ; COLOR10
	DC.W $0F00 ; COLOR11
	DC.W $0770 ; COLOR12
	DC.W $0F00 ; COLOR13
	DC.W $0770 ; COLOR14
	DC.W $0F00 ; COLOR15
	; Palette (no transparency): $0000, $00F0, $000F, $0FFF, $000F, $00F0, $00FF
	DC.W $0000 ; COLOR00
	DC.W $000F ; COLOR01
	DC.W $00F0 ; COLOR02
	DC.W $000F ; COLOR03
	DC.W $00F0 ; COLOR04
	DC.W $00FF ; COLOR05
	DC.W $00F0 ; COLOR06
	DC.W $00FF ; COLOR07
	DC.W $000F ; COLOR08
	DC.W $000F ; COLOR09
	DC.W $0FFF ; COLOR10
	DC.W $00FF ; COLOR11
	DC.W $00F0 ; COLOR12
	DC.W $00FF ; COLOR13
	DC.W $00F0 ; COLOR14
	DC.W $00FF ; COLOR15
ptPalettesEnd:
ptPalette:			DC.L 0
ptPaletteDelay:		DC.W 0
ptBackBufferA:		DC.L 0
ptBackBufferB:		DC.L 0
ptAccumulator0:		DC.W 0
ptAccumulator1:		DC.W 0
ptNbParticles:		DC.W 0
ptMaxNbParticles:	DC.W 0
ptParticles:		; For each particle: image (offset in ptParticleBitmapsShifted), x, y, speed, TTL, incX (default),
					; incY (default), incX (if overflow), incY (if overflow), min (|dx|, |dy|), max (|dx|, |dy|), accumulator
OFFSET_PARTICLE_BITMAP=0
OFFSET_PARTICLE_X=2
OFFSET_PARTICLE_Y=4
OFFSET_PARTICLE_SPEED=6
OFFSET_PARTICLE_TTL=8
OFFSET_PARTICLE_INCX0=10
OFFSET_PARTICLE_INCY0=12
OFFSET_PARTICLE_INCX1=14
OFFSET_PARTICLE_INCY1=16
OFFSET_PARTICLE_MINDXDY=18
OFFSET_PARTICLE_MAXDXDY=20
OFFSET_PARTICLE_ACCUMULATOR=22
DATASIZE_PARTICLE=12*2
ptFirstParticle:	DC.L 0
ptNextParticle:		DC.L 0
ptParticlesStart:
	BLK.W NB_PARTICLES*(DATASIZE_PARTICLE>>1),0
ptParticlesEnd:
ptParticleBitmaps:
	; Data format for the particle animation bitmaps is:
	; DC.B 1st line of frame 0, 1st line of frame 1, ..., 1st line of frame PARTICLE_NBKEYS-1
	; ...
	; DC.B 7th line of frame 0, 7th line of frame 1, ..., 7th line of frame PARTICLE_NBKEYS-1
	; Disc...
	IFNE PARTICLE_DISC
	DC.B $3C, $38, $00, $00, $00, $00, $00, $00
	DC.B $7E, $7C, $18, $10, $00, $00, $00, $00
	DC.B $FF, $FE, $3C, $38, $18, $10, $00, $00
	DC.B $FF, $FE, $7E, $7C, $3C, $38, $18, $10
	DC.B $FF, $FE, $7E, $38, $3C, $10, $18, $00
	DC.B $FF, $7C, $3C, $10, $18, $00, $00, $00
	DC.B $7E, $38, $18, $00, $00, $00, $00, $00
	DC.B $3C, $00, $00, $00, $00, $00, $00, $00
	ELSE
	; ...or square
	DC.B $FF, $FE, $00, $00, $00, $00, $00, $00
	DC.B $FF, $FE, $7E, $7C, $00, $00, $00, $00
	DC.B $FF, $FE, $7E, $7C, $3C, $38, $00, $00
	DC.B $FF, $FE, $7E, $7C, $3C, $38, $18, $10
	DC.B $FF, $FE, $7E, $7C, $3C, $38, $18, $00
	DC.B $FF, $FE, $7E, $7C, $3C, $00, $00, $00
	DC.B $FF, $FE, $7E, $00, $00, $00, $00, $00
	DC.B $FF, $00, $00, $00, $00, $00, $00, $00
	ENDC
ptParticleBitmapsShifted:
	BLK.W PARTICLE_NBKEYS*8*8
ptPathData:		DC.L 0
ptPathDelay:	DC.W 0
ptPathDataStart:		; For each position : x, y, dx, dy
OFFSET_PATH_X=0
OFFSET_PATH_Y=2
OFFSET_PATH_DX=4
OFFSET_PATH_DY=6
DATASIZE_PATH=4*2
	; x = sin (4 * (T + 90))
	; y = -sin (3 * T)
	DC.W 160, 128, 7, -5, 167, 123, 7, -5, 174, 118, 7, -5, 181, 112, 7, -6, 188, 107, 7, -5, 194, 102, 6, -5, 201, 97, 7, -5, 207, 92, 6, -5, 213, 87, 6, -5, 219, 83, 6, -4, 224, 78, 5, -5, 229, 74, 5, -4, 234, 69, 5, -5, 239, 65, 5, -4, 243, 61, 4, -4, 247, 57, 4, -4, 250, 54, 3, -3, 253, 50, 3, -4, 255, 47, 2, -3, 257, 44, 2, -3, 258, 41, 1, -3, 259, 39, 1, -2, 260, 37, 1, -2, 260, 35, 0, -2, 259, 33, -1, -2, 258, 31, -1, -2, 257, 30, -1, -1, 255, 29, -2, -1, 253, 29, -2, 0, 250, 28, -3, -1, 247, 28, -3, 0, 243, 28, -4, 0, 239, 29, -4, 1, 234, 29, -5, 0, 229, 30, -5, 1, 224, 31, -5, 1, 219, 33, -5, 2, 213, 35, -6, 2, 207, 37, -6, 2, 201, 39, -6, 2, 194, 41, -7, 2, 188, 44, -6, 3, 181, 47, -7, 3, 174, 50, -7, 3, 167, 54, -7, 4, 160, 57, -7, 3, 153, 61, -7, 4, 146, 65, -7, 4, 139, 69, -7, 4, 132, 74, -7, 5, 126, 78, -6, 4, 119, 83, -7, 5, 113, 87, -6, 4, 107, 92, -6, 5, 101, 97, -6, 5, 96, 102, -5, 5, 91, 107, -5, 5, 86, 112, -5, 5, 81, 118, -5, 6, 77, 123, -4, 5, 73, 128, -4, 5, 70, 133, -3, 5, 67, 138, -3, 5, 65, 144, -2, 6, 63, 149, -2, 5, 62, 154, -1, 5, 61, 159, -1, 5, 60, 164, -1, 5, 60, 169, 0, 5, 61, 173, 1, 4, 62, 178, 1, 5, 63, 182, 1, 4, 65, 187, 2, 5, 67, 191, 2, 4, 70, 195, 3, 4, 73, 199, 3, 4, 77, 202, 4, 3, 81, 206, 4, 4, 86, 209, 5, 3, 91, 212, 5, 3, 96, 215, 5, 3, 101, 217, 5, 2, 107, 219, 6, 2, 113, 221, 6, 2, 119, 223, 6, 2, 126, 225, 7, 2, 132, 226, 6, 1, 139, 227, 7, 1, 146, 227, 7, 0, 153, 228, 7, 1, 160, 228, 7, 0, 167, 228, 7, 0, 174, 227, 7, -1, 181, 227, 7, 0, 188, 226, 7, -1, 194, 225, 6, -1, 201, 223, 7, -2, 207, 221, 6, -2, 213, 219, 6, -2, 219, 217, 6, -2, 224, 215, 5, -2, 229, 212, 5, -3, 234, 209, 5, -3, 239, 206, 5, -3, 243, 202, 4, -4, 247, 199, 4, -3, 250, 195, 3, -4, 253, 191, 3, -4, 255, 187, 2, -4, 257, 182, 2, -5, 258, 178, 1, -4, 259, 173, 1, -5, 260, 169, 1, -4, 260, 164, 0, -5, 259, 159, -1, -5, 258, 154, -1, -5, 257, 149, -1, -5, 255, 144, -2, -5, 253, 138, -2, -6, 250, 133, -3, -5, 247, 128, -3, -5, 243, 123, -4, -5, 239, 118, -4, -5, 234, 112, -5, -6, 229, 107, -5, -5, 224, 102, -5, -5, 219, 97, -5, -5, 213, 92, -6, -5, 207, 87, -6, -5, 201, 83, -6, -4, 194, 78, -7, -5, 188, 74, -6, -4, 181, 69, -7, -5, 174, 65, -7, -4, 167, 61, -7, -4, 160, 57, -7, -4, 153, 54, -7, -3, 146, 50, -7, -4, 139, 47, -7, -3, 132, 44, -7, -3, 126, 41, -6, -3, 119, 39, -7, -2, 113, 37, -6, -2, 107, 35, -6, -2, 101, 33, -6, -2, 96, 31, -5, -2, 91, 30, -5, -1, 86, 29, -5, -1, 81, 29, -5, 0, 77, 28, -4, -1, 73, 28, -4, 0, 70, 28, -3, 0, 67, 29, -3, 1, 65, 29, -2, 0, 63, 30, -2, 1, 62, 31, -1, 1, 61, 33, -1, 2, 60, 35, -1, 2, 60, 37, 0, 2, 61, 39, 1, 2, 62, 41, 1, 2, 63, 44, 1, 3, 65, 47, 2, 3, 67, 50, 2, 3, 70, 54, 3, 4, 73, 57, 3, 3, 77, 61, 4, 4, 81, 65, 4, 4, 86, 69, 5, 4, 91, 74, 5, 5, 96, 78, 5, 4, 101, 83, 5, 5, 107, 87, 6, 4, 113, 92, 6, 5, 119, 97, 6, 5, 126, 102, 7, 5, 132, 107, 6, 5, 139, 112, 7, 5, 146, 118, 7, 6, 153, 123, 7, 5, 160, 128, 7, 5, 167, 133, 7, 5, 174, 138, 7, 5, 181, 144, 7, 6, 188, 149, 7, 5, 194, 154, 6, 5, 201, 159, 7, 5, 207, 164, 6, 5, 213, 169, 6, 5, 219, 173, 6, 4, 224, 178, 5, 5, 229, 182, 5, 4, 234, 187, 5, 5, 239, 191, 5, 4, 243, 195, 4, 4, 247, 199, 4, 4, 250, 202, 3, 3, 253, 206, 3, 4, 255, 209, 2, 3, 257, 212, 2, 3, 258, 215, 1, 3, 259, 217, 1, 2, 260, 219, 1, 2, 260, 221, 0, 2, 259, 223, -1, 2, 258, 225, -1, 2, 257, 226, -1, 1, 255, 227, -2, 1, 253, 227, -2, 0, 250, 228, -3, 1, 247, 228, -3, 0, 243, 228, -4, 0, 239, 227, -4, -1, 234, 227, -5, 0, 229, 226, -5, -1, 224, 225, -5, -1, 219, 223, -5, -2, 213, 221, -6, -2, 207, 219, -6, -2, 201, 217, -6, -2, 194, 215, -7, -2, 188, 212, -6, -3, 181, 209, -7, -3, 174, 206, -7, -3, 167, 202, -7, -4, 160, 199, -7, -3, 153, 195, -7, -4, 146, 191, -7, -4, 139, 187, -7, -4, 132, 182, -7, -5, 126, 178, -6, -4, 119, 173, -7, -5, 113, 169, -6, -4, 107, 164, -6, -5, 101, 159, -6, -5, 96, 154, -5, -5, 91, 149, -5, -5, 86, 144, -5, -5, 81, 138, -5, -6, 77, 133, -4, -5, 73, 128, -4, -5, 70, 123, -3, -5, 67, 118, -3, -5, 65, 112, -2, -6, 63, 107, -2, -5, 62, 102, -1, -5, 61, 97, -1, -5, 60, 92, -1, -5, 60, 87, 0, -5, 61, 83, 1, -4, 62, 78, 1, -5, 63, 74, 1, -4, 65, 69, 2, -5, 67, 65, 2, -4, 70, 61, 3, -4, 73, 57, 3, -4, 77, 54, 4, -3, 81, 50, 4, -4, 86, 47, 5, -3, 91, 44, 5, -3, 96, 41, 5, -3, 101, 39, 5, -2, 107, 37, 6, -2, 113, 35, 6, -2, 119, 33, 6, -2, 126, 31, 7, -2, 132, 30, 6, -1, 139, 29, 7, -1, 146, 29, 7, 0, 153, 28, 7, -1, 160, 28, 7, 0, 167, 28, 7, 0, 174, 29, 7, 1, 181, 29, 7, 0, 188, 30, 7, 1, 194, 31, 6, 1, 201, 33, 7, 2, 207, 35, 6, 2, 213, 37, 6, 2, 219, 39, 6, 2, 224, 41, 5, 2, 229, 44, 5, 3, 234, 47, 5, 3, 239, 50, 5, 3, 243, 54, 4, 4, 247, 57, 4, 3, 250, 61, 3, 4, 253, 65, 3, 4, 255, 69, 2, 4, 257, 74, 2, 5, 258, 78, 1, 4, 259, 83, 1, 5, 260, 87, 1, 4, 260, 92, 0, 5, 259, 97, -1, 5, 258, 102, -1, 5, 257, 107, -1, 5, 255, 112, -2, 5, 253, 118, -2, 6, 250, 123, -3, 5, 247, 128, -3, 5, 243, 133, -4, 5, 239, 138, -4, 5, 234, 144, -5, 6, 229, 149, -5, 5, 224, 154, -5, 5, 219, 159, -5, 5, 213, 164, -6, 5, 207, 169, -6, 5, 201, 173, -6, 4, 194, 178, -7, 5, 188, 182, -6, 4, 181, 187, -7, 5, 174, 191, -7, 4, 167, 195, -7, 4, 160, 199, -7, 4, 153, 202, -7, 3, 146, 206, -7, 4, 139, 209, -7, 3, 132, 212, -7, 3, 126, 215, -6, 3, 119, 217, -7, 2, 113, 219, -6, 2, 107, 221, -6, 2, 101, 223, -6, 2, 96, 225, -5, 2, 91, 226, -5, 1, 86, 227, -5, 1, 81, 227, -5, 0, 77, 228, -4, 1, 73, 228, -4, 0, 70, 228, -3, 0, 67, 227, -3, -1, 65, 227, -2, 0, 63, 226, -2, -1, 62, 225, -1, -1, 61, 223, -1, -2, 60, 221, -1, -2, 60, 219, 0, -2, 61, 217, 1, -2, 62, 215, 1, -2, 63, 212, 1, -3, 65, 209, 2, -3, 67, 206, 2, -3, 70, 202, 3, -4, 73, 199, 3, -3, 77, 195, 4, -4, 81, 191, 4, -4, 86, 187, 5, -4, 91, 182, 5, -5, 96, 178, 5, -4, 101, 173, 5, -5, 107, 169, 6, -4, 113, 164, 6, -5, 119, 159, 6, -5, 126, 154, 7, -5, 132, 149, 6, -5, 139, 144, 7, -5, 146, 138, 7, -6, 153, 133, 7, -5
	; x = cos (T)
	; y = sin (T)
	DC.W 260, 128, 0, -2, 260, 126, 0, -2, 260, 125, 0, -1, 260, 123, 0, -2, 260, 121, 0, -2, 260, 119, 0, -2, 259, 118, -1, -1, 259, 116, 0, -2, 259, 114, 0, -2, 259, 112, 0, -2, 258, 111, -1, -1, 258, 109, 0, -2, 258, 107, 0, -2, 257, 106, -1, -1, 257, 104, 0, -2, 257, 102, 0, -2, 256, 100, -1, -2, 256, 99, 0, -1, 255, 97, -1, -2, 255, 95, 0, -2, 254, 94, -1, -1, 253, 92, -1, -2, 253, 91, 0, -1, 252, 89, -1, -2, 251, 87, -1, -2, 251, 86, 0, -1, 250, 84, -1, -2, 249, 83, -1, -1, 248, 81, -1, -2, 247, 80, -1, -1, 247, 78, 0, -2, 246, 76, -1, -2, 245, 75, -1, -1, 244, 74, -1, -1, 243, 72, -1, -2, 242, 71, -1, -1, 241, 69, -1, -2, 240, 68, -1, -1, 239, 66, -1, -2, 238, 65, -1, -1, 237, 64, -1, -1, 235, 62, -2, -2, 234, 61, -1, -1, 233, 60, -1, -1, 232, 59, -1, -1, 231, 57, -1, -2, 229, 56, -2, -1, 228, 55, -1, -1, 227, 54, -1, -1, 226, 53, -1, -1, 224, 51, -2, -2, 223, 50, -1, -1, 222, 49, -1, -1, 220, 48, -2, -1, 219, 47, -1, -1, 217, 46, -2, -1, 216, 45, -1, -1, 214, 44, -2, -1, 213, 43, -1, -1, 212, 42, -1, -1, 210, 41, -2, -1, 208, 41, -2, 0, 207, 40, -1, -1, 205, 39, -2, -1, 204, 38, -1, -1, 202, 37, -2, -1, 201, 37, -1, 0, 199, 36, -2, -1, 197, 35, -2, -1, 196, 35, -1, 0, 194, 34, -2, -1, 193, 33, -1, -1, 191, 33, -2, 0, 189, 32, -2, -1, 188, 32, -1, 0, 186, 31, -2, -1, 184, 31, -2, 0, 182, 31, -2, 0, 181, 30, -1, -1, 179, 30, -2, 0, 177, 30, -2, 0, 176, 29, -1, -1, 174, 29, -2, 0, 172, 29, -2, 0, 170, 29, -2, 0, 169, 28, -1, -1, 167, 28, -2, 0, 165, 28, -2, 0, 163, 28, -2, 0, 162, 28, -1, 0, 160, 28, -2, 0, 158, 28, -2, 0, 157, 28, -1, 0, 155, 28, -2, 0, 153, 28, -2, 0, 151, 28, -2, 0, 150, 29, -1, 1, 148, 29, -2, 0, 146, 29, -2, 0, 144, 29, -2, 0, 143, 30, -1, 1, 141, 30, -2, 0, 139, 30, -2, 0, 138, 31, -1, 1, 136, 31, -2, 0, 134, 31, -2, 0, 132, 32, -2, 1, 131, 32, -1, 0, 129, 33, -2, 1, 127, 33, -2, 0, 126, 34, -1, 1, 124, 35, -2, 1, 123, 35, -1, 0, 121, 36, -2, 1, 119, 37, -2, 1, 118, 37, -1, 0, 116, 38, -2, 1, 115, 39, -1, 1, 113, 40, -2, 1, 112, 41, -1, 1, 110, 41, -2, 0, 108, 42, -2, 1, 107, 43, -1, 1, 106, 44, -1, 1, 104, 45, -2, 1, 103, 46, -1, 1, 101, 47, -2, 1, 100, 48, -1, 1, 98, 49, -2, 1, 97, 50, -1, 1, 96, 51, -1, 1, 94, 53, -2, 2, 93, 54, -1, 1, 92, 55, -1, 1, 91, 56, -1, 1, 89, 57, -2, 1, 88, 59, -1, 2, 87, 60, -1, 1, 86, 61, -1, 1, 85, 62, -1, 1, 83, 64, -2, 2, 82, 65, -1, 1, 81, 66, -1, 1, 80, 68, -1, 2, 79, 69, -1, 1, 78, 71, -1, 2, 77, 72, -1, 1, 76, 74, -1, 2, 75, 75, -1, 1, 74, 76, -1, 1, 73, 78, -1, 2, 73, 80, 0, 2, 72, 81, -1, 1, 71, 83, -1, 2, 70, 84, -1, 1, 69, 86, -1, 2, 69, 87, 0, 1, 68, 89, -1, 2, 67, 91, -1, 2, 67, 92, 0, 1, 66, 94, -1, 2, 65, 95, -1, 1, 65, 97, 0, 2, 64, 99, -1, 2, 64, 100, 0, 1, 63, 102, -1, 2, 63, 104, 0, 2, 63, 106, 0, 2, 62, 107, -1, 1, 62, 109, 0, 2, 62, 111, 0, 2, 61, 112, -1, 1, 61, 114, 0, 2, 61, 116, 0, 2, 61, 118, 0, 2, 60, 119, -1, 1, 60, 121, 0, 2, 60, 123, 0, 2, 60, 125, 0, 2, 60, 126, 0, 1, 60, 128, 0, 2, 60, 130, 0, 2, 60, 131, 0, 1, 60, 133, 0, 2, 60, 135, 0, 2, 60, 137, 0, 2, 61, 138, 1, 1, 61, 140, 0, 2, 61, 142, 0, 2, 61, 144, 0, 2, 62, 145, 1, 1, 62, 147, 0, 2, 62, 149, 0, 2, 63, 150, 1, 1, 63, 152, 0, 2, 63, 154, 0, 2, 64, 156, 1, 2, 64, 157, 0, 1, 65, 159, 1, 2, 65, 161, 0, 2, 66, 162, 1, 1, 67, 164, 1, 2, 67, 165, 0, 1, 68, 167, 1, 2, 69, 169, 1, 2, 69, 170, 0, 1, 70, 172, 1, 2, 71, 173, 1, 1, 72, 175, 1, 2, 73, 176, 1, 1, 73, 178, 0, 2, 74, 180, 1, 2, 75, 181, 1, 1, 76, 182, 1, 1, 77, 184, 1, 2, 78, 185, 1, 1, 79, 187, 1, 2, 80, 188, 1, 1, 81, 190, 1, 2, 82, 191, 1, 1, 83, 192, 1, 1, 85, 194, 2, 2, 86, 195, 1, 1, 87, 196, 1, 1, 88, 197, 1, 1, 89, 199, 1, 2, 91, 200, 2, 1, 92, 201, 1, 1, 93, 202, 1, 1, 94, 203, 1, 1, 96, 205, 2, 2, 97, 206, 1, 1, 98, 207, 1, 1, 100, 208, 2, 1, 101, 209, 1, 1, 103, 210, 2, 1, 104, 211, 1, 1, 106, 212, 2, 1, 107, 213, 1, 1, 108, 214, 1, 1, 110, 215, 2, 1, 112, 215, 2, 0, 113, 216, 1, 1, 115, 217, 2, 1, 116, 218, 1, 1, 118, 219, 2, 1, 119, 219, 1, 0, 121, 220, 2, 1, 123, 221, 2, 1, 124, 221, 1, 0, 126, 222, 2, 1, 127, 223, 1, 1, 129, 223, 2, 0, 131, 224, 2, 1, 132, 224, 1, 0, 134, 225, 2, 1, 136, 225, 2, 0, 138, 225, 2, 0, 139, 226, 1, 1, 141, 226, 2, 0, 143, 226, 2, 0, 144, 227, 1, 1, 146, 227, 2, 0, 148, 227, 2, 0, 150, 227, 2, 0, 151, 228, 1, 1, 153, 228, 2, 0, 155, 228, 2, 0, 157, 228, 2, 0, 158, 228, 1, 0, 160, 228, 2, 0, 162, 228, 2, 0, 163, 228, 1, 0, 165, 228, 2, 0, 167, 228, 2, 0, 169, 228, 2, 0, 170, 227, 1, -1, 172, 227, 2, 0, 174, 227, 2, 0, 176, 227, 2, 0, 177, 226, 1, -1, 179, 226, 2, 0, 181, 226, 2, 0, 182, 225, 1, -1, 184, 225, 2, 0, 186, 225, 2, 0, 188, 224, 2, -1, 189, 224, 1, 0, 191, 223, 2, -1, 193, 223, 2, 0, 194, 222, 1, -1, 196, 221, 2, -1, 197, 221, 1, 0, 199, 220, 2, -1, 201, 219, 2, -1, 202, 219, 1, 0, 204, 218, 2, -1, 205, 217, 1, -1, 207, 216, 2, -1, 208, 215, 1, -1, 210, 215, 2, 0, 212, 214, 2, -1, 213, 213, 1, -1, 214, 212, 1, -1, 216, 211, 2, -1, 217, 210, 1, -1, 219, 209, 2, -1, 220, 208, 1, -1, 222, 207, 2, -1, 223, 206, 1, -1, 224, 205, 1, -1, 226, 203, 2, -2, 227, 202, 1, -1, 228, 201, 1, -1, 229, 200, 1, -1, 231, 199, 2, -1, 232, 197, 1, -2, 233, 196, 1, -1, 234, 195, 1, -1, 235, 194, 1, -1, 237, 192, 2, -2, 238, 191, 1, -1, 239, 190, 1, -1, 240, 188, 1, -2, 241, 187, 1, -1, 242, 185, 1, -2, 243, 184, 1, -1, 244, 182, 1, -2, 245, 181, 1, -1, 246, 180, 1, -1, 247, 178, 1, -2, 247, 176, 0, -2, 248, 175, 1, -1, 249, 173, 1, -2, 250, 172, 1, -1, 251, 170, 1, -2, 251, 169, 0, -1, 252, 167, 1, -2, 253, 165, 1, -2, 253, 164, 0, -1, 254, 162, 1, -2, 255, 161, 1, -1, 255, 159, 0, -2, 256, 157, 1, -2, 256, 156, 0, -1, 257, 154, 1, -2, 257, 152, 0, -2, 257, 150, 0, -2, 258, 149, 1, -1, 258, 147, 0, -2, 258, 145, 0, -2, 259, 144, 1, -1, 259, 142, 0, -2, 259, 140, 0, -2, 259, 138, 0, -2, 260, 137, 1, -1, 260, 135, 0, -2, 260, 133, 0, -2, 260, 131, 0, -2, 260, 130, 0, -1
	; From https://tpenguinltg.wordpress.com/2014/02/15/representing-the-heart-shape-precisely/
	; x = K * 16 * sin (T)^3
	; y = K * (13 * cos (T) - 5 * cos (2 * T) - 2 * cos (3 * T) - cos (4 * T))
	DC.W 160, 96, 0, 0, 160, 96, 0, 0, 160, 96, 0, 0, 160, 96, 0, 0, 160, 95, 0, -1, 160, 95, 0, 0, 160, 95, 0, 0, 160, 94, 0, -1, 160, 93, 0, -1, 160, 93, 0, 0, 161, 92, 1, -1, 161, 91, 0, -1, 161, 90, 0, -1, 161, 90, 0, 0, 162, 89, 1, -1, 162, 88, 0, -1, 163, 87, 1, -1, 163, 85, 0, -2, 164, 84, 1, -1, 164, 83, 0, -1, 165, 82, 1, -1, 166, 81, 1, -1, 167, 79, 1, -2, 168, 78, 1, -1, 169, 77, 1, -1, 170, 75, 1, -2, 171, 74, 1, -1, 172, 73, 1, -1, 173, 71, 1, -2, 175, 70, 2, -1, 176, 69, 1, -1, 177, 67, 1, -2, 179, 66, 2, -1, 181, 65, 2, -1, 182, 64, 1, -1, 184, 63, 2, -1, 186, 61, 2, -2, 188, 60, 2, -1, 190, 59, 2, -1, 192, 58, 2, -1, 194, 57, 2, -1, 196, 57, 2, 0, 198, 56, 2, -1, 201, 55, 3, -1, 203, 54, 2, -1, 205, 54, 2, 0, 208, 53, 3, -1, 210, 53, 2, 0, 213, 52, 3, -1, 215, 52, 2, 0, 218, 52, 3, 0, 220, 52, 2, 0, 223, 52, 3, 0, 225, 52, 2, 0, 228, 52, 3, 0, 230, 52, 2, 0, 233, 52, 3, 0, 236, 53, 3, 1, 238, 53, 2, 0, 241, 54, 3, 1, 243, 54, 2, 0, 246, 55, 3, 1, 248, 56, 2, 1, 251, 57, 3, 1, 253, 58, 2, 1, 255, 59, 2, 1, 258, 60, 3, 1, 260, 61, 2, 1, 262, 62, 2, 1, 264, 64, 2, 2, 266, 65, 2, 1, 268, 67, 2, 2, 270, 68, 2, 1, 272, 70, 2, 2, 274, 71, 2, 1, 275, 73, 1, 2, 277, 75, 2, 2, 278, 76, 1, 1, 280, 78, 2, 2, 281, 80, 1, 2, 282, 82, 1, 2, 283, 84, 1, 2, 284, 86, 1, 2, 285, 88, 1, 2, 286, 90, 1, 2, 287, 92, 1, 2, 287, 94, 0, 2, 287, 96, 0, 2, 288, 98, 1, 2, 288, 100, 0, 2, 288, 102, 0, 2, 288, 105, 0, 3, 288, 107, 0, 2, 287, 109, -1, 2, 287, 111, 0, 2, 287, 113, 0, 2, 286, 115, -1, 2, 285, 117, -1, 2, 284, 119, -1, 2, 283, 122, -1, 3, 282, 124, -1, 2, 281, 126, -1, 2, 280, 128, -1, 2, 278, 130, -2, 2, 277, 132, -1, 2, 275, 134, -2, 2, 274, 136, -1, 2, 272, 138, -2, 2, 270, 140, -2, 2, 268, 142, -2, 2, 266, 144, -2, 2, 264, 146, -2, 2, 262, 148, -2, 2, 260, 150, -2, 2, 258, 152, -2, 2, 255, 154, -3, 2, 253, 156, -2, 2, 251, 158, -2, 2, 248, 159, -3, 1, 246, 161, -2, 2, 243, 163, -3, 2, 241, 165, -2, 2, 238, 167, -3, 2, 236, 169, -2, 2, 233, 170, -3, 1, 230, 172, -3, 2, 228, 174, -2, 2, 225, 176, -3, 2, 223, 178, -2, 2, 220, 179, -3, 1, 218, 181, -2, 2, 215, 183, -3, 2, 213, 184, -2, 1, 210, 186, -3, 2, 208, 188, -2, 2, 205, 189, -3, 1, 203, 191, -2, 2, 201, 193, -2, 2, 198, 194, -3, 1, 196, 196, -2, 2, 194, 198, -2, 2, 192, 199, -2, 1, 190, 201, -2, 2, 188, 202, -2, 1, 186, 204, -2, 2, 184, 206, -2, 2, 182, 207, -2, 1, 181, 209, -1, 2, 179, 210, -2, 1, 177, 211, -2, 1, 176, 213, -1, 2, 175, 214, -1, 1, 173, 216, -2, 2, 172, 217, -1, 1, 171, 218, -1, 1, 170, 220, -1, 2, 169, 221, -1, 1, 168, 222, -1, 1, 167, 223, -1, 1, 166, 224, -1, 1, 165, 225, -1, 1, 164, 226, -1, 1, 164, 227, 0, 1, 163, 228, -1, 1, 163, 229, 0, 1, 162, 230, -1, 1, 162, 231, 0, 1, 161, 232, -1, 1, 161, 233, 0, 1, 161, 233, 0, 0, 161, 234, 0, 1, 160, 234, -1, 0, 160, 235, 0, 1, 160, 235, 0, 0, 160, 236, 0, 1, 160, 236, 0, 0, 160, 236, 0, 0, 160, 237, 0, 1, 160, 237, 0, 0, 160, 237, 0, 0, 160, 237, 0, 0, 160, 237, 0, 0, 160, 237, 0, 0, 160, 237, 0, 0, 160, 236, 0, -1, 160, 236, 0, 0, 160, 236, 0, 0, 160, 235, 0, -1, 160, 235, 0, 0, 160, 234, 0, -1, 159, 234, -1, 0, 159, 233, 0, -1, 159, 233, 0, 0, 159, 232, 0, -1, 158, 231, -1, -1, 158, 230, 0, -1, 157, 229, -1, -1, 157, 228, 0, -1, 156, 227, -1, -1, 156, 226, 0, -1, 155, 225, -1, -1, 154, 224, -1, -1, 153, 223, -1, -1, 152, 222, -1, -1, 151, 221, -1, -1, 150, 220, -1, -1, 149, 218, -1, -2, 148, 217, -1, -1, 147, 216, -1, -1, 145, 214, -2, -2, 144, 213, -1, -1, 143, 211, -1, -2, 141, 210, -2, -1, 139, 209, -2, -1, 138, 207, -1, -2, 136, 206, -2, -1, 134, 204, -2, -2, 132, 202, -2, -2, 130, 201, -2, -1, 128, 199, -2, -2, 126, 198, -2, -1, 124, 196, -2, -2, 122, 194, -2, -2, 119, 193, -3, -1, 117, 191, -2, -2, 115, 189, -2, -2, 112, 188, -3, -1, 110, 186, -2, -2, 107, 184, -3, -2, 105, 183, -2, -1, 102, 181, -3, -2, 100, 179, -2, -2, 97, 178, -3, -1, 95, 176, -2, -2, 92, 174, -3, -2, 90, 172, -2, -2, 87, 170, -3, -2, 84, 169, -3, -1, 82, 167, -2, -2, 79, 165, -3, -2, 77, 163, -2, -2, 74, 161, -3, -2, 72, 159, -2, -2, 69, 158, -3, -1, 67, 156, -2, -2, 65, 154, -2, -2, 62, 152, -3, -2, 60, 150, -2, -2, 58, 148, -2, -2, 56, 146, -2, -2, 54, 144, -2, -2, 52, 142, -2, -2, 50, 140, -2, -2, 48, 138, -2, -2, 46, 136, -2, -2, 45, 134, -1, -2, 43, 132, -2, -2, 42, 130, -1, -2, 40, 128, -2, -2, 39, 126, -1, -2, 38, 124, -1, -2, 37, 122, -1, -2, 36, 119, -1, -3, 35, 117, -1, -2, 34, 115, -1, -2, 33, 113, -1, -2, 33, 111, 0, -2, 33, 109, 0, -2, 32, 107, -1, -2, 32, 105, 0, -2, 32, 102, 0, -3, 32, 100, 0, -2, 32, 98, 0, -2, 33, 96, 1, -2, 33, 94, 0, -2, 33, 92, 0, -2, 34, 90, 1, -2, 35, 88, 1, -2, 36, 86, 1, -2, 37, 84, 1, -2, 38, 82, 1, -2, 39, 80, 1, -2, 40, 78, 1, -2, 42, 76, 2, -2, 43, 75, 1, -1, 45, 73, 2, -2, 46, 71, 1, -2, 48, 70, 2, -1, 50, 68, 2, -2, 52, 67, 2, -1, 54, 65, 2, -2, 56, 64, 2, -1, 58, 62, 2, -2, 60, 61, 2, -1, 62, 60, 2, -1, 65, 59, 3, -1, 67, 58, 2, -1, 69, 57, 2, -1, 72, 56, 3, -1, 74, 55, 2, -1, 77, 54, 3, -1, 79, 54, 2, 0, 82, 53, 3, -1, 84, 53, 2, 0, 87, 52, 3, -1, 90, 52, 3, 0, 92, 52, 2, 0, 95, 52, 3, 0, 97, 52, 2, 0, 100, 52, 3, 0, 102, 52, 2, 0, 105, 52, 3, 0, 107, 52, 2, 0, 110, 53, 3, 1, 112, 53, 2, 0, 115, 54, 3, 1, 117, 54, 2, 0, 119, 55, 2, 1, 122, 56, 3, 1, 124, 57, 2, 1, 126, 57, 2, 0, 128, 58, 2, 1, 130, 59, 2, 1, 132, 60, 2, 1, 134, 61, 2, 1, 136, 63, 2, 2, 138, 64, 2, 1, 139, 65, 1, 1, 141, 66, 2, 1, 143, 67, 2, 1, 144, 69, 1, 2, 145, 70, 1, 1, 147, 71, 2, 1, 148, 73, 1, 2, 149, 74, 1, 1, 150, 75, 1, 1, 151, 77, 1, 2, 152, 78, 1, 1, 153, 79, 1, 1, 154, 81, 1, 2, 155, 82, 1, 1, 156, 83, 1, 1, 156, 84, 0, 1, 157, 85, 1, 1, 157, 87, 0, 2, 158, 88, 1, 1, 158, 89, 0, 1, 159, 90, 1, 1, 159, 90, 0, 0, 159, 91, 0, 1, 159, 92, 0, 1, 160, 93, 1, 1, 160, 93, 0, 0, 160, 94, 0, 1, 160, 95, 0, 1, 160, 95, 0, 0, 160, 95, 0, 0, 160, 96, 0, 1, 160, 96, 0, 0, 160, 96, 0, 0
	; x = (3 * R / 4) * cos (5 * T) + (R / 4) * cos (4 * T)
	; y = (3 * R / 4) * sin (5 * T) - (R / 4) * sin (4 * T)
	DC.W 260, 128, 0, 5, 260, 133, 0, 5, 259, 138, -1, 5, 257, 142, -2, 4, 255, 147, -2, 5, 251, 151, -4, 4, 248, 155, -3, 4, 244, 159, -4, 4, 239, 163, -5, 4, 233, 166, -6, 3, 227, 169, -6, 3, 221, 172, -6, 3, 214, 174, -7, 2, 207, 176, -7, 2, 200, 178, -7, 2, 192, 179, -8, 1, 184, 179, -8, 0, 176, 180, -8, 1, 168, 179, -8, -1, 160, 178, -8, -1, 151, 177, -9, -1, 143, 176, -8, -1, 135, 173, -8, -3, 127, 171, -8, -2, 120, 168, -7, -3, 113, 165, -7, -3, 106, 161, -7, -4, 99, 157, -7, -4, 93, 153, -6, -4, 88, 149, -5, -4, 83, 144, -5, -5, 78, 139, -5, -5, 74, 134, -4, -5, 71, 129, -3, -5, 68, 124, -3, -5, 66, 118, -2, -6, 65, 113, -1, -5, 64, 108, -1, -5, 64, 103, 0, -5, 65, 98, 1, -5, 66, 94, 1, -4, 68, 89, 2, -5, 71, 85, 3, -4, 74, 82, 3, -3, 78, 78, 4, -4, 82, 75, 4, -3, 87, 72, 5, -3, 92, 70, 5, -2, 98, 68, 6, -2, 104, 67, 6, -1, 111, 66, 7, -1, 118, 66, 7, 0, 125, 66, 7, 0, 132, 67, 7, 1, 140, 68, 8, 1, 147, 69, 7, 1, 155, 72, 8, 3, 163, 74, 8, 2, 170, 77, 7, 3, 178, 81, 8, 4, 185, 85, 7, 4, 192, 89, 7, 4, 199, 94, 7, 5, 205, 99, 6, 5, 211, 104, 6, 5, 217, 110, 6, 6, 222, 115, 5, 5, 227, 121, 5, 6, 231, 127, 4, 6, 235, 133, 4, 6, 238, 140, 3, 7, 241, 146, 3, 6, 243, 152, 2, 6, 244, 158, 1, 6, 245, 163, 1, 5, 245, 169, 0, 6, 244, 174, -1, 5, 243, 179, -1, 5, 242, 184, -1, 5, 239, 188, -3, 4, 237, 192, -2, 4, 233, 196, -4, 4, 229, 199, -4, 3, 225, 201, -4, 2, 220, 203, -5, 2, 215, 205, -5, 2, 210, 205, -5, 0, 204, 206, -6, 1, 198, 205, -6, -1, 191, 204, -7, -1, 185, 203, -6, -1, 178, 201, -7, -2, 172, 198, -6, -3, 165, 195, -7, -3, 158, 192, -7, -3, 152, 187, -6, -5, 145, 183, -7, -4, 139, 178, -6, -5, 133, 172, -6, -6, 127, 166, -6, -6, 122, 160, -5, -6, 117, 154, -5, -6, 112, 147, -5, -7, 107, 140, -5, -7, 104, 133, -3, -7, 100, 126, -4, -7, 97, 119, -3, -7, 95, 111, -2, -8, 93, 104, -2, -7, 91, 97, -2, -7, 90, 90, -1, -7, 90, 84, 0, -6, 90, 77, 0, -7, 91, 71, 1, -6, 92, 66, 1, -5, 94, 60, 2, -6, 96, 56, 2, -4, 99, 51, 3, -5, 102, 47, 3, -4, 106, 44, 4, -3, 110, 41, 4, -3, 114, 39, 4, -2, 119, 38, 5, -1, 124, 37, 5, -1, 129, 37, 5, 0, 134, 37, 5, 0, 140, 38, 6, 1, 145, 40, 5, 2, 151, 42, 6, 2, 157, 45, 6, 3, 162, 49, 5, 4, 168, 53, 6, 4, 173, 58, 5, 5, 178, 63, 5, 5, 183, 69, 5, 6, 188, 75, 5, 6, 193, 82, 5, 7, 197, 88, 4, 6, 200, 96, 3, 8, 204, 103, 4, 7, 207, 111, 3, 8, 210, 119, 3, 8, 212, 127, 2, 8, 214, 135, 2, 8, 215, 143, 1, 8, 216, 151, 1, 8, 216, 158, 0, 7, 216, 166, 0, 8, 215, 173, -1, 7, 214, 180, -1, 7, 212, 187, -2, 7, 210, 193, -2, 6, 208, 199, -2, 6, 205, 205, -3, 6, 202, 210, -3, 5, 199, 214, -3, 4, 195, 218, -4, 4, 191, 221, -4, 3, 187, 223, -4, 2, 182, 225, -5, 2, 177, 226, -5, 1, 173, 227, -4, 1, 168, 227, -5, 0, 163, 226, -5, -1, 158, 224, -5, -2, 153, 222, -5, -2, 148, 219, -5, -3, 144, 216, -4, -3, 139, 212, -5, -4, 135, 207, -4, -5, 131, 202, -4, -5, 127, 196, -4, -6, 124, 189, -3, -7, 121, 183, -3, -6, 118, 176, -3, -7, 116, 168, -2, -8, 114, 161, -2, -7, 112, 153, -2, -8, 111, 145, -1, -8, 110, 136, -1, -9, 110, 128, 0, -8, 110, 120, 0, -8, 111, 111, 1, -9, 112, 103, 1, -8, 114, 95, 2, -8, 116, 88, 2, -7, 118, 80, 2, -8, 121, 73, 3, -7, 124, 67, 3, -6, 127, 60, 3, -7, 131, 54, 4, -6, 135, 49, 4, -5, 139, 44, 4, -5, 144, 40, 5, -4, 148, 37, 4, -3, 153, 34, 5, -3, 158, 32, 5, -2, 163, 30, 5, -2, 168, 29, 5, -1, 173, 29, 5, 0, 177, 30, 4, 1, 182, 31, 5, 1, 187, 33, 5, 2, 191, 35, 4, 2, 195, 38, 4, 3, 199, 42, 4, 4, 202, 46, 3, 4, 205, 51, 3, 5, 208, 57, 3, 6, 210, 63, 2, 6, 212, 69, 2, 6, 214, 76, 2, 7, 215, 83, 1, 7, 216, 90, 1, 7, 216, 98, 0, 8, 216, 105, 0, 7, 215, 113, -1, 8, 214, 121, -1, 8, 212, 129, -2, 8, 210, 137, -2, 8, 207, 145, -3, 8, 204, 153, -3, 8, 200, 160, -4, 7, 197, 168, -3, 8, 193, 174, -4, 6, 188, 181, -5, 7, 183, 187, -5, 6, 178, 193, -5, 6, 173, 198, -5, 5, 168, 203, -5, 5, 162, 207, -6, 4, 157, 211, -5, 4, 151, 214, -6, 3, 145, 216, -6, 2, 140, 218, -5, 2, 134, 219, -6, 1, 129, 219, -5, 0, 124, 219, -5, 0, 119, 218, -5, -1, 114, 217, -5, -1, 110, 215, -4, -2, 106, 212, -4, -3, 102, 209, -4, -3, 99, 205, -3, -4, 96, 200, -3, -5, 94, 196, -2, -4, 92, 190, -2, -6, 91, 185, -1, -5, 90, 179, -1, -6, 90, 172, 0, -7, 90, 166, 0, -6, 91, 159, 1, -7, 93, 152, 2, -7, 95, 145, 2, -7, 97, 137, 2, -8, 100, 130, 3, -7, 104, 123, 4, -7, 107, 116, 3, -7, 112, 109, 5, -7, 117, 102, 5, -7, 122, 96, 5, -6, 127, 90, 5, -6, 133, 84, 6, -6, 139, 78, 6, -6, 145, 73, 6, -5, 152, 69, 7, -4, 158, 64, 6, -5, 165, 61, 7, -3, 172, 58, 7, -3, 178, 55, 6, -3, 185, 53, 7, -2, 191, 52, 6, -1, 198, 51, 7, -1, 204, 50, 6, -1, 210, 51, 6, 1, 215, 51, 5, 0, 220, 53, 5, 2, 225, 55, 5, 2, 229, 57, 4, 2, 233, 60, 4, 3, 237, 64, 4, 4, 239, 68, 2, 4, 242, 72, 3, 4, 243, 77, 1, 5, 244, 82, 1, 5, 245, 87, 1, 5, 245, 93, 0, 6, 244, 98, -1, 5, 243, 104, -1, 6, 241, 110, -2, 6, 238, 116, -3, 6, 235, 123, -3, 7, 231, 129, -4, 6, 227, 135, -4, 6, 222, 141, -5, 6, 217, 146, -5, 5, 211, 152, -6, 6, 205, 157, -6, 5, 199, 162, -6, 5, 192, 167, -7, 5, 185, 171, -7, 4, 178, 175, -7, 4, 170, 179, -8, 4, 163, 182, -7, 3, 155, 184, -8, 2, 147, 187, -8, 3, 140, 188, -7, 1, 132, 189, -8, 1, 125, 190, -7, 1, 118, 190, -7, 0, 111, 190, -7, 0, 104, 189, -7, -1, 98, 188, -6, -1, 92, 186, -6, -2, 87, 184, -5, -2, 82, 181, -5, -3, 78, 178, -4, -3, 74, 174, -4, -4, 71, 171, -3, -3, 68, 167, -3, -4, 66, 162, -2, -5, 65, 158, -1, -4, 64, 153, -1, -5, 64, 148, 0, -5, 65, 143, 1, -5, 66, 138, 1, -5, 68, 132, 2, -6, 71, 127, 3, -5, 74, 122, 3, -5, 78, 117, 4, -5, 83, 112, 5, -5, 88, 107, 5, -5, 93, 103, 5, -4, 99, 99, 6, -4, 106, 95, 7, -4, 113, 91, 7, -4, 120, 88, 7, -3, 127, 85, 7, -3, 135, 83, 8, -2, 143, 80, 8, -3, 151, 79, 8, -1, 160, 78, 9, -1, 168, 77, 8, -1, 176, 76, 8, -1, 184, 77, 8, 1, 192, 77, 8, 0, 200, 78, 8, 1, 207, 80, 7, 2, 214, 82, 7, 2, 221, 84, 7, 2, 227, 87, 6, 3, 233, 90, 6, 3, 239, 93, 6, 3, 244, 97, 5, 4, 248, 101, 4, 4, 251, 105, 3, 4, 255, 109, 4, 4, 257, 114, 2, 5, 259, 118, 2, 4, 260, 123, 1, 5
ptPathDataEnd:
ptParticleAnimation:	; For each step : bitmap (offset), speed
OFFSET_ANIMATION_BITMAP=0
OFFSET_ANIMATION_SPEED=2
DATASIZE_ANIMATION=2*2
	BLK.W PARTICLE_TTL*(DATASIZE_ANIMATION>>1),0
ptHalfBrightHalfHeight:			DC.W 0
ptHalfBrightLinesHalfWidth:		DC.W 0
ptFlags:						DC.B 0
								EVEN

;---------- Tune ----------

	IFNE TUNE
module:		INCBIN "scoopexONEv6.1/data/smash9.mod"
	ENDC
