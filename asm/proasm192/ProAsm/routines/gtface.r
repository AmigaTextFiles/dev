
;---;  gtface.r  ;-------------------------------------------------------------
*
*	****	WINDOW HANDLING AND GADTOOLS INTERFACE ROUTINES    ****
*
*	Author		Stefan Walter
*	Version		1.09c
*	Last Revision	04.12.96
*	Identifier	gtf_defined
*	Prefix		gtf_	(GadToolsFace)
*				 ¯  ¯    ¯
*	Functions	InitGTFace, ResetGTFace, SetZoomDimensionsLast
*			SetZoomDimensions, OpenScaledWindowLast
*			OpenScaledWindow, CloseScaledWindow
*			CreateGList, FreeGList, AddGList, RemGList
*			RefreshWindow, WaitForWindow, GetGTFMsg
*			RefreshEventHandler, FindGadget, FindGadgetInKey
*			SetZoomTitleBar, OpenUnScaledWindow
*			PrintScaled, PrintScaledList
*			AddMenu, RemMenu, GenMenu, FreeMenu, SetMenu, StripMenu
*			CallGadget, CallMenu, CallKey, UnLockPubScreen
*			WaitForWindowAndSignals, LockPubScreen
*
*	(PubScreen)	OpenScaledWindowPub,OpenScaledWindowLastPub
*			SetZoomTitleBarPub
*
*	Flags		gtf_pubscreenfallback	(0: off, -:on)
*
;------------------------------------------------------------------------------

;------------------
	ifnd	gtf_defined
gtf_defined	=1

;------------------
gtf_oldbase	equ __base
	base	gtf_base
gtf_base:

;------------------
; Some macros.
;
	include	tasktricks.r
	include	gtfdefs.r
	include	basicmac.r

;------------------
; Either let the startup do the library stuff or open it ourselves...
;
	IFD	ely_defined

	IFND	GRAPHICS.LIB
	FAIL	graphics.library needed for GTFace: GRAPHICS.LIB SET 1
	ENDIF
	IFND	INTUITION.LIB
	FAIL	intuition.library needed for GTFace: INTUITION.LIB SET 1
	ENDIF
	IFND	GADTOOLS.LIB
	FAIL	gadtools.library needed for GTFace: GADTOOLS.LIB SET 1
	ENDIF

gtf_gfxbase		EQU	GfxBase
gtf_intbase		EQU	IntBase
gtf_gadtoolsbase	EQU	GadToolsBase

	ELSE

gtf_gfxbase	EQU	glb_gfxbase
gtf_intbase	EQU	ilb_intbase
	ENDIF	

;------------------
	IFND	USE_NEWROUTINES
	WARN	You aren't using USE_NEWROUTINES, this is not efficient!
	NEED_	InitGTFace		
	NEED_	ResetGTFace		
	NEED_	OpenScaledWindow	
	NEED_	CloseScaledWindow	
	NEED_	CreateGList		
	NEED_	FreeGList		
	NEED_	AddGList		
	NEED_	RemGList		
	NEED_	RefreshWindow	
	NEED_	WaitForWindow	
	NEED_	GetGTFMsg		
	NEED_	RefreshEventHandler	
	NEED_	FindGadget		
	NEED_	AddMenu		
	NEED_	RemMenu		
	NEED_	CallGadget		
	NEED_	CallKey		
	NEED_	CallMenu		
	NEED_	ClearWindow		
	NEED_	PrintScaled		
	NEED_	PaintObjects	
	NEED_	LockWindow		
	NEED_	UnLockWindow	
	NEED_	gtf_doidcmp		
	NEED_	gtf_rectfill	
	NEED_	RemoveLVLabels	

	ENDIF

;------------------




;------------------------------------------------------------------------------
*
* InitGTFace	Prepare for GTFace actions. Open libs, find and lock the
*		system default font and get the pattern.
*
* RESULT:	d0	Default font or 0.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_InitGTFace
InitGTFace:
	NEED_	ResetGTFace

;------------------
; Open all needed libraries if no EasyLibraryHandler used.
;
\start:	movem.l	d1-a6,-(sp)
	lea	gtf_base(pc),a5

	IFND	ely_defined	
	bsr	OpenIntuitionLib
	beq	gtf_f1

	lea	gtf_gadtoolsname(pc),a1
	move.l	4.w,a6
	jsr	-408(a6)
	move.l	d0,gtf_gadtoolsbase(a5)
	beq	gtf_f2

	bsr	OpenGraphicsLib
	beq	gtf_f3
	ELSE
	move.l	gtf_gfxbase(pc),a6
	ENDIF

;------------------
; Get topaz80 font. We need that one if the default font can't be used.
;
\gettopaz:
	lea	gtf_topazattr(pc),a0
	lea	gtf_topazname(pc),a1
	move.l	a1,(a0)
	jsr	-72(a6)			;OpenFont
	move.l	d0,gtf_topazfont(a5)
	beq	gtf_f4

;------------------
; Get default font. Increase the accessor counter to ensure that noone
; takes that font from ous! Then init the TextAttr structure for it.
;
\font:	move.l	gtf_gfxbase(pc),a6
	Forbid_
	move.l	154(a6),a4		;gb_DefaultFont
	addq.w	#1,30(a4)		;tf_Accessors
	Permit_
	move.l	a4,gtf_defaultfont(a5)
	move.l	10(a4),gtf_defaultattr(a5)
	move.l	20(a4),gtf_defaultattr+4(a5)

;------------------
; Allocate space for pattern.
;
\alp:	moveq	#2,d0
	moveq	#3,d1
	move.l	4.w,a6
	jsr	-198(a6)
	move.l	d0,gtf_pattern(a5)
	beq.s	gtf_f5
	move.l	d0,a0
	move.w	#$aaaa,(a0)

	st.b	gtf_status(a5)		;set up!
	move.l	a4,d0			;return font
	movem.l	(sp)+,d1-a6
	rts

	ENDIF
;------------------




;------------------------------------------------------------------------------
*
* ResetGTFace	Free font and close libraries.
*
* RESULT:	d0	0
*
;------------------------------------------------------------------------------

;------------------
	IFD	xxx_ResetGTFace
ResetGTFace:

;------------------
; Free all:
;
\start:	movem.l	d1-a6,-(sp)
	move.b	gtf_status(pc),d0	;already reset?
	beq.s	gtf_f1
	move.l	4.w,a6
	moveq	#2,d0
	move.l	gtf_pattern(pc),a1
	jsr	-210(a6)		;FreeMem()

gtf_f5:	move.l	gtf_gfxbase(pc),a6
	move.l	gtf_defaultfont(pc),a1
	jsr	-78(a6)			;CloseFont()
	move.l	gtf_topazfont(pc),a1
	jsr	-78(a6)			;CloseFont()

gtf_f4:	IFND	ely_defined
	bsr	CloseGraphicsLib

gtf_f3:	move.l	4.w,a6
	move.l	gtf_gadtoolsbase(pc),a1
	jsr	-414(a6)		;CloseLibrary()

gtf_f2:	bsr	CloseIntuitionLib
	ENDIF

gtf_f1:	lea	gtf_status(pc),a0
	clr.b	(a0)			;status!
	moveq	#0,d0
	movem.l	(sp)+,d1-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* SetZoomDimensionsLast	Set the dimensions of the window when zoomed.
*			Use the same dimensions as when the window was
*			closed last time.
*
* INPUT:	a1	Tags for later OpenWindowScaled.
*		a2	Empty WindowKey structure.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_SetZoomDimensionsLast
SetZoomDimensionsLast:

;------------------
; Do.
;
\lock: 	movem.l	d0-d3,-(sp)
	movem.w	gfw_zoomxpos(a2),d0-d3
	CALL_	SetZoomDimensions
	movem.l	(sp)+,d0-d3
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* SetZoomTitleBarPub	(PubScreen only!)
* SetZoomTitleBar	Set the zoom dimensions such that the window
*			will be only a title bar and that the title
*			string will fully fit.
*
* INPUT:	d0	XPos.
*		d1	YPos.
*		a0	NewWindowStruct for later OpenWindowScaled
*		a1	Tags for later OpenWindowScaled.
*		a2	Empty WindowKey structure.
*		(a3 	PubScreenName, only for *Pub variant)
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_SetZoomTitleBar
SetZoomTitleBarPub:
	move.l	a3,gtf_pubscreenname
	CALL_	SetZoomTitleBar
	bne.s	1$
	tst.b	gtf_pubscreenfallback
	beq.s	1$
	CALL_	SetZoomTitleBar
