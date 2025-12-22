
;---;  scrollbars.r  ;---------------------------------------------------------
*
*	****	GTFACE ADDENDUM FOR H/V SCROLLBARS    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	22.10.94
*	Identifier	scb_defined
*       Prefix		scb_	(Scrollbars)
*				 ¯¯    ¯
*	Functions	InitScrollBars, ResetScrollBars, MakeHScrollBar,
*			MakeVScrollBar, UpdateScrollBar, AskScrollBar,
*			DisposeScrollBar, HandleScrollBar
*
;------------------------------------------------------------------------------


;------------------
	ifnd	scb_defined
scb_defined	=1

;------------------
scb_oldbase	equ __base
	base	scb_base
scb_base:

;------------------
	include	exec/libraries.i
	include	exec/types.i
	include	intuition/imageclass.i
	include	intuition/icclass.i


;------------------------------------------------------------------------------

    STRUCTURE	sck,0
	APTR    sck_SliderObject
	LABEL	sck_LeftObject
	APTR	sck_UpObject
	LABEL	sck_RightObject
	APTR	sck_DownObject

	ULONG	sck_ID
	ULONG	sck_DelayTimeSecs
	ULONG	sck_DelayTimeMicros
	UBYTE	sck_NewScroll
	UBYTE	sck_NewSlide

	ULONG	sck_LastTop
	ULONG	sck_LastVisible
	LABEL   sck_SIZEOF


SCB_ACTION_NONE		equ	0	;take no action
SCB_ACTION_LINE_UP	equ	1	;up/left arrow hit
SCB_ACTION_LINE_LEFT	equ	1
SCB_ACTION_LINE_DOWN	equ	2	;down/right arrow hit
SCB_ACTION_LINE_RIGHT	equ	2
SCB_ACTION_PAGE_UP	equ	3	;slider clicked up/left
SCB_ACTION_PAGE_LEFT	equ	3
SCB_ACTION_PAGE_DOWN	equ	4	;slider clicked down/right
SCB_ACTION_PAGE_RIGHT	equ	4
SCB_ACTION_SLIDE	equ	5	;slider currently sliding
SCB_ACTION_RELEASE	equ	6	;slider released
SCB_ACTION_TOO_FAST	equ	7	;user too fast, slider not moved



;------------------------------------------------------------------------------
*
* InitScrollBars	Prepare for usage of scrollbars on a screen
*
* INPUT:	a0	Screen address.
*
;------------------------------------------------------------------------------
	IFD	xxx_InitScrollBars
InitScrollBars:
;------------------
.start:	movem.l	d1-a6,-(sp)
	lea	scb_base(pc),a4
	move.l	a0,scb_Screen(a4)
	move.l	IntBase(pc),a6
	jsr	_LVOGetScreenDrawInfo(a6)
	move.l	d0,scb_DrawInfo(a4)
	beq	.err1

	moveq	#4+8+8,d0
	lea	scb_MyPrefs(pc),a0
	jsr	_LVOGetPrefs(a6)

	move.l	scb_Screen(pc),a0
	moveq	#SYSISIZE_LOWRES,d0
	move.w	sc_Flags(a0),d1
	and.w	#SCREENHIRES,d1
	beq.s	1$
	moveq	#SYSISIZE_MEDRES,d0
1$:	move.b	d0,scb_SysISize(a4)

	move.l	#$01020302,scb_bw(a4)
	cmp.w	#SYSISIZE_LOWRES,d0
	beq.s	2$
	move.b	#2,scb_bw(a4)
2$:	cmp.w	#SYSISIZE_HIRES,d0
	beq.s	3$
	move.b	#$01,scb_bh(a4)
	move.w	#$0201,scb_rw(a4)

3$:	move.l	scb_DrawInfo(pc),a0
	moveq	#0,d1
	move.l	dri_Flags(a0),d0
	and.l	#DRIF_NEWLOOK,d0
	beq.s	4$
	move.w	dri_Depth(a0),d0
	subq.w	#1,d0
	beq.s	4$
	moveq	#1,d1
