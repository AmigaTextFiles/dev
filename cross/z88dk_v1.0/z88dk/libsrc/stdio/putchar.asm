;
;       Small C+ Library Functions
;
;       stdio.h
;
;       August 98 djm
;
;       *** Z88 SPECIFIC ROUTINE ***
;

                INCLUDE "#stdio.def"

                XLIB    putchar    ;Print char

.putchar
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        call_oz(os_out)
        ret

