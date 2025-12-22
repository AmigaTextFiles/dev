
**
** putint(i:INTEGER)
**
** Copyright © 1995, Guichard Damien.
**

        include dos/dos_lib.i
        include globals.i

putint
        move.l  (stdout,a4),d1
        move.l  sp,d2
        add.l   #4,d2
        move.l  #4,d3
        move.l  #1,d4
        move.l  a0,-(sp)
        DOS_CALL FWrite
        move.l  (sp)+,a0
        rtd     #4

