/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * crt_createargv()  ---> QDEV_QCRT_ARGV
 * crt_destroyargv() ---> QDEV_QCRT_ARGV
 *
*/

#define ___QDEV_LIBINIT_SYS            34
#define ___QDEV_LIBINIT_DOS            34

#include "a-pre_xxxlibs.h"



#include "qdev.h"
#include "qversion.h"
#include "qcrt0.h"



static const UBYTE ___version[] =
             "\0$VER: example 1.0 (04/05/2014) " _QV_STRING "\0";



int main(int argc, char **argv)
{
  struct qcrtregs *cr;
  UBYTE buf[128];
  LONG x;
  LONG len;
  int rc = 20;


  if (QDEV_QCRT_CHECK(argv))
  {
    cr = (struct qcrtregs *)argv;

    QDEV_QCRT_NEW
    (
      cr,

      QDEV_QCRT_ARGV
      (
        cr,
        argc,
        argv,

        if (pre_openlibs())
        {
          rc = 0;

          for(x = 0; x < argc; x++)
          {
            len = txt_psnprintf(
                buf, sizeof buf, "argv[%ld] = %s\n", x, argv[x]);

            Write(Output(), buf, QDEV_HLP_ABS(len));
          }
        }

        pre_closelibs();
      );
    );
  }

  return rc;
}
