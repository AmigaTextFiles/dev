/****h* AmigaTalk/Interp.c [3.0] *************************************
*
* NAME
*    Interp.c
*
* DESCRIPTION
*    Little Smalltalk bytecode interpreter.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    22-Nov-2003 - Change the structure of Interpreter to include
*                  a stack array[ STACK_MAX ] of ULONGs at the
*                  tail of the structure.  push(), popstack() &
*                  cr_interpreter() were changed to reflect this.
*
*    09-Nov-2003 - Set up for memory management support.
*
*    03-Nov-2003 - Changed amigatalk back to a pseudo-variable.
*
*    04-Sep-2003 - Added FileClose MSG_PRMS_ string.
*
*    03-Feb-2003 - Added a new ByteCode (0xFD) to the interpreter,
*                  which turns tracing activity on or off.
*                  There is room for up to 253 other values for this
*                  opcode to control special features of AmigaTalk
*                  as they become necessary.
* 
*    27-Jan-2003 - Moved PrimStrs into CatalogInterp() function.
*
*    09-Jan-2003 - Moved all string constants to StringConstants.h
*    29-Mar-2002 - Moved the primitive 143 code out of resume() &
*                  placed it in primitive143() (V2.1).
*
*    12-Jan-2002 - Added the Translate() function.
*
* NOTES
*    $VER: AmigaTalk:Src/Interp.c 3.0 (25-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "object.h"
#include "drive.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#define     USE_NEWCODE
# define    INTERP_C
#  include  "cmds.h"
# undef     INTERP_C
#undef      USE_NEWCODE

#ifndef    AMIGATALKSTRUCTS_H
# include "ATStructs.h"
#endif

#include "FuncProtos.h"
#include "CantHappen.h"

IMPORT PROCESS  *runningProcess;
IMPORT OBJECT   *o_drive;
IMPORT OBJECT   *o_smalltalk;   /* value of pseudo variable smalltalk */

IMPORT int    started;
IMPORT int    ca_terp;          // cntr for interp' alloc's in Global.c
IMPORT UBYTE *ErrMsg;

IMPORT FILE *TraceFile;
IMPORT BOOL  traceByteCodes;
IMPORT int   TraceIndent;

#define TRACE_ON  1
#define TRACE_OFF 0

IMPORT ULONG InterpreterTableSize; // ToolType in Tools.c

PUBLIC char *PrimStrings[ 257 ] = { NULL, }; // Visible to CatalogInterp();

PRIVATE void *interpPoolHeader = NULL;

//PRIVATE INTERPRETER *lastRecycledInterpreter = NULL;
PRIVATE INTERPRETER *recycleInterpreterList  = NULL;

PRIVATE INTERPRETER *lastAllocdInterpreter   = NULL;
PRIVATE INTERPRETER *interpreterList         = NULL;

PRIVATE ULONG        AllocatedInterpSize     = 0L;

// -----------------------------------------------------------------

/****i* makeInterpPool() [3.0] *************************************
*
* NAME
*    makeInterpPool()
*
* DESCRIPTION
*    Allocate a Memory Pool of the given size.  If size is zero,
*    allocate a default-sized Memory Pool.
********************************************************************
*/

SUBFUNC void *makeInterpPool( ULONG poolSize )
{
   void *rval = NULL;

   FBEGIN( printf( "makeInterpPool( size = %d )\n", poolSize ) );

   if (poolSize == 0)   
      {
      if ((InterpreterTableSize % INTERPRETER_SIZE) != 0)
         {
         // Round InterpreterTabeSize to even BYTEARRAY_SIZE:
         int number = InterpreterTableSize / INTERPRETER_SIZE + 1;

         if (number < (MIN_ITPTABLE_SIZE / INTERPRETER_SIZE))
            number = MIN_ITPTABLE_SIZE / INTERPRETER_SIZE;
                     
         InterpreterTableSize = number * INTERPRETER_SIZE;
         }
         
      if ((rval = AT_AllocVec( (ULONG) InterpreterTableSize,
                               MEMF_CLEAR | MEMF_FAST,
                               "interpPoolHeader", TRUE ))) // != NULL)
         {
         AllocatedInterpSize = InterpreterTableSize;
         }
      }
   else
      {
      if ((poolSize % INTERPRETER_SIZE) != 0)
         {
         // Round poolSize to even BYTEARRAY_SIZE:
         int number = poolSize / INTERPRETER_SIZE + 1;
         
         if (number < (MIN_ITPTABLE_SIZE / INTERPRETER_SIZE))
            number = MIN_ITPTABLE_SIZE / INTERPRETER_SIZE;
                     
         poolSize = number * INTERPRETER_SIZE;
         }
         
      if ((rval = AT_AllocVec( poolSize, MEMF_CLEAR | MEMF_FAST,
                               "interpPoolHeader", TRUE ))) // != NULL)
         {
         AllocatedInterpSize = poolSize;
         }
      }

   FEND( printf( "0x%08LX = makeInterpPool()\n", rval ) );

   return( rval );
}

/****h* allocInterpPool() [3.0] ************************************
*
* NAME
*    allocInterpPool()
*
* DESCRIPTION
*    Allocate a Memory Pool for SmallTalk().
********************************************************************
*/

PUBLIC void *allocInterpPool( ULONG poolSize )
{
   FBEGIN( printf( "allocInterpPool( size = %d )\n", poolSize ) );

   if (interpPoolHeader) // != NULL)
      {
      FEND( printf( "0x%08LX = allocInterpPool() (CODE PROBLEM!)\n", interpPoolHeader ) );   
   
      return( interpPoolHeader );
      }

   if ((interpPoolHeader = makeInterpPool( poolSize ))) // != NULL)
      interpreterList = (INTERPRETER *) interpPoolHeader;

   FEND( printf( "0x%08LX = allocInterpPool()\n", interpPoolHeader ) );   

   return( interpPoolHeader );
}

/****i* storeInterpreter() [3.0] ***********************************
*
* NAME
*    storeInterpreter()
*
* DESCRIPTION
*    Place the given Interpreter on the given list & update the
*    pointers.
********************************************************************
*/

