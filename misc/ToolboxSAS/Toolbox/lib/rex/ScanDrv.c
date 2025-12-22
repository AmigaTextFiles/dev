/* $Id: ScanDrv.c,v 2.2 1992/08/07 15:29:41 grosch rel $ */

#include <stdio.h>
#include "Positions.h"
$@ #include "@.h"

int main (void)
 {
  int Token, Count = 0;
#ifdef Debug
  char Word [256];
#endif

$@  $_BeginScanner();
  do
   {
$@    Token = $_GetToken();
    Count++;
#ifdef Debug
$@    if (Token != $_EofToken)
$@      $_GetWord(Word);
    else
      Word[0] = '\x0';
$@    WritePosition(stdout,$_Attribute.Position);
    printf("%5d %s\n",Token,Word);
#endif
   }
$@  while (Token != $_EofToken);
$@  $_CloseScanner();
  printf("%d\n",Count);
  return(0);
 }
