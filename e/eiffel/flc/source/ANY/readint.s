
**
** readint
**
** Copyright © 1995, Guichard Damien.
**

        include dos/dos_lib.i
        include globals.i

readint
        move.l  (stdin,a4),d1
        lea     (lastint,a4),a2
        move.l  a2,d2
        move.l  #4,d3
        move.l  #1,d4
        move.l  a0,-(sp)
        DOS_CALL FRead
        move.l  (sp)+,a0
        rts

