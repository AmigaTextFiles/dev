
; The following constants are for debuging purpose, to enable / disable the various parts of the demo. Notice that a part assumes that the 
; bitplanes are set by default in the Copperlist, but it may change them in the Copperlist, which means that the bitplanes must be restored 
; as per default in the Copperlist before the next part begins. This is the job of a PART_MESSAGE_*, so don't forget to enable at least one
; PART_MESSAGE_* between two parts you enable.
PART_GENERAL=1
PART_DESIRE=0		; The 320x256x4 picture would require too much memory on a "standard" A500 (512Kb Chip + 512Kb Fast), so no great logo from ALIEN
PART_MESSAGE_SIGNAL=PART_GENERAL!1
PART_SIGNAL=PART_GENERAL!0
PART_MESSAGE_SCROLLS=PART_GENERAL!0
PART_SCROLLS=PART_GENERAL!0
PART_MESSAGE_MESH=PART_GENERAL!0
PART_MESH=PART_GENERAL!0
PART_MESSAGE_END=PART_GENERAL!0

; TO DO

; Cut;

; Remanence on the printer or the cutter?

; Main:

; -Pass the logo in more colours (be careful with the colours reserved for the mesh)
; - Delete all comments ;debug
; Test memory allocations and quit if not enough memory

; Signal:

; - WAIT_ENDOFFRAME is not enough when there are no more particles: the particle alone accelerates. But if you put a _wait, you sometimes miss a frame
; Use purple for an effect: scroll the BBS call number in giant font
; Introduce some randomness in the direction of the bounce
; Draw the curve in a bitplane
; Generate 360 positions and not 320, and make a window of 320 that runs through it
; The way the speed of the particles is managed seems to me to be shitty because we see too much slowing down: a possible solution?
; - When a generator arrives on the right of the screen it overflows on the left one line down because it is not clipped
; Write an explanation (calculations, triple buffering, barrel, animation...)
;- Use a bitplane according to the TTL ?

; Scrolls:

; - Use purple for an effect. A plasma in the background?

; Mesh:

; - The first frame is messed up.
; - see if it's not interesting to change the pattern on the right


;-------------------------------------------------------------------------------
;                           .oO Desire "ONE" (v1) Oo.
;                              A tribute to sysops
;
; An first intro for the glorious Desire Amiga group, produced in September 2019.
;
;                Code & Design: Yragael (stashofcode@gmail.com)
;                Graphics:      Bokanoid
;                Music:         Subi
;                Support:       Ramon B5 / Desire
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

; This work is licensed under the terms of the Creative Commons Attribution-NonCommercial 4.0 International License
; (http://creativecommons.org/licenses/by-nc/4.0/).

;*******************************************************************************
; Constants
;*******************************************************************************

; Program

TUNE=1
DEBUG=0
A1200=0

; COmmon

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=4
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*4+4
	; 10*4						Display configuration
	; DISPLAY_DEPTH*2*4			Bitplanes addresses
	; (1<<DISPLAY_DEPTH)*4		Palette
	; 4							$FFFFFFFE
LOGO_X=0		; Must be multiple of 16
LOGO_Y=0
LOGO_DX=320		; Must be multiple of 16
LOGO_DY=48
PRT_PRINTER=1

; Messages between parts

	IFNE PART_MESSAGE_SIGNAL!PART_MESSAGE_SCROLLS!PART_MESSAGE_MESH

MSG_PRINTER_DX=20*8
MSG_PRINTER_DY=16*8
MSG_PRINTER_X=(DISPLAY_DX-MSG_PRINTER_DX)>>1
MSG_PRINTER_Y=(DISPLAY_DY-MSG_PRINTER_DY)>>1
MSG_PRINTER_CHARDELAY=1
MSG_PRINTER_PAGEDELAY=130
MSG_CUTTER_X=MSG_PRINTER_X-16		; Must be multiple of 16
MSG_CUTTER_Y=MSG_PRINTER_Y-16
MSG_CUTTER_DX=MSG_PRINTER_DX+2*16	; Must be multiple of 16
MSG_CUTTER_DY=MSG_PRINTER_DY+2*16	; Must be multiple of 16
MSG_CUTTER_SQUARESDELAY=4
MSG_CUTTER_FINALDELAY=25			; Must be > 0
MSG_CUTTER_DURATION=130

	ENDC

; Part I

	IFNE PART_DESIRE

DSR_PART_DURATION=400	; Duration of the part (in frames)

	ENDC

; Part II

	IFNE PART_SIGNAL

SGN_PART_DURATION=400	; Duration of the part (in frames), unless the user clicks when allowed to exit. Warning! Must be enough for
						; sngNbParticles to reach SGN_NBPARTICLES (this rule is enforced)
SGN_STATE_DRAWING=$0001
SGN_STATE_EXTINGUISHING=$0002
SGN_STATE_FADING=$0004
SGN_FADE_NBSTEPS=50
SGN_EXTINCTION_DELAY=2	; Minimum is 1 (no delay)
SGN_PATH_LENGTH=DISPLAY_DX
SGN_PATH_Y=DISPLAY_DY>>1
SGN_PARTICLE_DX=8		; Do not touch!
SGN_PARTICLE_DY=8		; Do not touch!
SGN_PARTICLE_VX=0
SGN_PARTICLE_VY=0
	IFNE A1200
SGN_PARTICLE_SEEDS=1
SGN_NBPARTICLES=300
SGN_PARTICLE_DELAY=1	; Minimum is 0 (no delay)
SGN_PARTICLE_TTL=SGN_NBPARTICLES*SGN_PARTICLE_DELAY/SGN_PARTICLE_SEEDS	; At least SGN_NBPARTICLES*SGN_PARTICLE_DELAY/SGN_PARTICLE_SEEDS for SGN_NBPARTICLES
	ELSE
SGN_PARTICLE_SEEDS=1
SGN_NBPARTICLES=95
SGN_PARTICLE_DELAY=1	; Minimum is 0 (no delay)
SGN_PARTICLE_TTL=SGN_NBPARTICLES*SGN_PARTICLE_DELAY/SGN_PARTICLE_SEEDS	; At least SGN_NBPARTICLES*SGN_PARTICLE_DELAY/SGN_PARTICLE_SEEDS for SGN_NBPARTICLES
	ENDC
SGN_PARTICLE_DISC=1		; 0: Square, 1: Disc
SGN_PARTICLE_SPEED=3
SGN_PARTICLE_NBKEYS=8	; The bitmaps for the animation of the particle (see sgnParticleBitmaps)

	ENDC

; Part III

	IFNE PART_SCROLLS

SCL_PART_DURATION=7500	; Duration of the part (in frames), unless the user clicks when allowed to exit. Warning! Must be enough for
						; sclNbActiveScrolls to reach SCL_NBSCOLLS (this rule is enforced)
SCL_STATE_DRAWING=$0001
SCL_STATE_STOPPING=$0002
SCL_STOPPING_DELAY=10	; Minimum is 1 (no delay)
SCL_ENDING_DELAY=200	; Minimum is 1 (no delay)
SCL_NBSCROLLS=17
SCL_NBFONTS=13

	ENDC

; Part IV

	IFNE PART_MESH

MSH_PART_DURATION=1800	; Duration of the part (in frames), unless the user clicks when allowed to exit
MSH_ERASING_DELAY=15	; Minimum is 1 (no delay)
MSH_STATE_DRAWING=$0001
MSH_STATE_PRINTING=$0002
MSH_STATE_ERASING=$0004
MSH_STATE_FADING=$0008
MSH_FADE_NBSTEPS=50
MSH_PRINTER_DY=22*8
MSH_PRINTER_Y=LOGO_Y+LOGO_DY+(DISPLAY_DY-LOGO_Y-LOGO_DY-MSH_PRINTER_DY)>>1
MSH_PRINTER_CHARDELAY=1
MSH_PRINTER_PAGEDELAY=150
	IFNE A1200
MSH_DX=8
MSH_DY=8
	ELSE
MSH_DX=5
MSH_DY=5
	ENDC
MSH_SIDEX=30		; 1+DISPLAY_DX/MSH_DX		; + 1 to be sure to overstep the border of the screen
MSH_SIDEY=30		; 1+DISPLAY_DY/MSH_DY		; Same thing
MSH_SPEED=3
MSH_RADIUS=40
MSH_STRENGTH_START=200
MSH_STRENGTH_END=30
MSH_STRENGTH_STEPS=150

	ENDC

; *******************************************************************************
;  Macros
; *******************************************************************************

WAIT_BLITTER:		MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)		; Means testing bit 14%8=6 of the most significant byte of DMACONR, which is BBUSY
	bne _waitBlitter0\@
_waitBlitter1\@					; Not required since Fat Agnus which sets bit 14 as soon as BLTSIZE is written to instead of waiting for
								; a first Blitter DMA cycle
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM

	; This waits for the raster to reach or pass the bottom line of the displayed part of the screen (which should not be > 312).
	; Notice that this won't be enough to wait a full screen refresh if the code that calls WAIT_ENDOFFRAME in a loop takes less
	; time to execute than the raster needs it to start again at the first line of the displayed part of the screen.

WAIT_ENDOFFRAME:	MACRO
_waitEndOfFrame\@
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmpi.w #DISPLAY_Y+DISPLAY_DY,d0
	blt _waitEndOfFrame\@
	ENDM

; *******************************************************************************
;  Setup
; *******************************************************************************
	
	SECTION code,CODE

	; Stack registers

	movem.l d0-d7/a0-a6,-(sp)

	; StingRay's stuff

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)		; OpenLibrary ()
	move.l d0,graphicsBase
	move.l graphicsBase,a6
	move.l $22(a6),view
	movea.l #0,a1
	jsr -222(a6)		; LoadView ()
	jsr -270(a6)		; WaitTOF ()
	jsr -270(a6)		; WaitTOF ()
	jsr -228(a6)		; WaitBlit ()
	jsr -456(a6)		; OwnBlitter ()
	move.l graphicsBase,a1
	movea.l $4,a6
	jsr -414(a6)		; CloseLibrary ()

	moveq #0,d0			; Default VBR is $0
	movea.l $4,a6
	btst #0,296+1(a6)	; 68010+?
	beq _is68000
	lea _getVBR,a5
	jsr -30(a6)			; SuperVisor ()
	move.l d0,VBRPointer
	bra _is68000
_getVBR:
	; movec vbr,d0
	dc.l $4e7a0801		;  movec vbr,d0
	rte
_is68000:

	; Shut down the system

	jsr -132(a6)		; Forbid ()

	; Wait for VERTB (to avoid sprites drooling) and shut down the hardware interrupts and the DMAs

	lea $DFF000,a5
	bsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

	; Wait for the Blitter to end, if ever it was in use

	WAIT_BLITTER

	; Restore level 6 interrupt for music player

	IFNE TUNE
	move.l VBRPointer,a0
	lea $78(a0),a0
	move.l (a0),vector30
	move.w #$E000,INTENA(a5)
	ENDC

	; Allocate CHIP memory set to 0 for the Copperlist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,copperList

	; Allocate CHIP memory set to 0 for the front and back buffers. There are some requirements for triple-buffering in part I:
	; A1 and B1 must be contiguous, so must A2 and B2, so must A3 and B3, because An and Bn must be cleared in the same blit. 
	; Since we may not allocate 8 contiguous bitplanes, we must allocate several pairs of contiguous bitplanes.

	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,bitplanes1
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,bitplanes2
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,bitplanes3
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,bitplanes4

	; ---------- Copperlist ----------

	movea.l copperList,a0

	; Screen configuration

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	; OCS compatibility with AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Bitplanes addresses

	move.w #BPL1PTH,d0
	move.l bitplanes1,d1
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.l bitplanes2,d1
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.l bitplanes3,d1
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.l bitplanes4,d1
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0

	; Palette

	lea palette,a1
	IFNE DEBUG
	move.l #$01820000,(a0)+		; A NOP to avoid touching COLOR00 and keep the Copperlist structure
	move.w #COLOR01,d1
	lea 2(a1),a1
	moveq #(1<<DISPLAY_DEPTH)-2,d0
	ELSE
	move.w #COLOR00,d1
	moveq #(1<<DISPLAY_DEPTH)-1,d0
	ENDC
_copperListColors:
	move.w d1,(a0)+
	addq.w #2,d1
	move.w (a1)+,(a0)+
	dbf d0,_copperListColors

	; End of Copperlist

	move.l #$FFFFFFFE,(a0)

	; Start the Copperlist

	bsr _waitVERTB
	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1
	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; ---------- Setup ----------

	; Start the tune

	IFNE TUNE
	lea $DFF000,a6
	lea module,a0
	moveq #0,d0 ; start at pattern 0
	jsr mt_init
	moveq #1,d0 ; PAL timing
	move.l VBRPointer,a0
	jsr mt_install_cia
; 	lea mt_Enable(pc),a0
	movea.l #mt_Enable,a0
	st (a0)
	ENDC

	; Set the cutter pattern pointer

	IFNE PART_MESSAGE_SIGNAL!PART_MESSAGE_SCROLLS!PART_MESSAGE_MESH
	move.l #msgCutterPatterns,msgCutterPattern
	ENDC

; *******************************************************************************
;  Part I: DESIRE presents...
; *******************************************************************************

	IFNE PART_DESIRE

	; ---------------------------------------------------------------------------
	;  Setup
	; ---------------------------------------------------------------------------

	; Fade to white

	lea palette,a0
	lea whitePalette,a1
	jsr _fade

	;  COpy the picture

	move.w #$03AA,BLTCON0(a5)	; USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTCMOD(a5)
	move.w #0,BLTDMOD(a5)
	lea dsrPicture,a0
	movea.l copperList,a1		; Reading the addresses of the bitplanes in the Copperlist allows a loop
	lea 10*4+2(a1),a1
	moveq #DISPLAY_DEPTH-1,d0
_dsrCopyPicture:
	move.l a0,BLTCPTH(a5)
	move.w (a1),d1
	swap d1
	move.w 4(a1),d1
	move.l d1,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	lea 2*4(a1),a1
	WAIT_BLITTER
	dbf d0,_dsrCopyPicture

	; Fade to palette

	lea whitePalette,a0
	lea dsrPicture+DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),a1
	jsr _fade

	; ---------------------------------------------------------------------------
	;  Main loop
	; ---------------------------------------------------------------------------

	; Wait some time

	move.w #DSR_PART_DURATION,d0
	jsr _wait

	; Fade to black

	lea dsrPicture+DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),a0
	lea blackPalette,a1
	jsr _fade

	ENDC

; *******************************************************************************
;  Interlude: Announcing part II
; *******************************************************************************

	IFNE PART_MESSAGE_SIGNAL

	; Display message

	lea msgPartSignal,a0
	jsr _message

	ENDC

; *******************************************************************************
;  Part II: The Carrier
; *******************************************************************************

; Some quick & dirty notes about the algorithm:
; 
; 1/ To generate a particle
; 
; DX = SGN_PARTICLE_VX + OFFSET_PATH_DX
; If > 0
; 	incX = 1
; Else
; 	DX = -DX
; 	incX = -1
; DY = SGN_PARTICLE_VY + OFFSET_PATH_DY
; If > 0
; 	incY = 1
; Else
; 	DY = -DY
; 	incY = -1
; If DX > DY
; 	OFFSET_PARTICLE_INCX0 = incX
; 	OFFSET_PARTICLE_INCY0 = 0
; 	OFFSET_PARTICLE_INCX1 = 0
; 	OFFSET_PARTICLE_INCY1 = incY
; 	OFFSET_PARTICLE_MINDXDY = DY
; 	OFFSET_PARTICLE_MAXDXDY = DX
; Else
; 	OFFSET_PARTICLE_INCX0 = 0
; 	OFFSET_PARTICLE_INCY0 = incY
; 	OFFSET_PARTICLE_INCX1 = incX
; 	OFFSET_PARTICLE_INCY1 = 0
; 	OFFSET_PARTICLE_MINDXDY = DX
; 	OFFSET_PARTICLE_MAXDXDY = DY
; OFFSET_PARTICLE_ACCUMULATOR = 0
; 
; 2/ To move a particle:
; 
; OFFSET_PARTICLE_ACCUMULATOR += OFFSET_PARTICLE_MINDXDY
; If > OFFSET_PARTICLE_MAXDXDY
; 	OFFSET_PARTICLE_ACCUMULATOR -= OFFSET_PARTICLE_MAXDXDY
; 	OFFSET_PARTICLE_X += OFFSET_PARTICLE_INCX1
; 	OFFSET_PARTICLE_Y += OFFSET_PARTICLE_INCY1
; Else
; 	OFFSET_PARTICLE_X += OFFSET_PARTICLE_INCX0
; 	OFFSET_PARTICLE_Y += OFFSET_PARTICLE_INCY0


