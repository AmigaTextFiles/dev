;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                XLIB    l_uge
                LIB     l_ucmp

;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE >= HL [unsigned]
.l_uge
        call    l_ucmp
        ret     nc
        dec     hl
        ret

