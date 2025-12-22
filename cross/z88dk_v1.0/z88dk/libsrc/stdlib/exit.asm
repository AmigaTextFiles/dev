;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;Exit routine, rewritten 27/11/98 so to traverse the atexit stack

                XLIB    exit    ;outta here!

                XREF    cleanup
;                XREF    prog_atexitrout
                XREF    exitsp
                XREF    exitcount
                XREF    l_dcal


;This also allows for an atexit function to print a bye bye message
;or whatever... - no parameters are passed into it...

.exit
        ld      a,(exitcount)
        and     a
        jp      z,cleanup       ;nothing to clean up on stack
;Now, traverse the atexit routines in reverse ordr
        ld      b,a
.exit1
        push    bc
        dec     b               ;so calc correct offset
        ld      l,b
        ld      h,0
        add     hl,hl           ;x2
        ld      de,(exitsp)     ;start of atexit stack
        add     hl,de
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        call    l_dcal  ;jp(hl)
        pop     bc
        djnz    exit1
        jp      cleanup


        





IF ARCHAIC
.exit
        ld      hl,(prog_atexitrout)
        ld      a,h
        or      l
        jp      z,cleanup
        ld      de,cleanup      ;system clean up address
        push    de
        jp      (hl)
ENDIF