; D6 = offset in sgnPath on the point corresponding to the first generator (list browsed backwards, so from X=319 to X=0, 
; to facilitate the offset overflow test), the generators being distributed at regular intervals along the path, i.e.: 
; (SGN_PATH_LENGTH/SGN_PARTICLE_SEEDS)*DATASIZE_PATH positions between two successive generators
; and D7 = delay between the generation of particles by the generators (when this delay expires, all generators are 
; successively asked to generate a particle, but within the limit of the maximum number of particles)

	IFNE PART_SIGNAL

	; ---------------------------------------------------------------------------
	;  Setup
	; ---------------------------------------------------------------------------

	; COpy the logo

	move.w #$03AA,BLTCON0(a5)	; USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTCMOD(a5)
	move.w #(DISPLAY_DX-LOGO_DX)>>3,BLTDMOD(a5)
	move.l #logo,BLTCPTH(a5)
	movea.l bitplanes1,a0
	lea LOGO_Y*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(LOGO_DY<<6)!(LOGO_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; COpy the background

	move.w #0,BLTDMOD(a5)
	move.l #sgnBackground,BLTCPTH(a5)
	movea.l bitplanes1,a0
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Fade to palette

	lea whitePalette,a0
	lea sgnPalette,a1
	jsr _fade

	; ---------------------------------------------------------------------------
	;  Main loop
	; ---------------------------------------------------------------------------

	; ---------- Generate bitmaps for the animation of a particle ----------

	lea sgnParticleBitmaps,a0
	lea sgnParticleBitmapsShifted,a1
	moveq #SGN_PARTICLE_NBKEYS-1,d0
_sgnShiftParticleBitmaps:

	; COpy the bitmap

	movea.l a0,a2
	movea.l a1,a3
	REPT 8
	move.b (a2),(a3)
	lea 2(a3),a3
	lea SGN_PARTICLE_NBKEYS(a2),a2
	ENDR

	; Generate the 7 bitmaps for 7 consecutive shifts of one pixel toward the right of the bitmap

	moveq #8-2,d1
_sgnParticleShiftBitmap:
	moveq #8-1,d2
_sgnParticleShiftRow:
	move.w (a1)+,d3
	lsr.w #1,d3
	move.w d3,(a3)+
	dbf d2,_sgnParticleShiftRow
	dbf d1,_sgnParticleShiftBitmap

	; Next bitmap

	movea.l a3,a1
	lea 1(a0),a0
	dbf d0,_sgnShiftParticleBitmaps

	; ---------- Generate animation of a particle ----------

	; Generate the animation of a particle according to its TTL (warning: TTL increases in this loop, but it will decreases in the main loop)

	lea sgnParticleAnimation,a0
	move.w #-1,sgnAccumulator0
	move.w #-1,sgnAccumulator1
	move.w #SGN_PARTICLE_NBKEYS-1,d6
	move.w #1,d7
	move.w #SGN_PARTICLE_TTL,d5
_sgnParticleAnimate:

	; Animate the bitmap

	move.w #SGN_PARTICLE_NBKEYS-1,d0
	move.w #0,d1
	move.w #SGN_PARTICLE_TTL,d2
	move.w sgnAccumulator0,d3
	move.w d6,d4
	jsr _interpolate
	move.w d3,sgnAccumulator0
	move.w d4,d6
	mulu #8*8*2,d4
	move.w d4,(a0)+

	; Animate the speed

	move.w #1,d0
	move.w #SGN_PARTICLE_SPEED,d1
	move.w #SGN_PARTICLE_TTL,d2
	move.w sgnAccumulator1,d3
	move.w d7,d4
	jsr _interpolate
	move.w d3,sgnAccumulator1
	move.w d4,d7
	move.w d4,(a0)+

	subq.w #1,d5
	beq _sgnParticleAnimateDone
	bra _sgnParticleAnimate
_sgnParticleAnimateDone:

	; ---------- Setup the main loop ----------

	; Particles

	move.w #SGN_NBPARTICLES,sgnMaxNbParticles
	move.w #0,sgnNbParticles
	move.l #sgnParticlesStart,sgnFirstParticle
	move.l sgnFirstParticle,sgnNextParticle
	move.w #(SGN_PATH_LENGTH-1)*DATASIZE_PATH,d6	; Offset in sgnPath for the first generator position
	move.w #SGN_PARTICLE_DELAY,d7					; Delay between two particle generations

	; Set the bitplanes in the Copperlist

	movea.l copperList,a0
	lea 10*4+2(a0),a0

	move.l bitplanes1,d1
	swap d1
	move.w d1,(a0)
	swap d1
	move.w d1,4(a0)
	lea 8(a0),a0

	move.l bitplanes2,d2
	move.w d2,4(a0)
	swap d2
	move.w d2,(a0)
	lea 8(a0),a0

	move.l bitplanes3,d2
	move.w d2,4(a0)
	swap d2
	move.w d2,(a0)
	lea 8(a0),a0

	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d1
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)

	; Set the triple-buffering pointers

	movea.l bitplanes2,a0
	move.l a0,sgnBitplaneA1
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,sgnBitplaneB1
	movea.l bitplanes3,a0
	move.l a0,sgnBitplaneA2
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,sgnBitplaneB2
	movea.l bitplanes4,a0
	move.l a0,sgnBitplaneA3
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,sgnBitplaneB3

	; Setup the fader

	lea fadeSetupData,a0
	move.l #sgnPalette,OFFSET_FADESETUP_PALETTESTART(a0)
	move.l #blackPalette,OFFSET_FADESETUP_PALETTEEND(a0)
	move.w #16,OFFSET_FADESETUP_NBCOLORS(a0)
	move.w #SGN_FADE_NBSTEPS,OFFSET_FADESETUP_NBSTEPS(a0)
	movea.l copperList,a1
	lea 10*4+DISPLAY_DEPTH*2*4(a1),a1
	move.l a1,OFFSET_FADESETUP_COPPERLIST(a0)
	jsr _fadeSetup

	; Setup the state

	move.w #SGN_STATE_DRAWING,partState
	move.w #SGN_PART_DURATION,sgnTimer

	; ---------- Main loop ----------

_sgnLoop:

	; Wait for the raster to reach the bottom of the displayed area

	IFNE DEBUG
	movea.l bitplanes1,a0
	lea (DISPLAY_DY-8)*(DISPLAY_DX>>3)(a0),a0
	jsr _showTime
	moveq #1,d0
	jsr _wait
	ELSE
	WAIT_ENDOFFRAME
	ENDC

	; Roll bitplanes *1, *2 and *3 (*1 is being diplayed as *2 is being cleared using the Blitter and *3 is being drawn using the CPU)

	move.l sgnBitplaneA1,d0
	move.l sgnBitplaneA2,d1
	move.l sgnBitplaneA3,d2
	move.l d2,sgnBitplaneA1
	move.l d0,sgnBitplaneA2
	move.l d1,sgnBitplaneA3
	move.l copperList,a0
	move.w d2,10*4+1*2*4+4+2(a0)
	swap d2
	move.w d2,10*4+1*2*4+2(a0)

	move.l sgnBitplaneB1,d0
	move.l sgnBitplaneB2,d1
	move.l sgnBitplaneB3,d2
	move.l d2,sgnBitplaneB1
	move.l d0,sgnBitplaneB2
	move.l d1,sgnBitplaneB3
	move.l copperList,a0
	move.w d2,10*4+2*2*4+4+2(a0)
	swap d2
	move.w d2,10*4+2*2*4+2(a0)

	; Wait for end of ex-bitplanes *2 (now bitplanes *3) clearing and start clearing bitplanes *2

	WAIT_BLITTER
	move.w #0,BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=0
	move.w #$0000,BLTCON1(a5)
	move.l sgnBitplaneA2,BLTDPTH(a5)
	move.w #((2*DISPLAY_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)		; Clear contiguous A2 and B2

	; ########## Particles drawing (SGN_STATE_DRAWING) (start) ##########

	move.w partState,d0
	and.w #SGN_STATE_DRAWING,d0
	beq _sgnStateNotParticlesDrawing

	; ---------- Draw the particles and the generators ----------

	; Display the number of particles (debug)

	IFNE DEBUG
	movem.l d0/a0,-(sp)
	movea.l bitplanes1,a0
	lea 8*(DISPLAY_DX>>3)(a0),a0
	move.w sgnNbParticles,d0
	jsr _print4Digits
	movem.l (sp)+,d0/a0
	ENDC

	; Remove particles of which TTL has expired (ie : equal to 0) by moving the pointer to the data for the particles of
	; which TTL has not expired is moved in the circular list of data for the particles

	movea.l sgnFirstParticle,a0
	move.w sgnNbParticles,d0
	beq _sgnTestTTLDone
_sgnTestTTL:
	tst.w OFFSET_PARTICLE_TTL(a0)
	bne _sgnTestTTLEnd
	lea DATASIZE_PARTICLE(a0),a0
	cmp.l #sgnParticlesEnd,a0
	bne _sgnTestTTLNoListLoop
	lea sgnParticlesStart,a0
_sgnTestTTLNoListLoop:
	subq.w #1,d0
	bne _sgnTestTTL
_sgnTestTTLEnd:
	move.l a0,sgnFirstParticle
	move.w d0,sgnNbParticles
_sgnTestTTLDone:

	; Draw the particles

	movea.l sgnFirstParticle,a0
	move.w sgnNbParticles,d0
_sgnDrawParticles:
	beq _sgnDrawParticlesEnd

	move.w OFFSET_PARTICLE_BITMAP(a0),d1

	move.w OFFSET_PARTICLE_X(a0),d2
	move.w OFFSET_PARTICLE_Y(a0),d3
	mulu #DISPLAY_DX>>3,d3
	move.w d2,d4
	lsr.w #3,d4
	add.w d4,d3
	and.w #$0007,d2

	lsl.w #4,d2		; D2 contains the offset for the key bitmap, and 1 bitmap = 8 * 2 bytes, thereby a maximum offset of 7 * 8 * 2 = 128 bytes
	add.w d2,d1
	lea sgnParticleBitmapsShifted,a1
	lea (a1,d1.w),a1

	cmpi.w #SGN_PARTICLE_TTL>>1,OFFSET_PARTICLE_TTL(a0)		; Youngsters drawn in A3, elders drawn in B3 (remember that TTL is decreasing)
	bgt _sngParticleIsYoung
	movea.l sgnBitplaneB3,a2
	bra _sngParticleIsOld
_sngParticleIsYoung:
	movea.l sgnBitplaneA3,a2
_sngParticleIsOld:

	REPT 8
	move.b (a1)+,d1
	or.b d1,(a2,d3.w)
	move.b (a1)+,d1
	or.b d1,1(a2,d3.w)
	addi.w #DISPLAY_DX>>3,d3
	ENDR

	lea DATASIZE_PARTICLE(a0),a0
	cmp.l #sgnParticlesEnd,a0
	bne _sgnDrawParticlesNoListLoop
	lea sgnParticlesStart,a0
_sgnDrawParticlesNoListLoop
	subq.w #1,d0
	bra _sgnDrawParticles
_sgnDrawParticlesEnd:

	; Draw the generators

	lea sgnPath,a0
	moveq #SGN_PARTICLE_SEEDS-1,d3
	move.w d6,d4
_sgnDrawParticleSeeds:

	move.w OFFSET_PATH_X(a0,d4.w),d0
	move.w OFFSET_PATH_Y(a0,d4.w),d1
	mulu #DISPLAY_DX>>3,d1
	move.w d0,d2
	lsr.w #3,d2
	add.w d2,d1
	and.w #$0007,d0

	lsl.w #4,d0		; D2 contains the offset of the key bitmap, and 1 bitmap = 8 * 2 bytes, thereby a maximum offset of 7 * 8 * 2 = 128 bytes
	lea sgnParticleBitmapsShifted,a1
	lea (a1,d0.w),a1
	movea.l sgnBitplaneA3,a2
	REPT 8
	move.b (a1)+,d0
	or.b d0,(a2,d1.w)
	move.b (a1)+,d0
	or.b d0,1(a2,d1.w)
	addi.w #DISPLAY_DX>>3,d1
	ENDR

	subi.w #(SGN_PATH_LENGTH/SGN_PARTICLE_SEEDS)*DATASIZE_PATH,d4
	bge _sgnDrawParticleSeedsNoUnderflow
	addi.w #SGN_PATH_LENGTH*DATASIZE_PATH,d4
_sgnDrawParticleSeedsNoUnderflow:

	dbf d3,_sgnDrawParticleSeeds

	; ---------- Animate the particles and the generators ----------

	; Move the particles, decrease their TTL, set their bitmap according to their TTL

	movea.l sgnFirstParticle,a0
	lea sgnParticleAnimation,a1
	move.w sgnNbParticles,d0
_sgnMoveParticles:
	beq _sgnMoveParticlesEnd

	; Move the particle
	
	move.w OFFSET_PARTICLE_X(a0),d1
	move.w OFFSET_PARTICLE_Y(a0),d2
	move.w OFFSET_PARTICLE_ACCUMULATOR(a0),d3
	move.w OFFSET_PARTICLE_SPEED(a0),d4
_sgnMoveParticleSpeedLoop:
	add.w OFFSET_PARTICLE_MINDXDY(a0),d3
	cmp.w OFFSET_PARTICLE_MAXDXDY(a0),d3
	blt _sgnMoveParticlesNoAccumlatorOverflow
	sub.w OFFSET_PARTICLE_MAXDXDY(a0),d3
	add.w OFFSET_PARTICLE_INCX1(a0),d1
	add.w OFFSET_PARTICLE_INCY1(a0),d2
_sgnMoveParticlesNoAccumlatorOverflow:
	add.w OFFSET_PARTICLE_INCX0(a0),d1
	add.w OFFSET_PARTICLE_INCY0(a0),d2
	subq #1,d4
	bne _sgnMoveParticleSpeedLoop
	move.w d3,OFFSET_PARTICLE_ACCUMULATOR(a0)

	;  COnstrain the position of the particle by making it bounce if it reaches a border

	tst.w d1
	bge _sgnMoveParticleNoXUnderflow
	moveq #0,d1
	neg.w OFFSET_PARTICLE_INCX0(a0)
	neg.w OFFSET_PARTICLE_INCX1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
	bra _sgnMoveParticleNoXOverflow
_sgnMoveParticleNoXUnderflow:
	cmp.w #DISPLAY_DX-SGN_PARTICLE_DX,d1
	ble _sgnMoveParticleNoXOverflow
	move.w #DISPLAY_DX-SGN_PARTICLE_DX,d1
	neg.w OFFSET_PARTICLE_INCX0(a0)
	neg.w OFFSET_PARTICLE_INCX1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
_sgnMoveParticleNoXOverflow:

	tst.w d2
	bge _sgnMoveParticleNoYUnderflow
	moveq #0,d2
	neg.w OFFSET_PARTICLE_INCY0(a0)
	neg.w OFFSET_PARTICLE_INCY1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
	bra _sgnMoveParticleNoYOverflow
_sgnMoveParticleNoYUnderflow:
	cmp.w #DISPLAY_DY-SGN_PARTICLE_DY,d2
	ble _sgnMoveParticleNoYOverflow
	move.w #DISPLAY_DY-SGN_PARTICLE_DY,d2
	neg.w OFFSET_PARTICLE_INCY0(a0)
	neg.w OFFSET_PARTICLE_INCY1(a0)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a0)
_sgnMoveParticleNoYOverflow:

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
	cmp.l #sgnParticlesEnd,a0
	bne _sgnMoveParticlesNoListLoop
	lea sgnParticlesStart,a0
_sgnMoveParticlesNoListLoop:
	subq.w #1,d0
	bra _sgnMoveParticles
_sgnMoveParticlesEnd:

	; ---------- Generate one particle per generator ----------

	; Do not generate any particle if the delay between two generations has not expired
	
	movea.l sgnNextParticle,a1
	tst.w d7
	bne _sgnNoNewParticleAndWait

	; Particles generation loop

	lea sgnPath,a0
	move.w d6,d4
	moveq #SGN_PARTICLE_SEEDS-1,d5
_sgnNewParticle:

	; Exit the particles generation loop if the maximum number of particles has been reached
 
	move.w sgnNbParticles,d0
	cmp.w sgnMaxNbParticles,d0
	bge _sgnNoNewParticle

	; Generate a particle at the current generator position

	addq.w #1,d0
	move.w d0,sgnNbParticles

	move.w #0*8*8*2,OFFSET_PARTICLE_BITMAP(a1)	; Where 0 is the number of the key bitmap : 0 (8x8), 1 (7x7), 2 (6x6), etc.
	move.w OFFSET_PATH_X(a0,d4.w),OFFSET_PARTICLE_X(a1)
	move.w OFFSET_PATH_Y(a0,d4.w),OFFSET_PARTICLE_Y(a1)
	move.w #SGN_PARTICLE_SPEED,OFFSET_PARTICLE_SPEED(a1)
	move.w #SGN_PARTICLE_TTL,OFFSET_PARTICLE_TTL(a1)
	moveq #1,d2
	move.w #SGN_PARTICLE_VX,d0
	add.w OFFSET_PATH_DX(a0,d4.w),d0
	bge _sgnNewParticleDXPositive
	neg.w d0							; D0 = |DX|
	moveq #-1,d2						; D2 = IncX
_sgnNewParticleDXPositive:
	moveq #1,d3
	move.w #SGN_PARTICLE_VY,d1
	add.w OFFSET_PATH_DY(a0,d4.w),d1
	bge _sgnNewParticleDYPositive
	neg.w d1							; D1 = |DY|
	moveq #-1,d3						; D3 = IncY
_sgnNewParticleDYPositive:

	btst #0,VHPOSR+1(a5)				; Randomize (|DX| += n * bit #1 of raster X position) so that high frequency generated consecutives
										; particles are not aligned
	beq _sngNewParticleNoRandomnessX
	addq.w #6,d0						; n set to 6
_sngNewParticleNoRandomnessX:
	btst #0,VHPOSR(a5)					; Randomize (|DY| += n * bit #0 of raster Y position) so that high frequency generated consecutives
										; particles are not aligned
	beq _sngNewParticleNoRandomnessY
	addq.w #2,d1						; n set to 2
_sngNewParticleNoRandomnessY:

	cmp.w d0,d1
	bge _sgnNewParticleDYGreater
	exg d0,d1							; D1 = max (|DX|, |DY|) et d0 = min (|DX|, |DY|)
	move.w d2,OFFSET_PARTICLE_INCX0(a1)
	move.w #0,OFFSET_PARTICLE_INCY0(a1)
	move.w #0,OFFSET_PARTICLE_INCX1(a1)
	move.w d3,OFFSET_PARTICLE_INCY1(a1)
	bra _sgnNewParticleDXGreater
_sgnNewParticleDYGreater:
	move.w #0,OFFSET_PARTICLE_INCX0(a1)
	move.w d3,OFFSET_PARTICLE_INCY0(a1)
	move.w d2,OFFSET_PARTICLE_INCX1(a1)
	move.w #0,OFFSET_PARTICLE_INCY1(a1)
_sgnNewParticleDXGreater:
	move.w d0,OFFSET_PARTICLE_MINDXDY(a1)
	move.w d1,OFFSET_PARTICLE_MAXDXDY(a1)
	move.w #0,OFFSET_PARTICLE_ACCUMULATOR(a1)

	lea DATASIZE_PARTICLE(a1),a1
	cmp.l #sgnParticlesEnd,a1
	bne _sgnNewParticlesNoListLoop
	lea sgnParticlesStart,a1
_sgnNewParticlesNoListLoop:

	; Move to next generator position

	subi.w #(SGN_PATH_LENGTH/SGN_PARTICLE_SEEDS)*DATASIZE_PATH,d4
	bge _sgnNewParticleSeedsNoUnderflow
	addi.w #SGN_PATH_LENGTH*DATASIZE_PATH,d4
_sgnNewParticleSeedsNoUnderflow:
	dbf d5,_sgnNewParticle

	move.w #SGN_PARTICLE_DELAY,d7

	; End of or no particles generation

_sgnNoNewParticleAndWait:
	subq.w #1,d7
_sgnNoNewParticle:
	move.l a1,sgnNextParticle

	; Move the generator along the path

	subi.w #DATASIZE_PATH,d6
	bge _sgnPathNoUnderflow
	addi.w #SGN_PATH_LENGTH*DATASIZE_PATH,d6
_sgnPathNoUnderflow:

	; ---------- Draw the signal ----------

	movea.l bitplanes4,a0
	lea sgnPath,a1
	move.w OFFSET_PATH_X(a1,d6.w),d0
	move.w d0,d1
	lsr.w #3,d1
	move.w OFFSET_PATH_Y(a1,d6.w),d2
	addq.w #4,d2
	mulu #DISPLAY_DX>>3,d2
	add.w d2,d1
	not.b d0
	and.b #$07,d0
; 	bset d0,(a0,d1.w)

	; ---------- Test part exit condition: duration has expired and current number of particles has reached the maximum ----------

	move.w partState,d0
	and.w #SGN_STATE_EXTINGUISHING!SGN_STATE_FADING,d0
	bne _sgnTheShowMustGoOn
	move.w sgnTimer,d1
	beq _sgnTheShowMustEnd
	subq.w #1,d1
	move.w d1,sgnTimer
	bra _sgnTheShowMustGoOn
_sgnTheShowMustEnd:
	cmpi.w #SGN_NBPARTICLES,sgnNbParticles
	bne _sgnTheShowMustGoOn
	or.w #SGN_STATE_EXTINGUISHING,partState
	move.w #1,sgnTimer
_sgnTheShowMustGoOn:

_sgnStateNotParticlesDrawing:

	; ########## Particles drawing (SGN_STATE_DRAWING) (end) ##########

	; ########## Particles extinction (SGN_STATE_EXTINGUISHING) (start) ##########

	move.w partState,d0
	and.w #SGN_STATE_EXTINGUISHING,d0
	beq _sgnStateNotExtinguishing

	; Stop extinguishing and start fading if the maximum and current numbers of particles have been reduced to 0

	move.w sgnMaxNbParticles,d0
	bne _sgnMaxNbParticlesNotZero
	tst.w sgnNbParticles
	bne _sgnStateNotExtinguishing
	and.w #~SGN_STATE_EXTINGUISHING,partState
	or.w #SGN_STATE_FADING,partState
	bra _sgnStateNotExtinguishing

	; Check if timer has expired before reducing the maximum number of particles

