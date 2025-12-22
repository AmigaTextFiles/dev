/*
 * The purpose of this file is to demonstrate how to write code that:
 *
 * Uses minimalistic QCRT0 startup code
 *
*/

#define ___QDEV_LIBINIT_SYS            34
#define ___QDEV_LIBINIT_DOS            34

#include "a-pre_xxxlibs.h"



#include "qdev.h"
#include "qversion.h"
#include "qcrt0.h"



static const UBYTE ___version[] =
             "\0$VER: example 1.0 (17/04/2014) " _QV_STRING "\0";



/*
 * Despite standard C convention this is not what you think :-) .
 * First argument is always 1 and argv[0] contains an ID text.
*/
int main(int argc, char **argv)
{
  struct qcrtregs *cr;
  int rc = 20;


  /*
   * Check if we are a module and if so do not attempt to execute
   * anything below.
  */ 
  if (!(QDEV_QCRT_ISMOD()))
  {
    if (pre_openlibs())
    {
      rc = 0;

      /*
       * This assures compatibility with other startups so if you
       * link against different startup it won't attempt to enter
       * this.
      */
      if (QDEV_QCRT_CHECK(argv))
      {
        /*
         * Can now access command line arguments even under OS 1.3
        */
        cr = (struct qcrtregs *)argv;

        Write(Output(), cr->cr.m68k->a[0], cr->cr.m68k->d[0]);
      }
    }

    pre_closelibs();
  }

  return rc;
}
