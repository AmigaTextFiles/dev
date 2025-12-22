/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Conversion BOOL <-> int for rexx                                    **
 **                                                                     **
 *************************************************************************/

#ifndef BOOL_H
#define BOOL_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef REXXSUPPORT_H
#include <thor/rexxsupport.h>
#endif

/* get the string representing the boolean variable. This will be
   either TRUE or FALSE */
char __regargs *GetBOOLString(BOOL yesno);

/* Convert any binary expression to BOOL. Valid are:
        TRUE,FALSE,YES,NO,ON,OFF and
        integers representing 0 or 1 */
FailCode __regargs CheckBOOL(char *bl);

#endif




