;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>

                INCLUDE "#stdio.def"

                XLIB    nl      ;new line

;n() - MOve cursor to a new line scrolling if nessecary

.nl
        call_oz(gn_nln)
        ret