_sgnMaxNbParticlesNotZero:
	move.w sgnTimer,d1
	subq.w #1,d1
	bne _sgnTimerNotExpired

	; Reduce the maximum number of particles

	subq.w #1,d0
	move.w d0,sgnMaxNbParticles
	move.w #SGN_EXTINCTION_DELAY,d1

	; Update timer

_sgnTimerNotExpired:
	move.w d1,sgnTimer

_sgnStateNotExtinguishing:

	; ########## Particles extinction (SGN_STATE_EXTINGUISHING) (start) ##########

	; ########## Fader (SGN_STATE_FADING) (start) ##########

	move.w partState,d0
	and.w #SGN_STATE_FADING,d0
	beq _sgnStateNotFading

	; Run the fader

	jsr _fadeStep
	tst.w d0
	bne _sgnEnd

_sgnStateNotFading:

	; ########## Fader (SGN_STATE_FADING) (end) ##########

	; Start exit sequence if the left mouse button has been pressed and exit sequence has not already started and current number
	; of particles has reached the maximum

	move.w partState,d0
	and.w #SGN_STATE_EXTINGUISHING,d0
	bne _sgnNoQuickExit
	btst #6,$BFE001
	bne _sgnNoQuickExit
	cmpi.w #SGN_NBPARTICLES,sgnNbParticles
	bne _sgnNoQuickExit
	or.w #SGN_STATE_EXTINGUISHING,partState
	move.w #1,sgnTimer
_sgnNoQuickExit:

	bra _sgnLoop

	; ---------------------------------------------------------------------------
	;  Ending
	; ---------------------------------------------------------------------------

_sgnEnd:

	; End the fader

	jsr _fadeEnd

	; Wait for the left mouse button to be released

_sgnMouseButtonNotReleased:
	btst #6,$BFE001
	beq _sgnMouseButtonNotReleased

	bra _sgnPartDone

	; ---------------------------------------------------------------------------
	;  Routines
	; ---------------------------------------------------------------------------

_sgnPartDone:
	ENDC

; *******************************************************************************
;  Interlude: Announcing part III
; *******************************************************************************

	IFNE PART_MESSAGE_SCROLLS

	lea msgPartScrolls,a0
	jsr _message

	ENDC

; *******************************************************************************
;  Part III: The Chat
; *******************************************************************************

	IFNE PART_SCROLLS

	; ---------------------------------------------------------------------------
	;  Setup
	; ---------------------------------------------------------------------------

	; Setup the fonts (extract header and retrieve data)

	lea sclFonts,a0
	move.w #SCL_NBFONTS-1,d0
_sclSetupFonts:
	movea.l SCL_FONT_OFFSET_FONT(a0),a1
	clr.w d1
	move.b VFNT_HEADER_NBCHARS(a1),d1
	move.b d1,SCL_FONT_OFFSET_NBCHARS(a0)
	lea VFNT_HEADER_LENGTH(a1),a2
	move.l a2,SCL_FONT_OFFSET_DATA(a0)
	add.w d1,d1
	lea (a2,d1.w),a2
	move.l a2,SCL_FONT_OFFSET_BITPLANES(a0)
	move.b VFNT_HEADER_FIRSTASCII(a1),SCL_FONT_OFFSET_FIRSTASCII(a0)
	move.b VFNT_HEADER_CHARSIDE(a1),d2								; 16 x 16 => 4 or 32 x 32 => 5 or 64 x 64 => 6, which means that side = 1 << charSide
	move.b d2,SCL_FONT_OFFSET_CHARSIDE(a0)
	moveq #1,d1
	lsl.b d2,d1
	move.b d1,SCL_FONT_OFFSET_CHARSIDEPIXELS(a0)
	move.b VFNT_HEADER_CHARSIZE(a1),SCL_FONT_OFFSET_CHARSIZE(a0)
	move.b VFNT_HEADER_SPACEWIDTH(a1),SCL_FONT_OFFSET_SPACEWIDTH(a0)
	lea SCL_FONT_DATASIZE(a0),a0
	dbf d0,_sclSetupFonts

	; Setup the scrolls (precompute pointers and Blitter registers values)

	lea sclScrolls,a0
	moveq #SCL_NBSCROLLS-1,d0
_sclSetupScrolls:
	bsr _sclSetup
	lea SCL_SCROLL_DATASIZE(a0),a0
	dbf d0,_sclSetupScrolls

	; COpy the logo

	move.w #$03AA,BLTCON0(a5)	; USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTCMOD(a5)
	move.w #(DISPLAY_DX-LOGO_DX)>>3,BLTDMOD(a5)
	move.l #logo,BLTCPTH(a5)
	movea.l bitplanes1,a0
	lea LOGO_Y*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(LOGO_DY<<6)!(LOGO_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Setup the front and back buffers
	
	movea.l bitplanes2,a0
	move.l a0,sclFrontBuffer
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,sclBackBuffer

	; COunt number of scrolls that starts immediately

	moveq #0,d0
	lea sclScrolls,a0
	moveq #SCL_NBSCROLLS-1,d1
_sclCountStartingScrolls:
	tst.w SCL_SCROLL_OFFSET_DELAY(a0)
	bne _sclScrollStartsLater
	addq.w #1,d0
_sclScrollStartsLater:
	lea SCL_SCROLL_DATASIZE(a0),a0
	dbf d1,_sclCountStartingScrolls
	move.w d0,sclNbActiveScrolls

	; Setup the state

	move.w #SCL_STATE_DRAWING,partState
	move.w #SCL_PART_DURATION,sclTimer

	; Fade to palette

	lea whitePalette,a0
	lea sclPalette,a1
	jsr _fade

	; ---------------------------------------------------------------------------
	;  Main loop
	; ---------------------------------------------------------------------------

_sclLoop:

	; Wait for the raster to reach the bottom of the displayed area and swap the front and the back buffers

	WAIT_BLITTER
	IFNE DEBUG
	movea.l bitplanes1,a0
	lea (DISPLAY_DY-8)*(DISPLAY_DX>>3)(a0),a0
	jsr _showTime
	moveq #1,d0
	jsr _wait
	ELSE
	WAIT_ENDOFFRAME
	ENDC

	; Swap the scrolls front and back buffers

	move.l sclFrontBuffer,d0
	move.l sclBackBuffer,d1
	move.l d0,sclBackBuffer
	move.l d1,sclFrontBuffer
	movea.l copperList,a0
	lea 10*4+1*2*4+2(a0),a0
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)

	; ########## Scrolls drawing (SCL_DRAWING) (start) ##########

	move.w partState,d0
	and.w #SCL_STATE_DRAWING,d0
	beq _sclStateNotDrawing

	; Draw the scrolls

	lea sclScrolls,a0
	moveq #SCL_NBSCROLLS-1,d0
_sclDrawScrolls:
	tst.w SCL_SCROLL_OFFSET_DELAY(a0)
	beq _sclDelayExpired
	sub.w #1,SCL_SCROLL_OFFSET_DELAY(a0)
	bne _sclDelayNotExpired
	addi.w #1,sclNbActiveScrolls
_sclDelayNotExpired:
	bra _sclDrawDone
_sclDelayExpired:
	tst.b SCL_SCROLL_OFFSET_ORIENTATION(a0)
	bne _sclDrawVertical
	bsr _hScrollDraw
	bra _sclDrawDone
_sclDrawVertical:
	bsr _vScrollDraw
_sclDrawDone:
	lea SCL_SCROLL_DATASIZE(a0),a0
	dbf d0,_sclDrawScrolls

	; Test part exit condition: duration has expired and number of all scrolls are active

	move.w partState,d0
	and.w #SCL_STATE_STOPPING,d0
	bne _sclTheShowMustGoOn
	move.w sclTimer,d1
	beq _sclTheShowMustEnd
	subq.w #1,d1
	move.w d1,sclTimer
	bra _sclTheShowMustGoOn
_sclTheShowMustEnd:
	cmpi.w #SCL_NBSCROLLS,sclNbActiveScrolls
	bne _sclTheShowMustGoOn
	or.w #SCL_STATE_STOPPING,partState
	move.w #1,sclTimer
_sclTheShowMustGoOn:

_sclStateNotDrawing:

	; ########## Scrolls drawing (SCL_SCROLLS_DRAWING) (end) ##########

	; ########## Scrolls stopping (SCL_STATE_STOPPING) (start) ##########

	move.w partState,d0
	and.w #SCL_STATE_STOPPING,d0
	beq _sclStateNotStopping

	; Check if all scrolls have been stopped and display spaces only. There's no way to tell if a scroll displays spaces only.
	; The workaround is to wait for a reasonable amount of time for the widest and slowest of the scrolls to allegedly display spaces only. 
	; This is what SCL_ENDING_DELAY is about.

	move.w sclTimer,d1
	move.w sclNbActiveScrolls,d0
	bne _sclStillActiveScrolls
	subq.w #1,d1
	bne _sclTimerNotExpired
	bra _sclEnd
_sclStillActiveScrolls:

	; Check if timer has expired before stopping a new scroll

	subq.w #1,d1
	bne _sclTimerNotExpired

	; Find the last active scroll (this first would always be the same)

	move.w d0,d2
	subq.w #1,d2
	mulu #SCL_SCROLL_DATASIZE,d2
	lea sclScrolls,a0
	lea (a0,d2.w),a0

	; Stop this scroll by setting all chars to $20

	movea.l SCL_SCROLL_OFFSET_TEXT(a0),a0
_sclStopActiveScroll:
	tst.b (a0)
	beq _sclActiveScrollStopped
	move.b #$20,(a0)+
	bra _sclStopActiveScroll
_sclActiveScrollStopped:

	; Remember than one more scroll has been stopped

	subq.w #1,d0
	bne _sclActiveScrollsRemain
	move.w #SCL_ENDING_DELAY,d1
	bra _sclTimerSet
_sclActiveScrollsRemain:
	move.w #SCL_STOPPING_DELAY,d1
_sclTimerSet:
	move.w d0,sclNbActiveScrolls

	; Update timer

_sclTimerNotExpired:
	move.w d1,sclTimer

_sclStateNotStopping:

	; ########## Scrolls stopping (SCL_STATE_STOPPING) (end) ##########

	; Start exit sequence if the left mouse button has been pressed and exit sequence has not already started and all scrolls are active

	move.w partState,d0
	and.w #SCL_STATE_STOPPING,d0
	bne _sclNoQuickExit
	btst #6,$BFE001
	bne _sclNoQuickExit
	cmpi.w #SCL_NBSCROLLS,sclNbActiveScrolls
	bne _sclNoQuickExit
	or.w #SCL_STATE_STOPPING,partState
	move.w #1,sclTimer
_sclNoQuickExit:

	bra _sclLoop
	
	; ---------------------------------------------------------------------------
	;  Ending
	; ---------------------------------------------------------------------------

_sclEnd:

	; Wait for the left mouse button to be released

_sclMouseButtonNotReleased:
	btst #6,$BFE001
	beq _sclMouseButtonNotReleased

	; Fade to black

	lea sclPalette,a0
	lea blackPalette,a1
	jsr _fade

	bra _sclPartDone

	; ---------------------------------------------------------------------------
	;  Routines
	; ---------------------------------------------------------------------------

; ---------- Scroll setup ----------

; Input(s):
; 	A0 = Pointer to a SCL_SCROLL structure
; Output(s):
; 	None

_sclSetup:
	move.l SCL_SCROLL_OFFSET_TEXT(a0),SCL_SCROLL_OFFSET_CHAR(a0)
	subi.l #1,SCL_SCROLL_OFFSET_CHAR(a0)
	rts

; ---------- Horizontal scroll ----------

; Input(s):
; 	A0 = Pointer to a SCL_SCROLL structure
; Output(s):
; 	None
; Notice:
; 	Although this code looks like the code for a vertical scroll, it is not the same, since the new columns are drawn by drawing lines with the Blitter and not by moving words with the CPU.

SCL_LINEH_DX=15			; Do not touch! Syntactic sugar for a value for the Blitter: dx = max (abs (x2 - x1), abs (y2 - y1)) = 15
SCL_LINEH_DY=0			; Do not touch! Syntactic sugar for a value for the Blitter: dy = min (abs (x2 - x1), abs (y2 - y1)) = 0

_hScrollDraw:
	movem.l d0-d5/a1-a3,-(sp)

	; The part of the scroll to copy starts at X + SPEED and ends at X + DX - 1 (SPEED columns are going to vanish on the left)

	movea.l SCL_SCROLL_OFFSET_FONT(a0),a1	; A1 = Pointer to the font structure

	; Check if a copy is required (no copy if all the columns must change)

	moveq #1,d2								; D2 = # of words being fully or partially used
	move.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	cmp.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	beq _hScrollNoCopy

	; ---------- Copy and shift the previous characters columns ----------

	; Setup the Blitter: a simple copy of source A that is masked then shifted in DESC mode (required because shifting toward the left)

	WAIT_BLITTER
	move.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	ror.w #4,d0
	or.w #$09F0,d0
	move.w d0,BLTCON0(a5)					; ASH3-0=shift, USEA=1, USEB=0, USEC=0, USED=1, D=A
	move.w #$0002,BLTCON1(a5)				; DESC=1

	;  COnfigure the Blitter: the masks

	; For BLTALWM (first word of a line in DESC mode), it requires (notice the subtle value for X & $000F = 0: the whole word is used):
	; X & $000F = 0	 => $FFFF
	; X & $000F  = 1	 => $7FFF
	; ...
	; X & $000F  = 15 => $0001
	; For BLTAFWM (last word of a line in DESC mode), it requires (notice the subtle value for (X + DX - 1) & $000F = 15: the whole word is used):
	; (X + DX - 1) & $FFFF = 0  => $FFFF
	; (X + DX - 1) & $FFFF = 1  => $8000
	; ...
	; (X + DX - 1) & $FFFF = 15 => $FFFE

	move.w SCL_SCROLL_OFFSET_X(a0),d0
	add.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	and.w #$000F,d0
	moveq #-1,d1
	lsr.w d0,d1
	move.w d1,BLTALWM(a5)					; BLATLWM (first word of a line in DESC mode) = $FFFF >> (X & $000F)
	move.w SCL_SCROLL_OFFSET_X(a0),d0
	add.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	subq.w #1,d0
	and.w #$000F,d0
	addq.b #1,d0
	moveq #-1,d1
	lsr.w d0,d1
	not.w d1
	move.w d1,BLTAFWM(a5)					; BLATFWM (last word of a line in DESC mode) = ~ ($FFFF >> (1 + (X - DX - 1) & $000F))

	;  COmpute the width of the scroll in fully or partially used words, including the masked ones (D2 must be equal to 1)
	
	move.w SCL_SCROLL_OFFSET_X(a0),d0
	add.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	and.w #$000F,d0
	move.w SCL_SCROLL_OFFSET_SIZE(a0),d1
	subi.w #16,d1
	add.w d0,d1
	ble _hScrollDrawWORDCountDone
	moveq #2,d2
	move.w SCL_SCROLL_OFFSET_X(a0),d0
	add.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	subq.w #1,d0
	and.w #$000F,d0
	addq.w #1,d0
	sub.w d0,d1
	beq _hScrollDrawWORDCountDone
	lsr.w #4,d1
	add.w d1,d2								; D2 = # of fully or partially used words
