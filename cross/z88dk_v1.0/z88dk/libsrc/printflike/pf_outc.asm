;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>

;	Small C+ Library Function

	XLIB	pf_outc

	INCLUDE "#z88_crt0.hdr"
                LIB     fputc

.pf_outc
	ld	hl,(smc_pf_string)
	ld	a,h
	or	l
	jp	nz,i_3
	ld	hl,4
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,4
	add	hl,sp
	call	l_gint
	push	hl
	call	fputc
	pop	bc
	pop	bc
	jp	i_4
.i_3
	ld	hl,(smc_pf_string)
	inc	hl
	ld	(smc_pf_string),hl
	dec	hl
	push	hl
	ld	hl,6
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	pop	de
	ld	a,l
	ld	(de),a
.i_4
	ld	hl,(smc_pf_count)
	inc	hl
	ld	(smc_pf_count),hl
	ret




; --- Start of Static Variables ---


; --- End of Compilation ---
