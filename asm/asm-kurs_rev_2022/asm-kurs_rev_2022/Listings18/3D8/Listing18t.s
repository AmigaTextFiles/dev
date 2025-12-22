
; Listing18t.s = DEMOSELECT.s

; Assemble and die!!!
; Angus, there are 2 modules on this disk 'okkie' & 'scoopex theme'


	Section vectors,code_c	*All code to chip memory

no_stars	equ	48
	
	bsr	killsystem	*Get rid of O.S
	bsr	allocate	*Allocate memory
	bsr	setcopper	*Set up copper list
	bsr	setscreen	*Set screen parameters,palette
	bsr	startup		*Start up DMA channels
;	bsr	makesine
	bsr	getmouse
	bsr	set_sprites
	
	move.w	#-4,styvel


loop:
	bsr	flipframe
;	bsr	erase
;	bsr	movestars
	move.l	point_data_ptr,a6
;	bsr	calcobject
	bsr	demotasks
	move.l	face_data_ptr,a6
;	bsr	plotobject_filled
	bsr	demotasks
;	bsr	nextobject
	bsr	demotasks
	tst.w	ret_flag
	beq.s	loop		*If not pressed - continue loop

;	bsr	mt_end
	bsr	deallocate
	bsr	revivesystem	*Bring back O.S
	clr.l	d0		*Keep EXEC happy
	rts

****************************************


****************************************


demotasks:
	btst	#4,intreqr+1+custom
	beq.s	not_time_for_demo_tasks
	move.w	#$10,intreq+custom
	movem.l	d0-d7/a0-a6,-(sp)
;	bsr	mt_music
	bsr	calcequal
;	bsr	RotateObject
	bsr	scroll_bar
;	bsr	print
	bsr	move_pointer
;	bsr	greets
	move.w	joy0dat+custom,d0
	move.w	d0,omouse
	movem.l	(sp)+,d0-d7/a0-a6
not_time_for_demo_tasks
	rts

****************************************


*************************************
*	MAIN LOOP SUBROUTINES	    *
*************************************

*************************
*			*
*	MOVE SPRITE 	*
*			*
*************************

move_sprite:				*moves sprite
	move.l	sprites_ptr,a6
	lsl.w	#8,d2
	lea	(a6,d2.w),a6
move_reuse:
	add.w	#$81,d0		*value=height/2
	add.w	#$2c,d1
	move.w	d1,d2
	lsl.w	#8,d2
	roxl.b	#2,d2
	add.w	#16,d1			*value-height of sprites
	move.w	d1,d3
	lsl.w	#8,d3
	roxl.b	#1,d3
	or.b	d2,d3
	lsr.w	#1,d0
	move.b	d0,d2
	roxl.b	#1,d3
	or.w	#128,d3
	movem.w	d2-d3,(a6)
	rts

****************************************

rotate_flag:
	dc.w	0

move_pointer:
	clr.w	rotate_flag
	btst	#6,$bfe001
	beq.s	button_pressed
	bsr	getmouse
	add.w	px,d0
	bpl.s	mp1
	moveq	#0,d0
mp1:	cmp.w	#319,d0
	bmi.s	mp2
	move.w	#319,d0
mp2:
	add.w	py,d1
	bpl.s	mp3
	moveq	#0,d1
mp3:	cmp.w	#63,d1
	bmi.s	mp4
	move.w	#63,d1
mp4:
	movem.w	d0/d1,px
	moveq	#0,d2
	bsr	move_sprite
	movem.w	px,d0/d1
	moveq	#1,d2
	bsr	move_sprite
mp_ret:
	rts

button_pressed:
	move.w	px,d0
	sub.w	#235,d0
	bmi.s	mp_ret
	cmp.w	#48,d0
	bpl.s	mp_ret
	move.w	py,d1
	cmp.w	#32,d1
	bpl.s	mp_ret
	lsr.w	#4,d0
	lsr.w	#4,d1
	mulu	#3,d1
	add.w	d1,d0
	move.w	d0,d2
	lsl.w	#2,d2
	bsr	getmouse
	move.l	icon_table(pc,d2.w),a0
	jmp	(a0)

