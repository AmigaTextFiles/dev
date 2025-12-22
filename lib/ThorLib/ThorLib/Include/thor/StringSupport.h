/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for strings (dummy)                               **
 **                                                                     **
 *************************************************************************/

#ifndef STRINGSUPPORT_H
#define STRINGSUPPORT_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef PROTO_UTILITY_H
#include <proto/utility.h>
#endif

/* compare strings non-case sensitive. Uses the utility-lib */
#define UStrCmp(a,b) Stricmp((a),(b))

#endif

