/*-- AutoRev header do NOT edit!
*
*   Program         :   Bump.c
*   Copyright       :   © Copyright 1992 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   6-Feb-92
*   Current version :   1.0
*   Translator      :   DICE v2.06
*
*   Changes         :   © Copyright 1997 Software Industry & General Hardware
*   Author          :   Clark Williams
*   Changes Date    :   Version 2.0 & 2.1
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   26-Feb-97     2.4             Added the version string to the output.
*   26-Feb-97     2.3             Added the full century to the date string.
*   25-Feb-97     2.2             Changed date to always put out leading zeros.
*   25-Feb-97     2.1             Added the European date format as standard
*                                 Added the USA/S switch to output dd.mm.yy
*   25-Feb-97     2.0             Converted to SAS C/C++ Version 6.56
*   21-Mar-92     1.0             Added "ONLYDATE" option.
*   08-Feb-92     1.0             Added "QUIET" option.
*   06-Feb-92     1.0             Version string updater.
*
*-- REV_END --*/

/*
 * --- Compiling : dcc -r -mRR -proto Bump.c -o Bump
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/utility_protos.h>
#include <ctype.h>
#include <stdarg.h>

/*
 * --- Some macros
 */

#define SKIP_BLANKS(p)      while(isspace(*p))  p++;
#define SEEK_DIGIT(p)       while(!isdigit(*p)) p++;
#define FIND_DOT(p)         while(*p++ != '.');

/*
 * --- The version string
 */

static UBYTE *version_string = "$VER: BUMP 2.4 (1997.02.26)";

/*
 * --- For the shell args
 */

#define           TEMPLATE_MEMBERS 9
UBYTE *template = "Name/A,INCVER/S,INCREV/S,SETVER/K/N,SETREV/K/N,QUIET/S,ONLYDATE/S,USADATE/S,NOCENT/S";
ULONG  array [ TEMPLATE_MEMBERS ] = { 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L };

/*
 * --- Some global data
 */

UBYTE  *header    =   "Error -";
BPTR    stdout    =   NULL;
UBYTE  *pointer   =   NULL;
ULONG   filesize;

/*
 * --- Function proto's
 */
extern ULONG atoi ( UBYTE * );
extern void  exit ( long    );

ULONG  MyFPrintf      ( BPTR, UBYTE *, ... );
UBYTE *SeekVersion    ( void               );
LONG   CheckFormat    ( UBYTE *            );
LONG   ReadSourceFile ( void               );
ULONG  GetNum         ( UBYTE *            );
void   DoDate         ( BPTR, BOOL, BOOL   );

/*
 * --- Perform formatted output
 */
ULONG MyFPrintf ( BPTR fh, UBYTE *format, ... )
{
    va_list     args;
    long        ret;

    va_start ( args, format );

    ret = VFPrintf ( fh, format, args );

    va_end ( args );

    return ( ( ULONG ) ret );
}

/*
 * --- Check the version string format.
 */
LONG CheckFormat ( UBYTE *ptr )
{
    UBYTE d = 0, l = 0, r = 0;

    while ( *ptr != 0x22 && *ptr != 0x27 )
    {
        switch( *ptr )
        {
            case    '.': d++;
                         break;
            case    '(': l++;
                         break;
            case    ')': r++;
                         break;
        }
        ptr++;
    }
    if ( d != 3 || l != 1 || r != 1 ) return( FALSE );
    return ( TRUE );
}

/*
 * --- Search through the buffer for the version string
 */

UBYTE *SeekVersion ( void )
{
    UBYTE           *ptr = pointer;
    ULONG            num = 0L;

    while ( 1 )
    {
        if ( *ptr == '$' && ! Strnicmp ( ptr + 1, "VER: ", 5 ) ) return ( ptr );
        ptr++;
        if ( num++ > ( filesize - 18 ) ) return ( 0L );
    }
    return ( ptr );
}

/*
 * --- Read in the source file
 */
LONG ReadSourceFile( void )
{
  BPTR            file;

  stdout = Output();

  if ( file = Open ( ( UBYTE * ) array [ 0 ], MODE_OLDFILE ) )
     {
       Seek ( file, 0L, OFFSET_END );
       filesize = Seek ( file, 0L, OFFSET_BEGINNING );
       if ( pointer = ( UBYTE * ) AllocMem( filesize, MEMF_PUBLIC ) )
          {
            if ( Read ( file, pointer, filesize ) == filesize )
               {
                 Close  ( file );
                 return ( TRUE );
               }
               else PrintFault ( IoErr(), header );
            FreeMem ( pointer, filesize );
          }
          else
          {
            SetIoErr ( ERROR_NO_FREE_STORE );
            PrintFault ( ERROR_NO_FREE_STORE, header );
          }
       Close ( file );
     }
     else
     {
       MyFPrintf ( stdout, "Can't open \"%s\" for input - ", array[ 0 ] );
       PrintFault ( IoErr(), NULL );
     }
  return ( FALSE );
}

/*
 * --- Convert the numbers from the source
 * --- into real numbers.
 */

ULONG GetNum( UBYTE *ptr )
{
  UBYTE number[ 20 ];
  UBYTE i = 0;

  while ( isdigit( *ptr ) ) number[ i++ ] = *ptr++;
  number [ i ] = 0;
  return ( atoi ( number ) );
}

/*
 * --- Ouput the current system date to the file.
 */

