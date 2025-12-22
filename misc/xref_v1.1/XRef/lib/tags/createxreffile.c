/* xref.library
**
** $VER: createxreffile.c 0.1 (20.07.94)
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

APTR CreateXRefFile(STRPTR file,ULONG Tag1,...)
{
   return(CreateXRefFileA(file,(struct TagItem *) &Tag1));
}

