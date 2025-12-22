;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

                INCLUDE "#fileio.def"

                XLIB    fclose

;*fclose(fp)
;int fp
;on stack
;return address,fp
;fp=filehandle to close..


.fclose
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      a,d
        or      e
        jp      nz,fclose1      ;check to see its not null..
.fclose_abort
        ld      hl,-1           ;error!
        ret
.fclose1
        push    de
        pop     ix
        call_oz(gn_cl)
        jp      c,fclose_abort
        ld      hl,0
        ret
