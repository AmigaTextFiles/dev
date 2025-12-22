;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 11/3/99 djm ***UNTESTED***
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

                INCLUDE "#fileio.def"
                INCLUDE "libdefs.def"

                XLIB    feof
                LIB     fhand_ck        ;check filehandle for null, std*

;long ftell(fp)
;FILE *fp
;on stack
;return address,fp
;fp file handle to query for file posn
;
;Should this routine handle stdin, stdout, stderr etc and then barf?


.ftell
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        call    fhand_ck
        jr      z,ftell_error
.ftell1
        push    de
        pop     ix
        ld      a,fa_ptr
        call_oz(os_frm)
        push    bc              ;get the var into our preferred regs
        pop     hl
        ret     nc
;Error, return with zeri
.ftell_error
        ld      hl,0
        ld      d,l
        ld      e,l
        ret
