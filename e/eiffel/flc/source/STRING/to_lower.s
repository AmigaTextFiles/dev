
**
** to_lower
**
** Copyright © 1995, Guichard Damien.
**

to_lower
        move.l  #%00100000,d1
        move.l  #'a',d2
        move.l  #'z',d3
        move.l  ($C,a1),a2
        move.l  ($8,a1),d0
        beq.s   .end
        sub.l   #1,d0

.loop   move.b  (a2)+,d4
        cmp.b   d4,d2
        bgt.s   .next
        cmp.b   d4,d3
        blt.s   .next
        or.b    d1,d4
        move.b  d4,(-1,a2)
.next   dbra    d0,.loop

.end    rts

