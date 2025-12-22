/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getconunit()
 *
*/

#include "../gid.h"

#define WINTITLE "The Title"



int GID_main(void)
{
  struct ConUnit *cu;
  LONG fd;


  if ((fd = Open(
                "CON:////" WINTITLE "/WAIT/CLOSE", MODE_OLDFILE)))
  {
    if ((cu = nfo_getconunit(fd)))
    {
      FPrintf(Output(),
             "Window title is: %s\n", (LONG)cu->cu_Window->Title);
    }

    Close(fd);
  }

  return 0;
}
