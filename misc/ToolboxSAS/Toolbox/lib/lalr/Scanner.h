$@ #ifndef yy$
$@   #define yy$

/* $Id: Scanner.h,v 2.4 1992/08/07 15:28:42 grosch rel $ */

  #include "Positions.h"

$@   typedef struct {tPosition Position;} $_tScanAttribute;

$@   extern $_tScanAttribute $_Attribute;

$@   int $_GetToken(void);
$@   void $_ErrorAttribute(short yyToken, $_tScanAttribute *yyRepairAttribute);

#endif
