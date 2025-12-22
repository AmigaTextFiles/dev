/****h* AmigaTalk/Byte.c [3.0] *************************************
*
* NAME
*    Byte.c
*
* HISTORY
*    09-Nov-2003 - Set up for memory management support to be added.
*
* NOTES 
*    bytearray manipulation.
*    bytearrays are used almost entirely for storing bytecodes.
*
*    $VER: AmigaTalk:Src/Byte.c 3.0 (09-Nov-2003) by J.T. Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#ifndef  AMIGATALKSTRUCTS_H
# include "ATStructs.h"
#endif

#include "object.h"
#include "Constants.h"
#include "CantHappen.h"

#include "FuncProtos.h"

#ifndef  SUBFUNC
# define SUBFUNC PRIVATE
#endif

#define MEMFLAGS  MEMF_CLEAR | MEMF_FAST

IMPORT int started;

IMPORT int ca_barray; // In Global.c, where all good globals are. 
IMPORT int ca_wal;
IMPORT int ca_bsize;

IMPORT ULONG ByteArrayTableSize; // ToolType in Tools.c

// -------------------------------------------------------------------

PRIVATE void      *bytearrayPool         = NULL; // Only accessed twice

//PRIVATE BYTEARRAY *lastRecycledByteArray = NULL;
PRIVATE BYTEARRAY *recycleByteArrayList  = NULL;

PRIVATE BYTEARRAY *lastAllocdByteArray   = NULL;
PRIVATE BYTEARRAY *bytearrayList         = NULL;

PRIVATE ULONG      AllocatedBASize       = 0L; // Maximum List size

// -------------------------------------------------------------------

/****i* makeByteArrayPool() [3.0] *********************************
*
* NAME
*    makeByteArrayPool()
*
* DESCRIPTION
*    Allocate a Memory Pool of the given size.  If size is zero,
*    allocate a default-sized Memory Pool.
*******************************************************************
*
*/

SUBFUNC void *makeByteArrayPool( ULONG poolSize )
{
   void *rval = NULL;

   FBEGIN( printf( "makeByteArrayPool( size = %d )\n", poolSize ) );

   if (poolSize == 0)   
      {
      if ((ByteArrayTableSize % BYTEARRAY_SIZE) != 0)
         {
         // Round ByteArrayTableSize to even BYTEARRAY_SIZE:
         int number = ByteArrayTableSize / BYTEARRAY_SIZE + 1;

         if (number < (MIN_BYTTABLE_SIZE / BYTEARRAY_SIZE))
            number = MIN_BYTTABLE_SIZE / BYTEARRAY_SIZE;  // We need to maintain a minimum
                     
         ByteArrayTableSize = number * BYTEARRAY_SIZE;
         }
         
      if ((rval = AT_AllocVec( (ULONG) ByteArrayTableSize,
                               MEMF_CLEAR | MEMF_FAST,
                               "bytePoolHeader", TRUE ))) // != NULL)
         {
         AllocatedBASize = ByteArrayTableSize;
         }
      }
   else
      {
      if ((poolSize % BYTEARRAY_SIZE) != 0)
         {
         // Round poolSize to even BYTEARRAY_SIZE:
         int number = poolSize / BYTEARRAY_SIZE + 1;
         
         if (number < (MIN_BYTTABLE_SIZE / BYTEARRAY_SIZE))
            number = MIN_BYTTABLE_SIZE / BYTEARRAY_SIZE;  // We need to maintain a minimum
                     
         poolSize = number * BYTEARRAY_SIZE;
         }
         
      if ((rval = AT_AllocVec( poolSize, MEMF_CLEAR | MEMF_FAST,
                               "bytePoolHeader", TRUE ))) // != NULL)
         {
         AllocatedBASize = poolSize;
         }
      }

   FEND( printf( "0x%08LX = makeByteArrayPool()\n", rval ) );      

   return( rval );
}

/****h* allocByteArrayPool() [3.0] ********************************
*
* NAME
*    allocByteArrayPool()
*
* DESCRIPTION
*    Allocate the ByteArray PoolHeader for SmallTalk().
*******************************************************************
*
*/

PUBLIC void *allocByteArrayPool( ULONG poolSize ) // Visible to SmallTalk()
{
   FBEGIN( printf( "allocByteArrayPool( size = %d )\n", poolSize ) );

   if (bytearrayPool) // != NULL)
      {
      FEND( printf( "0x%08LX = allocByteArrayPool()\n", bytearrayPool ) );

      return( bytearrayPool );
      }
   if ((bytearrayPool = makeByteArrayPool( poolSize ))) // != NULL)
      bytearrayList = (BYTEARRAY *) bytearrayPool;

   FEND( printf( "0x%08LX = allocByteArrayPool()\n", bytearrayPool ) );

   return( bytearrayPool );
}

