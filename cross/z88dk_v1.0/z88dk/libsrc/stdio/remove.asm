;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 30 September 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

; This doesn't check for validity of filename at all.

                INCLUDE "#fileio.def"
                INCLUDE "#stdio.def"

                XLIB    remove

;int remove(char *s1)

.remove
        pop     bc
        pop     hl      ;dest filename
        push    hl
        push    bc
        ld      b,0     ;absolute address
        call_oz(gn_del)
        ld      hl,0
        ret     nc
        dec     hl      ;=1
        ret

