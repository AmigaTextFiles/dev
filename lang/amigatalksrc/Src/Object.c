/****h* AmigaTalk/Object.c [3.0] *********************************
*
* NAME
*   Object.c Little Smalltalk object memory management
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08_Dec-2003 - Added setRefCount() & setObjSize() functions.
*
*    11-Nov-2003 - Cleaned out old commented out code.
*
*    01-Nov-2003 - Added recycleList et. al. to speed up searches
*                  for free slots.
*
*    19-Oct-2003 - Fixed a bug in free_obj().
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*   $VER: Object.c 3.0 (25-Oct-2004) by J.T. Steichen
******************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include "ATStructs.h"

#include "object.h"
#include "drive.h"
#include "file.h"
#include "FuncProtos.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT OBJECT *o_acollection;
IMPORT CLASS  *ArrayedCollection;

// Located in Global.c, where all good globals should be:

IMPORT int started;
IMPORT int n_incs;      // number of increments counter
IMPORT int n_decs;      // number of decrements counter (should be equal)
IMPORT int n_mallocs;   // number of mallocs counter
IMPORT int ca_obj;      // count the # of allocations made
IMPORT int ca_objTotal; // count the size of allocations made
IMPORT int ca_cobj[5];  // count how many alloc's for small vals

IMPORT OBJECT *o_object, *o_magnitude, *o_number;

IMPORT char outmsg[];

IMPORT ULONG ObjectTableSize; // ToolType in Tools.c

// -------------------------------------------------------------------

/****h* setRefCount() [3.0] ******************************************
*
* NAME
*    setRefCount()
*
* DESCRIPTION
*    Initialize the reference count field of the Object.
**********************************************************************
*
*/

PUBLIC void setRefCount( OBJECT *obj, int newCount )
{
   if (obj && newCount >= 0)
      obj->ref_count = newCount;

   return;
}

/****h* setObjSize() [3.0] *******************************************
*
* NAME
*    setObjSize()
*
* DESCRIPTION
*    Initialize the size field of the Object.
**********************************************************************
*
*/

PUBLIC void setObjSize( OBJECT *obj, ULONG newSize )
{
   if (obj) // != NULL)
      obj->size = newSize;

   return;
}

/****h* objRefCount() [3.0] ******************************************
*
* NAME
*    objRefCount()
*
* DESCRIPTION
*    Reply with only the reference_count of the Object.
**********************************************************************
*
*/

PUBLIC int objRefCount( OBJECT *obj )
{
   if (obj) // != NULL)
      return( obj->ref_count );
   else
      return( 0 );
}

/****h* objSize() [3.0] **********************************************
*
* NAME
*    objSize()
*
* DESCRIPTION
*    Reply with only the size of the Object.
**********************************************************************
*
*/

PUBLIC int objSize( OBJECT *obj )
{
   if (obj) // != NULL)
      return( obj->size & MMF_MAX_OBJSIZE );
   else
      return( 0 );
}

/****h* objType() [3.0] **********************************************
*
* NAME
*    objType()
*
* DESCRIPTION
*    Reply with only the Type of the Object.
**********************************************************************
*
*/

PUBLIC int objType( OBJECT *obj )
{
   if (obj) // != NULL)
      return( obj->size & MMF_BUILTIN_MASK );
   else
      return( 0 );
}     

/****h* objIsFree() [3.0] ********************************************
*
* NAME
*    objIsFree()
*
* DESCRIPTION
*    Reply with only the State of the Object.
**********************************************************************
*
*/

PUBLIC BOOL objIsFree( OBJECT *obj )
{
   if (obj->size & MMF_INUSE_MASK == MMF_INUSE_MASK)
      return( FALSE );
   else
      return( TRUE );
}

/****h* nextObject() [3.0] *******************************************
*
* NAME
*    nextObject()
*
* DESCRIPTION
*    Reply with the next Object in the linked list.
**********************************************************************
*
*/

PUBLIC OBJECT *nextObject( OBJECT *obj )
{
   if (obj->nextLink) // != NULL)
      return( obj->nextLink );
   else
      return( o_nil );
}      

