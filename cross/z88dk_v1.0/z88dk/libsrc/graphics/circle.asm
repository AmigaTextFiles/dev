;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: circle(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    circle

                LIB     draw_circle
                LIB     plotpixel
                LIB     swapgfxbk


.circle
                pop     bc
                pop     ix
                push    ix
                push    bc
                ld      c,(ix+pix_y0)   ;y0
                ld      b,(ix+pix_x0)   ;x0
                ld      e,(ix+pix_y1)   ;skip factor
                ld      d,(ix+pix_x1)   ;radius
                ld      ix,plotpixel
                call    swapgfxbk
                call    draw_circle
                jp      swapgfxbk

