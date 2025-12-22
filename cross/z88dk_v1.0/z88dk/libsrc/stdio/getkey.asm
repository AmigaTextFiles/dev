;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>

                INCLUDE "#stdio.def"

                XLIB    getkey  ;Get key (Wait)


.getkey
.gkloop
        call_oz(os_in)
        jr      c,gkloop
        ld      l,a
        ld      h,0
        ret

