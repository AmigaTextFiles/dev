		INCLUDE	"pv_lib.i"

		move.l	(4).w,a6
		lea		PPName(pc),a1
		jsr		_LVOOldOpenLibrary(a6)
		tst.l		d0
		beq.s		EndIt
		move.l	d0,PPLib
		move.l	d0,a6
		jsr		_LVOPP_InitPortPrint(a6)
		tst.l		d0
		beq.s		EndClose
		move.l	d0,PPPort
	;test
		moveq		#5,d1
Loop:
		move.l	#500000,d0
Loop2:
		subq.l	#1,d0
		bne.s		Loop2
		move.l	PPLib(pc),a6
		move.l	PPPort(pc),a0
		lea		Text(pc),a1
		jsr		_LVOPP_Print(a6)
		dbra		d1,Loop
		move.l	PPPort(pc),a0
		jsr		_LVOPP_DumpRegs(a6)
		move.l	PPPort(pc),a0
		jsr		_LVOPP_StopPortPrint(a6)
EndClose:
		move.l	PPLib(pc),a1
		move.l	(4).w,a6
		jsr		_LVOCloseLibrary(a6)
EndIt:
		rts

PPLib:	dc.l	0
PPPort:	dc.l	0
PPName:	dc.b	"powervisor.library",0
Text:		dc.b	"This is a test",10,0

		END

