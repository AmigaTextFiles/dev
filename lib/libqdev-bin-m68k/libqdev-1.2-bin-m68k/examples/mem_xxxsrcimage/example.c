/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_readsrcimage()
 * mem_freesrcimage()
 *
*/

#include "../gid.h"

/*
 * Useful private defines are here, you will need them to extract
 * the palette off 'im'!
*/
#include "p-mem_xxxsrcimage.h"
#include "a-ctl_xxxconlogo.h"



#define DISPLAYTEXT "Pick Personal Paint 7.x C style 'struct Image' file."
#define DISPLAYTEXT2 "Press LMB on window body to switch to next pic!"



LONG aslrequester(UBYTE *pub, UBYTE *ptr, LONG size)
{
  UBYTE buf[128];
  LONG iptr = (LONG)buf;
  struct FileRequester *fr;
  struct TagItem asltags[] =
  {
    { ASLFR_InitialDrawer     , NULL  },
    { ASLFR_InitialFile       , NULL  },
    { ASLFR_InitialPattern    , NULL  },
    { ASLFR_TitleText         , NULL  },
    { ASLFR_PositiveText      , NULL  },
    { ASLFR_NegativeText      , NULL  },
    { ASLFR_AcceptPattern     , NULL  },
    { ASLFR_RejectPattern     , NULL  },
    { ASLFR_DoSaveMode        , FALSE },
    { ASLFR_DoMultiSelect     , FALSE },
    { ASLFR_DrawersOnly       , FALSE },
    { ASLFR_RejectIcons       , TRUE  },
    { ASLFR_PubScreenName     , iptr  },
    { ASLFR_DoPatterns        , FALSE },
    { ASLFR_InitialShowVolumes, TRUE  },
    { TAG_DONE                , NULL  }
  };
  LONG res = 0;


  if (!(ctl_findscreensafe(pub, buf, sizeof(buf))))
  {
    iptr = NULL;
  }

  if ((fr = AllocAslRequest(ASL_FileRequest, asltags)))
  {
    if (AslRequest(fr, NULL))
    {
      *ptr = '\0';

      txt_strncat(ptr, fr->fr_Drawer, size);

      AddPart(ptr, fr->fr_File, size);

      res = 1;
    }

    FreeAslRequest(fr);
  }

  return res;
}

struct BitMap *tobitmap2(struct Image *im,
                                ULONG *rgb32, struct ColorMap *cm,
                                        WORD *ptab, ULONG memtype)
{
  struct BitMap bm;


  /*
   * Initialize the pen cache.
  */
  QDEV_HLP_QUICKFILL(ptab, WORD, -1, (QDEV_MEM_RBP_PTABSIZE * 2));

  /*
   * Convert this Image to BitMap without using additional
   * memory.
  */
  mem_convimgtobmap(&bm, im, NULL, NULL);

  /*
   * Then remap it to fit given 'cm'.
  */
  return mem_remapbitmap2(&bm, rgb32, cm, ptab, memtype);
}

void freebitmap2(struct BitMap *bm,
                                  struct ColorMap *cm, WORD *ptab)
{
  if (bm)
  {
    FreeBitMap(bm);
  }

  mem_freepentab(cm, ptab);
}

LONG countimages(struct Image *im)
{
  LONG cnt = 0;


  while (im)
  {
    cnt++;

    im = im->NextImage;
  }

  return cnt;
}

void putframenum(void *logo,
                     struct ctl_csn_cwin *cc, LONG curr, LONG tot)
{
  struct ctl_acl_data *ad = logo;
  UBYTE buf[16];
  UBYTE dec[QDEV_CNV_UXXXLEN];
  LONG len;


  buf[0] = '\0';

  txt_strncat(buf,
        cnv_ULONGtoA(dec, curr, QDEV_CNV_UXXXFBE_D), sizeof(buf));

  txt_strncat(buf, "/", sizeof(buf));

  len = txt_strncat(buf,
         cnv_ULONGtoA(dec, tot, QDEV_CNV_UXXXFBE_D), sizeof(buf));

  len = QDEV_HLP_ABS(len);

  SetAPen(cc->cc_mainwin->RPort, 0);

  SetBPen(cc->cc_mainwin->RPort, 1);

  Move(cc->cc_mainwin->RPort,
            ad->ad_startx + cc->cc_mainwin->RPort->Font->tf_XSize,
           ad->ad_starty + cc->cc_mainwin->RPort->Font->tf_YSize);

  Text(cc->cc_mainwin->RPort, buf, len);


}

