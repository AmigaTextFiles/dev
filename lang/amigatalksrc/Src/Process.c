/****h* AmigaTalk/Process.c [3.0] ************************************
*
* NAME
*   Process.c 
*
* DESCRIPTION
*   Process manager
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    09-Nov-2003 - Set up for memory mangement support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
*    28-Jan-2002 - Added directControl argument to start_execution().
*
* NOTES
*   $VER: AmigaTalk/Src/Process.c 3.0 (25-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "object.h"

#undef SIGS
#ifdef SIGS
# include <signal.h>
#endif

#ifdef SETJUMP
# include <setjmp.h>
#endif

#include "drive.h"

#include "ATStructs.h"

#include "FuncProtos.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT OBJECT  *o_drive;

IMPORT int      started;
IMPORT int      atomcnt;     // atomic action flag

/* currently running process, may be different from currentProcess
** during process termination:
*/
IMPORT  PROCESS  *runningProcess;

PRIVATE PROCESS *recycleProcessList  = NULL;

PRIVATE PROCESS *lastAllocdProcess   = NULL;
PRIVATE PROCESS *processList         = NULL;

/****h* freeVecDeadProcesses() [3.0] *********************************
*
* NAME
*    freeVecDeadProcesses()
*
* DESCRIPTION
*    Free the memory space of ALL Processes in the recycleProcessList.
**********************************************************************
*
*/

SUBFUNC int freeVecDeadProcesses( PROCESS **recycledList, PROCESS **last )
{
   PROCESS *p       = *recycledList;
   PROCESS *next    =  NULL;
   
   int      howMany = 0;
   
   while (p) // != NULL)
      {
      next = p->nextLink;
      
      if (p->size & MMF_INUSE_MASK == 0)
         howMany++;
         
      p = next;
      }
   
   return( howMany );
}

SUBFUNC void storeProcess( PROCESS *p, PROCESS **last, PROCESS **list )
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

/****h* findFreeProcess() [3.0] **************************************
*
* NAME
*    findFreeProcess()
*
* DESCRIPTION
*    Find the first TERMINATED Process in the recycleProcessList.
**********************************************************************
*
*/

SUBFUNC PROCESS *findFreeProcess( void )
{
   PROCESS *p = recycleProcessList;

   if (!p) // == NULL)
      return( NULL );
         
   for ( ; p != NULL; p = p->nextLink)
      {
      if (p->state == TERMINATED)
         {
         return( p );
         }
      }
   
   return( NULL );
}

/****h* recycleProcess() [3.0] ***************************************
*
* NAME
*    recycleProcess()
*
* DESCRIPTION
*    Mark an element in an Object List as being free to be re-used.
**********************************************************************
*
*/

SUBFUNC void recycleProcess( PROCESS *killMe )
{
   killMe->size  = MMF_PROCESS | PROCESS_SIZE; // &= ~MMF_INUSE_MASK;
   killMe->state = TERMINATED;

   return;
}

// -------------------------------------------------------------------

/****h* freeVecAllProcesses() [3.0] **********************************
*
* NAME
*    freeVecAllProcesses()
*
* DESCRIPTION
*    Free the memory space of the entire Process List.
**********************************************************************
*
*/

PUBLIC void freeVecAllProcesses( void )
{
   PROCESS *p    = processList;
   PROCESS *next = NULL;
   
   while (p) // != NULL)
      {
      next = p->nextLink;

      AT_free( p, "Process", TRUE );
      
      p = next;
      }   

   return;
}

/****h* freeSlackProcessMemory() [3.0] *****************************
*
* NAME
*    freeSlackProcessMemory()
*
* DESCRIPTION
*    Get rid of all Processes in the recycleProcessList.
********************************************************************
*
*/

PUBLIC int freeSlackProcessMemory( void )
{
   return( freeVecDeadProcesses( &recycleProcessList, NULL )); // &lastRecycledProcess ) );
}

// ---------------------------------------------------------------