_hScrollDrawWORDCountDone:	

	; Setup the Blitter: the pointers

	move.w SCL_SCROLL_OFFSET_Y(a0),d0
	subq.w #1,d0
	move.w #DISPLAY_DX>>3,d1
	mulu d1,d0
	move.b SCL_FONT_OFFSET_CHARSIDE(a1),d3
	lsl.w d3,d1								; 16 x 16 => 4 or 32 x 32 => 5 or 64 x 64 => 6, so X * side = X << charSide
	add.w d1,d0

	move.w d0,d3
	move.w SCL_SCROLL_OFFSET_X(a0),d1
	add.w SCL_SCROLL_OFFSET_SPEED(a0),d1
	subq.w #1,d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.w d1,d3
	add.w d2,d3
	add.w d2,d3
	subq.w #2,d3	
	movea.l sclFrontBuffer,a2
	lea (a2,d3.w),a2
	move.l a2,BLTAPTH(a5)

	move.w SCL_SCROLL_OFFSET_X(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.w d1,d0
	add.w d2,d0
	add.w d2,d0
	subq.w #2,d0
	movea.l sclBackBuffer,a2
	lea (a2,d0.w),a2
	move.l a2,BLTDPTH(a5)

	; Setup the Blitter: the modulos
	
	move.w #DISPLAY_DX>>3,d0
	sub.w d2,d0
	sub.w d2,d0
	move.w d0,BLTAMOD(a5)
	move.w d0,BLTDMOD(a5)

	;  COpy the scroll while shifting it toward the left

	clr.w d0
	move.b SCL_FONT_OFFSET_CHARSIDEPIXELS(a1),d0
	lsl.w #6,d0
	or.w d2,d0
	move.w d0,BLTSIZE(a5)
_hScrollNoCopy:

	; ---------- Draw the new characters columns ----------

	;  COmpute the pointer to the last word of the scroll and the index of the first column where to draw a character column

	move.w SCL_SCROLL_OFFSET_Y(a0),d1
	mulu #DISPLAY_DX>>3,d1
	move.w SCL_SCROLL_OFFSET_X(a0),d0
	add.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	sub.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	move.w d0,d2
	lsr.w #3,d2
	and.b #$FE,d2
	add.w d2,d1
	add.l sclBackBuffer,d1							; D1 = Pointer to the word in the first column where to draw a character column
	and.w #$000F,d0									; D0 = First column where to draw a character column

	; Setup the Blitter for line drawing

	WAIT_BLITTER
	move.w #$F041!(0<<0),BLTCON1(a5)				; TEXTURE3-0=15 (start bit for the texture), SIGN=1, OVFLAG=0, SUD/SUL/AUL=octant (0), SING=0, LINE=1
	move.w #4*(SCL_LINEH_DY-SCL_LINEH_DX),BLTAMOD(a5)
	move.w #4*SCL_LINEH_DY,BLTBMOD(a5)
	move.w #DISPLAY_DX>>3,BLTCMOD(a5)
	move.w #DISPLAY_DX>>3,BLTDMOD(a5)
	move.w #(4*SCL_LINEH_DY)-(2*SCL_LINEH_DX),BLTAPTL(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)
	move.w #$8000,BLTADAT(a5)

	; Loop for drawing the character(s) column(s)

	movea.l SCL_SCROLL_OFFSET_CHAR(a0),a2			; A2 = Pointer to the current character in the text
	movea.l SCL_SCROLL_OFFSET_CHARCOLUMN(a0),a3		; A3 = Pointer to the column to draw in the next character bitplane
	move.w SCL_SCROLL_OFFSET_SPEED(a0),d2			; D2 = # of columns to draw
	move.b SCL_SCROLL_OFFSET_CHARCOLUMNS(a0),d3		; D3 = # of columns of the current character bitplane that remains to be drawn - 1
_hScrollDrawColumn:

	; Move to the next character column (which may be the first column of the next character)

	subq.b #1,d3
	bge _hScrollDrawNoSourceColumnOverflow
	lea 1(a2),a2
	tst.b (a2)
	bne _hScrollDrawDoNotLoopText
	movea.l SCL_SCROLL_OFFSET_TEXT(a0),a2
_hScrollDrawDoNotLoopText:
	moveq #0,d4										; And not CLR.B because MOVE.L D4,D5 later, then D5 used as a LONG to compute an offset...
	move.b (a2),d4
	sub.b SCL_FONT_OFFSET_FIRSTASCII(a1),d4
	move.l d4,d5
	bne _hScrollDrawCharNotSpace
	move.b SCL_FONT_OFFSET_SPACEWIDTH(a1),d3
	subq.b #1,d3									; D3 = # of columns in the current character that stil may be drawn - 1
	bra _hScrollDrawCharSpace
_hScrollDrawCharNotSpace:
	add.w d4,d4
	movea.l SCL_FONT_OFFSET_DATA(a1),a3
	move.b VFNT_CHAR_RIGHT(a3,d4.w),d3				; D3 = # of columns in the current character that stil may be drawn - 1
_hScrollDrawCharSpace:
	move.b SCL_FONT_OFFSET_CHARSIZE(a1),d4
	lsl.l d4,d5										; 16 x 16 => 5 or 32 x 32 => 7 or 64 x 64 => 9, so X * size = X << charSize (LSL.L because > 32768 if font is 64 x 64)
	movea.l SCL_FONT_OFFSET_BITPLANES(a1),a3
	add.l d5,a3										; A3 = Pointer to the column to draw in the current character bitplane (ADD.L for the same reason)
_hScrollDrawNoSourceColumnOverflow:

	; Draw the character column (draw N lines of 16 pixels)

	move.w d0,d4
	ror.w #4,d4
	or.w #$0BCA,d4
	move.w d4,BLTCON0(a5)							; START3-0=pixel, USEA=1, USEB=0, USEC=1, USED=1, D=AB+aC=ABC+ABc+abC+aBC=$CA
	move.b SCL_FONT_OFFSET_CHARSIDEPIXELS(a1),d4
	lsr.b #4,d4										; D4 = # of words of a column
	move.l d1,d5
_hScrollDrawColumnWORD:
	move.w (a3)+,BLTBDAT(a5)
	move.l d5,BLTCPTH(a5)
	move.l d5,BLTDPTH(a5)
	move.w #((SCL_LINEH_DX+1)<<6)!$0002,BLTSIZE(a5)
	WAIT_BLITTER
	addi.l #16*(DISPLAY_DX>>3),d5
	subq.b #1,d4
	bne _hScrollDrawColumnWORD

	; Move to the column where to draw the next one (maybe, in the next word)

	addq.b #1,d0
	cmp.b #16,d0
	blt _hScrollDrawNoDestinationColumnOverflow
	clr.b d0
	addq.l #2,d1
_hScrollDrawNoDestinationColumnOverflow:

	subq.b #1,d2
	bne _hScrollDrawColumn

	; Remember the state of the scroll

	move.l a2,SCL_SCROLL_OFFSET_CHAR(a0)
	move.l a3,SCL_SCROLL_OFFSET_CHARCOLUMN(a0)
	move.b d3,SCL_SCROLL_OFFSET_CHARCOLUMNS(a0)

	movem.l (sp)+,d0-d5/a1-a3
	rts

; ---------- Vertical scroll ----------

; Input(s):
; 	A0 = Pointer to a SCL_SCROLL structure
; Output(s):
; 	None
; Notice:
; 	Although this code looks like the code for an horizontal scroll, it is not the same, since the new columns are drawn by moving words
;   with the CPU and not by drawing lines with the Blitter

SCL_LINEV_DX=0		; Do not touch! Syntactic sugar for a value for the Blitter: dx = max (abs (x2 - x1), abs (y2 - y1)) = 15
SCL_LINEV_DY=15		; Do not touch! Syntactic sugar for a value for the Blitter: dy = min (abs (x2 - x1), abs (y2 - y1)) = 0

_vScrollDraw:
	movem.l d0-d7/a0-a4/a6,-(sp)

	; The part of the scroll to copy starts at Y and ends at Y + DY - SPEED - 1 (SPEED lines are going to vanish in the bottom)

	movea.l SCL_SCROLL_OFFSET_FONT(a0),a1	; A1 = Pointer to the font structure

	; Check if a copy is required (no copy if all the lines must be change)

	moveq #1,d2								; D2 = of lines being fully or partially used
	move.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	cmp.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	beq _vScrollNoCopy

	; ---------- Copy and shift the previous characters lines ----------

	; Setup the Blitter: simple copy of source A masked in DESC mode (required because shifting toward the bottom)

	WAIT_BLITTER
	move.w #$09F0,BLTCON0(a5)				; ASH3-0=0, USEA=1, USEB=0, USEC=0, USED=1, D=A
	move.w #$0002,BLTCON1(a5)				; DESC=1

	; Setup the Blitter: the masks

	; For BLTALWM (first word of a line in DESC mode), it requires (notice the subtle value for X & $000F = 0: the whole word is used):
	; X & $000F = 0	 => $FFFF
	; X & $000F  = 1	 => $7FFF
	; ...
	; X & $000F  = 15 => $0001
	; For  BLTAFWM (last word of a line in DESC mode), it requires (notice the subtle value for (X + DX - 1) & $000F = 15: the whole word is used):
	; (X + DX - 1) & $FFFF = 0  => $FFFF
	; (X + DX - 1) & $FFFF = 1  => $8000
	; ...
	; (X + DX - 1) & $FFFF = 15 => $FFFE

	move.w SCL_SCROLL_OFFSET_X(a0),d0
	and.w #$000F,d0
	moveq #-1,d1
	lsr.w d0,d1
	move.w d1,BLTALWM(a5)					; BLATLWM (first word of a line in DESC mode) = $FFFF >> (X & $000F)
	clr.w d0
	move.b SCL_FONT_OFFSET_CHARSIDEPIXELS(a1),d0
	add.w SCL_SCROLL_OFFSET_X(a0),d0
	subq.w #1,d0
	and.w #$000F,d0
	addq.b #1,d0
	moveq #-1,d1
	lsr.w d0,d1
	not.w d1
	move.w d1,BLTAFWM(a5)					; BLATFWM (last word of a line in DESC mode) = ~ ($FFFF >> (1 + (X - DX - 1) & $000F))

	;  COmpute the width of the scroll in fully or partially used words, including the masked ones (D2 must be equal to 1)

	move.w SCL_SCROLL_OFFSET_X(a0),d0
	and.w #$000F,d0
	clr.w d1
	move.b SCL_FONT_OFFSET_CHARSIDEPIXELS(a1),d1
	subi.w #16,d1
	add.w d0,d1
	ble _vScrollDrawWORDCountDone
	moveq #2,d2
	clr.w d0
	move.b SCL_FONT_OFFSET_CHARSIDEPIXELS(a1),d0
	add.w SCL_SCROLL_OFFSET_X(a0),d0
	subq.w #1,d0
	and.w #$000F,d0
	addq.w #1,d0
	sub.w d0,d1
	beq _vScrollDrawWORDCountDone
	lsr.w #4,d1
	add.w d1,d2								; D2 = # of fully or partially used words
_vScrollDrawWORDCountDone:	

	; Setup the Blitter: the pointers

	move.w SCL_SCROLL_OFFSET_Y(a0),d0
	add.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	sub.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	subq.w #1,d0
	move.w #DISPLAY_DX>>3,d1
	mulu d1,d0
	move.w SCL_SCROLL_OFFSET_X(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.w d1,d0
	add.w d2,d0
	add.w d2,d0
	subq.w #2,d0	
	movea.l sclFrontBuffer,a2
	lea (a2,d0.w),a2
	move.l a2,BLTAPTH(a5)

	move.w SCL_SCROLL_OFFSET_Y(a0),d0
	add.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	subq.w #1,d0
	move.w #DISPLAY_DX>>3,d1
	mulu d1,d0
	move.w SCL_SCROLL_OFFSET_X(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.w d1,d0
	add.w d2,d0
	add.w d2,d0
	subq.w #2,d0	
	movea.l sclBackBuffer,a2
	lea (a2,d0.w),a2
	move.l a2,BLTDPTH(a5)

	; Setup the Blitter: the modulos
	
	move.w #DISPLAY_DX>>3,d0
	sub.w d2,d0
	sub.w d2,d0
	move.w d0,BLTAMOD(a5)
	move.w d0,BLTDMOD(a5)

	;  COpy the scroll while shifting it toward the bottom

	clr.w d0
	move.w SCL_SCROLL_OFFSET_SIZE(a0),d0
	sub.w SCL_SCROLL_OFFSET_SPEED(a0),d0
	lsl.w #6,d0
	or.w d2,d0
	move.w d0,BLTSIZE(a5)
_vScrollNoCopy:

	; ---------- Draw the new characters columns ----------

	;  COmpute the pointer to the first line of the scroll where to draw a character column

	move.w SCL_SCROLL_OFFSET_Y(a0),d1
	add.w SCL_SCROLL_OFFSET_SPEED(a0),d1
	subq.w #1,d1
	mulu #DISPLAY_DX>>3,d1
	move.w SCL_SCROLL_OFFSET_X(a0),d0
	move.w d0,d2
	lsr.w #3,d2
	and.b #$FE,d2
	add.w d2,d1
	movea.l sclBackBuffer,a2
	lea (a2,d1.w),a2								; A2 = Pointer to the first line of the scroll where to draw a character column
	and.w #$000F,d0									; D0 = First pixel where to draw a character column

	; Loop for drawing the character(s) column(s)

	WAIT_BLITTER
	movea.l SCL_SCROLL_OFFSET_CHAR(a0),a3			; A3 = Pointer to the current character in the text
	movea.l SCL_SCROLL_OFFSET_CHARCOLUMN(a0),a4		; A4 = Pointer to the column to draw in the next character bitplane
	move.w SCL_SCROLL_OFFSET_SPEED(a0),d1			; D1 = # of columns to draw
	move.b SCL_SCROLL_OFFSET_CHARCOLUMNS(a0),d2		; D2 = # of columns of the current character bitplane that remains to be drawn - 1
_vScrollDrawColumn:

	; Move to the next character column (which may be the first column of the next character)

	subq.b #1,d2
	bge _vScrollDrawNoSourceColumnOverflow
	lea 1(a3),a3
	tst.b (a3)
	bne _vScrollDrawDoNotLoopText
	movea.l SCL_SCROLL_OFFSET_TEXT(a0),a3
_vScrollDrawDoNotLoopText:
	moveq #0,d3										; And not CLR.B because MOVE.L D3,D4 later, then D4 used as a LONG to compute an offset...
	move.b (a3),d3
	sub.b SCL_FONT_OFFSET_FIRSTASCII(a1),d3
	move.l d3,d4
	bne _vScrollDrawCharNotSpace
	move.b SCL_FONT_OFFSET_SPACEWIDTH(a1),d2
	subq.b #1,d2									; D2 = # of columns in the current character that still may be drawn - 1
	bra _vScrollDrawCharSpace
_vScrollDrawCharNotSpace:
	add.w d3,d3
	movea.l SCL_FONT_OFFSET_DATA(a1),a4
	move.b VFNT_CHAR_RIGHT(a4,d3.w),d2				; D2 = # of columns in the current character that stil may be drawn - 1
_vScrollDrawCharSpace:
	move.b SCL_FONT_OFFSET_CHARSIZE(a1),d3
	lsl.l d3,d4										; 16 x 16 => 5 or 32 x 32 => 7 or 64 x 64 => 9, so X * size = X << charSize (LSL.L because > 32768 if font is 64 x 64)
	movea.l SCL_FONT_OFFSET_BITPLANES(a1),a4
	add.l d4,a4										; A4 = Pointer to the column to draw, in the current character bitplane (ADD.L for the same reason)
_vScrollDrawNoSourceColumnOverflow:

	; Draw the character column

	move.b SCL_FONT_OFFSET_CHARSIDEPIXELS(a1),d3
	lsr.b #4,d3										; D3 = # of word in a column
	clr.w d4										; D4 = Bits of the previous character column to draw in the current word
	moveq #-1,d5
	lsl.w d0,d5
	not.w d5										; D5 = Mask for the bits of the current character column to draw in the next word
	movea.l a2,a6
_vScrollDrawColumnWORD:
	move.w (a4)+,d6
	move.w d6,d7
	lsr.w d0,d6
	or.w d4,d6
	move.w d6,(a6)+
	and.w d5,d7
	ror.w d0,d7
	move.w d7,d4
	subq.b #1,d3
	bne _vScrollDrawColumnWORD

	; Skip a line or draw the next one

	lea -DISPLAY_DX>>3(a2),a2

	subq.b #1,d1
	bne _vScrollDrawColumn

	; Remember the state of the scroll

	move.l a3,SCL_SCROLL_OFFSET_CHAR(a0)
	move.l a4,SCL_SCROLL_OFFSET_CHARCOLUMN(a0)
	move.b d2,SCL_SCROLL_OFFSET_CHARCOLUMNS(a0)

	movem.l (sp)+,d0-d7/a0-a4/a6
	rts	

_sclPartDone:
	ENDC

; *******************************************************************************
;  Interlude: Announcing part IV
; *******************************************************************************

	IFNE PART_MESSAGE_MESH

	lea msgPartMesh,a0
	jsr _message

	ENDC

; *******************************************************************************
;  Part IV: The World Wide Web
; *******************************************************************************

	IFNE PART_MESH

	; ---------------------------------------------------------------------------
	;  Setup
	; ---------------------------------------------------------------------------

	; ---------- Create the mesh ----------

	;  COmpute the points coordinates

	lea mshPoints,a0
	move.w #(DISPLAY_DY-MSH_DY*MSH_SIDEY)>>1,d3
	move.w #MSH_DY,d1
_mshAddPointsY:
	move.w #(DISPLAY_DX-MSH_DX*MSH_SIDEX)>>1,d2
	move.w #MSH_DX,d0
_mshAddPointsX:
	move.w d2,(a0)+
	addi.w #MSH_SIDEX,d2
	move.w d3,(a0)+
	dbf d0,_mshAddPointsX
	addi.w #MSH_SIDEY,d3
	dbf d1,_mshAddPointsY
	
	;  COmputes offsets of the lines

	lea mshLines,a0

	move.w #-(MSH_DX+1)*4,d2
	move.w #MSH_DY,d1
_mshAddHLinesY:
	addi.w #(MSH_DX+1)*4,d2
	move.w d2,d3
	move.w #MSH_DX-1,d0
_mshAddHLinesX:
	move.w d3,(a0)+
	addq.w #4,d3
	move.w d3,(a0)+
	dbf d0,_mshAddHLinesX
	dbf d1,_mshAddHLinesY

	moveq #-4,d2
	move.w #MSH_DX,d1
_mshAddVLinesY:
	addq.w #4,d2
	move.w d2,d3
	move.w #MSH_DY-1,d0
_mshAddVLinesX:
	move.w d3,(a0)+
	addi.w #(MSH_DX+1)*4,d3
	move.w d3,(a0)+
	dbf d0,_mshAddVLinesX
	dbf d1,_mshAddVLinesY

	; ---------- Main loop ----------

	; Setup the mesh animation

	move.w #-1,mshAccumulator0
	move.w #MSH_STRENGTH_START,mshStrengthMin
	move.w #MSH_STRENGTH_END,mshStrengthMax
	move.w #MSH_STRENGTH_STEPS,mshStrengthSteps
	move.w #MSH_STRENGTH_START,mshStrength
	move.w #MSH_RADIUS+(DISPLAY_DX>>1),mshAttractorX
	move.w #DISPLAY_DY>>1,mshAttractorY
	move.w #0,mshAngle

	; Setup the printer

	lea prtSetupData,a0
	movea.l bitplanes1,a1
	lea MSH_PRINTER_Y*(DISPLAY_DX>>3)(a1),a1
	move.l a1,OFFSET_PRINTERSETUP_BITPLANE(a0)
	move.w #DISPLAY_DX>>3,OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0)
	move.w #0,OFFSET_PRINTERSETUP_BITPLANEMODULO(a0)
	move.w #MSH_PRINTER_DY,OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a0)
	move.b #MSH_PRINTER_CHARDELAY,OFFSET_PRINTERSETUP_CHARDELAY(a0)
	move.w #MSH_PRINTER_PAGEDELAY,OFFSET_PRINTERSETUP_PAGEDELAY(a0)
	move.l #font,OFFSET_PRINTERSETUP_FONT(a0)
	move.l #mshText,OFFSET_PRINTERSETUP_TEXT(a0)
	jsr _prtSetup

	;  COpy the logo

	move.w #$03AA,BLTCON0(a5)	; USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTCMOD(a5)
	move.w #(DISPLAY_DX-LOGO_DX)>>3,BLTDMOD(a5)
	move.l #logo,BLTCPTH(a5)
	movea.l bitplanes1,a0
	lea LOGO_Y*(DISPLAY_DX>>3)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #(LOGO_DY<<6)!(LOGO_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Setup the front and back buffers

	movea.l bitplanes2,a0
	move.l a0,mshFrontBuffer
	lea DISPLAY_DY*(DISPLAY_DX>>3)(a0),a0
	move.l a0,mshBackBuffer

	; Setup the state

	move.w #MSH_STATE_DRAWING!MSH_STATE_PRINTING,partState
	move.w #MSH_PART_DURATION,mshTimer
	move.l #mshLinePatterns,mshLinePattern

	; Fade to palette

	lea whitePalette,a0
	lea mshPalette,a1
	jsr _fade

	; Setup the fader

	lea fadeSetupData,a0
	move.l #mshPalette,OFFSET_FADESETUP_PALETTESTART(a0)
	move.l #blackPalette,OFFSET_FADESETUP_PALETTEEND(a0)
	move.w #16,OFFSET_FADESETUP_NBCOLORS(a0)
	move.w #MSH_FADE_NBSTEPS,OFFSET_FADESETUP_NBSTEPS(a0)
	movea.l copperList,a1
	lea 10*4+DISPLAY_DEPTH*2*4(a1),a1
	move.l a1,OFFSET_FADESETUP_COPPERLIST(a0)
	jsr _fadeSetup

	; ---------------------------------------------------------------------------
	;  Main loop
	; ---------------------------------------------------------------------------

_mshLoop:

	; Wait for the raster to reach the bottom of the displayed area

	IFNE DEBUG
	movea.l bitplanes1,a0
	lea (DISPLAY_DY-8)*(DISPLAY_DX>>3)(a0),a0
	jsr _showTime
	moveq #1,d0
	jsr _wait
	ELSE
	WAIT_ENDOFFRAME
	ENDC

	; Roll the bitplanes after the one where the mesh is drawn, which is swapped

	movea.l copperList,a0
	lea 10*4+(DISPLAY_DEPTH-1)*2*4+2(a0),a0
	move.w (a0),d1
	swap d1
	move.w 4(a0),d1

	moveq #1,d0
	blt _mshRollBitplanesDone
_mshRollBitplanes:
	move.w -8(a0),(a0)
	move.w -4(a0),4(a0)
	lea -8(a0),a0
	dbf d0,_mshRollBitplanes
_mshRollBitplanesDone:

	move.l mshBackBuffer,d0
	move.w d0,4(a0)
	swap d0
	move.w d0,(a0)
	move.l d1,mshBackBuffer

	; ########## Printer (MSH_STATE_PRINTING) (start) ##########

	move.w partState,d0
	and.w #MSH_STATE_PRINTING,d0
	beq _mshStateNotPrinting

	; Printer

	jsr _prtStep
_mshStateNotPrinting:

	; ########## Printer (MSH_STATE_PRINTING) (end) ##########

	; ########## Mesh drawing (MSH_STATE_DRAWING) (start) ##########

	move.w partState,d0
	and.w #MSH_STATE_DRAWING,d0
	beq _mshStateNotMeshDrawing

	; Clear the back buffer

	move.w #0,BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=0
	move.w #$0000,BLTCON1(a5)
	move.l mshBackBuffer,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; ---------- Transform all the points but the ones on the borders ----------

	lea mshPoints,a0
	lea mshTPoints,a1
	move.w mshAttractorX,d0
	move.w mshAttractorY,d1

	; Points on the first line are not transformed

; *	move.w #MSH_DX,d2
; *_mshTranslateFirstRow:
; *	move.l (a0)+,(a1)+
; *	dbf d2,_mshTranslateFirstRow

	; Points from the 2nd to the before last line (the 1st and the last points on a line are not transformed)

; *	move.w #MSH_DY-2,d2
	move.w #MSH_DY,d2
_mshTranslateRow:
; *	move.l (a0)+,(a1)+
; *	move.w #MSH_DX-2,d3
	move.w #MSH_DX,d3
_mshTranslateColumn:

	; Retrieve the coordinates

	move.w (a0)+,d4
	move.w (a0)+,d5
	sub.w d0,d4
	sub.w d1,d5

	;  COmpute a rough value for d = max (|dx|, |dy|) + (min (|dx|, |dy|) >> 2) + (min (|dx|, |dy|) >> 3)
; AFAIRE : virer le dernier terme ?
	move.w d4,d6
	bge _mshDistanceDXPositive
	neg.w d6
_mshDistanceDXPositive:
	move.w d5,d7
	bge _mshDistanceDYPositive
	neg.w d7
_mshDistanceDYPositive:
	cmp.w d6,d7
	blt _mshDistanceDYGreater
	lsr.w #2,d6
	add.w d6,d7
	lsr.w #1,d6
	add.w d7,d6
	bra _mshDistanceDXGreater
_mshDistanceDYGreater:
	lsr.w #2,d7
	add.w d7,d6
	lsr.w #1,d7
	add.w d7,d6
_mshDistanceDXGreater:

	; Transform the coordinates by applying a factor of d/k, then center them
; attention à l'overflow... on présume ici que le résultat de la multiplication tient sur 16 bits
; donc là je mets un divs car j'anime la force, mais il est possible de mettre un asr.l #7 si on veut l'éviter et ne pas animer la force
	move.w mshStrength,d7
	muls d6,d4
	divs d7,d4
	add.w d0,d4
	muls d6,d5
	divs d7,d5
	add.w d1,d5

	; Store the new coordinates

	move.w d4,(a1)+
	move.w d5,(a1)+
	dbf d3,_mshTranslateColumn
; *	move.l (a0)+,(a1)+
	dbf d2,_mshTranslateRow

	; The points on the last line are not transformed

; *	move.w #MSH_DX,d2
; *_mshTranslateLastRow:
; *	move.l (a0)+,(a1)+
; *	dbf d2,_mshTranslateLastRow

	; ---------- Clip the mesh and draw the result ----------

	move.w #$8000,BLTADAT(a5)
	movea.l mshLinePattern,a0
	move.w (a0),BLTBDAT(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)
	move.w #DISPLAY_DX>>3,BLTCMOD(a5)
	move.w #DISPLAY_DX>>3,BLTDMOD(a5)
	movea.l mshBackBuffer,a0
	lea mshTPoints,a1
	lea mshLines,a2
	move.w #MSH_DX*(MSH_DY+1)+(MSH_DX+1)*MSH_DY-1,d7
_mshDrawLines:

	; Retrieve the coordinates for the points of the edge

	move.w (a2)+,d4
	move.w (a1,d4.w),d0
	move.w 2(a1,d4.w),d1
	move.w (a2)+,d4
	move.w (a1,d4.w),d2
	move.w 2(a1,d4.w),d3

	; 1/ Clip on the Y axis
	
	; Adjust the x coordinate of the points so that it is positive

	move.w d0,d6
	cmp.w d0,d2
	ble _mshClipGotMinX
	move.w d2,d6
_mshClipGotMinX:
	tst.w d6
	bge _mshClipDoNotOffsetX
	sub.w d6,d0
	sub.w d6,d2
_mshClipDoNotOffsetX:

	; Sort the points vertically: A (D0, D1) must be below B (D2, D3)

	cmp.w d1,d3
	ble _mshClipYDoNotInvert
	exg d1,d3
	exg d0,d2
_mshClipYDoNotInvert:

	; Test if the edge is beyond the vertical limits (D1 < 0 or D3 > DISPLAY_DY-1)

	cmpi.w #DISPLAY_DY-1,d3
	bgt _mshClipNotVisible
	tst.w d1
	blt _mshClipNotVisible

	; Clip vertically: fist B, then A (this way, we will learn that D1 and D3 > 0)

	tst.w d3
	bge _mshClipYbDone
	move.w d3,d4	; d4=Yb
	sub.w d1,d3		; d3=Yb-Ya
	move.w d2,d5	; d5=Xb
	sub.w d0,d5		; d5=Xb-Xa
	muls d4,d5		; d5=Yb*(Xb-Xa)
	divs d3,d5		; d5=[Yb*(Xb-Xa)]/(Yb-Ya)
	sub.w d5,d2		; d2=Xb-[Yb*(Xb-Xa)]/(Yb-Ya)
	clr.w d3
_mshClipYbDone:

	cmpi.w #DISPLAY_DY-1,d1
	ble _mshClipYaDone
	sub.w d3,d1				; d1=Ya-Yb
	move.w #DISPLAY_DY,d4	; d4=DISPLAY_DY
	sub.w d3,d4				; d4=DISPLAY_DY-Yb
	sub.w d2,d0				; d0=Xa-Xb
	muls d0,d4				; d4=(Xa-Xb)*(DISPLAY_DY-Yb)
	divs d1,d4				; d4=[(Xa-Xb)*(DISPLAY_DY-Yb)]/(Ya-Yb)
	move.w d2,d0			; d0=Xb
	add.w d4,d0				; d0=Xb+[(Xa-Xb)*(DISPLAY_DY-Yb)]/(Ya-Yb)
	move.w #DISPLAY_DY-1,d1
_mshClipYaDone:

	; Restore the x coordinates of the points if they have been adjusted to be positive

	tst.w d6
	bge _mshClipNoOffsetXRequired
	add.w d6,d0
	add.w d6,d2
_mshClipNoOffsetXRequired:

	; 2/ Clip horizontally

	; Sort the points horizontally: A (D0, D1) must be to the left of B (D2, D3)

	cmp.w d2,d0
	ble _mshClipXDoNotInvert
	exg d0,d2
	exg d1,d3
_mshClipXDoNotInvert:

	; Test if the edge is beyond the horizontal limits (D0 > DISPLAY_DX-1 or D2 < 0)

	cmpi.w #DISPLAY_DX-1,d0
	bgt _mshClipNotVisible
	tst.w d2
	blt _mshClipNotVisible

	; Clip horizontally: first A, then B (this way, we will learn that D0 and D2 > 0)

	tst.w d0
	bge _mshClipXaDone
	move.w d0,d4	; d4=Xa
	sub.w d2,d0		; d0=Xa-Xb
	move.w d1,d5	; d5=Ya
	sub.w d3,d5		; d5=Ya-Yb
	muls d4,d5		; d5=Xa*(Ya-Yb)
	divs d0,d5		; d5=[Xa*(Ya-Yb)]/(Xa-Xb)
	sub.w d5,d1		; d1=Ya-[Xa*(Ya-Yb)]/(Xa-Xb)
	clr.w d0
_mshClipXaDone:

	cmpi.w #DISPLAY_DX-1,d2
	ble _mshClipXbDone
	move.w #DISPLAY_DX,d4	; d4=DISPLAY_DX
	sub.w d0,d4				; d4=DISPLAY_DX-Xa
	sub.w d0,d2				; d2=Xb-Xa
	sub.w d1,d3				; d3=Yb-Ya
	muls d3,d4				; d4=(Yb-Ya)*(DISPLAY_DX-Xa)
	divs d2,d4				; d4=[(Yb-Ya)*(DISPLAY_DX-Xa)]/(Xb-Xa)
	move.w d1,d3			; d3=Ya
	add.w d4,d3				; d3=Ya+[(Yb-Ya)*(DISPLAY_DX-Xa)]/(Xb-Xa)
	move.w #DISPLAY_DX-1,d2
_mshClipXbDone:

	; Draw the clipped edge

	move.w #DISPLAY_DX>>3,d4
	jsr _drawLine
_mshClipNotVisible:
	dbf d7,_mshDrawLines	

	; ---------- Animate the magnet ----------

	; Animate the angle of the magnet

	move.w mshAngle,d0
	subq.w #MSH_SPEED<<1,d0
	bge _mshAngleNoUnderflow
	addi.w #360<<1,d0
_mshAngleNoUnderflow:
	move.w d0,mshAngle

	; Animate the strength of the magnet

	move.w mshStrengthMin,d0
	move.w mshStrengthMax,d1
	move.w #MSH_STRENGTH_STEPS-1,d2
	move.w mshAccumulator0,d3
	move.w mshStrength,d4
	jsr _interpolate
	move.w d4,mshStrength
	move.w d3,mshAccumulator0

	move.w mshStrengthSteps,d0
	subq.w #1,d0
	bne _mshStrengthNotDone
	move.w #MSH_STRENGTH_STEPS,d0
	move.w mshStrengthMin,d1
	move.w mshStrengthMax,d2
	move.w d2,mshStrengthMin
	move.w d1,mshStrengthMax
_mshStrengthNotDone:
	move.w d0,mshStrengthSteps	

	; Move the magnet

	move.w mshAngle,d1
	lea cosinus,a0
	move.w (a0,d1.w),d0
	muls #MSH_RADIUS,d0
	swap d0
	rol.l #2,d0
	addi.w #DISPLAY_DX>>1,d0
	move.w d0,mshAttractorX
	lea sinus,a0
	move.w (a0,d1.w),d0
	muls #MSH_RADIUS,d0
	swap d0
	rol.l #2,d0
	neg.w d0
	addi.w #DISPLAY_DY>>1,d0
	move.w d0,mshAttractorY

	; ---------- Test part exit condition: duration has expired ----------

	move.w partState,d0
	and.w #MSH_STATE_ERASING,d0
	bne _mshTheShowMustGoOn
	move.w mshTimer,d1
	beq _mshTheShowMustEnd
	subq.w #1,d1
	move.w d1,mshTimer
	bra _mshTheShowMustGoOn
_mshTheShowMustEnd:
	or.w #MSH_STATE_ERASING,partState
	move.w #1,mshTimer
_mshTheShowMustGoOn:

_mshStateNotMeshDrawing:

	; ########## Mesh drawing (MSH_STATE_DRAWING) (end) ##########

	; ########## Mesh erasing (MSH_STATE_ERASING) (start) ##########

	move.w partState,d0
	and.w #MSH_STATE_ERASING,d0
	beq _mshStateNotErasing

	; Check if timer has expired

	move.w mshTimer,d0
	subq.w #1,d0
	bne _mshTimerNotExpired

	; Erase one bit in the line pattern using an animation, and start fading if it is reduced to 0

	move.w #MSH_ERASING_DELAY,d0
	movea.l mshLinePattern,a0
	lea 2(a0),a0
	tst.w (a0)
	bne _mshNextPatternNotEmpty
	and.w #~MSH_STATE_ERASING,partState
	or.w #MSH_STATE_FADING,partState
	bra _mshStateNotErasing
_mshNextPatternNotEmpty:
	move.l a0,mshLinePattern

	; Update timer

_mshTimerNotExpired:
	move.w d0,mshTimer

_mshStateNotErasing:

	; ########## Mesh erasing (MSH_STATE_ERASING) (end) ##########

	; ########## Fader (MSH_STATE_FADING) (start) ##########

	move.w partState,d0
	and.w #MSH_STATE_FADING,d0
	beq _mshStateNotFading

	; Run the fader

	jsr _fadeStep
	tst.w d0
	bne _mshEnd

_mshStateNotFading:

	; ########## Fader (MSH_STATE_FADING) (end) ##########

	; Start exit sequence if the left mouse button has been pressed and exit sequence has not already started

	move.w partState,d0
	and.w #MSH_STATE_ERASING,d0
	bne _mshNoQuickExit
	btst #6,$BFE001
	bne _mshNoQuickExit
	or.w #MSH_STATE_ERASING,partState
	move.w #1,mshTimer
_mshNoQuickExit:

	bra _mshLoop

	; ---------------------------------------------------------------------------
	;  Ending
	; ---------------------------------------------------------------------------

_mshEnd:

	; End the fader

	jsr _fadeEnd

	; End the printer

	jsr _prtEnd

	; Wait for the left mouse button to be released

_mshMouseButtonNotReleased:
	btst #6,$BFE001
	beq _mshMouseButtonNotReleased

	bra _mshPartDone

	; ---------------------------------------------------------------------------
	;  Routines
	; ---------------------------------------------------------------------------

; ---------- Line drawing ----------

; Input(s) :
; 	A0 = Pointer to the bitplane
; 	D0 = x0
; 	D1 = y0
; 	D2 = x1
; 	D3 = y1
; 	D4 = Width of the bitplane in bytes
; 	Moreover, those registers must have been initialized: 
; 	- BLTCMOD = Width of the bitplane in bytes
; 	- BLTDMOD = Same thing
; 	- BLTAFWM = $FFFF
; 	- BLTALWM = $FFFF
; 	- BLTADAT = $8000
; 	- BLTBDAT = $FFFF (or any pattern)
; Notice:
; 	The Blitter has not finished when rts

_drawLine:
; 	movem.l d0-d5/a6,-(sp)

	; Sort the points

	cmp.w d1,d3
	bge _drawLineUpDown
	exg d0,d2
	exg d1,d3
_drawLineUpDown:

	;  COmpute the pointer for the start of the line

	move.w d1,d5
	mulu d4,d5		; d5=y1*# of bytes per line
	add.l a0,d5		; +start pointer of the bitplane

	moveq #0,d4
	move.w d0,d4
	lsr.w #3,d4
	and.b #$FE,d4
	add.l d4,d5		; +x1/8

	; Look for the octant

	moveq #0,d4
	sub.w d1,d3		; d3=Dy=y2-y1
	bpl.b _drawLineDYPositive
	or.b #1<<2,d4
	neg.w d3
_drawLineDYPositive:	
	sub.w d0,d2		; d2=Dx=x2-x1
	bpl.b _drawLineDXPositive
	or.b #1<<1,d4
	neg.w d2
_drawLineDXPositive:
	cmp.w d3,d2	; Dx-Dy
	bpl.b _drawLineDXDYPositive
	or.b #1<<0,d4
	exg d3,d2		; this way d3=Pdelta and d2=Gdelta
_drawLineDXDYPositive:
	add.w d3,d3	; d3=2*Pdelta

	; BLTCON0

	and.w #$000F,d0
	ror.w #4,d0
	or.w #%0000111111001010,d0	; USEA=1, USEC=1, USED=1, D=AB+aC=ABC+ABc+abC+aBC

	; BLTCON1

	lea octants,a6
	move.b (a6,d4.w),d4
	lsl.w #2,d4
	or.b #1<<0,d4

	; BLTBMOD, BLTAPTL, BLTAMOD

	WAIT_BLITTER
	move.w d3,BLTBMOD(a5)
	sub.w d2,d3
	bge.s _drawLineNoBit
	or.b #1<<6,d4
_drawLineNoBit:
	move.w d3,BLTAPTL(a5)
	sub.w d2,d3
	move.w d3,BLTAMOD(a5)

	; BLTSIZE

	lsl.w #6,d2
	add.w #$42,d2

	; Draw the line

	move.w d4,BLTCON1(a5)
	move.w d0,BLTCON0(a5)
	move.l d5,BLTCPTH(a5)
	move.l d5,BLTDPTH(a5)
	move.w d2,BLTSIZE(a5)
_drawLineEnd:

; 	movem.l (sp)+,d0-d5/a6
	rts

_mshPartDone:
	ENDC

; *******************************************************************************
;  Interlude: Announcing end
; *******************************************************************************

	IFNE PART_MESSAGE_END

	lea msgPartEnd,a0
	jsr _message

	ENDC

; *******************************************************************************
;  Finalizations
; *******************************************************************************

_end:
	
	; End the tune

	IFNE TUNE
; 	lea mt_Enable(pc),a0
	movea.l #mt_Enable,a0
	sf (a0)
	lea $DFF000,a6
	jsr mt_end
	ENDC

	; Wait for the Blitter (bitplane clearing may be in progress)

	WAIT_BLITTER

	; Shut down the hardware interrupts and the DMAs

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

	; Restore the level 6 interrupt vector

	IFNE TUNE
	movea.l VBRPointer,a0
	move.l vector30,$78(a0)
	ENDC

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

	; Restore the Copperlist

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)		; OpenLibrary ()
	move.l d0,graphicsBase

	movea.l d0,a0
	move.l 38(a0),COP1LCH(a5)
	clr.w COPJMP1(a5)

	; StingRay's stuff

	movea.l view,a1
	move.l graphicsBase,a6
	jsr -222(a6)		; LoadView ()
	jsr -462(a6)		; DisownBlitter ()
	move.l graphicsBase,a1
	movea.l $4,a6
	jsr -414(a6)		; CloseLibrary ()

	; Restore the system

	jsr -138(a6)		; Permit ()

	; Free allocated memory

	movea.l copperList,a1
	move.l #COPSIZE,d0
	jsr -210(a6)		; FreeMem ()

	movea.l bitplanes1,a1
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	jsr -210(a6)		; FreeMem ()

	movea.l bitplanes2,a1
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	jsr -210(a6)		; FreeMem ()

	movea.l bitplanes3,a1
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	jsr -210(a6)		; FreeMem ()

	movea.l bitplanes4,a1
	move.l #2*DISPLAY_DY*(DISPLAY_DX>>3),d0
	jsr -210(a6)		; FreeMem ()

	; Unstack registers

	movem.l (sp)+,d0-d7/a0-a6
	rts

; *******************************************************************************
;  Routines for two or more parts
; *******************************************************************************

	INCLUDE "desireONE/common/registers.s"
	INCLUDE "desireONE/common/wait.s"
	IFNE DEBUG
	INCLUDE "desireONE/common/debug.s"
	ENDC
	INCLUDE "desireONE/common/fade.s"
	INCLUDE "desireONE/common/cutter.s"
	INCLUDE "desireONE/common/advancedPrinter.s"
	IFNE TUNE
	INCLUDE "desireONE/common/ptplayer/ptplayer_FINAL.s"
	ENDC

; ---------- Message ----------

; Input(s):
; 	A0 = Message to print
; Output(s):
; 	None
; Notice:
; 	We don't use WAIT_ENDOFFRAME here, because the code in the loop may get executed so fast that it would be executed more than once in a frame. We use _wait instead.

	IFNE PART_MESSAGE_SIGNAL!PART_MESSAGE_SCROLLS!PART_MESSAGE_MESH

_message:

	movem.l d0-d1/a0-a2,-(sp)

	; ---------- Setup ----------

	; Setup the printer

	lea prtSetupData,a1
	move.l a0,OFFSET_PRINTERSETUP_TEXT(a1)
	move.l bitplanes1,a0
	lea MSG_PRINTER_Y*(DISPLAY_DX>>3)+(MSG_PRINTER_X>>3)(a0),a0
	move.l a0,OFFSET_PRINTERSETUP_BITPLANE(a1)
	move.w #DISPLAY_DX>>3,OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1)
	move.w #0,OFFSET_PRINTERSETUP_BITPLANEMODULO(a1)
	move.w #MSG_PRINTER_DY,OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a1)
	move.b #MSG_PRINTER_CHARDELAY,OFFSET_PRINTERSETUP_CHARDELAY(a1)
	move.w #MSG_PRINTER_PAGEDELAY,OFFSET_PRINTERSETUP_PAGEDELAY(a1)
	move.l #font,OFFSET_PRINTERSETUP_FONT(a1)
	movea.l a1,a0
	jsr _prtSetup

	; Setup the cutter

	lea cutSetupData,a0
	movea.l bitplanes2,a1
	lea MSG_CUTTER_Y*(DISPLAY_DX>>3)+(MSG_CUTTER_X>>3)(a1),a1
	move.l a1,OFFSET_CUTTERSETUP_BITPLANE(a0)
	move.w #MSG_CUTTER_DX,OFFSET_CUTTERSETUP_BITPLANEWIDTH(a0)
	move.w #MSG_CUTTER_DY,OFFSET_CUTTERSETUP_BITPLANEHEIGHT(a0)
	move.w #(DISPLAY_DX-MSG_CUTTER_DX)>>3,OFFSET_CUTTERSETUP_BITPLANEMODULO(a0)
	movea.l msgCutterPattern,a1
	move.l a1,OFFSET_CUTTERSETUP_PATTERN(a0)
	lea (MSG_CUTTER_DY>>4)*(MSG_CUTTER_DX>>4)(a1),a1
	move.l a1,msgCutterPattern
	move.b #MSG_CUTTER_SQUARESDELAY,OFFSET_CUTTERSETUP_SQUAREDELAY(a0)
	move.b #MSG_CUTTER_FINALDELAY,OFFSET_CUTTERSETUP_FINALDELAY(a0)
	move.w #MSG_CUTTER_DURATION,OFFSET_CUTTERSETUP_DURATION(a0)
	jsr _cutSetup

	; Restore the front buffer default bitplanes in the Copperlist

	movea.l copperList,a0
	lea 10*4+2(a0),a0

	move.l bitplanes1,d1
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)
	lea 8(a0),a0

	move.l bitplanes2,d1
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)
	lea 8(a0),a0

	move.l bitplanes3,d1
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)
	lea 8(a0),a0

	move.l bitplanes4,d1
	move.w d1,4(a0)
	swap d1
	move.w d1,(a0)
	lea 8(a0),a0

	; Clear all the bitplanes

	WAIT_BLITTER
	move.w #0,BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=0
	move.w #$0000,BLTCON1(a5)
	move.l bitplanes1,BLTDPTH(a5)
	move.w #((2*DISPLAY_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	move.l bitplanes2,BLTDPTH(a5)
	move.w #((2*DISPLAY_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	move.l bitplanes3,BLTDPTH(a5)
	move.w #((2*DISPLAY_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	move.l bitplanes4,BLTDPTH(a5)
	move.w #((2*DISPLAY_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Fade to palette

	lea blackPalette,a0
	lea palette,a1
	jsr _fade

	; ---------- Print the text ---------- 

