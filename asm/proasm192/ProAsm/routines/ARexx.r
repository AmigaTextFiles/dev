
;---;  ARexx  ;----------------------------------------------------------------
*
*	****	ARexx HANDLER ROUTINES    ****
*
*	Author		Daniel Weber
*	Version		1.12
*	Last Revision	28.12.93
*	Identifier	rxx_defined
*       Prefix		rxx_	(ARexx Routines)
*				  ¯ ¯¯
*	Functions	CreateARexxPort()	- create a valid arexx port
*			DeleteARexxPort()	- delete/remove it
*			DoARexxMsg()		- send an arexx msg and wait
*			SendARexxMsg()		- send an arexx message
*			SendFlagedARexxMsg()	- send an arexx message with flags
*			FreeARexxCommand()	- free contents of a arexx msg
*			GetARexxCommand()	- get first argument of a msg
*			CheckARexxCommand()	- check if it's a valid arexx msg
*			ReplyARexxMessage()	- returns a msg to the server
*			GetARexxArg()		- get the argument from a msg
*			GetARexxResult()	- get the result(s)
*
;------------------------------------------------------------------------------

;------------------
	IFND	rxx_defined
rxx_defined	SET	1

;------------------
rxx_oldbase	EQU	__BASE
	BASE	rxx_base
rxx_base:

;------------------
	opt	sto,o+,ow-,q+,qw-	;all optimisations on

;------------------
	incdir	include:
	incdir	routines:
;	include	"exec/types.i"		;included via rexx/storage.i
;	include	"exec/ports.i"		;"        "   "
	include	"rexx/rxslib.i"
	include	"rexx/rexxio.i"

	include	ports.r

;------------------
	IFND	MN_NODE
MN_NODE	equ	0			;value taken from 'Struct.doc'
	ENDC



;------------------------------------------------------------------------------
*
* CreateARexxPort()
*
* a0: MsgPort structure (see structure.r)
* a1: Portname
*
* => d0: MsgPort or 0 if an error is occured
*
;------------------------------------------------------------------------------
	IFD	xxx_CreateARexxPort

CreateARexxPort:
;------------------

	movem.l	d1-a6,-(a7)
	move.l	a0,a4
	move.l	4.w,a6
	jsr	-390(a6)			;findport()
	tst.l	d0
	bne.s	.out

	move.l	a4,a0
	bsr	MakePort
.out:	movem.l	(a7)+,d0-a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* DeleteARexxPort()
*
* a0: MsgPort
*
;------------------------------------------------------------------------------
	IFD	xxx_DeleteARexxPort

DeleteARexxPort:
;------------------

	movem.l	d0-a6,-(a7)
	move.l	a0,d0
	beq.s	.out
	bsr	UnMakePort
.out:	movem.l	(a7)+,d0-a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* DoARexxMsg()
*
* d0: MsgPort
* a0: Target port name
* a1: Command string
* a2: File extension (default: .rexx)
*
* => d0: (0: false/error   -: ARexxMessage)
*
;------------------------------------------------------------------------------
	IFD	xxx_DoARexxMsg
xxx_SendARexxMsg	SET	1

DoARexxMsg:
;------------------

	movem.l	d0-d1/a0-a2/a6,-(a7)
	bsr.s	SendARexxMsg
	tst.l	d0				;error occured???
	beq.s	1$
	move.l	4.w,a6
	move.l	(a7),a0				;msgport
	jsr	-384(a6)			;waitport()
1$:	movem.l	(a7)+,d0-d1/a0-a2/a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* SendARexxMsg()
* SendFlagedARexxMsg()
*
* d0: MsgPort
* (d1: command flags, for SentFlagedARexxMsg only)
* a0: target port name
* a1: command string
* a2: file extension (default: .rexx)
*
* => d0: (0: false/error   -: RexxMessage)
*
;------------------------------------------------------------------------------

	IFD	xxx_SendFlagedARexxMsg
xxx_SendARexxMsg	SET	1

SendFlagedARexxMsg:
;------------------
	movem.l	d1-a6,-(a7)
	move.l	d1,d5
	bra.s	rxx_SendARexxMsg

	ENDC


