
**
** bit_size:INTEGER
**
** Copyright © 1995, Guichard Damien.
**

        include globals.i

bit_size
        move.l  (-4,a2),d0
        add.l   #4,d0
        lsl.l   #3,d0
        rts