SUBFUNC void storeInterpreter( INTERPRETER  *i, 
                               INTERPRETER **last,
                               INTERPRETER **list
                             )
{
   if (!*last) // == NULL) // First element in list??
      {
      *last = i;
      *list = i;
      }
   else
      {
      (*last)->nextLink = i;
      }

   i->nextLink = NULL;

   *last = i; // Update the end of the List.
   
   return;       
}

/****i* allocInterp() [3.0] ****************************************
*
* NAME
*    allocInterp()
*
* DESCRIPTION
*    Allocate a new Interpreter structure from the Memory Pool.
********************************************************************
*/

SUBFUNC INTERPRETER *allocInterp( void )
{
   INTERPRETER *New = NULL;

   FBEGIN( printf( "allocInterp( void )\n" ) );

   if ((ca_terp + 1) * INTERPRETER_SIZE > AllocatedInterpSize)
      {
      // We're going to exceed the Pool size, so die instead:
      fprintf( stderr, "Ran out of memory in allocInterp()!\n" );
      
      MemoryOut( "allocInterp()" );

      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached
      }
         
   if (!lastAllocdInterpreter) // == NULL)
      {
      // the first ByteArray to get created:
      New           = interpreterList;
      New->nextLink = NULL;
      
      lastAllocdInterpreter = New;
      }
   else
      {
      INTERPRETER *prev = lastAllocdInterpreter; // interpreterList;
      
      while (prev->nextLink) // != NULL)
         prev = prev->nextLink; // Find the end of the list.

      New = ++prev; // + INTERPRETER_SIZE; // DEBUG this!
      
      storeInterpreter( New, &lastAllocdInterpreter, &interpreterList );
      }

   FEND( printf( "0x%08LX = allocInterp()\n", New ) );

   return( New );
}

/****i* freeDeadInterpreters() [3.0] *********************************
*
* NAME
*    freeDeadInterpreters()
*
* DESCRIPTION
*    Count the space on the recycledList.
**********************************************************************
*
*/

SUBFUNC int freeDeadInterpreters( INTERPRETER **recycledList, 
                                  INTERPRETER **last 
                                )
{
   INTERPRETER *p    = *recycledList;
   INTERPRETER *next =  (INTERPRETER *) NULL;
   
   int          howMany = 0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      howMany++;
         
      p = next;
      }
   
   return( howMany );
}

/****h* findFreeInterpreter() [3.0] **********************************
*
* NAME
*    findFreeInterpreter()
*
* DESCRIPTION
*    See if there are any unused Interpreters in the 
*    recycleInterpreterList.
**********************************************************************
*
*/

SUBFUNC INTERPRETER *findFreeInterpreter( void )
{
   INTERPRETER *p = recycleInterpreterList;

   FBEGIN( printf( "findFreeInterpreter( void )\n" ) );   

   if (!p) // == NULL)
      goto exitFindFree;
         
   for ( ; p != NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         break;
         }
      }

exitFindFree:

   FEND( printf( "0x%08LX = findFreeInterpreter()\n", p ) );   

   return( p );
}
         
/****h* recycleInterpreter() [3.0] ***********************************
*
* NAME
*    recycleInterpreter()
*
* DESCRIPTION
*    Mark an Interpreter as unused in the interpreterList.
**********************************************************************
*
*/

PRIVATE BOOL firstRecycledInterp = TRUE;

SUBFUNC void recycleInterpreter( INTERPRETER *killMe )
{
   int i;
   
   FBEGIN( printf( "recycleInterpreter( 0x%08LX )\n", killMe ) );

   killMe->ref_count   = 0;
   killMe->size        = MMF_INTERPRETER | INTERPRETER_SIZE; // &= ~MMF_INUSE_MASK; // Clear INUSE bit.
   killMe->creator     = NULL;
   killMe->sender      = NULL;
   killMe->bytecodes   = NULL;
   killMe->receiver    = NULL;
   killMe->literals    = NULL;
   killMe->context     = NULL;
   killMe->currentbyte = NULL;
   killMe->stacktop    = (OBJECT **) &killMe->stack[0];
      
   for (i = 0; i < STACK_MAX; i++)
      killMe->stack[i] = MYNULL;

   if (firstRecycledInterp == TRUE)
      {
      firstRecycledInterp    = FALSE;
      recycleInterpreterList = killMe;
      }

   FEND( printf( "recycleInterpreter() exits\n" ) );   

   return;
}

/****h* freeVecAllInterpreters() [3.0] *******************************
*
* NAME
*    freeVecAllInterpreters()
*
* DESCRIPTION
*    FreeVec ALL Interpreters for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllInterpreters( void )
{
   AT_FreeVec( interpPoolHeader, "interpPoolHeader", TRUE );

   interpPoolHeader = NULL;

   return;
}

/****h* freeSlackInterpreterMemory() [3.0] *************************
*
* NAME
*    freeSlackInterpreterMemory()
*
* DESCRIPTION
*    Get rid of all Interpreters in the recycleInterpreterList.
********************************************************************
*
*/

PUBLIC int freeSlackInterpreterMemory( void )
{
   return( freeDeadInterpreters( &recycleInterpreterList, 
                                 NULL // &lastRecycledInterpreter 
                               ) 
         );
}

/****h* cr_interpreter() [1.5] *************************************
*
* NAME
*    cr_interpreter()
*
* DESCRIPTION
*    Create a new interpreter.  Context is another name for 
*    instance variables.
********************************************************************
*
*/

