
**
** standard_copy (other:like Current)
**
** Copyright © 1995, Guichard Damien.
**

        include globals.i

standard_copy
        move.l  (-$4,a2),d0
        lsr.l   #2,d0
        beq.s   .end
        sub.w   #1,d0
        move.l  a1,a2
        add.l   #4,a2
        move.l  ($4,sp),a6
        add.l   #4,a6

.loop   move.l  (a6)+,(a2)+
        dbra    d0,.loop

.end    rtd     #4

