
; Listings17p3.s = NewGFXZoom.s

; Use LMB to Quit, RMB for ZOOMING
*****************************************************************************
* 320 * 200 * 4 Piccy zoomer by phagex,  optimised to fuck, but watch for   *
* AGA 8-bitplane zoomer!!!                                                  *
*****************************************************************************
* Basically first of all, all necessary data is pre-calculated into tables  *
* as there would be no free VBL time to do it live.  Tables contain         *
* co-ordinates for each zoom size of 0 to 159, these co-ordinates specify   *
* (for zooming into) where the piccy should be scrolled outwards, and where *
* a new line should be placed to fill the gap left by the scrolling.  This  *
* process of scrolling and blitting a couple of lines is a LOT faster than  *
* it would be blitting EACH line at a different position (like my earlier   *
* efforts! i couldnt even blit 1 bitplane without slooow down!).  To do the *
* Y axis even less is involved, all thats done is there is a modulo copper  *
* setting on each copper line, and the modulos are set to miss out no-lines *
* or several, depending on the zoom size! if only X axis could be done that *
* way also!!     For zooming away from, scrolling is just used, the X pos   *
* that is scrolled is just picked up from a table, just like zooming into.  *
* Simple really! (hard to think of though!)                                 *
*   I've documented this source, but not as well as i could have, sorry but *
* aint got that much time!                                                  *
*****************************************************************************

;	Opt	c-
	Section	"Zoomer Code",Code_c

;Screen	= $c0000	; Main memory base for piccy buffers!!

	IncDir	""

Start	Movem.l	d0-d7/a0-a6,-(sp) 
	Bsr	KillSys	  
	
	Bsr	InitCopper	
	move.w	#0,$dff1fc
	Lea	ScreenBase(pc),a0
	Move.l	#Screen,0(a0)
	Move.l	#Screen+$7e40,4(a0)	
	Lea	SizeVal(pc),a0
	Move.w	#0,(a0)
	Lea	ZoomCopper(pc),a0
	Move.l	a0,$Dff080
	Move.w	#$87c0,$Dff096
	Bsr	TabInit
	
	Lea	CopperBCon(pc),a0
	Move.w	#$4200,2(a0)	; Switch on bitplanes
	
	Bsr	StartZoom	; Do zoom Loop
	
	Lea	CopperBCon(pc),a0
	Move.w	#$0200,2(a0)	; Switch off bitplanes

	Bsr	ReturnSys	  
	Movem.l	(sp)+,d0-d7/a0-a6 
	Moveq	#0,d0	  
	Rts

InitCopper	Move.w	#$2c01,d0
	Move.w	#$fffe,d1
	Move.l	#$01080078,d2
	Move.l	#$010a0078,d3
	Move.w	#$0100,d4
	Move.w	#$f507,d5	
	Lea	CopperMods(pc),a0
	Move.l	a0,a2
	
	Move.w	#200,d7
CopLoop1	Move.w	d0,(a0)+	; Setup the copper with
	Move.w	d1,(a0)+	; plenty of Modulo
	Move.l	d2,(a0)+	; pointers...
	Move.l	d3,(a0)+
	Dbf	d7,CopLoop1

	Move.l	a2,a0
	Move.w	#$3e,d0
	Move.w	#201,d1
CWaitLoop	Add.w	#1,d0	; Set the copperlist wait
	Move.b	d0,(a0)	; instructions.
	Cmpi.w	#$100,d0
	Bne	PalCopper
	Move.w	#$ffe1,(a0)	; do PAL as well
	Move.w	#0,d0	
PalCopper	Add.l	#12,a0
	Dbf	d1,CWaitLoop
	
	Move.l	ScreenBase(pc),a0
	Move.l	a0,a1
	Add.l	#$7e40*2,a1

ClearScreen	Move.l	#0,(a0)+	; Simple Clear screen Loop
	Cmp.l	a0,a1
	Bne	ClearScreen
	
	Move.l	ScreenBase(pc),d2
	Lea	CopperBPLS(pc),a0
	Moveq	#3,d1
SetBPLLoop	Move.l	d2,d0	; Set main bitplane
	Move	d0,6(a0)	; pointers
	Swap	d0
	Move	d0,2(a0)
	Add.l	#$a0,d2
	Lea	8(a0),a0
	Dbf	d1,SetBPLLoop

	Lea	PiccyCols(pc),a0
	Lea	CopperCols(pc),a1
	Moveq	#15,d0
