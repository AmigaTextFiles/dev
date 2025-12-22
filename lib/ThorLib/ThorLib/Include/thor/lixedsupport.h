/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for long fixed integer                            **
 **                                                                     **
 *************************************************************************/

#ifndef LIXEDSUPPORT_H
#define LIXEDSUPPORT_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef FIXED_H
#include <thor/fixed.h>
#endif

/* multiply two long fixed points, sets V on overflow... (nothing for C!) */
Lixed __asm lxmul(register __d0 Lixed a,register __d1 Lixed b);

/* divide two long fixed points */
Lixed __asm lxdiv(register __d0 Lixed a,register __d1 Lixed b);

/* round mathematically to integer */
int __asm lxint(register __d0 Lixed n);

#endif