4$:	move.l	d1,scb_proptags+4(a4)

	move.l	#SIZEIMAGE,d0
	CALL_	NewImageObject
	move.l	d0,scb_SizeObject(a4)
	beq	.err2
	move.l	#LEFTIMAGE,d0
	CALL_	NewImageObject
	move.l	d0,scb_LeftObject(a4)
	beq.s	.err2
	move.l	#RIGHTIMAGE,d0
	CALL_	NewImageObject
	move.l	d0,scb_RightObject(a4)
	beq.s	.err2
	move.l	#UPIMAGE,d0
	CALL_	NewImageObject
	move.l	d0,scb_UpObject(a4)
	beq.s	.err2
	move.l	#DOWNIMAGE,d0
	CALL_	NewImageObject
	move.l	d0,scb_DownObject(a4)
	beq.s	.err2

	move.l	scb_SizeObject(pc),a0
	move.w	ig_Height(a0),d1
	move.l	scb_LeftObject(pc),a0
	move.w	ig_Height(a0),d0
	cmp.w	d0,d1
	bhs.s	5$
	move.w	d0,d1
5$:	move.l	scb_RightObject(pc),a0
	move.w	ig_Height(a0),d0
	cmp.w	d0,d1
	bhs.s	6$
	move.w	d0,d1
6$:	move.w	d0,scb_gh(a4)

	move.l	scb_SizeObject(pc),a0
	move.w	ig_Width(a0),d1
	move.l	scb_UpObject(pc),a0
	move.w	ig_Width(a0),d0
	cmp.w	d0,d1
	bhs.s	7$
	move.w	d0,d1
7$:	move.l	scb_DownObject(pc),a0
	move.w	ig_Width(a0),d0
	cmp.w	d0,d1
	bhs.s	8$
	move.w	d0,d1
8$:	move.w	d0,scb_gw(a4)

	moveq	#1,d0
	bra.s	.done

.err2:	move.l	scb_Screen(pc),a0
	move.l	scb_DrawInfo(pc),a1
	jsr	_LVOFreeScreenDrawInfo(a6)
.err1:	moveq	#0,d0

.done:	movem.l	(sp)+,d1-a6
	rts

;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* ResetScrollBars	Free scrollbar resources.
*
;------------------------------------------------------------------------------
	IFD	xxx_ResetScrollBars
ResetScrollBars:
;------------------
.start:	movem.l	d0-a6,-(sp)
	move.l	IntBase(pc),a6

	move.l	scb_SizeObject(pc),a0
	jsr	_LVODisposeObject(a6)
	move.l	scb_LeftObject(pc),a0
	jsr	_LVODisposeObject(a6)
	move.l	scb_RightObject(pc),a0
	jsr	_LVODisposeObject(a6)
	move.l	scb_UpObject(pc),a0
	jsr	_LVODisposeObject(a6)
	move.l	scb_DownObject(pc),a0
	jsr	_LVODisposeObject(a6)

	move.l	scb_Screen(pc),a0
	move.l	scb_DrawInfo(pc),a1
	jsr	_LVOFreeScreenDrawInfo(a6)

	movem.l	(sp)+,d0-a6
	rts

;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* MakeHScrollBar	Generate a horizontal Scrollbar.
*
* INPUT:	a0	GTFScrollBar structure.
*		d0	Gadget ID (gadget IDs d0+1 and d0+2 also used!)
*		d1	GA_Top
*		d2	GA_Total
*		d3	GA_Visible
*
* OUTPUT:	d0	First gadget or 0.
;------------------------------------------------------------------------------
	IFD	xxx_MakeHScrollBar
