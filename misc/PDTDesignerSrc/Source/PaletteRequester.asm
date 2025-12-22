	opt	c+,d+,l+,o+,i+
	incdir	sys:include/
	include	exec/exec_lib.i
	include	graphics/graphics_lib.i
	include	intuition/intuition_lib.i
	include	intuition/intuition.i

	output	MapDesignerV2.0:Modules/PaletteRequester.o

	xdef	_PaletteRequester		; Name of routine.

	xref	_IntuitionBase,_GfxBase		; Import library bases.

;  This routine takes the following inputs:
;
;	a0 - Screen - Pointer to a screen to open requester on.
;	a1 - Viewport - Pointer to a Viewport to be modified by the palette
;			requester.  NOTE: Screens viewport is also changed.


CCOLX		equ	172	; X start of "Current Colour" block.
CCOLY		equ	17	; Y start of "Current Colour" block.
CCOLWIDTH	equ	144	; Actual width of "Current Colour" block.
CCOLWIDTHR	equ	315	; Ending X co-ord for use with RectFill();
CCOLHEIGHT	equ	10	; Actual height of "Current Colour" block.
CCOLHEIGHTR	equ	26	; Ending Y co-ord for use with RectFill();
CWIDTH		equ	18	; Width of 1 colour gadget in palette block.
CHEIGHT		equ	8	; Height of 1 colour gadget in palette block.
PXST		equ	172	; X start of palette block.
PYST		equ	29	; Y start of palette block.

SUCCESS		equ	0	; All went okay, user selected OKAY.
CANCEL		equ	1	; All went okay, user selected CANCEL.
FAILURE		equ	-1	; Failed to open the palette requester.

		section	Program,code
_PaletteRequester:
	movem.l	d2-7/a2-6,-(sp)		; Save clients registers.
	move.l	a0,InputScreen		; Store inputs...
	move.l	a1,InputPort
	lea	PaletteWindow,a0
	move.l	InputScreen,nw_Screen(a0)	; Setup windows screen.
	CALLINT		OpenWindow	; Open the window.
	move.l	d0,WindowPtr		; Store and test result.
	beq	.Failure		; Exit failure if no window.
	move.l	d0,a0
	move.l	wd_RPort(a0),ReqRastPort     ; Get some stuff from window...
	move.l	wd_UserPort(a0),ReqMsgPort
	move.l	ReqRastPort,a1
	moveq	#RP_JAM1,d0
	CALLGRAF	SetDrMd		; Setup output mode.
	move.l	ReqRastPort,a1
	moveq	#1,d0
	CALLGRAF	SetAPen		; Setup output pen.
	move.l	ReqRastPort,a1
	moveq	#0,d0
	moveq	#0,d1
	move.w	#319,d2
	move.w	#63,d3
	CALLGRAF	RectFill	; Fill window.
	move.l	ReqRastPort,a0
	lea	Border1,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		DrawBorder	; Render section borders.
	move.l	ReqRastPort,a0
	lea	Text1,a1
	moveq	#0,d0
	moveq	#0,d1
	CALLINT		PrintIText	; Render texts into window.
	bsr	InitGadgets		; Setup rest of gadgets.
	bsr.s	HandleInputs		; Edit colours.
	move.l	WindowPtr,a0
	CALLINT		CloseWindow	; Close the window.
	move.l	ReturnCode,d0		; Get return value.
	bra.s	.Exit			; Return code to client.
.Failure:
	moveq	#FAILURE,d0		; Tell client about our problems.
.Exit:
	movem.l	(sp)+,d2-7/a2-6		; Recall regs.
	rts

HandleInputs:
	move.w	#0,Exit			; Make sure we don't suddenly quit!
.WhileNoExit:
	tst.w	Exit
	bne	.Exit			; Exit if flag says to do so.
	move.l	ReqMsgPort,a0
	CALLEXEC	WaitPort	; Wait for user to do something.
