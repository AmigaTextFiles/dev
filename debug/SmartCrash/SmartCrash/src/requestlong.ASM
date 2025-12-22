; FILE: Source:requestlong.ASM          REV: 206 --- number requester with gadtools
; History
;  200    16th Oct 1999: all but FOLLOWMOUSE implemented and working.
;  201    Now includes bin.saver.ASM for easy bin creation.
;  206    Should be ok.
;

;	include	"Devpac:Gen.gs"

	include	"exec/types.i"
	include	"exec/memory.i"
	include	"dos/dosextens.i"
	include	"utility/hooks.i"
	include	"devices/inputevent.i"
	include "intuition/intuition.i"
	include "intuition/sghooks.i"
	include	"graphics/displayinfo.i"
	include "libraries/gadtools.i"

	include	"requestlong.i"

	include	"exec/exec_lib.i"
	include	"graphics/graphics_lib.i"
	include	"intuition/intuition_lib.i"
	include	"libraries/gadtools_lib.i"
 	include	"utility/utility_lib.i"

call	MACRO
	jsr	(_LVO\1,a6)
	ENDM

	STRUCTURE rldata,0
	APTR	rl_ExecBase
	APTR	rl_GfxBase
	APTR	rl_IntuiBase
	APTR	rl_GtBase
	APTR	rl_UtilBase
	APTR	rl_valptr
	APTR	rl_title
	ULONG	rl_flags
	APTR	rl_Screen
	APTR	rl_ScrLock
	APTR	rl_VisualInfo
	ULONG	rl_giwidth
	APTR	rl_GList
	APTR	rl_Window
	APTR	rl_IDCMPPort
	APTR	rl_numgad
	ULONG	rl_WaitMask
	STRUCT	rl_NewGad,gng_SIZEOF
	STRUCT	rl_edithook,h_SIZEOF
	STRUCT	rl_str,32
	LABEL	rldata_SIZEOF

;MAXCHARS	EQU	11		; "-2147483648"
MAXCHARS	EQU	32
;CTRL_C	EQU	1

NUMGAD01_ID	EQU	1

GIMINWIDTH	EQU	40
GLEFT	EQU	4
GTOP	EQU	4

GHEIGHT_ADD	EQU	3*2

TITLEADD	EQU	54


;TESTMODE	EQU	1


	IFD	TESTMODE

Main
	;lea	(.long,pc),a0
	;lea	(.val,pc),a1
	;moveq	#TLF_NULLTERM,d0
	;bsr	DecToLong
	;rts

	pea	$abbaf00d
	move.l	sp,a0
	lea	(.title,pc),a1
	move.l	#RLF_ALLOWHEX|RLF_INITHEX|RLF_UNSIGNED|RLF_SHOWDEF|RLF_FOLLOWMOUSE|RLF_ALLOWEMPTY,d0
;	move.l	#RLF_ALLOWHEX|RLF_INITHEX|RLF_SHOWDEF|RLF_FOLLOWMOUSE|RLF_ALLOWEMPTY,d0
;	move.l	#RLF_SHOWDEF|RLF_UNSIGNED|RLF_FOLLOWMOUSE|RLF_ALLOWEMPTY,d0
	bsr	RequestLong
	move.l	(sp)+,d1
	tst.l	d0
	beq.b	.rts
	move.l	d1,d0
.rts	rts

;.val	dc.l	0
;.long	dc.b	'$FFFFFFFF',0
;.long	dc.b	'-2147483648',0	'4294967295',0	'-1073741824',0	'3221225472',0

.title	dc.b	'Jump to...',0
	CNOP	0,2

	ELSE

	; include hunk binary saver, will
	; generate PROGDIR:requestlong.bin when run
	include	"Source:bin.saver.ASM"

	ENDC


;  IN: a0=ptr to longword
;      a1=title, can be NULL
;      d0=flags, see above
; OUT: d0=success if user entered number

RequestLong	movem.l	d1-a6,-(sp)
	moveq	#0,d7

	move.l	a0,a2
	move.l	a1,a3
	move.l	d0,d2

	; remove impossible flag combinations
	btst	#RLB_ALLOWHEX,d2
	bne.b	.hextoo
	and.w	#~RLF_INITHEX,d2
.hextoo
	move.l	(4).w,a6
	move.l	#rldata_SIZEOF,d0
	move.l	#MEMF_CLEAR,d1
	call	AllocVec
	tst.l	d0
	beq	.exit
	move.l	d0,a5
	move.l	a6,(a5)			rl_ExecBase

	move.l	a2,(rl_valptr,a5)

	move.l	a3,(rl_title,a5)
	bne.b	.title
	lea	(DefTitle,pc),a0
	move.l	a0,(rl_title,a5)
