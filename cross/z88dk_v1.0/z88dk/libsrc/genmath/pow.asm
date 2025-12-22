;	Small C+ Math Library
;	Compiled C hence the size! 

	XLIB	pow
	LIB	log
	LIB	exp

	XREF	dload
	XREF	dpush
	XREF	dmul

.pow 
	ld	hl,8
	add	hl,sp
	call	dload
	call	dpush
	call	log
	pop	bc
	pop	bc
	pop	bc
	call	dpush
	ld	hl,8
	add	hl,sp
	call	dload
	call	dmul
	call	dpush
	call	exp
	pop	bc
	pop	bc
	pop	bc
	ret


	

	DEFVARS ASMPC
{
}

; --- End of Compilation ---