PUBLIC INTERPRETER *cr_interpreter( INTERPRETER *sender, 
                                    OBJECT      *receiver, 
                                    OBJECT      *literals,
                                    OBJECT      *bitearray, 
                                    OBJECT      *context 
                                  )
{
   INTERPRETER *New = (INTERPRETER *) NULL;

   FBEGIN( printf( "cr_interpreter( 0x%08LX, 0x%08LX, 0x%08LX, 0x%08LX, 0x%08LX, )\n",sender,receiver,literals,bitearray,context ) );

   if (started == TRUE)
      {
      if ((New = findFreeInterpreter())) // != NULL)
         goto setupNewInterpreter;
      }

   New = allocInterp();

   ca_terp++;

setupNewInterpreter:

   New->nextLink  = NULL;
   New->ref_count = 0;
   New->size      = MMF_INUSE_MASK | MMF_INTERPRETER | INTERPRETER_SIZE;
   New->creator   = NULL;
   
   if (sender) // != NULL)
      {
      New->sender = (INTERPRETER *) AssignObj( (OBJECT *) sender );
      }
   else
      {
      New->sender = (INTERPRETER *) AssignObj( o_nil );
      }

   New->bytecodes   = AssignObj( bitearray );
   New->receiver    = AssignObj( receiver  );
   New->literals    = AssignObj( literals  );
   New->context     = AssignObj( context );
   New->stacktop    = (OBJECT **) &New->stack[0];
   New->currentbyte = BYTE_VALUE( (BYTEARRAY *) New->bytecodes );

   if (ca_terp > 1)
      storeInterpreter( New, &lastAllocdInterpreter, &interpreterList );

   FEND( printf( "0x%08LX = cr_interpreter()\n", New ) );

   return( New );
}

/****h* free_terpreter() [1.5] *************************************
*
* NAME
*    free_terpreter()
*
* DESCRIPTION
*    Return an unused interpreter to free list.
********************************************************************
*
*/

PUBLIC void free_terpreter( INTERPRETER *anInterpreter )
{
   FBEGIN( printf( "free_terpreter( 0x%08LX )\n", anInterpreter ) );

   if (is_interpreter( (OBJECT *) anInterpreter ) == FALSE)
      {
      fprintf( stderr, "free_terpreter( 0x%08LX ) NOT an Interpreter!\n", anInterpreter );
      
      cant_happen( WRONGOBJECT_FREED );  // Die, you abomination!!
      
      return; // never reached
      }
      
   (void) obj_dec( (OBJECT *) anInterpreter->sender );
   (void) obj_dec( anInterpreter->receiver          );
   (void) obj_dec( anInterpreter->bytecodes         );
   (void) obj_dec( anInterpreter->literals          );
   (void) obj_dec( anInterpreter->context           );

   recycleInterpreter( anInterpreter );

   FEND( printf( "free_terpreter() exits\n" ) );   

   return;
}

/****h* copy_arguments() [1.6] *************************************
*
* NAME
*    copy_arguments()
*
* DESCRIPTION
*    Copy an array of arguments into the context.
********************************************************************
*
*/

void copy_arguments( INTERPRETER *anInterpreter, int argLocation, 
                     int argCount, OBJECT **argArray 
                   )
{
   OBJECT *ctext = anInterpreter->context;
   int    i;

   FBEGIN( printf( "copy_arguments( 0x%08LX, %d, %d, 0x%08LX )\n",anInterpreter,argLocation,argCount,argArray ) );

   for (i = 0; i < argCount; argLocation++, i++) 
      {
      ctext->inst_var[argLocation] = AssignObj( argArray[i] );
      }

   FEND( printf( "copy_arguments() exits\n" ) );

   return;
}

/****i* push() [1.6] ***********************************************
*
* NAME
*    push()
*
* DESCRIPTION
*    Place OBJECT on anInterpreter stack.  Used to be a Macro.
********************************************************************
*
*/

SUBFUNC void push( INTERPRETER *anInterpreter, OBJECT *x ) 
{
   OBJECT *rval   = (OBJECT *) NULL;
   char   *bottom = NULL;
   
   FBEGIN( printf( "push( Interp = 0x%08LX, obj = 0x%08LX )\n", anInterpreter, x ) );   

   bottom = (char *) &anInterpreter->stack[ STACK_MAX ];

   if (anInterpreter->stacktop > (OBJECT **) bottom) // Stack overflow?
      {
      int ans = 0;
      
      sprintf( ErrMsg, IntrpCMsg( MSG_FMT_INP_PUSH_INTERP ), 
                       x, ((STRING *) x->Class->class_name)->value
             );

      ans = Handle_Problem( ErrMsg, IntrpCMsg( MSG_RQTITLE_FATAL_INTERROR_INTERP ), NULL );
      if (ans == 0) 
         return;
      else
         ShutDown();
      }

   if (x) // != NULL)
      {
      rval = AssignObj( x );

      *(anInterpreter->stacktop) = rval;

      anInterpreter->stacktop++;
      }
   else
      {
      lexerr( IntrpCMsg( MSG_INP_PUSH2_INTERP ), IntrpCMsg( MSG_INP_HUH_INTERP ) );
      } 

   FEND( printf( "push() exits\n" ) );

   return;
}

/****h* push_object() [1.6] ****************************************
*
* NAME
*    push_object()
*
* DESCRIPTION
*    Push a returned value on to an interpreter stack.
*    same as push().  Used in block_execute() & block_return() in
*    the Block.c file.
********************************************************************
*
*/

PUBLIC void push_object( INTERPRETER *anInterpreter, OBJECT *anObject )
{
   push( anInterpreter, anObject );

   return;
}

/****h* nextbyte() [1.6] *******************************************
*
* NAME
*    nextbyte()
*
* DESCRIPTION
*    Get the next bytecode to interpret from anInterpreter.
********************************************************************
*
*/

PUBLIC int nextbyte( INTERPRETER *theInterp )
{
   int rval = (uctoi( *theInterp->currentbyte ) & 0xFF);

#  ifdef DEBUG
   uchar     *cb = theInterp->currentbyte + 1;
   BYTEARRAY *ba = (BYTEARRAY *) theInterp->bytecodes;
   void      *max;

   max = (void *) (((int) ba->bytes) + ba->bsize);

   if (IndexChk( (int) cb, (int) max, IntrpCMsg( MSG_INP_NEXTBYTE_INTERP ) ) == FALSE)
      {
      return( -1 ); // Much larger than 8 bits.
      }
#  endif

   theInterp->currentbyte++;

   return( rval );
}

/****i* popstack() [1.6] *******************************************
*
* NAME
*    popstack()
*
* DESCRIPTION
*    Get the next OBJECT from TheInterpreter's stack.
*    Used to be a Macro.
********************************************************************
*
*/

