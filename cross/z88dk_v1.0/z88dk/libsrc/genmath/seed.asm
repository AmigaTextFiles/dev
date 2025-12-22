;
;       Small C+ Generic Math Library
;
;       Set the floating point seed
;
;
                XLIB    seed
                XREF    dstore
                XREF    fp_seed


.seed
        ld      hl,fp_seed
        jp      dstore