/****h* AmigaTalk/Block.c [3.0] **************************************
*
* NAME
*    Block.c
*
* DESCRIPTION
*    Block creation & Block return.
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    09-Nov-2003 - Set up for adding new memory management support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
*    18-Nov-2002 - Added code to allow Blocks to keep better track
*                  of numberArguments for the rest of the Classes
*                  to have access to (see PrimFuncs.c <144>).
* NOTES
*    $VER: AmigaTalk:Src/Block.c 3.0 (24-Oct-2004) by J.T. Steichen
*    
* TODO
*    Add some Debugging statements to these functions.
**********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>
 
#include "object.h"
#include "drive.h"
#include "FuncProtos.h"

#ifndef    AMIGATALKSTRUCTS_H
# include "ATStructs.h"
#endif

#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT OBJECT   *o_drive;
IMPORT OBJECT   *o_object;        // value of generic object

IMPORT int       atomcnt;         // atomic action flag
IMPORT int       started;

IMPORT PROCESS  *runningProcess;  // currently running process

IMPORT int ca_block;              // count block allocations

typedef INTERPRETER INTERPR;

PRIVATE BLOCK *recycleBlockList  = NULL;

PRIVATE BLOCK *lastAllocdBlock   = NULL;
PRIVATE BLOCK *blockList         = NULL;

/****i* freeVecDeadBlocks() [3.0] ************************************
*
* NAME
*    freeVecDeadBlocks()
*
* DESCRIPTION
*    Free the memory space of all unused Blocks in the
*    recycleBlockList.
**********************************************************************
*
*/

SUBFUNC int freeVecDeadBlocks( BLOCK **recycledList, BLOCK **last )
{
   BLOCK *p    = *recycledList;
   BLOCK *next =  (BLOCK *) NULL;
   
   int    howMany = 0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      if (p->size & MMF_INUSE_MASK == 0)
         howMany++;
         
      p = next;
      }
      
   return( howMany );
}

SUBFUNC void storeBlock( BLOCK *b, BLOCK **last, BLOCK **list )
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

   b->nextLink = NULL;

   *last = b; // Update the end of the List.
   
   return;       
}

/****i* findFreeBlock() [3.0] ****************************************
*
* NAME
*    findFreeBlock()
*
* DESCRIPTION
*    Find the first Block marked as unused in the recycleBlockList.
**********************************************************************
*
*/

SUBFUNC BLOCK *findFreeBlock( void )
{
   BLOCK *p    = recycleBlockList;
   BLOCK *rval = (BLOCK *) NULL;

   FBEGIN( printf( "findFreeBlock( void )\n" ) );   

   if (!p) // == NULL)
      goto exitFindFreeBlock;
         
   for ( ; p != (BLOCK *) NULL; p = p->nextLink)
      {
      if ((p->size & MMF_INUSE_MASK) == 0)
         {
         rval = p;
         
         break;
         }
      }

exitFindFreeBlock:

   FEND( printf( "0x%08LX = findFreeBlock()\n", rval ) );   

   return( rval );
}

/****i* recycleBlock() [3.0] *****************************************
*
* NAME
*    recycleBlock()
*
* DESCRIPTION
*    Mark an element in an Object List as being free to be re-used.
**********************************************************************
*
*/

PRIVATE BOOL firstRecycledBlock = TRUE;

SUBFUNC void recycleBlock( BLOCK *killMe )
{
   killMe->ref_count = 0;
   killMe->size      = MMF_BLOCK | BLOCK_SIZE; // ~MMF_INUSE_MASK; // Clear INUSE bit.

   if (firstRecycledBlock == TRUE)
      {
      firstRecycledBlock = FALSE;
      recycleBlockList   = killMe;
      }
           
   return;
}

/****i* cpyinterptreter() ******************************************
*
* NAME
*    cpyInterpreter()
*
* DESCRIPTION
*    Make a new copy of an existing interpreter.
********************************************************************
*
*/

