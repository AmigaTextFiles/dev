/****h* AmigaTalk/Number.c [3.0] ***************************************
*
* NAME
*   Number.c
*
* DESCRIPTION
*    number definitions
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    29-Nov-2003 - Changed the design of the Integer Class such that
*                  a file of Integers from the previous run is read
*                  in via int_init( filename ).  Before the program
*                  exits, the integerList is sorted & the Integer file
*                  is written back out for the next run.
* 
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:src/Number.c 3.0 (25-Oct-2004) by J.T Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>      // for qsort() proto

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <libraries/asl.h>

#include "ATStructs.h"

#include "object.h"
#include "FuncProtos.h"
#include "Constants.h"

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;

IMPORT struct ExecIFace *IExec;
IMPORT struct DOSIFace  *IDOS;

#endif

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT UBYTE  *ErrMsg;
IMPORT UBYTE  *FATAL_USER_ERROR;
IMPORT OBJECT *o_nil;

IMPORT int started;
IMPORT int ca_int;   // count the number of integer alloc's (in Global.c)
IMPORT int debug;

IMPORT OBJECT *o_magnitude;
IMPORT OBJECT *o_number;
IMPORT ULONG IntegerTableSize; // ToolType in Tools.c

// ----------------------------------------------------------------

PRIVATE CHARACTER *characterList[256] = { NULL, }; // Array of Pointers

PRIVATE INTEGER   **integerList       = NULL;

PRIVATE ULONG      integerListSize    = 0L; // length of integerList
PRIVATE int        integerCount       = 0;
PRIVATE int        numElements        = 0;    // # of Integers in Integers.list
PRIVATE UBYTE     *IntegerFile        = NULL; // AmigaTalk:CodeLib/Integers.list

// ----------------------------------------------------------------

/****i* makeIntegerPool() [3.0] ***********************************
*
* NAME
*    makeIntegerPool()
*
* DESCRIPTION
*    Allocate a Memory Pool of the given size.  If size is zero,
*    allocate a default-sized Memory Pool.
*******************************************************************
*
*/

SUBFUNC void *makeIntegerPool( ULONG poolSize )
{
   void *rval = NULL;

   FBEGIN( printf( "makeIntegerPool( size = %d )\n", poolSize ) );

   if (poolSize == 0)   
      {
      if ((IntegerTableSize % INTEGER_SIZE) != 0)
         {
         // Round IntegerTableSize to even INTEGER_SIZE:
         int number = IntegerTableSize / INTEGER_SIZE + 1;
         
         if (number < (MIN_INTTABLE_SIZE / INTEGER_SIZE))
            number = MIN_INTTABLE_SIZE / INTEGER_SIZE;
             
         IntegerTableSize = number; //  * INTEGER_SIZE;
         }
         
      if ((rval = AT_AllocVec( IntegerTableSize * sizeof( ULONG ),
                               MEMF_CLEAR | MEMF_FAST, 
                               "integerList", TRUE ))) // != NULL)
         {
         integerListSize = IntegerTableSize;
         }
      }
   else
      {
      if ((poolSize % INTEGER_SIZE) != 0)
         {
         // Round poolSize to even INTEGER_SIZE:
         int number = poolSize / INTEGER_SIZE + 1;
         
         if (number < (MIN_INTTABLE_SIZE / INTEGER_SIZE))
            number = MIN_INTTABLE_SIZE / INTEGER_SIZE;

         poolSize = number; //  * INTEGER_SIZE;
         }
         
      if ((rval = AT_AllocVec( poolSize * sizeof( ULONG ), 
                               MEMF_FAST | MEMF_CLEAR, 
                               "integerList", TRUE ))) // != NULL)
         {
         integerListSize = poolSize;
         }
      }

   FEND( printf( "0x%08LX = makeIntegerPool()\n", rval ) );

   return( rval );
}

/****h* allocIntegerPool() [3.0] **********************************
*
* NAME
*    allocIntegerPool()
*
* DESCRIPTION
*    Allocate the Integer PoolHeader for SmallTalk().
*******************************************************************
*
*/

PUBLIC void *allocIntegerPool( ULONG poolSize ) // Visible to SmallTalk()
{
   void *rval = (void *) integerList;

   FBEGIN( printf( "allocIntegerPool( size = %d )\n", poolSize ) );   

   if (integerList) // != NULL)
      {
      goto exitAlloc;
      }
      
   if ((integerList = (INTEGER **) makeIntegerPool( poolSize ))) // != NULL)
      {
      rval = (void *) integerList;
      } 

exitAlloc:

   FEND( printf( "0x%08LX = allocIntegerPool()\n", rval ) );    

   return( rval );
}