CopyCols	Move.w	(a0)+,2(a1)	; Copy palette colours
	Addq	#4,a1
	Dbf	d0,CopyCols
	Rts

WaitBlitter	Btst	#$6,$Dff002
	Bne	WaitBlitter
	Lea	$Dff000,a6
	Rts

StartZoom	Lea	SizeVal(pc),a0	; Set zoomsize to 0
	Move.w	#0,(a0)

ZoomOut	Btst	#6,$Bfe001	; Exit if Left mousey pressed
	Beq	EndZoom
	Btst	#2,$Dff016	; Do zoom if right pressed
	Bne	ZoomOut

	Move	SizeVal(pc),d0
	Move.l	ScreenBase(pc),a0
	Lea	160(a0),a0	; Find Screen base data
	Move.l	ScreenBase1(pc),a1
	Lea	160(a1),a1
	Lea	VarList(pc),a4
	Add.l	#ZoomBitmap-VarList,a4
	
	Bsr	DoZoomOut	; Do Zoom blitting GFX
	
	Bsr	VBL	; wait Vert Blank
	
	Bsr	DoZoomCalc	; Calculate copperlist
			; bitplanes!
	Lea	SizeVal(pc),a0
	Addq.w	#1,(a0)	; Add 1 to Zoomsize
	Cmpi.w	#160,(a0)
	Blt	ZoomOut

	Subq.w	#1,(a0)

ZoomIn	Btst	#6,$Bfe001	; This lot does same as above
	Beq	EndZoom	; only for zooming IN this
	Btst	#2,$Dff016	; time...
	Bne	ZoomIn	;

	Move.w	SizeVal(pc),d0
	Move.l	ScreenBase(pc),a0
	Lea	160(a0),a0
	Move.l	ScreenBase1(pc),a1
	Lea	160(a1),a1
	Bsr	DoZoomIn
	Bsr	VBL
	Bsr	DoZoomCalc
	Lea	SizeVal(pc),a0
	Subq	#1,(a0)
	Bpl	ZoomIn
	Bra	StartZoom

EndZoom	Rts

VBL	Move.l	$Dff004,d0
	And.l	#$1ff00,d0
	Cmp.l	#$13000,d0
	Bne	VBL
	Rts
	
DoZoomCalc	Lea	ScreenBase(pc),a0
	Move.l	0(a0),d0	; Double buffer Base pointers
	Move.l	4(a0),d1
	Move.l	d0,4(a0)
	Move.l	d1,0(a0)
	
	Lea	CopperBPLS(pc),a0
	Moveq	#3,d7
SetBPLoop	Move.l	d1,d2	; Set next BPLS
	Move.w	d2,6(a0)
	Swap	d2
	Move.w	d2,2(a0)
	Addq	#8,a0
	Add.l	#40,d1
	Dbf	d7,SetBPLoop	
	
	Lea	CopperMods+6(pc),a0
	Move.l	a0,d0
	
	Lea	$Dff000,a6
	Bsr	WaitBlitter	
	Move.l	d0,$54(a6)	; Blitter clear buffer
	Move.w	#-40,$74(a6)	
	Move.w	#10,$66(a6)	
	Move.l	#$ffffffff,$44(a6)	
	Move.l	#$01f00000,$40(a6)	
	Move.w	#$3241,$58(a6)

	Move.w	SizeVal(pc),d1	; Get zoomsize value
	Add.w	d1,d1
	Add.w	d1,d1
	Lea	ModTabList(pc),a0
	Move.l	(a0,d1.w),a0	; find modulo for size val

	Move.w	(a0)+,d1
	Move.w	(a0)+,d2
	Beq	NextBlit

	Lsl.w	#6,d2
	Addq.w	#1,d2	; Work out blitter size
	
	Ext.l	d1
	Add.l	d0,d1

	Bsr	WaitBlitter	; Copy block of modulos
	Move.l	a0,$50(a6)
	Move.l	d1,$54(a6)
	Move.l	#$09f00000,$40(a6)
	Move.w	#0,$64(a6)
	Move.w	d2,$58(a6)

NextBlit	Bsr	WaitBlitter	; Same or other block to
	Move.l	d0,$50(a6)	; blit copy modulo sizes
	Addq.l	#4,d0
	Move.l	d0,$54(a6)
	Move.w	#10,$64(a6)
	Move.l	#$09f00000,$40(a6)
	Move.w	#$3241,$58(a6)
	Bsr	WaitBlitter
	Rts

