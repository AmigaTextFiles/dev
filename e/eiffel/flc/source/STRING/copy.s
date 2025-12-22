
**
** copy (other:STRING)
**
** Copyright © 1995, Guichard Damien.
**

copy
        move.l  ($4,sp),a6
        move.l  ($8,a6),d0
        move.l  ($4,a1),d1
        cmp.l   d1,d0
        ble.s   .full
        move.l  d1,d0
.full   move.l  d0,($8,a1)
        beq.s   .end
        sub.l   #1,d0
        move.l  ($C,a1),a2
        move.l  ($C,a6),a6

.loop   move.b  (a6)+,(a2)+
        dbra    d0,.loop

.end    rtd     #4