/****i* allocInteger() [3.0] **************************************
*
* NAME
*    allocInteger()
*
* DESCRIPTION
*    Allocate the Integer structure space.
*******************************************************************
*
*/

SUBFUNC INTEGER *allocInteger( void )
{
   INTEGER *New = NULL;

   FBEGIN( printf( "allocInteger( void )\n" ) );

   if ((ca_int + 1) > integerListSize)
      {
      // We're going to exceed the Pool size, so die instead:
      fprintf( stderr, "Ran out of memory in allocInteger()!\n" );
      
      MemoryOut( "allocInteger()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      }

   if (!(New = (INTEGER *) AT_calloc( 1, INTEGER_SIZE, "Integer", FALSE ))) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocInteger()!\n" );
      
      MemoryOut( "allocInteger()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      }

   integerCount++; // The ONLY place where integerCount changes!
      
   New->ref_count = 1;
   New->size      = MMF_INUSE_MASK | MMF_INTEGER | INTEGER_SIZE;
         
   FEND( printf( "0x%08LX = allocInteger()\n", New ) );

   return( New );
}

/****i* searchCompare() [3.0] ****************************************
*
* NAME
*    searchCompare()
*
* DESCRIPTION
*    compare two Integers & return the result.
**********************************************************************
*
*/

PRIVATE int searchCompare( ULONG i1, ULONG i2 )
{
   int rval = 0;

   if (i1 == i2)
      rval = 0;
   else if (i1 < i2)
      rval = -1;
   else
      rval = 1;
            
   return( rval );
}

/****i* intBinarySearch() ********************************************
*
* NAME
*    intBinarySearch()
*
* DESCRIPTION
*    Find the index in integerList that corresponds to the given value,
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

PRIVATE int intBinarySearch( int value, int *indexstore )
{
   int hi, lo;
   int midPt, adj;
   int rval = 0;
      
   lo = 0;
   hi = integerCount;

   // Have to do the full search:

   while ((hi - lo) > 0)
      {
      midPt = (hi + lo + 1) / 2;
      
      if ((hi - lo) == 1) // Pathological case:
         {
         if (value == int_value( integerList[midPt + 1] ))
            {
            *indexstore = midPt + 1;
            
            rval = midPt + 1;
            
            goto exitSearch;
            }
         else if (value == int_value( integerList[midPt - 1] ))
            {
            *indexstore = midPt - 1;

            rval = midPt - 1;

            goto exitSearch;
            }
         else if (value == int_value( integerList[ midPt ] ))
            {
            *indexstore = midPt;

            rval = midPt;

            goto exitSearch;
            }
         else
            {
            *indexstore = midPt;

            rval = -1; // value was NOT found!

            goto exitSearch;
            }
         }

      adj = searchCompare( (ULONG) value, (ULONG) int_value( integerList[ midPt ] ) );

      // Adjust the search end-point indices:

      if (adj == 0)
         {
         *indexstore = midPt;

         rval = midPt;      // Found the index!

         goto exitSearch;
         }
      else if (adj < 0)
         hi = midPt;
      else
         lo = midPt;      
      }

   // This code should never get executed:

   if (value == int_value( integerList[ hi ] ))
      {
      *indexstore = hi;

      rval = hi;
      } 
   else
      {
      *indexstore = -1;

      rval = -1;
      }

exitSearch:

   return( rval );
}

/****i* intSearch() [3.0] ********************************************
*
* NAME
*    intSearch()
*
* DESCRIPTION
*    performs a binary search of an Integer, is the main interface to
*    the Integer routines, surrounded by the new_int() function.
*    The Integer array integerList is NOT a power of 2 size,
*    so some problems have been encountered when searching for the
*    index of 256.
*
* HISTORY
*    29-Nov-2003 - Rewrote symSearch() to account for Integers.
*
* NOTES
*    Only one copy of Integer values are kept.
*    Multiple copies of the same Integer point to the same location.
*    intSearch will find, and if necessary insert, a value into
*    this common table.
**********************************************************************
*
*/

PRIVATE INTEGER *intSearch( int value, int insertFlag )
{
   int i        = -1;
   int insertpt = 0;

   if ((i = intBinarySearch( value, &insertpt )) >= 0)
      return( integerList[ i ] );

   if (insertFlag != FALSE) // Well, then insert a new Integer:
      {
      if (insertpt > 1) 
         i = insertpt;
      else if (insertpt > 0)
         i = 0;

      if ((integerCount + 1) >= integerListSize)
         {
         sprintf( ErrMsg, NumbCMsg( MSG_FMT_INT_OVERFLOW_NUMB ), value, insertpt );
         
         UserInfo( ErrMsg, NumbCMsg( MSG_RQTITLE_FATAL_ERROR_NUMB ) );
         
         cant_happen( NO_INTEGER_SPACE );  // Die, you abomination!!
         
         return( NULL ); // Never reached!
         }
                  
      for (insertpt = (integerCount + 1); insertpt > i; insertpt--) 
         {
         // We have to make a space by moving the elements down one:
         integerList[ insertpt ] = integerList[ insertpt - 1 ];
         }

      integerList[i]        = allocInteger();
      integerList[i]->value = value;
      ca_int++;
            
      return( integerList[ i ] );
      }
   else 
      return( NULL ); // Error condition!!
}

/****i* IntCompare() [3.0] *******************************************
*
* NAME
*    IntCompare()
*
* DESCRIPTION
*    Compare two integers for sortIntegerList() & return the result.
**********************************************************************
*
*/

SUBFUNC int IntCompare( const void *int1, const void *int2 )
{
   unsigned int i1, i2;
   int          rval = MYNULL;
   
   i1 = (unsigned int) int_value( (INTEGER *) int1 );
   i2 = (unsigned int) int_value( (INTEGER *) int2 );
    
   if (i1 == i2)
      rval = 0;
   else if (i1 < i2)
      rval = -1;
   else
      rval = 1;
      
   return( rval );
}

SUBFUNC int sortIntegerList( void )
{
   int size = 0;
   
   while (integerList[ size ]) // != NULL)
      size++;
   
   qsort( (void *) integerList[0], 
          (size_t) size, 
	  (size_t) INTEGER_SIZE, 
	  (int (*)( const void *, const void * )) IntCompare 
	);
   
   return( size );
}

/****h* WriteIntegerFile() [3.0] **********************************
*
* NAME
*    WriteIntegerFile()
*
* DESCRIPTION
*    Write all currently known Integers to the IntegerFile before
*    the program terminates, so that we won't have to do so
*    many insertions into the Integer table, which slows the 
*    loading of the program considerably.
******************************************************************
*
*/

SUBFUNC int WriteIntegerFile( void )
{
   FILE *outfile = fopen( IntegerFile, "w" );
   int   rval    = -1, i, value; // , size;

   if (!outfile) // == NULL)
      {
      rval = ERROR_OBJECT_NOT_FOUND; // IoErr();
      
      goto exitWriteIntegerFile;
      }

//   size = sortIntegerList(); // No longer necessary
   i    = 0;
   
   while (i < integerCount) // size)
      {
      value = int_value( integerList[ i ] );
      
      if (value > 255 || value < 0)
         fprintf( outfile, "0x%LX\n", value );
      else
         fprintf( outfile, "%d\n", value );
      
      i++;
      }

   fclose( outfile );

   rval = RETURN_OK;          // Success!

exitWriteIntegerFile:

   return( rval );   
}

/****h* new_int() [3.0] **********************************************
*
* NAME
*    new_int()
*
* DESCRIPTION
*    Allocate a new Integer or find it in the integerList.
**********************************************************************
*
*/

PUBLIC OBJECT *new_int( int value )
{
   INTEGER *New  = (INTEGER *) NULL;

   FBEGIN( printf( "new_int ( %d )\n", value ) );

   if (value < 256 && value >= 0)
      New = integerList[ value ];
   else
      New = intSearch( value, TRUE ); // TRUE = Insert into table.
   
   FEND( printf( "0x%08LX = new_int( %d )\n", New, New->value ) );

   return( (OBJECT *) New );
}

// -------------------------------------------------------------------

PUBLIC OBJECT *new_char( int value )
{
   return( (OBJECT *) characterList[ value ] );
}

/****h* new_cori() [3.0] *********************************************
*
* NAME
*    new_cori()
*
* DESCRIPTION
*    New character or integer
**********************************************************************
*
*/

PUBLIC OBJECT *new_cori( int val, int type )
{   
   if (type == 0)
      return( new_char( val ) );
   else
      return( new_int( val ) );
}

/****h* free_integer() [3.0] *****************************************
*
* NAME
*    free_integer()
*
* DESCRIPTION
*    Just reset the ref_count for these Types of Objects.
**********************************************************************
*
*/

PUBLIC void free_integer( INTEGER *i )
{
   FBEGIN( printf( "void free_integer( 0x%08LX = %d )\n", i, i->value ) );

   if (  (is_integer(   (OBJECT *) i ) == FALSE) 
      && (is_character( (OBJECT *) i ) == FALSE))
      {
      fprintf( stderr, "free_integer( 0x%08LX ) was not an Integer or Char!\n", i );

      cant_happen( WRONGOBJECT_FREED );  // Die, you abomination!!
      
      return; // never reached
      }

   i->ref_count = 1; // Reset our count because we do NOT free these!

   FEND( printf( "free_integer() exits\n" ) );

   return;
}

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

PRIVATE UBYTE ele[64] = { 0, }, *line = &ele[0];

SUBFUNC UBYTE *readInElement( FILE *fp )
{
   *line = '\0';

   fgets( line, 64, fp );
   
   if (StringLength( line ) < 1)
      {
      // Should flag this error condition:
      
      return( NULL );
      }
      
   return( line );
}

/****i* getValue() [3.0] *****************************************
*
* NAME
*    getValue()
*
* DESCRIPTION
*    Retrieve an Integer from an input line.
**********************************************************************
*
*/

PRIVATE UBYTE iv[48] = { 0, }, *intValue = &iv[0];

SUBFUNC int getValue( UBYTE *inputLine )
{
   int i;
   
   for (i = 0; i < 48; i++)
      *(intValue + i) = '\0'; // Make sure buffer is clean for passes > 1
   
   i = 0;
   
   while (i < 48 && *(inputLine + i) != ' ' 
                 && *(inputLine + i) != '\t'
                 && *(inputLine + i) != '\n')
      {
      *(intValue + i) = *(inputLine + i);
      
      i++;
      }

   if (*intValue != '0' && *(intValue + 1) != 'x')
      i = atoi( intValue );
   else
      {
#     ifdef __SASC   
      (void) stch_i( &intValue[2], &i );
#     else
      char *end = &intValue[0];
      
      i = (int) strtoul( &intValue[2], &end, 16 );
#     endif      
      }

   return( i );
}

/****i* readInIntegers() [3.0] ***************************************
*
* NAME
*    readInIntegers()
*
* DESCRIPTION
*    Set the IntegerDictionary Array to the contents of a file.
**********************************************************************
*
*/

SUBFUNC void readInIntegers( FILE *fp, int numElements )
{
   UBYTE *line = NULL;
   int    i;

   for (i = 0; i < numElements; i++)
      {
      INTEGER *New = NULL;
      
      if (!(line = readInElement( fp ))) // == NULL)
         break;

      New = allocInteger();

      ca_int++;

      New->ref_count = 1;
      New->size      = MMF_INUSE_MASK | MMF_INTEGER | INTEGER_SIZE;
      New->value     = getValue( line );
      
      integerList[i] = New;
      }

   return;
}

/****i* getIntegerFileName() [3.0] *******************************
*
* NAME
*    getIntegerFileName()
*
* DESCRIPTION
*    Open an ASL File requester & get the User to supply a valid
*    Integers.list fileName.
******************************************************************
*
*/

PRIVATE UBYTE ifn[256] = { 0, };

SUBFUNC UBYTE *getIntegerFileName( void )
{
   IMPORT struct TagItem LoadTags[];
   IMPORT struct Window  *ATWnd;

   char *title = NumbCMsg( MSG_GET_INTEGER_FILE_NUMB ); 

   SetTagItem( &LoadTags[0], ASLFR_TitleText, (ULONG) title );
   SetTagItem( &LoadTags[0], ASLFR_Window,    (ULONG) ATWnd );

   SetTagItem( &LoadTags[0], ASLFR_InitialDrawer,
                             (ULONG) "AmigaTalk:prelude/listFiles" 
             );

   if (FileReq( &ifn[0], &LoadTags[0] ) > 1)
      {
      return( &ifn[0] );
      }
   else
      return( NULL ); // They were given every chance!!
}

/****i* readIntegerFile() [3.0] **********************************
*
* NAME
*    readIntegerFile()
*
* DESCRIPTION
*    Open the Integers.list file, count the number of entries
*    while adding them to integerList.
******************************************************************
*
*/

PRIVATE int readIntegerFile( UBYTE *fileName )
{
   IMPORT int SeekFileSize( FILE *fp, int *return_linecount ); // In Symbol.c

   FILE  *fp      = NULL;
   UBYTE *fName   = fileName;
   int   rval     = RETURN_OK;
   int   numBytes = 0;

tryAgain:

   if (!(fp = fopen( fName, "r" ))) // == NULL)
      {
      if (!(fName = getIntegerFileName())) // == NULL)
         {
         rval = RETURN_ERROR;
         
         goto exitReadIntegerFile;
         }
      else
         goto tryAgain;         
      }

   numBytes = SeekFileSize( fp, &numElements );
   
   if (numElements < 1)
      {
      // Tell User that fp is empty:
      sprintf( ErrMsg, NumbCMsg( MSG_FILE_IS_EMPTY_NUMB ), fileName );

      UserInfo( ErrMsg, NumbCMsg( MSG_RQTITLE_ATALK_PROBLEM_NUMB ) );

      fclose( fp );
      
      rval = RETURN_ERROR;
      }
   else
      {
      readInIntegers( fp, numElements );
      }

   if (fp) // != NULL)
      fclose( fp );
         
exitReadIntegerFile:

   return( rval );
}

// calloc() a CHARACTER Object:

SUBFUNC CHARACTER *allocChar( void )
{
   CHARACTER *rval = (CHARACTER *) AT_calloc( 1, CHARACTER_SIZE, "Character", FALSE );
   
   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocChar()!\n" );
      
      MemoryOut( "allocChar()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); //  never reached
      }
      
   return( rval );
}

/****h* int_init() [3.0] *********************************************
*
* NAME
*    int_init()
*
* DESCRIPTION
*    Initialize the internal integer Object space.
**********************************************************************
*
*/

PUBLIC void int_init( char *integerFileName ) 
{
   int i;

   // Read in sorted Integers from a previous run:
   if (readIntegerFile( integerFileName ) != RETURN_OK)
      {
      sprintf( ErrMsg, NumbCMsg( MSG_FMT_F_UNOPENED_NUMB ), integerFileName );
      
      UserInfo( ErrMsg, FATAL_USER_ERROR ); // NumbCMsg() );
      
      cant_happen( FILE_OPEN_ERROR );
      
      return; // Never reached.
      }
   else
      IntegerFile = integerFileName;
   
   // Initialize the Character table:
   for (i = 0; i < 256; i++)
      {
      CHARACTER *ch = allocChar();
      
      ch->ref_count = 0xFF; // We do NOT want to free these until all is over
      ch->size      = MMF_INUSE_MASK | MMF_CHARACTER | CHARACTER_SIZE;
      ch->value     = i;

      characterList[i] = ch;
            
      ca_int++;
      }

   return;
}

/****h* freeVecAllIntegers() [3.0] ***********************************
*
* NAME
*    freeVecAllIntegers()
*
* DESCRIPTION
*    FreeVec ALL Integers & Chars for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllIntegers( void )
{
   int i;
/*       
   if (WriteIntegerFile() != RETURN_OK)
      {
      sprintf( ErrMsg, NumbCMsg( MSG_FMT_F_UNOPENED_NUMB ),IntegerFile );
      
      UserInfo( ErrMsg, NumbCMsg( MSG_RQTITLE_ATALK_PROBLEM_NUMB ) );
      }
*/
   for (i = 0; i < integerCount; i++) // i = 0; while (integerList[i++] != NULL)
      {
      AT_free( integerList[ i ], "Integer", FALSE );
      }           
      
   AT_FreeVec( integerList, "integerList", TRUE );
   
   integerList = NULL;

   for (i = 0; i < 256; i++)
      {
      AT_free( characterList[ i ], "Character", FALSE );
      }
         
   return;
}

// -------------------------------------------------------------------

IMPORT int ca_float; // See Global.c

PRIVATE SFLOAT *recycleFloatList  = NULL;

PRIVATE SFLOAT *lastAllocdFloat   = NULL;
PRIVATE SFLOAT *floatList         = NULL;

// -------------------------------------------------------------------

/****i* freeVecDeadFloats() [3.0] ************************************
*
* NAME
*    freeVecDeadFloats()
*
* DESCRIPTION
*    Free the memory space of all unused Floats in the 
*    recycleFloatList.
**********************************************************************
*
*/

SUBFUNC int freeVecDeadFloats( SFLOAT **recycledList, SFLOAT **last )
{
   SFLOAT *p       = *recycledList;
   SFLOAT *next    =  NULL;
   int     howMany =  0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      if (p->size & MMF_INUSE_MASK == 0) 
         howMany++;
          
      p = next;
      }

   return( howMany );
}

SUBFUNC void storeFloat( SFLOAT *f, SFLOAT **last, SFLOAT **list )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = f;
      *list = f;
      }
   else
      {
      (*last)->nextLink = f;
      }

   f->nextLink = NULL;

   *last = f; // Update the end of the List.
   
   return;       
}