.title
	move.l	d2,(rl_flags,a5)

	lea	(GfxName,pc),a1
	moveq	#37,d0
	call	OpenLibrary
	move.l	d0,(rl_GfxBase,a5)
	beq.b	.freem
	lea	(IntuiName,pc),a1
	moveq	#37,d0
	call	OpenLibrary
	move.l	d0,(rl_IntuiBase,a5)
	beq.b	.closeg
	lea	(GtName,pc),a1
	moveq	#37,d0
	call	OpenLibrary
	move.l	d0,(rl_GtBase,a5)
	beq.b	.closei
	lea	(UtilName,pc),a1
	moveq	#37,d0
	call	OpenLibrary
	move.l	d0,(rl_UtilBase,a5)
	beq.b	.closegt

	bsr	_Sub0

	move.l	(a5),a6
	move.l	(rl_UtilBase,a5),a1
	call	CloseLibrary
.closegt	move.l	(rl_GtBase,a5),a1
	call	CloseLibrary
.closei	move.l	(rl_IntuiBase,a5),a1
	call	CloseLibrary
.closeg	move.l	(rl_GfxBase,a5),a1
	call	CloseLibrary
.freem	move.l	a5,a1
	call	FreeVec
.exit	move.l	d7,d0
	movem.l	(sp)+,d1-a6
	rts

GfxName	dc.b	'graphics.library',0
IntuiName	dc.b	'intuition.library',0
GtName	dc.b	'gadtools.library',0
UtilName	dc.b	'utility.library',0
DefTitle	dc.b	'Number',0
	CNOP	0,2

_Sub0
	move.l	(a5),a6
	sub.l	a1,a1
	call	FindTask
	move.l	(rl_IntuiBase,a5),a6
	move.l	d0,a0
	cmp.b	#NT_PROCESS,(LN_TYPE,a0)
	bne.b	.notproc

	move.l	(pr_WindowPtr,a0),d0
	beq.b	.notproc
	move.l	d0,a0
	addq.l	#1,d0
	beq.b	.notproc
	move.l	(wd_WScreen,a0),(rl_Screen,a5)
	bra.b	.gotscreen
.notproc
	sub.l	a0,a0
	call	LockPubScreen
	move.l	d0,(rl_ScrLock,a5)
	move.l	d0,(rl_Screen,a5)
	beq.b	.exit
.gotscreen

	move.l	(rl_Screen,a5),a0
	sub.l	a1,a1
	move.l	(rl_GtBase,a5),a6
	call	GetVisualInfoA
	move.l	d0,(rl_VisualInfo,a5)
	beq.b	.unlock

	bsr.b	_Sub1

.freevi	move.l	(rl_GtBase,a5),a6
	move.l	(rl_VisualInfo,a5),a0
	call	FreeVisualInfo
.unlock	move.l	(rl_IntuiBase,a5),a6
	sub.l	a0,a0
	move.l	(rl_ScrLock,a5),a1
	call	UnlockPubScreen
.exit	rts


_Sub1	move.l	(rl_GfxBase,a5),a6

	move.l	(rl_Screen,a5),a1
	lea	(sc_RastPort,a1),a1
	lea	(.somenums,pc),a0
	moveq	#SOMENUMS_LEN,d0
	call	TextLength
	moveq	#GLEFT*2+5*2,d2
	add.l	d0,d2

	move.l	(rl_title,a5),a0
	move.l	a0,a1
	moveq	#-1,d0
.len	addq.l	#1,d0
	tst.b	(a1)+
	bne.b	.len
	move.l	(rl_Screen,a5),a1
	lea	(sc_RastPort,a1),a1
	call	TextLength
	add.l	#TITLEADD,d0

	cmp.l	d2,d0
	bhi.b	.nope1
	move.l	d2,d0
.nope1	move.l	#GIMINWIDTH,d2
	cmp.l	d2,d0
	bhi.b	.nope2
	move.l	d2,d0
.nope2	move.l	d0,(rl_giwidth,a5)

	btst	#RLB_SHOWDEF,(rl_flags+3,a5)
	beq.b	.nodef

	move.l	(rl_valptr,a5),a1
	move.l	(a1),-(sp)
	move.l	sp,a1
	lea	(.putchproc,pc),a2
	lea	(rl_str,a5),a3

	lea	(.fmt_lx,pc),a0
	btst	#RLB_INITHEX,(rl_flags+3,a5)
	beq.b	.dec

	btst	#RLB_UNSIGNED,(rl_flags+3,a5)
	bne.b	.fmt

	; handle signed hex
	tst.l	(a1)
	bpl.b	.fmt
	neg.l	(a1)
	subq.l	#.fmt_lx-.fmt_lxs,a0
	bra.b	.fmt

