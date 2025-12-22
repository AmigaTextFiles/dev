/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * crt_initmethod() ---> QDEV_QCRT_METHOD
 * crt_exitmethod() ---> QDEV_QCRT_METHOD
 *
*/

#define ___QDEV_LIBINIT_CLIONLY        ___QDEV_LIBINIT_CLISTREAM
#define ___QDEV_LIBINIT_SYS            34
#define ___QDEV_LIBINIT_DOS           -34       /* Optional    */
#define ___QDEV_LIBINIT_GFX           -34       /* Optional    */
#define ___QDEV_LIBINIT_INTUITION     -34       /* Optional    */

#include "a-pre_xxxlibs.h"



#include "qdev.h"
#include "qversion.h"
#include "qcrt0.h"

#include <exec/resident.h>



/*
 * ROMTag structure so that this code can also be loaded as a
 * module. If you want to include your binary in new ROM which
 * can be compiled using Remus then do not forget about magic
 * '__caddr' attribute and always initialize all globals so no
 * BSS section is created.
*/
static const __caddr struct Resident ___resident =
{
  RTC_MATCHWORD,
  (struct Resident *)&___resident,
  (APTR)&___resident.rt_Init,
  RTF_COLDSTART,
  1,
  NT_UNKNOWN,
  -48,
  (UBYTE *)"example",
  (UBYTE *)"example 1.0",
  (APTR)QDEV_QCRT_ENTRY
};



/*
 * QCRT does not define any globals nor WBenchMsg. Its up to
 * you to define this. Then you will have to attach real msg.
 * See QDEV_QCRT_M_WB case.
*/
QDEV_QCRT_WBMSGDECL(___QDEV_LIBINIT_DEFWBSTARTUP) = 0;



static const UBYTE ___version[] =
             "\0$VER: example 1.0 (28/04/2014) " _QV_STRING "\0";



void MyPrint(UBYTE *text);

int main(int argc, char **argv)
{
  struct qcrtregs *cr;
  int rc = 20;


  /*
   * Check if user linked against QCRT0 startup code to be on
   * the safe side.
  */
  if (QDEV_QCRT_CHECK(argv))
  {
    cr = (struct qcrtregs *)argv;

    /*
     * Determine call site and how to init and exit. Workbench
     * startup message is being handled here.
    */
    QDEV_QCRT_METHOD
    (
      cr,

      /*
       * Create new data instance if some objects are resident.
      */
      QDEV_QCRT_NEW
      (
        cr,

        /*
         * Select the right scenario for this call site. It is
         * possible to jump from one case to the other.
        */
        QDEV_QCRT_MTHSEL
        (
          cr,

          /*
           * (Bootstrap)
          */
          QDEV_QCRT_MTHCODE
          (
            QDEV_QCRT_M_BOOT,

            /*
             * Jump to the CLI case since library loader loads
             * only those that are available now. Even though
             * DOS is not available here our code (MyPrint) is
             * aware of that.
            */
            QDEV_QCRT_MTHGOTO(QDEV_QCRT_M_CLI);
          );

          /*
           * (CLI/Shell)
          */
          QDEV_QCRT_MTHCODE
          (
            QDEV_QCRT_M_CLI,

            if (pre_openlibs())
            {
              MyPrint("Hello World!\n");

              rc = 0;
            }

            pre_closelibs();
          );

          /*
           * (Workbench)
          */
          QDEV_QCRT_MTHCODE
          (
            QDEV_QCRT_M_WB,

            /*
             * Jump to the CLI case so library loader can turn
             * us into QCLI process (___QDEV_LIBINIT_CLIONLY).
             * But first attach Workbench message.
            */
            QDEV_QCRT_WBMSGADDR(
                             cr, ___QDEV_LIBINIT_DEFWBSTARTUP);

            QDEV_QCRT_MTHGOTO(QDEV_QCRT_M_CLI);
          );
        );
      );
    );
  }

  return rc;
}

void MyPrint(UBYTE *text)
{
#define TEXTPERIOD 3
  struct Screen *s;
  LONG count;


  if ((DOSBase) && (Output()))
  {
    /*
     * This will be executed if started from CLI or Workbench.
    */
    Write(Output(), text, txt_strlen(text));
  }
  else
  {
    if ((GfxBase) && (IntuitionBase))
    {
      /*
       * This will be executed when this binary is loaded as
       * a resident module or is a part of ROM image.
      */
      if ((s = OpenScreenTags(NULL, 
                           SA_Depth,           1,
                           SA_DisplayID,       0,
                           SA_Title,           (LONG)"example",
                           SA_LikeWorkbench,   TRUE,
                           TAG_DONE,           0)))
      {
        Move(&s->RastPort, (s->Width / 2), (s->Height / 2));

        Text(&s->RastPort, text, txt_strlen(text));

        /*
         * Emulate Delay().
        */
        count = (SysBase->VBlankFrequency * TEXTPERIOD);

        while (count--)
        {
          WaitTOF();
        }

        CloseScreen(s);
      }
    }
  }
}
