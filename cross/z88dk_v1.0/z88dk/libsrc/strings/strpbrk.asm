;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly optimized by djm 1/3/99

        XLIB    strpbrk

        INCLUDE "#z88_crt0.hdr"
        LIB     strchr

.strpbrk
.i_3
        ld      hl,4
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        and     a
        jp      z,i_4

;        ld      l,(hl)
;        ld      h,0
;        ld      a,h
;        or      l
;        jp      z,i_4
;Fetch second into off stack optimized
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    hl
        ld      hl,6
        add     hl,sp
        call    l_gint
        ld      l,(hl)
        ld      h,0
        push    hl
        call    strchr
        pop     bc
        pop     bc
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,4
        add     hl,sp
;Removing ret following call l_gint
        jp      l_gint


.i_5
        ld      hl,4
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
;Removed unwanted dec hl
;        dec     hl
.i_6
        jp      i_3
.i_4
        ld      hl,0
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
