/*
** $PROJECT: xrefsupport.lib
**
** $VER: getamigaguidenode.c 1.1 (08.09.94)
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
** 08.09.94 : 001.001 :  initial
*/

#include "/source/def.h"

#define EOS    '\0'

void getamigaguidenode(STRPTR *nameptr,STRPTR *titleptr)
{
   STRPTR ptr = *nameptr;
   STRPTR title;
   STRPTR name;

   while(*ptr == ' ' || *ptr == '\t')
      ptr++;

   name = ptr;

   if(*name == '"')
   {
      name++;
      ptr++;
      while(*ptr != '"' && *ptr != EOS)
         ptr++;
   } else
      while(*ptr != ' ' && *ptr != '\t' && *ptr != EOS)
         ptr++;

   *ptr++ = EOS;

   while(*ptr == ' ' || *ptr == '\t')
      ptr++;

   if(*ptr == '"')
   {
      title = ++ptr;
      while(*ptr != '"' && *ptr != EOS)
         ptr++;

      *ptr = EOS;
   } else
      title = name;

   *titleptr = title;
   *nameptr = name;
}

