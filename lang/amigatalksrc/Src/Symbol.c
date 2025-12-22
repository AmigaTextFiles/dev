/****h* AmigaTalk/Symbol.c [3.0] ************************************
* 
* NAME
*    Symbol.c
*
* DESCRIPTION
*    symbol creation
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
*    28-Mar-2002 - Added HandleMiscSymbolOps() <90>.
*
*    28-Feb-2001 - Added BinarySearch() & WriteSymbolFile() to
*                  this file.
*    19-Feb-2001 - Using new SymbolFile code.
*    21-Feb-2000 - sym_init() has been expanded to setup the 
*                  x_tab[] array.
*    20-Feb-2000 - Changed new_sym() from a macro to a function!
*
* NOTES
*    symbols are never deleted once created.
*
*    $VER: AmigaTalk:Src/Symbol.c 3.0 (25-Oct-2004) by J.T. Steichen
*********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include <libraries/asl.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Constants.h" // SYMTABMAX et.al.

#include "StringConstants.h"
#include "StringIndexes.h"

#include "object.h"

#include "CantHappen.h"

#include "FuncProtos.h"

IMPORT ULONG SymbolTableSize; // ToolType in Tools.c

IMPORT UBYTE SymbolFile[ LARGE_TOOLSPACE ];

IMPORT UBYTE *ErrMsg;
IMPORT UBYTE *FATAL_USER_ERROR;
IMPORT UBYTE *AllocProblem;

PUBLIC SYMBOL *x_tab[ SYMTABMAX ] = { 0, };

PUBLIC int x_tmax = 0;  // Number of entries in x_tab[] array.

/* ------------------------------------------------------------- */

IMPORT  int      ca_sym;            // symbol allocation counter
IMPORT  int      ca_symSpace;

PRIVATE MSTRUCT *fr_symbol = NULL;  // symbols free list

// initial symbols free list:

PRIVATE SYMBOL SymSpace[ SYMINITSIZE ] = { 0, };

IMPORT OBJECT *o_nil, *o_true, *o_false;
IMPORT OBJECT *o_object;                 // common instance of Object
IMPORT CLASS  *ArrayedCollection;

//           defined in Global.c:

IMPORT char *SymbolStringSpace;

/* ------------------------------------------------------------- */

/****h* freeTheSymbols() [3.0] ************************************
*
* NAME
*    freeTheSymbols()
*
* DESCRIPTION
*    Called from SmallTalk(), free the symbol spaces.
*******************************************************************
*
*/

PUBLIC void freeTheSymbols( void )
{
   if (x_tab) // != NULL)
      {
      int i = 0;
      
      while (x_tab[i] && i < SYMTABMAX)
         free( x_tab[i++] ); // FreeVec( x_tab[i++] );
      }

   if (SymbolStringSpace) // != NULL)
      {
      AT_free( SymbolStringSpace, "SymbolSpace", TRUE );

      SymbolStringSpace = NULL;
      }

   return;
}


/****i* GetSymbolFileName() [1.6] ********************************
*
* NAME
*    GetSymbolFileName()
*
* DESCRIPTION
*    There was a problem locating SymbolFile, get a new filename.
******************************************************************
*
*/

PRIVATE UBYTE sfn[512] = { 0, }, *SymbolFileName = &sfn[0]; // Temp Filename space

PRIVATE UBYTE *GetSymbolFileName( void )
{
   IMPORT struct TagItem LoadTags[];
   IMPORT struct Window  *ATWnd;

   char *title = SymCMsg( MSG_GET_SYMBOL_FILE_SYMBOL ); 

#  ifdef __SASC
   SetTagItem( &LoadTags[0], ASLFR_TitleText, (ULONG) title );
   SetTagItem( &LoadTags[0], ASLFR_Window,    (ULONG) ATWnd );
   SetTagItem( &LoadTags[0], ASLFR_InitialDrawer,
                             (ULONG) "AmigaTalk:prelude/listFiles"
             );
#  else
   OS4SetTagItem( &LoadTags[0], ASLFR_TitleText, (ULONG) title );
   OS4SetTagItem( &LoadTags[0], ASLFR_Window,    (ULONG) ATWnd );
   OS4SetTagItem( &LoadTags[0], ASLFR_InitialDrawer,
                                (ULONG) "AmigaTalk:prelude/listFiles"
                );
#  endif

   if (FileReq( SymbolFileName, &LoadTags[0] ) > 1)
      {
      return( SymbolFileName );
      }
   else
      return( NULL ); // They were given every chance!!
}

