
; Listings17l.s = snowgame.s

;--------The Snow Demo Source ©1993 Rombust. Late update 28/09/93----------

;----- Set tab size to 10 in the assembler options ------

;------------------------------Equates------------------------------

screenwidth:	equ	320
screenheight:	equ	256
bitplanes:	equ	4
maxsmallsnow:	equ	30
snowstart:	equ	20
cloudheight:	equ	40
maxspeed:		equ	8

 
custom	equ	$dff000 
bpl1pth	equ	$0e0 
bpl1ptl	equ	$0e2 
bpl2pth	equ	$0e4 
bpl2ptl	equ	$0e6 
bpl3pth	equ	$0e8 
bpl3ptl	equ	$0ea 
bpl4pth	equ	$0ec 
bpl4ptl	equ	$0ee 
bpl5pth	equ	$0f0 
bpl5ptl	equ	$0f2 
bpl6pth	equ	$0f4 
bpl6ptl	equ	$0f6 
bpl1dat	equ	$110 
bpl2dat	equ	$112 
bpl3dat	equ	$114 
bpl4dat	equ	$116 
bpl5dat	equ	$118 
bpl6dat	equ	$11a 
bltddat 	equ	$000
dmaconr	equ	$002
vposr	equ	$004
vhposr	equ	$006
dskdatr	equ	$008
joy0dat	equ	$00A
joy1dat	equ	$00C
clxdat	equ	$00E
adkconr	equ	$010
pot0dat	equ	$012
pot1dat	equ	$014
potinp	equ	$016
serdatr	equ	$018
dskbytr	equ	$01A
intenar	equ	$01C
intreqr	equ	$01E
dskpt	equ	$020
dsklen	equ	$024
dskdat	equ	$026
refptr	equ	$028
vposw	equ	$02A
vhposw	equ	$02C
copcon	equ	$02E
serdat	equ	$030
serper	equ	$032
potgo	equ	$034
joytest	equ	$036
strequ	equ	$038
strvbl	equ	$03A
strhor	equ	$03C
strlong	equ	$03E
bltcon0	equ	$040
bltcon1	equ	$042
bltafwm	equ	$044
bltalwm	equ	$046
bltcpt	equ	$048
bltbpt	equ	$04C
bltapt	equ	$050
bltdpt	equ	$054
bltsize	equ	$058
bltcon0l	equ	$05B		;note: byte access only
bltsizv	equ	$05C
bltsizh	equ	$05E
bltcmod	equ	$060
bltbmod	equ	$062
bltamod	equ	$064
bltdmod	equ	$066
bltcdat	equ	$070
bltbdat	equ	$072
bltadat	equ	$074
deniseid	equ	$07C
dsksync	equ	$07E
cop1lch	equ	$080
cop2lch	equ	$084
cop1lc	equ	$080
cop2lc	equ	$084
copjmp1	equ	$088
copjmp2	equ	$08A
copins	equ	$08C
diwstrt	equ	$08E
diwstop	equ	$090
ddfstrt	equ	$092
ddfstop	equ	$094
dmacon	equ	$096
clxcon	equ	$098
intena	equ	$09A
intreq	equ	$09C
adkcon	equ	$09E
bplpt	equ	$0E0
bplcon0	equ	$100
bplcon1	equ	$102
bplcon2	equ	$104
bplcon3	equ	$106
bpl1mod	equ	$108
bpl2mod	equ	$10A
bplcon4	equ	$10C
clxcon2	equ	$10E
bpldat	equ	$110
spr0pth	equ	$120 
spr0ptl	equ	$122 
spr1pth	equ	$124 
spr1ptl	equ	$126 
spr2pth	equ	$128 
spr2ptl	equ	$12a 
spr3pth	equ	$12c 
spr3ptl	equ	$12e 
spr4pth	equ	$130 
spr4ptl	equ	$132 
spr5pth	equ	$134 
spr5ptl	equ	$136 
spr6pth	equ	$138 
spr6ptl	equ	$13a 
spr7pth	equ	$13c 
spr7ptl	equ	$13e 
colour00	equ	$180 
colour01	equ	$182 
colour02	equ	$184 
colour03	equ	$186 
colour04	equ	$188 
colour05	equ	$18a 
colour06	equ	$18c 
colour07	equ	$18e 
colour08	equ	$190 
colour09	equ	$192 
colour10	equ	$194 
colour11	equ	$196 
colour12	equ	$198 
colour13	equ	$19a 
colour14	equ	$19c 
colour15	equ	$19e 
colour16	equ	$1a0 
colour17	equ	$1a2 
colour18	equ	$1a4 
colour19	equ	$1a6 
colour20	equ	$1a8 
colour21	equ	$1aa 
colour22	equ	$1ac 
colour23	equ	$1ae 
colour24	equ	$1b0 
colour25	equ	$1b2 
colour26	equ	$1b4 
colour27	equ	$1b6 
colour28	equ	$1b8 
colour29	equ	$1ba 
colour30	equ	$1bc 
colour31	equ	$1be 
htotal	equ	$1c0
hsstop	equ	$1c2
hbstrt	equ	$1c4
hbstop	equ	$1c6
vtotal	equ	$1c8
vsstop	equ	$1ca
vbstrt	equ	$1cc
vbstop	equ	$1ce
sprhstrt	equ	$1d0
sprhstop	equ	$1d2
bplhstrt	equ	$1d4
bplhstop	equ	$1d6
hhposw	equ	$1d8
hhposr	equ	$1da
beamcon0	equ	$1dc
hsstrt	equ	$1de
vsstrt	equ	$1e0
hcenter	equ	$1e2
diwhigh	equ	$1e4
fmode	equ	$1fc