icon_table:
	dc.l	i_nextobject
	dc.l	i_lastobject
	dc.l	i_rotate
	dc.l	i_inout
	dc.l	i_move
	dc.l	i_quit


i_nextobject:
	move.w	#$0F0,$dff180
	rts

i_lastobject:
	move.w	#$FF0,$dff180
	rts


i_rotate:
	move.w	#$F0F,$dff180
	rts


i_inout:
	move.w	#$0FF,$dff180
	rts


i_move:
	move.w	#$00F,$dff180
	rts

i_quit:
	move.w	#-1,ret_flag
	rts

ret_flag:	dc.w	0
px:	dc.w	0
py:	dc.w	0


****************************************



scroll_bar:
	move.w	#0,bltalwm+custom
	move.l	nextlt_ptr,a0
	cmp.b	#100,(a0)
	beq.s	noplot
	move.w	#-1,bltalwm+custom
	move.l	scrollbuffer_ptr(pc),a1
	lea	2(a1),a0
s_wait:	btst	#6,dmaconr+custom
	bne.s	s_wait
	move.w	#%1100100111110000,bltcon0+custom
	move.w	#0,bltcon1+custom
	move.w	#0,bltamod+custom
	move.w	#0,bltdmod+custom
	move.w	#%0000111111111111,bltafwm+custom
	move.w	#3,d0		*Loop to blit 4 planes
s_blit:
	btst	#6,dmaconr+custom
	bne.s	s_blit
	move.l	a0,bltapth+custom
	move.l	a1,bltdpth+custom
	move.w	#(64*lty)+(bufferwidth/2),bltsize+custom
	lea	buffersize(a0),a0
	lea	buffersize(a1),a1
	dbra	d0,s_blit
noplot:
	move.w	#-1,bltafwm+custom
	rts

*************************************

delay:					*Wait for start of vertical blank	
	btst	#4,intreqr+1+custom
	beq.s	delay
	move.w	#$10,intreq+custom
	rts

*****************************************

getmouse:
	move.w	joy0dat+custom,d0
	sub.w	omouse,d0
	move.w	d0,d1
	lsr.w	#8,d1
	ext.w	d0
	ext.w	d1
	rts

*****************************************

flipframe:
	btst	#4,intreqr+1+custom
	beq.s	flipframe
	
	bsr	demotasks

	move.l	bitmap_ptr(pc),d1
	move.l	copscr2_ptr(pc),a0
	eor.w	#1,frame
	cmp.w	#1,frame
	beq.s	flipframe2

	add.l	#plwidth*48,d1
	move.w	#$00E0,d0		*Set bitplane pointer for main screen
	move.l	#plsize,d2
	moveq	#3,d7

	bsr	setcopperpointers
	sub.l	#plwidth*48,d1
	move.l	d1,bitmap1_ptr
	rts
flipframe2:
	move.l	d1,bitmap1_ptr
	add.l	#plsize*4+plwidth*48,d1
	move.l	a0,copscr2_ptr
	move.w	#$00E0,d0		*Set bitplane pointer for main screen
	move.l	#plsize,d2
	moveq	#3,d7
	bsr	setcopperpointers
	rts

*****************************************
*	SETUP SUBROUTINES          	*
*****************************************

**********************************


set_sprites
	lea	pointer0+4,a0
	moveq	#0,d2
	bsr	sprite_image
	lea	pointer1+4,a0
	moveq	#1,d2
	bsr	sprite_image
	rts

pointer0:
	dc.w	$0000,$0000
	dc.w	$0000,$0000
	dc.w	$6000,$2000
	dc.w	$3000,$6000
	dc.w	$7800,$7000
	dc.w	$7C00,$1800
	dc.w	$1E00,$4E00
	dc.w	$6C00,$4A00
	dc.w	$6B80,$7200
	dc.w	$3940,$7EC0
	dc.w	$57E0,$4FE0
	dc.w	$34C0,$33C0
	dc.w	$4B00,$0400
	dc.w	$2400,$5480
	dc.w	$0200,$0100
	dc.w	$0380,$0280
	dc.w	$0000,$0000
	dc.w	$0000,$0000

