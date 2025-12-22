
	include	exec/exec_lib.i
	include	wildinc.gs
	include	wild/wild.i

Call	MACRO
	jsr	_LVO\1(a6)
	ENDM
	
Exec	MACRO
	movea.l	4.w,a6
	ENDM

Wi	MACRO
	movea.l	_WILDBase,a6
	ENDM
	
	Exec
	lea.l	wildname,a1
	jsr	_LVOOldOpenLibrary(a6)
	move.l	d0,_WILDBase
	beq	exit
	
	bsr	Go

exit	Exec
	movea.l	_WILDBase,a1
	move.l	a1,d0
	beq.b	.nwi
.nwi	jsr	_LVOCloseLibrary(a6)
	moveq.l	#0,d0
	rts
	
wildname	dc.b	'wild.library',0
_WILDBase	dc.l	0
WApp		dc.l	0
AppTags		dc.l	0

ThreadTags	dc.l	WITH_Entry,siso
		dc.l	WITH_Args,$12345678	; Don't need args, but put something.
		dc.l	WITH_Priority,-100
		dc.l	0

siso	movea.l	4.w,a6
	movea.l	wt_WildPort(a5),a0
	Call	GetMsg
	move.w	#$0c00,$dff106
	move.w	$dff006,$dff182
	tst.l	d0
	beq.b	siso
	rts

Go	bsr	SetUpWildApp

	move.l	WApp,a0
	lea.l	ThreadTags,a1
	Wi
	Call	AddWildThread
	move.l	d0,d7
	
	move.l	wi_DOSBase(a6),a6
	moveq.l	#20,d1
	Call	Delay
	
	Wi	
	move.l	d7,a0
	Call	RemWildThread


	bsr	KillWildApp
	rts

SetUpWildApp	Exec
		Call	CreateMsgPort
		tst.l	d0
		bne.b	.msgok
		rts
.msgok		Wild
		movea.l	d0,a0
		lea.l	AppTags,a1
		Call	AddWildApp
		move.l	d0,WApp
		rts

KillWildApp	Wild
		move.l	WApp,d0
		bne.b	.okwa
		rts
.okwa		movea.l	d0,a0
		move.l	wap_WildPort(a0),d2
		Call	RemWildApp
		Exec
		move.l	d2,a0
		Call	DeleteMsgPort
		rts