.WhileInputs:
	move.l	ReqMsgPort,a0
	CALLEXEC	GetMsg		; Get next message.
	tst.l	d0
	beq.s	.WhileNoExit		; Wait / exit if no messages.
	move.l	d0,a1
	move.l	im_IAddress(a1),IAddress	; Get useful data...
	move.l	im_Class(a1),IClass
	CALLEXEC	ReplyMsg	; The send message back.
	cmpi.l	#GADGETDOWN,IClass	; Is this a colour gadget?
	bne.s	.TrySlides		; No, then check sliders.
	move.l	IAddress,a0
	move.w	gg_GadgetID(a0),CurrCol	; Else change colour number.
	bsr	NewColour		; Then update the display.
	bra.s	.WhileInputs		; Now collect rest of inputs...
.TrySlides:
	cmpi.l	#MOUSEMOVE,IClass	; Is a slider being moved?
	bne.s	.TryGadgets		; No, then check the main gadgets.
	lea	RedInfo,a2
	moveq	#0,d4
	move.w	pi_HorizPot(a2),d4
	divu.w	#(MAXPOT/15),d4
	lea	GreenInfo,a2
	moveq	#0,d5
	move.w	pi_HorizPot(a2),d5
	divu.w	#(MAXPOT/15),d5
	lea	BlueInfo,a2
	moveq	#0,d6
	move.w	pi_HorizPot(a2),d6
	divu.w	#(MAXPOT/15),d6
	move.l	InputPort,a0		; Update colour for viewport...
	move.w	CurrCol,d0
	move.w	d4,d1
	move.w	d5,d2
	move.w	d6,d3
	CALLGRAF	SetRGB4
	move.l	InputScreen,a0		; Update colour for screen...
	lea	sc_ViewPort(a0),a0
	move.w	CurrCol,d0
	move.w	d4,d1
	move.w	d5,d2
	move.w	d6,d3
	CALLGRAF	SetRGB4
	bra	.WhileInputs		; Get rest of inputs...
.TryGadgets:
	lea	InputVectors,a0		; Get base of input table.
	move.l	IAddress,a1
	move.w	gg_GadgetID(a1),d0	; Get gadget number.
	subi.w	#35,d0
	mulu	#4,d0			; Calculate offset.
	move.l	(a0,d0),a0		; Get address of routine.
	jsr	(a0)			; Handle input.
	bra	.WhileInputs		; Loop for inputs...
.Exit:
	rts

InitGadgets:
	move.w	#0,CurrCol		; Setup initial colour.
	move.l	InputPort,a0
	move.l	vp_RasInfo(a0),a0
	move.l	ri_BitMap(a0),a0
	move.b	bm_Depth(a0),d0		; Get depth.
	ext.w	d0
	moveq	#1,d1
	lsl.w	d0,d1			; NumCols = ( 1 << Depth ).
	cmpi.w	#32,d1			; 32 is max.
	ble.s	.NumOK			; So, branch if value is OK.
	move.w	#32,d1
.NumOK:
	move.w	d1,NumCols		; Get number of colours to edit.
	lea	CancelTable,a0
	bsr	GrabBackup		; Get backup in case of a CANCEL.
	move.l	InputScreen,a0
	lea	sc_ViewPort(a0),a0
	lea	CancelTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Copy ViewPort colours into screen.
	lea	ColourGadgetArray,a0	; Get start of colour array.
	move.w	NumCols,d0
	subq.w	#2,d0			; -1 for dbra. -1, must have 1+ cols.
	bmi.s	.GotLastColour
.InitLoop:
	move.l	a0,a1			; OldGad = CurrGad.
	lea	gg_SIZEOF(a0),a0	; Move on a gadget.
	move.l	a0,gg_NextGadget(a1)	; Link new gadget into list.
	dbra	d0,.InitLoop		; Loop for all colours...
.GotLastColour:
	move.l	#0,gg_NextGadget(a0)	; Make this the last in list.
	lea	Gadget1,a0
	move.l	WindowPtr,a1
	suba.l	a2,a2
	CALLINT		RefreshGadgets	; Redraw gadgets into window.
	bsr.s	NewColour		; Draw palette & init rest of req.
	rts

