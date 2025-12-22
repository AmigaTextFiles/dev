/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_allocvecpooled()
 * mem_freevecpooled()
 * mem_setvecpooled()
 *
*/

#include "../gid.h"

#define PUDDLESIZE   8192  /* Puddle size if alloc below TRESHLSIZE */
#define TRESHLSIZE   8192  /* Treshold. All above, gets own puddle  */

#define MEMORYSIZE   4096



int GID_main(void)
{
  UBYTE *ptr;
  LONG alloc;
  LONG amnt;


  /*
   * This implementaion of pool allocator is somewhat different
   * but on the other hand can directly replace Alloc/FreeVec()!
   * Before you ever attempt to allocate the memory you can set
   * some params, such as puddle and treshold per memory node.
  */
  QDEV_MEM_XXXVPINIT(MEMF_PUBLIC, PUDDLESIZE, TRESHLSIZE);

  if ((ptr = mem_allocvecpooled(MEMORYSIZE, MEMF_PUBLIC)))
  {
    /*
     * As you can see it all looks pretty much standard, except
     * that you can see some statistics ;-) .
    */
    alloc = mem_setvecpooled(MEMF_PUBLIC,
                  QDEV_MEM_XXXVPI_REAL, QDEV_MEM_XXXVPV_NOCH);

    amnt = mem_setvecpooled(MEMF_PUBLIC,
                  QDEV_MEM_XXXVPI_AMNT, QDEV_MEM_XXXVPV_NOCH);

    FPrintf(Output(), "real alloc.   = %ld\n", alloc);

    FPrintf(Output(), "no. of alloc. = %ld\n", amnt);

    mem_freevecpooled(ptr);
  }

  return 0;
}
