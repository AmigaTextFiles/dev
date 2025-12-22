;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>

                INCLUDE "#stdio.def"

                XLIB    puts    ;Print string



.puts
	pop	de	;return address
	pop	hl	;address of string..
	push	hl
	push	de
        call_oz(gn_sop)
        ret

