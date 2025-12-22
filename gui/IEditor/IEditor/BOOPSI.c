/// Include
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define INTUI_V36_NAMES_ONLY
#define ASL_V38_NAMES_ONLY
#define CATCOMP_NUMBERS

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <intuition/intuition.h>        // intuition
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <clib/locale_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>


#include "DEV_IE:defs.h"
#include "DEV_IE:GUI.h"
#include "DEV_IE:GUI_locale.h"
#include "DEV_IE:Include/expanders.h"
///
/// Prototipi
static void     ClearBankZone( void );
static void     ShowLong( void );
static void     ShowBool( void );
static void     ShowString( void );
static void     ShowObjects( void );
static void     GetLong( void );
static void     Get_String( void );
static void     PutLong( void );
static void     Put_String( void );
static void     PutBool( void );
static void     BE_AttachList( void );
static void     BE_DetacheList( void );
///
/// Dati
static struct BTag         *SelTag;
static struct BOOPSIInfo   *EditObj;
static struct Gadget       *BankGList;
static struct IEXNode      *ExpNode;
static BOOL                 B_RetCode;
static UBYTE                CurrentBank;
static void                 ( *TakeValue )( void );

static APTR ShowProcs[] = {
	NULL,       // byte
	NULL,       // word
	ShowLong,
	NULL,       // byte ^
	NULL,       // word ^
	NULL,       // long ^
	ShowString,
	NULL,       // string array
	NULL,       // string list
	ShowBool,
	NULL,       // choose
	ShowObjects,
	NULL,       // user struct
	NULL,       // screen
};

static APTR GetProcs[] = {
	NULL,       // byte
	NULL,       // word
	GetLong,
	NULL,       // byte ^
	NULL,       // word ^
	NULL,       // long ^
	Get_String,
	NULL,       // string array
	NULL,       // string list
	NULL,       // bool
	NULL,       // choose
	NULL,       // object
	NULL,       // user struct
	NULL,       // screen
};

static APTR PutProcs[] = {
	NULL,       // byte
	NULL,       // word
	PutLong,
	NULL,       // byte ^
	NULL,       // word ^
	NULL,       // long ^
	Put_String,
	NULL,       // string array
	NULL,       // string list
	PutBool,
	NULL,       // choose
	NULL,       // object
	NULL,       // user struct
	NULL,       // screen
};
///


/// BoopsiEditor
BOOL BoopsiEditor( struct BOOPSIInfo *Obj )
{
    ULONG           ret;
    struct IEXNode *ex;

    EditObj = Obj;

    ex = IE.Expanders.mlh_Head;
    while( ex->ID != Obj->Kind )
	ex = ex->Node.ln_Succ;

    ExpNode = ex;

    LayoutWindow( BOOPSIWTags );
    ret = OpenBOOPSIWindow();
    PostOpenWindow( BOOPSIWTags );


    if( ret )
	DisplayBeep( Scr );
    else {

	CurrentBank = (UBYTE)-1;
	TakeValue   = NULL;
	SelTag      = NULL;

	BE_AttachList();

	while( ReqHandle( BOOPSIWnd, HandleBOOPSIIDCMP ));

	ClearBankZone();
    }

    CloseBOOPSIWindow();

    return( B_RetCode );
}
///
/// Control functions
BOOL BOOPSIVanillaKey( void )
{
    switch( BOOPSIMsg.Code ) {

	case 13:
	    return( BE_OkClicked() );

	case 27:
	    return( BE_AnnullaClicked() );
    }

    return( TRUE );
}

BOOL BE_OkKeyPressed( void )
{
    return( BE_OkClicked() );
}

BOOL BE_AnnullaKeyPressed( void )
{
    return( BE_AnnullaClicked() );
}

BOOL BE_CTypeKeyPressed( void )
{
    return( TRUE );
}

BOOL BE_LabelClicked( void )
{
    return( TRUE );
}