PRIVATE OBJECT *popstack( INTERPRETER *TheInterpreter )
{
   OBJECT *rval = (OBJECT *) NULL;
   char   *top  = (char *) &TheInterpreter->stack[0];

   FBEGIN( printf( "popstack( 0x%08LX )\n", TheInterpreter ) );

   if (TheInterpreter->stacktop < (OBJECT **) top)
      {
      // Too many pops!!
      int ans = 0;
      
      sprintf( ErrMsg, IntrpCMsg( MSG_INP_POPSTACK_INTERP ), TheInterpreter );
      
      ans = Handle_Problem( ErrMsg, IntrpCMsg( MSG_RQTITLE_FATAL_INTERROR_INTERP ), NULL );

      if (ans == 0)
         return( o_nil );
      else
         ShutDown();
      }

   --TheInterpreter->stacktop;

   rval = *TheInterpreter->stacktop;

   FEND( printf( "0x%08LX = popstack()\n", rval ) );

   return( rval );
}

// Alias for Class instance variable # x:
#define INST_VAR(x)  (Interper->receiver)->inst_var[ x ]

// Alias for Method temporary variable # x:
#define TEMPVAR(x)   (Interper->context)->inst_var[ x ]

// Alias for literal # x:
#define LIT(x)       (Interper->literals)->inst_var[ x ]

#define DECSTACK(x)  (Interper->stacktop    -= x)

#define SKIP(x)      (Interper->currentbyte += x)

// -----------------------------------------------------------------

PRIVATE char trStr[80] = { 0, };

PRIVATE OBJECT *translateObject( OBJECT *obj )
{
   if (obj == o_nil)
      StringCopy( trStr, IntrpCMsg( MSG_LX_NIL_STR_INTERP ) );
     
   else if (obj == o_true)
      StringCopy( trStr, IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) );
     
   else if (obj == o_false)
      StringCopy( trStr, IntrpCMsg( MSG_LX_FALSE_STR_INTERP ) );
     
   else 
      sprintf( trStr, IntrpCMsg( MSG_FMT_INP_OTHER_INTERP ), obj ); // ^ Object from ClassNew()

   return( obj );
}

PRIVATE OBJECT *translateClass( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_CLASS_INTERP ),
                   symbol_value( (SYMBOL *) ((CLASS *) obj)->class_name ) 
          );

   return( obj );
}
            
PRIVATE OBJECT *translateByteArray( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_BASZ_INTERP ), obj, ((BYTEARRAY *) obj)->bytes );
            
   return( obj );
}

PRIVATE OBJECT *translateSymbol( OBJECT *obj )
{
   sprintf( trStr, "#%s", symbol_value( (SYMBOL *) obj ) );
            
   return( obj );
}

PRIVATE OBJECT *translateInterp( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_INTP_INTERP ), obj );

   return( obj );
}

PRIVATE OBJECT *translateProcess( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_PROC_INTERP ), obj );

   return( obj );
}

PRIVATE OBJECT *translateBlock( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_BLOK_INTERP ), obj );

   return( obj );
}

PRIVATE OBJECT *translateFile( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_FILE_INTERP ), obj );

   return( obj );
}

PRIVATE OBJECT *translateChar( OBJECT *obj )
{
   sprintf( trStr, "$%c", char_value( obj ) );

   return( obj );
}

PRIVATE OBJECT *translateInteger( OBJECT *obj )
{
   if (int_value( obj ) > 100 || int_value( obj ) < 0)
      sprintf( trStr, "Int( 0x%08LX )", int_value( obj ) );
   else
      sprintf( trStr, IntrpCMsg( MSG_FMT_INP_INTG_INTERP ), int_value( obj ) );

   return( obj );
}

PRIVATE OBJECT *translateString( OBJECT *obj )
{
   sprintf( trStr, "'%20.20s'", string_value( (STRING *) obj ) );

   return( obj );
}

PRIVATE OBJECT *translateFloat( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_FLOAT_INTERP ), float_value( (SFLOAT *) obj ) );

   return( obj );
}

PRIVATE OBJECT *translateClassSpec( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_SPECL_INTERP ), 
                   symbol_value( (SYMBOL *) ((struct spec_object *) obj)->class_name  ) 
          );

   return( obj );
}

PRIVATE OBJECT *translateUnknown( OBJECT *obj )
{
   sprintf( trStr, IntrpCMsg( MSG_FMT_INP_OTHER_INTERP ), obj );

   return( obj );
}

PRIVATE OBJECT *translateAddress( OBJECT *obj )
{
   if (addr_value( obj ) > 100)
      sprintf( trStr, "Addr( 0x%08LX )", addr_value( obj ) );
   else
      sprintf( trStr, IntrpCMsg( MSG_FMT_INP_INTG_INTERP ), addr_value( obj ) );

   return( obj );
}

PRIVATE ULONG translators[] = {

   (ULONG) &translateObject,    (ULONG) &translateClass,   (ULONG) &translateByteArray, (ULONG) &translateSymbol,
   (ULONG) &translateInterp,    (ULONG) &translateProcess, (ULONG) &translateBlock,     (ULONG) &translateFile,
   (ULONG) &translateChar,      (ULONG) &translateInteger, (ULONG) &translateString,    (ULONG) &translateFloat,
   (ULONG) &translateClassSpec, (ULONG) &translateUnknown, (ULONG) &translateUnknown,   (ULONG) &translateAddress
};

/****h* Translate() [1.9] ******************************************
*
* NAME
*    Translate()
*
* DESCRIPTION
*    Return a string that describes the Object for Debug tracing
*    only.
********************************************************************
*
*/

SUBFUNC char *Translate( OBJECT *obj )
{
   trStr[0] = NIL_CHAR;

//   FBEGIN( printf( "Translate( 0x%08LX )\n", obj ) );   

   (void) ObjActionByType( obj, 
                           (OBJECT * (**)( OBJECT * )) translators 
                         );

   FEND( printf( "%s = Translate()\n", &trStr[0] ) );

   return( &trStr[0] );
}

/****i* primitive143() [2.1] ***************************************
*
* NAME
*    primitive143()
*
* DESCRIPTION
*    This is the code from resume() that used to process primitive
*    143 (perform:withArguments:)
********************************************************************
*
*/