DisplayPalette:
	move.l	ReqRastPort,a1
	moveq	#RP_JAM1,d0
	CALLGRAF	SetDrMd		; Setup output mode.
	moveq	#0,d7			; Init colour number to draw.
.DisplayLoop:
	move.l	ReqRastPort,a1
	move.w	d7,d0
	CALLGRAF	SetAPen		; Setup output pen.
	move.l	ReqRastPort,a1
	move.w	#PXST,d0
	move.w	#PYST,d1
	move.l	d7,d2
	divu.w	#8,d2			; Calculate Top left corner...
	move.l	d2,d3
	mulu.w	#CHEIGHT,d2
	swap.w	d3
	mulu.w	#CWIDTH,d3
	add.w	d2,d1
	add.w	d3,d0
	move.w	d0,d2			; Setup bottom right corner...
	move.w	d1,d3
	addi.w	#CWIDTH-1,d2
	addi.w	#CHEIGHT-1,d3
	CALLGRAF	RectFill	; Fill window.
	addq.l	#1,d7
	cmp.w	NumCols,d7		; Are we done?
	blt.s	.DisplayLoop		; No, then loop...
	rts

NewColour:
	lea	BackupTable,a0
	bsr	GrabBackup		; Get backup in case of an UNDO.
NewColourNB:	; Here we do the same but do not update the backup buffer.
	move.l	ReqRastPort,a1
	moveq	#RP_JAM1,d0
	CALLGRAF	SetDrMd		; Setup output mode.
	move.l	ReqRastPort,a1
	move.w	CurrCol,d0
	CALLGRAF	SetAPen		; Setup output pen.
	move.l	ReqRastPort,a1
	move.w	#CCOLX,d0
	move.w	#CCOLY,d1
	move.w	#CCOLWIDTHR,d2
	move.w	#CCOLHEIGHTR,d3
	CALLGRAF	RectFill	; Fill "Selected Colour" area.
	bsr	DisplayPalette		; Re-display palette.
	move.l	ReqRastPort,a0
	lea	SelectedBorder,a1
	move.w	#PXST,d0
	move.w	#PYST,d1
	move.w	CurrCol,d2
	ext.l	d2
	divu.w	#8,d2			; Calculate Top left corner...
	move.l	d2,d3
	mulu.w	#CHEIGHT,d2
	swap.w	d3
	mulu.w	#CWIDTH,d3
	add.w	d2,d1
	add.w	d3,d0
	CALLINT		DrawBorder	; Render "Selected" border.
	move.w	CurrCol,d0
	ext.l	d0
	move.l	InputPort,a0
	move.l	vp_ColorMap(a0),a0
	CALLGRAF	GetRGB4		; Get colour value.
	move.l	d0,d7
	lea	RedGadget,a0
	move.l	WindowPtr,a1
	suba.l	a2,a2
	move.w	#(AUTOKNOB!FREEHORIZ),d0
	move.w	d7,d1
	lsr.w	#8,d1
	andi.w	#$f,d1
	mulu.w	#(MAXPOT/15),d1
	move.w	#MAXPOT,d2
	move.w	#$1000,d3
	move.w	#MAXBODY,d4
	moveq	#1,d5
	CALLINT		NewModifyProp	; Update "Red" slider
	lea	GreenGadget,a0
	move.l	WindowPtr,a1
	suba.l	a2,a2
	move.w	#(AUTOKNOB!FREEHORIZ),d0
	move.w	d7,d1
	lsr.w	#4,d1
	andi.w	#$f,d1
	mulu.w	#(MAXPOT/15),d1
	move.w	#MAXPOT,d2
	move.w	#$1000,d3
	move.w	#MAXBODY,d4
	moveq	#1,d5
	CALLINT		NewModifyProp	; Update "Green" slider
	lea	BlueGadget,a0
	move.l	WindowPtr,a1
	suba.l	a2,a2
	move.w	#(AUTOKNOB!FREEHORIZ),d0
	move.w	d7,d1
	andi.w	#$f,d1
	mulu.w	#(MAXPOT/15),d1
	move.w	#MAXPOT,d2
	move.w	#$1000,d3
	move.w	#MAXBODY,d4
	moveq	#1,d5
	CALLINT		NewModifyProp	; Update "Blue" slider
	rts

