/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * crt_newinstance()  ---> QDEV_QCRT_NEW
 * crt_freeinstance() ---> QDEV_QCRT_NEW
 *
*/

#define ___QDEV_LIBINIT_SYS            34
#define ___QDEV_LIBINIT_DOS            34

#include "a-pre_xxxlibs.h"



#include "qdev.h"
#include "qversion.h"
#include "qcrt0.h"



static const UBYTE ___version[] =
             "\0$VER: example 1.0 (25/04/2014) " _QV_STRING "\0";



/*
 * Try to compile this program either with '-resident' flag and
 * without it and make it 'resident example pure' and check out
 * what happens by launching it multiple times.
*/
int main(int argc, char **argv)
{
  struct qcrtregs *cr;
  static LONG test = 0;
  UBYTE buf[32];
  LONG count;
  int rc = 20;


  if (QDEV_QCRT_CHECK(argv))
  {
    cr = (struct qcrtregs *)argv;

    /*
     * From now on data (globals, statics, ...) from each object
     * that was compiled to be resident will be copied. In other
     * words new data instance will be created.
    */ 
    QDEV_QCRT_NEW
    (
      cr,

      if (pre_openlibs())
      {
        rc = 0;

        count = txt_psnprintf(
                        buf, sizeof buf, "test = %ld\n", test++);

        Write(Output(), buf, QDEV_HLP_ABS(count));
      }

      pre_closelibs();
    );
  }

  return rc;
}
