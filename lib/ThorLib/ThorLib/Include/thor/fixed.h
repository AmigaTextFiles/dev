/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** definition for fixed point-numbers (long & short)                   **
 **                                                                     **
 *************************************************************************/

#ifndef FIXED_H
#define FIXED_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/* typedef & define for short fixed numbers, they are scaled from 0 to 0xffff
   and represend numbers between 0 and 0.9999 */

#ifndef FIXED           /* obsolete */
#define FIXED   UWORD
#define MAXFIX  (0xffff)
#endif

#ifndef TYPE_FIXED
typedef UWORD   Fixed;
#define TYPE_FIXED
#endif

/* typedef & define for long fixed numbers, they are also scaled and represent
   numbers between -32768 and 32767.9999 */

#ifndef LIXED           /* obsolete */
#define LIXED LONG

typedef LONG Lixed;

union uLixed {          /* union for access to integer & fractional part, obsolete */
                struct {
                        WORD    lxr_int;
                        Fixed   lxr_frac;
                }       lx_tr;
                int     lx_ir;
};

/* shortcuts */
#define lx_int  lx_tr.lxr_int
#define lx_frac lx_tr.lxr_frac
#define lx_whole lx_ir

#define LCTR(a) {{(WORD)(a),(Fixed)((a)*0xffff)}} /* double to uLixed,obsolete */

#define LCIR(a) ((Lixed)((a)*0x10000))  /* convert double to lixed */
#endif

#endif

