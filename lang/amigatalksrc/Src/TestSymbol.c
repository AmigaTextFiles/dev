/****h* TestSymbol.c [1.6] ******************************************
* 
* NAME
*    TestSymbol.c
*
* DESCRIPTION
*    This file is for testing searching functions on the symbol file.
*
* NOTES
*    symbols are never deleted once created.
*
*    $VER: TestSymbol.c 1.6 (07-Mar-2001) by J.T. Steichen
*********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Constants.h" // SYMTABMAX et.al.
#include "object.h"
#include "FuncProtos.h"

PRIVATE UBYTE sf[256], *SymbolFile = &sf[0];

PRIVATE SYMBOL *x_tab[ SYMTABMAX ] = { 0, };

PRIVATE int x_tmax = 0;  // Number of entries in x_tab[] array.

/* ------------------------------------------------------------- */

// initial symbols free list:

PRIVATE SYMBOL SymSpace[ SYMINITSIZE ] = { 0, };

PRIVATE char  *SymbolStringSpace;

/* ------------------------------------------------------------- */

char *symbol_value( SYMBOL *symbol )
{
   return( symbol->value );
}

/****i* SeekFileSize() [1.6] *************************************
*
* NAME
*    SeekFileSize()
*
* DESCRIPTION
*    Measure how long the file is in bytes & newlines.
******************************************************************
*
*/

PRIVATE int SeekFileSize( FILE *fp, int *return_linecount )
{
   int rval = 0, ch = 0;

   while ((ch = fgetc( fp )) != EOF)   
      {
      if (ch == '\n')
         (*return_linecount)++;  // God I hate these binding rules of C!

      rval++;
      }

   rewind( fp ); // Rewind the file.

   return( rval );
}

/****i* MakeSymSpace() [1.6] *************************************
*
* NAME
*    MakeSymSpace()
*
* DESCRIPTION
*    Make the initial symbol space by reading in SymbolFile.
******************************************************************
*
*/


PRIVATE int MakeSymSpace( char *SymbolFile )
{
   SYMBOL *NewSymbol = NULL;
   FILE   *sfile     = fopen( SymbolFile, "r" );
   char   *symbol    = NULL, tbuffer[256];
   char   *newstring = NULL;
   UBYTE  *SFName    = NULL;
   int     filesize  = 0;
   int     numlines  = 0, i, j;
   
   if (sfile == NULL)
      {
      return( -1 );
      }
   
   filesize = SeekFileSize( sfile, &numlines );

   if (filesize == 0 || numlines == 0)
      {
      // Tell User that sfile is empty:
      fprintf( stderr, "%s is EMPTY!!", SymbolFile );

      fclose( sfile );
   
      return( -1 );
      }   

   symbol = (char *) AllocVec( filesize + 4 * numlines, // approx 4K 
                               MEMF_CLEAR | MEMF_FAST
                             );

   if (symbol == NULL)
      {
      // Tell User they need more memory:
      fprintf( stderr, "No memory for %d Allocation!", 
               filesize + 4 * numlines
             );

      fclose( sfile );
    
      return( -1 );
      }

   for (i = 0; i < SYMTABMAX; i++)
      {
      if ((NewSymbol = (SYMBOL *) 
                       AllocVec( sizeof( SYMBOL ), 
                                 MEMF_CLEAR | MEMF_FAST )) == NULL)
         {
         for (j = 0; j < i; j++)
            FreeVec( x_tab[j] );
            
         FreeVec( symbol );
         
         // Tell User they need more memory:
         fprintf( stderr, "No memory for %d Allocation!", 
                  SYMTABMAX * sizeof( SYMBOL )
                );

         fclose( sfile );

         return( -1 );
         }

      x_tab[ i ] = NewSymbol;  // Add another space to the x_tab[] list.
      }

   // Now, read in the strings in symbols file:

   newstring = FGetS( tbuffer, 255, sfile );
   i         = 0;
   x_tmax    = 0; // Comment out for V1.5-

   if (strncmp( newstring, "\\n", 2 ) == 0) // Handle special case.
      {
      symbol[0] = '\n';
      symbol[1] = '\0';
      
      x_tab[ x_tmax ]->ref_count = 0;
      x_tab[ x_tmax ]->size      = SYMBOLSIZE;
      x_tab[ x_tmax ]->value     = &symbol[ 0 ];

      i += 2;

      x_tmax++;
   
      newstring = FGetS( tbuffer, 255, sfile );
      }
      
   while ((newstring != NULL) && (x_tmax < SYMTABMAX))
      {
      strcpy( &symbol[ i ], newstring );

      x_tab[ x_tmax ]->ref_count = 0;
      x_tab[ x_tmax ]->size      = SYMBOLSIZE;
      x_tab[ x_tmax ]->value     = &symbol[ i ];

      i += (strlen( newstring ) + 1); // Account for the '\0' also!

      x_tmax++;                       // index to next x_tab[] entry.

      newstring = FGetS( tbuffer, 255, sfile );
      }

   fclose( sfile );

   return( 0 );
}

