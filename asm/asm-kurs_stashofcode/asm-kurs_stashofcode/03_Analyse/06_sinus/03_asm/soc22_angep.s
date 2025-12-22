
; soc22.s = sinescroll.s

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
TEXT_CHECKSUM=$12e69
TEXT_CHECKSUM_LAMER=$7f6
COPSIZE=18*4+14*4+4

;---------- Macros ----------

; Wait for the Blitter. When the second operand is an address, BTST can only test bits 7-0 of the addressed byte, 
; but since the first operand is the number of the bit modulo 8, BTST #14,DMACONR(a5) means testing bit 14%8=6 of 
; the most significant byte of DMACONR, which is BBUSY as expected...

WAITBLIT:	MACRO
_waitBlitter0\@
	btst #14,DMACONR(a5)
	bne _waitBlitter0\@
_waitBlitter1\@
	btst #14,DMACONR(a5)
	bne _waitBlitter1\@
	ENDM

; Control the integrity of the text to diplay. Watch for the context in which the macro is used, because the 
; macro may modified the length of the initial text (which must be at least as long as "You are a LAMER!", 
; or data wil be overwritten) and make the code that was using it go berzerk

; ------------------------------------------ soc22d.s (auch: soc22b.s, soc22c.s) Anfang
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
; ------------------------------------------ soc22d.s (auch: soc22b.s, soc22c.s) Ende

;---------- Initializations ----------

; Stack the registers

	movem.l d0-d7/a0-a6,-(sp)

; Allocate Chip memory set to 0 for the Copper list

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperlist

; Allocate Chip memory set to 0 for the bitplanes

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

; Shut down the system

	movea.l $4,a6
	jsr -132(a6)

; Shut down the hardware

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
	move.w #SHADOW_DX<<4,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #0,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+	; Same thing as ((DISPLAY_X-17+DISPLAY_DX-16)>>1)&$00FC if DISPLAY_DX is multiple of 16
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

; Bitplanes addresses

	move.w #BPL1PTL,(a0)+
	move.l bitplaneA,d0
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
	move.w #$0186,(a0)+		; COLOR04 not used. That's just to avoid modifying COLOR00...
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
	move.w #$0188,(a0)+			; COLOR04 not used. That's just to avoid modifying COLOR00...
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
	move.w #$83C0,DMACON(a5)	; DMAEN=1, COPEN=1, BPLEN=1, COPEN=1, BLTEN=1

;---------- Creation of a 16x16 font from a 8x8 font ----------

; Prepare the data for the font (1st byte = serie of bits 7 of the 8 lignes / bytes
; of the character, 2nd byte = serie of bits 6 of the 8 lines / bytes of the character,
; and so on: a -90° rotation). Note that when using the Blitter, the columns must be
; drawn from the last to the first because of the way the pattern is oriented 
; (it should be flipped around the Y axis if it were to be drawn from the first to the last column)

; -------------------------------------------------------------------- soc22a.s Anfang
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
	bra _fontPixelNext
_fontPixelEmpty:
	addq.b #2,d4
_fontPixelNext:
	addq.b #1,d5
	btst #4,d4
	beq _fontColumnLoop
	move.w d3,(a1)+
	move.w d3,(a1)+
	dbf d1,_fontLineLoop
	lea 8(a0),a0
	dbf d0,_fontLoop
; -------------------------------------------------------------------- soc22a.s Ende

; ---------- Main loop ----------

; Main loop
	
	CHECKTEXT
_loop:

; Wait for the electron beam to finish drawing the screen (presumes that the
; execution will take more time than it takes for the electron beam to loop on line 0)

; -------------------------------------------------------------------- soc22e.s Anfang
_waitVBL:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0
	blt _waitVBL
; -------------------------------------------------------------------- soc22e.s Ende
	IFNE DEBUGDISPLAYTIME
	move.w #$0F00,COLOR00(a5)
	ENDC

; Bitplanes circular permutation

; -------------------------------------------------------------------- soc22f.s Anfang
	move.l bitplaneA,d0
	move.l bitplaneB,d1
	move.l bitplaneC,d2
	move.l d1,bitplaneA
	move.l d2,bitplaneB
	move.l d0,bitplaneC
; -------------------------------------------------------------------- soc22f.s Ende
	movea.l copperlist,a0
	move.w d1,9*4+2(a0)
	move.w d1,10*4+2(a0)
	swap d1
	move.w d1,11*4+2(a0)
	move.w d1,12*4+2(a0)

; Display the sine scroll (d0 must be the offset of the sine of the current angle)

; -------------------------------------------------------------------- soc22g.s Anfang
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

; -------------------------------------------------------------------- soc22g.s Ende

; -------------------------------------------------------------------- soc22h.s Anfang
; Get the offset of the word of the bitplane where the first column must be drawn

	moveq #SCROLL_X,d6
	lsr.w #3,d6				; Offset of the byte in the column of the bitplane
	bclr #0,d6				; Offset of the word (same thing as lsr.w #4 then lsl.w #1)

