;-------T-------T------------------------T----------------------------------;
;This is a demo of a triple buffered starfield.  I didn't orginally write
;this starfield code, but it was very old so it needed a fair bit of
;cleaning up to work with the library.  It now runs in 4 colours for a
;little more depth too...

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i

NSTARS	=	800                     ;Number of stars

XSPEED	=	-4
YSPEED	=	6
ZSPEED	=	2

SCRWIDTH  =	320
SCRHEIGHT =	256

	SECTION	"Stars",CODE

;==========================================================================;
;                             INITIALISE DEMO
;==========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0
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
	CALL	Display

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;==========================================================================;
;                                 INITIALISE
;==========================================================================;

	;Randomize star coordinates

Main:	lea	StarCoords,a0            ;a0 = Ptr to star co-ordinates.
	move.w	#NSTARS-1,d7
	move.l	DPKBase(pc),a6
.loop1	move.w	#8192,d1
	CALL	SlowRandom
	move.w	d0,(a0)+
	CALL	SlowRandom
	move.w	d0,(a0)+
	CALL	SlowRandom
	move.w	d0,(a0)+
	dbra	d7,.loop1

	;Construct perspective table

	lea	PersTable,a0             ;a0 = ptr to perspective table.
	moveq	#0,d1                    ;d1 = Starting at 0.
.loop2	move.l	#$95FFFF,d2              ;d2 = $95FFFF
	move.l	d1,d3                    ;d3 = d1
	add.w	#300,d3                  ;d3 = ++300
	divu	d3,d2                    ;d2 = ($95ffff)/d3
	move.w	d2,(a0)+                 ;a0 = d2+
	addq.w	#1,d1                    ;d1 = ++1
	cmp.w	#8192,d1                 ;d1 = Equal to 8192?
	bne.s	.loop2

	;Construct plot tables for fast drawing.

	lea	PlotXTable,a0            ;a0 = X table - byte positions.
	lea	PlotBTable,a1            ;a1 = Bit table (X related).
	lea	PlotYTable,a2            ;a2 = Y table - line position.
	moveq	#0,d0                    ;d0 = 00
.loop3	move.w	d0,d1                    ;d1 = d0
	lsr.w	#3,d1                    ;d1 = (d0)<<3
	move.w	d1,(a0)+                 ;a0 = d1+

	move.w	d0,d1                    ;d1 = d0
	eor.w	#$FFFF,d1                ;d1 = (d0) eor $ffff
	and.w	#%00000111,d1            ;d1 = &%00000111
	move.w	d1,(a1)+                 ;a1 = BitSet++

	cmp.w	#SCRHEIGHT,d0	;Write out the Y values for the
	bge.s	.plot2	;table.
	move.w	d0,d1	;d1 = Line Number.
	mulu	#80,d1	;d1 = (LineNumber)*80
	move.w	d1,(a2)+	;a2 = (LineNumber*80)++

.plot2	addq.w	#1,d0
	cmp.w	#SCRWIDTH,d0
	bne.s	.loop3

;==========================================================================;
;                                MAIN LOOP
;==========================================================================;

MainLoop:
	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL
	move.l	Screen(pc),a0
	CALL	scrSwapBuffers

;==========================================================================;
;                             STAR ANIMATION
;==========================================================================;

	movem.w	StarXPos(pc),d0/d1/d2    ;MV = d0/d1/d2 = XPos/YPos/ZPos
	add.w	#XSPEED,d0               ;d0 = (StarXPos)+XSPEED
	add.w	#YSPEED,d1               ;d1 = (StarYPos)+YSPEED
	add.w	#ZSPEED,d2               ;d2 = (StarZPos)+ZSPEED
	and.w	#%0000011111111111,d0
	and.w	#%0000011111111111,d1
	and.w	#%0000011111111111,d2
	movem.w	d0/d1/d2,StarXPos

	lea	Sinus(pc),a0             ;a0 = Sinus table.
	movem.w	StarXAdd(pc),d3/d4/d5    ;MV = d3/d4/d5 : X/Y/Z
	add.w	(a0,d0.w),d3
	add.w	(a0,d1.w),d4
	add.w	(a0,d2.w),d5
	movem.w	d3/d4/d5,StarXAdd

