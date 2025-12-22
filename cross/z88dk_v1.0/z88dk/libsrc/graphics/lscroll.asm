;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: lscroll(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    lscroll

                LIB     scroll_left



.lscroll
                pop     bc
                pop     ix
                push    ix
                push    bc
                ld      l,(ix+pix_y0)
                ld      h,(ix+pix_x0)
                ld      c,(ix+pix_y1)
                ld      b,(ix+pix_x1)
                ld      a,(ix+spare)    ;number of pixels 1-8
                jp      scroll_left