PRIVATE void primitive143( INTERPRETER *Interper, OBJECT *tempobj )
{
   OBJECT *receiver = (OBJECT *) NULL;
   char   *message  = symbol_value( (SYMBOL *) tempobj );
   int     i, numargs = 0;

   // -----------------------------------------------------------

   FBEGIN( printf( "primitive143( 0x%08LX, 0x%08LX )\n", Interper, tempobj ) );
            
   tempobj = popstack( Interper ); // Get Argument array
                                   // 1st element is receiver.
   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, IntrpCMsg( MSG_FMT_INP_143_INTERP ), Translate( tempobj ) );
      }

   numargs = objSize( tempobj ) - 1; // numargs has to be at least one!
      
   for (i = 0; i <= numargs; i++)
       push( Interper, (OBJECT *) tempobj->inst_var[i] );
         
   receiver = *(Interper->stacktop - (numargs + 1) );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, IntrpCMsg( MSG_FMT_INP_RECVR_INTERP ), Translate( receiver ) );
      }

   DECSTACK( numargs + 1 ); // Interper->stacktop += numargs + 1

   // send_mess() in Courier.c:
   send_mess( Interper, receiver, message,   
              Interper->stacktop, numargs  
            );

   FEND( printf( "primitive143() exits\n" ) );

   return;
}
    
/****i* replyToSender() [3.0] **************************************
*
* NAME
*    replyToSender()
*
* DESCRIPTION
*    Change our Interpreter to Interp->sender & link to the new
*    Process.
********************************************************************
*
*/

SUBFUNC void replyToSender( INTERPRETER *Interper, OBJECT *tempobj )
{
   INTERPRETER *sender = Interper->sender;

   FBEGIN( printf( "replyToSender( 0x%08LX, 0x%08LX )\n", Interper, tempobj ) );

   if (is_interpreter( (OBJECT *) sender ) == TRUE) 
      {
      if (is_driver( (OBJECT *) sender ) == FALSE)
         push_object( sender, tempobj );

      link_to_process( sender );
      }
//   else
   else if (is_driver( (OBJECT *) runningProcess->interp ) == FALSE)  // DEBUG this!!
      terminate_process( runningProcess );

   FEND( printf( "replyToSender() exits\n" ) );

   return;
}
        
/****h* resume() [3.0] *********************************************
*
* NAME
*    resume()
*
* DESCRIPTION
*    Resume executing bytecodes associated with an interpreter.
*    This is the main engine of the SmallTalk interpreter.
********************************************************************
*
*/

