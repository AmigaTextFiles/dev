/*
 * wbpath.c  V1.0
 *
 * Copy path from Workbench process
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

__geta4 struct PathListEntry *CopyWorkbenchPathList(
                              __A0 struct WBStartup *wbs,
                              __A1 struct PathListEntry **anchor,
                              __A6 struct DOSPathBase *dpb)
{
 struct Process       *wbproc;
 struct PathListEntry *rc     = NULL;

 DEBUGLOG(kprintf("CopyWB: WBS 0x%08lx List 0x%08lx Base 0x%08lx\n",
                  wbs, anchor, dpb);)

 /* Get a pointer to the Workbench task */
 if ((wbproc = (struct Process *)(

 /* Has a Workbench startup message been supplied? */
       wbs ?

 /* Yes, get the Workbench task from the reply port of the message   */
 /*                                                                  */
 /* NOTE: This is the correct method to get access to the Workbench  */
 /*       process' command path when started from the Workbench. The */
 /*       WB has to wait until your program finishes and replies the */
 /*       WBStartup message. Thus all pointers stay valid while we   */
 /*       copy the path list.                                        */

        wbs->sm_Message.mn_ReplyPort->mp_SigTask :

 /* No, search for a task called "Workbench" in the system.   */
 /* This is a little bit insecure, because we can't Forbid()! */
        FindTask("Workbench")))) {

  DEBUGLOG(kprintf("CopyWB: WBProc 0x%08lx\n", wbproc);)

  /* Get the path from the process and copy it */
  rc = CopyPathList(GetProcessPathList(wbproc), anchor, dpb);
 }

 DEBUGLOG(kprintf("CopyWB: Result 0x%08lx\n", rc);)

 /* Return pointer to head of copied path list */
 return(rc);
}