dma_aud0	equ	0
dma_aud1	equ	1
dma_aud2	equ	2
dma_aud3	equ	3
dma_disk	equ	4
dma_sprite equ	5
dma_blitter equ	6
dma_copper equ	7
dma_bitplanes equ	8
dma_master equ	9
dma_blithog equ	10
dma_bltzero equ	13
dma_bltdone equ	14
dma_set	equ	15


;---------------------------Macros----------------------------------

makerandom	macro			;random routine Macro
	move.w	d0,-(sp)			;save d0
	
	move.w	random,d0			;old random number
	sub.w	#111,d0			;subtract seed
	bpl	.\@rnd			;is it minus
	add.w	#screenwidth,d0		;yes - add screen width
.\@rnd	move.w	d0,random			;put it back

	move.w	random2,d0		;old random number
	sub.w	#3,d0			;subtract seed
	bpl	.\@rnd2			;is it minus
	add.w	#cloudheight,d0		;yes - add y pos at bottom of cloud
.\@rnd2	move.w	d0,random2		;put it back

	move.w	random3,d0		;old random number
	sub.w	#1,d0			;subtract seed
	bpl	.\@rnd3			;is it minus
	add.w	#maxspeed,d0		;yes - add maximum speed
.\@rnd3	move.w	d0,random3		;put it back

	move.w	(sp)+,d0			;return d0
	endm				;end of macro

	section	main_program,code		;stick this in any ram

;	opt	o+,w-			;optimisations on, warnings off

	bsr	killsys			;get total control

	bsr	makecopperlist		;for display

	bsr	main			;actual game

	bsr	recsys			;recover OS

	moveq	#0,d0			;no CLI return code
	rts				;exit

main:
	makerandom			;call macro
	btst 	#0,$dff005		;is in pal area?
	beq 	main			;no, then loop
.loopy	btst 	#0,$dff005		;is a pal area
	bne 	.loopy			;yes then loop

	bsr	makesnowfall		;snow routine

	btst	#6,$bfe001		;test left button
	beq	.exit

	bra	main			;loop.
.exit

	rts

;------------------------Do snow fall------------------------

makesnowfall:

	bsr	_clearsnow		;remove moving snow
	bsr	_checksnow		;move the snow and check if collision
	bsr	_drawsnow			;draw moving snow
	rts				;done

;----------------Clear the moving snow from the screen--------------

_clearsnow:

	move.w	#maxsmallsnow-1,d7		;number of snow -1 (for dbra)
	lea	snowlist,a0		;snowdata
	lea	drawscreen,a1		;dest bitplane
	lea	screenoffsetx,a2		;x offsets of bitplane
	lea	screenoffsety,a3		;y offsets of bitplane
.clearsnow

	move.w	(a0)+,d0			;x pos
	move.w	(a0)+,d1			;y pos
	tst.w	(a0)+			;test flag
	bpl	.yok			;if bit 15 clear (the -ve bit) then branch
	
	;---- Don't clear snow drop, and reset variables ----
	
	move.w	random3,d0		;speed random
	move.w	d0,-2(a0)			;place it
	move.w	random,d0			;x random
	move.w	random2,d1		;y random

	makerandom			;re-roll dice

	move.w	d0,-6(a0)			;write x
	move.w	d1,-4(a0)			;write y

	bra	.dontclear		;don't clear snow drop
	
