/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/types.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <libraries/asl.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/asl_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>
#include <pragmas/asl_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Config.h"
#include "DEV_IE:Generators/C/Protos.h"
///
/// Prototypes
static void     SavePrefs( void );
static BOOL     GetFile( struct IE_Data *, STRPTR, STRPTR, STRPTR );
///
/// Data
static ULONG    CheckedTag[] = { GTCB_Checked, 0, TAG_END };
static UBYTE    Back, MoreBack;

BOOL            PrefsOK = FALSE;
static TEXT     PrefsFile[] = "PROGDIR:C.prefs";

struct Library *AslBase;
///


/// Config
void Config( __A0 struct IE_Data *IE )
{
    struct Window  *Wnd = NULL;
    struct Gadget  *GList = NULL, *Gadgets[ Conf_CNT ];

    GrabOldPrefs( IE );

    if( OpenConfWindow( &Wnd, &GList, &Gadgets[0], IE )) {

	( *IE->Functions->Status )( "Cannot open my window!", TRUE, 0 );

    } else {

	Back     = Prefs.Flags;
	MoreBack = Prefs.MoreFlags;

	Prefs.Flags     = ~Prefs.Flags;
	Prefs.MoreFlags = ~Prefs.MoreFlags;

	TemplateKeyPressed( Wnd, Gadgets, IE, NULL );
	ClickKeyPressed( Wnd, Gadgets, IE, NULL );
	MsgKeyPressed( Wnd, Gadgets, IE, NULL );
	HandlerKeyPressed( Wnd, Gadgets, IE, NULL );
	KeyHandlerKeyPressed( Wnd, Gadgets, IE, NULL );
	ToLowerKeyPressed( Wnd, Gadgets, IE, NULL );
	SmartStrKeyPressed( Wnd, Gadgets, IE, NULL );
	NewTmpKeyPressed( Wnd, Gadgets, IE, NULL );
	CatCompKeyPressed( Wnd, Gadgets, IE, NULL );
	NoKPKeyPressed( Wnd, Gadgets, IE, NULL );

	Prefs.Flags     = Back;
	Prefs.MoreFlags = MoreBack;

	GT_SetGadgetAttrs( Gadgets[ GD_Chip ], Wnd, NULL,
			   GTST_String, Prefs.ChipString, TAG_END );

	GT_SetGadgetAttrs( Gadgets[ GD_Headers ], Wnd, NULL,
			   GTST_String, Prefs.HeadersFile, TAG_END );

	GT_SetGadgetAttrs( Gadgets[ GD_Hook ], Wnd, NULL,
			   GTST_String, Prefs.HookDef, TAG_END );

	GT_SetGadgetAttrs( Gadgets[ GD_Reg ], Wnd, NULL,
			   GTST_String, Prefs.RegisterDef, TAG_END );

	do {
	    WaitPort( Wnd->UserPort );
	} while( HandleConfIDCMP( Wnd, &Gadgets[0], IE ) == 0 );
    }

    CloseWnd( &Wnd, &GList );
}

BOOL MsgKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Intui_Message "'s activation key is pressed  */

    CheckedTag[1] = ( Prefs.Flags & INTUIMSG ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Msg ], Wnd, NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return MsgClicked( Wnd, Gadgets, IE, Msg );
}

BOOL ClickKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Clicked _Ptr  "'s activation key is pressed  */

    CheckedTag[1] = ( Prefs.Flags & CLICKED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Click ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return ClickClicked( Wnd, Gadgets, IE, Msg );
}

BOOL UseKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Use"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return UseClicked( Wnd, Gadgets, IE, Msg );
}

BOOL SaveKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Save"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return SaveClicked( Wnd, Gadgets, IE, Msg );
}

BOOL CancKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Cancel"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return CancClicked( Wnd, Gadgets, IE, Msg );
}

BOOL HandlerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "IDCMP _Handler"'s activation key is pressed  */

    CheckedTag[1] = ( Prefs.Flags & IDCMP_HANDLER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Handler ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return HandlerClicked( Wnd, Gadgets, IE, Msg );
}

BOOL KeyHandlerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Key Handler  "'s activation key is pressed  */

    CheckedTag[1] = ( Prefs.Flags & KEY_HANDLER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_KeyHandler ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return KeyHandlerClicked( Wnd, Gadgets, IE, Msg );
}

BOOL TemplateKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Template     "'s activation key is pressed  */
    CheckedTag[1] = ( Prefs.Flags & GEN_TEMPLATE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Template ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return TemplateClicked( Wnd, Gadgets, IE, Msg );
}

BOOL ToLowerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "To Lo_wer     "'s activation key is pressed  */
    CheckedTag[1] = ( Prefs.Flags & TO_LOWER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_ToLower ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return ToLowerClicked( Wnd, Gadgets, IE, Msg );
}

BOOL SmartStrKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Smart String"'s activation key is pressed  */
    CheckedTag[1] = ( Prefs.Flags & SMART_STR ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_SmartStr ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return SmartStrClicked( Wnd, Gadgets, IE, Msg );
}

BOOL NewTmpKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    CheckedTag[1] = ( Prefs.Flags & ONLY_NEW_TMP ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_NewTmp ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

    return NewTmpClicked( Wnd, Gadgets, IE, Msg );
}

BOOL CatCompKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    CheckedTag[1] = ( Prefs.MoreFlags & USE_CATCOMP ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_CatComp ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

    return CatCompClicked( Wnd, Gadgets, IE, Msg );
}

BOOL NoKPKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    CheckedTag[1] = ( Prefs.MoreFlags & NO_BUTTON_KP ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_NoKP ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

    return NoKPClicked( Wnd, Gadgets, IE, Msg );
}

