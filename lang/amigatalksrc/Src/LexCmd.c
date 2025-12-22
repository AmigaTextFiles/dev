/****h* AmigaTalk/LexCmd.c [3.0]  ************************************
*
* NAME
*    LexCmd.c
*
* DESCRIPTION
*    Little Smalltalk misc lexer-related routines.
*
* DEFINED FUNCTIONS:
*
* void  dolexcommand( char * ); Do ')!' & other command calls.
*       Call the user !command via ATSystem( cmdbuff ).
*
* ------------- Private functions: -----------------------------------
*
* void  lexinclude( char * );   Do ')i' command.
*       Call the PARSER via system( cmdbuff ).
*
* void  lexread( char * );      Do ')g' or ')r' command.
*       Use set_file( FILE * ) to set up line_grabber() to do the actual
*       reading of the file.
*
* int   lexedit( char * );      Do ')e' command.
*       Call the EDITOR defined in environment var EDITOR (or use 'Ed')
*       via ATSystem( cmdbuff ).  After lexedit(), the command string
*       ')e filename' is placed in the ListView gadget.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
*    01-Aug-2002 - Changed line 117 in lexinclude() to use ftemplate
*                  as a file, redirection no longer needed.
*
* EXTERNAL REF'S:
*
*    IMPORT char toktext[];     Defined in Src/Lex.c file
*
* NOTES
*    $VER: AmigaTalk:Src/LexCmd.c 3.0 (25-Oct-2004) by J.T Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/screens.h>

#include "env.h"

#include <ctype.h>

#ifdef    __SASC
# include <clib/intuition_protos.h>
#else

# define __USE_INLINE__

# include <proto/intuition.h>

#endif

#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "FuncProtos.h"

IMPORT char toktext[ MAXTOKEN ];

IMPORT void *malloc( int );

IMPORT char outmsg[]; // For APrint() calls.

IMPORT struct Screen *Scr;

/****h* lexread() [1.5] **********************************************
*
* NAME
*    lexread()
*
* DESCRIPTION
*    User typed in ')g' or ')r' command - read cmds from a file.
**********************************************************************
*
*/

PUBLIC void lexread( char *name )
{
   FILE *fd = (FILE *) NULL;

   FBEGIN( printf( "void lexread( %s )\n", name ) );

   fd = fopen( name, FILE_READ_STR );

   if (!fd) // == NULL)
      {
      NotOpened( 2 );

      fprintf( stderr, LCmdCMsg( MSG_CANNOT_OPEN_LXC ), name );
      
      // Amiga_Printf( "Can't open %s!\n", name );
      }
   else 
      {
      set_file( fd ); // reading will now be done by line_grabber()!
      }

   FEND( printf( "lexread() exits\n" ) );

   return;
}

/****h* lexinclude() [2.1] *******************************************
*
* NAME
*    lexinclude()
*
* DESCRIPTION
*    User typed in a ')i' command - parse a class and include the 
*    class description.
**********************************************************************
*
*/

PUBLIC void lexinclude( char *name )
{
   IMPORT UBYTE ParserName[ LARGE_TOOLSPACE ];

   char ftemplate[60] = { 0, }, *fname, cmdbuf[512] = { 0, };
   int  i;

   FBEGIN( printf( "void lexinclude( %s )\n", name ) );

#  ifndef NOSYSTEM

   fname = tmpnam( &ftemplate[0] );

   // Deleted redirection of output 01-Aug-2002 (Parser no longer uses it).
   sprintf( cmdbuf, "%s -hex %s %s", ParserName, name, ftemplate );
   
   i = ATSystem( cmdbuf ); // Execute the Parser command.

//   printf( "%s = %d\n", cmdbuf, i) ;

   if (i == 0)
      lexread( ftemplate ); // Read the Parser output into AmigaTalk system. 

#  else
   APrint( LCmdCMsg( MSG_NO_INCLUDE_LXC ) );
   // Amiga_Printf( ")i doesn't work on this system!\n" );
#  endif

   FEND( printf( "lexinclude() exits\n" ) );

   return;
}

/****h* lexedit() [1.5] **********************************************
*
* NAME
*    lexedit()
*
* DESCRIPTION
*    User typed in a ')e' command.  Edit a class description
**********************************************************************
*
*/

PUBLIC int lexedit( char *name )
{
   IMPORT UBYTE Editor[ LARGE_TOOLSPACE ]; // ToolType in main.c file.

   int  rval = 1;
   char bf[512] = { 0, }, *buffer = &bf[0];
   
   FBEGIN( printf( "lexedit( %s )\n", name ) );

#  ifndef NOSYSTEM
   
      sprintf( buffer,"%s %s", Editor, name ); // call editor from System:

      ScreenToBack( Scr );

      rval = ATSystem( buffer );
      
#  else
      APrint( LCmdCMsg( MSG_NO_EDITOR_LXC ) );
#  endif      
      // Amiga_Printf( ")e doesn't work on this system!\n" );

   FEND( printf( "%d = lexedit()\n", rval ) );

   return( rval );
}

/****h* dolexcommand() [1.5] *****************************************
*
* NAME
*    dolexcommand()
*
* DESCRIPTION
*    we read a ')x'-type directive in line_grabber().
*    It now needs to be processed by dolexcommand().
**********************************************************************
*
*/

PUBLIC void dolexcommand( char *p )
{
   IMPORT UBYTE LibraryPath[ LARGE_TOOLSPACE ];

   char *q, buffer[100] = { 0, };
   int   len = StringLength( LibraryPath );

   FBEGIN( printf( "void dolexcommand( %s )\n", p ) );   

   // replace trailing newline with end of string:
   for (q = p; (*q != NIL_CHAR) && (*q != NEWLINE_CHAR); q++)
      ;

   if (*q == NEWLINE_CHAR) 
      *q = NIL_CHAR;

      switch (*++p) // Skip over the ')'
         {
         case EXCLAIM_CHAR:      // Command was a Shelled System call!!

#           ifndef NOSYSTEM
            ATSystem( ++p ); // (void) ATSystem( ++p );
#           endif
            break;

         case SMALL_E_CHAR:
            for (++p; isspace( *p ); p++)  
               ;

            // NOT the same as the 'Edit a file...' menu item:
            if (lexedit( p ) == 0) 
               {
               ScreenToFront( Scr );

               lexinclude( p ); // Now, parse the new Class also!
               }

            break;

         case SMALL_G_CHAR:
            for (++p; isspace( *p ); p++) 
               ;

            // LIBLOC is 'AmigaTalk:CodeLib/':
            if ((LibraryPath[ len ] == SLASH_CHAR) || (LibraryPath[ len ] == COLON_CHAR))
               sprintf( buffer, "%s%s", LibraryPath, p );
            else
               sprintf( buffer, "%s/%s", LibraryPath, p );

            lexread( buffer );

            break;

         case SMALL_I_CHAR: 
            for (++p; isspace( *p ); p++)
               ;

            lexinclude( p );
            break;

         case SMALL_R_CHAR:
            for (++p; isspace( *p ); p++)
               ;

            lexread( p );
            break;
/*
         case SMALL_S_CHAR: 
            for (++p; isspace( *p ); p++)
               ;

            dosave( p );
            break;

         case SMALL_L_CHAR: 
            for (++p; isspace( *p ); p++)
               ;

            doload( p );
            break;
*/
         
         default:
            lexerr( LCmdCMsg( MSG_UNKNOWNCMD_LXC ), toktext );
         }

   FEND( printf( "dolexcommand() exits\n" ) );

   return;
}

/* --------------------- END of LexCmd.c file! ----------------------- */
