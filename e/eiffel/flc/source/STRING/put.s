
**
** put (c:CHARACTER; i:INTEGER)
**
** Copyright © 1995, Guichard Damien.
**

put
        move.l  ($C,a1),a2
        move.l  ($4,sp),d0
        move.b  ($7,sp),(-1,a2,d0.l)
        rtd     #8

