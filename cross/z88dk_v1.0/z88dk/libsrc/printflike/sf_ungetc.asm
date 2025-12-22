;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>
;
;	Hand optimized by djm (small change!) 15/3/99

;	Small C+ Library Function

	XLIB	sf_ungetc

	INCLUDE "#z88_crt0.hdr"
        XREF    smc_sf_oldch

.sf_ungetc
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	(smc_sf_oldch),a
	ret




; --- Start of Static Variables ---


; --- End of Compilation ---
