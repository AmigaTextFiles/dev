/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_copyitnimage()
 * mem_freeitnimage()
 *
*/

#include "../gid.h"

/*
 * Include our great Image ;-) as saved with PPaint.
*/
#define chip
#include "im_qdev.h"



int GID_main(void)
{
  struct Image *im;


  /*
   * So here is the problem. Your proggy was loaded into
   * public memory which happens to be fast memory and the
   * image was compiled in. Naturally you cannot blit this
   * image on a stock Miggy, so you will have to copy it
   * into chip ram.
  */
  if (TypeOfMem(&im_qdev.ImageData) & MEMF_CHIP)
  {
    /*
     * No need to copy, already in chip memory.
    */
    im = &im_qdev;
  }
  else
  {
    /*
     * We are about to copy.
    */
    im = mem_copyitnimage(&im_qdev, MEMF_CHIP);
  } 

  /*
   * If 'im' equals '&im_qdev' then proggy was loaded in
   * chip ram. If 'im' is NULL then there was not enough
   * memory.
  */
  FPrintf(Output(), "--- %s: 0x%08lx ---\n"
                    "LeftEdge   = %ld\n"
                    "TopEdge    = %ld\n"
                    "Width      = %ld\n"
                    "Height     = %ld\n"
                    "Depth      = %ld\n"
                    "ImageData  = 0x%08lx (%ld)\n"
                    "PlanePick  = 0x%02lx\n"
                    "PlaneOnOff = 0x%02lx\n"
                    "NextImage  = 0x%08lx\n\n",
                                (LONG)"im     ", (LONG)im,
                                             im->LeftEdge,
                                              im->TopEdge,
                                                im->Width,
                                               im->Height,
                                                im->Depth,
                                      (LONG)im->ImageData,
                (QDEV_HLP_RASSIZE(im->Width, im->Height) *
                        QDEV_HLP_POPCOUNT(im->PlanePick)),
                                            im->PlanePick,
                                           im->PlaneOnOff,
                                     (LONG)im->NextImage);

  FPrintf(Output(), "--- %s: 0x%08lx ---\n"
                    "LeftEdge   = %ld\n"
                    "TopEdge    = %ld\n"
                    "Width      = %ld\n"
                    "Height     = %ld\n"
                    "Depth      = %ld\n"
                    "ImageData  = 0x%08lx (%ld)\n"
                    "PlanePick  = 0x%02lx\n"
                    "PlaneOnOff = 0x%02lx\n"
                    "NextImage  = 0x%08lx\n",
                          (LONG)"im_qdev", (LONG)&im_qdev,
                                         im_qdev.LeftEdge,
                                          im_qdev.TopEdge,
                                            im_qdev.Width,
                                           im_qdev.Height,
                                            im_qdev.Depth,
                                  (LONG)im_qdev.ImageData,
                                      sizeof(im_qdevData),
                                        im_qdev.PlanePick,
                                       im_qdev.PlaneOnOff,
                                 (LONG)im_qdev.NextImage);

  /*
   * Now lets free the image if it was copied at all.
  */
  if ((im) && (im != &im_qdev))
  {
    mem_freeitnimage(im);
  }

  return 0;
}
