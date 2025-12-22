/* xref.library
**
** $VER: writexreffileentry.c 0.1 (20.07.94)
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
** 20.07.94 : 000.001 : initial
*/


#include <exec/types.h>
#include <clib/xref_protos.h>

ULONG WriteXRefFileEntry(APTR handle,ULONG Tag1,...)
{
   return(WriteXRefFileEntryA(handle,(struct TagItem *) &Tag1));
}