1$:	rts
	ENDIF
	
;------------------
	IFD	xxx_SetZoomTitleBar
SetZoomTitleBar:

;------------------
; Do.
;
\lock: 	movem.l	d0-d3/a0-a3,-(sp)
	lea	gfw_zoomxpos(a2),a3
	move.l	a3,8*2+4(a1)
	move.w	d0,(a3)
	move.w	d1,gfw_zoomypos(a2)
	CALL_	LockPubScreen
	beq.s	\done
	move.l	d0,a3
	moveq	#0,d0
	move.b	$1e(a3),d0		;bar heigth...
	add.b	$1f(a3),d0		;plus bar border... ???
	move.w	d0,gfw_zoomheigth(a2)
	lea	$54(a3),a1		;RP
	move.l	$1a(a0),a0		;string
	move.l	a0,a3
	moveq	#-1,d0
\loop:	addq.l	#1,d0
	tst.b	(a3)+
	bne.s	\loop
	move.l	gtf_gfxbase(pc),a6
	jsr	-54(a6)			;TextLength()
	add.w	#46+18+2+(20),d0		;magic number for gadgets!
	move.w	d0,gfw_zoomwidth(a2)
\done:	movem.l	(sp)+,d0-d3/a0-a3
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* SetZoomDimensions	Set the dimensions of the window when zoomed.
*			The sizes given are *NOT* scaled. This function
*			must be called *BEFORE* the window is opened.
*
* INPUT:	d0	XPos.
*		d1	YPos.
*		d2	Width (outer!).
*		d3	Heigth (outer!).
*		a1	Tags for later OpenWindowScaled.
*		a2	Empty WindowKey structure.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_SetZoomDimensions
SetZoomDimensions:

;------------------
; Do.
;
\lock: 	pea	(a0)
	lea	gfw_zoomheigth+2(a2),a0
	movem.w	d0-d3,-(a0)
	cmp.l	#WA_Zoom,2*8(a1)
	bne.s	1$
	move.l	a0,2*8+4(a1)		;set WA_Zoom!
1$:	cmp.l	#WA_Zoom,3*8(a1)
	bne.s	2$
	move.l	a0,3*8+4(a1)		;set WA_Zoom!
2$:	move.l	(sp)+,a0
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* OpenScaledWindowLastPub
* OpenScaledWindowLast	Opens a window again at the same position and
*			with the same size it was closed.
*			the same zoomed size. The tag WA_Zoom must be on
*			third position in the tag list.
*
* INPUT:	a0	NewWindow structure.
*		a1	Tags, at least the three mentioned above.
*		a2	Already used WindowKey structure.
*		(a3 	PubScreenName, only for *Pub variant)
*
* RESULT:	d0	Window or 0.
*		a2	Filled WindowKey structure.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_OpenScaledWindowLast
OpenScaledWindowLast:

;------------------
; Remember old arguments from NewWindow structure and do...
;
\do:	move.l	(a0),-(sp)		;remember old x/y
	move.l	4(a0),-(sp)		;and w/h
	move.l	gfw_winxpos(a2),(a0)
	move.l	gfw_winiwidth(a2),4(a0)
	st.b	gfw_noscale(a2)		;inner size scaled!!!
	CALL_	OpenScaledWindow
	move.l	(sp)+,4(a0)
	move.l	(sp)+,(a0)
	tst.l	d0
	bne.s	\fine
	CALL_	OpenScaledWindow	;try again!
\fine:	rts

	ENDIF
;------------------



;------------------
	IFD	xxx_OpenScaledWindowLastPub
OpenScaledWindowLastPub:

;------------------
; Remember old arguments from NewWindow structure and do...
;
\do:	move.l	(a0),-(sp)		;remember old x/y
	move.l	4(a0),-(sp)		;and w/h
	move.l	gfw_winxpos(a2),(a0)
	move.l	gfw_winiwidth(a2),4(a0)
	st.b	gfw_noscale(a2)		;inner size scaled!!!
	CALL_	OpenScaledWindowPub
	move.l	(sp)+,4(a0)
	move.l	(sp)+,(a0)
	tst.l	d0
	bne.s	\fine
	CALL_	OpenScaledWindowPub	;try again!
\fine:	rts

	ENDIF
;------------------



;--------------------------------------------------------------------
*
* OpenScaledWindowPub
* OpenScaledWindow	Open a window. The window will be opened with
*			an inner size that is scaled for use of the
*			system default font. The size used for topaz80
*			is stored in the NewWindow structure. The first
*			two tags you provide must be WA_InnerWidth and
*			WA_InnerHeigth. Min/Max values will also be
*			scaled and must be given for the enterior size!
*
* OpenUnScaledWindow	Open a window without scaling, but still in
*			GTFace manner. The first two tags must be WA_Width
*			and WA_Height.
*
* INPUT:	a0	NewWindow structure.
*		a1	Tags, at least the two mentioned above.
*		a2	Empty WindowKey structure.
*		(a3 	PubScreenName, only for *Pub variant)
*
* RESULT:	d0	Window or 0.
*		a2	Filled WindowKey structure.
*		ccr	On d0.
*
;--------------------------------------------------------------------
* INTERNAL NOTE:
*
* This routine contains the neccessary hacks to best get around C='s problems
* with opening a window. 3.0 always has a zoom gadget which zooms to the
* minimal size specified when opening the window. At this point it is not
* possible to calculate border sizes 100%, i.e. the width of size gadget
* cannot be calculated. Therefore the maximal and minimal size is still
* set with WindowLimits() after the window is opened, but the min/max sizes
* are preset to some relatively good values before the window openes. 
*
* If C= tells about some bugfixes and official ways around these problems,
* this routine may has to be changed.
;--------------------------------------------------------------------

;------------------
	IFD	xxx_OpenScaledWindowPub
OpenScaledWindowPub:
	move.l	a3,gtf_pubscreenname
	CALL_	OpenScaledWindow
	bne.s	1$
	tst.b	gtf_pubscreenfallback
	beq.s	1$
	CALL_	OpenScaledWindow
1$:	rts
	ENDIF

	
;------------------
	IFD	xxx_OpenUnScaledWindow
	NEED_	OpenScaledWindow	
OpenUnScaledWindow:
	st.b	gfw_noscale(a2)
	st.b	gtf_nolimscale
	ENDIF
	IFD	xxx_OpenScaledWindow
OpenScaledWindow:

;------------------
; Lock screen while we get the window up.
;
\start: movem.l	d1-a6,-(sp)
	move.l	a0,d6
	move.l	a1,d5
	move.l	a2,a4
	move.l	gtf_intbase(pc),a6

	lea	gtf_minmax(pc),a3
	move.l	$26(a0),(a3)+		;backup true min/max values!
	move.l	$2a(a0),(a3)

	CALL_	LockPubScreen
	beq	\fail

	move.l	gtf_screen(pc),d0
	cmp.l	#WA_PubScreen,2*8(a1)
	bne.s	..1
	move.l	d0,2*8+4(a1)
..1:	cmp.l	#WA_PubScreen,3*8(a1)
	bne.s	..2
	move.l	d0,3*8+4(a1)
..2:


;------------------
; Calculate border sizes for future window.
;
\calc:	move.l	gtf_screen(pc),a2
	moveq	#0,d4
	moveq	#0,d3
	move.b	$24(a2),d4		;left
	add.b	$25(a2),d4

	move.b	$23(a2),d3		;top
	addq.w	#1,d3			;+1	????
	move.l	$28(a2),a0
	add.w	4(a0),d3		;font heigth
	add.b	$26(a2),d3		;and bottom bar

