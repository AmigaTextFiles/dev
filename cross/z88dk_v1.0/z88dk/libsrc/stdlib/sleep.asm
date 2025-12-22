;
; Small C z88 Misc functions
;
; sleep(time)
;
; Pause for time seconds

		INCLUDE "#time.def"

                XLIB    sleep

;sleep(int time);


.sleep
        pop     hl
        pop     bc      ;number of seconds..
        push    bc
        push    hl
.sleep1
        ld      a,b
        or      c
        jr      z,sleep3
        push    bc
        ld      bc,100
        call_oz(os_dly)
        jr      c,sleep2
        pop     bc
        dec     bc
        jr      sleep1
;Normal exit
.sleep3
        ld      hl,0    ;NULL
        ret
;Abortive exit
.sleep2
        pop     bc
        ld      hl,1
        ret

