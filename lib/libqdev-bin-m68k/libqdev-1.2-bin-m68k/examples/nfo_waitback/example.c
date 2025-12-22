/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_waitback()
 *
*/

#include "../gid.h"

#define DUMMYAREXXSCRIPT "\"_lib = 'rexxsupport.library';"  \
                         "IF SHOW('L', _lib) = 0 THEN "     \
                         "_xxx = ADDLIB(_lib, 0, -30, 0);"  \
                         "_xxx = OPENPORT('MYPORT');"       \
                         "_xxx = DELAY(250)\""



/*
 * Function 'nfo_waitback()' is a mixture of 'nfo_istask()' and
 * 'nfo_ktm()' in a way that it allows to detect tasks and uses
 * KTM flagset and semantics.
*/
int GID_main(void)
{
  ULONG addr;


  /*
   * Suppose that you do not want to mess with loading binary
   * with 'LoadSeg()', setting up process tags and spawning it
   * with 'CreateNewProc()' but you want to know when the prog
   * was started or if it did start at all. Consider this:
   * A 'Wait' command with somewhat weird syntax that will be
   * started in a separate process.
  */
  ctl_clirun("wAIt 5", "NIL:", TRUE);

  /*
   * And now the detection part. We will wait for the process
   * to showup within 3 seconds. Square bracketed because its
   * a process!
  */
  addr = nfo_waitback("[wAIt]", 0, 3, 0);

  if (addr)
  {
    FPrintf(Output(),
                  "The process was found at 0x%08lx\n", addr);

    /*
     * Will it be able to find 'WaiT' then?
    */
    if (!(nfo_waitback("[WaiT]", 0, 0, 0)))
    {
      /*
       * But why... Ahha, case sensitive beast! Without flags
       * it distinguishes upper and lower case.
      */
      FPrintf(Output(), "Your second call did fail!\n");
    }

    /*
     * Now it should do. A matter of flag.
    */
    if ((nfo_waitback("[WaiT]", QDEV_NFO_KTM_FNOCASE, 0, 0)))
    {
      FPrintf(Output(), "But the 3rd call is successful!\n");
    }
  }
  else
  {
    FPrintf(Output(), "No such process man!\n");
  }


  /*
   * Another feature is the ability to find ports. Lets start
   * a simple ARexx script. That does create a port.
  */
  ctl_clirun("rx " DUMMYAREXXSCRIPT, NULL, TRUE);

  /*
   * OK, lets do it. The result is port address!
  */
  addr = nfo_waitback("MYPORT", QDEV_NFO_KTM_FPORTS, 3, 0);

  if (addr)
  {
    FPrintf(Output(),
                    "The port was found at 0x%08lx\n", addr);
  }
  else
  {
    FPrintf(Output(), "No such port man!\n");
  }

  return 0;
}
