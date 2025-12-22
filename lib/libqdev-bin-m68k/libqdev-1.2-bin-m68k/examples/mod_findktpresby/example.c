/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_findktpresby()
 *
*/

#include "../gid.h"

/*
 * Normally you do not need to include this private header
 * but in this example we need access to kh_rt member.
*/
#include "a-mod_xxxmodule.h"



int GID_main(void)
{
  struct mod_ade_feed af;
  struct mod_ade_data *ad;
  struct Resident *rt;


  /*
   * Lets create a dummy KTP module, so we can test the
   * finder beast.
  */
  af.af_memflags = MEMF_LOCAL;

  af.af_memstart = QDEV_MOD_ADE_24BITLOWER;

  af.af_memend = QDEV_MOD_ADE_32BITUPPER;

  af.af_rtflags = RTF_COLDSTART;

  af.af_type = NT_UNKNOWN;

  af.af_pri = 0;

  af.af_ver = 1;

  af.af_datalen = 0;

  af.af_dataptr = NULL;

  af.af_nameptr = "MyDummyModule";

  af.af_idstrptr = "mydummymodule 1.0 (8/8/2012)";

  if ((ad = mod_addmodule(&af)))
  {
    /*
     * We will want to find the module by its strongest
     * mark. The name.
    */
    rt = mod_findktpresby(
                  QDEV_MOD_FSB_ME_NAME, "MyDummyModule");

    FPrintf(Output(), "kh_rt = 0x%08lx, rt = 0x%08lx\n",
                       (LONG)&ad->ad_kh.kh_rt, (LONG)rt);

    mod_delmodule((void *)ad);
  }

  return 0;
}