BOOL BE_ClassClicked( void )
{
    return( TRUE );
}

BOOL BE_CTypeClicked( void )
{
    return( TRUE );
}

BOOL BE_OkClicked( void )
{
    B_RetCode = TRUE;

    return( FALSE );
}

BOOL BE_AnnullaClicked( void )
{
    B_RetCode = FALSE;

    return( FALSE );
}

BOOL BE_BoolClicked( void )
{
    SelTag->BoolValue = BOOPSIMsg.Code;

    return( TRUE );
}

BOOL BE_StringClicked( void )
{
    return( TRUE );
}

BOOL BE_ObjectsClicked( void )
{
    return( TRUE );
}

BOOL BE_LongClicked( void )
{
    return( TRUE );
}

BOOL BE_ImgClicked( void )
{
    return( TRUE );
}

BOOL BE_TagsClicked( void )
{
    ULONG           c;
    struct BTag    *tag;
    void            ( *func )( void );

    if( TakeValue )
	( *TakeValue )();

    tag = ( struct BTag * )EditObj->Tags.mlh_Head;

    for( c = 0; c < BOOPSIMsg.Code; c++ )
	tag = tag->Succ;

    SelTag = tag;

    if( tag->Type != CurrentBank ) {

	ClearBankZone();

	if( func = ShowProcs[ tag->Type ])
	    ( *func )();
    }

    if( func = PutProcs[ tag->Type ])
	( *func )();

    return( TRUE );
}

BOOL BE_TagInClicked( void )
{
    return( TRUE );
}

BOOL BE_NewTagKeyPressed( void )
{
    return( BE_NewTagClicked() );
}

BOOL BE_DelTagKeyPressed( void )
{
    return( BE_DelTagClicked() );
}

BOOL BE_NewTagClicked( void )
{
    struct BTag    *tag;

    if( TakeValue )
	( *TakeValue )();

    if( tag = AllocObject( IE_BTAG )) {
	struct BOOPSIExp   *exp;
	ULONG               max = 0;
	struct Node        *node;

	exp = ExpNode->Base;

	for( node = exp->Tags.mlh_Head; node->ln_Succ; node = node->ln_Succ )
	    ++max;

	if( ApriListaFin( "Select a tag...", 0, &exp->Tags )) {
	    WORD    ret;

	    ret = GestisciListaFin( EXIT, max );

	    if( ret >= 0 ) {
		struct BOOPSITag   *btag;
		ULONG               c;

		BE_DetacheList();
		AddTail(( struct List * )&EditObj->Tags, ( struct Node * )tag );
		BE_AttachList();

		SelTag = tag;

		btag = (struct BOOPSITag *)exp->Tags.mlh_Head;

		for( c = 0; c < ret; c++ )
		    btag = btag->Succ;

		tag->Type = btag->Type;
		tag->Name = btag->Name;

		if( btag->Type != CurrentBank ) {
		    void    ( *func )( void );

		    ClearBankZone();

		    if( func = ShowProcs[ btag->Type ])
			( *func )();

		    TakeValue = GetProcs[ btag->Type ];
		}

		SelTag = NULL;

	    } else
		FreeObject( tag, IE_BTAG );
	}

	ChiudiListaFin();

	GT_RefreshWindow( BOOPSIWnd, NULL );

    } else
	Stat( CatCompArray[ ERR_NOMEMORY ].cca_Str, TRUE, 0 );

    return( TRUE );
}

BOOL BE_DelTagClicked( void )
{
    if( SelTag ) {

	BE_DetacheList();

	Remove(( struct Node * )SelTag );

	FreeObject( SelTag, IE_BTAG );

	BE_AttachList();
    }

    return( TRUE );
}
///
/// BE_DetacheList
void BE_DetacheList( void )
{
    ListTag[1] = (ULONG)~0;

    GT_SetGadgetAttrsA( BOOPSIGadgets[ GD_BE_Tags ], BOOPSIWnd,
			NULL, (struct TagItem *)ListTag );
}
///
/// BE_AttachList
void BE_AttachList( void )
{
    ListTag[1] = (ULONG)&EditObj->Tags;
    GT_SetGadgetAttrsA( BOOPSIGadgets[ GD_BE_Tags ], BOOPSIWnd,
			NULL, (struct TagItem *)ListTag );
}
///