;------------------
; Test if window will fit screen when opened for default font.
;
\try:	move.l	gtf_defaultfont(pc),a3
	cmp.w	#7,24(a3)		;width limited to 7
	blt	\uset8
	cmp.w	#8,20(a3)		;heigth to 8
	blt	\uset8

	bsr	\calib
	move.w	$c(a2),d0		;screen width...
	sub.w	d4,d0			;- borders 
	cmp.w	6(a1),d0
	blt	\uset8

	move.w	$e(a2),d0		;screen heigth...
	sub.w	d3,d0			;- borders
	cmp.w	6+8(a1),d0
	blt	\uset8
	bra	\open
	
;------------------
; Calibrate window size. Set the WA_InnerWidth and WA_InnerHeigth
; Tags and the min/max sizes!
;
\calib:	move.l	d6,a0
	move.l	d5,a1
	move.w	24(a3),gfw_fontx(a4)
	move.w	20(a3),gfw_fonty(a4)

	moveq	#0,d0
	move.w	4(a0),d0
	move.b	gfw_noscale(a4),d2
	bne.s	111$
	mulu	24(a3),d0		;multiply with font x size
	addq.l	#7,d0
	lsr.l	#3,d0
111$	move.l	d0,4(a1)		;inner width
	move.w	d0,gfw_winiwidth(a4)
	move.w	6(a0),d0
	tst.b	d2
	bne.s	222$
	mulu	20(a3),d0		;multiply with font y size
	addq.l	#7,d0
	lsr.l	#3,d0
222$	move.l	d0,4+8(a1)		;inner height
	move.w	d0,gfw_winiheigth(a4)

	moveq	#-1,d2
	move.b	gtf_nolimscale(pc),d0
	bne.s	\nolsc

\maxy:	move.w	gtf_minmax+6(pc),d0
	cmp.w	d0,d2
	beq.s	\maxx
	CALL_	gtf_scaled0y
	add.w	d3,d0
	move.w	d0,$2c(a0)
	
\maxx:	move.w	gtf_minmax+4(pc),d0
	cmp.w	d0,d2
	beq.s	\miny
	CALL_	gtf_scaled0x
	add.w	d4,d0
	move.w	d0,$2a(a0)

\miny:	moveq	#1,d0
	move.w	gtf_minmax+2(pc),d1
	cmp.w	d1,d2
	beq.s	\minx
	move.w	d1,d0
	CALL_	gtf_scaled0y
	add.w	d3,d0

\minx:	move.w	d0,$28(a0)
	moveq	#16,d0
	move.w	gtf_minmax+2(pc),d1
	cmp.w	d1,d2
	beq.s	\setmm
	move.w	d1,d0
	CALL_	gtf_scaled0x
	add.w	d4,d0

\setmm:	move.w	d0,$26(a0)
\nolsc:	rts

;------------------
; Open Window. First try default font, then topaz80.
;
\open:	move.l	gtf_defaultfont(pc),a3
	lea	gtf_defaultattr(pc),a5
	bsr	\calib
	jsr	-606(a6)		;OpenWindowTagList()
	move.l	d0,d7
	bne.s	\set

\uset8:	move.l	gtf_topazfont(pc),a3
	lea	gtf_topazattr(pc),a5
	bsr	\calib
	jsr	-606(a6)		;OpenWindowTagList()
	move.l	d0,d7
	beq	\fail2
		
\set:	move.l	d7,a1
	move.l	4(a1),gfw_winxpos(a4)
	move.l	8(a1),gfw_winwidth(a4)
	move.l	50(a1),a1		;RasterPort
	move.l	a3,a0
	move.l	gtf_gfxbase(pc),a6
	jsr	-66(a6)			;SetFont()

	move.l	gtf_gadtoolsbase(pc),a6
	move.l	d7,a2
	move.l	$2e(a2),a0		;screen
	suba.l	a1,a1			;no tags
	jsr	-126(a6)		;GetVisualInfoA()
	move.l	d0,gfw_visualinfo(a4)
	beq	\fail3

	
;------------------
; Init rest of WindowKey.
;
\ikey:	move.l	d7,gfw_window(a4)
	move.l	a3,gfw_font(a4)
	move.l	a5,gfw_textattr(a4)
	
	lea	gfw_glists(a4),a0
	move.l	a0,8(a0)		;init 'gadget list' list!
	addq.l	#4,a0
	clr.l	(a0)
	move.l	a0,-4(a0)

;------------------
; Set new max and min size.
;
\lim:	lea	gtf_minmax+8(pc),a1
	move.l	d7,a0
	lea	$36(a0),a2

	moveq	#0,d4
	moveq	#0,d5
	move.b	(a2)+,d4
	move.w	d4,gfw_lefto(a4)
	move.b	(a2)+,d5
	move.w	d5,gfw_topo(a4)
	add.b	(a2)+,d4
	add.b	(a2)+,d5
	move.w	d4,gfw_horbd(a4)
	move.w	d5,gfw_vertbd(a4)

	move.l	d6,-(sp)
	move.l	d6,a2
	move.l	10(a2),gfw_idcmp(a4)	;remember needed IDCMP
	btst	#2,16(a2)		;G00 window?
	beq.s	\nog00
	clr.l	gfw_lefto(a4)

\nog00:	moveq	#-1,d6

\maxy2:	move.w	-(a1),d0
	move.w	d0,d3
	cmp.w	d6,d0
	beq.s	\maxx2
	CALL_	gtf_scaled0y
	move.w	d0,d3
	add.w	d5,d3

\maxx2:	move.w	-(a1),d0
	move.w	d0,d2
	cmp.w	d6,d0
	beq.s	\minx2
	CALL_	gtf_scaled0x
	move.w	d0,d2
	add.w	d4,d2

\minx2:	moveq	#1,d0
	cmp.w	-(a1),d6
	beq.s	\miny2
	move.w	(a1),d0
	CALL_	gtf_scaled0y
	add.w	d5,d0

\miny2:	move.w	d0,d1
	moveq	#16,d0
	cmp.w	-(a1),d6
	beq.s	\setmm2
	move.w	(a1),d0
	CALL_	gtf_scaled0x
	add.w	d4,d0

\setmm2:move.l	gtf_intbase(pc),a6
	jsr	-318(a6)		;WindowLimits()
	move.l	(sp)+,d6

;------------------
; Unlock screen.
;
\un:	move.l	gtf_screen(pc),a1
	suba.l	a0,a0
	move.l	gtf_intbase(pc),a6
	jsr	-516(a6)		;UnLockPubScreen()
	lea	gtf_locked(pc),a0
	clr.b	(a0)

\exit:	move.l	d6,a2
	move.l	gtf_minmax(pc),$26(a2)
	move.l	gtf_minmax+4(pc),$26+4(a2)
	clr.b	gfw_noscale(a4)		;scaling allowed!
	move.l	d7,d0
	movem.l	(sp)+,d1-a6
	rts

;------------------
; Failures.
;
\fail3:	move.l	gfw_window(a4),a0
	move.l	gtf_intbase(pc),a6
	jsr	-72(a6)			;CloseWindow

\fail2:	move.l	gtf_screen(pc),a1
	suba.l	a0,a0
	jsr	-516(a6)		;UnLockPubScreen()
	lea	gtf_locked(pc),a0
	clr.b	(a0)

\fail:	moveq	#0,d7
	bra.s	\exit

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* CloseScaledWindow	Close the window again.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_CloseScaledWindow
CloseScaledWindow

;------------------
; Close.
;
\start:	movem.l	d0-a6,-(sp)
	move.l	gfw_window(a2),d0
	beq.s	\done
	move.l	d0,a0
	clr.l	gfw_window(a2)		;closed!
	clr.b	gfw_domenu(a2)		;for CallMenu()

	move.l	gfw_visualinfo(a2),d7

	move.l	gtf_intbase(pc),a6
	jsr	-72(a6)			;CloseWindow

	move.l	d7,a0
	move.l	gtf_gadtoolsbase(pc),a6
	jsr	-132(a6)		;FreeVisualInfo()

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* CreateGList	Create a gadget list from a GTFace info structure.
*
* INPUT:	a0	GTFace gadget structure.
*		a1	Empty GadgetKey structure.
*		a2	WindowKey of window these gadgets are rendered for.
*
* RESULT:	d0	Gadget list or 0.
*		a1	GadgetKey.
*		a2	WindowKey.
*		d0	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_CreateGList
CreateGList:
	NEED_	gtf_newgadget
	NEED_	gtf_tagspace

