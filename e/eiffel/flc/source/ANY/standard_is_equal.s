
**
** standard_is_equal (other:like Current):BOOLEAN
**
** Copyright © 1995, Guichard Damien.
**

        include globals.i

standard_is_equal
        move.l  (-$4,a2),d0
        lsr.l   #2,d0
        beq.s   .yes
        sub.w   #1,d0
        move.l  a1,a2
        add.l   #4,a2
        move.l  ($4,sp),a6
        add.l   #4,a6

.loop   cmpm.l  (a2)+,(a6)+
        dbne    d0,.loop
        bne.s   .no

.yes    move.l  #-1,d0
        rtd     #4

.no     move.l  #0,d0
        rtd     #4
