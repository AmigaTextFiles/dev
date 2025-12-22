
; soc24.s = sinescroll_final.s

; Coded by Yragael for Stash of Code (http://www.stashofcode.fr) in 2017.

; This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

DEBUGDISPLAYTIME=0

;---------- Directives ----------

	SECTION yragael,CODE_C

;---------- Constants ----------

; Registers

VPOSR=$004
VHPOSR=$006
INTENA=$09A
INTENAR=$01C
INTREQ=$09C
INTREQR=$01E
DMACON=$096
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
DIWSTRT=$08E
DIWSTOP=$090
BPLCON0=$100
BPLCON1=$102
BPLCON2=$104
DDFSTRT=$092
DDFSTOP=$094
BPL1MOD=$108
BPL2MOD=$10A
BPL1PTH=$0E0
BPL1PTL=$0E2
BPL2PTH=$0E4
BPL2PTL=$0E6
COLOR00=$180
COLOR01=$182
COLOR02=$184
COLOR03=$186
COP1LCH=$080
COPJMP1=$088
FMODE=$1FC

; Program

BLITTER=1						; 0=draw with CPU 1=draw with Blitter
DISPLAY_DEPTH=2
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C
SCROLL_DX=DISPLAY_DX
SCROLL_X=(DISPLAY_DX-SCROLL_DX)>>1
SCROLL_DY=100
SCROLL_AMPLITUDE=SCROLL_DY-16	; SCROLL_DY-16 is the amplitude for possible ordinates of the scroll: [0,SCROLL_DY-16]
								; SCROLL_DY must be even so that the scroll is centered on DISPLAY_DY (which is even)
								; So SCROLL_DY-16 is even
								; The ordinates are given by (A>>1)*sin that gives values in [-A,A] when A is even and in [-A+1,A+1] when A is odd
								; Here, A=SCROLL_DY-16 so A is even: no correction to make
SCROLL_Y=(DISPLAY_DY-SCROLL_DY)>>1
SCROLL_SPEED=2
SCROLL_COLOR=$0FFF
SINE_SPEED_FRAME=5
SINE_SPEED_PIXEL=1
LINE_DX=15						; That's the number of lines of the line - 1 : LINE_DX=max (abs(15-0),abs(0,0))
LINE_DY=0						; That's the number of columns of the line - 1 : LINE_DY=min (abs(15-0),abs(0,0))
LINE_OCTANT=1
MIRROR_Y=SCROLL_Y+SCROLL_DY		; Ordinate of the line where the line begins in the mirror (the WAIT that modifies BPL1MOD occurs one line before)
MIRROR_COLOR=$000A
MIRROR_SCROLL_COLOR=$000F
SHADOW_DX=2						; Lies between 0 and 15
SHADOW_DY=2
SHADOW_COLOR=$0777
TEXT_XOR=$3B
TEXT_CHECKSUM=$12eda
TEXT_CHECKSUM_LAMER=$7f6
COPSIZE=18*4+14*4+4

;---------- Macros ----------

; Wait for the Blitter. When the second operand is an address, BTST can only test bits 7-0 of the
; addressed byte, but since the first operand is the number of the bit modulo 8, BTST #14,DMACONR(a5) 
; means testing bit 14%8=6 of the most significant byte of DMACONR, which is BBUSY as expected...

WAITBLIT:	MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@
;_waitBlitter1\@			; disabled for optimization: allows to to fit in the frame on A500
;	btst #14,DMACONR(a5)
;	bne _waitBlitter1\@
	ENDM

; Control the integrity of the text to diplay. Watch for the context in which the macro is used,
; because the macro may modified the length of the initial text (which must be at least as long as
; "You are a LAMER!", or data wil be overwritten) and make the code that was using it go berzerk

CHECKTEXT:	MACRO
	movem.l d0-d1/a0-a1,-(sp)
	lea text,a0
	clr.l d0
	clr.l d1
_checkTextLoop\@
	move.b (a0)+,d0
	add.l d0,d1
	eor.b #TEXT_XOR,d0
	bne _checkTextLoop\@
	cmp.l textChecksum,d1
	beq _checkTextOK\@
	move.l #TEXT_CHECKSUM_LAMER,textChecksum
	lea text,a0
	lea textLamer,a1
_checkTextLamerLoop\@
	move.b (a1)+,d0
	move.b d0,(a0)+
	eor.b #TEXT_XOR,d0
	bne _checkTextLamerLoop\@
_checkTextOK\@
	movem.l (sp)+,d0-d1/a0-a1
	ENDM

;---------- Initializations ----------

; Stack the registers

	movem.l d0-d7/a0-a6,-(sp)

; Allocate Chip memory set to 0 for the Copper list

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

; Same thing for the bitplanes

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplaneA

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplaneB

	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplaneC

; Same thing for the font

	move.l #256<<5,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,font16

; Same thing for the columns of pixels of the text

	lea text,a0
_textsize:
	move.b (a0)+,d1
	eor.b #TEXT_XOR,d1
	bne _textsize
	move.l a0,d0
	sub.l #text,d0
	lsl.w #5,d0					; 16 columns of 16 pixels per character = 32 bytes
	move.l d0,textColumnsSize
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,textColumns

; Same thing for the possible ordinates of the columns of pixels of the text

	move.l #360<<1,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,ordinates

; Shut down the system

	movea.l $4,a6
	jsr -132(a6)

; Shut down the hardware interrupts and the DMAs

	lea $dff000,a5
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

;---------- Copper list creation ----------

	movea.l copperlist,a0

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
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Same thing as ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC if DISPLAY_DX is multiple of 16
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

; Bitplanes addresses

	move.l bitplaneA,d0
	move.w #BPL1PTL,(a0)+
	move.w d0,(a0)+
	move.w #BPL2PTL,(a0)+
	move.w d0,(a0)+
	swap d0
	move.w #BPL1PTH,(a0)+
	move.w d0,(a0)+
	move.w #BPL2PTH,(a0)+
	move.w d0,(a0)+

; Colors

	IFNE DEBUGDISPLAYTIME
	move.w #$0186,(a0)+			; COLOR04 not used. That's just to avoid modifying COLOR00...
	ELSE
	move.w #COLOR00,(a0)+
	ENDC
	move.w #$0000,(a0)+
	move.w #COLOR01,(a0)+
	move.w #SCROLL_COLOR,(a0)+
	move.w #COLOR02,(a0)+
	move.w #SHADOW_COLOR,(a0)+
	move.w #COLOR03,(a0)+
	move.w #SCROLL_COLOR,(a0)+

; AGA comptability on OCS

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+
	
; Shadow and mirror

	move.w #((DISPLAY_Y+SCROLL_Y+SHADOW_DY-1)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #-SHADOW_DY*(DISPLAY_DX>>3),(a0)+

	move.w #((DISPLAY_Y+SCROLL_Y+SHADOW_DY)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #SHADOW_DX<<4,(a0)+

	move.w #((DISPLAY_Y+MIRROR_Y-1)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #-(DISPLAY_DX>>3),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #(SHADOW_DY-1)*(DISPLAY_DX>>3),(a0)+

	move.w #((DISPLAY_Y+MIRROR_Y)<<8)!$0001,(a0)+
	move.w #$FF00,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #-(DISPLAY_DX>>2),(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #-(DISPLAY_DX>>2),(a0)+
	IFNE DEBUGDISPLAYTIME
	move.w #$0186,(a0)+			; COLOR04 not used. That's just to avoid modifying COLOR00...
	ELSE
	move.w #COLOR00,(a0)+
	ENDC
	move.w #MIRROR_COLOR,(a0)+
	move.w #COLOR03,(a0)+
	move.w #MIRROR_SCROLL_COLOR,(a0)+

; End

	move.l #$FFFFFFFE,(a0)

; Activate the Copper list

	move.l copperlist,COP1LCH(a5)
	clr.w COPJMP1(a5)

; Activate the DMAs

	move.w #$83C0,DMACON(a5)	; DMAEN=1, COPEN=1, BPLEN=1, COPEN=1, BLTEN=1

;---------- Creation of a 16x16 font from a 8x8 font ----------

; Prepare the data for the font (1st byte = serie of bits 7 of the 8 lignes / bytes of the character,
; 2nd byte = serie of bits 6 of the 8 lines / bytes of the character, and so on: a -90° rotation).
; Note that when using the Blitter, the columns must be drawn from the last to the first because of
; the way the pattern is oriented (it should be flipped around the Y axis if it were to be drawn
; from the first to the last column)

	lea font8,a0
	move.l font16,a1
	move.w #256-1,d0
_fontLoop:
	moveq #7,d1
_fontLineLoop:
	clr.w d5
	clr.w d3
	clr.w d4
_fontColumnLoop:
	move.b (a0,d5.w),d2
	btst d1,d2
	beq _fontPixelEmpty
	bset d4,d3
	addq.b #1,d4
	bset d4,d3
	addq.b #1,d4
	bra _fontNextPixel
_fontPixelEmpty:
	addq.b #2,d4
_fontNextPixel:
	addq.b #1,d5
	btst #4,d4
	beq _fontColumnLoop
	move.w d3,(a1)+
	move.w d3,(a1)+
	dbf d1,_fontLineLoop
	lea 8(a0),a0
	dbf d0,_fontLoop

;---------- Precalculate ----------

	CHECKTEXT

; Precalculate all the possible ordinates

	lea sinus,a0
	movea.l ordinates,a1
	move.w #360-1,d0
_precomputeOrdinates:
	move.w (a0)+,d1
	muls #(SCROLL_AMPLITUDE>>1),d1
	swap d1
	rol.l #2,d1
	addi.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1
	mulu #DISPLAY_DX>>3,d1		; don't bother to optimize x*40=x*(2^5+2^3)...
	IFNE BLITTER
	; The Blitter draws the columns from the bottom to the top because of the way the pattern is oriented
	addi.w #LINE_DX*(DISPLAY_DX>>3),d1
	ENDC
	move.w d1,(a1)+
	dbf d0,_precomputeOrdinates

; Precompute all the columns of pixels of the text

	clr.l d1
	lea text,a0
	movea.l textColumns,a1
	movea.l font16,a2
_precomputeColumnsCharLoop:
	clr.w d0
	move.b (a0)+,d0				; characted to display
	eor.b #TEXT_XOR,d0
	beq _precomputeColumnsEnd
	sub.b #$20,d0
	lsl.w #5,d0					; 32 bytes per character in the 16x16 police
	lea (a2,d0.w),a3			; address of the current column in the bitmap of the character to display
	moveq #16-1,d0
_precomputeColumnsLinesLoop:
	move.w (a3)+,(a1)+
	dbf d0,_precomputeColumnsLinesLoop
	addi.l #16,d1
	bra _precomputeColumnsCharLoop
_precomputeColumnsEnd:
	move.l d1,textNbColumns

;---------- Main loop ----------

_loop:

	; Wait for the electron beam to finish drawing the screen (presumes that the execution
	; will take more time than it takes for the electron beam to loop on line 0)

_waitVBL:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0
	blt _waitVBL

	IFNE DEBUGDISPLAYTIME
	move.w #$0F00,COLOR00(a5)
	ENDC
	
	; Bitplanes circular permutation

	move.l bitplaneA,d0
	move.l bitplaneB,d1
	move.l bitplaneC,d2
	move.l d1,bitplaneA
	move.l d2,bitplaneB
	move.l d0,bitplaneC

	movea.l copperlist,a0
	move.w d1,9*4+2(a0)
	move.w d1,10*4+2(a0)
	swap d1
	move.w d1,11*4+2(a0)
	move.w d1,12*4+2(a0)

	; Initialize the text display loop

	movea.l bitplaneB,a0
	movea.l textColumns,a1
	move.l textColumnsSize,d0
	lea (a1,d0.l),a3
	move.l scrollColumn,d0
	lsl.l #1,d0					; 1 column = 1 word
	lea (a1,d0.l),a1
	movea.l ordinates,a2

	move.w angle,d0
	move.w #SCROLL_DX-1,d1
	move.w #SCROLL_X,d2
	lsr.w #3,d2					; offset in bytes of the screen column
	bclr #0,d2					; this column must lie in a word (all of this is lsr.w #4 then lsl.w #1)
	IFNE BLITTER

	WAITBLIT
	move.w #4*(LINE_DY-LINE_DX),BLTAMOD(a5)
	move.w #4*LINE_DY,BLTBMOD(a5)
	move.w #DISPLAY_DX>>3,BLTCMOD(a5)
	move.w #DISPLAY_DX>>3,BLTDMOD(a5)
	move.w #(4*LINE_DY)-(2*LINE_DX),BLTAPTL(a5)
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)
	move.w #$8000,BLTADAT(a5)
	move.w #(LINE_OCTANT<<2)!$F041,BLTCON1(a5)		; BSH3-0=15, SIGN=1, OVF=0, SUD/SUL/AUL=octant, SING=0, LINE=1
	; Blitter: it requires the number of the pixel in the word of the screen
	move.w #SCROLL_X,d3
	and.w #$000F,d3
	ror.w #4,d3
	or.w #$0B4A,d3

	ELSE
	
	; CPU: it requires the number of the bit matching the pixel in the word of the screen
	moveq #SCROLL_X,d4
	and.w #$000F,d4
	moveq #15,d3
	sub.b d4,d3

	ENDC

	; Draw the columns of characters in the bitplane

	; A0 = bitplane
	; A1 = columns of pixels of the text
	; A2 = ordinates
	; A3 = address after the one of the last column of pixels in the text
	; D0 = offset of the ordinate corresponding to the angle whose sine determines the ordinate of the current column of pixels
	; D1 = counter to run through all the columns to draw (SCROLL_DX columns)
	; D2 = offset in bytes of the word containing the current column of pixels in the screen
	; D3 = number of the pixel in the current column in the current word of the screen for BLT (required format for BLTCON0) / number of the bit of this pixel (CPU)

