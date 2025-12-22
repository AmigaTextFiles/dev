/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C_IE_Mod.generator 37.1 (29.4.96)

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

#define GD_Ok					0
#define GD_Canc					1
#define GD_Free					2
#define GD_Label					3

#define Main_CNT 4

extern struct IntuitionBase	*IntuitionBase;
extern struct Library		*GadToolsBase;
extern UBYTE			*FreeLabels[];
extern UWORD			MainGTypes[];
extern struct TextAttr		topaz8_065;
extern struct NewGadget		MainNGad[];
extern ULONG			MainGTags[];
extern LONG OpenMainWindow( struct Window **, struct Gadget **, struct Gadget **, struct IE_Data * );
extern void MainRender( struct Window *, struct IE_Data * );
extern LONG HandleMainIDCMP( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL MainVanillaKey( UBYTE, struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL HandleMainKeys( UBYTE, struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL OkKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL CancKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL FreeKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );

extern void CloseWnd( struct Window **Wnd, struct Gadget **GList );
extern BOOL OkClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL CancClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL FreeClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL LabelClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