BOOL MsgClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Intui_Message " is clicked  */

	Prefs.Flags ^= INTUIMSG;

	return( 0 );
}

BOOL ClickClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Clicked _Ptr  " is clicked  */

	Prefs.Flags ^= CLICKED;

	return( 0 );
}

BOOL UseClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Ok" is clicked  */

    strcpy( Prefs.ChipString,   GetString( Gadgets[ GD_Chip     ] ));
    strcpy( Prefs.HeadersFile,  GetString( Gadgets[ GD_Headers  ] ));
    strcpy( Prefs.HookDef,      GetString( Gadgets[ GD_Hook     ] ));
    strcpy( Prefs.RegisterDef,  GetString( Gadgets[ GD_Reg      ] ));

    return( 1 );
}

BOOL SaveClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Save" is clicked  */

    UseClicked( Wnd, Gadgets, IE, Msg );

    SavePrefs();

    return( 1 );
}

BOOL CancClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    Prefs.Flags     = Back;
    Prefs.MoreFlags = MoreBack;

    return( 1 );
}

BOOL HandlerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "IDCMP _Handler" is clicked  */

	Prefs.Flags ^= IDCMP_HANDLER;

	if( Prefs.Flags & IDCMP_HANDLER ) {

	    Prefs.Flags &= ~( CLICKED | INTUIMSG );

	    MsgKeyPressed( Wnd, Gadgets, IE, Msg );
	    ClickKeyPressed( Wnd, Gadgets, IE, Msg );
	}

	return( 0 );
}

BOOL KeyHandlerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Key Handler  " is clicked  */

	Prefs.Flags ^= KEY_HANDLER;

	if( Prefs.Flags & KEY_HANDLER ) {

	    Prefs.Flags &= ~( CLICKED | INTUIMSG );

	    MsgKeyPressed( Wnd, Gadgets, IE, Msg );
	    ClickKeyPressed( Wnd, Gadgets, IE, Msg );
	}

	return( 0 );
}

BOOL TemplateClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Template     " is clicked  */

	Prefs.Flags ^= GEN_TEMPLATE;

	return( 0 );
}

BOOL ToLowerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "To Lo_wer     " is clicked  */

    Prefs.Flags ^= TO_LOWER;

    return( 0 );
}

BOOL ChipClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_UWORD chip:" is clicked  */

    return( 0 );
}

BOOL HookClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Hook_:" is clicked  */

    return( 0 );
}

BOOL RegClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Re_gister:" is clicked  */

    return( 0 );
}

BOOL HeadersClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "H_eaders:" is clicked  */

    return( 0 );
}

BOOL SmartStrClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Smart String" is clicked  */

	Prefs.Flags ^= SMART_STR;

	return( 0 );
}

BOOL NewTmpClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	Prefs.Flags ^= ONLY_NEW_TMP;

	return( 0 );
}

BOOL CatCompClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	Prefs.MoreFlags ^= USE_CATCOMP;

	return( 0 );
}

BOOL NoKPClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	Prefs.MoreFlags ^= NO_BUTTON_KP;

	return( 0 );
}

BOOL GetHClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    TEXT    File[ 256 ];

    strcpy( File, GetString( Gadgets[ GD_Headers ] ));

    if( GetFile( IE, "Select the headers file...", "#?", File )) {

	GT_SetGadgetAttrs( Gadgets[ GD_Headers ], Wnd, NULL,
			    GTST_String, File, TAG_END );
    }

    return( 0 );
}
///

/// SavePrefs
void SavePrefs( void )
{
    BPTR    file;

    if( file = Open( PrefsFile, MODE_NEWFILE )) {

	Write( file, &Prefs, sizeof( struct CPrefs ));

	Close( file );
    }
}
///
/// LoadPrefs
void LoadPrefs( void )
{
    BPTR    file;

    if( file = Open( PrefsFile, MODE_OLDFILE )) {

	Read( file, &Prefs, sizeof( struct CPrefs ));

	Close( file );

	PrefsOK = TRUE; /* there's no need to read the old prefs from
			   IE's data structure                        */
    }
}
///

/// GetFile
BOOL GetFile( struct IE_Data *IE, STRPTR title, STRPTR pattern, STRPTR buffer )
{
    struct FileRequester   *req;
    BOOL                    ok = FALSE;
    static TEXT             initial_file[] = "",
			    initial_drawer[] = "";

    if( AslBase = OpenLibrary( "asl.library", 38 )) {

	if( req = AllocAslRequest( ASL_FileRequest, NULL )) {

	    if( ok = AslRequestTags( req, ASLFR_DoPatterns,     TRUE,
				     ASLFR_InitialHeight,  IE->ScreenData->Screen->Height - 40,
				     ASLFR_TitleText,      title,
				     ASLFR_InitialFile,    initial_file,
				     ASLFR_InitialDrawer,  initial_drawer,
				     ASLFR_InitialPattern, pattern,
				     ASLFR_Screen,         IE->ScreenData->Screen,
				     TAG_DONE )) {

		strcpy( initial_file,   req->fr_File   );
		strcpy( initial_drawer, req->fr_Drawer );

		strcpy( buffer, req->fr_Drawer );

		AddPart( buffer, req->fr_File, 256 );
	    }

	    FreeAslRequest( req );

	} else
	    ( *IE->Functions->Status )( "Cannot open the ASL requester!", TRUE, 0 );

	CloseLibrary( AslBase );

	AslBase = NULL;

    } else
	( *IE->Functions->Status )( "Cannot open asl.library v38+!", TRUE, 0 );

    return( ok );
}
///