/// ClearBankZone
void ClearBankZone( void )
{
    if( BankGList ) {

	RemGadgetBank( BOOPSIWnd, &BOOPSIWBanks, BankGList );
	FreeGadgets( BankGList );

	EraseRect( BOOPSIWnd->RPort, 275, YOffset + 3, 609, 124 );

	BankGList = NULL;
    }
}
///

/// ShowLong
void ShowLong( void )
{
    if( CurrentBank != TT_LONG ) {

	CurrentBank = TT_LONG;

	MakeGadgets( &BankGList, BE_LONGGadgets, BE_LONGNGad,
		     BE_LONGGTypes, BE_LONGGTags, BE_LONG_CNT );

	AddGadgetBank( BOOPSIWnd, &BOOPSIWBanks, BankGList );

	TakeValue = GetLong;
    }
}
///
/// ShowBool
void ShowBool( void )
{
    if( CurrentBank != TT_BOOL ) {

	CurrentBank = TT_BOOL;

	MakeGadgets( &BankGList, BE_BOOLGadgets, BE_BOOLNGad,
		     BE_BOOLGTypes, BE_BOOLGTags, BE_BOOL_CNT );

	AddGadgetBank( BOOPSIWnd, &BOOPSIWBanks, BankGList );
    }
}
///
/// ShowString
void ShowString( void )
{
    if( CurrentBank != TT_STRING ) {

	CurrentBank = TT_STRING;

	MakeGadgets( &BankGList, BE_STRINGGadgets, BE_STRINGNGad,
		     BE_STRINGGTypes, BE_STRINGGTags, BE_STRING_CNT );

	AddGadgetBank( BOOPSIWnd, &BOOPSIWBanks, BankGList );
    }
}
///
/// ShowObjects
void ShowObjects( void )
{
    if( CurrentBank != TT_OBJECT ) {

	CurrentBank = TT_OBJECT;

	MakeGadgets( &BankGList, BE_OBJECTSGadgets, BE_OBJECTSNGad,
		     BE_OBJECTSGTypes, BE_OBJECTSGTags, BE_OBJECTS_CNT );

	AddGadgetBank( BOOPSIWnd, &BOOPSIWBanks, BankGList );
    }
}
///

/// GetLong
void GetLong( void )
{
    SelTag->Value = GetNumber( BE_LONGGadgets[ GD_BE_Long ]);
}
///
/// Get_String
void Get_String( void )
{
    strcpy( SelTag->String, GetString( BE_STRINGGadgets[ GD_BE_String ]));

Printf( "%s\n", SelTag->String );
}
///

/// PutLong
void PutLong( void )
{
    IntegerTag[1] = SelTag->Value;
    GT_SetGadgetAttrsA( BE_LONGGadgets[ GD_BE_Long ], BOOPSIWnd,
			NULL, ( struct TagItem * )IntegerTag );
}
///
/// Put_String
void Put_String( void )
{
    StringTag[1] = (ULONG)SelTag->String;
    GT_SetGadgetAttrsA( BE_STRINGGadgets[ GD_BE_String ], BOOPSIWnd,
			NULL, ( struct TagItem * )StringTag );
}
///
/// PutBool
void PutBool( void )
{
    CheckedTag[1] = SelTag->BoolValue;
    GT_SetGadgetAttrsA( BE_BOOLGadgets[ GD_BE_Bool ], BOOPSIWnd,
			NULL, ( struct TagItem * )CheckedTag );
}
///