;------------------
; Shuffle some registers.
;
\init:	movem.l	d1-a6,-(a7)
	move.l	a2,a4
	move.l	a1,a5
	move.l	a0,a3
	moveq	#0,d5			;default is error

;------------------
; Create context.
;
\dogts:	move.l	gtf_gadtoolsbase(pc),a6
	lea	gfg_gadgets(a5),a0
	clr.l	(a0)
	jsr	-114(a6)		;CreateContext()
	lea	gtf_prev(pc),a0
	move.l	d0,(a0)
	beq	\done

;------------------
; Allocate table.
;
\atab:	move.l	(a3)+,d0
	move.l	(a3)+,gfg_idcmp(a5)
	clr.l	gfg_numof(a5)
	clr.l	gfg_objects(a5)
	clr.l	gfg_remkey(a5)
	move.l	d0,gfg_gnumof(a5)
	lsl.l	#2,d0
	addq.l	#4,d0			;to prevent 0 size allocs!
	moveq	#1,d1
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	move.l	d0,gfg_table(a5)
	beq	\gerr
	move.l	gtf_gadtoolsbase(pc),a6

;------------------
; Now we can create the gadgets! Go through the structure and do the basic
; stuff that is the same for all kinds of gadgets.
;
\cre:	move.w	(a3)+,d2			;more?
	beq	\fine
	bmi	\special			;BevelBoxes etc.

	lea	gtf_newgadget(pc),a1
	bsr	\scalexypair2
	bsr	\scalexypair
	move.l	(a3)+,(a1)+			;Text
	move.l	gfw_textattr(a4),(a1)+		;Font (TextAttr!!)
	move.w	(a3)+,(a1)+			;ID
	moveq	#0,d0
	move.w	(a3)+,d0
	move.l	d0,(a1)+			;Flags
	move.l	gfw_visualinfo(a4),(a1)+
	move.w	(a3)+,d4			;Tag flags!

;------------------
; Do the only basic tag, that is GT_Underscore and GA_Disabled.
;
\bas:	lea	gtf_tagspace(pc),a2
	moveq	#1,d1				;for all subs the default flag
	btst	#gtf_b_Disabled,d4		;Disabled?
	beq.s	\nod
	move.l	#GA_Disabled,(a2)+
	move.l	d1,(a2)+

\nod:	btst	#gtf_b_Underscore,d4		;GT_Underscore wanted?
	beq.s	\nou
	move.l	#GT_Underscore,(a2)+
	moveq	#"_",d0
	move.l	d0,(a2)+

\nou:	lea	\jumplist(pc),a0
	move.w	d2,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	jsr	(a0,d0.w)
	tst.w	d2
	bmi	\cre

\dogad:	clr.l	(a2)				;TAG_DONE
	moveq	#0,d0
	move.b	d2,d0
	move.l	gtf_prev(pc),a0
	lea	gtf_tagspace(pc),a2
	lea	gtf_newgadget(pc),a1
	jsr	-30(a6)			;CreateGadgetA()
	lea	gtf_prev(pc),a0
	move.l	d0,(a0)
	beq.s	\gerr

	move.l	gfg_numof(a5),d1
	lsl.l	#2,d1
	move.l	gfg_table(a5),a0
	move.l	d0,(a0,d1.l)		;remember in table

	addq.l	#1,gfg_numof(a5)	;one more

;------------------
; Do postcreation stuff, i.e. ToggleSelect.
;
\post:	move.l	d0,a0
	btst	#gtf_b_ToggleSelect,d4
	beq.s	\npo1
	or.w	#$100,14(a0)		;GACD_TOGGLESELECT in gg_Activation
\npo1:	btst	#gtf_b_Selected,d4
	beq.s	\npo2
	or.w	#$80,12(a0)		;Selected! in Flags
\npo2:	bra	\cre

;------------------
; All went fine! Now count the gadgets!
;
\fine:	move.l	gfg_gadgets(a5),d5
	move.l	a4,gfg_window(a5)

	move.l	d5,a0
	moveq	#1,d0
\count:	move.l	(a0),d1
	beq.s	\counted
	addq.l	#1,d0
	move.l	d1,a0
	bra.s	\count

\counted:
	move.l	d0,gfg_numof(a5)
	bra.s	\done

;------------------
; Init the GadgetKey structure.
;
\igkey:	lea	gfg_numof(a5),a0
	clr.l	(a0)+			;no gadgets yet

	bra.s	\done

;------------------
; Error occures, free all gadgets!
;
\gerr:	move.l	gfg_gadgets(a5),a0
	move.l	gtf_gadtoolsbase(pc),a6
	jsr	-36(a6)			;FreeGadgets()	
	move.l	gtf_intbase(pc),a6
	lea	gfg_remkey(a5),a0
	moveq	#-1,d0
	jsr	-408(a6)		;FreeRemember()

;------------------
; Okay!
;
\done:	move.l	d5,d0
	movem.l	(sp)+,d1-a6
	rts

;------------------
; Scale value!
;
\scalexypair:
	move.w	(a3)+,d0
	CALL_	gtf_scaled0x
	move.w	d0,(a1)+
	move.w	(a3)+,d0
	CALL_	gtf_scaled0y
	move.w	d0,(a1)+
	rts

\scalexypair2:
	bsr	\scalexypair
	move.l	gfw_lefto(a4),d0
	add.l	d0,-4(a1)			;left&top border!
	rts

;------------------
; Jumplist for different handlings.
;
	dc.w	\posinfo-\jumplist	;for own 'generic' gadgets (MINUS!)
\jumplist:
	dc.w	0			;Generic!
	dc.w	\button-\jumplist
	dc.w	\checkbox-\jumplist
	dc.w	\integer-\jumplist
	dc.w	\listview-\jumplist
	dc.w	\mx-\jumplist
	dc.w	0			;No Number Gadgets!
	dc.w	\cycle-\jumplist
	dc.w	0			;No Palette
	dc.w	0			;No Scroller
	dc.w	0			;RESERVED
	dc.w	\slider-\jumplist
	dc.w	\string-\jumplist
	dc.w	\text-\jumplist


;--------------------------------------------------------------------
; Each kind of gadget has a handler here.
;

;------------------
; Button tags handling sub. Does nothing.
;
\button:	rts

;------------------
; Checkbox tags handling sub.
;
\checkbox:
	btst	#gtf_b_Checked,d4
	beq.s	\ck1
	move.l	#GTCB_Checked,(a2)+
	move.l	d1,(a2)+
\ck1:	rts

;------------------
; Integer tags handling sub.
;
\integer:
;	bsr.s	\calibborder
	btst	#gtf_b_Number,d4
	beq.s	\in1
	move.l	#GTIN_Number,(a2)+
	move.l	(a3)+,(a2)+
\in1:	btst	#gtf_b_MaxChars,d4
	beq.s	\in2
	move.l	#GTIN_MaxChars,(a2)+
	move.l	(a3)+,(a2)+
\in2:	btst	#gtf_b_RightJustified,d4
	beq.s	\in3
	move.l	#STRINGA_Justification,(a2)+
	move.l	#$400,(a2)+
\in3:	btst	#gtf_b_NoTabCycle,d4
	beq.s	\in4
	move.l	#GA_TabCycle,(a2)+
	clr.l	(a2)+
\in4:	rts
	
;\calibborder:		;Change big borders for String/Integer
;	lea	gtf_newgadget(pc),a0
;	add.l	#$00040002,(a0)+
;	sub.l	#$00080004,(a0)
;	rts

;------------------
; Listview tags handling.
;
\listview:
	moveq	#16,d0
	CALL_	gtf_scaled0x
	move.l	#GTLV_ScrollWidth,(a2)+
	move.l	d0,(a2)+			;scale the slider width too!
	btst	#gtf_b_Labels,d4
	beq.s	\lv1
	move.l	#GTLV_Labels,(a2)+
	move.l	(a3)+,(a2)+
\lv1:	btst	#gtf_b_ReadOnly,d4
	beq.s	\lv2
	move.l	#GTLV_ReadOnly,(a2)+
	move.l	d1,(a2)+
