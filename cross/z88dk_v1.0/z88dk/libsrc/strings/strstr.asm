;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.46 Date: 1/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function
;
;       Semis-strong hand optimization by djm 1/3/99

        XLIB    strstr

        INCLUDE "#z88_crt0.hdr"
        LIB     strlen
        LIB     strncmp

.strstr
        dec     sp
        push    bc
        push    bc
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,9
        add     hl,sp
        call    l_gint
;Optimized copy of char
        ld      a,(hl)
        pop     de
        ld      (de),a
        ld      hl,1
        add     hl,sp
        push    hl
        ld      hl,9
        add     hl,sp
        call    l_gint
        push    hl
        call    strlen
        pop     bc
        pop     de
        call    l_pint
        ld      hl,3
        add     hl,sp
        push    hl
        ld      hl,11
        add     hl,sp
        call    l_gint
        pop     de
        call    l_pint
.i_5
        ld      hl,3
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        ld      hl,0
        add     hl,sp
        cp      (hl)
        jp      nz,i_7   ; l_ne returns hl=1 if not equal

;        ld      l,(hl)
;        ld      h,0
;        push    hl
;        ld      hl,2
;        add     hl,sp
;        ld      l,(hl)
;        ld      h,0
;        pop     de
;        call    l_ne
;        ld      a,h
;        or      l
;        jp      nz,i_7

        ld      hl,3
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,9
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,5
        add     hl,sp
        call    l_gint
        push    hl
        call    strncmp
        pop     bc
        pop     bc
        pop     bc
;push hl, ld hl,0 pop de optimized
        ld      de,0
        ex      de,hl
        call    l_ne
        ld      a,h
        or      l
        jp      z,i_8   ;hl=0 already
;        jp      nz,i_7
;        ld      hl,0
;        jp      i_8
.i_7
        ld      hl,1
.i_8
        ld      a,h
        or      l
        jp      z,i_4
;        jp      i_6
;.i_3
;        jp      i_5

.i_6
        ld      hl,3
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      a,(hl)
        and     a
        jp      nz,i_5  ;i_9 jumps to i_3 which jumps to i_5
;        ld      l,(hl)
;        ld      h,0
;        ld      a,h
;        or      l
;        jp      nz,i_9
        ld      hl,0
        inc     sp
        pop     bc
        pop     bc
        ret


;.i_9
;        jp      i_3
.i_4
        ld      hl,3
        add     hl,sp
        call    l_gint
        inc     sp
        pop     bc
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