.dec	addq.l	#.fmt_ld-.fmt_lx,a0
	btst	#RLB_UNSIGNED,(rl_flags+3,a5)
	beq.b	.fmt
	addq.l	#.fmt_lu-.fmt_ld,a0
.fmt
	move.l	(a5),a6
	call	RawDoFmt
	addq.l	#4,sp
.nodef

	move.l	(rl_GtBase,a5),a6

	move.l	(rl_Screen,a5),a0
	moveq	#0,d2
	move.b	(sc_WBorLeft,a0),d2	d2=leftbar
	moveq	#0,d3
	move.b	(sc_WBorTop,a0),d3
	move.l	(sc_Font,a0),a0
	move.w	(ta_YSize,a0),d4	d4=font y-size
	add.w	d4,d3
	addq.w	#1,d3			d3=titlebar
	; a6=gtbase
	lea	(rl_GList,a5),a0
	call	CreateContext
	tst.l	d0
	beq	.exit
	move.l	d0,a3

	lea	(EditHook,pc),a0
	move.l	a0,(rl_edithook+h_Entry,a5)
	move.l	a5,(rl_edithook+h_Data,a5)


	lea	(rl_NewGad,a5),a1
	move.l	#GLEFT<<16|GTOP,(a1)		gng_LeftEdge,gng_TopEdge,
	moveq	#-GLEFT*2,d0
	add.l	(rl_giwidth,a5),d0
	move.w	d0,(gng_Width,a1)
	addq.w	#GHEIGHT_ADD,d4
	move.w	d4,(gng_Height,a1)
	move.w	#NUMGAD01_ID,(gng_GadgetID,a1)
	add.w	d2,(gng_LeftEdge,a1)	Add offsets!
	add.w	d3,(gng_TopEdge,a1)
	;lea	(.text,pc),a0
	;move.l	a0,(gng_GadgetText,a1)
	;move.l	#PLACETEXT_ABOVE,(gng_Flags,a1)
	move.l	(rl_VisualInfo,a5),(gng_VisualInfo,a1)

	move.l	sp,d6
	clr.l	-(sp)			TAG_DONE
	pea	(rl_edithook,a5)
	pea	GTST_EditHook

	btst	#RLB_SHOWDEF,(rl_flags+3,a5)
	beq.b	.nodef2
	pea	(rl_str,a5)
	pea	GTST_String
.nodef2
	pea	(MAXCHARS).w
	pea	GTST_MaxChars
	move.l	sp,a2
	move.l	a3,a0
	moveq	#STRING_KIND,d0
	call	CreateGadgetA
	move.l	d6,sp
	move.l	d0,(rl_numgad,a5)
	beq	.freegad

	btst	#RLB_SHOWDEF,(rl_flags+3,a5)
	beq.b	.nodef3
	lea	(rl_str,a5),a0
	moveq	#-1,d0
.strlen	addq.l	#1,d0
	tst.b	(a0)+
	bne.b	.strlen
	move.l	(rl_numgad,a5),a0
	move.l	(gg_SpecialInfo,a0),a0
	move.w	d0,(si_BufferPos,a0)
.nodef3
	move.l	sp,a2
	clr.l	-(sp)			TAG_DONE
	move.l	(rl_title,a5),-(sp)
	pea	WA_Title
	move.l	(rl_Screen,a5),-(sp)
	pea	WA_CustomScreen
	move.l	(rl_GList,a5),-(sp)
	pea	WA_Gadgets
	pea	WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_SIMPLE_REFRESH|WFLG_ACTIVATE|WFLG_RMBTRAP
	pea	WA_Flags
	pea	IDCMP_CLOSEWINDOW|IDCMP_RAWKEY|STRINGIDCMP|IDCMP_REFRESHWINDOW|IDCMP_ACTIVEWINDOW|IDCMP_MOUSEBUTTONS
	pea	WA_IDCMP
	move.l	(rl_Screen,a5),a0
	ext.l	d3
	ext.l	d4
	add.l	d4,d3
	moveq	#0,d0
	move.b	(sc_WBorBottom,a0),d0
	add.l	d0,d3
	addq.l	#GTOP*2,d3
	move.l	d3,-(sp)
	pea	WA_Height
	move.l	(rl_giwidth,a5),d0
	moveq	#0,d1
	move.b	(sc_WBorLeft,a0),d1
	add.l	d1,d0
	move.b	(sc_WBorRight,a0),d1
	add.l	d1,d0
	move.l	d0,-(sp)
	pea	WA_Width

	move.l	(rl_Screen,a5),a0
	swap	d0
	or.l	d3,d0
	bsr	Center
	move.w	d0,d1
	ext.l	d1
	swap	d0
	ext.l	d0

	move.l	d1,-(sp)
	pea	WA_Top
	move.l	d0,-(sp)
	pea	WA_Left
	move.l	(rl_IntuiBase,a5),a6
	sub.l	a0,a0
	move.l	sp,a1
	call	OpenWindowTagList
	move.l	a2,sp
	move.l	d0,(rl_Window,a5)
	beq.b	.freegad

	bsr	_Sub2

	move.l	(rl_Window,a5),a0
	bsr	_StripMsg

	move.l	(rl_IntuiBase,a5),a6
	move.l	(rl_Window,a5),a0
	call	CloseWindow

