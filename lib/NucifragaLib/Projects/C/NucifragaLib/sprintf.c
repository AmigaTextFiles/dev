/*
 * Revision control info:
 *
 */

static const char rcsid[] =
   "$Id: sprintf.c 1.3 1995/10/23 20:22:01 JöG Exp JöG $";

/*
 * sprintf - a sprintf clone using exec/RawDoFmt()
 *
 * SAS/C 6.55 code - beware when porting:
 * autoinitalization of library bases
 * __oslibversion
 *
 *
 * Jörgen Grahn
 * Wetterlinsgatan 13E
 * S-521 34 Falköping
 * Sverige
 *
 */

/*
 * $Log: sprintf.c $
 * Revision 1.3  1995/10/23  20:22:01  JöG
 * changed my mind again about the header file
 *
 * Revision 1.2  1995/10/23  20:15:17  JöG
 * changed name of the header file used
 *
 * Revision 1.1  1995/10/23  14:04:32  JöG
 * Initial revision
 *
 */



#include <exec/types.h>

#include <proto/exec.h>

#include <stdlib.h>
#include <stdarg.h>

#include "support.h"



/*
 * The following RawDoFmt-sprintf code
 * comes from Doug Walker. Minor changes.
 *
 */
void supportsprintf(char * buf, char * fmt, ...)
{
   va_list args;

   va_start(args, fmt);

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

   RawDoFmt(fmt, args, (void (*))"\x16\xc0\x4e\x75", buf);

   va_end(args);
}
