;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function

;       Mildly hand optimized by djm 1/3/99

        XLIB    strchr

        INCLUDE "#z88_crt0.hdr"

.strchr
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
        ld      hl,4
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        ld      hl,2
        add     hl,sp
        cp      (hl)
        jp      nz,i_5

;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,4
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_eq
;        ld      a,h
;        or      l
;        jp      z,i_5  ; jp z means !=
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
; Removed dec hl, unneeded
;        dec     hl
.i_6
        jp      i_3
.i_4
        ld      hl,0
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
