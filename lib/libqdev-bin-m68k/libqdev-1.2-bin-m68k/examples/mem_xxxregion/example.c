/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_allocmemregion()
 * mem_freememregion()
 *
*/

#include "../gid.h"

#define MEMORYSIZE   4096



/*
 * Remember! Regional allocation carries MemChunk on its own!
*/
struct mymemregion
{
  struct MemChunk  mr_mc;
  UBYTE            mr_buf[MEMORYSIZE];
};



int GID_main(void)
{
  struct mymemregion *mr;
  LONG size;


  /*
   * First thing you must do is to align the allocation to be
   * on the safe side!
  */
  size = QDEV_MEM_REGALIGN(sizeof(struct mymemregion));

  /*
   * Then you can request that kinda memory, specifying the
   * region as start and stop addresses.
  */
  if ((mr = mem_allocmemregion(size, MEMF_PUBLIC | MEMF_LOCAL,
          QDEV_MOD_ADE_24BITLOWER, QDEV_MOD_ADE_32BITUPPER)))
  {
    /*
     * The memory is always allocated upside down, and that
     * is why you will notice high addresses.
    */
    FPrintf(Output(), "allocated 0x%08lx - 0x%08lx, %s\n",
                                  (LONG)mr, (LONG)mr + size,
       (LONG)(TypeOfMem(mr) & MEMF_CHIP ? "chip" : "public"));

    mem_freememregion(mr, size);
  }

  return 0;
}