; Get the bit in this word matching this column

	IFNE BLITTER
	
; Blitter: it requires the number of the pixel in the word of the screen
	moveq #SCROLL_X,d7
	and.w #$000F,d7

	ELSE
	
; CPU:  it requires the number of the bit matching the pixel in the word of the screen
	moveq #SCROLL_X,d4
	and.w #$000F,d4
	moveq #15,d7
	sub.b d4,d7

	ENDC

; -------------------------------------------------------------------- soc22h.s Ende

; -------------------------------------------------------------------- soc22i.s Anfang
; Get the address of the current character and its current column

	move.w scrollChar,d0
	lea text,a0
	lea (a0,d0.w),a0
	move.w scrollColumn,d4
	clr.w d1
	move.b (a0)+,d1			; characted to display
	eor.b #TEXT_XOR,d1
	subi.b #$20,d1
	lsl.w #5,d1				; 32 bytes per character in the 16x16 police
	move.w d4,d2			; column of pixels of the character to display
	lsl.w #1,d2				; 2 bytes per line in the 16x16 font
	add.w d2,d1
	move.l font16,a1
	lea (a1,d1.w),a1		; address of the current column in the bitmap of the character to display

; -------------------------------------------------------------------- soc22i.s Ende

; -------------------------------------------------------------------- soc22j.s Anfang
; Various initializations
	
	move.w angle,d0
	move.w #SCROLL_DX-1,d1
	move.l bitplaneB,a2

; Draw the columns of characters in the bitplane
	
_writeLoop:
	move.w d1,-(sp)

; Compute the address of the word that contains the column to draw in the bitplane
	
	lea sinus,a6
	move.w (a6,d0.w),d1
	muls #(SCROLL_AMPLITUDE>>1),d1
	swap d1
	rol.l #2,d1
	add.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1
	move.w d1,d2
	lsl.w #5,d1
	lsl.w #3,d2
	add.w d2,d1				; d1 = (DISPLAY_DX>>3)*d1 = 40*d1 = (32*d1)+(8*d1) = (2^5*d1)+(2^3*d1)
	add.w d6,d1
	lea (a2,d1.w),a4

; -------------------------------------------------------------------- soc22j.s Ende

; -------------------------------------------------------------------- soc22k.s Anfang
; Display the current column of the current character

	IFNE BLITTER

; Blitter: draw the column as one line (presumes that LINE_DX > LINE_DY)

	WAITBLIT
	lea LINE_DX*(DISPLAY_DX>>3)(a4),a4
	move.l a4,BLTCPTH(a5)
	move.l a4,BLTDPTH(a5)
	move.w (a1),BLTBDAT(a5)
	move.w d7,d2
	ror.w #4,d2
	or.w #$0B4A,d2
	move.w d2,BLTCON0(a5)		; ASH3-0=pixel, USEA=1, USEB=0, USEC=1, USED=1, LF7-0=AB+AC=$4A
	move.w #((LINE_DX+1)<<6)!$0002,BLTSIZE(a5)
; -------------------------------------------------------------------- soc22k.s Ende
	ELSE
; -------------------------------------------------------------------- soc22l.s Anfang	 1. Teil
; CPU: draw the column bit after bit

	move.w (a1),d1
	clr.w d2
	moveq #LINE_DX,d5
_columnLoop:
	move.w (a4),d3
	btst d2,d1
	beq _pixelEmpty
	bset d7,d3
	bra _pixelFilled
_pixelEmpty:
	bclr d7,d3
_pixelFilled:
	move.w d3,(a4)
	lea DISPLAY_DX>>3(a4),a4
	addq.b #1,d2
	dbf d5,_columnLoop
; -------------------------------------------------------------------- soc22l.s Ende geht noch weiter 
	ENDC
; -------------------------------------------------------------------- soc22m.s Anfang
; Move to the next column of the character (current, next or first)

	addq.b #1,d4
	btst #4,d4
	beq _writeKeepChar
	bclr #4,d4
; index the current column of pixels of the current character
	clr.w d1
	move.b (a0)+,d1			; characted to display
	eor.b #TEXT_XOR,d1
	bne _writeNoTextLoop
	lea text,a0
	move.b (a0)+,d1			; characted to display
	eor.b #TEXT_XOR,d1
_writeNoTextLoop
	subi.b #$20,d1
	lsl.w #5,d1				; 32 bytes per character in the 16x16 police
	move.l font16,a1
	lea (a1,d1.w),a1		; address of the current column in the bitmap of the character to display
	bra _writeKeepColumn
_writeKeepChar:
	lea 2(a1),a1
_writeKeepColumn:

; -------------------------------------------------------------------- soc22m.s Ende

; -------------------------------------------------------------------- soc22n.s Anfang
; Sine of the next column

	subq.w #(SINE_SPEED_PIXEL<<1),d0
	bge _anglePixelNoLoop
	add.w #(360<<1),d0