_msgPrint:

	; Wait for the raster to reach the bottom of the displayed area

	IFNE DEBUG
	movea.l bitplanes1,a0
	lea (DISPLAY_DY-8)*(DISPLAY_DX>>3)(a0),a0
	jsr _showTime
	ENDC
	moveq #1,d0
	jsr _wait

	; Run the cutter

	jsr _cutStep

	; Run the printerF

	jsr _prtStep
	tst.w d0
	bne _msgPrint

	; ---------- Wait some time for the user to read the text ---------- 

_msgWait:

	; Wait for the raster to reach the bottom of the displayed area

	IFNE DEBUG
	movea.l bitplanes1,a0
	lea (DISPLAY_DY-8)*(DISPLAY_DX>>3)(a0),a0
	jsr _showTime
	ENDC
	moveq #1,d0
	jsr _wait

	; Run the cutter

	jsr _cutStep
	tst.w d0
	beq _msgWait

	; ---------- Fade to white ---------- 

	; Setup the fader

	lea fadeSetupData,a0
	move.l #palette,OFFSET_FADESETUP_PALETTESTART(a0)
	move.l #whitePalette,OFFSET_FADESETUP_PALETTEEND(a0)
	move.w #16,OFFSET_FADESETUP_NBCOLORS(a0)
	move.w #FADE_NBSTEPS,OFFSET_FADESETUP_NBSTEPS(a0)
	movea.l copperList,a1
	lea 10*4+DISPLAY_DEPTH*2*4(a1),a1
	move.l a1,OFFSET_FADESETUP_COPPERLIST(a0)
	jsr _fadeSetup

	; Fade to white while running the cutter

