/*
** mmu.library proto-types
**
*/

#ifndef CLIB_MMU_PROTOS_H
#define CLIB_MMU_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

ULONG GetBit_PROTECTION_AWARE( void );
ULONG GetBit_COOKIE( void );
ULONG GetBit_TASK_READONLY( void );
ULONG GetBit_GLOBAL_READONLY( void );
ULONG GetBit_GLOBAL_ILLEGAL( void );
ULONG GetBit_WRITETHROUGH( void );
ULONG GetBit_NOCACHE( void );
ULONG AnalyzeEnforcerHit( APTR hitAddress, struct Task *task );

APTR AllocExecMem(ULONG size, ULONG type);
void FreeExecMem(APTR address, ULONG size);

void AcceptParentTask( struct Task *task );
void AdoptTask( struct Task *task );
void ChangeThreadOwner( struct Task *task );

/* note: returns values in d0:a0 */
ULONG SetReadonly(ULONG page);

/* note: returns values in d0:a0 */
ULONG SetIllegal(ULONG page);

void RestoreDescriptor(ULONG descriptor, APTR address);
void SetPageDescriptor(ULONG descriptor, APTR address);
#endif /* CLIB_MMU_PROTOS_H */
