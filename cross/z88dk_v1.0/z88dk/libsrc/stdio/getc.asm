;
;       Small C+ Library
;
;       Added to library 11/3/99 djm
;
;       char getc() read from keyboard
;



                XLIB    getc
        
                INCLUDE "#stdio.def"



.getc
        call_oz(os_in)
        ld      hl,1
        ret     c
        ld      l,a
        ret


