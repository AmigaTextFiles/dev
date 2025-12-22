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

;int fgetpos(FILE *fp, long *dump)
;FILE *fp
;on stack
;return address,+2=dump, +4=fp
;fp file handle to query for file posn
;
;Dumps in dump the file position, and returns 0 if all went well


.fgetpos
        ld      hl,4
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        call    fhand_ck
        jr      nz,fgetpos1
.fgetpos_err
        ld      hl,1
        ret                    ;barf together
.fgetpos1
        push    de
        pop     ix
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        push    de              ;store dumping place
        ld      a,fa_ptr
        call_oz(os_frm)
        pop     hl              ;dumping place
        jr      c,fgetpos_err   ;it all went wrong
        ld      (hl),c          ;store the file posn now
        inc     hl
        ld      (hl),b
        inc     hl
        ld      (hl),e
        inc     hl
        ld      (hl),d
        ld      hl,0            ;no errors
        ret