pointer1:
	dc.w	$0000,$0000
	dc.w	$6000,$6000
	dc.w	$9000,$9000
	dc.w	$A800,$A800
	dc.w	$B400,$B400
	dc.w	$DA00,$9A00
	dc.w	$ED00,$8D00
	dc.w	$F180,$8080
	dc.w	$FCC0,$8040
	dc.w	$FFE0,$8020
	dc.w	$BFF0,$8010
	dc.w	$CFE0,$8020
	dc.w	$FFC0,$80C0
	dc.w	$FFC0,$8840
	dc.w	$76C0,$7440
	dc.w	$0640,$0440
	dc.w	$0380,$0380
	dc.w	$0000,$0000



*********************************

sprite_image:	;(A0 = source image data, D2 = dest. sprite number)
	lsl.w	#8,d2
	move.l	sprites_ptr,a1
	lea	4(a1,d2.w),a1
	move.w	#15,d7
sprite_iloop:
	move.l	(a0)+,d0
	move.l	d0,68(a1)	* Set re-use
	move.l	d0,136(a1)	* Set re-use
	move.l	d0,(a1)+
	dbra	d7,sprite_iloop
	rts
	

***********************************

wait:
	move.l	#50,d7
.wait	bsr	delay
	dbra	d7,.wait
	rts

*********************************************

colmap:
	dc.w	$000,$fff,$ccc,$999,$777,$555
	dc.w	$f32,$c31,$921,$720,$510
	dc.w	$58f,$46d,$34c,$22b,$119

setcopper:
	move.l	copperlist_ptr(pc),a0
	move.l	#$01800000,(a0)+
	move.w	#$0120,d0		*Set sprite pointers:
	move.l	sprites_ptr,d1
	move.l	#$100,d2
	moveq	#7,d7
	bsr	setcopperpointers

	move.l	#bplcon0*$10000+$5200,(a0)+
	move.w	#$00E0,d0		*Set bitplane pointers for Icon Panel
	move.l	#pic,d1
	move.l	#plwidth*64,d2
	moveq	#4,d7
	bsr	setcopperpointers
	move.l	a0,coppal
	moveq	#31,d7
	lea	pic+plwidth*5*64,a1
	bsr	setcopperpalette

	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+

	move.l	#$3401fffe,d1
	move.l	#$02000000,d2
	move.w	#color16,d0
	moveq	#23,d7
	lea	greet_cols,a1
	bsr	setcopperbar

	move.l	#$6c01fffe,(a0)+
	move.l	a0,copscr2_ptr
	move.w	#$00E0,d0		*Set bitplane pointers for main screen
	move.l	bitmap2_ptr(pc),d1
	add.l	#48*plwidth,d1
	move.l	#plsize,d2
	moveq	#3,d7
	bsr	setcopperpointers

	move.w	#bplcon0,(a0)+
	move.w	#$4200,(a0)+

	moveq	#15,d7
	lea	colmap,a1
	bsr	setcopperpalette

	move.l	#$ff09fffe,(a0)+
	move.l	#$ffddfffe,(a0)+

	move.l	#$0c01fffe,(a0)+

	move.w	#$00E0,d0		*Set bitplane pointers for scroll text
	move.l	scrollbuffer_ptr(pc),d1
	move.l	#buffersize,d2
	moveq	#3,d7
	bsr	setcopperpointers
	move.l	#$0182014d,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#$4200,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#bufferwidth-plwidth,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#bufferwidth-plwidth,(a0)+

	
	move.l	#$1c01fffe,(a0)+	* Wait for end of display
	move.w	#intreq,(a0)+
	move.w	#%1000000000010000,(a0)+


	move.l	#$FFFFFFFE,(a0)+	*End copper list
	clr.w	$dff180
	move.w	#$8cf,$dff182
	rts

coppal:	dc.l	0

greet_cols:
	dc.w	$080,$090,$0a0,$0b0,$0c0,$1d1,$2e2,$3f3
	dc.w	$4f4,$5f5,$6f6,$7f7,$8f8,$9f9,$afa,$bfb
	dc.w	$cfc,$dfd,$efe,$dfd,$efe,$fff,$fff,$fff
	dc.w	$afa,$9f9,$8f8,$7f7,$6f6,$5f5,$4f4,$3f3

************************

