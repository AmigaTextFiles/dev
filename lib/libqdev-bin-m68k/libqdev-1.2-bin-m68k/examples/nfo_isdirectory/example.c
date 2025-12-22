/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isdirectory()
 *
*/

#include "../gid.h"

#define OBJECT  "RAM:"



int GID_main(void)
{
  LONG lock;


  if ((lock = Lock(OBJECT, SHARED_LOCK)))
  {
    /*
     * Determining whether locked object is a directory or not
     * is as easy as calling just this function.
    */
    if (nfo_isdirectory(lock))
    {
      FPrintf(Output(),
            "Object = '%s' is a directory.\n", (LONG)OBJECT);
    }

    UnLock(lock);
  }

  return 0;
}