_msgFade:

	; Wait for the raster to reach the bottom of the displayed area

	IFNE DEBUG
	movea.l bitplanes1,a0
	lea (DISPLAY_DY-8)*(DISPLAY_DX>>3)(a0),a0
	jsr _showTime
	ENDC
	moveq #1,d0
	jsr _wait

	; Run the fader

	jsr _fadeStep
	tst.w d0
	beq _msgFade

	; ---------- End ----------

	; End the printer

	jsr _prtEnd

	; End the cutter

	jsr _cutEnd

	; End the fader

	jsr _fadeEnd

	; Clear the bitplanes

	WAIT_ENDOFFRAME
	move.w #0,BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=0
	move.w #$0000,BLTCON1(a5)
	move.l bitplanes1,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER
	move.l bitplanes2,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	movem.l (sp)+,d0-d1/a0-a2
	rts

	ENDC

; ---------- Fader ----------

; Input(s) :
; 	A0 = Start palette
; 	A1 = End palette
; Output(s) :
; 	None

FADE_WAIT=1		; Must be >= 1
FADE_NBSTEPS=20

_fade:
	movem.l d0/a0/a2,-(sp)

	; Setup the fader

	lea fadeSetupData,a2
	move.l a0,OFFSET_FADESETUP_PALETTESTART(a2)
	move.l a1,OFFSET_FADESETUP_PALETTEEND(a2)
	move.w #16,OFFSET_FADESETUP_NBCOLORS(a2)
	move.w #FADE_NBSTEPS,OFFSET_FADESETUP_NBSTEPS(a2)
	movea.l copperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4(a0),a0
	move.l a0,OFFSET_FADESETUP_COPPERLIST(a2)
	movea.l a2,a0
	jsr _fadeSetup

	; Fade to the palette

_sgnFadeToPalette:
	moveq #FADE_WAIT,d0
	jsr _wait
	jsr _fadeStep
	tst.w d0
	beq _sgnFadeToPalette

	; End the fader

	jsr _fadeEnd

	movem.l (sp)+,d0/a0/a2
	rts

; ---------- Linear interpolator ----------

; Input(s) :
; 	D0 = Start value
; 	D1 = End value (may be equal to the start value)
; 	D2 = # of steps (the are at least two steps V = Vi and V = Vf, so the minimum value for D2 is 1)
; 	D3 = Accumulator (-1 for initializing)
; 	D4 = Value at the current step
; Output(s) :
; 	D3 = New value for the accumulator
; 	D4 = Value for the next step
; Notice:
; 	How to use the interpolator:
; 
; 	move.w #VALUE_START,d0
; 	move.w #VALUE_END,d1
; 	move.w #NB_STEPS-1,d2	; At least NB_STEPS = 2  : V = Vi and V = Vf, even if Vi == Vf
; 	moveq #-1,d3
; 	move.w d0,d4
; 
; 	This is the DBF version (the objective is to avoid useless loops):
; 
; 	move.w #NB_STEPS-2,d5
; 	or.w d4,d4				; Usage of D4 (example)
; _interpolation:
; 	jsr _interpolate
; 	or.w d4,d4				; Usage of D4 (example)
; 	dbf d5,_interpolation
; 
; 	Ou version BNE (même objectif) :
; 
; 	move.w #NB_STEPS,d5
; _interpolation:
; 	or.w d4,d4				; Usage of D4 (example)
; 	subq.w #1,d5
; 	beq _interpolateEnd
; 	jsr _interpolate
; 	bra _interpolation
; _interpolateEnd:
; 
; 	The interpolator may be called too many times, because it does nothing if Vf == Vi.

_interpolate:
	cmp.w d1,d4
	bne _interpolateNotDone
	rts
_interpolateNotDone:
	movem.l d2/d5/d6,-(sp)

	move.w d1,d5
	sub.w d0,d5
	bgt _interpolateDVPositive
	neg.w d5
	moveq #-1,d6
	bra _interpolateDVNegative
_interpolateDVPositive:
	moveq #1,d6
_interpolateDVNegative:
	addq.w #1,d5		; D5 = |end value - start value| + 1
	cmp.w d5,d2
	bge _interpolateNbStepsGreater

	; (|final value - start value| + 1) > # steps

	; In this case, it is a question of drawing a straight line in a pixel frame, where the abscissa axis is that of the steps whose
	; number is reduced by 1, and the ordinate axis is that of the values. The accumulator is always one pixel ahead of the line to
	; exit the routine when it is known that the next pixel changes its abscissa. This ensures that the routine is exited at the end
	; of the pixel segment with the same abscissa.
	
	subq.w #1,d2
	tst.w d3
	bge _interpolateAccumulatorAlreadyInitialized0
	clr.w d3
	move.w d0,d4
	sub.w d6,d4
_interpolateAccumulatorAlreadyInitialized0:
	add.w d6,d4
	add.w d2,d3
	cmp.w d5,d3
	blt _interpolateAccumulatorNoOverflow0
	sub.w d5,d3
	movem.l (sp)+,d2/d5/d6
	rts
_interpolateAccumulatorNoOverflow0:
	bra _interpolateAccumulatorAlreadyInitialized0

	; (|end value - start value| + 1) <= # steps

	; In this case, it is a matter of drawing a straight line in a pixel frame with the x-axis being the values and the y-axis being
	; the steps. Things are simpler, because you don't have to wait until you're at the end of the line to leave the routine.
		
_interpolateNbStepsGreater:
	tst.w d3
	bge _interpolateAccumulatorAlreadyInitialized1
	clr.w d3
	move.w d0,d4
_interpolateAccumulatorAlreadyInitialized1:
	add.w d5,d3
	cmp.w d2,d3
	blt _interpolateNoAccumulatorOverflow1
	sub.w d2,d3
	add.w d6,d4
_interpolateNoAccumulatorOverflow1:
	movem.l (sp)+,d2/d5/d6
	rts

; *******************************************************************************
;  Data in either Chip or Fast memory
; *******************************************************************************

	SECTION data,DATA

; ---------- Common ----------

vector30:			DC.L 0
VBRPointer:			DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
graphicsBase:		DC.L 0
view:				DC.L 0
copperList:			DC.L 0
bitplanes1:			DC.L 0
bitplanes2:			DC.L 0
bitplanes3:			DC.L 0
bitplanes4:			DC.L 0
partState:			DC.W 0	
whitePalette:		BLK.W 16,$0FFF
blackPalette:		BLK.W 16,$0000
palette:
					DC.W $0000	; COLOR00
					DC.W $0FFF	; COLOR01
					DC.W $0008	; COLOR02
					DC.W $0FFF	; COLOR03
					DC.W $0004	; COLOR04
					DC.W $0FFF	; COLOR05
					DC.W $0008	; COLOR06
					DC.W $0FFF	; COLOR07
					DC.W $0000	; COLOR08
					DC.W $0000	; COLOR09
					DC.W $0000	; COLOR10
					DC.W $0000	; COLOR11
					DC.W $0000	; COLOR12
					DC.W $0000	; COLOR13
					DC.W $0000	; COLOR14
					DC.W $0000	; COLOR15
sinus:				DC.W 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286
cosinus:			DC.W 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286, 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382
font:
	INCBIN "desireONE/data/fontBevelled8x8x1.raw"
	EVEN

;---------- Signal ----------

	IFNE PART_SIGNAL

sgnPalette:
					DC.W $0000	; COLOR00
					DC.W $0FFF	; COLOR01
					DC.W $000F	; COLOR02
					DC.W $0FFF	; COLOR03
					DC.W $0008	; COLOR04
					DC.W $0FFF	; COLOR05
					DC.W $000F	; COLOR06
					DC.W $0FFF	; COLOR07
					DC.W $0004	; COLOR08
					DC.W $0FFF	; COLOR09
					DC.W $000F	; COLOR10
					DC.W $0FFF	; COLOR11
					DC.W $0008	; COLOR12
					DC.W $0FFF	; COLOR13
					DC.W $000F	; COLOR14
					DC.W $0FFF	; COLOR15
sgnTimer:			DC.W 0
sgnBitplaneA1:		DC.L 0
sgnBitplaneA2:		DC.L 0
sgnBitplaneB1:		DC.L 0
sgnBitplaneB2:		DC.L 0
sgnBitplaneA3:		DC.L 0
sgnBitplaneB3:		DC.L 0
sgnAccumulator0:	DC.W 0
sgnAccumulator1:	DC.W 0
sgnNbParticles:		DC.W 0
sgnMaxNbParticles:	DC.W 0
sgnParticleBitmaps:
					; Data format for the particle animation bitmaps is:
					; DC.B 1st line of frame 0, 1st line of frame 1, ..., 1st line of frame SGN_PARTICLE_NBKEYS-1
					; ...
					; DC.B 7th line of frame 0, 7th line of frame 1, ..., 7th line of frame SGN_PARTICLE_NBKEYS-1
					; Disc...
					IFNE SGN_PARTICLE_DISC
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
sgnParticleBitmapsShifted:
					BLK.W SGN_PARTICLE_NBKEYS*8*8
OFFSET_PATH_X=0			; X coordinate
OFFSET_PATH_Y=2			; Y coordinate
OFFSET_PATH_DX=4		; Value added to previous point X coordinate to reach this point
OFFSET_PATH_DY=6		; Value added to previous point Y coordinate to reach this point
DATASIZE_PATH=4*2
sgnPath:			; SGN_PATH_LENGTH entries
					DC.W 319, 98, -1, 3, 318, 101, -1, 3, 317, 104, -1, 3, 316, 107, -1, 3, 315, 110, -1, 3, 314, 113, -1, 3, 313, 117, -1, 4, 312, 120, -1, 3, 311, 122, -1, 2, 310, 125, -1, 3, 309, 128, -1, 3, 308, 131, -1, 3, 307, 133, -1, 2, 306, 135, -1, 2, 305, 137, -1, 2, 304, 139, -1, 2, 303, 140, -1, 1, 302, 142, -1, 2, 301, 143, -1, 1, 300, 144, -1, 1, 299, 144, -1, 0, 298, 145, -1, 1, 297, 145, -1, 0, 296, 145, -1, 0, 295, 145, -1, 0, 294, 144, -1, -1, 293, 143, -1, -1, 292, 143, -1, 0, 291, 142, -1, -1, 290, 141, -1, -1, 289, 140, -1, -1, 288, 139, -1, -1, 287, 137, -1, -2, 286, 136, -1, -1, 285, 135, -1, -1, 284, 133, -1, -2, 283, 132, -1, -1, 282, 131, -1, -1, 281, 130, -1, -1, 280, 129, -1, -1, 279, 128, -1, -1, 278, 127, -1, -1, 277, 127, -1, 0, 276, 126, -1, -1, 275, 126, -1, 0, 274, 126, -1, 0, 273, 126, -1, 0, 272, 126, -1, 0, 271, 127, -1, 1, 270, 127, -1, 0, 269, 128, -1, 1, 268, 129, -1, 1, 267, 130, -1, 1, 266, 132, -1, 2, 265, 133, -1, 1, 264, 135, -1, 2, 263, 136, -1, 1, 262, 138, -1, 2, 261, 140, -1, 2, 260, 142, -1, 2, 259, 144, -1, 2, 258, 146, -1, 2, 257, 148, -1, 2, 256, 150, -1, 2, 255, 152, -1, 2, 254, 154, -1, 2, 253, 156, -1, 2, 252, 158, -1, 2, 251, 159, -1, 1, 250, 160, -1, 1, 249, 161, -1, 1, 248, 162, -1, 1, 247, 163, -1, 1, 246, 163, -1, 0, 245, 163, -1, 0, 244, 163, -1, 0, 243, 163, -1, 0, 242, 162, -1, -1, 241, 161, -1, -1, 240, 160, -1, -1, 239, 158, -1, -2, 238, 156, -1, -2, 237, 154, -1, -2, 236, 151, -1, -3, 235, 149, -1, -2, 234, 146, -1, -3, 233, 143, -1, -3, 232, 139, -1, -4, 231, 136, -1, -3, 230, 132, -1, -4, 229, 128, -1, -4, 228, 124, -1, -4, 227, 120, -1, -4, 226, 116, -1, -4, 225, 112, -1, -4, 224, 108, -1, -4, 223, 104, -1, -4, 222, 100, -1, -4, 221, 96, -1, -4, 220, 92, -1, -4, 219, 89, -1, -3, 218, 86, -1, -3, 217, 82, -1, -4, 216, 80, -1, -2, 215, 77, -1, -3, 214, 75, -1, -2, 213, 73, -1, -2, 212, 72, -1, -1, 211, 70, -1, -2, 210, 70, -1, 0, 209, 69, -1, -1, 208, 69, -1, 0, 207, 69, -1, 0, 206, 70, -1, 1, 205, 71, -1, 1, 204, 73, -1, 2, 203, 75, -1, 2, 202, 77, -1, 2, 201, 79, -1, 2, 200, 82, -1, 3, 199, 86, -1, 4, 198, 89, -1, 3, 197, 93, -1, 4, 196, 97, -1, 4, 195, 101, -1, 4, 194, 105, -1, 4, 193, 110, -1, 5, 192, 114, -1, 4, 191, 119, -1, 5, 190, 123, -1, 4, 189, 128, -1, 5, 188, 133, -1, 5, 187, 137, -1, 4, 186, 142, -1, 5, 185, 146, -1, 4, 184, 150, -1, 4, 183, 154, -1, 4, 182, 158, -1, 4, 181, 161, -1, 3, 180, 164, -1, 3, 179, 167, -1, 3, 178, 170, -1, 3, 177, 172, -1, 2, 176, 174, -1, 2, 175, 176, -1, 2, 174, 177, -1, 1, 173, 178, -1, 1, 172, 178, -1, 0, 171, 179, -1, 1, 170, 178, -1, -1, 169, 178, -1, 0, 168, 177, -1, -1, 167, 176, -1, -1, 166, 175, -1, -1, 165, 173, -1, -2, 164, 171, -1, -2, 163, 169, -1, -2, 162, 166, -1, -3, 161, 164, -1, -2, 160, 161, -1, -3, 159, 158, -1, -3, 158, 155, -1, -3, 157, 152, -1, -3, 156, 149, -1, -3, 155, 146, -1, -3, 154, 143, -1, -3, 153, 139, -1, -4, 152, 136, -1, -3, 151, 134, -1, -2, 150, 131, -1, -3, 149, 128, -1, -3, 148, 125, -1, -3, 147, 123, -1, -2, 146, 121, -1, -2, 145, 119, -1, -2, 144, 117, -1, -2, 143, 116, -1, -1, 142, 114, -1, -2, 141, 113, -1, -1, 140, 112, -1, -1, 139, 112, -1, 0, 138, 111, -1, -1, 137, 111, -1, 0, 136, 111, -1, 0, 135, 111, -1, 0, 134, 112, -1, 1, 133, 113, -1, 1, 132, 113, -1, 0, 131, 114, -1, 1, 130, 115, -1, 1, 129, 116, -1, 1, 128, 117, -1, 1, 127, 119, -1, 2, 126, 120, -1, 1, 125, 121, -1, 1, 124, 123, -1, 2, 123, 124, -1, 1, 122, 125, -1, 1, 121, 126, -1, 1, 120, 127, -1, 1, 119, 128, -1, 1, 118, 129, -1, 1, 117, 129, -1, 0, 116, 130, -1, 1, 115, 130, -1, 0, 114, 130, -1, 0, 113, 130, -1, 0, 112, 130, -1, 0, 111, 129, -1, -1, 110, 129, -1, 0, 109, 128, -1, -1, 108, 127, -1, -1, 107, 126, -1, -1, 106, 124, -1, -2, 105, 123, -1, -1, 104, 121, -1, -2, 103, 120, -1, -1, 102, 118, -1, -2, 101, 116, -1, -2, 100, 114, -1, -2, 99, 112, -1, -2, 98, 110, -1, -2, 97, 108, -1, -2, 96, 106, -1, -2, 95, 104, -1, -2, 94, 102, -1, -2, 93, 100, -1, -2, 92, 98, -1, -2, 91, 97, -1, -1, 90, 96, -1, -1, 89, 95, -1, -1, 88, 94, -1, -1, 87, 93, -1, -1, 86, 93, -1, 0, 85, 93, -1, 0, 84, 93, -1, 0, 83, 93, -1, 0, 82, 94, -1, 1, 81, 95, -1, 1, 80, 96, -1, 1, 79, 98, -1, 2, 78, 100, -1, 2, 77, 102, -1, 2, 76, 105, -1, 3, 75, 107, -1, 2, 74, 110, -1, 3, 73, 113, -1, 3, 72, 117, -1, 4, 71, 120, -1, 3, 70, 124, -1, 4, 69, 128, -1, 4, 68, 132, -1, 4, 67, 136, -1, 4, 66, 140, -1, 4, 65, 144, -1, 4, 64, 148, -1, 4, 63, 152, -1, 4, 62, 156, -1, 4, 61, 160, -1, 4, 60, 164, -1, 4, 59, 167, -1, 3, 58, 170, -1, 3, 57, 174, -1, 4, 56, 176, -1, 2, 55, 179, -1, 3, 54, 181, -1, 2, 53, 183, -1, 2, 52, 184, -1, 1, 51, 186, -1, 2, 50, 186, -1, 0, 49, 187, -1, 1, 48, 187, -1, 0, 47, 187, -1, 0, 46, 186, -1, -1, 45, 185, -1, -1, 44, 183, -1, -2, 43, 181, -1, -2, 42, 179, -1, -2, 41, 177, -1, -2, 40, 174, -1, -3, 39, 170, -1, -4, 38, 167, -1, -3, 37, 163, -1, -4, 36, 159, -1, -4, 35, 155, -1, -4, 34, 151, -1, -4, 33, 146, -1, -5, 32, 142, -1, -4, 31, 137, -1, -5, 30, 133, -1, -4, 29, 128, -1, -5, 28, 123, -1, -5, 27, 119, -1, -4, 26, 114, -1, -5, 25, 110, -1, -4, 24, 106, -1, -4, 23, 102, -1, -4, 22, 98, -1, -4, 21, 95, -1, -3, 20, 92, -1, -3, 19, 89, -1, -3, 18, 86, -1, -3, 17, 84, -1, -2, 16, 82, -1, -2, 15, 80, -1, -2, 14, 79, -1, -1, 13, 78, -1, -1, 12, 78, -1, 0, 11, 77, -1, -1, 10, 78, -1, 1, 9, 78, -1, 0, 8, 79, -1, 1, 7, 80, -1, 1, 6, 81, -1, 1, 5, 83, -1, 2, 4, 85, -1, 2, 3, 87, -1, 2, 2, 90, -1, 3, 1, 92, -1, 2, 0, 95, -1, 3
