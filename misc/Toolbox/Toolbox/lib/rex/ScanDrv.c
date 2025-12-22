/* $Id: ScanDrv.c,v 2.2 1992/08/07 15:29:41 grosch rel $ */

# include <stdio.h>
# include "Positions.h"
$@ # include "@.h"

main ()
{
   int Token, Count = 0;
   char Word [256];

$@    $_BeginScanner ();
   do {
$@       Token = $_GetToken ();
      Count ++;
# ifdef Debug
$@       if (Token != $_EofToken) (void) $_GetWord (Word); else Word [0] = '\0';
$@       WritePosition (stdout, $_Attribute.Position);
      (void) printf ("%5d %s\n", Token, Word);
# endif
$@    } while (Token != $_EofToken);
$@    $_CloseScanner ();
   (void) printf ("%d\n", Count);
   return 0;
}