PRIVATE PROCESS  *currentProcess;      // current process

/****h* SafeAssign() [1.7] *******************************************
*
* NAME
*    SafeAssign()
*
* DESCRIPTION
*    Although producing less efficient code, this will work even
*    when obj == val & obj->ref_count = 1.
**********************************************************************
*
*/

PRIVATE OBJECT *SafeAssign( OBJECT *variable, OBJECT *value )
{
   (void) obj_inc( value    );
   (void) obj_dec( variable );

   variable = value;

   return( variable );
}

SUBFUNC PROCESS *allocProcess( void )
{
   PROCESS *rval = (PROCESS *) AT_calloc( 1, PROCESS_SIZE, "Process", TRUE );
   
   if (!rval) // == NULL)
      {
      fprintf( stderr, "Ran out of memory in allocProcess()!\n" );
      
      MemoryOut( "allocProcess()" );
      
      cant_happen( NO_MEMORY );
      
      return( NULL ); // never reached.
      }
      
   return( rval );
}

/****h* cr_process() [1.7] *******************************************
*
* NAME
*    cr_process()
*
* DESCRIPTION
*    Create a new process with the given interpreter.
**********************************************************************
*
*/

PUBLIC PROCESS *cr_process( INTERPRETER *anInterpreter )
{
   PROCESS *New = NULL;

   if (started == TRUE)
      {
      if ((New = findFreeProcess())) // != NULL)
         goto setupNewProcess;
      }

   New = allocProcess();
   
setupNewProcess:

   New->nextLink  = NULL;
   New->ref_count = 0;
   New->size      = MMF_INUSE_MASK | MMF_PROCESS | PROCESS_SIZE;

   New->interp  = (INTERPRETER *) AssignObj( (OBJECT *) anInterpreter );

   New->next    = (PROCESS *) AssignObj( o_nil );
   New->prev    = (PROCESS *) AssignObj( o_nil );

   New->state   = SUSPENDED;

   storeProcess( New, &lastAllocdProcess, &processList );

   return( New );
}

/****h* init_process() [1.7] *****************************************
*
* NAME
*    init_process()
*
* DESCRIPTION
*    Initialize the first Process.
**********************************************************************
*
*/

PUBLIC int init_process( INTERPRETER *newInterper )
{
   PROCESS *cp   = NULL;

   // make the process associated with the driver:
   cp             = cr_process( (INTERPRETER *) newInterper );
   currentProcess = cp;

   cp->prev       = (PROCESS *) AssignObj( (OBJECT *) cp );
   cp->next       = (PROCESS *) AssignObj( (OBJECT *) cp );

   cp->state      = ACTIVE;

   cp->nextLink   = NULL;

   // Because this will be the first Process, we can do this; however, if
   // init_rpocess() gets moved in SmallTalk(), we might have to change:
   processList           = cp;
   processList->nextLink = NULL;

   return( 0 );
}

/****h* free_process() [1.7] *****************************************
*
* NAME
*    free_process()
*
* DESCRIPTION
*    Return an unused process to the free list
**********************************************************************
*
*/

PRIVATE BOOL firstRecycledProcess = TRUE;

PUBLIC int free_process( PROCESS *aProcess )
{
   (void) obj_dec( (OBJECT *) aProcess->interp );
   (void) obj_dec( (OBJECT *) aProcess->next   );
   (void) obj_dec( (OBJECT *) aProcess->prev   );

   aProcess->state = TERMINATED; // with extreme prejudice!

   if (firstRecycledProcess == TRUE)
      {
      firstRecycledProcess = FALSE;
      recycleProcessList   = aProcess;
      }
      
   recycleProcess( aProcess );

   return( 0 );
}

/****i* remove_process() [1.7] ***************************************
*
* NAME
*    remove_process()
*
* DESCRIPTION
*    Remove a process from SmallTalk process queue
**********************************************************************
*
*/

