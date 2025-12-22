/*
** $PROJECT: xrefsupport.lib
**
** $VER: checkentrytype.c 1.1 (04.09.94)
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

ULONG checkentrytype(STRPTR name)
{
   ULONG type;
   ULONG len = strlen(name);
   ULONG i;
   ULONG upper = 0;

   for(i = 0; i < len ; i++)
   {
      if((isalpha(name[i]) && isupper(name[i])) || name[i] == '_' || isdigit(name[i]))
         upper++;
   }

   if((len > 9 && !strcmp(&name[len - 9],".datatype")) ||
      (len > 8 && !strcmp(&name[len - 8],"_handler")) ||
      (len > 7 && !strcmp(&name[len - 7],".gadget")) ||
      (*name == '-'))
   {
      type = XREFT_GENERIC;
   } else if(upper == len)
   {
      type = XREFT_COMMAND;
   } else 
   {
      type = XREFT_FUNCTION;
   }

   return(type);
}

