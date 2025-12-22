/* mpaddock@cix.compulink.co.uk */
/* mark@topic.demon.co.uk */

/* sprintf() using RawDoFmt() */

#define __USE_SYSBASE 1
#ifdef __GNUC__
#include <inline/exec.h>
#else
#include <proto/exec.h>
#endif
#include <stdarg.h>
/*#include <stdio.h> */

int sprintf(char *buffer,char *ctl, ...)
{
   va_list args;

   va_start(args, ctl);

   /*********************************************************/
   /* NOTE: The string below is actually CODE that copies a */
   /*       value from d0 to A3 and increments A3:          */
   /*                                                       */
   /*          move.b d0,(a3)+                              */
   /*          rts                                          */
   /*                                                       */
   /*       It is essentially the callback routine needed   */
   /*       by RawDoFmt.                                    */
   /*********************************************************/

   RawDoFmt(ctl, args, (void (*))"\x16\xc0\x4e\x75", buffer);

   va_end(args);

   return 0;
}
