/*
 * Generic Init Definition (GID)
 *
 * A shortcut to "startupless" example(s) initialization.
*/

#define ___QDEV_LIBINIT_REPORTERR      ___QDEV_LIBINIT_REPORTDEF
#define ___QDEV_LIBINIT_NOEXTRAS
#define ___QDEV_LIBINIT_SYS            37
#define ___QDEV_LIBINIT_DOS            37
#define ___QDEV_LIBINIT_INTUITION      37
#define ___QDEV_LIBINIT_GFX            37
#define ___QDEV_LIBINIT_MATHFFP        37
#define ___QDEV_LIBINIT_ICON           37
#define ___QDEV_LIBINIT_LAYERS         37
#define ___QDEV_LIBINIT_ASL            37

#include "a-pre_xxxlibs.h"

#include <intuition/intuitionbase.h>
#include <devices/hardblocks.h>
#include <devices/conunit.h>
#include <dos/dostags.h>
#include <proto/alib.h>

#include "qdev.h"
                 


int GID_main(void);

int main(void)
{
  int rc = 666;


  if (pre_openlibs())
  {
    rc = GID_main();
  }

  pre_closelibs();

  return rc;
}
