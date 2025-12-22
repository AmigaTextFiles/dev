
**
** index_of (c:CHARACTER; i:INTEGER):INTEGER
**
** Copyright © 1995, Guichard Damien.
**

index_of
        move.l  #0,d0
        move.w  ($6,sp),d1
        move.b  ($B,sp),d2
        move.l  ($C,a1),a2
        sub.l   #1,d1
        add.l   d1,a2
        move.l  ($8,a1),d3
        beq.s   .end
        sub.l   #1,d3

.loop   
        add.l   #1,d1
        cmp.b   (a2)+,d2
        dbeq    d3,.loop
        bne.s   .end
        move.l  d1,d0

.end    rtd     #8