\lv2:	btst	#gtf_b_ShowSelected,d4
	beq.s	\lv3
	move.l	#GTLV_ShowSelected,(a2)+
	clr.l	(a2)+
\lv3:	btst	#gtf_b_LVSelected,d4
	beq.s	\lv4
	move.l	#GTLV_Selected,(a2)+
	move.l	(a3)+,(a2)+
\lv4:	rts

;------------------
; MX tags handling.
;
\mx:	btst	#gtf_b_Labels,d4
	beq.s	\mx1
	move.l	#GTMX_Labels,(a2)+
	move.l	(a3)+,(a2)+
\mx1:	btst	#gtf_b_Active,d4
	beq.s	\mx2
	move.l	#GTMX_Active,(a2)+
	move.l	(a3)+,(a2)+
\mx2:	btst	#gtf_b_Spacing,d4
	beq.s	\mx3
	move.l	#GTMX_Spacing,(a2)+
	move.l	(a3)+,d0
	mulu	gfw_fonty(a4),d0
	lsr.l	#3,d0
	move.l	d0,(a2)+
\mx3:	rts

;------------------
; Slider gadget tags handling.
;
\slider:
	move.l	#PGA_Freedom,(a2)+
	move.l	(a3)+,(a2)+
	btst	#gtf_b_RelVerify,d4
	beq.s	\sl1
	move.l	#GA_RelVerify,(a2)+
	move.l	d1,(a2)+
\sl1:	btst	#gtf_b_Min,d4
	beq.s	\sl2
	move.l	#GTSL_Min,(a2)+
	clr.w	(a2)+
	move.w	(a3)+,(a2)+
\sl2:	btst	#gtf_b_Max,d4
	beq.s	\sl3
	move.l	#GTSL_Max,(a2)+
	clr.w	(a2)+
	move.w	(a3)+,(a2)+
\sl3:	btst	#gtf_b_Level,d4
	beq.s	\sl4
	move.l	#GTSL_Level,(a2)+
	clr.w	(a2)+
	move.w	(a3)+,(a2)+
\sl4:	btst	#gtf_b_MaxLevelLen,d4
	beq.s	\sl5
	move.l	#GTSL_MaxLevelLen,(a2)+
	clr.w	(a2)+
	move.w	(a3)+,(a2)+
\sl5:	btst	#gtf_b_LevelFormat,d4
	beq.s	\sl6
	move.l	#GTSL_LevelFormat,(a2)+
	move.l	(a3)+,(a2)+
\sl6:	btst	#gtf_b_LevelPlace,d4
	beq.s	\sl7
	move.l	#GTSL_LevelPlace,(a2)+
	clr.w	(a2)+
	move.w	(a3)+,(a2)+
\sl7:	btst	#gtf_b_DispFunc,d4
	beq.s	\sl8
	move.l	#GTSL_DispFunc,(a2)+
	move.l	(a3)+,(a2)+
\sl8:	rts

;------------------
; Cycle gadget tags handling.
;
\cycle:	btst	#gtf_b_Labels,d4
	beq.s	\cy1
	move.l	#GTCY_Labels,(a2)+
	move.l	(a3)+,(a2)+
\cy1:	btst	#gtf_b_Active,d4
	beq.s	\cy2
	move.l	#GTCY_Active,(a2)+
	move.l	(a3)+,(a2)+
\cy2:	rts
	
;------------------
; String tags handling.
;
\string:
;	bsr	\calibborder
	btst	#gtf_b_String,d4
	beq.s	\st1
	move.l	#GTST_String,(a2)+
	move.l	(a3)+,(a2)+
\st1:	btst	#gtf_b_MaxChars,d4
	beq.s	\st2
	move.l	#GTST_MaxChars,(a2)+
	move.l	(a3)+,(a2)+
\st2:	btst	#gtf_b_RightJustified,d4
	beq.s	\st3
	move.l	#STRINGA_Justification,(a2)+
	move.l	#$400,(a2)+
\st3:	btst	#gtf_b_TabCycle,d4
	beq.s	\st4
	move.l	#GA_TabCycle,(a2)+
	move.l	d1,(a2)+
\st4:	btst    #gtf_b_EditHook,d4
        beq.s   \st5
	move.l	#GTST_EditHook,(a2)+
	move.l	(a3)+,(a2)+
\st5:	rts


;------------------
; Text tags handling.
;
\text:	btst	#gtf_b_Text,d4
	beq.s	\tx1
	move.l	#GTTX_Text,(a2)+
	move.l	(a3)+,(a2)+
\tx1:	btst	#gtf_b_CopyText,d4
	beq.s	\tx2
	move.l	#GTTX_CopyText,(a2)+
	move.l	d1,(a2)+
\tx2:	btst	#gtf_b_Border,d4
	beq.s	\tx3
	move.l	#GTTX_Border,(a2)+
	move.l	d1,(a2)+	
\tx3:	rts

;------------------
; PosInfo handling.
\posinfo:	
	move.l	(a3)+,a0
	move.l	gtf_newgadget(pc),(a0)+
	move.l	gtf_newgadget+4(pc),(a0)+
	rts

;--------------------------------------------------------------------
; Special handling of BevelBoxes and Texts.
;
\special:
	move.l	gtf_intbase(pc),a6
	lea	gfg_remkey(a5),a0
	moveq	#gfb_SIZEOF,d0
	moveq	#1,d1
	jsr	-396(a6)		;AllocRemember()
	move.l	gtf_gadtoolsbase(pc),a6
	tst.l	d0
	beq	\gerr

	move.l	d0,a1
	lea	gfg_objects(a5),a0
\spe1:	move.l	(a0),d0
	beq.s	\spe2
	move.l	d0,a0
	bra.s	\spe1
\spe2:	move.l	a1,(a0)

	clr.l	(a1)+
	move.l	(a3)+,(a1)+		;type, flag, x
	move.l	(a3)+,(a1)+		;y, x2/stype
	move.l	(a3)+,(a1)+		;text/ fill,y2
	bra	\cre

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* FreeGList	Free the gadgets in a list.
*
* INPUT:	a1	GadgetKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_FreeGList
FreeGList:

;------------------
; Start:
;
\do:	movem.l	d0-a6,-(sp)
	move.l	gtf_gadtoolsbase(pc),a6
	move.l	a1,a5
	move.l	gfg_gadgets(a1),d0
	beq.s	\done
	move.l	d0,a0
	clr.l	gfg_gadgets(a1)
	jsr	-36(a6)			;FreeGadgets()

	move.l	gtf_intbase(pc),a6
	lea	gfg_remkey(a5),a0
	moveq	#-1,d0
	jsr	-408(a6)		;FreeRemember()

	move.l	gfg_gnumof(a5),d0
	lsl.l	#2,d0
	addq.l	#4,d0			;to prevent 0 size allocs!
	move.l	gfg_table(a5),a1
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* AddGList	Add a gadget list to the window.
*
* INPUT:	a1	GadgetKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_AddGList
AddGList:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(sp)
	move.l	a1,a5
	CALL_	PaintObjects
	move.l	gfg_gadgets(a5),d7
	move.l	gfg_window(a5),a4

	move.l	gfw_window(a4),a0
	move.l	d7,a1
	moveq	#-1,d0
	moveq	#-1,d1
	move.l	gtf_intbase(pc),a6
	jsr	-438(a6)		;AddGList()

	move.l	gfw_window(a4),a1
	move.l	d7,a0
	move.l	gfg_numof(a5),d0	;only refresh the new ones..
	jsr	-432(a6)		;RefreshGList()

	move.l	4.w,a6
	lea	gfw_glists(a4),a0
	move.l	a5,a1
	jsr	-246(a6)		;AddTail()

	CALL_	gtf_doidcmp

	movem.l	(sp)+,d0-a6
	rts

	ENDIF
	IFD	xxx_gtf_doidcmp

;------------------
; Modify IDCMP for new lists.
;
gtf_doidcmp:
	move.l	gfw_glists(a4),a0
	move.l	gfw_idcmp(a4),d0
	or.l	#gtf_MINIDCMP,d0

