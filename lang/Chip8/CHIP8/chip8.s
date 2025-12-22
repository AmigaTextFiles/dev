*****************************************
* AMIGA CHIP 8 INTERPRETER & DREAM MON	*
*    started dec 8 90		*
*   (C) Paul Hayter			*
* V1.0 Use con window to enter fnames	*
* 900727				*
* V1.1 added file requester		*
*****************************************

* This version uses a 64 x 64 pixel screen (actually 256 x 256 lores)

	xref	FileReq		Use sslib Filerequester off FF247

* NEED THESE 2 MACROS FOR A68K ASSEMBLER
blo	macro
	bcs \1
	endm
	
bhs	macro
	bcc \1
	endm

SIZE_OF_CHIP8_MEMORY	equ	4096

ACCESS_READ	equ	-2
MODE_OLDFILE	equ	1005
MODE_NEWFILE	equ	1006
OFFSET_END	equ	1
OFFSET_BEGINNING	equ	-1


dskdatr	EQU	$008
joy0dat	EQU	$00A
joy1dat	EQU	$00C
clxdat 	EQU	$00E

pot0dat	EQU	$012
pot1dat	EQU	$014
potinp 	EQU	$016
intenar	EQU	$01C
intreqr	EQU	$01E

vposw  	EQU	$02A
vhposw 	EQU	$02C
copcon 	EQU	$02E
vhposr	equ	$006
vposr	equ	$004
	
cop1lc 	EQU	$080
cop2lc 	EQU	$084
copjmp1	EQU	$088
copjmp2	EQU	$08A
copins 	EQU	$08C
diwstrt	EQU	$08E
diwstop	EQU	$090
ddfstrt	EQU	$092
ddfstop	EQU	$094
dmacon 	EQU	$096
clxcon 	EQU	$098
intena 	EQU	$09A
intreq 	EQU	$09C
adkcon 	EQU	$09E

aud    	EQU	$0A0
aud0   	EQU	$0A0
aud1   	EQU	$0B0
aud2   	EQU	$0C0
aud3   	EQU	$0D0


bpl1pth  	EQU	$0E0
bpl1ptl	equ	$0e2
bpl2pth	equ	$0e4
bpl2ptl	equ	$0e6

bplcon0	EQU	$100
bplcon1	EQU	$102
bplcon2	EQU	$104
bpl1mod	EQU	$108
bpl2mod	EQU	$10A

bpldat 	EQU	$110

spr0pth  	EQU	$120
spr0ptl  	EQU	$122
spr1pth  	EQU	$124
spr1ptl  	EQU	$126
spr2pth	EQU	$128
spr2ptl	EQU	$12A

spr    	EQU	$140

color00  	EQU	$180
color01	equ	$0182
color02	equ	$184
color03	equ	$186
color17	equ	$1a2
color18	equ	$1a4
color19	equ	$1a6
color20	equ	$1a8
color21	equ	$1aa


