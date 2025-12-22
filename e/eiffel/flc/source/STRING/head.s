
**
** head (n:INTEGER)
**
** Copyright © 1995, Guichard Damien.
**

head
        move.l  ($4,sp),d0
        cmp.l   ($8,a1),d0
        bge.s   .end
        move.l  d0,($8,a1)
.end    rtd     #4

