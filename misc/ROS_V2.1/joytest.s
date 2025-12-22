**
**	$VER: joytest.s 1.0 (01.11.96)
**
**	Joyport test source
**	Needs RETIRE-Operating-System Includes & Library
**	ASM-One V1.09 or later required
**
**	RETIRE Operating System (ROS) programmed by TIK/RETIRE
**	Useful ideas and hints by TODI/RETIRE
**	Thanks to PABLO/RETIRE for ROS beta testing
**


*------------------------------------------------------------------------------

	INCDIR	Include:

	INCLUDE	Exec/exec_lib.i
;	INCLUDE	Exec/memory.i
;	INCLUDE	Hardware/custom.i
;	INCLUDE	Hardware/cia.i
	INCLUDE	graphics/graphics_lib.i
	INCLUDE	intuition/intuition_lib.i
	INCLUDE	Libraries/ros.i
	INCLUDE	Libraries/ros_lib.i

*------------------------------------------------------------------------------

SourceTest	= 1			; 1=YES/0=NO
ROSVersion	= 2			; required ros.library version

*------------------------------------------------------------------------------
; CPU and chipset options, uncomment if you need it

;_CPUType	= AFB_68020		; Set the CPU type you need
;_ChipSetType	= ROSCSB_AGA		; Set the chipset (ECS or AGA) you need

_CacheBits	= CACRF_EnableI!CACRF_IBE!CACRF_EnableD!CACRF_DBE!CACRF_WriteAllocate!CACRF_CopyBack
_CacheMask	= CACRF_EnableI!CACRF_IBE!CACRF_EnableD!CACRF_DBE!CACRF_WriteAllocate!CACRF_CopyBack

*------------------------------------------------------------------------------
; The Player 6.1A options

;use		= -1		; The Usecode, uncomment to use P61A player

	IFD 	use
opt020		= 0		; 0 = MC680x0 code, 1 = MC68020+ or better
;start		= 6		; Starting position, uncomment if you need
fade		= 0		; 0 = normal, 1 = use master volume
CIA		= 1		; 0 = disabled, 1 = enabled
channels	= 4		; amount of channels to be played
jump		= 1		; 0 = do NOT include position jump code
	ENDC

*------------------------------------------------------------------------------

	printt	""
	printt	"Code options used:"
	printt	"------------------"

	IFD	_CPUType
	IF	_CPUType=AFB_68010
	printt	"CPU: 68000"
	ELSE
	IF	_CPUType=AFB_68020
	printt	"CPU: 68020"
	ELSE
	IF	_CPUType=AFB_68030
	printt	"CPU: 68030"
	ELSE
	IF	_CPUType=AFB_68040
	printt	"CPU: 68040"
	ELSE
	IF	_CPUType=AFB_68060
	printt	"CPU: 68060"
	ENDC
	ENDC
	ENDC
	ENDC
	ENDC
	ELSE
	printt	"CPU: no check"
	ENDC

	IFD	_ChipSetType
	IF	_ChipSetType=ROSCSB_AGA
	printt	"ChipSet: AGA"
	ELSE
	printt	"ChipSet: ECS"
	ENDC
	ELSE
	printt	"ChipSet: no check"
	ENDC

	printt	""

*------------------------------------------------------------------------------
;Screen constants

ScrWidth	= 40
ScrHeight	= 256
Scr		= ScrWidth*ScrHeight	; Size of the screen
Bpl		= 1			; Number of BitPlanes


*------------------------------------------------------------------------------
; The code

	SECTION	Code,CODE

	IFEQ SourceTest
	INCLUDE	misc/easystart.i	; Then the proggy runs from Workbench
	ENDC
	
PrgStart:
	moveq	#0,d0
	lea	_IntName(pc),a1
	CALLEXEC OpenLibrary
	move.l	d0,_IntuitionBase
	beq.w	.end

	moveq	#ROSVersion,d0
	lea	_ROSName(pc),a1
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,_ROSBase
	bne.b	.libok

	moveq	#0,d0
	moveq	#0,d1
	move.w	#20*8+52,d2		; req width
	move.w	#1*10+50,d3		; req height
	sub.l	a0,a0
	sub.l	a2,a2
	lea	.body(pc),a1
	lea	.neggad(pc),a3
	move.l	_IntuitionBase(pc),a6
	jsr	_LVOAutoRequest(a6)	; error requester
	bra.w	.closeint

