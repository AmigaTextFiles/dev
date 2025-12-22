
**
** readchar
**
** Copyright © 1995, Guichard Damien.
**

        include dos/dos_lib.i
        include globals.i

readchar
        move.l  (stdin,a4),d1
        move.l  a0,-(sp)
        DOS_CALL FGetC
        move.l  (sp)+,a0
        move.l  d0,(lastchar,a4)
        rts

