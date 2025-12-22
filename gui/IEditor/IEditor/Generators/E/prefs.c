/// Includes
#define INTUI_V36_NAMES_ONLY

#include <exec/nodes.h>                 // exec
#include <exec/lists.h>
#include <exec/types.h>
#include <intuition/intuition.h>        // intuition
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>         // libraries
#include <libraries/reqtools.h>
#include <clib/exec_protos.h>           // protos
#include <clib/intuition_protos.h>
#include <clib/reqtools_protos.h>
#include <pragmas/exec_pragmas.h>       // pragmas
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/reqtools_pragmas.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "DEV_IE:Generators/defs.h"
#include "DEV_IE:Include/IEditor.h"
#include "DEV_IE:Generators/C/Config.h"
#include "DEV_IE:Generators/C/Protos.h"
///
/// Data
static ULONG CheckedTag[] = { GTCB_Checked, 0, TAG_END };
///

/// Config
void Config( __A0 struct IE_Data *IE )
{
    struct Window  *Wnd = NULL;
    struct Gadget  *GList = NULL, *Gadgets[ Conf_CNT ];
    UBYTE           Back;
    BOOL            ret;

    if( OpenConfWindow( &Wnd, &GList, &Gadgets[0], IE )) {

	(*IE->Functions->Status)( "Cannot open my window!", TRUE, 0 );

    } else {

	Back = IE->C_Prefs;

	IE->C_Prefs = ~IE->C_Prefs;
	TemplateKeyPressed( Wnd, Gadgets, IE, NULL );
	ClickKeyPressed( Wnd, Gadgets, IE, NULL );
	MsgKeyPressed( Wnd, Gadgets, IE, NULL );
	HandlerKeyPressed( Wnd, Gadgets, IE, NULL );
	KeyHandlerKeyPressed( Wnd, Gadgets, IE, NULL );
	ToLowerKeyPressed( Wnd, Gadgets, IE, NULL );
	SmartStrKeyPressed( Wnd, Gadgets, IE, NULL );
	NewTmpKeyPressed( Wnd, Gadgets, IE, NULL );
	IE->C_Prefs = Back;

	GT_SetGadgetAttrs( Gadgets[ GD_Chip ], Wnd, NULL,
			   GTST_String, IE->ChipString, TAG_END );

	do {
	    WaitPort( Wnd->UserPort );
	    ret = HandleConfIDCMP( Wnd, &Gadgets[0], IE );
	} while ( ret == 0 );

	if( ret > 0 )
	    IE->C_Prefs = Back;
	else
	    strcpy( IE->ChipString, GetString( Gadgets[ GD_Chip ] ));
    }

    CloseWnd( &Wnd, &GList );
}

/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.0 (16.1.96)

    Copy registered to :  Simone Tellini
    Serial Number      : #0
*/

/*
   In this file you'll find empty  template  routines
   referenced in the GUI source.  You  can fill these
   routines with your code or use them as a reference
   to create your main program.
*/

BOOL MsgKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Intui_Message "'s activation key is pressed  */

    CheckedTag[1] = ( IE->C_Prefs & INTUIMSG ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Msg ], Wnd, NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return MsgClicked( Wnd, Gadgets, IE, Msg );
}

BOOL ClickKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Clicked _Ptr  "'s activation key is pressed  */

    CheckedTag[1] = ( IE->C_Prefs & CLICKED ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Click ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return ClickClicked( Wnd, Gadgets, IE, Msg );
}

BOOL OkKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Ok"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return OkClicked( Wnd, Gadgets, IE, Msg );
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

    CheckedTag[1] = ( IE->C_Prefs & IDCMP_HANDLER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Handler ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return HandlerClicked( Wnd, Gadgets, IE, Msg );
}

BOOL KeyHandlerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Key Handler  "'s activation key is pressed  */

    CheckedTag[1] = ( IE->C_Prefs & KEY_HANDLER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_KeyHandler ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return KeyHandlerClicked( Wnd, Gadgets, IE, Msg );
}

BOOL TemplateKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Template     "'s activation key is pressed  */
    CheckedTag[1] = ( IE->C_Prefs & GEN_TEMPLATE ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_Template ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return TemplateClicked( Wnd, Gadgets, IE, Msg );
}

BOOL ToLowerKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "To Lo_wer     "'s activation key is pressed  */
    CheckedTag[1] = ( IE->C_Prefs & TO_LOWER ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_ToLower ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return ToLowerClicked( Wnd, Gadgets, IE, Msg );
}

BOOL SmartStrKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Smart String"'s activation key is pressed  */
    CheckedTag[1] = ( IE->C_Prefs & SMART_STR ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_SmartStr ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

	/*  ...or return TRUE not to call the gadget function  */
	return SmartStrClicked( Wnd, Gadgets, IE, Msg );
}

BOOL NewTmpKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
    CheckedTag[1] = ( IE->C_Prefs & ONLY_NEW_TMP ) ? FALSE : TRUE;
    GT_SetGadgetAttrsA( Gadgets[ GD_NewTmp ], Wnd,
			NULL, (struct TagItem *)CheckedTag );

    return NewTmpClicked( Wnd, Gadgets, IE, Msg );
}

BOOL MsgClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Intui_Message " is clicked  */

	IE->C_Prefs ^= INTUIMSG;

	return( 0 );
}

BOOL ClickClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Clicked _Ptr  " is clicked  */

	IE->C_Prefs ^= CLICKED;

	return( 0 );
}

BOOL OkClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Ok" is clicked  */
	return( -1 );
}

BOOL CancClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Cancel" is clicked  */
	return( 1 );
}

BOOL HandlerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "IDCMP _Handler" is clicked  */

	IE->C_Prefs ^= IDCMP_HANDLER;

	if( IE->C_Prefs & IDCMP_HANDLER ) {

	    IE->C_Prefs &= ~( CLICKED | INTUIMSG );

	    MsgKeyPressed( Wnd, Gadgets, IE, Msg );
	    ClickKeyPressed( Wnd, Gadgets, IE, Msg );
	}

	return( 0 );
}

BOOL KeyHandlerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Key Handler  " is clicked  */

	IE->C_Prefs ^= KEY_HANDLER;

	if( IE->C_Prefs & KEY_HANDLER ) {

	    IE->C_Prefs &= ~( CLICKED | INTUIMSG );

	    MsgKeyPressed( Wnd, Gadgets, IE, Msg );
	    ClickKeyPressed( Wnd, Gadgets, IE, Msg );
	}

	return( 0 );
}

BOOL TemplateClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Template     " is clicked  */

	IE->C_Prefs ^= GEN_TEMPLATE;

	return( 0 );
}

BOOL ToLowerClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "To Lo_wer     " is clicked  */

	IE->C_Prefs ^= TO_LOWER;

	return( 0 );
}

BOOL ChipClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_UWORD chip:" is clicked  */
	return( 0 );
}

BOOL SmartStrClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Smart String" is clicked  */

	IE->C_Prefs ^= SMART_STR;

	return( 0 );
}

BOOL NewTmpClicked( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	IE->C_Prefs ^= ONLY_NEW_TMP;

	return( 0 );
}
///

