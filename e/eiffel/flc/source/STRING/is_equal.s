
**
** is_equal (other:STRING):BOOLEAN  (inherited from ANY)
**
** Copyright © 1995, Guichard Damien.
**

is_equal
        move.l  ($4,sp),a6
        move.l  ($8,a6),d0
        cmp.l   ($8,a1),d0
        bne.s   .no
        sub.l   #1,d0
        move.l  ($C,a6),a6
        move.l  ($C,a1),a2

.loop   cmpm.b  (a2)+,(a6)+
        dbne    d0,.loop
        bne.s   .no

.yes    move.l  #-1,d0
        rtd     #4

.no     move.l  #0,d0
        rtd     #4

