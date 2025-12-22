/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C_IE_Mod.generator 37.1 (29.4.96)

    Copy registered to :  Simone Tellini
    Serial Number      : #0
*/

/*
   In this file you'll find empty  template  routines
   referenced in the GUI source.  You  can fill these
   routines with your code or use them as a reference
   to create your main program.
*/

#include <stdio.h>
#include <exec/types.h>


BOOL TagsVanillaKey( UBYTE, struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine for IDCMP_VANILLAKEY  */
	return( TRUE );
}

BOOL PosTitKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Position"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return PosTitClicked( Wnd, Gadgets, IE );
}

BOOL UndKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Underscore"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return UndClicked( Wnd, Gadgets, IE );
}

BOOL HighKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "H_ighlight"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return HighClicked( Wnd, Gadgets, IE );
}

BOOL OkKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Ok"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return OkClicked( Wnd, Gadgets, IE );
}

BOOL AnnullaKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Cancel"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return AnnullaClicked( Wnd, Gadgets, IE );
}

BOOL DisabKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Disabled"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return DisabClicked( Wnd, Gadgets, IE );
}

BOOL ROnKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Read Only"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return ROnClicked( Wnd, Gadgets, IE );
}

BOOL ShowKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "S_how Selected"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return ShowClicked( Wnd, Gadgets, IE );
}

BOOL TitClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Tit_le" is clicked  */
	return( TRUE );
}

BOOL LabelClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "La_bel" is clicked  */
	return( TRUE );
}

BOOL PosTitClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Position" is clicked  */
	return( TRUE );
}

BOOL UndClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Underscore" is clicked  */
	return( TRUE );
}

BOOL HighClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "H_ighlight" is clicked  */
	return( TRUE );
}

BOOL OkClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Ok" is clicked  */
	return( TRUE );
}

BOOL AnnullaClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Cancel" is clicked  */
	return( TRUE );
}

BOOL TopClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Top         " is clicked  */
	return( TRUE );
}

BOOL VisClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Make _Visible" is clicked  */
	return( TRUE );
}

BOOL ScWClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Scroll _Width" is clicked  */
	return( TRUE );
}

BOOL SpcClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Sp_acing     " is clicked  */
	return( TRUE );
}

BOOL DisabClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Disabled" is clicked  */
	return( TRUE );
}

BOOL ROnClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "_Read Only" is clicked  */
	return( TRUE );
}

BOOL ShowClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "S_how Selected" is clicked  */
	return( TRUE );
}

BOOL IHClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Ite_m Height" is clicked  */
	return( TRUE );
}

BOOL MaxPClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE, struct IntuiMessage *Msg )
{
	/*  Routine when "Ma_x Pen    " is clicked  */
	return( TRUE );
}