.yok
	;---- Clear snow drop ----

	add.w	d1,d1			;Y * 2 (into words)
	move.w	(a3,d1.w),d1		;d1 = y offset on screen
	add.w	d0,d0			;X * 2 (into words)
	move.b	(a2,d0.w),d2		;d2 = x offset (bytes)
	ext.w	d2			;turn byte to word
	add.w	d2,d1			;d1 = exacts offset to screen

	move.b	1(a2,d0.w),d0		;d0 = bit to set in byte

	bclr	d0,(a1,d1.w)		;clear the bit

	
.dontclear	
	dbra	d7,.clearsnow		;do all snow
	rts	

;-----------Move the snow and check collision between snow-------------

_checksnow:

	move.w	#maxsmallsnow-1,d7		;number of snow -1 (for dbra)
	lea	snowlist,a0		;snowdata
	lea	drawscreen,a1		;dest bitplane
	lea	screenoffsetx,a2		;x offsets of bitplane
	lea	screenoffsety,a3		;y offsets of bitplane
.movesnow	
	
	move.w	(a0),d0			;x pos
	move.w	2(a0),d1			;y pos

	move.b	5(a0),d3			;snow rate of fall
	ext.w	d3			;byte to word
	move.w	d0,d5			;save x pos
	move.w	d1,d6			;save y pos

	;----- Check to see if the difference between the old y pos and the
	;      new y pos contains a still snow drop ----

.checkloop
	move.w	d5,d0			;x pos
	move.w	d6,d1			;y pos

	add.w	#1,d1			;next line down

	;---- Test if snow drop is on pixel ----

	add.w	d1,d1			;Y * 2 (into words)
	move.w	(a3,d1.w),d1		;d1 = y offset on screen
	add.w	d0,d0			;X * 2 (into words)
	move.b	(a2,d0.w),d2		;d2 = x offset (bytes)
	ext.w	d2			;turn byte to word
	add.w	d2,d1			;d1 = exacts offset to screen

	move.b	1(a2,d0.w),d0		;d0 = bit to set in byte

	btst	d0,(a1,d1.w)		;test the bit
	beq	.nocol			;branch if snow is not present
	
	or.w	#1<<15,4(a0)		;set the flag bit (for clear snow routine)
					;so it re-rolls dice
	bra	.coloccured		;done
	
.nocol
	add.w	#1,d6			;next y pos
	dbra	d3,.checkloop		;do all y's
	
.coloccured
	move.w	d5,(a0)+			;save x
	move.w	d6,(a0)+			;save y
	addq.l	#2,a0			;skip flag

	dbra	d7,.movesnow		;do all snow

	rts				;done
	
;-----------------Draw the snow----------------------------------

_drawsnow:
	move.w	#maxsmallsnow-1,d7		;number of snow -1 (for dbra)
	lea	drawscreen,a1		;dest
	lea	snowlist,a0		;snowdata
	lea	screenoffsetx,a2		;x offsets of bitplane
	lea	screenoffsety,a3		;y offsets of bitplane
.drawsnow
	
	move.w	(a0)+,d0			;x pos
	move.w	(a0)+,d1			;y pos
	addq.l	#2,a0			;skip flag

	;---- draw the snow drop ----

	add.w	d1,d1			;Y * 2 (into words)
	move.w	(a3,d1.w),d1		;d1 = y offset on screen
	add.w	d0,d0			;X * 2 (into words)
	move.b	(a2,d0.w),d2		;d2 = x offset (bytes)
	ext.w	d2			;turn byte to word
	add.w	d2,d1			;d1 = exacts offset to screen

	move.b	1(a2,d0.w),d0		;d0 = bit to set in byte

	bset	d0,(a1,d1.w)		;set the bit	
	
	dbra	d7,.drawsnow		;do all snow
	rts

makecopperlist:
	lea	screen,a0			;screen
	lea	screenlist,a1		;screen for copperlist
	move.l	a0,d0
	
	move.l	#(screenwidth/8)*screenheight,d2 ;bitplane size
	
	move.w	#6-1,d1			;do all bitplanes
	
.putscr
	move.w	d0,6(a1)			;insert low adr
	swap	d0
	move.w	d0,2(a1)			;insert high adr
	swap	d0
	add.l	d2,d0			;next bitplane
	
	lea	8(a1),a1			;next bitplane instruction

	dbra	d1,.putscr		;do all bitplanes

	clr.l	0.w			;spr pointers are at 0, so stop them.

	move.l	#copperlist,cop1lc+custom	;the new copper

	move.w	#1<<dma_set+1<<dma_master+1<<dma_sprite+1<<dma_bitplanes+1<<dma_copper,dmacon+custom	;start hardware
	move.w	d0,$dff088
	move.w	#0,$dff1fc			
	rts


