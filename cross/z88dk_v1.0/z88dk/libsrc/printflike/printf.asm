;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.49 Date: 14/3/99 
;
;       Reconstructed for the z80 Module Assembler
;       By Dominic Morris <djm@jb.man.ac.uk>

;       Small C+ Library Function

        XLIB    printf

        INCLUDE "#z88_crt0.hdr"
                LIB  printf1
                LIB  getarg 
                XREF    smc_sgoioblk

.printf
        ld      hl,0
        ld      (smc_pf_string),hl
; optimized ld hl,smc_sgoioblk inc hl (usu from array access)
; optimized ld hl,smc_sgoioblk+1 inc hl (usu from array access)
; optimized ld hl,smc_sgoioblk+1+1 call l_gint
        ld      hl,(smc_sgoioblk+1+1)
        push    hl
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
        push    hl
        call    printf1
        pop     bc
        pop     bc
        ret




; --- Start of Static Variables ---


; --- End of Compilation ---
