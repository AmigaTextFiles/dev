#ifndef CLIB_BGUI_PROTOS_H
#define CLIB_BGUI_PROTOS_H
/*
**      $VER: clib/bgui_protos.h 37.1 (12.10.93)
**      bgui.library prototypes. For use with 32 bit integers only.
**
**
**      (C) Copyright 1993-1994 Jaba Development.
**      (C) Copyright 1993-1994 Jan van den Baard.
**          All Rights Reserved.
**/

#ifndef LIBRARIES_BGUI_H
#include <libraries/bgui.h>
#endif

Class *BGUI_GetClassPtr( ULONG );
Object *BGUI_NewObjectA( ULONG, struct TagItem * );
ULONG BGUI_RequestA( struct Window *, struct bguiRequest *, ULONG * );
BOOL BGUI_Help( struct Window *, UBYTE *, UBYTE *, ULONG );
APTR BGUI_LockWindow( struct Window * );
VOID BGUI_UnlockWindow( APTR );
ULONG BGUI_DoGadgetMethodA( Object *, struct Window *, struct Requester *, Msg );

/* varargs */
Object *BGUI_NewObject( ULONG, Tag, ... );
ULONG BGUI_Request( struct Window *, struct bguiRequest *, ... );
ULONG BGUI_DoGadgetMethod( Object *, struct Window *, struct Requester *, ULONG, ... );
#endif
