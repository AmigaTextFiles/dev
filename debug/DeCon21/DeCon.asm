; New Debug Console (also can be installed as resident module)
; (c) 1995 Martin Mares, MJSoft System Software

;DEBUG	equ	1
NOSS	equ	1
SYSI	equ	1
LBSIZE	equ	80

	ifd	DEBUG
	opt	x+
	endc

	include	"ssmac.h"

				; At offset 0: ExecBase
	; IT'S DANGEROUS TO CHANGE THESE OFFSETS
	dv.l	oldtaskpri
	dv.l	intuitionbase
	dv.l	thistask
	dv.l	arg_xpos
	dv.l	arg_ypos
	dv.l	arg_width
	dv.l	arg_height
	dv.l	arg_title
	dv.l	arg_screen
	dv.l	window
	dv.l	msgport
	dv.l	iorq
	dv.l	msgport2
	dv.l	iorq2
	dv.l	inbuf		; Circular buffer holding input data
	dv.l	inbufread
	dv.l	inbufwrite
	dv.l	inbufend
	dv.l	keybuf
	dv.l	keybufend
	dv.l	signal
	dv.l	sigmask
	dv.l	oldRawPutChar
	dv.l	linebwr
	dv.l	dosbase
	dv.l	dosbase2
	dv.l	rdargs
	dbuf	sema4,SS_SIZE
	dbuf	sema5,SS_SIZE
	dbuf	linebuf,LBSIZE
	dv.l	waitingtask
	dv.w	dumpsuccess
	dv.w	stopped
	dv.l	varsize

; MAIN ENTRY POINT (if called from CLI)

	ifd	DEBUG
	move.l	4.w,a1
	move.l	ThisTask(a1),a1
	move.l	pr_GlobVec(a1),a2
	endc

	push	$204(a2)
	bsr	Main
	pop	a6
	moveq	#0,d0
	move.l	a4,d1
	beq.s	CLIRet
	lea	errfmt(pc),a0
	move.l	a0,d1
	push	a4
	move.l	sp,d2
	call	VPrintf
	addq.l	#4,sp
CLIRet	rts

; RESIDENT TAG

STKSIZE	equ	2048		; 2048 bytes of stack must be sufficient

res	dc.w	$4afc
	dc.l	res
	dc.l	endskip
	dc.b	$01		; flg
	dc.b	2		; ver
	dc.b	$00		; type
	dc.b	4		; pri
	dc.l	winname
	dc.l	idstr
	dc.l	ModStart

ModStart	mpush	d7/a2-a3/a6
	move.l	#TC_SIZE+STKSIZE,d0
	moveq	#MEMF_PUBLIC,d1
	call	exec,AllocMem
	tst.l	d0
	bne.s	ModOkay1
	moveq	#1,d7
	swap	d7
	call	Alert
	bra.s	ModDone
ModOkay1	move.l	d0,a1
	move.l	d0,a0
	lea	TC_SIZE(a0),a3
	clr.l	(a0)+
	clr.l	(a0)+
	move.w	#NT_TASK<<8+15,(a0)+
	lea	winname(pc),a2
	move.l	a2,(a0)+
	moveq	#9,d0
1$	clr.l	(a0)+
	dbf	d0,1$
	lea	STKSIZE(a3),a2
	move.l	a2,(a0)+
	move.l	a3,(a0)+
	move.l	a2,(a0)+
	moveq	#(TC_SIZE-TC_SWITCH)/2-1,d0
2$	clr.w	(a0)+
	dbf	d0,2$
	lea	ModTaskEntry(pc),a2
	sub.l	a3,a3
	call	AddTask
ModDone	mpop	d7/a2-a3/a6
Return1	rts

ModTaskEntry	bsr.s	Main
	move.l	a4,d0
	beq.s	Return1
	move.l	#AN_Unknown+$440000,d7
	move.b	(a4),d7
	jump	exec,Alert

; MAIN PROGRAM

