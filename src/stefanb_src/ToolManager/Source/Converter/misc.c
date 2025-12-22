/*
 * misc.c  V3.1
 *
 * ToolManager preferences file converter misc. routines
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

#include "converter.h"

/* Local data structures */
struct IDListEntry {
 struct Node ile_Node;
 ULONG       ile_ID;
};

/* Convert one string config parameter and return pointer to next string */
#define DEBUGFUNCTION ConvertConfigString
char *ConvertConfigString(char *buf, struct IFFHandle *iffh, ULONG id)
{
 ULONG len = strlen(buf) + 1;

 MISC_LOG(LOG3(Entry, "Chunk 0x%08lx String '%s' (0x%08lx)", id, buf, buf))

 /* Push, write and pop chunk */
 return(((PushChunk(iffh, 0, id, len) == 0) &&
         (WriteChunkBytes(iffh, buf, len) == len) &&
         (PopChunk(iffh) == 0)) ? (buf + len) : NULL);
}

/* Add on entry to the ID list */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AddToIDList
BOOL AddIDToList(struct MinList *l, const char *name, ULONG id)
{
 ULONG               len = sizeof(struct IDListEntry) + strlen(name) + 1;
 struct IDListEntry *ile;

 MISC_LOG(LOG4(Entry, "List 0x%08lx Name '%s' (0x%08lx) ID 0x%08lx",
               l, name, name, id))

 /* Allocate ID list entry */
 if (ile = GetVector(len)) {

  MISC_LOG(LOG2(Allocated, "Entry 0x%08lx Length %ld", ile, len))

  /* Initialize list entry */
  ile->ile_Node.ln_Name = (char *) (ile + 1);
  ile->ile_ID           = id;

  /* Copy name */
  strcpy(ile->ile_Node.ln_Name, name);

  /* Add entry to list */
  AddTail((struct List *) l, (struct Node *) ile);
 }

 return(ile != NULL);
}

/* Find ID in list */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FindIDInList
ULONG FindIDInList(struct MinList *l, const char *name)
{
 ULONG               rc  = 0;
 struct IDListEntry *ile = (struct IDListEntry *) GetHead(l);

 MISC_LOG(LOG3(Entry, "List 0x%08lx Name '%s' (0x%08lx)", l, name, name))

 /* Scan list */
 for (ile = (struct IDListEntry *) l->mlh_Head;
      ile->ile_Node.ln_Succ;
      ile = (struct IDListEntry *) ile->ile_Node.ln_Succ)

  /* Name found? */
  if (strcmp(name, ile->ile_Node.ln_Name) == 0) {

   /* Get ID */
   rc = ile->ile_ID;

   /* Leave loop */
   break;
  }

 MISC_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeIDList
void FreeIDList(struct MinList *l)
{
 struct IDListEntry *ile;

 MISC_LOG(LOG1(List, "0x%08lx", l))

 /* Scan list */
 while (ile = (struct IDListEntry *) RemTail((struct List *) l)) {

  MISC_LOG(LOG1(Entry, "0x%08lx", ile))

  /* Free entry */
  FreeVector(ile);
 }
}

/* Include global miscellaneous code */
#include "/global_misc.c"
