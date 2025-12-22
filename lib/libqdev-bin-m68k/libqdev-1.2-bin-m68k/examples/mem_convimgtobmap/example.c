/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_convimgtobmap()
 *
*/

#include "../gid.h"

/*
 * Include our great Image ;-) as saved with PPaint.
*/
#define chip
#include "im_qdev.h"

#define WINDOWSIZE_X   320
#define WINDOWSIZE_Y   200



int GID_main(void)
{
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  struct BitMap tbm;
  struct BitMap *bm;
  WORD ptab[QDEV_MEM_RBP_PTABSIZE];
  VUQUAD hash = {0, 0};
  ULONG blitmem;
  ULONG sigs;
  LONG loop;
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
                    WA_Width,          WINDOWSIZE_X,
                    WA_Height,         WINDOWSIZE_Y,
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
           * This function aside from converting Image to
           * BitMap can also hash all planes on the fly!
          */
          mem_convimgtobmap(
                      &tbm, &im_qdev, &hash, mem_pjw64hash);

          FPrintf(Output(), "tbm = 0x%08lx\n"
                                    "hash = 0x%08lx%08lx\n",
                      (LONG)&tbm, hash.vuq_hi, hash.vuq_lo);

          /*
           * Lets see if we can use other than chip memory
           * for graphics.
          */
          blitmem = ((nfo_typeofgfxmem(GetVPModeID(
                      &cc->cc_mainwin->WScreen->ViewPort)) &
                      MEMF_CHIP) ? MEMF_CHIP : MEMF_PUBLIC);

          /*
           * OK. Lets remap this BitMap so we can actually
           * display it. Ptr. returned is totally different
           * bitmap!
          */
          QDEV_HLP_QUICKFILL(
                          &ptab[0], WORD, -1, sizeof(ptab));

          if ((bm = mem_remapbitmap2(
                                  &tbm, im_qdevPaletteRGB32,
                 cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                            ptab, blitmem)))
          {

            /*
             * Go and display it with logo rendition stuff.
            */
            if ((logo = ctl_addconlogo(cc, bm, 50, 30)))
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

            /*
             * Deassociate allocated pens.
            */
            mem_freepentab(
            cc->cc_mainwin->WScreen->ViewPort.ColorMap, ptab);
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