Main	moveq	#varsize/4-1,d0
clrvars	clr.l	-(sp)
	dbf	d0,clrvars
	move.l	sp,a5
	move.l	sp,a3			; A3=var write index
	lea	safeplace(pc),a0
	move.l	a5,(a0)

	move.l	4.w,a6
	move.l	a6,(a3)+

	move.l	ThisTask(a6),a1
	moveq	#15,d0
	call	SetTaskPri
	move.l	d0,(a3)+

	lea	unaop1(pc),a4
	lea	intuiname(pc),a1
	call	OldOpenLibrary
	move.l	d0,(a3)+
	beq	cle1

	move.l	ThisTask(a6),a0
	move.l	a0,(a3)+
	cmp.b	#NT_PROCESS,LN_TYPE(a0)
	bne.s	NoCliArgs
	move.l	pr_GlobVec(a0),a2
	move.l	$204(a2),a6
	put.l	a6,dosbase
	lea	templ(pc),a0
	move.l	a0,d1
	move.l	a3,d2
	moveq	#0,d3
	call	ReadArgs
	lea	invarg(pc),a4
	put.l	d0,rdargs
	beq	cle2

NoCliArgs	clr.l	-(sp)
	lea	tags(pc),a1
	moveq	#1,d0
	ror.l	#1,d0	; TAG_USER
	pea	winname(pc)
	move.b	(a1)+,d0
	push	d0
NoCliArgs1	move.b	(a1)+,d0
	beq.s	NoCliArgs2
	move.l	(a3)+,d1
	beq.s	NoCliArgs1
	move.l	d1,a6
	push	(a6)
	push	d0
	bra.s	NoCliArgs1

NoCliArgs2	move.b	(a1)+,d0
	beq.s	NoCliArgs3
	move.l	(a3)+,d1
	beq.s	NoCliArgs2
	push	d1
	push	d0
	bra.s	NoCliArgs2

NoCliArgs3	pea	(IDCMP_CLOSEWINDOW).w
	move.b	(a1)+,d0
	push	d0
	pea	(WFLG_DRAGBAR+WFLG_DEPTHGADGET+WFLG_SIZEGADGET+WFLG_CLOSEGADGET).w
	move.b	(a1)+,d0
	push	d0
	moveq	#16,d1		; Window limits: [16,16]--[inf,inf]
	push	d1
	move.b	(a1)+,d0
	push	d0
	push	d1
	addq.b	#1,d0
	push	d0
	moveq	#-1,d1
	push	d1
	addq.b	#1,d0
	push	d0
	push	d1
	addq.b	#1,d0
	push	d0
	move.b	(a1)+,d0	; REFRESH mode
	push	d1
	push	d0

	sub.l	a0,a0
	move.l	sp,a1
	call	intuition,OpenWindowTagList
	move.l	a5,sp
	lea	nowin(pc),a4
	move.l	d0,(a3)+
	beq	cle3
	move.l	d0,a0
	move.l	wd_UserPort(a0),a0
	moveq	#1,d7
	move.b	MP_SIGBIT(a0),d0
	lsl.l	d0,d7

	move.l	(v),a6
	lea	outofmem(pc),a4
	call	CreateMsgPort
	move.l	d0,(a3)+
	beq	cle4
	move.l	d0,a0
	moveq	#IOSTD_SIZE,d0
	call	CreateIORequest
	move.l	d0,(a3)+
	beq	cle5

	call	CreateMsgPort
	move.l	d0,(a3)+
	beq	cle5a
	move.l	d0,a0
	move.b	MP_SIGBIT(a0),d0
	bset	d0,d7
	moveq	#IOSTD_SIZE,d0
	call	CreateIORequest
	move.l	d0,(a3)+
	beq	cle5b

	get.l	iorq,a1
	lea	conname(pc),a0
	get.l	window,IO_DATA(a1)
	moveq	#CONU_SNIPMAP,d0
	moveq	#0,d1
	call	OpenDevice
	lea	unacon(pc),a4
	tst.l	d0
	bne	cle6
	get.l	iorq,a0
	get.l	iorq2,a1
	move.l	IO_DEVICE(a0),IO_DEVICE(a1)
	move.l	IO_UNIT(a0),IO_UNIT(a1)

	moveq	#64,d0
	lsl.l	#8,d0			; Char buffer: 16K
	move.l	#MEMF_PUBLIC+MEMF_CLEAR,d1
	move.l	d0,d2
	call	AllocVec
	lea	outofmem(pc),a4
	move.l	d0,(a3)+
	beq	cle7
	move.l	d0,(a3)+
	move.l	d0,(a3)+
	add.l	d2,d0
	move.l	d0,(a3)+

	moveq	#126,d0			; Key buffer: 126B
	moveq	#MEMF_PUBLIC,d1
	call	AllocVec
	move.l	d0,(a3)+
	beq	cle8
	moveq	#126,d1
	add.l	d0,d1
	move.l	d1,(a3)+

	moveq	#-1,d0
	call	AllocSignal
	lea	nosig(pc),a4
	move.l	d0,(a3)+
	bmi	cle8
	moveq	#1,d5			; D5=sigmask of "ring" signal
	lsl.l	d0,d5
	move.l	d5,(a3)+
	or.l	d5,d7

	geta	sema4,a0		; S4 locks the buffer
	call	InitSemaphore
	geta	sema5,a0		; S5 maintains caller queue
	lea	sema5addr(pc),a1
	move.l	a0,(a1)
	call	InitSemaphore

	lea	myRawPutChar(pc),a2
	move.l	a2,d0
	move.l	a6,a1
	lea	(_LVORawPutChar).w,a0
	call	SetFunction
	move.l	d0,(a3)+

	geta	linebuf,a0
	move.l	a0,(a3)
	bsr	SendReadIO
	bset	#12,d7

