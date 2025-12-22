;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>

;	Small C+ Library Function

	XLIB	sscanf

	INCLUDE "#z88_crt0.hdr"
        LIB     scanf1
        LIB     getarg
        XREF    smc_sf_string1
        XREF    smc_sgoioblk

.sscanf
	push	bc
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
; Optimized pointless reloading of top integer on stack (After storage)
	pop	bc
	push	hl
	call	l_gint
	ld	(smc_sf_string1),hl
; optimized ld hl,smc_sgoioblk inc hl (usu from array access)
; optimized ld hl,smc_sgoioblk+1 inc hl (usu from array access)
; optimized ld hl,smc_sgoioblk+1+1 call l_gint
	ld	hl,(smc_sgoioblk+1+1)
	push	hl
	ld	hl,2
	add	hl,sp
	push	hl
	call	l_gint
	dec	hl
	dec	hl
	pop	de
	call	l_pint
	push	hl
	call	scanf1
	pop	bc
	pop	bc
	pop	bc
	ret




; --- Start of Static Variables ---


; --- End of Compilation ---
