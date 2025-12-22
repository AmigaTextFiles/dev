/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.2 (22.2.96)

    Copy registered to :  Gian Maria Calzolari - Beta Tester 2
    Serial Number      : #2
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

#include "SysHD:Develop/ieditor/EsempiMiei/GMExample.h"
int    main( void );
void   OpenLibs( void );
void   Setup( void );
void   CloseLibs( void );
void   CloseAll( void );
void   PlayTheGame( void );
void   Error( STRPTR, STRPTR );
void   End( ULONG );
int    wbmain( struct WBStartup * );
extern void MySetup( void );

BOOL            Ok_to_Run = TRUE;
ULONG           mask = NULL;

extern struct Library   *SysBase;
extern struct Library   *DOSBase;
struct WBStartup        *WBMsg = NULL;
struct Library      *RexxSysBase = NULL;

#include "IE_Errors.h"

int main( void )
{
    OpenLibs();
    Setup();
    MySetup();
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
    if (!( RexxSysBase = OpenLibrary( "rexxsyslib.library", 0 )))
	Error( ErrStrings[ OPEN_LIB ], "rexxsyslib.library" );
}

void Setup( void )
{
    ULONG       ret;
    if (!( OpenDiskFonts()))
	Error( ErrStrings[ OPEN_FONTS ], NULL );
    if ( ret = SetupScreen())
	Error( ErrStrings[ SETUP_SCR ], ErrStrings[ SETUP_SCR+ret ]);
    if ( ret = OpenMiaFinWindow())
	Error( ErrStrings[ OPEN_WND ], ErrStrings[ OPEN_WND+ret ]);
    SetupRexxPort();
}

void CloseAll( void )
{
    CloseMiaFinWindow();
    CloseDownScreen();
    CloseDiskFonts();
    DeleteRexxPort();
}

void CloseLibs( void )
{
    if ( RexxSysBase )
	CloseLibrary( RexxSysBase );

}

void PlayTheGame( void )
{
    ULONG   signals, other = mask;
    ULONG   MiaFin_signal = 1 << MiaFinWnd->UserPort->mp_SigBit;
    ULONG   rexx_signal = NULL;

    if ( RexxPort )
	rexx_signal = 1 << RexxPort->mp_SigBit;

    mask = mask | SIGBREAKF_CTRL_C | MiaFin_signal | rexx_signal;

    while( Ok_to_Run ) {
	signals = Wait( mask );
	if (signals & MiaFin_signal)
	    Ok_to_Run = HandleMiaFinIDCMP();
	if (signals & rexx_signal)
	    HandleRexxMsg();
	if (signals & SIGBREAKF_CTRL_C)
	    Ok_to_Run = FALSE;
    };

}

int wbmain( struct WBStartup *msg )
{
    WBMsg = msg;
    return( main() );
}