TabInit	Lea	ZoomerTab(pc),a0
	Lea	BitMapTab(pc),a1

	Moveq	#15,d0	; Initialise main data Tables
TabInitLoop1	Lea	WordTab(pc),a2
	Move.w	(a1)+,d1
	Move.w	#9,d2

TabInitLoop2	Move.w	(a2)+,d3
	Asl.w	#4,d3
	Add.w	d1,d3
	Move.w	d3,(a0)+
	Dbf	d2,TabInitLoop2
	Dbf	d0,TabInitLoop1

	Lea	LineBaseTab(pc),a0
	Move.w	#159,d0
	Move.w	#2000,d1
TabInitLoop3	Move.w	d1,(a0)+
	Dbf	d0,TabInitLoop3

	Lea	ZoomerTab(pc),a0
	Lea	ColCalcTab(pc),a1
	Lea	LineBaseTab(pc),a2
	Move.w	#0,d0

TabInitLoop4	Move.w	(a0,d0.w),d1
	Moveq	#-2,d2

TabInitLoop5	Addq.w	#2,d2
	Cmp.w	(a2,d2.w),d1
	Bgt	TabInitLoop5

	Lea	318(a2),a3
	Lea	(a2,d2.w),a4

TabInitLoop6	Move.w	-(a3),2(a3)
	Cmpa.l	a4,a3
	Bhi	TabInitLoop6

	Move.w	d1,(a4)
	Lsr.w	#1,d2
	Move.w	d2,(a1)+
	Addq.w	#2,d0
	Cmp.w	#160*2,d0
	Blo	TabInitLoop4

	Lea	PicZoomList(pc),a2
	Move.w	#0,(a2)+

	Move.w	#120,d0
	Move.w	#160,d1
	Move.w	#200,d2

TabInitLoop10	Move.w	d0,(a2)+
	Add.w	d1,d0
	Dbf	d2,TabInitLoop10

	Lea	ModuloTab(pc),a0
	Lea	ModTabList(pc),a1
	Lea	PicZoomList(pc),a2
	Moveq	#1,d7

	Move.l	a0,(a1)+
	Move.l	#0,(a0)+

TabInitLoop9	Move.l	a0,(a1)+
	Moveq	#0,d6

	Move.w	d7,d0
	Move.w	d7,d2
	Mulu	#$a000,d0
	Move.l	#$640000,d1
	Sub.l	d0,d1
	Swap	d1

	Add.w	d1,d1
	Add.w	d1,d1
	Add.w	d1,d6
	Add.w	d1,d1
	Add.w	d1,d6

	Add.l	d0,d0
	Swap	d0

	Move.l	#$a000,d1
	divu	d2,d1
	Swap	d1
	Move.w	#0,d1
	Lsr.l	#8,d1

	Moveq	#0,d2
	Moveq	#0,d4

	Move.w	d6,(a0)+
	Move.w	d0,(a0)+
	Addq.w	#1,-2(a0)
	Bra	TabInitLoop7

TabInitLoop8	Add.l	d1,d2
	Swap	d2
	Move.w	d2,d3

	Sub.w	d4,d3
	Add.w	d3,d3

	Move.w	(a2,d3.w),(a0)+
	Move.w	d2,d4
	Swap	d2

TabInitLoop7	Dbf	d0,TabInitLoop8

	Move.w	#201,d3
	Sub.w	d4,d3
	Add.w	d3,d3
	Move.w	(a2,d3.w),(a0)+
	Addq.w	#1,d7
	Cmp.w	#160,d7
	Bls	TabInitLoop9
	Rts

