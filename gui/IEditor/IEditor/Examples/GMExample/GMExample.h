/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.2 (22.2.96)

    Copy registered to :  Gian Maria Calzolari - Beta Tester 2
    Serial Number      : #2
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

#define GD_Bottone					0
#define GD_Palette					1
#define GD_Sceglimi					2
#define GD_Text					3
#define GD_Numero					4
#define GD_Stringa					5
#define GD_ProvaImg					6

#define MiaFin_CNT 6

extern struct IntuitionBase	*IntuitionBase;
extern struct Library		*GadToolsBase;
extern struct Screen		*Scr;
extern int			YOffset;
extern UWORD			XOffset;
extern APTR			VisualInfo;
extern UBYTE			*PubScreenName;
extern struct Window		*MiaFinWnd;
extern struct Menu		*MiaFinMenus;
extern struct Gadget		*MiaFinGList;
extern struct IntuiMessage	MiaFinMsg;
extern struct Gadget		*MiaFinGadgets[6];
extern struct TextFont		*topaz8_065Font;
extern UWORD __chip ChickenImgData[3030];
extern UWORD __chip EnricoImgData[2058];
extern UBYTE			*SceglimiLabels[];
extern UWORD			MiaFinGTypes[];
extern struct TextAttr		topaz8_065;
extern struct NewGadget		MiaFinNGad[];
extern ULONG			MiaFinGTags[];
extern struct Gadget		ProvaImgGadget;
extern BOOL SubItem1Menued( void );
extern BOOL SubItem2aMenued( void );
extern BOOL SubItem2bMenued( void );
extern struct IntuiText		MiaFinIText[];
extern struct Image		ChickenImg;
extern struct Image		EnricoImg;
extern struct Image		MiaFin_0Image;
extern UWORD			RX_Unconfirmed;
extern struct MsgPort		*RexxPort;
extern UBYTE			RexxPortName[];
extern BOOL SetupRexxPort( void );
extern void DeleteRexxPort( void );
extern void HandleRexxMsg( void );
extern BOOL SendRexxMsg( char *Host, char *Ext, char *Command, APTR Msg, LONG Flags );
extern LONG GetTheStringRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG QuitRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG Gimme5Rexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG PutTheStringRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern struct TagItem		MiaFinWTags[];
extern struct Library	*DiskfontBase;
extern struct Library	*GfxBase;
extern BOOL OpenDiskFonts( void );
extern void CloseDiskFonts( void );
extern LONG OpenMiaFinWindow( void );
extern void CloseMiaFinWindow( void );
extern void MiaFinRender( void );
extern LONG HandleMiaFinIDCMP( void );
extern BOOL MiaFinVanillaKey( void );
extern BOOL MiaFinCloseWindow( void );
extern BOOL HandleMiaFinKeys( void );
extern BOOL BottoneKeyPressed( void );
extern BOOL SceglimiKeyPressed( void );

extern int SetupScreen( void );
extern void CloseDownScreen( void );
extern LONG MakeGadgets( struct Gadget **GList, struct Gadget *Gads[],
	struct NewGadget NGad[], UWORD GTypes[], ULONG GTags[], UWORD CNT );
extern LONG OpenWnd( struct Gadget *GList, struct TagItem WTags[], struct Window **Wnd );
extern void CloseWnd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn );
extern BOOL BottoneClicked( void );
extern BOOL PaletteClicked( void );
extern BOOL SceglimiClicked( void );
extern BOOL NumeroClicked( void );
extern BOOL StringaClicked( void );
extern BOOL ProvaImgClicked( void );
