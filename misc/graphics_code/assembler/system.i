 
 	include	dos/dos.i
 
	include	exec/types.i
	include 	exec/exec_lib.i
	include	exec/exec.i
	include	exec/io.i
	include	exec/libraries.i
	include	exec/lists.i
	include	exec/memory.i
	include	exec/nodes.i
	include	exec/ports.i
	include	exec/semaphores.i
	include	exec/tasks.i
	
	include	hardware/custom.i
	include	hardware/dmabits.i
	include	hardware/intbits.i
	
	include	libraries/asl.i
	include	libraries/asl_lib.i
	
	include 	libraries/dos.i
	include 	libraries/dos_lib.i
	include 	libraries/dosextens.i
	
	include	libraries/gadtools.i
	include	libraries/gadtools_lib.i

	include	libraries/iffparse.i
	include	libraries/iffparse_lib.i
	
	include	math/mathffp_lib.i
	include	math/mathtrans_lib.i

	include	devices/inputevent.i
	include	devices/timer.i

	include	graphics/clip.i
	include	graphics/copper.i
	include	graphics/gfx.i
	include	graphics/gfxnodes.i
	include	graphics/graphics_lib.i
	include	graphics/gfxbase.i
	include	graphics/layers.i
	include	graphics/layers_lib.i
	include	graphics/rastport.i
	include	graphics/text.i
	include	graphics/videocontrol.i
	include	graphics/displayinfo.i
	include	graphics/view.i

	include 	intuition/intuition.i
	include 	intuition/intuition_lib.i
	include	intuition/intuitionbase.i
	include	intuition/iobsolete.i
	include	intuition/preferences.i
	include	intuition/screens.i

	include	rexx/errors.i
	include	rexx/storage.i
	
	include	utility/tagitem.i
	include	utility/utility.i
	include	utility/utility_lib.i
	
	include	workbench/startup.i
	include	workbench/icon_lib.i
	include	workbench/workbench.i


;	custom library includes

 	include	custom/iff.i
 	include	custom/iff_lib.i
 	
OPENLIB MACRO	address of name,version no,libbase
	movea.l	(4).w,a6
	lea	\1,a1
	moveq.l	#\2,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,\3
	ENDM

CLOSELIB MACRO	libbase
 	 movea.l	(4).w,a6	
	 movea.l	\1,a1
	 jsr	_LVOCloseLibrary(a6)
	 ENDM

; Push registers contents onto stack -- use for > 3 registers only

PUSH		macro
		movem.l		\1,-(sp)
		endm

PUSHALL		macro
		PUSH		d0-d7/a0-a6
		endm
		
; Retrieve registers contents from stack

PULL		macro
		movem.l		(sp)+,\1
		endm

PULLALL		macro
		PULL		d0-d7/a0-a6
		endm
		
; fast multiply by 10

TIMES10		macro		dn
		add.l		\1,\1			x2
		move.l		\1,-(sp)
		asl.l		#2,\1			x8
		add.l		(sp),\1
		addq.l		#4,sp
		endm

; Inserts pause 

PAUSE		macro

		PUSHALL
		move.l		#\1,d0
_pause\@		subi.l		#1,d0
		bne.s		_pause\@
		PULLALL
		endm

CHECK_CLICK	macro
		btst.b		#6,$BFE001		LMB check
		endm

CHECK_SPACE	macro
		bsr	GetKey
		cmp.b	#$40,d0
		endm
		
