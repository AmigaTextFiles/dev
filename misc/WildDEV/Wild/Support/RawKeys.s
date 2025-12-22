
	include	escape:escape.gs

Exec	MACRO
	movea.l	4.w,a6
	ENDM

Dos	MACRO
	movea.l	_DOSBase(pc),a6
	ENDM

Call	MACRO
	jsr	_LVO\1(a6)
	ENDM

	Exec
	lea.l	dosname(pc),a1
	Call	OldOpenLibrary
	move.l	d0,_DOSBase
	
	Dos
	Call	Output
	move.l	d0,_DefOut	
	move.l	d0,d1
	move.l	#HelloMessage,d2
	move.l	#HelloEnd-HelloMessage,d3
	Call	Write

Start	bsr	InitInputCatcher
MouseW1	bsr	CheckPressed
	btst	#6,$bfe001
	bne.b	MouseW1
MouseW2	bsr	CheckPressed
	btst	#6,$bfe001
	beq.b	MouseW2
	bsr	FreeInputCatcher
	
	Exec
	move.l	_DOSBase,a1
	Call	CloseLibrary

	rts

Message	dc.b	'Pressed RawKey:$'
	dc.b	'____'
Number	dc.b	10,0
Cyf	dc.b	'0123456789ABCDEF'

CheckPressed		move.w	KeyPressed(pc),d0
			bne.b	CP_Some
			rts
CP_Some		lea.l	Number(pc),a0
		lea.l	Cyf(pc),a1
		moveq.l	#3,d1
CP_WriteNumber	move.w	d0,d2
		andi.w	#$f,d2
		move.b	(a1,d2.w),-(a0)
		lsr.w	#4,d0
		dbra	d1,CP_WriteNumber
		
		Dos
		move.l	_DefOut,d1
		move.l	#Message,d2
		moveq.l	#Cyf-Message,d3
		Call	Write
		rts


FreeInputCatcher	Exec
			move.l	IIC_InputIO,d7
			beq.b	FIC_NoInpDevIO
			movea.l	d7,a1
			move.l	#INT_InputCatch,IO_DATA(a1)
			move.w	#IND_REMHANDLER,IO_COMMAND(a1)
			move.b	#IOF_QUICK,IO_FLAGS(a1)
			Call	DoIO
			movea.l	d7,a1
			Call	CloseDevice
			movea.l	d7,a0
			Call	DeleteIORequest
FIC_NoInpDevIO		move.l	IIC_MsgPort,d7
			beq.b	FIC_NoInpMsgPort
			movea.l	d7,a1
			Call	RemPort
			movea.l	d7,a0
			Call	DeleteMsgPort
FIC_NoInpMsgPort	rts

InitInputCatcher
	Exec
	Call	CreateMsgPort
	move.l	d0,IIC_MsgPort
	beq.b	IIC_Error
	movea.l	d0,a1
	move.l	d0,d7
	Call	AddPort
	movea.l	d7,a0
	moveq.l	#IOSTD_SIZE,d0
	Call	CreateIORequest
	move.l	d0,IIC_InputIO
	beq.b	IIC_Error
	movea.l	d0,a1
	move.l	d0,d7
	moveq.l	#0,d0
	lea.l	InputName,a0
	move.l	d0,d1
	Call	OpenDevice
	tst.w	d0
	bne.b	IIC_Error
	movea.l	d7,a1
	move.l	#INT_InputCatch,IO_DATA(a1)	
	move.w	#IND_ADDHANDLER,IO_COMMAND(a1)
	move.b	#IOF_QUICK,IO_FLAGS(a1)
	Call	DoIO
	tst.w	d0
	bne.b	IIC_Error
	moveq.l	#-1,d0
	rts
	
IIC_Error	moveq.l	#0,d0
		rts	
		
IIC_InputIO	dc.l	0
IIC_MsgPort	dc.l	0

InputCatchCode		clr.w	(a1)	
ICC_CheckForKey		cmp.b	#IECLASS_RAWKEY,ie_Class(a0)
			bne.b	ICC_NextEvent
			move.w	ie_Code(a0),d0
			btst	#7,d0
			bne.b	ICC_NextEvent
			move.w	d0,(a1)
ICC_NextEvent		movea.l	(a0),a0
			move.l	a0,d0
			bne.b	ICC_CheckForKey
			moveq.l	#0,d0
			rts
			
INT_InputCatch		dc.l	0,0
			dc.b	NT_INTERRUPT
			dc.b	69
			dc.l	ICName
			dc.l	KeyPressed,InputCatchCode
KeyPressed		dc.w	0

_DOSBase	dc.l	0
_DefOut		dc.l	0
ICName		dc.b	'RawKey interceptor...',0
dosname		dc.b	'dos.library',0
InputName	dc.b	'input.device',0
		dc.b	0,'$VER:'
HelloMessage	dc.b	'RawKey 1.2 (20.11.1997)',10,10
		dc.b	'Press mouse button to exit !',10,0
HelloEnd