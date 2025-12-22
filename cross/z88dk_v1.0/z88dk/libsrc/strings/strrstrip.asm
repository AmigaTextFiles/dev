;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Mildly Handoptimized by djm 1/3/99

        XLIB    strrstrip

        INCLUDE "#z88_crt0.hdr"
        LIB     strlen

.strrstrip
; Optimized set first pointer (unused stack ops)
        ld      hl,4
        add     hl,sp
        call    l_gint
        push    hl
        call    strlen
        pop     bc
        push    hl

;        push    bc
;        ld      hl,6
;        add     hl,sp
;        call    l_gint
;        push    hl
;        call    strlen
;        pop     bc
;        pop     bc
;        push    hl
.i_3
;Get top int off stack optimized
        pop     hl
        push    hl
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,6
        add     hl,sp
        call    l_gint
        push    hl
;Fetch second into off stack optimized
        pop     bc
        pop     hl
        push    hl
        push    bc
        dec     hl
        pop     de
        add     hl,de
        ld      a,(hl)
        ld      hl,4
        add     hl,sp
        cp      (hl)
        jp      nz,i_5  ;not equal
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
        ld      hl,1
        jp      i_6
.i_5
        ld      hl,0
.i_6
        ld      a,h
        or      l
        jp      z,i_4
;Decrement int at top of stack (from j--)
        pop     hl
        dec     hl
        push    hl
; Removed surplus inc hl
;        inc     hl
        jp      i_3
.i_4
        ld      hl,6
        add     hl,sp
        call    l_gint
        push    hl
;Fetch second into off stack optimized
        pop     bc
        pop     hl
        push    hl
        push    bc
        pop     de
        add     hl,de
;push hl, ld hl,0 pop de optimized
;Set char to number, but not when result is used
        ld      (hl),(0 % 256)
        ld      hl,6
        add     hl,sp
        call    l_gint
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