PUBLIC void resume( register INTERPRETER *Interper )
{
   IMPORT OBJECT  *primitive( int primnumber, int numargs, OBJECT **args );
    
   OBJECT         *tempobj  = (OBJECT *) NULL;
   OBJECT         *receiver = (OBJECT *) NULL;
   INTERPRETER    *sender   = (INTERPRETER *) NULL;

   register int   highBits = -1;
   register int   lowBits  = -1;

   char           *message  = NULL;
   BOOL           failflag = FALSE;
   int            i, j, k, numargs, arglocation;

   FBEGIN( printf( "resume( Interp = 0x%08LX )\n", Interper ) );   

   while ( 1 ) // FOREVER:
      {
      if ((highBits = nextbyte( Interper )) < 0)
         {
         // We've reached an error condition!
         highBits = (SPECIAL << 4) + NOOP;    // 0xF0, keep going.
         failflag = TRUE;
         }

      lowBits   = highBits % 16;
      highBits /= 16;

switchtop:

      switch (highBits) 
         {
         default:  // Zapped by lightning or something!!

            fprintf( stderr, "resume() decoded 0x%02LX 0x%02LX!\n", highBits, lowBits );

            cant_happen( HIGHBITS_OVERSIZED );  // Die, you abomination!!

            break;

         case 0:   // two-byte form of instruction (ref. Chap. 13):
            highBits = lowBits;

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
               fprintf( TraceFile, "{+ 0x0%1LX", highBits );
               }

            if ((lowBits = nextbyte( Interper )) < 0)
               {
               // We've reached an error condition:
               lowBits  = (SPECIAL << 4) + NOOP; // 0xF0, keep going.
               failflag = TRUE;
               }

            if (TraceFile && traceByteCodes == TRUE)
               {
               fprintf( TraceFile, " 0x%02LX +} ", lowBits );
               }

            goto switchtop;

         case 1: // Push Interper->receiver->inst_var[ lowBits ]:
            push( Interper, INST_VAR( lowBits ) );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_1X_INTERP ), 
                        lowBits, lowBits, Translate( INST_VAR( lowBits ) )
                      );
               }

            break;

         case 2: // Push Interper->context->inst_var[ lowBits ]:
            push( Interper, TEMPVAR( lowBits ) );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_2X_INTERP ), 
                        lowBits, lowBits, Translate( TEMPVAR( lowBits ) )
                      );
               }

            break;

         case 3: // Push Interper->literals->inst_var[ lowBits ]:
            push( Interper, LIT( lowBits ) );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_3X_INTERP ),
                        lowBits, lowBits, Translate( LIT( lowBits ) )
                      );
               }

            break;

         case 4: // Push (class) Interper->literals->inst_var[ lowBits ]:
            tempobj = LIT( lowBits );

            if (is_symbol( tempobj ) == FALSE) 
               {
               fprintf( stderr, "resume(): 0x%08LX was NOT a Symbol!\n", tempobj );
               
               cant_happen( INTERP_NOSYMBOL );  // Die, you abomination!!
               }
               
            tempobj = primitive( FINDCLASS, 1, &tempobj );

            push( Interper, tempobj );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();

               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_4X_INTERP ),
                        lowBits, lowBits, tempobj, 
                        ((SYMBOL *) ((CLASS *)tempobj)->class_name)->value
                      );
               }

            break;

         case 5: // special literals:
            if (lowBits < 10) 
               {
               tempobj = new_int( lowBits );

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();

                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5X_INTERP ),
                                      lowBits, lowBits
                         );
                  }
               }
            else if (lowBits == 10)
               { 
               tempobj = new_int( -1 );

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();

                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5A_INTERP ) );
                  }
               }
            else if (lowBits == 11)
               {
               tempobj = o_true;

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();

                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5B_INTERP ) );
                  }
               }
            else if (lowBits == 12)
               {
               tempobj = o_false;

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();

                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5C_INTERP ) );
                  }    
               }
            else if (lowBits == 13)
               {
               tempobj = o_nil;

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();

                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5D_INTERP ) );
                  }
               }
            else if (lowBits == 14)
               {
               tempobj = o_smalltalk;

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();

                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5E_INTERP ), tempobj );
                  }
               }
            else if (lowBits == 15)
               {
               tempobj = (OBJECT *) runningProcess;

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();
        
                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5F_INTERP ), tempobj );
                  }
               }
            else if ((lowBits >= 30) && (lowBits < 60)) 
               {
               // get class:
               tempobj = (OBJECT *) new_sym( classpecial[ lowBits - 30 ] );

               tempobj = primitive( FINDCLASS, 1, &tempobj );

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();
        
                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5Z_INTERP ), 
                           lowBits, lowBits, tempobj,
                           ((SYMBOL *) ((CLASS *)tempobj)->class_name)->value
                         );
                  }
               }
            else 
               {
               tempobj = new_int( lowBits );

               if (TraceFile && traceByteCodes == TRUE)
                  {
                  indentTrace();
        
                  fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_5X_INTERP ), lowBits, lowBits );
                  }
               }

            push( Interper, tempobj );

            break;

         case 6: // Pop Interper->receiver->inst_var[ lowBits ]:
            INST_VAR( lowBits ) = AssignObj( popstack( Interper ) );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
  
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_6X_INTERP ), 
                        lowBits, lowBits, Translate( INST_VAR( lowBits ) )
                      );
               }

            break;

         case 7: // Pop Interper->context->inst_var[ lowBits ]:
            TEMPVAR( lowBits ) = AssignObj( popstack( Interper ) );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
  
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_7X_INTERP ),
                        lowBits, lowBits, Translate( TEMPVAR( lowBits ) )
                      );
               }

            break;

         case 8: // send a message:
            numargs = lowBits;

            if ((i = nextbyte( Interper )) < 0)
               {
               failflag = TRUE;
               tempobj  = o_nil;

               replyToSender( Interper, tempobj );
                     
               FEND( printf( "resume() exits at 0x8x %d (ABNORMAL)\n", i ) );

               return;
               }

            // tempobj <- Interper->literals->inst_var[ i ]:
            tempobj = LIT( i );

            if (is_symbol( tempobj ) == FALSE) 
               {
               fprintf( stderr, "resume(): 0x%08LX was NOT a Symbol!\n", tempobj );
 
               cant_happen( INTERP_NOMSGSYMBOL );   // Die, you abomination!!
               }
               
            message = symbol_value( (SYMBOL *) tempobj );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
  
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_8X_INTERP ),
                        lowBits, i, message, numargs
                      );
               }

            goto do_send;

         case 9: // send a superclass message:
            numargs = lowBits;

            if ((i = nextbyte( Interper )) < 0)
               {
               failflag = TRUE;
               tempobj  = o_nil;

               replyToSender( Interper, tempobj );
                     
               FEND( printf( "resume() exits at 0x9x %d (ABNORMAL)\n", i ) );

               return;
               }

            // tempobj <- Interper->literals->inst_var[ i ]:
            tempobj = LIT( i );

            if (is_symbol( tempobj ) == FALSE) 
               {
               fprintf( stderr, "resume(): 0x%08LX was NOT a Symbol!\n", tempobj );

               cant_happen( INTERP_NOSUPSYMBOL );   // Die, you abomination!!
               }
               
            message  = symbol_value( (SYMBOL *) tempobj );

            receiver = fnd_super( Interper->receiver );

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
  
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_9X_INTERP ), 
                        lowBits, i, message, numargs, Translate( receiver )
                      );
               }

            goto do_send2;

         case 10: // send a special unary message:
            numargs = 0;

            message = unspecial[ lowBits ];

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
  
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_AX_INTERP ), lowBits, message );
               }

            goto do_send;

         case 11: // send a special binary message:
            numargs = 1;

            message = binspecial[ lowBits ];

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
  
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_BX_INTERP ), lowBits, message );
               }

            goto do_send;

         case 12: // send a special arithmetic message:
            tempobj = *(Interper->stacktop - 2);

            if (is_integer( tempobj ) == FALSE) 
               goto ohwell;

            i = k = int_value( tempobj );

            tempobj = *(Interper->stacktop - 1);

            if (is_integer( tempobj ) == FALSE) 
               goto ohwell;

            j = int_value( tempobj );

            DECSTACK( 2 );

            switch (lowBits) 
               {
               case 0: 
                  i += j; 
    
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C0_INTERP ), j, k );
                     }

                  break;
               
               case 1: 
                  i -= j; 

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C1_INTERP ), j, k );
                     } 

                  break;
               
               case 2: 
                  i *= j; 

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C2_INTERP ), k, j );
                     }

                  break;
               
               case 3:
                  if (i < 0) 
                     i = -i;
                  
                  i %= j; 

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C3_INTERP ), k, j );
                     } 

                  break;

               case 4:
                  if (j < 0) 
                     {
                     i >>= (-j);

                     if (TraceFile && traceByteCodes == TRUE)
                        {
                        indentTrace();
 
                        fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C41_INTERP ), k, j );
                        }
                     }
                  else
                     { 
                     i <<= j;

                     if (TraceFile && traceByteCodes == TRUE)
                        {
                        indentTrace();
 
                        fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C42_INTERP ), k, j );
                        }
                     } 

                  break;

               case 5:  
                  i &= j;

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C5_INTERP ), k, j );
                     }

                  break;
           
               case 6:  
                  i |= j;

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C6_INTERP ), k, j );
                     }

                  break;
               
               case 7:  
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C7_INTERP ), 
                              i, j, 
                              i < j ? IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) 
                                    : IntrpCMsg( MSG_LX_FALSE_STR_INTERP )
                            );
                     }

                  i = (i < j);  

                  break;
               
               case 8:  
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C8_INTERP ), 
                              i, j, 
                              i <= j ? IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) 
                                     : IntrpCMsg( MSG_LX_FALSE_STR_INTERP )
                            );
                     }

                  i = (i <= j); 

                  break;
               
               case 9:  
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C9_INTERP ), 
                              i, j, 
                              i == j ? IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) 
                                     : IntrpCMsg( MSG_LX_FALSE_STR_INTERP )
                            );
                     }

                  i = (i == j); 

                  break;
               
               case 10: 
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CA_INTERP ), 
                              i, j, 
                              i != j ? IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) 
                                     : IntrpCMsg( MSG_LX_FALSE_STR_INTERP )
                            );
                     }

                  i = (i != j); 

                  break;
               
               case 11: 
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CB_INTERP ), 
                              i, j, 
                              i >= j ? IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) 
                                     : IntrpCMsg( MSG_LX_FALSE_STR_INTERP )
                            );
                     }

                  i = (i >= j); 

                  break;
               
               case 12: 
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CC_INTERP ), 
                              i, j,
                              i > j ? IntrpCMsg( MSG_LX_TRUE_STR_INTERP ) 
                                    : IntrpCMsg( MSG_LX_FALSE_STR_INTERP )
                            );
                     }

                  i = (i > j);  

                  break;
               
               case 13: 
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CD_INTERP ), i, j, i %= j );
                     }

                  i %= j;       

                  break;
               
               case 14: 
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CE_INTERP ), i, j, i /= j );
                     }

                  i /= j;

                  break;
               
               case 15:
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CF_INTERP ), i, j, i %= j );
                     }

                  i = (i < j) ? i : j;

                  break;
                        
               case 16:
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();
 
                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_C10_INTERP ), i, j, i %= j );
                     }

                  i = (i < j) ? j : i;

                  break;
               
               default:
                  fprintf( stderr, "resume(): 0x%02LX wrong for Arithmetic!\n", lowBits ); 

                  cant_happen( INTERP_ARITHLOWBITS ); // Die, you abomination!!

                  break;
               }

            if ((lowBits < 7) || (lowBits > 12))
               tempobj = new_int( i ); 
            else 
               tempobj = (i ? o_true : o_false);

            push( Interper, tempobj );

            break;