.freegad	move.l	(rl_GtBase,a5),a6
	move.l	(rl_GList,a5),a0
	call	FreeGadgets

.exit	rts

.putchproc	move.b	d0,(a3)+
	rts

;.text	dc.b	'test',0

.fmt_lxs	dc.b	'-'
.fmt_lx	dc.b	'$%lx',0
.fmt_ld	dc.b	'%ld',0
.fmt_lu	dc.b	'%lu',0

.somenums	dc.b	'-2147483648®'
SOMENUMS_LEN	EQU	*-.somenums
	CNOP	0,2


; EditHook call conventions
;	A0 - struct Hook *hook
;	A1 - ULONG *msg
;	A2 - struct SGWork *sgw

EditHook	cmp.l	#SGH_KEY,(a1)
	beq.b	.key
	moveq	#0,d0
	rts

.key	movem.l	d1-d7/a0-a6,-(sp)
	move.l	(h_Data,a0),a5

	IFGT	1
	cmp.w	#EO_REPLACECHAR,(sgw_EditOp,a2)
	beq.b	.doit2
	cmp.w	#EO_INSERTCHAR,(sgw_EditOp,a2)
	bne.b	.exit2
.doit2
	cmp.b	#27,(sgw_Code+1,a2)
	bne.b	.exit2

	btst	#RLB_ESCISRETURN,(rl_flags+3,a5)
	bne.b	.escisreturn

	; ESC is cancel
	move.l	(sgw_WorkBuffer,a2),a0
	move.b	#27,(a0)+
	clr.b	(a0)+
	or.w	#SGA_END,(sgw_Actions+2,a2)
	bra.b	.exit2
.escisreturn
	and.w	#~SGA_USE,(sgw_Actions+2,a2)

	move.l	(sgw_PrevBuffer,a2),a0
	moveq	#TLF_NULLTERM,d0
	bsr.b	testvalidity
	bne.b	.beep2

	or.w	#SGA_END,(sgw_Actions+2,a2)
	bra.b	.exit2

.beep2	or.w	#SGA_BEEP,(sgw_Actions+2,a2)

.exit2
	ENDC

	IFGT	0
	cmp.w	#EO_REPLACECHAR,(sgw_EditOp,a2)
	beq.b	.doit0
	cmp.w	#EO_INSERTCHAR,(sgw_EditOp,a2)
	beq.b	.doit0
	cmp.w	#EO_BIGCHANGE,(sgw_EditOp,a2)
	bne.b	.exit0
.doit0
	move.l	(sgw_WorkBuffer,a2),a0
	moveq	#TLF_NOWHITE|TLF_NULLTERM,d0
	bsr.b	testvalidity
	beq.b	.exit0

	or.w	#SGA_BEEP,(sgw_Actions+2,a2)
	and.w	#~SGA_USE,(sgw_Actions+2,a2)
.exit0
	ENDC

	IFGT	1
	cmp.w	#EO_ENTER,(sgw_EditOp,a2)
	bne.b	.exit1

	move.l	(sgw_WorkBuffer,a2),a0
	tst.b	(a0)
	beq.b	.exit1

	move.l	(sgw_WorkBuffer,a2),a0
	moveq	#TLF_NULLTERM,d0
	bsr.b	testvalidity
	beq.b	.exit1

	or.w	#SGA_BEEP,(sgw_Actions+2,a2)
	and.w	#~SGA_END,(sgw_Actions+2,a2)
.exit1
	ENDC

	moveq	#1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts


;  IN: a0=UBYTE *
;      a2=struct SGWork *
;      a5=rldata
;      d0=TLF flags
; OUT: d0=0 if ok, <>0 if bad, ccr set
testvalidity	move.l	a1,-(sp)
	lea	(sgw_LongInt,a2),a1

	btst	#RLB_ALLOWHEX,(rl_flags+3,a5)
	bne.b	.hexer