PRIVATE int remove_process( PROCESS *aProcess )
{
   if (aProcess == aProcess->next)
      { 
      fprintf( stderr, "remove_process() tried to remove o_drive!\n", aProcess);
      
      cant_happen( ALL_PROCS_BLOCKED );  // removing last active process!
      }
      
   /* currentProcess must always point to a process that is on the
   ** process queue, make sure this remains true 
   */

   if (aProcess == currentProcess)
       currentProcess = currentProcess->prev;

   /* In order to avoid having memory recovered while we are changing
   ** pointers, we increment the reference counts on both processes,
   ** change pointers, then decrement reference counts 
   */

   (void) obj_inc( (OBJECT *) currentProcess ); 
   (void) obj_inc( (OBJECT *) aProcess );

   aProcess->next->prev = (PROCESS *) 
                           SafeAssign( (OBJECT *) aProcess->next->prev, 
                                       (OBJECT *) aProcess->prev
                                     );

   aProcess->prev->next = (PROCESS *)
                           SafeAssign( (OBJECT *) aProcess->prev->next, 
                                       (OBJECT *) aProcess->next
                                     );

   (void) obj_dec( (OBJECT *) currentProcess ); 
   (void) obj_dec( (OBJECT *) aProcess ); // recycleProcess( aProcess );

   return( 0 );
}

/****h* flush_processes() [1.7] **************************************
*
* NAME
*    flush_processes()
*
* DESCRIPTION
*    Flush out any remaining processes from the queue.
**********************************************************************
*
*/

PUBLIC int flush_processes( void )
{
   while (currentProcess != currentProcess->next)
      remove_process( currentProcess );

   /* prev link and next link should point to the same place now.
   ** In order to avoid having memory recovered while we are
   ** manipulating pointers, we increment reference count, then change
   ** pointers, then decrement reference counts 
   */

   (void) obj_inc( (OBJECT *) currentProcess );

   currentProcess->prev = (PROCESS *) 
                           SafeAssign( (OBJECT *) currentProcess->prev, 
                                       o_nil 
                                     );

   currentProcess->next = (PROCESS *) 
                           SafeAssign( (OBJECT *) currentProcess->next,
                                       o_nil 
                                     );

   (void) obj_dec( (OBJECT *) currentProcess );

   return( 0 );
}

/****h* link_to_process() [1.7] **************************************
*
* NAME
*    link_to_process()
*
* DESCRIPTION
*    Change the interpreter for the current process
**********************************************************************
*
*/

PUBLIC int link_to_process( INTERPRETER *anInterpreter )
{
   runningProcess->interp = (INTERPRETER *) 
                             SafeAssign( (OBJECT *) runningProcess->interp,
                                         (OBJECT *) anInterpreter
                                       );
   return( 0 );
}

/****i* schedule_process() [1.7] *************************************
*
* NAME
*    schedule_process()
*
* DESCRIPTION
*    Add a new process to the process queue
**********************************************************************
*
*/

PRIVATE int schedule_process( PROCESS *aProcess )
{
   aProcess->next = (PROCESS *) SafeAssign( (OBJECT *) aProcess->next, 
                                            (OBJECT *) currentProcess 
                                          );

   aProcess->prev = (PROCESS *) SafeAssign( (OBJECT *) aProcess->prev, 
                                            (OBJECT *) currentProcess->prev
                                          );

   aProcess->prev->next = (PROCESS *) 
                           SafeAssign( (OBJECT *) aProcess->prev->next, 
                                       (OBJECT *) aProcess 
                                     );

   currentProcess->prev = (PROCESS *) 
                           SafeAssign( (OBJECT *) currentProcess->prev, 
                                       (OBJECT *) aProcess 
                                     );
   return( 0 );
}

/****h* set_state() [1.7] ********************************************
*
* NAME
*    set_state()
*
* DESCRIPTION
*    Set the state on a process, which may involve inserting or
*    removing it from the process queue. 
**********************************************************************
*
*/