PRIVATE INTERPR *cpyInterpreter( INTERPR *anInterpreter )
{   
   INTERPR *New = (INTERPR *) NULL;

   FBEGIN( printf( "cpyInterpreter( Interp = 0x%08LX )\n", anInterpreter ) );

   // In Interp.c file:
   New = cr_interpreter( (INTERPR *) 0,
                         anInterpreter->receiver,
                         anInterpreter->literals,
                         anInterpreter->bytecodes,
                         anInterpreter->context   
                       );

   if (anInterpreter->creator) // != NULL)
      New->creator = anInterpreter->creator;
   else
      New->creator = anInterpreter;

   New->currentbyte = anInterpreter->currentbyte;

   FEND( printf( "0x%08LX = cpyInterpreter()\n" ) );

   return( New );
}

// ---- PUBLIC functions: --------------------------------------------

/****h* freeVecAllBlocks() [3.0] *************************************
*
* NAME
*    freeVecAllBlocks()
*
* DESCRIPTION
*    FreeVec ALL Blocks for ShutDown().
**********************************************************************
*
*/

PUBLIC void freeVecAllBlocks( void )
{
   BLOCK *p         = blockList;
   BLOCK *next      = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      AT_free( p, "Block", FALSE ); // FreeVec( p );
      
      p = next;
      }   

   return;
}

/****h* freeSlackBlockMemory() [3.0] *******************************
*
* NAME
*    freeSlackBlockMemory()
*
* DESCRIPTION
*    Get rid of all Blocks in the recycleBlockList.
********************************************************************
*
*/

PUBLIC int freeSlackBlockMemory( void )
{
   return( freeVecDeadBlocks( &recycleBlockList, NULL )); // &lastRecycledBlock ) );
}

SUBFUNC BLOCK *allocBlock( void )
{
   BLOCK *rval = (BLOCK *) AT_calloc( 1, BLOCK_SIZE, "Block", FALSE );
   
   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allockBlock()!\n" );

      MemoryOut( "allocBlock()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // Never reached.      
      }
      
   return( rval );
}

/****h* new_block() ************************************************
*
* NAME
*    new_block()
*
* DESCRIPTION
*    Create a new instance of class Block.
********************************************************************
*
*/

PUBLIC OBJECT *new_block( INTERPR *anInterpreter, 
                          int argcount, 
                          int arglocation
                        )
{   
   BLOCK *New = (BLOCK *) NULL;

   FBEGIN( printf( "new_block( Interp = 0x%08LX, %d, %d)\n", anInterpreter, argcount, arglocation ) );

   if (started == TRUE)
      {
      if ((New = findFreeBlock())) // != NULL)
         goto setupNewBlock;
      }

   New = allocBlock();
   
   ca_block++;
   
setupNewBlock:

   New->ref_count   = 0;
   New->size        = MMF_INUSE_MASK | MMF_BLOCK | BLOCK_SIZE;

   New->interpreter = (INTERPR *) 
                       AssignObj( (OBJECT *) 
                                  cpyInterpreter( anInterpreter )
                                );

   New->numargs     = argcount;
   New->arglocation = arglocation;
   New->nextLink    = NULL;

   storeBlock( New, &lastAllocdBlock, &blockList );

   FEND( printf( "0x%08LX = new_block()\n" ) );

   return( (OBJECT *) New );
}

/****h* free_block() ***********************************************
*
* NAME
*    free_block()
*
* DESCRIPTION
*    Return an unused block to the block free list. 
********************************************************************
*
*/

PUBLIC void free_block( BLOCK *b )
{
   FBEGIN( printf( "void free_block( Block = 0x%08LX )\n", b ) );

   if (is_block( (OBJECT *) b ) == FALSE) 
      {
      fprintf( stderr, "free_block( 0x%08LX ) NOT a block!\n", b );
      
      cant_happen( WRONGOBJECT_FREED );         // Die, you abomination!!
      }
      
   (void) obj_dec( (OBJECT *) b->interpreter );

   recycleBlock( b );

   FEND( printf( "free_block() exits\n" ) );

   return;
}

