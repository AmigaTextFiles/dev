/* $Id: Scanner.c,v 2.6 1992/08/07 15:28:42 grosch rel $ */

$@ # include "$.h"
# include <stdio.h>

$@ $_tScanAttribute	$_Attribute	= {{ 1, 0 }};

$@ int $_GetToken ()
   {
      char ch;

      do {
	 ch = getchar ();
$@ 	 if (ch == '\n') { $_Attribute.Position.Column = 0; $_Attribute.Position.Line ++; }
$@ 	 else $_Attribute.Position.Column ++;
      } while (ch == ' ' || ch == '\t' || ch == '\n');
      return ch == -1 ? 0 : ch;
   }

$@ void $_ErrorAttribute
# if defined __STDC__ | defined __cplusplus
$@    (short yyToken, $_tScanAttribute * yyRepairAttribute)
# else
$@    (yyToken, yyRepairAttribute) short yyToken; $_tScanAttribute * yyRepairAttribute;
# endif
   { }
