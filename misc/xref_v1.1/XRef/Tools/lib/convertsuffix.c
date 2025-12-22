/*
** $PROJECT: xrefsupport.lib
**
** $VER: convertsuffix.c 1.1 (10.09.94)
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

#include "xrefsupport.h"

#define EOS          '\0'

static const STRPTR guidesuffix = ".guide";

void convertsuffix(ULONG filetype,STRPTR file)
{
   ULONG len = strlen(file);

   switch(filetype)
   {
   case FTYPE_AUTODOC:
      file[len-4] = EOS;
      break;
   case FTYPE_DOC:
      strcpy(&file[len-4],guidesuffix);
      break;
   case FTYPE_MAN:
      strcpy(&file[len-2],guidesuffix);
      break;
   }
}