.trydec	btst	#RLB_UNSIGNED,(rl_flags+3,a5)
	bne.b	.unsig
	bsr	DecToLong
	bra.b	.was_s
.unsig	bsr	DecToLongU
.was_s	bmi.b	.exit

.ok	moveq	#0,d0
.exit	move.l	(sp)+,a1
	rts

.hexer	move.l	d0,-(sp)
	btst	#RLB_UNSIGNED,(rl_flags+3,a5)
	bne.b	.h_unsig
	bsr	HexToLong
	bra.b	.h_was_s
.h_unsig	bsr	HexToLongU
.h_was_s	bmi.b	.h_exit
	addq.l	#4,sp			hex was ok..
	bra.b	.ok

	; hex failed, try decimal instead
.h_exit	move.l	(sp)+,d0
	bra.b	.trydec


; --------------------------------------------------------------------------
; General purpose dec & hex c-string to number conversion routines
; Support for both signed and unsigned numbers.
; Correctly handles ranges:
;   signed routines: -2147483648 to 2147483647
; unsigned routines: 0 to 4294967295
;
; Written by Harry Sintonen 3rd October 1999 in 68000 assembler.
;

	BITDEF	TL,NOWHITE,0		; don't allow whitespaces before number
	BITDEF	TL,NULLTERM,1		; number must be null terminated
	BITDEF	TL,NOHEXPREFIX,2	; hex allowed without $ or 0x prefix

;  IN: a0=UBYTE *str
;      a1=ULONG *num
;      d0=ULONG flags
; OUT: d0=Number of characters converted or -1, ccr set
HexToLongU	movem.l	d1-d6/a0,-(sp)
	moveq	#0,d1
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5

	; skip whitespaces
	btst	#TLB_NOWHITE,d0
	bne.b	.skipped
.skipwhite	move.b	(a0)+,d3
	addq.l	#1,d5
	cmp.b	#' ',d3
	beq.b	.skipwhite
	cmp.b	#9,d3
	beq.b	.skipwhite
	subq.l	#1,a0
	subq.l	#1,d5
.skipped
	; test for $ or 0x prefix
	btst	#TLB_NOHEXPREFIX,d0
	bne.b	.prefixok

	addq.l	#1,d5
	move.b	(a0)+,d3
	cmp.b	#'$',d3
	beq.b	.prefixok
	cmp.b	#'0',d3
	bne.b	.badprefix
	addq.l	#1,d5
	move.b	(a0)+,d3
	or.b	#('a'-'A'),d3
	cmp.b	#'x',d3
	bne.b	.badprefix
.prefixok

.loop	move.b	(a0)+,d3
	addq.l	#1,d5
	sub.b	#'0',d3
	bmi.b	.non_numalpha
	cmp.b	#('9'-'0'+1),d3
	blt.b	.add
	or.b	#('a'-'A'),d3
	sub.b	#('a'-'0'),d3
	bmi.b	.non_numalpha
	cmp.b	#('f'-'a'+1),d3
	bge.b	.non_numalpha
	add.b	#($a-$0),d3

.add	move.l	#$F0000000,d2
	and.l	d1,d2
	bne.b	.overflow
	asl.l	#4,d1
	add.l	d3,d1
	bcs.b	.overflow
	moveq	#1,d4
	bra.b	.loop

.non_numalpha	btst	#TLB_NULLTERM,d0
	beq.b	.allow
	tst.b	-(a0)
	bne.b	.overflow
.allow
	subq.l	#1,d5
	tst.l	d4
	bne.b	.didsome
.badprefix
.overflow	moveq	#-1,d5
	bra.b	.exit
.didsome	move.l	d1,(a1)
.exit	move.l	d5,d0
	movem.l	(sp)+,d1-d6/a0
	rts


;  IN: a0=UBYTE *str
;      a1=LONG *num
;      d0=ULONG flags
; OUT: d0=Number of characters converted or -1, ccr set
HexToLong	movem.l	d1-d6/a0,-(sp)
	moveq	#0,d1
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5

	; skip whitespaces
	btst	#TLB_NOWHITE,d0
	bne.b	.skipped
.skipwhite	move.b	(a0)+,d3
	addq.l	#1,d5
	cmp.b	#' ',d3
	beq.b	.skipwhite
	cmp.b	#9,d3
	beq.b	.skipwhite
	subq.l	#1,a0
	subq.l	#1,d5
.skipped
	; test sign
	cmp.b	#'-',(a0)
	seq	d6			; d6.b=0 -> positive, d6.b<>0 -> negative
	bne.b	.nosign
	addq.l	#1,d5
	addq.l	#1,a0
