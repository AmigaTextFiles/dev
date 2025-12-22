/*
 *      CONFIG.C
 */

#include "BGUIPlayer.h"

/*
 *      Parse and evaluate command.
 */
static ULONG ParseConfigComm( struct RDArgs *rda, CONFIGCOMM *parser, UBYTE *argstr )
{
        UBYTE                   *temp = parser->cc_ArgTemplate;
        ULONG                   *args, rc = 0L;
        UWORD                    nargs = 0;

        /*
         *      Args expected?
         */
        if ( ! temp ) {
                ( parser->cc_Func )( NULL );
                return;
        }

        /*
         *      Count the number of arguments we can expect.
         */
        while ( *temp ) {
                if ( *temp == ',' ) nargs++;
                temp++;
        }
        nargs++;

        /*
         *      Allocate storage for the parsed result.
         */
        if ( args = ( ULONG * )AllocVec( nargs * sizeof( ULONG ), MEMF_PUBLIC | MEMF_CLEAR )) {
                /*
                 *      Setup RDArgs structure.
                 */
                rda->RDA_Source.CS_Buffer = argstr;
                rda->RDA_Source.CS_Length = strlen( argstr );
                rda->RDA_Source.CS_CurChr = 0;
                rda->RDA_DAList           = NULL;
                rda->RDA_Buffer           = NULL;
                /*
                 *      Parse arguments.
                 */
                if ( ReadArgs( parser->cc_ArgTemplate, args, rda )) {
                        /*
                         *      Call the evaluation routine.
                         */
                        ( parser->cc_Func )( args );
                        FreeArgs( rda );
                } else
                        rc = IoErr();
                FreeVec( args );
        } else
                rc = ERROR_NO_FREE_STORE;

        return( rc );
}

/*
 *      Read a configuration file.
 */
Prototype LONG ReadConfigFile( UBYTE *, CONFIGCOMM *, ULONG * );

LONG ReadConfigFile( UBYTE *name, CONFIGCOMM *parsers, ULONG *linenum )
{
        struct RDArgs          *rda;
        struct ConfigComm      *reset = parsers;
        BPTR                    file;
        UBYTE                   lbuf[ 512 ];
        ULONG                   rc = 0L;
        UWORD                   i;

        /*
         *      Clear line number.
         */
        *linenum = 0;

        /*
         *      Allocate a RDArgs structure.
         */
        if ( rda = ( struct RDArgs * )AllocDosObject( DOS_RDARGS, NULL )) {
                /*
                 *      No prompting.
                 */
                rda->RDA_Flags |= RDAF_NOPROMPT;
                /*
                 *      Open the file.
                 */
                if ( file = Open( name, MODE_OLDFILE )) {
                        /*
                         *      Read the file line-by-line.
                         */
                        while ( FGets( file, lbuf, 512 )) {
                                /*
                                 *      Start from the beginning.
                                 */
                                i = 0;
                                /*
                                 *      Increase line number.
                                 */
                                *linenum += 1;
                                /*
                                 *      Skip leading spaces.
                                 */
                                while ( lbuf[ i ] == ' ' || lbuf[ i ] == '\t' ) i++;
                                /*
                                 *      Characters left?
                                 */
                                if ( ! lbuf[ i ] || lbuf[ i ] == '\n' )
                                        goto nextLine;
                                /*
                                 *      A comment line?
                                 */
                                if ( lbuf[ i ] != ';' && lbuf[ i ] != '#' ) {
                                        /*
                                         *      Look for the correct command parser.
                                         */
                                        while ( parsers->cc_Name ) {
                                                /*
                                                 *      Is this the one?
                                                 */
                                                if ( ! strnicmp( &lbuf[ i ], parsers->cc_Name, strlen( parsers->cc_Name ))) {
                                                        /*
                                                         *      Skip the command name.
                                                         */
                                                        i += strlen( parsers->cc_Name );
                                                        /*
                                                         *      Parse and evaluate args.
                                                         */
                                                        rc = ParseConfigComm( rda, parsers, &lbuf[ i ] );
                                                        /*
                                                         *      Error?
                                                         */
                                                        if ( rc )
                                                                goto error;
                                                        goto nextLine;
                                                }
                                                /*
                                                 *      Next...
                                                 */
                                                parsers++;
                                        }
                                        /*
                                         *      Command found?
                                         */
                                        if ( ! parsers->cc_Name ) {
                                                rc = ERROR_BAD_TEMPLATE;
                                                goto error;
                                        }
                                }
                                nextLine:
                                parsers = reset;
                        }
                        error:
                        /*
                         *      Closeup the file.
                         */
                        Close( file );
                } else
                        rc = ERROR_OBJECT_NOT_FOUND;
                /*
                 *      Free the RDArgs structure.
                 */
                FreeDosObject( DOS_RDARGS, rda );
        } else
                rc = ERROR_NO_FREE_STORE;

        return( rc );
}