/****i* SymCompare() [1.6] *******************************************
*
* NAME
*    SymCompare()
*
* DESCRIPTION
*    compare two strings & return the result.
**********************************************************************
*
*/


PRIVATE int SymCompare( char *sym1, char *sym2 )
{
   int rval = 0;

   if (sym1 == sym2)
      return( rval ); // they're equal!
         
   rval = *sym1 - *sym2;             // Compare the 1st char's. 

   if (rval == 0) 
      rval = *(sym1 + 1) - *(sym2 + 1); // Compare the next two char's.

   if (rval == 0) 
      rval = strcmp( sym1, sym2 ); // Might be done, compare whole word.

   return( rval );
}

/****i* BinarySearch() ***********************************************
*
* NAME
*    BinarySearch()
*
* DESCRIPTION
*    Find the index in x_tab[] that corresponds to the given word,
*    using a binary search of this sorted table.  Note the side
*    effect of setting indexstore for later insertion information.
**********************************************************************
*
*/

PRIVATE int BinarySearch( char *word, int *indexstore )
{
   int hi, lo;
   
   lo = 0;
   hi = x_tmax;

   // Check for simple cases first:   

/* This code eats up a lot of time, eliminate it:

   if (strcmp( word, symbol_value( x_tab[lo] ) ) == 0)
      {
      *indexstore = lo;
      return( lo );
      }

   if (strcmp( word, symbol_value( x_tab[hi] ) ) == 0)
      {
      *indexstore = hi;
      return( hi );
      }
*/
   // Have to do the full search:

   while ((hi - lo) > 0)
      {
      int j, k;
      
      j = (hi + lo + 1) / 2;
      
      if ((hi - lo) == 1) // Pathological case:
         {
         if      (strcmp( word, symbol_value( x_tab[j + 1] )) == 0)
            {
            *indexstore = j + 1;
            return( j + 1 ); // Occasional return.
            }
         else if (strcmp( word, symbol_value( x_tab[j - 1] )) == 0)
            {
            *indexstore = j - 1;
            return( j - 1 );
            }
         else if (strcmp( word, symbol_value( x_tab[j    ] )) == 0)
            {
            *indexstore = j;
            return( j );
            }
         else
            {
            *indexstore = j; // The only (?) valid value for indexstore.
            return( -1 );    // Normal return path.
            }
         }
      
      // see if symbol is on a 2^n boundary:
      k = SymCompare( word, symbol_value( x_tab[j] ) );

      // Adjust the search end-point indices:

      if (k == 0)
         {
         *indexstore = j;

         return( j );      // Found the index!
         }
      else if (k < 0)
         hi = j;
      else
         lo = j;
      }

   // This code should never get executed:

   if (strcmp( word, symbol_value( x_tab[hi] ) ) == 0)
      {
      *indexstore = hi;
      return( hi );
      } 
   else
      {
      *indexstore = -1;
      return( -1 );
      }
}

