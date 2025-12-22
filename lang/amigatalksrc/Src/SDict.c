/****h* AmigaTalk/SDict.c [3.0] *************************************
* 
* NAME
*    SDict.c
*
* DESCRIPTION
*    SystemDictionary primitive interface <206 0-5> for the
*    SystemDictionary Class in General/SystemDictionary.st
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    14-Nov-2003 - Created this file from Symbol.c
*
* NOTES
*
*    $VER: AmigaTalk:Src/SDict.c 3.0 (25-Oct-2004) by J.T. Steichen
*********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "object.h"

#include "CantHappen.h"

#include "FuncProtos.h"

#define  MMF_SYSDICT MMF_RESERVED1

// -------------------------------------------------------------------

IMPORT UBYTE  *ErrMsg;
IMPORT UBYTE  *FATAL_USER_ERROR;
IMPORT UBYTE  *AllocProblem;
IMPORT OBJECT *o_nil;

// -------------------------------------------------------------------

/****i* readInElement() [3.0] ****************************************
*
* NAME
*    readInElement()
*
* DESCRIPTION
*    Retrieve an input line from a SystemDictionary file.
*    Each entry is as follows:   Symbol_String @ Integer
**********************************************************************
*
*/

UBYTE ele[256] = { 0, }, *line = &ele[0];

SUBFUNC UBYTE *readInElement( FILE *fp )
{
   *line = '\0';

   fgets( line, 256, fp );
   
   if (StringLength( line ) < 1)
      {
      // Should flag this error condition:
      
      return( NULL );
      }
      
   return( line );
}

/****i* getKeyString() [3.0] *****************************************
*
* NAME
*    getKeyString()
*
* DESCRIPTION
*    Retrieve a key from an input line.
*    Each entry is as follows:   Symbol_String @ Integer
**********************************************************************
*
*/

PRIVATE UBYTE kv[256] = { 0, }, *keyValue = &kv[0];

SUBFUNC UBYTE *getKeyString( UBYTE *inputLine )
{
   int i;
   
   for (i = 0; i < 256; i++)
      *(keyValue + i) = '\0'; // Make sure buffer is clean for passes > 1
   
   i = 0;
   
   while (i < 256 && *(inputLine + i) != ' ' 
                  && *(inputLine + i) != '\t'
                  && *(inputLine + i) != '@' )
      {
      *(keyValue + i) = *(inputLine + i);
      
      i++;
      }

   return( keyValue );
}

/****i* getValue() [3.0] *********************************************
*
* NAME
*    getValue()
*
* DESCRIPTION
*    Retrieve the value associated with a key from an input line.
*    Each entry is as follows:   Symbol_String @ Integer
**********************************************************************
*
*/

SUBFUNC int getValue( UBYTE *inputLine )
{
   int i    = 0;
   int rval = 0L;
   
   while (   *(inputLine + i) != ' ' 
          && *(inputLine + i) != '\t'
          && *(inputLine + i) != '@')
      {
      i++; // Skip over to delimiters.
      }

   while (  *(inputLine + i) == ' ' 
         || *(inputLine + i) == '@'
         || *(inputLine + i) == '\t')
      {
      i++;  // Skip over to the value associated with the key.
      }

   if (*(inputLine + i) == '0' && *(inputLine + i + 1) == 'x')
      {
#     ifdef  __SASC
      (void) stch_i( &inputLine[ i + 2 ], &rval ); // Verify this
#     else
      (void) hexStrToLong( &inputLine[ i + 2 ], (long *) &rval ); 
#     endif
      }
   else
      {
      rval = atoi( &inputLine[ i ] );
      }

   return( rval );   
}

/****i* readInSDict() [3.0] ******************************************
*
* NAME
*    readInSDict()
*
* DESCRIPTION
*    Set the SystemDictionary Array to the contents of a file.
*    Each entry is as follows:   Symbol_String @ Integer
**********************************************************************
*
*/

