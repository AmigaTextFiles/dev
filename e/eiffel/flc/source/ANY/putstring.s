
**
** putstring(s:STRING)
**
** Copyright © 1995, Guichard Damien.
**

        include dos/dos_lib.i
        include globals.i

putstring
        move.l  (stdout,a4),d1
        move.l  ($4,sp),a2
        move.l  ($C,a2),d2
        move.l  ($8,a2),d3
        move.l  #1,d4
        move.l  a0,-(sp)        
        DOS_CALL FWrite
        move.l  (sp)+,a0
        rtd     #4