/****h* sy_search() [1.6] ********************************************
*
* NAME
*    sy_search()
*
* DESCRIPTION
*    performs a binary search of a symbol, is the main interface to
*    the symbols routines, surrounded by the new_sym() MACRO in 
*    Symbol.h.  The symbol array x_tab[] is NOT a power of 2 size,
*    so some problems have been encountered when searching for the
*    index of 256 (pTempVar).  So instead of setting i = x_tmax;,
*    we set it to i = i - j, i += (x_tmax - i) / 2;.
*
* HISTORY
*    28-Feb-2001 - Replaced the innards of this function with 
*                  BinarySearch().
*
* NOTES
*    Only one copy of symbol values are kept.
*    Multiple copies of the same symbol point to the same location.
*    sy_search will find, and if necessary insert, a string into
*    this common table.
**********************************************************************
*
*/

PRIVATE SYMBOL *sy_searchbin( char *word, int insert )
{
   register int  i        = 0;
   int           insertpt = 0;

   if ((i = BinarySearch( word, &insertpt )) >= 0)
      return( x_tab[i] );
   else
      return( insertpt );
}

/****h* sy_search() [1.6] ********************************************
*
* NAME
*    sy_search()
*
* DESCRIPTION
*    performs a binary search of a symbol, is the main interface to
*    the symbols routines, surrounded by the new_sym() MACRO in 
*    Symbol.h.  The symbol array x_tab[] is NOT a power of 2 size,
*    so some problems have been encountered when searching for the
*    index of 256 (pTempVar).  So instead of setting i = x_tmax;,
*    we set it to i = i - j, i += (x_tmax - i) / 2;.
*
* HISTORY
*    28-Feb-2001 - Replaced the innards of this function with 
*                  BinarySearch().
*
* NOTES
*    Only one copy of symbol values are kept.
*    Multiple copies of the same symbol point to the same location.
*    sy_search will find, and if necessary insert, a string into
*    this common table.
**********************************************************************
*
*/

PRIVATE SYMBOL *sy_search( char *word, int insert )
{
   register int i, j, k = 0;
   char         *p = NULL;
   BOOL          UseTMax = FALSE;

   // find the maximum 2^n for i that's <= x_tmax
   for (i = 1; i <= x_tmax; i <<= 1)
      ;

   // j is half of i (the midpoint of the search array):
   for (i >>= 1, j = i >> 1, i--; ; j >>= 1) 
      {

      if (x_tab[i] != NULL)            // Added to prevent Enforcer hits.
         p = symbol_value( x_tab[i] );
      else
         p = symbol_value( x_tab[0] ); // is this necessary?? 

      if (p == NULL)      // Should NEVER happen! 
         goto skipChecks; // Added to prevent Enforcer hits.

      if (word == p) 
         return( x_tab[i] );         // Entry was on a 2^n boundary!

      if ((k = SymCompare( word, p )) == 0)
         return( x_tab[i] );    // Yep, we found the entry.

skipChecks:

      if ((j == 0) || ((i == x_tmax) && (p == NULL))) 
         break;       // No entry was found!

      // Adjust the index i to point either up a half or down a half: 

      if (k < 0) 
         {
         if (UseTMax == FALSE)
            i -= j; // We're looking for an entry below where we're at.
         else
            {
            i -= ((x_tmax - i) / 2);
            UseTMax = FALSE;
            }
         }
      else 
         {
         if ((i += j) > x_tmax) 
            {
            // i = i - j + 1; // Don't go beyond the x_tab[] array!
            // i = i - j + 1 works, but we're going to try the following,
            // which will keep the search binary:

            i      -= j;
            i      += (x_tmax - i) / 2;
            UseTMax = TRUE;
            }
         else
            UseTMax = FALSE;
         }
      }

   // Straight linear search code: --------------------------------

   if (insert == FALSE)
      {
      fprintf( stderr, "performed a straight linear search on %s\n",
               word 
             );
      
      for (i = x_tmax; i >= 0; i--) // Do a straight linear search:
         {
         p = symbol_value( x_tab[i] );

         if (*word == *p)
            {
            if (strcmp( word, p ) == 0)
               return( x_tab[i] );
            }
         }
      }
   else
      return( NULL );
}