/****i* findFreeFloat() [3.0] ****************************************
*
* NAME
*    findFreeFloat()
*
* DESCRIPTION
*    Find the first Float marked as unused in the recycleFloatList.
**********************************************************************
*
*/

SUBFUNC SFLOAT *findFreeFloat( void )
{
   SFLOAT *p = recycleFloatList;

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

SUBFUNC void recycleFloat( SFLOAT *killMe )
{
   killMe->size      = MMF_FLOAT | FLOAT_SIZE; // Clear MMF_INUSE_MASK bit.
   killMe->ref_count = 0;
   killMe->value     = 0.0;
       
   return;
}

/****h* freeSlackFloatMemory() [3.0] *******************************
*
* NAME
*    freeSlackFloatMemory()
*
* DESCRIPTION
*    Get rid of all Floats in the recycleFloatList.
********************************************************************
*
*/

PUBLIC int freeSlackFloatMemory( void )
{
   return( freeVecDeadFloats( &recycleFloatList, NULL ) ); // &lastRecycledFloat ) );
}

/****h* freeVecAllFloats() [3.0] *************************************
*
* NAME
*    freeVecAllFloats()
*
* DESCRIPTION
*    FreeVec ALL Floats for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllFloats( void )
{
   SFLOAT *p    = floatList;
   SFLOAT *next = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      AT_free( p, "Float", TRUE );
      
      p = next;
      }

   return;
}

SUBFUNC SFLOAT *allocFloat( void )
{
   SFLOAT *rval = (SFLOAT *) AT_calloc( 1, FLOAT_SIZE, "Float", TRUE );
   
   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocFloat()!\n" );
      
      MemoryOut( "allocFloat()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); //  never reached
      }
      
   return( rval );
}

/****h* new_float() [1.5] ********************************************
*
* NAME
*    new_float()
*
* DESCRIPTION
*    Produce a new floating point number
**********************************************************************
*
*/

PUBLIC OBJECT *new_float( double val )
{   
   SFLOAT *New  = NULL;

   if (started == TRUE)
      {
      if ((New = findFreeFloat())) // != NULL)
         goto setupNewFloat;
      }

   New = allocFloat();

   if (debug == TRUE)
      fprintf( stderr, NumbCMsg( MSG_N_NEW_FLOAT_NUMB ), val, New );

   ca_float++;

setupNewFloat:

   New->ref_count = 0;
   New->size      = MMF_INUSE_MASK | MMF_FLOAT | FLOAT_SIZE;
   New->value     = val;
   New->nextLink  = NULL;

   storeFloat( New, &lastAllocdFloat, &floatList );

   return( (OBJECT *) New );
}

/****h* free_float() [1.5] *******************************************
*
* NAME
*    free_float()
*
* DESCRIPTION
*    Remove a float Object from the Program space.
**********************************************************************
*
*/

PRIVATE BOOL firstFloatRecycle = TRUE;

PUBLIC void free_float( SFLOAT *f )
{
   if (is_float( (OBJECT *) f ) == FALSE)
      {
      fprintf( stderr, "free_float( 0x%08LX ) was NOT a Float!\n", f );

      cant_happen( WRONGOBJECT_FREED );  // Die, you abomination!!
      }
      
   if (debug == TRUE)
      fprintf( stderr, NumbCMsg( MSG_N_FREE_FLOAT_NUMB ), f->value );

   if (firstFloatRecycle == TRUE)
      {
      recycleFloatList  = f;
      firstFloatRecycle = FALSE;
      }            

   recycleFloat( f );
   
   return;
}

/* ------------------ END of Number.c file! ---------------------- */
