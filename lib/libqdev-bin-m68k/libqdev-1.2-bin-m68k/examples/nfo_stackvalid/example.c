/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_stackvalid()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG state;


  /*
   * If you need to confirm stack validity or if you need
   * to know if you are still within stack block call this
   * function.
  */
  state = nfo_stackvalid(NULL);

  FPrintf(Output(), "Stack is %s.\n",
                     (LONG)(state ? "valid" : "invalid"));

  return 0;
}