setcopperpointers:
	move.w	d0,(a0)+
	add.w	#2,d0
	swap	d1
	move.w	d1,(a0)+
	move.w	d0,(a0)+
	add.w	#2,d0
	swap	d1
	move.w	d1,(a0)+
	add.l	d2,d1
	dbra	d7,setcopperpointers
	rts

setcopperbar:
	move.l	d1,(a0)+
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	add.l	d2,d1
	dbra	d7,setcopperbar
	rts

setcopperpalette:
	move.w	#$0180,d0
.setcopperpalette
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq	#2,d0
	dbra	d7,.setcopperpalette
	rts

*****************************************

setscreen:
	clr.w	bplcon1+custom
	move.w	#$0038,ddfstrt+custom
	move.w	#$00d0,ddfstop+custom
	move.w	#$2C81,diwstrt+custom
	move.w	#$1CC1,diwstop+custom
	move.w	#$FFFF,bltafwm+custom
	move.w	#$FFFF,bltalwm+custom
	rts

*****************************************

allocate:
	move.l	#(plsize*8)+(buffersize*4)+(coppersize)+(spritesize*8)+(plsize),d0
	move.l	#chip+clear,d1
	move.l	execbase,a6
	jsr	allocmem(a6)
	

	lea	bitmap_ptr(pc),a0
	move.l	d0,(a0)+
	move.l	d0,(a0)+		*Bitmap 1 pointer
	add.l	#plsize*4,d0
	move.l	d0,(a0)+
	add.l	#plsize*4,d0
	move.l	d0,(a0)+		*Scroll buffer pointer
	add.l	#buffersize*4,d0
	move.l	d0,(a0)+		*Copperlist pointer
	add.l	#coppersize,d0
	move.l	d0,(a0)+		*Sprite pointer
	add.l	#spritesize*8,d0
	move.l	d0,spare_ptr

	rts

*****************************************

deallocate:
	move.l	#(plsize*8)+(buffersize*4)+(coppersize)+(spritesize*8)+(plsize),d0
	move.l	bitmap_ptr(pc),a1
	move.l	execbase,a6
	jsr	freemem(a6)
	rts

*****************************************		

startup:
	move.l	copperlist_ptr(pc),a0
	move.l	a0,cop1lc+custom	*Tell system where copper is
	move.w	copjmp1+custom,d0	*And start it
	move.w	#0,$dff1fc	; reset AGA
	move.w	#$87e0,dmacon+custom	*Enable Dma.

	move.w	#40-12,bltdmod+custom
	move.l	#pic+4+plwidth*8,bltdpth+custom
	move.w	#$0100,bltcon0+custom
	move.w	#0,bltcon1+custom
	move.w	#(64*48)+6,bltsize+custom
g_wb4:
	btst	#6,dmaconr+custom
	bne.s	g_wb4

	rts

*****************************************


killsystem:
	move.l	execbase,a6			*Get pointer to EXEC
	lea	gfxname(pc),a1
	moveq	#0,d0
	jsr	openlib(a6)		*Openoldlibrary
	move.l	d0,a1
	move.l	38(a1),syscop
	move.w	intenar+custom,d0
	or.w	#$8000,d0
	move.w	d0,interrupts
	move.w	dmaconr+custom,d0
	or.w	#$8000,d0
	move.w	d0,dmacontrol

	move.w	#$7fff,intena+custom	*All interrupts off
	move.w	#$7fff,dmacon+custom	*All dma off
	rts

*****************************************

revivesystem:
	move.l	execbase,a6

	move.w	dmacontrol(pc),dmacon+custom
	move.w	interrupts(pc),intena+custom
	move.w	#$7fff,intreq+custom
	clr.w	aud0vol+custom
	clr.w	aud1vol+custom
	clr.w	aud2vol+custom
	clr.w	aud3vol+custom

	move.l	syscop(pc),d0
	move.l	d0,cop1lc+custom

	move.l	execbase,a6			*Get pointer to EXEC 
	lea	intname(pc),a1
	moveq	#0,d0
	jsr	-552(a6)
	move.l	d0,a6
	jsr	-390(a6)
	rts

*****************************************
*	EQUALISER CALCULATION:		*
*****************************************

eq1		dc.w	15		;equalizer heights!
eq2		dc.w	15
eq3		dc.w	15
eq4		dc.w	15


