*-------------------------------------------------------*
*		   Set up input handler			*
*-------------------------------------------------------*

StartHandler	LibBase exec
		Call	CreateMsgPort
		beq.s	.error
		move.l	d0,msgport	; save pointer to port

		move.l	d0,a0
		move.l	#IOSTD_SIZE,d0
		Call	CreateIORequest
		beq.s	.error
		move.l	d0,ioreq	; save pointer to request

		lea.l	idname,a0	; devName
		move.l	ioreq,a1	; iORequest
		moveq.l	#0,d0		; unitNumber
		moveq.l	#0,d1		; flags
		Call	OpenDevice	; open input.device!
		tst.l	d0
		bne.s	.error		; zero = success

		move.l	ioreq,a1
		move.l	#inter,IO_DATA(a1)
		move.w	#IND_ADDHANDLER,IO_COMMAND(a1)
		Call	DoIO		; Install the handler!
		tst.l	d0
		bne.s	.error		; zero = success

		move.l	#-1,d0		; report success
		move.w	#1,handler	; flag it's ok to remove handler later
		rts

.error		LibBase	exec
		tst.l	ioreq
		beq.s	.no1
		move.l	ioreq,a0
		Call	DeleteIORequest		; delete iORequest if it exists!

.no1		tst.l	msgport
		beq.s	.no2
		move.l	msgport,a0
		Call	DeleteMsgPort		; delete port if it exists!

.no2		move.l	ioreq,a1
		Call	CloseDevice		; this is safe in >V36 even if open failed!
		move.l	#0,d0			; report error
		rts

*-------------------------------------------------------*
*		 Close down input handler		*
*-------------------------------------------------------*

StopHandler	LibBase	exec
		move.l	ioreq,a1
		move.l	#inter,IO_DATA(a1)
		move.w	#IND_REMHANDLER,IO_COMMAND(a1)
		Call	DoIO		; remove the handler!

		move.l	ioreq,a1
		move.l	$4.w,a6
		Call	CloseDevice	; close input.device

		move.l	ioreq,a0
		Call	DeleteIORequest

		move.l	msgport,a0
		Call	DeleteMsgPort	; Free MsgPort
		rts

*-------------------------------------------------------*
*		Take care of input events		*
*-------------------------------------------------------*

IHandler	move.w	ie_Qualifier(a0),d0	; Get qualifiers
		btst	#IEQUALIFIERB_LEFTBUTTON,d0
		beq.s	.noleft
		move.w	#1,_Quit
.noleft		move.l	(a0),d0			; Get next event
		move.l	d0,a0
		bne.s	IHandler
		clr.l	d0	; return NULL, no events passed on!
		rts

*-------------------------------------------------------*
*		    Input Handler Data			*
*-------------------------------------------------------*

handler		dc.w	0	
_Quit		dc.w	0		; = 1 when LMB is pressed
msgport		dc.l	0		; pointer from CreateMsgPort()
ioreq		dc.l	0		; pointer from CreateIORequest()
inter		dc.l	0,0		; LN_SUCC, LN_PRED
		dc.b	NT_INTERRUPT	; LN_TYPE
		dc.b	100		; LN_PRI
		dc.l	intername	; LN_NAME
		dc.l	0		; IS_DATA
		dc.l	IHandler	; IS_CODE
intername	dc.b	"dFX Input-Handler",0
idname		dc.b	"input.device",0
		even