MakeHScrollBar:
;------------------
.start:	movem.l	d1-a6,-(sp)
	CALL_	scb_InitKey
	move.l	d1,.t8+4(a4)
	move.l	d2,.t6+4(a4)
	move.l	d3,.t7+4(a4)
	move.l	d1,sck_LastTop(a0)
	move.l	d3,sck_LastVisible(a0)

	moveq	#1,d0
	add.b	scb_rw(pc),d0
	move.b	d0,.t1+7(a4)

	moveq	#2,d0
	add.b	scb_bh(pc),d0
	sub.w	scb_gh(pc),d0
	ext.l	d0
	move.l	d0,.t2+4(a4)

	moveq	#-1,d0
	sub.b	scb_rw(pc),d0
	sub.b	scb_rw(pc),d0
	sub.w	scb_gw(pc),d0
	move.l	scb_LeftObject(pc),a0
	sub.w	ig_Width(a0),d0	
	move.l	scb_RightObject(pc),a0
	sub.w	ig_Width(a0),d0	
	ext.l	d0
	move.l	d0,.t3+4(a4)

	moveq	#-2,d0
	sub.b	scb_bh(pc),d0
	sub.b	scb_bh(pc),d0
	add.w	scb_gh(pc),d0
	ext.l	d0
	move.l	d0,.t4+4(a4)

	move.l	d7,.t5+4(a4)
	addq.l	#1,d7

	suba.l	a0,a0
	lea	PROPGCLASS,a1
	lea	.hptags(pc),a2
	jsr	_LVONewObjectA(a6)
	move.l	d0,(a3)
	beq	.err1


	
	move.l	d0,.l4+4(a4)
	move.l	scb_LeftObject(pc),.l1+4(a4)
	move.l	d7,.l5+4(a4)
	addq.l	#1,d7

	moveq	#1,d0
	move.l	scb_LeftObject(pc),a0
	sub.w	ig_Width(a0),d0	
	move.l	scb_RightObject(pc),a0
	sub.w	ig_Width(a0),d0	
	sub.w	scb_gw(pc),d0
	ext.l	d0
	move.l	d0,.l2+4(a4)
	
	moveq	#1,d0
	move.l	scb_LeftObject(pc),a0
	sub.w	ig_Height(a0),d0	
	ext.l	d0
	move.l	d0,.l3+4(a4)

	suba.l	a0,a0
	lea	BUTTONGCLASS(pc),a1
	lea	.hbtags(pc),a2
	jsr	_LVONewObjectA(a6)
	move.l	d0,4(a3)
	beq.s	.err2

		
	
	move.l	d0,.l4+4(a4)
	move.l	scb_RightObject(pc),.l1+4(a4)
	move.l	d7,.l5+4(a4)

	moveq	#1,d0
	move.l	scb_RightObject(pc),a0
	sub.w	ig_Width(a0),d0	
	sub.w	scb_gw(pc),d0
	ext.l	d0
	move.l	d0,.l2+4(a4)
	
	moveq	#1,d0
	move.l	scb_RightObject(pc),a0
	sub.w	ig_Height(a0),d0	
	ext.l	d0
	move.l	d0,.l3+4(a4)

	suba.l	a0,a0
	lea	BUTTONGCLASS(pc),a1
	lea	.hbtags(pc),a2
	jsr	_LVONewObjectA(a6)
	move.l	d0,8(a3)
	beq.s	.err2

	move.l	(a3),d0
	bra.s	.done
		
	

.err3:	move.l	4(a3),a0
	jsr	_LVODisposeObject(a6)
.err2:	move.l	(a3),a0
	jsr	_LVODisposeObject(a6)
.err1:	moveq	#0,d0
.done:	movem.l	(sp)+,d1-a6
	rts



.hptags:dc.l	PGA_Freedom,FREEHORIZ
.t1	dc.l	GA_Left,0
.t2	dc.l	GA_RelBottom,0
.t3	dc.l	GA_RelWidth,0
.t4	dc.l	GA_Height,0
	dc.l	GA_BottomBorder,1