void DoDate ( BPTR file, BOOL UsaDate, BOOL NoCentury )
{
  struct DateTime  dt;
  char             date [ 12 ];
  ULONG            day, month, year;

  DateStamp ( (struct DateStamp * ) &dt );
  dt.dat_Format  = FORMAT_CDN;
  dt.dat_StrDate = &date [ 0 ];
  dt.dat_Flags   = 0;
  dt.dat_StrDay  = 0;
  dt.dat_StrTime = 0;
  DateToStr(&dt);

  day   = GetNum ( &date[ 0 ] );
  month = GetNum ( &date[ 3 ] );
  year  = GetNum ( &date[ 6 ] );

  /* Add the Century to the year */
  if ( ! NoCentury )
     {
       if ( year < 78 ) year += 2000;
          else          year += 1900;
     }

  /* Force out leading zeros. -- S.I.G.H. (BCW) */
  if ( UsaDate )
       if ( NoCentury ) MyFPrintf ( file, "(%02ld.%02ld.%02ld)", day, month, year );
          else          MyFPrintf ( file, "(%02ld.%02ld.%4ld)",  day, month, year );
     else
       if ( NoCentury ) MyFPrintf ( file, "(%02ld.%02ld.%02ld)", year, month, day );
          else          MyFPrintf ( file, "(%4ld.%02ld.%02ld)",  year, month, day );
}

void main ( int argc, char *argv[] )
{
    struct RDArgs   *cli_args;
    BPTR             file;
    UBYTE           *ptr;
    UBYTE           *ptr1;
    ULONG            revision;
    ULONG            version;
    BOOL             UsaDate   = FALSE;  /* Use USA date format. */
    BOOL             NoCentury = FALSE;  /* Do not include century in output of date. */

    stdout = Output();

    if ( cli_args = ReadArgs( template, (long *) &array[ 0 ], 0L ) )
       {
        if ( ! array [ 1 ] && ! array [ 2 ] && ! array [ 3 ] && ! array [ 4 ] && ! array [ 6 ] )
           {
             array [ 2 ] = TRUE;
             if ( ! array [ 5 ] ) FPuts ( stdout, "Defaulting to INCREV\n" );
           }

        SetIoErr ( NULL );

        if ( ReadSourceFile() )
           {
            SetIoErr ( 0L );

            if ( ! array [ 5 ] ) MyFPrintf ( stdout, "%s\n",                version_string );
            if ( ! array [ 5 ] ) MyFPrintf ( stdout, "Processing \"%s\"\n", array[ 0 ]     );

            UsaDate   = array [ 7 ]; /* Does User want a USA date format?  */
            NoCentury = array [ 8 ]; /* Whether to output century in date. */

            if ( ptr = SeekVersion())
               {
                 if ( CheckFormat( ptr ))
                    {
                      ptr1 = pointer;

                      if ( ! array [ 5 ] )
                           MyFPrintf ( stdout, "Found version string at %ld in \"%s\"\n", ptr - ptr1, array[ 0 ] );

                      ptr += 6;

                      if ( file = Open ( ( UBYTE * ) array [ 0 ], MODE_NEWFILE ) )
                         {
                           FWrite ( file, ptr1, (ULONG) ( ptr - ptr1 ), 1 );

                           SKIP_BLANKS ( ptr );

                           if ( ! array [ 5 ] ) FPuts ( stdout, "Program name \"" );

                           while ( ! isspace ( *ptr ) )
                           {
                              FPutC ( file, *ptr );
                              if ( ! array [ 5 ] ) FPutC ( stdout, *ptr );
                              ptr++;
                           }

                           if ( ! array[ 5 ] ) FPuts ( stdout, "\"\n" );

                           SEEK_DIGIT ( ptr );

                           version = GetNum ( ptr );

                           FIND_DOT ( ptr );

                           revision = GetNum ( ptr );

                           if ( ! array [ 5 ] )
                              {
                                if ( ! array [ 6 ] )
                                     MyFPrintf ( stdout, "Old version : %ld.%ld\n", version, revision );
                                   else FPuts( stdout, "Updating version date\n" );
                              }

                           if ( ! array [ 6 ] )
                              {
                                if ( array [ 2 ] ) revision++;
                                   else
                                     if ( array [ 4 ] ) revision = *( (ULONG *) array [ 4 ] );
                                if ( array [ 1 ] ) version++;
                                   else
                                     if ( array [ 3 ] ) version  = *( (ULONG *) array [ 3 ] );
                              }

                           if ( ! array [ 5 ] )
                              if ( ! array [ 6 ] ) MyFPrintf ( stdout, "New version : %ld.%ld\n", version, revision );

                           MyFPrintf ( file, " %ld.%ld ", version, revision );

                           DoDate ( file, UsaDate, NoCentury );

                           while ( *ptr != 0x22 && *ptr != 0x27 ) ptr++;

                           FWrite ( file, ptr, (ULONG) ( filesize - (ULONG) ( ptr - ptr1 ) ), 1 );

                           Close ( file );

                           if ( IoErr() ) PrintFault ( IoErr(), header );
                              else if ( ! array [ 5 ] ) FPuts ( stdout, "Done.\n" );
                         }
                    }
                  else FPuts ( stdout, "Error -: Malformed version string\n" );
               }
              else FPuts ( stdout, "Error -: no version string found\n" );
            FreeMem ( pointer, filesize );
           }
         FreeArgs ( cli_args );
       }
     else PrintFault ( IoErr(), header );
    exit ( IoErr() );
}
