
**
** new_line
**
** Copyright © 1995, Guichard Damien.
**

        include dos/dos_lib.i
        include globals.i

new_line
        move.l  (stdout,a4),d1
        move.l  #$a,d2
        move.l  a0,-(sp)
        DOS_CALL FPutC
        move.l  (sp)+,a0
        rts

