/****h* AmigaTalk/GrabMem.c [3.0] *************************************
*
* NAME 
*   GrabMem.c
*
* DESCRIPTION
*   Functions that handle <209 0> to AmigaTalk primitives.
*   Called from the Handler in WBench.c
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleGrabMem( int numargs, OBJECT **args ); <209 0>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    21-Mar-2003 - Changed GMFreeMemory() to PUBLIC visibility so that
*                  disposeHook() in UtilityLib.c can find it.
*
*    19-May-2002 - Added the GMgetField() & GMsetField() methods.
*
*    19-Feb-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/GrabMem.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#ifdef __SASC

# include <clib/intuition_protos.h>

#else

# define __USE_INLINE__

# include <proto/intuition.h>

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *SystemProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

/****i* GMallocMemory() [2.0] *****************************************
*
* NAME
*    GMallocMemory()
*
* DESCRIPTION
*    Allocate an arbitrary amount of memory.
*    ^ private <- <primitive 209 0 0 numBytes>
***********************************************************************
*
*/

METHODFUNC OBJECT *GMallocMemory( int numBytes )
{
   void   *mem  = NULL; 
   OBJECT *rval = o_nil;

   if (numBytes < 1)
      return( rval );

   // allocMemory() in CPGM:GlobalObjects/AllocStruct.o:
   mem = (void *) allocMemory( numBytes, MEMF_CLEAR | MEMF_ANY );
   
   if (!mem) // == NULL)
      return( rval );
   else
      return( new_address( (ULONG) mem ) );
}

/****i* GMallocStructure() [2.0] **************************************
*
* NAME
*    GMallocStructure()
*
* DESCRIPTION
*    Allocate an amount of memory for the given structure number.
*    ^ private <- <primitive 209 0 1 whichStruct>
***********************************************************************
*
*/

METHODFUNC OBJECT *GMallocStructure( int whichStruct )
{
   IMPORT void *allocStructure( int whichOne, int memFlags );
   
   void   *mem  = NULL; 
   OBJECT *rval = o_nil;

   if (whichStruct < 0)
      return( rval );

   // allocStructure() in CPGM:GlobalObjects/AllocStruct.o:
   mem = allocStructure( whichStruct, MEMF_CLEAR | MEMF_ANY );

   if (!mem) // == NULL)
      return( rval );
   else
      return( new_address( (ULONG) mem ) );
}

/****h* GMfreeMemory() [3.0] ******************************************
*
* NAME
*    GMfreeMemory()
*
* DESCRIPTION
*    <primitive 209 0 2 private>
***********************************************************************
*
*/

PUBLIC void GMfreeMemory( OBJECT *memPtr )
{
   void *mem = (void *) CheckObject( memPtr );

   if (mem) // != NULL)
      freeMemory( mem ); // in CPGM:GlobalObjects/AllocStruct.o
         
   return;
}

/****i* GMgetField() [2.1] ********************************************
*
* NAME
*    GMgetField()
*
* DESCRIPTION
*    <primitive 209 0 3 memoryObject byteArray offset>
***********************************************************************
*
*/

METHODFUNC void GMgetField( OBJECT *memObj, OBJECT *baObj, int offset )
{
   char   *mem   = (char *) CheckObject( memObj );
   char   *bytes =          ((BYTEARRAY *) baObj)->bytes;
   ULONG   size  = (ULONG)  ((BYTEARRAY *) baObj)->bsize;

   // It's impossible for bytes to be NULL:

   if (mem && (size > 0))
      CopyMem( (CONST APTR) &mem[ offset ], (APTR) bytes, size );

   return;          
}

/****i* GMsetField() [2.1] ********************************************
*
* NAME
*    GMsetField()
*
* DESCRIPTION
*    <primitive 209 0 4 memoryObject byteArray offset>
***********************************************************************
*
*/

