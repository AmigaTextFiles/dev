/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_clipath()
 *
*/

#include "../gid.h"

/*
 * This private header is useful when ones wants to dump paths.
*/
#include "a-ctl_clipath.h"



/*
 * To dump paths this simple code can be used. No arbitration is
 * necessary. You should really allocate the memory for 'path'!
 * This should be at last 1024 bytes. This is just an example so
 * stack is being used.
*/ 
void showpaths(void)
{
  struct CommandLineInterface *cli;
  struct ctl_cph_data *cd;
  UBYTE path[256];


  if ((cli = Cli()))
  {
    cd = (struct ctl_cph_data *)&cli->cli_CommandDir;

    while (cd)
    {
      if (cd->cd_lock)
      {
        path[0] = '\0';

        NameFromLock(cd->cd_lock, path, sizeof(path));

        FPrintf(Output(), "%s\n", (LONG)path);
      }

      cd = QDEV_CTL_PRV_PATHENTRY(cd->cd_next);
    }
  }
}

int GID_main(void)
{
  /*
   * Lets try to add current path to the list. It is necessary
   * to be in the example directory!
  */
  if (!(ctl_clipath(QDEV_CTL_CLIPATH_FIND, "")))
  {
    ctl_clipath(QDEV_CTL_CLIPATH_ADD, "");

    showpaths();
  }

  /*
   * While adding requires finding first to avoid duplicates the
   * removal references finding internally, do it is really safe
   * to call it with bogus/non-existant path.
  */
  ctl_clipath(QDEV_CTL_CLIPATH_REM, "");

  return 0;
}
