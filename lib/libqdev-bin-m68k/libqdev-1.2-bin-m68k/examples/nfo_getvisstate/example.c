/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getvisstate()
 *
*/

#include "../gid.h"

#define SCREENINFO   "Press CTRL+C to quit."
#define SCREENWARN   "Cannot quit at this time!"



int GID_main(void)
{
  struct Screen *screen;
  LONG res;
  ULONG modeid;
  UWORD depth;


  /*
   * Lets lock current pubscreen and obtain the modeid.
  */
  if ((screen = ctl_lockscreensafe("*")))
  {
    res = nfo_getscparams(screen, &modeid, &depth);

    ctl_unlockscreensafe(screen);

    if (res)
    {
      /*
       * Now its just a matter of creating our new screen.
       * Notice that we are not using screen sig. feature!
      */
      screen = OpenScreenTags(NULL, 
                      SA_Depth,           depth,
                      SA_DisplayID,       modeid,
                      SA_Title,           (LONG)"MyScreen",
                      SA_PubName,         (LONG)"_SCREEN_",
                      SA_Overscan,        OSCAN_TEXT,
                      SA_SharePens,       TRUE,
                      SA_ShowTitle,       TRUE,
                      TAG_DONE,           0);

      if (screen)
      {
        /*
         * Allow others to visit this very public screen.
         * After launching this example invite something to
         * this screen.
        */
        PubScreenStatus(screen, 0);

        /*
         * Print dummy info directly to the screen.
        */
        SetAPen(&screen->RastPort, 1);

        SetBPen(&screen->RastPort, 2);

        Move(&screen->RastPort, 16, 32);

        Text(&screen->RastPort,
                       SCREENINFO, sizeof(SCREENINFO) - 1);

        while(1)
        {
          Wait(SIGBREAKF_CTRL_C);

          /*
           * No new visitors are allowed at this point.
          */
          PubScreenStatus(screen, PSNF_PRIVATE);

          /*
           * Check for visitors on this screen. Obviously
           * we cannot close it while others are here.
          */
          if (!(nfo_getvisstate(screen)))
          {
            break;
          }

          /*
           * There are still some visitors to this public
           * screen!
          */
          Move(&screen->RastPort, 16, 32);

          Text(&screen->RastPort,
                       SCREENWARN, sizeof(SCREENWARN) - 1);
        }

        CloseScreen(screen);
      }
    }
  }

  return 0;
}