;----------------------------
	IFD	xxx_SendARexxMsg
xxx_rxx_getstrlen	SET	1

SendARexxMsg:
;------------------

	movem.l	d1-a6,-(a7)
	moveq	#0,d5			;no additional flags
;
; d5: additional command flags
;
rxx_SendARexxMsg:			;entry for SendFlagedARexxMsg
	move.l	d0,d7			;no port given
	beq	\senderror
	move.l	a1,d6			;no commandstring given
	beq	\senderror

	move.l	a0,d0			;init...
	beq	\senderror		;no target port name
	move.l	a2,d1
	bne.s	11$
	lea	rxx_rexxext(pc),a2
11$:	move.l	a2,a1			;extension
	move.l	RexxBase(pc),a6	;RexxBase		(d1)
	move.l	d7,a0			;replyport
	jsr	_LVOCreateRexxMsg(a6)
	move.l	d0,d7
	beq	\senderror
	move.l	d0,a4			;save message structure

	move.l	d6,a0
	bsr	rxx_getstrlen
	jsr	_LVOCreateArgstring(a6)
	move.l	d0,rm_Args(a4)
	beq.s	\argerror

	or.l	#RXCOMM,d5
	move.l	d5,rm_Action(a4)	;not a function

	move.l	4.w,a6
	jsr	-132(a6)		;forbid()
	lea	rxx_rexxport(pc),a1	;"REXX"
	jsr	-390(a6)		;findport()
	tst.l	d0			;no rexxport opened
	beq	\argerror2

	move.l	d0,a0			;dest. Port (REXX)
	move.l	a4,a1			;Message
	jsr	-366(a6)		;putmsg()
	jsr	-138(a6)		;permit()

	move.l	a4,d0			;message in d0
	movem.l	(a7)+,d1-a6
	rts


\argerror2:
	jsr	-138(a6)		;permit()
\argerror:
	move.l	RexxBase(pc),a6
	move.l	a4,a0
	jsr	_LVODeleteRexxMsg(a6)
\senderror:				;no...
	movem.l	(a7)+,d1-a6		;commandstring, port
	moveq	#0,d0			;or REXX-port
	rts				;found

rxx_rexxport
rxx_rexxext:
	dc.b	"REXX",0
	even

	ENDC


;--------------------------------------
;a0: string
;=> d0: length
;
	IFD	xxx_rxx_getstrlen

rxx_getstrlen:
	move.l	a0,-(a7)
	moveq	#0,d0
\loop:
	tst.b	(a0)+
	beq.s	2$
	addq.l	#1,d0
	bra.s	\loop
2$:	move.l	(a7)+,a0
	rts

	ENDC


;------------------------------------------------------------------------------
*
* FreeARexxCommand()
*
* d0: RexxMessage
*
;------------------------------------------------------------------------------
	IFD	xxx_FreeARexxCommand

FreeARexxCommand:
;------------------

	movem.l	d0-a6,-(a7)
	tst.l	d0
	beq.s	.out
	move.l	d0,a4
	move.l	RexxBase(pc),a6		;RexxBase	(d1)
	move.l	rm_Args(a4),d0
	beq.s	\noargs
	move.l	d0,a0
	jsr	_LVODeleteArgstring(a6)

\noargs:
	move.l	a4,a0
	jsr	_LVODeleteRexxMsg(a6)
.out:	movem.l	(a7)+,d0-a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* GetARexxCommand()
*
* a0: RexxMessage
*
* => d0: first argument or 0 if no message arrived...
*
;------------------------------------------------------------------------------
	IFD	xxx_GetARexxCommand

GetARexxCommand:
;------------------

	movem.l	d1-a6,-(a7)
	move.l	MN_NODE(a0),d0
	beq.s	.out
	move.l	d0,a1
	cmp.w	#NT_REPLYMSG,RRTYPE(a1)	;RRTYPE=LN_TYPE
	beq.s	\nomessage
	move.l	rm_Args(a1),d0		;first argument