DoZoomIn	Add.w	d0,d0	; Get size val
	Lea	ColCalcTab(pc),a2
	Move.w	#$9f,d6
	Sub.w	(a2,d0.w),d6	; Use size as offset for
			; data table pickup
	Move.l	a0,a2
	Move.l	a1,a3

	Move.w	d6,d7	; Get horizontal position
	Not.w	d7	; to start horiz scrolling
	And.w	#$f,d7
	Lsr.w	#4,d6
	Move.w	d6,d5
	Add.w	d5,d5

	Moveq	#38,d0
	Sub.w	d5,d0
	Move.w	d6,d1
	Add.w	#$c801,d1

	Bsr	WaitBlitter
	Move.l	#$fffffffe,$44(a6)
	Movem.l	a0/a1,$50(a6)
	Move.w	d0,$64(a6)
	Move.w	d0,$66(a6)
	Move.l	#$19f00000,$40(a6)
	Move.w	d1,$58(a6)	; Scroll data inwards at
			; horizontal point
	Adda.w	d5,a0
	Adda.w	d5,a1
	Move.w	#0,d4
	Bset	d7,d4
	Subq.w	#1,d4

	Moveq	#38,d2
	Bsr	WaitBlitter	
	Movem.l	a0/a1,$50(a6)
	Move.l	a1,$4c(a6)
	Move.w	d2,$62(a6)
	Move.w	d2,$64(a6)
	Move.w	d2,$66(a6)
	Move.w	#$ffff,$46(a6)
	Move.w	d4,$70(a6)
	Move.w	#$0de4,$40(a6)	; Blitter clip line to make
	Move.w	#$c801,$58(a6)	; it look nice..

	Moveq	#18,d2
	Sub.w	d5,d2
	Beq	GetNextBlit	; is copy necessary?
	Moveq	#40,d3
	Sub.w	d2,d3
	Sub.w	d2,d3
	Add.w	#$c800,d2	; move on a screen or so.
	Addq.w	#2,a0
	Addq.w	#2,a1

	Bsr	WaitBlitter	
	Movem.l	a0/a1,$50(a6)	; blit it all back so it
	Move.w	d3,$64(a6)	; looks nice and smooooth
	Move.w	d3,$66(a6)
	Move.w	#$09f0,$40(a6)
	Move.w	d2,$58(a6)

GetNextBlit	Lea	$7d00-2(a2),a2	; now do the same to the 
	Lea	$7d00-2(a3),a3	; opposite side of the 
	Bsr	WaitBlitter	; screen..
	Movem.l	a2/a3,$50(a6)
	Move.w	#$7fff,$46(a6)
	Move.w	d0,$64(a6)
	Move.w	d0,$66(a6)
	Move.l	#$19f00002,$40(a6)
	Move.w	d1,$58(a6)	; Blit scroll inwards to
			; centre
	Eori.w	#$f,d7
	Addq.w	#1,d7
	Move.w	#0,d4	; calculate clip for blit
	Bset	d7,d4
	Subq.w	#1,d4
	Not.w	d4

	Moveq	#38,d2
	Suba.w	d5,a2
	Suba.w	d5,a3

	Bsr	WaitBlitter
	Movem.l	a2/a3,$50(a6)	; clip it so theres no
	Move.l	a3,$4c(a6)	; nasty remains
	Move.w	d2,$62(a6)
	Move.w	d2,$64(a6)
	Move.w	d2,$66(a6)
	Move.w	#$ffff,$46(a6)
	Move.w	d4,$70(a6)
	Move.w	#$0de4,$40(a6)
	Move.w	#$c801,$58(a6)	; hehe, all gone..
	Rts

DoZoomOut	Lea	ColCalcTab(pc),a2
	Add.w	d0,d0
	Move.w	d0,-(sp)
	Move.w	#$9f,d6
	Sub.w	(a2,d0.w),d6	; find our data with the
			; Size value again
	Move.l	a0,a2
	Move.l	a1,a3

	Move.w	d6,d7
	And.w	#$f,d7
	Lsr.w	#4,d6
	Move.w	d6,d5
	Add.w	d5,d5

	Lea	38(a0),a0
	Lea	38(a1),a1
	Suba.w	d5,a0
	Suba.w	d5,a1

	Moveq	#38,d0	; work out horizontal pos
	Sub.w	d5,d0	; for blitter scrolling
	Move.w	d6,d1
	Add.w	#$c801,d1

	Lea	$Dff000,a6
	Bsr	WaitBlitter
	Move.l	#$ffffffff,$44(a6)
	Movem.l	a0/a1,$50(a6)
	Move.w	d0,$64(a6)	; scroll the piccy out 
	Move.w	d0,$66(a6)	; towards the edges...
	Move.l	#$19f00000,$40(a6)
	Move.w	d1,$58(a6)

	Lea	$7d00-4(a2),a0
	Lea	$7d00-2(a3),a1
	Suba.w	d5,a0
	Suba.w	d5,a1

	Move.w	#0,d4	; work out where gap is..
	Addq.w	#1,d7
	Bset	d7,d4
	Subq.w	#1,d7
	Subq.w	#1,d4
	Not.w	d4

	Lea	$Dff000,a6
	Moveq	#38,d2
	Bsr	WaitBlitter
	Move.l	a1,$4c(a6)
	Move.l	a1,$50(a6)	; fill in the gap left
	Move.l	a1,$54(a6)	; behind by the scroll with
	Move.w	d2,$62(a6)	; a new line from the
	Move.w	d2,$64(a6)	; origional piccy!!
	Move.w	d2,$66(a6)
	Move.w	d4,$70(a6)
	Move.l	#$1de40002,$40(a6)
	Move.w	#$c801,$58(a6)

	Subq.w	#2,a1

	Moveq	#18,d2
	Sub.w	d5,d2
	Beq	GetNextBlit1
	Moveq	#40,d3
	Sub.w	d2,d3
	Sub.w	d2,d3

	Bsr	WaitBlitter	; Copy to make the screen
	Movem.l	a0/a1,$50(a6)	; a wee bit tidier..
	Move.w	d3,$64(a6)
	Move.w	d3,$66(a6)
	Move.w	d2,d3
	Add.w	#$c800,d2
	Move.w	#$09f0,$40(a6)
	Move.w	d2,$58(a6)

	Add.w	d3,d3
	Suba.w	d3,a0
	Suba.w	d3,a1

