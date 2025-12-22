
**
** laststring:STRING
**
** Copyright © 1995, Guichard Damien.
**

        include globals.i

_laststring
        move.l  (laststring,a4),d0
        rts