.neggad	dc.b	0			; FrontPen
	dc.b	1			; BackPen
	dc.b	0			; DrawMode
	dc.b	0			; Fill
	dc.w	6			; LeftEdge
	dc.w	3			; TopEdge
	dc.l	0			; No special font
	dc.l	.gadtxt			; Pointer to text
	dc.l	0			; No more text

.body	dc.b	0			; FrontPen
	dc.b	1			; BackPen
	dc.b	0			; DrawMode
	dc.b	0			; Fill
	dc.w	16			; LeftEdge
	dc.w	10			; TopEdge
	dc.l	0			; No special font
	dc.l	.txt1			; Pointer to text
	dc.l	0			; No more text

.gadtxt	dc.b	"Abort",0
.txt1	dc.b	"Can't open ros.library V",ROSVersion+"0",0
	even


*--------------------------------------
.libok

	move.l	_ROSBase(pc),a6
	MOVE.L	ROS_GfxBase(a6),A6
	LEA	DTxtAttr,A0		; FontStructure-Pointer to A0
	JSR	_LVOOpenFont(A6)	; Open the font
	MOVE.L	D0,A1			; Save the Font-Pointer
	MOVE.L	34(A1),DFontPtr		; Save the RomFont-Pointer
	MOVE.W	38(A1),DFontMod		; Save The RomFont-Modulo
	JSR	_LVOCloseFont(A6)	; Close the font

	move.l	_ROSBase(pc),a6


*--------------------------------------
; set Caches

	move.l	#AllCaches,d0		; cachebits
	move.l	#AllCaches,d1		; cachemask
	jsr	_LVOROSSetCache(a6)

*--------------------------------------
; Hardware Check

	IFD	_CPUType
	move.w	#_CPUType,d0
	jsr	_LVOROSCPUCheck(a6)
	tst.w	d0
	beq.w	.close
	ENDC

	IFD	_ChipSetType
	move.w	#_ChipSetType,d0
	jsr	_LVOROSChipsetCheck(a6)	
	tst.w	d0
	beq.w	.close
	ENDC

	IFD	use
	jsr	_LVOROSAllocAudio(a6)
	tst.w	d0
	beq.w	.close
	ENDC

*--------------------------------------
; Some initializings

	move.l	#Screen1,d0		; Set plane pointers of Screen1
	lea	CopBpl,a0
	move.w	#Bpl-1,d1		; # of planes
.Loop1	move.w	d0,6(a0)
	swap	d0
	move.w	d0,2(a0)
	swap	d0
	addq.l	#8,a0
	add.l	#Scr,d0
	dbf	d1,.Loop1

*--------------------------------------
; set Playerinterrupt

	IFD	use
	lea	P61_lev6server(pc),a0

	moveq	#INTB_CIABTIMA,d0
	jsr	_LVOROSSetIntVec(a6)
	tst.w	d0
	beq.b	.timb
	move.w	#INTF_CIABTIMA,d0
	moveq	#0,d1			; indicate timer a usage
	bra.b	.ciaok

.timb	moveq	#INTB_CIABTIMB,d0
	jsr	_LVOROSSetIntVec(a6)
	tst.w	d0
	beq.w	.freeaudio
	move.w	#INTF_CIABTIMB,d0
	moveq	#1,d1			; indicate timer b usage

.ciaok	move.w	d0,_CiaIntFlag
	move.w	d1,_CiaTimer
	ENDC

*--------------------------------------
; Init-Routines

.Inits
	moveq	#0,d0
	moveq	#ROSJPA_ADDKEYS,d1
;	moveq	#ROSJPA_MOUSE,d1
	jsr	_LVOROSSetJoyPortAttrs(a6)	
	tst.w	d0
	beq.b	.afterawake

	moveq	#1,d0
	moveq	#ROSJPA_ADDKEYS,d1
;	moveq	#ROSJPA_JOYSTK,d1
;	moveq	#ROSJPA_GAMECTLR,d1
	jsr	_LVOROSSetJoyPortAttrs(a6)	
	tst.w	d0
	beq.b	.afterawake


*--------------------------------------

	lea	ExitHandler(pc),a0
	jsr	_LVOROSSetExitHandler(a6)


;	moveq	#KILLF_DEATHMODE,d0
	moveq	#KILLF_SYSMODE,d0
	jsr	_LVOROSKillSystem(a6)
	tst.w	d0
	beq.w	.afterawake

*--------------------------------------
; PlayerInit

	IFD	use
	IFD	Smpl
	lea	Smpl,a1			; Samples
	ELSE
	sub.l	a1,a1
	ENDC

	IFD	SmpBuf
	lea	SmpBuf,a2		; Sample buffer
	ENDC

	lea	Song,a0			; Module
	moveq	#0,d0			; Auto Detect
	move.w	_CiaTimer(pc),d1	; indicate timer usage
	bsr.w	P61_motuuli+P61_InitOffset
	ENDC
	