calcequal:
	move.l	coppal,a1
	lea	24*4(a1),a1
;	move.w	mt_aud1temp(pc),d0
	lea	eq1(pc),a0
	bsr.s	doequal
	move.w	(a0),2(a1)
;	move.w	mt_aud2temp(pc),d0
	lea	eq2(pc),a0
	bsr.s	doequal
	move.w	(a0),6(a1)
;	move.w	mt_aud3temp(pc),d0
	lea	eq3(pc),a0
	bsr.s	doequal
	move.w	(a0),10(a1)
;	move.w	mt_aud4temp(pc),d0
	lea	eq4(pc),a0
	bsr.s	doequal
	move.w	(a0),14(a1)

	move.w	pulse,d0
	addq.b	#1,d0
	and.w	#$3f,d0
	move.w	d0,pulse
	lsl.w	#1,d0
	lea	pulse_table,a0
	move.w	(a0,d0.w),d0
	move.w	d0,22(a1)
	neg.w	d0
	add.w	#$fff,d0
	move.w	d0,26(a1)
	rts

doequal	tst.w	d0
	beq.s	.down		;if note not played then equalizer down
	cmp.w	#15,(a0)
	bge.s	.exit
	addq	#2,(a0)		;if it is played then equalizer up!
.exit	rts	

.down	cmp.w	#1,(a0)
	ble.s	.exit2
	subq.w	#1,(a0)
	rts
.exit2	clr.w (a0)		;make sure equalizer has no minus numbers!
	rts

*********************************
*	SOUND TRACKER REPLAY	*
*********************************


***************************************
*         EQUATES                     *
***************************************


* HARDWARE REGISTERS *

custom 	EQU $dff000
bltddat	EQU $000
dmaconr	EQU $002
vposr	EQU $004
vhposr	EQU $006
dskdatr	EQU $008
joy0dat	EQU $00A
joy1dat	EQU $00C
clxdat	EQU $00E
adkconr	EQU $010
pot0dat	EQU $012
pot1dat	EQU $014
potinp	EQU $016
serdatr	EQU $018
dskbytr	EQU $01A
intenar	EQU $01C
intreqr	EQU $01E
dskpt	EQU $020
dsklen	EQU $024
dskdat	EQU $026
refptr	EQU $028
vposw	EQU $02A
vhposw	EQU $02C
copcon	EQU $02E
serdat	EQU $030
serper	EQU $032
potgo	EQU $034
joytest	EQU $036
strequ	EQU $038
strvbl	EQU $03A
strhor	EQU $03C
strlong	EQU $03E
bltcon0	EQU $040
bltcon1	EQU $042
bltafwm	EQU $044
bltalwm	EQU $046
bltcpth	EQU $048
bltbpth	EQU $04C
bltapth	EQU $050
bltaptl	EQU $052
bltdpth	EQU $054
bltsize	EQU $058
bltcmod	EQU $060
bltbmod	EQU $062
bltamod	EQU $064
bltdmod	EQU $066
bltcdat	EQU $070
bltbdat	EQU $072
bltadat	EQU $074
dsksync	EQU $07E
cop1lc	EQU $080
cop2lc	EQU $084
copjmp1	EQU $088
copjmp2	EQU $08A
copins	EQU $08C
diwstrt	EQU $08E
diwstop	EQU $090
ddfstrt	EQU $092
ddfstop	EQU $094
dmacon	EQU $096
clxcon	EQU $098
intena	EQU $09A
intreq	EQU $09C
adkcon	EQU $09E
aud0lc	EQU $0A0
aud1lc	EQU $0b0
aud2lc	EQU $0c0
aud3lc	EQU $0d0
aud0len	EQU $a4
aud1len	EQU $b4
aud2len	EQU $c4
aud3len	EQU $d4
aud0per	EQU $a6
aud1per	EQU $b6
aud2per	EQU $c6
aud3per	EQU $d6
aud0vol	EQU $a8
aud1vol	EQU $b8
aud2vol	EQU $c8
aud3vol	EQU $d8
aud0dat	EQU $aa
aud1dat	EQU $ba
aud2dat	EQU $ca
aud3dat	EQU $da
bpl1pth	EQU $0E0
bpl2pth	EQU $0E4
bpl3pth	EQU $0E8
bpl4pth	EQU $0EC
bpl5pth	EQU $0F0
bpl6pth	EQU $0F4
bplcon0	EQU $100
bplcon1	EQU $102
bplcon2	EQU $104
bpl1mod	EQU $108
bpl2mod	EQU $10A
bpldat	EQU $110
sprpt	EQU $120
spr	EQU $140
sd_pos	EQU $00
sd_ctl	EQU $02
sd_dataa 	EQU $04
sd_datab 	EQU $08
color00	EQU $180
color01	EQU $182
color02	EQU $184
color03	EQU $186
color04	EQU $188
color05	EQU $18a
color06	EQU $18c
color07	EQU $18e
color08	EQU $190
color09	EQU $192
color10	EQU $194
color11	EQU $196
color12	EQU $198
color13	EQU $19a
color14	EQU $19c
color15	EQU $19e
color16	EQU $1a0
color17	EQU $1a2
color18	EQU $1a4
color19	EQU $1a6
color20	EQU $1a8
color21	EQU $1aa
color22	EQU $1ac
color23	EQU $1ae
color24	EQU $1b0
color25	EQU $1b2
color26	EQU $1b4
color27	EQU $1b6
color28	EQU $1b8
color29	EQU $1ba
color30	EQU $1bc
color31	EQU $1be
diskreg	EQU $bfd100
skeys	EQU $bfec01



