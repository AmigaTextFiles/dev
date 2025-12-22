
**
** make (n:INTEGER)
**
** Copyright © 1995, Guichard Damien.
**

make
        move.l  ($4,sp),d0
        move.l  d0,($4,a1)
        move.l  a3,($C,a1)
        add.l   #1,d0
        bclr.l  #1,d0
        add.l   d0,a3
        rtd     #4

