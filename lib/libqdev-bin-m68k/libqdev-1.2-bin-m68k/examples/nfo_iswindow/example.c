/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_iswindow()
 *
*/

#include "../gid.h"



BOOL iswindow(UBYTE *obj, struct Window *win)
{
  if (nfo_iswindow(win))
  {
    FPrintf(Output(), "%s did open a window.\n", (LONG)obj);

    return TRUE;
  }
  else
  {
    FPrintf(Output(),
                  "%s did not open a window.\n", (LONG)obj);
  }

  return FALSE;
}

int GID_main(void)
{
  struct Window *win;
  LONG fd;


  /*
   * Sort of obvious that the console always opens a window.
   * On the other hand an "/AUTO" option is questionable ;-)
   * and this is when this function comes in.
  */
  if ((fd = Open("CON://///CLOSE", MODE_OLDFILE)))
  {
    win = nfo_getwinaddr(fd);

    iswindow("1. CON:", win);

    Close(fd);
  }

  if ((fd = Open("NIL:", MODE_OLDFILE)))
  {
    win = nfo_getwinaddr(fd);

    iswindow("2. NIL:", win);

    Close(fd);
  }

  return 0;
}