.t5	dc.l	GA_ID,0
.t6	dc.l	PGA_Total,10000
.t7	dc.l	PGA_Visible,2500
.t8	dc.l	PGA_Top,5000
	dc.l	TAG_MORE,scb_proptags

.hbtags:
.l1:	dc.l	GA_Image,0
.l2:	dc.l	GA_RelRight,0
.l3:	dc.l	GA_RelBottom,0
	dc.l	GA_BottomBorder,1
.l4:	dc.l	GA_Previous,0
.l5:	dc.l	GA_ID,0
        dc.l	ICA_TARGET,ICTARGET_IDCMP
	dc.l	TAG_DONE

	
;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* MakeVScrollBar	Generate a vertical Scrollbar.
*
* INPUT:	a0	GTFScrollBar structure.
*		d0	Gadget ID (gadget IDs d0+1 and d0+2 also used!)
*		d1	GA_Top
*		d2	GA_Total
*		d3	GA_Visible
*
* OUTPUT:	d0	First gadget or 0.
;------------------------------------------------------------------------------
	IFD	xxx_MakeVScrollBar
MakeVScrollBar:
;------------------
.start:	movem.l	d1-a6,-(sp)
	CALL_	scb_InitKey
	move.l	d1,.t8+4(a4)
	move.l	d2,.t6+4(a4)
	move.l	d3,.t7+4(a4)
	move.l	d1,sck_LastTop(a0)
	move.l	d3,sck_LastVisible(a0)

	move.l	scb_Screen(pc),a0
	move.b	sc_WBorTop(a0),d4
	ext.w	d4
	move.l	sc_Font(a0),a0
	add.w	ta_YSize(a0),d4
	addq.w	#1,d4



	moveq	#0,d0
	move.b	scb_rh(pc),d0
	add.w	d4,d0
	ext.l	d0
	move.l	d0,.t1+4(a4)

	moveq	#3,d0
	add.b	scb_bw(pc),d0
	sub.w	scb_gw(pc),d0
	ext.l	d0
	move.l	d0,.t2+4(a4)

	moveq	#0,d0
	sub.b	scb_rh(pc),d0
	sub.b	scb_rh(pc),d0
	ext.w	d0
	move.l	scb_SizeObject(pc),a0
	sub.w	ig_Height(a0),d0	
	move.l	scb_UpObject(pc),a0
	sub.w	ig_Height(a0),d0	
	move.l	scb_DownObject(pc),a0
	sub.w	ig_Height(a0),d0	
	sub.w	d4,d0
	ext.l	d0
	move.l	d0,.t3+4(a4)

	moveq	#-4,d0
	sub.b	scb_bw(pc),d0
	sub.b	scb_bw(pc),d0
	add.w	scb_gw(pc),d0
	ext.l	d0
	move.l	d0,.t4+4(a4)

	move.l	d7,.t5+4(a4)
	addq.l	#1,d7

	suba.l	a0,a0
	lea	PROPGCLASS,a1
	lea	.vptags(pc),a2
	jsr	_LVONewObjectA(a6)
	move.l	d0,(a3)
	beq	.err1


	
	move.l	d0,.l4+4(a4)
	move.l	scb_UpObject(pc),.l1+4(a4)
	move.l	d7,.l5+4(a4)
	addq.l	#1,d7

	moveq	#1,d0
	move.l	scb_UpObject(pc),a0
	sub.w	ig_Width(a0),d0	
	ext.l	d0
	move.l	d0,.l2+4(a4)
	
	moveq	#1,d0
	move.l	scb_UpObject(pc),a0
	sub.w	ig_Height(a0),d0	
	move.l	scb_DownObject(pc),a0
	sub.w	ig_Height(a0),d0	
	move.l	scb_SizeObject(pc),a0
	sub.w	ig_Height(a0),d0	
	ext.l	d0
	move.l	d0,.l3+4(a4)

	suba.l	a0,a0
	lea	BUTTONGCLASS(pc),a1
	lea	.vbtags(pc),a2
	jsr	_LVONewObjectA(a6)
	move.l	d0,4(a3)
	beq.s	.err2

		
	
	move.l	d0,.l4+4(a4)
	move.l	scb_DownObject(pc),.l1+4(a4)
	move.l	d7,.l5+4(a4)

	moveq	#1,d0
	move.l	scb_DownObject(pc),a0
	sub.w	ig_Width(a0),d0	
	ext.l	d0
	move.l	d0,.l2+4(a4)
	
	moveq	#1,d0
	move.l	scb_DownObject(pc),a0
	sub.w	ig_Height(a0),d0	
	move.l	scb_SizeObject(pc),a0
	sub.w	ig_Height(a0),d0	
	ext.l	d0
	move.l	d0,.l3+4(a4)

	suba.l	a0,a0
	lea	BUTTONGCLASS(pc),a1
	lea	.vbtags(pc),a2
	jsr	_LVONewObjectA(a6)
	move.l	d0,8(a3)
	beq.s	.err2

	move.l	(a3),d0
	bra.s	.done
		
	