.nosign
	; test for $ or 0x prefix
	btst	#TLB_NOHEXPREFIX,d0
	bne.b	.prefixok

	addq.l	#1,d5
	move.b	(a0)+,d3
	cmp.b	#'$',d3
	beq.b	.prefixok
	cmp.b	#'0',d3
	bne.b	.badprefix
	addq.l	#1,d5
	move.b	(a0)+,d3
	or.b	#('a'-'A'),d3
	cmp.b	#'x',d3
	bne.b	.badprefix
.prefixok

.loop	move.b	(a0)+,d3
	addq.l	#1,d5
	sub.b	#'0',d3
	bmi.b	.non_numalpha
	cmp.b	#('9'-'0'+1),d3
	blt.b	.add
	or.b	#('a'-'A'),d3
	sub.b	#('a'-'0'),d3
	bmi.b	.non_numalpha
	cmp.b	#('f'-'a'+1),d3
	bge.b	.non_numalpha
	add.b	#($a-$0),d3

.add	asl.l	#4,d1
	bvc.b	.nflow
	bsr.b	.flow
.nflow	add.l	d3,d1
	bsr.b	.flow
	moveq	#1,d4
	bra.b	.loop

.flow	tst.b	d6
	beq.b	.fouch
	cmp.l	#$80000000,d1
	bls.b	.frts
	bra.b	.fxit
.fouch	cmp.l	#$7FFFFFFF,d1
	bls.b	.frts
.fxit	addq.l	#4,sp
	bra.b	.overflow

.non_numalpha	btst	#TLB_NULLTERM,d0
	beq.b	.allow
	tst.b	-(a0)
	bne.b	.overflow
.allow
	subq.l	#1,d5
	tst.l	d4
	bne.b	.didsome
.badprefix
.overflow	moveq	#-1,d5
	bra.b	.exit
.didsome	tst.b	d6
	beq.b	.nosign2
	neg.l	d1
.nosign2	move.l	d1,(a1)
.exit	move.l	d5,d0
	movem.l	(sp)+,d1-d6/a0
.frts	rts


;  IN: a0=UBYTE *str
;      a1=ULONG *num
;      d0=ULONG flags
; OUT: d0=Number of characters converted or -1, ccr set
DecToLongU	movem.l	d1-d6/a0,-(sp)
	moveq	#0,d1
	moveq	#'9'-'0'+1,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5

	btst	#TLB_NOWHITE,d0
	bne.b	.loop

.skipwhite	move.b	(a0)+,d3
	addq.l	#1,d5
	cmp.b	#' ',d3
	beq.b	.skipwhite
	cmp.b	#9,d3
	beq.b	.skipwhite
	bra.b	.goloop
.loop	move.b	(a0)+,d3
	addq.l	#1,d5
.goloop	sub.b	#'0',d3
	bmi.b	.nondec
	cmp.b	d2,d3
	bge.b	.nondec
	move.l	#$E0000000,d6
	and.l	d1,d6
	bne.b	.overflow
	move.l	d1,d6
	asl.l	#3,d1
	add.l	d6,d1
	bcs.b	.overflow
	add.l	d6,d1
	bcs.b	.overflow
	add.l	d3,d1
	bcs.b	.overflow
	moveq	#1,d4
	bra.b	.loop

.nondec	btst	#TLB_NULLTERM,d0
	beq.b	.allow
	tst.b	-(a0)
	bne.b	.overflow
.allow
	subq.l	#1,d5
	tst.l	d4
	bne.b	.didsome
.overflow	moveq	#-1,d5
	bra.b	.exit
.didsome	move.l	d1,(a1)
.exit	move.l	d5,d0
	movem.l	(sp)+,d1-d6/a0
	rts

;  IN: a0=UBYTE *str
;      a1=LONG *num
;      d0=ULONG flags
; OUT: d0=Number of characters converted or -1, ccr set
DecToLong	movem.l	d1-d7/a0-a1,-(sp)
	moveq	#0,d1
	moveq	#'9'-'0'+1,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6

	btst	#TLB_NOWHITE,d0
	beq.b	.skipwhite
	move.b	(a0)+,d4
	bra.b	.nowhite

.skipwhite	move.b	(a0)+,d4
	addq.l	#1,d6
	cmp.b	#' ',d4
	beq.b	.skipwhite
	cmp.b	#9,d4
	beq.b	.skipwhite
.nowhite	cmp.b	#'-',d4
	bne.b	.positive
	moveq	#1,d3
.loop	move.b	(a0)+,d4
	addq.l	#1,d6
.positive	sub.b	#'0',d4
	bmi.b	.nondec
	cmp.b	d2,d4
	bge.b	.nondec
	move.l	d1,d7
	asl.l	#3,d1
	bvc.b	.noflow
	bsr.b	.flow