MainLoop	move.l	d7,d0
	call	Wait
	sub.l	a2,a2
	btst	#12,d0
	bne	TryQuit
	and.l	d5,d0
	beq.s	MainLoopI

MainLoopRR	tsv.b	stopped
	bne.s	MainLoopI
	geta	sema4,a0
	call	ObtainSemaphore
	vmovem.l inbuf,d2/a2-a4		; D2=buf,A2=r,A3=w,A4=bufend
	sub.l	a0,a0
	cmp.l	a2,a3
	beq.s	MainLoopD
	geta	linebuf,a0
	lea	LBSIZE(a0),a1
MLW1	move.b	(a2)+,d0
	cmp.l	a2,a4
	bne.s	MLW2
	move.l	d2,a2
MLW2	move.b	d0,(a0)+
	cmp.l	a0,a1
	beq.s	MLWP
	cmp.b	#32,d0
	bcs.s	MLWP
	cmp.l	a2,a3
	bne.s	MLW1
MLWP	put.l	a2,inbufread

MainLoopD	move.l	a0,a2
	get.l	waitingtask,d0
	beq.s	MainLoopE
	move.l	d0,a1
	moveq	#SIGF_BLIT,d0
	call	Signal
	clv.l	waitingtask

MainLoopE	geta	sema4,a0
	call	ReleaseSemaphore
	move.l	a2,d0
	beq.s	MainLoopI
	geta	linebuf,a0
	sub.l	a0,d0
	bsr	WriteBlock

MainLoopI	get.l	msgport2,a0
	call	GetMsg
	tst.l	d0
	beq.s	MainLoopZ
	push	a2
	bsr	ProcessInput
	pop	a2
	bsr	SendReadIO
	sub.l	a0,a0		; Deselect currently selected text
	moveq	#0,d0
	bsr	WriteBlock
	bra.s	MainLoopI

MainLoopZ	get.b	stopped,d0
	vcmp.b	stopped+1,d0
	beq.s	MainLoopZ1
	put.b	d0,stopped+1
	bra	MainLoopRR
MainLoopZ1	move.l	a2,d0
	bne	MainLoopRR

MainLoopR	get.l	window,a0
	move.l	wd_UserPort(a0),a0
	call	GetMsg
	tst.l	d0
	beq	MainLoop
	move.l	d0,a1
	move.l	im_Class(a1),d2
	call	ReplyMsg
	rol.w	#7,d2	; IDCMP_CLOSEWINDOW = $200
	bcc.s	MainLoopR

TryQuit	call	Forbid			; Deinstall the patch
	lea	myRawPutChar(pc),a0
	cmp.l	_LVORawPutChar+2(a6),a0
	beq.s	DeInstOK
	call	Permit
DeInstFail	sub.l	a0,a0
	call	intuition,DisplayBeep
	move.l	(v),a6
	bra	MainLoop
DeInstOK	move.l	a6,a1
	lea	(_LVORawPutChar).w,a0
	get.l	oldRawPutChar,d0
	call	SetFunction
	get.l	waitingtask,d0
	beq.s	DeInst1
	move.l	d0,a1
	moveq	#SIGF_SINGLE,d0
	call	Signal
DeInst1	put.l	a6,waitingtask	; Signal "finishing"
	geta	sema5,a0
	call	ObtainSemaphore
	call	Permit		; No-one is inside the patches

	get.l	iorq2,a1
	call	AbortIO
	get.l	iorq2,a1
	call	WaitIO

	sub.l	a4,a4		; OK

