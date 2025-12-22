/*
** $PROJECT: xrefsupport.lib
**
** $VER: writebuffer.c 1.1 (08.09.94)
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

#include "/source/Def.h"

#include "xrefsupport.h"

RegCall void _mysprintf(REGA3 STRPTR buf,REGA0 STRPTR fmt,REGA1 APTR data,REGA6 struct Library *SysBase);

extern struct Library *SysBase;

void mysprintf(struct Buffer *buf,STRPTR fmt,APTR arg,...)
{
   _mysprintf(buf->b_Ptr,fmt,&arg,SysBase);
   buf->b_Ptr += strlen(buf->b_Ptr);
   *buf->b_Ptr = '\0';
}