;--------------- Recsys: Recovers the operating system-------------------

recsys:
	lea	custom,A6			;Hardware regs
	move.w	#$7fff,dmacon(a6)		;Disable dmacon
	move.w	#$7fff,intena(a6)		;Disable intena
	move.w	#$7fff,intreqr(a6)		;Disable intreqr

	move.l	oldcopper(pc),cop1lc(a6)	;Put back old copper

	sub.l	a0,a0			;clear a0
	lea	oldsys(pc),a1		;old os. regs
	move.w	#(256/4)-1,d0		;number of regs
.rec	move.l	(a1)+,(a0)+		;put back to original value
	dbra	d0,.rec

	move.w	old_dmaconr(pc),d0
	move.w	old_intenar(pc),d1		;old hw regs
	move.w	old_intreqr(pc),d2

	or.w	#1<<15,d0
	or.w	#1<<15,d1			;set the "set" bits
	or.w	#1<<15,d2
	
	move.w	d0,dmacon(a6)
	move.w	d1,intena(a6)		;write to hardware
	move.w	d2,intreqr(a6)
	
	move.l 	gfxbase(pc),a6		;gfxbase
	jsr	-462(a6)			;Disown blitter

	move.l	4.w,a6			;execbase
	move.l	gfxbase(pc),a1		;gfxbase
	jsr	-414(a6)			;close graphics.library
	jsr	-126(a6)			;turn mulitasking back on

	rts				;done

;---------------------Killsys: Kills the operating system ----------------

killsys:
	lea 	gfxname(pc),a1		;name of the gfx library
	move.l	4.w,a6
	jsr	-408(a6)			;open graphics.library
	move.l	d0,a1
	move.l	d0,gfxbase		;store gfx base
	move.l	38(a1),oldcopper		;store old copper address
	move.l	a1,a6			;gfx base
	jsr	-456(a6)			;own blitter!
	move.l	4.w,a6			;exec base
	jsr	-120(a6)			;no multitasking

	sub.l	a0,a0			;clear a0
	lea	oldsys(pc),a1
	move.w	#(256/4)-1,d0		;save OS regs.
.copy	move.l	(a0)+,(a1)+
	dbra	d0,.copy

	lea	custom,a6
	move.w	dmaconr(a6),old_dmaconr
	move.w	intenar(a6),old_intenar	;clear hw regs
	move.w	intreqr(a6),old_intreqr

	move.w	#$7fff,dmacon(a6)		;Disable dmacon
	move.w	#$7fff,intena(a6)		;Disable intena
	move.w	#$7fff,intreqr(a6)		;Disable intreqr

	move.w	#0,fmode(a6)		;for AGA machines

	rts

gfxname:		dc.b	"graphics.library",0
		even
gfxbase:		dc.l	0
oldcopper: 	dc.l	0
oldsys:		dcb.b	256,0
old_dmaconr	dc.w	0
old_intenar 	dc.w	0
old_intreqr 	dc.w	0


	section	variables,data		;for variables
	
snowlist:
	rept	maxsmallsnow
	dc.w	screenwidth/2,10,1		;snow list
	endr
random:	dc.w	0
random2:	dc.w	0			;random variables
random3:	dc.w	0

screenoffsety:			;contains a list of y positions
temp	set	0		;clear assembler variable

	rept	screenheight+1		;repeat for all y's +1 (for safety)
	dc.w	temp			;make a dc.w (y pos)
temp	set	temp+(screenwidth/8)	;the next line down
	endr				;end repeat

screenoffsetx:			;contains a list of y positions
temp	set	0		;clear assembler variable

	rept	(screenwidth/8)+1		;repeat for all x's +1 (for safety)
	dc.b	temp,7			;make a dc.b (x pos, bit to set)
	dc.b	temp,6
	dc.b	temp,5
	dc.b	temp,4
	dc.b	temp,3			;for all 8 bits
	dc.b	temp,2
	dc.b	temp,1
	dc.b	temp,0
temp	set	temp+1			;the next x pos (byte)
	endr				;end repeat

	section	chip_stuff,data_c

copperlist:
	dc.w	bplcon0,bitplanes<<12	;4 bitplanes, 
	dc.w	bplcon1,0
	dc.w	bplcon2,$a
	dc.w	bpl1mod,0,bpl2mod,0
   	dc.w	ddfstrt,$38		;screen details
	dc.w	ddfstop,$d0
	dc.w	diwstrt,$2c81
	dc.w	diwstop,$2cc1

