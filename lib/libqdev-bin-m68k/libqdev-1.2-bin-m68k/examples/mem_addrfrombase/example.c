/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_addrfrombase()
 *
*/

/*
 * Enable Local Base Support for this object. This header must always
 * be included before any other headers!
*/
#include "qlbs.h"

#include "../gid.h"



int GID_main(void)
{
  struct Library **jt;


  /*
   * Allocate new jump table as big as OS 3.1 DOSBase one plus 25 %
   * to be on the safe side.
  */
  if ((jt = mem_allocjumptable(
                    QBASESLOTS(DOSBase, 25), QDEV_MEM_LBS_FNOFLUSH)))
  {
    /*
     * If 0 then jump table has been imported in whole. Positive val.
     * would mean that 'jt' is too small.
    */
    if (mem_importjumptable(jt, (struct Library **)&DOSBase) == 0)
    {
      /*
       * The reason why does the 'mem_addrfrombase()' exist is that
       * local jump tables are a bit different so 'mem_addrfromlvo()'
       * would return call entry instead of function pointer. Check
       * it out. Offset -492 is a 'Cli()' function.
      */
      FPrintf(Output(), 
                 "mem_addrfromlvo(DOSBase, -492)  = 0x%08lx\n",
                               (LONG)mem_addrfromlvo(DOSBase, -492));

      /*
       * Of course it is possible to modify call entry without the
       * need to save it. Use 'mem_filljumptable(jt, -1, -1, 82, 1)'
       * to restore it where 82 (492 / 6) is a slot number. In order
       * to compute slot from offset use macro that is available in
       * 'a-mem_xxxjumptable.h'.
      */
      FPrintf(Output(),
                 "mem_addrfromlvo(*jt    , -492)  = 0x%08lx (!)\n\n",
                                   (LONG)mem_addrfromlvo(*jt, -492));

      FPrintf(Output(),
                 "mem_addrfrombase(DOSBase, -492) = 0x%08lx\n",
                              (LONG)mem_addrfrombase(DOSBase, -492));

      FPrintf(Output(),
                 "mem_addrfrombase(*jt    , -492) = 0x%08lx\n\n",
                                  (LONG)mem_addrfrombase(*jt, -492));
    }

    mem_freejumptable(jt);
  }

  return 0;
}
