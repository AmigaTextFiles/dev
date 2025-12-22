/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getwinaddr()
 *
*/

#include "../gid.h"

#define WINTITLE "The Title"



int GID_main(void)
{
  struct Window *win;
  LONG fd;


  if ((fd = Open(
                "CON:////" WINTITLE "/WAIT/CLOSE", MODE_OLDFILE)))
  {
    if ((win = nfo_getwinaddr(fd)))
    {
      FPrintf(Output(), "Window title is: %s\n", (LONG)win->Title);
    }

    Close(fd);
  }

  return 0;
}