_writeLoop:

	; Compute the address of the word of the first pixel of the current column in the screen

	move.w (a2,d0.w),d4
	add.w d2,d4
	lea (a0,d4.w),a4

	; Display the current column of pixels of the text

	IFNE BLITTER

	; Blitter: draw the column as a single line
	; presumes that LINE_DX > LINE_DY
	WAITBLIT
	move.l a4,BLTCPTH(a5)
	move.l a4,BLTDPTH(a5)
	move.w (a1)+,BLTBDAT(a5)
	move.w d3,BLTCON0(a5)		; ASH3-0=pixel, USEA=1, USEB=0, USEC=1, USED=1, LF7-0=AB+AC=$4A
	move.w #((LINE_DX+1)<<6)!$0002,BLTSIZE(a5)

	ELSE
	
	; CPU: draw the column bit after bit
	move.w (a1)+,d7
	clr.b d6
	moveq #LINE_DX,d5			; display loop for the lines (if LINE_DX was set to 16, we could replace DBF with BTST #4,D6 and save some CPU cycles)
_pixel_loop:
	btst d6,d7
	beq _pixelEmpty
	move.w (a4),d4
	bset d3,d4
	move.w d4,(a4)				; using D4 is most probably not as optimized as a BSET D3,(A4) but A4 would have to point to the byte instead of the word...