* EXEC LIBRARY *

execbase	equ	4
openlib		equ	-30-378
closelib	equ	-414
forbid		equ	-132
permit		equ	-138
allocmem	equ	-198
allocabs	equ	-204
freemem		equ	-210
chip		equ	$2
clear		equ	$10000

* DOS LIBRARY *

mode_old	equ	1005
mode_new	equ	1006
read		equ	-42
write		equ	-48

* PROGRAM EQUATES *

ltx		equ	2	*In BYTES
lty		equ	16
plwidth		equ	40
plsize		equ	plwidth*256
bufferwidth	equ	plwidth+ltx
buffersize	equ	bufferwidth*(lty+4)
coppersize	equ	8192
spritesize	equ	256
fontplwidth	equ	32	
fontplsize	equ	fontplwidth*5*lty
picplsize	equ	40*62

***************************************
*         DATA                        *
***************************************

* WORKSPACE FOR MAIN PROGRAM *

styvel	dc.w	0
texture	dc.w	$8000
linesize	dc.w	-1
object	dc.w	0
cycle	dc.w	0
old_y	dc.w	0
omouse	dc.w	0
wobx	dc.w	0
size	dc.w	16
svel	dc.w	0
frame	dc.w	0
rcount	dc.w	0
count	dc.w	0
ocount	dc.w	0
stdata	ds.w	no_stars*3

* POINTERS TO ALLOCATED MEMORY,ETC *

bitmap_ptr		dc.l	0
bitmap1_ptr		dc.l	0
bitmap2_ptr		dc.l	0
scrollbuffer_ptr	dc.l	0
copperlist_ptr		dc.l	0
sprites_ptr		dc.l	0
spare_ptr		dc.l	0
equbar_ptr		dc.l	0
wob_ptr			dc.l	0
nextlt_ptr		dc.l	0
copscr2_ptr		dc.l	0
point_data_ptr		dc.l	0
line_data_ptr		dc.l	0
face_data_ptr		dc.l	0
vtable_ptr		dc.l	0

* WORKSPACE FOR SETUP ROUTINES *

dosbase	dc.l 0
handle	dc.l 0
syscop 	dc.l 0

interrupts	dc.w 0
dmacontrol	dc.w 0


* LIBRARY NAMES *

intname	dc.b "intuition.library",0
gfxname	dc.b "graphics.library",0
dosrod	dc.b 'dos.library',0
	even


* BINARY DATA *

SDAT:	dc.w	032,134,221,331,013,167,218,395,071,162,238,354
	dc.w	023,188,234,314,054,125,278,394,069,123,293,346
	dc.w	032,134,221,331,013,167,218,395,071,162,238,354
	dc.w	023,188,234,314,054,125,278,394,069,123,293,346
	dc.w	032,134,221,331,013,167,218,395,071,162,238,354
	dc.w	023,188,234,314,054,125,278,394,069,123,293,346

