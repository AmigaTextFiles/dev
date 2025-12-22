/****h* AmigaTalk/File.c [3.0] **************************************
*
* NAME
*    File.c
*
* DESCRIPTION
*    For Little Smalltalk system.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
*    23-Apr-2000
*
* NOTES
*    $VER: File.c 3.0 (25-Oct-2004) by J.T. Steichen    
*********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "ATStructs.h"

#include "object.h"
#include "file.h"
#include "FuncProtos.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT int    started;

IMPORT UBYTE *ErrMsg;

PRIVATE AT_FILE *lastAllocdFile = NULL;
PRIVATE AT_FILE *fileList       = NULL;
 
// ---------------------------------------------------------

PUBLIC void freeVecAllFiles( void )
{
   AT_FILE *p        = fileList;
   AT_FILE *next     = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      if (p->fp) // != NULL)
         fclose( p->fp ); // Close all files first!
      
      AT_free( p, "AT_FILE", TRUE );
      
      p = next;
      }
      
   return;
}

SUBFUNC void storeFile( AT_FILE *newF, AT_FILE **last )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last    = newF;
      fileList = newF;
      }
   else
      {
      (*last)->nextLink = newF;
      }

   newF->nextLink = NULL;

   *last = newF; // Update the end of the List.
   
   return;       
}

PRIVATE AT_FILE *findFreeFile( void )
{
   AT_FILE *p = fileList;

   if (!p) // == NULL)
      return( NULL );
         
   for ( ; p != NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         return( p );
         }
      }
   
   return( NULL );
}

SUBFUNC AT_FILE *allocFile( void )
{
   AT_FILE *fp = (AT_FILE *) AT_calloc( 1, FILE_SIZE, "AT_FILE", TRUE );
   
   if (!fp) // == NULL)
      {
      MemoryOut( "allocFile()" );
      
      fprintf( stderr, "Ran out of memory in allocFile()!\n" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached
      }
      
   return( fp );
}
     
/****h* new_file() *****************************************
*
* NAME
*    new_file()
*
* DESCRIPTION
*    Return a new pointer to a file OBJECT or Allocate one.
************************************************************
*
*/

PUBLIC OBJECT *new_file( void )
{
   AT_FILE *New = (AT_FILE *) NULL;
   
   if (fileList && (started == TRUE))
      {
      if (!(New = findFreeFile())) // != NULL)
         goto setupNewFile;
      }

   New = allocFile();

setupNewFile:

   New->size      = MMF_INUSE_MASK | MMF_FILE | FILE_SIZE;

   New->ref_count = 0;

   New->file_mode = STRMODE;
   New->fp        = 0; // NULL;
   New->nextLink  = 0; // NULL;
   
   storeFile( New, &lastAllocdFile );
   
   return( (OBJECT *) New );
}

SUBFUNC void recycleFile( AT_FILE *killMe )
{
   AT_FILE *upper = fileList;
   
   if (killMe == upper)               // first item in list?
      {
      upper->size &= ~MMF_INUSE_MASK; // Clear INUSE bit.
      
      return;
      }
      
   while (upper != killMe)
      upper = upper->nextLink;     // find the item in the list.

   upper->size &= ~MMF_INUSE_MASK; // Clear INUSE bit.
   
   return;
}

/****h* free_file() ****************************************
*
* NAME
*    free_file()
*
* DESCRIPTION
*    Close a type2 file.
************************************************************
*
*/

PUBLIC void free_file( AT_FILE *phil )
{
   if (is_file( (OBJECT *) phil ) == FALSE)
      cant_happen( WRONGOBJECT_FREED );          // Die, you abomination!!

   if (phil->fp) // != NULL)
      fclose( phil->fp );

   recycleFile( phil );
   
   return;
}

/****h* file_err() *****************************************
*
* NAME
*    file_err()
*
* DESCRIPTION
*    Print an error message about a file.
************************************************************
*
*/

PUBLIC void file_err( char *msg )
{
   OBJECT *errp = NULL;
   
   sprintf( ErrMsg, FileCMsg( MSG_FMT_F_FILE ), msg );

   errp = AssignObj( new_str( ErrMsg ) );

   (void) primitive( ERRPRINT, 1, &errp );

   (void) obj_dec( errp ); // Mark errp for deletion.

   return;
}

