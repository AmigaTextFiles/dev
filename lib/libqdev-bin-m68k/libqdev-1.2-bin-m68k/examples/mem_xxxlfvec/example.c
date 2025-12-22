/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_alloclfvec()
 * mem_freelfvec()
 * mem_checklfvec()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  void *ptr;


  /*
   * Not much of a wizardy here, except that freeing memory is
   * not mandatory and there will be no memory leak after exit.
  */
  ptr = mem_alloclfvec(1024, MEMF_PUBLIC);

  /*
   * NEW (1.2)! If for some reason you cannot determine if this
   * memory is still available use following function. Normally
   * right after allocation you would check ptr directly.
  */
  if (mem_checklfvec(ptr))
  {
    FPrintf(Output(), "Memory allocated!\n");

    /*
     * mem_freelfvec(ptr);
    */
  }

  return 0;
}
