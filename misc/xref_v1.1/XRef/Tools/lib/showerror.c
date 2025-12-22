/*
** $PROJECT: xrefsupport.lib
**
** $VER: showerror.c 1.1 (04.09.94)
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

/* ------------------------------ include's ------------------------------- */

#include "/source/Def.h"

/* ------------------------------- function ------------------------------- */

void showerror(STRPTR prgname,STRPTR header,LONG error)
{
   UBYTE buffer[100];

   struct EasyStruct es = {
      sizeof(struct EasyStruct),
      0,
      NULL,
      "%s",
      "End"};

   es.es_Title = prgname;

   Fault(error,header,buffer,sizeof(buffer));

   EasyRequest(NULL,&es,NULL,buffer);
}