_anglePixelNoLoop:

	IFNE BLITTER

; Move to the next column in the bitplane
	
; Blitter: it requires the number of the pixel in the word
	addq.b #1,d7
	btst #4,d7
	beq _pixelKeepWord
	addq.w #2,d6
	clr.b d7
_pixelKeepWord:

	ELSE
; -------------------------------------------------------------------- soc22l.s Anfang	 2. Teil
; CPU: it requires the number of the pixel in the word of the screen
	subq.b #1,d7
	bge _pixelKeepWord
	addq.w #2,d6
	moveq #15,d7
_pixelKeepWord:
; -------------------------------------------------------------------- soc22l.s Ende
; -------------------------------------------------------------------- soc22n.s Ende	
	ENDC

	move.w (sp)+,d1
	dbf d1,_writeLoop

; -------------------------------------------------------------------- soc22p.s Anfang	
; Animate the sine of the image

	move.w angle,d0
	sub.w #(SINE_SPEED_FRAME<<1),d0
	bge _angleFrameNoLoop
	add.w #(360<<1),d0
_angleFrameNoLoop:
	move.w d0,angle
; -------------------------------------------------------------------- soc22p.s Ende

; -------------------------------------------------------------------- soc22q.s Anfang	
; Scroll the text

	move.w scrollColumn,d0
	addq.w #SCROLL_SPEED,d0
	cmp.b #15,d0			; Is the new column after the last of the character?
	;ble _scrollNextColumn	; If not, nothing happens
	blt _scrollNextColumn
	sub.b #15,d0			; If yes, get the new column in the next character...
	move.w scrollChar,d1
	addq.w #1,d1			; ..and move to the next character
	lea text,a0
	move.b (a0,d1.w),d2		; Is the new character after the last one?
	eor.b #TEXT_XOR,d2
	bne _scrollNextChar
	clr.w d1				; If yes, loop on the first character
_scrollNextChar:
	move.w d1,scrollChar
_scrollNextColumn:
	move.w d0,scrollColumn
; -------------------------------------------------------------------- soc22q.s Ende

; -------------------------------------------------------------------- soc22r.s Anfang
; Erase the hidden bitplane

	WAITBLIT
	move.w #0,BLTDMOD(a5)
	move.w #$0000,BLTCON1(a5)
	move.w #%0000000100000000,BLTCON0(a5)
	move.l bitplaneC,BLTDPTH(a5)
	move.w #(DISPLAY_DX>>4)!(DISPLAY_DY<<6),BLTSIZE(a5)
; -------------------------------------------------------------------- soc22r.s Ende

	IFNE DEBUGDISPLAYTIME
	move.w #$00F0,COLOR00(a5)
	ENDC

; ---------------------------------------------------soc22s.s (auch: soc22s2.s) Anfang

; ********** DEBUGDISPLAYTIME (start) **********
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
; =>d0.w = # of lines required by the calculations to display
	and.l #$0000FFFF,d0
	moveq #0,d1
	moveq #3-1,d2
_timeLoopNumber:
	divu #10,d0			; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0	; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
	lsl.l #8,d1
	clr.w d0
	swap d0
	dbf d2,_timeLoopNumber
	divu #10,d0			; => d0=remainder:quotient of the division of d0 coded on 32 bits
	swap d0
	add.b #$30-$20,d0	; ASCII code for "0" minus the first character offset in font8 ($20)
	move.b d0,d1
; => d1 : d1 : sequence of 4 ASCII offsets in the font for the 4 characters to display, but in reverse order (ex: 123 => "3210")
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
; ********** DISPLAYTIME (end) **********
; ---------------------------------------------------soc22s.s (auch: soc22s2.s) Ende

	; Test if the mouse button is pushed

	btst #6,$bfe001
	bne _loop
_loopEnd:
	WAITBLIT

; ---------- Finalizations ----------

; Shut down the hardware

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

; Restore the hardware

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

; Unstack the registers

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Data ----------

graphicslibrary:		DC.B "graphics.library",0
	EVEN
font8:
						INCBIN "font8.fnt"
	EVEN