ohwell:     // oh well, send message:
            numargs = 1;

            message = arithspecial[ lowBits ];

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
     
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_CX_INTERP ), lowBits, message );
               }

            goto do_send;

         case 13: // send a special ternary keyword message:
            numargs = 2;

            message = keyspecial[ lowBits ];

            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();
     
               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_DX_INTERP ), lowBits, message );
               }

            goto do_send;

         case 14: // block creation:
            {
            OBJECT *blk = (OBJECT *) NULL;

            numargs = lowBits;

            if (numargs != 0)
               {
               if ((arglocation = nextbyte( Interper )) < 0)
                  {
                  failflag = TRUE;
                  tempobj  = o_nil;

                  replyToSender( Interper, tempobj );
                     
                  FEND( printf( "resume() exits at 0xE%d (ABNORMAL)\n", numargs ) );
   
                  return;
                  }
               }

            if ((i = nextbyte( Interper )) < 0)   // i = size of block
               {
               failflag = TRUE;
               tempobj  = o_nil;

               replyToSender( Interper, tempobj );
                     
               FEND( printf( "resume() exits at 0xE%d %d (ABNORMAL)\n", numargs, i ) );

               return;
               }

            blk = new_block( Interper, numargs, arglocation );
            
            if (TraceFile && traceByteCodes == TRUE)
               {
               indentTrace();

               fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_EX_INTERP ),
                        lowBits, arglocation, i, blk
                      );

               TraceIndent++;
               }

            push( Interper, blk );

            SKIP( i );
            }

            break;

         case 15: // special bytecodes:
            switch (lowBits) 
               {
               case 0: // no - op (normally):
                  if (failflag == TRUE)
                     {
                     tempobj  = o_nil;
                     failflag = FALSE; // Reset.

                     // goto do_return;
                     replyToSender( Interper, tempobj );
                     }

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F0_INTERP ) );
                     }
                  break;

               case 1: // duplicate top of stack:
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F1_INTERP ), 
                              Translate( *(Interper->stacktop - 1) )
                            );
                     }

                  push( Interper, *(Interper->stacktop - 1) );

                  break;

               case 2: // pop top of stack:
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F2_INTERP ),
                                         Translate( *Interper->stacktop ));
                     }

                  (void) popstack( Interper );

                  break;

               case 3: // return top of stack:
                  tempobj = popstack( Interper );

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F3_INTERP ), Translate( tempobj ) );

                     TraceIndent--;
                     }

                  replyToSender( Interper, tempobj );

                  FEND( printf( "resume() exits at 0xF3\n" ) );

                  return;
                  
               case 4: // block return:
                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F4_INTERP ) );
                     TraceIndent--;
                     }

                  block_return( Interper, popstack( Interper ) );

                  FEND( printf( "resume() exits at 0xF4\n" ) );

                  return;

               case 5: // self return:
                  tempobj = TEMPVAR( 0 );

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F5_INTERP ), Translate( tempobj ) );

                     TraceIndent--;
                     }

                  replyToSender( Interper, tempobj );

                  FEND( printf( "resume() exits at 0xF5\n" ) );

                  return;

               case 6: // skip on true: (ifFalse: decoding)
                  if ((i = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );

                     FEND( printf( "resume() exits at 0xF6 %d (ABNORMAL)\n", i ) );

                     return;
                     }

                  tempobj = popstack( Interper );

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F6_INTERP ),
                              i, 
                              tempobj == o_true ? IntrpCMsg( MSG_TAKEN_STRING_INTERP )
                                                : IntrpCMsg( MSG_NOTTAKEN_STRING_INTERP )
                            );
                     }

                  if (tempobj == o_true) 
                     {
                     SKIP( i ); // Interper->currentbyte += i

                     push( Interper, o_nil );
                     }

                  break;

               case 7: // skip on false: (ifTrue: decoding)
                  if ((i = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );

                     FEND( printf( "resume() exits at 0xF7 %d (ABNORMAL)\n", i ) );

                     return;
                     }

                  tempobj = popstack( Interper );

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F7_INTERP ),
                               
                              i, tempobj == o_false ? IntrpCMsg( MSG_TAKEN_STRING_INTERP ) 
                                                    : IntrpCMsg( MSG_NOTTAKEN_STRING_INTERP )
                            );
                     }

                  if (tempobj == o_false) 
                     {
                     SKIP( i ); // Interper->currentbyte += i

                     push( Interper, o_nil );
                     }

                  break;

               case 8: // just skip:
                  if ((i = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );
                     
                     FEND( printf( "resume() exits at 0xF8 %d (ABNORMAL)\n", i ) );

                     return;
                     }

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F8_INTERP ), i );
                     }

                  SKIP( i );    // Interper->currentbyte += i

                  break;

               case 9: // skip backward:
                  if ((i = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );
                     
                     FEND( printf( "resume() exits at 0xF9 %d (ABNORMAL)\n", i ) );

                     return;
                     }

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_F9_INTERP ), i );
                     }

                  SKIP( -i );   // Interper->currentbyte -= i

                  break;

               case 10: // 0xFA = execute a primitive:
                  if ((numargs = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );
                     
                     return;
                     }

                  if ((i = nextbyte( Interper )) < 0) // primitive #.
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );
                     
                     FEND( printf( "resume() exits at 0xFA %d %d (ABNORMAL)\n", numargs, i ) );

                     return;
                     }

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     fprintf( TraceFile, "\n" );

                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_FA_INTERP ), 
                                         numargs, PrimStrings[i], i, i
                            );
                     }

                  if (i == BLOCKEXECUTE) // <primitive 140 x>
                     goto blk_execute;
                  else if (i == DOPERFORM) // perform:withArguments: <143>
                     {
                     tempobj = popstack( Interper );   

                     primitive143( Interper, tempobj );

                     FEND( printf( "resume() exits at <143>\n" ) );                     

                     return;
                     }
                  else 
                     {
                     DECSTACK( numargs ); // Interper->stacktop -= numargs

                     tempobj = primitive( i, numargs,
                                          Interper->stacktop
                                        );

                     if (TraceFile && traceByteCodes == TRUE)
                        {
                        fprintf( TraceFile, " ^-%s\n", Translate( tempobj ) );
                        }

                     push( Interper, tempobj );
                     }

                  break;

               case 11: // 0xFB == skip true, push true:
                  if ((i = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );
                     
                     FEND( printf( "resume() exits at 0xFB %d (ABNORMAL)\n", i ) );                     

                     return;
                     }

                  tempobj = popstack( Interper );

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_FB_INTERP ),
                              i, tempobj == o_true ? IntrpCMsg( MSG_TAKEN_STRING_INTERP )
                                                   : IntrpCMsg( MSG_NOTTAKEN_STRING_INTERP )
                            );
                     }

                  if (tempobj == o_true) 
                     {
                     SKIP( i ); // Interper->currentbyte += i

                     Interper->stacktop++;
                     }

                  break;

               case 12: // 0xFC == skip on false, push false:
                  if ((i = nextbyte( Interper )) < 0)
                     {
                     failflag = TRUE;
                     tempobj  = o_nil;

                     replyToSender( Interper, tempobj );

                     FEND( printf( "resume() exits at 0xFC %d (ABNORMAL)\n", i ) );

                     return;
                     }

                  tempobj = popstack( Interper );

                  if (TraceFile && traceByteCodes == TRUE)
                     {
                     indentTrace();

                     fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_FC_INTERP ),
                              i, tempobj == o_false ? IntrpCMsg( MSG_TAKEN_STRING_INTERP )
                                                    : IntrpCMsg( MSG_NOTTAKEN_STRING_INTERP )
                            );
                     }

                  if (tempobj == o_false) 
                     {
                     SKIP( i ); // Interper->currentbyte += i

                     Interper->stacktop++;
                     }

                  break;

               case 13: // 0xFD == special method & pseuvar decoding goes on here.
                  i = nextbyte( Interper );
                  
                  switch (i)
                     {
                     case TRACE_ON:
                        traceByteCodes = TRUE;

                        if (TraceFile)
                           {
                           indentTrace(); // We have to trace ourself also!

                           fprintf( TraceFile, IntrpCMsg( MSG_FMT_BCODE_FD_INTERP ), 0xFD, i );
                           }

                        break;
                        
                     case TRACE_OFF:
                        traceByteCodes = FALSE;
                        break;
                     
                     default:
                        break;
                     }
                     
                  break;