*--------------------------------------

	jsr	_LVOROSWaitVBlank(a6)
	lea	CopList1,a0
	moveq	#COPF_COPPER1!COPF_STROBE,d0
	jsr	_LVOROSSetCopper(a6)
	move.w	#DMAF_SETCLR!DMAF_MASTER!DMAF_RASTER!DMAF_COPPER,d0
	jsr	_LVOROSSetDMA(a6)

	lea	Inter(pc),a0
	moveq	#INTB_VERTB,d0
	jsr	_LVOROSSetIntVec(a6)

	lea	KeyHandler(pc),a0
	moveq	#INTB_KEYB,d0
	jsr	_LVOROSSetIntVec(a6)

	move.w	#INTF_SETCLR!INTF_INTEN!INTF_VERTB!INTF_KEYB,d0
	IFD	use
	or.w	_CiaIntFlag(pc),d0	; start P61 int
	ENDC
	jsr	_LVOROSSetInt(a6)

*--------------------------------------
; Main-Program

.MainLoop	
	jsr	_LVOROSWaitVBlank(a6)



.tstend	move.b	endflag(pc),d0
	beq.b	.MainLoop

*--------------------------------------

.done	jsr	_LVOROSWaitVBlank(a6)
	move.w	#DMAF_MASTER!DMAF_RASTER!DMAF_COPPER,d0 ; clear dma
	jsr	_LVOROSSetDMA(a6)
	move.w	#INTF_VERTB!INTF_KEYB,d0		; clear int
	IFD	use
	or.w	_CiaIntFlag(pc),d0	; stop P61 int
	ENDC
	jsr	_LVOROSSetInt(a6)

	IFD	use
	bsr.w	P61_motuuli+P61_EndOffset
	ENDC

	jsr	_LVOROSAwakeSystem(a6)
.afterawake


.freeaudio
	IFD	use
	jsr	_LVOROSFreeAudio(a6)
	ENDC


.close

.closeROS
	move.l	_ROSBase(pc),a1
	CALLEXEC CloseLibrary

.closeint
	move.l	_IntuitionBase(pc),a1
	CALLEXEC CloseLibrary

.end	moveq	#0,d0
	rts

*--------------------------------------



_ROSBase	dc.l	0
_IntuitionBase	dc.l	0

	IFD	use
_CiaTimer	dc.w	0		; P61 timer flags
_CiaIntFlag	dc.w	0
	ENDC

_ROSName	ROSNAME
_IntName	INTNAME

endflag		dc.b	0
		even

*--------------------------------------

ExitHandler:
	move.b	#1,endflag
	rts


*--------------------------------------

KeyHandler:
	move.l	d0,d1
	LEA	Screen1,A0		; Address for text on screen
	MOVE.L	#'Key ',D0		; 4 chars (label for each value)
	BSR.W	Debug			; Show both on screen
	moveq	#0,d0
	rts


*------------------------------------------------------------------------------
; Players

	IFD	use
	INCLUDE	Player/player610.2_ROS.s ; The Player 6.1a
	ENDC

*------------------------------------------------------------------------------

Inter:					; Level 3 Interrupt-Routine
; The routines every interrupt

	moveq	#0,d0
	jsr	_LVOROSReadJoyPort(a6)

	move.l	d0,d1
	LEA	Screen1+10*ScrWidth,A0	; Address for text on screen
	MOVE.L	#'JP0 ',D0		; 4 chars (label for each value)
	BSR.W	Debug			; Show both on screen

	moveq	#1,d0
	jsr	_LVOROSReadJoyPort(a6)

	move.l	d0,d1
	LEA	Screen1+20*ScrWidth,A0	; Address for text on screen
	MOVE.L	#'JP1 ',D0		; 4 chars (label for each value)
	BSR.W	Debug			; Show both on screen

	rts

*------------------------------------------------------------------------------



; Show 4 chars and a 32 bit value on screen (for debugging)
; -> A0-Address for text, D0-Display as 4 chars, D1-Display as 8 Hex-Values
; Uses A0-A2/D0-D4/D6/D7

Debug:
	MOVE.L	DFontPtr,A1		; Address of RomFont
	MOVEQ	#0,D4

	MOVEQ	#4-1,D6			; # of chars