.err3:	move.l	4(a3),a0
	jsr	_LVODisposeObject(a6)
.err2:	move.l	(a3),a0
	jsr	_LVODisposeObject(a6)
.err1:	moveq	#0,d0
.done:	movem.l	(sp)+,d1-a6
	rts



.vptags:dc.l	PGA_Freedom,FREEVERT
.t1	dc.l	GA_Top,0
.t2	dc.l	GA_RelRight,0
.t3	dc.l	GA_RelHeight,0
.t4	dc.l	GA_Width,0
	dc.l	GA_RightBorder,1
.t5	dc.l	GA_ID,0
.t6	dc.l	PGA_Total,10000
.t7	dc.l	PGA_Visible,2500
.t8	dc.l	PGA_Top,2500
	dc.l	TAG_MORE,scb_proptags

.vbtags:
.l1:	dc.l	GA_Image,0
.l2:	dc.l	GA_RelRight,0
.l3:	dc.l	GA_RelBottom,0
	dc.l	GA_RightBorder,1
.l4:	dc.l	GA_Previous,0
.l5:	dc.l	GA_ID,0
        dc.l	ICA_TARGET,ICTARGET_IDCMP
	dc.l	TAG_DONE

	
;------------------
	ENDIF


	IFD	xxx_scb_InitKey
scb_InitKey:
;------------------
	lea	scb_base(pc),a4
	move.l	IntBase(pc),a6
	move.l	d0,d7
	move.l	a0,a3
	move.l	d0,sck_ID(a3)
	clr.l	sck_DelayTimeSecs(a3)
	clr.l	sck_DelayTimeMicros(a3)
	clr.w	sck_NewScroll(a3)
	rts


;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* DisposeScrollBar	Free a scrollbar.
*
* INPUT:	a0	GTFScrollBar structure.
;------------------------------------------------------------------------------
	IFD	xxx_DisposeScrollBar
DisposeScrollBar:
;------------------
.start:	movem.l	d0-a6,-(sp)
	move.l	a0,a3
	move.l	IntBase(pc),a6

	move.l	8(a3),a0
	jsr	_LVODisposeObject(a6)
	move.l	4(a3),a0
	jsr	_LVODisposeObject(a6)
	move.l	(a3),a0
	jsr	_LVODisposeObject(a6)

	movem.l	(sp)+,d0-a6
	rts
	
;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* HandleScrollBar	Deal with events from a scrollbar. Does repeat
*			delay for arrows.
*
* INPUT:	a0	GTFScrollBar structure.
*		a2	WindowKey.
*
* OUTPUT:	d0	Action to take, SCB_ACTION_*.
*		d1	Absolute value for SCB_ACTION_SLIDE and SCB_ACTION_RELEASE
*			or count for SCB_ACTION_PAGE_*.
;------------------------------------------------------------------------------
	IFD	xxx_HandleScrollBar
