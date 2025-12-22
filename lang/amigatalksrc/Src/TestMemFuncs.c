/****h* AmigaTalk/TestMemFuncs.c [2.5] **********************************
*
* NAME
*    TestMemFuncs.c
*
* NOTES
*    the asm functions are in asmUtilLib.asm file.
*************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>

IMPORT __asm void *asmAllocVecPooled( register __a0 void  *PoolHeader,
                                      register __d0 ULONG  memSize
                                    );

IMPORT __asm void  asmFreeVecPooled( register __a0 void *PoolHeader,
                                     register __a1 void *memHeader
                                   );
                
PUBLIC void *makeMemoryPool( ULONG maxSize, ULONG threshold )
{
   void *PoolHeader = NULL;
   
   if (threshold > maxSize)
      return( PoolHeader );
      
   PoolHeader = CreatePool( MEMF_CLEAR | MEMF_FAST, maxSize, threshold );
   
   return( PoolHeader );   
}

PUBLIC void drainMemoryPool( void *PoolHeader )
{
   if (PoolHeader != NULL)
      DeletePool( PoolHeader );
    
   return;
}

PUBLIC void *AllocVecPooled( void *PoolHeader, ULONG memSize )
{
   return( asmAllocVecPooled( PoolHeader, memSize ) ); 
}

PUBLIC void FreeVecPooled( void *PoolHeader, void *memHeader )
{
   asmFreeVecPooled( PoolHeader, memHeader );
   
   return;
}

#define PUDDLE 0x00100000 // 1048576 Bytes
#define THRESH 0x00000100

void *myPool    = NULL;
void *myMemory1 = NULL;
void *myMemory2 = NULL;
void *myMemory3 = NULL;
void *myMemory4 = NULL;

PUBLIC int main( int argc, char **argv )
{
   ULONG fastmem = 0L;
   int   rval    = RETURN_OK;
   
   fastmem = AvailMem( MEMF_FAST ); // SAS-C Opens exec.library
   
   printf( "%s begins testing memory functions...\n\n", argv[0] );
   
   printf( "There is 0x%08LX bytes of Fast memory available!\n", fastmem );
    
   printf( "\tFirst, we create a Pool( puddleSize = 0x%08LX, threshold = %d )...\n",
            PUDDLE, THRESH 
         );
   
   myPool = makeMemoryPool( PUDDLE, THRESH );
   
   printf( "\tmakeMemoryPool() returned 0x%08LX\n", myPool );
   
   if (myPool == NULL)
      {
      rval = ERROR_NO_FREE_STORE;

      goto exitTestMemFuncs;
      }
   
   fastmem = AvailMem( MEMF_FAST );
   
   printf( "There is now 0x%08LX bytes of Fast memory available!\n", fastmem );

   printf( "\tNow, let's allocate a 512 byte chunk from the Pool...\n" );
   
   myMemory1 = AllocVecPooled( myPool, 512 );

   if (myMemory1 == NULL)
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitTestMemFuncs;
      }

   printf( "\tNow, let's allocate a 257 byte chunk from the Pool...\n" );
   
   myMemory2 = AllocVecPooled( myPool, 257 );

   if (myMemory2 == NULL)
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitTestMemFuncs;
      }

   printf( "\tNow, let's allocate a 48 byte chunk from the Pool...\n" );
   
   myMemory3 = AllocVecPooled( myPool, 48 );

   if (myMemory3 == NULL)
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitTestMemFuncs;
      }

   printf( "\tNow, let's allocate a 8192 byte chunk from the Pool...\n" );
   
   myMemory4 = AllocVecPooled( myPool, 8192 );

   if (myMemory4 == NULL)
      {
      rval = ERROR_NO_FREE_STORE;
      
      goto exitTestMemFuncs;
      }

   printf( "\tNow, let's free the 1st chunk from the Pool...\n" );
   
   FreeVecPooled( myPool, myMemory1 );
   
   printf( "\tNow, let's free the 3rd chunk from the Pool...\n" );
   
   FreeVecPooled( myPool, myMemory3 );

   printf( "\tNow, let's free the 4th chunk from the Pool...\n" );
   
   FreeVecPooled( myPool, myMemory4 );
   
exitTestMemFuncs:

   drainMemoryPool( myPool );

   fastmem = AvailMem( MEMF_FAST );
   
   printf( "There is now 0x%08LX bytes of Fast memory available!\n", fastmem );

   printf( "\t%s testing is complete!\n", argv[0] );

   return( rval );
}

/* -------------------- END of TestMemFuncs.c file! --------------------- */

