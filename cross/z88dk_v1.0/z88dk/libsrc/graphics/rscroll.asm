;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;

;       The function scroll_right does not exist - needs to be written!


;Usage: rscroll(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    rscroll

                LIB     scroll_right



.rscroll
                pop     bc
                pop     ix
                push    ix
                push    bc
                ld      l,(ix+pix_y0)
                ld      h,(ix+pix_x0)
                ld      c,(ix+pix_y1)
                ld      b,(ix+pix_x1)
                ld      a,(ix+spare)    ;number of pixels 1-8
                jp      scroll_right

