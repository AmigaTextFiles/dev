;-------T-------T------------------------T----------------------------------;
;This is a graphical demonstration of the Random() functions.  The default
;is to use FastRandom, but you can change it to SlowRandom if you look
;below.
;
;Note that there are no screen settings in this demo - all of the user
;defaults are used, including the palette colours.
;
;Press the LMB to exit.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

Random	=	_LVOFastRandom	;_LVOFastRandom() or _LVOSlowRandom().

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6

	moveq	#ID_SCREEN,d0
	CALL	Get
	move.l	d0,Screen

	move.l	Screen(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	moveq	#ID_JOYDATA,d0	;Get joydata structure.
	CALL	Get
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0	;Initialise the joydata structure.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a0
	CALL	Show

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:
.loop	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	bne.s	.done

	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a1
	move.l	BMP_AmtColours(a1),d1	;Get random colour.
	subq.l	#1,d1
	jsr	Random(a6)	;>> = Get random number.
	addq.l	#1,d0
	move.l	d0,d3	;d3 = Colour to use.

	move.w	GS_Width(a0),d1	;Get random X.
	jsr	Random(a6)	;>> = Get random number.
	move.w	d0,d4	;d4 = Store X to use.

	move.w	GS_Height(a0),d1	;Get random Y.
	jsr	Random(a6)	;>> = Get random number.
	move.w	d0,d2	;d2 = Y to use.
	move.w	d4,d1	;d1 = Get back X.

	move.l	BLTBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	CALL	bltDrawUCPixel
	bra.s	.loop

.done	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0
Screen:		dc.l  0

;===========================================================================;

ProgName:	dc.b  "Random Plot",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "February 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Random pixel plotter.",0
		even
