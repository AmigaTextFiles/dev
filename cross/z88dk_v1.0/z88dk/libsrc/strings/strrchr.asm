;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly hand optimized djm 1/3/99

        XLIB    strrchr

        INCLUDE "#z88_crt0.hdr"

.strrchr
; Optimized push bc, ld hl,0 pop bc push hl -> ld hl,0 push hl
        ld      hl,0
        push    hl
.i_3
        ld      hl,6
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
        ld      hl,6
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        ld      hl,4
        add     hl,sp
        cp      (hl)
        jp      nz,i_5  ;remember l_eq returns hl=0 if !=

;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,6
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_eq
;        ld      a,h
;        or      l
;        jp      z,i_5
        ld      hl,6
        add     hl,sp
        call    l_gint
        pop     bc
        push    hl
.i_5
        ld      hl,6
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
; Removed surplus to requirements dec hl
;        dec     hl
        jp      i_3
.i_4
;Get top int off stack optimized
; Optimized pop hl, push hl, pop bc, ret usu from return(n) if n is top 
        pop     hl
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
