/*
** $PROJECT: xrefsupport.lib
**
** $VER: checksuffix.c 1.1 (04.09.94)
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
** 04.09.94 : 001.001 :  initial
*/

#include "/source/Def.h"

BOOL checksuffix(STRPTR file,STRPTR suffix)
{
   ULONG suflen = strlen(suffix);
   ULONG len    = strlen(file);

   if(len > suflen && !Stricmp(&file[len-suflen],suffix))
      return(TRUE);

   return(FALSE);
}

