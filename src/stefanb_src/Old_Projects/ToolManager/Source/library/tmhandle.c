/*
 * tmhandle.c  V2.1
 *
 * TMHandle managment routines
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Allocate a TMHandle */
BOOL InternalAllocTMHandle(struct TMHandle *handle)
{
 int i;

 DEBUG_PRINTF("InternalAllocTMHandle(%08lx) called.\n",handle);

 /* Init list structures */
 for (i=0; i<TMOBJTYPES; i++) NewList(&handle->tmh_ObjectLists[i]);

 return(TRUE);
}

/* Free a TMHandle */
BOOL InternalFreeTMHandle(struct TMHandle *handle)
{
 int i;

 DEBUG_PRINTF("InternalFreeTMHandle(%08lx) called.\n",handle);

 /* Remove objects from lists */
 for (i=TMOBJTYPES-1; i>=0; i--) {
  /* Remove objects from one list */
  struct List    *tmol=&handle->tmh_ObjectLists[i];
  struct TMObect *tmobj;

  /* Scan list and delete objects */
  while (tmobj=GetHead(tmol)) CallDeleteTMObject(tmobj);
 }

 return(TRUE);
}
