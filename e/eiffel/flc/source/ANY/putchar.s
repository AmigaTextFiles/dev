
**
** putchar(c:CHARACTER)
**
** Copyright © 1995, Guichard Damien.
**

        include dos/dos_lib.i
        include globals.i

putchar
        move.l  (stdout,a4),d1
        move.l  (4,sp),d2
        move.l  a0,-(sp)
        DOS_CALL FPutC
        move.l  (sp)+,a0
        rtd     #4