PUBLIC int main( int argc, char **argv )
{
   if (argc != 2)
      {
      fprintf( stderr, "Usage: %s <symbolfile>\n", argv[0] );
      return( RETURN_ERROR );
      }

   if (MakeSymSpace( argv[1] ) < 0)
      {
      return( RETURN_FAIL ); // Errors were already explained!!
      }

   fprintf( stderr, "Profiling sy_search()...\n" );

   // Now, do a bunch of searches using the same strings on the two
   // functions:

   (void) sy_searchbin( "<=", FALSE );   
   (void) sy_searchbin( "==", FALSE );   
   (void) sy_searchbin( ">=", FALSE );   
   (void) sy_searchbin( "@" , FALSE );
   (void) sy_searchbin( "AbsJoyStick", FALSE );   
   (void) sy_searchbin( "AmigaTalk", FALSE );   
   (void) sy_searchbin( "Object", FALSE );
   (void) sy_searchbin( "OrderedCollection", FALSE );   
   (void) sy_searchbin( "Painter", FALSE );   
   (void) sy_searchbin( "ParallelDevice", FALSE );   
   (void) sy_searchbin( "Pen", FALSE );   
   (void) sy_searchbin( "Point", FALSE );   
   (void) sy_searchbin( "Process", FALSE );   
   (void) sy_searchbin( "PropGadget", FALSE );   
   (void) sy_searchbin( "SUSPENDED", FALSE );   
   (void) sy_searchbin( "Set", FALSE );   
   (void) sy_searchbin( "SmallInt", FALSE );   
   (void) sy_searchbin( "String", FALSE );   
   (void) sy_searchbin( "Symbol", FALSE );   
   (void) sy_searchbin( "x:", FALSE );   
   (void) sy_searchbin( "x:y:", FALSE );   
   (void) sy_searchbin( "xvalue", FALSE );   
   (void) sy_searchbin( "y:", FALSE );   
   (void) sy_searchbin( "yOffset", FALSE );   
   (void) sy_searchbin( "yScale", FALSE );   
   (void) sy_searchbin( "ySize", FALSE );   
   (void) sy_searchbin( "yesNoReq:title:", FALSE );   
   (void) sy_searchbin( "yield", FALSE );   
   (void) sy_searchbin( "yourself", FALSE );   
   (void) sy_searchbin( "yvalue", FALSE );   
   (void) sy_searchbin( "|", FALSE );   
   (void) sy_searchbin( "~", FALSE );   
   (void) sy_searchbin( "~=", FALSE );   
   (void) sy_searchbin( "~~", FALSE );   


   // Now for the fast function:
   (void) sy_search( "<=", FALSE );   
   (void) sy_search( "==", FALSE );   
   (void) sy_search( ">=", FALSE );   
   (void) sy_search( "@" , FALSE );
   (void) sy_search( "AbsJoyStick", FALSE );   
   (void) sy_search( "AmigaTalk", FALSE );   
   (void) sy_search( "Object", FALSE );
   (void) sy_search( "OrderedCollection", FALSE );   
   (void) sy_search( "Painter", FALSE );   
   (void) sy_search( "ParallelDevice", FALSE );   
   (void) sy_search( "Pen", FALSE );   
   (void) sy_search( "Point", FALSE );   
   (void) sy_search( "Process", FALSE );   
   (void) sy_search( "PropGadget", FALSE );   
   (void) sy_search( "SUSPENDED", FALSE );   
   (void) sy_search( "Set", FALSE );   
   (void) sy_search( "SmallInt", FALSE );   
   (void) sy_search( "String", FALSE );   
   (void) sy_search( "Symbol", FALSE );   
   (void) sy_search( "x:", FALSE );   
   (void) sy_search( "x:y:", FALSE );   
   (void) sy_search( "xvalue", FALSE );   
   (void) sy_search( "y:", FALSE );   
   (void) sy_search( "yOffset", FALSE );   
   (void) sy_search( "yScale", FALSE );   
   (void) sy_search( "ySize", FALSE );   
   (void) sy_search( "yesNoReq:title:", FALSE );   
   (void) sy_search( "yield", FALSE );   
   (void) sy_search( "yourself", FALSE );   
   (void) sy_search( "yvalue", FALSE );   
   (void) sy_search( "|", FALSE );   
   (void) sy_search( "~", FALSE );   
   (void) sy_search( "~=", FALSE );   
   (void) sy_search( "~~", FALSE );   

   return( RETURN_OK );
}

/* ------------------- End of TestSymbol.c file. ---------------------- */
