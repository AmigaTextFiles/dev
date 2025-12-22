;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: draw(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    draw
                LIB     swapgfxbk

                LIB     line
                LIB     plotpixel



.draw
                pop     bc
                pop     ix
                push    ix
                push    bc
                ld      l,(ix+pix_y0)
                ld      h,(ix+pix_x0)
                ld      e,(ix+pix_y1)
                ld      d,(ix+pix_x1)
                ld      ix,plotpixel
                call    swapgfxbk
                call    line
                jp      swapgfxbk

