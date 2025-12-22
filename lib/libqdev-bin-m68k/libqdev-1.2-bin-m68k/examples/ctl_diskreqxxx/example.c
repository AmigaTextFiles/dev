/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_diskreqon()
 * ctl_diskreqoff()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG fd;
  APTR win;


  win = ctl_diskreqoff();

  /*
   * This alone would raise the requester, but not this time!
  */
  if ((fd = Open("INVISIBLE:", MODE_OLDFILE)))
  {
    Close(fd);
  }

  ctl_diskreqon(win);

  return 0;
}
