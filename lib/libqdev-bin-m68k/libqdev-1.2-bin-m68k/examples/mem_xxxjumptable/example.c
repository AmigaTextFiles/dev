/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_allocjumptable()
 * mem_freejumptable()
 * mem_swapjumptable()
 * mem_filljumptable()
 * mem_importjumptable()
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



/*
 * Private StrToLong() replacement. Originally at offset -816 (slot
 * 136).
*/
LONG myStrToLong(REGARG(STRPTR string, d1), REGARG(LONG *value, d2),
                                 REGARG(struct Library *dosbase, a6))
{
  if (cnv_ALtoULONG(string, value, 0) == 0)
  {
    return -1;
  }

  return txt_strlen(string);
}

void testStrToLong(void)
{
  LONG value = 0;


  StrToLong("0 x ABAD C0DE", &value);

  FPrintf(Output(), "value = 0x%08lx\n", value);
}

/*
 * Please note that A6 points at local jump table and not DOSBase!
 * You need to 'dosbase = *(struct Library **)jt;' to get the base
 * pointer.
*/
LONG unimplemented(REGARG(struct Library *jt, a6))
{
  FPrintf(Output(), "Unimplemented!\n");

  return 0;
}

int GID_main(void)
{
  struct Library **jt;
  struct Library **old;


  /*
   * Allocate new jump table as big as OS 3.1 DOSBase one plus 25 %
   * to be on the safe side. Notice the flag. It means that caches
   * will not be flushed after calling 'mem_filljumptable()',
   * 'mem_importjumptable()', 'mem_setaddrjtslot()' and
   * mem_setdatajtslot()'. Function 'mem_swapjumptable()' always
   * flushes caches. Doing 'mem_swapjumptable(NULL, jt)' will unset
   * QDEV_MEM_LBS_FNOFLUSH and flush caches!
  */
  if ((jt = mem_allocjumptable(
                    QBASESLOTS(DOSBase, 25), QDEV_MEM_LBS_FNOFLUSH)))
  {
    /*
     * If 0 then jump table has been imported in whole. Positive val.
     * would mean that 'jt' is too small and negative that 'jt' is
     * not compatible.
     *
     * We are about to import DOSBase function table in a relative
     * way. This means that if someone else will patch it we will be
     * able to use the replacements as well. 
    */
    if (mem_importjumptable(jt, (struct Library **)&DOSBase) == 0)
    {
      /*
       * Now we are interested in patching local jump table so
       * that StrToLong() can accept other numeral systems such as
       * HEX, OCT, BIN and DEC of course and digit grouped strings.
       * The original cannot do that.
       *
       * Note that this replacement is not OS wide. Only this proc.
       * will benefit. OK patch it.
      */
      mem_setaddrjtslot(
                  jt, (LONG)myStrToLong, QDEV_PRV_LBS_OFF2SLOT(816));

      /*
       * BEFORE.
      */
      testStrToLong();

      /*
       * Activate local jump tab. QBASEPOINTER() macro selects local
       * base.
      */
      if ((old = mem_swapjumptable(
                       (struct Library *)QBASEPOINTER(DOSBase), jt)))
      {
        /*
         * AFTER.
        */
        testStrToLong();

        /*
         * Restore original jump table. You should call this in case
         * you do not want replacements at some point.
        */
        mem_swapjumptable(
                       (struct Library *)QBASEPOINTER(DOSBase), old);
      }

      /*
       * Lets now focus on 'mem_filljumptable()' which is very handy
       * in catching unimplemented functions for instance. The way
       * how the driver func. looks its up to you. I will just demo
       * basic prinicple. We fill every slot, except VFPrintf() that
       * is at -354 and Output() that is at -60 as we need both!
       * Last two args are: start slot and number of slots.
      */
      mem_filljumptable(jt, -1,
                        (LONG)unimplemented, 1, QBASESLOTS(DOSBase));

      /*
       * If args 2 and 3 are -1 then call entry will be restored.
      */
      mem_filljumptable(jt, -1, -1, QDEV_PRV_LBS_OFF2SLOT(354), 1);

      mem_filljumptable(jt, -1, -1, QDEV_PRV_LBS_OFF2SLOT(60), 1);

      /*
       * OK. Activate 'jt'.
      */
      if ((old = mem_swapjumptable(
                       (struct Library *)QBASEPOINTER(DOSBase), jt)))
      {
        /*
         * Calling here pretty much anything will direct to function
         * unimplemented(). Good points? Yep. Instead of a crash due
         * to no function at certain offset a message :-) .
        */
        Open("whatever", MODE_OLDFILE);

        Cli();

        IsFileSystem("DISK:");

        //...

        /*
         * Clean up.
        */
        mem_swapjumptable(
                       (struct Library *)QBASEPOINTER(DOSBase), old);
      }
    }

    mem_freejumptable(jt);
  }

  return 0;
}
