/****h* AmigaTalk/APrintf.c [3.0] *************************************
*
* NAME
*    APrintf.c
*
* DESCRIPTION
*    APrintf is a substitute that sends output to the
*    st_console that is opened in Amiga.c
*
* RETURNS
*    Integer.
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*    19-Mar-2001 - Added a fixed string output function APrint().
*    09-Feb-2000 - Started a major re-write of the entire program,
*                  mostly to incorporate CommonFuncs.o
*    19-Aug-1998 - Deleted AmigaStatus().
*
* NOTES
*    $VER: APrintf.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
//#include <stdarg.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "CProtos.h"
#include "FuncProtos.h"

#include "StringIndexes.h"
#include "StringConstants.h"

/*
#define  MAX_LINE 80
#define  ENDLINE  "\n"
#define  FLOAT    1
#define  STRING   2
#define  INTEGER  3
#define  LONG_INT 4
#define  CHAR     5
*/

PRIVATE int ReopenConsole( int Height )
{
   int rval = 0;
   
   if ((rval = OpenStatusWindow( Height )) < 0)
      {
      fprintf( stderr, APrintCMsg( MSG_FMT_AP_REOPEN_APRINTF ), rval );

      return( -1 );
      }

   return( 0 );
}

PRIVATE char *TABSTR  = THREE_SPACES;

IMPORT UWORD DefaultTabSize; // ToolType in Main.c 

IMPORT void  ConDumps( struct Console *, char * );
IMPORT void  ConDumpc( struct Console *, char );


IMPORT struct Console *st_console;


/* ---------------- Places where APrint is used: ----------------- */
/*     LexCmd.c Line.c PrimFuncs.c Object.c Main.c Process.c       */
/* --------------------------------------------------------------- */

/****h* AmigaTalk/APrint() *****************************************
*
* NAME
*    APrint()
*
* DESCRIPTION
*    Send a string to the status console.  This function is 
*    necessary since Amiga_Printf() produces mis-spaced output.
********************************************************************
*
*/

PUBLIC void APrint( char *outstr )
{
   if (!st_console) // == NULL)
      {
      if (ReopenConsole( 50 ) != 0)
         {
         fprintf( stderr, APrintCMsg( MSG_FMT_AP_NOCONSOLE_APRINTF ), outstr );

         return;        // NO st_console!
         }
      }

   ConDumps( st_console, outstr );   

   return;
}

/* ------------------- END of APrintf.c file --------------------- */