/****h* SeekFileSize() [1.6] *************************************
*
* NAME
*    SeekFileSize()
*
* DESCRIPTION
*    Measure how long the file is in bytes & newlines.
*    Also used in SDict.c file
******************************************************************
*
*/

PUBLIC int SeekFileSize( FILE *fp, int *return_linecount )
{
   int rval = 0, ch = 0;

   while ((ch = fgetc( fp )) != EOF)   
      {
      if (ch == NEWLINE_CHAR)
         (*return_linecount)++;  // God I hate these binding rules of C!

      rval++;
      }

   rewind( fp ); // Rewind the file.

   return( rval );
}

/****h* WriteSymbolFile() [1.6] **********************************
*
* NAME
*    WriteSymbolFile()
*
* DESCRIPTION
*    Write all currently known symbols to the SymbolFile before
*    the program terminates, so that we won't have to do so
*    many insertions into the symbol table, which slows the 
*    loading of the program considerably.
******************************************************************
*
*/

PUBLIC int WriteSymbolFile( void )
{
   int   rval    = -1, i, start;
   FILE *outfile = fopen( &SymbolFile[0], "w" );

   if (!outfile) // == NULL)
      goto exitWriteSymbolFile;

   if (StringNComp( symbol_value( x_tab[0] ), NEWLINE_STR, 1 ) == 0)
      {
      fputs( "\\n\n", outfile ); // Write special case newline symbol.
      start = 1;
      }
   else
      start = 0;
              
   for (i = start; i < x_tmax; i++)
      {
      fputs( symbol_value( x_tab[i] ), outfile );
      fputc( NEWLINE_CHAR, outfile ); // fputs() does not do this.
      }

   fclose( outfile );

   rval = 0;          // Success!

exitWriteSymbolFile:

   return( rval );   
}