_pixelEmpty:
	lea 40(a4),a4
	addq.b #1,d6
	dbf d5,_pixel_loop

	ENDC

	; Move to the next column in the bitplane

	IFNE BLITTER

	;Blitter: it requires the number of the pixel in the word of the screen
	addi.w #$1000,d3
	bcc _pixelKeepWord
	addq.w #2,d2
_pixelKeepWord:

	ELSE

	; CPU: it requires the number of the bit matching the pixel in the word of the screen
	subq.b #1,d3
	bge _pixelKeepWord
	addq.w #2,d2
	moveq #15,d3
_pixelKeepWord:

	ENDC

	; Move to the next column or loop on the first

	cmp.l a1,a3
	bne _nextColumnLoop
	movea.l textColumns,a1
_nextColumnLoop:

	; Sine of the next column

	subq.w #(SINE_SPEED_PIXEL<<1),d0
	bge _anglePixelNoLoop
	addi.w #(360<<1),d0
_anglePixelNoLoop:

	dbf d1,_writeLoop
	
	; Scroll the text

	move.l scrollColumn,d0
	addq.l #SCROLL_SPEED,d0
	cmp.l textNbColumns,d0
	blt _scrollnoloop
	sub.l textNbColumns,d0
_scrollnoloop:
	move.l d0,scrollColumn

	; Animate the sine of the image

	move.w angle,d0
	subi.w #(SINE_SPEED_FRAME<<1),d0
	bge _angleFrameNoLoop
	addi.w #(360<<1),d0