/*
 *      Global configuratio data.
 */
Prototype UBYTE DeviceName[ 108 ], Popkey[ 128 ], *PubScreen, DiskPath[ 256 ];
Prototype ULONG DevID, Popup;

UBYTE DeviceName[ 108 ]   = "scsi.device";
UBYTE Popkey[ 128 ]       = "lshift control c";
UBYTE PubScreenName[ 64 ], *PubScreen;
UBYTE DiskPath[ 256 ];
ULONG DevID, Popup;

/*
 *      The configuration commands.
 */
static VOID ParseDevice( ULONG * );
static VOID ParsePopKey( ULONG * );
static VOID ParsePubScreen( ULONG * );
static VOID ParsePopup( ULONG * );
static VOID ParseDiskPath( ULONG * );

static CONFIGCOMM ConfigCommands[] = {
        { "DEVICE",     "NAME/K,BOARD/K/N,LUN/K/N,ADDRESS/K/N", ParseDevice     },
        { "POPKEY",     "KEY/A/F",                              ParsePopKey     },
        { "PUBSCREEN",  "SCREEN/K,DEFAULT/S",                   ParsePubScreen  },
        { "POPUP",      "YES/S,NO/S",                           ParsePopup      },
        { "DISKPATH",   "PATH/F",                               ParseDiskPath   }
};

/*
 *      Evaluate the DEVICE command.
 */
static VOID ParseDevice( ULONG *args )
{
        /*
         *      Copy device name.
         */
        if ( args[ 0 ] ) strcpy( DeviceName, ( UBYTE * )args[ 0 ] );
        /*
         *      Evaluate Device ID.
         */
        if ( args[ 1 ] ) DevID += *(( LONG * )args[ 1 ] ) * 100;
        if ( args[ 2 ] ) DevID += *(( LONG * )args[ 2 ] ) * 10;
        if ( args[ 3 ] ) DevID += *(( LONG * )args[ 3 ] ); else DevID += 1;
}

/*
 *      Evaluate the POPKEY command.
 */
static VOID ParsePopKey( ULONG *args )
{
        strncpy( Popkey, ( UBYTE * )args[ 0 ], 128 );
}

/*
 *      Evaluate the PUBSCREEN command.
 */
static VOID ParsePubScreen( ULONG *args )
{
        /*
         *      Name specified?
         */
        if ( args[ 0 ] ) {
                strncpy( PubScreenName, ( UBYTE * )args[ 0 ], 64 );
                PubScreen = PubScreenName;
        } else
                /*
                 *      No. Use default screen.
                 */
                PubScreen = NULL;
}

/*
 *      Evaluate the POPUP command.
 */
static VOID ParsePopup( ULONG *args )
{
        /*
         *      No?
         */
        if ( args[ 1 ] ) Popup = 0;
        else             Popup = 1;
}

/*
 *      Evaluate the DISKPATH command.
 */
static VOID ParseDiskPath( ULONG *args )
{
        if ( args[ 0 ] ) strncpy( DiskPath, ( UBYTE * )args[ 0 ], 256 );
}

/*
 *      Read the configuration file. First we try
 *      to load it from PROGDIR: and if that fails
 *      we try it in ENVARC:
 */
Prototype VOID LoadConfig( void );

VOID LoadConfig( void )
{
        ULONG           line = 0;

        if ( ReadConfigFile( "PROGDIR:bgp.prefs", ConfigCommands, &line ) == ERROR_OBJECT_NOT_FOUND )
                ReadConfigFile( "ENVARC:bgp.prefs", ConfigCommands, &line );
}
