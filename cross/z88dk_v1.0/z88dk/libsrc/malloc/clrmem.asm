;
;        Small C+ Library
; 
;       More Memory Functions
; 
;       Added to Small C+ 12/3/99 djm
; 
;       This one is writ by me!
; 
; 
;       void clrmem(void *addr, int size)
; 
;       Allocate memory for numsize and clear it (set to 0)
;


                XLIB    clrmem


.clrmem
        ld      hl,2
        add     hl,sp
        ld      c,(hl)  ;length
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)  ;buffer
        inc     hl
        ld      d,(hl)
        ld      a,b
        or      c
        ret     z       ;so no duff stuff!
        ld      l,e
        ld      h,d
        inc     de
        ld      (hl),0
        ldir            ;quick'n'easy
        ret
        