.Char:	MOVEQ	#0,D2			; ScrWidht
	MOVEQ	#0,D3			; FontMod

	ROL.L	#8,D0			; Get first char in Low-Byte
	MOVE.B	D0,D4			; Get char in D3
	SUB.B	#32,D4			; Get position on font
	LEA	(A1,D4.W),A2		; Get address of char

	MOVEQ	#8-1,D7			; # of Char-Bytes
.Move1:	MOVE.B	(A2,D3.W),(A0,D2.W)
	ADD.W	#ScrWidth,D2		; Next line on screen
	ADD.W	DFontMod,D3		; Next byte of char
	DBF	D7,.Move1

	ADDQ.L	#1,A0			; Next position on screen
	DBF	D6,.Char


	MOVEQ	#8-1,D6			; # of values
.Value:	MOVEQ	#0,D2			; ScrWidht
	MOVEQ	#0,D3			; FontMod

	ROL.L	#4,D1			; Get first value (4 bit) in Low-Byte
	MOVE.B	D1,D4			; But get 8 bits
	AND.W	#$000F,D4		; Mask out unwanted bits
	CMP.W	#9,D4
	BHI.S	.Hex			; Use A to F for Hex-Values, jump
	ADD.B	#16,D4			; Get position in font (Value<A, hex)
	BRA.S	.Move
.Hex:	ADD.B	#23,D4			; Get position in font (Value>9)
.Move:	LEA	(A1,D4.W),A2		; Get address of char

	MOVEQ	#8-1,D7			; # of Char-Bytes
.Move2:	MOVE.B	(A2,D3.W),(A0,D2.W)
	ADD.W	#ScrWidth,D2		; Next line on screen
	ADD.W	DFontMod,D3		; Next byte of char
	DBF	D7,.Move2

	ADDQ.L	#1,A0			; Next position on screen
	DBF	D6,.Value
	RTS


DFontPtr	DC.L	0
DFontMod	DC.W	0
DTxtAttr	DC.L	DFntName
		DC.W	8
		DC.B	0
		DC.B	0
DFntName	DC.B	'topaz.font',0





*------------------------------------------------------------------------------
; Copper area

	SECTION	Copper1,DATA_C

CopList1:
CopBpl	dc.w	$00e0,0000		; bpl-pointers
	dc.w	$00e2,0000
	dc.w	$00e4,0000
	dc.w	$00e6,0000
	dc.w	$00e8,0000
	dc.w	$00ea,0000
	dc.w	$00ec,0000
	dc.w	$00ee,0000
	dc.w	$00f0,0000
	dc.w	$00f2,0000
	dc.w	$00f4,0000
	dc.w	$00f6,0000
	dc.w	$00f8,0000
	dc.w	$00fa,0000
	dc.w	$00fc,0000
	dc.w	$00fe,0000
	dc.w	$0100,Bpl<<12!$200	; bit-plane control reg.
	dc.w	$0102,$0000		; hor-scroll
	dc.w	$0104,$0010		; sprite/gfx priority
	dc.w	$01fc,$0000		; fetch mode
	dc.w	$0108,$0000		; modolu (odd)
	dc.w	$010a,$0000		; modolu (even)
	dc.w	$008e,$2c81		; screen size
	dc.w	$0090,$2cc1		; screen size
	dc.w	$0092,$0038		; h-start
	dc.w	$0094,$00d0		; h-stop
; end of initializing, and now the user-copper-data
	dc.w	$0180,$0000
	dc.w	$0182,$0eee
	dc.l	$fffffffe		; end of copperlist


*------------------------------------------------------------------------------
; Screen area

	SECTION	Screen1,BSS_C

Screen1	DS.B	Scr*Bpl			; Area for Screen1


*------------------------------------------------------------------------------
; Music area

	IFD	use

	SECTION	Music1,DATA_C	; Chipmem for entire module or for samples
				; Uncomment if you use separate samples
;Smpl	INCBIN	st-00:modules/p61a/smp.art


	IFD	Smpl
	SECTION	Music2,DATA	; If separate samples, we use fast mem for song
	ENDC
Song	INCBIN	st-00:modules/p61a/p61.art


	SECTION	Music3,BSS_C
;SmpBuf	DS.B	120000		; Uncomment if you have packed samples
				; and insert sample buffer length
	ENDC

*------------------------------------------------------------------------------

	IFEQ SourceTest
	printt	""
	printt	""
	printt	"Attention Workbench-Startup enabled"
	printt	""
	AUTO	WO\
	ENDC

*------------------------------------------------------------------------------
End:					; The end of all shit

