/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C_IE_Mod.generator 37.0 (15.2.96)

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


BOOL MainVanillaKey( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine for IDCMP_VANILLAKEY  */
	return( TRUE );
}

BOOL OkKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Ok"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return OkClicked( Wnd, Gadgets, IE );
}

BOOL CancKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Cancel"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return CancClicked( Wnd, Gadgets, IE );
}

BOOL FreeKeyPressed( struct Window *Wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Freedom"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return FreeClicked( Wnd, Gadgets, IE );
}

BOOL OkClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Ok" is clicked  */
	return( TRUE );
}

BOOL CancClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Cancel" is clicked  */
	return( TRUE );
}

BOOL FreeClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Freedom" is clicked  */
	return( TRUE );
}

BOOL LabelClicked( struct Window *wnd, struct Gadget *Gadgets[], struct IE_Data *IE )
{
	/*  Routine when "_Label :" is clicked  */
	return( TRUE );
}