sprite_data:	ds.b	$100*7
SPR7:	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.L	0
	
text:
	dc.b	"Welcome to vector demo 4 by legend. please note that on some amigas"
	dc.b	" there seems to be a hardware bug with area fill,but this demo should work on most amigas,like my own 500."
     	dc.b	$ff
	even

	dc.b	$ff

	even

cvectors:
	dc.w	$011,$101,$110,$001

coltb1:	dc.w	$f00,$f11,$f22,$f33,$f44,$f55,$f66,$f77
	dc.w	$f88,$f99,$faa,$fbb,$fcc,$fdd,$fee,$fff
	dc.w	$fff,$fee,$fdd,$fcc,$fbb,$faa,$f99,$f88
	dc.w	$f77,$f66,$f55,$f44,$f33,$f22,$f11,$f00
	

coltb2:	dc.w	$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999,$888
	dc.w	$777,$666,$555,$444,$333,$222,$111,$000

coltb3:	dc.w	$000,$fff,$fff,$fff,$eee,$eee,$ccc,$ccc
	dc.w	$aaa,$aaa,$888,$888,$666,$666,$444,$444

	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	
coltb4:
	dc.w	$aef,$bff,$cff,$dff,$eff
	dc.w	$fff,$ffe,$ffd,$ffc,$ffb,$ffa,$ff9,$ff8
	dc.w	$fe7,$fd6,$fc5,$fb4,$fa3,$f92,$f81,$f70
	dc.w	$e60,$d50,$c40,$b30,$a20,$910,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$000

coltb5:
	dc.w	$000,$000,$100,$200,$300,$400,$500,$600
	dc.w	$700,$800,$910,$a20,$b30,$c40,$d50,$e60
	dc.w	$f70,$f81,$f92,$fa3,$fb4,$fc5,$fd6,$fe7
	dc.w	$ff8,$ff9,$ffa,$ffb,$ffc,$ffd,$ffe,$fff
	dc.w	$fff,$ffe,$ffd,$ffc,$ffb,$ffa,$ff9,$ff8
	dc.w	$fe7,$fd6,$fc5,$fb4,$fa3,$f92,$f81,$f70
	dc.w	$e60,$d50,$c40,$b30,$a20,$910,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$000
coltb5_end:
	dc.w	$000,$000,$100,$200,$300,$400,$500,$600
	dc.w	$700,$800,$910,$a20,$b30,$c40,$d50,$e60
	dc.w	$f70,$f81,$f92,$fa3,$fb4,$fc5,$fd6,$fe7
	dc.w	$ff8,$ff9,$ffa,$ffb,$ffc,$ffd,$ffe,$fff
	dc.w	$fff,$ffe,$ffd,$ffc,$ffb,$ffa,$ff9,$ff8
	dc.w	$fe7,$fd6,$fc5,$fb4,$fa3,$f92,$f81,$f70
	dc.w	$e60,$d50,$c40,$b30,$a20,$910,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$000


	dc.w	$000,$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999
	dc.w	$888,$777,$666,$555,$444,$333,$222,$111
	dc.w	$000,$fea,$cb3,$870
	dc.w	$000,$fea,$cb3,$870
	dc.w	$000,$fea,$cb3,$870
	dc.w	$000,$fea,$cb3,$870

pulse_table:
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007
	dc.w	$008,$009,$00a,$00b,$00c,$00d,$00e,$00f
	dc.w	$00f,$01f,$02f,$03f,$04f,$05f,$06f,$07f
	dc.w	$08f,$09f,$0af,$0bf,$0cf,$0df,$0ef,$0ff
	dc.w	$0ff,$1ff,$2ff,$3ff,$4ff,$5ff,$6ff,$7ff
	dc.w	$8ff,$9ff,$aff,$bff,$cff,$dff,$eff,$fff
	dc.w	$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999,$888
	dc.w	$777,$666,$555,$444,$333,$222,$111,$000

pulse:	dc.w	0


	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	
	dc.w	$340,$450,$340,$010
	dc.w	$450,$561,$450,$010
	dc.w	$560,$672,$560,$010
	dc.w	$670,$783,$670,$010

pic:
	incbin	"iconpanel.raw"