_angleFrameNoLoop:
	move.w d0,angle

	; Erase the hidden bitplane

	WAITBLIT
	move.w #0,BLTDMOD(a5)
	move.w #$0000,BLTCON1(a5)
	move.w #$0100,BLTCON0(a5)
	move.l bitplaneC,BLTDPTH(a5)
	move.w #(DISPLAY_DX>>4)!(DISPLAY_DY<<6),BLTSIZE(a5)

	IFNE DEBUGDISPLAYTIME
	move.w #$00F0,COLOR00(a5)
	ENDC
	
;********** DEBUGDISPLAYTIME (start) **********
; display the decimal number of lines since the end of the screen (ie: since line DISPLAY_Y+DISPLAY_DY included)
	; the frame ends at DISPLAY_Y+DISPLAY_DY-1
	; the time is the number of lines since line DISPLAY_Y+DISPLAY_DY included
	IFNE DEBUGDISPLAYTIME
	movem.l d0-d2/a0-a3,-(sp)
	clr.w d0
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0
	bge _timeBelowBitplanes
	; we looped to the top of the screen
	add.w #1+312-(DISPLAY_Y+DISPLAY_DY-1),d0	; 312 is the very last line that the electron beam may draw
	bra _timeDisplayCounter
_timeBelowBitplanes:
	; we are still at the bottom of the screen
	sub.w #DISPLAY_Y+DISPLAY_DY-1,d0
