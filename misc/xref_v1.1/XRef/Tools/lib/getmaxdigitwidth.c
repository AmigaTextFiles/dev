/*
** $PROJECT: xrefsupport.lib
**
** $VER: getmaxdigitwidth.c 1.1 (16.09.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 16.09.94 : 001.001 :  initial
*/

#include "/source/def.h"

UWORD getmaxdigitwidth(struct RastPort *rp)
{
   UWORD max = 0;
   UWORD x;
   UWORD i;
   UBYTE chr;

   for(i = 0 ; i < 9 ; i++)
   {
      chr = '0' + i;

      if((x = TextLength(rp,&chr,1)) > max)
         max = x;
   }

   return(max);
}

