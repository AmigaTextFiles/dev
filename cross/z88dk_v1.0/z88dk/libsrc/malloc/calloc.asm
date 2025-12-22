;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.48e Date: 11/3/99 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>

;	Small C+ Library Function

	XLIB	calloc

	INCLUDE "#z88_crt0.hdr"
                LIB     malloc
                LIB     clrmem

.calloc
	push	bc
	push	bc
	ld	hl,6
	add	hl,sp
	call	l_gint
	push	hl
	ld	hl,10
	add	hl,sp
	call	l_gint
	pop	de
	call	l_mult
	pop	bc
	push	hl
	ld	hl,0
	add	hl,sp
	call	l_gint
	push	hl
	call	malloc
	pop	bc
	pop	de
	pop	bc
	push	hl
	push	de
	ld	a,h
	or	l
	jp	z,i_3
	ld	hl,2
	add	hl,sp
	call	l_gint
	push	hl
	ld	hl,2
	add	hl,sp
	call	l_gint
	push	hl
	call	clrmem
	pop	bc
	pop	bc
.i_3
	ld	hl,2
	add	hl,sp
	call	l_gint
	pop	bc
	pop	bc
	ret




; --- Start of Static Variables ---


; --- End of Compilation ---
