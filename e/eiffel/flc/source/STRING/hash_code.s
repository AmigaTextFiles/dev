
**
** hash_code:INTEGER
**
** Copyright © 1995, Guichard Damien.
**

hash_code
        move.l  #0,d0
        move.l  #0,d1
        move.l  #13,d2
        move.l  ($C,a1),a2
        move.l  ($8,a1),d3
        beq.s   .end
        sub.l   #1,d3

.loop   muls.w  d2,d0
        move.b  (a2)+,d1
        add.l   d1,d0
        dbra    d3,.loop

.end    rts

