/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_doconswitch()
 * ctl_undoconswitch()
 *
*/

#include "../gid.h"

#define AUXCONSOLE "CON:50/50/400/200/Console2/SCREEN*/CLOSE"



int GID_main(void)
{
  struct ctl_csh_data ct = {0, 0, 0};
  LONG fd;


  /*
   * Suppose you want to run some proggy in a new CON: win.,
   * but you generally want it to belong to this proc.,  so
   * it can be reused.
  */
  if ((fd = Open(AUXCONSOLE, MODE_OLDFILE)))
  {
    /*
     * After your CON: is up and running you will just need
     * to switch the console task to point at new console.
    */
    ctl_doconswitch(&ct, fd);

    /*
     * And now you can run whatever you like in it.
    */
    ctl_clirun("cpu", "CONSOLE:", FALSE);

    ctl_clirun("avail", "CONSOLE:", FALSE);

    /*
     * Now you can restore prev. console and close your new
     * CON:.
    */
    ctl_undoconswitch(&ct);

    FPrintf(Output(), "Press CTRL-C to quit.\n");

    Wait(SIGBREAKF_CTRL_C);

    Close(fd);
  }

  return 0;
}