GrabBackup:
	move.l	a0,a2			; Input a0 - Desination backup table.
	move.l	InputPort,a3
	move.l	vp_ColorMap(a3),a3	; Get ptr to source color map.
	moveq	#0,d5			; ix = 0.
.BackupLoop:
	move.l	a3,a0
	move.l	d5,d0
	CALLGRAF	GetRGB4		; Get value.
	move.w	d0,(a2)+		; Store value in table.
	addq.w	#1,d5
	cmp.w	NumCols,d5		; Are we done?
	blt.s	.BackupLoop		; No then loop...
	rts

HandleUndo:
	move.l	InputScreen,a0
	lea	sc_ViewPort(a0),a0
	lea	BackupTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Restore screen colours.
	move.l	InputPort,a0
	lea	BackupTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Restore ViewPort colours.
	bsr	NewColour
	rts

HandleOkay:
	move.w	#-1,Exit		; Tell parent routines to exit.
	move.l	#SUCCESS,ReturnCode		; Setup return value for user.
	rts
HandleCancel:
	move.w	#-1,Exit		; Tell parent routines to exit.
	move.l	InputScreen,a0
	lea	sc_ViewPort(a0),a0
	lea	CancelTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Restore initial screen colours.
	move.l	InputPort,a0
	lea	CancelTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Restore initial ViewPort colours.
	move.l	#CANCEL,ReturnCode		; Setup return value for user.
	rts

HandleSpread:
	rts

HandleExchg:
	lea	WorkTable,a0
	bsr	GrabBackup		; Get colour values to work with.
	move.w	CurrCol,FirstCol
.WhileNoExit:
	move.l	ReqMsgPort,a0
	CALLEXEC	WaitPort	; Wait for user to do something.
.WhileInputs:
	move.l	ReqMsgPort,a0
	CALLEXEC	GetMsg		; Get next message.
	tst.l	d0
	beq.s	.WhileNoExit		; Wait / exit if no messages.
	move.l	d0,a1
	move.l	im_IAddress(a1),IAddress	; Get useful data...
	move.l	im_Class(a1),IClass
	CALLEXEC	ReplyMsg	; The send message back.
	cmpi.l	#GADGETDOWN,IClass	; Is this a colour gadget?
	bne.s	.WhileInputs		; No, loop...
	move.l	IAddress,a0
	move.w	gg_GadgetID(a0),CurrCol	; Else change colour number.
	move.w	CurrCol,d0
	move.w	FirstCol,d1		; Calculate colour offsets.
	lsl.w	#1,d0
	lsl.w	#1,d1
	lea	WorkTable,a3
	move.w	(a3,d0),d2		; Get 2nd colour
	move.w	(a3,d1),(a3,d0)		; Put 1st colour into 2nd position.
	move.w	d2,(a3,d1)		; Put 2nd colour into 1st position.
	move.l	InputScreen,a0
	lea	sc_ViewPort(a0),a0
	lea	WorkTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Update screen colours.
	move.l	InputPort,a0
	lea	WorkTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Update ViewPort colours.
	bsr	NewColourNB		; Then update the display.
	rts

HandleCopy:
	lea	WorkTable,a0
	bsr	GrabBackup		; Get colour values to work with.
	move.w	CurrCol,FirstCol
.WhileNoExit:
	move.l	ReqMsgPort,a0
	CALLEXEC	WaitPort	; Wait for user to do something.