_timeDisplayCounter:
;=>d0.w = # of lines required by the calculations to display
	and.l #$0000FFFF,d0
	moveq #0,d1
	moveq #3-1,d2
_timeLoopNumber:
	divu #10,d0					; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0			; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
	lsl.l #8,d1
	clr.w d0
	swap d0
	dbf d2,_timeLoopNumber
	divu #10,d0					; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0			; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
;=> d1 : d1 : sequence of 4 ASCII offsets in the font for the 4 characters to display, but in reverse order (ex: 123 => "3210")
	lea font8,a0
	movea.l bitplaneB,a1
	moveq #4-1,d0
_timeLoopDisplay:
	clr.w d2
	move.b d1,d2
	lsl.w #3,d2
	lea (a0,d2.w),a2
	move.l a1,a3
	moveq #8-1,d2
_timeLoopDisplayChar:
	move.b (a2)+,(a3)
	lea DISPLAY_DX>>3(a3),a3
	dbf d2,_timeLoopDisplayChar
	lea 1(a1),a1
	lsr.l #8,d1
	dbf d0,_timeLoopDisplay
	movem.l (sp)+,d0-d2/a0-a3
	ENDC
;********** DISPLAYTIME (end) **********

	btst #6,$bfe001
	bne _loop
_loopEnd:
	WAITBLIT

;---------- Finalizations ----------

; Shut down the hardware interrupts and the DMAs

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

; Restore the hardware interrupts and the DMAs

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

	lea graphicslibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

; Restore the system

	movea.l $4,a6
	jsr -138(a6)

; Free memory

	movea.l font16,a1
	move.l #256<<5,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l bitplaneA,a1
	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l bitplaneB,a1
	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l bitplaneC,a1
	move.l #(DISPLAY_DX*DISPLAY_DY)>>3,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l copperlist,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)
	movea.l textColumns,a1
	move.l textColumnsSize,d0
	movea.l $4,a6
	jsr -210(a6)

; Unstack the registers

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Data ----------

graphicslibrary:		DC.B "graphics.library",0
	EVEN
font8:					INCBIN "font8.fnt"
	EVEN
