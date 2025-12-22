/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_whichchipset()
 *
*/

#include "../gid.h"



/*
 * Small remark though... I did not test that routine on a
 * real OCS nor ECS hardware nor on OS below V39! I would
 * appreciate if anyone can confirm if it does really work
 * there.
*/
int GID_main(void)
{
  ULONG chipset;
  UBYTE *ptr;


  chipset = nfo_whichchipset();

  switch(chipset)
  {
    case QDEV_NFO_WHICHCS_OCS:
    {
      ptr = "OCS";

      break;
    }

    case QDEV_NFO_WHICHCS_ECS:
    {
      ptr = "ECS";

      break;
    }

    case QDEV_NFO_WHICHCS_AGA:
    {
      ptr = "AGA";

      break;
    }

    default:
    {
      ptr = "WTF?";
    }
  }

  FPrintf(Output(), "Chipset of effect is: %s\n", (LONG)ptr);

  return 0;
}
