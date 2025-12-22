/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.15 (6.12.96)

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

#define A0(stuff) __A0 stuff
#define A1(stuff) __A1 stuff
#define A2(stuff) __A2 stuff
#define GD_Quit					0
#define GD_List					1

#define Main_CNT 2

extern struct IntuitionBase	*IntuitionBase;
extern struct Library		*GadToolsBase;
extern struct Library		*GfxBase;
extern struct Screen		*Scr;
extern int			YOffset;
extern UWORD			XOffset;
extern APTR			VisualInfo;
extern UBYTE			*PubScreenName;
extern struct Window		*MainWnd;
extern struct Gadget		*MainGList;
extern struct IntuiMessage	MainMsg;
extern struct Gadget		*MainGadgets[2];
extern UBYTE			String0[];
extern UBYTE			String1[];
extern UBYTE			String2[];
extern UBYTE			String3[];
extern UBYTE			String4[];
extern UBYTE			String5[];
extern UBYTE			String6[];
extern UBYTE			String7[];
extern UBYTE			String8[];
extern UBYTE			String9[];
extern struct MinList ListList;
extern UWORD			MainGTypes[];
extern struct NewGadget		MainNGad[];
extern ULONG			MainGTags[];
extern struct TagItem		MainWTags[];
extern WORD ScaleX( WORD );
extern WORD ScaleY( WORD );
extern __geta4 ULONG ListHookFunc( A0( struct Hook * ), A1( struct LVDrawMsg * ), A2( struct Node * ));

#define ML_SELECTED  (1<<0)

extern LONG OpenMainWindow( void );
extern void CloseMainWindow( void );
extern LONG HandleMainIDCMP( void );
extern BOOL MainCloseWindow( void );
extern BOOL HandleMainKeys( void );
extern BOOL QuitKeyPressed( void );

extern int SetupScreen( void );
extern void CloseDownScreen( void );
extern struct Gadget *MakeGadgets( struct Gadget **GList, struct Gadget *Gads[],
	struct NewGadget NGad[], UWORD GTypes[], ULONG GTags[], UWORD CNT );
extern LONG OpenWnd( struct Gadget *GList, struct TagItem WTags[], struct Window **Wnd );
extern void CloseWnd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn );
extern BOOL QuitClicked( void );
extern BOOL ListClicked( void );
