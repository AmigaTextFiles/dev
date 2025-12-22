/*
 * copy.c  V1.0
 *
 * Copy a path list
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

__geta4 struct PathListEntry *CopyPathList(__A0 struct PathListEntry *orig,
                                           __A1 struct PathListEntry **anchor,
                                           __A6 struct DOSPathBase *dpb)
{
 struct PathListEntry *head    = NULL;                    /* Head new list */
 struct PathListEntry *current = anchor ? *anchor : NULL; /* Current entry */
 struct PathListEntry *next    = NULL;                    /* Next entry    */
 struct Library       *DOSBase = dpb->dpb_DOSBase;

 DEBUGLOG(kprintf("Copy: Orig 0x%08lx Anchor 0x%08lx Base 0x%08lx\n",
                  orig, anchor, dpb);)

 /* Scan original path list */
 while (orig) {

  DEBUGLOG(kprintf("Copy: Next Orig 0x%08lx\n", orig);)

  /* Allocate memory for next path list entry (only if not yet allocated!) */
  /* Note: Please use AllocVec otherwise DOS gets mightely confused :-)    */
  if ((next != NULL) ||
      (next = AllocVec(sizeof(struct PathListEntry), MEMF_PUBLIC))) {

   DEBUGLOG(kprintf("Copy: Entry 0x%08lx\n", next);)

   /* Duplicate directory lock */
   if (next->ple_Lock = DupLock(orig->ple_Lock)) {

    DEBUGLOG(kprintf("Copy: Lock 0x%08lx\n", next->ple_Lock);)

    /* Lock duplicated, clear pointer to next node */
    next->ple_Next = NULL;

    /* Set head pointer */
    if (head == NULL) head = next;

    /* Append new entry after current entry */
    if (current) current->ple_Next = MKBADDR(next);

    /* Move current pointer */
    current = next;

    /* Clear next pointer. A new entry must be allocated in the next round. */
    next = NULL;
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

  /* Get next entry in original path list */
  orig = BADDR(orig->ple_Next);
 }

 /* Next path list entry already allocated? Free it! */
 if (next) FreeVec(next);

 /* If anchor is valid and copy was successful then return end of list */
 if (anchor && head) *anchor = current;

 DEBUGLOG(kprintf("Copy: Head 0x%08lx Anchor 0x%08lx\n", head, anchor);)

 /* Return pointer to head of copied path list */
 return(head);
}