/****h* block_execute() ********************************************
*
* NAME
*    block_execute()
* 
* DESCRIPTION
*    Queue a block interpreter for execution.
*    <primitive 140> (trapped by resume() & sent here).
********************************************************************
*
*/

PUBLIC INTERPR *block_execute( INTERPR *sender, BLOCK *aBlock,
                               int numargs, OBJECT **args 
                             )
{   
   INTERPR *newInt  = (INTERPR *) NULL;
   OBJECT  *tempobj = (OBJECT  *) NULL;

   FBEGIN( printf( "block_execute( sender = 0x%08LX, blk = 0x%08LX, %d, args = 0x%08LX )\n", sender, aBlock, numargs, args ) );

   if (is_block( (OBJECT *) aBlock ) == FALSE) 
      {
      fprintf( stderr, "block_execute( 0x%08LX ) NOT a block!\n", aBlock );

      cant_happen( NON_BLOCK_EXECUTE );// Die, you abomination!!
      }
      
   if (numargs != aBlock->numargs) 
      {
      tempobj = AssignObj( new_str( BlkCMsg( MSG_BL_WRONG_ARGS_BLOCK ) ) );

      primitive( ERRPRINT, 1, &tempobj );
      
      (void) obj_dec( tempobj );

      if (sender) // != NULL) 
         {
         push_object( sender, o_nil );
         }

      FEND( printf( "0x%08LX = sender = block_execute()\n", sender ) );

      return( sender ); // Not sure about this .....
      }

   /* we copy the interpreter so as to not destroy the original and to
   ** avoid memory pointer cycles 
   */

   newInt = cpyInterpreter( aBlock->interpreter );

   if (sender) // != NULL)
      {
      newInt->sender= (INTERPR *) AssignObj( (OBJECT *) sender );
      }

   if (numargs > 0)
      copy_arguments( newInt, aBlock->arglocation, numargs, args );

   FEND( printf( "newInterp = 0x%08LX = block_execute()\n", newInt ) );

   return( newInt );
}

/****h* block_return() **********************************************
*
* NAME
*    block_return()
*
* DESCRIPTION
*    Return an object from the context in which a block was created.
*********************************************************************
* 
*/

PUBLIC void block_return( INTERPR *blockInterpreter, 
                          OBJECT  *anObject
                        )
{   
   INTERPR *backchain    = (INTERPR *) NULL;
   INTERPR *parent       = (INTERPR *) NULL;
   INTERPR *creatorblock = blockInterpreter->creator;

   FBEGIN( printf( "void block_return( Interp = 0x%08LX, Obj = 0x%08LX )\n", blockInterpreter, anObject ) );

   // Look for the Creator of this Block:
   for (backchain = blockInterpreter->sender; backchain; 
         backchain = backchain->sender) 
      {
      if (is_interpreter( (OBJECT *) backchain ) == FALSE) 
         break;

      if (backchain == creatorblock) 
         {
         // found creating context, back up one more:
         parent = backchain->sender;

         if (parent) // != NULL) 
            {
            // Do NOT push another copy of o_drive:
            if (is_driver( (OBJECT *) parent ) == FALSE)
               push_object( parent, anObject );

            link_to_process( parent );
            }
         else 
            terminate_process( runningProcess );

         goto exitBlockReturn;
         }
      }

   // no block found, issue error message:
   (void) primitive( BLKRETERROR, 1, (OBJECT **) &blockInterpreter );

   parent = blockInterpreter->sender;

   if (parent) // != NULL) 
      {
      // Do NOT push another copy of o_drive:
      if (is_driver( (OBJECT *) parent ) == FALSE)
         push_object( parent, anObject );

      link_to_process( parent ); // Help me, Mommy!
      }
   else 
      terminate_process( runningProcess );

exitBlockReturn:

   FEND( printf( "block_return() exits\n" ) );

   return;
}

/* -------------------- END of Block.c file! ------------------ */