GetNextBlit1	Bsr	WaitBlitter	; do a scroll on the opposite
	Movem.l	a0/a1,$50(a6)	; side of the screen to make
	Move.w	d0,$64(a6)	; things look even again..
	Move.w	d0,$66(a6)
	Move.w	#$19f0,$40(a6)
	Move.w	d1,$58(a6)

	Lea	(a3,d5.w),a1
	Moveq	#38,d2	; oops, our scrolling action
	Move.w	#0,d4	; seems to have left an 
	Eori.w	#$f,d7	; empty line again, lets
	Bset	d7,d4	; do the decent thing and 
	Subq.w	#1,d4	; fill it up shall we??

	Lea	$Dff000,a6
	Bsr	WaitBlitter
	Move.l	a1,$4c(a6)
	Move.l	a1,$50(a6)
	Move.l	a1,$54(a6)
	Move.w	d2,$62(a6)
	Move.w	d2,$64(a6)
	Move.w	d2,$66(a6)
	Move.w	d4,$70(a6)
	Move.l	#$1de40000,$40(a6)
	Move.w	#$c801,$58(a6)	; yes, fill it in with GFX!

	Move.w	(sp)+,d0
	Lea	ZoomerTab(pc),a2
	Move.w	(a2,d0.w),d6
	Move.w	#$9f,d1
	Sub.w	d6,d1
	Move.w	d1,d2	; now then, we'll have to
	Not.w	d2	; make shure its all there
	And.w	#$f,d2	; (GFX that is)
	Lsr.w	#4,d1
	Add.w	d1,d1

	Lea	(a4,d1.w),a0	; are we approaching last
	Lea	(a3,d5.w),a1	; blit???
	Bsr	LastBlit

	Neg.w	d1
	Lea	38(a4,d1.w),a0
	Neg.w	d5
	Lea	38(a3,d5.w),a1
	Eor	#$f,d7
	Eor	#$f,d2
	Bsr	LastBlit
	Rts

LastBlit	Move.w	#0,d4	; do final clean up operation
	Bset	d7,d4

	Move.w	d2,d3
	Sub.w	d7,d3
	Bmi	DoDescend	; hmm, i'm going the other 
			; way thankyouverymuch.
	Ror.w	#4,d3
	Or.w	#$0de4,d3

	Bsr	WaitBlitter
	Movem.l	a0/a1,$50(a6)
	Move.l	a1,$4c(a6)
	Move.w	d3,$40(a6)
	Move.w	#0,$42(a6)
	Move.w	d4,$70(a6)
	Move.w	#$c801,$58(a6)
	Rts

DoDescend	Neg.w	d3	; opposite direction, GFX
	Ror.w	#4,d3	; line filled..
	Or.w	#$0de4,d3

	Lea	799*40(a0),a0	; point to the end of piccy
	Lea	799*40(a1),a1	; as mr. blitters going
			; backwards!!!
	Bsr	WaitBlitter
	Movem.l	a0/a1,$50(a6)
	Move.l	a1,$4c(a6)
	Move.w	d3,$40(a6)
	Move.w	#2,$42(a6)
	Move.w	d4,$70(a6)
	Move.w	#$c801,$58(a6)
	Rts