PUBLIC int set_state( PROCESS *aProcess, int state )
{
   switch (state) 
      {
      case BLOCKED:
      case SUSPENDED:
      case TERMINATED:   
         if (aProcess->state == ACTIVE)
            remove_process( aProcess );

         aProcess->state |= state;
         break;

      case READY:
      case UNBLOCKED:   
         if ((aProcess->state ^ state) == ~ACTIVE)
            schedule_process( aProcess );

         aProcess->state &= state;
         break;

      case CUR_STATE:   
         break;
      
      default:          
         fprintf( stderr, "set_state( %d ) is an Unknown state!\n", state );

         cant_happen( BADARG_SET_STATE );  // Die, you abomination!!

         break; // never reached.
      }

   return( aProcess->state );
}

/****h* terminate_process() [1.7] ************************************
*
* NAME
*    terminate_process()
*
* DESCRIPTION
*    Change a process' status to TERMINATED.
**********************************************************************
*
*/

PUBLIC void terminate_process( PROCESS *aProcess)  
{ 
   set_state( aProcess, TERMINATED ); // with extreme prejudice!

   if (aProcess == runningProcess) 
      atomcnt = 0; 

   return;
}

#ifdef SETJUMP

PRIVATE jmp_buf intenv;

#endif

/****h* brkfun() [1.7] ***********************************************
*
* NAME
*    brkfun()
*
* DESCRIPTION
*    What to do on a break key
*
* WARNINGS
*    This function does NOT interface to Amiga shells correctly!
**********************************************************************
*
*/

PUBLIC int brkfun( void )
{   
   PRIVATE int warn = 1;

#  ifndef SETJUMP
   ShutDown();

   exit( 1 );
#  endif

   if (warn != 0) 
      {
      APrint( ProcCMsg( MSG_WARN1_PROC ) );
      APrint( ProcCMsg( MSG_WARN2_PROC ) );
      APrint( ProcCMsg( MSG_WARN3_PROC ) );
/*
      Amiga_Printf( PROC_WARN1 );
      Amiga_Printf( PROC_WARN2 );
      Amiga_Printf( PROC_WARN3 );
*/
      warn = 0;
      }

#  ifdef SETJUMP
   ShutDown();         // check behavior.

   longjmp( intenv, 1 );
#  endif
}

/****h* start_execution() [1.7] **************************************
*
* NAME
*    start_execution()
*
* DESCRIPTION
*    Main execution loop.
**********************************************************************
*
*/

PUBLIC int start_execution( BOOL directControl )
{
   INTERPRETER  *presentInterpreter = NULL;
   BOOL          test               = FALSE;
         
   atomcnt = 0;

#  ifdef SIGS
   // trap user interrupt signals and recover:
   signal( SIGINT, brkfun );
#  endif

#  ifdef SETJUMP
   if (setjmp( intenv )) 
      {
      atomcnt = 0;
      link_to_process( (INTERPRETER *) o_drive );
      }
#  endif

   while (1) // Until currentProcess == o_drive
      {
      // unless it is an atomic action get the next process:
      if (atomcnt == 0)
         runningProcess = currentProcess = currentProcess->next;

      test = (currentProcess == currentProcess->next) 
                             || (atomcnt > 0);
      
      if (is_driver( (OBJECT *) runningProcess->interp ) == FALSE) 
         {
         presentInterpreter = (INTERPRETER *) 
                               AssignObj( (OBJECT *) 
                                          runningProcess->interp 
                                        );
         
         resume( presentInterpreter ); // Interpret the ByteCodes.

         (void) obj_dec( (OBJECT *) presentInterpreter );
         }
      else if (test_driver( test, directControl ) == FALSE) // currentProcess is o_drive.
         break;
      }

/*    Does not help much in eliminating the large number of Interpreters:

   if (presentInterpreter != (INTERPRETER *) o_drive)
      KillObject( (OBJECT *) presentInterpreter );
*/
   return( 0 );
}

/* ----------------- END of Process.c file. --------------------------- */