spritelist:

	dc.w	spr0pth,0,spr0ptl,0	
	dc.w	spr1pth,0,spr1ptl,0	
	dc.w	spr2pth,0,spr2ptl,0	
	dc.w	spr3pth,0,spr3ptl,0	
	dc.w	spr4pth,0,spr4ptl,0		;sprite positions
	dc.w	spr5pth,0,spr5ptl,0	
	dc.w	spr6pth,0,spr6ptl,0	
	dc.w	spr7pth,0,spr7ptl,0	

screenlist:

	dc.w	bpl1pth,0,bpl1ptl,0
	dc.w	bpl2pth,0,bpl2ptl,0
	dc.w	bpl3pth,0,bpl3ptl,0		;bitplane positions
	dc.w	bpl4pth,0,bpl4ptl,0
	dc.w	bpl5pth,0,bpl5ptl,0
	dc.w	bpl6pth,0,bpl6ptl,0

	;---	Main picture colours

	dc.w	colour00,$0000
	dc.w	colour01,$0666
	dc.w	colour02,$0555
	dc.w	colour03,$0444		;picture colours
	dc.w	colour04,$0322
	dc.w	colour05,$0720
	dc.w	colour06,$0830
	dc.w	colour07,$0070		;same colour as grass (hidden message)
	
	;----	Snow bitplane colours
	
	dc.w	colour08,$0fff		;snow colours
	dc.w	colour09,$0666
	dc.w	colour10,$0555		;same colour as cloud over cloud
	dc.w	colour11,$0444
	dc.w	colour12,$0fff
	dc.w	colour13,$0fff
	dc.w	colour14,$0fff
	dc.w	colour15,$0f00		;"Snow demo" colour

	
	dc.w	$1c01,$fffe,colour00,$100
	dc.w	$1d01,$fffe,colour00,$200
	dc.w	$1e01,$fffe,colour00,$300
	dc.w	$1f01,$fffe,colour00,$400
	dc.w	$2001,$fffe,colour00,$500
	dc.w	$2201,$fffe,colour00,$600
	dc.w	$2301,$fffe,colour00,$700	;colour bar at top
	dc.w	$2401,$fffe,colour00,$800
	dc.w	$2501,$fffe,colour00,$900
	dc.w	$2601,$fffe,colour00,$a00
	dc.w	$2701,$fffe,colour00,$b00
	dc.w	$2801,$fffe,colour00,$c00
	dc.w	$2901,$fffe,colour00,$d00
	dc.w	$2a01,$fffe,colour00,$e00
	dc.w	$2b01,$fffe,colour00,$f00
	dc.w	$2c01,$fffe,colour00,$1
	dc.w	$4001,$fffe,colour00,$2
	dc.w	$5701,$fffe,colour00,$3	;sky colours
	dc.w	$7001,$fffe,colour00,$4
	dc.w	$8701,$fffe,colour00,$5
	dc.w	$9d01,$fffe,colour00,$410
	dc.w	$9e01,$fffe,colour00,$330
	dc.w	$9f01,$fffe,colour00,$250	;sky to grass
	dc.w	$a001,$fffe,colour00,$160
	dc.w	$a101,$fffe,colour00,$070

	dc.w	$ffdf,$fffe		;wait for PAL
	
	dc.w	$2c01,$fffe,colour00,$f00
	dc.w	$2d01,$fffe,colour00,$e00
	dc.w	$2e01,$fffe,colour00,$d00
	dc.w	$2f01,$fffe,colour00,$c00
	dc.w	$3001,$fffe,colour00,$b00
	dc.w	$3101,$fffe,colour00,$a00
	dc.w	$3201,$fffe,colour00,$900
	dc.w	$3301,$fffe,colour00,$800
	dc.w	$3401,$fffe,colour00,$700	;colour bar at bottom
	dc.w	$3501,$fffe,colour00,$600
	dc.w	$3601,$fffe,colour00,$500
	dc.w	$3701,$fffe,colour00,$400
	dc.w	$3801,$fffe,colour00,$300
	dc.w	$3901,$fffe,colour00,$200
	dc.w	$3a01,$fffe,colour00,$100
	dc.w	$3b01,$fffe,colour00,$000


	dc.w	$ffff,$fffe		;end copper

screen:
	incbin	main.bm
drawscreen: equ	screen+(screenwidth/8)*screenheight*3	;pointer to last bitplane
	dcb.b	screenwidth/8,-1		;bottom of screen has snow on it.


	end

