
**
** item (n:INTEGER):CHARACTER
**
** Copyright © 1995, Guichard Damien.
**

item
        move.l  ($C,a1),a2
        move.l  ($4,sp),d0
        move.b  (-1,a2,d0.l),d0
        extb.l  d0
        rtd     #4