/****i* allocBytes() [3.0] ****************************************
*
* NAME
*    allocBytes()
*
* DESCRIPTION
*    Allocate the contents area pointer of the ByteArray & copy
*    the values into it.
*******************************************************************
*
*/

SUBFUNC UBYTE *allocBytes( UBYTE *values, int size )
{
   UBYTE *p = NULL, *ch = NULL, *start = NULL;

   if (!(p = (UBYTE *) AT_AllocVec( size, MEMFLAGS, "byteArray", FALSE ))) // == NULL)
      {
      // Something different will have to be done here:
      fprintf( stderr, "Ran out of memory in allocBytes()!\n" );
      
      MemoryOut( "allocBytes()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      } 

   ca_wal++;
   ca_bsize += size;
   
   start = p; // Save the start of the byte string.
   
   for (ch = values; size > 0; size--)
      *p++ = *ch++; // Copy val into our allocation
      
   return( start );
}

/****i* storeByteArray() [3.0] ************************************
*
* NAME
*    storeByteArray()
*
* DESCRIPTION
*    Add ByteArray b to the byteArrayList.
*******************************************************************
*
*/

SUBFUNC void storeByteArray( BYTEARRAY *b, 
                             BYTEARRAY **last,
                             BYTEARRAY **list
                           )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = b;
      *list = b;
      }
   else
      {
      (*last)->nextLink = b;
      }

   b->nextLink = (BYTEARRAY *) NULL;

   *last = b; // Update the end of the List.
   
   return;       
}

/****i* allocByteArray() [3.0] ************************************
*
* NAME
*    allocByteArray()
*
* DESCRIPTION
*    Allocate the ByteArray structure space.
*******************************************************************
*
*/

