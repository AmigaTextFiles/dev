;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: drawb(struct *pixel)
;Draw a box at x0,y0 width x1, height y1
;
;The same structure as for opening window is used!


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    drawb

                LIB     drawbox
                LIB     plotpixel
                LIB     swapgfxbk


.drawb
                pop     bc
                pop     ix      ;y
                push    ix
                push    bc
                ld      h,(ix+pix_x0)
                ld      l,(ix+pix_y0)
                ld      c,(ix+pix_y1)
                ld      b,(ix+pix_x1)
                ld      ix,plotpixel
                call    swapgfxbk
                call    drawbox
                jp      swapgfxbk

