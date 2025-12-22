/*
 * handle.c  V3.1
 *
 * TMHandle management routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Local data */
static struct MinList HandleList;

/* Initialize handle management */
void InitHandles(void)
{
 /* Initialize handle list */
 NewList((struct List *) &HandleList);
}

/* Get handle list */
struct MinList *GetHandleList(void)
{
 return(&HandleList);
}

/* Initialize a ToolManager handle */
#define DEBUGFUNCTION InitToolManagerHandle
BOOL InitToolManagerHandle(struct TMHandle *tmh)
{
 int i;

 TMHANDLE_LOG(LOG1(Handle, "0x%08lx", tmh))

 /* Set ID counter to 0 */
 tmh->tmh_IDCounter = 0;

 /* For all list structures */
 for (i = 0; i < TMOBJTYPES; i++)

  /* Init list structure */
  NewList((struct List *) &tmh->tmh_ObjectLists[i]);

 /* Append handle to list */
 AddTail((struct List *) &HandleList, (struct Node *) &tmh->tmh_Node);

 return(TRUE);
}

/* Shut down a ToolManager handle */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteToolManagerHandle
void DeleteToolManagerHandle(struct TMHandle *tmh)
{
 int i;

 TMHANDLE_LOG(LOG1(Handle, "0x%08lx", tmh))

 /* Remove handle from list */
 Remove((struct Node *) &tmh->tmh_Node);

 /* Remove objects from lists */
 for (i = TMOBJTYPES - 1; i >= 0; i--) {
  Object *obj1 = (Object *) tmh->tmh_ObjectLists[i].mlh_Head;
  Object *obj2;

  TMHANDLE_LOG(LOG2(List, "Type %ld Head 0x%08lx", i, obj1))

  /* Scan object list and delete objects */
  while (obj2 = NextObject(&obj1)) DisposeObject(obj2);
 }

 TMHANDLE_LOG(LOG0(Deleted))
}

/* Create a new ToolManager object */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateToolManagerObject
Object *CreateToolManagerObject(struct TMHandle *tmh, ULONG type)
{
 Object *rc;

 TMHANDLE_LOG(LOG2(Arguments, "Handle 0x%08lx Type %ld", tmh, type))

 rc = NewObject(ToolManagerClasses[type], NULL, TMA_ObjectType, type,
                                                TMA_TMHandle,   tmh,
                                                TAG_DONE);

 TMHANDLE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Find a named ToolManager object in the specified list */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FindTypedNamedTMObject
Object *FindTypedNamedTMObject(struct TMHandle *tmh, const char *name,
                               ULONG type)
{
 Object *obj = (Object *) tmh->tmh_ObjectLists[type].mlh_Head;
 Object *rc;

 TMHANDLE_LOG(LOG4(Arguments, "Handle 0x%08lx Name '%s' (0x%08lx) Type %ld",
                   tmh, name, name, type))

 /* Scan object list */
 while (rc = NextObject(&obj)) {
  const char *s;

  /* Get name of object */
  GetAttr(TMA_ObjectName, rc, (ULONG *) &s);

  /* Object found? --> Leave loop */
  if (strcmp(name, s) == 0) break;
 }

 TMHANDLE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Find a named ToolManager object in the handle */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FindNamedTMObject
Object *FindNamedTMObject(struct TMHandle *tmh, const char *name)
{
 int     i;
 Object *rc;

 TMHANDLE_LOG(LOG3(Arguments, "Handle 0x%08lx Name '%s' (0x%08lx) Type %ld",
                   tmh, name, name))

 /* For all object lists */
 for (i = 0; i < TMOBJTYPES; i++)

  /* Object with this type found? --> Leave loop */
  if (rc = FindTypedNamedTMObject(tmh, name, i)) break;

 TMHANDLE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Find a ToolManager object with this ID in the specified list */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FindTypedIDTMObject
Object *FindTypedIDTMObject(struct TMHandle *tmh, ULONG id, ULONG type)
{
 Object *obj = (Object *) tmh->tmh_ObjectLists[type].mlh_Head;
 Object *rc;

 TMHANDLE_LOG(LOG3(Arguments, "Handle 0x%08lx ID 0x%08lx Type %ld",
                   tmh, id, type))

 /* Scan object list */
 while (rc = NextObject(&obj)) {
  ULONG tmp;

  /* Get ID of object */
  GetAttr(TMA_ObjectID, rc, &tmp);

  /* Object found? --> Leave loop */
  if (tmp == id) break;
 }

 TMHANDLE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
