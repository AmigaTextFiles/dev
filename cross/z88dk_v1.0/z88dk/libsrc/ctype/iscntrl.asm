;
; Small C z88 Character functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 1/3/99 djm

                XLIB    iscntrl


;iscntrl (c) char c
;return address, c

.iscntrl
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      hl,1
        cp      32
        ret     nc      ; > 32
        ld      hl,0
        ret

