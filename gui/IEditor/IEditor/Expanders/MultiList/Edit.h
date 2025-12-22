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

#define GD_Tit					0
#define GD_Label					1
#define GD_PosTit					2
#define GD_Und					3
#define GD_High					4
#define GD_Ok					5
#define GD_Annulla					6
#define GD_Top					7
#define GD_Vis					8
#define GD_ScW					9
#define GD_Spc					10
#define GD_Disab					11
#define GD_ROn					12
#define GD_Show					13
#define GD_IH					14
#define GD_MaxP					15

#define Tags_CNT 16

extern struct IntuitionBase	*IntuitionBase;
extern struct Library		*GadToolsBase;
extern UBYTE			*PosTitLabels[];
extern UWORD			TagsGTypes[];
extern struct TextAttr		topaz8_065;
extern struct NewGadget		TagsNGad[];
extern ULONG			TagsGTags[];
extern LONG OpenTagsWindow( struct Window **, struct Gadget **, struct Gadget **, struct IE_Data * );
extern void TagsRender( struct Window *, struct IE_Data * );
extern LONG HandleTagsIDCMP( struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL TagsVanillaKey( UBYTE, struct Window *, struct Gadget **, struct IE_Data * );
extern BOOL HandleTagsKeys( UBYTE, struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL PosTitKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL UndKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL HighKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL OkKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL AnnullaKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL DisabKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ROnKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ShowKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );

extern void CloseWnd( struct Window **Wnd, struct Gadget **GList );
extern BOOL TitClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL LabelClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL PosTitClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL UndClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL HighClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL OkClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL AnnullaClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL TopClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL VisClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ScWClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL SpcClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL DisabClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ROnClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ShowClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL IHClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL MaxPClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
