
; TO DO: The CT_WAIT wait time (commented in this version) is used to delay the cut on A1200, because the beginning of the module has
; been lengthened so that the second part of the music starts when the rotozoom starts on A500 (it's a cracktro for A500). In fact,
; this wait time should be conditioned to the type of CPU determined at runtime, but I don't have the time to do it
; To DO: It doesn't always fit in the frame, probably the printer's fault when it uses the blitter, but it's not too obvious,
; especially with downscaling
; To DO: There is a comment in advanced printer saying that the printer must return something in D0?
; TO DO: Add a fade at the end


;-------------------------------------------------------------------------------
;                          .oO Scoopex "TWO" (v8) Oo.
;                         A tribute to graphic artists
;
; An second intro for the glorious Scoopex Amiga group, produced in September 2018.
;
;                     Code: Yragael (stashofcode@gmail.com)
;                     Picture: alien^pdx
;                     Logo : alien^pdx
;                     Music: Curt Cool / Depth
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

; This work is licensed under the terms of the Creative Commons Attribution-NonCommercial 4.0 International License
; (http://creativecommons.org/licenses/by-nc/4.0/).

; The most important constant is A500. Set it ot 1 for the cracktro to run on a basic A500 (512Kb of Chip memory only).
; The FX are then downsized as follows:
; - The maximum width (and height) of the BOBs of the puzzle is 32 pixels and not 64 pixels
; - The part of the picture that is rotozoomed is 200x200 and not 256x256
; Notice that shoud the A500 have more memory (512Kb of Fast memory), and A500 be set to 0, this cracktro would still run in 1/50th of a second per loop!

; The puzzle and the rotozoom consumes a lot of memory, so memory allocations have been splitted. It may sound strange that a program which first shut
; down the system later uses its routines for memory management, but this works... A true demo would run its own memory management system.

; The color map for the logo is special :
; - COLOR00 must be set to $0000 and may be used as an opaque color (reserved for the borders of the screen)
; - COLOR01 must used as the transparent color (reserved for the rotozoom instead of COLOR00, so that the color of the borders of the screen is untouched)
; - COlOR03 must be set to $FFFF (reserved for the text)

; Note to self on the logo. The problem with bitmapConverter.html is that it generates the palette as the first pixels it encounters:
; read a pixel, and if its colour is not in the palette, add it. As a result, the palette specified in an IFF file is likely to end up in
; the DCB file out of order. A trick is to add a first line to the image, and to paint the first N pixels with the N colours of the palette,
; in the right order. Once the conversion is done, you must delete the DC.B of this line in the DCB file before assembling it.

;********** Constants **********

; Program

A500=1						; Set to 1 for basic A500 with only 512Kb of Chip memory, else set to 0 (meaning at least 1 Mb of memory)
TUNE=0						; Probleme beim Einbinden PTPlayer
DEBUG=0

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256

; Cut

CT_WAIT=50					; Must be >= 0
CT_FADE_NBSTEPS=20
CT_FADE_WAIT=1				; Must be >= 1

; Picture

BITMAP_DEPTH=5
BITMAP_DX=320
BITMAP_DY=256

; Rotozoom

RZ_LOGO_DEPTH=1				; Must match RZ_DISPLAY_DEPTH
RZ_LOGO_DX=320				; Multiple of 32
RZ_LOGO_DY=56
RZ_LOGO_X=0					; Not used (see comments when copying the logo into the front buffer)
RZ_LOGO_Y=8

	IFNE A500
RZ_BITMAP_DX=200			; Multiple of 8
RZ_BITMAP_DY=200
	ELSE
RZ_BITMAP_DX=256			; Multiple of 8
RZ_BITMAP_DY=256
	ENDC
RZ_BITMAP_X=0				; Center the rotozoomed part in the picture with (BITMAP_DX-RZ_BITMAP_DX)>>1
RZ_BITMAP_Y=0				; Center the rotozoomed part in the picture with (BITMAP_DY-RZ_BITMAP_DY)>>1

RZ_COPPER_DX=40				; Width of the Copper screen in MOVE (8 pixels per MOVE)
RZ_COPPER_DY=32				; Height of the Copper screen in blocks of 8 pixels
RZ_COPPER_X=$81
RZ_COPPER_Y=$2C

RZ_DISPLAY_DEPTH=1

RZ_ANGLE_SPEED=3
RZ_WINDOW_DXMIN=(RZ_COPPER_DX>>1)-1		; The width of the window for computing coordinates in the Copper screen must be odd, so that the rotating picture may be centered. That's why it is set to RZ_WINDOW_DX+1. This means that the aspect ratio of the Copper screen is not exactly the aspect ratio of the rotating picture, but nobody will notice.
RZ_WINDOW_DYMIN=(RZ_COPPER_DY>>1)-1		; Same thing for the width : the height of the window must be odd...
	IFNE A500
RZ_WINDOW_DXMAX=3*RZ_COPPER_DX-1		; Must be somewhat <= RZ_BITMAP_DX or "pixels" outside the picture will be displayed
RZ_WINDOW_DYMAX=3*RZ_COPPER_DY-1		; Must be somewhat <= RZ_BITMAP_DY or "pixels" outside the picture will be displayed
	ELSE
RZ_WINDOW_DXMAX=5*RZ_COPPER_DX-1		; Must be somewhat <= RZ_BITMAP_DX or "pixels" outside the picture will be displayed
RZ_WINDOW_DYMAX=5*RZ_COPPER_DY-1		; Must be somewhat <= RZ_BITMAP_DY or "pixels" outside the picture will be displayed
	ENDC
RZ_ZOOM_STEPS=200						; No less than 2 (see _interpolate)

RZ_TEXTBITPLANE=1
RZ_TEXTCOLOR=$0FFF
RZ_TEXTDY=22*8
RZ_TEXTY=RZ_LOGO_Y+RZ_LOGO_DY+16+(DISPLAY_DY-RZ_LOGO_DY-RZ_LOGO_Y-16-RZ_TEXTDY)>>1
RZ_TEXTCHARDELAY=1
RZ_TEXTPAGEDELAY=150
PRT_PRINTER=5

RZ_COPPERLIST=10*4+RZ_DISPLAY_DEPTH*2*4+(1<<RZ_DISPLAY_DEPTH)*4+4+28*(3+RZ_COPPER_DX+1+2)*4+4+(RZ_COPPER_DX+1)*4+6*(3+RZ_COPPER_DX+1+2)*4+2*4+4
	; 10*4							Display configuration
	; RZ_DISPLAY_DEPTH*2*4			Bitplanes addresses
	; (1<<RZ_DISPLAY_DEPTH)*4		Palette for the bitmap
	; 4								Copper screen: WAIT
	; 28*(3+RZ_COPPER_DX+1+2)*4		Copper screen: 28*(COP1LCH+COP1LCL+WAIT+(RZ_COPPER_DX+1)*(COLOR00)+SKIP+COPJMP1)
	; 4								Copper screen: WAIT
	; (RZ_COPPER_DX+1)*4			Copper screen: (RZ_COPPER_DX+1)*(COLOR00)
	; 6*(3+RZ_COPPER_DX+1+2)*4		Copper screen: 6*(COP1LCH+COP1LCL+WAIT+(RZ_COPPER_DX+1)*(COLOR00)+SKIP+COPJMP1)
	; 2*4							Copper screen: COPL1LCL+COP1LCH
	; 4								$FFFFFFFE

; Puzzle

PZ_STATE_TODISPLAY=0
PZ_STATE_TOMOVE=1
PZ_STATE_TOREMOVE=2
PZ_STATE_TOIGNORE=3

	IFNE A500
PZ_BOB_DXMAX=32					; Maximum width of a BOB (must be multiple of 16)
	ELSE
PZ_BOB_DXMAX=64					; Maximum width of a BOB (must be multiple of 16)
	ENDC
PZ_BOB_DYMAX=PZ_BOB_DXMAX		; Maximum height of a BOB
PZ_NB_DISPLAYEDBOBS=12			; Maximum number of BOBs that are simultaneously moving

PZ_BITMAP_DX=BITMAP_DX			; Width of the "puzzled" bitmap
PZ_BITMAP_DY=BITMAP_DY			; Height of the "puzzled" bitmap

PZ_DISPLAY_DEPTH=BITMAP_DEPTH
PZ_PLAYFIELD_DX=DISPLAY_DX+(PZ_BOB_DXMAX<<1)
PZ_PLAYFIELD_DY=DISPLAY_DY+(PZ_BOB_DYMAX<<1)
PZ_COPPERLIST=10*4+PZ_DISPLAY_DEPTH*2*4+(1<<PZ_DISPLAY_DEPTH)*4+4
	; 10*4							Display configuration
	; PZ_DISPLAY_DEPTH*2*4			Bitplanes addresses
	; (1<<PZ_DISPLAY_DEPTH)*4		Palette
	; 4								$FFFFFFFE

; ********** Macros **********

WAIT_BLITTER:		MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)		; Means testing bit 14%8=6 of the most significant byte of DMACONR, which is BBUSY
	bne _waitBlitter0\@
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

; ********** Initializations **********
	
	SECTION code,CODE

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

	; Restore level 6 interrupt for music player

	move.l VBRPointer,a0
	lea $78(a0),a0
	move.l (a0),vector30
	move.w #$E000,INTENA(a5)

; ********** Puzzle **********

	; ---------- Setup data ----------

	; Allocate CHIP memory set to 0 for the Copperlist

	move.l #PZ_COPPERLIST,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,pzCopperList

	; Allocate CHIP memory set to 0 for the front buffer

	move.l #PZ_DISPLAY_DEPTH*PZ_PLAYFIELD_DY*(PZ_PLAYFIELD_DX>>3),d0
	move.l #$10002,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,pzFrontBuffer

	; Allocate CHIP memory set to 0 for the back buffer

	move.l #PZ_DISPLAY_DEPTH*PZ_PLAYFIELD_DY*(PZ_PLAYFIELD_DX>>3),d0
	move.l #$10002,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,pzBackBuffer

	; Allocate CHIP memory set to 0 for the final picture

	move.l #PZ_DISPLAY_DEPTH*PZ_PLAYFIELD_DY*(PZ_PLAYFIELD_DX>>3),d0
	move.l #$10002,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,pzFinalBuffer

	; Build the BOBs mask list

	lea pzBOBMasks,a0
	move.l #pzBOBMask16,(a0)+
	move.l #pzBOBMask32,(a0)+
	move.l #pzBOBMask48,(a0)+
	move.l #pzBOBMask64,(a0)

	; ---------- Copperlist ----------

	movea.l pzCopperList,a0

	; Screen configuration

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(PZ_DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #(PZ_DISPLAY_DEPTH-1)*(PZ_PLAYFIELD_DX>>3)+((PZ_PLAYFIELD_DX-DISPLAY_DX)>>3),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #(PZ_DISPLAY_DEPTH-1)*(PZ_PLAYFIELD_DX>>3)+((PZ_PLAYFIELD_DX-DISPLAY_DX)>>3),(a0)+

	; OCS compatibility with AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Bitplanes addresses

	move.w #BPL1PTH,d0
	move.l pzFrontBuffer,d1
	addi.l #PZ_BOB_DYMAX*PZ_DISPLAY_DEPTH*(PZ_PLAYFIELD_DX>>3)+(PZ_BOB_DXMAX>>3),d1
	moveq #PZ_DISPLAY_DEPTH-1,d2
_pzCopperListBitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	addi.l #PZ_PLAYFIELD_DX>>3,d1
	dbf d2,_pzCopperListBitplanes

	; Palette

	lea rzBitmap+PZ_DISPLAY_DEPTH*PZ_BITMAP_DY*(PZ_BITMAP_DX>>3),a1
	IFNE DEBUG
	move.l #$01820000,(a0)+		; A kind of NOP to preserve COLOR00 for debuging while keeping the size of the palette
	move.w #COLOR01,d1
	lea 2(a1),a1
	moveq #(1<<PZ_DISPLAY_DEPTH)-2,d0
	ELSE
	move.w #COLOR00,d1
	moveq #(1<<PZ_DISPLAY_DEPTH)-1,d0
	ENDC
_pzCopperListColors:
	move.w d1,(a0)+
	addq.w #2,d1
	move.w (a1)+,(a0)+
	dbf d0,_pzCopperListColors

	; End of Copperlist

	move.l #$FFFFFFFE,(a0)

	; Start the Copperlist

	bsr _waitVERTB
	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1
	move.l pzCopperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; Start the tune

	IFNE TUNE
	lea $DFF000,a6
	lea module,a0
	moveq #0,d0 ; start at pattern 0
	bsr mt_init
	moveq #1,d0 ; PAL timing
	move.l VBRPointer,a0
	bsr mt_install_cia
; 	lea mt_Enable(pc),a0
	movea.l #mt_Enable,a0
	st (a0)
	ENDC

	; Wait a bit to adjust the tune to the cracktro

	move.w #50,d0
	jsr _wait

	; ---------- Main loop ----------

_pzLoop:

	; ++++++++++ Restore the background behing the BOBs that must be moved or removed ++++++++++

	lea pzBOBsDataStart,a1
	move.w #PZ_NB_DISPLAYEDBOBS,d0
_pzRecover:

	; (1) BOB to ignore

	cmpi.w #PZ_STATE_TOIGNORE,OFFSET_PZBOB_STATE(a1)
	beq _pzRecoverSkipBOB

	; (2) BOB to ignore (ie : it has been copied in the background at (xFront, yFront), the position
	; where it lies in the front buffer after having been moved from (xBack, yBack) in the back buffer,
	; which means that it must be removed from the back buffer at this position, and that it must be
	; displayed at (xFront, yFront) in the back buffer, both operations coming down to : erase the
	; area from (min (xFront, xBack), min (yFront, yBack)) to (max (xFront, xBack) + width, max (yFront, yBack) + height) in the back buffer).

	cmpi.w #PZ_STATE_TOREMOVE,OFFSET_PZBOB_STATE(a1)
	bne _pzRecoverNotToRemove

	; COmpute xMin = min (xFront, xBack) and yMin = min (yFront, yBack)

	move.w OFFSET_PZBOB_FRONTX(a1),d1
	move.w OFFSET_PZBOB_BACKX(a1),d2
	cmp.w d2,d1
	ble _pzRecoverToRemoveMinXFound
	exg d1,d2
_pzRecoverToRemoveMinXFound:
	sub.w d1,d2
	addi.w OFFSET_PZBOB_DX(a1),d2

	move.w OFFSET_PZBOB_FRONTY(a1),d3
	move.w OFFSET_PZBOB_BACKY(a1),d4
	cmp.w d4,d3
	ble _pzRecoverToRemoveMinYFound
	exg d3,d4
_pzRecoverToRemoveMinYFound:
	sub.w d3,d4
	addi.w OFFSET_PZBOB_DY(a1),d4

	; Update the state of the BOB so that is will be ignored

	move.w #PZ_STATE_TOIGNORE,OFFSET_PZBOB_STATE(a1)

	; COpy the area of the background from (xMin, yMin) to (xMax + width, yMax + height) at (xMin, yMin) in the back buffer

	lea bobClearBOBData,a0
	move.w #PZ_DISPLAY_DEPTH,OFFSET_CLEARBOB_DEPTH(a0)
	move.w d1,OFFSET_CLEARBOB_X(a0)
	move.w d3,OFFSET_CLEARBOB_Y(a0)
	move.w d2,OFFSET_CLEARBOB_DX(a0)
	move.w d4,OFFSET_CLEARBOB_DY(a0)
	move.l pzFinalBuffer,OFFSET_CLEARBOB_SRC(a0)
	move.l pzBackBuffer,OFFSET_CLEARBOB_DST(a0)
	move.w #PZ_PLAYFIELD_DX,OFFSET_CLEARBOB_SRCDSTWIDTH(a0)
	bsr _bobClearBOBFast

	bra _pzRecoverSkipBOB
_pzRecoverNotToRemove:

	; (3) BOB to move (ie : it must be moved from its position in the back buffer to its position in the front buffer)

	cmpi.w #PZ_STATE_TOMOVE,OFFSET_PZBOB_STATE(a1)
	bne _pzRecoverNotToMove

	; COpy area of the background from (xBack, yBack) to (xBack + width, yBack + height) at (xBack, yBack) in the back buffer

	; The BOB must move 2 * speedX et 2 * speedY pixels from its position in the back buffer. This means that the
	; background recovering may be lmited to the area of the background that the BOB wil reveal. Since the BOB moves 
	; either horizontally or vertically, this area is either a vertical strip (to the left of the BOB if speedX >= 0, 
	; to the right if speedX < 0) or an horizontal strip (above the BOB if speedY >= 0, below if speedY < 0).

	move.w OFFSET_PZBOB_BACKX(a1),d1
	move.w OFFSET_PZBOB_BACKY(a1),d2
	move.w OFFSET_PZBOB_SPEEDX(a1),d3
	beq _pzRecoverV
	blt _pzRecoverHNegative
	move.w OFFSET_PZBOB_DY(a1),d4	
	bra _pzRecoverHVDone
_pzRecoverHNegative:
	move.w OFFSET_PZBOB_DY(a1),d4
	addi.w OFFSET_PZBOB_DX(a1),d1
	add.w d3,d1
	neg.w d3
	bra _pzRecoverHVDone
_pzRecoverV:
	move.w OFFSET_PZBOB_DX(a1),d3
	move.w OFFSET_PZBOB_SPEEDY(a1),d4
	asl.w #1,d4
	bge _pzRecoverHVDone
	addi.w OFFSET_PZBOB_DY(a1),d2
	add.w d4,d2
	neg.w d4
_pzRecoverHVDone:

	lea bobClearBOBData,a0
	move.w #PZ_DISPLAY_DEPTH,OFFSET_CLEARBOB_DEPTH(a0)
	move.w d1,OFFSET_CLEARBOB_X(a0)
	move.w d2,OFFSET_CLEARBOB_Y(a0)
	move.w d3,OFFSET_CLEARBOB_DX(a0)
	move.w d4,OFFSET_CLEARBOB_DY(a0)
	move.l pzFinalBuffer,OFFSET_CLEARBOB_SRC(a0)
	move.l pzBackBuffer,OFFSET_CLEARBOB_DST(a0)
	move.w #PZ_PLAYFIELD_DX,OFFSET_CLEARBOB_SRCDSTWIDTH(a0)
	bsr _bobClearBOBFast

; This is a non optimized version of this background recovering. The whole background area below the BOB is recovered. 
; It may be useful if the trajectories are just horizontal or vertical. Perhap's someday...
; 	lea bobClearBOBData,a0
; 	move.w #PZ_DISPLAY_DEPTH,OFFSET_CLEARBOB_DEPTH(a0)
; 	move.w OFFSET_PZBOB_BACKX(a1),OFFSET_CLEARBOB_X(a0)
; 	move.w OFFSET_PZBOB_BACKY(a1),OFFSET_CLEARBOB_Y(a0)
; 	move.w OFFSET_PZBOB_DX(a1),OFFSET_CLEARBOB_DX(a0)
; 	move.w OFFSET_PZBOB_DY(a1),OFFSET_CLEARBOB_DY(a0)
; 	move.l pzFinalBuffer,OFFSET_CLEARBOB_SRC(a0)
; 	move.l pzBackBuffer,OFFSET_CLEARBOB_DST(a0)
; 	move.w #PZ_PLAYFIELD_DX,OFFSET_CLEARBOB_SRCDSTWIDTH(a0)
; 	bsr _bobClearBOBFast

	; COmpute the new coordinates x = xFront + speedX and y = yFront + speedY

	moveq #%11,d4		; Bit 0 : 0 if the BOB has reached its final x position
						; Bit 1 : 0 if the BOB has reached its final y position

	move.w OFFSET_PZBOB_FRONTX(a1),d1
	cmp.w OFFSET_PZBOB_ENDX(a1),d1
	bne _pzMoveBOBX
	and.b #$FE,d4
	bra _pzMoveBOBXDone
_pzMoveBOBX:
	move.w OFFSET_PZBOB_SPEEDX(a1),d3
	bge _pzMoveBOBXPositive
	add.w d3,d1
	cmp.w OFFSET_PZBOB_ENDX(a1),d1
	bge _pzMoveBOBXDone
	move.w OFFSET_PZBOB_ENDX(a1),d1
	and.b #$FE,d4
	bra _pzMoveBOBXDone
_pzMoveBOBXPositive:
	add.w d3,d1
	cmp.w OFFSET_PZBOB_ENDX(a1),d1
	ble _pzMoveBOBXDone
	move.w OFFSET_PZBOB_ENDX(a1),d1
	and.b #$FE,d4
_pzMoveBOBXDone:

	move.w OFFSET_PZBOB_FRONTY(a1),d2
	cmp.w OFFSET_PZBOB_ENDY(a1),d2
	bne _pzMoveBOBY
	and.b #$FD,d4
	bra _pzMoveBOBYDone
_pzMoveBOBY:
	move.w OFFSET_PZBOB_SPEEDY(a1),d3
	bge _pzMoveBOBYPositive
	add.w d3,d2
	cmp.w OFFSET_PZBOB_ENDY(a1),d2
	bge _pzMoveBOBYDone
	move.w OFFSET_PZBOB_ENDY(a1),d2
	and.b #$FD,d4
	bra _pzMoveBOBYDone
_pzMoveBOBYPositive:
	add.w d3,d2
	cmp.w OFFSET_PZBOB_ENDY(a1),d2
	ble _pzMoveBOBYDone
	move.w OFFSET_PZBOB_ENDY(a1),d2
	and.b #$FD,d4
_pzMoveBOBYDone:

	; If the BOB has reached its final position, update its state so that it will be removed

	move.w d1,OFFSET_PZBOB_BACKX(a1)
	move.w d2,OFFSET_PZBOB_BACKY(a1)
	tst.b d4
	bne _pzRecovertToMoveKeepMoving
	move.w #PZ_STATE_TOREMOVE,OFFSET_PZBOB_STATE(a1)
_pzRecovertToMoveKeepMoving:

	bra _pzRecoverNextBOB
_pzRecoverNotToMove:

	; (4) BOB to display (ie : it just must be displayed at its starting position before it moves)

	cmpi.w #PZ_STATE_TODISPLAY,OFFSET_PZBOB_STATE(a1)
	bne _pzRecoverNotToDisplay

	; Update the state so that the BOB will be moved
	
	move.w #PZ_STATE_TOMOVE,OFFSET_PZBOB_STATE(a1)

; 	bra _pzRecoverNextBOB	; Useless. Reminder only.
_pzRecoverNotToDisplay:

	; Next BOB, as long as there are moving BOBs at BOBs left to be moved

_pzRecoverNextBOB:
	subq.w #1,d0
	beq _pzRecoverDone
_pzRecoverSkipBOB:
	lea DATASIZE_PZBOB(a1),a1
	cmpi.l #pzBOBsDataEnd,a1
	beq _pzRecoverDone
	bra _pzRecover
_pzRecoverDone:

	; ++++++++++ Display the BOBs that are moving or that must be dropped ++++++++++

	lea pzBOBsDataStart,a1
	move.w #PZ_NB_DISPLAYEDBOBS,d0
_pzDraw:

	; Ignore the BOB if it has alreay been dropped

	cmpi.w #PZ_STATE_TOIGNORE,OFFSET_PZBOB_STATE(a1)
	beq _pzDrawSkipBOB

	; Swap (xFront, yFront) and (xBack, yBack) because front and back buffers will be swapped

	move.w OFFSET_PZBOB_FRONTX(a1),d1
	move.w OFFSET_PZBOB_BACKX(a1),OFFSET_PZBOB_FRONTX(a1)
	move.w d1,OFFSET_PZBOB_BACKX(a1)
	move.w OFFSET_PZBOB_FRONTY(a1),d1
	move.w OFFSET_PZBOB_BACKY(a1),OFFSET_PZBOB_FRONTY(a1)
	move.w d1,OFFSET_PZBOB_BACKY(a1)

	;  COpy the BOB at (xFront, yFront) in the back buffer

	lea bobDrawBOBData,a0
	move.w #PZ_DISPLAY_DEPTH,OFFSET_DRAWBOB_DEPTH(a0)
	move.w OFFSET_PZBOB_FRONTX(a1),OFFSET_DRAWBOB_X(a0)
	move.w OFFSET_PZBOB_FRONTY(a1),OFFSET_DRAWBOB_Y(a0)
	moveq #0,d1
	move.w OFFSET_PZBOB_DX(a1),d1
	move.w d1,OFFSET_DRAWBOB_DX(a0)
	move.w OFFSET_PZBOB_DY(a1),OFFSET_DRAWBOB_DY(a0)
	move.w d1,d2
	lsr.b #2,d1
	subq.b #4,d1
	lea pzBOBMasks,a2
	addi.l d1,a2
	move.l (a2),OFFSET_DRAWBOB_MASK(a0)
	lsr.w #3,d2
	addq.w #2,d2
	neg.w d2
	move.w d2,OFFSET_DRAWBOB_MASKMODULO(a0)		; Alle Zeilen der Maske sind identisch, also verwenden Sie -((BOB_DX+16)>>3)
	move.l #rzBitmap,OFFSET_DRAWBOB_SRC(a0)
	move.w #PZ_BITMAP_DX,OFFSET_DRAWBOB_SRCWIDTH(a0)
	move.w OFFSET_PZBOB_SRCX(a1),OFFSET_DRAWBOB_SRCX(a0)
	move.w OFFSET_PZBOB_SRCY(a1),OFFSET_DRAWBOB_SRCY(a0)
	move.l pzBackBuffer,OFFSET_DRAWBOB_DST(a0)
	move.w #PZ_PLAYFIELD_DX,OFFSET_DRAWBOB_DSTWIDTH(a0)
	bsr _bobDrawBOB

	; COpy the BOB at (xFront, yFront) in the background, if it has to be dropped

	cmpi.w #PZ_STATE_TOREMOVE,OFFSET_PZBOB_STATE(a1)
	bne _pzDrawNextBOB

	move.l pzFinalBuffer,OFFSET_DRAWBOB_DST(a0)
	bsr _bobDrawBOB

	; Next BOB, as long as there are moving BOBs at BOBs left to be moved

_pzDrawNextBOB:
	subq.w #1,d0
	beq _pzDrawDone
_pzDrawSkipBOB:
	lea DATASIZE_PZBOB(a1),a1
	cmpi.l #pzBOBsDataEnd,a1
	beq _pzDrawDone
	bra _pzDraw
_pzDrawDone:
	move.w d0,d2

	; Swap the front and back buffers

	WAIT_BLITTER
	IFNE DEBUG
	moveq #1,d0
	jsr _wait
	ELSE
	WAIT_ENDOFFRAME
	ENDC

	move.l pzFrontBuffer,d0
	move.l pzBackBuffer,d1
	move.l d0,pzBackBuffer
	move.l d1,pzFrontBuffer
	movea.l pzCopperList,a0
	lea 10*4+2(a0),a0
	moveq #PZ_DISPLAY_DEPTH-1,d0
	move.l pzFrontBuffer,d1
	addi.l #PZ_BOB_DYMAX*PZ_DISPLAY_DEPTH*(PZ_PLAYFIELD_DX>>3)+(PZ_BOB_DXMAX>>3),d1
_pzSwapBitplanes:
	swap d1
	move.w d1,(a0)
	swap d1
	move.w d1,4(a0)
	addi.l #PZ_PLAYFIELD_DX>>3,d1
	lea 2*4(a0),a0
	dbf d0,_pzSwapBitplanes

	; Stop if there are no more BOBs to display / move

	cmpi.w #PZ_NB_DISPLAYEDBOBS,d2
	beq _pzExit
	bra _pzLoop
_pzExit:

; ********** Cut **********

; The rotozoom requires so much memory that it is'nt possible to allocate it at the beginning of the demo, because
; the puzzle requires a lot of memory itself. This means that the MOVEs can not be precalculated at the beginning
; of the demo. So, the user has to wait between the end of the puzzle and the start of the rotozoom for this
; precalculation to end. We choose to have him look at the picture during the precalculation. That's welcome, 
; because the purpose of the puzzle was to give the user an opportunity to watch a picture that required a lot of
; work before it is deformed by the rotozoom.

; So, we have to free as much memory as possible because the rotozoom requires it. Since the picture is displayed
; in bitplanes that are wider than the screen, and that we won't need such a wide area, we copy the picture into 
; smaller bitplanes and free memory allocated for the previous bitplanes. This saves
; PZ_DISPLAY_DEPTH * (2 * DISPLAY_DX * PZ_BOB_DYMAX + 2 * DISPLAY_DY * PZ_BOB_DXMAX) / 8 = 46 080 more bytes.

	; Free allocated memory

	movea.l pzBackBuffer,a1
	move.l #PZ_DISPLAY_DEPTH*PZ_PLAYFIELD_DY*(PZ_PLAYFIELD_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)			; FreeMem ()

	movea.l pzFinalBuffer,a1
	move.l #PZ_DISPLAY_DEPTH*PZ_PLAYFIELD_DY*(PZ_PLAYFIELD_DX>>3),d0
	jsr -210(a6)			; FreeMem ()

	; Allocate CHIP memory set to 0 for a redux version of the bitplanes. We use PZ_DISPLAY_DEPTH (=5) and not
	; RZ_DISPLAY_DEPTH (=4) since this last value is smaller than the first. We loose the opportunity to save
	; 320 x 256 / 8 = 10 240 more bytes but that's not a big deal...

	move.l #PZ_DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,rzFrontBuffer

	;  COpy the picture from the previous bitplanes to the new ones

	move.w #$05CC,BLTCON0(a5)	; ASH3-0=0, USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a0)
	move.w #(PZ_DISPLAY_DEPTH-1)*(PZ_PLAYFIELD_DX>>3)+((PZ_BOB_DXMAX<<1)>>3),BLTBMOD(a5)
	move.w #(PZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),BLTDMOD(a5)
	move.l pzFrontBuffer,a0
	lea PZ_DISPLAY_DEPTH*PZ_BOB_DYMAX*(PZ_PLAYFIELD_DX>>3)+(PZ_BOB_DXMAX>>3)(a0),a0
	move.l rzFrontBuffer,a1
	move.w #PZ_DISPLAY_DEPTH-1,d0
_cutCopyBitplanes:
	move.l a0,BLTBPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(DISPLAY_DY<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	lea PZ_PLAYFIELD_DX>>3(a0),a0
	lea DISPLAY_DX>>3(a1),a1
	WAIT_BLITTER
	dbf d0,_cutCopyBitplanes

	; Display the new bitplanes (not forgetting to set the modulos to the new value)

	moveq #1,d0
	jsr _wait
	movea.l pzCopperList,a0
	move.w #(PZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),7*4+2(a0)
	move.w #(PZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),8*4+2(a0)
	lea 10*4+2(a0),a0
	moveq #PZ_DISPLAY_DEPTH-1,d0
	move.l rzFrontBuffer,d1
_cutSwapBitplanes:
	swap d1
	move.w d1,(a0)
	swap d1
	move.w d1,4(a0)
	addi.l #DISPLAY_DX>>3,d1
	lea 2*4(a0),a0
	dbf d0,_cutSwapBitplanes

	; Free memory allocated for the previous bitplanes

	movea.l pzFrontBuffer,a1
	move.l #PZ_DISPLAY_DEPTH*PZ_PLAYFIELD_DY*(PZ_PLAYFIELD_DX>>3),d0
	jsr -210(a6)			; FreeMem ()

	; ---------- (Rotozoom) Setup data (start) ----------

	; Allocate any memory set to 0 for the bitmap converted in Copper MOVEs

	move.l #RZ_BITMAP_DY*RZ_BITMAP_DX*4,d0
	move.l #$10000,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,rzMoves

	; Allocate CHIP memory set to 0 for the front Copperlist

	move.l #RZ_COPPERLIST,d0
	move.l #$10002,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,rzFrontCopperList

	; Allocate CHIP memory set to 0 for the back Copperlist

	move.l #RZ_COPPERLIST,d0
	move.l #$10002,d1
	jsr -198(a6)			; AllocMem ()
	move.l d0,rzBackCopperList

	; "Copperize" the bitmap

	lea rzBitmap,a0
	movea.l a0,a1
	addi.l #BITMAP_DEPTH*BITMAP_DY*(BITMAP_DX>>3),a1
	lea RZ_BITMAP_Y*BITMAP_DEPTH*(BITMAP_DX>>3)+(RZ_BITMAP_X>>3)(a1),a1
	movea.l rzMoves,a2
	move.w #RZ_BITMAP_DY-1,d1
_rzConvertY:
	move.w #(RZ_BITMAP_DX>>3)-1,d0
_rzConvertX:
	moveq #7,d2
_rzConvertByte:
	clr.w d4
	clr.w d5
	moveq #1,d6
	moveq #BITMAP_DEPTH-1,d3
_rzConvertByteBitplanes:
	btst d2,(a0,d4.w)
	beq _rzConvertBit0
	or.b d6,d5
_rzConvertBit0:
	add.b d6,d6
	add.w #BITMAP_DX>>3,d4
	dbf d3,_rzConvertByteBitplanes
	add.w d5,d5
	move.w (a1,d5.w),(a2)+
	dbf d2,_rzConvertByte
	lea 1(a0),a0
	dbf d0,_rzConvertX
	lea (BITMAP_DEPTH-1)*(BITMAP_DX>>3)+((BITMAP_DX-RZ_BITMAP_DX)>>3)(a0),a0
	dbf d1,_rzConvertY

	; ---------- (Rotozoom) Setup data (end) ----------

	; Wait some time for the user to watch the picture

	IFEQ A500
	move.w #CT_WAIT,d0
	beq _cutNoWait
	jsr _wait
_cutNoWait:
	ENDC

	; Wait a number of frames

	moveq #CT_FADE_WAIT,d0
	jsr _wait

	; Setup the fade. The fade turn one source palette into a target palette, which is too much since we just want
	; to turn the colors of the source palette to one and only color (white) : we have to use a target palette
	; which colors are all white. Well, since only 32 colors are concerned, this is not a big wase of ressources. 
	; Let's not optimize the fade.

	lea fadeSetupData,a0
	move.l #rzBitmap+PZ_DISPLAY_DEPTH*PZ_BITMAP_DY*(PZ_BITMAP_DX>>3),OFFSET_FADESETUP_PALETTESTART(a0)
	move.l #ctPalette,OFFSET_FADESETUP_PALETTEEND(a0)
	move.w #1<<PZ_DISPLAY_DEPTH,OFFSET_FADESETUP_NBCOLORS(a0)
	move.w #CT_FADE_NBSTEPS,OFFSET_FADESETUP_NBSTEPS(a0)
	movea.l pzCopperList,a1
	lea 10*4+PZ_DISPLAY_DEPTH*2*4(a1),a1
	move.l a1,OFFSET_FADESETUP_COPPERLIST(a0)
	bsr _fadeSetup

	; Fade

_cutFade:
	moveq #CT_FADE_WAIT,d0
	jsr _wait
	bsr _fadeRun
	tst.w d0
	beq _cutFade

; ********** Rotozoom **********

; This version of the rotozoom relies on Copper loops. This means that is not possible to shift horizontally the
; bitmap 4 pixels from one line to the other, but this saves a lot of time (from [230, 250] to [185, 215] raster lines)
; and the Blitter is not required anymore !

; Since the Copperlist contains pointers to itself, both Copperlist must be built at the same time. Otherwise, it
; would be a pain in the ass to built the front Copperlist, duplicate it into the back Copperlist, and update the 
; pointers it contains so that they point to the back Copperlist.

	; ---------- Copperlist ----------

	movea.l rzFrontCopperList,a0

	; Screen configuration

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(RZ_DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #(RZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+			; Warning! Modulo for RAW blitter
	move.w #BPL2MOD,(a0)+
	move.w #(RZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),(a0)+			; Warning! Modulo for RAW blitter

	; OCS compatibility with AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Bitplanes addresses

	move.w #BPL1PTH,d0
	move.l rzFrontBuffer,d1
	move.w #RZ_DISPLAY_DEPTH-1,d2
_rzCopperListBitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+	
	addq.w #2,d0
	addi.l #DISPLAY_DX>>3,d1	; Warning! Offset for RAW blitter
	dbf d2,_rzCopperListBitplanes

	; Palette

	lea rzLogo,a1
	lea RZ_LOGO_DEPTH*RZ_LOGO_DY*(RZ_LOGO_DX>>3)(a1),a1
	IFNE DEBUG
	lea 2(a1),a1
	move.l #$01820000,(a0)+		; A kind of NOP to preserve COLOR00 for debuging while keeping the size of the palette
	move.w #COLOR01,d0
	move.w #(1<<RZ_DISPLAY_DEPTH)-2,d1
	ELSE
	move.w #COLOR00,d0
	move.w #(1<<RZ_DISPLAY_DEPTH)-1,d1
	ENDC
_rzCopperListPalette:
	move.w d0,(a0)+
	addq.w #2,d0
	move.w (a1)+,(a0)+
	dbf d1,_rzCopperListPalette

	; Duplicate the previous part in the back Copperlist

	movea.l rzFrontCopperList,a0
	movea.l rzBackCopperList,a1
	move.w #((10*4+RZ_DISPLAY_DEPTH*2*4+(1<<RZ_DISPLAY_DEPTH)*4)>>2)-1,d0
_rzCopperListDuplicate:
	move.l (a0)+,(a1)+
	dbf d0,_rzCopperListDuplicate

	;  COpper screen

	lea rzWAITs,a2
	lea rzSKIPs,a3

	move.l (a2),(a0)+
	move.l (a2)+,(a1)+

	move.w #28-1,d0
_rzCopperScreenWaits0:
	move.l a0,d1
	addq.l #2*4,d1
	move.w #COP1LCL,(a0)+
	move.w d1,(a0)+
	swap d1
	move.w #COP1LCH,(a0)+
	move.w d1,(a0)+
	move.l a1,d1
	addq.l #2*4,d1
	move.w #COP1LCL,(a1)+
	move.w d1,(a1)+
	swap d1
	move.w #COP1LCH,(a1)+
	move.w d1,(a1)+
	move.l (a2),(a0)+
	move.l (a2)+,(a1)+
	move.w #RZ_COPPER_DX,d1
_rzCopperScreenMoves0:
	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+
	move.w #COLOR00,(a1)+
	move.w #$0000,(a1)+
	dbf d1,_rzCopperScreenMoves0
	move.l (a3),(a0)+
	move.l (a3)+,(a1)+
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+
	move.w #COPJMP1,(a1)+
	move.w #$0000,(a1)+
	dbf d0,_rzCopperScreenWaits0

	move.l (a2),(a0)+
	move.l (a2)+,(a1)+
	move.w #RZ_COPPER_DX,d0
_rzCopperScreenMoves1:
	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+
	move.w #COLOR00,(a1)+
	move.w #$0000,(a1)+
	dbf d0,_rzCopperScreenMoves1

	move.w #6-1,d0
_rzCopperScreenWaits2:
	move.l a0,d1
	addq.l #2*4,d1
	move.w #COP1LCL,(a0)+
	move.w d1,(a0)+
	swap d1
	move.w #COP1LCH,(a0)+
	move.w d1,(a0)+
	move.l a1,d1
	addq.l #2*4,d1
	move.w #COP1LCL,(a1)+
	move.w d1,(a1)+
	swap d1
	move.w #COP1LCH,(a1)+
	move.w d1,(a1)+
	move.l (a2),(a0)+
	move.l (a2)+,(a1)+
	move.w #RZ_COPPER_DX,d1
_rzCopperScreenMoves2:
	move.w #COLOR00,(a0)+
	move.w #$0000,(a0)+
	move.w #COLOR00,(a1)+
	move.w #$0000,(a1)+
	dbf d1,_rzCopperScreenMoves2
	move.l (a3),(a0)+
	move.l (a3)+,(a1)+
	move.w #COPJMP1,(a0)+
	move.w #$0000,(a0)+
	move.w #COPJMP1,(a1)+
	move.w #$0000,(a1)+
	dbf d0,_rzCopperScreenWaits2

	; The contents of COP1LCH/L must be restored (but it is going to change because of double buffering at the end of each loop anyway)

	move.l rzFrontCopperList,d0
	move.w #COP1LCL,(a0)+
	move.w d0,(a0)+
	swap d0
	move.w #COP1LCH,(a0)+
	move.w d0,(a0)+
	move.l rzBackCopperList,d0
	move.w #COP1LCL,(a1)+
	move.w d0,(a1)+
	swap d0
	move.w #COP1LCH,(a1)+
	move.w d0,(a1)+

	move.l #$FFFFFFFE,(a0)
	move.l #$FFFFFFFE,(a1)

	; Clear all the bitplanes

	moveq #1,d0
	jsr _wait

	move.w #$0100,BLTCON0(a5)	; USEA=0, USEB=0, USEC=0, USED=1, D=0
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTDMOD(a5)
	move.l rzFrontBuffer,BLTDPTH(a5)
	move.w #((RZ_DISPLAY_DEPTH*DISPLAY_DY)<<6)!(DISPLAY_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Start the Copperlist

	bsr _waitVERTB
	move.w #$8180,DMACON(a5)	;  BPLEN=1, COPEN=1
	move.l rzFrontCopperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

	; ---------- Initializations ----------

	;  COpy the logo

	move.w #$03AA,BLTCON0(a5)		; ASH3-0=0, USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	move.w #0,BLTCMOD(a5)
	move.w #(DISPLAY_DX-RZ_LOGO_DX)>>3,BLTDMOD(a5)
	move.l #rzLogo,BLTCPTH(a5)
	movea.l rzFrontBuffer,a0
	lea RZ_DISPLAY_DEPTH*RZ_LOGO_Y*(DISPLAY_DX>>3)+((DISPLAY_DX-RZ_LOGO_DX)>>4)(a0),a0
	move.l a0,BLTDPTH(a5)
	move.w #((RZ_DISPLAY_DEPTH*RZ_LOGO_DY)<<6)!(RZ_LOGO_DX>>4),BLTSIZE(a5)
	WAIT_BLITTER

	; Printer setup

	lea prtSetupData,a0
	move.l rzFrontBuffer,d0
	addi.l #((RZ_TEXTBITPLANE-1)+RZ_TEXTY*RZ_DISPLAY_DEPTH)*(DISPLAY_DX>>3),d0
	move.l d0,OFFSET_PRINTERSETUP_BITPLANE(a0)
	move.w #DISPLAY_DX>>3,OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0)
	move.w #(RZ_DISPLAY_DEPTH-1)*(DISPLAY_DX>>3),OFFSET_PRINTERSETUP_BITPLANEMODULO(a0)
	move.w #RZ_TEXTDY,OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a0)
	move.b #RZ_TEXTCHARDELAY,OFFSET_PRINTERSETUP_CHARDELAY(a0)
	move.w #RZ_TEXTPAGEDELAY,OFFSET_PRINTERSETUP_PAGEDELAY(a0)
	move.l #font,OFFSET_PRINTERSETUP_FONT(a0)
	move.l #printerText,OFFSET_PRINTERSETUP_TEXT(a0)
	bsr _prtSetup

	; Rotozoom setup

	move.w #(360-1)<<1,rzAngle
	move.w #RZ_WINDOW_DXMIN,rzWindowDX
	move.w #RZ_WINDOW_DXMIN,rzWindowDXMin
	move.w #RZ_WINDOW_DXMAX,rzWindowDXMax
	move.w #-1,accumulator0
	move.w #RZ_WINDOW_DYMIN,rzWindowDY
	move.w #RZ_WINDOW_DYMIN,rzWindowDYMin
	move.w #RZ_WINDOW_DYMAX,rzWindowDYMax
	move.w #-1,accumulator1
	move.w #RZ_ZOOM_STEPS,rzZoomSteps

	; ---------- Main loop ----------

_rzLoop:

	; Printer

	bsr _prtStep

	; Update the coordinates of the vertices of the Copper screen in the picture

	lea rzPoints,a0
	move.w rzWindowDX,d0
	lsr.w #1,d0
	move.w d0,4(a0)
	move.w d0,8(a0)
	neg.w d0
	move.w d0,(a0)
	move.w d0,12(a0)
	move.w rzWindowDY,d0
	lsr.w #1,d0
	move.w d0,10(a0)
	move.w d0,14(a0)
	neg.w d0
	move.w d0,2(a0)
	move.w d0,6(a0)

	; COmpute the images of the vertices of the Copper screen in the picture after a rotation

	lea sinus,a0
	move.w rzAngle,d0
	move.w (a0,d0.w),d1
	swap d1
	lea cosinus,a0
	move.w (a0,d0.w),d1
	move.l #((1<<3)<<16)!(1<<3),d2	; A factor K must be multiplie by 2^3
	move.l #((RZ_BITMAP_DY>>1)<<16)!(RZ_BITMAP_DX>>1),d3
	moveq #4,d0
	lea rzPoints,a0
	lea rzTPoints,a1
	bsr _transform

	;  COmpute the amplitudes and the increments of the top horizontal edge H (ie : AB)

	lea rzTPoints,a0

	moveq #2,d1
	move.w 4(a0),d0
	sub.w (a0),d0
	bge _rzDXHPositive
	neg.w d0
	neg.w d1
_rzDXHPositive:
	addq.w #1,d0
	move.w d0,rzDXH
	move.w d1,rzIncXH

	move.w #RZ_BITMAP_DX<<1,d1
	move.w 6(a0),d0
	sub.w 2(a0),d0
	bge _rzDYHPositive
	neg.w d0
	neg.w d1
_rzDYHPositive:
	addq.w #1,d0
	move.w d0,rzDYH
	move.w d1,rzIncYH

	; COmpute the amplitudes and the increments of the left vertical edge V (ie : AD)

	moveq #2,d1
	move.w 12(a0),d0
	sub.w (a0),d0
	bge _rzDXVPositive
	neg.w d0
	neg.w d1
_rzDXVPositive:
	addq.w #1,d0
	move.w d0,rzDXV
	move.w d1,rzIncXV

	move.w #RZ_BITMAP_DX<<1,d1
	move.w 14(a0),d0
	sub.w 2(a0),d0
	bge _rzDYVPositive
	neg.w d0
	neg.w d1
_rzDYVPositive:
	addq.w #1,d0
	move.w d0,rzDYV
	move.w d1,rzIncYV

	; COmpute the offsets along the vertical side (AB)

	move.w rzDXV,d0
	move.w rzDYV,d1
	move.w rzIncXV,d5
	move.w rzIncYV,d6
	clr.w d7
	lea rzOffsetsV,a0
	cmp.w d1,d0
	bge _rzDrawSideVDXVGreaterThanDYV
	; ---------- (1) DXV < DYV ----------
	cmpi.w #RZ_COPPER_DY,d1
	bgt _rzDrawSideVDYVGreaterThanCOPPERDY
	; ---------- (1.a) DXV < DYV and DYV <= RZ_COPPER_DY ----------
	move.w #RZ_COPPER_DY-1,d2
	clr.w d3					; Accumulator DYV / RZ_COPPER_DY
	clr.w d4					; Accumulator DXV / DYV
; 	clr.w dx
_rzDrawSideV1a:
	move.w d7,(a0)+
	clr.w d7
	add.w d1,d3
	cmpi.w #RZ_COPPER_DY,d3
	blt _rzDrawSideV1aNoDYVOverCOPPERDYOveflow
	subi.w #RZ_COPPER_DY,d3

	add.w d0,d4
	cmp.w d1,d4
	blt _rzDrawSideV1aNoDXVOverDYVOverflow
	sub.w d1,d4
; 	add rzAspectRatioMin,dx
; 	cmp.w rzAspectRatioMax,dx
; 	blt _rzDrawSideV1aNoDXVOverDYVOverflow
; 	sub.w rzAspectRatioMax,dx
	add.w d5,d7
_rzDrawSideV1aNoDXVOverDYVOverflow:
	add.w d6,d7


_rzDrawSideV1aNoDYVOverCOPPERDYOveflow:
	dbf d2,_rzDrawSideV1a
	bra _rzDrawSideVDone
	; ---------- (1.b) DXV < DYV and DYV > RZ_COPPER_DY ----------
_rzDrawSideVDYVGreaterThanCOPPERDY:
	move.w d1,d2
	subq.w #2,d2				; Because DYV = |YD - YA| + 1
	move.w #RZ_COPPER_DY-1,d3	; Accumulator RZ_COPPER_DY-1 / DYV
	clr.w d4					; Accumulator DXV / DYV
	move.w d7,(a0)+
_rzDrawSideV1b:
	add.w d6,d7
	add.w d0,d4
	cmp.w d1,d4
	blt _rzDrawSideV1bNoDXVOverDYVOverflow
	sub.w d1,d4
	add.w d5,d7
_rzDrawSideV1bNoDXVOverDYVOverflow:
	addi.w #RZ_COPPER_DY-1,d3
	cmp.w d1,d3
	blt _rzDrawSideV1bNoCOPPERDYOverDYVOverflow
	sub.w d1,d3
	move.w d7,(a0)+
	clr.w d7
_rzDrawSideV1bNoCOPPERDYOverDYVOverflow:
	dbf d2,_rzDrawSideV1b
	bra _rzDrawSideVDone
	; ---------- (2) DXV >= DYV ----------
_rzDrawSideVDXVGreaterThanDYV:
	cmpi.w #RZ_COPPER_DY,d0
	bgt _rzDrawSideVDXVGreaterThanCOPPERDY
	; ---------- (2.a) DXV >= DYV and DXV <= RZ_COPPER_DY ----------
	move.w #RZ_COPPER_DY-1,d2
	clr.w d3					; Accumulator DXV / RZ_COPPER_DY
	clr.w d4					; Accumulator DYV / DXV
_rzDrawSideV2a:
	move.w d7,(a0)+
	clr.w d7
	add.w d0,d3
	cmpi.w #RZ_COPPER_DY,d3
	blt _rzDrawSideV2aNoDXVOverCOPPERDYOveflow
	subi.w #RZ_COPPER_DY,d3
	add.w d1,d4
	cmp.w d0,d4
	blt _rzDrawSideV2aNoDYVOverDXVOverflow
	sub.w d0,d4
	add.w d6,d7
_rzDrawSideV2aNoDYVOverDXVOverflow:
	add.w d5,d7
_rzDrawSideV2aNoDXVOverCOPPERDYOveflow:
	dbf d2,_rzDrawSideV2a
	bra _rzDrawSideVDone
	; ---------- (2.b) DXV >= DYV and DXV > RZ_COPPER_DY ----------
_rzDrawSideVDXVGreaterThanCOPPERDY:
	move.w d0,d2
	subq.w #2,d2				; Because DYV = |YD - YA| + 1
	move.w #RZ_COPPER_DY-1,d3	; Accumulator RZ_COPPER_DY-1 / DXV
	clr.w d4					; Accumulator DYV / DXV
	move.w d7,(a0)+
_rzDrawSideV2b:
	add.w d5,d7
	add.w d1,d4
	cmp.w d0,d4
	blt _rzDrawSideV2bNoDYVOverDXVOverflow
	sub.w d0,d4
	add.w d6,d7
_rzDrawSideV2bNoDYVOverDXVOverflow:
	addi.w #RZ_COPPER_DY-1,d3
	cmp.w d0,d3
	blt _rzDrawSideV2bNoCOPPERDYOverDXVOverflow
	sub.w d0,d3
	move.w d7,(a0)+
	clr.w d7
_rzDrawSideV2bNoCOPPERDYOverDXVOverflow:
	dbf d2,_rzDrawSideV2b
_rzDrawSideVDone:

	; COmpute the offsets along the horizontal edge (AD) (this is the same code)

	move.w rzDXH,d0
	move.w rzDYH,d1
	move.w rzIncXH,d5
	move.w rzIncYH,d6
	clr.w d7
	lea rzOffsetsH,a0
	cmp.w d1,d0
	bge _rzDrawSideHDXHGreaterThanDYH
	; ---------- (1) DXH < DYH ----------
	cmpi.w #RZ_COPPER_DX,d1
	bgt _rzDrawSideHDYHGreaterThanCOPPERDX
	; ---------- (1.a) DXH < DYH and DYH <= RZ_COPPER_DX ----------
	move.w #RZ_COPPER_DX-1,d2
	clr.w d3					; Accumulator DYH / RZ_COPPER_DX
	clr.w d4					; Accumulator DXH / DYH
_rzDrawSideH1a:
	move.w d7,(a0)+
	clr.w d7
	add.w d1,d3
	cmpi.w #RZ_COPPER_DX,d3
	blt _rzDrawSideH1aNoDYHOverCOPPERDXOveflow
	subi.w #RZ_COPPER_DX,d3
	add.w d0,d4
	cmp.w d1,d4
	blt _rzDrawSideH1aNoDXHOverDYHOverflow
	sub.w d1,d4
	add.w d5,d7
_rzDrawSideH1aNoDXHOverDYHOverflow:
	add.w d6,d7
_rzDrawSideH1aNoDYHOverCOPPERDXOveflow:
	dbf d2,_rzDrawSideH1a
	bra _rzDrawSideHDone
	; ---------- (1.b) DXH < DYH and DYH > RZ_COPPER_DX ----------
_rzDrawSideHDYHGreaterThanCOPPERDX:
	move.w d1,d2
	subq.w #2,d2				; Car DYH = |YD - YA| + 1
	move.w #RZ_COPPER_DX-1,d3	; Accumulator RZ_COPPER_DX-1 / DYH
	clr.w d4					; Accumulator DXH / DYH
	move.w d7,(a0)+
_rzDrawSideH1b:
	add.w d6,d7
	add.w d0,d4
	cmp.w d1,d4
	blt _rzDrawSideH1bNoDXHOverDYHOverflow
	sub.w d1,d4
	add.w d5,d7
_rzDrawSideH1bNoDXHOverDYHOverflow:
	addi.w #RZ_COPPER_DX-1,d3
	cmp.w d1,d3
	blt _rzDrawSideH1bNoCOPPERDXOverDYHOverflow
	sub.w d1,d3
	move.w d7,(a0)+
	clr.w d7
_rzDrawSideH1bNoCOPPERDXOverDYHOverflow:
	dbf d2,_rzDrawSideH1b
	bra _rzDrawSideHDone
	; ---------- (2) DXH >= DYH ----------
_rzDrawSideHDXHGreaterThanDYH:
	cmpi.w #RZ_COPPER_DX,d0
	bgt _rzDrawSideHDXHGreaterThanCOPPERDX
	; ---------- (2.a) DXH >= DYH and DXH <= RZ_COPPER_DX ----------
	move.w #RZ_COPPER_DX-1,d2
	clr.w d3					; Accumulator DXH / RZ_COPPER_DX
	clr.w d4					; Accumulator DYH / DXH
_rzDrawSideH2a:
	move.w d7,(a0)+
	clr.w d7
	add.w d0,d3
	cmpi.w #RZ_COPPER_DX,d3
	blt _rzDrawSideH2aNoDXHOverCOPPERDXOveflow
	subi.w #RZ_COPPER_DX,d3
	add.w d1,d4
	cmp.w d0,d4
	blt _rzDrawSideH2aNoDYHOverDXHOverflow
	sub.w d0,d4
	add.w d6,d7
_rzDrawSideH2aNoDYHOverDXHOverflow:
	add.w d5,d7
_rzDrawSideH2aNoDXHOverCOPPERDXOveflow:
	dbf d2,_rzDrawSideH2a
	bra _rzDrawSideHDone
	; ---------- (2.b) DXH >= DYH and DXH > RZ_COPPER_DX ----------
_rzDrawSideHDXHGreaterThanCOPPERDX:
	move.w d0,d2
	subq.w #2,d2				; Because DYH = |YD - YA| + 1
	move.w #RZ_COPPER_DX-1,d3	; Accumulator RZ_COPPER_DX-1 / DXH
	clr.w d4					; Accumulator DYH / DXH
	move.w d7,(a0)+
_rzDrawSideH2b:
	add.w d5,d7
	add.w d1,d4
	cmp.w d0,d4
	blt _rzDrawSideH2bNoDYHOverDXHOverflow
	sub.w d0,d4
	add.w d6,d7
_rzDrawSideH2bNoDYHOverDXHOverflow:
	addi.w #RZ_COPPER_DX-1,d3
	cmp.w d0,d3
	blt _rzDrawSideH2bNoCOPPERDXOverDXHOverflow
	sub.w d0,d3
	move.w d7,(a0)+
	clr.w d7
_rzDrawSideH2bNoCOPPERDXOverDXHOverflow:
	dbf d2,_rzDrawSideH2b
_rzDrawSideHDone:

	; Using the offsets, draw the lines in the Copper screen

	lea rzTPoints,a0
	moveq #0,d0
	move.w (a0),d0
	add.w d0,d0
	move.w 2(a0),d1
	mulu #RZ_BITMAP_DX<<1,d1
	add.l d1,d0				; D0 and D1 are LONG so that the size of the image is not too mush limited 
							; (the offset does not fit on 16 bits if the picture is made of 320x200 WORDs)
	movea.l rzMoves,a0
	add.l d0,a0
	lea rzOffsetsV,a1
	movea.l rzBackCopperList,a2

	lea 10*4+RZ_DISPLAY_DEPTH*2*4+(1<<RZ_DISPLAY_DEPTH)*4+4*4+2(a2),a2
	move.w #11-1,d0
_rzDrawRows0:
	move.w (a1)+,d1
	lea (a0,d1.w),a0
	movea.l a0,a3
	lea rzOffsetsH,a4
	move.w #RZ_COPPER_DX-1,d2
_rzDrawColumns0:
	move.w (a4)+,d3
	lea (a3,d3.w),a3
	move.w (a3),(a2)
	lea 4(a2),a2
	dbf d2,_rzDrawColumns0
	lea 6*4(a2),a2
	dbf d0,_rzDrawRows0

	subq.l #2,a1
	neg.w d1
	lea (a0,d1.w),a0
	move.w #17-1,d0
_rzDrawRows1:
	move.w (a1)+,d1
	lea (a0,d1.w),a0
	movea.l a0,a3
	lea rzOffsetsH,a4
	move.w #RZ_COPPER_DX-1,d2
_rzDrawColumns1:
	move.w (a4)+,d3
	lea (a3,d3.w),a3
	move.w (a3),(a2)
	lea 4(a2),a2
	dbf d2,_rzDrawColumns1
	lea 6*4(a2),a2
	dbf d0,_rzDrawRows1

	subq.l #2*4,a2
	movea.l a0,a3
	lea rzOffsetsH,a4
	move.w #RZ_COPPER_DX-1,d2
_rzDrawColumns2:
	move.w (a4)+,d3
	lea (a3,d3.w),a3
	move.w (a3),(a2)
	lea 4(a2),a2
	dbf d2,_rzDrawColumns2
	lea 4*4(a2),a2

	subq.l #2,a1
	neg.w d1
	lea (a0,d1.w),a0
	move.w #6-1,d0
_rzDrawRows2:
	move.w (a1)+,d1
	lea (a0,d1.w),a0
	movea.l a0,a3
	lea rzOffsetsH,a4
	move.w #RZ_COPPER_DX-1,d2
_rzDrawColumns3:
	move.w (a4)+,d3
	lea (a3,d3.w),a3
	move.w (a3),(a2)
	lea 4(a2),a2
	dbf d2,_rzDrawColumns3
	lea 6*4(a2),a2
	dbf d0,_rzDrawRows2

	; Animate the vertices of the Copper screen in the picture

	move.w rzWindowDXMin,d0
	move.w rzWindowDXMax,d1
	move.w #RZ_ZOOM_STEPS-1,d2
	move.w accumulator0,d3
	move.w rzWindowDX,d4
	bsr _interpolate
	move.w d4,rzWindowDX
	move.w d3,accumulator0

	move.w rzWindowDYMin,d0
	move.w rzWindowDYMax,d1
	move.w #RZ_ZOOM_STEPS-1,d2
	move.w accumulator1,d3
	move.w rzWindowDY,d4
	bsr _interpolate
	move.w d4,rzWindowDY
	move.w d3,accumulator1

	move.w rzZoomSteps,d0
	subq.w #1,d0
	bne _rzZoomNotDone
	move.w #RZ_ZOOM_STEPS,d0
	move.w rzWindowDXMin,d1
	move.w rzWindowDXMax,d2
	move.w d2,rzWindowDXMin
	move.w d1,rzWindowDXMax
	move.w rzWindowDYMin,d1
	move.w rzWindowDYMax,d2
	move.w d2,rzWindowDYMin
	move.w d1,rzWindowDYMax
_rzZoomNotDone:
	move.w d0,rzZoomSteps

	; Animate the angle

	move.w rzAngle,d0
	sub.w #RZ_ANGLE_SPEED<<1,d0
	bge _rzAngleNoUnderflow
	add.w #360<<1,d0
_rzAngleNoUnderflow:
	move.w d0,rzAngle

	; Wait for the VERTB

	IFNE DEBUG
	movea.l rzFrontBuffer,a0
	bsr _showTime
	moveq #1,d0
	bsr _wait
	ELSE
	WAIT_ENDOFFRAME
	ENDC

	; Swap the front and the back Copperlists

	move.l rzFrontCopperList,d0
	move.l rzBackCopperList,rzFrontCopperList
	move.l d0,rzBackCopperList
	move.l rzFrontCopperList,COP1LCH(a5)
; 	clr.w COPJMP1(a5)

	; Test if left mouse button is pressed

	btst #6,$BFE001
	bne _rzLoop

	; End the tune

	IFNE TUNE
; 	lea mt_Enable(pc),a0
	movea.l #mt_Enable,a0
	sf (a0)
	lea $DFF000,a6
	bsr mt_end
	ENDC

	; End the printer

	bsr _prtEnd

; ********** Finalizations **********

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

	movea.l pzCopperList,a1
	move.l #PZ_COPPERLIST,d0
	jsr -210(a6)		; FreeMem ()

	movea.l rzFrontCopperList,a1
	move.l #RZ_COPPERLIST,d0
	jsr -210(a6)		; FreeMem ()

	movea.l rzBackCopperList,a1
	move.l #RZ_COPPERLIST,d0
	jsr -210(a6)		; FreeMem ()

	movea.l rzFrontBuffer,a1
; And not RZ_DISPLAY_DEPTH: see transition
	move.l #PZ_DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	jsr -210(a6)		; FreeMem ()

	movea.l rzMoves,a1
	move.l #RZ_BITMAP_DY*RZ_BITMAP_DX*4,d0
	jsr -210(a6)		; FreeMem ()

	; Unstack registers

	movem.l (sp)+,d0-d7/a0-a6
	rts

; ********** Routines **********

; ---------- Transform a set of points ----------

; Input(s) :
; 	A0 = Address of points to be transformed
; 	A1 = Address of transformed points
; 	D0 = Number of points
; 	D1 = Angle (sinus:cosinus) (signed interger values : v*2^14)
; 	D2 = Zoom factors (sy:sx) (signed integer values : v*2^3)
; 	D3 = Translation (dy:dx)
; Registers usage :
; 	=D0 =D1 =D2 =D3 *D4 *D5 *D6 =D7 =A0 *A1 =A2 =A3 =A4 =A5 =A6

_transform:
	movem.l d4-d6/a1,-(sp)

_transformLoop:

	; Rotation

	move.w (a0),d4
	muls d1,d4				; D4 = x*cos
	move.w 2(a0),d5
	muls d1,d5				; D5 = y*cos
	swap d1
	move.w (a0)+,d6
	muls d1,d6				; D6 = x*sin
	sub.l d6,d5				; D5 = y*cos - x*sin
	swap d5
	rol.l #2,d5
	move.w (a0)+,d6
	muls d1,d6				; D6 = y*sin
	add.l d6,d4				; D4 = x*cos + y*sin
	swap d1
	swap d4
	rol.l #2,d4

	; Zoom

	muls d2,d5
	ror.l #3,d5
	swap d2
	muls d2,d4
	ror.l #3,d4
	swap d2

	; Translation

	add.w d3,d5
	swap d3
	add.w d3,d4
	swap d3

	; Storage

	move.w d4,(a1)+
	move.w d5,(a1)+
	subq.w #1,d0
	bne _transformLoop

	movem.l (sp)+,d4-d6/a1
	rts

	INCLUDE "common/registers.s"
	INCLUDE "common/wait.s"
	INCLUDE "common/interpolate.s"
	INCLUDE "common/bob.s"
	INCLUDE "common/fade.s"
	INCLUDE "common/advancedPrinter.s"
	IFNE DEBUG
	INCLUDE "common/debug.s"
	ENDC
	IFNE TUNE
	INCLUDE "common/ptplayer/ptplayer_FINAL.s"
	ENDC

; ********** Data **********

	SECTION data,DATA_C

; ---------- Program ----------

vector30:			DC.L 0
VBRPointer:			DC.L 0
olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
graphicsBase:		DC.L 0
view:				DC.L 0

; ---------- Puzzle ----------

pzCopperList:		DC.L 0
pzFrontBuffer:		DC.L 0
pzBackBuffer:		DC.L 0
pzFinalBuffer:		DC.L 0
pzBOBMask16:		BLK.W 16>>4,$FFFF
					DC.W $0000
pzBOBMask32:		BLK.W 32>>4,$FFFF
					DC.W $0000
pzBOBMask48:		BLK.W 48>>4,$FFFF
					DC.W $0000
pzBOBMask64:		BLK.W 64>>4,$FFFF
					DC.W $0000
pzBOBMasks:			BLK.L 4,0
pzBOBsDataStart:
; For each BOB (y being an offset): width (multiple of 16), height, source (x, y), front buffer (x, y), back buffer (x, y), 
; arrival (x, y), speed (x, y), state (PZ_STATE_TODISPLAY=0)
; Generated with a custom tool (sheet "puzzle" in "Amiga.xlsm" Excel file)
OFFSET_PZBOB_DX=0
OFFSET_PZBOB_DY=2
OFFSET_PZBOB_SRCX=4
OFFSET_PZBOB_SRCY=6
OFFSET_PZBOB_FRONTX=8
OFFSET_PZBOB_FRONTY=10
OFFSET_PZBOB_BACKX=12
OFFSET_PZBOB_BACKY=14
OFFSET_PZBOB_ENDX=16
OFFSET_PZBOB_ENDY=18
OFFSET_PZBOB_SPEEDX=20
OFFSET_PZBOB_SPEEDY=22
OFFSET_PZBOB_STATE=24
DATASIZE_PZBOB=26
	IFNE A500
	DC.W 16, 16, 64, 0, 352, 32, 352, 32, 96, 32, -7, 0, 0
	DC.W 16, 16, 32, 240, 64, 288, 64, 288, 64, 272, 0, -7, 0
	DC.W 32, 32, 240, 224, 352, 256, 352, 256, 272, 256, -8, 0, 0
	DC.W 32, 32, 16, 128, 48, 288, 48, 288, 48, 160, 0, -5, 0
	DC.W 16, 16, 240, 144, 272, 288, 272, 288, 272, 176, 0, -6, 0
	DC.W 32, 32, 240, 0, 0, 32, 0, 32, 272, 32, 6, 0, 0
	DC.W 16, 16, 144, 64, 176, 0, 176, 0, 176, 96, 0, 6, 0
	DC.W 32, 32, 80, 48, 352, 80, 352, 80, 112, 80, -6, 0, 0
	DC.W 16, 16, 304, 96, 336, 288, 336, 288, 336, 128, 0, -8, 0
	DC.W 16, 16, 272, 176, 352, 208, 352, 208, 304, 208, -5, 0, 0
	DC.W 16, 16, 0, 80, 32, 0, 32, 0, 32, 112, 0, 6, 0
	DC.W 16, 16, 128, 224, 352, 256, 352, 256, 160, 256, -8, 0, 0
	DC.W 32, 32, 160, 96, 352, 128, 352, 128, 192, 128, -5, 0, 0
	DC.W 16, 16, 176, 80, 208, 288, 208, 288, 208, 112, 0, -6, 0
	DC.W 32, 32, 48, 192, 352, 224, 352, 224, 80, 224, -5, 0, 0
	DC.W 32, 32, 240, 176, 272, 0, 272, 0, 272, 208, 0, 6, 0
	DC.W 16, 16, 192, 192, 352, 224, 352, 224, 224, 224, -6, 0, 0
	DC.W 32, 32, 112, 80, 0, 112, 0, 112, 144, 112, 5, 0, 0
	DC.W 16, 16, 160, 48, 192, 0, 192, 0, 192, 80, 0, 5, 0
	DC.W 16, 16, 0, 224, 32, 288, 32, 288, 32, 256, 0, -5, 0
	DC.W 16, 16, 112, 112, 0, 144, 0, 144, 144, 144, 8, 0, 0
	DC.W 16, 16, 32, 160, 0, 192, 0, 192, 64, 192, 8, 0, 0
	DC.W 16, 16, 32, 96, 0, 128, 0, 128, 64, 128, 5, 0, 0
	DC.W 32, 32, 288, 64, 320, 0, 320, 0, 320, 96, 0, 6, 0
	DC.W 32, 32, 240, 32, 272, 288, 272, 288, 272, 64, 0, -5, 0
	DC.W 16, 16, 96, 112, 128, 0, 128, 0, 128, 144, 0, 7, 0
	DC.W 16, 16, 144, 80, 0, 112, 0, 112, 176, 112, 7, 0, 0
	DC.W 32, 32, 48, 160, 0, 192, 0, 192, 80, 192, 6, 0, 0
	DC.W 16, 16, 160, 240, 0, 272, 0, 272, 192, 272, 5, 0, 0
	DC.W 16, 16, 224, 32, 352, 64, 352, 64, 256, 64, -6, 0, 0
	DC.W 16, 16, 256, 64, 0, 96, 0, 96, 288, 96, 7, 0, 0
	DC.W 16, 16, 272, 208, 0, 240, 0, 240, 304, 240, 5, 0, 0
	DC.W 16, 16, 32, 176, 352, 208, 352, 208, 64, 208, -7, 0, 0
	DC.W 16, 16, 64, 48, 352, 80, 352, 80, 96, 80, -5, 0, 0
	DC.W 16, 16, 160, 160, 192, 0, 192, 0, 192, 192, 0, 7, 0
	DC.W 32, 32, 144, 208, 352, 240, 352, 240, 176, 240, -5, 0, 0
	DC.W 32, 32, 176, 48, 208, 288, 208, 288, 208, 80, 0, -7, 0
	DC.W 16, 16, 0, 144, 352, 176, 352, 176, 32, 176, -8, 0, 0
	DC.W 16, 16, 176, 0, 208, 0, 208, 0, 208, 32, 0, 7, 0
	DC.W 16, 16, 96, 32, 128, 288, 128, 288, 128, 64, 0, -6, 0
	DC.W 32, 32, 32, 0, 352, 32, 352, 32, 64, 32, -7, 0, 0
	DC.W 16, 16, 224, 128, 256, 0, 256, 0, 256, 160, 0, 8, 0
	DC.W 16, 16, 224, 96, 0, 128, 0, 128, 256, 128, 8, 0, 0
	DC.W 32, 32, 192, 80, 224, 288, 224, 288, 224, 112, 0, -6, 0
	DC.W 16, 16, 80, 208, 0, 240, 0, 240, 112, 240, 7, 0, 0
	DC.W 16, 16, 160, 144, 352, 176, 352, 176, 192, 176, -5, 0, 0
	DC.W 32, 32, 176, 16, 208, 0, 208, 0, 208, 48, 0, 6, 0
	DC.W 16, 16, 304, 16, 0, 48, 0, 48, 336, 48, 7, 0, 0
	DC.W 32, 32, 176, 224, 0, 256, 0, 256, 208, 256, 6, 0, 0
	DC.W 16, 16, 160, 128, 192, 288, 192, 288, 192, 160, 0, -7, 0
	DC.W 16, 16, 96, 192, 352, 224, 352, 224, 128, 224, -6, 0, 0
	DC.W 16, 16, 208, 32, 0, 64, 0, 64, 240, 64, 5, 0, 0
	DC.W 16, 16, 224, 80, 256, 288, 256, 288, 256, 112, 0, -8, 0
	DC.W 32, 32, 208, 144, 240, 0, 240, 0, 240, 176, 0, 5, 0
	DC.W 16, 16, 16, 96, 48, 288, 48, 288, 48, 128, 0, -7, 0
	DC.W 16, 16, 0, 64, 32, 288, 32, 288, 32, 96, 0, -6, 0
	DC.W 16, 16, 160, 192, 192, 0, 192, 0, 192, 224, 0, 6, 0
	DC.W 16, 16, 208, 128, 240, 288, 240, 288, 240, 160, 0, -6, 0
	DC.W 16, 16, 0, 208, 32, 0, 32, 0, 32, 240, 0, 5, 0
	DC.W 32, 32, 112, 176, 144, 288, 144, 288, 144, 208, 0, -6, 0
	DC.W 32, 32, 144, 16, 0, 48, 0, 48, 176, 48, 7, 0, 0
	DC.W 16, 16, 208, 176, 0, 208, 0, 208, 240, 208, 5, 0, 0
	DC.W 16, 16, 48, 128, 80, 0, 80, 0, 80, 160, 0, 5, 0
	DC.W 16, 16, 272, 144, 304, 0, 304, 0, 304, 176, 0, 5, 0
	DC.W 16, 16, 32, 112, 64, 0, 64, 0, 64, 144, 0, 5, 0
	DC.W 16, 16, 112, 128, 144, 288, 144, 288, 144, 160, 0, -5, 0
	DC.W 32, 32, 64, 16, 96, 288, 96, 288, 96, 48, 0, -8, 0
	DC.W 16, 16, 272, 64, 304, 0, 304, 0, 304, 96, 0, 8, 0
	DC.W 32, 32, 176, 128, 0, 160, 0, 160, 208, 160, 7, 0, 0
	DC.W 16, 16, 240, 128, 0, 160, 0, 160, 272, 160, 7, 0, 0
	DC.W 16, 16, 224, 192, 0, 224, 0, 224, 256, 224, 6, 0, 0
	DC.W 16, 16, 144, 48, 352, 80, 352, 80, 176, 80, -5, 0, 0
	DC.W 32, 32, 16, 208, 48, 0, 48, 0, 48, 240, 0, 7, 0
	DC.W 16, 16, 240, 64, 352, 96, 352, 96, 272, 96, -6, 0, 0
	DC.W 16, 16, 80, 240, 0, 272, 0, 272, 112, 272, 8, 0, 0
	DC.W 16, 16, 128, 0, 160, 288, 160, 288, 160, 32, 0, -5, 0
	DC.W 16, 16, 240, 208, 272, 0, 272, 0, 272, 240, 0, 7, 0
	DC.W 32, 32, 208, 0, 240, 288, 240, 288, 240, 32, 0, -6, 0
	DC.W 16, 16, 128, 240, 352, 272, 352, 272, 160, 272, -8, 0, 0
	DC.W 16, 16, 256, 208, 352, 240, 352, 240, 288, 240, -5, 0, 0
	DC.W 16, 16, 192, 0, 352, 32, 352, 32, 224, 32, -8, 0, 0
	DC.W 16, 16, 224, 208, 352, 240, 352, 240, 256, 240, -6, 0, 0
	DC.W 16, 16, 144, 96, 352, 128, 352, 128, 176, 128, -7, 0, 0
	DC.W 16, 16, 96, 208, 128, 288, 128, 288, 128, 240, 0, -5, 0
	DC.W 16, 16, 224, 112, 352, 144, 352, 144, 256, 144, -6, 0, 0
	DC.W 32, 32, 288, 208, 0, 240, 0, 240, 320, 240, 7, 0, 0
	DC.W 32, 32, 256, 112, 288, 0, 288, 0, 288, 144, 0, 7, 0
	DC.W 32, 32, 208, 48, 240, 0, 240, 0, 240, 80, 0, 5, 0
	DC.W 32, 32, 96, 0, 352, 32, 352, 32, 128, 32, -6, 0, 0
	DC.W 16, 16, 80, 112, 112, 288, 112, 288, 112, 144, 0, -5, 0
	DC.W 32, 32, 80, 160, 112, 288, 112, 288, 112, 192, 0, -6, 0
	DC.W 32, 32, 112, 48, 144, 0, 144, 0, 144, 80, 0, 8, 0
	DC.W 16, 16, 144, 240, 176, 0, 176, 0, 176, 272, 0, 7, 0
	DC.W 16, 16, 288, 240, 0, 272, 0, 272, 320, 272, 6, 0, 0
	DC.W 16, 16, 128, 16, 160, 0, 160, 0, 160, 48, 0, 6, 0
	DC.W 16, 16, 80, 0, 0, 32, 0, 32, 112, 32, 7, 0, 0
	DC.W 16, 16, 80, 192, 352, 224, 352, 224, 112, 224, -6, 0, 0
	DC.W 16, 16, 208, 192, 240, 288, 240, 288, 240, 224, 0, -5, 0
	DC.W 32, 32, 96, 224, 0, 256, 0, 256, 128, 256, 6, 0, 0
	DC.W 16, 16, 0, 240, 352, 272, 352, 272, 32, 272, -8, 0, 0
	DC.W 16, 16, 256, 160, 352, 192, 352, 192, 288, 192, -7, 0, 0
	DC.W 16, 16, 272, 240, 352, 272, 352, 272, 304, 272, -6, 0, 0
	DC.W 16, 16, 128, 208, 160, 0, 160, 0, 160, 240, 0, 5, 0
	DC.W 32, 32, 288, 176, 320, 288, 320, 288, 320, 208, 0, -8, 0
	DC.W 16, 16, 160, 64, 0, 96, 0, 96, 192, 96, 7, 0, 0
	DC.W 32, 32, 288, 144, 320, 288, 320, 288, 320, 176, 0, -7, 0
	DC.W 16, 16, 0, 96, 352, 128, 352, 128, 32, 128, -6, 0, 0
	DC.W 16, 16, 288, 96, 320, 0, 320, 0, 320, 128, 0, 7, 0
	DC.W 32, 32, 80, 128, 0, 160, 0, 160, 112, 160, 6, 0, 0
	DC.W 16, 16, 192, 112, 224, 288, 224, 288, 224, 144, 0, -6, 0
	DC.W 16, 16, 160, 80, 352, 112, 352, 112, 192, 112, -5, 0, 0
	DC.W 16, 16, 304, 48, 336, 0, 336, 0, 336, 80, 0, 5, 0
	DC.W 16, 16, 112, 208, 352, 240, 352, 240, 144, 240, -8, 0, 0
	DC.W 16, 16, 272, 224, 304, 288, 304, 288, 304, 256, 0, -6, 0
	DC.W 16, 16, 224, 176, 256, 288, 256, 288, 256, 208, 0, -6, 0
	DC.W 16, 16, 304, 32, 352, 64, 352, 64, 336, 64, -5, 0, 0
	DC.W 16, 16, 0, 192, 352, 224, 352, 224, 32, 224, -6, 0, 0
	DC.W 32, 32, 176, 160, 352, 192, 352, 192, 208, 192, -7, 0, 0
	DC.W 16, 16, 304, 240, 336, 0, 336, 0, 336, 272, 0, 5, 0
	DC.W 16, 16, 144, 144, 0, 176, 0, 176, 176, 176, 7, 0, 0
	DC.W 32, 32, 240, 80, 352, 112, 352, 112, 272, 112, -6, 0, 0
	DC.W 16, 16, 240, 112, 272, 0, 272, 0, 272, 144, 0, 6, 0
	DC.W 16, 16, 144, 0, 176, 288, 176, 288, 176, 32, 0, -7, 0
	DC.W 32, 32, 80, 80, 112, 288, 112, 288, 112, 112, 0, -5, 0
	DC.W 16, 16, 144, 160, 352, 192, 352, 192, 176, 192, -5, 0, 0
	DC.W 16, 16, 80, 224, 0, 256, 0, 256, 112, 256, 5, 0, 0
	DC.W 16, 16, 128, 32, 160, 288, 160, 288, 160, 64, 0, -7, 0
	DC.W 16, 16, 64, 144, 96, 288, 96, 288, 96, 176, 0, -6, 0
	DC.W 16, 16, 208, 208, 240, 0, 240, 0, 240, 240, 0, 7, 0
	DC.W 16, 16, 16, 240, 0, 272, 0, 272, 48, 272, 5, 0, 0
	DC.W 32, 32, 0, 0, 32, 0, 32, 0, 32, 32, 0, 5, 0
	DC.W 16, 16, 240, 160, 272, 288, 272, 288, 272, 192, 0, -7, 0
	DC.W 16, 16, 192, 208, 0, 240, 0, 240, 224, 240, 6, 0, 0
	DC.W 16, 16, 176, 192, 208, 0, 208, 0, 208, 224, 0, 5, 0
	DC.W 16, 16, 112, 32, 144, 0, 144, 0, 144, 64, 0, 6, 0
	DC.W 16, 16, 272, 192, 0, 224, 0, 224, 304, 224, 7, 0, 0
	DC.W 32, 32, 48, 96, 352, 128, 352, 128, 80, 128, -5, 0, 0
	DC.W 16, 16, 16, 192, 48, 0, 48, 0, 48, 224, 0, 5, 0
	DC.W 32, 32, 0, 32, 32, 288, 32, 288, 32, 64, 0, -7, 0
	DC.W 16, 16, 0, 128, 32, 0, 32, 0, 32, 160, 0, 7, 0
	DC.W 16, 16, 48, 144, 80, 288, 80, 288, 80, 176, 0, -5, 0
	DC.W 16, 16, 160, 0, 0, 32, 0, 32, 192, 32, 7, 0, 0
	DC.W 32, 32, 32, 32, 0, 64, 0, 64, 64, 64, 8, 0, 0
	DC.W 32, 32, 272, 32, 352, 64, 352, 64, 304, 64, -5, 0, 0
	DC.W 16, 16, 32, 192, 64, 288, 64, 288, 64, 224, 0, -8, 0
	DC.W 32, 32, 16, 64, 0, 96, 0, 96, 48, 96, 7, 0, 0
	DC.W 16, 16, 208, 112, 240, 0, 240, 0, 240, 144, 0, 7, 0
	DC.W 16, 16, 176, 208, 208, 288, 208, 288, 208, 240, 0, -8, 0
	DC.W 16, 16, 256, 144, 0, 176, 0, 176, 288, 176, 6, 0, 0
	DC.W 32, 32, 0, 160, 32, 0, 32, 0, 32, 192, 0, 6, 0
	DC.W 16, 16, 144, 176, 176, 288, 176, 288, 176, 208, 0, -7, 0
	DC.W 16, 16, 304, 0, 336, 288, 336, 288, 336, 32, 0, -7, 0
	DC.W 16, 16, 160, 176, 0, 208, 0, 208, 192, 208, 8, 0, 0
	DC.W 32, 32, 128, 112, 160, 0, 160, 0, 160, 144, 0, 6, 0
	DC.W 16, 16, 64, 128, 352, 160, 352, 160, 96, 160, -8, 0, 0
	DC.W 16, 16, 16, 112, 352, 144, 352, 144, 48, 144, -7, 0, 0
	DC.W 16, 16, 144, 192, 0, 224, 0, 224, 176, 224, 7, 0, 0
	DC.W 32, 32, 208, 224, 352, 256, 352, 256, 240, 256, -5, 0, 0
	DC.W 16, 16, 272, 80, 352, 112, 352, 112, 304, 112, -8, 0, 0
	DC.W 32, 32, 288, 112, 352, 144, 352, 144, 320, 144, -8, 0, 0
	DC.W 16, 16, 272, 96, 0, 128, 0, 128, 304, 128, 7, 0, 0
	DC.W 16, 16, 0, 112, 0, 144, 0, 144, 32, 144, 7, 0, 0
	DC.W 32, 32, 272, 0, 304, 0, 304, 0, 304, 32, 0, 5, 0
	DC.W 16, 16, 272, 160, 304, 288, 304, 288, 304, 192, 0, -6, 0
	DC.W 32, 32, 112, 144, 0, 176, 0, 176, 144, 176, 7, 0, 0
	DC.W 32, 32, 48, 64, 80, 288, 80, 288, 80, 96, 0, -6, 0
	DC.W 32, 32, 48, 224, 80, 0, 80, 0, 80, 256, 0, 8, 0
	ELSE
	DC.W 16, 16, 144, 176, 208, 320, 208, 320, 208, 240, 0, -7, 0
	DC.W 32, 32, 112, 144, 0, 208, 0, 208, 176, 208, 5, 0, 0
	DC.W 16, 16, 304, 96, 368, 320, 368, 320, 368, 160, 0, -8, 0
	DC.W 16, 16, 0, 224, 64, 320, 64, 320, 64, 288, 0, -6, 0
	DC.W 16, 16, 112, 112, 0, 176, 0, 176, 176, 176, 5, 0, 0
	DC.W 16, 16, 64, 144, 128, 320, 128, 320, 128, 208, 0, -5, 0
	DC.W 16, 16, 272, 64, 336, 0, 336, 0, 336, 128, 0, 8, 0
	DC.W 16, 16, 32, 112, 96, 0, 96, 0, 96, 176, 0, 7, 0
	DC.W 16, 16, 112, 208, 384, 272, 384, 272, 176, 272, -7, 0, 0
	DC.W 32, 32, 240, 224, 384, 288, 384, 288, 304, 288, -8, 0, 0
	DC.W 16, 16, 0, 240, 384, 304, 384, 304, 64, 304, -5, 0, 0
	DC.W 16, 16, 192, 112, 256, 320, 256, 320, 256, 176, 0, -8, 0
	DC.W 16, 16, 304, 32, 384, 96, 384, 96, 368, 96, -7, 0, 0
	DC.W 16, 16, 288, 96, 352, 0, 352, 0, 352, 160, 0, 8, 0
	DC.W 16, 16, 16, 192, 80, 0, 80, 0, 80, 256, 0, 7, 0
	DC.W 16, 16, 144, 192, 0, 256, 0, 256, 208, 256, 7, 0, 0
	DC.W 16, 16, 80, 240, 0, 304, 0, 304, 144, 304, 6, 0, 0
	DC.W 16, 16, 128, 0, 192, 320, 192, 320, 192, 64, 0, -5, 0
	DC.W 32, 32, 112, 176, 176, 320, 176, 320, 176, 240, 0, -8, 0
	DC.W 16, 16, 240, 64, 384, 128, 384, 128, 304, 128, -8, 0, 0
	DC.W 16, 16, 192, 0, 384, 64, 384, 64, 256, 64, -6, 0, 0
	DC.W 16, 16, 256, 208, 384, 272, 384, 272, 320, 272, -6, 0, 0
	DC.W 16, 16, 160, 0, 0, 64, 0, 64, 224, 64, 7, 0, 0
	DC.W 16, 16, 160, 192, 224, 0, 224, 0, 224, 256, 0, 8, 0
	DC.W 16, 16, 160, 176, 0, 240, 0, 240, 224, 240, 6, 0, 0
	DC.W 16, 16, 96, 112, 160, 0, 160, 0, 160, 176, 0, 8, 0
	DC.W 16, 16, 160, 144, 384, 208, 384, 208, 224, 208, -5, 0, 0
	DC.W 16, 16, 16, 240, 0, 304, 0, 304, 80, 304, 5, 0, 0
	DC.W 16, 16, 0, 208, 64, 0, 64, 0, 64, 272, 0, 7, 0
	DC.W 16, 16, 0, 96, 384, 160, 384, 160, 64, 160, -7, 0, 0
	DC.W 16, 16, 0, 192, 384, 256, 384, 256, 64, 256, -5, 0, 0
	DC.W 16, 16, 272, 80, 384, 144, 384, 144, 336, 144, -5, 0, 0
	DC.W 16, 16, 240, 144, 304, 320, 304, 320, 304, 208, 0, -6, 0
	DC.W 16, 16, 224, 32, 384, 96, 384, 96, 288, 96, -6, 0, 0
	DC.W 16, 16, 144, 160, 384, 224, 384, 224, 208, 224, -6, 0, 0
	DC.W 32, 32, 80, 128, 0, 192, 0, 192, 144, 192, 6, 0, 0
	DC.W 32, 32, 240, 80, 384, 144, 384, 144, 304, 144, -6, 0, 0
	DC.W 32, 32, 240, 176, 304, 0, 304, 0, 304, 240, 0, 6, 0
	DC.W 32, 32, 288, 64, 352, 0, 352, 0, 352, 128, 0, 5, 0
	DC.W 16, 16, 64, 0, 384, 64, 384, 64, 128, 64, -7, 0, 0
	DC.W 16, 16, 0, 64, 64, 320, 64, 320, 64, 128, 0, -5, 0
	DC.W 16, 16, 272, 240, 384, 304, 384, 304, 336, 304, -5, 0, 0
	DC.W 16, 16, 304, 0, 368, 320, 368, 320, 368, 64, 0, -7, 0
	DC.W 16, 16, 304, 240, 368, 0, 368, 0, 368, 304, 0, 5, 0
	DC.W 32, 32, 0, 160, 64, 0, 64, 0, 64, 224, 0, 7, 0
	DC.W 16, 16, 0, 80, 64, 0, 64, 0, 64, 144, 0, 6, 0
	DC.W 16, 16, 160, 80, 384, 144, 384, 144, 224, 144, -6, 0, 0
	DC.W 16, 16, 208, 32, 0, 96, 0, 96, 272, 96, 8, 0, 0
	DC.W 16, 16, 272, 192, 0, 256, 0, 256, 336, 256, 5, 0, 0
	DC.W 16, 16, 272, 224, 336, 320, 336, 320, 336, 288, 0, -8, 0
	DC.W 16, 16, 192, 208, 0, 272, 0, 272, 256, 272, 7, 0, 0
	DC.W 16, 16, 304, 48, 368, 0, 368, 0, 368, 112, 0, 5, 0
	DC.W 64, 64, 80, 48, 0, 112, 0, 112, 144, 112, 5, 0, 0
	DC.W 16, 16, 272, 208, 0, 272, 0, 272, 336, 272, 6, 0, 0
	DC.W 16, 16, 144, 96, 384, 160, 384, 160, 208, 160, -6, 0, 0
	DC.W 32, 32, 176, 224, 0, 288, 0, 288, 240, 288, 5, 0, 0
	DC.W 16, 16, 208, 112, 272, 0, 272, 0, 272, 176, 0, 7, 0
	DC.W 16, 16, 224, 80, 288, 320, 288, 320, 288, 144, 0, -5, 0
	DC.W 32, 32, 48, 224, 112, 0, 112, 0, 112, 288, 0, 8, 0
	DC.W 16, 16, 0, 112, 0, 176, 0, 176, 64, 176, 5, 0, 0
	DC.W 16, 16, 272, 176, 384, 240, 384, 240, 336, 240, -5, 0, 0
	DC.W 16, 16, 128, 32, 192, 320, 192, 320, 192, 96, 0, -8, 0
	DC.W 16, 16, 80, 112, 144, 320, 144, 320, 144, 176, 0, -8, 0
	DC.W 32, 32, 16, 128, 80, 320, 80, 320, 80, 192, 0, -8, 0
	DC.W 16, 16, 16, 96, 80, 320, 80, 320, 80, 160, 0, -6, 0
	DC.W 32, 32, 96, 224, 0, 288, 0, 288, 160, 288, 6, 0, 0
	DC.W 32, 32, 208, 0, 272, 320, 272, 320, 272, 64, 0, -7, 0
	DC.W 32, 32, 208, 48, 272, 0, 272, 0, 272, 112, 0, 5, 0
	DC.W 32, 32, 48, 64, 112, 320, 112, 320, 112, 128, 0, -6, 0
	DC.W 16, 16, 128, 224, 384, 288, 384, 288, 192, 288, -5, 0, 0
	DC.W 32, 32, 208, 224, 384, 288, 384, 288, 272, 288, -6, 0, 0
	DC.W 16, 16, 208, 192, 272, 320, 272, 320, 272, 256, 0, -5, 0
	DC.W 32, 32, 16, 208, 80, 0, 80, 0, 80, 272, 0, 6, 0
	DC.W 16, 16, 48, 128, 112, 0, 112, 0, 112, 192, 0, 7, 0
	DC.W 64, 64, 176, 128, 0, 192, 0, 192, 240, 192, 5, 0, 0
	DC.W 16, 16, 32, 192, 96, 320, 96, 320, 96, 256, 0, -7, 0
	DC.W 16, 16, 64, 48, 384, 112, 384, 112, 128, 112, -8, 0, 0
	DC.W 16, 16, 240, 128, 0, 192, 0, 192, 304, 192, 7, 0, 0
	DC.W 16, 16, 16, 112, 384, 176, 384, 176, 80, 176, -5, 0, 0
	DC.W 16, 16, 208, 208, 272, 0, 272, 0, 272, 272, 0, 5, 0
	DC.W 16, 16, 288, 240, 0, 304, 0, 304, 352, 304, 8, 0, 0
	DC.W 16, 16, 112, 32, 176, 0, 176, 0, 176, 96, 0, 5, 0
	DC.W 64, 64, 48, 160, 112, 0, 112, 0, 112, 224, 0, 5, 0
	DC.W 16, 16, 160, 240, 0, 304, 0, 304, 224, 304, 8, 0, 0
	DC.W 16, 16, 240, 160, 304, 320, 304, 320, 304, 224, 0, -7, 0
	DC.W 32, 32, 288, 208, 0, 272, 0, 272, 352, 272, 8, 0, 0
	DC.W 16, 16, 112, 128, 176, 320, 176, 320, 176, 192, 0, -8, 0
	DC.W 16, 16, 64, 128, 384, 192, 384, 192, 128, 192, -6, 0, 0
	DC.W 16, 16, 48, 144, 112, 320, 112, 320, 112, 208, 0, -7, 0
	DC.W 16, 16, 224, 112, 384, 176, 384, 176, 288, 176, -5, 0, 0
	DC.W 16, 16, 240, 112, 304, 0, 304, 0, 304, 176, 0, 8, 0
	DC.W 64, 64, 144, 16, 384, 80, 384, 80, 208, 80, -4, 0, 0
	DC.W 16, 16, 128, 208, 192, 0, 192, 0, 192, 272, 0, 5, 0
	DC.W 16, 16, 80, 224, 0, 288, 0, 288, 144, 288, 5, 0, 0
	DC.W 16, 16, 128, 240, 384, 304, 384, 304, 192, 304, -5, 0, 0
	DC.W 16, 16, 256, 64, 0, 128, 0, 128, 320, 128, 8, 0, 0
	DC.W 16, 16, 32, 96, 0, 160, 0, 160, 96, 160, 5, 0, 0
	DC.W 16, 16, 144, 0, 208, 320, 208, 320, 208, 64, 0, -6, 0
	DC.W 16, 16, 272, 96, 0, 160, 0, 160, 336, 160, 8, 0, 0
	DC.W 16, 16, 32, 240, 96, 320, 96, 320, 96, 304, 0, -8, 0
	DC.W 64, 64, 256, 112, 320, 320, 320, 320, 320, 176, 0, -5, 0
	DC.W 32, 32, 48, 96, 384, 160, 384, 160, 112, 160, -6, 0, 0
	DC.W 16, 16, 304, 16, 0, 80, 0, 80, 368, 80, 8, 0, 0
	DC.W 32, 32, 192, 80, 256, 320, 256, 320, 256, 144, 0, -7, 0
	DC.W 16, 16, 160, 128, 224, 320, 224, 320, 224, 192, 0, -8, 0
	DC.W 64, 64, 240, 0, 304, 320, 304, 320, 304, 64, 0, -5, 0
	DC.W 32, 32, 288, 176, 352, 320, 352, 320, 352, 240, 0, -6, 0
	DC.W 16, 16, 144, 80, 0, 144, 0, 144, 208, 144, 5, 0, 0
	DC.W 16, 16, 176, 0, 240, 0, 240, 0, 240, 64, 0, 6, 0
	DC.W 16, 16, 96, 32, 160, 320, 160, 320, 160, 96, 0, -5, 0
	DC.W 64, 64, 0, 0, 384, 64, 384, 64, 64, 64, -5, 0, 0
	DC.W 32, 32, 144, 208, 384, 272, 384, 272, 208, 272, -6, 0, 0
	DC.W 16, 16, 80, 0, 0, 64, 0, 64, 144, 64, 5, 0, 0
	DC.W 32, 32, 96, 0, 384, 64, 384, 64, 160, 64, -3, 0, 0
	DC.W 16, 16, 0, 144, 384, 208, 384, 208, 64, 208, -7, 0, 0
	DC.W 16, 16, 160, 160, 224, 0, 224, 0, 224, 224, 0, 8, 0
	DC.W 16, 16, 32, 176, 384, 240, 384, 240, 96, 240, -8, 0, 0
	DC.W 32, 32, 16, 64, 0, 128, 0, 128, 80, 128, 7, 0, 0
	DC.W 16, 16, 176, 192, 240, 0, 240, 0, 240, 256, 0, 7, 0
	DC.W 16, 16, 192, 192, 384, 256, 384, 256, 256, 256, -7, 0, 0
	DC.W 16, 16, 176, 208, 240, 320, 240, 320, 240, 272, 0, -7, 0
	DC.W 16, 16, 224, 96, 0, 160, 0, 160, 288, 160, 5, 0, 0
	DC.W 32, 32, 160, 96, 384, 160, 384, 160, 224, 160, -6, 0, 0
	DC.W 16, 16, 240, 208, 304, 0, 304, 0, 304, 272, 0, 8, 0
	DC.W 32, 32, 128, 112, 192, 0, 192, 0, 192, 176, 0, 8, 0
	DC.W 16, 16, 224, 208, 384, 272, 384, 272, 288, 272, -6, 0, 0
	DC.W 16, 16, 128, 16, 192, 0, 192, 0, 192, 80, 0, 5, 0
	DC.W 16, 16, 144, 144, 0, 208, 0, 208, 208, 208, 6, 0, 0
	DC.W 16, 16, 176, 80, 240, 320, 240, 320, 240, 144, 0, -5, 0
	DC.W 16, 16, 0, 128, 64, 0, 64, 0, 64, 192, 0, 7, 0
	DC.W 16, 16, 224, 192, 0, 256, 0, 256, 288, 256, 5, 0, 0
	DC.W 32, 32, 64, 16, 128, 320, 128, 320, 128, 80, 0, -7, 0
	DC.W 16, 16, 144, 240, 208, 0, 208, 0, 208, 304, 0, 8, 0
	DC.W 16, 16, 32, 160, 0, 224, 0, 224, 96, 224, 5, 0, 0
	ENDC
pzBOBsDataEnd:

; ---------- Cut ----------

ctPalette:
	REPT 32
	DC.W $FFFF
	ENDR

; ---------- Printer ----------

printerText:
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
	DC.B " /     .oO Scoopex ""TWO"" [v8] Oo.     \",0
	DC.B " \                                    /",0
	DC.B " /    A tribute to graphic artists    \",0
	DC.B " \                                    /",0
	DC.B " /      Produced in October 2018      \",0
	DC.B " \                                    /",0
	DC.B " /       Code & Design: Yragael       \",0
	DC.B " \         Picture: alien^pdx         /",0
	DC.B " /        Logo: Pro Motion NG!        \",0
	DC.B " \      Music: Curt Cool / Depth      /",0
	DC.B " /                                    \",0
	DC.B " \  Get the source, data and doc at:  /",0
	DC.B " /                                    \",0
	DC.B " \      http://www.stashofcode.fr     /",0
	DC.B " /                                    \",0
	DC.B " \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/",-1
	; Page 1
	DC.B " Yragael sends its best regards to...",0
	DC.B 0
	DC.B " ALIEN: You must be some kind of semi-",0
	DC.B "        god to draw this well and fast!",0
	DC.B " Curt: Thanks for the tune! King",0
	DC.B "       Tutankhamun would enjoy it!",0
	DC.B " Ramon B5: Man, you just *saved* the",0
	DC.B "           day! So many thanks!",0
	DC.B " Galahad: Thanks for giving me a",0
	DC.B "          chance to code this cracktro!",0
	DC.B " Asle & Crown: Thanks for the contacts",0
	DC.B "               and long live to AMP!",0
	DC.B " StingRay: No absolute addressing here!",0
	DC.B "           Thanks for the VBR code!",0
	DC.B " Sim1: We missed time on this one, but",0
	DC.B "       next time, we will do better!",0
	DC.B " Photon: Thanks for showing that I was",0
	DC.B "         not cycle-exact!",-1
	; End of pages
	DC.B -1
	EVEN
font:
	INCBIN "data/fontBevelled8x8x1.raw"
	EVEN

; ---------- Rotozoom ----------

; rzLogo:				INCBIN "SOURCES:scoopexTWO/scoopexTWOv8/data/scoopexTWOLogoAharoni320x56x1.rawb"	; Set the RZ_LOGO_* constants accordingly !
; rzLogo:				INCBIN "SOURCES:scoopexTWO/scoopexTWOv8/data/scoopexTWOLogoJokerman320x56x1.rawb"	; Set the RZ_LOGO_* constants accordingly !
; rzLogo:				INCBIN "SOURCES:scoopexTWO/scoopexTWOv8/data/scoopexTWOLogoMistral320x56x1.rawb"	; Set the RZ_LOGO_* constants accordingly !
rzLogo:				; INCBIN "SOURCES:scoopexTWO/scoopexTWOv8/data/scoopexTWOLogoRavie320x56x1.rawb"	; Set the RZ_LOGO_* constants accordingly !
					INCBIN "data/scoopexTWOLogoRavie320x56x1.rawb"
rzMoves:			DC.L 0
rzFrontBuffer:		DC.L 0
rzFrontCopperList:	DC.L 0
rzBackCopperList:	DC.L 0
rzZoomSteps:		DC.W 0
rzWindowDX:			DC.W 0
rzWindowDXMin:		DC.W 0
rzWindowDXMax:		DC.W 0
rzWindowDY:			DC.W 0
rzWindowDYMin:		DC.W 0
rzWindowDYMax:		DC.W 0
rzDXV:				DC.W 0
rzIncXV:			DC.W 0
rzDYV:				DC.W 0
rzIncYV:			DC.W 0
rzDXH:				DC.W 0
rzIncXH:			DC.W 0
rzDYH:				DC.W 0
rzIncYH:			DC.W 0
rzOffsetsH:			BLK.W RZ_COPPER_DX,0
rzOffsetsV:			BLK.W RZ_COPPER_DY,0
rzPoints:			BLK.W 4*2,0
rzTPoints:			BLK.W 4*2,0
rzAngle:			DC.W 0
rzBitmap:			INCBIN "data/alienKingTut320x256x5.rawb"
accumulator0:		DC.W 0
accumulator1:		DC.W 0
sinus:				DC.W 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286
cosinus:		DC.W 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286, 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382
rzWAITs:
	DC.W $2C01, $FFFE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $803F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
	DC.W $003F, $80FE
rzSKIPs:
	DC.W $3401, $FF01
	DC.W $3C01, $FF01
	DC.W $4401, $FF01
	DC.W $4C01, $FF01
	DC.W $5401, $FF01
	DC.W $5C01, $FF01
	DC.W $6401, $FF01
	DC.W $6C01, $FF01
	DC.W $7401, $FF01
	DC.W $7C01, $FF01
	DC.W $8001, $FF01
	DC.W $8401, $FF01
	DC.W $8C01, $FF01
	DC.W $9401, $FF01
	DC.W $9C01, $FF01
	DC.W $A401, $FF01
	DC.W $AC01, $FF01
	DC.W $B401, $FF01
	DC.W $BC01, $FF01
	DC.W $C401, $FF01
	DC.W $CC01, $FF01
	DC.W $D401, $FF01
	DC.W $DC01, $FF01
	DC.W $E401, $FF01
	DC.W $EC01, $FF01
	DC.W $F401, $FF01
	DC.W $FC01, $FF01
	DC.W $FF01, $FF01
	DC.W $0401, $FF01
	DC.W $0C01, $FF01
	DC.W $1401, $FF01
	DC.W $1C01, $FF01
	DC.W $2401, $FF01
	DC.W $2C01, $FF01

; ---------- Tune ----------

	IFNE TUNE
module:		INCBIN "data/salah's_fists.mod"
	ENDC