SUBFUNC int allocSymbolSpace( int numSymbols, int filesize )
{
   SYMBOL *NewSymbol = NULL;
   char   *symbol    = NULL;

   int     i, j, rval = RETURN_OK;
   
   ca_symSpace = filesize + 4 * numSymbols;
   ca_sym      = numSymbols;

   // Set to minimum requirement:
   ca_symSpace = ca_symSpace < MIN_CLSTABLE_SIZE ? MIN_CLSTABLE_SIZE : ca_symSpace;
      
   symbol = (char *) AT_calloc( 1, ca_symSpace * sizeof( UBYTE ), "SymbolSpace", TRUE );

   if (!symbol) // == NULL)
      {
      // Tell User they need more memory:
      sprintf( ErrMsg, SymCMsg( MSG_NO_MEMORY_ALLOC_SYMBOL ), ca_symSpace );

      UserInfo( ErrMsg, AllocProblem );

      ca_symSpace = 0;
      
      rval = ERROR_NO_FREE_STORE;
      
      goto exitAllocSymbolSpace;    
      }

   for (i = 0; i < SYMTABMAX; i++)
      {
      if (!(NewSymbol = (SYMBOL *) AT_calloc( 1, SYMBOL_SIZE, "Symbol", FALSE ))) // == NULL) 
         {
         for (j = 0; j < i; j++)
            AT_free( x_tab[j], "Symbol", FALSE ); // FreeVec();
            
         AT_free( symbol, "SymbolSpace", TRUE ); // FreeVec( symbol );
         
         // Tell User they need more memory:
         sprintf( ErrMsg, SymCMsg( MSG_NO_MEMORY_ALLOC_SYMBOL ), 
                          SYMTABMAX * SYMBOL_SIZE
                );

         UserInfo( ErrMsg, AllocProblem );
         
         rval = ERROR_NO_FREE_STORE;
      
         goto exitAllocSymbolSpace;    
         }

      x_tab[ i ] = NewSymbol;  // Add another space to the x_tab[] list.
      }

   SymbolStringSpace = symbol; // for FreeVec() in SmallTalk() in main.c

exitAllocSymbolSpace:
   
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

PRIVATE int MakeSymSpace( void )
{
   FILE   *sfile     = fopen( &SymbolFile[0], "r" );
   char   *symbol    = NULL, tbuffer[256] = { 0, };
   char   *newstring = NULL;
   UBYTE  *SFName    = NULL;
   int     filesize  = 0;
   int     numlines  = 0, i;
   
   if (!sfile) // == NULL)
      {
      if (!(SFName = GetSymbolFileName())) // == NULL)
         return( -1 );

      StringNCopy( &SymbolFile[0], SFName, LARGE_TOOLSPACE );

      sfile = fopen( &SymbolFile[0], "r" );
      }
   
   filesize = SeekFileSize( sfile, &numlines );

   if (filesize == 0 || numlines == 0)
      {
      // Tell User that sfile is empty:
      sprintf( ErrMsg, SymCMsg( MSG_FILE_IS_EMPTY_SYMBOL ), &SymbolFile[0] );

      UserInfo( ErrMsg, FATAL_USER_ERROR );

      fclose( sfile );
   
      return( -1 );
      }   

   if (allocSymbolSpace( numlines, filesize ) != RETURN_OK)
      {
      fclose( sfile );

      return( -1 );
      }
   else
      symbol = SymbolStringSpace;
      
   // Now, read in the strings in symbols file:

   newstring = FGetS( tbuffer, 255, sfile );
   i         = 0;
   x_tmax    = 0; // Comment out for V1.5-

   if (StringNComp( newstring, "\\n", 2 ) == 0) // Handle special case.
      {
      symbol[0] = NEWLINE_CHAR;
      symbol[1] = NIL_CHAR;
      
      x_tab[ x_tmax ]->ref_count = 20;
      x_tab[ x_tmax ]->size      = MMF_INUSE_MASK | MMF_SYMBOL | SYMBOL_SIZE; // SYMBOLSIZE;
      x_tab[ x_tmax ]->value     = &symbol[ 0 ];

      i += 2;

      x_tmax++;
   
      newstring = FGetS( tbuffer, 255, sfile );
      }
      
   while (newstring && (x_tmax < SYMTABMAX))
      {
      StringCopy( &symbol[ i ], newstring );

      x_tab[ x_tmax ]->ref_count = 20;
      x_tab[ x_tmax ]->size      = MMF_INUSE_MASK | MMF_SYMBOL | SYMBOL_SIZE; // SYMBOLSIZE;
      x_tab[ x_tmax ]->value     = &symbol[ i ];

      i += (StringLength( newstring ) + 1); // Account for the '\0' also!

      x_tmax++;                       // index to next x_tab[] entry.

      newstring = FGetS( tbuffer, 255, sfile );
      }

   fclose( sfile );

   return( 0 );
}

/****h* sym_init() [1.6] *********************************************
*
* NAME
*    sym_init()
*
* DESCRIPTION
*    Initialize the symbols space, by linking symbol pointers
*    together to form a list of symbols.
**********************************************************************
*
*/

PUBLIC int sym_init( void ) 
{
   if (MakeSymSpace() < 0)
      {
      return( -1 ); // Errors were already explained!!
      }
   else
      return( 0 );
}

SUBFUNC SYMBOL *allocSymbol( void )
{
   SYMBOL *rval = (SYMBOL *) AT_calloc( 1, SYMBOL_SIZE, "Symbol", FALSE );
   
   if (!rval) // == NULL)
      {
      MemoryOut( "allocSymbol()" );
      
      fprintf( stderr, "Ran out of memory in allocSymbol()!\n" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached.
      }
      
   return( rval );
}

/****i* NewSym() [1.6] ************************************************
*
* NAME
*    NewSym()
*
* DESCRIPTION
*    The PRIVATE internal routine for making new symbols
**********************************************************************
*
*/

PRIVATE SYMBOL *NewSym( char *text )
{
   SYMBOL *New = allocSymbol();

   ca_sym++;
   
   New->ref_count = 1;
   New->size      = MMF_INUSE_MASK | MMF_SYMBOL | SYMBOL_SIZE; // SYMBOLSIZE;
   New->value     = text;

   return( New );
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
      return( rval );                   // They're equal!
         
   rval = *sym1 - *sym2;                // Compare the 1st char's. 

   if (rval == 0) 
      rval = *(sym1 + 1) - *(sym2 + 1); // Compare the next two char's.

   if (rval == 0) 
      rval = StringComp( sym1, sym2 ); // Might be done, compare whole word.

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
*
* HISTORY
*    07-Mar-2001 - Removed the code that was eating up the most
*                  time.  Apparently, it's quicker to search for the
*                  endpoints than to make special checks for them.
**********************************************************************
*
*/

PRIVATE int BinarySearch( char *word, int *indexstore )
{
   int hi, lo;
   
   lo = 0;
   hi = x_tmax;

   // Have to do the full search:

   while ((hi - lo) > 0)
      {
      int j, k;
      
      j = (hi + lo + 1) / 2;
      
      if ((hi - lo) == 1) // Pathological case:
         {
         if      (StringComp( word, symbol_value( x_tab[j + 1] )) == 0)
            {
            *indexstore = j + 1;
            return( j + 1 ); // Occasional return.
            }
         else if (StringComp( word, symbol_value( x_tab[j - 1] )) == 0)
            {
            *indexstore = j - 1;
            return( j - 1 );
            }
         else if (StringComp( word, symbol_value( x_tab[j    ] )) == 0)
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

   if (StringComp( word, symbol_value( x_tab[hi] ) ) == 0)
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

PUBLIC SYMBOL *sy_search( char *word, int insert )
{
   register int  i        = -1;
   int           insertpt = 0;

   if ((i = BinarySearch( word, &insertpt )) >= 0)
      return( x_tab[i] );

   if (insert != FALSE) // Well, then insert a new Symbol:
      {
      if (insertpt > 1) 
         i = insertpt;
      else if (insertpt > 0)
         i = 0;

      // NOTE that x_tmax gets incremented here:

      if ((insertpt = ++x_tmax) >= SYMTABMAX)
         cant_happen( NO_SYMBOL_SPACE );  // Die, you abomination!!
         
      for ( ; insertpt > i; insertpt--) 
         {
         // We have to make a space by moving the elements down one:
         x_tab[insertpt] = x_tab[ insertpt - 1 ];
         }

#     ifdef DEBUG      
      fprintf( stderr, SymCMsg( MSG_ADDING_STR_SYMBOL ), word );
#     endif

      x_tab[i] = NewSym( walloc( word, strlen( word ) + 1 ) ); // walloc() in String.c

      x_tab[i]->ref_count += 20; // make sure its not freed

      return( x_tab[i] );
      }
   else 
      return( NULL ); // Error condition!!
}

/****h* new_sym() [1.6] **********************************************
*
* NAME
*    new_sym()
*
* DESCRIPTION
*    Insert the a new symbol into the symbol table.
*
* NOTES
*    This used to be a macro (Aaarrgghh!!).
**********************************************************************
*
*/

PUBLIC SYMBOL *new_sym( char *symbol_string )
{
   return( sy_search( symbol_string, TRUE ) ); // TRUE = Insert into table.
}


/****h* w_search() [1.6] *********************************************
*
* NAME
*    w_search()
*
* DESCRIPTION
*    Perform a search for a word, not a symbol.  We search the 
*    symbol table for an entry that matches 'word', then return a
*    (char *) string.
**********************************************************************
*
*/

PUBLIC char *w_search( char *word, int insert )
{
   SYMBOL *sym = sy_search( word, insert );

   if (sym) // != NULL)
      return( symbol_value( sym ) );
   else
      return( (char *) NULL );
}

// Called only by countNumArgs():

SUBFUNC int checkForBinaryOp( char *str )
{
   int rval = 0;
   
   switch (*str)
      {
      case COMMA_CHAR:
      case TILDE_CHAR:
      case PLUS_CHAR:
      case MINUS_CHAR:
      case STAR_CHAR:
      case GREAT_CHAR:
      case LESS_CHAR:
      case EQUAL_CHAR:
      case CARET_CHAR:
      case AT_CHAR:
      case SLASH_CHAR:

         rval = 2;
         break;
         
      case AMP_CHAR:
      case BAR_CHAR:
         rval = 1;
         break;
         
      default:
         break;
      }

   return( rval );
      
}

/****i* countNumArgs() [2.1] ***************************************
*
* NAME
*    countNumArgs()
*
* DESCRIPTION
*    The number of arguments a Symbol describes can be found by
*    simply counting the number of colons in the Symbol.
*    ^ <primitive 90 0 aSymbol>
********************************************************************
*
*/

METHODFUNC OBJECT *countNumArgs( OBJECT *symObj )
{
   char *symStr = symbol_value( (SYMBOL *) symObj );
   int   len    = 0, count = 0, i;

   len = StringLength( symStr );
   
   if ((len == 1) || (len == 2))
      count = checkForBinaryOp( symStr );
   else
      {   
      for (i = 0; i < len; i++)
         {
         if (*(symStr + i) == COLON_CHAR)
            count++;
         }
      }

   return( new_int( count ) ); // ( count + 1 ) ); ????
}

/****h* HandleMiscSymbolOps() [2.1] ********************************
*
* NAME
*    HandleMiscSymbolOps()
* 
* DESCRIPTION
*    Handle more Symbol primitive operations
*    ^ <primitive 90 xx yy args>
********************************************************************
*
*/

PUBLIC OBJECT *HandleMiscSymbolOps( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 90 );
      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // numArgs
              // ^ <90 0 aSymbol>
         if (is_symbol( args[1] ) == FALSE)
            (void) PrintArgTypeError( 90 );
         else
            rval = countNumArgs( args[1] );
               
         break;

         
      default:
         (void) PrintArgTypeError( 90 );

         break;
      }

   return( rval );
}

/* -------------- End of Symbol.c file. ---------------------------- */