.WhileInputs:
	move.l	ReqMsgPort,a0
	CALLEXEC	GetMsg		; Get next message.
	tst.l	d0
	beq.s	.WhileNoExit		; Wait / exit if no messages.
	move.l	d0,a1
	move.l	im_IAddress(a1),IAddress	; Get useful data...
	move.l	im_Class(a1),IClass
	CALLEXEC	ReplyMsg	; The send message back.
	cmpi.l	#GADGETDOWN,IClass	; Is this a colour gadget?
	bne.s	.WhileInputs		; No, loop...
	move.l	IAddress,a0
	move.w	gg_GadgetID(a0),CurrCol	; Else change colour number.
	move.w	CurrCol,d0
	move.w	FirstCol,d1		; Calculate colour offsets.
	lsl.w	#1,d0
	lsl.w	#1,d1
	lea	WorkTable,a3
	move.w	(a3,d1),(a3,d0)		; Copy colour from source to dest.
	move.l	InputScreen,a0
	lea	sc_ViewPort(a0),a0
	lea	WorkTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Update screen colours.
	move.l	InputPort,a0
	lea	WorkTable,a1
	move.w	NumCols,d0
	CALLGRAF	LoadRGB4	; Update ViewPort colours.
	bsr	NewColourNB		; Then update the display.
	rts

		section	ProgStuff,data
InputVectors:
	dc.l	HandleSpread,HandleExchg,HandleCopy
	dc.l	HandleCancel,HandleUndo,HandleOkay
ReturnCode:
	dc.l	0
ReqMsgPort:
	dc.l	0	; Where to render all output.
ReqRastPort:
	dc.l	0	; Where to get input messages.
InputPort:
	dc.l	0	; Users Viewport.
InputScreen:
	dc.l	0	; Users Screen.
NumCols:
	dc.w	0	; Number of colours in our viewport.
CurrCol:
	dc.w	0	; Current colour being edited.
FirstCol:
	dc.w	0	; Used for copy, exchange & spread operations.
