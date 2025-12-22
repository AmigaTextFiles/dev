/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_newshell()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct Process *pr;
  LONG num = -1;
  LONG fd;


  if ((fd = Open(
           "CON://320/200/Shell/CLOSE/SCREEN*", MODE_OLDFILE)))
  {
    /*
     * Arbitrate before structure access cus shell is a process
     * that may disappear at any time!
    */
    QDEV_HLP_NOSWITCH
    (
      if ((pr = ctl_newshell(fd, NULL)))
      {
        num = pr->pr_TaskNum;
      }
    );

    FPrintf(Output(),
              "NewShell is at 0x%08lx (%ld)\n", (LONG)pr, num);

    Close(fd);
  }

  return 0;
}
