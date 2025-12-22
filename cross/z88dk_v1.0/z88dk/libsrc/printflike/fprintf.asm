;       Fprintf - integer version
;       20 October 1998 djm
;       Compiled C - Hand optimized..



                XLIB fprintf

                LIB  printf1
                LIB  l_sxt
                XREF pf_string
                XREF pf_count

.fprintf
        ld      hl,0
        ld      (pf_string),hl
        call    l_sxt   ;sign extend a..
        ex      de,hl   ;into de
        ld      hl,2
        add     hl,sp
        ex      de,hl   ;hl=number of word arguments
        add     hl,hl
        add     hl,de   ;address of first argument+2
        dec     hl
        ld      d,(hl)
        dec     hl
        ld      e,(hl)  ;fp
        push    de
        dec     hl
        dec     hl
        push    hl      ;addy of format strinh
        call    printf1
        pop     bc
        pop     bc
        ret


