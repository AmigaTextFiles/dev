;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Midly hand optimized by djm 1/3/99

        XLIB    strcspn

        INCLUDE "#z88_crt0.hdr"
        LIB     strchr

.strcspn
; Optimized push bc, ld hl,0 pop bc push hl -> ld hl,0 push hl
        ld      hl,0
        push    hl
.i_3
        ld      hl,6
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        and     a
        jp      z,i_5

;        ld      l,(hl)
;        ld      h,0
;        ld      a,h
;        or      l
;        jp      z,i_5
        ld      hl,4
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,8
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      l,(hl)
        ld      h,0
        push    hl
        call    strchr
        pop     bc
        pop     bc
        call    l_lneg
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,1
        jp      i_6
.i_5
        ld      hl,0
.i_6
        ld      a,h
        or      l
        jp      z,i_4
;Increment int at top of stack optimised (from ++)
        pop     hl
        inc     hl
        push    hl
;Unwanted dec removed
;        dec     hl
        jp      i_3
.i_4
;Get top int off stack optimized
; Optimized pop hl, push hl, pop bc, ret usu from return(n) if n is top 
        pop     hl
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
