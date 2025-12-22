/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_loadpicture()
 * mem_freepicture()
 *
*/

#include "../gid.h"

#define DISPLAYTEXT "Aside from #?.logo & #?.loco I use datatypes!"



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

/*
 * This func. creates storyboard when #?.logo pictures are
 * loaded, who contain more than one frame.
*/
void blastpictures(void *logo, struct BitMap **bm)
{
  struct BitMap **cbm = bm;
  LONG w;
  LONG h;
  LONG x = 0;
  LONG y = 0;


  w = GetBitMapAttr(*cbm, BMA_WIDTH) + 1;

  h = GetBitMapAttr(*cbm, BMA_HEIGHT) + 1;

  while (*cbm)
  {
    ctl_swapconlogo(logo, *cbm, x, y);

    x += w;

    /*
     * Let it be 5 frames per row.
    */
    if (!(x % (w * 5)))
    {
      x = 0;

      y += h;
    }

    cbm++;
  }
}

int GID_main(void)
{
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  struct BitMap **bm;
  UBYTE file[256];
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
          SetAPen(cc->cc_mainwin->RPort, 3);

          SetBPen(cc->cc_mainwin->RPort, 0);

          Move(cc->cc_mainwin->RPort, 32, 32);

          Text(cc->cc_mainwin->RPort,
                      DISPLAYTEXT, sizeof(DISPLAYTEXT) - 1);

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
             * OK. This function is different. Instead of a
             * pointer to single bitmap you are given vector
             * of bitmaps.
            */
            if ((bm = mem_loadpicture(file,
                 cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                             cc->cc_mainwin->RPort, blitmem, 
                                    QDEV_MEM_IFLPIC_SHRINK |
                                   QDEV_MEM_IFLPIC_GGD_FS)))
            {
              /*
               * Go and display it with logo rendition stuff.
              */
              if ((logo = ctl_addconlogo(cc, *bm, 0, 0)))
              {
                blastpictures(logo, bm);

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
                          blastpictures(logo, bm);

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

              mem_freepicture(bm);
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