.noflow	add.l	d7,d1
	bsr.b	.flow
	add.l	d7,d1
	bsr.b	.flow
	add.l	d4,d1
	bsr.b	.flow
	moveq	#1,d5
	bra.b	.loop

.flow	tst.l	d3
	beq.b	.fouch
	cmp.l	#$80000000,d1
	bls.b	.frts
	bra.b	.fxit
.fouch	cmp.l	#$7FFFFFFF,d1
	bls.b	.frts
.fxit	addq.l	#4,sp
	bra.b	.overflow


.nondec	btst	#TLB_NULLTERM,d0
	beq.b	.allow
	tst.b	-(a0)
	bne.b	.overflow
.allow
	subq.l	#1,d6
	tst.l	d5
	bne.b	.didsome
.overflow	moveq	#-1,d6
	bra.b	.exit
.didsome	tst.l	d3
	beq.b	.nosign
	neg.l	d1
.nosign	move.l	d1,(a1)
.exit	move.l	d6,d0
	movem.l	(sp)+,d1-d7/a0-a1
.frts	rts



; --------------------------------------------------------------------------


;  IN: a0=UBYTE *str
;      a1=ULONG *num (can be LONG too)
;      a5=rldata
;      d0=ULONG flags
; OUT: d0=Number of characters converted or -1, ccr set
StrToLong	btst	#RLB_ALLOWHEX,(rl_flags+3,a5)
	bne.b	.hexer

.trydec	btst	#RLB_UNSIGNED,(rl_flags+3,a5)
	bne	DecToLongU
	bra	DecToLong

.hexer	move.l	d0,-(sp)
	btst	#RLB_UNSIGNED,(rl_flags+3,a5)
	bne.b	.h_unsig
	bsr	HexToLong
	bra.b	.h_was_s
.h_unsig	bsr	HexToLongU
.h_was_s	bmi.b	.h_exit
	addq.l	#4,sp			hex was ok..
	rts

	; hex failed, try decimal instead
.h_exit	move.l	(sp)+,d0
	bra.b	.trydec



_StripMsg	move.l	(wd_UserPort,a0),a0
	move.l	(rl_GtBase,a5),a6
.loop	move.l	a0,-(sp)
	call	GT_GetIMsg
	move.l	(sp)+,a0
	tst.l	d0
	beq.b	.done
	move.l	d0,a1
	call	GT_ReplyIMsg
	bra.b	.loop
.done	rts


_Sub2	move.l	(rl_Window,a5),a0
	sub.l	a1,a1
	move.l	(rl_GtBase,a5),a6
	call	GT_RefreshWindow

	move.l	(rl_Window,a5),a0
	move.l	(wd_UserPort,a0),a0
	move.l	a0,(rl_IDCMPPort,a5)
	move.b	(MP_SIGBIT,a0),d0
	moveq	#1,d1
	lsl.l	d0,d1
	IFD	CTRL_C
	or.w	#SIGBREAKF_CTRL_C,d0
	ENDC
	or.l	d1,(rl_WaitMask,a5)

.mloop	move.l	(a5),a6
	move.l	(rl_WaitMask,a5),d0
	call	Wait

	IFD	CTRL_C
	sub.l	a0,a0
	and.l	#SIGBREAKF_CTRL_C,d0
	bne	.quit
	ENDC

.loop	move.l	(rl_GtBase,a5),a6
	move.l	(rl_IDCMPPort,a5),a0
	call	GT_GetIMsg
	tst.l	d0
	beq.b	.mloop
	move.l	d0,a2

	move.l	(im_Class,a2),d0
	cmp.l	#IDCMP_REFRESHWINDOW,d0
	bne.b	.skipm0
	move.l	a6,-(sp)
	move.l	(rl_Window,a5),a0
	call	GT_BeginRefresh
	move.l	(rl_Window,a5),a0
	moveq	#1,d0
	call	GT_EndRefresh
	move.l	(sp)+,a6
	bra.b	.reply
.skipm0
	move.l	d0,d1
	and.l	#IDCMP_ACTIVEWINDOW|IDCMP_MOUSEBUTTONS,d1
	beq.b	.skipm2

	move.l	(rl_numgad,a5),a0
.activate	move.l	(rl_Window,a5),a1
	movem.l	a2/a6,-(sp)
	sub.l	a2,a2
	move.l	(rl_IntuiBase,a5),a6
	call	ActivateGadget
	movem.l	(sp)+,a2/a6
	bra.b	.reply

