/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_getsmparams()
 * ctl_setsmparams()
 *
*/

#include "../gid.h"

/*
 * The absolute path was chosen purposely not to ditch your
 * permanent settings if you are not using RAM: .
*/
#define SMPREFSFILE   "ram:env/sys/screenmode.prefs"
#define GFXINPUT      "640x512 0xAFFFF 0xFFFFFFFF similar ycofact"
#define NATINPUT      "640x512 0x0 0xAFFFF similar ycofact"
#define DEFMODEID     0
#define DEFDEPTH      4



int GID_main(void)
{
  ULONG modeid = DEFMODEID;
  UWORD depth = DEFDEPTH;
  ULONG fdepth = depth << 16;


  /*
   * With these two functions it is very easy to get and set
   * modeid and depth of the Workbench.
  */
  if (ctl_getsmparams(SMPREFSFILE, &modeid, &depth))
  {
    FPrintf(Output(),
                   "Currently you are using these params:\n"
                                        "modeid = 0x%08lx\n"
                                            "depth = %ld\n",
                                             modeid, depth);
  }
  else
  {
    FPrintf(Output(),
            "You dont seem to have the config at all...\n");

    /*
     * Lets guess the best suited modeid and set it so the
     * poor user can use the Miggy ;-) . Firstly try to find
     * a gfx card.
    */
    if ((modeid = nfo_findgfxentry(GFXINPUT, &fdepth))
                                              == INVALID_ID)
    {
      /*
       * Seems this system does not make use of gfx boards.
      */
      modeid = nfo_findgfxentry(NATINPUT, &fdepth);
    }

    if (modeid != INVALID_ID)
    {
      if (ctl_setsmparams(SMPREFSFILE, &modeid, &depth))
      {
        FPrintf(Output(),
                         "I did set these params for you:\n"
                                        "modeid = 0x%08lx\n"
                                            "depth = %ld\n",
                                             modeid, depth);
      }
    }
  }

  return 0;
}
