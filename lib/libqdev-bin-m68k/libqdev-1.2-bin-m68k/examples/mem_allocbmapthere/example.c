/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_allocbmapthere()
 *
*/

#include "../gid.h"

#define BITMAPSIZE_X   320
#define BITMAPSIZE_Y   200
#define BITMAPDEPTH      3



int GID_main(void)
{
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  struct BitMap *bm;
  struct RastPort rp;
  UBYTE decbuf[QDEV_CNV_UXXXLEN];
  UBYTE *text;
  WORD x;
  WORD y;
  ULONG blitmem;
  ULONG sigs;
  LONG loop;
  LONG mempre;
  LONG mempost;
  void *logo;


  /*
   * Firstly allocate memory for console screen emulation,
   * so we can use logo related funcs to render graphics.
  */
  if ((cd = AllocVec(
    sizeof(struct ctl_csn_data), MEMF_PUBLIC | MEMF_CLEAR)))
  {
    /*
     * Intilialize Intuition support semaphore.
    */
    InitSemaphore(&cd->cd_isem);

    /*
     * Then try to lock current screen.
    */
    if ((cd->cd_screen = ctl_lockscreensafe("*")))
    {
      /*
       * Attach the very first window to our handy pointer,
       * assign fakish console screen to the window and set
       * the max amount of screen available in Y axis.
      */
      cc = &cd->cd_cc[0];

      cc->cc_cd = cd;

      cc->cc_rpylim = cd->cd_screen->Height;

      /*
       * Obtain 'black hole' descriptor. A must!
      */
      if ((cc->cc_con = Open("NIL:", MODE_OLDFILE)))
      {
        /*
         * Now try to open the window.
        */
        if ((cc->cc_mainwin = OpenWindowTags(NULL,
                    WA_Left,           50,
                    WA_Top,            50,
                    WA_MinWidth,       50,
                    WA_MinHeight,      50,
                    WA_Width,          BITMAPSIZE_X,
                    WA_Height,         BITMAPSIZE_Y,
                    WA_MaxWidth,       cd->cd_screen->Width,
                    WA_MaxHeight,      cd->cd_screen->Height,
                    WA_PubScreen,      (LONG)cd->cd_screen,
                    WA_Title,          (LONG)"My window",
                    WA_IDCMP,          IDCMP_CLOSEWINDOW |
                                         IDCMP_REFRESHWINDOW,
                    WA_Activate,       TRUE,
                    WA_SizeGadget,     TRUE,
                    WA_DragBar,        TRUE,
                    WA_DepthGadget,    TRUE,
                    WA_CloseGadget,    TRUE,
                    WA_SimpleRefresh,  FALSE,
                    TAG_DONE,          0)))
        {
          /*
           * Lets see if we can use other than chip memory
           * for graphics.
          */
          blitmem = ((nfo_typeofgfxmem(GetVPModeID(
                      &cc->cc_mainwin->WScreen->ViewPort)) &
                      MEMF_CHIP) ? MEMF_CHIP : MEMF_PUBLIC);

          /*
           * OK. Lets allocate the bitmap where appropriate.
          */
          mempre = AvailMem(MEMF_CHIP);

          if ((bm = mem_allocbmapthere(BITMAPSIZE_X,
                       BITMAPSIZE_Y, BITMAPDEPTH, blitmem)))
          {
            mempost = AvailMem(MEMF_CHIP);

            /*
             * Initialize RastPort and associate the bitmap
             * with it so we can draw something.
            */
            InitRastPort(&rp);

            rp.BitMap = bm;

            /*
             * Fill our bitmap with colored rectangles.
            */
            x = BITMAPSIZE_X / 2;

            y = BITMAPSIZE_Y / 2;

            SetDrMd(&rp, JAM1);

            SetAPen(&rp, 0);

            RectFill(&rp, 0, 0, x - 1, y - 1);

            SetAPen(&rp, 1);

            RectFill(&rp, x, 0, (x + x) - 1, y - 1);

            SetAPen(&rp, 2);

            RectFill(&rp, 0, y, x - 1, (y + y) - 1);

            SetAPen(&rp, 3);

            RectFill(&rp, x, y, (x + x) - 1, (y + y) - 1);

            /*
             * Blast how much chip memory was before and is
             * left now.
            */
            text = cnv_ULONGtoA(
                       decbuf, mempre, QDEV_CNV_UXXXFBE_D);

            *--text = ' ';

            *--text = ':';

            *--text = 'B';

            Move(&rp, 15, 15);

            SetAPen(&rp, 1);

            Text(&rp, text, txt_strlen(text));

            /*
             * The 'decbuf' is big enough to stuff these
             * 3 additional bytes.
            */
            text = cnv_ULONGtoA(
                      decbuf, mempost, QDEV_CNV_UXXXFBE_D);

            *--text = ' ';

            *--text = ':';

            *--text = 'A';

            Move(&rp, x + 15, y + 15);

            SetAPen(&rp, 0);

            Text(&rp, text, txt_strlen(text));

            /*
             * Go and display it with logo rendition stuff.
            */
            if ((logo = ctl_addconlogo(cc, bm, 0, 0)))
            {
              /*
               * Lets wait for the signal or close window
               * message.
              */
              loop = 1;

              while(loop)
              {
                sigs = Wait(SIGBREAKF_CTRL_C |
               (1L << cc->cc_mainwin->UserPort->mp_SigBit));

                if (sigs & SIGBREAKF_CTRL_C)
                {
                  loop = 0;
                }
                else
                {
                  while ((cc->cc_imsg =
                  (void *)GetMsg(cc->cc_mainwin->UserPort)))
                  {
                    switch (cc->cc_imsg->Class)
                    {
                      case IDCMP_CLOSEWINDOW:
                      {
                        loop = 0;

                        break;
                      }

                      case IDCMP_REFRESHWINDOW:
                      {
                        ctl_swapconlogo(logo, NULL, 0, 0);

                        break;
                      }

                      default:
                    }

                    ReplyMsg((struct Message *)cc->cc_imsg);
                  }
                }
              }

              ctl_remconlogo(logo);
            }

            FreeBitMap(bm);
          }

          ctl_haltidcmp(cc->cc_mainwin);

          CloseWindow(cc->cc_mainwin);
        }

        Close(cc->cc_con);
      }

      ctl_unlockscreensafe(cd->cd_screen);
    }

    FreeVec(cd);
  }

  return 0;
}