.skipm2	cmp.l	#IDCMP_GADGETUP,d0
	bne.b	.skipm1
	move.l	(im_IAddress,a2),a0
	cmp.w	#NUMGAD01_ID,(gg_GadgetID,a0)
	bne.b	.skipg0

	btst	#RLB_ALLOWEMPTY,(rl_flags+3,a5)
	bne.b	.allow
	move.l	(gg_SpecialInfo,a0),a1
	move.l	(a1),a1			(si_Buffer,a1),a1
	tst.b	(a1)
	beq.b	.activate
.allow
.doquit	move.l	a0,-(sp)
	move.l	a2,a1
	call	GT_ReplyIMsg
	move.l	(sp)+,a0
	bra.b	.quit
.skipg0	;bra.b	.reply

.skipm1	cmp.l	#IDCMP_CLOSEWINDOW,d0
	beq.b	.doquit
.skipm3

.reply	move.l	a2,a1
	call	GT_ReplyIMsg
	bra	.loop

.quit
	IFD	CTRL_C
	move.l	a0,d0
	beq.b	.false
	ENDC
	move.l	(gg_SpecialInfo,a0),a0
	move.l	(a0),d0			(si_Buffer,a0),d0
	beq.b	.nostr

	move.l	d0,a0			a0=ptr to str
	move.l	(rl_valptr,a5),a1	a1=ptr to dest (U)LONG
	moveq	#TLF_NULLTERM,d0
	bsr	StrToLong
	spl	d7			signal ok!
.nostr
	rts



;  IN: a0=screen
;      d0=width<<16 | height
;      a5=rldata
; OUT: d0=xpos<<16 | ypos
Center2Screen	movem.l	d0-a6,-(sp)

	move.l	a0,a4			a4=screen

	clr.l	-(sp)			Rectangle
	clr.l	-(sp)

	move.l	(rl_GfxBase,a5),a6

	lea	(sc_ViewPort,a4),a0
	call	GetVPModeID

	move.l	(rl_IntuiBase,a5),a6
	move.l	d0,a0
	move.l	sp,a1
	moveq	#OSCAN_TEXT,d0
	call	QueryOverscan

	move.w	(ra_MaxX,sp),d1
	ext.l	d1
	move.w	(ra_MinX,sp),d0
	ext.l	d0
	sub.l	d0,d1
	addq.l	#1,d1

	move.w	(ra_MaxY,sp),d2
	ext.l	d2
	move.w	(ra_MinY,sp),d0
	ext.l	d0
	sub.l	d0,d2
	addq.l	#1,d2

	addq.l	#8,sp

	move.w	(sc_Width,a4),d0
	ext.l	d0
	move.w	(sc_LeftEdge,a4),d3
	cmp.l	d1,d0
	bge.b	.wge
	move.l	d0,d1
	moveq	#0,d3
.wge	ext.l	d3
	move.w	(sc_Height,a4),d0
	ext.l	d0
	move.w	(sc_TopEdge,a4),d4
	cmp.l	d2,d0
	bge.b	.hge
	move.l	d0,d2
	moveq	#0,d4
.hge	ext.l	d4

	move.w	(sp),d0			d0=width<<16 | height
	ext.l	d0
	sub.l	d0,d1
	asr.l	#1,d1
	sub.l	d3,d1

	move.w	(2,sp),d0
	ext.l	d0
	sub.l	d0,d2
	asr.l	#1,d2
	sub.l	d4,d2

	swap	d1
	move.w	d2,d1

	move.l	d1,(sp)
	movem.l	(sp)+,d0-a6
	rts


;  IN: a0=screen
;      d0=width<<16 | height
;      a5=rldata
; OUT: d0=xpos<<16 | ypos
Center	btst	#RLB_FOLLOWMOUSE,(rl_flags+3,a5)
	beq	Center2Screen
	;bra	FollowMouse

;  IN: a0=screen
;      d0=width<<16 | height
; OUT: d0=xpos<<16 | ypos

FM_YADD	EQU	6

FollowMouse	movem.l	d1-d3,-(sp)

	move.l	(sc_MouseY,a0),d3	read sc_MouseY and sc_MouseX
	move.w	d3,d2			d2.w=mousex
	swap	d3			d3.w=moysey

	move.w	d0,d1
	swap	d0
	lsr.w	#1,d1			d1.w=height/2
	lsr.w	#1,d0			d0.w=width/2

	sub.w	d0,d2			d2=xpos=mousex-width/2
	bpl.b	.pl1
	moveq	#0,d2
.pl1	sub.w	d1,d3			d3=ypos=mousey-height/2
	subq.w	#FM_YADD,d3
	bpl.b	.pl2
	moveq	#0,d3
.pl2	swap	d2
	move.w	d3,d2			d2=xpos<<16 | ypos
	move.l	d2,d0

	movem.l	(sp)+,d1-d3
	rts

	END
