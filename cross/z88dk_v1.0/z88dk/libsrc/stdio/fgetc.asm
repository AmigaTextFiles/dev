;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; 11/3/99 Fixed for stdin

                INCLUDE "#fileio.def"
                INCLUDE "#stdio.def"
                INCLUDE "libdefs.def"




                XLIB    fgetc
                LIB     fhand_ck

;fgetc(fp)
;FILE *fp
;on stack
;return address,fp
;fp=filepointer
;

;fgetc - read byte from file - also handles stdin

.fgetc
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      a,d
        or      e
        jp      nz,fgetc1
.fgetc_abort
        ld      hl,EOF
        ret
.fgetc1
        call    fhand_ck
        jr      nz,fgetc_file
        ld      hl,stdin
        and     a
        sbc     hl,de
        jp      nz,fgetc_abort
        call_oz(os_in)
        jp      c,fgetc_abort
        ld      l,a
        ld      h,0
        ret

.fgetc_file     
        push    de
        pop     ix
        call_oz(os_gb)
        jp      c,fgetc_abort
        ld      l,a
        ld      h,0
        ret