*   A6= gfxbase
*   A5= chip8 program counter
*   A4= ptr to chip ram workspace
*	+0   = screen
*	-16  = chip8 variables
*	-18  = I memory ptr (16 bit word, only 12 its used.
*   A3= $dff000

chip_block	equ	1000
param_area	equ	1000


**negative equates in the chip block
variables		equ	-16
Iptr		equ	variables-2
old_copper	equ	Iptr-4
stack_ptr		equ	old_copper-4
stack_lower	equ	stack_ptr-256	256 byte call stack
intbase		equ	stack_lower-4
screen		equ	intbase-4
screen_addr	equ	screen-4
window		equ	screen_addr-4
timer		equ	window-2
last_key		equ	timer-2
last_time		equ	last_key-2
dosbase		equ	last_time-4
mon_addr		equ	dosbase-2
count		equ	mon_addr-2
hex_bump		equ	count-2
con_handle	equ	hex_bump-4
file_string	equ	con_handle-64
file_handle	equ	file_string-4
start_addr	equ	file_handle-2
file_size		equ	start_addr-4
rand_seed		equ	file_size-2
WBenchScreen	equ	rand_seed-4
screen_bound	equ	WBenchScreen-4

LOFlist		equ	$32
left_mouse	equ	$bfe001
keyboard		equ	$bfec01
timerA		equ	$bfe801

_LVOSeek		equ	-66
_LVOClose		equ	-36
_LVOOpen		equ	-30
_LVORead		equ	-42
_LVOWrite		equ	-48
	
_LVOText		equ	-60
_LVOInitRastPort	equ	-198
_LVOMove		equ	-240
_LVOInitBitMap	equ	-390
_LVOSetAPen	equ	-342
_LVOSetBPen	equ	-348
_LVORectFill	equ	-306
_LVOReadPixel	equ	-318
_LVOWritePixel	equ	-324
_LVOSetRast	equ	-234
_LVOWaitTOF	equ	-270
_LVOVBeamPos	equ	-384
	
_LVOOpenScreen	equ	-198
_LVOCloseScreen	equ	-66
_LVOOpenWindow	equ	-204
_LVOCloseWindow	equ	-72
_LVOScreenToBack	equ	-246
_LVOScreenToFront	equ	-252

custom		equ	$dff000
_LVOOpenLibrary	equ	-552
_LVOCloseLibrary	equ	-414
_LVOAllocMem	equ	-198
_LVOFreeMem	equ	-210
_LVOForbid	equ	-132
_LVOPermit	equ	-138

rp_BitMap		equ	4
bm_Planes		equ	8

sc_BitMap		equ	184
sc_RastPort	equ	84

	section ethel,code		code_c

*CLI/WORKBENCH STARTUP CODE
_AbsExecBase	equ	4
_LVOFindTask	equ	-294
pr_CLI		equ	172
pr_MsgPort	equ	92
_LVOWaitPort	equ	-384
_LVOGetMsg	equ	-372
*_LVOForbid	equ	-132
_LVOReplyMsg	equ	-378


startup:            ; reference for Wack users
	move.l   sp,initialSP   ; initial task stack pointer

	;------ get Exec's library base pointer:
	move.l   _AbsExecBase,a6

	;------ get the address of our task
	suba.l   a1,a1
	jsr	_LVOFindTask(a6)
	move.l   d0,a4

	;------ are we running as a son of Workbench?
	tst.l   pr_CLI(A4)
	beq.s   fromWorkbench

;=======================================================================
;====== CLI Startup Code ===============================================
;=======================================================================
fromCLI:


	;------ call C main entry point
	jsr   _main

	;------ return success code:
	moveq.l   #0,D0
	move.l   initialSP,sp   ; restore stack ptr
	rts

;=======================================================================
;====== Workbench Startup Code =========================================
;=======================================================================
fromWorkbench:

	;------ we are now set up.  wait for a message from our starter
	bsr.s   waitmsg

	;------ save the message so we can return it later
	move.l   d0,_WBenchMsg

	;------ push the message on the stack for wbmain
	move.l   d0,-(SP)
	clr.l   -(SP)      indicate: run from Workbench

domain:
	jsr   _main
	moveq.l   #0,d0      Successful return code
	move.l  initialSP,SP   ; restore stack pointer
	move.l   d0,-(SP)   ; save return code

	move.l   _AbsExecBase,A6

	;------ if we ran from CLI, skip workbench cleanup:
	tst.l   _WBenchMsg
	beq.s   exitToDOS


	;------ return the startup message to our parent
	;------   we forbid so workbench can't UnLoadSeg() us
	;------   before we are done:
	jsr	_LVOForbid(a6)
	move.l   _WBenchMsg,a1
	jsr	_LVOReplyMsg(a6)

	;------ this rts sends us back to DOS:
exitToDOS:
	move.l   (SP)+,d0
	rts


;-----------------------------------------------------------------------
; This routine gets the message that workbench will send to us
; called with task id in A4


waitmsg:
	lea   pr_MsgPort(A4),a0     * our process base
	jsr	_LVOWaitPort(a6)
	lea   pr_MsgPort(A4),a0     * our process base
	jsr	_LVOGetMsg(a6)
	rts


************************************************************************

   DATA

************************************************************************



initialSP   dc.l   0
_WBenchMsg   dc.l   0

_main

********PUT YOUR PROGRAM HERE***************************



START	move.l	4,a6
	bsr	allocate_chip
	tst.l	d0
	beq	exit1
	move.l	d0,a4
	add.l	#param_area,a4	A4=workspace
	lea	gfxname(pc),a1
	moveq	#0,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,a5
	lea	intname(pc),a1
	moveq	#0,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,intbase(a4)
	move.l	d0,a1
	move.l	56(a1),WBenchScreen(a4)	get the initial screen
	lea	dosname(pc),a1
	moveq	#0,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,dosbase(a4)
	move.l	a5,a6		A6=gfxbase
	
	lea	custom,a3		A3=custom
	lea	area_base+$0600,a5	A5=program counter
	move.b	timerA,last_time(a4)
	clr.b	file_string(a4)	make sure we have null filename
	bsr	clear_memory	PUT DIGIT/mon IN AREA_BASE+CLEAR
	bsr	setup_screen
*	bsr	chip8_interpreter
	bsr	DREAM_MON
	bsr	close_screen

	move.l	a6,a1
	move.l	4,a6
	jsr	_LVOCloseLibrary(a6)	close gfx
	move.l	intbase(a4),a1
	jsr	_LVOCloseLibrary(a6)	close int
	move.l	dosbase(a4),a1
	jsr	_LVOCloseLibrary(a6)
	bsr	free_chip
exit1	moveq	#0,d0
	rts

chip8_interpreter
	bsr	init_chip8
ch82
*	jsr	_LVOWaitTOF(a6)

*	move.l	#20,d0
*ch89	subq.l	#1,d0
*	bne.s	ch89	
	
add_time	move.b	timerA,d0
	move.b	d0,d1
	sub.b	last_time(a4),d0
	move.b	d1,last_time(a4)
	sub.b	d0,timer(a4)

	btst	#6,left_mouse
	bne.s	no_press
	rts
no_press
	moveq	#0,d0
	move.b	(a5)+,-(sp)
	move.w	(sp)+,d0		shove in high byte
	move.b	(a5)+,d0		get next byte
	move.w	d0,d1		D1 = copy of command.
	move.w	d0,d2
	lea	variables(a4),a2
	lsr.w	#4,d2
	and.w	#$000F,d2
	lea	0(a2,d2.w),a1	A1 ->y variable
	move.w	d0,d2
	lsr.w	#8,d2
	and.w	#$000F,d2
	lea	0(a2,d2.w),a0	A0 ->x variable	
	lsl.l	#5,d0
	swap	d0
	bclr	#0,d0
	lea	command_list(pc),a2
	move.w	0(a2,d0.w),d0	get word address
	lea	START(pc),a2
	jsr	0(a2,d0.w)	jump to command
	bra	ch82

command_list	dc.w	com0-START,com1-START,com2-START
		dc.w	com3-START,com4-START,com5-START
		dc.w	com6-START,com7-START,com8-START
		dc.w	com9-START,comA-START,comB-START
		dc.w	comC-START,comD-START,comE-START
		dc.w	comF-START

init_chip8
	bsr	erase_scr
	lea	stack_ptr(a4),a0
	move.l	a0,stack_ptr(a4)
	rts

DREAM_MON
	move.w	#$0200,mon_addr(a4)		DREAM ON!!
	bsr	erase_scr
dm_st	bsr	show_bar
	bsr	show_addr
	addq.b	#8,variables(a4)
	move.w	mon_addr(a4),d6
	moveq	#0,d7
	lea	area_base,a0
	move.b	0(a0,d6.w),d7
	move.b	d7,-(sp)
	lsr.b	#4,d7
	bsr	show_digit	MSD
	move.b	(sp)+,d7
	and.b	#$0f,d7
	addq.b	#4,variables(a4)
	bsr	show_digit	LSD
	moveq	#2,d0
	bsr	wait_for_key	WAIT FOR KEY
	cmp.b	#$0F,d2
	bhi.s	mon_command
	move.w	mon_addr(a4),d0	ENTER HEX DIGITS
	lea	area_base,a0
	move.b	0(a0,d0.w),d1
	lsl.b	#4,d1		=0Y
	or.b	d1,d2
	move.b	d2,0(a0,d0.w)
	addq.b	#1,hex_bump(a4)
	cmp.b	#2,hex_bump(a4)
	blo.s	dm_st
	clr.b	hex_bump(a4)
	addq.w	#1,mon_addr(a4)
	bra	dm_st
mon_command
	clr.b	hex_bump(a4)
	cmp.b	#'M',d2
	bne.s	not_M
	move.w	#4,count(a4)
mc_1	bsr	show_bar
	bsr	show_addr
	moveq	#2,d0
	bsr	wait_for_key		GET KEY
	move.w	mon_addr(a4),d3
	lsl.w	#4,d3
	or.w	d3,d2
	move.w	d2,mon_addr(a4)
	subq.w	#1,count(a4)
	bne.s	mc_1
	bra	dm_st
not_M	cmp.b	#'+',d2
	bne.s	not_fwd
	addq.w	#1,mon_addr(a4)
	bra	dm_st
not_fwd	cmp.b	#'-',d2
	bne.s	not_bwd
	subq.w	#1,mon_addr(a4)
	bra	dm_st
not_bwd	cmp.b	#'G',d2
	bne.s	not_go
	move.w	mon_addr(a4),d0		execute CHIP8 prog at current
	lea	area_base,a0
	lea	0(a0,d0.w),a5
	bsr	do_forbid
	bsr	chip8_interpreter
	bsr	do_permit
still_press
*	btst	#6,left_mouse
*	beq.s	still_press
	bra	dm_st
not_go	cmp.b	#'L',d2
	bne.s	not_L
	lea	load_title(pc),a1
	lea	file_string(a4),a0
	bsr	do_filerequester
	tst.l	d0
	beq	dm_st		error
	bmi	dm_st		selected cancel
	bsr	read_file
	tst.l	d0
	beq	dm_st		error!
	bsr	rll_decompress
	bra	dm_st
not_L	cmp.b	#'S',d2
	bne.s	not_S
	lea	save_title(pc),a1
	lea	file_string(a4),a0
	bsr	do_filerequester
	tst.l	d0
	beq	dm_st		error!
	bmi	dm_st		selected cancel!
	bsr	rll_compress	compress workspace!
	bsr	write_file
	bra	dm_st

not_S	cmp.b	#'X',d2		EXIT
	bne	not_X
	rts
not_X	cmp.b	#'K',d2		KLEAR
	bne	dm_st
	bsr	clear_memory
	bra	dm_st

	
	
show_addr	move.b	#26,variables+1(a4)	V1=26
	move.b	#16,variables(a4)	V0=16
	moveq	#0,d7
	moveq	#3,d6
	move.w	mon_addr(a4),d7
dm_2	lsl.l	#4,d7		SHOW ADDRESS
	swap	d7
	bsr	show_digit
	clr.w	d7
	swap	d7
	addq.b	#4,variables(a4)	bump x
	dbra	d6,dm_2
	rts
	
	
show_digit	
	move.w	d7,d5	x 1
	lsl.w	#2,d5	x 4
	add.w	d7,d5	x 5
	move.w	d5,Iptr(a4)
	movem.l	d6-d7,-(sp)
	move.w	#$D015,d1
	lea	variables(a4),a0
	lea	variables+1(a4),a1
	bsr	displ
	movem.l	(sp)+,d6-d7
	rts

show_bar	move.l	screen_addr(a4),a1
	lea	3200(a1),a1
	move.w	#224-1,d0
	moveq	#-1,d1
dm_1	move.l	d1,(a1)+		WHITE BAR
	dbra	d0,dm_1
	rts
	
* 00EE=return, 00E0=erase,
com0	cmp.w	#$00EE,d1
	bne	not_return
	bsr	pull_address
	lea	area_base,a0
	lea	0(a0,d0.w),a5
	rts
not_return
	cmp.w	#$00E0,d1
	bne	not_erase
erase_scr	move.l	screen(a4),a1
	lea	sc_RastPort(a1),a1
	moveq	#0,d0
	jsr	_LVOSetRast(a6)
	jsr	_LVOWaitTOF(a6)
	jmp	_LVOWaitTOF(a6)
not_erase	
	rts		NEED TO ALLOW FOR 0MMM instructions

push_address
	move.l	stack_ptr(a4),a0
	move.w	d0,-(a0)
	move.l	a0,stack_ptr(a4)
	rts
	
pull_address
	move.l	stack_ptr(a4),a0
	moveq	#0,d0
	move.w	(a0)+,d0
	move.l	a0,stack_ptr(a4)
	rts
	
* GOTO MMM
com1	and.w	#$0FFF,d1
	lea	area_base,a0
	lea	0(a0,d1.w),a5
	rts

* DO MMM
com2	sub.l	#area_base,a5
	move.l	a5,d0
	bsr	push_address
	bra	com1		goto address


** SKF VX = KK  3XKK
com3	cmp.b	(a0),d1
	bne	com3_fail
	move.w	(a5)+,d0
com3_fail	rts

** SKF VX <> KK
com4	cmp.b	(a0),d1
	beq	com4_fail
	move.w	(a5)+,d0
com4_fail	rts

** SKF VX = VY	5XY0
com5	cmp.b	(a0)+,(a1)+	don't need post +,but illegal addr mode
	bne	com5_fail
	move.w	(a5)+,d0
com5_fail	rts

** VX = KK   6XKK
com6	move.b	d1,(a0)
	rts
	
** VX= VX+KK
com7	add.b	d1,(a0)
	rts


** 8XYn
com8	move.b	d1,d2
	and.b	#$0F,d2
	cmp.b	#$0,d2
	bne.s	try_01
	move.b	(a1),(a0)		VX=VY
	rts
try_01	cmp.b	#$1,d2
	bne.s	try_02
	move.b	(a1),d3
	or.b	d3,(a0)
	rts
try_02	cmp.b	#$2,d2
	bne.s	try_03
	move.b	(a1),d3
	and.b	d3,(a0)
	rts
try_03	cmp.b	#$3,d2
	bne.s	try_04
	move.b	(a1),d3
	eor.b	d3,(a0)
	rts
try_04	cmp.b	#$4,d2
	bne.s	try_05
	moveq	#0,d4
	move.b	(a0),d3
	add.b	(a1),d3
	bcc.s	try04a
	moveq	#1,d4
try04a	move.b	d4,variables+15(a4)	VF=1
	move.b	d3,(a0)
	rts
try_05	cmp.b	#$5,d2
	bne.s	exit8
	moveq	#1,d4
	move.b	(a0),d3
	sub.b	(a1),d3
	bcc.s	try05a
	moveq	#0,d4
try05a	move.b	d4,variables+15(a4)
	move.b	d3,(a0)
exit8	rts
	
	
** SKF VX <> VY
com9	cmp.b	(a0)+,(a1)+
	beq.s	com9_fail
	move.w	(a5)+,d0
com9_fail	rts


** I = MMM
comA	and.w	#$0FFF,d1
	move.w	d1,Iptr(a4)
	rts


* GOTO MMM + V0
comB	and.w	#$0FFF,d1
	moveq	#0,d0
	move.b	variables(a4),d0	GET V0
	add.w	d0,d1
	bra	com1

* CXKK	I don't know how to write random number generators!
comC
	move.w	rand_seed(a4),d2
*	move.w	rand_seed(a4),d1
*	addq.w	#1,rand_seed(a4)
	mulu	#41693,d2
	addq.w	#1,d2
	move.w	d2,rand_seed(a4)
	lsr.w	#8,d2
	and.b	d2,d1
*	eor.b	#$ff,d1
	move.b	d1,(a0)
	rts


** DISP N @ (X,Y)
comD	movem.l	a0-a1/d1,-(sp)
comDbeam	jsr	_LVOVBeamPos(a6)
*	cmp.w	#256+$1c,d0
*	blo.s	comDbeam
	cmp.l	#36,d0
	bhi.s	comDbeam
	
	movem.l	(sp)+,a0-a1/d1
displ	clr.b	variables+15(a4)		VF=0
	move.w	d1,d2			D2=n
	and.w	#$0f,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a1),d0			D0=y
	and.b	#64-1,d0
	move.b	(a0),d1			D1=x
	and.b	#64-1,d1
comD2	move.w	Iptr(a4),d3
	lea	area_base,a0
	lea	0(a0,d3.w),a2	A2=I pointer
	subq.w	#1,d2		D2=line counter
	bsr	calc_scr_addr
drawloop	cmp.l	screen_bound(a4),a1
	blo.s	draw2
	sub.l	#32*4*64,a1
draw2	move.b	(a2)+,d3		D3=byte
	bsr	draw_byte
	dbra	d2,drawloop
	rts

** D0=y,D1=x,d3=byte to draw
draw_byte	moveq	#3,d4	draw 4 lines the same	D4=pixel depth
	moveq	#0,d5
	tst.l	d6
	beq	db3
	lsr.b	#1,d3
	bcc.s	db3
	move.b	#$f0,d5
db3	bsr	quadruple

db2	swap	d3		D3=45670123
	move.w	d3,-(sp)
	move.b	(sp)+,d0
	move.b	d0,d1
	cmp.l	screen_bound(a4),a1
	bhs	over_bnd1
	or.b	(a1),d1
	eor.b	d0,(a1)		1st 2 pixels
	cmp.b	(a1)+,d1
	beq.s	ok1
	move.b	#1,variables+15(a4)

ok1	move.b	d3,d1
	cmp.l	screen_bound(a4),a1
	bhs	over_bnd2
	or.b	(a1),d1
	eor.b	d3,(a1)		next 2 pixels
	cmp.b	(a1)+,d1
	beq.s	ok2
	move.b	#1,variables+15(a4)

ok2	swap	d3
	move.w	d3,-(sp)
	move.b	(sp)+,d0
	move.b	d0,d1
	cmp.l	screen_bound(a4),a1
	bhs	over_bnd3
	or.b	(a1),d1
	eor.b	d0,(a1)		next 2 pixels
	cmp.b	(a1)+,d1
	beq.s	ok3
	move.b	#1,variables+15(a4)

ok3	move.b	d3,d1
	cmp.l	screen_bound(a4),a1
	bhs	over_bnd4
	or.b	(a1),d1
	eor.b	d3,(a1)		next 2 pixels
	cmp.b	(a1)+,d1
	beq.s	ok4
	move.b	#1,variables+15(a4)
ok4	move.b	d5,d1
	cmp.l	screen_bound(a4),a1
	bhs	over_bnd5
	or.b	(a1),d1
	eor.b	d5,(a1)		possible next pixel
	cmp.b	(a1)+,d1
	beq.s	ok5
	move.b	#1,variables+15(a4)
ok5	add.l	#27,a1
	dbra	d4,db2
	rts

over_bnd1	tst.b	(a1)+
over_bnd2	tst.b	(a1)+
over_bnd3	tst.b	(a1)+
over_bnd4	tst.b	(a1)+
over_bnd5	tst.b	(a1)+
	add.l	#27,a1
	dbra	d4,db2
	rts

calc_scr_addr
	moveq	#0,d6
	move.b	d0,d6	D6=y
	lsl.l	#7,d6	x 128
	moveq	#0,d7
	move.b	d1,d7	D7=x
	lsr.l	#1,d7	x 2
	bcs.s	odd_pixel
	add.l	d7,d6
	move.l	screen_addr(a4),a1
	lea	0(a1,d6.l),a1	A1=screen pointer
	moveq	#0,d6		D6=odd pixel indicator
	rts
odd_pixel	add.l	d7,d6
	move.l	screen_addr(a4),a1
	lea	0(a1,d6.l),a1
	moveq	#1,d6
	rts

** D3=byte| exit d3.l=graphic
quadruple	swap	d3	D3=00XX0000
	moveq	#3,d0	
q2	lsr.l	#1,d3
	asr.w	#3,d3
	dbra	d0,q2
	move.w	d3,d1
	moveq	#3,d0
q3	lsr.l	#1,d3
	asr.w	#3,d3
	dbra	d0,q3
	swap	d3
	move.w	d1,d3
	rts

** EXA1 and EX9E
comE	move.b	(a0),d4
	bsr	get_key
	move.b	d2,last_key(a4)
	cmp.b	#$9e,d1
	bne.s	tryA1
	cmp.b	d4,d2
	bne.s	coE1_fail
	move.w	(a5)+,d0
coE1_fail	rts
tryA1	cmp.b	d4,d2
	beq.s	coE2_fail
	move.w	(a5)+,d0
coE2_fail	rts

get_key	move.b	timerA,d2
	move.b	d2,-(sp)
	sub.b	last_time(a4),d2
	sub.b	d2,timer(a4)
	move.b	(sp)+,last_time(a4)
	moveq	#0,d2
	move.b	keyboard,d2
	not.b	d2
	lsr.w	#1,d2
	bcc.s	key_down
	moveq	#-1,d2		D2=FF key up
	move.b	d2,last_key(a4)
	rts
key_down	move.l	a0,-(sp)
	lea	key_lookup(pc),a0
	move.b	0(a0,d2.w),d2	GET KEY
	move.l	(sp)+,a0
	rts

******
comF	moveq	#0,d2
	move.b	(a0),d2

	cmp.w	#$F000,d1	THIS IS STOP IN THE DREAM CHIP8		NOT IMPLEMENTED   PITCH = VX
	bne.s	not_pitch	BUT IS PITCH=V0 in the ETI 660
	move.l	(sp)+,d0
	rts
not_pitch	cmp.b	#$1e,d1
	bne.s	not_1E
	add.w	Iptr(a4),d2
	move.w	d2,Iptr(a4)
	rts
not_1E	cmp.b	#$07,d1
	bne.s	not_07
	move.b	timer(a4),(a0)	GET CURRENT TIMER VALUE
	rts
not_07	cmp.b	#$0A,d1
	bne.s	not_0A	
loop12
	btst	#6,left_mouse	WAIT FOR KEY
	bne.s	loop120
	move.l	(sp)+,d0
	rts
loop120	bsr	get_key
	tst.b	d2
	bmi.s	loop12
	cmp.b	last_key(a4),d2
	beq.s	loop12
	move.b	d2,last_key(a4)
	move.b	d2,(a0)
	rts
not_0A	cmp.b	#$15,d1
	bne.s	not_15
	move.b	(a0),timer(a4)  SET TIMER
	rts
not_15	cmp.b	#$29,d1
	bne.s	not_29
	and.b	#$0f,d2		I=show digit
	mulu	#5,d2
	move.w	d2,Iptr(a4)
	rts
not_29	cmp.b	#$33,d1
	bne.s	not_33
	move.w	Iptr(a4),d3
	lea	area_base,a0
	divu	#10,d2
	swap	d2
	move.b	d2,2(a0,d3.w)	1's digit
	clr.w	d2
	swap	d2
	divu	#10,d2
	swap	d2
	move.b	d2,1(a0,d3.w)	10's digit
	clr.w	d2
	swap	d2
	divu	#10,d2
	swap	d2
	move.b	d2,0(a0,d3.w)	100's digit
	rts
not_33	cmp.b	#$55,d1
	bne.s	not_55
	move.w	Iptr(a4),d3
	lea	area_base,a2
	lea	variables(a4),a1
loop55	move.b	(a1)+,0(a2,d3.w)  store V0-X @ I
	addq.w	#1,d3
	cmp.l	a0,a1	CMP #@VX,A1
	bls.s	loop55
	move.w	d3,Iptr(a4)
	rts
not_55	cmp.b	#$65,d1
	bne.s	not_65
	move.w	Iptr(a4),d3
	lea	area_base,a2
	lea	variables(a4),a1
loop65	move.b	0(a2,d3.w),(a1)+  load V0-X from I
	addq.w	#1,d3
	cmp.l	a0,a1
	bls.s	loop65
	move.w	d3,Iptr(a4)
	rts
not_65	rts
	
	
wait_for_key
1$	bsr	get_key
	tst.b	d2
	bmi.s	1$
	cmp.b	last_key(a4),d2
	beq.s	1$
	move.b	d2,last_key(a4)
	rts


allocate_chip
	move.l	#$10002,d1
	move.l	#chip_block,d0
	jmp	_LVOAllocMem(a6)	allocmem

free_chip
	move.l	#chip_block,d0	Deallocate memory
	sub.l	#param_area,a4
	move.l	a4,a1
	move.l	4,a6
	jmp	_LVOFreeMem(a6)



setup_screen
	move.l	a6,-(sp)
	move.l	intbase(a4),a6
	lea	newscreen(pc),a0
	jsr	_LVOOpenScreen(a6)
	move.l	d0,screen(a4)
	move.l	d0,nw_Screen
	move.l	d0,a0
	lea	sc_BitMap(a0),a0
	move.l	bm_Planes(a0),d0
*	add.l	#32*12,d0
	move.l	d0,screen_addr(a4)
	add.l	#32*4*64,d0
	move.l	d0,screen_bound(a4)
	lea	newwindow(pc),a0
	jsr	_LVOOpenWindow(a6)
	move.l	d0,window(a4)
	move.l	(sp)+,a6
	rts

close_screen
	move.l	a6,-(sp)
	move.l	intbase(a4),a6
	move.l	window(a4),a0
	jsr	_LVOCloseWindow(a6)
	move.l	screen(a4),a0
	jsr	_LVOCloseScreen(a6)
	move.l	(sp)+,a6
	rts


* Entry A0=filename(0)
* RETURN D0= 0 if failure
read_file
	move.l	a6,-(sp)
	move.l	dosbase(a4),a6
	move.l	#MODE_OLDFILE,d2
	move.l	a0,d1
	jsr	_LVOOpen(a6)
	tst.l	d0
	bne.s	its_actually_here
	move.l	(sp)+,a6
	rts
its_actually_here
	move.l	d0,file_handle(a4)
	move.l	d0,d6
	move.l	d0,d1
	moveq	#0,d2
	moveq	#OFFSET_END,d3
	jsr	_LVOSeek(a6)
	move.l	d6,d1
	moveq	#0,d2
	moveq	#OFFSET_BEGINNING,d3
	jsr	_LVOSeek(a6)
	move.l	d0,file_size(a4)
	clr.w	file_area
	cmp.l	#SIZE_OF_CHIP8_MEMORY,D0
	bhs.s	closerd
load_da_file
*	move.w	mon_addr(a4),d0
*	lea	area_base,a0
*	lea	0(a0,d0.w),a0
	LEA	file_area,A0	NEW
	move.l	a0,d2
	move.l	d6,d1
	move.l	file_size(a4),d3
	jsr	_LVORead(a6)
closerd	move.l	d6,d1
	jsr	_LVOClose(a6)
	move.l	(sp)+,a6
	cmp.w	#$4338,file_area	check if chip8 source file
	bne.s	1$
	moveq	#1,d0		return OK
	rts
1$	moveq	#0,d0
	rts
	
* ENTRY A0=filename(0), D0=size
write_file
	move.l	a6,-(sp)
	move.l	d0,d4
	move.l	dosbase(a4),a6
	move.l	#MODE_NEWFILE,d2
	move.l	a0,d1
	jsr	_LVOOpen(a6)
	tst.l	d0
	beq	1$
	move.l	d0,d6
*	move.w	mon_addr(a4),d0
*	lea	area_base,a0
	lea	file_area,a0
*	lea	0(a0,d0.w),a0
	move.l	a0,d2
	move.l	d6,d1
	move.l	d4,d3		used to be always 2048 bytes
	jsr	_LVOWrite(a6)
	move.l	d6,d1
	jsr	_LVOClose(a6)
1$	move.l	(sp)+,a6
	rts



** ENTRY A0 = filename buffer,A1=requester name
** RETURN A0 =filename, D0=0 error, =1 success, =-1 Cancel
do_filerequester
	bsr	show_req
	jsr	FileReq
	bsr	show_chip8
	rts

show_req	
	movem.l	a0-a1/d0/a6,-(sp)
	move.l	intbase(a4),a6
	move.l	WBenchScreen(a4),a0
	jsr	_LVOScreenToFront(a6)
	movem.l	(sp)+,a0-a1/d0/a6
	rts

show_chip8
	movem.l	a0-a1/d0/a6,-(sp)
	move.l	intbase(a4),a6
	move.l	screen(a4),a0
	jsr	_LVOScreenToFront(a6)
	movem.l	(sp)+,a0-a1/d0/a6
	rts

copy_stuff
	lea	area_base,a0
	lea	digits(pc),a1
	moveq	#5*16-1,d0
cd_1	move.b	(a1)+,(a0)+
	dbra	d0,cd_1
	rts

clear_memory
	movem.l	a0-a1/d0,-(sp)
	lea	area_base,a0
	move.w	#SIZE_OF_CHIP8_MEMORY/4-1,d0
1$	clr.l	(a0)+
	dbra	d0,1$
	bsr	copy_stuff
	movem.l	(sp)+,a0-a1/d0
	rts

** RLL COMPRESSOR. FILES WILL BE SAVED COMPRESSED
rll_compress
	movem.l	a0-a1/d1-d3,-(sp)
	lea	area_base,a0
	lea	file_area,a1
	move.w	#$4338,(a1)+	'C8' for first two chars
	move.l	#SIZE_OF_CHIP8_MEMORY,d0
	add.l	a0,d0		D0=end address

newstart	moveq	#0,d2
	cmp.l	a0,d0
	beq	rll_finish
	move.b	(a0)+,d1
	cmp.b	(a0),d1
	bne	1$
	cmp.b	1(a0),d1
	beq	byterun
1$	move.l	a1,a3
	tst.b	(a1)+	bump
sequence	move.b	d1,(a1)+
	addq.b	#1,d2
	btst	#7,d2
	bne	RUN128
	cmp.l	a0,d0
	beq	rll_finish2
	move.b	(a0)+,d1
	cmp.b	(a0),d1
	bne	sequence
	cmp.b	1(a0),d1
	bne	sequence
	tst.b	-(a0)	pt to last
RUN128	subq.b	#1,d2
	move.b	d2,(a3)
	bra	newstart

rll_finish2
	subq.b	#1,d2
	move.b	d2,(a3)
rll_finish
	sub.l	#file_area,a1
	move.l	a1,d0
	movem.l	(sp)+,a0-a1/d1-d3
	rts

byterun	move.l	a1,a3
	tst.b	(a1)+
	move.b	d1,(a1)+
runner	addq.b	#1,d2
	btst	#7,d2
	bne	RUNNY128
	cmp.l	a0,d0
	beq	rll_finish3
	cmp.b	(a0)+,d1
	beq	runner
	tst.b	-(a0)
RUNNY128	subq.b	#1,d2
	bset	#7,d2
	move.b	d2,(a3)
	bra	newstart

rll_finish3
	subq.b	#1,d2
	bset	#7,d2
	move.b	d2,(a3)
	sub.l	#file_area,a1
	move.l	a1,d0
	movem.l	(sp)+,a0-a1/d1-d3
	rts

** RLL DECOMPRESSOR
rll_decompress
	movem.l	a0-a1/d1-d2/d4,-(sp)
	lea	file_area,a0	src
	lea	area_base,a1	dest
	move.l	a1,d4
	add.l	#SIZE_OF_CHIP8_MEMORY,d4	D4=end address
	tst.w	(a0)+	bump over C8 ID
next_one	moveq	#0,d1
	cmp.l	a1,d4
	bls.s	end_decomp
	move.b	(a0)+,d1
	bmi.s	decomp_run
1$	move.b	(a0)+,(a1)+
	dbra	d1,1$
	bra.s	next_one
decomp_run
	and.b	#$7f,d1
	move.b	(a0)+,d2
1$	move.b	d2,(a1)+
	dbra	d1,1$
	bra.s	next_one

end_decomp
	movem.l	(sp)+,a0-a1/d1-d2/d4
	rts

do_forbid	move.l	a6,-(sp)
	move.l	4,a6
	jsr	_LVOForbid(a6)
	move.l	(sp)+,a6
	rts
	
do_permit	move.l	a6,-(sp)
	move.l	4,a6
	jsr	_LVOPermit(a6)
	move.l	(sp)+,a6
	rts

CUSTOMSCREEN	equ	$000F
newscreen
	dc.w	0,0,256,256,1
	dc.b	1,0
	dc.w	0
	dc.w	CUSTOMSCREEN
	dc.l	0
	dc.l	0	NO heading
	dc.l	0
	dc.l	0

BORDERLESS              EQU  $0800
ACTIVATE                EQU  $1000
WINDOWACTIVE            EQU  $2000
INREQUEST               EQU  $4000
MENUSTATE               EQU  $8000
RMBTRAP                 EQU  $00010000
NOCAREREFRESH           EQU  $00020000

newwindow
	dc.w	0,0,256,256
	dc.b	1,0
	dc.l	0
	dc.l	BORDERLESS+ACTIVATE+NOCAREREFRESH
	DC.L	0
	dc.l	0
	dc.l	0	title
nw_Screen	dc.l	0
nw_BitMap	dc.l	0
	dc.w	256,256,256,256
	dc.w	CUSTOMSCREEN
	

save_title	dc.b 'SAVE FILE',0
load_title	dc.b 'LOAD FILE',0

gfxname		dc.b 'graphics.library',0

intname		dc.b 'intuition.library',0

dosname		dc.b 'dos.library',0


** Increment address uses RETURN,=,SPACE
** Decrement address uses - BACKSPACE

CR	EQU	13
SPACE	EQU	32
TAB	EQU	9
BACKSPACE	EQU	8
key_lookup
	dc.b	"`",1,2,3,4,5,6,7,8,9,0,"-+\ ",0,"QW",$E,"RTYUIOP[] ",1,2,3
	dc.b	$A,"S",$D,$F,"GHJKL;'~ ",4,5,6," ZX",$C,"V",$B,"NM,./"
	DC.B	"  ",7,8,9,'+-',TAB,"++"
	DC.B	$1B,$7F,$A,$B,$C,$E,$D,"-++-"

	even

digits	dc.b	$e0,$a0,$a0,$a0,$e0
	dc.b	$40,$40,$40,$40,$40
	dc.b	$e0,$20,$e0,$80,$e0
	dc.b	$e0,$20,$e0,$20,$e0
	dc.b	$80,$a0,$a0,$e0,$20
	dc.b	$e0,$80,$e0,$20,$e0
	dc.b	$e0,$80,$e0,$a0,$e0
	dc.b	$e0,$20,$20,$20,$20		7
	dc.b	$e0,$a0,$e0,$a0,$e0		8
	dc.b	$e0,$a0,$e0,$20,$e0		9
	dc.b	$e0,$a0,$e0,$a0,$a0		A
	dc.b	$c0,$a0,$e0,$a0,$c0		B
	dc.b	$e0,$80,$80,$80,$e0		C
	dc.b	$c0,$a0,$a0,$a0,$c0		D
	dc.b	$e0,$80,$e0,$80,$e0		E
	dc.b	$e0,$80,$c0,$80,$80		F

* This will never get printed, but its to make sure this program can
* be identified
ego	dc.b	'CHIP 8 Emulator V1.1 (C)1990,91 Paul Hayter',0
	

	section program_area,bss
area_base	ds.b	SIZE_OF_CHIP8_MEMORY
file_area	ds.b	SIZE_OF_CHIP8_MEMORY+100
	end
