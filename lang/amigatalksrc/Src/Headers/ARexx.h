/****h* AmigaTalk/ARexx.h [1.5] ***********************************
*
* NAME
*    ARexx.h
*
* DESCRIPTION
*    Header for the AmigaTalk structures needed by
*    the Arexx interface to AmigaTalk.
*******************************************************************
*
*/

/*
 * $Log$
*/

#if      !(AREXX_H)
# define   AREXX_H      1


# define     MAX_ARGS       15
# define     ARG_SIZE       80
# define     FNAME_LEN      34
# define     NUM_FILES      15
# define     MAXNAME_LEN    80

struct ReturnBlock {

   LONG         Type;
   union  {

      LONG      IntVal;
      APTR      AddrVal;
      UBYTE     CharVal[ 256 ];
         
      }   values;
};

# define      RBINT      1
# define      RBADDR     2
# define      RBSTRING   3

typedef   struct RexxMsg       *RXMSGPTR;
typedef   struct ReturnBlock   *RBLOCKPTR;

/* ---- Function prototypes for ARexxFuncs.c file: ---- */

PRIVATE LONG PlaceCodesInFile( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG PurgeClass(       RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG ReloadClass(      RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG GetClassListType( RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG ReloadMethod(     RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG AddClass(         RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG AddMethod(        RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG ArexxQuit(        RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG GetClassFileName( RXMSGPTR rmptr, RBLOCKPTR result );

/* Private to AmigaTalk: */

PRIVATE LONG ReportStatus(         RXMSGPTR rmptr, RBLOCKPTR result );
PRIVATE LONG TranslateErrorNumber( RXMSGPTR rmptr, RBLOCKPTR result );

#endif

/* ----------------------- END of ARexx.h file! ---------------------- */
