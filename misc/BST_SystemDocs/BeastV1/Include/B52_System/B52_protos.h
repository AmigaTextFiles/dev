#ifndef  CLIB_B52_PROTOS_H
#define  CLIB_B52_PROTOS_H

/****h* Beast/B52_Protos.h [1.0b]
*
*  NAME
*    B52 proto types --
*
*  COPYRIGHT
*    Maverick Software Development 1995
*
*  FUNCTION
*
*  AUTHOR
*    Frans Slothouber
*
*  CREATION DATE
*
*  MODIFICATION HISTORY
*
*  NOTES
*
******
*/

#include <exec/types.h>

struct B52_Handle
{
  ULONG  dict_size ;
  void   *dict ;
  ULONG  stack_size ;
  void   *stack ;
} ;

ULONG             B52_Execute      (struct B52_Handle *,
                                    UWORD *program,
                                    void *call_back,
                                    struct TagItem *) ;
void              B52_Free         (struct B52_Handle *) ;
struct B52_Handle *B52_Alloc_Handle (void) ;

#endif	 /* CLIB_B52_PROTOS_H */