\l1:	move.l	(a0),d1
	beq.s	\done
	or.l	gfg_idcmp(a0),d0
	move.l	d1,a0
	bra.s	\l1

\done:	move.l	gtf_intbase(pc),a6
	move.l	gfw_window(a4),a0
	jsr	-150(a6)		;ModifyIDCMP()
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* RemGList	Remove a gadget list again.
*
* INPUT:	a1	GadgetKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_RemGList
RemGList:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(sp)
	move.l	a1,a5
	move.l	gfg_gadgets(a1),d0	;key used?
	beq.s	\done
	move.l	4.w,a6
	jsr	-252(a6)

	move.l	gfg_window(a5),a4
	CALL_	gtf_doidcmp

	move.l	gfg_gadgets(a5),d7
	move.l	gfg_numof(a5),d0	;there is always at least ONE!
        move.l  d0,d6
	move.l	d7,a1
	move.l	gfw_window(a4),a0
	move.l	gtf_intbase(pc),a6
	jsr	-444(a6)		;RemoveGList()

        move.l  d7,a0
\loop:  subq.l  #1,d6
        beq.s   \yo
        move.l  (a0),a0
        bra.s   \loop
\yo:	clr.l	(a0)			;clear last of list for FreeGList()

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* RefreshWindow		Refresh a window with all gadget lists etc.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_RefreshWindow
RefreshWindow:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(a7)

	move.l	gtf_intbase(pc),a6
	move.l	gfw_window(a2),a0
	move.l	a0,d0
	beq.s	.out
	jsr	-456(a6)		;RefreshWindowFrame()	

	move.l	gfw_window(a2),a0
	move.l	gtf_gadtoolsbase(pc),a6
	suba.l	a1,a1
	jsr	-84(a6)			;GT_RefreshWindow()

.out:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* RefreshEventHandler	Used when a REFRESH is required due to sizeing.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_RefreshEventHandler
RefreshEventHandler:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(a7)
	move.l	gfw_window(a2),d7
	beq.s	.out

	move.l	gtf_gadtoolsbase(pc),a6
	move.l	d7,a0
	jsr	-90(a6)			;GT_BeginRefresh()

	moveq	#-1,d0
	move.l	d7,a0
	move.l	gtf_gadtoolsbase(pc),a6
	jsr	-96(a6)			;GT_EndRefresh()

	move.l	a2,a4

	move.w	gfw_clear(a4),d0
	beq.s	\nopattern1

	CALL_	ClearWindow

\nopattern1:
	movea.l	gfw_glists(a4),a3
	move.l	a3,d7
	beq.s	\done

\loop:	move.l	(a3),d7
	beq.s	\done
	move.l	a3,a1
	CALL_	PaintObjects
	move.l	d7,a3
	bra.s	\loop

\done:	move.w	gfw_clear(a4),d0
	beq.s	\nopattern

	move.l	gtf_intbase(pc),a6
	move.l	gfw_window(a4),a0
	jsr	-456(a6)		;RefreshWindowFrame()	

\nopattern:
	move.l	gfw_window(a4),a0
	move.l	gtf_gadtoolsbase(pc),a6
	suba.l	a1,a1
	jsr	-84(a6)			;GT_RefreshWindow()

.out:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* WaitForWindow	Wait for a message to arrive at the window. Only returns
*		if there is one.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_WaitForWindow
WaitForWindow:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	move.l	gfw_window(a2),a0
	move.l	86(a0),d7

\wait:	move.l	d7,a0
	move.l	4.w,a6
	jsr	-384(a6)			;WaitPort()
	tst.l	d0
	beq.s	\wait
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* WaitForWindowAndSignals	Wait for a message to arrive at the window.
*				Also waits for a given signal set.
*
* INPUT:	a2	WindowKey.
*		d0	Signals.
*
* RESULT:	d0	Signals received.
*		d1.b	-1 if there is a message to get with GetGTFMsg
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_WaitForWindowAndSignals
WaitForWindowAndSignals:

;------------------
; Do!
;
\do:	movem.l	d2-a6,-(sp)
	move.l	gfw_window(a2),a0
	move.l	86(a0),a0
	move.b	15(a0),d7
	bset	d7,d0

	move.l	4.w,a6
	jsr	-318(a6)		;Wait()
	btst	d7,d0
	sne	d1

	movem.l	(sp)+,d2-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* GetGTFMsg	Get a message from GTFace. This does also track window
*		size changes!
*
* INPUT:	a2	WindowKey.
*
* RESULT:	d0	IDCMP that came in or 0.
*		a2	WindowKey. If there was a message, the information
*			contained is put in the gfw_msg* fields.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_GetGTFMsg
GetGTFMsg:

;------------------
; Do!
;
\do:	movem.l	d1-a6,-(sp)
	move.l	a2,a5
	moveq	#0,d0
	move.l	gfw_window(a5),a0
	move.l	a0,d1
	beq.s	\done
	move.l	86(a0),a0
	move.l	gtf_gadtoolsbase(pc),a6
	jsr	-72(a6)			;GT_GetIMsg
	tst.l	d0
	beq.s	\done

;------------------
; Read message fields!
;
\read:	move.l	d0,a0
	move.l	$14(a0),gfw_msgidcmp(a5)	;idcmp bits
	move.l	$18(a0),gfw_msgcode(a5)		;code and qualifier
	move.l	$1c(a0),gfw_msgaddr(a5)		;address of object
	move.l	$20(a0),gfw_msgmousex(a5)	;mousex/y
	move.l	$24(a0),gfw_msgseconds(a5)	;seconds
	move.l	$28(a0),gfw_msgmicros(a5)	;micros

	move.l	d0,a1
	jsr	-78(a6)			;GT_ReplyIMsg()
	move.l	gfw_msgidcmp(a5),d0

;------------------
; Check if we must track window size changes...
;
\sized:	cmp.l	#$02000000,d0		;IDCMP_CHANGEWINDOW??
	bne.s	\done

	move.l	gfw_window(a5),a0
	lea	gfw_zoomxpos(a5),a1
	btst	#4,24(a0)		;WFLG_ZOOMED??
	bne.s	\copy

	move.w	10(a0),d1
	sub.w	gfw_vertbd(a5),d1
	move.w	d1,-(a1)		;inner heigth...	
	move.w	8(a0),d1
	sub.w	gfw_horbd(a5),d1
	move.w	d1,-(a1)		;inner width...
	subq.l	#8,a1

\copy:	move.l	4(a0),(a1)+
	move.l	8(a0),(a1)

\done:	movem.l	(sp)+,d1-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* ClearWindow	Fill the entier inside of the window with a line
*		pattern or with color 0.
*
* INPUT:	d0	Color.
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_ClearWindow
ClearWindow:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(a7)
	tst.l	gfw_window(a2)
	beq.s	.out
	CALL_	LockWindow

	move.w	d0,d4
	move.w	d0,gfw_clear(a2)

	move.l	gfw_window(a2),a3
	move.w	8(a3),d2
	move.w	10(a3),d3
	moveq	#0,d0
	move.b	$38(a3),d0
	sub.w	d0,d2
	move.b	$39(a3),d0
	sub.w	d0,d3

	move.w	gfw_lefto(a2),d0
	move.w	gfw_topo(a2),d1

	CALL_	gtf_rectfill

\no:	CALL_	UnLockWindow
.out:	movem.l	(sp)+,d0-a6
	rts	

	ENDIF
	IFD	xxx_gtf_rectfill

;------------------
; RectFill() subroutine.
;
;	d0-d3	Coords & size.
;	d4	Color.
;	a3	Window.
;
gtf_rectfill:
	movem.l	d0-d3,-(sp)

	move.l	gtf_gfxbase(pc),a6

	move.l	50(a3),a1
	move.l	d4,d0	
	jsr	-342(a6)		;SetAPen()
	move.l	50(a3),a1
	moveq	#1,d0	
	jsr	-354(a6)		;SetDrMd()
	movem.l	(sp)+,d0-d3

	subq.w	#1,d2
	subq.w	#1,d3

	cmp.w	d2,d0
	bge.s	\do
	cmp.w	d3,d1
	bge.s	\do

	move.l	50(a3),a1
	move.l	8(a1),-(sp)
	move.l	gtf_pattern(pc),8(a1)
	clr.b	$1d(a1)
	jsr	-306(a6)		;RectFill()
	move.l	50(a3),a1
	move.l	(sp)+,8(a1)
	
