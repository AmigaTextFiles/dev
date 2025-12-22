/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.2 (22.2.96)

    Copy registered to :  Gian Maria Calzolari - Beta Tester 2
    Serial Number      : #2
*/

/*
   In this file you'll find empty  template  routines
   referenced in the GUI source.  You  can fill these
   routines with your code or use them as a reference
   to create your main program.
*/

#include <stdio.h>
#include <exec/types.h>

void MySetup( void );
{
	/*  ...Initialization Stuff...  */
}

BOOL SubItem1Menued( void )
{
	/*  Routine for menu "Menu1/Item1/SubItem1"  */
	return( TRUE );
}

BOOL SubItem2aMenued( void )
{
	/*  Routine for menu "Menu1/Item2/SubItem2a"  */
	return( TRUE );
}

BOOL SubItem2bMenued( void )
{
	/*  Routine for menu "Menu1/Item2/SubItem2b"  */
	return( TRUE );
}

LONG GetTheStringRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
	/*  Routine for the "GETTHESTRING" ARexx command  */
	return( 0L );
}

LONG QuitRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
	/*  Routine for the "QUIT" ARexx command  */
	return( 0L );
}

LONG Gimme5Rexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
	/*  Routine for the "GIMMEFIVE" ARexx command  */
	return( 0L );
}

LONG PutTheStringRexxed( ULONG *ArgArray, struct RexxMsg *Msg )
{
	/*  Routine for the "PUTTHESTRING" ARexx command  */
	return( 0L );
}

BOOL MiaFinVanillaKey( void )
{
	/*  Routine for IDCMP_VANILLAKEY  */
	return( TRUE );
}

BOOL MiaFinCloseWindow( void )
{
	/*  Routine for IDCMP_CLOSEWINDOW  */
	/*  Return FALSE to quit, I suppose... ;)  */
	return( FALSE );
}

BOOL BottoneKeyPressed( void )
{
	/*  Routine when "_Button!"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return BottoneClicked();
}

BOOL SceglimiKeyPressed( void )
{
	/*  Routine when "_Choose me!"'s activation key is pressed  */

	/*  ...or return TRUE not to call the gadget function  */
	return SceglimiClicked();
}

BOOL BottoneClicked( void )
{
	/*  Routine when "_Button!" is clicked  */
	return( TRUE );
}

BOOL PaletteClicked( void )
{
	/*  Routine when "Palette" is clicked  */
	return( TRUE );
}

BOOL SceglimiClicked( void )
{
	/*  Routine when "_Choose me!" is clicked  */
	return( TRUE );
}

BOOL NumeroClicked( void )
{
	/*  Routine when "Key in a _number" is clicked  */
	return( TRUE );
}

BOOL StringaClicked( void )
{
	/*  Routine when "Key in a _string" is clicked  */
	return( TRUE );
}

BOOL ProvaImgClicked( void )
{
	/*  Routine when "BooleanGadget" is clicked  */
	return( TRUE );
}
