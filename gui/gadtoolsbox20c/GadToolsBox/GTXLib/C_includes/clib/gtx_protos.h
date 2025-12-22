#ifndef CLIB_GTX_PROTOS_H
#define CLIB_GTX_PROTOS_H
/*
**      $VER: clib/gtx_protos.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      C Prototypes. For use with 32 bit integers only.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard.
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GADTOOLSBOX_HOTKEY_H
#include <gadtoolsbox/hotkey.h>
#endif

#ifndef GADTOOLSBOX_GUI_H
#include <gadtoolsbox/gui.h>
#endif

LONG GTX_TagInArray( Tag, struct TagItem * );
LONG GTX_SetTagData( Tag, ULONG, struct TagItem * );

struct Node *GTX_GetNode( struct List *, ULONG );
LONG GTX_GetNodeNumber( struct List *, struct Node * );
ULONG GTX_CountNodes( struct List * );
LONG GTX_MoveNode( struct List *, struct Node *, LONG );

UBYTE *GTX_IFFErrToStr( LONG, LONG );

HOTKEYHANDLE GTX_GetHandleA( struct TagItem * );
VOID GTX_FreeHandle( HOTKEYHANDLE );
VOID GTX_RefreshWindow( HOTKEYHANDLE, struct Window *, struct Requester * );
struct Gadget *GTX_CreateGadgetA( HOTKEYHANDLE, ULONG, struct Gadget *, struct NewGadget *, struct TagItem * );
ULONG GTX_RawToVanilla( HOTKEYHANDLE, ULONG, ULONG );
struct IntuiMessage *GTX_GetIMsg( HOTKEYHANDLE, struct MsgPort * );
VOID GTX_ReplyIMsg( HOTKEYHANDLE, struct IntuiMessage * );
VOID GTX_SetGadgetAttrsA( HOTKEYHANDLE, struct Gadget *, struct TagItem * );
VOID GTX_DetachLabels( HOTKEYHANDLE, struct Gadget * );

VOID GTX_DrawBox( struct RastPort *, ULONG, ULONG, LONG, LONG, struct DrawInfo *, ULONG );

struct IClass *GTX_InitTextClass( void );
struct IClass *GTX_InitGetFileClass( void );

VOID GTX_SetHandleAttrsA( HOTKEYHANDLE, struct TagItem * );

VOID GTX_BeginRefresh( HOTKEYHANDLE );
VOID GTX_EndRefresh( HOTKEYHANDLE, LONG );

VOID GTX_FreeWindows( struct MemoryChain *, struct WindowList * );
LONG GTX_LoadGUIA( struct MemoryChain *, UBYTE *, struct TagItem * );

/*--- varargs versions ---*/
HOTKEYHANDLE GTX_GetHandle( Tag, ... );
struct Gadget *GTX_CreateGadget( HOTKEYHANDLE, ULONG, struct Gadget *, struct NewGadget *, Tag, ... );
VOID GTX_SetGadgetAttrs( HOTKEYHANDLE, struct Gadget *, Tag, ... );
VOID GTX_SetHandleAttrs( HOTKEYHANDLE, Tag, ... );
LONG GTX_LoadGUI( struct MemoryChain *, UBYTE *, Tag, ... );

#endif