sgnParticleAnimation:
OFFSET_ANIMATION_BITMAP=0	; Offset of the bitmap for the frame
OFFSET_ANIMATION_SPEED=2	; Speed of the frame
DATASIZE_ANIMATION=2*2
					BLK.W SGN_PARTICLE_TTL*(DATASIZE_ANIMATION>>1),0

	ENDC

; ---------- Message ----------

	IFNE PART_MESSAGE_SIGNAL!PART_MESSAGE_SCROLLS!PART_MESSAGE_MESH!PART_MESSAGE_END
	
msgCutterPatterns:	; Generated with the tool "patterns" in desire.xlsx
					; Each pattern must contain (MSG_CUTTER_DX / 16) * (MSG_CUTTER_DY / 16) entries (so 12 x 10 entries)
					; Diamond
					DC.B 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1,2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2,3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3,4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4,4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4,3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3,2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2,1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1,0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0
					; Spiral
					DC.B 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 2,8, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 3,7, 0, 5, 6, 7, 8, 9, 0, 1, 0, 1, 4,6, 9, 4, 1, 2, 3, 4, 5, 2, 1, 2, 5,5, 8, 3, 0, 9, 8, 7, 6, 3, 2, 3, 6,4, 7, 2, 9, 8, 7, 6, 5, 4, 3, 4, 7,3, 6, 1, 0, 9, 8, 7, 6, 5, 4, 5, 8,2, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 9,1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
					; Diagonal
					DC.B 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2,2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3,3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4,4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5,5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6,6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7,7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8,8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
					; Many spirals
					DC.B 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0, 7, 8, 9, 0, 1, 6, 6, 1, 0, 9, 8, 7,6, 7, 8, 9, 2, 7, 7, 2, 9, 8, 7, 6,5, 6, 5, 4, 3, 8, 8, 3, 4, 5, 6, 5,4, 3, 2, 1, 0, 9, 9, 0, 1, 2, 3, 4,4, 3, 2, 1, 0, 9, 9, 0, 1, 2, 3, 4,5, 6, 5, 4, 3, 8, 8, 3, 4, 5, 6, 5,6, 7, 8, 9, 2, 7, 7, 2, 9, 8, 7, 6,7, 8, 9, 0, 1, 6, 6, 1, 0, 9, 8, 7,0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0
msgCutterPattern:	DC.L 0
msgPartSignal:
					; 20 chars per line
					; $00 to skip a line
					; $FF to end page
					; $FF after end of page to end text
					; No trailing spaces allowed
					; For this demo :
					; 16 lines
					; Page 0
					DC.B "Transporting data",0
					DC.B "bits in times",0
					DC.B "before always on",0
					DC.B  0
					DC.B "Dial-up was your",0
					DC.B "friend, landline",0
					DC.B "your tech and busy",0
					DC.B "signal or drop",0
					DC.B "carrier your 404",0
					DC.B 0
					DC.B "Love the social",0
					DC.B "media dial-Up",0
					DC.B "ancestor and",0
					DC.B "textbased terminals",-1
					; End of pages
					DC.B -1
					EVEN
msgPartScrolls:
					; Same constraints
					DC.B "Net neutrality is",0
					DC.B "not a problem on",0
					DC.B "vintage systems",0
					DC.B 0
					DC.B "Come visit FASTLINE",0
					DC.B "the cooperation BBS",0
					DC.B "for Hokuto-Force,",0
					DC.B "Mayday, Lacity,",0
					DC.B "TRSi and DESiRE",0
					DC.B 0
					DC.B "You should connect",0
					DC.B "via fastline.nu",0
					DC.B "port 1541",0
					DC.B 0
					DC.B "BBSing like a boss",-1
					; End of pages
					DC.B -1
					EVEN
msgPartMesh:
					; Same constraints
					DC.B "Then the internet",0
					DC.B "came along mid-90s",0
					DC.B "Like a comet to the",0
					DC.B "dinosaurs, wiped out",0
					DC.B "the online BBS",0
					DC.B "landscape",0
					DC.B 0
					DC.B "Until, one by one,",0
					DC.B "the brightest lights",0
					DC.B "of the BBS world",0
					DC.B "blinked out of",0
					DC.B "existence",0
					DC.B 0
					DC.B "www.wemakdemos.nl",-1
					; End of pages
					DC.B -1
					EVEN
msgPartEnd:
					DC.B "Binge netflix",0
					DC.B "Tweet selfies",0
					DC.B "Game mobile",0
					DC.B "Like facebook ",0
					DC.B "Reddit culture",0
					DC.B "Strip Fortnite",0
					DC.B "Troll pouete",0
					DC.B "Demos youtube",0
					DC.B "Beats patatap",0
					DC.B "Browse demozoo",0
					DC.B "Sunbleach amiga",0
					DC.B 0
					DC.B "When do you find the",0
					DC.B "time to make a new",0
					DC.B "demo? ",-1
					; End of pages
					DC.B -1
					EVEN

	ENDC

;---------- Scrolls ----------

	IFNE PART_SCROLLS

sclPalette:
					DC.W $0000	; COLOR00
					DC.W $0FFF	; COLOR01
					DC.W $000F	; COLOR02
					DC.W $0FFF	; COLOR03
					DC.W $0000	; COLOR04
					DC.W $0000	; COLOR05
					DC.W $000D	; COLOR06
					DC.W $0000	; COLOR07
					DC.W $0000	; COLOR08
					DC.W $0000	; COLOR09
					DC.W $0000	; COLOR10
					DC.W $0000	; COLOR11
					DC.W $0000	; COLOR12
					DC.W $0000	; COLOR13
					DC.W $0000	; COLOR14
					DC.W $0000	; COLOR15
sclTimer:			DC.W 0
sclNbActiveScrolls:	DC.W 0
sclFrontBuffer:		DC.L 0
sclBackBuffer:		DC.L 0
SCL_FONT_DATASIZE=4+4+4+1+1+1+1+1+1
SCL_FONT_OFFSET_FONT=0				; Pointer to the font binary data (used to setup the rest of this structure only)
SCL_FONT_OFFSET_DATA=4				; Pointer to the characters data in the font binary data
SCL_FONT_OFFSET_BITPLANES=8			; Pointer to the characters bitplanes in the font binary data
SCL_FONT_OFFSET_NBCHARS=12			; Number of characters in the font
SCL_FONT_OFFSET_FIRSTASCII=13		; ASCII code of the first character of the font
SCL_FONT_OFFSET_CHARSIDEPIXELS=14	; Side of a character, in pixels
SCL_FONT_OFFSET_CHARSIZE=15			; Size of a character (the N of 2^N bytes)
SCL_FONT_OFFSET_CHARSIDE=16			; Side of a character (the N of 2^N pixels)
SCL_FONT_OFFSET_SPACEWIDTH=17		; Width of the space character in pixels
sclFonts:
sclFontArial16:
	DC.L vfntArial16, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontArial32:
	DC.L vfntArial32, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontArial64:
	DC.L vfntArial64, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontArialBlack32:
	DC.L vfntArialBlack32, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontBroadway32:
	DC.L vfntBroadway32, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontCooper16:
	DC.L vfntCooper16, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontJokerman64:
	DC.L vfntJokerman64, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontOldEnglish32:
	DC.L vfntOldEnglish32, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontOldEnglish64:
	DC.L vfntOldEnglish64, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontRavie32:
	DC.L vfntRavie32, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontRavie64:
	DC.L vfntRavie64, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontTimes16:
	DC.L vfntTimes16, 0, 0
	DC.B 0, 0, 0, 0, 0, 0
sclFontTimes32:
	DC.L vfntTimes32, 0, 0
	DC.B 0, 0, 0, 0, 0, 0

sclTextCooper16_0:
	DC.B "Did you know that the best scroller is one that has a great beginning, a memorable end, and not much in between? Now here we are in an age where connecting people from opposite sides of the earth with no problem at al doing scroll text for your favourite retro homecomputer. Welcome to our BBS tribute that has the following credz.  -= Code by Yragael =-  -= GFX by Bokanoid =-  -= Music by Subi =-  -= Organized by RamonB5 =-  and many thanks to -= Stingray =- for helping with bug hunting.  Contact dSr if you have an interest to live out your creative potential in GFX, music, or devising clever routines, and blend them with our interest for & usage of computer technology then do contact DESiRE via: www.wemakedemos.nl  or email at frono@home.nl or really oldskool via our BBS  FASTLINE.NU  PORT 1541 ",0
	EVEN
sclTextArial16_0:
	DC.B "Hey, Hey! Heyyy!! Hey what’s going? Wsup, Wsup! What’s going on? Whatcha up to? This little production is an homage for the sysops and everybody that made BBS such a great time in our younger years. You know, Normal people have normal hobbies, strange people have strange hobbies. While some people enjoy climbing up to the top of the highest mountains, others may enjoy collecting stamps. And some find it interesting to live out their creative potential: painting, making music, solving math puzzles or devising clever routines, etc. Demosceners blend those activities with their interest for & usage of computer technology. ",0
	EVEN
sclTextTimes16_0:
	DC.B "The DESiRE comradeship is aimed to have fun and preserve demoscene splendor for posterity. The team of dSr we believe in connecting artists and technicians, where the artist can inspire the technician, the technician can inspire the artist, and both of them can inspire the audience. Contact dSr if you have an interest to live out your creative potential in GFX, music, or devising clever routines, and blend them with our interest for & usage of computer technology then do contact DESiRE via: www.wemakedemos.nl  or email at frono@home.nl or really oldskool via our BBS  FASTLINE.NU  PORT 1541 ",0
	EVEN
sclTextOldEnglish32:
	DC.B "Art is how we decorate space, music is how we decorate time, code is how we decorate the 4 dimensions.  We offer chronic union of science and entertainment. Artists and technicians often have very different goals and ways of working, but many things also overlap. In DESiRE we believe in connecting the two, the artist can inspire the technician, the technician can inspire the artist, and both of them can inspire the audience. Work is needed to preserve demoscene splendor for posterity.  Tinkering with technology is terrific. At DESiRE, we experience the benefits of technology every day. Passing on our passion to a new generation is our shared responsibility. Desire is the Engine of Creation. Not old or new school, but elements of both combining in an attitude that best suits the idea in question.....  ..  .    . ",0
	EVEN
sclTextArial64:
	DC.B "This seems to be a good spot for some greetings and kudos to our demoscene friends ... abyss - alcatraz - arise design - arsenic - artstate - ate bit - atlantis - avatar - bauknecht - blocktronics - camelot - crtc - darklite - deadliners - dekadence - delysid- - fairlight - flood - g*p - glance - hare krishna - hokuto force - hornet - insane - jetset - laxity - lft - logicoma - mahoney - mayday - melon. - multistyle labs - nah kolor....   Contact dSr if you have an interest to live out your creative potential in GFX, music, or devising clever routines, and blend them with our interest for & usage of computer technology then do contact DESiRE via: www.wemakedemos.nl  or email at frono@home.nl or really oldskool via our BBS  FASTLINE.NU  PORT 1541 ",0
	EVEN
sclTextJokerman64:
	DC.B "Let us speed these greetings up a bit here ... offence - orb - oxyron - plush - poo-brain - porta2note - prosonix - quadtrip - quebarium - resistance - rift - samar productions - sensenstahl - shape - silicon ltd - singular crew - success - svatg - the ruling company - the undead sceners - titan - toondichters - triad - trsi - vision - xenon - and everybody that we forget to put down in this scroller. ... Contact dSr if you have an interest to live out your creative potential in GFX, music, or devising clever routines, and blend them with our interest for & usage of computer technology then do contact DESiRE via: www.wemakedemos.nl  or email at frono@home.nl or really oldskool via our BBS  FASTLINE.NU  PORT 1541  ",0
	EVEN
sclTextArialBlack32_0:
	DC.B "Lot of love and respect to our past present and future dSr crew ... Alien^PDX - Ambient - Antibody - BIP - Bokanoid - Chipper - Chromag - CMR - Daison - Dascon - Dave - Deathstar - Forcer - Giz - Guy Frost - Hammerfist - Heaven - Infant - Jerry - Paragon - Luis - Mxbyte - Mysery - Nik - Oni - Premium - ramon b5 - Ratbone - Redferne - Riox - Sacha - Scali - Subi - SuperPlek - Tecon - THD - Tim - Twillight - Zaxe - zeroZshadow - TRiACE - No-XS - Defcon8 - Rotteroy - cPix - Optic - Lowlife - bstrr - Hell Mood - Igor - Nucleus - Mudlord - Homecoded - Organicdreams - Hamcha - Serpent - Stingray - Supadupa - Ozan - Shadez - Havoc - Slash - Orbitaldecay - jmph - Blueghost - SkyLyrac - Phaazon - General Iroh - Tursi - DYA - Evvvvil - Scan - Waldo - The Invisible Man - Dark - sBeam - VisionVortex - MrVux - Golara - Art-X - Peakreacher - ZootimeEdit - Salacryl - Z  ....  ..  You should connect via FASTLINE.NU  PORT 1541.  ",0
	EVEN
sclTextRavie64:
	DC.B "Call our FASTLINE BBS for your Amiga Atari Spectrum PC and C64 warez and meet our friendly sysop The Fix. Call FASTLINE.NU  PORT 1541.  FASTLINE is the cooperation BBS for HOKUTO-FORCE MAYDAY LAXITY TRSI and DESIRE. You should connect via FASTLINE.NU  PORT 1541. FASTLINE changed from FAME BBS to AmiExpress 5.1 mostly to support the race for firsties and real c64 bbses now Fastline also run son AmiExpress for an even better experience. You should connect via FASTLINE.NU  PORT 1541  Contact dSr if you have an interest to live out your creative potential in GFX, music, or devising clever routines, and blend them with our interest for & usage of computer technology then do contact DESiRE via: www.wemakedemos.nl  or email at frono@home.nl or really oldskool via our BBS  FASTLINE.NU  PORT 1541 ",0
	EVEN
sclTextRavie32:
	DC.B "The first modem for microcomputers was invented by Dennis Hayes in 1977. This device (short for MOdulator-DEModulator) allowed two computers to connect to each other over the existing telephone network. Previously, dedicated phone lines were used between permanent computer installations. He soon founded D. C. Hayes Associates, later Hayes Corporation, which was a leader in PC Modems for most of the 1980's. While the idea of being able to use the existing phone network for computer communication was still new (and gaining interest by hobbyists and others to transfer information) it was two people, Ward Christensen and Randy Suess, who created the first Bulletin Board System and put it online in February, 1978. The concept behind Ward and Randy's CBBS was to provide a way for others to dial into their computer, and leave messages for other users. They described it as a natural extension of an actual physical Bulletin Board, and the era of the Dial-Up BBS had begun. ",0
	EVEN
sclTextTimes32:
	DC.B "Remember what places sucked up all your long distance calls and sleepless nights, trying to get past the busy signals ... 6 hour blobs - A.C.E. - Acid House - Apocalypse - Asylum - Atomic Fallout - Badlands - Baghdad Café - Black Plague - Blastersound - Boondocks - Braindead - Camelot -  Channel X -  Crystal Palace - Dark Domain - Data Center - Defcon 5 - Digital Nightmare - Down Town - Dox Domus Horus - Eleventh Hour - Equilizer - Fastline - Fastrax - Fiend Club - Forgotten Realms - Future Inferno - Gangstars District - Gates Of Asgard - Hallowed Point - Head Trauma - Heaven's Door - High Crime - Kukoo - Methadone - Modem Massacre - Motherboard One - Mystical Places - Neon City - Nightfall - One Eight Seven - One Nighter - Panic Zone - Phantom - Pirates Haven - Plato's Place - Pleasure Dome - Snarf's Pub - Splatter House - Taj Mahal - Tempest Thunderstorm - Terminal Zone - The Empire - The Hood - The Tower - The Yard - Throne Chamber - Time Station - Treasure Island - Underworld - Warez Depot  ",0
	EVEN