/****h* objClass() [3.0] *********************************************
*
* NAME
*    objClass()
*
* DESCRIPTION
*    Reply with the Class of the Object.
**********************************************************************
*
*/

PUBLIC CLASS *objClass( OBJECT *obj )
{
   CLASS *rval = NULL;

   if (obj->Class) // != NULL)
      rval = (CLASS *) obj->Class;
   else
      rval = (CLASS *) o_nil;
   
   return( rval );
}
     

/****h* obj_inc() [1.7] **********************************************
*
* NAME
*    obj_inc()
*
* DESCRIPTION
*    Increment an object (usually expanded in-line)
**********************************************************************
*
*/

PUBLIC int obj_inc( register OBJECT *x ) 
{
   if (x) // != NULL)
      {
      x->ref_count++;
      n_incs++;

      return( x->ref_count ); // Always > 0.
      }
   else
      {
      fprintf( stderr, "obj_inc() given a NULL pointer!\n" );

      cant_happen( CH_NULL_POINTER ); // Die, you abomination!

      return( -1 );                   // Unreachable.
      }
}

// -----------------------------------------------------------------

PRIVATE OBJECT *freeObject( OBJECT *obj )
{
   FBEGIN( printf( "freeObject( 0x%08LX )\n", obj ) );

   if (obj->super_obj) // != NULL)
      {
      // Check for infinite recursive condition:
      if (obj->super_obj != obj)
         (void) obj_dec( obj->super_obj ); // Tell Parent child is dead.
      }

   free_obj( obj, TRUE );

   FEND( printf( "freeObject() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeClass( OBJECT *obj )
{
   FBEGIN( printf( "freeClass( 0x%08LX )\n", obj ) );

   free_class( (CLASS *) obj ); 

   FEND( printf( "freeClass() exits \n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeByteArray( OBJECT *obj )
{
   FBEGIN( printf( "freeByteArray( 0x%08LX )\n", obj ) );

   free_bytearray( (BYTEARRAY *) obj ); 

   FEND( printf( "freeByteArray() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeSymbol( OBJECT *obj )
{
   FBEGIN( printf( "freeSymbol( 0x%08LX )\n", obj ) );

   obj->ref_count = 20; // Reset ref_count

   FEND( printf( "freeSymbol() exits\n" ) );

   return( obj );
}

PRIVATE OBJECT *freeInterp( OBJECT *obj )
{
   FBEGIN( printf( "freeInterp( 0x%08LX )\n", obj ) );

   free_terpreter( (INTERPRETER *) obj ); 

   FEND( printf( "freeInterp() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeProcess( OBJECT *obj )
{
   FBEGIN( printf( "freeProcess( 0x%08LX )\n", obj ) );

   free_process( (PROCESS *) obj );

   FEND( printf( "freeProcess() exits\n" ) );    

   return( o_nil );
}

PRIVATE OBJECT *freeBlock( OBJECT *obj )
{
   FBEGIN( printf( "freeBlock( 0x%08LX )\n", obj ) );

   free_block( (BLOCK *) obj ); 

   FEND( printf( "freeBlock() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeFile( OBJECT *obj )
{
   FBEGIN( printf( "freeFile( 0x%08LX )\n", obj ) );

   free_file( (AT_FILE *) obj );

   FEND( printf( "freeFile() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeChar( OBJECT *obj )
{
   FBEGIN( printf( "freeChar( 0x%08LX )\n", obj ) );

   obj->ref_count = 2; // Do NOT free Chars!

   FEND( printf( "freeChar() exits\n" ) );

   return( obj );
}

PRIVATE OBJECT *freeInteger( OBJECT *obj )
{
   FBEGIN( printf( "freeInteger( 0x%08LX )\n", obj ) );

   free_integer( (INTEGER *) obj ); 

   FEND( printf( "freeInteger() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeString( OBJECT *obj )
{
   FBEGIN( printf( "freeString( 0x%08LX )\n", obj ) );

   free_string( (STRING *) obj ); 

   FEND( printf( "freeString() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeFloat( OBJECT *obj )
{
   FBEGIN( printf( "freeFloat( 0x%08LX )\n", obj ) );

   free_float( (SFLOAT *) obj ); 

   FEND( printf( "freeFloat() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeClassSpec( OBJECT *obj )
{
   FBEGIN( printf( "freeClassSpec( 0x%08LX )\n", obj ) );

   if (obj->super_obj) // != NULL)
      {
      // Check for infinite recursive condition:
      if (obj->super_obj != obj)
         (void) obj_dec( obj->super_obj ); // Tell Parent child is dead.
      }
               
   free_obj( obj, FALSE ); // Debug this!! 

   FEND( printf( "freeClassSpec() exits\n" ) );

   return( o_nil );
}

PRIVATE OBJECT *freeClassEntry( OBJECT *obj )
{
   FBEGIN( printf( "freeClassEntry( 0x%08LX ) [No-OP]\n", obj ) );

   return( o_nil );
}

PRIVATE OBJECT *freeSDict( OBJECT *obj )
{
   FBEGIN( printf( "freeSDict( 0x%08LX ) [No-OP]\n", obj ) );

   return( o_nil );
}

PRIVATE OBJECT *freeAddress( OBJECT *obj )
{
   FBEGIN( printf( "freeAddress( 0x%08LX )\n", obj ) );

   free_address( (AT_ADDRESS *) obj );
   
   return( o_nil );
}

PRIVATE ULONG releasors[] = {

   (ULONG) &freeObject,    (ULONG) &freeClass,      (ULONG) &freeByteArray, (ULONG) &freeSymbol,
   (ULONG) &freeInterp,    (ULONG) &freeProcess,    (ULONG) &freeBlock,     (ULONG) &freeFile,
   (ULONG) &freeChar,      (ULONG) &freeInteger,    (ULONG) &freeString,    (ULONG) &freeFloat,
   (ULONG) &freeClassSpec, (ULONG) &freeClassEntry, (ULONG) &freeSDict,     (ULONG) &freeAddress
};

/****h* throwAwayObject() [3.0] **************************************
*
* NAME
*    throwAwayObject()
*
* DESCRIPTION
*    Called by obj_dec() only.
**********************************************************************
*
*/

SUBFUNC void throwAwayObject( OBJECT *x )
{
   FBEGIN( printf( "throwAwayObject( 0x%08LX )\n", x ));

   (void) ObjActionByType( x, (OBJECT * (**)( OBJECT *)) releasors );
   
   FEND( printf( "throwAwayObject() exits\n" ) );

   return;
}

/****h* obj_dec() [3.0] **********************************************
*
* NAME
*    obj_dec()
*
* DESCRIPTION
*    Decrement an object.
*
* SEE ALSO
*    free_obj() & throwAwayObject() above.
**********************************************************************
*
*/

PUBLIC int obj_dec( OBJECT *x ) 
{
   if (x) // != NULL)
      {
      n_decs++;

      if ((x->ref_count - 1) > 0) 
         {
         --x->ref_count;   

         return( x->ref_count );
         }
      else if (x->ref_count < 0) 
         {
         sprintf( outmsg, ObjCMsg( MSG_O_REFCOUNT_ERR_OBJ ), x->ref_count, x );

         APrint( outmsg );

          x->ref_count = 0;

         primitive( REFCOUNTERROR, 1, &x );
         }
      else if ((x->ref_count - 1) == 0)
         {
         x->ref_count = 0;

         return( 0 );
         }
      else if (x->ref_count == 0)
         {
         throwAwayObject( x );

         return( 0 );
         }
      }
   else
      {
      fprintf( stderr, "obj_dec() given a NULL Pointer!\n" );

      cant_happen( CH_NULL_POINTER ); // Die, you abomination!

      return( -1 );   
      }

   return( x->ref_count );
}

PRIVATE void   *objectPoolHeader    = NULL; // New PoolMemory system

//PRIVATE OBJECT *lastRecycledObject  = NULL;
PRIVATE OBJECT *recycleObjectList   = NULL;

PRIVATE OBJECT *lastAllocdObject    = NULL;
PRIVATE OBJECT *objectList          = NULL;

PRIVATE ULONG   AllocatedObjectSize = 0L;

// -------------------------------------------------------------------

/****i* makeObjectPool() [3.0] ************************************
*
* NAME
*    makeObjectPool()
*
* DESCRIPTION
*    Allocate a Memory Pool of the given size.  If size is zero,
*    allocate a default-sized Memory Pool.
*******************************************************************
*
*/

SUBFUNC void *makeObjectPool( ULONG poolSize )
{
   void *rval = NULL;

   FBEGIN( printf( "makeObjectPool( size = %d )\n", poolSize ) );

   if (poolSize == 0)   
      {
      if ((ObjectTableSize % BASIC_OVERHEAD) != 0)
         {
         // Round ObjectTableSize to even BASIC_OVERHEAD:
         int number = ObjectTableSize / BASIC_OVERHEAD + 1;

         if (number < (MIN_OBJTABLE_SIZE / ((BASIC_OVERHEAD + 2) * sizeof( ULONG ))))
            number = MIN_OBJTABLE_SIZE / ((BASIC_OVERHEAD + 2) * sizeof( ULONG ));
                     
         ObjectTableSize = number * (BASIC_OVERHEAD + 2) * sizeof( ULONG );
         }
         
      if ((rval = AT_AllocVec( (ULONG) ObjectTableSize, 
                               MEMF_CLEAR | MEMF_FAST, 
                               "objectPoolHeader", TRUE ))) // != NULL)
         {
         AllocatedObjectSize = ObjectTableSize;
         }
      }
   else
      {
      if ((poolSize % BASIC_OVERHEAD) != 0)
         {
         // Round poolSize to even BASIC_OVERHEAD:
         int number = poolSize / BASIC_OVERHEAD + 1;
         
         if (number < (MIN_OBJTABLE_SIZE / ((BASIC_OVERHEAD + 2) * sizeof( ULONG ))))
            number = MIN_OBJTABLE_SIZE / ((BASIC_OVERHEAD + 2) * sizeof( ULONG ));

         poolSize = number * (BASIC_OVERHEAD + 2) * sizeof( ULONG );
         }
         
      if ((rval = AT_AllocVec( poolSize, MEMF_CLEAR | MEMF_FAST, 
                               "objectPoolHeader", TRUE ))) // != NULL)
         {
         AllocatedObjectSize = poolSize;
         }
      }

   FEND( printf( "0x%08LX = makeObjectPool()\n", rval ) );      

   return( rval );
}

/****h* allocObjectPool() [3.0] ***********************************
*
* NAME
*    allocObjectPool()
*
* DESCRIPTION
*    Allocate the Object PoolHeader for SmallTalk().
*******************************************************************
*
*/

PUBLIC void *allocObjectPool( ULONG poolSize ) // Visible to SmallTalk()
{
   void *rval = objectPoolHeader;

   FBEGIN( printf( "allocObjectPool( size = %d )\n", poolSize ) );   

   if (objectPoolHeader) // != NULL)
      goto exitAlloc;
   
   if ((objectPoolHeader = makeObjectPool( poolSize ))) // != NULL)
      rval = objectList = objectPoolHeader;

exitAlloc:

   FEND( printf( "0x%08LX = allocObjectPool()\n", rval ) );   

   return( rval );
}

/****i* storeObject() [3.0] ***************************************
*
* NAME
*    storeObject()
*
* DESCRIPTION
*    Add Object p to the objectList.
*******************************************************************
*
*/

SUBFUNC void storeObject( OBJECT *p, OBJECT **last, OBJECT **list )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = p;
      *list = p;
      }
   else
      {
      (*last)->nextLink = p;
      }

   p->nextLink = NULL;

   *last = p; // Update the end of the List.
   
   return;       
}

/****i* allocObject() [3.0] ***************************************
*
* NAME
*    allocObject()
*
* DESCRIPTION
*    Allocate the Object structure space.
*    the size argument already has BASIC_OVERHEAD added in.
*******************************************************************
*
*/

SUBFUNC OBJECT *allocObject( int size )
{
   OBJECT *New   = NULL;
   int     tSize = size * sizeof( ULONG );

   FBEGIN( printf( "allocObject( %d )\n", size ) );

   if ((ca_objTotal + tSize) > AllocatedObjectSize)
      {
      // We're going to exceed the Pool size, so die instead:
      fprintf( stderr, "Ran out of memory in allocObject()!\n" );

      MemoryOut( "allocObject()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      }
      
   if (!lastAllocdObject) // == NULL)
      {
      // the first Object to get created:
      New           = objectList;
      New->nextLink = NULL;
      
      lastAllocdObject = New;
      }
   else
      {
      char   *ptr  = NULL;
      OBJECT *prev = lastAllocdObject; // objectList;
      
      while (prev->nextLink) // != NULL)
         prev = prev->nextLink; // Find the end of the list.

      ptr  = (char *) prev;     // Only (char *) behaves with arithmetic

      // Convert to # of ULONGs & point to next free ULONG:
      ptr += ((objSize( prev ) + BASIC_OVERHEAD) * sizeof( ULONG ));
      
      New = (OBJECT *) ptr;
      
      storeObject( New, &lastAllocdObject, &objectList );
      }      

   ca_objTotal += tSize;

   FEND( printf( "0x%08LX = allocObject()\n", New ) );

   return( New );
}

/****i* freeDeadObjects() [3.0] ************************************
*
* NAME
*    freeDeadObjects()
*
* DESCRIPTION
*    Just count the free space.
********************************************************************
*
*/

PRIVATE int freeDeadObjects( OBJECT **recycledList, OBJECT **last )
{
   OBJECT *p       = *recycledList;
   OBJECT *next    =  NULL;
   int     howMany =  0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      if (p->size & MMF_INUSE_MASK == 0)      
         howMany += (objSize( p ) + BASIC_OVERHEAD);
         
      p = next;
      }

   return( howMany );
}

/****i* removeFromList() [3.0] ************************************
*
* NAME
*    removeFromList()
*
* DESCRIPTION
*    Remove the Object from the given list & update the pointers.
*******************************************************************
*
*/

SUBFUNC void removeFromList( OBJECT *killMe, OBJECT **list, OBJECT **last )
{
   OBJECT *prev = *list;
   OBJECT *next =  killMe->nextLink;

   if (killMe == prev)
      {
      *list = next;
      
      return;
      }

   while (prev->nextLink != killMe && prev->nextLink != NULL)
      prev = prev->nextLink;       // Find the previous item.

   if (killMe == *last && prev) // != NULL)
      {
      *last           = prev; // Chop off the tail.
       prev->nextLink = NULL;
      }
   else
      prev->nextLink = next; // Disconnect killMe from the list.

   return;
}

/****i* findFreeObject() [3.0] ************************************
*
* NAME
*    findFreeObject()
*
* DESCRIPTION
*    See if there's an available Object structure already
*    waiting for us.  If so, remove it from the recycleList.
*******************************************************************
*
*/

SUBFUNC OBJECT *findFreeObject( int sizeDesired )
{
   OBJECT *p = NULL;

   FBEGIN( printf( "findFreeObject( size = %d )\n", sizeDesired ) );

   if (!recycleObjectList) // == NULL)
      goto exitFinder;
         
   for (p = recycleObjectList; p != NULL; p = p->nextLink)
      {
      if (p->size & MMF_INUSE_MASK == 0)
         {
         if ((p->size & MMF_MAX_OBJSIZE) == sizeDesired)
            {
//            removeFromList( p, &recycleObjectList, &lastRecycledObject );
         
            break;
            }
         }
      }

exitFinder:

   FEND( printf( "0x%08LX = findFreeObject()\n", p ) );   

   return( p );
}

/****i* recycleObject() [3.0] *************************************
*
* NAME
*    recycleObject()
*
* DESCRIPTION
*    Remove the Object from the objectList, then place it on the 
*    recycleList.
*******************************************************************
*
*/

PRIVATE BOOL firstObjectRecycle = TRUE;

PUBLIC void recycleObject( OBJECT *killMe )
{
   int i = 0;
   
//   removeFromList( killMe, &objectList, &lastAllocdObject );
      
   killMe->size &= MMF_MAX_OBJSIZE; // Clears MMF_INUSE bit.
   
   for (i = 0; i < objSize( killMe ); i++)
      killMe->inst_var[i] = NULL;   // Throw out the trash!

   killMe->ref_count = 0;
   killMe->Class     = NULL;
   killMe->super_obj = NULL;         
   killMe->reserved  = NULL;

   if (firstObjectRecycle == TRUE)
      {
      recycleObjectList  = killMe;
      firstObjectRecycle = FALSE;
      }   

//   storeObject( killMe, &lastRecycledObject, &recycleObjectList );
      
   return;
}

/****h* freeVecAllObjects() [3.0] ************************************
*
* NAME
*    freeVecAllObjects()
*
* DESCRIPTION
*    Help ShutDown() to free up used memory space.
**********************************************************************
*
*/

PUBLIC void freeVecAllObjects( void )
{
   AT_FreeVec( objectPoolHeader, "objectPoolHeader", TRUE );

   objectPoolHeader = NULL;

   return;
}

/****h* freeSlackObjectMemory() [3.0] ********************************
*
* NAME
*    freeSlackObjectMemory()
*
* DESCRIPTION
*    Get rid of ALL unused Objects in the recycleObjectList only!
**********************************************************************
*
*/

PUBLIC int freeSlackObjectMemory( void )
{
   return( freeDeadObjects( &recycleObjectList, NULL ) ); // &lastRecycledObject ));
}

/****h* init_objs() [1.7] ********************************************
*
* NAME
*    init_objs()
*
* DESCRIPTION
*    Initialize the OBJECT memory management module.  This function
*    is only called once in the startup code (SmallTalk()).
**********************************************************************
*
*/

PUBLIC int init_objs( void )
{
   return( 0 );
}

/****h* new_obj() [1.7] **********************************************
*
* NAME
*    new_obj()
*
* DESCRIPTION
*    Create a new non-special object
**********************************************************************
*
*/

PUBLIC OBJECT *new_obj( CLASS *nclass, int nsize, int initIVars )
{
   OBJECT *New      = NULL;
   int     i        = 0;
   int     numIVars = nsize & MMF_MAX_OBJSIZE;
   int     newSize  = numIVars + BASIC_OVERHEAD;

   FBEGIN( printf( "new_obj( 0x%08LX, size = %d, BOOL init = %d )\n", nclass, nsize, initIVars ) );      

   if (nsize < 0)
      {
      fprintf( stderr, "size < 0 for new_obj( 0x%08LX )\n", nsize );

      cant_happen( ARRAYSIZE_ERR ); // Die, you abomination!
      }

   if (started == TRUE)
      {
      if ((New = findFreeObject( newSize ))) // != NULL)
         goto setupNewObject;
      }

   New = allocObject( newSize ); // BASIC_OVERHEAD is added in here.

   ca_obj++;
            
setupNewObject:
         
   New->ref_count = 0;
   New->size      = MMF_INUSE_MASK | nsize; // (newSize - BASIC_OVERHEAD);
   New->Class     = nclass;
   New->super_obj = NULL;

   if (nclass) // != NULL)
      (void) obj_inc( (OBJECT *) New->Class );

   if (initIVars != FALSE)
      {
      for (i = 0; i < numIVars; i++) // (newSize - BASIC_OVERHEAD); i++)
         {
         New->inst_var[ i ] = AssignObj( o_nil );
         }
      }

   FEND( printf( "0x%08LX = new_obj()\n", New ) );   

   return( New );
}

/****h* free_obj() [3.0] *********************************************
*
* NAME
*    free_obj()
*
* DESCRIPTION
*    Free a non-special object
*
* HISTORY
*    19-Oct-2003 - Fixed a potential infinite loop inside the for()
*                  loop.
* SEE ALSO
*    obj_dec()
**********************************************************************
*
*/

PUBLIC int free_obj( register OBJECT *obj, BOOL dofree )
{
   int i, size = 0;

   FBEGIN( printf( "free_obj( 0x%08LX, BOOL doFree = %d )\n", obj, dofree ) );   

   if (!obj) // == NULL)
      return( 0 );
      
   size = objSize( obj );

   if (dofree != FALSE)  // Throw out all instance variables also:
      {
      for (i = 0; i < size; i++)
         {
         // If an Object's instance variable references the Object,
         // we'll get into an infinite recursive loop, so only decrement the
         // Object's instance variable if it DOES NOT point to itself: 

         if ((OBJECT *) obj->inst_var[i] != obj && obj->inst_var[i] != NULL)
            (void) obj_dec( (OBJECT *) obj->inst_var[i] );

         // ref_count = 0, then place on free list:

         if (objRefCount( (OBJECT *) obj->inst_var[i] ) == 0)
            {
            OBJECT *sub = obj->inst_var[i];

            if (sub) // != NULL)
               {
               if (sub->Class) // != NULL)
                  (void) obj_dec( (OBJECT *) sub->Class );

               if ((sub->size & MMF_INUSE_MASK) == MMF_INUSE_MASK) 
                  recycleObject( sub );
               }
            }
         }
      }

   if (obj->Class) // != NULL)
      (void) obj_dec( (OBJECT *) obj->Class );

   if ((obj->size & MMF_INUSE_MASK) == MMF_INUSE_MASK) 
      recycleObject( obj );

   FEND( printf( "free_obj() exits\n" ) );

   return( 0 );
}

/****h* o_alloc() [1.7] **********************************************
*
* NAME
*    o_alloc()
*
* DESCRIPTION
*    Allocate a block of memory for a new Object, checking for 
*    end of memory (NULL).
**********************************************************************
*
*/

PUBLIC char *o_alloc( unsigned int n )
{
   char *p = NULL;

   p = (char *) allocObject( n );
    
   if (!p) // == NULL) 
      {
      fprintf( stderr, "o_alloc( %d ) found a NULL Pointer!\n", n );
      
      cant_happen( NO_MEMORY );   // Out of memory, die you abomination!!
      }

   n_mallocs++;

   return( p );
}

/****h* AmigaTalk/structalloc() [1.0] ******************************
*
* NAME
*    structalloc()
*
* DESCRIPTION
*    Calls o_alloc to allocate a block of memory 
*    for an Internal structure and the programmer will cast the
*    returned pointer to the appropriate type
********************************************************************
* 
*/

PUBLIC void *structalloc( int obj_size )
{
   return( (void *) o_alloc( obj_size ) );
}

/****h* AssignObj() [1.7] ********************************************
*
* NAME
*    (OBJECT *) variable = AssignObj( OBJECT *value );
*
* DESCRIPTION
*    Used wherever a variable gets a value assigned to it:
**********************************************************************
*
*/

PUBLIC OBJECT *AssignObj( OBJECT *value )
{
   (void) obj_inc( value ); // make reference count > 0.

   return( value );
}

// -------------------------------------------------------------------

SUBFUNC OBJECT *findObjSuper( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = findObjSuper( 0x%08LX )\n", obj->super_obj, obj ) );

   return( obj->super_obj );
}

SUBFUNC OBJECT *findObjClass( OBJECT *obj )
{
   FBEGIN( printf( "o_object = 0x%08LX = findObjClass( 0x%08LX )\n", o_object, obj ) );

   return( o_object );
}

SUBFUNC OBJECT *findObjByteArray( OBJECT *obj )
{
   if (started == TRUE)
      {
      FBEGIN( printf( "ArrayedCollection = 0x%08LX = findObjByteArray( 0x%08LX )\n", ArrayedCollection, obj ) );
      return( (OBJECT *) ArrayedCollection );
      }
   else
      {
      FBEGIN( printf( "o_acollection = 0x%08LX = findObjByteArray( 0x%08LX )\n", o_acollection, obj ) );
      return( o_acollection );
      }
}

SUBFUNC OBJECT *findObjSymbol( OBJECT *obj )
{
   FBEGIN( printf( "o_object = 0x%08LX = findObjSymbol( 0x%08LX )\n", o_object, obj ) );

   return( o_object );
}

SUBFUNC OBJECT *findObjInterp( OBJECT *obj )
{
   FBEGIN( printf( "o_object = 0x%08LX = findObjInterp( 0x%08LX )\n", o_object, obj ) );

   return( o_object );
}

SUBFUNC OBJECT *findObjProcess( OBJECT *obj )
{
   FBEGIN( printf( "o_object = 0x%08LX = findObjProcess( 0x%08LX )\n", o_object, obj ) );

   return( o_object );
}

SUBFUNC OBJECT *findObjBlock( OBJECT *obj )
{
   FBEGIN( printf( "o_object = 0x%08LX = findObjBlock( 0x%08LX )\n", o_object, obj ) );

   return( o_object );
}

SUBFUNC OBJECT *findObjFile( OBJECT *obj )
{
   FBEGIN( printf( "o_object = 0x%08LX = findObjFile( 0x%08LX )\n", o_object, obj ) );

   return( o_object );
}

SUBFUNC OBJECT *findObjChar( OBJECT *obj )
{
   FBEGIN( printf( "o_magnitude = 0x%08LX = findObjChar( 0x%08LX )\n", o_magnitude, obj ) );

   return( o_magnitude );
}

SUBFUNC OBJECT *findObjInteger( OBJECT *obj )
{
   FBEGIN( printf( "o_number = 0x%08LX = findObjInteger( 0x%08LX )\n", o_number, obj ) );

   return( o_number );
}

SUBFUNC OBJECT *findObjString( OBJECT *obj )
{
   FBEGIN( printf( "0x%08LX = findObjString( 0x%08LX )\n", ((STRING *) obj)->super_obj, obj));

   return( ((STRING *) obj)->super_obj );
}

SUBFUNC OBJECT *findObjFloat( OBJECT *obj )
{
   FBEGIN( printf( "o_number = 0x%08LX = findObjFloat( 0x%08LX )\n", o_number, obj ) );

   return( o_number );
}

SUBFUNC OBJECT *findObjClassSpec( OBJECT *obj )
{
   FBEGIN( printf( "o_nil = 0x%08LX = findObjClassSpec( 0x%08LX )\n", o_nil, obj ) );

   return( o_nil );
}

SUBFUNC OBJECT *findObjClassEntry( OBJECT *obj )
{
   FBEGIN( printf( "o_nil = 0x%08LX = findObjClassEntry( 0x%08LX )\n", o_nil, obj ) );

   return( o_nil );
}

SUBFUNC OBJECT *findObjSDict( OBJECT *obj )
{
   FBEGIN( printf( "o_nil = 0x%08LX = findObjSDict( 0x%08LX )\n", o_nil, obj ) );

   return( o_nil );
}

/****i* findObjAddress() [2.6] ***************************************
*
* NAME
*    findObjAddress()
*
* DESCRIPTION
*    Since Addresses are Internal objects only, we tell AmigaTalk 
*    that it's trying to find the superClass of an Integer Object.
**********************************************************************
*
*/

SUBFUNC OBJECT *findObjAddress( OBJECT *obj )
{
   FBEGIN( printf( "o_number = 0x%08LX = findObjAddress( 0x%08LX )\n", o_number, obj ) );

   return( o_number ); // superClass of Integer!
}

PRIVATE ULONG finders[] = {

   (ULONG) &findObjSuper,     (ULONG) &findObjClass,      (ULONG) &findObjByteArray, (ULONG) &findObjSymbol,
   (ULONG) &findObjInterp,    (ULONG) &findObjProcess,    (ULONG) &findObjBlock,     (ULONG) &findObjFile,
   (ULONG) &findObjChar,      (ULONG) &findObjInteger,    (ULONG) &findObjString,    (ULONG) &findObjFloat,
   (ULONG) &findObjClassSpec, (ULONG) &findObjClassEntry, (ULONG) &findObjSDict,     (ULONG) &findObjAddress
};

/****h* fnd_super() [1.7] ********************************************
*
* NAME
*    fnd_super()
*
* DESCRIPTION
*    Produce a super-object for a special object
**********************************************************************
*
*/

PUBLIC OBJECT *fnd_super( OBJECT *anObject )
{
   OBJECT *rval = NULL;
   
   FBEGIN( printf( "fnd_super( 0x%08LX )\n", anObject ) );

   rval = ObjActionByType( anObject, (OBJECT * (**)( OBJECT * )) finders );

   FEND( printf( "0x%08LX = fnd_super()\n", rval ) );

   return( rval );
}

/* ------------------ END of Object.c file! -------------------------- */
