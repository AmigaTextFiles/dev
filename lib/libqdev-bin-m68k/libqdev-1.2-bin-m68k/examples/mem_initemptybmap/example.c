/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_initemptybmap()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct BitMap bm;
  ULONG w;
  ULONG h;
  ULONG d;
  ULONG f;

  /*
   * Of course no planes are allocated with this function!
   * You can however pass it to the blitting routines, so
   * that a ghost rect. will be rendered. Following bitmap
   * is BMF_STANDARD.
  */
  mem_initemptybmap(&bm, 320, 200, 8);

  w = GetBitMapAttr(&bm, BMA_WIDTH);

  h = GetBitMapAttr(&bm, BMA_HEIGHT);

  d = GetBitMapAttr(&bm, BMA_DEPTH);

  f = GetBitMapAttr(&bm, BMA_FLAGS);

  FPrintf(Output(),
               "bm = %ldx%ldx%ld, 0x%08lx\n", w, h, d, f);

  return 0;
}
