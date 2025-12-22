/*
 * free.c  V1.0
 *
 * Free a path list
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

__geta4 void FreePathList(__A0 struct PathListEntry *next,
                          __A6 struct DOSPathBase *dpb)
{
 struct PathListEntry *current;
 struct Library       *DOSBase = dpb->dpb_DOSBase;

 DEBUGLOG(kprintf("Free: List 0x%08lx Base 0x%08lx\n", next, dpb);)

 /* Scan list */
 while (current = next) {

  /* Save pointer to next entry */
  next = BADDR(current->ple_Next);

  /* Release lock */
  UnLock(current->ple_Lock);

  /* Free current path list entry */
  FreeVec(current);
 }
}
