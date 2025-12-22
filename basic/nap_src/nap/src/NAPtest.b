PRINT "Dies ist ein kleiner Test, ~
       ob die line continuation \
       Codes funktionieren ;)"

a /* com 1 */  /* com 2 */ /* com 3 */
{a} {b}b{c}

PRINT "Diese Kommentare werden entfernt: { } /* */ '"

#include <ace/acedef.h>
#include <devices/narrator.h>

declare struct narrator_rb *s

if Test=FALSE then Test=truE
if Test=TRUE then Text=FaLse

BOX(100,100,200,200)

SETXY 110,110
PRINTS "compiled at ";__TIME;" MET on ";__DATE

