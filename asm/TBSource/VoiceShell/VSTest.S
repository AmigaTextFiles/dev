*************************************************
*						*
*		 (C)opyright 1992-93		*
*						*
*		  by Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*************************************************

	INCLUDE "JMPLibs.i"

	INCLUDE "XREF:exec.xref"

DVoice		set	1

TRUE:		EQU	1

		section VS_TEST,CODE

		move.l	#7,d0
		move.l	$4,a6
		lea.l	_VoiceLib,a1
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_VoiceBase
		beq	ShutDown_ERR

ShutDown1000:	closlib Voice
		clr.l	d0
		rts

ShutDown_ERR:	move.l	#-20,d0
		rts

		libnames

		end
