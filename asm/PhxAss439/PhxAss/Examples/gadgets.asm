**
**	Gadget Example
**

	incdir	"include"
	include	"lib/exec.i"		; library offsets
	include	"lib/intuition.i"
	include	"lib/gadtools.i"

**  You should also define an include path for your Commodore **
** includes or make use of the PHXASSINC environment variable **
	include	"intuition/intuition.i"	; OS includes
	include	"libraries/gadtools.i"
	include "graphics/gfxbase.i"
	include	"graphics/rastport.i"
	include	"graphics/text.i"



	code


start:
	bsr	initialize
	beq	1$			;error during init?
	bsr	main			;main loop
1$:	bsr	cleanup			;free all
	moveq	#0,d0
	rts


main:
	move.l	GadtoolsBase,a6
	move.l	usrport,a0
	jsr	GT_GetIMsg(a6)		;fetch next IDCMP-Message
	tst.l	d0
	bne	2$			;deal with it
	move.l	SysBase,a6
	move.l	usrport,a0		;process sleeps until next
	jsr	WaitPort(a6)		; message arrives
	bra	main

2$:	move.l	d0,a1
	move.l	im_Class(a1),d3		;d2 message's IDCMP-Class
	move.w	im_Code(a1),d2		;d3 IDCMP-Code
	move.l	im_IAddress(a1),a2	;a2 object which generated this msg
	jsr	GT_ReplyIMsg(a6)

	cmp.l	#IDCMP_CLOSEWINDOW,d3	;clicked close gadget?
	beq	1$

3$:	cmp.l	#IDCMP_GADGETUP,d3	;released one of our gadgets?
	bne	4$
	move.w	gg_GadgetID(a2),d0	;gadget Id
	move.l	gg_SpecialInfo(a2),a0	;gadget's SpecialInfo structure
	bsr	do_gadget

4$:	bra	main

; place for extensions

1$:	rts


do_gadget:
; a2 = pointer to Gadget structure
; d0 = Id of selected gadget
; a0 = pointer to gadget's SpecialInfo (for string-, integer gadgets, etc.)
	cmp.w	#MYBUTTONGAD,d0
	bne	1$
; Button gadget was clicked
	move.l	IntBase,a6
	clr.l	-(sp)
	move.l	sp,a2
	move.l	sp,a3
	move.l	winptr,a0
	lea	easyreq_button,a1
	jsr	EasyRequestArgs(a6)
	addq.l	#4,sp
	bra	3$
1$:	cmp.w	#MYCHECKBOX,d0
	bne	2$
; Checkbox gadget was clicked
	move.l	IntBase,a6
	clr.l	-(sp)
	move.l	sp,a2
	move.l	sp,a3
	move.l	winptr,a0
	lea	easyreq_checkbox,a1
	jsr	EasyRequestArgs(a6)
	addq.l	#4,sp
	bra	3$
2$:	cmp.w	#MYINTEGERGAD,d0
	bne	3$			;unknown gadget
; a new value was entered into the Integer gadget
	move.l	IntBase,a6
	move.l	gg_SpecialInfo(a2),a0	;contrains ptr to StringInfo struct
	move.l	si_LongInt(a0),-(sp)	;entered integer value
	move.l	sp,a3			;pass as argument for EasyRequest
	clr.l	-(sp)
	move.l	sp,a2
	move.l	winptr,a0
	lea	easyreq_intgad,a1
	jsr	EasyRequestArgs(a6)
	addq.l	#8,sp
3$:	rts


initialize:
; open all reqiuired libraries, initialize gadgets and
; open a window on the workbench
; -> d0 = TRUE: ok, FALSE: error
	move.l	4,a6
	move.l	a6,SysBase
	lea	intname(pc),a1
	moveq	#36,d0
	jsr	OpenLibrary(a6)		;intuition.library v36
	move.l	d0,IntBase
	beq	1$
	lea	gadtname(pc),a1
	moveq	#36,d0
	jsr	OpenLibrary(a6)		;gadtools.library v36
	move.l	d0,GadtoolsBase
	beq	1$

	lea	gfxname(pc),a1
	moveq	#36,d0			;graphics.library
	jsr	OpenLibrary(a6)
	tst.l	d0
	beq	1$
	move.l	d0,a1
	lea	gadtxtattr,a5		;get default font TxtAttr
	move.l	gb_DefaultFont(a1),a0
	move.l	LN_NAME(a0),ta_Name(a5)
	move.l	tf_YSize(a0),ta_YSize(a5)
	move.w	ta_YSize(a5),d6
	addq.w	#6,d6			;d6 default height for gadgets
	jsr	CloseLibrary(a6)

	move.l	IntBase,a6
	sub.l	a0,a0
	jsr	LockPubScreen(a6)	;lock default public screen
	move.l	d0,pubscreen
	move.l	GadtoolsBase,a6
	move.l	d0,a0
	sub.l	a1,a1
	jsr	GetVisualInfoA(a6)	;get pointer to screen's VisualInfo
	move.l	d0,vinfo
	beq	1$
	move.l	d0,d7			;d7 VisualInfo
	
	lea	glist,a0		;start to create GadTools gadgets
	jsr	CreateContext(a6)
	tst.l	d0
	beq	1$
	move.l	d0,a0
	lea	newbutton,a1
	move.w	d6,gng_Height(a1)
	move.l	d7,gng_VisualInfo(a1)
	move.l	a5,gng_TextAttr(a1)
	sub.l	a2,a2
	moveq	#BUTTON_KIND,d0
	jsr	CreateGadgetA(a6)	;create Button Gadget
	tst.l	d0
	beq	1$
	move.l	d0,a0
	lea	newcheckbox,a1
	move.l	d7,gng_VisualInfo(a1)
	move.l	a5,gng_TextAttr(a1)
	sub.l	a2,a2
	moveq	#CHECKBOX_KIND,d0
	jsr	CreateGadgetA(a6)	;create Checkbox Gadget
	tst.l	d0
	beq	1$
	move.l	d0,a0
	lea	newintgad,a1
	move.w	d6,gng_Height(a1)
	move.l	d7,gng_VisualInfo(a1)
	move.l	a5,gng_TextAttr(a1)
	sub.l	a2,a2
	moveq	#INTEGER_KIND,d0
	jsr	CreateGadgetA(a6)	;create Integer Gadget
	tst.l	d0
	beq	1$

	move.l	IntBase,a6
	lea	mywindow,a0		;open window on public screen
	move.l	glist,nw_FirstGadget(a0)
	jsr	OpenWindow(a6)
	move.l	d0,winptr
	beq	1$
	move.l	d0,a2
	move.l	wd_UserPort(a2),usrport	;pointer to window's IDCMP-MsgPort

	sub.l	a0,a0
	move.l	pubscreen,a1
	jsr	UnlockPubScreen(a6)
	clr.l	pubscreen

	move.l	GadtoolsBase,a6
	move.l	winptr,a0
	sub.l	a1,a1
	jsr	GT_RefreshWindow(a6)

	moveq	#-1,d0			;ok, no problems
