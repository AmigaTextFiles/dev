/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_freepentab()
 *
*/

#include "../gid.h"

/*
 * Include the test image as created with PPaint. Even though
 * this example does not intend to display it, it is needed to
 * illustrate how does the pen cache works. The image contains
 * horizontal raster bars that fall from darkest to brightest.
*/
#define chip
#include "im_raster.h"



void dumpcache(WORD *ptab)
{
  LONG cnt;


  for (cnt = 0; cnt < 16; cnt++)
  {
    FPrintf(Output(),
               "%4ld%4ld%4ld%4ld%4ld%4ld%4ld%4ld%4ld%4ld"
                            "%4ld%4ld%4ld%4ld%4ld%4ld\n",
    ptab[0], ptab[1], ptab[2], ptab[3], ptab[4], ptab[5],
            ptab[6], ptab[7], ptab[8], ptab[9], ptab[10],
       ptab[11], ptab[12], ptab[13], ptab[14], ptab[15]);

    ptab += 16;
  }
}

int GID_main(void)
{
  struct Screen *screen;
  struct BitMap *bm;
  struct BitMap tbm;
  WORD ptab[QDEV_MEM_RBP_PTABSIZE];


  /*
   * Lets lock current screen so we can get the palette.
  */
  if ((screen = ctl_lockscreensafe("*")))
  {
    /*
     * Initialize the pen cache. All entries shall be set
     * to -1.
    */
    QDEV_HLP_QUICKFILL(&ptab[0], WORD, -1, sizeof(ptab));

    /*
     * Attach all Image planes to BitMap plane pointers.
    */
    mem_convimgtobmap(&tbm, &im_raster, NULL, NULL);

    /*
     * Remap the image using pen cache. Why pen cache and
     * not just plain ObtainBestPen()? Well, there are at
     * least two reasons. One: caching reduces func. calls
     * and thus boosts the remapping. Two: you can preset
     * the pens and thus create the transparency masks!
    */
    if ((bm = mem_remapbitmap2(&tbm,
        im_rasterPaletteRGB32, screen->ViewPort.ColorMap,
                                     ptab, MEMF_PUBLIC)))
    {
      /*
       * Show cache organisation. Each entry is logical
       * image pen number that maps to screen's pen at
       * the moment.
      */
      dumpcache(ptab);

      FreeBitMap(bm);

      /*
       * Now release each cached pen. Please note that if
       * you did setup your own value in the cache before
       * calling remap routine you will have to revert it
       * to -1!
      */
      mem_freepentab(screen->ViewPort.ColorMap, ptab);
    }

    ctl_unlockscreensafe(screen);
  }

  return 0;
}
