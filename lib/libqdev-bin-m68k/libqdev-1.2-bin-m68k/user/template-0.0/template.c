/*
 * template
 *
 * This is a quick 'qdev' fashioned template you may use in order to
 * write your own programs.
 *
 * Small  remark though. Do not put  non-prototyped functions before 
 * 'main()',  instead make a prototype  and put them  afterwards! We
 * are  kind  of low level here, so anything  in front is considered
 * entry point!
 * 
*/

#define ___QDEV_LIBINIT_REPORTERR      ___QDEV_LIBINIT_REPORTDEF
#define ___QDEV_LIBINIT_NOEXTRAS
#define ___QDEV_LIBINIT_SYS            36
#define ___QDEV_LIBINIT_DOS            36

#include "a-pre_xxxlibs.h"



#include "qdev.h"
#include "qversion.h"


static const UBYTE ___version[] = 
               "\0$VER: template 0.0 (10/11/2012) " _QV_STRING "\0";



/*
 * Always put  prototypes here. Never! Never put helper functions in
 * here!
*/
void myfunction(void);

int main(void)
{
  struct RDArgs *rda;
  LONG argv[1];
  int rc = 20;


  /*
   * Open neeeded libraries, because we do not use fully
   * featured startup code!
  */
  if (pre_openlibs())
  {
    /*
     * Prepare the arguments vector and read command line.
    */
    QDEV_HLP_QUICKFILL(&argv[0], LONG, 0, sizeof(argv));

    rda = ReadArgs("ARG=ARGUMENT",
    argv, NULL);

    if (rda)
    {
      rc = 5;

      if (argv[0])
      {
        rc = 0;
      }

      myfunction();

      FreeArgs(rda);
    }
    else
    {
      FPrintf(Output(),
              " *** template: template [arg=argument]\n");
    }
  }

  pre_closelibs();

  return rc;
}

void myfunction(void)
{
  FPrintf(Output(), "Hello Underworld!\n");
}
