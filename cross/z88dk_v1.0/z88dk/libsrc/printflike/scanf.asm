;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>

;	Small C+ Library Function

	XLIB	scanf

	INCLUDE "#z88_crt0.hdr"
        LIB     scanf1
        LIB     getarg
        XREF    smc_sf_string1
        XREF    smc_sgoioblk

.scanf
	ld	hl,0
	ld	(smc_sf_string1),hl
; optimized ld hl,smc_sgoioblk call l_gint
	ld	hl,(smc_sgoioblk)
	push	hl
	call	getarg
	push	hl
	ld	hl,6
	add	hl,sp
	pop	de
	ex	de,hl
	add	hl,hl
	add	hl,de
	dec	hl
	dec	hl
	push	hl
	call	scanf1
	pop	bc
	pop	bc
	ret




; --- Start of Static Variables ---


; --- End of Compilation ---
