/*
 * build.c  V1.0
 *
 * Build a path lish
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

/* Build path list from string array  */
static struct PathListEntry *BuildFromArray(const char **array,
                                            struct PathListEntry **anchor,
                                            struct DOSPathBase *dpb)
{
 struct PathListEntry *head = NULL; /* Head of new path list */

 DEBUGLOG(kprintf("Build: Array 0x%08lx Anchor 0x%08lx Base 0x%08lx\n",
                  array, anchor, dpb);)

 /* Array valid? */
 if (array) {
  struct Library       *DOSBase = dpb->dpb_DOSBase;
  struct FileInfoBlock *fib;

  /* Allocate FIB */
  if (fib = AllocDosObject(DOS_FIB, NULL)) {
   struct PathListEntry *current = anchor ? *anchor : NULL; /* Current entry */
   struct PathListEntry *next    = NULL;                    /* Next entry    */
   const char           *path;

   DEBUGLOG(kprintf("Build: FIB 0x%08lx\n", fib);)

   /* Scan array */
   while (path = *array++) {

    DEBUGLOG(kprintf("Build: Next Path %s (0x%08lx)\n", path, path);)

    /* Allocate memory for next path list entry (only if not yet allocated!) */
    /* Note: Please use AllocVec otherwise DOS gets mightely confused :-)    */
    if ((next != NULL) ||
        (next = AllocVec(sizeof(struct PathListEntry), MEMF_PUBLIC))) {

     DEBUGLOG(kprintf("Build: Entry 0x%08lx\n", next);)

     /* Lock next path */
     if (next->ple_Lock = Lock(path, SHARED_LOCK)) {

      DEBUGLOG(kprintf("Build: Lock 0x%08lx\n", next->ple_Lock);)

      /* Is this a directory lock? */
      if (Examine(next->ple_Lock, fib) && (fib->fib_DirEntryType > 0)) {

       /* Directory lock, clear pointer to next node */
       next->ple_Next = NULL;

       /* Set head pointer */
       if (head == NULL) head = next;

       /* Append new entry after current entry */
       if (current) current->ple_Next = MKBADDR(next);

       /* Move current pointer */
       current = next;

       /* Clear next pointer. A new entry must be allocated in the next round. */
       next = NULL;

      } else

       /* This is no directory lock, release it */
       UnLock(next->ple_Lock);
     }

     /* Couldn't allocate memory for next path list entry */
    } else {

     /* Free path list */
     FreePathList(head, dpb);

     /* Clear head pointer */
     head = NULL;

     /* If anchor was supplied remove new list from chain */
     if (anchor && *anchor) (*anchor)->ple_Next = NULL;

     /* Leave loop */
     break;
    }
   }

   /* Next path list entry already allocated? Free it! */
   if (next) FreeVec(next);

   /* If anchor is valid and copy was successful then return end of list */
   if (anchor && head) *anchor = current;

   /* Free FIB */
   FreeDosObject(DOS_FIB, fib);
  }
 }

 DEBUGLOG(kprintf("Build: Head 0x%08lx Anchor 0x%08lx\n", head, anchor);)

 /* Return pointer to head of new path list */
 return(head);
}

/* Build path list from Exec list */
static struct PathListEntry *BuildFromList(struct List *list,
                                           struct PathListEntry **anchor,
                                           struct DOSPathBase *dpb)
{
 struct PathListEntry *head = NULL; /* Head of new path list */

 DEBUGLOG(kprintf("Build: List 0x%08lx Anchor 0x%08lx Base 0x%08lx\n",
                  list, anchor, dpb);)

