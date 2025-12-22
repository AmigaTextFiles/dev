/*
** $PROJECT: xrefsupport.lib
**
** $VER: calctextwidth.c 1.1 (10.09.94)
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
** 10.09.94 : 001.001 :  initial
*/

#include "/source/Def.h"

UWORD calctextwidth(struct RastPort *rp,STRPTR *textarray)
{
   UWORD max = 0;
   UWORD x;

   while(*textarray)
   {
      if((x = TextLength(rp,*textarray,strlen(*textarray))) > max)
         max = x;
      textarray++;
   }

   return(max);
}

