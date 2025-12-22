;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly handoptimized by djm 1/3/99

        XLIB    strupr

        INCLUDE "#z88_crt0.hdr"
        LIB     toupper

.strupr
        push    bc
        ld      hl,4
        add     hl,sp
        call    l_gint
        pop     bc
        push    hl
.i_3
;Get top int off stack optimized
        pop     hl
        push    hl
        push    hl
;Fetch second into off stack optimized
        pop     bc
        pop     hl
        push    hl
        push    bc
        ld      l,(hl)
        ld      h,0
        push    hl
        call    toupper
        pop     bc
        pop     de
        ld      a,l
        ld      (de),a
        and     a
        jp      z,i_4
;        ld      a,h
;        or      l
;        jp      z,i_4
;Increment int at top of stack optimised (from ++)
        pop     hl
        inc     hl
        push    hl
;Removed surplus dec hl
;        dec     hl
        jp      i_3
.i_4
        ld      hl,4
        add     hl,sp
        call    l_gint
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
