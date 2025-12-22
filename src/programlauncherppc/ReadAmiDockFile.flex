/****h* ProgramLauncher/ReadAMiDockFile.flex [1.0] *****************
*
* NAME
*    ReadAmiDockFile.flex
*
* DESCRIPTION
*    Scan through the file that defines the contents of AmiDock.
*
* HISTORY
*    29-Jan-2005 - Created this file.
********************************************************************
*
*/

/* ----------------------- Definitions Section: -------------------- */

%option noyywrap
%START PREAMBLE GOT_PREAMBLE DOCK_NAME GOT_KEY NORM AMIERROR

WHT           ([ \t]*)

XML_ID        "<?xml version="

KEY_ICONS     "<key>Icons</key>"

KEY_FILENAME  "<key>FileName</key>"

KEY_NAME      "<key>Name</key>"

STRING_START  "<string>"

STRING_END    "</string>"

IDENT         ([_a-zA-Z][_a-zA-Z0-9\:\/]*)

PRGM_STRING   ({STRING_START}{IDENT}{STRING_END})

NL            \n

%{

#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/locale.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *LocaleBase;

IMPORT struct ExecIFace   *IExec;
IMPORT struct DOSIFace    *IDOS;
IMPORT struct LocaleIFace *ILocale;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#ifndef DEBUG

# define   CATCOMP_ARRAY 1
# include "ProgramLauncherLocale.h"

IMPORT struct Catalog *catalog;

IMPORT UBYTE *ErrMsg;

IMPORT STRPTR CMsg( int strIndex, STRPTR defaultString );

PRIVATE void storeProgramString( char *pgmString );
PRIVATE void displayError( char *whereAt );

IMPORT  void WriteProgramString( char *programString, int pgmindex ); // back in main source file.

#else

PRIVATE void storeProgramString( char *pgmString );
PRIVATE void displayError( char *whereAt );
PRIVATE void WriteProgramString( char *programString, int pgmindex );

#endif

#ifdef   DEBUG
# define DBG(p) p
#else
# define DBG(p)
#endif

// --------------------------------------------------------------------

PRIVATE int preamble = 0, lineCount = 0;

%}

/* -------------------------- Rules Section: ------------------------ */

%%

<PREAMBLE>{XML_ID}           { BEGIN 0;
                               BEGIN GOT_PREAMBLE;
		               preamble++;
                             }

<PREAMBLE>{KEY_FILENAME}     ;

<GOT_PREAMBLE>{KEY_ICONS}    { if (preamble < 1)
		                  BEGIN AMIERROR;
			       else
			          GOT_PREAMBLE;
                             }

<GOT_PREAMBLE>{KEY_NAME}     { BEGIN DOCK_NAME; }

<GOT_PREAMBLE>{PRGM_STRING}  ;

<DOCK_NAME>{KEY_NAME}        { BEGIN NORM; }

<NORM>{KEY_FILENAME}         { BEGIN GOT_KEY; }

<GOT_KEY>{PRGM_STRING}       { storeProgramString( yytext ); 
                               BEGIN DOCK_NAME;
			     }

<AMIERROR>.                  { displayError( yytext ); }

{NL}                         { lineCount++; }

{WHT}                        ;

.                            ;

%%

/* -------------------------- User Code Section: -------------------- */

PRIVATE pgmIndex = 0;

PRIVATE void storeProgramString( char *pgmString )
{
   char program[512] = { 0, };
   int  i, len = 0;
   
   while (*pgmString != '>')
      pgmString++;
   
   pgmString++; // Skip over the '>' also
   
   len = StringLength( pgmString );
   i   = 0;
   
   while (*(pgmString + i) != '<' && i < len)
      {
      program[i] = *(pgmString + i);
      
      if (i >= len)
         break;
	 
      i++;
      }
   
   *(pgmString + i) = '\0';
   
   WriteProgramString( &program[0], pgmIndex++ );
   
   return;
}

FILE *amiDockFP = NULL;

PRIVATE void displayError( char *whereAt )
{
   DBG( fprintf( stderr, "FAILED near:\n\n   '%s'\n", whereAt ) );   

   if (amiDockFP && amiDockFP != stdin)
      fclose( amiDockFP );

   exit( RETURN_FAIL );   
}

PRIVATE int checkFileSize( FILE *fp )
{
   int rval = 0, ch = 0;
   
   ch = fgetc( fp );
   
   while (ch != EOF)
      {
      rval++;

      ch = fgetc( fp );
      }

   rewind( fp );
   
   return( rval );
}

/****h* ProgramLauncher/readAmiDockFile() *****************************
*
* NAME
*    readAmiDockFile()
*
* DESCRIPTION
*    Scan through file that defines the contents of AmiDock.
***********************************************************************
*
*/

PUBLIC int readAmiDockFile( char *amiDockFileName )
{
   IMPORT FILE *yyin;

   BOOL closeAmiDockFile = FALSE;

   int  rval = RETURN_OK, chk = 0;
   
   // -----------------------------------------------------------------

#  ifndef DEBUG
   if (!(amiDockFP = OpenFile( amiDockFileName, "r" )))
#  else
   if (!(amiDockFP = fopen( amiDockFileName, "r" )))
#  endif
      {
      rval = IoErr();

      DBG( fprintf( stderr, "%s did NOT open!\n", amiDockFileName ) ); // 

#     ifndef DEBUG      
      fprintf( stderr, CMsg( MSG_FMT_NO_READ_FILEOPEN, MSG_FMT_NO_READ_FILEOPEN_STR ), amiDockFileName );
#     endif

      goto ExitReadAmiDock;
      }
  
   closeAmiDockFile = TRUE;

   if ((chk = checkFileSize( amiDockFP )) == 0)
      {
      DBG( fprintf( stderr, "%s is EMPTY!\n", amiDockFileName ) );
      
#     ifndef DEBUG      
      fprintf( stderr, CMsg( MSG_FMT_EMPTY_FILE_FOUND, MSG_FMT_EMPTY_FILE_FOUND_STR ), amiDockFileName );
#     endif

      rval = RETURN_ERROR;

      goto ExitReadAmiDock;
      }

   yyin = amiDockFP;
   BEGIN PREAMBLE;
   yylex();           // Find those Program strings!

   // All done, Close the file(s) & exit:

ExitReadAmiDock:

   if (closeAmiDockFile == TRUE)
      fclose( amiDockFP );

   return( rval );
}    

#ifdef DEBUG

PRIVATE void WriteProgramString( char *programString, int pgmindex )
{
   fprintf( stderr, "%d would have: \"%s\"\n", pgmindex, programString );
   
   return;
}

PUBLIC int main( int argc, char **argv )
{
   int rval = RETURN_OK;
   
   if (argc != 2)
      {
      fprintf( stderr, "USAGE:  %s <AmiDockFileName>\n", argv[0] );
      
      return( RETURN_ERROR );
      }

   if (readAmiDockFile( argv[1] ) != RETURN_OK)
      {
      fprintf( stderr, "%s Failed!\n", argv[0] );
      
      return( RETURN_FAIL );
      }

   return( rval );
}

#endif

/* ---------------- END of ReadAmiDockFile.flex file! --------------- */
