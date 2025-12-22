/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.15 (6.12.96)

    Copy registered to :  Simone Tellini
    Serial Number      : #0
*/

#define INTUI_V36_NAMES_ONLY

#include <dos/dos.h>
#include <exec/libraries.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "MultiSelect.h"
int    main( void );
void   OpenLibs( void );
void   Setup( void );
void   CloseLibs( void );
void   CloseAll( void );
void   PlayTheGame( void );
void   Error( STRPTR, STRPTR );
void   End( ULONG );
int    wbmain( struct WBStartup * );

BOOL			Ok_to_Run = TRUE;
ULONG			mask = NULL;

extern struct Library	*SysBase;
extern struct Library	*DOSBase;
struct WBStartup		*WBMsg = NULL;
struct Library		*GadToolsBase = NULL;
struct Library		*GfxBase = NULL;
struct Library		*IntuitionBase = NULL;

#include "IE_Errors.h"

int main( void )
{
	OpenLibs();
	Setup();
	PlayTheGame();
	End( RETURN_OK );
}

void End( ULONG RetCode )
{
	CloseAll();
	CloseLibs();
	exit( RetCode );
}

void OpenLibs( void )
{
	if (!( GadToolsBase = OpenLibrary( "gadtools.library", 0 )))
		Error( ErrStrings[ OPEN_LIB ], "gadtools.library" );
	if (!( GfxBase = OpenLibrary( "graphics.library", 0 )))
		Error( ErrStrings[ OPEN_LIB ], "graphics.library" );
	if (!( IntuitionBase = OpenLibrary( "intuition.library", 0 )))
		Error( ErrStrings[ OPEN_LIB ], "intuition.library" );
}

void Setup( void )
{
	ULONG		ret;
	if ( ret = SetupScreen())
		Error( ErrStrings[ SETUP_SCR ], ErrStrings[ SETUP_SCR+ret ]);
	if ( ret = OpenMainWindow())
		Error( ErrStrings[ OPEN_WND ], ErrStrings[ OPEN_WND+ret ]);
}

void CloseAll( void )
{
	CloseMainWindow();
	CloseDownScreen();
}

void CloseLibs( void )
{
	if ( GadToolsBase )
		CloseLibrary( GadToolsBase );
	if ( GfxBase )
		CloseLibrary( GfxBase );
	if ( IntuitionBase )
		CloseLibrary( IntuitionBase );
}

void PlayTheGame( void )
{
	ULONG	signals;
	ULONG	Main_signal = 1 << MainWnd->UserPort->mp_SigBit;
	mask = mask | SIGBREAKF_CTRL_C | Main_signal;

	while( Ok_to_Run ) {
		signals = Wait( mask );
		if (signals & Main_signal)
			Ok_to_Run = HandleMainIDCMP();
		if (signals & SIGBREAKF_CTRL_C)
			Ok_to_Run = FALSE;
	};

}

int wbmain( struct WBStartup *msg )
{
	WBMsg = msg;
	return( main() );
}