WindowPtr:
	dc.l	0	; Pointer to window.  (We're not a real requester!)
IAddress:
	dc.l	0	; Data from input message...
IClass	dc.l	0
Exit:
	dc.w	0	; Exit flag
BackupTable:
	ds.w	32	; Table of backup colour values.
CancelTable:
	ds.w	32	; Backup of initial colour values, in case of CANCEL.
WorkTable:
	ds.w	32	; Used for copy, spread, and exchange functions.
PaletteWindow:
	dc.w	0,0,320,64
	dc.b	0,1
	dc.l	(GADGETUP!GADGETDOWN!MOUSEMOVE),(SIMPLE_REFRESH!NOCAREREFRESH!RMBTRAP!ACTIVATE)
	dc.l	Gadget1,0,0,0,0
	dc.w	0,0,320,64,CUSTOMSCREEN
Gadget1:
	dc.l	Gadget3
	dc.w	4,38,50,11,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	GadgetBorder,0,Gadget2Text,0,0
	dc.w	36
	dc.l	0
Gadget3:
	dc.l	Gadget4
	dc.w	117,38,50,11,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	GadgetBorder,0,Gadget3Text,0,0
	dc.w	37
	dc.l	0
Gadget4:
	dc.l	Gadget5
	dc.w	4,50,50,11,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	GadgetBorder,0,Gadget4Text,0,0
	dc.w	38
	dc.l	0
Gadget5:
	dc.l	Gadget6
	dc.w	60,38,50,11,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	GadgetBorder,0,Gadget5Text,0,0
	dc.w	39
	dc.l	0
Gadget6:
	dc.l	RedGadget
	dc.w	117,50,50,11,GADGHCOMP,RELVERIFY,BOOLGADGET
	dc.l	GadgetBorder,0,Gadget6Text,0,0
	dc.w	40
	dc.l	0
RedGadget:
	dc.l	GreenGadget
	dc.w	17,4,150,10,GADGHCOMP,FOLLOWMOUSE,PROPGADGET
	dc.l	RedKnob,0,0,0,RedInfo
	dc.w	32
	dc.l	0
GreenGadget:
	dc.l	BlueGadget
	dc.w	17,15,150,10,GADGHCOMP,FOLLOWMOUSE,PROPGADGET
	dc.l	GreenKnob,0,0,0,GreenInfo
	dc.w	33
	dc.l	0
BlueGadget:
	dc.l	Colour1Gadget
	dc.w	17,26,150,10,GADGHCOMP,FOLLOWMOUSE,PROPGADGET
	dc.l	BlueKnob,0,0,0,BlueInfo
	dc.w	34
	dc.l	0
Gadget2Text:
	dc.b	0,1,RP_JAM1
	dc.w	5,2
	dc.l	0,Gadget2String,0
Gadget3Text:
	dc.b	0,1,RP_JAM1
	dc.w	8,2
	dc.l	0,Gadget3String,0
Gadget4Text:
	dc.b	0,1,RP_JAM1
	dc.w	1,2
	dc.l	0,Gadget4String,0
Gadget5Text:
	dc.b	0,1,RP_JAM1
	dc.w	10,2
	dc.l	0,Gadget5String,0
Gadget6Text:
	dc.b	0,1,RP_JAM1
	dc.w	9,2
	dc.l	0,Gadget6String,0
RedKnob:
	ds.b	ig_SIZEOF
GreenKnob:
	ds.b	ig_SIZEOF
BlueKnob:
	ds.b	ig_SIZEOF
RedInfo:
	dc.w	(AUTOKNOB!FREEHORIZ)
	dc.w	0,0,$1000,MAXBODY
	dc.w	0,0,0,0,0,0
BlueInfo:
	dc.w	(AUTOKNOB!FREEHORIZ)
	dc.w	0,0,$1000,MAXBODY
	dc.w	0,0,0,0,0,0
GreenInfo:
	dc.w	(AUTOKNOB!FREEHORIZ)
	dc.w	0,0,$1000,MAXBODY
	dc.w	0,0,0,0,0,0
Gadget2String:
	dc.b	"EXCHG",0
	even
Gadget3String:
	dc.b	"COPY",0
	even
Gadget4String:
	dc.b	"CANCEL",0
	even
Gadget5String:
	dc.b	"UNDO",0
	even
Gadget6String:
	dc.b	"OKAY",0
	even
Border1:
	dc.w	1,1
	dc.b	0,1,RP_JAM1,5
	dc.l	Array1,Border2
Border2:
	dc.w	169,1
	dc.b	0,1,RP_JAM1,5
	dc.l	Array2,Border3
Border3:
	dc.w	171,3
	dc.b	0,1,RP_JAM1,5
	dc.l	Array3,Border4
Border4:
	dc.w	171,16
	dc.b	0,1,RP_JAM1,5
	dc.l	Array4,0
Array1:
	dc.w	0,0,168,0,168,61,0,61,0,0
Array2:
	dc.w	0,0,149,0,149,61,0,61,0,0
Array3:
	dc.w	0,0,145,0,145,10,0,10,0,0
Array4:
	dc.w	0,0,145,0,145,11,0,11,0,0
Text1:
	dc.b	0,1,RP_JAM1
	dc.w	187,5
	dc.l	0,String1,Text2
Text2:
	dc.b	0,1,RP_JAM1
	dc.w	6,5
	dc.l	0,String2,Text3
Text3:
	dc.b	0,1,RP_JAM1
	dc.w	6,16
	dc.l	0,String3,Text4
Text4:
	dc.b	0,1,RP_JAM1
	dc.w	6,27
	dc.l	0,String4,0
String1:
	dc.b	"Colour Palette",0
	even
String2:
	dc.b	"R",0
	even
String3:
	dc.b	"G",0
	even
String4:
	dc.b	"B",0
	even
GadgetBorder:
	dc.w	0,0
	dc.b	0,1,RP_JAM1,5
	dc.l	GadgetArray,0
GadgetArray:
	dc.w	0,0,49,0,49,10,0,10,0,0
ColourGadgetArray:
Colour1Gadget:
	dc.l	0
	dc.w	PXST+(0*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	0
	dc.l	0
Colour2Gadget:
	dc.l	0
	dc.w	PXST+(1*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	1
	dc.l	0
Colour3Gadget:
	dc.l	0
	dc.w	PXST+(2*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	2
	dc.l	0
Colour4Gadget:
	dc.l	0
	dc.w	PXST+(3*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	3
	dc.l	0
Colour5Gadget:
	dc.l	0
	dc.w	PXST+(4*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	4
	dc.l	0
Colour6Gadget:
	dc.l	0
	dc.w	PXST+(5*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	5
	dc.l	0
Colour7Gadget:
	dc.l	0
	dc.w	PXST+(6*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	6
	dc.l	0
Colour8Gadget:
	dc.l	0
	dc.w	PXST+(7*CWIDTH),PYST+(0*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	7
	dc.l	0
Colour9Gadget:
	dc.l	0
	dc.w	PXST+(0*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	8
	dc.l	0
Colour10Gadget:
	dc.l	0
	dc.w	PXST+(1*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	9
	dc.l	0
Colour11Gadget:
	dc.l	0
	dc.w	PXST+(2*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	10
	dc.l	0
Colour12Gadget:
	dc.l	0
	dc.w	PXST+(3*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	11
	dc.l	0
Colour13Gadget:
	dc.l	0
	dc.w	PXST+(4*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	12
	dc.l	0
Colour14Gadget:
	dc.l	0
	dc.w	PXST+(5*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	13
	dc.l	0
Colour15Gadget:
	dc.l	0
	dc.w	PXST+(6*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	14
	dc.l	0
Colour16Gadget:
	dc.l	0
	dc.w	PXST+(7*CWIDTH),PYST+(1*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	15
	dc.l	0
Colour17Gadget:
	dc.l	0
	dc.w	PXST+(0*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	16
	dc.l	0
Colour18Gadget:
	dc.l	0
	dc.w	PXST+(1*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	17
	dc.l	0
Colour19Gadget:
	dc.l	0
	dc.w	PXST+(2*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	18
	dc.l	0
Colour20Gadget:
	dc.l	0
	dc.w	PXST+(3*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	19
	dc.l	0
Colour21Gadget:
	dc.l	0
	dc.w	PXST+(4*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	20
	dc.l	0
Colour22Gadget:
	dc.l	0
	dc.w	PXST+(5*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	21
	dc.l	0
Colour23Gadget:
	dc.l	0
	dc.w	PXST+(6*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	22
	dc.l	0
Colour24Gadget:
	dc.l	0
	dc.w	PXST+(7*CWIDTH),PYST+(2*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	23
	dc.l	0
Colour25Gadget:
	dc.l	0
	dc.w	PXST+(0*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	24
	dc.l	0
Colour26Gadget:
	dc.l	0
	dc.w	PXST+(1*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	25
	dc.l	0
Colour27Gadget:
	dc.l	0
	dc.w	PXST+(2*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	26
	dc.l	0
Colour28Gadget:
	dc.l	0
	dc.w	PXST+(3*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	27
	dc.l	0
Colour29Gadget:
	dc.l	0
	dc.w	PXST+(4*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	28
	dc.l	0
Colour30Gadget:
	dc.l	0
	dc.w	PXST+(5*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	29
	dc.l	0
Colour31Gadget:
	dc.l	0
	dc.w	PXST+(6*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	30
	dc.l	0
Colour32Gadget:
	dc.l	0
	dc.w	PXST+(7*CWIDTH),PYST+(3*CHEIGHT),CWIDTH,CHEIGHT,GADGHNONE,GADGIMMEDIATE,BOOLGADGET
	dc.l	0,0,0,0,0
	dc.w	31
	dc.l	0
SelectedBorder:
	dc.w	0,0
	dc.b	1,0,RP_JAM1,5
	dc.l	SelectedArray,0
SelectedArray:
	dc.w	0,0,CWIDTH-1,0,CWIDTH-1,CHEIGHT-1,0,CHEIGHT-1,0,0
	end
