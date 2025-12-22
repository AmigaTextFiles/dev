/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.15 (6.12.96)

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
#include <pragmas/exec_pragmas.h>
#include <pragmas/gadtools_pragmas.h>

#include "MultiSelect.h"

extern void End( ULONG );
extern struct Node ListNodes[];
extern void  *WBMsg;

void Error(STRPTR str, STRPTR str2)
{
    TEXT c[ 256 ] = "";

    sprintf( c, "%s %s", str, str2 );

    if( WBMsg ) {   // this requires the 'Workbench' checkbox to be checked

	fprintf( stderr, "\n%s\n", c );

      } else {

	struct IntuiText error_text = {
	   0, 0, JAM1, 0, 10, NULL, c, NULL };

	static struct IntuiText ok_text = {
	   0, 0, JAM1, 0, 0, NULL, "OK", NULL };

	if( IntuitionBase )
	    AutoRequest( NULL, &error_text, NULL, &ok_text, 0, 0, 0, 0 );
    }

    End( 10 );
}


BOOL MainCloseWindow( void )
{
	/*  Routine for IDCMP_CLOSEWINDOW  */
	/*  Return FALSE to quit, I suppose... ;)  */
	return( FALSE );
}

BOOL QuitClicked( void )
{
    return( FALSE );
}

BOOL QuitKeyPressed( void )
{
    return( FALSE );
}


BOOL ListClicked( void )
{
    static ULONG ListTag[] = { GTLV_Labels, 0, TAG_END };

    ListTag[1] = (ULONG)~0;

    GT_SetGadgetAttrsA( MainGadgets[ GD_List ], MainWnd, NULL,
			( struct TagItem * )ListTag );

    ListNodes[ MainMsg.Code ].ln_Pri ^= ML_SELECTED;

    ListTag[1] = (ULONG)&ListList;

    GT_SetGadgetAttrsA( MainGadgets[ GD_List ], MainWnd, NULL,
			( struct TagItem * )ListTag );

    return( TRUE );
}