METHODFUNC void GMsetField( OBJECT *memObj, OBJECT *baObj, int offset )
{
   char   *mem   = (char *) CheckObject( memObj );
   char   *bytes =          ((BYTEARRAY *) baObj)->bytes;
   ULONG   size  = (ULONG)  ((BYTEARRAY *) baObj)->bsize;

   // It's impossible for bytes to be NULL:

   if (mem && (size > 0))
      CopyMem( (CONST APTR) bytes, (APTR) &mem[ offset ], size );

   return;          
}

/****i* GMcopyString() [2.1] ******************************************
*
* NAME
*    GMcopyString()
*
* DESCRIPTION
*    <primitive 209 0 5 memoryObject aString offset>
***********************************************************************
*
*/

METHODFUNC void GMcopyString( OBJECT *memObj, char *aString, int offset )
{
   char  *mem  = (char *) CheckObject( memObj );
   ULONG  size =  (ULONG) strlen( aString );

   // It's impossible for aString to be NULL (we checked already!):

   if (mem && (size > 0))
      CopyMem( (CONST APTR) aString, (APTR) &mem[ offset ], size );

   return;          
}

/****i* GMsetPointer() [2.1] ******************************************
*
* NAME
*    GMsetPointer()
*
* DESCRIPTION
*    <primitive 209 0 6 memoryObject intObject offset>
***********************************************************************
*
*/

METHODFUNC void GMsetPointer( OBJECT *memObj, int address, int offset )
{
   ULONG *mem = (ULONG *) CheckObject( memObj );

   if (mem && (address != 0))
      mem[ offset ] = (ULONG) address; // DEBUG this!!

   return;          
}

/****i* GMgetPointer() [2.1] ******************************************
*
* NAME
*    GMgetPointer()
*
* DESCRIPTION
*    ^ <primitive 209 0 7 memoryObject offset>
***********************************************************************
*
*/

METHODFUNC OBJECT *GMgetPointer( OBJECT *memObj, int offset )
{
   ULONG *mem = (ULONG *) CheckObject( memObj );

   if (mem) // != NULL)
      return( new_address( (ULONG) mem[ offset ] ) );
}

/*
APTR AllocRemember( struct Remember **rememberKey, ULONG size, ULONG flags );
VOID FreeRemember(  struct Remember **rememberKey, LONG reallyForget );
*/
      
/****h* HandleGrabMem() [2.0] ******************************************
*
* NAME
*    HandleGrabMem() {Primitive 209 0 ??}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    GrabMem interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleGrabMem( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   // numargs--; // Not currently needed.
   
   switch (int_value( args[0] ))
      {
      case 0: // create: howMuch ^ <primitive 209 0 0 howMuch>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = GMallocMemory( int_value( args[1] ) );

         break;


      case 1: // createPrivate: whichOne ^ <primitive 209 0 1 whichOne>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = GMallocStructure( int_value( args[1] ) );           

         break;

      case 2: // disposePrivate: private <primitive 209 0 2 private>
         GMfreeMemory( args[1] );

         KillObject( args[1] );

         break;

      case 3: // getFieldFrom: memoryObject at: offset into: byteArray
              //   <primitive 209 0 3 memoryObject byteArray offset>
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            GMgetField( args[1], args[2], int_value( args[3] ) );

         break;

      case 4: // setFieldFrom: byteArray at: offset into: memoryObject
              //   <primitive 209 0 4 memoryObject byteArray offset>
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            GMsetField( args[1], args[2], int_value( args[3] ) );

         break;

      case 5: // copyStringToMem: memoryObject str: aString at: offset
              //   <primitive 209 0 5 memoryObject aString offset>
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            GMcopyString( args[1], string_value( (STRING *) args[2] ),
                                      int_value( args[3] ) 
                        );
         break;

      case 6: // setPointer: intObject in: memoryObject at: offset
              //   <primitive 209 0 6 memoryObject intObject offset>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            GMsetPointer( args[1], int_value( args[2] ), int_value( args[3] ) );

         break;

      case 7: // getPointerFrom: memoryObject at: offset
              // ^ <primitive 209 0 7 memoryObject offset>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = GMgetPointer( args[1], int_value( args[2] ) );
         
         break;

      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

/* ---------------------- END of GrabMem.c file! ----------------------- */
