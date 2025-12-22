*******************************************************************************
* Load_File:	independent module to load an entire file in memory.
* ---------
*	This routine is especially handy for ASCII text files since
*	it marks the end of your text with a LONG of 0s.
*	The returned size INCLUDES this extra LONG so that your FreeMem()
*	is straight forward.
*
*******************************************************************************

		include	std

		XREF	_DOSBase		;use Lattice's ptr to dos.library

; EXPORTS
		XDEF	_load_file

*******************************************************************************
FENCE_SPACE	equ	8			;# of $00s to add beyond EOF
*******************************************************************************

;-----------------------------------------------
; BOOL = load_file( char *filename , struct FileCache *fc );
;   D0 =              4(SP)		    8(SP)
;-----------------------------------------------

SAVED_REGS	equ	(6*4)+(5*4)		;room for MOVEM regs

_load_file	move.l	4(SP),a0		;get fname argument from stack
		movem.l	d2-d7/a2-a6,-(SP)	;push all Amiga regs
		move.l	a0,a4			;save filename

		bsr	get_file_size		;D6/D7 size,filehandle
		beq	ldfile_error		;if unable to find file: quit now
		
		add.l	#FENCE_SPACE,D6		;extra room for fence space

		move.l	4.w,a6
		move.l	d6,d0			;wanted file buffer size
		moveq	#MEMF_PUBLIC,d1		;any RAM will do.
		EXEC	AllocMem
		tst.l	d0			;did I get the file buffer?
		beq	ldfile_error		;no : FAIL !

		move.l	d0,a5			;A5 -> buffer memory

		move.l	_DOSBase,a6
		move.l	d7,d1			;file handle
		move.l	a5,d2			;-> buffer
		move.l	d6,d3			;file size +FENCE_SPACE
		sub.l	#FENCE_SPACE,d3		;adjust to pure file size
		DOS	Read			;read entire file into buffer

		lea	-FENCE_SPACE(a5,d6.L),a0  ;->> last FENCE bytes of buffer
		clr.b	(a0)+			;mark last bytes
		clr.b	(a0)+
		clr.b	(a0)+
		clr.b	(a0)+			;to delimit text
		clr.b	(a0)+
		clr.b	(a0)+
		clr.b	(a0)+
		clr.b	(a0)+

		move.l	d7,d1
		DOS	Close

		move.l	SAVED_REGS+8(SP),a0	;get ptr to FileCache struct
		move.l	a5,(a0)
		move.l	d6,4(a0)		;fill in struct

		movem.l	(SP)+,d2-d7/a2-a6
		moveq	#-1,d0
		rts

ldfile_error	movem.l	(SP)+,d2-d7/a2-a6
		moveq	#0,d0			;return FALSE
dummy		rts
;-----------------------------------------------
; A4 -> C- filename
; OPEN file, SEEK to EOF, RECORD size, SEEK back to beginning
; OUTPUT : D7 = filehandle
;	   D6 = size
;-----------------------------------------------

get_file_size	move.l	_DOSBase,a6
		move.l	a4,d1			;D1 -> filename
		move.l	#MODE_OLDFILE,d2
		DOS	Open			;open file
		move.l	d0,d7			;D7 = file handle
		req				;if Open failed: return EQ

		move.l	d7,d1
		moveq	#0,d2
		move.l	#OFFSET_END,d3		;goto EOF
		DOS	Seek			;returns old file pointer (0)

		move.l	d7,d1
		moveq	#0,d2
		move.l	#OFFSET_BEGINNING,d3	;go back to start
		DOS	Seek			;old pos (EOF) = size

		move.l	d0,d6			;record file size (return NE)
		rts		
;-----------------------------------------------
*******************************************************************************
