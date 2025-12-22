/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_addexhandler()
 * mem_remexhandler()
 *
*/

#include "../gid.h"



struct mydata
{
  struct IntuiMessage *md_im;
  struct Window       *md_win;

};



/*
 * OK. So this is the private task exception handler. About
 * 99% of the OS functions cannot be called from under this
 * code ;-) . You will have to call 'CreateTask()' in most
 * cases to execute your pseudo-interrupt code.
*/
__saveds __interrupt ULONG myhandler(
      REGARG(ULONG sigs, d0), REGARG(struct mydata *md, a1))
{
  struct ExecBase *SysBase = (*((struct ExecBase **) 4));


  /*
   * Get the Intuition message our window did generate.
  */
  while ((md->md_im = (struct IntuiMessage *)
                              GetMsg(md->md_win->UserPort)))
  {
    switch(md->md_im->Class)
    {
      case IDCMP_CLOSEWINDOW:
      {
        /*
         * User pressed close button, so lets tell the main
         * context that it is time to go.
        */
        Signal(FindTask(NULL), SIGBREAKF_CTRL_C);

        break;
      }

      default:
    }

    /*
     * Reply this message immediately. Notice that the main
     * stream code can lag heavily and the messages wont be
     * queued. This is good!
    */
    ReplyMsg((struct Message *)md->md_im);
  }

  return sigs;
}

int GID_main(void)
{
  struct mydata md;
  UBYTE text[32];
  LONG size;
  LONG sigbit;
  LONG cnt = 0;


  md.md_win = OpenWindowTags(NULL,
                             WA_Left,           50,
                             WA_Top,            50,
                             WA_MinWidth,       100,
                             WA_MinHeight,      100,
                             WA_Width,          320,
                             WA_Height,         240,
                             WA_MaxWidth,       640,
                             WA_MaxHeight,      480,
                             WA_Activate,       TRUE,
                             WA_SizeGadget,     TRUE,
                             WA_DragBar,        TRUE,
                             WA_DepthGadget,    TRUE,
                             WA_CloseGadget,    TRUE,
                             WA_Backdrop,       FALSE,
                             WA_Borderless,     FALSE,
                             WA_SimpleRefresh,  FALSE,
                             WA_IDCMP,
                                    IDCMP_CLOSEWINDOW,
                             TAG_DONE,          NULL);

  if (md.md_win)
  {
    SetAPen(md.md_win->RPort, 0);

    SetBPen(md.md_win->RPort, 1);

    /*
     * Lets install the exception handler that will be tied
     * to our window.
    */
    if ((sigbit = mem_addexhandler(
      md.md_win->UserPort->mp_SigBit, myhandler, &md)) > -1)
    {
      /*
       * From now on whenever Intuition generates a message
       * we do not have to worry about dispatching it here,
       * cus handler will take care of that so we can do
       * something totally different.
      */
      while (1)
      {
        if (SetSignal(0L, 0L) & SIGBREAKF_CTRL_C)
        {
          SetSignal(0L, SIGBREAKF_CTRL_C);

          break;
        }

        size = txt_psnprintf(
                    text, sizeof(text), "cnt = %ld", cnt++);

        size = QDEV_HLP_ABS(size);

        FPrintf(Output(), "%s\r", (LONG)text);

        Move(md.md_win->RPort, 25, 25);

        Text(md.md_win->RPort, text, size);

        Delay(10);
      }

      mem_remexhandler(sigbit);
    }

    ctl_haltidcmp(md.md_win);

    CloseWindow(md.md_win);
  }

  return 0;
}
