;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function

        XLIB    sprintf

        INCLUDE "#z88_crt0.hdr"
                LIB  printf1
                LIB  getarg 
                XREF    smc_sgoioblk

.sprintf
        push    bc
        call    getarg
        push    hl
        ld      hl,6
        add     hl,sp
        pop     de
        ex      de,hl
        add     hl,hl
        add     hl,de
        dec     hl
        dec     hl
; Optimized pointless reloading of top integer on stack (After storage)
        pop     bc
        push    hl
        call    l_gint
        ld      (smc_pf_string),hl
; optimized ld hl,smc_sgoioblk call l_gint
        ld      hl,(smc_sgoioblk)
        push    hl
        ld      hl,2
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        dec     hl
        pop     de
        call    l_pint
        push    hl
        call    printf1
        pop     bc
        pop     bc
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