 /* list valid? */
 if (list) {
  struct Library       *DOSBase = dpb->dpb_DOSBase;
  struct FileInfoBlock *fib;

  /* Allocate FIB */
  if (fib = AllocDosObject(DOS_FIB, NULL)) {
   struct PathListEntry *current = anchor ? *anchor : NULL; /* Current entry */
   struct PathListEntry *next    = NULL;                    /* Next entry    */
   struct Node          *node;

   DEBUGLOG(kprintf("Build: FIB 0x%08lx\n", fib);)

   /* Scan Exec list */
   for (node = list->lh_Head; node->ln_Succ; node = node->ln_Succ) {
    const char *path;

    /* Name pointer valid? */
    if (path = node->ln_Name) {

     DEBUGLOG(kprintf("Build: Next Path %s (0x%08lx)\n", path, path);)

     /* Allocate memory for next path list entry (only if not yet allocated!) */
     /* Note: Please use AllocVec otherwise DOS gets mightely confused :-)    */
     if ((next != NULL) ||
         (next = AllocVec(sizeof(struct PathListEntry), MEMF_PUBLIC))) {

      DEBUGLOG(kprintf("Build: Entry 0x%08lx\n", next);)

      /* Lock next path */
      if (next->ple_Lock = Lock(path, SHARED_LOCK)) {

       DEBUGLOG(kprintf("Build: Lock 0x%08lx\n", next->ple_Lock);)

       /* Is this a directory lock? */
       if (Examine(next->ple_Lock, fib) && (fib->fib_DirEntryType > 0)) {

        /* Directory lock, clear pointer to next node */
        next->ple_Next = NULL;

        /* Set head pointer */
        if (head == NULL) head = next;

        /* Append new entry after current entry */
        if (current) current->ple_Next = MKBADDR(next);

        /* Move current pointer */
        current = next;

        /* Clear next pointer. A new entry must be allocated in the next round. */
        next = NULL;

       } else

        /* This is no directory lock, release it */
        UnLock(next->ple_Lock);
      }

      /* Couldn't allocate memory for next path list entry */
     } else {

      /* Free path list */
      FreePathList(head, dpb);

      /* Clear head pointer */
      head = NULL;

      /* If anchor was supplied remove new list from chain */
      if (anchor && *anchor) (*anchor)->ple_Next = NULL;

      /* Leave loop */
      break;
     }
    }
   }

   /* Next path list entry already allocated? Free it! */
   if (next) FreeVec(next);

   /* If anchor is valid and copy was successful then return end of list */
   if (anchor && head) *anchor = current;

   /* Free FIB */
   FreeDosObject(DOS_FIB, fib);
  }
 }

 DEBUGLOG(kprintf("Build: Head 0x%08lx Anchor 0x%08lx\n", head, anchor);)

 /* Return pointer to head of new path list */
 return(head);
}

/* Entry point */
__geta4 struct PathListEntry *BuildPathListTagList(
                                            __A0 struct PathListEntry **anchor,
                                            __A1 struct TagItem *tags,
                                            __A6 struct DOSPathBase *dpb)
{
 struct PathListEntry *head = NULL; /* Head of new path list */

 DEBUGLOG(kprintf("Build: Anchor 0x%08lx Tags 0x%08lx Base 0x%08lx\n",
                  anchor, tags, dpb);)

 /* Tags valid? */
 if (tags) {
  struct Library *UtilityBase = dpb->dpb_UtilityBase;
  struct TagItem *ti;
  struct TagItem *tistate     = tags;

  /* Scan tag item list */
  while (ti = NextTagItem(&tistate)) {
   struct PathListEntry *new = NULL;

   /* Which tag? */
   switch (ti->ti_Tag) {

    case DOSPath_BuildFromArray:
     new = BuildFromArray((const char **) ti->ti_Data, anchor, dpb);
     break;

    case DOSPath_BuildFromList:
     new = BuildFromList((struct List *) ti->ti_Data, anchor, dpb);
     break;
   }

   /* Head pointer already set? */
   if (head == NULL) head = new;
  }
 }

 DEBUGLOG(kprintf("Build: Head 0x%08lx Anchor 0x%08lx\n", head, anchor);)

 /* Return pointer to head of new path list */
 return(head);
}
