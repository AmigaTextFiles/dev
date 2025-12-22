/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** AllocVec & FreeVec for V33                                          **
 **                                                                     **
 *************************************************************************/

#ifndef PRIVATEVECS_H
#define PRIVATEVECS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

/* allocvec a V37 vector under V33 */
void __asm *PrivateAllocVec(register __d0 ULONG size,register __d1 ULONG reqments);

/* free it */
void __asm PrivateFreeVec(register __a1 void *mem);

#endif