\do:	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* PaintObjects	Refresh all objects of a gadget list.
*
* INPUT:	a1	GadgetKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_PaintObjects
PaintObjects:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(sp)
	lea	gfg_objects(a1),a3
	move.l	gfg_window(a1),a4
	move.l	gfw_window(a4),a5
	move.l	$32(a5),a5		;RasterPort

\loop:	move.l	(a3),d7
	beq	\done
	move.l	d7,a3
	addq.l	#4,a3
	tst.b	(a3)+
	beq.s	\text

\bevel:	lea	gtf_beveltags(pc),a1
	move.l	gfw_visualinfo(a4),4(a1)
	tst.b	(a3)+
	beq.s	\norec
	subq.l	#8,a1
\norec:	move.l	a5,a0
	move.w	(a3)+,d0
	CALL_	gtf_scaled0x
	move.w	d0,d4
	move.w	(a3)+,d0
	CALL_	gtf_scaled0y
	move.w	d0,d1
	move.w	(a3)+,d0
	CALL_	gtf_scaled0x
	move.w	d0,d2
	move.w	(a3)+,d0
	CALL_	gtf_scaled0y
	move.w	d0,d3
	move.w	d4,d0
	add.w	gfw_lefto(a4),d0
	add.w	gfw_topo(a4),d1
	move.l	gtf_gadtoolsbase(pc),a6
	movem.l	d0-d3,-(sp)
	jsr	-120(a6)			;DrawBevelBoxA()
	movem.l	(sp)+,d0-d3

\fill:	move.w	(a3)+,d4
	bmi.s	\next

	CALL_	LockWindow

	subq.w	#4,d2
	subq.w	#2,d3
	addq.w	#2,d0
	addq.w	#1,d1
	add.w	d0,d2
	add.w	d1,d3
	move.l	gfw_window(a4),a3
	CALL_	gtf_rectfill

	CALL_	UnLockWindow

\next:	move.l	d7,a3
	bra.s	\loop

\text:	move.b	(a3)+,d3
	move.w	(a3)+,d0
	move.w	(a3)+,d1
	move.w	(a3)+,d2
	move.l	(a3)+,a0
	tst.b	d3
	beq.s	\noptr
	move.l	(a0),a0
\noptr:	move.l	a4,a2
	CALL_	PrintScaled
	bra.s	\next

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* AddMenu	Generate and add a menu.
*
* INPUT:	a0	Menu structure.
*		a2	WindowKey.
*
* RESULT:	d0	0 if failure.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_AddMenu
AddMenu:
	NEED_	SetMenu

;------------------
; Do.
;
\do:	CALL_	GenMenu
	bne.s	SetMenu
	rts

	ENDIF
;------------------





;--------------------------------------------------------------------
*
* GenMenu	Generate a menu.
*
* INPUT:	a0	Menu structure.
*		a2	WindowKey.
*
* RESULT:	d0	Menu strip or 0 if failure.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_GenMenu
GenMenu:

;------------------
; Do.
;
\do:	movem.l	d1-a6,-(sp)
	move.l	a2,a4
	lea	gtf_tagend(pc),a1
	move.l	gtf_gadtoolsbase(pc),a6
	jsr	-48(a6)			;CreateMenus()
	move.l	d0,d7
	beq.s	\done

	move.l	gfw_visualinfo(a4),a1
	move.l	d7,a0
	lea	\newlooktag(pc),a2
	jsr	-66(a6)			;LayoutMenus()
	tst.l	d0
	beq.s	\done
	move.l	d7,d0

\done:	movem.l	(sp)+,d1-a6
	rts

\newlooktag:
	IFD	GTMN_NewLookMenus
	dc.l	GTMN_NewLookMenus,1
	ENDC
	dc.l	TAG_DONE

	ENDIF
;------------------





;--------------------------------------------------------------------
*
* SetMenu	Set a menu strip.
*
* INPUT:	d0	Menu strip.
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_SetMenu
SetMenu:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(sp)
	move.l	a2,a4
	move.l	gtf_intbase(pc),a6
	move.l	gfw_window(a4),a0
	move.l	d0,a1
	move.l	d0,gfw_menu(a4)
	jsr	-264(a6)		;SetMenuStrip()
	tst.l	d0

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------





;--------------------------------------------------------------------
*
* RemMenu	Remove and deallocate the menu.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_RemMenu
RemMenu:

;------------------
; Do.
;
\do:	CALL_	StripMenu
	JUMP_	FreeMenu

	ENDIF
;------------------





;--------------------------------------------------------------------
*
* StripMenu	Remove the menu.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_StripMenu
StripMenu:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(sp)
	move.l	gtf_intbase(pc),a6
	move.l	gfw_window(a2),a0
	clr.b	gfw_domenu(a2)		;for CallMenu()
	jsr	-54(a6)			;ClearMenuStrip()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* FreeMenu	Free a menu.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_FreeMenu
FreeMenu:

;------------------
; Do.
;
\do:	movem.l	d0-a6,-(sp)
	move.l	gtf_gadtoolsbase(pc),a6
	move.l	gfw_menu(a2),d0
	beq.s	\done
	move.l	d0,a0
	clr.l	gfw_menu(a2)
	jsr	-54(a6)			;FreeMenu()

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* (Un)LockWindow	Lock or unlock the window for graphics.
* (Un)LockPubScreen	Lock or unlock the screen.
*
* INPUT:	a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_LockWindow
LockWindow:

;------------------
; Do!
;
\do:	movem.l	a5/a6,-(sp)
	move.l	gtf_gfxbase(pc),a6
	move.l	gfw_window(a2),a5
	move.l	$7c(a5),a5		;Layer!
	jsr	-432(a6)		;LockLayerRom()
	movem.l	(sp)+,a5/a6
	rts

	ENDIF
;------------------
	IFD	xxx_UnLockWindow
UnLockWindow:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	move.l	gtf_gfxbase(pc),a6
	move.l	gfw_window(a2),a5
	move.l	$7c(a5),a5		;Layer!
	jsr	-438(a6)		;UnLockLayerRom()
	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------
	IFD	xxx_LockPubScreen
LockPubScreen:

;------------------
; Do!
;
\do:	movem.l	d1-a6,-(sp)
	move.b	gtf_locked(pc),d0
	bne.s	\okay
	move.l	gtf_intbase(pc),a6
	move.l	gtf_pubscreenname(pc),a0
	jsr	-510(a6)		;LockPubScreen()
	clr.l	gtf_pubscreenname
	lea	gtf_screen(pc),a0
	move.l	d0,(a0)
	beq	\done
	lea	gtf_locked(pc),a0
	st.b	(a0)
\okay:	move.l	gtf_screen(pc),d0
\done:	movem.l	(sp)+,d1-a6
	rts

	ENDIF
;------------------
	IFD	xxx_UnLockPubScreen
UnLockPubScreen:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	move.b	gtf_locked(pc),d0
	beq.s	\done
	move.l	gtf_screen(pc),a1
	suba.l	a0,a0
	move.l	gtf_intbase(pc),a6
	jsr	-516(a6)		;UnLockPubScreen()
	lea	gtf_locked(pc),a0
	clr.b	(a0)
\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* CallGadget	Call the gadget handler for a gadget.
*
* INPUT:	a2	WindowKey.
*		a0	Info list.
*
* Handler gets called with:
*
*		a1	Gadget address.
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_CallGadget
CallGadget:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	tst.l	(a2)
	beq.s	\done
	moveq	#$40,d0
	cmp.l	gfw_msgidcmp(a2),d0
	bne.s	\done
	move.l	gfw_msgaddr(a2),a1
	move.w	$26(a1),d0
	move.w	d0,d1
	CALL_	FindGadget		;does that gadget exist?
	beq.s	\done

\loop:	tst.w	(a0)
	beq.s	\done
	cmp.w	(a0)+,d1
	bne.s	\next
	move.w	(a0),d0

	pea	\done(pc)
	lea	gtf_base(pc),a0
	jmp	(a0,d0)

