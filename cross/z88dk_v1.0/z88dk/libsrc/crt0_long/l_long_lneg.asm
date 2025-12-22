;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_lneg



; deHL = !deHL
.l_long_lneg   
        ld a,h
        or l
        or      e
        or      d
        jr z,l_long_lneg1
        ld hl,0
        ld      de,0
        ret
.l_long_lneg1  
        inc   hl
        ret