;text:					DC.B $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $62, $69, $7a, $7c, $7a, $7e, $77, $1b, $59, $49, $52, $55, $5c, $41, $1b, $42, $5a, $1b, $5a, $1b, $54, $55, $5e, $1b, $4b, $52, $43, $5e, $57, $1b, $48, $52, $55, $5e, $1b, $48, $58, $49, $54, $57, $57, $1a, $1b, $68, $54, $49, $49, $42, $17, $1b, $55, $54, $1b, $a, $d, $43, $a, $d, $1b, $5d, $54, $55, $4f, $1b, $5a, $4d, $5a, $52, $57, $5a, $59, $57, $5e, $15, $1b, $72, $1b, $53, $5a, $5f, $1b, $4f, $54, $1b, $48, $4f, $49, $5e, $4f, $58, $53, $1b, $5a, $1b, $3, $43, $3, $1b, $54, $55, $5e, $17, $1b, $53, $5e, $55, $58, $5e, $1b, $52, $4f, $48, $1b, $4b, $52, $43, $5e, $57, $5e, $5f, $1b, $57, $54, $54, $50, $15, $15, $15, $1b, $7c, $49, $5e, $5e, $4f, $52, $55, $5c, $48, $1b, $5d, $54, $57, $57, $54, $4c, $15, $15, $15, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $68, $6f, $74, $69, $76, $6f, $69, $74, $74, $6b, $7e, $69, $1, $1b, $73, $54, $4c, $1b, $52, $48, $1b, $6b, $5a, $55, $41, $5e, $49, $1b, $79, $57, $52, $4f, $41, $1b, $5c, $54, $52, $55, $5c, $4, $1b, $78, $5a, $55, $1c, $4f, $1b, $4c, $5a, $52, $4f, $1b, $4f, $54, $1b, $4b, $57, $5a, $42, $1b, $4f, $53, $5e, $1b, $5c, $5a, $56, $5e, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $7f, $7a, $69, $70, $1b, $7e, $75, $6f, $69, $72, $7e, $68, $1, $1b, $7f, $54, $1b, $42, $54, $4e, $1b, $48, $4f, $52, $57, $57, $1b, $54, $4c, $55, $1b, $42, $54, $4e, $49, $1b, $7a, $56, $52, $5c, $5a, $1b, $a, $b, $b, $b, $4, $1b, $77, $54, $54, $50, $1b, $4e, $55, $5f, $5e, $49, $48, $52, $5f, $5e, $1b, $4f, $53, $5e, $1b, $57, $52, $5f, $1, $1b, $4f, $53, $5e, $49, $5e, $1b, $56, $5a, $42, $1b, $59, $5e, $1b, $4d, $5a, $57, $4e, $5a, $59, $57, $5e, $1b, $48, $52, $5c, $55, $5a, $4f, $4e, $49, $5e, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $71, $6e, $75, $70, $72, $7e, $1, $1b, $75, $52, $58, $5e, $1b, $4f, $5e, $5a, $56, $1b, $4c, $54, $49, $50, $1b, $5f, $5e, $58, $54, $5f, $52, $55, $5c, $1b, $4f, $53, $5e, $1b, $7a, $7c, $7a, $1b, $49, $5e, $5c, $52, $48, $4f, $5e, $49, $48, $1a, $1b, $6f, $53, $54, $48, $5e, $1b, $5c, $4e, $42, $48, $1b, $5a, $4f, $1b, $78, $54, $56, $56, $54, $5f, $54, $49, $5e, $1b, $49, $5e, $5a, $57, $57, $42, $1b, $59, $5e, $57, $52, $5e, $4d, $5e, $5f, $1b, $55, $54, $59, $54, $5f, $42, $1b, $4c, $54, $4e, $57, $5f, $1b, $4f, $49, $42, $1b, $4f, $54, $1b, $56, $5e, $4f, $5a, $57, $1b, $59, $5a, $48, $53, $1b, $4f, $53, $5e, $1b, $58, $53, $52, $4b, $48, $5e, $4f, $4, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $78, $74, $69, $7e, $75, $6f, $72, $75, $1, $1b, $69, $5e, $56, $5e, $56, $59, $5e, $49, $52, $55, $5c, $1b, $4f, $53, $5e, $1b, $5d, $52, $49, $48, $4f, $1b, $4f, $52, $56, $5e, $1b, $72, $1b, $48, $5a, $4c, $1b, $5a, $55, $1b, $7a, $56, $52, $5c, $5a, $1b, $5c, $5a, $56, $5e, $15, $15, $15, $1b, $72, $4f, $1b, $4c, $5a, $48, $1b, $74, $59, $57, $52, $4f, $5e, $49, $5a, $4f, $54, $49, $1b, $49, $4e, $55, $55, $52, $55, $5c, $1b, $54, $55, $1b, $42, $54, $4e, $49, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $73, $7e, $7a, $7f, $73, $6e, $75, $6f, $7e, $69, $1, $1b, $6f, $53, $5a, $55, $43, $1b, $5a, $5c, $5a, $52, $55, $1b, $5d, $54, $49, $1b, $4f, $53, $5e, $1b, $5f, $52, $48, $5a, $59, $57, $5e, $5f, $1b, $5a, $58, $58, $5e, $48, $48, $1a, $1b, $78, $54, $55, $5f, $5e, $56, $55, $5e, $5f, $1b, $78, $5e, $57, $57, $4, $1b, $79, $5e, $48, $4f, $1b, $5c, $5e, $49, $56, $5a, $55, $1b, $79, $79, $68, $1b, $5e, $4d, $5e, $49, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $76, $74, $75, $6f, $62, $1, $1b, $68, $54, $1b, $5c, $49, $5e, $5a, $4f, $1b, $4f, $4e, $55, $5e, $48, $1b, $5d, $54, $49, $1b, $4f, $53, $5e, $1b, $58, $49, $5a, $58, $50, $4f, $49, $54, $48, $1a, $1b, $6c, $53, $5a, $4f, $1b, $5a, $1b, $4f, $5e, $5a, $56, $1b, $4c, $5e, $1b, $56, $5a, $5f, $5e, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $73, $7e, $7a, $6f, $73, $7e, $75, $1, $1b, $77, $54, $54, $50, $1b, $5a, $4f, $1b, $42, $54, $4e, $1a, $1b, $6c, $53, $5a, $4f, $1b, $5a, $1b, $4b, $5a, $52, $55, $4f, $59, $5a, $57, $57, $1b, $58, $53, $5a, $56, $4b, $52, $54, $55, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $76, $7a, $63, $72, $76, $72, $77, $72, $7e, $75, $1, $1b, $72, $1b, $5f, $54, $4e, $59, $4f, $1b, $42, $54, $4e, $1b, $4c, $52, $57, $57, $1b, $49, $5e, $5a, $5f, $1b, $4f, $53, $52, $48, $1b, $54, $55, $5e, $17, $1b, $59, $4e, $4f, $1b, $4c, $53, $5a, $4f, $5e, $4d, $5e, $49, $15, $15, $15, $1b, $72, $4f, $1b, $4c, $5a, $48, $1b, $5d, $4e, $55, $1b, $4f, $54, $1b, $58, $54, $5f, $5e, $1b, $4f, $53, $54, $48, $5e, $1b, $58, $49, $5a, $58, $50, $4f, $49, $54, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $6f, $69, $72, $68, $6f, $7a, $75, $1, $1b, $62, $54, $4e, $1b, $4c, $5e, $49, $5e, $1b, $49, $52, $5c, $53, $4f, $1, $1b, $7a, $76, $74, $68, $1b, $52, $48, $1b, $77, $7a, $76, $74, $68, $1a, $1b, $7a, $68, $76, $1b, $49, $4e, $57, $5e, $41, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $7d, $72, $69, $7e, $78, $69, $7a, $78, $70, $7e, $69, $1, $1b, $73, $52, $17, $1b, $56, $5a, $55, $1a, $1b, $73, $54, $4b, $5e, $1b, $42, $54, $4e, $1c, $49, $5e, $1b, $55, $54, $4f, $1b, $59, $54, $49, $52, $55, $5c, $1b, $4f, $54, $1b, $5f, $5e, $5a, $4f, $53, $1b, $52, $55, $1b, $42, $54, $4e, $49, $1b, $59, $5a, $55, $50, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $3b
text:					; der verschlüsselte Text
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B62, $697A, $7C7A, $7E77
	dc.w $1B59, $4952, $555C, $411B, $425A, $1B5A, $1B54, $555E
	dc.w $1B4B, $5243, $5E57, $1B48, $5255, $5E1B, $4858, $4954
	dc.w $5757, $1A1B, $6854, $4949, $4217, $1B55, $541B, $0A0D
	dc.w $430A, $0D1B, $5D54, $554F, $1B5A, $4D5A, $5257, $5A59
	dc.w $575E, $151B, $721B, $535A, $5F1B, $4F54, $1B48, $4F49
	dc.w $5E4F, $5853, $1B5A, $1B03, $4303, $1B54, $555E, $171B
	dc.w $535E, $5558, $5E1B, $524F, $481B, $4B52, $435E, $575E
	dc.w $5F1B, $5754, $5450, $1515, $151B, $7C49, $5E5E, $4F52
	dc.w $555C, $481B, $5D54, $5757, $544C, $1515, $151B, $1B15
	dc.w $5474, $5415, $1B1B, $686F, $7469, $766F, $6974, $746B
	dc.w $7E69, $011B, $7354, $4C1B, $5248, $1B6B, $5A55, $415E
	dc.w $491B, $7957, $524F, $411B, $5C54, $5255, $5C04, $1B78
	dc.w $5A55, $1C4F, $1B4C, $5A52, $4F1B, $4F54, $1B4B, $575A
	dc.w $421B, $4F53, $5E1B, $5C5A, $565E, $1A1B, $1B15, $5474
	dc.w $5415, $1B1B, $7F7A, $6970, $1B7E, $756F, $6972, $7E68
	dc.w $011B, $7F54, $1B42, $544E, $1B48, $4F52, $5757, $1B54
	dc.w $4C55, $1B42, $544E, $491B, $7A56, $525C, $5A1B, $0A0B
	dc.w $0B0B, $041B, $7754, $5450, $1B4E, $555F, $5E49, $4852
	dc.w $5F5E, $1B4F, $535E, $1B57, $525F, $011B, $4F53, $5E49
	dc.w $5E1B, $565A, $421B, $595E, $1B4D, $5A57, $4E5A, $5957
	dc.w $5E1B, $4852, $5C55, $5A4F, $4E49, $5E48, $1A1B, $1B15
	dc.w $5474, $5415, $1B1B, $716E, $7570, $727E, $011B, $7552
	dc.w $585E, $1B4F, $5E5A, $561B, $4C54, $4950, $1B5F, $5E58
	dc.w $545F, $5255, $5C1B, $4F53, $5E1B, $7A7C, $7A1B, $495E
	dc.w $5C52, $484F, $5E49, $481A, $1B6F, $5354, $485E, $1B5C
	dc.w $4E42, $481B, $5A4F, $1B78, $5456, $5654, $5F54, $495E
	dc.w $1B49, $5E5A, $5757, $421B, $595E, $5752, $5E4D, $5E5F
	dc.w $1B55, $5459, $545F, $421B, $4C54, $4E57, $5F1B, $4F49
	dc.w $421B, $4F54, $1B56, $5E4F, $5A57, $1B59, $5A48, $531B
	dc.w $4F53, $5E1B, $5853, $524B, $485E, $4F04, $1B1B, $1554
	dc.w $7454, $151B, $1B78, $7469, $7E75, $6F72, $7501, $1B69
	dc.w $5E56, $5E56, $595E, $4952, $555C, $1B4F, $535E, $1B5D
	dc.w $5249, $484F, $1B4F, $5256, $5E1B, $721B, $485A, $4C1B
	dc.w $5A55, $1B7A, $5652, $5C5A, $1B5C, $5A56, $5E15, $1515
	dc.w $1B72, $4F1B, $4C5A, $481B, $7459, $5752, $4F5E, $495A
	dc.w $4F54, $491B, $494E, $5555, $5255, $5C1B, $5455, $1B42
	dc.w $544E, $4948, $1A1B, $1B15, $5474, $5415, $1B1B, $737E
	dc.w $7A7F, $736E, $756F, $7E69, $011B, $6F53, $5A55, $431B
	dc.w $5A5C, $5A52, $551B, $5D54, $491B, $4F53, $5E1B, $5F52
	dc.w $485A, $5957, $5E5F, $1B5A, $5858, $5E48, $481A, $1B78
	dc.w $5455, $5F5E, $5655, $5E5F, $1B78, $5E57, $5704, $1B79
	dc.w $5E48, $4F1B, $5C5E, $4956, $5A55, $1B79, $7968, $1B5E
	dc.w $4D5E, $491A, $1B1B, $1554, $7454, $151B, $1B76, $7475
	dc.w $6F62, $011B, $6854, $1B5C, $495E, $5A4F, $1B4F, $4E55
	dc.w $5E48, $1B5D, $5449, $1B4F, $535E, $1B58, $495A, $5850
	dc.w $4F49, $5448, $1A1B, $6C53, $5A4F, $1B5A, $1B4F, $5E5A
	dc.w $561B, $4C5E, $1B56, $5A5F, $5E1A, $1B1B, $1554, $7454
	dc.w $151B, $1B73, $7E7A, $6F73, $7E75, $011B, $7754, $5450
	dc.w $1B5A, $4F1B, $4254, $4E1A, $1B6C, $535A, $4F1B, $5A1B
	dc.w $4B5A, $5255, $4F59, $5A57, $571B, $5853, $5A56, $4B52
	dc.w $5455, $1A1B, $1B15, $5474, $5415, $1B1B, $767A, $6372
	dc.w $7672, $7772, $7E75, $011B, $721B, $5F54, $4E59, $4F1B
	dc.w $4254, $4E1B, $4C52, $5757, $1B49, $5E5A, $5F1B, $4F53
	dc.w $5248, $1B54, $555E, $171B, $594E, $4F1B, $4C53, $5A4F
	dc.w $5E4D, $5E49, $1515, $151B, $724F, $1B4C, $5A48, $1B5D
	dc.w $4E55, $1B4F, $541B, $5854, $5F5E, $1B4F, $5354, $485E
	dc.w $1B58, $495A, $5850, $4F49, $5448, $1A1B, $1B15, $5474
	dc.w $5415, $1B1B, $6F69, $7268, $6F7A, $7501, $1B62, $544E
	dc.w $1B4C, $5E49, $5E1B, $4952, $5C53, $4F01, $1B7A, $7674
	dc.w $681B, $5248, $1B77, $7A76, $7468, $1A1B, $7A68, $761B
	dc.w $494E, $575E, $411A, $1B1B, $1554, $7454, $151B, $1B7D
	dc.w $7269, $7E78, $697A, $7870, $7E69, $011B, $7352, $171B
	dc.w $565A, $551A, $1B73, $544B, $5E1B, $4254, $4E1C, $495E
	dc.w $1B55, $544F, $1B59, $5449, $5255, $5C1B, $4F54, $1B5F
	dc.w $5E5A, $4F53, $1B52, $551B, $4254, $4E49, $1B59, $5A55
	dc.w $501A, $1B1B, $1554, $7454, $151B, $1B3B, $0000