SUBFUNC void readInSDict( FILE *fp, OBJECT *sd, int numElements )
{
   UBYTE *line = NULL;
   int    i;

   for (i = 0; i < 2 * numElements; i += 2)
      {
      line = readInElement( fp );
      
      sd->inst_var[i    ] = (OBJECT *) new_sym( getKeyString( line ) ); // Key

      sd->inst_var[i + 1] = AssignObj( new_int( getValue( line )) ); // Value
      }

   return;
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

SUBFUNC int SymCompare( char *sym1, char *sym2 )
{
   int rval = 0;

   if (sym1 == sym2)
      return( rval );                   // They're equal!
         
   rval = *sym1 - *sym2;                // Compare the 1st char's. 

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
*    Find the index in sdStruct that corresponds to the given key,
*    using a binary search of this sorted table.  The even 
*    inst_vars[] are the keys, the odd are the values, which do not
*    concern us in this function.
*
* HISTORY
*    07-Mar-2001 - Removed the code that was eating up the most
*                  time.  Apparently, it's quicker to search for the
*                  endpoints than to make special checks for them.
**********************************************************************
*
*/

SUBFUNC int BinarySearch( SYMBOL *key, OBJECT *sdStruct )
{
   struct SDict *sd = (struct SDict *) int_value( sdStruct );
   OBJECT       *si = NULL;
   int           lo;
   int           hi;

   // --------------------------------------------------------
   
   if (!sd || (sd == (struct SDict *) o_nil))
      return( -1 );
   
   si = (OBJECT *) sd->sd_Storage;      
   lo = 0;
   hi = sd->sd_NumEntries;

   while ((hi - lo) > 0) // Start searching:
      {
      int midPt, adj;
      
      midPt = (hi + lo + 1) / 2;
      
      if ((hi - lo) == 1) // Pathological case:
         {
         if (key == (SYMBOL *) si->inst_var[ (midPt + 1) * 2 ])
            {
            return( midPt + 1 ); // Occasional return.
            }
         else if (key == (SYMBOL *) si->inst_var[ (midPt - 1) * 2 ])
            {
            return( midPt - 1 );
            }
         else if (key == (SYMBOL *) si->inst_var[ midPt * 2 ])
            {
            return( midPt );
            }
         else
            {
            return( -1 );    // Abnormal return path.
            }
         }

      adj = SymCompare( symbol_value( key ), 
                        symbol_value( (SYMBOL *) si->inst_var[ midPt * 2 ] ) 
                      );

      // Adjust the search end-point indices:

      if (adj == 0)
         {
         return( midPt ); // Found the correct key!
         }
      else if (adj < 0)
         hi = midPt;      // Eliminate high portion
      else
         lo = midPt;      // Eliminate low portion 
      }

   // This code should never get executed:

   if (key == (SYMBOL *) si->inst_var[ hi * 2 ])
      {
      return( hi );
      } 
   else
      {
      return( -1 );
      }
}

/****h* search() [1.6] *******************************************
*
* NAME
*    search()
*
* DESCRIPTION
*    performs a binary search for a key,
******************************************************************
*
*/

SUBFUNC int search( OBJECT *word, OBJECT *sdStruct )
{
   register int  i = -1;

   if ((i = BinarySearch( (SYMBOL *) word, sdStruct )) >= 0)
      return( i );
   else 
      return( -1 ); // Error condition!!
}

/****i* closeSDict() [3.0] ***************************************
* 
* NAME
*    closeSDict()
*
* DESCRIPTION
*   Close the SystemDictionary file & freeVec the structure.
*   Return o_nil.
*     private <- <primitive 206 0 private uniqueInstance>
******************************************************************
*
*/

METHODFUNC OBJECT *closeSDict( FILE *fp, OBJECT *sdStruct )
{
   struct SDict *sd = (struct SDict *) CheckObject( sdStruct );
   
   if (fp) // != NULL)
      fclose( fp );
      
   if (sd && sd->sd_Storage) // != NULL)
      {
      AT_FreeVec( sd->sd_Storage, "sdictStorage", TRUE );
      
      AT_FreeVec( sd, "SDict", TRUE ); // All gone!!
      }
      
   return( o_nil );
}

/****i* openSDictFile() [3.0] ************************************
*
* NAME
*    openSDictFile()
*
* DESCRIPTION
*    Open the SystemDictionary file, count the number of entries,
*    Then try to allocate space for them.
*
*    private <- <primitive 206 1 sourceFileName uniqueInstance>
******************************************************************
*
*/

METHODFUNC OBJECT *openSDictFile( UBYTE *fileName, OBJECT *sdStruct )
{
   IMPORT int SeekFileSize( FILE *fp, int *return_linecount ); // In Symbol.c

   struct SDict *sd   = (struct SDict *) CheckObject( sdStruct );
   FILE         *fp   = NULL;
   OBJECT       *rval = o_nil;

   int numBytes    = 0;
   int numElements = 0;

   if (!sd || (sd == (struct SDict *) o_nil))
      return( rval );
      
   if (!(fp = fopen( fileName, "r" ))) // == NULL)
      return( rval );   

   numBytes = SeekFileSize( fp, &numElements );
   
   if (numElements < 1)
      {
      if (sd) // != NULL) 
         AT_FreeVec( sd, "SDict", TRUE );

      // Tell User that fp is empty:
      sprintf( ErrMsg, SDictCMsg( MSG_FILE_IS_EMPTY_SDICT ), fileName );

      UserInfo( ErrMsg, FATAL_USER_ERROR );

      fclose( fp );
      
      return( rval );
      }
   else
      {
      OBJECT *tsd  = NULL;
      int     size = (2 * numElements + BASIC_OVERHEAD) * sizeof( ULONG );   

      if (!(sd->sd_Storage = (UBYTE *) AT_AllocVec( size, 
                                                    MEMF_CLEAR | MEMF_ANY,
                                                    "sdictStorage", TRUE ))) // == NULL)
         {
         if (sd) // != NULL)
            AT_FreeVec( sd, "SDict", TRUE );
         
         goto errorReturn;
         }
      
      tsd            = (OBJECT *) sd->sd_Storage;

      tsd->ref_count = 1;      
      tsd->size      = MMF_INUSE_MASK | MMF_SYSDICT | 2 * numElements;

                       // This is a private party, so buzz off:
      tsd->Class     = (CLASS  *) 0xDEADBEEF;
      tsd->super_obj = (OBJECT *) 0xDEADBEEF;
            
      readInSDict( fp, tsd, numElements );

      sd->sd_File       = fp;
      sd->sd_FileName   = fileName;
      sd->sd_NumEntries = numElements;
                 
      rval = AssignObj( new_address( (ULONG) fp ) );
      
      return( rval );
      }

errorReturn:

   if (fp) // != NULL)
      fclose( fp );
         
   MemoryOut( "openSDictFile()" );

   fprintf( stderr, "Ran out of memory in openSDictFile()!\n" );         
      
   cant_happen( NO_MEMORY );
      
   return( rval ); // never reached.
}

/****i* findKey() [3.0] ******************************************
*
* NAME
*    findKey()
*
* DESCRIPTION
*    Search for aSymbol in the SystemDictionary & return it's
*    associated value:
*       ^ <primitive 206 2 uniqueInstance aSymbol>
******************************************************************
*
*/

METHODFUNC OBJECT *findKey( OBJECT *sdStruct, OBJECT *keySymbol )
{
   struct SDict *sd   = (struct SDict *) int_value( sdStruct );
   OBJECT       *si   = NULL;
   OBJECT       *rval = o_nil;
   int           idx  = -1;
   
   if (!sd || (sd == (struct SDict *) o_nil))
      return( rval );
   
   si   = (OBJECT *) sd->sd_Storage;      
   idx  = search( keySymbol, sdStruct );

   if (idx < 0)
      {
      // Error condition (or User mis-spelled the Symbol!):
      
      return( rval ); // Return nil then.
      }   

   rval = AssignObj( si->inst_var[ 2 * idx + 1 ] );
   
   return( rval );
} 

/****i* allocSDictStructure() [3.0] ******************************
*
* NAME
*    allocSDictStructure()
*
* DESCRIPTION
*    Allocate a SystemDictionary structure.  The space for the
*    contents will be allocated by the openSDictFile() function.
*      ^ uniqueInstance <- <primitive 206 3>
******************************************************************
*
*/

METHODFUNC OBJECT *allocSDictStructure( void )
{
   struct SDict *sd   = NULL;
   OBJECT       *rval = o_nil;
      
   if (!(sd = (struct SDict *) AT_AllocVec( sizeof( struct SDict ),
                                            MEMF_CLEAR | MEMF_ANY,
                                            "SDict", TRUE ))) // == NULL)
      {
      MemoryOut( "allocSDictStructure()" );
      
      fprintf( stderr, "Ran out of memory in allocSDictStructure()!\n" );         

      return( rval );
      }

   rval = AssignObj( new_address( (ULONG) sd ) );
   
   return( rval );
}

/****h* HandleSDict() [3.0] ****************************************
*
* NAME
*    HandleSDict()
* 
* DESCRIPTION
*    Handle SystemDictionary primitive operations.
*
*    uniqueInstance is the SDict structure Integer Object,
*    private        is the FILE *fpointer  Integer Object.
*
*    ^ <primitive 206 0-5 args>
********************************************************************
*
*/

PUBLIC OBJECT *HandleSDict( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 206 );
      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // close [private uniqueInstance]
              // ^ nil <- <206 0 private uniqueInstance>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 206 );
         else
            rval = closeSDict( (FILE *) addr_value( args[1] ), 
                                                    args[2] 
                             );
         break;

      case 1: // private <- super new: sourceFileName [uniqueInstance]
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 206 );
         else
            rval = openSDictFile( string_value( (STRING *) args[1] ),
                                                           args[2]
                                );
         break;
         
      case 2: // systemTag: keySymbol ^ <primitive 206 2 uniqueInstance keySymbol>
         if (!is_address( args[1] ) || !is_symbol( args[2] ))
            (void) PrintArgTypeError( 206 );
         else
            rval = findKey( args[1], args[2] );
         break;

      case 3: // uniqueInstance <- <primitive 206 3>
         rval = allocSDictStructure();
         break;

      case 4: // Insert an element:
      case 5: // Sort the SystemDictionary:
               
      default:
         (void) PrintArgTypeError( 206 );

         break;
      }

   return( rval );
}

/* -------------- End of SDict.c file. ---------------------------- */
