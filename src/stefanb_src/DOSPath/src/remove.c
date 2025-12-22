/*
 * remove.c  V1.0
 *
 * Remove a directory from a path list
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

__geta4 struct PathListEntry *RemoveFromPathList(
                              __A0 struct PathListEntry *path,
                              __A1 BPTR dirlock,
                              __A6 struct DOSPathBase *dpb)
{
 struct Library       *DOSBase = dpb->dpb_DOSBase;
 struct PathListEntry *rc      = path;
 struct PathListEntry *prev    = NULL;

 DEBUGLOG(kprintf("Remove: List 0x%08lx Lock 0x%08lx Base 0x%08lx\n",
                  path, dirlock, dpb);)

 /* Scan path list */
 while (path) {

  DEBUGLOG(kprintf("Remove: Lock 0x%08lx\n", path->ple_Lock);)

  /* Same directory? */
  if (SameLock(path->ple_Lock, dirlock) == LOCK_SAME) {

   DEBUGLOG(kprintf("Remove: Entry 0x%08lx\n", path);)

   /* Yes, unlink current entry from list */
   if (prev)

    /* Remove a node INSIDE the list */
    prev->ple_Next = path->ple_Next;

   else

    /* Head node will be removed, set new head pointer */
    rc = (struct PathListEntry *) BADDR(path->ple_Next);

   /* Unlock directory lock from this entry */
   UnLock(path->ple_Lock);

   /* Free entry */
   FreeVec(path);

   /* Leave loop */
   break;
  }

  /* Next entry */
  prev = path;
  path = BADDR(path->ple_Next);
 }

 DEBUGLOG(kprintf("Remove: Result 0x%08lx\n", rc);)

 /* Return pointer to (new) head of list */
 return(rc);
}