;	EVEN
;textLamer:				DC.B $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $62, $54, $4e, $1b, $5a, $49, $5e, $1b, $5a, $1b, $77, $7a, $76, $7e, $69, $1a, $3b
;	EVEN

textLamer:	
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B62, $544E, $1B5A, $495E
	dc.w $1B5A, $1B77, $7A76, $7E69, $1A3B, $0000
	EVEN

olddmacon:				DC.W 0
oldintena:				DC.W 0
oldintreq:				DC.W 0
textChecksum:			DC.L TEXT_CHECKSUM
scrollColumn:			DC.W 0
scrollChar:				DC.W 0
angle:					DC.W 0
copperlist:				DC.L 0
font16:					DC.L 0
bitplaneA:				DC.L 0
bitplaneB:				DC.L 0
bitplaneC:				DC.L 0
;sinus:					DC.W 0, 286, 572, 857, 1143, 1428, 1713, 1997, 2280, 2563, 2845, 3126, 3406, 3686, 3964, 4240, 4516, 4790, 5063, 5334, 5604, 5872, 6138, 6402, 6664, 6924, 7182, 7438, 7692, 7943, 8192, 8438, 8682, 8923, 9162, 9397, 9630, 9860, 10087, 10311, 10531, 10749, 10963, 11174, 11381, 11585, 11786, 11982, 12176, 12365, 12551, 12733, 12911, 13085, 13255, 13421, 13583, 13741, 13894, 14044, 14189, 14330, 14466, 14598, 14726, 14849, 14968, 15082, 15191, 15296, 15396, 15491, 15582, 15668, 15749, 15826, 15897, 15964, 16026, 16083, 16135, 16182, 16225, 16262, 16294, 16322, 16344, 16362, 16374, 16382, 16384, 16382, 16374, 16362, 16344, 16322, 16294, 16262, 16225, 16182, 16135, 16083, 16026, 15964, 15897, 15826, 15749, 15668, 15582, 15491, 15396, 15296, 15191, 15082, 14968, 14849, 14726, 14598, 14466, 14330, 14189, 14044, 13894, 13741, 13583, 13421, 13255, 13085, 12911, 12733, 12551, 12365, 12176, 11982, 11786, 11585, 11381, 11174, 10963, 10749, 10531, 10311, 10087, 9860, 9630, 9397, 9162, 8923, 8682, 8438, 8192, 7943, 7692, 7438, 7182, 6924, 6664, 6402, 6138, 5872, 5604, 5334, 5063, 4790, 4516, 4240, 3964, 3686, 3406, 3126, 2845, 2563, 2280, 1997, 1713, 1428, 1143, 857, 572, 286, 0, -286, -572, -857, -1143, -1428, -1713, -1997, -2280, -2563, -2845, -3126, -3406, -3686, -3964, -4240, -4516, -4790, -5063, -5334, -5604, -5872, -6138, -6402, -6664, -6924, -7182, -7438, -7692, -7943, -8192, -8438, -8682, -8923, -9162, -9397, -9630, -9860, -10087, -10311, -10531, -10749, -10963, -11174, -11381, -11585, -11786, -11982, -12176, -12365, -12551, -12733, -12911, -13085, -13255, -13421, -13583, -13741, -13894, -14044, -14189, -14330, -14466, -14598, -14726, -14849, -14968, -15082, -15191, -15296, -15396, -15491, -15582, -15668, -15749, -15826, -15897, -15964, -16026, -16083, -16135, -16182, -16225, -16262, -16294, -16322, -16344, -16362, -16374, -16382, -16384, -16382, -16374, -16362, -16344, -16322, -16294, -16262, -16225, -16182, -16135, -16083, -16026, -15964, -15897, -15826, -15749, -15668, -15582, -15491, -15396, -15296, -15191, -15082, -14968, -14849, -14726, -14598, -14466, -14330, -14189, -14044, -13894, -13741, -13583, -13421, -13255, -13085, -12911, -12733, -12551, -12365, -12176, -11982, -11786, -11585, -11381, -11174, -10963, -10749, -10531, -10311, -10087, -9860, -9630, -9397, -9162, -8923, -8682, -8438, -8192, -7943, -7692, -7438, -7182, -6924, -6664, -6402, -6138, -5872, -5604, -5334, -5063, -4790, -4516, -4240, -3964, -3686, -3406, -3126, -2845, -2563, -2280, -1997, -1713, -1428, -1143, -857, -572, -286

