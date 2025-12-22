/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_haltidcmp()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct Window *win;


  win = OpenWindowTags(NULL,
                             WA_Left,           50,
                             WA_Top,            50,
                             WA_MinWidth,       320,
                             WA_MinHeight,      240,
                             WA_Width,          320,
                             WA_Height,         240,
                             WA_MaxWidth,       320,
                             WA_MaxHeight,      240,
                             WA_Activate,       TRUE,
                             WA_SizeGadget,     FALSE,
                             WA_DragBar,        TRUE,
                             WA_DepthGadget,    TRUE,
                             WA_CloseGadget,    TRUE,
                             WA_Backdrop,       FALSE,
                             WA_Borderless,     FALSE,
                             WA_SimpleRefresh,  FALSE,
                             TAG_DONE,          NULL);

  if (win)
  {
    /*
     * Lets create the message port and stuff, but lets
     * not receive any messages. Silly isnt it?
    */
    ModifyIDCMP(win,
               IDCMP_CLOSEWINDOW | IDCMP_ACTIVEWINDOW);

    SetRast(win->RPort, 1);

    SetAPen(win->RPort, 2);

    SetBPen(win->RPort, 1);

    Move(win->RPort, 32, 32);

    Text(win->RPort, "Close me!", 9);

    RefreshWindowFrame(win);

    /*
     * Now just wait for the signal.
    */
    Wait(SIGBREAKF_CTRL_C |
                    (1L << win->UserPort->mp_SigBit));

    /*
     * And this is where 'ctl_haltidcmp()' comes in
     * handy. It will reply all messages that were not
     * handled and will kill the message port, so that
     * no further IDCMP is possible.
    */
    ctl_haltidcmp(win);

    CloseWindow(win);
  }

  return 0;
}
