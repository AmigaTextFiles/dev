		opt	c+,l-

;******************************
;* Wait for a signal 			*
;* © J.Tyberghein 29 sep 89	*
;******************************

SysBase			equ	4
	;ExecBase routines
_LVOOldOpenLibrary	equ	-408
_LVOCloseLibrary		equ	-414
_LVOWait					equ	-318
	;DosBase routines
_LVOOutput				equ	-60
_LVOWrite				equ	-48

CALLEXEC	macro
			move.l (SysBase).w,a6
			jsr _LVO\1(a6)
			endm

CALLDOS	macro
			move.l DosBase,a6
			jsr _LVO\1(a6)
			endm

		lea		DosLib,a1
		CALLEXEC	OldOpenLibrary
		move.l	d0,DosBase
		CALLDOS	Output
		move.l	d0,OutputHandle

		move.l	#255,d0
		CALLEXEC	Wait
		lea		Dummy,a0
		bsr		ToString
		bsr		Message

		move.l	DosBase,a1
		CALLEXEC	CloseLibrary
		rts


	;*** String length ***
	;a0 = string address
	;-> d0 = length
	;***
StrLen:
		moveq		#-1,d0
LoopSL:
		addq.l	#1,d0
		tst.b		(a0)+
		bne.s		LoopSL
		rts

	;*** Convert an int to a string ***
	;a0 = pointer
	;d0 = int
	;-> a0 = int string
	;***
ToString:
		move.w	d0,d1
		moveq		#0,d2
LoopTS:
		tst.w		d1
		beq.s		EndLTS
		ext.l		d1
		divu		#10,d1
		addq.w	#1,d2
		bra.s		LoopTS
EndLTS:
		move.b	#10,(a0,d2.w)
		move.b	#0,1(a0,d2.w)
Loop2:
		tst.w		d2
		beq.s		End2
		subq.w	#1,d2
		ext.l		d0
		divu		#10,d0
		swap		d0
		add.w		#48,d0
		move.b	d0,(a0,d2.w)
		swap		d0
		bra.s		Loop2
End2:
		rts

	;*** Put a message on the screen ***
	;a0 = message
	;***
Message:
		movem.l	a0,-(a7)
		bsr		StrLen
		movem.l	(a7)+,a0
		move.l	d0,d3
		move.l	OutputHandle,d1
		move.l	a0,d2
		CALLDOS	Write
		rts


	EVEN
DosBase:			dc.l	0
OutputHandle:	dc.l	0

	;Library names
DosLib:			dc.b	"dos.library",0
	EVEN
Dummy:			ds.b	5

	END