void *openwindowstacksafe(struct ctl_csn_data *cd)
{
  return OpenWindowTags(NULL,
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
                                         IDCMP_REFRESHWINDOW |
                                           IDCMP_MOUSEBUTTONS,
                    WA_Activate,       TRUE,
                    WA_SizeGadget,     TRUE,
                    WA_DragBar,        TRUE,
                    WA_DepthGadget,    TRUE,
                    WA_CloseGadget,    TRUE,
                    WA_SimpleRefresh,  FALSE,
                    TAG_DONE,          0);
}

int GID_main(void)
{
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  struct Image *im;
  struct Image *pim;
  struct BitMap *bm;
  WORD ptab[QDEV_MEM_RBP_PTABSIZE];
  UBYTE file[256];
  ULONG blitmem;
  ULONG sigs;
  UBYTE *rgb32;
  LONG count;
  LONG curr;
  LONG loop;
  LONG error;
  void *logo;
  void *iimsg;


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
        if ((cc->cc_mainwin = openwindowstacksafe(cd)))
        {
          SetAPen(cc->cc_mainwin->RPort, 3);

          SetBPen(cc->cc_mainwin->RPort, 0);

          Move(cc->cc_mainwin->RPort, 32, 32);

          Text(cc->cc_mainwin->RPort,
                            DISPLAYTEXT, sizeof(DISPLAYTEXT) - 1);

          Move(cc->cc_mainwin->RPort, 32,
                       32 + cc->cc_mainwin->RPort->Font->tf_YSize);

          Text(cc->cc_mainwin->RPort,
                           DISPLAYTEXT2, sizeof(DISPLAYTEXT2) - 1);

          /*
           * Lets see if we can use other than chip memory
           * for graphics.
          */
          blitmem = ((nfo_typeofgfxmem(GetVPModeID(
                            &cc->cc_mainwin->WScreen->ViewPort)) &
                            MEMF_CHIP) ? MEMF_CHIP : MEMF_PUBLIC);

          /*
           * Allow user to select the picture to be loaded.
          */
          if (aslrequester("*", file, sizeof(file)))
          {
            /*
             * OK. Now just pseudo-compile the source code that
             * contains some 'Image's.
            */
            if ((im = mem_readsrcimage(&error, file)))
            {
              pim = im;

              curr = 1;

              count = countimages(im);

              /*
               * Yes, the palettes are implicitly attached!
              */
              rgb32 = (void *)im;

              rgb32 = (void *)
                           *(ULONG *)&rgb32[QDEV_PRV_PRL_M_RGB32];

              if ((bm = tobitmap2(im, (ULONG *)rgb32,
                       cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                                  ptab, blitmem)))
              {
                /*
                 * Display it with logo rendition stuff.
                */
                if ((logo = ctl_addconlogo(cc, bm, 0, 0)))
                {
                  putframenum(logo, cc, curr, count);

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
                            if (logo)
                            {
                              ctl_swapconlogo(logo, NULL, 0, 0);

                              putframenum(logo, cc, curr, count);
                            }

                            break;
                          }

                          case IDCMP_MOUSEBUTTONS:
                          {
                            if (cc->cc_imsg->Code == SELECTDOWN)
                            {
                              /*
                               * Ignore second such message.
                              */
                              if ((iimsg = GetMsg(
                                      cc->cc_mainwin->UserPort)))
                              {
                                ReplyMsg((struct Message *)iimsg);
                              }

                              /*
                               * Pressing LMB once transfers to the
                               * next image.
                              */
                              SetRast(cc->cc_mainwin->RPort, 0);

                              RefreshWindowFrame(cc->cc_mainwin);

                              if (logo)
                              {
                                ctl_remconlogo(logo);

                                logo = NULL;
                              }

                              freebitmap2(bm,
                       cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                                            ptab);

                              curr++;

                              if (!(pim = pim->NextImage))
                              {
                                pim = im;

                                curr = 1;
                              }

                              rgb32 = (void *)pim;

                              rgb32 = (void *)
                           *(ULONG *)&rgb32[QDEV_PRV_PRL_M_RGB32];

                              if ((bm = tobitmap2(
                                              pim, (ULONG *)rgb32,
                       cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                                  ptab, blitmem)))
                              {
                                logo = ctl_addconlogo(
                                                    cc, bm, 0, 0);

                                putframenum(logo, cc, curr, count);
                              }
                            }

                            break;
                          }

                          default:
                        }

                        ReplyMsg((struct Message *)cc->cc_imsg);
                      }
                    }
                  }

                  if (logo)
                  {
                    ctl_remconlogo(logo);
                  }
                }
              }

              freebitmap2(bm,
                       cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                                            ptab);

              mem_freesrcimage(im);
            }
            else
            {
              FPrintf(Output(), "error = %ld\n", error);
            }
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
