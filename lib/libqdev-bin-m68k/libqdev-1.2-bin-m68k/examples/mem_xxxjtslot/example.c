/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_setaddrjtslot()
 * mem_setdatajtslot()
 *
*/

/*
 * Enable Local Base Support for this object. This header must always
 * be included before any other headers!
*/
#include "qlbs.h"

#include "../gid.h"

/*
 * Include this for extra macros.
*/
#include "a-mem_xxxjumptable.h"



struct mydata
{
  struct DosLibrary *md_db;
};



/*
 * Replacement for SetIoErr(). As you can see you do not have to
 * save old function address anywhere and then create func. ptr
 * to make a wrapper. This way call stays real base relative.
*/
LONG mySetIoErr(REGARG(LONG code, d1), REGARG(struct mydata *md, a6))
{
  QBASEDECL2(struct DosLibrary *, DOSBase, md->md_db);


  FPrintf(Output(),
               "About to call real SetIoErr(code = %ld)...\n", code);

  return SetIoErr(code);
}

int GID_main(void)
{
  struct mydata md;
  struct Library **jt;
  struct Library **old;


  /*
   * Setup mydata structure.
  */
  md.md_db = DOSBase;

  /*
   * Allocate new jump table of the size OS 3.1 DOSBase and prevent
   * from cache flushes until 'mem_swapjumptable()'.
  */
  if ((jt = mem_allocjumptable(
                        QBASESLOTS(DOSBase), QDEV_MEM_LBS_FNOFLUSH)))
  {
    /*
     * About to import DOSBase function table in a relative way.
    */
    if (mem_importjumptable(jt, (struct Library **)&DOSBase) == 0)
    {
      /*
       * Load mySetIoErr() in place of SetIoErr() which is at -462.
       * This affects this process only.
      */
      mem_setaddrjtslot(
                   jt, (LONG)mySetIoErr, QDEV_PRV_LBS_OFF2SLOT(462));

      /*
       * Attach custom data pointer too.
      */
      mem_setdatajtslot(jt, &md, QDEV_PRV_LBS_OFF2SLOT(462));

      /*
       * Activate local jump tab. QBASEPOINTER() macro selects local
       * base.
      */
      if ((old = mem_swapjumptable(
                       (struct Library *)QBASEPOINTER(DOSBase), jt)))
      {
        /*
         * Call the replacement.
        */
        SetIoErr(ERROR_OBJECT_EXISTS);

        FPrintf(Output(), "Error code: %ld\n", IoErr());

        /*
         * Restore original jump table. You should call this in case
         * you do not want replacements at some point.
        */
        mem_swapjumptable(
                       (struct Library *)QBASEPOINTER(DOSBase), old);
      }
    }

    mem_freejumptable(jt);
  }

  return 0;
}
