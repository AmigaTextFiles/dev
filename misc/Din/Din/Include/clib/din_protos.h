#ifndef  CLIB_DIN_PROTOS_H
#define  CLIB_DIN_PROTOS_H
/*
**  $Filename: clib/din_protos.h $
**  $Release: 1.0 revision 3 $
**  $Revision: 3 $
**  $Date: 10 Nov 90 $
**
**	C prototypes.
**
**  © Copyright 1990 Jorrit Tyberghein.
**    All Rights Reserved
*/

/* "din.library" */

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef  LIBRARIES_DIN_H
#include <libraries/din.h>
#endif

ULONG NotifyDinLinks (struct DinObject *dob, ULONG Flags);
void ResetDinLinkFlags (struct DinLink *dl);
struct DinObject *MakeDinObject (char *Name, UWORD Type, ULONG Flags, APTR po, ULONG Size);
BOOL EnableDinObject (struct DinObject *dob);
BOOL DisableDinObject (struct DinObject *dob);
BOOL PropagateDinObject (struct DinObject *dob, struct Task *task);
BOOL RemoveDinObject (struct DinObject *dob);
BOOL LockDinObject (struct DinObject *dob);
BOOL UnlockDinObject (struct DinObject *dob);
struct DinObject *FindDinObject (char *Name);
struct DinLink *MakeDinLink (struct DinObject *dob, char *Name);
void RemoveDinLink (struct DinLink *dl);
BOOL ReadLockDinObject (struct DinObject *dob);
void ReadUnlockDinObject (struct DinObject *dob);
BOOL WriteLockDinObject (struct DinObject *dob);
void WriteUnlockDinObject (struct DinObject *dob);
void LockDinBase (void);
void UnlockDinBase (void);
struct InfoDinObject *InfoDinObject (struct DinObject *dob);
void FreeInfoDinObject (struct InfoDinObject *ido);

#endif   /* CLIB_DIN_PROTOS_H */
