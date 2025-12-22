/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_iloadseg()
 *
*/

#include "../gid.h"

/*
 * Lets include what we did hexdump, so that it can be
 * incorporated into this binary.
*/
#include "hello.h"



int GID_main(void)
{
  struct Process *pr;
  BPTR fd;
  LONG segs;


  /*
   * Make a copy of current window dialog, so that new
   * process can use it after we are gone.
  */
  if ((fd = Open("CONSOLE:", MODE_OLDFILE)))
  {
    /*
     * Scatter-load hexdumped binary. Using second ver
     * here cus it is better :-) .
    */
    if ((segs = mem_iloadseg2(hello, sizeof(hello))))
    {
      /*
       * Now just start separate process whose code is
       * totally standalone.
      */
      pr = CreateNewProcTags(
                     NP_Seglist    , (ULONG)segs,
                     NP_FreeSeglist, TRUE,
                     NP_Cli        , TRUE,
                     NP_CommandName, (ULONG)"helloworld",
                     NP_Name       , (ULONG)"mytask",
                     NP_StackSize  , 4096,
                     NP_Output     , fd,
                     NP_CloseOutput, TRUE,
                     NP_CloseInput , TRUE,
                     TAG_DONE      , NULL);

      if (pr == NULL)
      {
        /*
         * Too bad, the process did not fire for some
         * reason, so clean everything up.
        */
        Close(fd);

        mem_uniloadseg2(segs);
      }
    }
  }

  return 0;
}