KillSys	Bsr.s	SysWait	

	Move.l	$4,a6	
	Lea	GFXName(pc),a1	
	Moveq	#0,d0	
	Jsr	-552(a6)	
		
	Lea	OldCop1(pc),a5
	Move.l	$26(a0),$0(a5)	
	Move.l	$32(a0),$4(a5)	
	
	Lea	HardWare,a6
	Move.w	IntEnaR(a6),d0	
	Move.w	DMAConR(a6),d1  
	Or.w	#$8000,d0	
	And.w	#$03ff,d1	
	Or.w	#$8000,d1	
	Move.w	d0,$8(a5)	
	Move.w	d1,$a(a5)	
	
	Move.w	#$7fff,IntEna(a6) 
	Move.w	#$7fff,DMACon(a6) 
	Rts

SysWait	Move.w	#15,d7	
SysWaitLoop	Move.l	#$05000,d1	
	Bsr.s	WaitVBL	
	Bsr.s	DoWaitVBL	
	Dbf	d7,SysWaitLoop	
	Rts

DoWaitVBL	Move.l	#$03000,d1	
WaitVBL	Movem.l	d0-d1/a6,-(sp)	
	Lea	HardWare,a6	
WaitVBLLoop	Move.l	VPosR(a6),d0	
	And.l	#$1ff00,d0	
	Cmp.l	d1,d0	
	Bne.s	WaitVBLLoop	
	Movem.l	(sp)+,d0-d1/a6	
	Rts		

ReturnSys	Lea	HardWare,a6	
	Move.w	OldIntEna(pc),IntEna(a6)
	Move.w	OldDMACon(pc),DMACon(a6)
	Move.l	OldCop1(pc),Cop1lc(a6)
	Move.l	OldCop2(pc),Cop2lc(a6)
	Rts

VarList

GFXName	Dc.b	"graphics.library",0
	Even
OldCop1	Dc.l	0	
OldCop2	Dc.l	0	
OldIntEna	Dc.w	0	
OldDmaCon	Dc.w	0	

SizeVal	Dc.w	0	; our luverly screen size

ZoomerTab	Dcb.w	160,0	; X Co-ords for zoom scroll
ColCalcTab 	Dcb.w	160,0	; X Co-ords for filling
LineBaseTab	Dcb.w	160,0	; Base for line pos calcs

WordTab	Dc.w	0,5,7,3,9,1,6,4,8,2   ; Word order
BitMapTab	Dc.w	8,12,4,14,2,10,6,15   ; Pixel order
	Dc.w	0,3,13,5,11,9,7,1     ; (both for blitter)
			
ScreenBase	Dc.l	$c0000	; Piccy buffer 1
ScreenBase1	Dc.l	$c7e40	; Piccy buffer 2

PiccyCols	Dc.w	0,$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999
	Dc.w	$888,$777,$666,$555,$444,$333,$222,$111
	Dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
Cmv	Macro
	Dc.w	\2,\1
	EndM
	
Cwt	Macro
	Dc.w	(\1*$100)+$01,$fffe
	EndM	

Pal	Macro
	Dc.w	$ffe1,$fffe
	EndM	

EndCop	Macro
	Dc.w	$ffff,$fffe
	EndM	

ZoomCopper	Cwt	$15	
	Cmv	$0200,BplCon0	
	Cmv	$00bb,BplCon1	
	Cmv	$000a,BplCon2	
	Cmv	$0034,DdfStrt	
	Cmv	$00c8,DdfStop	
	Cmv	$1651,DiwStrt	
	Cmv	$36c1,DiwStop
	Cmv	$78,BplMod1	
	Cmv	$78,BplMod2	
	
	Cwt	$25		