.out	movem.l	(a7)+,d1-a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* CheckARexxMsg()
*
* a0: RexxMessage
*
* => d0: TRUE(-1) if it is a RexxMsg, FALSE(0) if it is not a RexxMsg
*
;------------------------------------------------------------------------------
	IFD	xxx_CheckARexxMsg

CheckARexxMsg:
;------------------

	movem.l	d1-a6,-(a7)
	move.l	a0,d0
	beq.s	\nomsg
	move.l	RexxBase(pc),a6
	jsr	_LVOIsRexxMsg(a6)	;IsRexxMsg()
\nomsq:	movem.l	(a7)+,d1-a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* ReplyARexxMessage()
*
* d0: Error# (or zero if no error)
* a0: ARexx Message
* a1: Return String (Result) [string will be doublicated by Rexx]
*
;------------------------------------------------------------------------------
	IFD	xxx_ReplyARexxMessage
xxx_rxx_getstrlen	SET	1

ReplyARexxMessage:
;------------------

	movem.l	d0-a6,-(a7)
	move.l	RexxBase(pc),a6
	move.l	a0,a4
	clr.l	rm_Result2(a4)
	move.l	d0,rm_Result1(a4)	;error?
	bne.s	.return			;yes, no further result handling
	move.l	rm_Action(a4),d0
	and.l	#RXFF_RESULT,d0		;result requeted
	beq.s	.return
	move.l	a1,d0
	beq.s	1$
	move.l	d0,a0
	bsr	rxx_getstrlen
1$:	jsr	_LVOCreateArgstring(a6)
	move.l	d0,rm_Result2(a4)
.return:
	move.l	4.w,a6
	move.l	a4,a1
	jsr	_LVOReplyMsg(a6)
	movem.l	(a7)+,d0-a6
	rts

	ENDC


;------------------------------------------------------------------------------
*
* GetARexxArg()
*
* d0: Argument number (0-15)
* a0: RexxMessage
*
* =>d0: Argument (or zero if the argument number is higher than 15!)
* =>d1: start of first argument (or zero if the arg number is higher than 15!)
*
;------------------------------------------------------------------------------
	IFD	xxx_GetARexxArg

GetARexxArg:
;------------------

	movem.l	d2-a6,-(a7)
	move.l	a0,d2
	beq.s	\noRexxMsg
	moveq	#15,d2
	cmp.l	d2,d0
	bhi.s	\noRexxMsg
	lsl.w	#2,d0
	lea.l	rm_Args(a0),a0
	move.l	(a0,d0.w),d0		;get the argument
	move.l	a0,d1			;pointer to the first arg (rm_Arg0)
	movem.l	(a7)+,d2-a6
	rts

\noRexxMsg:
	movem.l	(a7)+,d2-a6
	moveq	#0,d0
	moveq	#0,d1
	rts

	ENDC


;------------------------------------------------------------------------------
*
* GetARexxResult()
*
* d0: RexxMessage
* d1: Result number (1/2/- : Result1/Result2/Result1&2)
*
* =>d0: result_1/2
* =>d1: result_2, if the result number wasnot equal to 1 or 2
*
;------------------------------------------------------------------------------
	IFD	xxx_GetARexxResult

GetARexxResult:
;------------------

	movem.l	d2-a6,-(a7)
	tst.l	d0
	beq.s	\norexxmessage
	move.l	d0,a0
	subq.l	#1,d1
	bne.s	\Result2

\Result1:				;get the first Result...
	move.l	rm_Result1(a0),d0
	bra.s	\norexxmessage

\Result2:				;...the second Result...
	subq.l	#1,d1
	bne.s	\bothResults
	move.l	rm_Result2(a0),d0
	bra.s	\norexxmessage

\bothResults:				;... both Results!
	move.l	rm_Result1(a0),d0
	move.l	rm_Result2(a0),d1

\norexxmessage:
	movem.l	(a7)+,d2-a6
	rts


	ENDC


;--------------------------------------------------------------------

;------------------
	BASE	rxx_oldbase

;------------------
	opt	rcl

;------------------
	ENDIF

	end

