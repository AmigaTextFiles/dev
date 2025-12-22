
StartSkip	=	0		;0=WB/CLI, 1=CLI only (eg. from AsmOne)
Processor	=	68020		;0/680x0 (= 0 is faster than 68000)
MathProc	=	0		;FPU: 0(none)/68881/68882/68040

A		= 0
B		= 1

		; set which cia timer to use

CIAchip		= B
TIMER		= B

MicroTiming	= 20000		; interval timing for faked VerticalBlank


		include	"startup.asm"	; get NewStartupxx.lha from AmiNet!!

		include	"exec/exec.i"
		include	"exec/exec_lib.i"
		include	"dos/dos_lib.i"
		include	"intuition/intuition.i"
		include	"intuition/intuition_lib.i"
		include	"graphics/graphics_lib.i"
		include	"graphics/rastport.i"
		include	"hardware/cia.i"
		include	"resources/cia_lib.i"
		include	"cybergraphics/cybergraphics.i"
		include	"cybergraphics/cybergraphics_lib.i"
		include "devices/input.i"
		include "devices/inputevent.i"

		include	"depmacros_ns.i"
		include	"inc/input.i"
		include	"cia.i"

		dc.b	"$VER: CyberDirect 0.0001 © Andreas Fredriksson",0
		even

*-------------------------------------------------------*
*	            Inits for starup.asm		*
*-------------------------------------------------------*

Init:
Devpac:		TaskName "<Rendering>"

		TaskPri	10			;set task pri, optional

		; define the libraries

		DefLib	cybergraphics,40
		DefLib	graphics,39
		DefLib	intuition,39
		DefLib	dos,39
		DefEnd				;ALWAYS REQUIRED!!!

*-------------------------------------------------------*
*		      Start off				*
*-------------------------------------------------------*

Start		bsr.w	GetCIA			; allocate a CIA timer
		bne	ciaerror

		LibBase	cybergraphics
		suba.l	a0,a0			; requester: not used
		lea.l	requestertags,a1
		Call	CModeRequestTagList	; get a mode
		tst.l	d0
		beq	Exit
		move.l	d0,mode_insert+4   ; save modeid in screen taglist

		suba.l	a0,a0
		lea.l	screentags,a1
		CallInt	OpenScreenTagList  ; open the screen
		tst.l	d0
		beq	Exit
		move.l	d0,screen
		add.l	#sc_RastPort,d0
		move.l	d0,rastport	; save rport address

		suba.l	a0,a0
		lea.l	windowtags,a1
		CallInt	OpenWindowTagList  ; open a dummy window...
		tst.l	d0
		beq	Exit
		move.l	d0,window

		move.l	window,a0
		lea.l	sprite,a1
		moveq.w	#0,d0
		moveq.w	#0,d1
		moveq.w	#0,d2
		moveq.w	#0,d3
		CallInt	SetPointer	; ...for blanking the mouse!

		bsr.w	StartHandler	; install the inputhandler!
		beq	Exit

		bsr.w	UpdateBuffer	; black screen

.ll		tst.w	_Quit		; no ugly $bfe001!
		bne	Exit

		bsr.w	Render		; do your stuff in the 24-bit buffer..
		bsr.w	UpdateBuffer	; ..and put the results in the screen!
		bra.s	.ll		; loop again!


Exit		tst.w	handler		; some nice exit code
		beq.s	.nohandler
		bsr.w	StopHandler

.nohandler	tst.l	window
		beq.s	.nowin
		move.l	window,a0
		CallInt	CloseWindow

.nowin		tst.l	screen
		beq.s	.noscr
		move.l	screen,a0
		CallInt	CloseScreen

.noscr		bsr.w	FreeCIA
		Return	0			;return code and bye bye!
ciaerror	Return	20




*-------------------------------------------------------*
*                 Update 24bit buffer			*
*   Could easily be modified here for direct rendering  *
*              using the lock-functions!		*
*-------------------------------------------------------*

UpdateBuffer	lea.l	RGBChunky,a0
		move.l	rastport,a1
		clr.w	d0
		clr.w	d1
		move.w	#4*320,d2		; bytes per line in source
		clr.w	d3
		clr.w	d4
		move.w	#320,d5
		move.w	#240,d6
		move.w	#RECTFMT_ARGB,d7
		CallCyb	WritePixelArray
		rts


*-------------------------------------------------------*
*		      Render				*
*-------------------------------------------------------*

Render
		; the chunky buffer is yours!

		rts

*-------------------------------------------------------*
*		       Data				*
*-------------------------------------------------------*

;StartShow	dc.w	0

reqtitle	dc.b	"Pick a 24bit screenmode!",0
		even
requestertags	dc.l	CYBRMREQ_WinTitle,reqtitle
		dc.l	CYBRMREQ_MinWidth,320	; sorry, hardcoded screen
		dc.l	CYBRMREQ_MaxWidth,320	; just change if you want more
		dc.l	CYBRMREQ_MinHeight,240
		dc.l	CYBRMREQ_MaxHeight,240
		dc.l	CYBRMREQ_MinDepth,24	; minimum depth
		;dc.l	CYBRMREQ_MaxDepth,32
		dc.l	0,0

rastport	dc.l	0

screentags	dc.l	SA_Left,0
		dc.l	SA_Top,0
		dc.l	SA_Width,320
		dc.l	SA_Height,240
		dc.l	SA_Depth
mode_depth	dc.l	32
		dc.l	SA_Type,CUSTOMSCREEN
mode_insert	dc.l	SA_DisplayID,0
		dc.l	SA_Draggable,0
		dc.l	SA_Exclusive,1
		dc.l	0,0		

window		dc.l	0
windowtags	dc.l	WA_Left,0
		dc.l	WA_Top,0
		dc.l	WA_Width,20
		dc.l	WA_Height,20
		dc.l	WA_CustomScreen
screen		dc.l	0
		dc.l	WA_Borderless,1
		;dc.l	WA_Backdrop,1
		dc.l	WA_BackFill,LAYERS_NOBACKFILL
		dc.l	WA_Activate,1
		dc.l	0,0

		Section	Chunky,BSS_F

RGBChunky	ds.b	320*240*4

		section	blaha,data_C

sprite		dc.l	0,0,0,0		; dummy for clearing the sprite!


*-------------------------------------------------------*
*          Faked VBL interrupt via CIA timing!		*
*-------------------------------------------------------*

		Section	CIA_INT,Code_F

cia_Interrupt	movem.l	a2-a6/d2-d7,-(sp)

		; do syncs here!
.leave
		movem.l	(sp)+,a2-a6/d2-d7
		clr.w	d0
		rts
