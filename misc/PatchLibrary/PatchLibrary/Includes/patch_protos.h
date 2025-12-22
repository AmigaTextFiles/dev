/* patch_protos.h - prototypes for patch.library functions */
/* (C) Copyright 1993 Stefan Fuchs                         */

#ifndef CLIB_PATCH_H
#define CLIB_PATCH_H

struct Patch *InstallPatch( struct NewPatch *newPatch );
ULONG WaitRemovePatch( struct Patch *patch );
ULONG RemovePatch( struct Patch *patch );
struct Patch *FindPatch( UBYTE *name );

#endif  /* CLIB_PATCH_H */
