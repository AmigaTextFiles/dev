#ifndef MOB_PROTOS_H
#define MOB_PROTOS_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>

#include <proto/classes/supermodel.h>

/* private protos! */

BOOL i_SuperModelInit(void);
void i_SuperModelTerm(void);

BOOL i_SuperICInit(void); // called by above!
void i_SuperICTerm(void);

Class *i_MakeClass(STRPTR ClassID, STRPTR SuperClassID, APTR SuperClassPtr, ULONG ISize, ULONG Nil, ULONG(*Entry)() );

ULONG __asm __saveds SuperModel_Dispatch(register __a0 Class *CL, register __a2 Object *O, register __a1 Msg M);
ULONG __asm __saveds SuperIC_Dispatch(register __a0 Class *CL, register __a2 Object *O, register __a1 Msg M, register __a6 struct Library *LibBase);

#endif /* MOB_PROTOS_H */