text:					DC.B $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $62, $69, $7a, $7c, $7a, $7e, $77, $1b, $59, $49, $52, $55, $5c, $41, $1b, $42, $5a, $1b, $5a, $1b, $54, $55, $5e, $1b, $4b, $52, $43, $5e, $57, $1b, $48, $52, $55, $5e, $1b, $48, $58, $49, $54, $57, $57, $1a, $1b, $68, $54, $49, $49, $42, $17, $1b, $55, $54, $1b, $a, $d, $43, $a, $d, $1b, $5d, $54, $55, $4f, $1b, $5a, $4d, $5a, $52, $57, $5a, $59, $57, $5e, $15, $1b, $72, $1b, $53, $5a, $5f, $1b, $4f, $54, $1b, $48, $4f, $49, $5e, $4f, $58, $53, $1b, $5a, $1b, $3, $43, $3, $1b, $54, $55, $5e, $17, $1b, $53, $5e, $55, $58, $5e, $1b, $52, $4f, $48, $1b, $4b, $52, $43, $5e, $57, $5e, $5f, $1b, $57, $54, $54, $50, $15, $15, $15, $1b, $7c, $49, $5e, $5e, $4f, $52, $55, $5c, $48, $1b, $5d, $54, $57, $57, $54, $4c, $15, $15, $15, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $68, $6f, $74, $69, $76, $6f, $69, $74, $74, $6b, $7e, $69, $1, $1b, $73, $54, $4c, $1b, $52, $48, $1b, $6b, $5a, $55, $41, $5e, $49, $1b, $79, $57, $52, $4f, $41, $1b, $5c, $54, $52, $55, $5c, $4, $1b, $78, $5a, $55, $1c, $4f, $1b, $4c, $5a, $52, $4f, $1b, $4f, $54, $1b, $4b, $57, $5a, $42, $1b, $4f, $53, $5e, $1b, $5c, $5a, $56, $5e, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $7f, $7a, $69, $70, $1b, $7e, $75, $6f, $69, $72, $7e, $68, $1, $1b, $7f, $54, $1b, $42, $54, $4e, $1b, $48, $4f, $52, $57, $57, $1b, $54, $4c, $55, $1b, $42, $54, $4e, $49, $1b, $7a, $56, $52, $5c, $5a, $1b, $a, $b, $b, $b, $4, $1b, $77, $54, $54, $50, $1b, $4e, $55, $5f, $5e, $49, $48, $52, $5f, $5e, $1b, $4f, $53, $5e, $1b, $57, $52, $5f, $1, $1b, $4f, $53, $5e, $49, $5e, $1b, $56, $5a, $42, $1b, $59, $5e, $1b, $4d, $5a, $57, $4e, $5a, $59, $57, $5e, $1b, $48, $52, $5c, $55, $5a, $4f, $4e, $49, $5e, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $71, $6e, $75, $70, $72, $7e, $1, $1b, $75, $52, $58, $5e, $1b, $4f, $5e, $5a, $56, $1b, $4c, $54, $49, $50, $1b, $5f, $5e, $58, $54, $5f, $52, $55, $5c, $1b, $4f, $53, $5e, $1b, $7a, $7c, $7a, $1b, $49, $5e, $5c, $52, $48, $4f, $5e, $49, $48, $1a, $1b, $6f, $53, $54, $48, $5e, $1b, $5c, $4e, $42, $48, $1b, $5a, $4f, $1b, $78, $54, $56, $56, $54, $5f, $54, $49, $5e, $1b, $49, $5e, $5a, $57, $57, $42, $1b, $59, $5e, $57, $52, $5e, $4d, $5e, $5f, $1b, $55, $54, $59, $54, $5f, $42, $1b, $4c, $54, $4e, $57, $5f, $1b, $4f, $49, $42, $1b, $4f, $54, $1b, $56, $5e, $4f, $5a, $57, $1b, $59, $5a, $48, $53, $1b, $4f, $53, $5e, $1b, $58, $53, $52, $4b, $48, $5e, $4f, $4, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $78, $74, $69, $7e, $75, $6f, $72, $75, $1, $1b, $69, $5e, $56, $5e, $56, $59, $5e, $49, $52, $55, $5c, $1b, $4f, $53, $5e, $1b, $5d, $52, $49, $48, $4f, $1b, $4f, $52, $56, $5e, $1b, $72, $1b, $48, $5a, $4c, $1b, $5a, $55, $1b, $7a, $56, $52, $5c, $5a, $1b, $5c, $5a, $56, $5e, $15, $15, $15, $1b, $72, $4f, $1b, $4c, $5a, $48, $1b, $74, $59, $57, $52, $4f, $5e, $49, $5a, $4f, $54, $49, $1b, $49, $4e, $55, $55, $52, $55, $5c, $1b, $54, $55, $1b, $42, $54, $4e, $49, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $73, $7e, $7a, $7f, $73, $6e, $75, $6f, $7e, $69, $1, $1b, $6f, $53, $5a, $55, $43, $1b, $5a, $5c, $5a, $52, $55, $1b, $5d, $54, $49, $1b, $4f, $53, $5e, $1b, $5f, $52, $48, $5a, $59, $57, $5e, $5f, $1b, $5a, $58, $58, $5e, $48, $48, $1a, $1b, $78, $54, $55, $5f, $5e, $56, $55, $5e, $5f, $1b, $78, $5e, $57, $57, $4, $1b, $79, $5e, $48, $4f, $1b, $5c, $5e, $49, $56, $5a, $55, $1b, $79, $79, $68, $1b, $5e, $4d, $5e, $49, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $76, $74, $75, $6f, $62, $1, $1b, $68, $4e, $58, $53, $1b, $5c, $49, $5e, $5a, $4f, $1b, $4f, $4e, $55, $5e, $48, $1b, $5d, $54, $49, $1b, $4f, $53, $5e, $1b, $58, $49, $5a, $58, $50, $4f, $49, $54, $48, $1a, $1b, $6c, $53, $5a, $4f, $1b, $5a, $1b, $4f, $5e, $5a, $56, $1b, $4c, $5e, $1b, $56, $5a, $5f, $5e, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $73, $7e, $7a, $6f, $73, $7e, $75, $1, $1b, $77, $54, $54, $50, $1b, $5a, $4f, $1b, $42, $54, $4e, $1a, $1b, $6c, $53, $5a, $4f, $1b, $5a, $1b, $4b, $5a, $52, $55, $4f, $59, $5a, $57, $57, $1b, $58, $53, $5a, $56, $4b, $52, $54, $55, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $76, $7a, $63, $72, $76, $72, $77, $72, $7e, $75, $1, $1b, $72, $1b, $5f, $54, $4e, $59, $4f, $1b, $42, $54, $4e, $1b, $4c, $52, $57, $57, $1b, $49, $5e, $5a, $5f, $1b, $4f, $53, $52, $48, $1b, $54, $55, $5e, $17, $1b, $59, $4e, $4f, $1b, $4c, $53, $5a, $4f, $5e, $4d, $5e, $49, $15, $15, $15, $1b, $72, $4f, $1b, $4c, $5a, $48, $1b, $5d, $4e, $55, $1b, $4f, $54, $1b, $58, $54, $5f, $5e, $1b, $4f, $53, $54, $48, $5e, $1b, $58, $49, $5a, $58, $50, $4f, $49, $54, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $6f, $69, $72, $68, $6f, $7a, $75, $1, $1b, $62, $54, $4e, $1b, $4c, $5e, $49, $5e, $1b, $49, $52, $5c, $53, $4f, $1, $1b, $7a, $76, $74, $68, $1b, $52, $48, $1b, $77, $7a, $76, $74, $68, $1a, $1b, $7a, $68, $76, $1b, $49, $4e, $57, $5e, $41, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $7d, $72, $69, $7e, $78, $69, $7a, $78, $70, $7e, $69, $1, $1b, $73, $52, $17, $1b, $56, $5a, $55, $1a, $1b, $73, $54, $4b, $5e, $1b, $42, $54, $4e, $1c, $49, $5e, $1b, $55, $54, $4f, $1b, $59, $54, $49, $52, $55, $5c, $1b, $4f, $54, $1b, $5f, $5e, $5a, $4f, $53, $1b, $5a, $4f, $1b, $42, $54, $4e, $49, $1b, $59, $5a, $55, $50, $1a, $1b, $1b, $15, $54, $74, $54, $15, $3b
	EVEN
textLamer:				DC.B $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $62, $54, $4e, $1b, $5a, $49, $5e, $1b, $5a, $1b, $77, $7a, $76, $7e, $69, $1a, $3b
	EVEN
textColumns:			DC.L 0
textNbColumns:			DC.L 0
textColumnsSize:		DC.L 0
ordinates:				DC.L 0
scrollColumn:			DC.L 0
olddmacon:				DC.W 0
oldintena:				DC.W 0
oldintreq:				DC.W 0
textChecksum:			DC.L TEXT_CHECKSUM
angle:					DC.W 0
copperlist:				DC.L 0
font16:					DC.L 0
bitplaneA:				DC.L 0
bitplaneB:				DC.L 0
bitplaneC:				DC.L 0
sinus:					DC.W 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286