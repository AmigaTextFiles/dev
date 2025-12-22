#ifndef CLIB_IOBLIX_PROTOS_H
#define CLIB_IOBLIX_PROTOS_H

/*
**      $VER: ioblix_protos.h 37.3 (7.4.99)
**
**      C prototypes. For use with 32 bit integers only.
**
**      (C) Copyright 1998 Thore Böckelmann
**      All Rights Reserved.
**
** (TAB SIZE: 8)
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef RESOURCES_IOBLIX_H
#include <resources/ioblix.h>
#endif

struct IOBlixChipNode *ObtainChip( ULONG chipType, ULONG chipNum, UBYTE *newOwner, UBYTE **oldOwner );
void ReleaseChip( struct IOBlixChipNode *node );
struct IOBlixChipNode *FindChip( ULONG chipType, ULONG chipNum );
struct List *AllocChipList( void );
void FreeChipList( struct List *list );
void AddIRQHook( struct IRQHookNode *node );
void RemIRQHook( struct IRQHookNode *node );
struct IOBlixChipNode *ObtainChipShared( ULONG chipType, ULONG chipNum, UBYTE *newOwner, UBYTE **oldOwner );
void ReleaseChipShared( struct IOBlixChipNode *node, UBYTE *owner );

#endif /* CLIB_IOBLIX_PROTOS_H */