cle9	get.l	signal,d0
	move.l	(v),a6
	call	FreeSignal
cle8	get.l	inbuf,a1
	move.l	(v),a6
	call	FreeVec
	get.l	keybuf,a1
	call	FreeVec
cle7	get.l	iorq,a1
	move.l	(v),a6
	call	CloseDevice
cle6	get.l	iorq2,a0
	move.l	(v),a6
	call	DeleteIORequest
cle5b	get.l	msgport2,a0
	move.l	(v),a6
	call	DeleteMsgPort
cle5a	get.l	iorq,a0
	move.l	(v),a6
	call	DeleteIORequest
cle5	get.l	msgport,a0
	move.l	(v),a6
	call	DeleteMsgPort
cle4	get.l	window,a0
	call	intuition,CloseWindow
cle3	get.l	rdargs,d1
	beq.s	cle2
	call	dos,FreeArgs
cle2	get.l	intuitionbase,a1
	move.l	(v),a6
	call	CloseLibrary
cle1	move.l	(v),a6
	move.l	ThisTask(a6),a1
	get.l	oldtaskpri,d0
	call	SetTaskPri
	lea	varsize(sp),sp
GCEnd	rts

WriteBlock	get.l	iorq,a1
	move.w	#CMD_WRITE,IO_COMMAND(a1)
	movem.l	d0/a0,IO_LENGTH(a1)	; +IO_DATA
	jump	DoIO

SendReadIO	get.l	iorq2,a1
	move.w	#CMD_READ,IO_COMMAND(a1)
	vmovem.l keybuf,d0/d1
	sub.l	d0,d1
	move.l	d0,IO_DATA(a1)
	move.l	d1,IO_LENGTH(a1)
	jump	SendIO

ProcessInput	get.l	iorq2,a0
	move.l	IO_DATA(a0),a2
	move.l	IO_ACTUAL(a0),d2
	add.l	a2,d2
In1	cmp.l	d2,a2
	bcc.s	GCEnd
	move.b	(a2)+,d0
	cmp.b	#'W'-'@',d0
	beq.s	CallDump
	cmp.b	#'S'-'@',d0
	beq.s	InXOFF
	cmp.b	#'Q'-'@',d0
	beq.s	InXON
	cmp.b	#12,d0
	bne.s	In1
InCls	lea	cls(pc),a0
	moveq	#1,d0
	bsr.s	WriteBlock
	get.l	inbufread,a0
	vcmp.l	inbuf,a0
	bne.s	InCls1
	get.l	inbufend,a0
InCls1	sf	-(a0)
	bra.s	In1
CallDump	clv.l	dumpsuccess
	bsr.s	DumpBuf
	tsv.l	dumpsuccess
	bne.s	CD1
	sub.l	a0,a0
	call	intuition,DisplayBeep
	move.l	(v),a6
	bra.s	In1
CD1	lea	fsat(pc),a0
	moveq	#3,d0
	bsr	WriteBlock
	bra.s	In1

InXON	clv.b	stopped
	bra.s	In1
InXOFF	stv	stopped
	bra.s	In1

DumpBuf	lea	doslib(pc),a1
	call	OldOpenLibrary
	tst.l	d0
	beq.s	DumpNoDos
	move.l	d0,a6
	put.l	d0,dosbase2
	clr.l	-(sp)
	pea	DumpRout(pc)
	pea	NP_Entry
	pea	winname(pc)
	pea	NP_Name
	move.l	sp,d1
	call	CreateNewProc
	lea	20(sp),sp
	move.l	(v),a6
	tst.l	d0
	beq.s	Dump1
	moveq	#SIGF_BLIT,d0
	call	Wait
Dump1	get.l	dosbase2,a1
	jump	CloseLibrary

DumpNoDos	rts

DumpRout	move.l	safeplace(pc),a5
	geta	sema4,a0
	move.l	(v),a6
	call	ObtainSemaphore

	get.l	dosbase2,a6
	lea	outname(pc),a0
	move.l	a0,d1
	move.l	#MODE_NEWFILE,d2
	call	Open
	move.l	d0,d7
	beq.s	DumpRout2

	vmovem.l inbuf,d2/a2-a4	; D2=inbuf,A2=rd,A3=wr,A4=bufend
	move.l	a2,a1		; A1=end of current chunk
	move.l	a2,a0
	clr.l	-(sp)