sclTextBroadway32:
	DC.B "Kudos for the Orgas : Arok - Assembly - Birdie - Buenzli - Chaos Constructions - Compusphere - Datastorm - Deadline - DemoJS - Demosplash - DiHALT - Dreamhack - Edison - End of the World - Euskal - Evoke - Finnish Amiga Party - Flashback - Forever - Function - Gerp - Gubbdata - Hackerence - Instanssi - JHCon - js1k - Kindergarden - Little Computer People - Main - Nordlicht - NOVA - NVScene - Outline - Payback - Recursion - ReSeT - Revision - ReWired - Riverwash - Silly Venture - Solskogen - Somewhere in Holland - Sommarhack -  Stream - Sundown - Syntax - The Alternative Party - The Gathering - the Ultimate Meeting - TMDC - TokyoDemoFest - TRSAC - Very Important Party - X ... Contact dSr if you have an interest to live out your creative potential in GFX, music, or devising clever routines, and blend them with our interest for & usage of computer technology then do contact DESiRE via: www.wemakedemos.nl  or email at frono@home.nl or really oldskool via our BBS  FASTLINE.NU  PORT 1541 ",0
	EVEN
sclTextArial32:
	DC.B "For the latest warez in PC Console Amiga meet us in the womens shower at Evoke or at the annual dSr and friends BBQ. You can also get our autographs at Arok - Assembly - Atariada - Birdie - Buenzli - Chaos Constructions - Compusphere - Datastorm  - Deadline - DemoJS - Demosplash - DiHALT  - Dreamhack - Edison - End of the World - Euskal - Finnish Amiga Party - Flashback - Forever  - Function - Gerp  - Gubbdata - Hackerence - Instanssi - JHCon - js1k - Kindergarden - Little Computer People - Main - Nordlicht - NVScene  - Outline - Payback - ReSeT - Revision - ReWired - Riverwash  - Silly Venture - Solskogen - Somewhere in Holland - Sommarhack  - Stream - NOVA - Syntax - The Alternative Party - The Gathering - the Ultimate Meeting - TMDC - TokyoDemoFest  - TRSAC - Very Important Party - X ....  You should connect via FASTLINE.NU  PORT 1541. ",0
	EVEN
sclTextOldEnglish64:
	DC.B "Came into the game Then pulled the pin and let it go Blew the battle bus up Just sit and watch it glow Legends round my table If you're building, hit the road heavy ammunition flying straight into your dome We ignite classes kitted right  Flying to the fight Say goodnight Wingman ain't polite  Dancing? Yeah alright Quite the sight Not the silly type Came to take a life Lacking hype Call it falling damage Think your scared of heights  Strategy is key I build and block shots Only thing you do is slide And try to hide behind a rock Three people on a team is not really a full squad New bugs everyday A million new flaws I'm hitting you too hard little homie So what now? This puppy on my back Got more bite than your bloodhound Knocked down then knocked out You sideline observer Fortnite is still the king Shut down your servers. ....  You should connect via FASTLINE.NU  PORT 1541. ",0
	EVEN
sclTextArial16_1:
	DC.B "Paardengeit je weet zelf het is je niffauw in de building  kom in de club krullende hert Huts a niffauw, ken je die dans al of niet? Springen Ah kleine damhert Huts a niffauw, doe normaal ey niffauw Krullen op mijn hoofd en ik space a niffauw Huts a niffauw, ik space a niffauw Huts, Louboutin slangenleer geen studs Kom ik in de club, dan je weet ik maak stuk Die Cartier heeft geen sterkte, huts .45 op de hip, volle clip die money wordt gestoord eh niffo En ik blow het in de motherfucking store eh niffo Huts, die slangen worden leer eh niffo Huts, die slangen worden leer eh niffo Huts, ben ik in BLU dan scheurt de hele tent groot (groot) Hele tent bloot (bloot), hele tent rood (red) Geen remblok, ik moet racen naar die finish Racen naar die finish, ra-racen naar die finish En die tattoos op me been laat d’r smelten net boter Ho-hoge hightop domme swag op motor Rolex bustdown, alle kanten glimmen (heh) Nek je die? Alle kanten glimmen ........ You should connect via FASTLINE.NU  PORT 1541. ",0
	EVEN
sclTextArialBlack32_1:
	DC.B "Originally BBSes were accessed only over a phone line using an analog dial-up modem, but by the early 1990s BBSes were allowing connection by other means, such as via a Telnet, packet switched network, or packet radio connection. The term Bulletin Board System itself is a reference to the traditional cork-and-pin bulletin board often found in entrances of supermarkets, schools, libraries or other public areas where people can post messages, advertisements, or community news. During their heyday from the late 1970s to the mid 1990s, most BBSes were run as a hobby free of charge by the system operator (or ""SysOp""), while other BBSes charged their users a subscription fee for access, or were operated by a business as a means of supporting their customers. Bulletin Board Systems were in many ways a precursor to the modern form of the World Wide Web and other aspects of the Internet.....  You should connect via FASTLINE.NU  PORT 1541. ",0
	EVEN
sclTextTimes16_1:
	DC.B "The demoscene, roughly put, centers around using specific hardware and software to make visual sequences with music. It was originally centered in Europe. The wiki definition: “The demoscene is an international computer art subculture that specializes in producing demos: small, self-contained computer programs that produce audio-visual presentations. The main goal of a demo is to show off programming, artistic, and musical skills. Obviously the artform has evolved with technology over the years and in my research I have stumbled on some incredible digital art with music, which is an essential part of what we are doing at Light the Music. I have found a few inspiring examples amongst numerous to choose from. There are also a variety websites dedicated to the demoscene to peruse as well. The Demoscene is all about hardware/software constraints: Awards in the demoscene are given based on the types of technology used. Parameters define the form, and we are certainly working with technology constraints.",0
	EVEN
sclTextCooper16_1:
	DC.B "The marriage of music, visuals and code: The best pieces in the demoscene are a beautiful marriage of visual skill, great music and proficient code. This is the nexus in which we are attempting to operate at Light the Music. The Demoscene mostly deals in abstraction: The pieces in the demoscene are mostly abstract and done for the sake of beauty, not a linear story line or a commercial purpose. One major thing we are loving about our app is the ability for users to have an abstract and pleasing visual-music experience. Peer Acceptance is a valuable currency: The international demoscene functions in the underground and is mostly non-commercial. Getting propers from your peers is the main currency.  Whereas we are a commercial company, our team is highly motivated to make a beautiful product that we can all be proud of showing our colleagues across a variety of fields. It’s all about the nod ... .. You should connect via FASTLINE.NU  PORT 1541.",0
	EVEN

SCL_SCROLL_DELAY_FACTOR=40			; This is a quick way to change the delays for testing purpose
SCL_SCROLL_DATASIZE=2+4+4+2+2+2+2+4+4+1+1
SCL_SCROLL_OFFSET_DELAY=0			; Delay before starting (# of VERTB)
SCL_SCROLL_OFFSET_FONT=2			; Pointer to the font structure
SCL_SCROLL_OFFSET_TEXT=6			; Pointer to the text
SCL_SCROLL_OFFSET_X=10				; X position
SCL_SCROLL_OFFSET_Y=12				; Y position
SCL_SCROLL_OFFSET_SIZE=14			; Size (horizontal: width, vertical: height)
SCL_SCROLL_OFFSET_SPEED=16			; Speed
SCL_SCROLL_OFFSET_CHAR=18			; Pointer to current character in the text (reserved)
SCL_SCROLL_OFFSET_CHARCOLUMN=22		; Pointer to the first column to be drawn in the current character (reserved)
SCL_SCROLL_OFFSET_CHARCOLUMNS=26	; # of columns of the current character bitplane to be drawn - 1 (reserved)
SCL_SCROLL_OFFSET_ORIENTATION=27	; Orientation (0: horizontal, 1: vertical)
sclScrolls:
	DC.W 0*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontCooper16
	DC.L sclTextCooper16_0
	DC.W 0, 208, 288, 2
	DC.L 0, 0
	DC.B 0, 0

	DC.W 1*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontArial16
	DC.L sclTextArial16_0
	DC.W 0, 240, 192, 1
	DC.L 0, 0
	DC.B 0, 0

	DC.W 2*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontTimes16
	DC.L sclTextTimes16_0
	DC.W 0, 224, 192, 4
	DC.L 0, 0
	DC.B 0, 0

	DC.W 3*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontOldEnglish32
	DC.L sclTextOldEnglish32
	DC.W 192, 224, 128, 3
	DC.L 0, 0
	DC.B 0, 0

	DC.W 4*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontArial64
	DC.L sclTextArial64
	DC.W 160, 144, 128, 2
	DC.L 0, 0
	DC.B 0, 0

	DC.W 5*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontJokerman64
	DC.L sclTextJokerman64
	DC.W 160, 80, 128, 1
	DC.L 0, 0
	DC.B 0, 0

	DC.W 6*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontArialBlack32
	DC.L sclTextArialBlack32_0
	DC.W 288, 48, 176, 3
	DC.L 0, 0
	DC.B 0, 1

	DC.W 7*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontRavie64
	DC.L sclTextRavie64
	DC.W 0, 80, 144, 3
	DC.L 0, 0
	DC.B 0, 0

	DC.W 8*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontRavie32
	DC.L sclTextRavie32
	DC.W 80, 176, 80, 3
	DC.L 0, 0
	DC.B 0, 0

	DC.W 9*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontTimes32
	DC.L sclTextTimes32
	DC.W 0, 144, 144, 4
	DC.L 0, 0
	DC.B 0, 0

	DC.W 10*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontBroadway32
	DC.L sclTextBroadway32
	DC.W 64, 48, 224, 2
	DC.L 0, 0
	DC.B 0, 0

	DC.W 11*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontArial32
	DC.L sclTextArial32
	DC.W 64, 16, 256, 4
	DC.L 0, 0
	DC.B 0, 0

	DC.W 12*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontOldEnglish64
	DC.L sclTextOldEnglish64
	DC.W 0, 0, 80, 1
	DC.L 0, 0
	DC.B 0, 1

	DC.W 13*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontArial16
	DC.L sclTextArial16_1
	DC.W 144, 80, 96, 2
	DC.L 0, 0
	DC.B 0, 1

	DC.W 14*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontArialBlack32
	DC.L sclTextArialBlack32_1
	DC.W 0, 176, 80, 1
	DC.L 0, 0
	DC.B 0, 0

	DC.W 15*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontTimes16
	DC.L sclTextTimes16_1
	DC.W 64, 0, 128, 3
	DC.L 0, 0
	DC.B 0, 0

	DC.W 16*SCL_SCROLL_DELAY_FACTOR
	DC.L sclFontCooper16
	DC.L sclTextCooper16_1
	DC.W 192, 0, 128, 1
	DC.L 0, 0
	DC.B 0, 0

	ENDC

;---------- Mesh ----------

	IFNE PART_MESH

mshPalette:
					DC.W $0000	; COLOR00
					DC.W $0FFF	; COLOR01
					DC.W $000F	; COLOR02
					DC.W $0FFF	; COLOR03
					DC.W $000D	; COLOR04
					DC.W $0FFF	; COLOR05
					DC.W $040D	; COLOR06
					DC.W $0FFF	; COLOR07
					DC.W $000B	; COLOR08
					DC.W $0FFF	; COLOR09
					DC.W $060B	; COLOR10
					DC.W $0FFF	; COLOR11
					DC.W $080D	; COLOR12
					DC.W $0FFF	; COLOR13
					DC.W $0C0F	; COLOR14
					DC.W $0FFF	; COLOR15
mshTimer:			DC.W 0
mshLinePatterns:	DC.W $FFFF, $FDFF, $FDFD, $DDFD, $DDDD, $D5DD, $D5D5, $D555, $5555, $5551, $5151, $5111, $1111, $1101, $0101, $0100, $0000
mshLinePattern:		DC.L 0
mshFrontBuffer:		DC.L 0
mshBackBuffer:		DC.L 0
mshStrength:		DC.W 0
mshStrengthSteps:	DC.W 0
mshStrengthMin:		DC.W 0
mshStrengthMax:		DC.W 0
mshAngle:			DC.W 0
mshAttractorX:		DC.W 0
mshAttractorY:		DC.W 0
mshPoints:			; Points (x, y), from left to right, from top to bottom
					BLK.W 2*(MSH_DX+1)*(MSH_DY+1),0
mshTPoints:
					BLK.W 2*(MSH_DX+1)*(MSH_DY+1),0
mshLines:			; Horizontal edges line after line, then vertical edges column after column
					BLK.W 2*(MSH_DX*(MSH_DY+1)+(MSH_DX+1)*MSH_DY),0
mshAccumulator0:	DC.W 0
mshAccumulator1:	DC.W 0
mshText:
	; 40 chars per line
	; $00 to skip a line
	; $FF to end page
	; $FF after end of page to end text
	; No trailing spaces allowed
	; For this demo :
	; 38 chars per line, each line with a leading space
	; 22 lines
	; Page 0
	DC.B " /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\",0
	DC.B " \                                    /",0
	DC.B " /    .oO Desire September 2019 Oo.   \",0
	DC.B " \  ________    _______  ___________  /",0
	DC.B " /  \_____  \   \      \ \_   _____/  \",0
	DC.B " \   /   |   \  /   |   \ |    __)_   /",0
	DC.B " /  /    |    \/    |    \|        \  \",0
	DC.B " \  \_______  /\____|__  /_______  /  /",0
	DC.B " /          \/         \/        \/   \",0
	DC.B " \                                    /",0
	DC.B " /    .oO A tribute to sysops Oo.     \",0
	DC.B " \                                    /",0
	DC.B " /       Code & Design: Yragael       \",0
	DC.B " \       Graphics:      Bokanoid      /",0
	DC.B " /       Music:         Subi          \",0
	DC.B " \       Support:       Ramon B5      /",0
	DC.B " /                                    \",0
	DC.B " \  Get the source, data and doc at:  /",0
	DC.B " /                                    \",0
	DC.B " \     http://www.stashofcode.fr      /",0
	DC.B " /                                    \",0
	DC.B " \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/",-1
	; Page 1
	DC.B " /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\",0
	DC.B "   ____  ____  ___  ____  ____  ____   ",0
	DC.B "  (  _ \( ___)/ __)(_  _)(  _ \( ___)  ",0
	DC.B "   )(_) ))__) \__ \ _)(_  )   / )__)   ",0
	DC.B "  (____/(____)(___/(____)(_)\_)(____)  ",0
	DC.B "                                       ",0
	DC.B " Remember fondly the technology of your",0
	DC.B " youth, since it shaped the future and ",0
	DC.B " it shaped you.                        ",0
	DC.B "                                       ",0
	DC.B " Work is needed to preserve demoscene  ",0
	DC.B " splendor for posterity.               ",0
	DC.B "                                       ",0
	DC.B " We love you all, and respect your time",0
	DC.B " devotion and passion for the demoscene",0
	DC.B "                                       ",0
	DC.B "    kudos for you all from DESiRE !    ",0
	DC.B "                                       ",0
	DC.B "  ...oOo.oOo.oOo. dSR .oOo.oOo.oOo...  ",0
	DC.B "        FASTLINE.NU - PORT 1541        ",0
	DC.B "                                       ",0
	DC.B " \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/",-1
	; End of pages
	DC.B -1
	EVEN
; Table for the octants: y1 - y0, x1 - x0, Dx - Dy
; If < 0 then 0, if >= 0 then 1
; For example:
; y1 - y0 < 0 then 1
; x1 - x0 < 0 then 1
; dx - dy < 0 then 1
; The code for the octant is the address of the octant + 111
octants:
	DC.B 4	; 000 : y0 < y1 et x0 < x1 et dx > dy		 
	DC.B 0	; 001 : y0 < y1 et x0 < x1 et dx < dy
	DC.B 5	; 010 : y0 < y1 et x0 > x1 et dx > dy
	DC.B 2	; 011 : y0 < y1 et x0 > x1 et dx < dy
	DC.B 6	; 100 : y0 > y1 et x0 < x1 et dx > dy
	DC.B 1	; 101 : y0 > y1 et x0 < x1 et dx < dy
	DC.B 7	; 110 : y0 > y1 et x0 > x1 et dx > dy
	DC.B 3	; 111 : y0 > y1 et x0 > x1 et dx < dy
	EVEN

	ENDC

;*******************************************************************************
; Data in Chip memory
;*******************************************************************************
	
	SECTION data_c,DATA_C

;---------- Common ----------

	IFNE TUNE
module:	INCBIN "desireONE/data/subi-modem_romance.mod"
	ENDC
logo:	INCBIN "desireONE/data/logo320x48x1.raw"

;---------- DESIRE ----------

	IFNE PART_DESIRE

dsrPicture:		INCBIN "desireONE/data/picture320x256x4.raw"	

	ENDC

;---------- Signal ----------

	IFNE PART_SIGNAL

OFFSET_PARTICLE_BITMAP=0		; Image (offset in sgnParticleBitmapsShifted)
OFFSET_PARTICLE_X=2				; X coordinate
OFFSET_PARTICLE_Y=4				; Y coordinate
OFFSET_PARTICLE_SPEED=6			; Speed (decreasing to 0 as TTL increases)
OFFSET_PARTICLE_TTL=8			; Time to live
OFFSET_PARTICLE_INCX0=10		; 
OFFSET_PARTICLE_INCY0=12		;
OFFSET_PARTICLE_INCX1=14		;
OFFSET_PARTICLE_INCY1=16		;
OFFSET_PARTICLE_MINDXDY=18		;
OFFSET_PARTICLE_MAXDXDY=20		;
OFFSET_PARTICLE_ACCUMULATOR=22	;
DATASIZE_PARTICLE=12*2
sgnFirstParticle:	DC.L 0
sgnNextParticle:	DC.L 0
sgnParticlesStart:
					BLK.W SGN_NBPARTICLES*(DATASIZE_PARTICLE>>1),0
sgnParticlesEnd:
sgnBackground:		INCBIN "desireONE/data/courrier.raw"
	ENDC

;---------- Scrolls ----------

	IFNE PART_SCROLLS

VFNT_HEADER_NBCHARS=0
VFNT_HEADER_FIRSTASCII=1
VFNT_HEADER_CHARSIDE=2
VFNT_HEADER_CHARSIZE=3
VFNT_HEADER_RIGHTPADDING=4
VFNT_HEADER_SPACEWIDTH=5
VFNT_HEADER_LENGTH=6
VFNT_CHAR_LEFT=0
VFNT_CHAR_RIGHT=1
vfntArial16:
	INCBIN "desireONE/data/arial16.vfnt"
vfntArial32:
	INCBIN "desireONE/data/arial32.vfnt"
vfntArial64:
	INCBIN "desireONE/data/arial64.vfnt"
vfntArialBlack32:
	INCBIN "desireONE/data/arialblack32.vfnt"
vfntBroadway32:
	INCBIN "desireONE/data/broadway32.vfnt"
vfntCooper16:
	INCBIN "desireONE/data/cooper16.vfnt"
vfntJokerman64:
	INCBIN "desireONE/data/jokerman64.vfnt"
vfntOldEnglish32:
	INCBIN "desireONE/data/oldenglish32.vfnt"
vfntOldEnglish64:
	INCBIN "desireONE/data/oldenglish64.vfnt"
vfntRavie32:
	INCBIN "desireONE/data/ravie32.vfnt"
vfntRavie64:
	INCBIN "desireONE/data/ravie64.vfnt"
vfntTimes16:
	INCBIN "desireONE/data/times16.vfnt"
vfntTimes32:
	INCBIN "desireONE/data/times32.vfnt"

	ENDC