CopperCols	Cmv	$0000,Color00
	Cmv	$0fff,Color01
	Cmv	$0000,Color02
	Cmv	$0fff,Color03
	Cmv	$0000,Color04
	Cmv	$0fff,Color05
	Cmv	$0000,Color06
	Cmv	$0fff,Color07
	Cmv	$0000,Color08
	Cmv	$0fff,Color09
	Cmv	$0000,Color10
	Cmv	$0fff,Color11
	Cmv	$0000,Color12
	Cmv	$0fff,Color13
	Cmv	$0000,Color14
	Cmv	$0fff,Color15
	Cmv	$0000,Color16
	Cmv	$0fff,Color17
	Cmv	$0000,Color18
	Cmv	$0fff,Color19
	Cmv	$0000,Color20
	Cmv	$0fff,Color21
	Cmv	$0000,Color22
	Cmv	$0fff,Color23
	Cmv	$0000,Color24
	Cmv	$0fff,Color25
	Cmv	$0000,Color26
	Cmv	$0fff,Color27
	Cmv	$0000,Color28
	Cmv	$0fff,Color29
	Cmv	$0000,Color30
	Cmv	$0fff,Color31
	
CopperBPLS	Cmv	$0,BplPt0h
	Cmv	$0,BplPt0l	
	Cmv	$0,BplPt1h	
	Cmv	$0,BplPt1l	
	Cmv	$0,BplPt2h	
	Cmv	$0,BplPt2l	
	Cmv	$0,BplPt3h	
	Cmv	$0,BplPt3l	
	Cmv	$0,BplPt4h
	Cmv	$0,BplPt4l 
	
	Cwt	$3f
CopperBCon	Cmv	$0200,BplCon0

CopperMods	Ds.w	202*6	; Copper instructions for
			; bitplane use					
	EndCop

PicZoomList	Dcb.w	202,0	; Y co-ord line base
ModTabList	Dcb.l	161,0	; Modulo pointers
ModuloTab	Dcb.b	33044	; Pre-calced modulos!

	incdir	""

ZoomBitmap	Incbin	Transorb.Raw  ; piccy!

;	incdir	""

	section	piccy,bss_C

Screen:
	ds.b	10240*10

****Custom Chip Registers****

Hardware	= $Dff000



;Control Registers

Dmaconr	= $002
Vposr	= $004
Vhposr	= $006
Joy0dat	= $00A
Joy1dat	= $00C
Clxdat	= $00E
Intenar	= $01C
Intereqr	= $01E
Copcon	= $02E

;Blitter Registers

Bltcon0	= $040
Bltcon1	= $042
Bltafwm	= $044
Bltalwm	= $046
Bltcpth	= $048
Bltcptl	= $04A
Bltbpth	= $04C
Bltbptl	= $04E
Bltapth	= $050
Bltaptl	= $052
Bltdpth	= $054
Bltdptl	= $056
Bltsize	= $058
Bltcmod	= $060
Bltbmod	= $062
Bltamod	= $064
Bltdmod	= $066
Bltcdat	= $070
Bltbdat	= $072
Bltadat	= $074

;Copper Registers

Cop1lc	= $080
Cop1lch	= $080
Cop1lcl	= $082
Cop2lc	= $084
Cop2lch	= $084
Cop2lcl	= $086
Copjmp1	= $088
Copjmp2	= $08A
Diwstrt	= $08E
Diwstop	= $090
Ddfstrt	= $092
Ddfstop	= $094
Dmacon	= $096
Clxcon	= $098
Intena	= $09A
Intreq	= $09C

;BitPlane Registers 

BplCon0	= $100
BplCon1	= $102
BplCon2	= $104
BplMod1	= $108
BplMod2	= $10a

BplPt0h	= $0e0
BplPt0l	= $0e2
BplPt1h	= $0e4
BplPt1l	= $0e6
BplPt2h	= $0e8
BplPt2l	= $0ea
BplPt3h	= $0ec
BplPt3l	= $0ee
BplPt4h	= $0f0
BplPt4l	= $0f2
BplPt5h	= $0f4
BplPt5l	= $0f6

;Colour Registers

Color00	= $180
Color01	= $182
Color02	= $184
Color03	= $186
Color04	= $188
Color05	= $18a
Color06	= $18c
Color07	= $18e
Color08	= $190
Color09	= $192
Color10	= $194
Color11	= $196
Color12	= $198
Color13 	= $19a
Color14 	= $19c
Color15 	= $19e
Color16 	= $1a0
Color17 	= $1a2
Color18 	= $1a4
Color19 	= $1a6
Color20 	= $1a8
Color21 	= $1aa
Color22 	= $1ac
Color23 	= $1ae
Color24 	= $1b0
Color25 	= $1b2
Color26 	= $1b4
Color27 	= $1b6
Color28 	= $1b8
Color29 	= $1ba
Color30 	= $1bc
Color31 	= $1be

EcsNop	= $1fe