sinus:
	dc.w $0000, $011E, $023C, $0359, $0477, $0594, $06B1, $07CD
	dc.w $08E8, $0A03, $0B1D, $0C36, $0D4E, $0E66, $0F7C, $1090
	dc.w $11A4, $12B6, $13C7, $14D6, $15E4, $16F0, $17FA, $1902
	dc.w $1A08, $1B0C, $1C0E, $1D0E, $1E0C, $1F07, $2000, $20F6
	dc.w $21EA, $22DB, $23CA, $24B5, $259E, $2684, $2767, $2847
	dc.w $2923, $29FD, $2AD3, $2BA6, $2C75, $2D41, $2E0A, $2ECE
	dc.w $2F90, $304D, $3107, $31BD, $326F, $331D, $33C7, $346D
	dc.w $350F, $35AD, $3646, $36DC, $376D, $37FA, $3882, $3906
	dc.w $3986, $3A01, $3A78, $3AEA, $3B57, $3BC0, $3C24, $3C83
	dc.w $3CDE, $3D34, $3D85, $3DD2, $3E19, $3E5C, $3E9A, $3ED3
	dc.w $3F07, $3F36, $3F61, $3F86, $3FA6, $3FC2, $3FD8, $3FEA
	dc.w $3FF6, $3FFE, $4000, $3FFE, $3FF6, $3FEA, $3FD8, $3FC2
	dc.w $3FA6, $3F86, $3F61, $3F36, $3F07, $3ED3, $3E9A, $3E5C
	dc.w $3E19, $3DD2, $3D85, $3D34, $3CDE, $3C83, $3C24, $3BC0
	dc.w $3B57, $3AEA, $3A78, $3A01, $3986, $3906, $3882, $37FA
	dc.w $376D, $36DC, $3646, $35AD, $350F, $346D, $33C7, $331D
	dc.w $326F, $31BD, $3107, $304D, $2F90, $2ECE, $2E0A, $2D41
	dc.w $2C75, $2BA6, $2AD3, $29FD, $2923, $2847, $2767, $2684
	dc.w $259E, $24B5, $23CA, $22DB, $21EA, $20F6, $2000, $1F07
	dc.w $1E0C, $1D0E, $1C0E, $1B0C, $1A08, $1902, $17FA, $16F0
	dc.w $15E4, $14D6, $13C7, $12B6, $11A4, $1090, $0F7C, $0E66
	dc.w $0D4E, $0C36, $0B1D, $0A03, $08E8, $07CD, $06B1, $0594
	dc.w $0477, $0359, $023C, $011E, $0000, $FEE2, $FDC4, $FCA7
	dc.w $FB89, $FA6C, $F94F, $F833, $F718, $F5FD, $F4E3, $F3CA
	dc.w $F2B2, $F19A, $F084, $EF70, $EE5C, $ED4A, $EC39, $EB2A
	dc.w $EA1C, $E910, $E806, $E6FE, $E5F8, $E4F4, $E3F2, $E2F2
	dc.w $E1F4, $E0F9, $E000, $DF0A, $DE16, $DD25, $DC36, $DB4B
	dc.w $DA62, $D97C, $D899, $D7B9, $D6DD, $D603, $D52D, $D45A
	dc.w $D38B, $D2BF, $D1F6, $D132, $D070, $CFB3, $CEF9, $CE43
	dc.w $CD91, $CCE3, $CC39, $CB93, $CAF1, $CA53, $C9BA, $C924
	dc.w $C893, $C806, $C77E, $C6FA, $C67A, $C5FF, $C588, $C516
	dc.w $C4A9, $C440, $C3DC, $C37D, $C322, $C2CC, $C27B, $C22E
	dc.w $C1E7, $C1A4, $C166, $C12D, $C0F9, $C0CA, $C09F, $C07A
	dc.w $C05A, $C03E, $C028, $C016, $C00A, $C002, $C000, $C002
	dc.w $C00A, $C016, $C028, $C03E, $C05A, $C07A, $C09F, $C0CA
	dc.w $C0F9, $C12D, $C166, $C1A4, $C1E7, $C22E, $C27B, $C2CC
	dc.w $C322, $C37D, $C3DC, $C440, $C4A9, $C516, $C588, $C5FF
	dc.w $C67A, $C6FA, $C77E, $C806, $C893, $C924, $C9BA, $CA53
	dc.w $CAF1, $CB93, $CC39, $CCE3, $CD91, $CE43, $CEF9, $CFB3
	dc.w $D070, $D132, $D1F6, $D2BF, $D38B, $D45A, $D52D, $D603
	dc.w $D6DD, $D7B9, $D899, $D97C, $DA62, $DB4B, $DC36, $DD25
	dc.w $DE16, $DF0A, $E000, $E0F9, $E1F4, $E2F2, $E3F2, $E4F4
	dc.w $E5F8, $E6FE, $E806, $E910, $EA1C, $EB2A, $EC39, $ED4A
	dc.w $EE5C, $EF70, $F084, $F19A, $F2B2, $F3CA, $F4E3, $F5FD
	dc.w $F718, $F833, $F94F, $FA6C, $FB89, $FCA7, $FDC4, $FEE2
	dc.w $1234, $5678, $0101, $0000, $0004, $0101, $0000, $000E
	dc.w $0101, $0000, $0014, $0000, $0000, $0000, $0000, $0000