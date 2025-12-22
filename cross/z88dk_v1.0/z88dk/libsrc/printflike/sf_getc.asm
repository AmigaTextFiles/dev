;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>
;
;       Mildy hand optimized by djm 15/3/99
;
;       Small C+ Library Function

        XLIB    sf_Getc

        INCLUDE "#z88_crt0.hdr"
        LIB     fgetc
        XDEF    smc_sf_oldch
        XDEF    smc_sf_string1

.sf_getc
        dec     sp
        ld      hl,smc_sf_oldch
; Optimized char x != -1 jp z,i_3
        ld      a,(hl)
        cp      -1
;       ld      hl,0
        jp      z,i_3
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,smc_sf_oldch
;Optimized copy of char
        ld      a,(hl)
        pop     de
        ld      (de),a
;       smc_sf_oldch = char -1
        ld      a,-1
        ld      (smc_sf_oldch),a
        ld      hl,0
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        inc     sp
        ret


.i_3
        ld      hl,(smc_sf_string1)
        ld      a,h
        or      l
        jp      z,i_5
        ld      hl,0
        add     hl,sp
        push    hl
        ld      hl,(smc_sf_string1)
        inc     hl
        ld      (smc_sf_string1),hl
        dec     hl
        ld      a,(hl)
        pop     de
        ld      (de),a
        and     a
        jp      z,i_6
        ld      l,a
        ld      h,0
        inc     sp
        ret


.i_6
        ld      hl,(smc_sf_string1)
        dec     hl
        ld      (smc_sf_string1),hl
        ld      hl,-1
        inc     sp
        ret


.i_7
        jp      i_8
.i_5
        ld      hl,3
        add     hl,sp
        call    l_gint
        push    hl
        call    fgetc
        pop     bc
        inc     sp
        ret


.i_8
.i_4
        inc     sp
        ret




; --- Start of Static Variables ---

.smc_sf_string1 defs    2
.smc_sf_oldch   defs    1

; --- End of Compilation ---
