/****h* AmigaTalk/ExecAlloc.c [3.0] ***********************************
*
* NAME 
*   ExecAlloc.c
*
* DESCRIPTION
*   Functions that Allocate/deallocate Exec structures.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleMoreExec( int numargs, OBJECT **args ); <209 5 ???>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    25-Mar-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/ExecAlloc.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <utility/tagitem.h>

#ifdef    __SASC

# include <clib/intuition_protos.h>
# include <clib/wb_protos.h>
# include <clib/exec_protos.h>

#else

# define __USE_INLINE__
# include <proto/wb.h>
# include <proto/exec.h>
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

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray ); // in TagFuncs.c

/****i* DeallocateExecStruct() [3.0] **********************************
*
* NAME
*    DeallocateExecStruct()
*
* DESCRIPTION
*    Deallocate various objects for the Exec primitives.
*    <primitive 209 5 0 addrObj>
***********************************************************************
*
*/

METHODFUNC void DeallocateExecStruct( OBJECT *addrObj )
{
   APTR address = (APTR) CheckObject( addrObj );
   
   if (NullChk( (OBJECT *) address ) == FALSE)
      AT_FreeVec( address, "execStruct", TRUE );
      
   return;
}

/****i* AllocateSemaphore() [3.0] *************************************
*
* NAME
*    AallocateSemaphore()
*
* DESCRIPTION
*    Allocate a signalSemaphore object for the Exec primitives.
*    <primitive 209 5 1 semaphoreName priority>
***********************************************************************
*
*/

METHODFUNC OBJECT *AllocateSemaphore( char *semName, int pri )
{
   struct SignalSemaphore *ss = NULL;
   
   ss = (struct SignalSemaphore *) AT_AllocVec( sizeof( struct SignalSemaphore ),
                                                MEMF_CLEAR | MEMF_ANY, 
                                                "execSema", TRUE 
                                              );

   if (ss) // != NULL)
      {
      ss->ss_Link.ln_Name = semName;
      ss->ss_Link.ln_Pri  = pri;
      
      return( new_int( (int) ss ) );
      }
   else
      return( o_nil );
}

/****i* AllocateSemaphoreMsg() [3.0] **********************************
*
* NAME
*    AallocateSemaphoreMsg()
*
* DESCRIPTION
*    Allocate a SemaphoreMessage object for the Exec primitives.
*    <primitive 209 5 2 signalSemaphoreObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *AllocateSemaphoreMsg( OBJECT *ssmObj )
{
   struct SignalSemaphore  *ss = (struct SignalSemaphore  *) CheckObject( ssmObj );
   struct SemaphoreMessage *sm = (struct SemaphoreMessage *) NULL;

   sm = (struct SemaphoreMessage *) AT_AllocVec( sizeof( struct SemaphoreMessage ),
                                                 MEMF_CLEAR | MEMF_ANY, 
                                                 "execSema", TRUE 
                                               );
   if (sm) // != NULL)
      {
      if (ss) // != NULL)
         sm->ssm_Semaphore = ss;
      
      return( new_address( (ULONG) sm ) );
      }
   else
      return( o_nil );
}

/****i* HandleMoreExec() [3.0] ****************************************
*
* NAME
*    HandleMoreExec()
*
* DESCRIPTION
*    Allocate/Deallocate various objects for the Exec primitives.
*    ^ <primitive 209 5 xx ??>
***********************************************************************
*
*/

PUBLIC OBJECT *HandleMoreExec( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // <209 5 0 address>
         DeallocateExecStruct( args[1] );
         
//         KillObject( args[1] );

         break;

      case 1: // ^ <209 5 1 semaphoreName pri>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = AllocateSemaphore( string_value( (STRING *) args[1] ),
                                         int_value( args[2] ) 
                                    );
         break;
         
      case 2: // <209 5 2 signalSemaphoreObj>
         rval = AllocateSemaphoreMsg( args[1] );
         break;
      
      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}
