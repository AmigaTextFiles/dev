/* xref.library
**
** $VER: xr_expungexreftags.c 0.2 (03.09.94) 
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
** 03.09.94 : 000.002 :  return value added
** 20.05.94 : 000.001 : initial
*/

#include <exec/types.h>
#include <clib/xref_protos.h>

ULONG XR_ExpungeXRefTags(ULONG Tag1,...)
{                     
   return(XR_ExpungeXRef((struct TagItem *) &Tag1));
}