Srch1	cmp.l	d2,a0
	beq.s	Srch2
	tst.b	-(a0)
	beq.s	Srch3
	cmp.l	a0,a3
	bne.s	Srch1
	bra.s	Srch3a

Srch2	push	a0
	push	a1
	move.l	a4,a1
	move.l	a4,a0
Srch4	tst.b	-(a0)
	beq.s	Srch3
	cmp.l	a0,a3
	bne.s	Srch4
	subq.l	#1,a0
Srch3	addq.l	#1,a0
Srch3a	push	a0
	push	a1

SrchCopy	pop	d3
	beq.s	DumpDone
	pop	d2
	move.l	d7,d1
	sub.l	d2,d3
	call	Write
	bra.s	SrchCopy

DumpDone	move.l	d7,d1
	get.l	dosbase2,a6
	call	Close

	stv	dumpsuccess
DumpRout2	geta	sema4,a0
	move.l	(v),a6
	call	ReleaseSemaphore
	get.l	thistask,a1
	moveq	#SIGF_BLIT,d0
	jump	Signal

myRawPutChar	mpush	a0/a6
	move.l	4.w,a6
	move.l	sema5addr(pc),a0	; The sequence before ObtainSema4
	call	ObtainSemaphore		; should be shortest possible
	mpush	d0-d1/a1-a3/a5
	move.l	safeplace(pc),a5
	tst.b	d0			; NULs are not dumped, but signalled
	beq.s	RPCSignal
RPC1	geta	sema4,a0
	call	ObtainSemaphore
	vmovem.l inbuf,d1/a0-a2
	move.l	a1,a3
	addq.l	#1,a3
	cmp.l	a2,a3
	bne.s	RPC2
	move.l	d1,a3
RPC2	cmp.l	a0,a3
	geta	sema4,a0
	beq.s	RPCWait
	move.b	d0,(a1)
	put.l	a3,inbufwrite
	call	ReleaseSemaphore
	cmp.b	#32,d0
	bcc.s	RPC3
RPCSignal	bsr.s	SignalMain
RPC3	mpop	d0-d1/a1-a3/a5
	move.l	sema5addr(pc),a0
	call	ReleaseSemaphore
	mpop	a0/a6
	rts

RPCWait	call	ReleaseSemaphore
	move.l	d0,a2
	call	Forbid
	tsv.l	waitingtask
	bne.s	RPCCancel
	put.l	ThisTask(a6),waitingtask
	moveq	#0,d0
	moveq	#SIGF_SINGLE,d1
	call	SetSignal
	bsr.s	SignalMain
	moveq	#SIGF_SINGLE,d0
	call	Wait
	call	Permit
	move.l	a2,d0
	bra.s	RPC1

RPCCancel	call	Permit
	bra.s	RPC3

SignalMain	get.l	thistask,a1
	get.l	sigmask,d0
	jump	Signal

	dc.b	'$VER: '
idstr	dc.b	'DeCon 2.1 (7.2.95) © 1995 Martin Mares',0
winname	dc.b	'Debug Console',0
errfmt	dc.b	'DeCon: %s !',10,0
unaop1	dc.b	'Unable to open ',0
intuiname	dc.b	'intuition.library',0
invarg	dc.b	'Invalid arguments',0
nowin	dc.b	'Unable to open window',0
templ	dc.b	'LEFT/N,TOP/N,WIDTH/N,HEIGHT/N,TITLE,SCREEN',0
outofmem	dc.b	'Out of memory',0
unacon	dc.b	'Unable to open ',0
conname	dc.b	'console.device',0
nosig	dc.b	'No free signals',0
doslib	dc.b	'dos.library',0
outname	dc.b	'T:Debug',0
fsat	dc.b	'OK',10
cls	dc.b	12
tags	dc.b	WA_Title-TAG_USER
	dc.b	WA_Left-TAG_USER,WA_Top-TAG_USER,WA_Width-TAG_USER
	dc.b	WA_Height-TAG_USER,0
	dc.b	WA_Title-TAG_USER,WA_PubScreenName-TAG_USER,0
	dc.b	WA_IDCMP-TAG_USER,WA_Flags-TAG_USER
	dc.b	WA_MinWidth-TAG_USER,WA_SimpleRefresh-TAG_USER
	even

safeplace	ds.l	1	; Original A5 stored here !
sema5addr	ds.l	1	; Pointer to sema5 stored here !

endskip
	end
