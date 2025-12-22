/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_isblitable()
 *
*/

#include "../gid.h"

/*
 * Include our test image as saved in PPaint: A dotted rect.
 * Notice that the linker does not support chip attribute,
 * thus empty macro below!
*/
#define chip
#include "im_rect.h"



int GID_main(void)
{
  struct Screen *screen;


  /*
   * Firstly lock current screen, so we can get its modeid.
  */
  if ((screen = ctl_lockscreensafe("*")))
  {
    /*
     * Then check if this image can be blitted directly or if
     * if requires to be put in chip memory first. This func.
     * assumes that if the gfx board is under the control of
     * CGX or P96 then there is no prob. On the other hand if
     * you are using native graphics then 'fblit' can help!
    */
    if (nfo_isblitable(
           im_rect.ImageData, GetVPModeID(&screen->ViewPort)))
    {
      FPrintf(Output(),
         "Your hardware can blit directly from this area!\n");
    }
    else
    {
      FPrintf(Output(),
      "Sorry you will have to put all planes in chip mem!\n");
    }

    ctl_unlockscreensafe(screen);
  }

  return 0;
}
