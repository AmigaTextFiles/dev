;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; Amos Switcher v1.0 ©1996 Dairymen Soft
; Written by Pietro Ghizzoni
; E-Mail: ghizzo@agonet.it
;


		include	'gs/Amos.gs'
		include	'exec/exec_lib.i'
		include	'exec/tasks.i'

		lea	AmosName(pc),a1
		move.l	$4,a6
		Jsr	_LVOFindTask(a6)
		tst.l	d0
		beq.s	NoEditor
	
		move.l	d0,a0			;Task Sructure Address -> A0
		move.l	TC_Userdata(a0),a5	;Amos Data Zone Address -> A5
	
		EcCalD	AMOS_WB,1		;Call the Amos To Front function
		move.w	#0,T_NoFlip(a5)		;Unlock Amos
NoEditor	Rts

AmosName	dc.b	' AMOS',0