;===========================================================================;
;                              SCREEN CLEAR
;===========================================================================;

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a1	;a1 = GameScreen
	move.l	GS_Bitmap(a1),a0	;a0 = Bitmap
	CALL	Clear

;==========================================================================;
;                               DRAW STARS
;==========================================================================;

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	CALL	Lock

	lea	StarCoords,a0            ;Draw starfield
	lea	PersTable,a1
	lea	PlotXTable,a2
	lea	PlotBTable,a3
	lea	PlotYTable,a4
	move.l	Screen(pc),a6
	move.l	GS_MemPtr2(a6),a6

	movem.w	StarXAdd(pc),d3/d4/d5    ;MV = d3/d4/d5 : ?
	add.w	#4096,d3                 ;d3 = ++4096
	add.w	#4096,d4                 ;d4 = ++4096

	move.w	#NSTARS-1,d7

.draw1	movem.w	(a0)+,d0/d1/d2           ;MV = d0/d1/d2 : XPos/YPos/ZPos.
	add.w	d3,d0                    ;Increase XPos.
	and.w	#8191,d0                 ;d0 = And'd
	sub.w	#4096,d0                 ;d0 = --4096

	add.w	d4,d1                    ;Y-movement
	and.w	#8191,d1                 ;d1 = And'd
	sub.w	#4096,d1                 ;d1 = --4096

	add.w	d5,d2                    ;Z-movement
	and.w	#8191,d2
	add.w	d2,d2                    ;d2 = *2 [word]
	move.w	(a1,d2.w),d6             ;d6 = Read from Perspective table.

	muls	d6,d0                    ;X-projection
	swap	d0
	add.w	#176,d0

	cmp.w	#SCRWIDTH-1,d0
	bhi.s	.nodraw
	muls	d6,d1                    ;Y-projection
	swap	d1
	add.w	#136,d1
	cmp.w	#SCRHEIGHT-1,d1
	bhi.s	.nodraw

	add.w	d0,d0                    ;d0 = *2 [word]
	add.w	d1,d1                    ;d1 = *2 [word]
	move.w	(a4,d1.w),d6             ;d6 = Plot Y.
	add.w	(a2,d0.w),d6             ;d6 = ++PlotX.
	move.w	(a3,d0.w),d0             ;d0 = BitValue.

	cmp.w	#7000,d2                 ;Now draw the star according to
	bgt.s	.draw2                   ;its position in the Z axis.
	bset	d0,(a6,d6.w)
	dbra	d7,.draw1
	bra.s	.done

.draw2	cmp.w	#13000,d2
	bgt.s	.draw3
	bset	d0,SCRWIDTH/8(a6,d6.w)
	dbra	d7,.draw1
	bra.s	.done

.draw3	bset	d0,(a6,d6.w)
	bset	d0,SCRWIDTH/8(a6,d6.w)
.nodraw	dbra	d7,.draw1

.done	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	CALL	Unlock

	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	sub.l	a1,a1
	moveq	#$00,d1
	btst	#JB_LMB,d0
	beq	MainLoop
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,SCRWIDTH
		dc.l  GSA_Height,SCRHEIGHT
		dc.l  GSA_Attrib,SCR_TPLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Type,ILBM
		dc.l    BMA_Palette,.palette
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,4
		dc.l  $000000,$D0D0D0,$606060,$202020

;===========================================================================;
;                                STAR DATA
;===========================================================================;

StarXAdd:	dc.w  33                       ;Star stuff
StarYAdd:	dc.w  12
StarZAdd:	dc.w  -114
StarXPos:	dc.w  0                        ;Sinus positions
StarYPos:	dc.w  310
StarZPos:	dc.w  1280

	INCLUDE	"GMSDev:source/asm/demos/StarSinus.i"

	SECTION	Storage,BSS

StarCoords:	ds.w  NSTARS*3	;Star coordinates
PersTable:	ds.w  8192	;Perspective table
PlotXTable:	ds.w  SCRWIDTH	;Plot tables
PlotBTable:	ds.w  SCRWIDTH
PlotYTable:	ds.w  SCRHEIGHT

;===========================================================================;

ProgName:	dc.b  "3D Starfield 4",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "4 colour star field demonstration.",0
		even

