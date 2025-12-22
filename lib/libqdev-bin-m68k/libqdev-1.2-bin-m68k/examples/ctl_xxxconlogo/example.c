/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_addconlogo()
 * ctl_swapconlogo()
 * ctl_remconlogo()
 *
*/

#include "../gid.h"

/*
 * Include our test images as saved in PPaint: Jade and Billy.
*/
#define chip
#include "im_jade.h"
#include "im_billy.h"



struct BitMap *imagetobitmap(struct Image *im,
                            ULONG *rgb32, struct ColorMap *cm,
                                    WORD *ptab, ULONG memtype)
{
  struct BitMap bm;


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

int GID_main(void)
{
  struct ctl_csn_feed cf;
  struct ctl_csn_data *cd;
  struct ctl_csn_cwin *cc;
  struct BitMap *bm_jade;
  struct BitMap *bm_billy;
  void *logo;
  WORD ptab[QDEV_MEM_RBP_PTABSIZE];
  ULONG blitmem;


  /*
   * Lets 0 all structure members first so overall param feed
   * will be sane.
  */
  txt_memfill(&cf, 0, sizeof(cf));

  /*
   * Now lets fetch modeid of current screen.
  */
  nfo_getscparams(IntuitionBase->ActiveScreen,
                                        &cf.cf_modeid, NULL);

  cf.cf_depth = 4;

  /*
   * OK, open the console screen with just one console window.
  */
  cf.cf_backpen = 1;

  cf.cf_numcon = 1;

  cf.cf_active = 0;

  if ((cd = ctl_openconscreen(&cf)))
  {
    /*
     * Lets buffer the first window for the sake of handiness.
    */
    cc = &cd->cd_cc[0];

    /*
     * Firstly try to save as much chip memory as possible.
    */
    blitmem = ((nfo_typeofgfxmem(GetVPModeID(
                        &cc->cc_mainwin->WScreen->ViewPort)) &
                        MEMF_CHIP) ? MEMF_CHIP : MEMF_PUBLIC);

    /*
     * Then initialize the pen cache. No need for pen holder
     * since both images have same palette.
    */
    QDEV_HLP_QUICKFILL(&ptab[0], WORD, -1, sizeof(ptab));

    /*
     * Hack on first entry to achieve pseudo-transparency.
    */
    ptab[0] = 0;

    /*
     * We will have to turn both images to pure bitmaps and
     * then remap them to fit screen palette.
    */
    if ((bm_jade = imagetobitmap(
                                &im_jade, im_jadePaletteRGB32,
                   cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                              ptab, blitmem)))
    {
      if ((bm_billy = imagetobitmap(
                              &im_billy, im_billyPaletteRGB32,
                   cc->cc_mainwin->WScreen->ViewPort.ColorMap,
                                              ptab, blitmem)))
      {
        /*
         * Before installing the logo lets increase Y area to
         * match the image height.
        */
        cc->cc_rpylim = im_jade.Height;

        /*
         * Now we can install the logo. Lets start from Jade.
        */
        if ((logo = ctl_addconlogo(cc, bm_jade, 0, 0)))
        {
          FPrintf(cc->cc_con, "This is Jade.\n");

          Delay(100);

          /*
           * Then switch to Billy.
          */
          ctl_swapconlogo(logo, bm_billy, im_billy.Width, 0);

          FPrintf(cc->cc_con, "And this is Billy!\n");

          Delay(100);

          ctl_remconlogo(logo);
        }

        FreeBitMap(bm_billy);
      }

      FreeBitMap(bm_jade);

      /*
       * Before we can free the pens we will have to revert
       * back what we did hack!
      */
      ptab[0] = -1;

      mem_freepentab(
            cc->cc_mainwin->WScreen->ViewPort.ColorMap, ptab);

    }

    ctl_closeconscreen(cd);
  }

  return 0;
}
