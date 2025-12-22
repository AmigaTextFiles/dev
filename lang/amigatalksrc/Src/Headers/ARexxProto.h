/****h* AmigaTalk/ARexxProto.h [1.5] ********************************
*
* NAME
*    ARexxProto.h
*
* DESCRIPTION
*    Function prototypes for the ARexx interface.
*********************************************************************
*
*/

/*
 * $Log$
*/

/* ----------------- functions in ARexxFuncs.c: ---------------- */

PUBLIC LONG ARexxExec( RXMSGPTR rmptr, ENVPTR Env, STRPTR resultptr );

/*
PRIVATE LONG funclookup( STRPTR fname );

PRIVATE LONG PlaceCodesInFile( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG GetClassFileName( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG PurgeClass( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG ReloadClass( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG GetClassListType( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG ReloadMethod( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG AddClass( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG AddMethod( RXMSGPTR rmptr, RBLOCKPTR result );

PRIVATE LONG ArexxQuit( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG ReportStatus( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG TranslateErrorNumber( RXMSGPTR rmptr, RBLOCKPTR result );

PRIVATE void StringToUpper( char *dest, char *src );
PRIVATE int  revstr( char string[], int start, int end );
PRIVATE void pad_w_zeroes( char string[], int numzeroes );
PRIVATE void to_hexstr( unsigned int input, char hex[], unsigned int pad );
*/

/* ----------------- functions in ATBrowser.c: -------------- */

PUBLIC int HandleBrowser( void );

/*
PRIVATE int   Destroy_ARexx( void );
PRIVATE int   Create_ARexx( void );
PRIVATE int   Handle_ARexx( void );
PRIVATE int   execute_command( struct RexxMsg *rexxmessage );

PRIVATE void           CloseAll( void );
PRIVATE struct MsgPort *setup_rexx_port( void );
PRIVATE int            Setup( void );
PRIVATE int            send_rexx_command( char *buff );
PRIVATE void           free_rexx_command( struct RexxMsg *rexxmessage );
PRIVATE int            GetArguments( char *str );
PRIVATE int            StripOffCommand( char *str );

PRIVATE void reply_rexx_command( struct RexxMsg *rexxmessage,
                                 long           primary, 
                                 long           secondary,
                                 char           *result
                               );
*/                                          

/* --------------------- END of ARexxProto.h file! -------------------- */