\next:	addq.w	#2,a0
	bra.s	\loop
	
\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------



;--------------------------------------------------------------------
*
* CallKey	Call the key handler for a key.
*
* INPUT:	a2	WindowKey.
*		a0	Info list.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_CallKey
CallKey:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	tst.l	(a2)
	beq.s	\done
	move.w	gfw_msgcode(a2),d0

\loop:	tst.w	(a0)
	beq.s	\done
	cmp.w	(a0)+,d0
	bne.s	\next
	move.w	(a0),d0

	pea	\done(pc)
	lea	gtf_base(pc),a0
	jmp	(a0,d0)

\next:	addq.w	#2,a0
	bra.s	\loop
	
\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------



;--------------------------------------------------------------------
*
* CallMenu	Call the menu handler for a menu selection.
*
* INPUT:	a2	WindowKey.
*		a0	Info list.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_CallMenu
CallMenu:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	cmp.l	#$100,gfw_msgidcmp(a2)
	bne.s	\done
	move.w	gfw_msgcode(a2),d0
	st.b	gfw_domenu(a2)
	move.l	a0,a3

\loop:	tst.l	(a2)			;maybe menu point removes window?
	beq.s	\done
	move.l	gfw_menu(a2),d1
	beq.s	\done
	move.l	d1,a0
	move.l	gtf_intbase(pc),a6
	jsr	-144(a6)		;ItemAddress()
	tst.l	d0
	beq.s	\done
	move.l	d0,a1
	btst	#4,13(a1)		;enabled?
	beq.s	\next
	move.l	a3,a0
	move.w	$22(a1),d0

\find:	tst.w	(a0)
	beq.s	\next
	cmp.w	(a0)+,d0
	bne.s	\no
	move.w	(a0),d0
	movem.l	a1/a2/a3,-(sp)
	lea	gtf_base(pc),a0
	jsr	(a0,d0.w)
	movem.l	(sp)+,a1/a2/a3
	bra.s	\next

\no:	addq.w	#2,a0
	bra.s	\find

\next:	tst.b	gfw_domenu(a2)
	beq.s	\done
	move.w	$20(a1),d0
	bra.s	\loop
	
\done:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* PrintScaledList	Print a linked list of IntuiTexts.
*
* INPUT:	a2	WindowKey.
*		a0	IntuiText list. 0 allowed.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_PrintScaledList
PrintScaledList:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	move.l	a0,d0
	beq.s	\end

\loop:	move.l	d0,a3
	move.b	(a3),d2
	lsl.w	#8,d2
	move.b	1(a3),d2
	move.w	6(a3),d1
	move.w	4(a3),d0
	move.l	12(a3),a0
	CALL_	PrintScaled
	move.l	16(a3),d0
	bne.s	\loop

\end:	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* PrintScaled	Print a one-line text, scaled.
*
* INPUT:	a0	Text.
*		d0	X position in inner window, for topaz80.
*		d1	Y position in inner window, for topaz80.
*		d2	(B Pen)*256+A Pen.
*		a2	WindowKey.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_PrintScaled
PrintScaled:

;------------------
; Do!
;
\do:	movem.l	d0-a6,-(sp)
	move.l	a2,a4

	lea	gtf_intuitext(pc),a1
	move.l	a1,a2
	move.b	d2,(a2)+
	lsr.w	#8,d2
	move.b	d2,(a2)+
	move.w	#$100,(a2)+
	CALL_	gtf_scaled0x
	move.w	d0,(a2)+
	move.w	d1,d0
	CALL_	gtf_scaled0y
	move.w	d0,(a2)+
	move.l	a0,4(a2)

	move.l	gfw_window(a4),a0
	move.l	a0,d0
	beq.s	.out
	move.l	50(a0),a0
	move.w	gfw_lefto(a4),d0
	move.w	gfw_topo(a4),d1
	move.l	gtf_intbase(pc),a6
	jsr	-216(a6)		;PrintIText()
.out	movem.l	(sp)+,d0-a6
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* FindGadget	Find a gadget in any of the gadget lists of a window.
*
* INPUT:	d0	ID
*		a2	WindowKey. DO NOT FORGET!
*
* RESULT:	d0	Gadget address or 0.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_FindGadget
FindGadget:

;------------------
; Do.
;
\do:	movem.l	d1/a1,-(sp)
	move.l	d0,d1
	move.l	gfw_glists(a2),a1
\l1:	move.l	a1,d0
	beq.s	\done
	tst.l	(a1)
	beq.s	\none
	move.l	d1,d0
	CALL_	FindGadgetInKey
	bne.s	\done
	move.l	(a1),a1
	bra.s	\l1

\none:	moveq	#0,d0
\done:	movem.l	(sp)+,d1/a1
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------
*
* FindGadgetInKey	Find a gadget in a GadgetKey. It needn't to be added
*			to the window yet.
*
* INPUT:	d0	ID
*		a1	GadgetKey
*
* RESULT:	d0	Gadget address or 0.
*		ccr	On d0.
*
;--------------------------------------------------------------------

;------------------
	IFD	xxx_FindGadgetInKey
FindGadgetInKey:

;------------------
; Do.
;
\do:	movem.l	d1/d2/a0/a1,-(sp)
	move.l	gfg_table(a1),a0
	moveq	#0,d2
	move.l	gfg_gnumof(a1),d1
	beq.s	\done

\l2:	move.l	(a0)+,a1
	cmp.w	$26(a1),d0
	bne.s	\n1
	move.l	a1,d2
	bra.s	\done

\n1:	subq.l	#1,d1
	bne.s	\l2

\done:	move.l	d2,d0
	movem.l	(sp)+,d1/d2/a0/a1
	rts

	ENDIF
;------------------




;--------------------------------------------------------------------

;------------------
; Two scaling subroutines.
;
;	d0=position
;	a4=WindowKey
;
	IFD	xxx_gtf_scaled0x
gtf_scaled0x:
	mulu	gfw_fontx(a4),d0
	addq.l	#7,d0
	lsr.l	#3,d0
	rts
	ENDIF

	IFD	xxx_gtf_scaled0y
gtf_scaled0y:
	mulu	gfw_fonty(a4),d0
	addq.l	#7,d0
	lsr.l	#3,d0
	rts
	ENDIF

;------------------

;--------------------------------------------------------------------

;------------------
; Includes.
;
	IFND	ely_defined
	include	graphicslib.r
	include	intuitionlib.r
	ENDIF

;------------------
; Data.
	IFND	ely_defined
gtf_gadtoolsbase:	dc.l	0
	ENDIF
gtf_pubscreenname:	dc.l	0
gtf_topazfont:		dc.l	0
gtf_defaultfont:	dc.l	0
gtf_screen:		dc.l	0
gtf_prev:		dc.l	0
gtf_refgnum:		dc.l	0
gtf_pattern:		dc.l	0
gtf_status:		dc.b	0
gtf_locked:		dc.b	0

gtf_pubscreenfallback:	dc.b	-1	;turned on as default
gtf_nolimscale:		dc.b	0	;turn off scaling of min/max values


	IFD	xxx_gtf_tagspace
gtf_tagspace:		ds.l	30,0
	ENDIF

	IFD	xxx_OpenScaledWindow
gtf_minmax		dc.l	0,0
	ENDIF

	IFD	xxx_gtf_newgadget
gtf_newgadget:		ds.b	30,0
	ENDIF

	IFND	ely_defined
gtf_gadtoolsname:	dc.b	"gadtools.library",0,0
	ENDIF

;------------------
; The text attribute structures.
;
gtf_topazattr:
	dc.l	0
	dc.w	8
	dc.b	0,%01000001
gtf_topazname:
	dc.b	"topaz.font",0,0

gtf_defaultattr:
	dc.l	0
	dc.w	0
	dc.b	0,0

gtf_intuitext:
	dc.l	0,0,0,0,0

gtf_beveltags2:
	dc.l	GTBB_Recessed,-1
gtf_beveltags:
	dc.l	GT_VisualInfo,0
gtf_tagend:
	dc.l	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	gtf_oldbase

;------------------
	endif

	end

