
**
** to_integer:INTEGER
**
** Copyright © 1995, Guichard Damien.
**

to_integer
        move.l  #0,d0
        move.l  ($8,a1),d1
        sub.l   #1,d1
        move.l  #'0',d2
        move.l  #0,d3
        move.l  ($C,a1),a2

.loop   move.l  d0,d4
        lsl.l   #3,d0
        add.l   d4,d0
        add.l   d4,d0
        move.b  (a2)+,d3
        sub.l   d2,d3
        add.l   d3,d0
        dbra    d1,.loop

.end    rts