HandleScrollBar:
;------------------
.start:	movem.l	d2-a6,-(sp)

	move.l	a0,a5
	move.l	#GA_ID,d0
	move.l	gfw_msgaddr(a2),a0
	moveq	#0,d1
	move.l	UtilBase(pc),a6
	jsr	_LVOGetTagData(a6)

	move.w	gfw_msgqualifier(a2),d3
	sub.l	sck_ID(a5),d0
	beq	.scroll
	subq.l	#1,d0
	beq.s	.left
	subq.l	#1,d0
	beq.s	.right

.none:	moveq	#SCB_ACTION_NONE,d4
.done:	move.l	d4,d0
	movem.l	(sp)+,d2-a6
	rts


.left:	moveq	#SCB_ACTION_LINE_UP,d4
	bra.s	.both

.right:	moveq	#SCB_ACTION_LINE_DOWN,d4

.both:	tst.b	sck_NewScroll(a5)
	bne.s	.nodel
	move.l	gfw_msgseconds(a2),d0
	move.l	gfw_msgmicros(a2),d1
	add.l	scb_RepDelay+4(pc),d1
	cmp.l	#999999,d1
	bls.s	.nover
	sub.l	#1000000,d1
	addq.l	#1,d0
.nover:	add.l	scb_RepDelay(pc),d0
	move.l	d0,sck_DelayTimeSecs(a5)
	move.l	d1,sck_DelayTimeMicros(a5)
	st.b	sck_NewScroll(a5)

.nodel:	tst.w	d3
	bne.s	.nol1
	clr.b	sck_NewScroll(a5)	
	bra.s	.done
.nol1:	move.l	gfw_msgseconds(a2),d0
	cmp.l	sck_DelayTimeSecs(a5),d0
	bhi.s	.done
	blo.s	.none
	move.l	gfw_msgmicros(a2),d0
	cmp.l	sck_DelayTimeMicros(a5),d0
	blo.s	.none
	bra.s	.done

.scroll:
	move.l	a5,a0
	CALL_	AskScrollBar
	move.l	d0,d1
	tst.w	d3
	beq.s	.nod2
	st.b	sck_NewSlide(a5)	
	moveq	#SCB_ACTION_SLIDE,d4
	bra	.done

.sla:	clr.b	sck_NewSlide(a5)
	moveq	#SCB_ACTION_RELEASE,d4
	bra	.done

.nod2:	tst.b	sck_NewSlide(a5)
	bne.s	.sla
	clr.b	sck_NewSlide(a5)
	move.l	sck_LastTop(a5),d0
	move.l	d1,sck_LastTop(a5)
	cmp.l	d0,d1
	beq	.over
	blt.s	.pup

.pdown:	moveq	#SCB_ACTION_PAGE_DOWN,d4
	exg	d1,d0
	bra.s	.cntp
.pup:	moveq	#SCB_ACTION_PAGE_UP,d4
.cntp:	sub.l	d1,d0
	move.l	sck_LastVisible(a5),d2
	moveq	#1,d1
.cntpl:	cmp.l	d2,d0
	ble	.done
	sub.l	d2,d0
	addq.l	#1,d1
	bra	.cntpl

.over:	moveq	#SCB_ACTION_TOO_FAST,d4
	bra	.done


;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* AskScrollBar	Get scrollbar position.
*
* INPUT:	a0	GTFScrollBar structure.
*
* OUTPUT:	d0	PGA_Top.
;------------------------------------------------------------------------------
	IFD	xxx_AskScrollBar
