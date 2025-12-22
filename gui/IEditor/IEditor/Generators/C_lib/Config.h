/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C_IE_Mod.generator 37.0 (15.2.96)

    Copy registered to :  Simone Tellini
    Serial Number      : #0
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif
#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif
#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif
#ifndef CLIB_INTUITION_PROTOS_H
#include <clib/intuition_protos.h>
#endif
#ifndef CLIB_GADTOOLS_PROTOS_H
#include <clib/gadtools_protos.h>
#endif
#ifndef CLIB_GRAPHICS_PROTOS_H
#include <clib/graphics_protos.h>
#endif
#ifndef CTYPE_H
#include <ctype.h>
#endif
#ifndef STRING_H
#include <string.h>
#endif

#define GetString( g )	((( struct StringInfo * )g->SpecialInfo )->Buffer  )
#define GetNumber( g )	((( struct StringInfo * )g->SpecialInfo )->LongInt )

#define WT_LEFT				0
#define WT_TOP				1
#define WT_WIDTH			2
#define WT_HEIGHT			3

#define GD_Click					0
#define GD_Ok					1
#define GD_Canc					2
#define GD_Handler					3
#define GD_KeyHandler					4
#define GD_Template					5
#define GD_ToLower					6
#define GD_Chip					7

#define Conf_CNT 8

extern struct IntuitionBase	*IntuitionBase;
extern struct Library		*GadToolsBase;
extern UWORD			ConfGTypes[];
extern struct TextAttr		topaz8_065;
extern struct NewGadget		ConfNGad[];
extern ULONG			ConfGTags[];
extern UWORD ScaleX( UWORD, UWORD );
extern UWORD ScaleY( UWORD, UWORD );
extern LONG OpenConfWindow( struct Window **, struct Gadget **, struct Gadget **, struct IE_Data * );
extern LONG HandleConfIDCMP( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL HandleConfKeys( UBYTE, struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL ClickKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL OkKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL CancKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL HandlerKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL KeyHandlerKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL TemplateKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL ToLowerKeyPressed( struct Window *, struct Gadget **, struct IE_Data * );

extern void CloseWnd( struct Window **Wnd, struct Gadget **GList );
extern BOOL ClickClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL OkClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL CancClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL HandlerClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL KeyHandlerClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL TemplateClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL ToLowerClicked( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL ChipClicked( struct Window *, struct Gadget **, struct IE_Data * );