1$:	rts


cleanup:
; free all allocated resources
	move.l	IntBase,d0
	beq	1$
	move.l	d0,a6
	move.l	winptr,d0
	beq	6$
	move.l	d0,a0
	jsr	CloseWindow(a6)		;close window
6$:	move.l	pubscreen,d0
	beq	5$
	sub.l	a0,a0
	move.l	d0,a1
	jsr	UnlockPubScreen(a6)

5$:	move.l	GadtoolsBase,d0
	beq	2$
	move.l	d0,a6
	move.l	vinfo,d0
	beq	4$
	move.l	d0,a0
	jsr	FreeVisualInfo(a6)	;free screen's VisualInfo
4$:	move.l	glist,a0
	jsr	FreeGadgets(a6)		;free GadTools gadgets

	move.l	a6,a1
	move.l	SysBase,a6
	jsr	CloseLibrary(a6)	;closse gadtools.library
2$:	move.l	SysBase,a6
	move.l	IntBase,a1
	jsr	CloseLibrary(a6)	;close intuition.library
1$:	rts


intname:
	dc.b	"intuition.library",0
gadtname:
	dc.b	"gadtools.library",0
gfxname:
	dc.b	"graphics.library",0



	data


mywindow:				;refer to: struct NewWindow
	dc.w	16,16,256,128
	dc.b	0,1
; we're waiting for these IDCMP messages
	dc.l	IDCMP_CLOSEWINDOW|IDCMP_GADGETUP
; window flags
	dc.l	WFLG_ACTIVATE|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET
	dc.l	0,0,win_title,0,0
	dc.w	128,32,-1,-1,PUBLICSCREEN
win_title:
	dc.b	"Gadget Example",0
	even

; NewGadget strucures, refer to: libraries/gadtools.i
newbutton:
	dc.w	16,32,80,0
	dc.l	1$,0
	dc.w	MYBUTTONGAD
	dc.l	PLACETEXT_IN,0,0
1$:	dc.b	"Button",0
	even
newcheckbox:
	dc.w	160,32,20,20
	dc.l	1$,0
	dc.w	MYCHECKBOX
	dc.l	PLACETEXT_BELOW,0,0
1$:	dc.b	"Checkbox",0
	even
newintgad:
	dc.w	100,80,128,0
	dc.l	1$,0
	dc.w	MYINTEGERGAD
	dc.l	PLACETEXT_LEFT,0,0
1$:	dc.b	"Number:",0
	even
; Gadget-Ids
MYBUTTONGAD	equ	1
MYCHECKBOX	equ	2
MYINTEGERGAD	equ	3

easyreq_intgad:
	dc.l	EasyStruct_SIZEOF,0,1$,2$,3$
1$:	dc.b	"Integer Gadget",0
2$:	dc.b	"The number %ld\n"
	dc.b	"was just entered.",0
3$:	dc.b	"Indeed",0
	even
easyreq_button:
	dc.l	EasyStruct_SIZEOF,0,1$,2$,3$
1$:	dc.b	"Button Gadget",0
2$:	dc.b	"The button gadget\n"
	dc.b	"was just released.",0
3$:	dc.b	"That's true",0
	even
easyreq_checkbox:
	dc.l	EasyStruct_SIZEOF,0,1$,2$,3$
1$:	dc.b	"Checkbox Gadget",0
2$:	dc.b	"The checkbox gadget\n"
	dc.b	"has been clicked.",0
3$:	dc.b	"Ok",0
	even



	bss


SysBase:	ds.l	1
IntBase:	ds.l	1
GadtoolsBase:	ds.l	1
pubscreen:	ds.l	1		; default public screen
winptr:		ds.l	1
usrport:	ds.l	1
vinfo:		ds.l	1
glist:		ds.l	1		; gadget list
gadtxtattr:	ds.b	ta_SIZEOF 	; TextAttr structure for gadget's font


	end
