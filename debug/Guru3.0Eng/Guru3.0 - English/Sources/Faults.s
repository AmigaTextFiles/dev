* Faults
* SYNTAX: 
*
* By E.Lensink
* Using Devpac III
*
***********************************

	include "exec/execbase.i"
	include "exec/exec_lib.i"
	include	"libraries/dos_lib.i"
	include	"libraries/dos.i"
	
	lea		Dosname,a1
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	move.l		d0,_DOSBase
	beq		EXIT
	
	CALLDOS		Output
	move.l		d0,StdOut
	
	moveq		#0,d6
loop	moveq		#68,d0
	lea		ClearString,a0
.loop	move.b		#' ',(a0)+
	dbf		d0,.loop	

	move.l		d6,d1
	moveq		#0,d2
	move.l		#ClearString,d3
	moveq		#70,d4
	CALLDOS		Fault

	move.l		StdOut,d1
	move.l		#ClearString,d2
	moveq		#70,d3
	CALLDOS		Write
	
	addq.l		#1,d6
	cmpi.l		#500,d6
	bne		loop


	move.l		_DOSBase,a1
	CALLEXEC	CloseLibrary
	
EXIT	rts

	even
_DOSBase	dc.l	0
StdOut		dc.l	0
Dosname		dc.b	'dos.library',0
ClearString	ds.b	69
		dc.b	10	


