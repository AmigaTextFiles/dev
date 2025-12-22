/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_growpenholder()
 * mem_freepenholder()
 *
*/

#include "../gid.h"

/*
 * Include our test images as saved in PPaint: Crab and Crash.
 * They have distinct palettes!
*/
#define chip
#include "im_crab.h"
#include "im_crash.h"



void dumpholder(WORD *htab)
{
  LONG cnt;


  for (cnt = 0; cnt < 16; cnt++)
  {
    FPrintf(Output(),
               "%4ld%4ld%4ld%4ld%4ld%4ld%4ld%4ld%4ld%4ld"
                            "%4ld%4ld%4ld%4ld%4ld%4ld\n",
    htab[0], htab[1], htab[2], htab[3], htab[4], htab[5],
            htab[6], htab[7], htab[8], htab[9], htab[10],
       htab[11], htab[12], htab[13], htab[14], htab[15]);

    htab += 16;
  }
}

struct BitMap *newimagetobitmap(struct Image *im,
                            ULONG *rgb32, struct ColorMap *cm,
                        WORD *ptab, WORD *htab, ULONG memtype)
{
  struct BitMap bm;
  struct BitMap *nbm;


  /*
   * Convert this Image to BitMap without using additional
   * memory.
  */
  mem_convimgtobmap(&bm, im, NULL, NULL);

  /*
   * Then remap it to fit given 'cm'. If successful then
   * grow global pen holder so that we do not need to have
   * separate pen caches per image.
  */
  if ((nbm = mem_remapbitmap2(&bm, rgb32, cm, ptab, memtype)))
  {
    /*
     * This will resolve pens the bitmap is now tied to 
     * and will store them as a count per element which is
     * logical pen number. This way we only need 512 bytes
     * to store per image pen cache.
    */
    mem_growpenholder(htab, ptab);
  }
  else
  {
    /*
     * Failure...
    */
    mem_freepentab(cm, ptab);
  }

  return nbm;
}

int GID_main(void)
{
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  struct BitMap *bm_crab;
  struct BitMap *bm_crash;
  WORD ptab[QDEV_MEM_RBP_PTABSIZE];
  WORD htab[QDEV_MEM_RBP_PTABSIZE];
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
       * Turn off outmasking so we can blast two bitmpas at
       * the same time using one handle.
      */
      cc->cc_lflags = QDEV_CTL_LFLLOGO_AREA;

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
                    WA_Width,          320,
                    WA_Height,         200,
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
           * Initialize the pen cache. All elements to -1.
          */
          QDEV_HLP_QUICKFILL(&ptab[0], WORD, -1, sizeof(ptab));

          /*
           * Initialize the pen holder. All elements to 0.
          */
          QDEV_HLP_QUICKFILL(&htab[0], WORD, 0, sizeof(htab));

          /*
           * We will have to turn both images to pure bitmaps
           * and then remap them to fit screen palette.
          */
          if ((bm_crab = newimagetobitmap(
                                &im_crab, im_crabPaletteRGB32,
                   cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                       ptab, htab, blitmem)))
          {
            if ((bm_crash = newimagetobitmap(
                              &im_crash, im_crashPaletteRGB32,
                   cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                       ptab, htab, blitmem)))
            {
              /*
               * Show contents of the pen holder. Each table
               * entry is logical screen pen and the number
               * it carries is how many times it was queried
               * for.
              */
              dumpholder(htab);

              /*
               * Go and display it with logo rendition stuff.
              */
              if ((logo = ctl_addconlogo(cc, bm_crab, 0, 0)))
              {
                ctl_swapconlogo(
                       logo, bm_crash, im_crab.Width + 1, 0);

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
                          ctl_swapconlogo(logo, bm_crab, 0, 0);

                          ctl_swapconlogo(
                         logo, bm_crash, im_crab.Width + 1, 0);

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

              FreeBitMap(bm_crash);
            }

            FreeBitMap(bm_crab);

            /*
             * Deallocate screen pens both bitmaps were using!
            */
            mem_freepenholder(
                   cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                                        htab);
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
