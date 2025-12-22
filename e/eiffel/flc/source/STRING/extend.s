
**
** extend (c:CHARACTER)
**
** Copyright © 1995, Guichard Damien.
**

extend
        move.l  ($8,a1),d0
        cmp.l   ($4,a1),d0
        bge.s   .end
        move.l  ($C,a1),a2
        move.b  ($7,sp),(0,a2,d0.l)
        add.l   #1,d0
        move.l  d0,($8,a1)
.end    rtd     #4

