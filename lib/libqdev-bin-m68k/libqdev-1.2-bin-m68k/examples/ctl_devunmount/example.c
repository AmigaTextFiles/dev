/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_devunmount()
 *
*/

#include "../gid.h"

#define UNENTRY   "MYDEV0:"



/*
 * This is totally artifficial structure. It doesnt do anything.
 * Below you can see how to pass it and read in the callback.
*/
struct userstruct
{
  LONG  us_flags;
  void *us_ptr;
};


/*
 * Remeber though that the 'uc' is temporary! Aside from that
 * not much can be inspected here, just the state and name.
*/
void usercb(struct ctl_umn_cb *uc)
{
  struct userstruct *us = uc->uc_userdata;


  FPrintf(Output(), "%s:\n"
                    "S_CODE: (0x%08lx)\n", (LONG)uc->uc_devname,
                                                   uc->uc_state);
}

int GID_main(void)
{
  struct userstruct us;
  LONG flags;
  LONG rc;


  /*
   * Lets prepare user structure.
  */
  us.us_flags = 0x00004000 | 0x00008000;

  us.us_ptr = "Meaningless text as well";

  /*
   * Flags are already defined. See QDEV_CTL_DMT_F#? flag group.
   * Expecially and only first and last.
  */
  flags = 0;

  /*
   * Unlike 'ctl_devmount()', this subsystem is self-contained
   * and does not allow user own device disintegration code. The
   * callback will be executed only when the device exists!
  */
  rc = ctl_devunmount(UNENTRY, flags, &us, usercb);

  FPrintf(Output(), "rc = 0x%08lx\n", rc);

  return 0;
}