AskScrollBar:
;------------------
.start:	movem.l	d0-a6,-(sp)
	
	move.l	#PGA_Top,d0
	move.l	(a0),a0
	lea	(sp),a1
	move.l	IntBase(pc),a6
	jsr	_LVOGetAttr(a6)

	movem.l	(sp)+,d0-a6
	rts

;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* UpdateScrollBar	Update a scrollbar.
*
* INPUT:	a0	GTFScrollBar structure.
*		a1	Window.
*		d0	GA_Top
*		d1	GA_Total
*		d2	GA_Visible
;------------------------------------------------------------------------------
	IFD	xxx_UpdateScrollBar
UpdateScrollBar:
;------------------
.start:	movem.l	d0-a6,-(sp)
	move.l	d0,sck_LastTop(a0)
	move.l	d2,sck_LastVisible(a0)
	move.l	(a0),a0
	move.l	a0,d7
	move.l	a1,d6

	lea	.tags,a1
	move.l	d0,4(a1)
	move.l	d1,12(a1)
	move.l	d2,20(a1)
	move.l	IntBase(pc),a6
	jsr	_LVOSetAttrsA(a6)

	move.l	d7,a0
	move.l	d6,a1
	suba.l	a2,a2
	moveq	#1,d0
	jsr	_LVORefreshGList(a6)

	movem.l	(sp)+,d0-a6
	rts

.tags:	dc.l	PGA_Top,0
	dc.l	PGA_Total,0
	dc.l	PGA_Visible,0
	dc.l	TAG_DONE

;------------------
	ENDIF



;------------------------------------------------------------------------------
*
* Subroutines
*
;------------------------------------------------------------------------------

*
* d0=NewImageObject(which)(d0)
*
	IFD	xxx_NewImageObject
NewImageObject:
;------------------
.start:	movem.l	d1-a6,-(sp)
	suba.l	a0,a0
	lea	SYSICLASS(pc),a1
	lea	.tags(pc),a2
	move.l	scb_DrawInfo,4(a2)
	move.l	d0,12(a2)
	move.b	scb_SysISize(pc),20+3(a2)
	move.l	IntBase(pc),a6
	jsr	_LVONewObjectA(a6)	
	movem.l	(sp)+,d1-a6
	rts

.tags:	dc.l	SYSIA_DrawInfo,0
	dc.l	SYSIA_Which,0
	dc.l	SYSIA_Size,0
	dc.l	TAG_DONE

;------------------
	ENDIF


	IFD	xxx_CalcHScrollGfx
CalcHScrollGfx:
;------------------
.start:	movem.l	d0-a6,-(sp)
	
	movem.l	(sp)+,d0-a6
	rts

;------------------
	ENDIF



;--------------------------------------------------------------------

;------------------
scb_Screen:	dc.l	0
scb_SysISize:	dc.b	0
		dc.b	0
scb_DrawInfo:	dc.l	0

scb_SizeObject:	dc.l	0
scb_LeftObject:	dc.l	0
scb_RightObject:dc.l	0
scb_UpObject:	dc.l	0
scb_DownObject:	dc.l	0

scb_bw:		dc.b	0	;\
scb_bh:		dc.b	0	; |
scb_rw:		dc.b	0	; |
scb_rh:		dc.b	0	;/

scb_gw:		dc.w	0
scb_gh:		dc.w	0

scb_MyPrefs:	dc.l	0
		dc.l	0,0
scb_RepDelay:	dc.l	0,0

scb_proptags:	dc.l	PGA_Borderless,0		;must be first!
		dc.l	ICA_TARGET,ICTARGET_IDCMP
		dc.l	PGA_NewLook,1
		dc.l	TAG_DONE

PROPGCLASS:	dc.b	"propgclass",0
BUTTONGCLASS:	dc.b	"buttongclass",0
SYSICLASS:	dc.b	"sysiclass",0
		even

;------------------

;--------------------------------------------------------------------

;------------------
	base	scb_oldbase

;------------------
	endif
	end