SUBFUNC BYTEARRAY *allocByteArray( void )
{
   BYTEARRAY *New = (BYTEARRAY *) NULL;

   FBEGIN( printf( "allocByteArray( void )\n" ) );

   if ((ca_barray + 1) * BYTEARRAY_SIZE > AllocatedBASize)
      {
      // We're going to exceed the Pool size, so die instead:
      fprintf( stderr, "Ran out of memory in allocByteArray()!\n" );
      
      MemoryOut( "allocByteArray()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      }
      
   if (!lastAllocdByteArray) // == NULL)
      {
      // the first ByteArray to get created:
      New           = bytearrayList;
      New->nextLink = NULL;
      
      lastAllocdByteArray = New;
      }
   else
      {
      BYTEARRAY *prev = lastAllocdByteArray; // bytearrayList;
      
      while (prev->nextLink) // != NULL)
         prev = prev->nextLink; // Find the end of the list.

      New = ++prev; // + BYTEARRAY_SIZE; // DEBUG this!
      
      storeByteArray( New, &lastAllocdByteArray, &bytearrayList );
      }      

  FEND( printf( "0x%08LX = allocByteArray()\n", New ) );

  return( New );
}

/****i* freeDeadByteArrays() [3.0] *********************************
*
* NAME
*    freeDeadByteArrays()
*
* DESCRIPTION
*    Count the space on the recycledList
********************************************************************
*
*/

SUBFUNC int freeDeadByteArrays( BYTEARRAY **recycledList, BYTEARRAY **last )
{
   BYTEARRAY *p     = *recycledList;
   BYTEARRAY *next  =  (BYTEARRAY *) NULL;
   int        count =  0, byteCount = 0;
      
   while (p) // != NULL)
      {
      next = p->nextLink;

      if (p->bytes) // != NULL)
         byteCount += p->bsize;

      count++;
   
      p = next;
      }   

   return( count * BYTEARRAY_SIZE + byteCount );
}

/****i* findFreeByteArray() [3.0] *********************************
*
* NAME
*    findFreeByteArray()
*
* DESCRIPTION
*    See if there's an available ByteArray structure already
*    waiting for us.  If so, remove it from the recycleList.
*******************************************************************
*
*/

SUBFUNC BYTEARRAY *findFreeByteArray( void )
{
   BYTEARRAY *p    = recycleByteArrayList;
   BYTEARRAY *rval = (BYTEARRAY *) NULL;

   FBEGIN( printf( "findFreeByteArray( void )\n" ) );   

   if (!p) // == NULL)
      goto exitFindFreeByteArray;
         
   for ( ; p != (BYTEARRAY *) NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         rval = p;
         
         break;
         }
      }

exitFindFreeByteArray:

   FEND( printf( "0x%08LX = findFreeByteArray()\n", rval ) );   

   return( rval );
}

/****i* recycleByteArray() [3.0] **********************************
*
* NAME
*    recycleByteArray()
*
* DESCRIPTION
*    Remove the ByteArray Object from the bytearrayList & Free
*    the bytecode space,  then place it on the recycleList.
*******************************************************************
*
*/

PRIVATE BOOL firstRecycledBA = TRUE;

SUBFUNC void recycleByteArray( BYTEARRAY *killMe )
{
   killMe->size &= ~MMF_INUSE_MASK; // Clear INUSE bit.

   if (killMe->bytes) // != NULL)
      {
      AT_FreeVec( killMe->bytes, "byteArray", FALSE );
      
      killMe->bytes = 0; // NULL;
      killMe->bsize = 0;
      }

   if (firstRecycledBA == TRUE)
      {
      firstRecycledBA      = FALSE;
      recycleByteArrayList = killMe;
      }
      
   return;
}

/****h* freeVecAllByteArrays() [3.0] *******************************
*
* NAME
*    freeVecAllByteArrays()
*
* DESCRIPTION
*    Deallocate all ByteArray Objects.
********************************************************************
*
*/

PUBLIC void freeVecAllByteArrays( void )
{
   AT_FreeVec( bytearrayPool, "bytePoolHeader", TRUE );

   bytearrayPool = NULL;

   return;
}

/****h* freeSlackByteArrayMemory() [3.0] ***************************
*
* NAME
*    freeSlackByteArrayMemory()
*
* DESCRIPTION
*    Get rid of ALL unused ByteArrays in the recycleByteArrayList.
********************************************************************
*
*/

PUBLIC int freeSlackByteArrayMemory( void )
{
   return( freeDeadByteArrays( &recycleByteArrayList, 
                               NULL // &lastRecycledByteArray 
                             ) 
         );
}

/****h* byte_init() [1.5] ******************************************
*
* NAME
*    byte_init()
*
* DESCRIPTION
*    Initialize the ByteArray list of free objects.
********************************************************************
*
*/

PUBLIC void byte_init( void )
{   
   return;
}

/****h* new_bytearray() [1.5] **************************************
*
* NAME
*    new_bytearray()
*
* DESCRIPTION
*    get space for a new ByteArray or Allocate one.
********************************************************************
*
*/

PUBLIC OBJECT *new_bytearray( UBYTE *values, int size )
{   
   BYTEARRAY *New = (BYTEARRAY *) NULL;

   FBEGIN( printf( "new_bytearray( 0x%08LX, %d = size )\n", values, size ) );

   if (started == TRUE)
      {
      if ((New = findFreeByteArray())) // != NULL)
         goto setupNewByteArray;
      }

   New = allocByteArray();

   ca_barray++;
  
setupNewByteArray:

   size &= MMF_MAX_OBJSIZE;
   
   New->ref_count = 0;
   New->size      = MMF_INUSE_MASK | MMF_BYTEARRAY | BYTEARRAY_SIZE;
   New->bsize     = size;
   New->bytes     = allocBytes( values, size );
   New->nextLink  = 0; // NULL;

   if (ca_barray > 1)
      storeByteArray( New, &lastAllocdByteArray, &bytearrayList );

   FEND( printf( "0x%08LX = new_bytearray()\n", New ) );

   return( (OBJECT *) New );
}

/****h* free_bytearray() [1.5] *************************************
*
* NAME
*    free_bytearray()
*
* DESCRIPTION
*    Place a ByteArray on the free list or free() it.
********************************************************************
*
*/

PUBLIC void  free_bytearray( BYTEARRAY *obj )
{   
   FBEGIN( printf( "free_bytearray( BYTEARRAY * 0x%08LX )\n", obj ) );

   if (is_bytearray( (OBJECT *) obj ) == FALSE)
      {
      fprintf( stderr, "free_bytearray( 0x%08LX ) NOT a ByteArray!\n", obj );
      
      cant_happen( WRONGOBJECT_FREED );  // Die, you abomination!!
      }
      
   recycleByteArray( obj );   

   FEND( printf( "free_bytearray() exits\n" ) );

   return;
}

/* --------------------- END of Byte.c file! -------------------- */
