/*
 * find.c  V1.0
 *
 * Find a file in a path list
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

__geta4 BPTR FindFileInPathList(__A0 struct PathListEntry **anchor,
                                __A1 const char *file,
                                __A6 struct DOSPathBase *dpb)
{
 struct Library *DOSBase = dpb->dpb_DOSBase;
 BPTR            olddir  = CurrentDir(NULL);
 BPTR            rc      = NULL;

 DEBUGLOG(kprintf("Find: List 0x%08lx File '%s' 0x%08lx Base 0x%08lx\n",
                  path, file, file, dpb);)

 /* File name and anchor pointer valid? */
 if (file && anchor) {
  struct PathListEntry *path = *anchor;

  /* Scan path list */
  while (path) {
   BPTR filelock;

   DEBUGLOG(kprintf("Find: Lock 0x%08lx\n", path->ple_Lock);)

   /* Go to directory */
   CurrentDir(path->ple_Lock);

   /* Program in this directory? */
   if (filelock = Lock(file, SHARED_LOCK)) {

    /* Yes, unlock it */
    UnLock(filelock);

    /* Set return code */
    rc = path->ple_Lock;

    /* Leave loop */
    break;
   }

   /* Next entry */
   path = BADDR(path->ple_Next);
  }

  /* Store pointer to next entry for next call */
  *anchor = path ? (struct PathListEntry *) BADDR(path->ple_Next) : NULL;
 }

 /* Go back to old directory */
 CurrentDir(olddir);

 DEBUGLOG(kprintf("Find: Result 0x%08lx\n", rc);)

 /* Return lock to directory where the file was found */
 return(rc);
}
