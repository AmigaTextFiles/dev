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

#define GD_Msg					0
#define GD_Click					1
#define GD_Use					2
#define GD_Canc					3
#define GD_Handler					4
#define GD_KeyHandler					5
#define GD_Template					6
#define GD_ToLower					7
#define GD_Chip					8
#define GD_SmartStr					9
#define GD_NewTmp					10
#define GD_Headers					11
#define GD_GetH					12
#define GD_Save					13
#define GD_CatComp					14
#define GD_Hook					15
#define GD_Reg					16
#define GD_NoKP					17

#define Conf_CNT 18

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
extern BOOL HandleConfKeys( UBYTE, struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL MsgKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ClickKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL UseKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL CancKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL HandlerKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL KeyHandlerKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL TemplateKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ToLowerKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL SmartStrKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL NewTmpKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL SaveKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL CatCompKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL NoKPKeyPressed( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );

extern void CloseWnd( struct Window **Wnd, struct Gadget **GList );
extern BOOL MsgClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ClickClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL UseClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL CancClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL HandlerClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL KeyHandlerClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL TemplateClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ToLowerClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL ChipClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL SmartStrClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL NewTmpClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL HeadersClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL GetHClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL SaveClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL CatCompClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL HookClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL RegClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
extern BOOL NoKPClicked( struct Window *, struct Gadget **, struct IE_Data *, struct IntuiMessage * );