/*
               case 14: // 0xFE == Class variable???
               case 15: // 0xFF == super Class instance variable??? 
*/            
               default:
                  fprintf( stderr, "resume(): 0x%02LX wrong for SpecialOP!\n", lowBits ); 

                  cant_happen( INTERP_SPCLOWBITS );  // Die, you abomination!!

                  break;
               }
            break;
         }
      }

do_send:

      receiver = *(Interper->stacktop - (numargs + 1) );

      // do_send2 - call courier to send a message:

do_send2:

      DECSTACK( numargs + 1 ); // Interper->stacktop += numargs + 1

      // send_mess() in Courier.c:
      send_mess( Interper, receiver, message,   
                 Interper->stacktop, numargs  
               );

      FEND( printf( "resume() exits at do_send2:\n" ) );

      return;

      // blk_execute (in Block.c) - perform the block execute primitive:

blk_execute:

      if (TraceFile && traceByteCodes == TRUE)
         {
         fprintf( TraceFile, NEWLINE_STR ); // Work around primitive conditional.
         }

      tempobj = popstack( Interper );

      if (is_integer( tempobj ) == FALSE) 
         {
         fprintf( stderr, "resume(): 0x%08LX NOT an Integer for Block!\n", tempobj );
        
         cant_happen( BAD_BLOCK_ARG );    // Die, you abomination!!
         
         return; // never reached
         }
         
      numargs = int_value( tempobj );

      // TEMPVAR( x ) => (Interper->context)->inst_var[ x ]
      sender  = block_execute( Interper->sender, (BLOCK *) TEMPVAR( 0 ), 
                               numargs,          &TEMPVAR( 1 )
                             );

      link_to_process( sender );

      FEND( printf( "resume() exits at blk_execute:\n" ) );

      return;
}

/* ---------------- END of Interp.c file! --------------------------- */
