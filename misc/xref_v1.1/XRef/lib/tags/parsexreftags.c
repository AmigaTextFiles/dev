/* xref.library
**
** $VER: parsexreftags.c 0.1 (20.05.94)
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
** 20.05.94 : 000.001 : initial
*/

#include <exec/types.h>
#include <clib/xref_protos.h>

ULONG ParseXRefTags(STRPTR string,ULONG Tag1,...)
{
   return(ParseXRef(string,(struct TagItem *) &Tag1));
}

