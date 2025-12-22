/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** NewList                                                             **
 **                                                                     **
 *************************************************************************/

#ifndef NEWLIST_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

void __asm NewList(register __a0 struct List *); /* tiny NewList */

#endif


