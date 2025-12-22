;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: plot(struct *pixel)
;


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    plot
                LIB     swapgfxbk

                LIB     plotpixel



.plot
                pop     bc
                pop     ix      ;y
                push    ix
                push    bc
                ld      h,(ix+pix_x0)
                ld      l,(ix+pix_y0)
                call    swapgfxbk
                call    plotpixel
                jp      swapgfxbk

