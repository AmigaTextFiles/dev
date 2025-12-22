/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_attachhotvec()
 * mem_attachrelhotvec()
 * mem_detachhotvec()
 * mem_obtainhotvec()
 * mem_obtainrelhotvec()
 * mem_resolvehotvec()
 *
*/

#include "../gid.h"

/*
 * This private header is useful when one wants to quickly access
 * hot vector right after allocation.
*/
#include "a-mem_xxxhotvec.h"



/*
 * Static hot vector id should be between 0x00400000 and 0x7FFFFFFF.
*/
#define HOTVECID 0x004ABCDE

/*
 * Please remeber that anything less than 4 will always lead to 4 in
 * the end! It is the minimal array len possible.
*/
#define ARRAYLEN 0

#define STRING   "See me even though I was never given a global!"



/*
 * Please note that these funcs are totally isolated in terms that
 * they take no args nor refrence any data from the outside!
*/
void resolvedata(void)
{
  LONG **vec;


  if ((vec = mem_obtainhotvec(HOTVECID, 0)))
  {
    FPrintf(Output(), "%s\n", (LONG)*vec);
  }
}

void resolvedatadynamic(void)
{
  LONG **vec;


  if ((vec = mem_obtainrelhotvec(resolvedatadynamic, 0)))
  {
    FPrintf(Output(), "%s\n", (LONG)*vec);
  }
}

int GID_main(void)
{
  UBYTE *text = STRING;
  void *hot;
  LONG **vec;


  /*
   * Static allocator (just to explain how it works).
  */
  if ((hot = mem_attachhotvec(HOTVECID, ARRAYLEN)))
  {
    /*
     * NEW (1.2)! Can now determine if hot vector is valid. If the
     * ID is not 0 then allocation is valid. This may be useful in
     * managing remote allocations.
    */
    FPrintf(
         Output(), "HOTVECID = 0x%08lx\n", mem_resolvehotvec(hot));

    /*
     * Quickly access top of hot vec. You may 'mem_obtainhotvec()'
     * as well.
    */
    vec = QDEV_PRV_MEM_HOT_PTR(hot);

    /*
     * You have got at least 4 vectors for your disposal here. Will
     * use 0 in a direct manner.
     *
     * vec[0] = <address>;
     * vec[1] = <address>;
     * vec[2] = <address>;
     * vec[3] = <address>;
    */
    *vec = (LONG *)text;

    resolvedata();

    mem_detachhotvec(hot);
  }


  /*
   * Dynamic allocator is what you want to use in your programs as
   * wrapper address is guaranteed not to collide with other stuff
   * for 100%. Function pointer is turned into id above 0x7FFFFFFF
   * retaining its 31 bit base.
  */
  if ((hot = mem_attachrelhotvec(resolvedatadynamic, ARRAYLEN)))
  {
    vec = QDEV_PRV_MEM_HOT_PTR(hot);

    *vec = (LONG *)text;

    resolvedatadynamic();

    mem_detachhotvec(hot);
  }

  return 0;
}