/****h* file_open() ****************************************
*
* NAME
*    file_open()
*
* DESCRIPTION
*    Open a type2 file.
************************************************************
*
*/

PUBLIC void file_open( AT_FILE *phil, char *name, char *type )
{
   char   buffer[ 256 ] = { 0, };

   if (phil->fp) // != NULL)
      fclose( phil->fp );

   phil->fp = fopen( name, type );

   if (!phil->fp) // == NULL)   
      {
      sprintf( buffer, FileCMsg( MSG_FMT_F_UNOPENED_FILE ), name );

      file_err( buffer );
      }

   return;
}

/****h* getw() *********************************************
*
* NAME
*    getw()
*
* DESCRIPTION
*    Retrieve a WORD (short int) from a file.
************************************************************
*
*/

PUBLIC int getw( FILE *fp )
{
   int   rval = 0, ch = 0;
   
   if ((EOF == (ch = fgetc( fp ))))
      return( rval );

   rval = ch << 8;

   if ((EOF == (ch = fgetc( fp ))))
      return( rval );

   rval += ch;

   return( rval );
}

/****h* file_read() ****************************************
*
* NAME
*    file_read()
*
* DESCRIPTION
*    Get some input from a type2 file.
************************************************************
*
*/

PUBLIC OBJECT *file_read( AT_FILE *phil )
{
   OBJECT *New = (OBJECT *) NULL;
   int    c;
   char   buffer[ BUFLENGTH ] = { 0, }, *p = NULL;

   if (!phil->fp) // == NULL)   
      {
      file_err( FileCMsg( MSG_F_BAD_READ_FILE ) );

      return( o_nil );
      }

   switch (phil->file_mode)   
      {
      case CHARMODE:
         if (EOF == (c = fgetc( phil->fp )))
            New = o_nil;
         else
            New = new_char( c );

         break;
      
      case STRMODE:
         if (!fgets( buffer, BUFLENGTH, phil->fp )) // == NULL)
            New = o_nil;
         else   
            {
            p = &buffer[ StringLength( buffer ) - 1 ];

            if (*p == NEWLINE_CHAR)      
               *p = NIL_CHAR;

            New = new_str( buffer );
            }

         break;

      case INTMODE:
         if (EOF == (c = getw( phil->fp )))
            New = o_nil;
         else
            New = new_int( c );

         break;

       default:
         file_err( FileCMsg( MSG_F_UNK_MODE_FILE ) );

         New = o_nil;
      }

   return( New );
}

/****h* putw() *********************************************
*
* NAME
*    putw()
*
* DESCRIPTION
*    Send a WORD (short int) to a file.
************************************************************
*
*/

PUBLIC void putw( int val, FILE *fp )
{
   int ch1 = 0, ch2 = 0;

   ch2 = val && 0xFF;
   ch1 = (val - ch2) >> 8; // was ch1 = val - ch2;

   fputc( ch1, fp );
   fputc( ch2, fp );

   return;
}

/****h* file_write() ***************************************
*
* NAME
*    file_write()
*
* DESCRIPTION
*    Write to a type2 file.
************************************************************
*
*/

PUBLIC void file_write( AT_FILE *phil, OBJECT *obj )
{
   if (!phil->fp) // == NULL)   
      {
      file_err( FileCMsg( MSG_F_BAD_WRITE_FILE ) );

      return;
      }
      
   switch (phil->file_mode)   
      {
      case CHARMODE:
         if (is_character( obj ) == FALSE)      
            goto modeerr;

         fputc( int_value( obj ), phil->fp );

         break;
      
      case STRMODE:
         if (is_string( obj ) == FALSE)         
            goto modeerr;

         fputs( string_value( (STRING *) obj ), phil->fp );
         fputc( NEWLINE_CHAR, phil->fp );

         break;
      
      case INTMODE:
         if (is_integer( obj ) == FALSE)      
            goto modeerr;

         putw( int_value( obj ), phil->fp );

         break;
       
      default:
         file_err( FileCMsg( MSG_F_UNK_WMODE_FILE ) );

         return;
      }

   return;

modeerr:

   file_err( FileCMsg( MSG_F_BAD_ATTEMPT_FILE ) );

   return;
}

/* ------------------ END of File.c file! ---------------------- */
