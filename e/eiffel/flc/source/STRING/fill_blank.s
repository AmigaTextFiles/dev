
**
** fill_blank
**
** Copyright © 1995, Guichard Damien.
**

fill_blank
        move.l  ($8,a1),d0
        beq.s   .end
        sub.l   #1,d0
        move.l  #' ',d1
        move.l  ($C,a1),a2

.loop   move.b  d1,(a2)+
        dbra    d0,.loop

.end    rts

