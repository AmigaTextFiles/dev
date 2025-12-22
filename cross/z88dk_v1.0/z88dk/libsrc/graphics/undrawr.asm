;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;


;Usage: undrawr(struct *pixels)


                INCLUDE "grafix.inc"    /* Contains fn defs */

                XLIB    undrawr
                LIB     swapgfxbk


                LIB     line_r
                LIB     respixel



.undrawr
                pop     bc
                pop     ix
                push    ix
                push    bc
                ld      e,(ix+draw_y)
                ld      d,(ix+draw_y+1)
                ld      l,(ix+draw_x)
                ld      h,(ix+draw_x+1)
                ld      ix,respixel
                call    swapgfxbk
                call    line_r
                jp      swapgfxbk

